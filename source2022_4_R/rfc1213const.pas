{ TODO : Change ifTypeString - should be from MIB, not hardcoded }

{ rfc1213 project - at the moment - http://yana.sourceforge.net/

  =====================
  unit rfc1213const.pas
  =====================

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

{ @abstract(RFC1213 related @bold(constants)) @br
  Shared constants for other units of the rfc1213 project.}
unit rfc1213const;

interface

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
        @row( @cell( 0.2.0)
              @cell( 2007-06-11)
              @cell( beta 1 release, some errors has been fixed,
                     missed strings were added))
  )
  version of the unit }
  version = '0.2.0';
  
const
  { Set to True when sending SNMP request to m0n0wall (http://m0n0.ch/wall).
    I do not know why, but some snmp requests disables all snmp replies
    from m0n0. }
  m0n0 : boolean = False;

const
  { ICMP default timeout in ms}
  ICMP_Default_Timeout      = 5000;

  { DEfault max hops for traceroute}
  ICMP_Default_Max_Hops     = 40;

  { Null ip, used as mask and to show error}
  Null_IP           = '0.0.0.0';

  { Unknown ip, could be also used to indicate problem }
  Unknown_IP        = '?.?.?.?';
  
  { Unknown interface index, reasm size, etc; any 6-digits WORD
    could also be used to indicate problem. }
  Unknown_Word_value  = '??????';
  
  { message for unknown string}
  Unknown_string = '<unknown>';
  
  { can not decode MAC address }
  Unknown_MAC = '??-??-??-??-??-??';

const
  { -------------------------------------------------
    sysServices Layers description, bitwise
    1  physical (e.g., repeaters)
    2  datalink/subnetwork (e.g., bridges)
    3  internet (e.g., IP gateways)
    4  end-to-end  (e.g., IP hosts)
    7  applications (e.g., mail relays)

    For systems including OSI protocols, layers 5 and
    6 may also be counted
    ------------------------------------------------- }

    {bit 1 - physical (e.g., repeaters)}
    ssPhysicalLayer = $01;

    {bit 2 - datalink/subnetwork (e.g., bridges)}
    ssDatalinkSubnetworkLayer = $02;

    {bit 3 - internet (e.g., IP gateways)}
    ssInternetLayer = $04;

    {bit 4 - end-to-end  (e.g., IP hosts)}
    ssEndToEndLayer = $08;

    {For systems including OSI protocols,
    layers 5 and 6 may also be counted }
    ssOSI1Layer = $10;

    {For systems including OSI protocols,
    layers 5 and 6 may also be counted }
    ssOSI2Layer = $20;

    {bit 7  applications (e.g., mail relays)}
    ssApplicationsLayer = $40;

    {bit 8 is not described in rfc1213,
    therefore we need ot indicate an error}
    ssUnknown = $80;

const
  {Indicates empty response after snmp request}
  empty_response = '<empty>';

  {Indicates no response after snmp request}
  no_reply_response = '<no snmp reply>';

  {Indicates that number was expected in response after snmp request}
  not_a_number  = '- not a number';

  {Indicates that number received in response after snmp request
  is not in expected range}
  not_in_range = '- not in range';

const
  Question_Sign = '?';  // question sign may indicate "unknown"
  
const
  // error codes
  
  no_snmp_reply = -1; //<error code to be returned if no smtp reply is received
  FEC_no_snmp         = no_snmp_reply;  //< no SNMP
  
  FEC_no_error        = 0;  //< no error
  FEC_init_error      = 1;  //< initialization error
  FEC_get_error       = 2;  //< get error
  FEC_get_table_error = 3;  //< can not get table
  
// --- ip group
const
  ipForwardingMax = 2;
  sipForwardingString: array[1..ipForwardingMax] of string[18]=
  ( 'forwarding(1)',       // -- acting as a gateway
    'not-forwarding(2)');  // -- NOT acting as a gateway
    
  { -- Maximal value of integer "ipRouteType" }
  ipRouteTypeMax = 4;

  { -- ipRouteType strings }
  sIpRouteTypeString: array[1..ipRouteTypeMax] of string[15] =
  ( 'other(1)',    // -- none of the following
    'invalid(2)',  // -- an invalidated route
    'direct(3)',   // -- route to directly connected (sub-)network
    'indirect(4)'  // -- route to a non-local host/network/sub-network
    );

  { -- Maximal value of integer "ipRouteProto" }
  ipRouteProtoMax = 18;

  { -- ipRouteProto strings }
  sipRouteProtoString: array[1..ipRouteProtoMax] of string[15] =
  ( 'other(1)',   // none of the following
    'local(2)',   // non-protocol information, e.g., manually configured entries
    'netmgmt(3)', // set via a network management protocol
    'icmp(4)',    // obtained via ICMP, e.g., Redirect
                
    (* -- the values from 5 to 14 are all gateway routing protocols *)
    'egp(5)',         // Exterior Gateway Protocol
    'ggp(6)',         // Gateway-Gateway Protocol
    'hello(7)',       // HELLO routing protocol (FuzzBall HelloSpeak)
    'rip(8)',         // Routing Information Protocol (Berkeley RIP or RIP-II)
    'is-is(9)',       // Dual IS-IS
    'es-is(10)',      // ISO 9542
    'ciscoIgrp(11)',  // Cisco IGRP
    'bbnSpfIgp(12)',  // BBN SPF IGP
    'ospf(13)',       // Open Shortest Path First routing protocol
    'bgp(14)',        // Border Gateway Protocol

    (* -- taken from uIpHelper unit *)
    'bootp(15)',      // Bootstrap Protocol
    'ntAutoStat(16)', // Routes that were originally generated by a routing
                      // protocol, but which are now static
    'Static(17)',     // Routes that were added from the routing user
                      // interface, or by "routemon ip add"
    'nonDOD(18)'      // Identical to NET_STATIC, except these routes do not
                      // cause Dial On Demand (DOD)
    );

  { - Maximal value of integer "ipNetToMediaType" }
  ipNetToMediaTypeMax = 4;

  { - ipNetToMediaType strings }
  sipNetToMediaTypeString: array[1..ipNetToMediaTypeMax] of string[15] =
  ( 'other(1)',  // -- none of the following
    'invalid(2)',  // -- an invalidated mapping
    'dynamic(3)',
    'static(4)');
    
// --- ip group end

const
  { Maximnum amount of interface types from rfc1213 plus additional information
  from http://www.iana.org/assignments/ianaiftype-mib }
  MaxIfType = 242;

  { Interface types textual description from rfc1213 plus additional
    information, see http://www.iana.org/assignments/ianaiftype-mib for
    details. }
  ifTypeStr : array[1..MaxIfType] of string[36] = (
    'other (1)',
    'regular1822 (2)',
    'hdh1822 (3)',
    'ddnX25 (4)',
    'rfc877x25 (5)',
    'ethernetCsmacd (6)',
    'iso88023Csmacd (7)',
    'iso88024TokenBus (8)',
    'iso88025TokenRing (9)',
    'iso88026Man (10)',
    'starLan (11)',
    'proteon10Mbit (12)',
    'proteon80Mbit (13)',
    'hyperchannel( 14)',
    'fddi (15)',
    'lapb (16)',
    'sdlc (17)',
    'ds1 (18)',
    'e1 (19)',
    'basicISDN (20)',
    'primaryISDN (21)',
    'propPointToPointSerial (22)',
    'ppp (23)',
    'softwareLoopback (24)',
    'eon (25)',
    'ethernet3Mbit (26)',
    'nsip (27)',
    'slip (28)',
    'ultra (29)',
    'ds3 (30)',
    'sip (31)',
    'frameRelay (32)',
    'rs232 (33)',
    'para (34)',
    'arcnet (35)',
    'arcnetPlus( 36)',
    'atm (37)',
    'miox25 (38)',
    'sonet (39)',
    'x25ple (40)',
    'iso88022llc (41)',
    'localTalk (42)',
    'smdsDxi (43)',
    'frameRelayService (44)',
    'v35 (45)',
    'hssi (46)',
    'hippi (47)',
    'modem (48)',
    'aal5 (49)',
    'sonetPath (50)',
    'sonetVT (51)',
    'smdsIcip (52)',
    'propVirtual (53)',
    'propMultiplexor (54)',
    'ieee80212 (55)',
    'fibreChannel (56)',
    'hippiInterface (57)',
    'frameRelayInterconnect (58)',
    'aflane8023 (59)',
    'aflane8025 (60)',
    'cctEmul (61)',
    'fastEther (62)',
    'isdn (63)',
    'v11 (64)',
    'v36 (65)',
    'g703at64k (66)',
    'g703at2mb (67)',
    'qllc (68)',
    'fastEtherFX (69)',
    'channel (70)',
    'ieee80211 (71)',
    'ibm370parChan (72)',
    'escon (73)',
    'dlsw (74)',
    'isdns (75)',
    'isdnu (76)',
    'lapd (77)',
    'ipSwitch (78)',
    'rsrb (79)',
    'atmLogical (80)',
    'ds0 (81)',
    'ds0Bundle (82)',
    'bsc (83)',
    'async (84)',
    'cnr (85)',
    'iso88025Dtr (86)',
    'eplrs (87)',
    'arap (88)',
    'propCnls (89)',
    'hostPad (90)',
    'termPad (91)',
    'frameRelayMPI (92)',
    'x213 (93)',
    'adsl (94)',
    'radsl (95)',
    'sdsl (96)',
    'vdsl (97)',
    'iso88025CRFPInt (98)',
    'myrinet (99)',
    'voiceEM (100)',
    'voiceFXO (101)',
    'voiceFXS (102)',
    'voiceEncap (103)',
    'voiceOverIp (104)',
    'atmDxi (105)',
    'atmFuni (106)',
    'atmIma (107)',
    'pppMultilinkBundle (108)',
    'ipOverCdlc (109)',
    'ipOverClaw (110)',
    'stackToStack (111)',
    'virtualIpAddress (112)',
    'mpc (113)',
    'ipOverAtm (114)',
    'iso88025Fiber (115)',
    'tdlc (116)',
    'gigabitEthernet (117)',
    'hdlc (118)',
    'lapf (119)',
    'v37 (120)',
    'x25mlp (121)',
    'x25huntGroup (122)',
    'trasnpHdlc (123)',
    'interleave (124)',
    'fast (125)',
    'ip (126)',
    'docsCableMaclayer (127)',
    'docsCableDownstream (128)',
    'docsCableUpstream (129)',
    'a12MppSwitch (130)',
    'tunnel (131)',
    'coffee (132)',
    'ces (133)',
    'atmSubInterface (134)',
    'l2vlan (135)',
    'l3ipvlan (136)',
    'l3ipxvlan (137)',
    'digitalPowerline (138)',
    'mediaMailOverIp (139)',
    'dtm (140)',
    'dcn (141)',
    'ipForward (142)',
    'msdsl (143)',
    'ieee1394 (144)',
    'if-gsn (145)',
    'dvbRccMacLayer (146)',
    'dvbRccDownstream (147)',
    'dvbRccUpstream (148)',
    'atmVirtual (149)',
    'mplsTunnel (150)',
    'srp (151)',
    'voiceOverAtm (152)',
    'voiceOverFrameRelay (153)',
    'idsl (154)',
    'compositeLink (155)',
    'ss7SigLink (156)',
    'propWirelessP2P (157)',
    'frForward (158)',
    'rfc1483 (159)',
    'usb (160)',
    'ieee8023adLag (161)',
    'bgppolicyaccounting (162)',
    'frf16MfrBundle (163)',
    'h323Gatekeeper (164)',
    'h323Proxy (165)',
    'mpls (166)',
    'mfSigLink (167)',
    'hdsl2 (168)',
    'shdsl (169)',
    'ds1FDL (170)',
    'pos (171)',
    'dvbAsiIn (172)',
    'dvbAsiOut (173)',
    'plc (174)',
    'nfas (175)',
    'tr008 (176)',
    'gr303RDT (177)',
    'gr303IDT (178)',
    'isup (179)',
    'propDocsWirelessMaclayer (180)',
    'propDocsWirelessDownstream (181)',
    'propDocsWirelessUpstream (182)',
    'hiperlan2 (183)',
    'propBWAp2Mp (184)',
    'sonetOverheadChannel (185)',
    'digitalWrapperOverheadChannel (186)',
    'aal2 (187)',
    'radioMAC (188)',
    'atmRadio (189)',
    'imt (190)',
    'mvl (191)',
    'reachDSL (192)',
    'frDlciEndPt (193)',
    'atmVciEndPt (194)',
    'opticalChannel (195)',
    'opticalTransport (196)',
    'propAtm (197)',
    'voiceOverCable (198)',
    'infiniband (199)',
    'teLink (200)',
    'q2931 (201)',
    'virtualTg (202)',
    'sipTg (203)',
    'sipSig (204)',
    'docsCableUpstreamChannel (205)',
    'econet (206)',
    'pon155 (207)',
    'pon622 (208)',
    'bridge (209)',
    'linegroup (210)',
    'voiceEMFGD (211)',
    'voiceFGDEANA (212)',
    'voiceDID (213)',
    'mpegTransport (214)',
    'sixToFour (215)',
    'gtp (216)',
    'pdnEtherLoop1 (217)',
    'pdnEtherLoop2 (218)',
    'opticalChannelGroup (219)',
    'homepna (220)',
    'gfp (221)',
    'ciscoISLvlan (222)',
    'actelisMetaLOOP (223)',
    'fcipLink (224)',
    'rpr (225)',
    'qam (226)',
    'lmp (227)',
    'cblVectaStar (228)',
    'docsCableMCmtsDownstream (229)',
    'adsl2 (230)',
    'macSecControlledIF (231)',
    'macSecUncontrolledIF (232)',
    'aviciOpticalEther (233)',
    'atmbond (234)',
    'voiceFGDOS (235)',
    'mocaVersion1 (236)',
    'ieee80216WMAN (237)',
    'adsl2plus (238)',
    'dvbRcsMacLayer (239)',
    'dvbTdm (240)',
    'dvbRcsTdma (241)',
    'x86Laps (242)'
    );


//--rfc1213tcp
const
  { -- Maximal value of integer "tcpRtoAlgorithm" }
  tcpRtoAlgorithmMax = 4;

  { -- tcpRtoAlgorithm strings }
  sTcpRtoAlgorithmString : array[1..tcpRtoAlgorithmMax] of string[15] =
  ( 'other(1)',      // -- none of the following
    'constant(2)',   // -- a constant rto
    'rsre(3)',       // -- MIL-STD-1778, Appendix B
    'vanj(4)');      // -- Van Jacobson's algorithm [10]

const
  { -- Maximal value of integer "tcpConnState" }
  tcpConnStateMax = 12;

  { -- tcpConnState strings }
  stcpConnStateString : array[1..tcpConnStateMax] of string[15] =
  ( 'closed(1)',
    'listen(2)',
    'synSent(3)',
    'synReceived(4)',
    'established(5)',
    'finWait1(6)',
    'finWait2(7)',
    'closeWait(8)',
    'lastAck(9)',
    'closing(10)',
    'timeWait(11)',
    'deleteTCB(12)');

//--rfc1213tcp end

//--rfc1213egp
const
  { Maximum possible value of integer "egpNeighState". }
  egpNeighStateMax = 5;

  { String messages for "egpNeighState" }
  segpNeighStateString : array[1..egpNeighStateMax] of string[15] =
  ( 'idle(1)',
    'acquisition(2)',
    'down(3)',
    'up(4)',
    'cease(5)');

  { Maximum possible value of integer "egpNeighMode". }
  egpNeighModeMax = 2;

  { String messages for "egpNeighMode". }
  segpNeighModeString : array[1..egpNeighModeMax] of string[10] =
  ( 'active(1)',
    'passive(2)');

  { Maximum possible value of integer "egpNeighEventTrigger". }
  egpNeighEventTriggerMax = 2;

  { String messages for "egpNeighEventTrigger". }
  segpNeighEventTriggerString: array[1..egpNeighEventTriggerMax] of string[8] =
  ( 'start(1)',
    'stop(2)');

//--rfc1213egp end


//--rfc1213snmp
const
  { Maximum value of integer "snmpEnableAuthenTraps". }
  snmpEnableAuthenTrapsMax = 2;

  { Textual description of snmpEnableAuthenTraps. }
  ssnmpEnableAuthenTrapsString : array[1..snmpEnableAuthenTrapsMax] of string[15] =
  ( 'enabled(1)',
    'disabled(2)');

//--rfc1213snmp end


implementation

end.
