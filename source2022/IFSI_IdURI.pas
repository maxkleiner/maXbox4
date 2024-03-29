unit IFSI_IdURI;
{
This file has been generated by UnitParser v0.6, written by M. Knight
and updated by NP. v/d Spek.
}
//{$I PascalScript.inc}
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
  TPSImport_IdURI = class(TPSPlugin)
  protected
    procedure CompOnUses(CompExec: TPSScript); override;
    procedure ExecOnUses(CompExec: TPSScript); override;
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure CompileImport2(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
    procedure ExecImport2(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 

{ compile-time registration functions }
procedure SIRegister_TIdURI(CL: TPSPascalCompiler);
procedure SIRegister_IdURI(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdURI(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdURI(CL: TPSRuntimeClassImporter);



implementation


uses
   IdException
  ,IdURI
  ;
 
 
{ compile-time importer function }
(*----------------------------------------------------------------------------
 Sometimes the CL.AddClassN() fails to correctly register a class, 
 for unknown (at least to me) reasons
 So, you may use the below RegClassS() replacing the CL.AddClassN()
 of the various SIRegister_XXXX calls 
 ----------------------------------------------------------------------------*)
function RegClassS(CL: TPSPascalCompiler; const InheritsFrom, Classname: string): TPSCompileTimeClass;
begin
  Result := CL.FindClass(Classname);
  if Result = nil then
    Result := CL.AddClassN(CL.FindClass(InheritsFrom), Classname)
  else Result.ClassInheritsFrom := CL.FindClass(InheritsFrom);
end;
  
  
(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdURI(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TIdURI') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TIdURI') do begin
    RegisterMethod('Constructor Create(const AURI : string)');
    RegisterMethod('Function GetFullURI( const AOptionalFileds : TIdURIOptionalFieldsSet) : String');
    RegisterMethod('Procedure NormalizePath( var APath : string)');
    RegisterMethod('Function URLDecode( ASrc : string) : string');
    RegisterMethod('Function URLEncode( const ASrc : string) : string');
    RegisterMethod('Function ParamsEncode( const ASrc : string) : string');
    RegisterMethod('Function PathEncode( const ASrc : string) : string');
    RegisterProperty('Bookmark', 'string', iptrw);
    RegisterProperty('Document', 'string', iptrw);
    RegisterProperty('Host', 'string', iptrw);
    RegisterProperty('Password', 'string', iptrw);
    RegisterProperty('Path', 'string', iptrw);
    RegisterProperty('Params', 'string', iptrw);
    RegisterProperty('Port', 'string', iptrw);
    RegisterProperty('Protocol', 'string', iptrw);
    RegisterProperty('URI', 'string', iptrw);
    RegisterProperty('Username', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdURI(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIdURIOptionalFields', '( ofAuthInfo, ofBookmark )');
  CL.AddTypeS('TIdURIOptionalFieldsSet', 'set of TIdURIOptionalFields');
  SIRegister_TIdURI(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdURIException');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdURIUsername_W(Self: TIdURI; const T: string);
begin Self.Username := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIUsername_R(Self: TIdURI; var T: string);
begin T := Self.Username; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIURI_W(Self: TIdURI; const T: string);
begin Self.URI := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIURI_R(Self: TIdURI; var T: string);
begin T := Self.URI; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIProtocol_W(Self: TIdURI; const T: string);
begin Self.Protocol := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIProtocol_R(Self: TIdURI; var T: string);
begin T := Self.Protocol; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIPort_W(Self: TIdURI; const T: string);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIPort_R(Self: TIdURI; var T: string);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIParams_W(Self: TIdURI; const T: string);
begin Self.Params := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIParams_R(Self: TIdURI; var T: string);
begin T := Self.Params; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIPath_W(Self: TIdURI; const T: string);
begin Self.Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIPath_R(Self: TIdURI; var T: string);
begin T := Self.Path; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIPassword_W(Self: TIdURI; const T: string);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIPassword_R(Self: TIdURI; var T: string);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIHost_W(Self: TIdURI; const T: string);
begin Self.Host := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIHost_R(Self: TIdURI; var T: string);
begin T := Self.Host; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIDocument_W(Self: TIdURI; const T: string);
begin Self.Document := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIDocument_R(Self: TIdURI; var T: string);
begin T := Self.Document; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIBookmark_W(Self: TIdURI; const T: string);
begin Self.Bookmark := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdURIBookmark_R(Self: TIdURI; var T: string);
begin T := Self.Bookmark; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdURI(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdURI) do begin
    RegisterConstructor(@TIdURI.Create, 'Create');
    RegisterMethod(@TIdURI.GetFullURI, 'GetFullURI');
    RegisterMethod(@TIdURI.NormalizePath, 'NormalizePath');
    RegisterMethod(@TIdURI.URLDecode, 'URLDecode');
    RegisterMethod(@TIdURI.URLEncode, 'URLEncode');
    RegisterMethod(@TIdURI.ParamsEncode, 'ParamsEncode');
    RegisterMethod(@TIdURI.PathEncode, 'PathEncode');
    RegisterPropertyHelper(@TIdURIBookmark_R,@TIdURIBookmark_W,'Bookmark');
    RegisterPropertyHelper(@TIdURIDocument_R,@TIdURIDocument_W,'Document');
    RegisterPropertyHelper(@TIdURIHost_R,@TIdURIHost_W,'Host');
    RegisterPropertyHelper(@TIdURIPassword_R,@TIdURIPassword_W,'Password');
    RegisterPropertyHelper(@TIdURIPath_R,@TIdURIPath_W,'Path');
    RegisterPropertyHelper(@TIdURIParams_R,@TIdURIParams_W,'Params');
    RegisterPropertyHelper(@TIdURIPort_R,@TIdURIPort_W,'Port');
    RegisterPropertyHelper(@TIdURIProtocol_R,@TIdURIProtocol_W,'Protocol');
    RegisterPropertyHelper(@TIdURIURI_R,@TIdURIURI_W,'URI');
    RegisterPropertyHelper(@TIdURIUsername_R,@TIdURIUsername_W,'Username');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdURI(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdURI(CL);
  with CL.Add(EIdURIException) do
end;

 
 
{ TPSImport_IdURI }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdURI.CompOnUses(CompExec: TPSScript);
begin
  { nothing } 
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdURI.ExecOnUses(CompExec: TPSScript);
begin
  { nothing } 
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdURI.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdURI(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdURI.CompileImport2(CompExec: TPSScript);
begin
  { nothing } 
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdURI.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdURI(ri);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdURI.ExecImport2(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  { nothing } 
end;
 
 
end.
