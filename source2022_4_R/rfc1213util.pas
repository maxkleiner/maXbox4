{ TODO : Rewrite UptimeToDays functions - it looks quick and dirty }

{ rfc1213 project - at the moment - http://yana.sourceforge.net/

  ====================
  unit rfc1213util.pas
  ====================

  Copyright (C) 2006-2007 Sergei Kostigoff (sergei<at>users<dot>sourceforge<dot>net)

  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option)
  any later version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web
  at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
  to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
  MA 02111-1307, USA.
}

{ @abstract(RFC1213 related @bold(utility) functions; no forms) @br
  Few utility funtions I have not quickly found elsewhere.
  Code in this unit is very quick and dirty. }
unit rfc1213util;

//{$mode delphi} {$H+}

interface

uses
  SysUtils,
  Classes,
  SNMPsend,
  rfc1213const;

const
  { @bold(release history)
    @table(
    @rowhead( @cell( Release)
              @cell( Date (YYYY-MM-DD))
              @cell( Description))
        @row( @cell( 0.1.0)
              @cell( 2006-10-01)
              @cell( Initial release, pre-alpha, for internal use))
        @row( @cell( 0.1.1)
              @cell( 2007-04-09)
              @cell( alpha release - for yana 0.1.0 alpha))
        @row( @cell( 0.1.2)
              @cell( 2007-05-09)
              @cell( alpha 2 release, comments were added, some minor "comb"
                     has been made; constants were moved between source files))
  )
  version of the unit}
  version = '0.1.2';


{ Formats Uptime ticks from 100th of second
  to days-hours-minuts-seconds format}
function UptimeToDays(const Uptime:string): string;

{ Gets snmp information in string format, set Error value if any}
function getSNMP(const mib,community,host: string; var ErrNo: Integer):string;

{ Function sysServicesString returns text description of
the received argument 'sysServicesStr' which is a string value
of bit coded integer, see @link(ssPhysicalLayer) for example}
function sysServicesString(const sysServicesStr : string) : string;


//---rfc1213 ip---

function ipForwardingString(const ipForwarding: string): string;
{ -- Interpret ipRouteType to human-readable string
  @param( ipRouteType is a string with integer value)
  @return( ipRouteTypeString is a human-readable string with explanation of
           the ipRouteType; see @link(sIpRouteTypeString) for possible
           result values ) }
function ipRouteTypeString(const ipRouteType:string):string;

{ -- Interpret ipRouteProto to human-readable string
  @param( ipRouteProto is a string with integer value)
  @return( ipRouteProtoString is a human-readable string with explanation of
           the ipRouteProto; see @link(sIpRouteProtoString) for possible result
           values ) }
function ipRouteProtoString(const ipRouteProto: string): string;

{ -- Interpret ipNetToMediaType to human-readable string
  @param( ipNetToMediaType is a string with integer value)
  @return( ipNetToMediaTypeString is a human-readable string with explanation of
           the ipRouteProto; see @link(sIpNetToMediaTypeString) for possible result
           values ) }
function ipNetToMediaTypeString(const ipNetToMediaType: string): string;

//---rfc1213ip end---


