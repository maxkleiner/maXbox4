
{*******************************************************}
{                                                       }
{       WDosX Delphi Run-time Library                   }
{       WDOSX TCP/IP Socket Utilities Unit              }
{                                                       }
{       for Delphi 4, 5 WDosX DOS-Extender              }
{       Copyright (c) 2000 by Immo Wache                }
{       e-mail: immo.wache@t-online.de                  }
{                                                       }
{*******************************************************}

{
  Version history:
    IWA 11/20/00 Version 1.1
}

unit WDosSocketUtils;

interface

{$DEFINE DESIGNPACKAGE}

{$IFDEF DESIGNPACKAGE}
uses
  SysUtils;
{$ELSE}
uses
  WDosSysUtils;
{$ENDIF}

const
  IpAny       = $00000000;
  IpLoopBack  = $7F000001;
  IpBroadcast = $FFFFFFFF;
  IpNone      = $FFFFFFFF;

  PortAny     = $0000;

  SocketMaxConnections = 5;

type
  TIpAddr =type LongWord;

  TIpRec =packed record
    case Integer of
    0: (IpB1, IpB2, IpB3, IpB4: Byte);
    1: (IpW1, IpW2: Word);
  end;

function HostToNetLong(HostLong: LongWord): LongWord;
function HostToNetShort(HostShort: Word): Word;
function NetToHostLong(NetLong: LongWord): LongWord;
function NetToHostShort(NetShort: Word): Word;
function StrToIp(Ip: string): TIpAddr;
function IpToStr(Ip: TIpAddr): string;

implementation

function HostToNetLong(HostLong: LongWord): LongWord; assembler;
asm
        XCHG    AH,AL
        ROR     EAX,16
        XCHG    AH,AL
end;

function HostToNetShort(HostShort: Word): Word; assembler;
asm
        XCHG    AH,AL
end;

function NetToHostLong(NetLong: LongWord): LongWord; assembler;
asm
        XCHG    AH,AL
        ROR     EAX,16
        XCHG    AH,AL
end;

function NetToHostShort(NetShort: Word): Word; assembler;
asm
        XCHG    AH,AL
end;

function StrToIp(Ip: string): TIpAddr;
var
  S: string;
  I, K: Integer;
  P: packed array[1..4] of Byte absolute Result;
  Code: Integer;
begin
  for K :=1 to 3 do
  begin
    I :=Pos('.', Ip);
    S :=Copy(Ip, 1, I -1);
    Ip :=Copy(Ip, I +1, Length(Ip));
    if S ='' then S :='0';
    Val(S, P[K], Code);
    if Code <>0 then
    begin
      Result :=IpNone;
      Exit;
    end;
  end;
  Val(Ip, P[4], Code);
  if Code <>0 then Result :=IpNone;
end;

function IpToStr(Ip: TIpAddr): string;
begin
  with TIpRec(Ip) do
    Result :=Format('%d.%d.%d.%d', [IpB1, IpB2, IpB3, IpB4]);
end;

end.
