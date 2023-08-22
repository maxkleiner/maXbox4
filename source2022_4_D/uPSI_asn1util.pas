unit uPSI_asn1util;
{
  another asnutil see also idasn1util
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
  TPSImport_asn1util = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_asn1util(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_asn1util_Routines(S: TPSExec);

procedure Register;

implementation


uses
   synautil
  ,asn1util
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_asn1util]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_asn1util(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('synASN1_BOOL','LongWord').SetUInt( $01);
 CL.AddConstantN('synASN1_INT','LongWord').SetUInt( $02);
 CL.AddConstantN('synASN1_OCTSTR','LongWord').SetUInt( $04);
 CL.AddConstantN('synASN1_NULL','LongWord').SetUInt( $05);
 CL.AddConstantN('synASN1_OBJID','LongWord').SetUInt( $06);
 CL.AddConstantN('synASN1_ENUM','LongWord').SetUInt( $0a);
 CL.AddConstantN('synASN1_SEQ','LongWord').SetUInt( $30);
 CL.AddConstantN('synASN1_SETOF','LongWord').SetUInt( $31);
 CL.AddConstantN('synASN1_IPADDR','LongWord').SetUInt( $40);
 CL.AddConstantN('synASN1_COUNTER','LongWord').SetUInt( $41);
 CL.AddConstantN('synASN1_GAUGE','LongWord').SetUInt( $42);
 CL.AddConstantN('synASN1_TIMETICKS','LongWord').SetUInt( $43);
 CL.AddConstantN('synASN1_OPAQUE','LongWord').SetUInt( $44);
 CL.AddDelphiFunction('Function synASNEncOIDItem( Value : Integer) : AnsiString');
 CL.AddDelphiFunction('Function synASNDecOIDItem( var Start : Integer; const Buffer : AnsiString) : Integer');
 CL.AddDelphiFunction('Function synASNEncLen( Len : Integer) : AnsiString');
 CL.AddDelphiFunction('Function synASNDecLen( var Start : Integer; const Buffer : AnsiString) : Integer');
 CL.AddDelphiFunction('Function synASNEncInt( Value : Integer) : AnsiString');
 CL.AddDelphiFunction('Function synASNEncUInt( Value : Integer) : AnsiString');
 CL.AddDelphiFunction('Function synASNObject( const Data : AnsiString; ASNType : Integer) : AnsiString');
 CL.AddDelphiFunction('Function synASNItem( var Start : Integer; const Buffer : AnsiString; var ValueType : Integer) : AnsiString');
 CL.AddDelphiFunction('Function synMibToId( Mib : String) : AnsiString');
 CL.AddDelphiFunction('Function synIdToMib( const Id : AnsiString) : String');
 CL.AddDelphiFunction('Function synIntMibToStr( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ASNdump( const Value : AnsiString) : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_asn1util_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ASNEncOIDItem, 'synASNEncOIDItem', cdRegister);
 S.RegisterDelphiFunction(@ASNDecOIDItem, 'synASNDecOIDItem', cdRegister);
 S.RegisterDelphiFunction(@ASNEncLen, 'synASNEncLen', cdRegister);
 S.RegisterDelphiFunction(@ASNDecLen, 'synASNDecLen', cdRegister);
 S.RegisterDelphiFunction(@ASNEncInt, 'synASNEncInt', cdRegister);
 S.RegisterDelphiFunction(@ASNEncUInt, 'synASNEncUInt', cdRegister);
 S.RegisterDelphiFunction(@ASNObject, 'synASNObject', cdRegister);
 S.RegisterDelphiFunction(@ASNItem, 'synASNItem', cdRegister);
 S.RegisterDelphiFunction(@MibToId, 'synMibToId', cdRegister);
 S.RegisterDelphiFunction(@IdToMib, 'synIdToMib', cdRegister);
 S.RegisterDelphiFunction(@IntMibToStr, 'synIntMibToStr', cdRegister);
 S.RegisterDelphiFunction(@ASNdump, 'ASNdump', cdRegister);
end;

 
 
{ TPSImport_asn1util }
(*----------------------------------------------------------------------------*)
procedure TPSImport_asn1util.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_asn1util(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_asn1util.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_asn1util(ri);
  RIRegister_asn1util_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
