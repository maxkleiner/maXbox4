unit uPSI_HtmlHelpViewer;
{
   link to intf obj
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
  TPSImport_HtmlHelpViewer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IHtmlHelpTester(CL: TPSPascalCompiler);
procedure SIRegister_HtmlHelpViewer(CL: TPSPascalCompiler);

{ run-time registration functions }

procedure Register;

implementation


uses
   HtmlHelpViewer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_HtmlHelpViewer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IHtmlHelpTester(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IInterface', 'IHtmlHelpTester') do
  with CL.AddInterface(CL.FindInterface('IInterface'),IHtmlHelpTester, 'IHtmlHelpTester') do
  begin
    RegisterMethod('Function CanShowALink( const ALink, FileName : String) : Boolean', cdRegister);
    RegisterMethod('Function CanShowTopic( const Topic, FileName : String) : Boolean', cdRegister);
    RegisterMethod('Function CanShowContext( const Context : Integer; const FileName : String) : Boolean', cdRegister);
    RegisterMethod('Function GetHelpStrings( const ALink : String) : TStringList', cdRegister);
    RegisterMethod('Function GetHelpPath : String', cdRegister);
    RegisterMethod('Function GetDefaultHelpFile : String', cdRegister);
    RegisterMethod('Function ConvertWinHelp( var Command : Word; var Data : LongInt) : Boolean', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_HtmlHelpViewer(CL: TPSPascalCompiler);
begin
  SIRegister_IHtmlHelpTester(CL);
end;

(* === run-time registration functions === *)
 
 
{ TPSImport_HtmlHelpViewer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_HtmlHelpViewer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_HtmlHelpViewer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_HtmlHelpViewer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
end;
(*----------------------------------------------------------------------------*)
 
 
end.
