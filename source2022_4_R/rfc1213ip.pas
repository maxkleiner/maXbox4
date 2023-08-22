{ rfc1213 project - at the moment - http://yana.sourceforge.net/

  ==================
  unit rfc1213ip.pas
  ==================

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

{ @abstract(RFC1213 - @bold(IP group)) @br
  @preformatted(
-- the IP group

-- Implementation of the IP group is mandatory for all
-- systems.
  ) }
unit rfc1213ip;

interface

uses
  Classes,
  
  rfc1213const,
  rfc1213util,
  
  asn1util,
  snmpsend;
  
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
              @cell( 2007-05-11)
              @cell( alpha 2 release, comments were added, some minor "comb"
                     has been made; constants were moved between source files))
        @row( @cell( 0.2.1)
              @cell( 2007-05-21)
              @cell( beta 1 release, use of "snmp call" has been improved -
                     better integrtion with synapse library ))
        @row( @cell( 0.2.2)
              @cell( 2007-06-09)
              @cell( beta 2 release, destructor code amended ))
  )
  version of the unit}
  version = 'rfc1213ip v.0.2.2';

type
  Tip = class; //  = forward

type
  (* ipAddrEntry *)
  TipAddrEntry = record
    ipAdEntAddr: string;  //<.1
    ipAdEntIfIndex: string;  //<.2
    ipAdEntNetMask: string;  //<.3
    ipAdEntBcastAddr: string;  //<.4
    ipAdEntReasmMaxSize: string;  //<.5
  end;
  
  (* ipAddrTable *)
  TipAddrTable = class (TObject)

    ipAddrEntry: array of TipAddrEntry;

    constructor Create(AOwner: Tip);
    
    function Get: boolean;
    
    function IpAddrForIfIndex(const ifIndex:string):string;

    destructor Destroy;
    
    { Table defined as array of rows. Each row is @link(TipAddrEntry). }
    //ipAddrEntry: array of TipAddrEntry;

    protected
      Owner: Tip;
      FCount : integer;

    public
      property Count: integer read FCount;
  end;

  (* ipRouteEntry *)
  TipRouteEntry = record
    ipRouteDest: string;
    ipRouteIfIndex: string;
    ipRouteMetric1: string;
    ipRouteMetric2: string;
    ipRouteMetric3: string;
    ipRouteMetric4: string;
    ipRouteNextHop: string;
    ipRouteType: string;
    ipRouteProto: string;
    ipRouteAge: string;
    ipRouteMask: string;
    ipRouteMetric5: string;
    ipRouteInfo: string;
  end;

  (* ipRouteTable *)
  TipRouteTable = class (TObject)

  ipRouteEntry: array of TipRouteEntry;

    constructor Create(AOwner: Tip);
    function Get: boolean;
    destructor Destroy;


    protected
      Owner: Tip;
      FCount: integer;

    public
      property Count: integer read FCount;
  end;
  

  (* ipNetToMediaEntry *)
  TipNetToMediaEntry = record
    ipNetToMediaIfIndex: string;  //<.1
    ipNetToMediaPhysAddress: string;  //<.2
    ipNetToMediaNetAddress: string;  //<.3
    ipNetToMediaType: string;  //<.4
  end;
  
  (* ipNetToMediaTable *)
  TipNetToMediaTable = class (TObject)

   ipNetToMediaEntry: array of TipNetToMediaEntry;
   
    constructor Create(AOwner: Tip);
    function Get: boolean;
    destructor Destroy;


    protected
      Owner: Tip;
      FCount: integer;

    public
      property Count: integer read FCount;
  end;


  (* @abstract(RFC1213 @bold(ip) @br Textual OID
                .iso.org.dod.internet.mgmt.mib-2.ip @br
                Numerical OID .1.3.6.1.2.1.4)
     @preformatted(ip           OBJECT IDENTIFIER ::= { mib-2 4 }   ) *)
  Tip = class (TObject)

    private
    protected
      FErrorCode : Integer;
      
      FHostAddress : string;  //<host address
      FReadCommunity  : string;  //<'Read' community string
      FWriteCommunity : string;  //<'Write' community string
      SNMPSend: TSNMPSend;
      FipForwarding: string;  //<.1
      FipDefaultTTL: string;  //<.2
      FipInReceives: string;  //<.3
      FipInHdrErrors: string;  //<.4
      FipInAddrErrors: string;  //<.5
      FipForwDatagrams: string;  //<.6
      FipInUnknownProtos: string;  //<.7
      FipInDiscards: string;  //<.8
      FipInDelivers: string;  //<.9
      FipOutRequests: string;  //<.10
      FipOutDiscards: string;  //<.11
      FipOutNoRoutes: string;  //<.12
      FipReasmTimeout: string;  //<.13
      FipReasmReqds: string;  //<.14
      FipReasmOKs: string;  //<.15
      FipReasmFails: string;  //<.16
      FipFragOKs: string;  //<.17
      FipFragFails: string;  //<.18
      FipFragCreates: string;  //<.19
      
      { Tables
      .iso.org.dod.internet.mgmt.mib-2.ip.ipAddrTable
      .1.3.6.1.2.1.4.20
      
      .iso.org.dod.internet.mgmt.mib-2.ip.ipRouteTable
      .1.3.6.1.2.1.4.21
      
      .iso.org.dod.internet.mgmt.mib-2.ip.ipNetToMediaTable
      .1.3.6.1.2.1.4.22 }
      
      FipRoutingDiscards: string;  //<.23
      
    public

      ipAddrTable: TipAddrTable;  //<.20
      ipRouteTable: TipRouteTable;  //<.21
      ipNetToMediaTable: TipNetToMediaTable;  //<.22


      { Class Constructor }
    constructor Create;
    
    { Gets all possible snmp parameters for ip group. }
    function Get: boolean;

    procedure Bind(const BHostAddress, BReadCommunity, BWriteCommunity: string);

    function IpNetMaskForIfIndex(const ifIndex:string):string;

    { Class Destructor}
    destructor Destroy;

    //public

    published  

      property HostAddress: string read FHostAddress;
      property ReadCommunity: string read FReadCommunity;
      property WriteCommunity: string read FWriteCommunity;
      property ipForwarding: string read FipForwarding write FipForwarding;  //<.1
      property ipDefaultTTL: string read FipDefaultTTL;  //.2
      property ipInReceives: string read FipInReceives;  //.3
      property ipInHdrErrors: string read FipInHdrErrors;  //.4
      property ipInAddrErrors: string read FipInAddrErrors;  //.5
      property ipForwDatagrams: string read FipForwDatagrams;  //.6
      property ipInUnknownProtos: string read FipInUnknownProtos;  //.7
      property ipInDiscards: string read FipInDiscards;  //.8
      property ipInDelivers: string read FipInDelivers;  //.9
      property ipOutRequests: string read FipOutRequests;  //.10
      property ipOutDiscards: string read FipOutDiscards;  //.11
      property ipOutNoRoutes: string read FipOutNoRoutes;  //.12
      property ipReasmTimeout: string read FipReasmTimeout;  //.13
      property ipReasmReqds: string read FipReasmReqds;  //.14
      property ipReasmOKs: string read FipReasmOKs;  //.15
      property ipReasmFails: string read FipReasmFails;  //.16
      property ipFragOKs: string read FipFragOKs;  //.17
      property ipFragFails: string read FipFragFails;  //.18
      property ipFragCreates: string read FipFragCreates;  //.19

    //public

      property ipRoutingDiscards: string read FipRoutingDiscards;  //<.23
  end;


