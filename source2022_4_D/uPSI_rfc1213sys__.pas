unit uPSI_rfc1213sys;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_rfc1213sys = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_Tsys(CL: TPSPascalCompiler);
procedure SIRegister_rfc1213sys(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Tsys(CL: TPSRuntimeClassImporter);
procedure RIRegister_rfc1213sys(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   rfc1213const
  ,rfc1213util
  ,asn1util
  ,snmpsend
  ,rfc1213sys
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_rfc1213sys]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_Tsys(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'Tsys') do
  with CL.AddClassN(CL.FindClass('TObject'),'Tsys') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Get : boolean');
    RegisterMethod('Procedure Bind( const BHostAddress, BReadCommunity, BWriteCommunity : string)');
    RegisterProperty('ErrorCode', 'integer', iptr);
    RegisterProperty('HostAddress', 'string', iptr);
    RegisterProperty('ReadCommunity', 'string', iptr);
    RegisterProperty('WriteCommunity', 'string', iptr);
    RegisterProperty('sysDescr', 'string', iptr);
    RegisterProperty('sysObjectID', 'string', iptr);
    RegisterProperty('sysUpTime', 'string', iptr);
    RegisterProperty('sysContact', 'string', iptr);
    RegisterProperty('sysName', 'string', iptr);
    RegisterProperty('sysLocation', 'string', iptr);
    RegisterProperty('sysServices', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_rfc1213sys(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('version','String').SetString( 'rfc1213sys v.0.2.2');
  SIRegister_Tsys(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TsyssysServices_R(Self: Tsys; var T: string);
begin T := Self.sysServices; end;

(*----------------------------------------------------------------------------*)
procedure TsyssysLocation_R(Self: Tsys; var T: string);
begin T := Self.sysLocation; end;

(*----------------------------------------------------------------------------*)
procedure TsyssysName_R(Self: Tsys; var T: string);
begin T := Self.sysName; end;

(*----------------------------------------------------------------------------*)
procedure TsyssysContact_R(Self: Tsys; var T: string);
begin T := Self.sysContact; end;

(*----------------------------------------------------------------------------*)
procedure TsyssysUpTime_R(Self: Tsys; var T: string);
begin T := Self.sysUpTime; end;

(*----------------------------------------------------------------------------*)
procedure TsyssysObjectID_R(Self: Tsys; var T: string);
begin T := Self.sysObjectID; end;

(*----------------------------------------------------------------------------*)
procedure TsyssysDescr_R(Self: Tsys; var T: string);
begin T := Self.sysDescr; end;

(*----------------------------------------------------------------------------*)
procedure TsysWriteCommunity_R(Self: Tsys; var T: string);
begin T := Self.WriteCommunity; end;

(*----------------------------------------------------------------------------*)
procedure TsysReadCommunity_R(Self: Tsys; var T: string);
begin T := Self.ReadCommunity; end;

(*----------------------------------------------------------------------------*)
procedure TsysHostAddress_R(Self: Tsys; var T: string);
begin T := Self.HostAddress; end;

(*----------------------------------------------------------------------------*)
procedure TsysErrorCode_R(Self: Tsys; var T: integer);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Tsys(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(Tsys) do
  begin
    RegisterConstructor(@Tsys.Create, 'Create');
    RegisterMethod(@Tsys.Get, 'Get');
    RegisterMethod(@Tsys.Bind, 'Bind');
    RegisterPropertyHelper(@TsysErrorCode_R,nil,'ErrorCode');
    RegisterPropertyHelper(@TsysHostAddress_R,nil,'HostAddress');
    RegisterPropertyHelper(@TsysReadCommunity_R,nil,'ReadCommunity');
    RegisterPropertyHelper(@TsysWriteCommunity_R,nil,'WriteCommunity');
    RegisterPropertyHelper(@TsyssysDescr_R,nil,'sysDescr');
    RegisterPropertyHelper(@TsyssysObjectID_R,nil,'sysObjectID');
    RegisterPropertyHelper(@TsyssysUpTime_R,nil,'sysUpTime');
    RegisterPropertyHelper(@TsyssysContact_R,nil,'sysContact');
    RegisterPropertyHelper(@TsyssysName_R,nil,'sysName');
    RegisterPropertyHelper(@TsyssysLocation_R,nil,'sysLocation');
    RegisterPropertyHelper(@TsyssysServices_R,nil,'sysServices');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_rfc1213sys(CL: TPSRuntimeClassImporter);
begin
  RIRegister_Tsys(CL);
end;

 
 
{ TPSImport_rfc1213sys }
(*----------------------------------------------------------------------------*)
procedure TPSImport_rfc1213sys.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_rfc1213sys(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_rfc1213sys.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_rfc1213sys(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
