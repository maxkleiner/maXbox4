{*_* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       François PIETTE
Description:  Component to query DNS records.
              Implement a subset of RFC 1035 (A and MX records).
Creation:     January 29, 1999
Version:      8.00
EMail:        http://www.overbyte.be        francois.piette@overbyte.be
Support:      Use the mailing list twsocket@elists.org
              Follow "support" link at http://www.overbyte.be for subscription.
Legal issues: Copyright (C) 1999-2010 by François PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium. Fax: +32-4-365.74.56
              <francois.piette@overbyte.be>

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

              4. You must register this software by sending a picture postcard
                 to the author. Use a nice stamp and mention your name, street
                 address, EMail address and any comment you like to say.

History:
Feb 14, 1999 V0.02 Indirectly call winsock functions using wsocket because
             wsocket provide runtime dynamic link instead of loadtime link.
             This allows a program to use DnsQuery if it discover that winsock
             is installed and still run if winsock is not installed.
Feb 24, 1999 V1.00 Added code for reverse lookup (PTR record).
Mar 07, 1999 V1.01 Adapted for Delphi 1
Aug 20, 1999 V1.02 Revise compile time option. Adapted for BCB4
Jul 27, 2001 V1.03 Holger Lembke <holger@hlembke.de> implemented a few new
                   queries or propreties (QueryAny, LongLatToDMS, Loc2Geo, Loc)
                   and related data types.
Sep 04, 2003 V1.04 Replaced all htons by WSocket_htons
May 31, 2004 V1.05 Used ICSDEFS.INC
Nov 19, 2004 V1.06 Added Multithreaded property
Mar 06, 2005 V1.07 DecodeAnswer has been fixed to avoid winsock ntohs and
                   ntohl function which have range check errors because Borland
                   defined the function as returning LongInt instead of Cardinal
May 29, 2005 V1.08 Jack <jlist9@gmail.com> added TCP support
Mar 26, 2006 V6.00 New version 6 started
Jun 05, 2008 A. Garrels made some changes to prepare code for Unicode
Aug 11, 2008 V6.02 A. Garrels - Type AnsiString rolled back to String.
Oct 09, 2009 V6.03 Yaroslav Chernykh fixed a bug in WSocketSessionConnected()
                   when using UDP.
May 2012 - V8.00 - Arno added FireMonkey cross platform support with POSIX/MacOS
                   also IPv6 support, include files now in sub-directory


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

unit OverbyteIcsDnsQuery;

interface

 (*   Ics.Fmx.OverbyteIcsWSocket,
{$ELSE}
    OverbyteIcsWSocket,
{$ENDIF}
    OverbyteIcsWinsock;
   *)
   
   {$DEFINE MSWINDOWS}
   
const
  DnsQueryVersion    = 800;

  { Maximum answers (responses) count }
  MAX_ANCOUNT     = 50;
  { Maximum number of MX records taken into account in responses }
  MAX_MX_RECORDS  = 50;
  MAX_A_RECORDS   = 50;
  MAX_PTR_RECORDS = 10;

  { DNS Classes }
  DnsClassIN      = 1;   { The internet                                      }
  DnsClassCS      = 2;   { The CSNET class (obsolete, used only for examples)}
  DnsClassCH      = 3;   { The CHAOS class                                   }
  DnsClassHS      = 4;   { Hesiod name service                               }
  DnsClassALL     = 255; { Any class                                         }

  { Type of query/response a DNS can handle }
  DnsQueryA       = 1;  { A     HostAddress                                  }
  DnsQueryNS      = 2;  { NS    Authoritative name server                    }
  DnsQueryMD      = 3;  { MD    MailDestination, obsolete, use Mail Exchange }
  DnsQueryMF      = 4;  { MF    MailForwarder, obsolete, use Mail Exchange   }
  DnsQueryCNAME   = 5;  { CNAME CanonicalName                                }
  DnsQuerySOA     = 6;  { SOA   Start of a Zone of Authority                 }
  DnsQueryMB      = 7;  { MB    MailBox, experimental                        }
  DnsQueryMG      = 8;  { MG    MailGroup, experimental                      }
  DnsQueryMR      = 9;  { MR    MailRename, experimental                     }
  DnsQueryNULL    = 10; { NULL  Experimental                                 }
  DnsQueryWKS     = 11; { WKS   Well Known Service Description               }
  DnsQueryPTR     = 12; { PTR   Domain Name Pointer                          }
  DnsQueryHINFO   = 13; { HINFO Host Information                             }
  DnsQueryMINFO   = 14; { MINFO Mailbox information                          }
  DnsQueryMX      = 15; { MX    Mail Exchange                                }
  DnsQueryTXT     = 16; { TXT   Text Strings                                 }
  { !!KAP!! }
  DnsQueryRP      = 17;
  DnsQueryAFSDB   = 18;
  DnsQueryX25     = 19;
  DnsQueryISDN    = 20;
  DnsQueryRT      = 21;
  DnsQueryNSAP    = 22;
  DnsQueryNSAPPTR = 23;
  DnsQuerySIG     = 24; { see RFC-2065                                       }
  DnsQueryKEY     = 25; { see RFC-2065                                       }
  DnsQueryPX      = 26;
  DnsQueryGPOS    = 27; { GPOS has the following format:
                          <owner> <ttl> <class> GPOS <longitude> <latitude> <altitude> }
  DnsQueryAAAA    = 28; { see IP6 Address                                    }
  DnsQueryLOC     = 29; (* see RFC-1876  http://rfc.net/rfc1876.html
                         <owner> <TTL> <class> LOC ( d1 [m1 [s1]] {"N"|"S"} d2 [m2 [s2]]
                               {"E"|"W"} alt["m"] [siz["m"] [hp["m"]
                               [vp["m"]]]] )
                        *)
  DnsQueryNXT     = 30; { see RFC-2065                                       }

  DnsQuerySRV     = 33; { see RFC-2052                                       }
  DnsQueryNAPTR   = 35; { see RFC-2168                                       }
  DnsQueryKX      = 36;

  { Some additional type only allowed in queries }
  DnsQueryAXFR    = 252; { Transfer for an entire zone                       }
  DnsQueryMAILB   = 253; { Mailbox related records (MB, MG or MR)            }
  DnsQueryMAILA   = 254; { MailAgent, obsolete, use MX instead               }
  DnsQueryALL     = 255; { Request ALL records                               }

  { Opcode field in query flags }
  DnsOpCodeQUERY  = 0;
  DnsOpCodeIQUERY = 1;
  DnsOpCodeSTATUS = 2;

type
  TDnsRequestDoneEvent = procedure (Sender : TObject; Error : WORD); // of Object;
  TDnsRequestHeader = record
      ID      : WORD;
      Flags   : WORD;
      QDCount : WORD;
      ANCount : WORD;
      NSCount : WORD;
      ARCount : WORD;
  end;
  //PDnsRequestHeader = ^TDnsRequestHeader;

  TLOCInfo = record { need to be 16 bytes }
    version    : byte;
    size       : byte;
    horizpre   : byte;
    vertpre    : byte;
    latitude   : longint;
    longitude  : longint;
    altitude   : longint;
  end;
  //PLOCInfo = ^TLOCInfo;

  { Decoded TLOCInfo }
  TLogGeo = record
    version             : byte;
    longsize            : integer;
    latsize             : integer;
    horizpre            : integer;
    vertpre             : integer;
    { Latitude, degree, minutes, seconds, milliseconds }
    lad, lam, las, lams : integer;
    lahem               : ansichar;
    { same for Longitude }
    lod, lom, los, loms : integer;
    lohem               : ansichar;
    altitude            : integer;
  end;

  

function ReverseIP(const IP : AnsiString) : AnsiString;
function LongLatToDMS(longlat : longint; hemis : AnsiString) : AnsiString; { !!KAP!! }
function Loc2Geo(loc : TLOCInfo) : TLogGeo;                        { !!KAP!! }

implementation

{type
    PWORD  = ^WORD;
    PDWORD = ^DWORD;
 }

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function ReverseIP(const IP : AnsiString) : AnsiString;
var
    I, J : Integer;
begin
    Result := '';
    if Length(IP) = 0 then
        Exit;
    J      := Length(IP);
    writeln(itoa(j))
    I      := J;
    while I >= 0 do begin 
      writeln(ip[i])
        if (I = 0) or (IP[I] = '.') then begin
            Result := Result + '.' + Copy(IP, I + 1, J - I);
            J := I - 1;
        end;
        Dec(I);
        //if I<=0 then break;
    end;
    if Result[1] = '.' then
        Delete(Result, 1, 1);
end;

function ReverseIP2(const IP : String) : String;
var
    I, J : Integer;
begin
    Result := '';
    if Length(IP) = 0 then
        Exit;
    J      := Length(IP);
    writeln(itoa(j))
    I      := J;
    while I >= 0 do begin 
      writeln(ip[i])
        if (I = 0) or (IP[I] = '.') then begin
            Result := Result + '.' + Copy(IP, I + 1, J - I);
            J := I - 1;
        end;
        Dec(I);
    end;
    if Result[1] = '.' then
        Delete(Result, 1, 1);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}


