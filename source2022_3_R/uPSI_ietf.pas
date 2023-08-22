unit uPSI_ietf;
{
for the net

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
  TPSImport_ietf = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ietf(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ietf_Routines(S: TPSExec);

procedure Register;

implementation


uses
  { tpautils
  ,vpautils
  ,dpautils
  ,fpautils
  ,gpautils}
  ietf
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ietf]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ietf(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function mime_isvalidcontenttype( const s : shortstring) : boolean');
 CL.AddDelphiFunction('Function langtag_isvalid( const s : string) : boolean');
 CL.AddDelphiFunction('Function langtag_split( const s : string; var primary, sub : string) : boolean');
 CL.AddConstantN('URI_START_DELIMITER_CHAR','String').SetString( '<');
 CL.AddConstantN('URI_END_DELIMITER_CHAR','String').SetString( '>');
 CL.AddConstantN('URI_SCHEME_NAME_EMAIL','String').SetString( 'mailto');
 CL.AddConstantN('URI_SCHEME_SEPARATOR','String').SetString( ':');
 CL.AddDelphiFunction('Function uri_split( url : string; var scheme, authority, path, query : string) : boolean');
 CL.AddDelphiFunction('Function urn_isvalid( s : shortstring) : boolean');
 CL.AddDelphiFunction('Function urn_isvalidnid( nid : string) : boolean');
 CL.AddDelphiFunction('Function urn_split( urn : string; var urnidstr, nidstr, nssstr : string) : boolean');
 CL.AddDelphiFunction('Function urn_pathsplit( path : string; var namespace, nss : string) : boolean');
 CL.AddDelphiFunction('Function http_pathsplit( path : string; var directory, name : string) : boolean');
 CL.AddDelphiFunction('Function file_pathsplit( path : string; var directory, name : string) : boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ietf_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@mime_isvalidcontenttype, 'mime_isvalidcontenttype', cdRegister);
 S.RegisterDelphiFunction(@langtag_isvalid, 'langtag_isvalid', cdRegister);
 S.RegisterDelphiFunction(@langtag_split, 'langtag_split', cdRegister);
 S.RegisterDelphiFunction(@uri_split, 'uri_split', cdRegister);
 S.RegisterDelphiFunction(@urn_isvalid, 'urn_isvalid', cdRegister);
 S.RegisterDelphiFunction(@urn_isvalidnid, 'urn_isvalidnid', cdRegister);
 S.RegisterDelphiFunction(@urn_split, 'urn_split', cdRegister);
 S.RegisterDelphiFunction(@urn_pathsplit, 'urn_pathsplit', cdRegister);
 S.RegisterDelphiFunction(@http_pathsplit, 'http_pathsplit', cdRegister);
 S.RegisterDelphiFunction(@file_pathsplit, 'file_pathsplit', cdRegister);
end;

 
 
{ TPSImport_ietf }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ietf.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ietf(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ietf.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ietf_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