implementation


//--- ipAddrTable ---
const
  { .iso.org.dod.internet.mgmt.mib-2.ip.ipAddrTable.ipAddrEntry (.20.1) }
  oid_ipAddrEntry = '1.3.6.1.2.1.4.20.1';

constructor TipAddrTable.Create(AOwner: Tip);
begin
  if AOwner = nil then
    exit;
  inherited Create;
  Owner := AOwner;
  
  FCount := 0;
end;

function TipAddrTable.Get: boolean;
var
  ipAddrTableRows: TStringList;
  ipAddrEntryCols: TStringList;
  i : Integer;
begin
  ipAddrTableRows := TStringList.Create;
  ipAddrEntryCols := TStringList.Create;
  Result := SNMPGetTable(oid_ipAddrEntry, Owner.FReadCommunity, Owner.FHostAddress, ipAddrTableRows);

  if Result then begin
    FCount := ipAddrTableRows.Count;
    SetLength(ipAddrEntry,FCount);

    for i:= 0 to FCount-1 do begin
      ipAddrEntryCols.CommaText :=ipAddrTableRows.Strings[i];
      ipAddrEntry[i].ipAdEntAddr:= GetColFromTableRow(ipAddrEntryCols,0); //.1
      ipAddrEntry[i].ipAdEntIfIndex := GetColFromTableRow(ipAddrEntryCols,1);  //.2
      ipAddrEntry[i].ipAdEntNetMask := GetColFromTableRow(ipAddrEntryCols,2);  //.3
      ipAddrEntry[i].ipAdEntBcastAddr := GetColFromTableRow(ipAddrEntryCols,3);  //.4
      ipAddrEntry[i].ipAdEntReasmMaxSize := GetColFromTableRow(ipAddrEntryCols,4); //.5
    end;  // for i
  end else begin
    FCount := 0;
    SetLength(ipAddrEntry,0);
  end;  // if Result

  ipAddrTableRows.Destroy;
  ipAddrEntryCols.Destroy;
