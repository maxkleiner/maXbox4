unit uPSI_TypeTrans;
{
   just routines 
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
  TPSImport_TypeTrans = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTypeTranslator(CL: TPSPascalCompiler);
procedure SIRegister_TypeTrans(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TypeTrans_Routines(S: TPSExec);
procedure RIRegister_TTypeTranslator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TypeTrans(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   TypInfo
  ,IntfInfo
  ,InvokeRegistry
  ,TypeTrans
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_TypeTrans]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTypeTranslator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTypeTranslator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TTypeTranslator') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function CastSoapToNative( Info : PTypeInfo; const SoapData : WideString; NatData : Pointer; IsNull : Boolean) : Boolean');
    RegisterMethod('Procedure CastNativeToSoap( Info : PTypeInfo; var SoapData : WideString; NatData : Pointer; var IsNull : Boolean)');
    RegisterMethod('Procedure CastSoapToVariant( SoapInfo : PTypeInfo; const SoapData : WideString; NatData : Pointer);');
    RegisterMethod('Function CastSoapToVariant1( SoapInfo : PTypeInfo; const SoapData : WideString) : Variant;');
    RegisterMethod('Procedure Base64ToVar( NatData : Pointer; const SoapData : WideString);');
    RegisterMethod('Procedure Base64ToVar1( var V : Variant; const SoapData : WideString);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TypeTrans(CL: TPSPascalCompiler);
begin
  SIRegister_TTypeTranslator(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'ETypeTransException');
 CL.AddDelphiFunction('Function FloatToStrEx( Value : Extended) : string');
 CL.AddDelphiFunction('Function StrToFloatEx( const S : string) : Extended');
 CL.AddDelphiFunction('Function GetEnumValueEx( TypInfo : PTypeInfo; const Name : string) : Integer');
 CL.AddDelphiFunction('Procedure SetEnumPropEx( Instance : TObject; PropInfo : PPropInfo; const Value : string)');
 CL.AddDelphiFunction('Function GetEnumValueExW( TypInfo : PTypeInfo; const Name : WideString) : Integer');
 CL.AddDelphiFunction('Procedure SetEnumPropExW( Instance : TObject; PropInfo : PPropInfo; const Value : WideString)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure TTypeTranslatorBase64ToVar1_P(Self: TTypeTranslator;  var V : Variant; const SoapData : WideString);
Begin Self.Base64ToVar(V, SoapData); END;

(*----------------------------------------------------------------------------*)
Procedure TTypeTranslatorBase64ToVar_P(Self: TTypeTranslator;  NatData : Pointer; const SoapData : WideString);
Begin Self.Base64ToVar(NatData, SoapData); END;

(*----------------------------------------------------------------------------*)
Function TTypeTranslatorCastSoapToVariant1_P(Self: TTypeTranslator;  SoapInfo : PTypeInfo; const SoapData : WideString) : Variant;
Begin Result := Self.CastSoapToVariant(SoapInfo, SoapData); END;

(*----------------------------------------------------------------------------*)
Procedure TTypeTranslatorCastSoapToVariant_P(Self: TTypeTranslator;  SoapInfo : PTypeInfo; const SoapData : WideString; NatData : Pointer);
Begin Self.CastSoapToVariant(SoapInfo, SoapData, NatData); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TypeTrans_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@FloatToStrEx, 'FloatToStrEx', cdRegister);
 S.RegisterDelphiFunction(@StrToFloatEx, 'StrToFloatEx', cdRegister);
 S.RegisterDelphiFunction(@GetEnumValueEx, 'GetEnumValueEx', cdRegister);
 S.RegisterDelphiFunction(@SetEnumPropEx, 'SetEnumPropEx', cdRegister);
 S.RegisterDelphiFunction(@GetEnumValueExW, 'GetEnumValueExW', cdRegister);
 S.RegisterDelphiFunction(@SetEnumPropExW, 'SetEnumPropExW', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTypeTranslator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTypeTranslator) do begin
    RegisterConstructor(@TTypeTranslator.Create, 'Create');
    RegisterMethod(@TTypeTranslator.CastSoapToNative, 'CastSoapToNative');
    RegisterMethod(@TTypeTranslator.CastNativeToSoap, 'CastNativeToSoap');
    RegisterMethod(@TTypeTranslatorCastSoapToVariant_P, 'CastSoapToVariant');
    RegisterMethod(@TTypeTranslatorCastSoapToVariant1_P, 'CastSoapToVariant1');
    RegisterMethod(@TTypeTranslatorBase64ToVar_P, 'Base64ToVar');
    RegisterMethod(@TTypeTranslatorBase64ToVar1_P, 'Base64ToVar1');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TypeTrans(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TTypeTranslator(CL);
  with CL.Add(ETypeTransException) do
end;

 
 
{ TPSImport_TypeTrans }
(*----------------------------------------------------------------------------*)
procedure TPSImport_TypeTrans.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_TypeTrans(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_TypeTrans.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_TypeTrans(ri);
  RIRegister_TypeTrans_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