(*
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TDnsQuery.PTRLookup(IP : AnsiString) : Integer;
begin
    Inc(FIDCount);
    BuildRequestHeader(PDnsRequestHeader(@FQueryBuf), FIDCount, DnsOpCodeQuery, TRUE, 1, 0, 0, 0);
    FQueryLen := BuildQuestionSection(@FQueryBuf[SizeOf(TDnsRequestHeader)],
                                      ReverseIP(IP) + '.in-addr.arpa',
                                      DnsQueryPTR, DnsClassIN);
    FQueryLen := FQueryLen + SizeOf(TDnsRequestHeader);
    Result    := FIDCount;
    SendQuery;
end;
*)

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
(*procedure TDnsQuery.SendQuery;
begin
    FResponseLen                := -1;
    FGotPacketLength            := FALSE;
    FWSocket.OnDataAvailable    := nil;
    FWSocket.Abort;
    FWSocket.OnDataAvailable    := WSocketDataAvailable;
    FWSocket.OnSessionConnected := WSocketSessionConnected;
    FWSocket.Proto              := FProto;
    FWSocket.Port               := FPort;
    FWSocket.Addr               := FAddr;
    FWSocket.Connect;
    { Note: UDP is connectionless, nevertheless, TWSocket call              }
    { OnSessionConnected event handler immediately. For TCP the event       }
    { handler is called only when session is connected (or fails to)        }
end;

 *)
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
(*procedure TDnsQuery.WSocketSessionConnected(Sender: TObject; Error: WORD);
var
    Buf: array [0..1] of BYTE;
begin
    if Error = 0 then begin
        if FProto = 'tcp' then begin { V6.03 }
            Buf[0] := FQueryLen div 256;
            Buf[1] := FQueryLen mod 256;
            { Send 2 byte length for tcp packets, see RFC 1035 - 4.2.2. TCP usage }
            FWSocket.Send(@Buf[0], 2);
        end;
        FWSocket.Send(@FQueryBuf, FQueryLen);
    end;
end;
 *)


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function ntohs(V : WORD) : Integer;
begin
    Result := ((V and $FF) shl 8) or ((V shr 8) and $FF);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function ntohl(V : DWORD) : LongInt;
