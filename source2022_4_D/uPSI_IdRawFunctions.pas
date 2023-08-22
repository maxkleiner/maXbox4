unit uPSI_IdRawFunctions;
{
   abuffer: string;    -->stringbuffer
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
  TPSImport_IdRawFunctions = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IdRawFunctions(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IdRawFunctions_Routines(S: TPSExec);

procedure Register;

implementation


uses
   IdStack
  ,IdRawHeaders
  ,IdRawFunctions
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdRawFunctions]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IdRawFunctions(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function IdRawBuildArp( AHwAddressFormat, AProtocolFormat : word; AHwAddressLen, AProtocolLen : byte; AnOpType : word; ASenderHw : TIdEtherAddr; ASenderPr : TIdInAddr; ATargetHw : TIdEtherAddr; ATargetPr : TIdInAddr;'+
  'const APayload, APayloadSize : integer; var ABuffer: string) : boolean');
 CL.AddDelphiFunction('Function IdRawBuildDns( AnId, AFlags, ANumQuestions, ANumAnswerRecs, ANumAuthRecs, ANumAddRecs : word; const APayload, APayloadSize : integer; var ABuffer: string) : boolean');
 CL.AddDelphiFunction('Function IdRawBuildEthernet( ADest, ASource : TIdEtherAddr; AType : word; const APayload, APayloadSize : integer; var ABuffer: string) : boolean');
 CL.AddDelphiFunction('Function IdRawBuildIcmpEcho( AType, ACode : byte; AnId, ASeq : word; const APayload, APayloadSize : integer; var ABuffer: string) : boolean');
 CL.AddDelphiFunction('Function IdRawBuildIcmpMask( AType, ACode : byte; AnId, ASeq : word; AMask : longword; const APayload, APayloadSize : integer; var ABuffer: string) : boolean');
 CL.AddDelphiFunction('Function IdRawBuildIcmpRedirect( AType, ACode : byte; AGateway : TIdInAddr; AnOrigLen : word; AnOrigTos : byte; AnOrigId, AnOrigFrag : word; AnOrigTtl, AnOrigProtocol : byte; AnOrigSource, AnOrigDest : TIdInAddr;'+
 ' const AnOrigPayload, APayloadSize : integer; var ABuffer: string) : boolean');
 CL.AddDelphiFunction('Function IdRawBuildIcmpTimeExceed( AType, ACode : byte; AnOrigLen : word; AnOrigTos : byte; AnOrigId, AnOrigFrag : word; AnOrigTtl : byte; AnOrigProtocol : byte; AnOrigSource, AnOrigDest : TIdInAddr; '+
 'const AnOrigPayload, APayloadSize : integer; var ABuffer: string) : boolean');
 CL.AddDelphiFunction('Function IdRawBuildIcmpTimestamp( AType, ACode : byte; AnId, ASeq : word; AnOtime, AnRtime, ATtime : TIdNetTime; const APayload, APayloadSize : integer; var ABuffer: string) : boolean');
 CL.AddDelphiFunction('Function IdRawBuildIcmpUnreach( AType, ACode : byte; AnOrigLen : word; AnOrigTos : byte; AnOrigId, AnOrigFrag : word; AnOrigTtl, AnOrigProtocol : byte; AnOrigSource, AnOrigDest : TIdInAddr;'
 +' const AnOrigPayload, APayloadSize : integer; var ABuffer: string) : boolean');
 CL.AddDelphiFunction('Function IdRawBuildIgmp( AType, ACode : byte; AnIp : TIdInAddr; const APayload, APayloadSize : integer; var ABuffer: string) : boolean');
 CL.AddDelphiFunction('Function IdRawBuildIp( ALen : word; ATos : byte; AnId, AFrag : word; ATtl, AProtocol : byte; ASource, ADest : TIdInAddr; const APayload, APayloadSize : integer; var ABuffer: string) : boolean');
 CL.AddDelphiFunction('Function IdRawBuildRip( ACommand, AVersion : byte; ARoutingDomain, AnAddressFamily, ARoutingTag : word; AnAddr, AMask, ANextHop, AMetric : longword; const APayload, APayloadSize: integer; var ABuffer: string): boolean');
 CL.AddDelphiFunction('Function IdRawBuildTcp( ASourcePort, ADestPort : word; ASeq, AnAck : longword; AControl : byte; AWindowSize, AnUrgent : word; const APayload, APayloadSize : integer; var ABuffer: string) : boolean');
 CL.AddDelphiFunction('Function IdRawBuildUdp( ASourcePort, ADestPort : word; const APayload, APayloadSize : integer; var ABuffer: string) : boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_IdRawFunctions_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IdRawBuildArp, 'IdRawBuildArp', cdRegister);
 S.RegisterDelphiFunction(@IdRawBuildDns, 'IdRawBuildDns', cdRegister);
 S.RegisterDelphiFunction(@IdRawBuildEthernet, 'IdRawBuildEthernet', cdRegister);
 S.RegisterDelphiFunction(@IdRawBuildIcmpEcho, 'IdRawBuildIcmpEcho', cdRegister);
 S.RegisterDelphiFunction(@IdRawBuildIcmpMask, 'IdRawBuildIcmpMask', cdRegister);
 S.RegisterDelphiFunction(@IdRawBuildIcmpRedirect, 'IdRawBuildIcmpRedirect', cdRegister);
 S.RegisterDelphiFunction(@IdRawBuildIcmpTimeExceed, 'IdRawBuildIcmpTimeExceed', cdRegister);
 S.RegisterDelphiFunction(@IdRawBuildIcmpTimestamp, 'IdRawBuildIcmpTimestamp', cdRegister);
 S.RegisterDelphiFunction(@IdRawBuildIcmpUnreach, 'IdRawBuildIcmpUnreach', cdRegister);
 S.RegisterDelphiFunction(@IdRawBuildIgmp, 'IdRawBuildIgmp', cdRegister);
 S.RegisterDelphiFunction(@IdRawBuildIp, 'IdRawBuildIp', cdRegister);
 S.RegisterDelphiFunction(@IdRawBuildRip, 'IdRawBuildRip', cdRegister);
 S.RegisterDelphiFunction(@IdRawBuildTcp, 'IdRawBuildTcp', cdRegister);
 S.RegisterDelphiFunction(@IdRawBuildUdp, 'IdRawBuildUdp', cdRegister);
end;

 
 
{ TPSImport_IdRawFunctions }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdRawFunctions.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdRawFunctions(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdRawFunctions.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_IdRawFunctions(ri);
  RIRegister_IdRawFunctions_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
