(***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is TurboPower Async Professional
 *
 * The Initial Developer of the Original Code is
 * TurboPower Software
 *
 * Portions created by the Initial Developer are Copyright (C) 1991-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   ADWUTIL.PAS 4.06                    *}
{*********************************************************}
{* Winsock DLL interface and utility methods             *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}
{$C MOVEABLE,DEMANDLOAD,DISCARDABLE}

unit AdWUtil;
  { -Basic Winsock interface unit }

interface

uses
  Classes,
  WinTypes,
  WinProcs,
  SysUtils,
  OOMisc;

type
  TSocket = Integer;
  {$IFNDEF Win32}
  AnsiChar = Char;
  PAnsiChar = ^Char;
  {$ENDIF}

const
  { Version of Winsock that we support }
  Sock_Version = $0101;

  Fd_Setsize = 64;

  IocParm_Mask = $7F;
  Ioc_Void     = $20000000;
  Ioc_Out      = $40000000;
  Ioc_In       = $80000000;
  Ioc_InOut    = (Ioc_In or Ioc_Out);

  { Protocols }
  IpProto_Ip   = 0;               { Dummy for IP }
  IpProto_Icmp = 1;               { Control message protocol }
  IpProto_Igmp = 2;               { Group management protocol }
  IpProto_Ggp  = 3;               { Gateway^2 (deprecated) }
  IpProto_Tcp  = 6;               { Tcp }
  IpProto_Pup  = 12;              { Pup }
  IpProto_Udp  = 17;              { User datagram protocol }
  IpProto_Idp  = 22;              { Xns idp }
  IpProto_Nd   = 77;              { UNOFFICIAL net disk proto }

  IpProto_Raw  = 255;             { Raw IP packet }
  IpProto_Max  = 256;

  { Port/socket numbers: network standard functions}

  IpPort_Echo       = 7;
  IpPort_Discard    = 9;
  IpPort_SyStat     = 11;
  IpPort_Daytime    = 13;
  IpPort_NetStat    = 15;
  IpPort_Ftp        = 21;
  IpPort_Telnet     = 23;
  IpPort_Smtp       = 25;
  IpPort_TimeServer = 37;
  IpPort_NameServer = 42;
  IpPort_WhoIs      = 43;
  IpPort_Mtp        = 57;

  { Port/socket numbers: host specific functions }

  IpPort_Tftp    = 69;
  IpPort_Rje     = 77;
  IpPort_Finger  = 79;
  IpPort_TtyLink = 87;
  IpPort_SupDup  = 95;

  { Unix TCP sockets }

  IpPort_ExecServer  = 512;
  IpPort_LoginServer = 513;
  IpPort_CmdServer   = 514;
  IpPort_EfsServer   = 520;

  { Unix UDP sockets }

  IpPort_BiffUdp     = 512;
  IpPort_WhoServer   = 513;
  IpPort_RouteServer = 520;

  { Ports < IpPort_Reserved are reserved for privileged processes (e.g. root). }

  IpPort_Reserved = 1024;

  { Link numbers }

  ImpLink_Ip        = 155;
  ImpLink_LowExper  = 156;
  ImpLink_HighExper = 158;

  { Get # bytes to read }
  FiOnRead = Ioc_Out or ((LongInt(SizeOf(LongInt)) and IocParm_Mask) shl 16) or
    (LongInt(Byte('f')) shl 8) or 127;

  { Set/Clear non-blocking i/o }
  FiOnBio  = Ioc_In or((LongInt(SizeOf(LongInt)) and IocParm_Mask) shl 16) or
    (LongInt(Byte('f')) shl 8) or 126;

  { Set/Clear async i/o }
  FioAsync = Ioc_In or ((LongInt(SizeOf(LongInt)) and IocParm_Mask) shl 16) or
    (LongInt(Byte('f')) shl 8) or 125;

  InAddr_Any       = $00000000;
  InAddr_LoopBack  = $7F000001;
  InAddr_BroadCast = $FFFFFFFF;
  InAddr_None      = $FFFFFFFF;

  wsaDescription_Len = 256;
  wsaSys_Status_Len  = 128;

  { Options for use with (get/set)sockopt at the IP level. }

  Ip_Options         = 1;
  Ip_Multicast_If    = 2;           { set/get IP multicast interface   }
  Ip_Multicast_Ttl   = 3;           { set/get IP multicast timetolive  }
  Ip_Multicast_Loop  = 4;           { set/get IP multicast loopback    }
  Ip_Add_Membership  = 5;           { add  an IP group membership      }
  Ip_Drop_Membership = 6;           { drop an IP group membership      }

  Ip_Default_Multicast_Ttl  = 1;    { normally limit m'casts to 1 hop  }
  Ip_Default_Multicast_Loop = 1;    { normally hear sends if a member  }
  Ip_Max_Memberships        = 20;   { per socket; must fit in one mbuf }

  { This is used instead of -1, since the TSocket type is unsigned.}

  Invalid_Socket = TSocket(not(0));
  Socket_Error   = -1;

  { Types }

  Sock_Stream    = 1;               { stream socket }
  Sock_DGram     = 2;               { datagram socket }
  Sock_Raw       = 3;               { raw-protocol interface }
  Sock_Rdm       = 4;               { reliably-delivered message }
  Sock_SeqPacket = 5;               { sequenced packet stream }

  { Option flags per-socket. }

  So_Debug       = $0001;           { turn on debugging info recording }
  So_AcceptConn  = $0002;           { socket has had listen() }
  So_ReuseAddr   = $0004;           { allow local address reuse }
  So_KeepAlive   = $0008;           { keep connections alive }
  So_DontRoute   = $0010;           { just use interface addresses }
  So_Broadcast   = $0020;           { permit sending of broadcast msgs }
  So_UseLoopback = $0040;           { bypass hardware when possible }
  So_Linger      = $0080;           { linger on close if data present }
  So_OobInline   = $0100;           { leave received OOB data in line }

  So_DontLinger  = $FF7F;

  SD_Receive     = $0000;
  SD_Send        = $0001;
  SD_Both        = $0002;

  { Additional options. }

  So_SndBuf   = $1001;              { send buffer size }
  So_RcvBuf   = $1002;              { receive buffer size }
  So_SndLoWat = $1003;              { send low-water mark }
  So_RcvLoWat = $1004;              { receive low-water mark }
  So_SndTimeO = $1005;              { send timeout }
  So_RcvTimeO = $1006;              { receive timeout }
  So_Error    = $1007;              { get error status and clear }
  So_Type     = $1008;              { get socket type }

  { Options for connect and disconnect data and options.  Used only by }
  { non-TCP/IP transports such as DecNet, Osi TP4, etc. }

  So_ConnData    = $7000;
  So_ConnOpt     = $7001;
  So_DISCData    = $7002;
  So_DISCOpt     = $7003;
  So_ConnDataLen = $7004;
  So_ConnOptLen  = $7005;
  So_DISCDataLen = $7006;
  So_DISCOptLen  = $7007;

  { Option for opening sockets for synchronous access. }

  So_OpenType    = $7008;

  So_Synchronous_Alert    = $10;
  So_Synchronous_NonAlert = $20;

  { Other NT-specific options. }

  So_MaxDG     = $7009;
  So_MaxPathDG = $700A;

  { TCP options. }

  Tcp_NoDelay   = $0001;
  Tcp_BsdUrgent = $7000;

  { Address families. }

  Af_Unspec    = 0;                 { unspecified }
  Af_Unix      = 1;                 { local to host (pipes, portals) }
  Af_Inet      = 2;                 { internetwork: UDP, TCP, etc. }
  Af_ImpLink   = 3;                 { arpanet imp addresses }
  Af_Pup       = 4;                 { pup protocols: e.g. BSP }
  Af_Chaos     = 5;                 { mit Chaos protocols }
  Af_Ipx       = 6;                 { Ipx and SPX }
  Af_Ns        = 6;                 { XEROX Ns protocols }
  Af_Iso       = 7;                 { Iso protocols }
  Af_Osi       = Af_Iso;            { Osi is Iso }
  Af_Ecma      = 8;                 { european computer manufacturers }
  Af_DataKit   = 9;                 { datakit protocols }
  Af_CcItt     = 10;                { CcItt protocols, X.25 etc }
  Af_Sna       = 11;                { IBM Sna }
  Af_DecNet    = 12;                { DecNet }
  Af_Dli       = 13;                { Direct data link interface }
  Af_Lat       = 14;                { Lat }
  Af_HyLink    = 15;                { NsC Hyperchannel }
  Af_AppleTalk = 16;                { AppleTalk }
  Af_NetBios   = 17;                { NetBios-style addresses }
  Af_VoiceView = 18;                { VoiceView }
  Af_Max       = 19;

  { Protocol families, same as address families for now. }

  Pf_Unspec    = Af_Unspec;
  Pf_Unix      = Af_Unix;
  Pf_Inet      = Af_Inet;
  Pf_ImpLink   = Af_ImpLink;
  Pf_Pup       = Af_Pup;
  Pf_Chaos     = Af_Chaos;
  Pf_Ns        = Af_Ns;
  Pf_Ipx       = Af_Ipx;
  Pf_Iso       = Af_Iso;
  Pf_Osi       = Af_Osi;
  Pf_Ecma      = Af_Ecma;
  Pf_DataKit   = Af_DataKit;
  Pf_CcItt     = Af_CcItt;
  Pf_Sna       = Af_Sna;
  Pf_DecNet    = Af_DecNet;
  Pf_Dli       = Af_Dli;
  Pf_Lat       = Af_Lat;
  Pf_HyLink    = Af_HyLink;
  Pf_AppleTalk = Af_AppleTalk;
  Pf_VoiceView = Af_VoiceView;

  Pf_Max       = Af_Max;

  { Level number for (get/set)sockopt() to apply to socket itself. }

  Sol_Socket = $FFFF;               {options for socket level }

  { Maximum queue length specifiable by listen. }

  SoMaxConn     = 5;

  Msg_Oob       = $1;               {process out-of-band data }
  Msg_Peek      = $2;               {peek at incoming message }
  Msg_DontRoute = $4;               {send without using routing tables }

  Msg_MaxIovLen = 16;

  Msg_Partial   = $8000;            {partial send or recv for message xport }

  { Define constant based on rfc883, used by gethostbyxxxx() calls. }

  MaxGetHostStruct = 1024;

  { Define flags to be used with the wsaAsyncSelect() call. }

  Fd_Read    = $01;
  Fd_Write   = $02;
  Fd_Oob     = $04;
  Fd_Accept  = $08;
  Fd_Connect = $10;
  Fd_Close   = $20;

  { moved wsa* error consts to OOMisc }                                  {!!.04}


  { Windows Sockets errors redefined as regular Berkeley error constants. }
  { These are commented out in Windows NT to avoid conflicts with errno.h. }
  { Use the wsa constants instead. }

  EWouldBlock     = wsaEWouldBlock;
  EInProgress     = wsaEInProgress;
  EAlreadY        = wsaEAlready;
  ENotSock        = wsaENotSock;
  EDestAddrReq    = wsaEDestAddrReq;
  EMsgSize        = wsaEMsgSize;
  EPrototype      = wsaEPrototype;
  ENoProtoOpt     = wsaENoProtoOpt;
  EProtoNoSupport = wsaEProtoNoSupport;
  ESocktNoSupport = wsaESocktNoSupport;
  EOpNotSupp      = wsaEOpNotSupp;
  EPfNoSupport    = wsaEPfNoSupport;
  EAfNoSupport    = wsaEAfNoSupport;
  EAddrInUse      = wsaEAddrInUse;
  EAddrNotAvail   = wsaEAddrNotAvail;
  ENetDown        = wsaENetDown;
  ENetUnreach     = wsaENetUnreach;
  ENetReset       = wsaENetReset;
  EConnAborted    = wsaEConnAborted;
  EConnReset      = wsaEConnReset;
  ENoBufs         = wsaENoBufs;
  EIsConn         = wsaEIsConn;
  ENotConn        = wsaENotConn;
  EShutDown       = wsaEShutDown;
  ETooManyRefs    = wsaETooManyRefs;
  ETimedOut       = wsaETimedOut;
  EConnRefused    = wsaEConnRefused;
  ELoop           = wsaELoop;
  ENameTooLong    = wsaENameTooLong;
  EHostDown       = wsaEHostDown;
  EHostUnreach    = wsaEHostUnreach;
  ENotEmpty       = wsaENotEmpty;
  EProcLim        = wsaEProcLim;
  EUsers          = wsaEUsers;
  EDQuot          = wsaEDQuot;
  EStale          = wsaEStale;
  ERemote         = wsaERemote;

type
  PFDSet = ^TFDSet;
  TFDSet = packed record
    fd_count : Integer;
    fd_array : array[0..Pred(Fd_SETSIZE)] of TSocket;
  end;

  PTimeVal = ^TTimeVal;
  TTimeVal = packed record
    tv_sec  : LongInt;
    tv_usec : LongInt;
  end;

const
  MaxAddrs = 256;
  MaxAlias = 256;

type
  { moved to OOMisc to prevent type conflicts }                          {!!.06}
  {SunB = packed record
    s_b1, s_b2, s_b3, s_b4 : AnsiChar;
  end;

  SunW = packed record
    s_w1, s_w2 : Word;
  end;

  PInaddr = ^TInaddr;
  TInaddr = packed record
    case Integer of
      0 : (S_un_b : SunB);
      1 : (S_un_w : SunW);
      2 : (S_addr : LongInt);
  end;}

  PAddrArray = ^TAddrArray;
  TAddrArray = array[0..MaxAddrs-1] of PInAddr;

  PAliasArray = ^TAliasArray;
  TAliasArray = array[0..MaxAlias-1] of PAnsiChar;

  { Host Entity }

  PHostEnt = ^THostEnt;
  THostEnt = packed record
    h_name : PAnsiChar;                 { Official name of host }
    h_aliases : PAliasArray;            { Alias list }
    h_addrtype : SmallInt;              { Host address type }
    h_length : SmallInt;                { Length of address }
    h_addr_list : PAddrArray;           { List of addresses }
  end;
  
  { Network Entity }
  PNetEnt = ^TNetEnt;
  TNetEnt = packed record
    n_name     : PAnsiChar;
    n_aliases  : ^PAnsiChar;
    n_addrtype : SmallInt;
    n_net      : LongInt;
  end;

  { Server Entity }
  PServEnt = ^TServEnt;
  TServEnt = packed record
    s_name    : PAnsiChar;
    s_aliases : ^PAnsiChar;
    s_port    : SmallInt;
    s_proto   : PAnsiChar;
  end;

  { Protocol Entity }
  PProtoEnt = ^TProtoEnt;
  TProtoEnt = packed record
    p_name    : PAnsiChar;
    p_aliases : ^PAnsiChar;
    p_proto   : SmallInt;
  end;

  PSockAddrIn = ^TSockAddrIn;
  TSockAddrIn = packed record
    case Integer of
      0: (sin_family : Word;
          sin_port   : Word;
          sin_addr   : TInAddr;
          sin_zero   : array[0..7] of AnsiChar);
      1: (sa_family  : Word;
          sa_data    : array[0..13] of AnsiChar)
  end;

  PwsaData = ^TwsaData;
  TwsaData = packed record
    wVersion       : Word;
    wHighVersion   : Word;
    szDescription  : array[0..wsaDESCRIPTION_Len] of AnsiChar;
    szSystemStatus : array[0..wsaSYS_STATUS_Len] of AnsiChar;
    iMaxSockets    : Word;
    iMaxUdpDg      : Word;
    lpVendorInfo   : PAnsiChar;
  end;

  {$IFDEF Win32}
  PTransmitFileBuffers = ^TTransmitFileBuffers;
  TTransmitFileBuffers = packed record
      Head       : Pointer;
      HeadLength : DWORD;
      Tail       : Pointer;
      TailLength : DWORD;
  end;
  {$ENDIF}

  { Structure used by kernel to store most addresses. }

  PSockAddr = ^TSockAddr;
  TSockAddr = TSockAddrIn;

  { Structure used by kernel to pass protocol information in raw sockets. }
  PSockProto = ^TSockProto;
  TSockProto = packed record
    sp_family   : Word;
    sp_protocol : Word;
  end;

  { Structure used for manipulating linger option. }
  PLinger = ^TLinger;
  TLinger = packed record
    l_onoff  : Word;
    l_linger : Word;
  end;

  { Winsock data record }
  PWsDataRec = ^TWsDataRec;
  TWsDataRec = record
     WsSockAddr : TSockAddrIn;
     WsHostAddr : TSockAddrIn;
     WsIsClient : Boolean;
     WsIsTelnet : Boolean;
  end;

  { Socket function types }

  TfnAccept                   = function(S : TSocket;
                                         var Addr : TSockAddr;
                                         var Addrlen : Integer) : TSocket;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnBind                     = function(S : TSocket;
                                         var Addr : TSockAddr;
                                         NameLen : Integer) : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnCloseSocket              = function(S : TSocket) : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnConnect                  = function(S : TSocket;
                                         var Name : TSockAddr;
                                         NameLen : Integer) : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnIOCtlSocket              = function(S : TSocket;
                                         Cmd : LongInt;
                                         var Arg : LongInt) : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnGetPeerName              = function(S : TSocket;
                                         var Name : TSockAddr;
                                         var NameLen : Integer) : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnGetSockName              = function(S : TSocket;
                                         var Name : TSockAddr;
                                         var NameLen : Integer) : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnGetSockOpt               = function(S : TSocket;
                                         Level, OptName : Integer;
                                         var OptVal; var OptLen : Integer) : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  Tfnhtonl                    = function(HostLong : LongInt) : LongInt;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  Tfnhtons                    = function(HostShort : Word) : Word;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnINet_Addr                = function(Cp : PAnsiChar) : LongInt;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnINet_NtoA                = function(InAddr : TInAddr) : PAnsiChar;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnListen                   = function(S : TSocket; Backlog : Integer) : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  Tfnntohl                    = function(NetLong : LongInt) : LongInt;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  Tfnntohs                    = function(NetShort : Word) : Word;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnRecv                     = function(S : TSocket; var Buf;
                                         Len, Flags : Integer) : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnRecvFrom                 = function(S : TSocket; var Buf;
                                         Len, Flags : Integer;
                                         var From : TSockAddr;
                                         var FromLen : Integer) : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnSelect                   = function(Nfds : Integer;
                                         Readfds, Writefds,
                                         Exceptfds : PFDSet;
                                         Timeout : PTimeVal) : LongInt;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnSend                     = function(S : TSocket; var Buf;
                                         Len, Flags : Integer) : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnSendTo                   = function(S : TSocket; var Buf;
                                         Len, Flags : Integer;
                                         var AddrTo : TSockAddr;
                                         ToLen : Integer) : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnSetSockOpt               = function(S : TSocket;
                                         Level, OptName : Integer;
                                         var OptVal; OptLen : Integer) : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnShutdown                 = function(S : TSocket; How : Integer) : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnSocket                   = function(Af, Struct, Protocol : Integer) : TSocket;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnGetHostByAddr            = function(var Addr; Len, Struct : Integer): PHostEnt;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnGetHostByName            = function(Name : PAnsiChar) : PHostEnt;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnGetHostName              = function(Name : PAnsiChar;
                                         Len : Integer): Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnGetServByPort            = function(Port : Word; Proto : PAnsiChar) : PServEnt;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnGetServByName            = function(Name, Proto : PAnsiChar) : PServEnt;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnGetProtoByNumber         = function(Proto : Integer) : PProtoEnt;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnGetProtoByName           = function(Name : PAnsiChar) : PProtoEnt;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnwsaStartup               = function(wVersionRequired : Word;
                                         var WSData : TwsaData) : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnwsaCleanup               = function : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnwsaSetLastError          = procedure(iError : Integer);
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnwsaGetLastError          = function : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnwsaIsBlocking            = function : BOOL;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnwsaUnhookBlockingHook    = function : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnwsaSetBlockingHook       = function(lpBlockFunc : TFarProc) : TFarProc;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnwsaCancelBlockingCall    = function : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnwsaAsyncGetServByName    = function(HWindow : HWnd; wMsg : Integer;
                                         Name, Proto, Buf : PAnsiChar;
                                         BufLen : Integer) : THandle;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnwsaAsyncGetServByPort    = function(HWindow : HWnd;
                                         wMsg, Port : Integer;
                                         Proto, Buf : PAnsiChar;
                                         BufLen : Integer) : THandle;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnwsaAsyncGetProtoByName   = function(HWindow : HWnd;
                                         wMsg : Integer;
                                         Name, Buf : PAnsiChar;
                                         BufLen : Integer) : THandle;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnwsaAsyncGetProtoByNumber = function(HWindow : HWnd;
                                         wMsg : Integer;
                                         Number : Integer;
                                         Buf : PAnsiChar;
                                         BufLen : Integer) : THandle;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnwsaAsyncGetHostByName    = function(HWindow : HWnd;
                                         wMsg : Integer;
                                         Name, Buf : PAnsiChar;
                                         BufLen : Integer) : THandle;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnwsaAsyncGetHostByAddr    = function(HWindow : HWnd;
                                         wMsg : Integer;
                                         Addr : PAnsiChar;
                                         Len, Struct : Integer;
                                         Buf : PAnsiChar;
                                         BufLen : Integer) : THandle;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnwsaCancelAsyncRequest    = function(hAsyncTaskHandle : THandle) : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  TfnwsaAsyncSelect           = function(S : TSocket;
                                         HWindow : HWnd;
                                         wMsg : Integer;
                                         lEvent : LongInt) : Integer;
                                         {$IFDEF Win32} stdcall; {$ENDIF}

  {$IFDEF Win32}
  TfnwsaRecvEx                = function(S : TSocket;
                                         var Buf;
                                         Len : Integer;
                                         var Flags : Integer) : Integer; stdcall;

  TfnTransmitFile             = function(hSocket : TSocket;
                                         hFile : THandle;
                                         nNumberOfBytesToWrite : DWORD;
                                         nNumberOfBytesPerSend : DWORD;
                                         lpOverlapped : POverlapped;
                                         lpTransmitBuffers: PTransmitFileBuffers;
                                         dwReserved: DWORD) : BOOL; stdcall;
  {$ENDIF}

  { Record for our function pointers. }
  PSocketFuncs = ^TSocketFuncs;
  TSocketFuncs = record
    Accept                   : TfnAccept;
    Bind                     : TfnBind;
    CloseSocket              : TfnCloseSocket;
    Connect                  : TfnConnect;
    IOCtlSocket              : TfnIOCtlSocket;
    GetPeerName              : TfnGetPeerName;
    GetSockName              : TfnGetSockName;
    GetSockOpt               : TfnGetSockOpt;
    htonl                    : Tfnhtonl;
    htons                    : Tfnhtons;
    INet_Addr                : TfnINet_Addr;
    INet_Ntoa                : TfnINet_Ntoa;
    Listen                   : TfnListen;
    ntohl                    : Tfnntohl;
    ntohs                    : Tfnntohs;
    Recv                     : TfnRecv;
    RecvFrom                 : TfnRecvFrom;
    Select                   : TfnSelect;
    Send                     : TfnSend;
    SendTo                   : TfnSendTo;
    SetSockOpt               : TfnSetSockOpt;
    Shutdown                 : TfnShutdown;
    Socket                   : TfnSocket;
    GetHostByAddr            : TfnGetHostByAddr;
    GetHostByName            : TfnGetHostByName;
    GetHostName              : TfnGetHostName;
    GetServByPort            : TfnGetServByPort;
    GetServByName            : TfnGetServByName;
    GetProtoByNumber         : TfnGetProtoByNumber;
    GetProtoByName           : TfnGetProtoByName;
    wsaStartup               : TfnwsaStartup;
    wsaCleanup               : TfnwsaCleanup;
    wsaSetLastError          : TfnwsaSetLastError;
    wsaGetLastError          : TfnwsaGetLastError;
    wsaIsBlocking            : TfnwsaIsBlocking;
    wsaUnhookBlockingHook    : TfnwsaUnhookBlockingHook;
    wsaSetBlockingHook       : TfnwsaSetBlockingHook;
    wsaCancelBlockingCall    : TfnwsaCancelBlockingCall;
    wsaAsyncGetServByName    : TfnwsaAsyncGetServByName;
    wsaAsyncGetServByPort    : TfnwsaAsyncGetServByPort;
    wsaAsyncGetProtoByName   : TfnwsaAsyncGetProtoByName;
    wsaAsyncGetProtoByNumber : TfnwsaAsyncGetProtoByNumber;
    wsaAsyncGetHostByName    : TfnwsaAsyncGetHostByName;
    wsaAsyncGetHostByAddr    : TfnwsaAsyncGetHostByAddr;
    wsaCancelAsyncRequest    : TfnwsaCancelAsyncRequest;
    wsaAsyncSelect           : TfnwsaAsyncSelect;
    {$IFDEF Win32}
    wsaRecvEx                : TfnwsaRecvEx;
    TransmitFile             : TfnTransmitFile;
    {$ENDIF}
  end;

function LoadWinsock : Boolean;
function wsaMakeSyncReply(Buflen, Error : Word) : LongInt;
function wsaMakeSelectReply(Event, Error : Word) : LongInt;
function wsaGetAsyncBuflen(Param : LongInt) : Word;
function wsaGetAsyncError(Param : LongInt) : Word;
function wsaGetSelectEvent(Param : LongInt) : Word;
function wsaGetSelectError(Param : LongInt) : Word;

var
  SockFuncs : TSocketFuncs;

implementation

const
  {$IFDEF Win32}
  SockDLL = 'WSOCK32';
  {$ELSE}
  SockDLL = 'WINsOCK.DLL';
  {$ENDIF}

var
  SocketModule : THandle;


{ Assure Winsock module is loaded and function pointers are set }
function LoadWinsock : Boolean;
begin
  Result := False;

  { Load Winsock module if it isn't already }
  if SocketModule = 0 then
    SocketModule := LoadLibrary(SockDLL);

  { Validate loading of the module }
  {$IFDEF Win32}
  if SocketModule = 0 then begin
  {$ELSE}
  if SocketModule <= HINsTANCE_ERROR then begin
  {$ENDIF}
    SocketModule := 0;
    Exit;
  end;

  { Load and validate all pointers }
  with SockFuncs do begin

    @Accept := GetProcAddress(SocketModule, 'accept');
    if not Assigned(Accept) then Exit;

    @Bind := GetProcAddress(SocketModule, 'bind');
    if not Assigned(Bind) then Exit;

    @CloseSocket := GetProcAddress(SocketModule, 'closesocket');
    if not Assigned(CloseSocket) then Exit;

    @Connect := GetProcAddress(SocketModule, 'connect');
    if not Assigned(Connect) then Exit;

    @GetPeerName := GetProcAddress(SocketModule, 'getpeername');
    if not Assigned(GetPeerName) then Exit;

    @GetSockName := GetProcAddress(SocketModule, 'getsockname');
    if not Assigned(GetSockName) then Exit;

    @GetSockOpt := GetProcAddress(SocketModule, 'getsockopt');
    if not Assigned(GetSockOpt) then Exit;

    @htonl := GetProcAddress(SocketModule, 'htonl');
    if not Assigned(htonl) then Exit;

    @htons := GetProcAddress(SocketModule, 'htons');
    if not Assigned(htons) then Exit;

    @INet_Addr := GetProcAddress(SocketModule, 'inet_addr');
    if not Assigned(INet_Addr) then Exit;

    @INet_Ntoa := GetProcAddress(SocketModule, 'inet_ntoa');
    if not Assigned(INet_Ntoa) then Exit;

    @IOCtlSocket := GetProcAddress(SocketModule, 'ioctlsocket');
    if not Assigned(IOCtlSocket) then Exit;

    @Listen := GetProcAddress(SocketModule, 'listen');
    if not Assigned(Listen) then Exit;

    @ntohl := GetProcAddress(SocketModule, 'ntohl');
    if not Assigned(ntohl) then Exit;

    @ntohs := GetProcAddress(SocketModule, 'ntohs');
    if not Assigned(ntohs) then Exit;

    @Recv := GetProcAddress(SocketModule, 'recv');
    if not Assigned(Recv) then Exit;

    @RecvFrom := GetProcAddress(SocketModule, 'recvfrom');
    if not Assigned(RecvFrom) then Exit;

    @Select := GetProcAddress(SocketModule, 'select');
    if not Assigned(Select) then Exit;

    @Send := GetProcAddress(SocketModule, 'send');
    if not Assigned(Send) then Exit;

    @SendTo := GetProcAddress(SocketModule, 'sendto');
    if not Assigned(SendTo) then Exit;

    @SetSockOpt := GetProcAddress(SocketModule, 'setsockopt');
    if not Assigned(SetSockOpt) then Exit;

    @Shutdown := GetProcAddress(SocketModule, 'shutdown');
    if not Assigned(Shutdown) then Exit;

    @Socket := GetProcAddress(SocketModule, 'socket');
    if not Assigned(Socket) then Exit;

    @GetHostByAddr := GetProcAddress(SocketModule, 'gethostbyaddr');
    if not Assigned(GetHostByAddr) then Exit;

    @GetHostByName := GetProcAddress(SocketModule, 'gethostbyname');
    if not Assigned(GetHostByName) then Exit;

    @GetHostName := GetProcAddress(SocketModule, 'gethostname');
    if not Assigned(GetHostName) then Exit;

    @GetServByPort := GetProcAddress(SocketModule, 'getservbyport');
    if not Assigned(GetServByPort) then Exit;

    @GetServByName := GetProcAddress(SocketModule, 'getservbyname');
    if not Assigned(GetServByName) then Exit;

    @GetProtoByNumber := GetProcAddress(SocketModule, 'getprotobynumber');
    if not Assigned(GetProtoByNumber) then Exit;

    @GetProtoByName := GetProcAddress(SocketModule, 'getprotobyname');
    if not Assigned(GetProtoByName) then Exit;

    @wsaStartup := GetProcAddress(SocketModule, 'WSAStartup');
    if not Assigned(wsaStartup) then Exit;

    @wsaCleanup := GetProcAddress(SocketModule, 'WSACleanup');
    if not Assigned(wsaCleanup) then Exit;

    @wsaSetLastError := GetProcAddress(SocketModule, 'WSASetLastError');
    if not Assigned(wsaSetLastError) then Exit;

    @wsaGetLastError := GetProcAddress(SocketModule, 'WSAGetLastError');
    if not Assigned(wsaGetLastError) then Exit;

    @wsaIsBlocking := GetProcAddress(SocketModule, 'WSAIsBlocking');
    if not Assigned(wsaIsBlocking) then Exit;

    @wsaUnhookBlockingHook := GetProcAddress(SocketModule, 'WSAUnhookBlockingHook');
    if not Assigned(wsaUnhookBlockingHook) then Exit;

    @wsaSetBlockingHook := GetProcAddress(SocketModule, 'WSASetBlockingHook');
    if not Assigned(wsaSetBlockingHook) then Exit;

    @wsaCancelBlockingCall := GetProcAddress(SocketModule, 'WSACancelBlockingCall');
    if not Assigned(wsaCancelBlockingCall) then Exit;

    @wsaAsyncGetServByName := GetProcAddress(SocketModule, 'WSAAsyncGetServByName');
    if not Assigned(wsaAsyncGetServByName) then Exit;

    @wsaAsyncGetServByPort := GetProcAddress(SocketModule, 'WSAAsyncGetServByPort');
    if not Assigned(wsaAsyncGetServByPort) then Exit;

    @wsaAsyncGetProtoByName := GetProcAddress(SocketModule, 'WSAAsyncGetProtoByName');
    if not Assigned(wsaAsyncGetProtoByName) then Exit;

    @wsaAsyncGetProtoByNumber := GetProcAddress(SocketModule, 'WSAAsyncGetProtoByNumber');
    if not Assigned(wsaAsyncGetProtoByNumber) then Exit;

    @wsaAsyncGetHostByName := GetProcAddress(SocketModule, 'WSAAsyncGetHostByName');
    if not Assigned(wsaAsyncGetHostByName) then Exit;

    @wsaAsyncGetHostByAddr := GetProcAddress(SocketModule, 'WSAAsyncGetHostByAddr');
    if not Assigned(wsaAsyncGetHostByAddr) then Exit;

    @wsaCancelAsyncRequest := GetProcAddress(SocketModule, 'WSACancelAsyncRequest');
    if not Assigned(wsaCancelAsyncRequest) then Exit;

    @wsaAsyncSelect := GetProcAddress(SocketModule, 'WSAAsyncSelect');
    if not Assigned(wsaAsyncSelect) then Exit;

    {$IFDEF Win32}

    {At least one implementation of 32-bit Winsock does not have these calls}
    {@wsaRecvEx := GetProcAddress(SocketModule, 'WSARecvEx');
    if not Assigned(wsaRecvEx) then Exit;}

    {@TransmitFile := GetProcAddress(SocketModule, 'TransmitFile');
    if not Assigned(TransmitFile) then Exit;}
    {$ENDIF}

  end;

  { If we got here -- we succeeded }
  Result := True;
end;

function wsaMakeSyncReply(Buflen, Error : Word) : LongInt;
begin
  Result := MakeLong(Buflen, Error);
end;

function wsaMakeSelectReply(Event, Error : Word) : LongInt;
begin
  Result := MakeLong(Event, Error);
end;

function wsaGetAsyncBuflen(Param : LongInt) : Word;
begin
  Result := LoWord(Param);
end;

function wsaGetAsyncError(Param : LongInt) : Word;
begin
  Result := HiWord(Param);
end;

function wsaGetSelectEvent(Param : LongInt) : Word;
begin
  Result := LoWord(Param);
end;

function wsaGetSelectError(Param : LongInt) : Word;
begin
  Result := HiWord(Param);
end;

procedure WinsockExit; far;
begin
  if SocketModule <> 0 then begin
    FreeLibrary(SocketModule);
    SocketModule := 0;
  end;
end;

initialization
{$IFNDEF Win32}
  AddExitProc(WinsockExit);
{$ENDIF}
  FillChar(SockFuncs, Sizeof(SockFuncs), #0);
  SocketModule := 0;

{$IFDEF Win32}
finalization
  {Free Winsock if we loaded it}
  WinsockExit;
{$ENDIF}

end.