begin
    Result := (ntohs(V and $FFFF) shl 16) or ntohs((V shr 16) and $FFFF);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
(*function TDnsQuery.DecodeMXData(
    Base           : PAnsiChar;
    From           : PAnsiChar;
    var Preference : Integer;
    var Exchange   : AnsiString) : PAnsiChar;
begin
    Result := From;
    Preference := WSocket_ntohs(PWORD(Result)^);
    Inc(Result, 2);
    Result := ExtractName(Base, Result, Exchange);
end;
 *)

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{
  <0><1><129><128><0><1><0><1><0><4><0><5><7>inp
  rise<3>com<0><0><15><0><1><192><12><0>
  <15><0><1><0><1>QV<0><10><0><10><5>drui
  d<192><12><192><12><0><2><0><1><0><1>Qc<0><6><3>
  ns1<192><12><192><12><0><2><0><1><0><1>Qc<0>
  <20><3>NS1<10>SPRINTLINK
  <3>NET<0><192><12><0><2><0><1><0><1>Qc<0>
  <6><3>NS2<192>U<192><12><0><2><0><1><0><1>Q
  c<0><6><3>NS3<192>U<192>+<0><1><0><1><0>
  <1>QV<0><4><143><186><11>F<192>?<0><1><0><1><0>
  <1>Qc<0><4><207>iS<30><192>Q<0><1><0><1><0>
  <2><144>i<0><4><204>u<214><10><192>q<0><1><0><1><0>
  <2><144>i<0><4><199><2><252><10><192><131><0><1><0><1><0>
  <2><142><182><0><4><204>a<212><10>
}
{
  <0><3><129><128><0><1><0><1><0><2><0><3><4>rtf
  m<2>be<0><0><15><0><1><192><12><0><15><0><1><0>
  <1>.b<0><9><0><10><4>mail<192><12><192><12>
  <0><2><0><1><0><1>.b<0><11><2>ns<3>dn
  s<2>be<0><192><12><0><2><0><1><0><1>.b<0>
  <5><2>ns<192><12><192>'<0><1><0><1><0><1>.b
  <0><4><195><0>d<253><192>:<0><1><0><1><0><1>QY
  <0><4><134>:J!<192>Q<0><1><0><1><0><1>.b
  <0><4><195><0>d<253>
}
{
  <0><7><133><128><0><1><0><1><0><2><0><2><3>www
  <4>rtfm<2>be<0><0><1><0><1><192><12><0>
  <1><0><1><0><1>Q<128><0><4><195><0>d<253><4>rt
  fm<2>be<0><0><2><0><1><0><1>Q<128><0><5>
  <2>ns<192>-<192>-<0><2><0><1><0><1>Q<128><0>
  <9><2>ns<3>dns<192>2<192>@<0><1><0><1>
  <0><1>Q<128><0><4><195><0>d<253><192>Q<0><1><0><1>
  <0><0><26><132><0><4><134>:J!
}
(*
<0><1><129><128><0><1><0><1><0><5><0><5><9>fu-berlin
<2>de<0><0>

<29><0><1><192><12><0><29><0><1><0><0>,

<0><16><0><21><22><19><139>Av<167><130><218>L<242>
<0><152><156>\<192><12><0><2><0><1><0><0><12><176>
<0>"<4>arbi<10>informatik<13>uni-oldenburg<2>de<0>
<192><12><0><2><0><1><0><0><12><176><0><12><5>deneb<3>
dfn<192>d<192><12><0><2><0><1><0><0><12><176><0><6><3>
ns3<192><12><192><12><0><2><0><1><0><0><12><176><0><6>
<3>ns2<192><12><192><12><0><2><0><1><0><0><12><176><0>
<6><3>ns1<192><12><192>F<0><1><0><1><0><0>t<169><0><4>
<134>j<1><7><192>t<0><1><0><1><0><0>9<209><0><4><192>L
<176><9><192><140><0><1><0><1><0><0>T<19><0><4><130>
<133><1>9<192><158><0><1><0><1><0><0><28><206><0><4>
<160>-<10><12><192><176><0><1><0><1><0><0>1<198><0>
<4><160>-<8><8>
*)