end;

function TipAddrTable.IpAddrForIfIndex(const ifIndex:string):string;
var
  i : integer;
begin
  for i:= 0 to Count-1 do begin
    if ipAddrEntry[i].ipAdEntIfIndex = ifIndex then begin
      Result:=ipAddrEntry[i].ipAdEntAddr;
      exit;
    end;
  end;
  Result := '-';
end;

destructor TipAddrTable.Destroy;
begin
  if Self <> nil then begin

    Free;
    Self := Nil;
  end;
end;

//--- ipRouteTable

const
  oid_ipRouteEntry = '1.3.6.1.2.1.4.21.1';

constructor TipRouteTable.Create(AOwner: Tip);
begin
  if AOwner = nil then
    exit;
  inherited Create;
  Owner := AOwner;

  FCount := 0;
end;

function TipRouteTable.Get: boolean;
var
  ipRouteTableRows: TStringList;
  ipRouteEntryCols: TStringList;
  i : Integer;
begin
  ipRouteTableRows := TStringList.Create;
  ipRouteEntryCols := TStringList.Create;
  
  Result := SNMPGetTable(oid_ipRouteEntry, Owner.FReadCommunity, Owner.FHostAddress, ipRouteTableRows);

  if Result then begin
    FCount := ipRouteTableRows.Count;
    SetLength(ipRouteEntry,FCount);
    for i:= 0 to FCount-1 do begin
      ipRouteEntryCols.CommaText :=ipRouteTableRows.Strings[i];
      ipRouteEntry[i].ipRouteDest := GetColFromTableRow(ipRouteEntryCols,0);  //.1
      ipRouteEntry[i].ipRouteIfIndex := GetColFromTableRow(ipRouteEntryCols,1);  //.2
      ipRouteEntry[i].ipRouteMetric1 := GetColFromTableRow(ipRouteEntryCols,2);  //.3
      ipRouteEntry[i].ipRouteMetric2 := GetColFromTableRow(ipRouteEntryCols,3);  //.4
      ipRouteEntry[i].ipRouteMetric3 := GetColFromTableRow(ipRouteEntryCols,4);  //.5
      ipRouteEntry[i].ipRouteMetric4 := GetColFromTableRow(ipRouteEntryCols,5);  //.6
      ipRouteEntry[i].ipRouteNextHop := GetColFromTableRow(ipRouteEntryCols,6);  //.7
      ipRouteEntry[i].ipRouteType := GetColFromTableRow(ipRouteEntryCols,7);  //.8
      ipRouteEntry[i].ipRouteProto := GetColFromTableRow(ipRouteEntryCols,8);  //.9
      ipRouteEntry[i].ipRouteAge := GetColFromTableRow(ipRouteEntryCols,9);  //.10
      ipRouteEntry[i].ipRouteMask := GetColFromTableRow(ipRouteEntryCols,10);  //.11
      ipRouteEntry[i].ipRouteMetric5 := GetColFromTableRow(ipRouteEntryCols,11);  //.12
      ipRouteEntry[i].ipRouteInfo := GetColFromTableRow(ipRouteEntryCols,12);  //.13
    end;  // for i
  end else begin
    FCount := 0;
    SetLength(ipRouteEntry,0);
  end;  // if Result
  
  ipRouteEntryCols.Destroy;
  ipRouteTableRows.Destroy;
end;

destructor TipRouteTable.Destroy;
begin
  if Self <> nil then begin

    Free;
    Self := Nil;
  end;
end;

// --- TipNetToMediaTable
const
  oid_ipNetToMediaEntry = '1.3.6.1.2.1.4.22.1';

