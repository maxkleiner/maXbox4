unit usniffer;

//------------------------------------------------------
//  VKSSoft - SimpleSniffer 1.0
//  This is a simple net sniffer based on Winsock2.
//  4.01.05
//  mX4 - SimpleSniffer 1.2
// add terminatethread and start-stop to mX4
// empty hint: must be started as ADMIN!
//------------------------------------------------------

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Winsock;

const
  MAX_PACKET_SIZE = $10000;
  SIO_RCVALL      = $98000001;

type
  TsniffForm = class(TForm)
    ListView1: TListView;
    procedure FormCreate(Sender: TObject);
    procedure ListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListView1DblClick(Sender: TObject);
  private
    { Private declarations }
     startthread: boolean;
  public
    { Public declarations }
  end;

type
  USHORT = Word;
  TIPHeader = record
    iph_verlen:   UCHAR;
    iph_tos:      UCHAR;
    iph_length:   USHORT;
    iph_id:       USHORT;
    iph_offset:   USHORT;
    iph_ttl:      UCHAR;
    iph_protocol: UCHAR;
    iph_xsum:     USHORT;
    iph_src:      ULONG;
    iph_dest:     ULONG;
  end;
  PIPHeader = ^TIPHeader;

var
  sniffForm: TsniffForm;
  Buffer: array [0..MAX_PACKET_SIZE] of Char;
  flag: Integer;
  hThread: Cardinal;

implementation

{$R *.DFM}

procedure ListenThread(LV: TListView); stdcall;
var
  lowbyte, hibyte: USHORT;
  wsadata: TWSAData;
  s: TSocket;
  name: array [0..128]of Char;
  phe: PHostent;
  sa: TSockAddrIn;
  sa1: TInAddr;
  count: Integer;
  hdr: PIPHeader;
begin
  flag:=1;
  WSAStartup(MAKEWORD(2,2), wsadata);
  s := socket(AF_INET, SOCK_RAW, IPPROTO_IP);
  gethostname(name, sizeof(name));
  phe := gethostbyname(name);
  ZeroMemory(@sa, sizeof(sa));
  sa.sin_family := AF_INET;
  sa.sin_addr.s_addr := cardinal(pointer(phe^.h_addr_list^)^);
  bind(s, sa, sizeof(TSockaddr));
  ioctlsocket(s, SIO_RCVALL, flag);
  repeat
     count := recv(s, Buffer, sizeof(Buffer), 0);
      if (count >= sizeof(TIPHeader)) then
      with LV.Items.Add do begin
        hdr := @Buffer;
        Caption:= TimeToStr(Time);
        case hdr.iph_protocol of
          IPPROTO_TCP:  SubItems.Add('TCP');
          IPPROTO_UDP:  SubItems.Add('UDP');
          IPPROTO_RAW:  SubItems.Add('RAW');
          IPPROTO_ICMP: SubItems.Add('ICMP');
          IPPROTO_IGMP: SubItems.Add('IGMP');
          IPPROTO_IP:   SubItems.Add('IP');
        else SubItems.Add('unknown') end;
        sa1.s_addr := hdr.iph_src;
        SubItems.Add(inet_ntoa(sa1));
        sa1.s_addr := hdr.iph_dest;
        SubItems.Add(inet_ntoa(sa1));
        lowbyte := hdr.iph_length shr 8;
        hibyte := hdr.iph_length shl 8;
        hibyte := hibyte + lowbyte;
        SubItems.Add(IntToStr(hibyte));
        SubItems.Add(IntToStr(hdr.iph_ttl));
        SubItems.Add(IntToStr(hdr.iph_xsum));
        SubItems.Add(IntToStr(hdr.iph_tos));
        SubItems.Add(IntToStr(hdr.iph_verlen));
        SubItems.Add(IntToStr(hdr.iph_id));

      end;
  until false;
end;

procedure TsniffForm.FormCreate(Sender: TObject);
var
  ThID: Cardinal;
begin
 startthread:= true;
 sniffform.caption:= 'mX4 SimpleSniffer2 - Continue/Pause with DblClick';
 hThread:=CreateThread(nil,0,@ListenThread,ListView1,0,ThID);
 if hThread=0 then ShowMessage(SysErrorMessage(GetLastError));
     ListView1.Items.Add.SubItems.Add('If empty: start as ADMIN!');

end;

procedure TsniffForm.ListView1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  ListView1.Scroll(0,Item.Position.y);
end;

procedure TsniffForm.ListView1DblClick(Sender: TObject);
begin
  //startthread:= NOT startthread;
  if startthread then begin
     SuspendThread(hThread);
     sniffform.caption:= 'mX4 SimpleSniffer2 - Pause!';
   end
   else begin
     ResumeThread(hThread);
     sniffform.caption:= 'mX4 SimpleSniffer2 - Continue!';
   end;
   startthread:= NOT startthread;

     //function SuspendThread(hThread: THandle): DWORD; stdcall;
//{$EXTERNALSYM SuspendThread}
//function ResumeThread(hThread: THandle): DWORD; stdcall;
end;

procedure TsniffForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  while not TerminateThread(hThread,0) do
    Sleep(500);
    startthread:= false;
    Showmessage('mX TerminateThread success');
end;

end.
