unit uPSI_xrtl_util_FileVersion;
{
  filebox utils

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
  TPSImport_xrtl_util_FileVersion = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TXRTLFileVersion(CL: TPSPascalCompiler);
procedure SIRegister_xrtl_util_FileVersion(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TXRTLFileVersion(CL: TPSRuntimeClassImporter);
procedure RIRegister_xrtl_util_FileVersion(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   xrtl_util_FileVersion
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_util_FileVersion]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLFileVersion(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TXRTLFileVersion') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TXRTLFileVersion') do begin
    RegisterMethod('Constructor Create( const AFileName : string; ALanguage : Integer; ACharset : Integer)');
    RegisterMethod('Procedure Free');
    RegisterProperty('FileName', 'string', iptr);
    RegisterProperty('FileVersion', 'TXRTLNumberVersionInfo', iptr);
    RegisterProperty('FileVersionString', 'string', iptr);
    RegisterProperty('ProductVersion', 'TXRTLNumberVersionInfo', iptr);
    RegisterProperty('ProductVersionString', 'string', iptr);
    RegisterProperty('FileType', 'TXRTLFileType', iptr);
    RegisterProperty('FileSubType', 'Integer', iptr);
    RegisterProperty('DateTime', 'TDateTime', iptr);
    RegisterProperty('Debug', 'Boolean', iptr);
    RegisterProperty('Patched', 'Boolean', iptr);
    RegisterProperty('PreRelease', 'Boolean', iptr);
    RegisterProperty('PrivateBuild', 'Boolean', iptr);
    RegisterProperty('SpecialBuild', 'Boolean', iptr);
    RegisterProperty('InfoInferred', 'Boolean', iptr);
    RegisterProperty('OS', 'Integer', iptr);
    RegisterProperty('VersionString', 'string string', iptr);
    RegisterProperty('Language', 'Integer', iptrw);
    RegisterProperty('Charset', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_util_FileVersion(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('fvsComments','String').SetString( 'Comments');
 CL.AddConstantN('fvsCompanyName','String').SetString( 'CompanyName');
 CL.AddConstantN('fvsFileDescription','String').SetString( 'FileDescription');
 CL.AddConstantN('fvsFileVersion','String').SetString( 'FileVersion');
 CL.AddConstantN('fvsInternalName','String').SetString( 'InternalName');
 CL.AddConstantN('fvsLegalCopyright','String').SetString( 'LegalCopyright');
 CL.AddConstantN('fvsLegalTrademarks','String').SetString( 'LegalTrademarks');
 CL.AddConstantN('fvsOriginalFilename','String').SetString( 'OriginalFilename');
 CL.AddConstantN('fvsPrivateBuild','String').SetString( 'PrivateBuild');
 CL.AddConstantN('fvsProductName','String').SetString( 'ProductName');
 CL.AddConstantN('fvsProductVersion','String').SetString( 'ProductVersion');
 CL.AddConstantN('fvsSpecialBuild','String').SetString( 'SpecialBuild');
  CL.AddTypeS('TXRTLNumberVersionInfoIndex', '( viMajor, viMinor, viRelease, viBuild )');
  CL.AddTypeS('TXRTLFileType', '( ftUnknown, ftApplication, ftDLL, ftDriver, ftFont, ftVXD, ftStaticLibrary )');
  SIRegister_TXRTLFileVersion(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionCharset_W(Self: TXRTLFileVersion; const T: Integer);
begin Self.Charset := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionCharset_R(Self: TXRTLFileVersion; var T: Integer);
begin T := Self.Charset; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionLanguage_W(Self: TXRTLFileVersion; const T: Integer);
begin Self.Language := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionLanguage_R(Self: TXRTLFileVersion; var T: Integer);
begin T := Self.Language; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionVersionString_R(Self: TXRTLFileVersion; var T: string; const t1: string);
begin T := Self.VersionString[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionOS_R(Self: TXRTLFileVersion; var T: Integer);
begin T := Self.OS; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionInfoInferred_R(Self: TXRTLFileVersion; var T: Boolean);
begin T := Self.InfoInferred; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionSpecialBuild_R(Self: TXRTLFileVersion; var T: Boolean);
begin T := Self.SpecialBuild; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionPrivateBuild_R(Self: TXRTLFileVersion; var T: Boolean);
begin T := Self.PrivateBuild; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionPreRelease_R(Self: TXRTLFileVersion; var T: Boolean);
begin T := Self.PreRelease; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionPatched_R(Self: TXRTLFileVersion; var T: Boolean);
begin T := Self.Patched; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionDebug_R(Self: TXRTLFileVersion; var T: Boolean);
begin T := Self.Debug; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionDateTime_R(Self: TXRTLFileVersion; var T: TDateTime);
begin T := Self.DateTime; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionFileSubType_R(Self: TXRTLFileVersion; var T: Integer);
begin T := Self.FileSubType; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionFileType_R(Self: TXRTLFileVersion; var T: TXRTLFileType);
begin T := Self.FileType; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionProductVersionString_R(Self: TXRTLFileVersion; var T: string);
begin T := Self.ProductVersionString; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionProductVersion_R(Self: TXRTLFileVersion; var T: TXRTLNumberVersionInfo);
begin T := Self.ProductVersion; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionFileVersionString_R(Self: TXRTLFileVersion; var T: string);
begin T := Self.FileVersionString; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionFileVersion_R(Self: TXRTLFileVersion; var T: TXRTLNumberVersionInfo);
begin T := Self.FileVersion; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLFileVersionFileName_R(Self: TXRTLFileVersion; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLFileVersion(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLFileVersion) do begin
    RegisterConstructor(@TXRTLFileVersion.Create, 'Create');
    RegisterMethod(@TXRTLFileVersion.Destroy, 'Free');
    RegisterPropertyHelper(@TXRTLFileVersionFileName_R,nil,'FileName');
    RegisterPropertyHelper(@TXRTLFileVersionFileVersion_R,nil,'FileVersion');
    RegisterPropertyHelper(@TXRTLFileVersionFileVersionString_R,nil,'FileVersionString');
    RegisterPropertyHelper(@TXRTLFileVersionProductVersion_R,nil,'ProductVersion');
    RegisterPropertyHelper(@TXRTLFileVersionProductVersionString_R,nil,'ProductVersionString');
    RegisterPropertyHelper(@TXRTLFileVersionFileType_R,nil,'FileType');
    RegisterPropertyHelper(@TXRTLFileVersionFileSubType_R,nil,'FileSubType');
    RegisterPropertyHelper(@TXRTLFileVersionDateTime_R,nil,'DateTime');
    RegisterPropertyHelper(@TXRTLFileVersionDebug_R,nil,'Debug');
    RegisterPropertyHelper(@TXRTLFileVersionPatched_R,nil,'Patched');
    RegisterPropertyHelper(@TXRTLFileVersionPreRelease_R,nil,'PreRelease');
    RegisterPropertyHelper(@TXRTLFileVersionPrivateBuild_R,nil,'PrivateBuild');
    RegisterPropertyHelper(@TXRTLFileVersionSpecialBuild_R,nil,'SpecialBuild');
    RegisterPropertyHelper(@TXRTLFileVersionInfoInferred_R,nil,'InfoInferred');
    RegisterPropertyHelper(@TXRTLFileVersionOS_R,nil,'OS');
    RegisterPropertyHelper(@TXRTLFileVersionVersionString_R,nil,'VersionString');
    RegisterPropertyHelper(@TXRTLFileVersionLanguage_R,@TXRTLFileVersionLanguage_W,'Language');
    RegisterPropertyHelper(@TXRTLFileVersionCharset_R,@TXRTLFileVersionCharset_W,'Charset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_FileVersion(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TXRTLFileVersion(CL);
end;

 
 
{ TPSImport_xrtl_util_FileVersion }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_FileVersion.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_util_FileVersion(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_FileVersion.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_xrtl_util_FileVersion(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
