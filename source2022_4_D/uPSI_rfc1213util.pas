unit uPSI_rfc1213util;
{
more of utils

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
  TPSImport_rfc1213util = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_rfc1213util(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_rfc1213util_Routines(S: TPSExec);

procedure Register;

implementation


uses
   SNMPsend
  ,rfc1213const
  ,rfc1213util
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_rfc1213util]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_rfc1213util(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('rfc1213version','String').SetString( '0.1.2');
 CL.AddDelphiFunction('Function UptimeToDays( const Uptime : string) : string');
 CL.AddDelphiFunction('Function getSNMP( const mib, community, host : string; var ErrNo : Integer) : string');
 CL.AddDelphiFunction('Function sysServicesString( const sysServicesStr : string) : string');
 CL.AddDelphiFunction('Function ipForwardingString( const ipForwarding : string) : string');
 CL.AddDelphiFunction('Function ipRouteTypeString( const ipRouteType : string) : string');
 CL.AddDelphiFunction('Function ipRouteProtoString( const ipRouteProto : string) : string');
 CL.AddDelphiFunction('Function ipNetToMediaTypeString( const ipNetToMediaType : string) : string');
 CL.AddDelphiFunction('Function GetColFromTableRow( const EntryCols : TStringList; index : integer) : string');
 CL.AddDelphiFunction('Function ifTypeString( ifTypeStringNo : string) : string');
 CL.AddDelphiFunction('Function ifStatusString( ifStatusStringNo : string) : string');
 CL.AddDelphiFunction('Function tcpRtoAlgorithmString( const tcpRtoAlgorithm : string) : string');
 CL.AddDelphiFunction('Function tcpConnStateString( const tcpConnState : string) : string');
 CL.AddDelphiFunction('Function egpNeighStateString( const egpNeighState : string) : string');
 CL.AddDelphiFunction('Function egpNeighModeString( const egpNeighMode : string) : string');
 CL.AddDelphiFunction('Function egpNeighEventTriggerString( const egpNeighEventTrigger : string) : string');
 CL.AddDelphiFunction('Function snmpEnableAuthenTrapsString( const snmpEnableAuthenTraps : string) : string');
 CL.AddDelphiFunction('Function FormatMac( const Mac : string) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_rfc1213util_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@UptimeToDays, 'UptimeToDays', cdRegister);
 S.RegisterDelphiFunction(@getSNMP, 'getSNMP', cdRegister);
 S.RegisterDelphiFunction(@sysServicesString, 'sysServicesString', cdRegister);
 S.RegisterDelphiFunction(@ipForwardingString, 'ipForwardingString', cdRegister);
 S.RegisterDelphiFunction(@ipRouteTypeString, 'ipRouteTypeString', cdRegister);
 S.RegisterDelphiFunction(@ipRouteProtoString, 'ipRouteProtoString', cdRegister);
 S.RegisterDelphiFunction(@ipNetToMediaTypeString, 'ipNetToMediaTypeString', cdRegister);
 S.RegisterDelphiFunction(@GetColFromTableRow, 'GetColFromTableRow', cdRegister);
 S.RegisterDelphiFunction(@ifTypeString, 'ifTypeString', cdRegister);
 S.RegisterDelphiFunction(@ifStatusString, 'ifStatusString', cdRegister);
 S.RegisterDelphiFunction(@tcpRtoAlgorithmString, 'tcpRtoAlgorithmString', cdRegister);
 S.RegisterDelphiFunction(@tcpConnStateString, 'tcpConnStateString', cdRegister);
 S.RegisterDelphiFunction(@egpNeighStateString, 'egpNeighStateString', cdRegister);
 S.RegisterDelphiFunction(@egpNeighModeString, 'egpNeighModeString', cdRegister);
 S.RegisterDelphiFunction(@egpNeighEventTriggerString, 'egpNeighEventTriggerString', cdRegister);
 S.RegisterDelphiFunction(@snmpEnableAuthenTrapsString, 'snmpEnableAuthenTrapsString', cdRegister);
 S.RegisterDelphiFunction(@FormatMac, 'FormatMac', cdRegister);
end;

 
 
{ TPSImport_rfc1213util }
(*----------------------------------------------------------------------------*)
procedure TPSImport_rfc1213util.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_rfc1213util(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_rfc1213util.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_rfc1213util_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
