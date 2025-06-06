unit uPSI_xercesxmldom;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_xercesxmldom = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TXercesDOMImplementationFactory(CL: TPSPascalCompiler);
procedure SIRegister_xercesxmldom(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TXercesDOMImplementationFactory(CL: TPSRuntimeClassImporter);
procedure RIRegister_xercesxmldom(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   xmldom
  ,xercesxmldom
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xercesxmldom]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXercesDOMImplementationFactory(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDOMVendor', 'TXercesDOMImplementationFactory') do
  with CL.AddClassN(CL.FindClass('TDOMVendor'),'TXercesDOMImplementationFactory') do
  begin
    RegisterMethod('Constructor Create( const ADesc, ALibName : string)');
    RegisterMethod('Function DOMImplementation : IDOMImplementation');
    RegisterMethod('Function Description : String');
    RegisterMethod('Procedure EnablePreserveWhitespace( Value : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_xercesxmldom(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('SXercesXML','String').SetString( 'Xerces XML');
  SIRegister_TXercesDOMImplementationFactory(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TXercesDOMImplementationFactory(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXercesDOMImplementationFactory) do
  begin
    RegisterConstructor(@TXercesDOMImplementationFactory.Create, 'Create');
    RegisterMethod(@TXercesDOMImplementationFactory.DOMImplementation, 'DOMImplementation');
    RegisterMethod(@TXercesDOMImplementationFactory.Description, 'Description');
    RegisterMethod(@TXercesDOMImplementationFactory.EnablePreserveWhitespace, 'EnablePreserveWhitespace');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xercesxmldom(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TXercesDOMImplementationFactory(CL);
end;

 
 
{ TPSImport_xercesxmldom }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xercesxmldom.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xercesxmldom(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xercesxmldom.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_xercesxmldom(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