{ !!KAP!! }
{raw translation of some perl-source LOC.pm from package Net::DNS::RR::LOC;

fu-berlin.de   LOC  52 27 19.591 N 13 17 40.978 E 15.00m 1000.00m 10000.00m 10.00m
}
const conv_sec = 1000.0;
      conv_min = 60.0 * conv_sec;
      conv_deg = 60.0 * conv_min;
      zh31     = 1 shl 31;
      
 var  GWSockCritSect : TRTLCriticalSection;
      WSocketGCount   : Integer;

procedure SubLOCgeo(longlat : longint;
                    hemis : AnsiString;
                    var ldeg, lmin, lsec, lmsec : Extended;
                    var hemic : AnsiChar);
var
    Labs : Extended;
begin
    //LongLat := WSocket_ntohl(LongLat);
    Labs    := Abs(1.0 * LongLat - zh31);
    Ldeg    := Trunc(labs / conv_deg);
    Labs    := Labs - ldeg * conv_deg;
    Lmin    := Trunc(labs / conv_min);
    Labs    := Labs - lmin * conv_min;
    Lsec    := Trunc(labs / conv_sec);
    Labs    := Labs - lsec * conv_sec;
    Lmsec   := Labs;
    Hemic   := Copy(Hemis, 1 + ord(LongLat <= zh31), 1)[1]; { yeah. }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function LongLatToDMS(longlat : longint; hemis : AnsiString): AnsiString;
Var ldeg, lmin, lsec, lmsec : extended;
    hemi                    : AnsiChar;
begin
  SubLOCgeo(longlat,hemis,ldeg,lmin,lsec,lmsec,hemi);
  result := AnsiString(Format('%d %02d %02d.%03d',
               [round(ldeg), round(lmin), round(lsec),
                round(lmsec)]) + ' ' + Char(hemi));
end;


