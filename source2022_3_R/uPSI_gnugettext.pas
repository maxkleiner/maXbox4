unit uPSI_gnugettext;
{
  gnu4you
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
  TPSImport_gnugettext = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TGnuGettextInstance(CL: TPSPascalCompiler);
procedure SIRegister_TExecutable(CL: TPSPascalCompiler);
procedure SIRegister_gnugettext(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TGnuGettextInstance(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExecutable(CL: TPSRuntimeClassImporter);
procedure RIRegister_gnugettext_Routines(S: TPSExec);

procedure Register;

implementation


uses
   TypInfo
  ,gnugettext
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_gnugettext]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGnuGettextInstance(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TGnuGettextInstance') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TGnuGettextInstance') do begin
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure UseLanguage( LanguageCode : string)');
    RegisterMethod('Function gettext( const szMsgId : widestring) : widestring');
    RegisterMethod('Function ngettext( const singular, plural : widestring; Number : longint) : widestring');
    RegisterMethod('Function GetCurrentLanguage : string');
    RegisterMethod('Function GetTranslationProperty( Propertyname : string) : WideString');
    RegisterMethod('Function GetTranslatorNameAndEmail : widestring');
    RegisterMethod('Procedure TP_Ignore( AnObject : TObject; const name : string)');
    RegisterMethod('Procedure TP_GlobalIgnoreClass( IgnClass : TClass)');
    RegisterMethod('Procedure TP_GlobalIgnoreClassProperty( IgnClass : TClass; propertyname : string)');
    RegisterMethod('Procedure TP_GlobalHandleClass( HClass : TClass; Handler : TTranslator)');
    RegisterMethod('Function TP_CreateRetranslator : TExecutable');
    RegisterMethod('Procedure TranslateProperties( AnObject : TObject; textdomain : string)');
    RegisterMethod('Procedure TranslateComponent( AnObject : TComponent; TextDomain : string)');
    RegisterMethod('Function dgettext( const szDomain : string; const szMsgId : widestring) : widestring');
    RegisterMethod('Function dngettext( const szDomain, singular, plural : widestring; Number : longint) : widestring');
    RegisterMethod('Procedure textdomain( const szDomain : string)');
    RegisterMethod('Function getcurrenttextdomain : string');
    RegisterMethod('Procedure bindtextdomain( const szDomain : string; const szDirectory : string)');
    RegisterMethod('Procedure SaveUntranslatedMsgids( filename : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExecutable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TExecutable') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TExecutable') do begin
    RegisterMethod('Procedure Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_gnugettext(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function _( const szMsgId : widestring) : widestring');
 CL.AddDelphiFunction('Function gettext( const szMsgId : widestring) : widestring');
 CL.AddDelphiFunction('Procedure TranslateComponent( AnObject : TComponent; TextDomain : string)');
 CL.AddDelphiFunction('Procedure AddDomainForResourceString( domain : string)');
 CL.AddDelphiFunction('Procedure UseLanguage( LanguageCode : string)');
 //CL.AddDelphiFunction('Function LoadResString( ResStringRec : PResStringRec) : widestring');
 //CL.AddDelphiFunction('Function LoadResStringA( ResStringRec : PResStringRec) : ansistring');
 //CL.AddDelphiFunction('Function LoadResStringW( ResStringRec : PResStringRec) : widestring');
 CL.AddDelphiFunction('Function GetTranslatorNameAndEmail : widestring');
 CL.AddConstantN('DefaultTextDomain','String').SetString( 'default');
 //CL.AddConstantN('RuntimePackageSupportEnabled','Boolean')BoolToStr( false);
 CL.AddDelphiFunction('Procedure TP_Ignore( AnObject : TObject; const name : string)');
 //CL.AddDelphiFunction('Procedure TP_GlobalIgnoreClass( IgnClass : TClass)');
 //CL.AddDelphiFunction('Procedure TP_GlobalIgnoreClassProperty( IgnClass : TClass; propertyname : string)');
  CL.AddTypeS('TTranslator', 'Procedure ( obj : TObject)');
 //CL.AddDelphiFunction('Procedure TP_GlobalHandleClass( HClass : TClass; Handler : TTranslator)');
 CL.AddDelphiFunction('Procedure TranslateProperties( AnObject : TObject; TextDomain : string)');
 CL.AddDelphiFunction('Function LoadDLLifPossible( dllname : string) : boolean');
 CL.AddDelphiFunction('Function GetCurrentLanguage : string');
 CL.AddDelphiFunction('Function dgettext( const szDomain : string; const szMsgId : widestring) : widestring');
 CL.AddDelphiFunction('Function dngettext( const szDomain : string; const singular, plural : widestring; Number : longint) : widestring');
 CL.AddDelphiFunction('Function ngettext( const singular, plural : widestring; Number : longint) : widestring');
 CL.AddDelphiFunction('Procedure textdomain( const szDomain : string)');
 CL.AddDelphiFunction('Function getcurrenttextdomain : string');
 CL.AddDelphiFunction('Procedure bindtextdomain( const szDomain : string; const szDirectory : string)');
  SIRegister_TExecutable(CL);
  SIRegister_TGnuGettextInstance(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TGnuGettextInstanceEnabled_W(Self: TGnuGettextInstance; const T: Boolean);
Begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TGnuGettextInstanceEnabled_R(Self: TGnuGettextInstance; var T: Boolean);
Begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGnuGettextInstance(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGnuGettextInstance) do
  begin
    RegisterPropertyHelper(@TGnuGettextInstanceEnabled_R,@TGnuGettextInstanceEnabled_W,'Enabled');
    RegisterConstructor(@TGnuGettextInstance.Create, 'Create');
         RegisterMethod(@TGnuGettextInstance.Destroy, 'Free');
      RegisterMethod(@TGnuGettextInstance.UseLanguage, 'UseLanguage');
    RegisterMethod(@TGnuGettextInstance.gettext, 'gettext');
    RegisterMethod(@TGnuGettextInstance.ngettext, 'ngettext');
    RegisterMethod(@TGnuGettextInstance.GetCurrentLanguage, 'GetCurrentLanguage');
    RegisterMethod(@TGnuGettextInstance.GetTranslationProperty, 'GetTranslationProperty');
    RegisterMethod(@TGnuGettextInstance.GetTranslatorNameAndEmail, 'GetTranslatorNameAndEmail');
    RegisterMethod(@TGnuGettextInstance.TP_Ignore, 'TP_Ignore');
    RegisterMethod(@TGnuGettextInstance.TP_GlobalIgnoreClass, 'TP_GlobalIgnoreClass');
    RegisterMethod(@TGnuGettextInstance.TP_GlobalIgnoreClassProperty, 'TP_GlobalIgnoreClassProperty');
    RegisterMethod(@TGnuGettextInstance.TP_GlobalHandleClass, 'TP_GlobalHandleClass');
    //RegisterMethod(@TGnuGettextInstance.TP_CreateRetranslator, 'TP_CreateRetranslator');
    RegisterMethod(@TGnuGettextInstance.TranslateProperties, 'TranslateProperties');
    RegisterMethod(@TGnuGettextInstance.TranslateComponent, 'TranslateComponent');
    RegisterMethod(@TGnuGettextInstance.dgettext, 'dgettext');
    RegisterMethod(@TGnuGettextInstance.dngettext, 'dngettext');
    RegisterMethod(@TGnuGettextInstance.textdomain, 'textdomain');
    RegisterMethod(@TGnuGettextInstance.getcurrenttextdomain, 'getcurrenttextdomain');
    RegisterMethod(@TGnuGettextInstance.bindtextdomain, 'bindtextdomain');
    //RegisterMethod(@TGnuGettextInstance.SaveUntranslatedMsgids, 'SaveUntranslatedMsgids');
  end;
   // RIRegister_TGnuGettextInstance(CL);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExecutable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExecutable) do begin
    //RegisterVirtualAbstractMethod(@TExecutable, @!.Execute, 'Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_gnugettext_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@_, '_', cdRegister);
 S.RegisterDelphiFunction(@gettext, 'gettext', cdRegister);
 S.RegisterDelphiFunction(@TranslateComponent, 'TranslateComponent', cdRegister);
 S.RegisterDelphiFunction(@AddDomainForResourceString, 'AddDomainForResourceString', cdRegister);
 S.RegisterDelphiFunction(@UseLanguage, 'UseLanguage', cdRegister);
 S.RegisterDelphiFunction(@LoadResString, 'LoadResString', cdRegister);
 S.RegisterDelphiFunction(@LoadResStringA, 'LoadResStringA', cdRegister);
 S.RegisterDelphiFunction(@LoadResStringW, 'LoadResStringW', cdRegister);
 S.RegisterDelphiFunction(@GetTranslatorNameAndEmail, 'GetTranslatorNameAndEmail', cdRegister);
 S.RegisterDelphiFunction(@TP_Ignore, 'TP_Ignore', cdRegister);
 S.RegisterDelphiFunction(@TP_GlobalIgnoreClass, 'TP_GlobalIgnoreClass', cdRegister);
 S.RegisterDelphiFunction(@TP_GlobalIgnoreClassProperty, 'TP_GlobalIgnoreClassProperty', cdRegister);
 S.RegisterDelphiFunction(@TP_GlobalHandleClass, 'TP_GlobalHandleClass', cdRegister);
 S.RegisterDelphiFunction(@TranslateProperties, 'TranslateProperties', cdRegister);
 S.RegisterDelphiFunction(@LoadDLLifPossible, 'LoadDLLifPossible', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentLanguage, 'GetCurrentLanguage', cdRegister);
 S.RegisterDelphiFunction(@dgettext, 'dgettext', cdRegister);
 S.RegisterDelphiFunction(@dngettext, 'dngettext', cdRegister);
 S.RegisterDelphiFunction(@ngettext, 'ngettext', cdRegister);
 S.RegisterDelphiFunction(@textdomain, 'textdomain', cdRegister);
 S.RegisterDelphiFunction(@getcurrenttextdomain, 'getcurrenttextdomain', cdRegister);
 S.RegisterDelphiFunction(@bindtextdomain, 'bindtextdomain', cdRegister);
  //RIRegister_TExecutable(CL);
  //RIRegister_TGnuGettextInstance(CL);
end;



{ TPSImport_gnugettext }
(*----------------------------------------------------------------------------*)
procedure TPSImport_gnugettext.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_gnugettext(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_gnugettext.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_gnugettext_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