constructor TipNetToMediaTable.Create(AOwner: Tip);
begin
  if AOwner = nil then
    exit;
  inherited Create;
  Owner := AOwner;

  FCount := 0;
end;

function TipNetToMediaTable.Get: boolean;
var
  ipNetToMediaTableRows: TStringList;
  ipNetToMediaEntryCols: TStringList;
  i : Integer;
begin
  ipNetToMediaTableRows := TStringList.Create;
  ipNetToMediaEntryCols := TStringList.Create;
  Result := SNMPGetTable(oid_ipNetToMediaEntry, Owner.FReadCommunity, Owner.FHostAddress, ipNetToMediaTableRows);

  if Result then begin
    FCount := ipNetToMediaTableRows.Count;
    SetLength(ipNetToMediaEntry,FCount);

    for i:= 0 to FCount-1 do begin
      ipNetToMediaEntryCols.CommaText :=ipNetToMediaTableRows.Strings[i];
      ipNetToMediaEntry[i].ipNetToMediaIfIndex := GetColFromTableRow(ipNetToMediaEntryCols,0); //.1
      ipNetToMediaEntry[i].ipNetToMediaPhysAddress := GetColFromTableRow(ipNetToMediaEntryCols,1);  //.2
      ipNetToMediaEntry[i].ipNetToMediaNetAddress := GetColFromTableRow(ipNetToMediaEntryCols,2);  //.3
      ipNetToMediaEntry[i].ipNetToMediaType := GetColFromTableRow(ipNetToMediaEntryCols,3);  //.4
    end;  // for i
  end else begin
    FCount := 0;
    SetLength(ipNetToMediaEntry,0);
  end;  // if Result

  ipNetToMediaTableRows.Destroy;
  ipNetToMediaEntryCols.Destroy;
end;

destructor TipNetToMediaTable.Destroy;
begin
  if Self <> nil then begin

    Free;
    Self := Nil;
  end;
end;


// .ip mib strings
const
  oid_ipForwarding      = '1.3.6.1.2.1.4.1.0';
  oid_ipDefaultTTL      = '1.3.6.1.2.1.4.2.0';
  oid_ipInReceives      = '1.3.6.1.2.1.4.3.0';
  oid_ipInHdrErrors     = '1.3.6.1.2.1.4.4.0';
  oid_ipInAddrErrors    = '1.3.6.1.2.1.4.5.0';
  oid_ipForwDatagrams   = '1.3.6.1.2.1.4.6.0';
  oid_ipInUnknownProtos = '1.3.6.1.2.1.4.7.0';
  oid_ipInDiscards      = '1.3.6.1.2.1.4.8.0';
  oid_ipInDelivers      = '1.3.6.1.2.1.4.9.0';
  oid_ipOutRequests     = '1.3.6.1.2.1.4.10.0';
  oid_ipOutDiscards     = '1.3.6.1.2.1.4.11.0';
  oid_ipOutNoRoutes     = '1.3.6.1.2.1.4.12.0';
  oid_ipReasmTimeout    = '1.3.6.1.2.1.4.13.0';
  oid_ipReasmReqds      = '1.3.6.1.2.1.4.14.0';
  oid_ipReasmOKs        = '1.3.6.1.2.1.4.15.0';
  oid_ipReasmFails      = '1.3.6.1.2.1.4.16.0';
  oid_ipFragOKs         = '1.3.6.1.2.1.4.17.0';
  oid_ipFragFails       = '1.3.6.1.2.1.4.18.0';
  oid_ipFragCreates     = '1.3.6.1.2.1.4.19.0';
//  oid_ipAddrTable       = '1.3.6.1.2.1.4.20.0'; // not accessible directly
//  oid_ipRouteTable      = '1.3.6.1.2.1.4.21.0'; // not accessible directly
//  oid_ipNetToMediaTable = '1.3.6.1.2.1.4.22.0'; // not accessible directly
  oid_ipRoutingDiscards = '1.3.6.1.2.1.4.23.0';
  