{$IFNDEF NO_ADV_MT}
procedure SafeIncrementCount;
begin
  {$IFNDEF POSIX}
    EnterCriticalSection(GWSockCritSect);
    Inc(WSocketGCount);
    LeaveCriticalSection(GWSockCritSect);
  {$ENDIF}
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure SafeDecrementCount;
begin
  {$IFDEF MSWINDOWS}
    EnterCriticalSection(GWSockCritSect);
    Dec(WSocketGCount);
    LeaveCriticalSection(GWSockCritSect);
  {$ENDIF}
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function SafeWSocketGCount : Integer;
begin
  {$IFDEF MSWINDOWS}
    EnterCriticalSection(GWSockCritSect);
    Result := WSocketGCount;
    LeaveCriticalSection(GWSockCritSect);
  {$ELSE}
    Result := 0;
  {$ENDIF}
end;
{$ENDIF}


function WSocket_Synchronized_ntohl(netlong: longint): longint;
  {$IFDEF USE_INLINE} inline; {$ENDIF}
begin
  {$IFDEF MSWINDOWS}
    //Result := Ics_ntohl(netlong);    NOT Found!
  {$ENDIF}
  {$IFDEF POSIX}
    Result := ntohl(netlong);
  {$ENDIF}
    (*
    if @Fntohl = nil then
        @Fntohl := WSocketGetProc('ntohl');
    Result := Fntohl(netlong);
    *)
end;


//function WSocket_ntohl(netlong: u_long): u_long;
function WSocket_ntohl(netlong: longint): longint;
begin
{$IFNDEF NO_ADV_MT}
    SafeIncrementCount;
    try
{$ENDIF}
        Result := WSocket_Synchronized_ntohl(netlong);
{$IFNDEF NO_ADV_MT}
    finally
        SafeDecrementCount;
    end;
{$ENDIF}
end;



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ in cm!! }
function LocAltToAlt(Localt : LongInt) : LongInt;
begin
    Result := Round((WSocket_ntohl(localt) - 100000.0 * 100.0) / 100.0);
end;

procedure du(longlat : Integer;
               hemis   : AnsiString;
               var ideg, imin, isec, imsec : Integer;
               var hemic : AnsiChar);
  var
      ldeg, lmin, lsec, lmsec : extended;
  begin
      SubLOCgeo(longlat, hemis, ldeg, lmin, lsec, lmsec, hemic);
      ideg  := Round(ldeg);
      imin  := Round(lmin);
      isec  := Round(lsec);
      imsec := Round(lmsec);
  end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ !!KAP!! }
function Loc2Geo(loc : TLOCInfo):TLogGeo;
  { dolle umwandlung }
  (*procedure du(longlat : Integer;
               hemis   : AnsiString;
               var ideg, imin, isec, imsec : Integer;
               var hemic : AnsiChar);
  var
      ldeg, lmin, lsec, lmsec : extended;
  begin
      SubLOCgeo(longlat, hemis, ldeg, lmin, lsec, lmsec, hemic);
      ideg  := Round(ldeg);
      imin  := Round(lmin);
      isec  := Round(lsec);
      imsec := Round(lmsec);
  end; *)

begin
    Result.version  := Loc.version;
    Result.longsize := Round(Exp(Ln(10)*(loc.size and $f)));
    Result.latsize  := Round(Exp(Ln(10)*(loc.size shr 4)));

    Result.horizpre := Loc.horizpre;
    Result.vertpre  := Loc.vertpre;

    du(loc.latitude, 'NS', result.lad, result.lam,
       result.las, result.lams, result.lahem);
    du(loc.longitude, 'EW', result.lod, result.lom,
       result.los, result.loms, result.lohem);

    Result.altitude := LocAltToAlt(loc.altitude);
end;

(*
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TDnsQuery_SetMultiThreaded(const Value: Boolean);
begin
    if Assigned(FWSocket) then
        FWSocket.Multithreaded := Value;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TDnsQuery.GetMultiThreaded: Boolean;
begin
    if Assigned(FWSocket) then
        Result := FWSocket.Multithreaded
    else
        Result := FALSE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TDnsQuery.SetProto(const Value: String);
var
    Buf : String;
begin
    Buf := LowerCase(Value);
    if not ((Buf = 'tcp') or (Buf = 'udp')) then
        raise Exception.Create('TDnsQuery accept only TCP or UDP protocol');
    FProto := Value;
end; *)


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

begin
 //LocAltToAlt(250)
 
 //function ReverseIP(const IP : AnsiString) : AnsiString;
  //writeln('function ReverseIP: '+ReverseIP('192.168.012.255'));
  writeln('function ReverseIP: '+ReverseIP2('192.168.012.255'));


End.
