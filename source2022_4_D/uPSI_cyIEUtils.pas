unit uPSI_cyIEUtils;
{
   ieutils
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
  TPSImport_cyIEUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cyIEUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cyIEUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Graphics
  ,Windows
  ,Registry
  ,cyIEUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyIEUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cyIEUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TwbPageSetup', 'record font : String; footer : String; header : '
   +'String; margin_bottom : String; margin_left : String; margin_right : Strin'
   +'g; margin_top : String; Print_Background : String; Shrink_To_Fit : String; end');
 CL.AddDelphiFunction('Function cyURLEncode( const S : string) : string');
 CL.AddDelphiFunction('Function MakeResourceURL( const ModuleName : string; const ResName : PChar; const ResType : PChar) : string;');
 CL.AddDelphiFunction('Function MakeResourceURL1( const Module : HMODULE; const ResName : PChar; const ResType : PChar) : string;');
 CL.AddDelphiFunction('Function cyColorToHtml( aColor : TColor) : String');
 CL.AddDelphiFunction('Function HtmlToColor( aHtmlColor : String) : TColor');
 //CL.AddDelphiFunction('Function GetStreamEncoding( aStream : TStream) : TEncoding');
 // CL.AddDelphiFunction('Function IsStreamEncodedWith( aStream : TStream; Encoding : TEncoding) : Boolean');
 CL.AddDelphiFunction('Function AddHtmlUnicodePrefix( aHtml : String) : String');
 CL.AddDelphiFunction('Function RemoveHtmlUnicodePrefix( aHtml : String) : String');
 CL.AddDelphiFunction('Procedure GetPageSetupFromRegistry( var awbPageSetup : TwbPageSetup)');
 CL.AddDelphiFunction('Procedure SetPageSetupToRegistry( awbPageSetup : TwbPageSetup)');
 CL.AddConstantN('IEBodyBorderless','String').SetString( 'none');
 CL.AddConstantN('IEBodySingleBorder','String').SetString( '');
 CL.AddConstantN('IEDesignModeOn','String').SetString( 'On');
 CL.AddConstantN('IEDesignModeOff','String').SetString( 'Off');
 CL.AddConstantN('cHtmlUnicodePrefixChar','Char').SetString( #$FEFF);
 CL.AddConstantN('cHtmlUnicodePrefixChar','Char').SetString( #$FE);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function MakeResourceURL1_P( const Module : HMODULE; const ResName : PChar; const ResType : PChar) : string;
Begin Result := cyIEUtils.MakeResourceURL(Module, ResName, ResType); END;

(*----------------------------------------------------------------------------*)
Function MakeResourceURL_P( const ModuleName : string; const ResName : PChar; const ResType : PChar) : string;
Begin Result := cyIEUtils.MakeResourceURL(ModuleName, ResName, ResType); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyIEUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@URLEncode, 'cyURLEncode', cdRegister);
 S.RegisterDelphiFunction(@MakeResourceURL, 'MakeResourceURL', cdRegister);
 S.RegisterDelphiFunction(@MakeResourceURL1_P, 'MakeResourceURL1', cdRegister);
 S.RegisterDelphiFunction(@ColorToHtml, 'cyColorToHtml', cdRegister);
 S.RegisterDelphiFunction(@HtmlToColor, 'HtmlToColor', cdRegister);
 //S.RegisterDelphiFunction(@GetStreamEncoding, 'GetStreamEncoding', cdRegister);
 //S.RegisterDelphiFunction(@IsStreamEncodedWith, 'IsStreamEncodedWith', cdRegister);
 S.RegisterDelphiFunction(@AddHtmlUnicodePrefix, 'AddHtmlUnicodePrefix', cdRegister);
 S.RegisterDelphiFunction(@RemoveHtmlUnicodePrefix, 'RemoveHtmlUnicodePrefix', cdRegister);
 S.RegisterDelphiFunction(@GetPageSetupFromRegistry, 'GetPageSetupFromRegistry', cdRegister);
 S.RegisterDelphiFunction(@SetPageSetupToRegistry, 'SetPageSetupToRegistry', cdRegister);
end;

 
 
{ TPSImport_cyIEUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyIEUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyIEUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyIEUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_cyIEUtils(ri);
  RIRegister_cyIEUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