constructor Tip.Create;
begin
  inherited Create;
  
  FHostAddress := unknown_string;
  FReadCommunity := unknown_string;
  FWriteCommunity := unknown_string;

  FipForwarding := unknown_string;  //.1
  FipDefaultTTL := unknown_string;  //.2
  FipInReceives := unknown_string;  //.3
  FipInHdrErrors := unknown_string;  //.4
  FipInAddrErrors := unknown_string;  //.5
  FipForwDatagrams := unknown_string;  //.6
  FipInUnknownProtos := unknown_string;  //.7
  FipInDiscards := unknown_string;  //.8
  FipInDelivers := unknown_string;  //.9
  FipOutRequests := unknown_string;  //.10
  FipOutDiscards := unknown_string;  //.11
  FipOutNoRoutes := unknown_string;  //.12
  FipReasmTimeout := unknown_string;  //.13
  FipReasmReqds := unknown_string;  //.14
  FipReasmOKs := unknown_string;  //.15
  FipReasmFails := unknown_string;  //.16
  FipFragOKs := unknown_string;  //.17
  FipFragFails := unknown_string;  //.18
  FipFragCreates := unknown_string;  //.19

  FipRoutingDiscards := unknown_string;  //.23

  SNMPsend := TSNMPsend.Create;
  
  FErrorCode := FEC_no_error;
  
  ipAddrTable := TipAddrTable.Create(Self);
  ipRouteTable := TipRouteTable.Create(Self);
  ipNetToMediaTable := TipNetToMediaTable.Create(Self);

end;

