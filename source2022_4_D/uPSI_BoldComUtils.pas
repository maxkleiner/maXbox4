unit uPSI_BoldComUtils;
{
   more bold
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
  TPSImport_BoldComUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_BoldComUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_BoldComUtils_Routines(S: TPSExec);
procedure RIRegister_BoldComUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ActiveX
  ,BoldDefs
  ,BoldComUtils
  ,BoldGUIDUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BoldComUtils]);
end;


function StringRefCount(const s: String): integer;
begin
  result := Integer(Pointer(integer(Addr(s)^)-8)^);
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_BoldComUtils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('RPC_C_AUTHN_LEVEL_DEFAULT','LongInt').SetInt( 0);
 CL.AddConstantN('RPC_C_AUTHN_LEVEL_NONE','LongInt').SetInt( 1);
 CL.AddConstantN('RPC_C_AUTHN_LEVEL_CONNECT','LongInt').SetInt( 2);
 CL.AddConstantN('RPC_C_AUTHN_LEVEL_CALL','LongInt').SetInt( 3);
 CL.AddConstantN('RPC_C_AUTHN_LEVEL_PKT','LongInt').SetInt( 4);
 CL.AddConstantN('RPC_C_AUTHN_LEVEL_PKT_INTEGRITY','LongInt').SetInt( 5);
 CL.AddConstantN('RPC_C_AUTHN_LEVEL_PKT_PRIVACY','LongInt').SetInt( 6);
 CL.AddConstantN('BOLDESC','string').SetString(#27);
 CL.AddConstantN('BOLDNULL','string').SetString(#0);
 CL.AddConstantN('BOLDCRLF','string').SetString(#13+#10);
 CL.AddConstantN('BOLDCR','string').SetString(#13);
 CL.AddConstantN('BOLDLF','string').SetString(#10);
 {CL.AddConstantN('alDefault','1').SetString( RPC_C_AUTHN_LEVEL_DEFAULT);
 CL.AddConstantN('alNone','2').SetString( RPC_C_AUTHN_LEVEL_NONE);
 CL.AddConstantN('alConnect','3').SetString( RPC_C_AUTHN_LEVEL_CONNECT);
 CL.AddConstantN('alCall','4').SetString( RPC_C_AUTHN_LEVEL_CALL);
 CL.AddConstantN('alPacket','5').SetString( RPC_C_AUTHN_LEVEL_PKT);
 CL.AddConstantN('alPacketIntegrity','6').SetString( RPC_C_AUTHN_LEVEL_PKT_INTEGRITY);
 CL.AddConstantN('alPacketPrivacy','7').SetString( RPC_C_AUTHN_LEVEL_PKT_PRIVACY);}
 CL.AddConstantN('RPC_C_IMP_LEVEL_DEFAULT','LongInt').SetInt( 0);
 CL.AddConstantN('RPC_C_IMP_LEVEL_ANONYMOUS','LongInt').SetInt( 1);
 CL.AddConstantN('RPC_C_IMP_LEVEL_IDENTIFY','LongInt').SetInt( 2);
 CL.AddConstantN('RPC_C_IMP_LEVEL_IMPERSONATE','LongInt').SetInt( 3);
 CL.AddConstantN('RPC_C_IMP_LEVEL_DELEGATE','LongInt').SetInt( 4);
 {CL.AddConstantN('ilDefault','0').SetString( RPC_C_IMP_LEVEL_DEFAULT);
 CL.AddConstantN('ilAnonymous','1').SetString( RPC_C_IMP_LEVEL_ANONYMOUS);
 CL.AddConstantN('ilIdentiry','2').SetString( RPC_C_IMP_LEVEL_IDENTIFY);
 CL.AddConstantN('ilImpersonate','3').SetString( RPC_C_IMP_LEVEL_IMPERSONATE);
 CL.AddConstantN('ilDelegate','4').SetString( RPC_C_IMP_LEVEL_DELEGATE);}
 CL.AddConstantN('EOAC_NONE','LongWord').SetUInt( $0);
 CL.AddConstantN('EOAC_DEFAULT','LongWord').SetUInt( $800);
 CL.AddConstantN('EOAC_MUTUAL_AUTH','LongWord').SetUInt( $1);
 CL.AddConstantN('EOAC_STATIC_CLOACKING','LongWord').SetUInt( $20);
 CL.AddConstantN('EOAC_DYNAMIC_CLOAKING','LongWord').SetUInt( $40);
 CL.AddConstantN('EOAC_ANY_AUTHORITY','LongWord').SetUInt( $80);
 CL.AddConstantN('RPC_C_AUTHN_WINNT','LongInt').SetInt( 10);
 CL.AddConstantN('RPC_C_AUTHNZ_NONE','LongInt').SetInt( 0);
 CL.AddConstantN('RPC_C_AUTHNZ_NAME','LongInt').SetInt( 1);
 CL.AddConstantN('RPC_C_AUTHNZ_DCE','LongInt').SetInt( 2);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EBoldCom');
 CL.AddDelphiFunction('Function BoldVariantIsType( V : OleVariant; TypeCode : Integer) : Boolean');
 CL.AddDelphiFunction('Function BoldMemoryToVariant( const Buffer, BufSize : Integer) : OleVariant');
 CL.AddDelphiFunction('Function BoldStreamToVariant( Stream : TStream) : OleVariant');
 CL.AddDelphiFunction('Function BoldStringsToVariant( Strings : TStrings) : OleVariant');
 CL.AddDelphiFunction('Function BoldVariantToMemory( V : OleVariant; var Buffer, BufSize : Integer) : Integer');
 CL.AddDelphiFunction('Function BoldVariantToStream( V : OleVariant; Stream : TStream) : Integer');
 CL.AddDelphiFunction('Function BoldVariantArrayOfArraysOfStringToStrings( V : OleVariant; Strings : TStrings) : Integer');
 CL.AddDelphiFunction('Function BoldVariantIsNamedValues( V : OleVariant) : Boolean');
 CL.AddDelphiFunction('Function BoldCreateNamedValues( const Names : array of string; const Values : array of OleVariant) : OleVariant');
 CL.AddDelphiFunction('Function BoldGetNamedValue( Data : OleVariant; const Name : string) : OleVariant');
 CL.AddDelphiFunction('Procedure BoldSetNamedValue( Data : OleVariant; const Name : string; Value : OleVariant)');
 CL.AddDelphiFunction('Function BoldCreateGUID : TGUID');
 CL.AddDelphiFunction('Function BoldCreateComObject( const ClsId, IId : TGUID; out Obj : variant; out Res : HResult) : Boolean');
 CL.AddDelphiFunction('Function BoldCreateRemoteComObject( const HostName : string; const ClsId, IId : TGUID; out Obj : variant; out Res : HResult) : Boolean');
 CL.AddDelphiFunction('Procedure BoldInitializeComSecurity( AuthenticationLevel, ImpersonationLevel : longint)');
 CL.AddDelphiFunction('Procedure BoldSetSecurityForInterface( AuthenticationLevel, ImpersonationLevel : longint; Unk : IUnknown)');
 CL.AddDelphiFunction('Function BoldCreateGUIDAsString( StripBrackets : Boolean) : string');
 CL.AddDelphiFunction('Function BoldCreateGUIDWithBracketsAsString : string');
 CL.AddDelphiFunction('function StringRefCount(const s: String): integer;');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_BoldComUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@BoldVariantIsType, 'BoldVariantIsType', cdRegister);
 S.RegisterDelphiFunction(@BoldMemoryToVariant, 'BoldMemoryToVariant', cdRegister);
 S.RegisterDelphiFunction(@BoldStreamToVariant, 'BoldStreamToVariant', cdRegister);
 S.RegisterDelphiFunction(@BoldStringsToVariant, 'BoldStringsToVariant', cdRegister);
 S.RegisterDelphiFunction(@BoldVariantToMemory, 'BoldVariantToMemory', cdRegister);
 S.RegisterDelphiFunction(@BoldVariantToStream, 'BoldVariantToStream', cdRegister);
 S.RegisterDelphiFunction(@BoldVariantArrayOfArraysOfStringToStrings, 'BoldVariantArrayOfArraysOfStringToStrings', cdRegister);
 S.RegisterDelphiFunction(@BoldVariantIsNamedValues, 'BoldVariantIsNamedValues', cdRegister);
 S.RegisterDelphiFunction(@BoldCreateNamedValues, 'BoldCreateNamedValues', cdRegister);
 S.RegisterDelphiFunction(@BoldGetNamedValue, 'BoldGetNamedValue', cdRegister);
 S.RegisterDelphiFunction(@BoldSetNamedValue, 'BoldSetNamedValue', cdRegister);
 S.RegisterDelphiFunction(@BoldCreateGUID, 'BoldCreateGUID', cdRegister);
 S.RegisterDelphiFunction(@BoldCreateComObject, 'BoldCreateComObject', cdRegister);
 S.RegisterDelphiFunction(@BoldCreateRemoteComObject, 'BoldCreateRemoteComObject', cdRegister);
 S.RegisterDelphiFunction(@BoldInitializeComSecurity, 'BoldInitializeComSecurity', cdRegister);
 S.RegisterDelphiFunction(@BoldSetSecurityForInterface, 'BoldSetSecurityForInterface', cdRegister);
 S.RegisterDelphiFunction(@BoldCreateGUIDAsString, 'BoldCreateGUIDAsString', cdRegister);
 S.RegisterDelphiFunction(@BoldCreateGUIDWithBracketsAsString, 'BoldCreateGUIDWithBracketsAsString', cdRegister);
 S.RegisterDelphiFunction(@StringRefCount, 'StringRefCount', cdRegister);


 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BoldComUtils(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EBoldCom) do
end;

 
 
{ TPSImport_BoldComUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldComUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BoldComUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldComUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BoldComUtils(ri);
  RIRegister_BoldComUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