{ -- Extract mib column value for column[index[ from mib row.
     Main purpose of the function is to suppress SNMP implementation for some
     devices which does not provide full support. }
function GetColFromTableRow(const EntryCols: TStringList; index : integer): string;

//-----------------------------------------
//--- rfc1213if ---------------------------
{ Returns textual description of the number presented by ifTypeStringNo. }
function ifTypeString(ifTypeStringNo : string): string;

{ Returns textual description of the number presented by ifStatusStringNo. }
function ifStatusString(ifStatusStringNo : string): string;
//--- rfc1213if end -----------------------
//-----------------------------------------


//-----------------------------------------
//--- rfc1213tcp --------------------------
{ -- Interpret tcpRtoAlgorithm to human-readable string
  @param( tcpRtoAlgorithm is a string with integer value)
  @return( tcpRtoAlgorithmString is a human-readable string with explanation of
           the tcpRtoAlgorithm; see @link(stcpRtoAlgorithmString) for possible
           result values ) }
function tcpRtoAlgorithmString(const tcpRtoAlgorithm: string): string;

{ -- Interpret tcpConnState to human-readable string
  @param( tcpConnState is a string with integer value)
  @return( tcpConnStateString is a human-readable string with explanation of
           the tcpConnState; see @link(stcpConnStateString) for possible
           result values ) }
function tcpConnStateString(const tcpConnState: string): string;
//--- rfc1213tcp end ----------------------
//-----------------------------------------


//-----------------------------------------
//--- rfc1213egp --------------------------
function egpNeighStateString(const egpNeighState: string): string;

function egpNeighModeString(const egpNeighMode: string): string;

function egpNeighEventTriggerString(const egpNeighEventTrigger: string): string;
//--- rfc1213egp end ----------------------
//-----------------------------------------


//-----------------------------------------
//--- rfc1213snmp -------------------------
{ Replaces integer value of "snmpEnableAuthenTraps" with its textual
explanation. }
function snmpEnableAuthenTrapsString(const snmpEnableAuthenTraps: string): string;
//--- rfc1213snmp end ---------------------
//-----------------------------------------

function FormatMac(const Mac: string): string;

implementation

function UptimeToDays(const Uptime:string): string;
var
  UptimeInt : Integer;
  Code : Integer;
  days, hours, minutes, seconds, sec100 : integer;
const
  oneDay = 24*60*60*100;  {# of sec100th in one day}
  oneHour = 60*60*100;    {# of sec100th in one hour}
  oneMinute = 60*100;     {# of sec100th in one minute}
  oneSecond = 100;        {# of sec100th in one second}

begin
  if (Uptime = empty_response) or (Uptime = '') or
     (Uptime = no_reply_response) then begin
    Result := '<empty>';
    exit;
  end;
  Val(Uptime,UptimeInt,Code);
  if Code <> 0 then begin
    Result := 'Error'; {should not happen in theory}
    Exit;
  end;
  days := UptimeInt div oneDay;
  UptimeInt := UptimeInt - days * oneDay;

  hours := UptimeInt div oneHour;
  UptimeInt := UptimeInt - hours * oneHour;

  minutes := UptimeInt div oneMinute;
  UptimeInt := UptimeInt - minutes * oneMinute;

  seconds := UptimeInt div oneSecond;
  sec100 := UptimeInt - seconds * oneSecond;

  Result := IntToStr(days) + ' d, ' +
            IntTostr(hours) + ' h, '+
            IntToStr(minutes) + ' min, '+
            IntToStr(seconds) + '.' +
            IntToStr(sec100) + ' sec';

end;


function getSNMP(const mib,community,host: string; var ErrNo: Integer):string;
var
  response : string;
begin
  { does error exists? }
  if ErrNo <> 0 then begin
    { yes - dont send request }
    Result := Question_Sign;
    exit;
  end;

  // no error, try to get MIB reply string
  if SNMPget(mib,community,host,response) then begin
    Result := response;
    exit;
  end;

  // no snmp reply received, set error state and return error message
  ErrNo := no_snmp_reply;
  Result := Question_Sign;
end;

function sysServicesString(const sysServicesStr : string) : string;
var
  sysServices, Code : Integer;
begin
  Result :='';
  if sysServicesStr = '' then
    exit;
  Val(sysServicesStr,sysServices,Code);
  if Code <> 0 then begin
    Result := 'Error - not a number';
    exit;
  end;
  if (sysServices < 0) or (sysServices > 127) then begin
    Result := 'Error - out of range';
  end;
  Result := '';
  if sysServices and ssPhysicalLayer <> 0 then
    Result := Result + #13#10' physical (e.g., repeaters)';
  if sysServices and ssDatalinkSubnetworkLayer <> 0 then
    Result := Result + #13#10' datalink/subnetwork (e.g., bridges)';
  if sysServices and ssInternetLayer <> 0 then
    Result := Result + #13#10' internet (e.g., IP gateways)';
  if sysServices and ssEndToEndLayer <> 0 then
    Result := Result + #13#10' end-to-end (e.g., IP hosts)';
  if sysServices and (ssOSI1Layer or ssOSI2Layer) <> 0 then
    Result := Result + #13#10' OSI protocols system';
  if sysServices and ssApplicationsLayer <> 0 then
    Result := Result + #13#10' applications (e.g., mail relays)';
end;

//---rfc1213ip
function ipForwardingString(const ipForwarding: string): string;
var
  Code : Integer;
  Value: Integer;
begin
  Val(ipForwarding,Value,Code);
  if (Code <> 0) then begin
    Result := ipForwarding + not_a_number;
    exit;
  end;
  if (Value < 1) or (Value > ipForwardingMax) then
    Result := ipForwarding + not_in_range
  else
    Result := sipForwardingString[Value];
end;

function ipRouteTypeString(const ipRouteType: string) :string;
var
  Code : Integer;
  Value: Integer;
begin
  Val(ipRouteType,Value,Code);
  if (Code <> 0) then begin
    Result := ipRouteType + not_a_number;
    exit;
  end;
  if (Value < 1) or (Value > ipRouteTypeMax) then
    Result := ipRouteType + not_in_range
  else
    Result := sipRouteTypeString[Value];
end;

//------------
function IpRouteProtoString(const ipRouteProto: string): string;
var
  Code : Integer;
  Value: Integer;
begin
  Val(ipRouteProto,Value,Code);
  if (Code <> 0) then begin
    Result := ipRouteProto + not_a_number;
    exit;
  end;
  if (Value < 1) or (Value > ipRouteProtoMax) then
    Result := ipRouteProto + not_in_range
  else
    Result := sIpRouteProtoString[Value];
end;

function ipNetToMediaTypeString(const ipNetToMediaType: string): string;
var
  Code : Integer;
  Value: Integer;
begin
  Val(ipNetToMediaType,Value,Code);
  if (Code <> 0) then begin
    Result := ipNetToMediaType + not_a_number;
    exit;
  end;
  if (Value < 1) or (Value > ipNetToMediaTypeMax) then
    Result := ipNetToMediaType + not_in_range
  else
    Result := sipNetToMediaTypeString[Value];
end;

//---rfc1213ip

function GetColFromTableRow(const EntryCols: TStringList; index : integer): string;
begin
  if EntryCols.Count > index then
    Result := EntryCols.Strings[index]
  else
    Result := empty_response;
end;

//---rfc1213if
function ifTypeString(ifTypeStringNo : string): string;
var
  ifType, Code : Integer;
begin
  Val(ifTypeStringNo,ifType,Code);
  if Code <> 0 then begin
    Result := ifTypeStringNo +' -'+not_a_number;
    exit;
  end;
  if (ifType < 1) or (ifType > MaxIfType) then begin
    Result := ifTypeStringNo +' -'+ not_in_range;
    exit;
  end;
  Result := ifTypeStr[ifType];
end;

function ifStatusString(ifStatusStringNo : string): string;
var
  ifStatusInt, Code : integer;
begin
  Val(ifStatusStringNo,ifStatusInt,Code);
  if Code <> 0 then begin
    Result := ifStatusStringNo +' -'+not_a_number;
    exit;
  end;
  case ifStatusInt of
    1 : Result := 'up';
    2 : Result := 'down';
    3 : Result := 'testing';
    else Result := ifStatusStringNo +' -'+not_in_range;
  end; // case
end;
//--- rfc1213if end ----------------------
//----------------------------------------

//----------------------------------------
//--- rfc1213tcp -------------------------
function tcpRtoAlgorithmString(const tcpRtoAlgorithm: string): string;
var
  Code : Integer;
  Value: Integer;
begin
  Val(tcpRtoAlgorithm,Value,Code);
  if (Code <> 0) then begin
    Result := tcpRtoAlgorithm + not_a_number;
    exit;
  end;
  if (Value < 1) or (Value > tcpRtoAlgorithmMax) then
    Result := tcpRtoAlgorithm + not_in_range
  else
    Result := sTcpRtoAlgorithmString[Value];
end;

function tcpConnStateString(const tcpConnState: string): string;
var
  Code : Integer;
  Value: Integer;
begin
  Val(tcpConnState,Value,Code);
  if (Code <> 0) then begin
    Result := tcpConnState + not_a_number;
    exit;
  end;
  if (Value < 1) or (Value > tcpConnStateMax) then
    Result := tcpConnState + not_in_range
  else
    Result := stcpConnStateString[Value];
end;
//---rfc1213tcp end

//---rfc1213egp
function egpNeighStateString(const egpNeighState: string): string;
var
  Code : Integer;
  Value: Integer;
begin
  Val(egpNeighState,Value,Code);
  if (Code <> 0) then begin
    Result := egpNeighState + not_a_number;
    exit;
  end;
  if (Value < 1) or (Value > egpNeighStateMax) then
    Result := egpNeighState + not_in_range
  else
    Result := segpNeighStateString[Value];
end;

function egpNeighModeString(const egpNeighMode: string): string;
var
  Code : Integer;
  Value: Integer;
begin
  Val(egpNeighMode,Value,Code);
  if (Code <> 0) then begin
    Result := egpNeighMode + not_a_number;
    exit;
  end;
  if (Value < 1) or (Value > egpNeighModeMax) then
    Result := egpNeighMode + not_in_range
  else
    Result := segpNeighModeString[Value];
end;

function egpNeighEventTriggerString(const egpNeighEventTrigger: string): string;
var
  Code : Integer;
  Value: Integer;
begin
  Val(egpNeighEventTrigger,Value,Code);
  if (Code <> 0) then begin
    Result := egpNeighEventTrigger + not_a_number;
    exit;
  end;
  if (Value < 1) or (Value > egpNeighEventTriggerMax) then
    Result := egpNeighEventTrigger + not_in_range
  else
    Result := segpNeighEventTriggerString[Value];
end;
//---rfc1213egp

//---rfc1213snmp
//---
function snmpEnableAuthenTrapsString(const snmpEnableAuthenTraps: string): string;
var
  Code : Integer;
  Value: Integer;
begin
  Val(snmpEnableAuthenTraps,Value,Code);
  if (Code <> 0) then begin
    Result := snmpEnableAuthenTraps + not_a_number;
    exit;
  end;
  if (Value < 1) or (Value > snmpEnableAuthenTrapsMax) then
    Result := snmpEnableAuthenTraps + not_in_range
  else
    Result := ssnmpEnableAuthenTrapsString[Value];
end;


//---rfc1213snmp end



{1234567890ab}
function FormatMac(const Mac: string): string;
var
  i: integer;
begin
  Result :='';
  if Mac='' then
    Result := '-'
  else
    if length(Mac) <> 12 then
      Result := Mac
    else begin
      for i := 0 to 5 do
        Result := Result + copy(Mac,i*2+1,2) + '-';
      Delete(Result,length(result),1);
    end;
end;

initialization

finalization


end.
