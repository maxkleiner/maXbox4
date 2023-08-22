unit uPSI_IdASN1Util;
{
crypto lib to a PKI with cryptobox
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
  TPSImport_IdASN1Util = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IdASN1Util(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IdASN1Util_Routines(S: TPSExec);

procedure Register;

implementation


uses
   IdASN1Util;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdASN1Util]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IdASN1Util(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ASN1_INT','LongWord').SetUInt( $02);
 CL.AddConstantN('ASN1_OCTSTR','LongWord').SetUInt( $04);
 CL.AddConstantN('ASN1_NULL','LongWord').SetUInt( $05);
 CL.AddConstantN('ASN1_OBJID','LongWord').SetUInt( $06);
 CL.AddConstantN('ASN1_SEQ','LongWord').SetUInt( $30);
 CL.AddConstantN('ASN1_IPADDR','LongWord').SetUInt( $40);
 CL.AddConstantN('ASN1_COUNTER','LongWord').SetUInt( $41);
 CL.AddConstantN('ASN1_GAUGE','LongWord').SetUInt( $42);
 CL.AddConstantN('ASN1_TIMETICKS','LongWord').SetUInt( $43);
 CL.AddConstantN('ASN1_OPAQUE','LongWord').SetUInt( $44);
 CL.AddDelphiFunction('Function ASNEncOIDItem( Value : Integer) : string');
 CL.AddDelphiFunction('Function ASNDecOIDItem( var Start : Integer; const Buffer : string) : Integer');
 CL.AddDelphiFunction('Function ASNEncLen( Len : Integer) : string');
 CL.AddDelphiFunction('Function ASNDecLen( var Start : Integer; const Buffer : string) : Integer');
 CL.AddDelphiFunction('Function ASNEncInt( Value : Integer) : string');
 CL.AddDelphiFunction('Function ASNEncUInt( Value : Integer) : string');
 CL.AddDelphiFunction('Function ASNObject( const Data : string; ASNType : Integer) : string');
 CL.AddDelphiFunction('Function ASNItem( var Start : Integer; const Buffer : string; var ValueType : Integer) : string');
 CL.AddDelphiFunction('Function MibToId( Mib : string) : string');
 CL.AddDelphiFunction('Function IdToMib( const Id : string) : string');
 CL.AddDelphiFunction('Function IntMibToStr( const Value : string) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_IdASN1Util_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ASNEncOIDItem, 'ASNEncOIDItem', cdRegister);
 S.RegisterDelphiFunction(@ASNDecOIDItem, 'ASNDecOIDItem', cdRegister);
 S.RegisterDelphiFunction(@ASNEncLen, 'ASNEncLen', cdRegister);
 S.RegisterDelphiFunction(@ASNDecLen, 'ASNDecLen', cdRegister);
 S.RegisterDelphiFunction(@ASNEncInt, 'ASNEncInt', cdRegister);
 S.RegisterDelphiFunction(@ASNEncUInt, 'ASNEncUInt', cdRegister);
 S.RegisterDelphiFunction(@ASNObject, 'ASNObject', cdRegister);
 S.RegisterDelphiFunction(@ASNItem, 'ASNItem', cdRegister);
 S.RegisterDelphiFunction(@MibToId, 'MibToId', cdRegister);
 S.RegisterDelphiFunction(@IdToMib, 'IdToMib', cdRegister);
 S.RegisterDelphiFunction(@IntMibToStr, 'IntMibToStr', cdRegister);
end;

 
 
{ TPSImport_IdASN1Util }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdASN1Util.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdASN1Util(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdASN1Util.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_IdASN1Util(ri);
  RIRegister_IdASN1Util_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
