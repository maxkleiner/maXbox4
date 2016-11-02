{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  110665: fMain.pas    #locs:632
{
{   Rev 1.0    25/10/2004 23:20:18  ANeillans    Version: 9.0.17
{ Verified    #sign:Max: MAXBOX10: 18/05/2016 13:33:18 
}
{-----------------------------------------------------------------------------
 Demo Name: fMain
 Author:    Allen O'Neill
 Copyright: Indy Pit Crew
 Purpose:
 History:
-----------------------------------------------------------------------------
 Notes:

 Simple demo of loading / saving an RFC message.
 IMPORTANT - there MUST be a CRLF + period + CRLF at
        the end of the file for it to load correctly.
        This is according to RFC standards.

Verified:
  Indy 9:
    D7: 25th Oct 2004 by Andy Neillans #sign:Max: MAXBOX10: 18/05/2016 13:33:18 
}

program fMainMessage;

{$DEFINE MSWINDOWS}

//interface

{uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, IdBaseComponent, IdMessage, IdEmailAddress, IdException;
 }
 
//type
  //TForm1 = class(TForm)
   var 
    Label1: TLabel;
    edtSender: TEdit;
    Label2: TLabel;
    edtSubject: TEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    lbHeaders: TListBox;
    lbTo: TListBox;
    edtToAddress: TEdit;
    btnAddTo: TButton;
    edtCCAddress: TEdit;
    btnAddCC: TButton;
    lbCC: TListBox;
    edtBCCAddress: TEdit;
    btnAddBCC: TButton;
    lbBCC: TListBox;
    mmoBody: TMemo;
    btnAddFile: TButton;
    lbAttach: TListBox;
    btnSaveToFile: TButton;
    btnLoadFromFile: TButton;
    IdMessage: TIdMessage;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    edtAddHeader: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
       procedure btnLoadFromFileClick(Sender: TObject); forward;
       procedure Button1Click(Sender: TObject); forward;
       procedure btnAddToClick(Sender: TObject); forward;
       procedure btnAddCCClick(Sender: TObject); forward;
       procedure btnAddBCCClick(Sender: TObject); forward;
       procedure btnSaveToFileClick(Sender: TObject); forward;
       procedure edtSenderChange(Sender: TObject); forward;
       procedure edtSubjectChange(Sender: TObject); forward;
       procedure mmoBodyChange(Sender: TObject); forward;
       procedure btnAddFileClick(Sender: TObject); forward;
       procedure Button2Click(Sender: TObject); forward;
       procedure Button3Click(Sender: TObject); forward;
     //private
    { Private declarations }
  //public
    { Public declarations }
  Procedure ClearControls; forward;
  //end;

var
  Form1: TForm;

//implementation

//{$R *.DFM}


{$IFDEF MSWINDOWS}
procedure TIdAntiFreeze_Process;
var
  Msg: TMsg;
  ApplicationHasPriority: boolean;
begin
  if ApplicationHasPriority then begin
    Application.ProcessMessages;
  end else begin
    // This guarantees it will not ever call Application.Idle
    if PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) then begin
      Application.HandleMessage;
    end;
  end;
end;
{$ENDIF}

procedure btnLoadFromFileClick(Sender: TObject);
var
  i : integer;
begin
ClearControls;
if OpenDialog.execute then
  begin
  try
  IdMessage.Clear;
  IdMessage.LoadFromFile(OpenDialog.FileName, false);
  edtSender.text := IdMessage.From.Text;
  edtSubject.text := IdMessage.Subject;
  lbHeaders.Items.AddStrings(IdMessage.Headers);
  // To
  for i := 0 to IdMessage.Recipients.Count - 1 do
    lbTo.items.Append(IdMessage.Recipients.Items[i].Text);
  if IdMessage.Recipients.Count > 0 then
    edtToAddress.text := IdMessage.Recipients.Items[0].Text;
  // CC
  for i := 0 to IdMessage.CCList.Count - 1 do
    lbCC.items.Append(IdMessage.CCList.Items[i].Text);
  if IdMessage.CCList.Count > 0 then
    edtCCAddress.text := IdMessage.CCList.Items[0].Text;
  // BCC
  for i := 0 to IdMessage.BCCList.Count - 1 do
    lbBCC.items.Append(IdMessage.BCCList.Items[i].Text);
  if IdMessage.BCCList.Count > 0 then
    edtBCCAddress.text := IdMessage.BCCList.Items[0].Text;
  for i := 0 to IdMessage.MessageParts.Count - 1 do
    if IdMessage.MessageParts.Items[i] is TidText then
      mmoBody.Lines.AddStrings(TidText(IdMessage.MessageParts.Items[i]).Body)
  else if IdMessage.MessageParts.Items[i] is TidAttachment then
      lbAttach.items.Append(TidAttachment(IdMessage.MessageParts.Items[i]).FileName);
  except
  //on E : EIdReadTimeout do
  MessageDlg('Message does not conform to RFC standards.'+#13+#10+'Must have " . " terminator to signify end of message.', mtError, [mbOK], 0);
  end;
  end;
end;

procedure ClearControls;
begin
edtAddHeader.text := '';
edtSender.text := '';
edtSubject.text := '';
edtToAddress.text := '';
edtCCAddress.text := '';
edtBCCAddress.text := '';
lbHeaders.Clear;
lbTo.Clear;
lbCC.Clear;
lbBCC.Clear;
mmoBody.Clear;
lbAttach.Clear;
end;

procedure Button1Click(Sender: TObject);
begin
if trim(edtAddHeader.text) <> '' then
  lbHeaders.items.Append(edtAddHeader.text);
IdMessage.Headers.Add(edtAddHeader.text);
end;

procedure btnAddToClick(Sender: TObject);
var
  AnItem : TidEmailAddressItem;
begin
if trim(edtToAddress.text) <> '' then
  lbTo.items.Append(edtToAddress.text);
AnItem := IdMessage.Recipients.Add;
AnItem.Text := edtToAddress.text;
end;

procedure btnAddCCClick(Sender: TObject);
var
  AnItem : TidEmailAddressItem;
begin
if trim(edtCCAddress.text) <> '' then
  lbCC.items.Append(edtCCAddress.text);
AnItem := IdMessage.CCList.Add;
AnItem.Text := edtCCAddress.text;
end;

procedure btnAddBCCClick(Sender: TObject);
var
  AnItem : TidEmailAddressItem;
begin
if trim(edtBCCAddress.text) <> '' then
  lbBCC.items.Append(edtBCCAddress.text);
AnItem := IdMessage.BCCList.Add;
AnItem.Text := edtBCCAddress.text;
end;

procedure btnSaveToFileClick(Sender: TObject);
begin
if SaveDialog.execute then
  IdMessage.SaveToFile(SaveDialog.FileName, false);
end;

procedure edtSenderChange(Sender: TObject);
begin
IdMessage.From.Address := edtSender.text;
end;

procedure edtSubjectChange(Sender: TObject);
begin
IdMessage.Subject := edtSubject.text;
end;

procedure mmoBodyChange(Sender: TObject);
begin
IdMessage.Body.Text := mmoBody.Text;
end;

procedure btnAddFileClick(Sender: TObject);
begin
if OpenDialog.Execute then
  begin
  lbAttach.Items.Append(OpenDialog.FileName);
  TIdAttachment.Create(IdMessage.MessageParts,OpenDialog.FileName);
  end;
end;

procedure Button2Click(Sender: TObject);
begin
ClearControls;
IdMessage.Clear;
end;

procedure Button3Click(Sender: TObject);
begin
  //application.terminate;
  form1.close;
end;

procedure loadPForm(vx, vy: smallint);
var psize: smallint;
  page: integer;
    alist: TIdEMailAddressList;

begin
  psize:= vx*vy
  //constructor
  form1:= Tform.create(self);
  with form1 do begin
    caption:= 'LEDBOX, Indy MIME Message out pattern'; 
    setbounds(266,132,445,428) 
    Position:= poScreenCenter;
    OldCreateOrder:= False
     PixelsPerInch:= 96
    //OnClick:= @Label1Click;
    show;
  end; 
  Label1:= TLabel.create(self)
  with label1 do begin
    parent:= form1
    Left := 8
    Top := 12
    Width := 61
    Height := 13
    Caption := 'Sender email'
  end;
  Label2:= TLabel.create(self)
  with label2 do begin
    parent:= form1
    Left := 8
    Top := 38
    Width := 36
    Height := 13
    Caption := 'Subject'
  end;
  edtSender:= TEdit.create(self)
  with edtsender  do begin
    parent:= form1
    Left := 92
    Top := 8
    Width := 225
    Height := 21
    TabOrder := 0
    OnChange := @edtSenderChange
  end;
  edtSubject:= TEdit.create(self)
  with edtsubject do begin
    parent:= form1
    Left := 92
    Top := 34
    Width := 225
    Height := 21
    TabOrder := 1
    OnChange := @edtSubjectChange
  end;
  
  //  TabSheet1:= TTabSheet.create(self)
  PageControl1:= TPageControl.create(self)
  with pagecontrol1 do begin
    parent:= form1
    //caption
    Left := 8
    Top := 120
    Width := 417
    Height := 193
    ActivePage := TabSheet1
    writeln('first pagecount: '+itoa(PageCount));
    //PageControl1.ActivePageIndex := 3;
    TabOrder := 2  
    visible:= true;
    //active:= true;
    show;
    end;
    //with PageControl1.Pages[0] do
    for page := 0 to PageControl1.PageCount - 1 do begin
        PageControl1.Pages[page].TabVisible := true;
      end;
    TabSheet1:= TTabSheet.create(self)
    with tabsheet1 do begin
      parent:= pagecontrol1; //form1
      pagecontrol:= pagecontrol1
      Caption := 'Headers'
      visible:= true;
      //active
      show
      end;
      lbHeaders:= TListBox.create(self)
      with lbheaders do begin
        parent:= tabsheet1
        Left := 0
        Top := 36
        Width := 409
        Height := 129
        Align := alBottom
        ItemHeight := 13
        TabOrder := 0
      end;
      edtAddHeader:= TEdit.create(self)
      with edtaddheader do begin
        parent:= tabsheet1
        Left := 4
        Top := 8
        Width := 209
        Height := 21
        TabOrder := 1
      end;
      Button1:= TButton.create(self)
      with Button1 do begin
        parent:= tabsheet1
        Left := 220
        Top := 8
        Width := 75
        Height := 25
        Caption := 'Add Header'
        TabOrder := 2
        OnClick := @Button1Click
      end;
    //end
    TabSheet2:= TTabSheet.create(self)
     with tabsheet2 do begin
      parent:= pagecontrol1; //form1
       pagecontrol:= pagecontrol1
      Caption := 'To'
      ImageIndex := 1
      show;
     end;
      lbTo:= TListBox.create(self)
     with lbTo do begin
        parent:= tabsheet2
        Left := 0
        Top := 36
        Width := 409
        Height := 129
        Align := alBottom
        ItemHeight := 13
        TabOrder := 0
      end;
      edtToAddress:= TEdit.create(self)
       with edtToAddress do begin
        parent:= tabsheet2
        Left := 4
        Top := 8
        Width := 209
        Height := 21
        TabOrder := 1
      end;
      btnAddTo:= TButton.create(self)
       with btnAddTo do begin
        parent:= tabsheet2
        Left := 220
        Top := 8
        Width := 75
        Height := 25
        Caption := 'Add To'
        TabOrder := 2
        OnClick := @btnAddToClick
      end;
    //end
    TabSheet3:= TTabSheet.create(self)
    with tabsheet3 do begin
      parent:= pagecontrol1; //form1
       pagecontrol:= pagecontrol1
     
      Caption := 'CC'
      ImageIndex := 2
      show;
      end;
      edtCCAddress:= TEdit.create(self)
       with edtCCAddress do begin
        parent:= tabsheet3
        Left := 4
        Top := 8
        Width := 209
        Height := 21
        TabOrder := 0
      end;
      btnAddCC:= TButton.create(self)
       with btnAddCC do begin
        parent:= tabsheet3
        Left := 220
        Top := 8
        Width := 75
        Height := 25
        Caption := 'Add CC'
        TabOrder := 1
        OnClick := @btnAddCCClick
      end;
      lbCC:= TListBox.create(self)
       with lbcc do begin
        parent:= tabsheet3
        Left := 0
        Top := 36
        Width := 409
        Height := 129
        Align := alBottom
        ItemHeight := 13
        TabOrder := 2
      end;
    //end
    TabSheet4:= TTabSheet.create(self)
    with tabsheet4 do begin
      parent:= pagecontrol1
       pagecontrol:= pagecontrol1
     
      Caption := 'BCC'
      ImageIndex := 3
      show;
     end; 
       edtBCCAddress:= TEdit.create(self)
       with edtbccaddress do begin
        parent:= tabsheet4
        Left := 4
        Top := 8
        Width := 209
        Height := 21
        TabOrder := 0
      end;
      btnAddBCC:= TButton.create(self)
      with btnAddBCC do begin
        parent:= tabsheet4
        Left := 220
        Top := 8
        Width := 75
        Height := 25
        Caption := 'Add BCC'
        TabOrder := 1
        OnClick := @btnAddBCCClick
      end;
      lbBCC:= TListBox.create(self)
      with lbbcc do begin
        parent:= tabsheet4
        Left := 0
        Top := 36
        Width := 409
        Height := 129
        Align := alBottom
        ItemHeight := 13
        TabOrder := 2
      end;
    //end
     TabSheet5:= TTabSheet.create(self)
     with tabsheet5 do begin
      parent:= pagecontrol1
     pagecontrol:= pagecontrol1
       
      Caption := 'Body'
      ImageIndex := 4
      show;
      end;
      mmoBody:= TMemo.create(self)
      with mmobody do begin
        parent:= tabsheet5
        Left := 0
        Top := 0
        Width := 409
        Height := 165
        Align := alClient
        TabOrder := 0
        OnChange := @mmoBodyChange
      end;
    //end
    TabSheet6:= TTabSheet.create(self)
     with tabsheet6 do begin
        parent:= pagecontrol1
       pagecontrol:= pagecontrol1
       Caption := 'Attachments'
      ImageIndex := 5
      show;
     end;
      btnAddFile:= TButton.create(self)
      with btnAddfile do begin
        parent:= tabsheet6
        Left := 4
        Top := 4
        Width := 75
        Height := 25
        Caption := 'Add File'
        TabOrder := 0
        OnClick := @btnAddFileClick
      end;
      lbAttach:= TListBox.create(self)
      with lbattach do begin
        parent:= tabsheet6
        Left := 0
        Top := 36
        Width := 409
        Height := 129
        Align := alBottom
        ItemHeight := 13
        TabOrder := 1
      end;
    //end
  //end
  btnSaveToFile:= TButton.create(self)
  with btnsavetofile do begin
    parent:= form1
    Left := 328
    Top := 6
    Width := 93
    Height := 25
    Caption := 'Save to file'
    TabOrder := 3
    OnClick := @btnSaveToFileClick
  end;
  btnLoadFromFile:= TButton.create(self)
    with btnloadfromfile do begin
    parent:= form1
    Left := 328
    Top := 32
    Width := 93
    Height := 25
    Caption := 'Load from file'
    TabOrder := 4
    OnClick := @btnLoadFromFileClick
  end;
  Button2:= TButton.create(self)
  with button2 do begin
    parent:= form1
    Left := 11
    Top := 65
    Width := 90
    Height := 25
    Caption := 'New Message'
    TabOrder := 5
    OnClick := @Button2Click
  end;
  Button3:= TButton.create(self)
    with button3 do begin
    parent:= form1
    Left := 102
    Top := 65
    Width := 75
    Height := 25
    Caption := 'Exit'
    TabOrder := 6
    OnClick := @Button3Click
  end;
  IdMessage:= TIdMessage.create(self)
  alist:= TIdEMailAddressList.create(self)
    with idmessage do begin
    AttachmentEncoding := 'MIME'
    BccList := alist; //Nil; //'<>'
    CCList := alist; //'<>'
    DeleteTempFiles := False
    Encoding := meMIME
    Recipients := alist; //<>
    ReplyTo := alist; //<>
    //Left := 396
    //Top := 60
  end;
  //  obje
  OpenDialog:= TOpenDialog.create(self)
  //  Left := 368 //Top := 60
  //end
  SaveDialog:= TSaveDialog.create(self)
  {  Left := 340  Top := 60
  end
   }
   writeln('pagecount '+itoa(pagecontrol1.pagecount))
   PageControl1.ActivePageIndex := 1;
end;


var istext: boolean;

begin

  loadPForm(10,10)

 //LoadDFMFile2Strings(const AFile:string; AStrings:TStrings; var WasText:boolean):integer
 // LoadDFMFile2Strings('C:\maXbox\maxbox3\work2015\Indy9Demos_26Oct04\Indy9Demos\MessageSaveLoad\fmain.dfm',memo2.lines, istext)
End.

//https://en.wikipedia.org/wiki/Idempotence

The description text was created by our editors, using sources such as text
from your product's homepage, information from its help system, the PAD
file (if available) and the editor's own opinions on the program itself.

"maXbox" has been tested in the Softpedia labs using several
industry-leading security solutions and found to be completely clean of
adware/spyware components. We are impressed with the quality of your
product and encourage you to keep these high standards in the future.

To assure our visitors that maXbox is clean, we have granted it with the
"100% FREE" Softpedia award. To let your users know about this
certification, you may display this award on your website, on software
boxes or inside your product.

More information about your product's certification and the award is
available on this page:
http://www.softpedia.com/get/Programming/Other-Programming-Files/maXbox.shtml

Feel free to link to us using the URLs above. If you choose to link to the
clean award page for your product, you may use the award graphic or a text
link: "100% FREE award granted by Softpedia".

Your developer page on Softpedia can be reached at the URL below. It
contains the list of software products and a link to your website.
http://www.softpedia.com/publisher/max-kleiner-66685.html 

If you feel that having your product listed on Softpedia is not a benefit
for you or simply need something changed or updated, please contact us via
email at webmaster@softpedia.com and we will work with you to fix any
problem you may have found with the product's listing.


{   // ***********************************************************
// TIdBaseComponent is the base class for all Indy components.
// ***********************************************************
type
  TIdBaseComponent = class(TComponent)
  public
    function GetVersion: string;
    property Version: string read GetVersion;
  published
  end;
  
  
  
   
Sorry for the late answer. I'm only acting as intermediary for this job offer. You should contact Jean-Christophe at jcp@novateam.com for more details on the job position and requirements.?
  }
  
  ref:
  
   with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TIdEMailAddressList') do
  begin
    RegisterMethod('Constructor Create( AOwner : TPersistent)');
    RegisterMethod('Procedure FillTStrings( AStrings : TStrings)');
    RegisterMethod('Function Add : TIdEMailAddressItem');
    RegisterProperty('Items', 'TIdEMailAddressItem Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('EMailAddresses', 'String', iptrw);
  end;

  
  object Form1: TForm1
  Left = 266
  Top = 132
  Width = 445
  Height = 328
  Caption = 'Message Loading and saving'
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
    Left = 8
    Top = 12
    Width = 61
    Height = 13
    Caption = 'Sender email'
  end
  object Label2: TLabel
    Left = 8
    Top = 38
    Width = 36
    Height = 13
    Caption = 'Subject'
  end
  object edtSender: TEdit
    Left = 92
    Top = 8
    Width = 225
    Height = 21
    TabOrder = 0
    OnChange = edtSenderChange
  end
  object edtSubject: TEdit
    Left = 92
    Top = 34
    Width = 225
    Height = 21
    TabOrder = 1
    OnChange = edtSubjectChange
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 101
    Width = 417
    Height = 193
    ActivePage = TabSheet1
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Headers'
      object lbHeaders: TListBox
        Left = 0
        Top = 36
        Width = 409
        Height = 129
        Align = alBottom
        ItemHeight = 13
        TabOrder = 0
      end
      object edtAddHeader: TEdit
        Left = 4
        Top = 8
        Width = 209
        Height = 21
        TabOrder = 1
      end
      object Button1: TButton
        Left = 220
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Add Header'
        TabOrder = 2
        OnClick = Button1Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'To'
      ImageIndex = 1
      object lbTo: TListBox
        Left = 0
        Top = 36
        Width = 409
        Height = 129
        Align = alBottom
        ItemHeight = 13
        TabOrder = 0
      end
      object edtToAddress: TEdit
        Left = 4
        Top = 8
        Width = 209
        Height = 21
        TabOrder = 1
      end
      object btnAddTo: TButton
        Left = 220
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Add To'
        TabOrder = 2
        OnClick = btnAddToClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'CC'
      ImageIndex = 2
      object edtCCAddress: TEdit
        Left = 4
        Top = 8
        Width = 209
        Height = 21
        TabOrder = 0
      end
      object btnAddCC: TButton
        Left = 220
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Add CC'
        TabOrder = 1
        OnClick = btnAddCCClick
      end
      object lbCC: TListBox
        Left = 0
        Top = 36
        Width = 409
        Height = 129
        Align = alBottom
        ItemHeight = 13
        TabOrder = 2
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'BCC'
      ImageIndex = 3
      object edtBCCAddress: TEdit
        Left = 4
        Top = 8
        Width = 209
        Height = 21
        TabOrder = 0
      end
      object btnAddBCC: TButton
        Left = 220
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Add BCC'
        TabOrder = 1
        OnClick = btnAddBCCClick
      end
      object lbBCC: TListBox
        Left = 0
        Top = 36
        Width = 409
        Height = 129
        Align = alBottom
        ItemHeight = 13
        TabOrder = 2
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Body'
      ImageIndex = 4
      object mmoBody: TMemo
        Left = 0
        Top = 0
        Width = 409
        Height = 165
        Align = alClient
        TabOrder = 0
        OnChange = mmoBodyChange
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Attachments'
      ImageIndex = 5
      object btnAddFile: TButton
        Left = 4
        Top = 4
        Width = 75
        Height = 25
        Caption = 'Add File'
        TabOrder = 0
        OnClick = btnAddFileClick
      end
      object lbAttach: TListBox
        Left = 0
        Top = 36
        Width = 409
        Height = 129
        Align = alBottom
        ItemHeight = 13
        TabOrder = 1
      end
    end
  end
  object btnSaveToFile: TButton
    Left = 328
    Top = 6
    Width = 93
    Height = 25
    Caption = 'Save to file'
    TabOrder = 3
    OnClick = btnSaveToFileClick
  end
  object btnLoadFromFile: TButton
    Left = 328
    Top = 32
    Width = 93
    Height = 25
    Caption = 'Load from file'
    TabOrder = 4
    OnClick = btnLoadFromFileClick
  end
  object Button2: TButton
    Left = 11
    Top = 65
    Width = 90
    Height = 25
    Caption = 'New Message'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 102
    Top = 65
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 6
    OnClick = Button3Click
  end
  object IdMessage: TIdMessage
    AttachmentEncoding = 'MIME'
    BccList = <>
    CCList = <>
    DeleteTempFiles = False
    Encoding = meMIME
    Recipients = <>
    ReplyTo = <>
    Left = 396
    Top = 60
  end
  object OpenDialog: TOpenDialog
    Left = 368
    Top = 60
  end
  object SaveDialog: TSaveDialog
    Left = 340
    Top = 60
  end
end

https://reactos.org/wiki/VirtualBox