function Tip.Get: Boolean;
begin
  if FErrorCode <> FEC_no_error then begin
    Result := False;
    exit;
  end;
  
  SNMPSend.Query.Clear();
  SNMPSend.Query.Community := FReadCommunity;
  SNMPSend.Query.PDUType := PDUGetRequest;

  SNMPSend.Query.MIBAdd(oid_ipForwarding, '', ASN1_NULL);  //.1
  SNMPSend.Query.MIBAdd(oid_ipDefaultTTL, '', ASN1_NULL);  //.2
  SNMPSend.Query.MIBAdd(oid_ipInReceives, '', ASN1_NULL);  //.3
  SNMPSend.Query.MIBAdd(oid_ipInHdrErrors, '', ASN1_NULL);  //.4
  SNMPSend.Query.MIBAdd(oid_ipInAddrErrors, '', ASN1_NULL);  //.5
  SNMPSend.Query.MIBAdd(oid_ipForwDatagrams, '', ASN1_NULL);  //.6
  SNMPSend.Query.MIBAdd(oid_ipInUnknownProtos, '', ASN1_NULL);  //.7
  SNMPSend.Query.MIBAdd(oid_ipInDiscards, '', ASN1_NULL);  //.8
  SNMPSend.Query.MIBAdd(oid_ipInDelivers, '', ASN1_NULL);  //.9
  SNMPSend.Query.MIBAdd(oid_ipOutRequests, '', ASN1_NULL);  //.10
  SNMPSend.Query.MIBAdd(oid_ipOutDiscards, '', ASN1_NULL);  //.11
  if not m0n0 then
    SNMPSend.Query.MIBAdd(oid_ipOutNoRoutes, '', ASN1_NULL);  //.12
  SNMPSend.Query.MIBAdd(oid_ipReasmTimeout, '', ASN1_NULL);  //.13
  SNMPSend.Query.MIBAdd(oid_ipReasmReqds, '', ASN1_NULL);  //.14
  SNMPSend.Query.MIBAdd(oid_ipReasmOKs, '', ASN1_NULL);  //.15
  SNMPSend.Query.MIBAdd(oid_ipReasmFails, '', ASN1_NULL);  //.16
  SNMPSend.Query.MIBAdd(oid_ipFragOKs, '', ASN1_NULL);  //.17
  SNMPSend.Query.MIBAdd(oid_ipFragFails, '', ASN1_NULL);  //.18
  SNMPSend.Query.MIBAdd(oid_ipFragCreates, '', ASN1_NULL);  //.19

  SNMPSend.Query.MIBAdd(oid_ipRoutingDiscards, '', ASN1_NULL);  //.23

  SNMPSend.TargetHost := FHostAddress;

  Result := SNMPSend.SendRequest();
  
  if Result then begin
    FipForwarding := SNMPSend.Reply.MIBGet(oid_ipForwarding);  //.1
    FipDefaultTTL := SNMPSend.Reply.MIBGet(oid_ipDefaultTTL);  //.2
    FipInReceives := SNMPSend.Reply.MIBGet(oid_ipInReceives);  //.3
    FipInHdrErrors := SNMPSend.Reply.MIBGet(oid_ipInHdrErrors);  //.4
    FipInAddrErrors := SNMPSend.Reply.MIBGet(oid_ipInAddrErrors);  //.5
    FipForwDatagrams := SNMPSend.Reply.MIBGet(oid_ipForwDatagrams);  //.6
    FipInUnknownProtos := SNMPSend.Reply.MIBGet(oid_ipInUnknownProtos);  //.7
    FipInDiscards := SNMPSend.Reply.MIBGet(oid_ipInDiscards);  //.8
    FipInDelivers := SNMPSend.Reply.MIBGet(oid_ipInDelivers);  //.9
    FipOutRequests := SNMPSend.Reply.MIBGet(oid_ipOutRequests);  //.10
    FipOutDiscards := SNMPSend.Reply.MIBGet(oid_ipOutDiscards);  //.11
    FipOutNoRoutes := SNMPSend.Reply.MIBGet(oid_ipOutNoRoutes);  //.12
    FipReasmTimeout := SNMPSend.Reply.MIBGet(oid_ipReasmTimeout);  //.13
    FipReasmReqds := SNMPSend.Reply.MIBGet(oid_ipReasmReqds);  //.14
    FipReasmOKs := SNMPSend.Reply.MIBGet(oid_ipReasmOKs);  //.15
    FipReasmFails := SNMPSend.Reply.MIBGet(oid_ipReasmFails);  //.16
    FipFragOKs := SNMPSend.Reply.MIBGet(oid_ipFragOKs);  //.17
    FipFragFails := SNMPSend.Reply.MIBGet(oid_ipFragFails);  //.18
    FipFragCreates := SNMPSend.Reply.MIBGet(oid_ipFragCreates);  //.19
    
    FipRoutingDiscards := SNMPSend.Reply.MIBGet(oid_ipRoutingDiscards);  //.23
    if not ipAddrTable.Get() then begin
      FErrorCode := FEC_get_table_error;
      exit;
    end;
    
    if not ipRouteTable.Get() then begin
      FErrorCode := FEC_get_table_error;
      exit;
    end;

    if not ipNetToMediaTable.Get() then begin
      FErrorCode := FEC_get_table_error;
      exit;
    end;

  end else begin
    FipForwarding := unknown_string;  //.1
    FipDefaultTTL := unknown_string;  //.2
    FipInReceives := unknown_string;  //.3
    FipInHdrErrors := unknown_string;  //.4
    FipInAddrErrors := unknown_string;  //.5
    FipForwDatagrams := unknown_string;  //.6
    FipInUnknownProtos := unknown_string;  //.7
    FipInDiscards := unknown_string;  //.8
    FipInDelivers := unknown_string;  //.9
    FipOutRequests := unknown_string;  //.10
    FipOutDiscards := unknown_string;  //.11
    FipOutNoRoutes := unknown_string;  //.12
    FipReasmTimeout := unknown_string;  //.13
    FipReasmReqds := unknown_string;  //.14
    FipReasmOKs := unknown_string;  //.15
    FipReasmFails := unknown_string;  //.16
    FipFragOKs := unknown_string;  //.17
    FipFragFails := unknown_string;  //.18
    FipFragCreates := unknown_string;  //.19
    
    FipRoutingDiscards := unknown_string;  //.23
    
    FErrorCode := FEC_get_error;
    
  end;  // if Result

end;

procedure Tip.Bind(const BHostAddress, BReadCommunity, BWriteCommunity: string);
begin
  FHostAddress := BHostAddress;
  FReadCommunity := BReadCommunity;
  FWriteCommunity := BWriteCommunity;
  FErrorCode := FEC_no_error;
  {
  if not Get then
      FErrorCode := FEC_init_error;
  }
end;

function Tip.IpNetMaskForIfIndex(const ifIndex:string):string;
var
  i : integer;
begin
  for i:= 0 to ipAddrTable.Count-1 do begin
    if ipAddrTable.ipAddrEntry[i].ipAdEntIfIndex = ifIndex then begin
      Result:=ipAddrTable.ipAddrEntry[i].ipAdEntNetMask;
      exit;
    end;
  end;
  Result := '-';
end;

destructor Tip.Destroy;
begin
  if Self <> nil then begin
    SNMPsend.Destroy;
    
    ipAddrTable.Destroy;
    ipRouteTable.Destroy;
    ipNetToMediaTable.Destroy;

    Free;
    Self := Nil;
  end;
end;


initialization


end.
