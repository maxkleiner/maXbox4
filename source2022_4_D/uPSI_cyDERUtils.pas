unit uPSI_cyDERUtils;
{
  doc utils
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
  TPSImport_cyDERUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cyDERUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cyDERUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,cyDateUtils
  ,cyDERUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyDERUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cyDERUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('DERString', 'String');
  CL.AddTypeS('DERChar', 'Char');
  CL.AddTypeS('TElementsType', '( etText, etExpressionKeyWord, etNumbers, etInt'
   +'eger, etFloat, etPercentage, etwebSite, etWebMail, etMoney, etDate, etTextLine, etParagraph )');
  CL.AddTypeS('TElementsTypes', 'set of TElementsType');
  CL.AddTypeS('DERNString', 'String');
 CL.AddConstantN('DERDecimalSeparator','String').SetString( '.');
 CL.AddConstantN('DERDefaultChars','String').SetString( '+º@/%-_.:0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ');
 CL.AddConstantN('DERNDefaultChars','String').SetString( '/%-.0123456789abcdefghjkmnopqrstuvwxyz');
 CL.AddDelphiFunction('Function isValidWebSiteChar( aChar : Char) : Boolean');
 CL.AddDelphiFunction('Function isValidWebMailChar( aChar : Char) : Boolean');
 CL.AddDelphiFunction('Function isValidwebSite( aStr : String) : Boolean');
 CL.AddDelphiFunction('Function isValidWebMail( aStr : String) : Boolean');
 CL.AddDelphiFunction('Function ValidateDate( aDERStr : DERString; var RsltFormat : String) : Boolean');
 CL.AddDelphiFunction('Function DERStrToDate( aDERStr, aFormat : String) : TDate');
 CL.AddDelphiFunction('Function IsDERChar( aChar : Char) : Boolean');
 CL.AddDelphiFunction('Function IsDERDefaultChar( aChar : Char) : Boolean');
 CL.AddDelphiFunction('Function IsDERMoneyChar( aChar : Char) : Boolean');
 CL.AddDelphiFunction('Function IsDERExceptionCar( aChar : Char) : Boolean');
 CL.AddDelphiFunction('Function IsDERSymbols( aDERString : String) : Boolean');
 CL.AddDelphiFunction('Function StringToDERCharSet( aStr : String) : DERString');
 CL.AddDelphiFunction('Function IsDERNDefaultChar( aChar : Char) : Boolean');
 CL.AddDelphiFunction('Function IsDERNChar( aChar : Char) : Boolean');
 CL.AddDelphiFunction('Function DERToDERNCharset( aDERStr : DERString) : DERNString');
 CL.AddDelphiFunction('Function DERExtractwebSite( aDERStr : DERString; SmartRecognition : Boolean) : String');
 CL.AddDelphiFunction('Function DERExtractWebMail( aDERStr : DERString) : String');
 CL.AddDelphiFunction('Function DERExtractPhoneNr( aDERStr : DERString) : String');
 CL.AddDelphiFunction('Function DERExecute( aDERStr : DERString; SmartNumbersRecognition, SmartWebsiteRecognition : Boolean) : TElementsType;');
 CL.AddDelphiFunction('Function DERExecute1( aDERStr : DERString; var RsltNumbers, RsltInteger, RsltFloat, RsltPercentage, RsltwebSite, RsltWebMail, RsltMoney, RsltDate : String; SmartNumbersRecognition, SmartWebsiteRecognition : Boolean) : TElementsType;');
 CL.AddDelphiFunction('Function RetrieveElementValue( aStr : String; SmartNumbersRecognition, SmartWebsiteRecognition : Boolean; aElementsType : TElementsType) : String;');
 CL.AddDelphiFunction('Procedure RetrieveElementValue1( aStr : String; SmartNumbersRecognition, SmartWebsiteRecognition : Boolean; var RsltDERStr : DERString; var RsltElementType : TElementsType);');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure RetrieveElementValue1_P( aStr : String; SmartNumbersRecognition, SmartWebsiteRecognition : Boolean; var RsltDERStr : DERString; var RsltElementType : TElementsType);
Begin cyDERUtils.RetrieveElementValue(aStr, SmartNumbersRecognition, SmartWebsiteRecognition, RsltDERStr, RsltElementType); END;

(*----------------------------------------------------------------------------*)
Function RetrieveElementValue_P( aStr : String; SmartNumbersRecognition, SmartWebsiteRecognition : Boolean; aElementsType : TElementsType) : String;
Begin Result := cyDERUtils.RetrieveElementValue(aStr, SmartNumbersRecognition, SmartWebsiteRecognition, aElementsType); END;

(*----------------------------------------------------------------------------*)
Function DERExecute1_P( aDERStr : DERString; var RsltNumbers, RsltInteger, RsltFloat, RsltPercentage, RsltwebSite, RsltWebMail, RsltMoney, RsltDate : String; SmartNumbersRecognition, SmartWebsiteRecognition : Boolean) : TElementsType;
Begin Result := cyDERUtils.DERExecute(aDERStr, RsltNumbers, RsltInteger, RsltFloat, RsltPercentage, RsltwebSite, RsltWebMail, RsltMoney, RsltDate, SmartNumbersRecognition, SmartWebsiteRecognition); END;

(*----------------------------------------------------------------------------*)
Function DERExecute_P( aDERStr : DERString; SmartNumbersRecognition, SmartWebsiteRecognition : Boolean) : TElementsType;
Begin Result := cyDERUtils.DERExecute(aDERStr, SmartNumbersRecognition, SmartWebsiteRecognition); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyDERUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@isValidWebSiteChar, 'isValidWebSiteChar', cdRegister);
 S.RegisterDelphiFunction(@isValidWebMailChar, 'isValidWebMailChar', cdRegister);
 S.RegisterDelphiFunction(@isValidwebSite, 'isValidwebSite', cdRegister);
 S.RegisterDelphiFunction(@isValidWebMail, 'isValidWebMail', cdRegister);
 S.RegisterDelphiFunction(@ValidateDate, 'ValidateDate', cdRegister);
 S.RegisterDelphiFunction(@DERStrToDate, 'DERStrToDate', cdRegister);
 S.RegisterDelphiFunction(@IsDERChar, 'IsDERChar', cdRegister);
 S.RegisterDelphiFunction(@IsDERDefaultChar, 'IsDERDefaultChar', cdRegister);
 S.RegisterDelphiFunction(@IsDERMoneyChar, 'IsDERMoneyChar', cdRegister);
 S.RegisterDelphiFunction(@IsDERExceptionCar, 'IsDERExceptionCar', cdRegister);
 S.RegisterDelphiFunction(@IsDERSymbols, 'IsDERSymbols', cdRegister);
 S.RegisterDelphiFunction(@StringToDERCharSet, 'StringToDERCharSet', cdRegister);
 S.RegisterDelphiFunction(@IsDERNDefaultChar, 'IsDERNDefaultChar', cdRegister);
 S.RegisterDelphiFunction(@IsDERNChar, 'IsDERNChar', cdRegister);
 S.RegisterDelphiFunction(@DERToDERNCharset, 'DERToDERNCharset', cdRegister);
 S.RegisterDelphiFunction(@DERExtractwebSite, 'DERExtractwebSite', cdRegister);
 S.RegisterDelphiFunction(@DERExtractWebMail, 'DERExtractWebMail', cdRegister);
 S.RegisterDelphiFunction(@DERExtractPhoneNr, 'DERExtractPhoneNr', cdRegister);
 S.RegisterDelphiFunction(@DERExecute, 'DERExecute', cdRegister);
 S.RegisterDelphiFunction(@DERExecute1_P, 'DERExecute1', cdRegister);
 S.RegisterDelphiFunction(@RetrieveElementValue, 'RetrieveElementValue', cdRegister);
 S.RegisterDelphiFunction(@RetrieveElementValue1_P, 'RetrieveElementValue1', cdRegister);
end;

 
 
{ TPSImport_cyDERUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyDERUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyDERUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyDERUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_cyDERUtils(ri);
  RIRegister_cyDERUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
