unit uPSI_maxXMLUtils2;
{
Ta second version of utils

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
  TPSImport_OmniXMLUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_OmniXMLUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_OmniXMLUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,Variants
  ,maxXMLUtils2, xmldom, XMLIntf;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_OmniXMLUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_OmniXMLUtils(CL: TPSPascalCompiler);
begin


  //  XmlString = WideString;
     CL.AddTypeS('XmlString', 'WideString');

 CL.AddDelphiFunction('Function XMLStrToReal38( nodeValue : XmlString; var value : real) : boolean;');
 CL.AddDelphiFunction('Function XMLStrToReal39( nodeValue : XmlString) : real;');
 CL.AddDelphiFunction('Function XMLStrToRealDef( nodeValue : XmlString; defaultValue : real) : real');
 CL.AddDelphiFunction('Function XMLStrToExtended40( nodeValue : XmlString; var value : extended) : boolean;');
 CL.AddDelphiFunction('Function XMLStrToExtended41( nodeValue : XmlString) : extended;');
 CL.AddDelphiFunction('Function XMLStrToExtendedDef( nodeValue : XmlString; defaultValue : extended) : extended');
 CL.AddDelphiFunction('Function XMLStrToCurrency42( nodeValue : XmlString; var value : Currency) : boolean;');
 CL.AddDelphiFunction('Function XMLStrToCurrency43( nodeValue : XmlString) : Currency;');
 CL.AddDelphiFunction('Function XMLStrToCurrencyDef( nodeValue : XmlString; defaultValue : Currency) : Currency');
 CL.AddDelphiFunction('Function XMLStrToInt44( nodeValue : XmlString; var value : integer) : boolean;');
 CL.AddDelphiFunction('Function XMLStrToInt45( nodeValue : XmlString) : integer;');
 CL.AddDelphiFunction('Function XMLStrToIntDef( nodeValue : XmlString; defaultValue : integer) : integer');
 CL.AddDelphiFunction('Function XMLStrToInt6446( nodeValue : XmlString; var value : int64) : boolean;');
 CL.AddDelphiFunction('Function XMLStrToInt6447( nodeValue : XmlString) : int64;');
 CL.AddDelphiFunction('Function XMLStrToInt64Def( nodeValue : XmlString; defaultValue : int64) : int64');
 CL.AddDelphiFunction('Function XMLStrToBool48( nodeValue : XmlString; var value : boolean) : boolean;');
 CL.AddDelphiFunction('Function XMLStrToBool49( nodeValue : XmlString) : boolean;');
 CL.AddDelphiFunction('Function XMLStrToBoolDef( nodeValue : XmlString; defaultValue : boolean) : boolean');
 CL.AddDelphiFunction('Function XMLStrToDateTime50( nodeValue : XmlString; var value : TDateTime) : boolean;');
 CL.AddDelphiFunction('Function XMLStrToDateTime51( nodeValue : XmlString) : TDateTime;');
 CL.AddDelphiFunction('Function XMLStrToDateTimeDef( nodeValue : XmlString; defaultValue : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function XMLStrToDate52( nodeValue : XmlString; var value : TDateTime) : boolean;');
 CL.AddDelphiFunction('Function XMLStrToDate53( nodeValue : XmlString) : TDateTime;');
 CL.AddDelphiFunction('Function XMLStrToDateDef( nodeValue : XmlString; defaultValue : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function XMLStrToTime54( nodeValue : XmlString; var value : TDateTime) : boolean;');
 CL.AddDelphiFunction('Function XMLStrToTime55( nodeValue : XmlString) : TDateTime;');
 CL.AddDelphiFunction('Function XMLStrToTimeDef( nodeValue : XmlString; defaultValue : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function XMLStrToBinary( nodeValue : XmlString; const value : TStream) : boolean');
 CL.AddDelphiFunction('Function XMLRealToStr( value : real; precision : byte) : XmlString');
 CL.AddDelphiFunction('Function XMLExtendedToStr( value : extended) : XmlString');
 CL.AddDelphiFunction('Function XMLCurrencyToStr( value : Currency) : XmlString');
 CL.AddDelphiFunction('Function XMLIntToStr( value : integer) : XmlString');
 CL.AddDelphiFunction('Function XMLInt64ToStr( value : int64) : XmlString');
 CL.AddDelphiFunction('Function XMLBoolToStr( value : boolean; useBoolStrs : boolean) : XmlString');
 CL.AddDelphiFunction('Function XMLDateTimeToStr2( value : TDateTime) : XmlString');
 CL.AddDelphiFunction('Function XMLDateTimeToStrEx( value : TDateTime) : XmlString');
 CL.AddDelphiFunction('Function XMLDateToStr2( value : TDateTime) : XmlString');
 CL.AddDelphiFunction('Function XMLTimeToStr( value : TDateTime) : XmlString');
 CL.AddDelphiFunction('Function XMLBinaryToStr( value : TStream) : XmlString');
 CL.AddDelphiFunction('Function XMLVariantToStr( value : Variant) : XmlString');
  end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
(*----------------------------------------------------------------------------*)
Function XMLStrToTime55_P( nodeValue : XmlString) : TDateTime;
Begin Result := maxXMLUtils2.XMLStrToTime(nodeValue); END;

(*----------------------------------------------------------------------------*)
Function XMLStrToTime54_P( nodeValue : XmlString; var value : TDateTime) : boolean;
Begin Result := maxXMLUtils2.XMLStrToTime(nodeValue, value); END;

(*----------------------------------------------------------------------------*)
Function XMLStrToDate53_P( nodeValue : XmlString) : TDateTime;
Begin Result := maxXMLUtils2.XMLStrToDate(nodeValue); END;

(*----------------------------------------------------------------------------*)
Function XMLStrToDate52_P( nodeValue : XmlString; var value : TDateTime) : boolean;
Begin Result := maxXMLUtils2.XMLStrToDate(nodeValue, value); END;

(*----------------------------------------------------------------------------*)
Function XMLStrToDateTime51_P( nodeValue : XmlString) : TDateTime;
Begin Result := maxXMLUtils2.XMLStrToDateTime(nodeValue); END;

(*----------------------------------------------------------------------------*)
Function XMLStrToDateTime50_P( nodeValue : XmlString; var value : TDateTime) : boolean;
Begin Result := maxXMLUtils2.XMLStrToDateTime(nodeValue, value); END;

(*----------------------------------------------------------------------------*)
Function XMLStrToBool49_P( nodeValue : XmlString) : boolean;
Begin Result := maxXMLUtils2.XMLStrToBool(nodeValue); END;

(*----------------------------------------------------------------------------*)
Function XMLStrToBool48_P( nodeValue : XmlString; var value : boolean) : boolean;
Begin Result := maxXMLUtils2.XMLStrToBool(nodeValue, value); END;

(*----------------------------------------------------------------------------*)
Function XMLStrToInt6447_P( nodeValue : XmlString) : int64;
Begin Result := maxXMLUtils2.XMLStrToInt64(nodeValue); END;

(*----------------------------------------------------------------------------*)
Function XMLStrToInt6446_P( nodeValue : XmlString; var value : int64) : boolean;
Begin Result := maxXMLUtils2.XMLStrToInt64(nodeValue, value); END;

(*----------------------------------------------------------------------------*)
Function XMLStrToInt45_P( nodeValue : XmlString) : integer;
Begin Result := maxXMLUtils2.XMLStrToInt(nodeValue); END;

(*----------------------------------------------------------------------------*)
Function XMLStrToInt44_P( nodeValue : XmlString; var value : integer) : boolean;
Begin Result := maxXMLUtils2.XMLStrToInt(nodeValue, value); END;

(*----------------------------------------------------------------------------*)
Function XMLStrToCurrency43_P( nodeValue : XmlString) : Currency;
Begin Result := maxXMLUtils2.XMLStrToCurrency(nodeValue); END;

(*----------------------------------------------------------------------------*)
Function XMLStrToCurrency42_P( nodeValue : XmlString; var value : Currency) : boolean;
Begin Result := maxXMLUtils2.XMLStrToCurrency(nodeValue, value); END;

(*----------------------------------------------------------------------------*)
Function XMLStrToExtended41_P( nodeValue : XmlString) : extended;
Begin Result := maxXMLUtils2.XMLStrToExtended(nodeValue); END;

(*----------------------------------------------------------------------------*)
Function XMLStrToExtended40_P( nodeValue : XmlString; var value : extended) : boolean;
Begin Result := maxXMLUtils2.XMLStrToExtended(nodeValue, value); END;

(*----------------------------------------------------------------------------*)
Function XMLStrToReal39_P( nodeValue : XmlString) : real;
Begin Result := maxXMLUtils2.XMLStrToReal(nodeValue); END;

(*----------------------------------------------------------------------------*)
Function XMLStrToReal38_P( nodeValue : XmlString; var value : real) : boolean;
Begin Result := maxXMLUtils2.XMLStrToReal(nodeValue, value); END;

(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
procedure RIRegister_OmniXMLUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@XMLStrToReal38_P, 'XMLStrToReal38', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToReal39_P, 'XMLStrToReal39', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToRealDef, 'XMLStrToRealDef', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToExtended40_P, 'XMLStrToExtended40', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToExtended41_P, 'XMLStrToExtended41', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToExtendedDef, 'XMLStrToExtendedDef', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToCurrency42_P, 'XMLStrToCurrency42', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToCurrency43_P, 'XMLStrToCurrency43', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToCurrencyDef, 'XMLStrToCurrencyDef', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToInt44_P, 'XMLStrToInt44', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToInt45_P, 'XMLStrToInt45', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToIntDef, 'XMLStrToIntDef', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToInt6446_P, 'XMLStrToInt6446', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToInt6447_P, 'XMLStrToInt6447', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToInt64Def, 'XMLStrToInt64Def', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToBool48_P, 'XMLStrToBool48', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToBool49_P, 'XMLStrToBool49', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToBoolDef, 'XMLStrToBoolDef', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToDateTime50_P, 'XMLStrToDateTime50', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToDateTime51_P, 'XMLStrToDateTime51', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToDateTimeDef, 'XMLStrToDateTimeDef', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToDate52_P, 'XMLStrToDate52', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToDate53_P, 'XMLStrToDate53', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToDateDef, 'XMLStrToDateDef', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToTime54_P, 'XMLStrToTime54', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToTime55_P, 'XMLStrToTime55', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToTimeDef, 'XMLStrToTimeDef', cdRegister);
 S.RegisterDelphiFunction(@XMLStrToBinary, 'XMLStrToBinary', cdRegister);
 S.RegisterDelphiFunction(@XMLRealToStr, 'XMLRealToStr', cdRegister);
 S.RegisterDelphiFunction(@XMLExtendedToStr, 'XMLExtendedToStr', cdRegister);
 S.RegisterDelphiFunction(@XMLCurrencyToStr, 'XMLCurrencyToStr', cdRegister);
 S.RegisterDelphiFunction(@XMLIntToStr, 'XMLIntToStr', cdRegister);
 S.RegisterDelphiFunction(@XMLInt64ToStr, 'XMLInt64ToStr', cdRegister);
 S.RegisterDelphiFunction(@XMLBoolToStr, 'XMLBoolToStr', cdRegister);
 S.RegisterDelphiFunction(@XMLDateTimeToStr, 'XMLDateTimeToStr2', cdRegister);
 S.RegisterDelphiFunction(@XMLDateTimeToStrEx, 'XMLDateTimeToStrEx', cdRegister);
 S.RegisterDelphiFunction(@XMLDateToStr, 'XMLDateToStr2', cdRegister);
 S.RegisterDelphiFunction(@XMLTimeToStr, 'XMLTimeToStr', cdRegister);
 S.RegisterDelphiFunction(@XMLBinaryToStr, 'XMLBinaryToStr', cdRegister);
 S.RegisterDelphiFunction(@XMLVariantToStr, 'XMLVariantToStr', cdRegister);
  end;

(*----------------------------------------------------------------------------*)

 
{ TPSImport_OmniXMLUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_OmniXMLUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_OmniXMLUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_OmniXMLUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_OmniXMLUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
