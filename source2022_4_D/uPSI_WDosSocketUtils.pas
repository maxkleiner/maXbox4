unit uPSI_WDosSocketUtils;
{
   RT DOS
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
  TPSImport_WDosSocketUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_WDosSocketUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_WDosSocketUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   WDosSocketUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_WDosSocketUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_WDosSocketUtils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('IpAny','LongWord').SetUInt( $00000000);
 CL.AddConstantN('IpLoopBack','LongWord').SetUInt( $7F000001);
 CL.AddConstantN('IpBroadcast','LongWord').SetUInt( $FFFFFFFF);
 CL.AddConstantN('IpNone','LongWord').SetUInt( $FFFFFFFF);
 CL.AddConstantN('PortAny','LongWord').SetUInt( $0000);
 CL.AddConstantN('SocketMaxConnections','LongInt').SetInt( 5);
  CL.AddTypeS('TIpAddr', 'LongWord');
  CL.AddTypeS('TIpRec', 'record IpB1 : byte; IpB2 : byte; IpB3 : byte; IpB4 : Byte; end');
 CL.AddDelphiFunction('Function HostToNetLong( HostLong : LongWord) : LongWord');
 CL.AddDelphiFunction('Function HostToNetShort( HostShort : Word) : Word');
 CL.AddDelphiFunction('Function NetToHostLong( NetLong : LongWord) : LongWord');
 CL.AddDelphiFunction('Function NetToHostShort( NetShort : Word) : Word');
 CL.AddDelphiFunction('Function StrToIp( Ip : string) : TIpAddr');
 CL.AddDelphiFunction('Function IpToStr( Ip : TIpAddr) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_WDosSocketUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@HostToNetLong, 'HostToNetLong', cdRegister);
 S.RegisterDelphiFunction(@HostToNetShort, 'HostToNetShort', cdRegister);
 S.RegisterDelphiFunction(@NetToHostLong, 'NetToHostLong', cdRegister);
 S.RegisterDelphiFunction(@NetToHostShort, 'NetToHostShort', cdRegister);
 S.RegisterDelphiFunction(@StrToIp, 'StrToIp', cdRegister);
 S.RegisterDelphiFunction(@IpToStr, 'IpToStr', cdRegister);
end;

 
 
{ TPSImport_WDosSocketUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WDosSocketUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WDosSocketUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WDosSocketUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_WDosSocketUtils(ri);
  RIRegister_WDosSocketUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
