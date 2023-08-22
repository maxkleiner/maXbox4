unit uPSI_IdRawHeaders;
{
    just headers
}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_IdRawHeaders = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IdRawHeaders(CL: TPSPascalCompiler);

{ run-time registration functions }

procedure Register;

implementation


uses
   IdStack
  ,IdRawHeaders
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdRawHeaders]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IdRawHeaders(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIdNetTime', 'longword');
 CL.AddConstantN('Id_ARP_HSIZE','LongWord').SetUInt( $1C);
 CL.AddConstantN('Id_DNS_HSIZE','LongWord').SetUInt( $0C);
 CL.AddConstantN('Id_ETH_HSIZE','LongWord').SetUInt( $0E);
 CL.AddConstantN('Id_ICMP_HSIZE','LongWord').SetUInt( $04);
 CL.AddConstantN('Id_ICMP_ECHO_HSIZE','LongWord').SetUInt( $08);
 CL.AddConstantN('Id_ICMP_MASK_HSIZE','LongWord').SetUInt( $0C);
 CL.AddConstantN('Id_ICMP_UNREACH_HSIZE','LongWord').SetUInt( $08);
 CL.AddConstantN('Id_ICMP_TIMEXCEED_HSIZE','LongWord').SetUInt( $08);
 CL.AddConstantN('Id_ICMP_REDIRECT_HSIZE','LongWord').SetUInt( $08);
 CL.AddConstantN('Id_ICMP_TS_HSIZE','LongWord').SetUInt( $14);
 CL.AddConstantN('Id_IGMP_HSIZE','LongWord').SetUInt( $08);
 CL.AddConstantN('Id_IP_HSIZE','LongWord').SetUInt( $14);
 CL.AddConstantN('Id_RIP_HSIZE','LongWord').SetUInt( $18);
 CL.AddConstantN('Id_TCP_HSIZE','LongWord').SetUInt( $14);
 CL.AddConstantN('Id_UDP_HSIZE','LongWord').SetUInt( $08);
 CL.AddConstantN('Id_MAX_IPOPTLEN','LongInt').SetInt( 40);
 CL.AddConstantN('Id_IP_RF','LongWord').SetUInt( $8000);
 CL.AddConstantN('Id_IP_DF','LongWord').SetUInt( $4000);
 CL.AddConstantN('Id_IP_MF','LongWord').SetUInt( $2000);
 CL.AddConstantN('Id_IP_OFFMASK','LongWord').SetUInt( $1FFF);
  //CL.AddTypeS('PIdIpHdr', '^TIdIpHdr // will not work');
  CL.AddTypeS('TIdIpHdr', 'record ip_verlen : byte; ip_tos : byte; ip_len : wor'
   +'d; ip_id : word; ip_off : word; ip_ttl : byte; ip_p : byte; ip_sum : word;'
   +' ip_src : TIdInAddr; ip_dst : TIdInAddr; ip_options : longword; end');
 CL.AddConstantN('Id_IP_MAXPACKET','LongInt').SetInt( 65535);
 CL.AddConstantN('Id_TCP_FIN','LongWord').SetUInt( $01);
 CL.AddConstantN('Id_TCP_SYN','LongWord').SetUInt( $02);
 CL.AddConstantN('Id_TCP_RST','LongWord').SetUInt( $04);
 CL.AddConstantN('Id_TCP_PUSH','LongWord').SetUInt( $08);
 CL.AddConstantN('Id_TCP_ACK','LongWord').SetUInt( $10);
 CL.AddConstantN('Id_TCP_URG','LongWord').SetUInt( $20);
 // CL.AddTypeS('PIdTcpHdr', '^TIdTcpHdr // will not work');
  CL.AddTypeS('TIdTcpHdr', 'record tcp_sport : word; tcp_dport : word; tcp_seq '
   +': longword; tcp_ack : longword; tcp_x2off : byte; tcp_flags : byte; tcp_wi'
   +'n : word; tcp_sum : word; tcp_urp : word; end');
 // CL.AddTypeS('PIdUdpHdr', '^TIdUdpHdr // will not work');
  CL.AddTypeS('TIdUdpHdr', 'record udp_sport : word; udp_dport : word; udp_ulen'
   +' : word; udp_sum : word; end');
  CL.AddTypeS('TIdEtherAddr', 'record ether_addr_octet: array [0..5] of byte; end');

   {TIdEtherAddr = packed record
    ether_addr_octet: array [0..Id_ETHER_ADDR_LEN-1] of byte;}

 CL.AddConstantN('Id_ICMP_ECHOREPLY','LongInt').SetInt( 0);
 CL.AddConstantN('Id_ICMP_UNREACH','LongInt').SetInt( 3);
 CL.AddConstantN('Id_ICMP_SOURCEQUENCH','LongInt').SetInt( 4);
 CL.AddConstantN('Id_ICMP_REDIRECT','LongInt').SetInt( 5);
 CL.AddConstantN('Id_ICMP_ECHO','LongInt').SetInt( 8);
 CL.AddConstantN('Id_ICMP_ROUTERADVERT','LongInt').SetInt( 9);
 CL.AddConstantN('Id_ICMP_ROUTERSOLICIT','LongInt').SetInt( 10);
 CL.AddConstantN('Id_ICMP_TIMXCEED','LongInt').SetInt( 11);
 CL.AddConstantN('Id_ICMP_PARAMPROB','LongInt').SetInt( 12);
 CL.AddConstantN('Id_ICMP_TSTAMP','LongInt').SetInt( 13);
 CL.AddConstantN('Id_ICMP_TSTAMPREPLY','LongInt').SetInt( 14);
 CL.AddConstantN('Id_ICMP_IREQ','LongInt').SetInt( 15);
 CL.AddConstantN('Id_ICMP_IREQREPLY','LongInt').SetInt( 16);
 CL.AddConstantN('Id_ICMP_MASKREQ','LongInt').SetInt( 17);
 CL.AddConstantN('Id_ICMP_MASKREPLY','LongInt').SetInt( 18);
 CL.AddConstantN('Id_ICMP_UNREACH_NET','LongInt').SetInt( 0);
 CL.AddConstantN('Id_ICMP_UNREACH_HOST','LongInt').SetInt( 1);
 CL.AddConstantN('Id_ICMP_UNREACH_PROTOCOL','LongInt').SetInt( 2);
 CL.AddConstantN('Id_ICMP_UNREACH_PORT','LongInt').SetInt( 3);
 CL.AddConstantN('Id_ICMP_UNREACH_NEEDFRAG','LongInt').SetInt( 4);
 CL.AddConstantN('Id_ICMP_UNREACH_SRCFAIL','LongInt').SetInt( 5);
 CL.AddConstantN('Id_ICMP_UNREACH_NET_UNKNOWN','LongInt').SetInt( 6);
 CL.AddConstantN('Id_ICMP_UNREACH_HOST_UNKNOWN','LongInt').SetInt( 7);
 CL.AddConstantN('Id_ICMP_UNREACH_ISOLATED','LongInt').SetInt( 8);
 CL.AddConstantN('Id_ICMP_UNREACH_NET_PROHIB','LongInt').SetInt( 9);
 CL.AddConstantN('Id_ICMP_UNREACH_HOST_PROHIB','LongInt').SetInt( 10);
 CL.AddConstantN('Id_ICMP_UNREACH_TOSNET','LongInt').SetInt( 11);
 CL.AddConstantN('Id_ICMP_UNREACH_TOSHOST','LongInt').SetInt( 12);
 CL.AddConstantN('Id_ICMP_UNREACH_FILTER_PROHIB','LongInt').SetInt( 13);
 CL.AddConstantN('Id_ICMP_UNREACH_HOST_PRECEDENCE','LongInt').SetInt( 14);
 CL.AddConstantN('Id_ICMP_UNREACH_PRECEDENCE_CUTOFF','LongInt').SetInt( 15);
 CL.AddConstantN('Id_ICMP_REDIRECT_NET','LongInt').SetInt( 0);
 CL.AddConstantN('Id_ICMP_REDIRECT_HOST','LongInt').SetInt( 1);
 CL.AddConstantN('Id_ICMP_REDIRECT_TOSNET','LongInt').SetInt( 2);
 CL.AddConstantN('Id_ICMP_REDIRECT_TOSHOST','LongInt').SetInt( 3);
 CL.AddConstantN('Id_ICMP_TIMXCEED_INTRANS','LongInt').SetInt( 0);
 CL.AddConstantN('Id_ICMP_TIMXCEED_REASS','LongInt').SetInt( 1);
 CL.AddConstantN('Id_ICMP_PARAMPROB_OPTABSENT','LongInt').SetInt( 1);
 // CL.AddTypeS('PIdIcmpEcho', '^TIdIcmpEcho // will not work');
  CL.AddTypeS('TIdIcmpEcho', 'record id : word; seq : word; end');
  //CL.AddTypeS('PIdIcmpFrag', '^TIdIcmpFrag // will not work');
  CL.AddTypeS('TIdIcmpFrag', 'record pad : word; mtu : word; end');
  //CL.AddTypeS('PIdIcmpTs', '^TIdIcmpTs // will not work');
  CL.AddTypeS('TIdIcmpTs', 'record otime : TIdNetTime; rtime : TIdNetTime; ttime : TIdNetTime; end');
 CL.AddConstantN('Id_IGMP_MEMBERSHIP_QUERY','LongWord').SetUInt( $11);
 CL.AddConstantN('Id_IGMP_V1_MEMBERSHIP_REPORT','LongWord').SetUInt( $12);
 CL.AddConstantN('Id_IGMP_V2_MEMBERSHIP_REPORT','LongWord').SetUInt( $16);
 CL.AddConstantN('Id_IGMP_LEAVE_GROUP','LongWord').SetUInt( $17);
 // CL.AddTypeS('PIdIgmpHdr', '^TIdIgmpHdr // will not work');
  CL.AddTypeS('TIdIgmpHdr', 'record igmp_type : byte; igmp_code : byte; igmp_su'
   +'m : word; igmp_group : TIdInAddr; end');
 CL.AddConstantN('Id_ETHER_ADDR_LEN','LongInt').SetInt( 6);
 CL.AddConstantN('Id_ETHERTYPE_PUP','LongWord').SetUInt( $0200);
 CL.AddConstantN('Id_ETHERTYPE_IP','LongWord').SetUInt( $0800);
 CL.AddConstantN('Id_ETHERTYPE_ARP','LongWord').SetUInt( $0806);
 CL.AddConstantN('Id_ETHERTYPE_REVARP','LongWord').SetUInt( $8035);
 CL.AddConstantN('Id_ETHERTYPE_VLAN','LongWord').SetUInt( $8100);
 CL.AddConstantN('Id_ETHERTYPE_LOOPBACK','LongWord').SetUInt( $9000);
  //CL.AddTypeS('PIdEthernetHdr', '^TIdEthernetHdr // will not work');
  CL.AddTypeS('TIdEthernetHdr', 'record ether_dhost : TIdEtherAddr; ether_shost'
   +' : TIdEtherAddr; ether_type : word; end');
 CL.AddConstantN('Id_ARPHRD_ETHER','LongInt').SetInt( 1);
 CL.AddConstantN('Id_ARPOP_REQUEST','LongInt').SetInt( 1);
 CL.AddConstantN('Id_ARPOP_REPLY','LongInt').SetInt( 2);
 CL.AddConstantN('Id_ARPOP_REVREQUEST','LongInt').SetInt( 3);
 CL.AddConstantN('Id_ARPOP_REVREPLY','LongInt').SetInt( 4);
 CL.AddConstantN('Id_ARPOP_INVREQUEST','LongInt').SetInt( 8);
 CL.AddConstantN('Id_ARPOP_INVREPLY','LongInt').SetInt( 9);
  //CL.AddTypeS('PIdArpHdr', '^TIdArpHdr // will not work');
  CL.AddTypeS('TIdArpHdr', 'record arp_hrd : word; arp_pro : word; arp_hln : by'
   +'te; arp_pln : byte; arp_op : word; arp_sha : TIdEtherAddr; arp_spa : TIdIn'
   +'Addr; arp_tha : TIdEtherAddr; arp_tpa : TIdInAddr; end');
  //CL.AddTypeS('PIdDnsHdr', '^TIdDnsHdr // will not work');
  CL.AddTypeS('TIdDnsHdr', 'record dns_id : word; dns_flags : word; dns_num_q :'
   +' word; dns_num_answ_rr : word; dns_num_auth_rr : word; dns_num_addi_rr : word; end');
 CL.AddConstantN('Id_RIPCMD_REQUEST','LongInt').SetInt( 1);
 CL.AddConstantN('Id_RIPCMD_RESPONSE','LongInt').SetInt( 2);
 CL.AddConstantN('Id_RIPCMD_TRACEON','LongInt').SetInt( 3);
 CL.AddConstantN('Id_RIPCMD_TRACEOFF','LongInt').SetInt( 4);
 CL.AddConstantN('Id_RIPCMD_POLL','LongInt').SetInt( 5);
 CL.AddConstantN('Id_RIPCMD_POLLENTRY','LongInt').SetInt( 6);
 CL.AddConstantN('Id_RIPCMD_MAX','LongInt').SetInt( 7);
 CL.AddConstantN('Id_RIPVER_0','LongInt').SetInt( 0);
 CL.AddConstantN('Id_RIPVER_1','LongInt').SetInt( 1);
 CL.AddConstantN('Id_RIPVER_2','LongInt').SetInt( 2);
 // CL.AddTypeS('PIdRipHdr', '^TIdRipHdr // will not work');
  CL.AddTypeS('TIdRipHdr', 'record rip_cmd : byte; rip_ver : byte; rip_rd : wor'
   +'d; rip_af : word; rip_rt : word; rip_addr : longword; rip_mask : longword;'
   +' rip_next_hop : longword; rip_metric : longword; end');
end;

(* === run-time registration functions === *)
 
 
{ TPSImport_IdRawHeaders }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdRawHeaders.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdRawHeaders(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdRawHeaders.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_IdRawHeaders(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
