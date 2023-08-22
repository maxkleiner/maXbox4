unit uPSI_SRMgr;
{
   res exchange
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
  TPSImport_SRMgr = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TpsStringResource(CL: TPSPascalCompiler);
procedure SIRegister_SRMgr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TpsStringResource(CL: TPSRuntimeClassImporter);
procedure RIRegister_SRMgr(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,WinProcs
  ,WinTypes
  ,SRMgr
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SRMgr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TpsStringResource(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TpsStringResource') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TpsStringResource') do begin
    RegisterMethod('Constructor Create( Instance : THandle; const ResourceName : string)');
    RegisterMethod('Procedure ChangeResource( Instance : THandle; const ResourceName : string)');
    RegisterMethod('Function GetAsciiZ( Ident : TInt32; Buffer : PChar; BufChars : Integer) : PChar');
    RegisterMethod('Function GetString( Ident : TInt32) : string');
    RegisterProperty('Strings', 'string TInt32', iptr);
    SetDefaultPropery('Strings');
    RegisterMethod('Function GetWideChar( Ident : TInt32; Buffer : PWideChar; BufChars : Integer) : PWideChar');
    RegisterProperty('ReportError', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SRMgr(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('DefReportError','Boolean')BoolToStr( False);
  CL.AddClassN(CL.FindClass('TOBJECT'),'ETpsStringResourceError');
  CL.AddTypeS('TInt32', 'Integer');
  CL.AddTypeS('TInt32', 'LongInt');
  CL.AddTypeS('PIndexRec', '^TIndexRec // will not work');
  CL.AddTypeS('TIndexRec', 'record id : TInt32; ofs : TInt32; len : TInt32; end');
  CL.AddTypeS('PResourceRec', '^TResourceRec // will not work');
  SIRegister_TpsStringResource(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TpsStringResourceReportError_W(Self: TpsStringResource; const T: Boolean);
begin Self.ReportError := T; end;

(*----------------------------------------------------------------------------*)
procedure TpsStringResourceReportError_R(Self: TpsStringResource; var T: Boolean);
begin T := Self.ReportError; end;

(*----------------------------------------------------------------------------*)
procedure TpsStringResourceStrings_R(Self: TpsStringResource; var T: string; const t1: TInt32);
begin T := Self.Strings[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TpsStringResource(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TpsStringResource) do begin
    RegisterConstructor(@TpsStringResource.Create, 'Create');
    RegisterMethod(@TpsStringResource.ChangeResource, 'ChangeResource');
    RegisterMethod(@TpsStringResource.GetAsciiZ, 'GetAsciiZ');
    RegisterMethod(@TpsStringResource.GetString, 'GetString');
    RegisterPropertyHelper(@TpsStringResourceStrings_R,nil,'Strings');
    RegisterMethod(@TpsStringResource.GetWideChar, 'GetWideChar');
    RegisterPropertyHelper(@TpsStringResourceReportError_R,@TpsStringResourceReportError_W,'ReportError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SRMgr(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ETpsStringResourceError) do
  RIRegister_TpsStringResource(CL);
end;

 
 
{ TPSImport_SRMgr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SRMgr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SRMgr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SRMgr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SRMgr(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
