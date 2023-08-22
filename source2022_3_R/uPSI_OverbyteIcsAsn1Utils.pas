unit uPSI_OverbyteIcsAsn1Utils;
{
to cert validationn and cryptobox 3 

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
  TPSImport_OverbyteIcsAsn1Utils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_OverbyteIcsAsn1Utils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_OverbyteIcsAsn1Utils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   OverbyteIcsAsn1Utils
  ;
 
 
procedure Register;
begin
  //RegisterComponents('Pascal Script', [TPSImport_OverbyteIcsAsn1Utils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_OverbyteIcsAsn1Utils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ASN1UtilsVersion','LongInt').SetInt( 101);
 CL.AddConstantN('CopyRight','String').SetString( ' ASN1Utils (c) 2011 Francois Piette V1.01 ');
 CL.AddConstantN('ASN1_BOOL','LongWord').SetUInt( $01);
 CL.AddConstantN('ASN1_INT','LongWord').SetUInt( $02);
 CL.AddConstantN('ASN1_OCTSTR','LongWord').SetUInt( $04);
 CL.AddConstantN('ASN1_NULL','LongWord').SetUInt( $05);
 CL.AddConstantN('ASN1_OBJID','LongWord').SetUInt( $06);
 CL.AddConstantN('ASN1_ENUM','LongWord').SetUInt( $0a);
 CL.AddConstantN('ASN1_SEQ','LongWord').SetUInt( $30);
 CL.AddConstantN('ASN1_SETOF','LongWord').SetUInt( $31);
 CL.AddConstantN('ASN1_IPADDR','LongWord').SetUInt( $40);
 CL.AddConstantN('ASN1_COUNTER','LongWord').SetUInt( $41);
 CL.AddConstantN('ASN1_GAUGE','LongWord').SetUInt( $42);
 CL.AddConstantN('ASN1_TIMETICKS','LongWord').SetUInt( $43);
 CL.AddConstantN('ASN1_OPAQUE','LongWord').SetUInt( $44);
 CL.AddDelphiFunction('Function ASNEncOIDItem2( Value : Integer) : AnsiString');
 CL.AddDelphiFunction('Function ASNDecOIDItem2( var Start : Integer; const Buffer : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ASNEncLen2( Len : Integer) : AnsiString');
 CL.AddDelphiFunction('Function ASNDecLen2( var Start : Integer; const Buffer : AnsiString) : Integer');
 CL.AddDelphiFunction('Function ASNEncInt2( Value : Integer) : AnsiString');
 CL.AddDelphiFunction('Function ASNEncUInt2( Value : Integer) : AnsiString');
 CL.AddDelphiFunction('Function ASNObject2( const Data : AnsiString; ASNType : Integer) : AnsiString');
 CL.AddDelphiFunction('Function ASNItem2( var Start : Integer; const Buffer : AnsiString; var ValueType : Integer) : AnsiString');
 CL.AddDelphiFunction('Function MibToId2( Mib : String) : AnsiString;');
 //CL.AddDelphiFunction('Function MibToId1( Mib : AnsiString) : AnsiString;');
 CL.AddDelphiFunction('Function IdToMib2( const Id : AnsiString) : String');
 CL.AddDelphiFunction('Function IntMibToStr2( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ASNdump2( const Value : AnsiString) : String');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function MibToId1_P( Mib : AnsiString) : AnsiString;
Begin Result := OverbyteIcsAsn1Utils.MibToId(Mib); END;

(*----------------------------------------------------------------------------*)
Function MibToId_P( Mib : String) : AnsiString;
Begin Result := OverbyteIcsAsn1Utils.MibToId(Mib); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_OverbyteIcsAsn1Utils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ASNEncOIDItem, 'ASNEncOIDItem2', cdRegister);
 S.RegisterDelphiFunction(@ASNDecOIDItem, 'ASNDecOIDItem2', cdRegister);
 S.RegisterDelphiFunction(@ASNEncLen, 'ASNEncLen2', cdRegister);
 S.RegisterDelphiFunction(@ASNDecLen, 'ASNDecLen2', cdRegister);
 S.RegisterDelphiFunction(@ASNEncInt, 'ASNEncInt2', cdRegister);
 S.RegisterDelphiFunction(@ASNEncUInt, 'ASNEncUInt2', cdRegister);
 S.RegisterDelphiFunction(@ASNObject, 'ASNObject2', cdRegister);
 S.RegisterDelphiFunction(@ASNItem, 'ASNItem2', cdRegister);
 S.RegisterDelphiFunction(@MibToId, 'MibToId2', cdRegister);
 //S.RegisterDelphiFunction(@MibToId1, 'MibToId1', cdRegister);
 S.RegisterDelphiFunction(@IdToMib, 'IdToMib2', cdRegister);
 S.RegisterDelphiFunction(@IntMibToStr, 'IntMibToStr2', cdRegister);
 S.RegisterDelphiFunction(@ASNdump, 'ASNdump2', cdRegister);
end;

 
 
{ TPSImport_OverbyteIcsAsn1Utils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_OverbyteIcsAsn1Utils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_OverbyteIcsAsn1Utils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_OverbyteIcsAsn1Utils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_OverbyteIcsAsn1Utils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
