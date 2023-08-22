unit uPSI_XmlDocRssParser;
{
it has a functional and a interfaces access!

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
  TPSImport_XmlDocRssParser = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TXmlDocRssParser(CL: TPSPascalCompiler);
procedure SIRegister_XmlDocRssParser(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TXmlDocRssParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_XmlDocRssParser(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  RssParser
  ,RssModel
  ,XmlDocRssParser
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_XmlDocRssParser]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXmlDocRssParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TXmlDocRssParser') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TXmlDocRssParser') do
  begin
    RegisterMethod('Function ParseRSSDate( DateStr : string) : TDateTime');
    RegisterMethod('Function ParseRSSFeed( XML : string) : TRSSFeed');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_XmlDocRssParser(CL: TPSPascalCompiler);
begin
  SIRegister_TXmlDocRssParser(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TXmlDocRssParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXmlDocRssParser) do
  begin
    RegisterMethod(@TXmlDocRssParser.ParseRSSDate, 'ParseRSSDate');
    RegisterMethod(@TXmlDocRssParser.ParseRSSFeed, 'ParseRSSFeed');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_XmlDocRssParser(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TXmlDocRssParser(CL);
end;

 
 
{ TPSImport_XmlDocRssParser }
(*----------------------------------------------------------------------------*)
procedure TPSImport_XmlDocRssParser.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_XmlDocRssParser(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_XmlDocRssParser.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_XmlDocRssParser(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
