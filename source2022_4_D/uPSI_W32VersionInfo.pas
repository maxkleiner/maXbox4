unit uPSI_W32VersionInfo;
{
  from lazarus
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
  TPSImport_W32VersionInfo = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TProjectVersionInfo(CL: TPSPascalCompiler);
procedure SIRegister_W32VersionInfo(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_W32VersionInfo_Routines(S: TPSExec);
procedure RIRegister_TProjectVersionInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_W32VersionInfo(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Process
  //,LCLProc
  ,Controls
  ,Forms
  //,CodeToolManager
  //,CodeCache
  //,LazConf
  ,W32VersionInfo
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_W32VersionInfo]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TProjectVersionInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TProjectVersionInfo') do
  with CL.AddClassN(CL.FindClass('TObject'),'TProjectVersionInfo') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
      RegisterMethod('Function CompileRCFile( const MainFilename, TargetOS : string) : TModalResult');
    RegisterMethod('Function UpdateMainSourceFile( const AFilename : string) : TModalResult');
    RegisterProperty('Modified', 'boolean', iptrw);
    RegisterProperty('UseVersionInfo', 'boolean', iptrw);
    RegisterProperty('AutoIncrementBuild', 'boolean', iptrw);
    RegisterProperty('VersionNr', 'integer', iptrw);
    RegisterProperty('MajorRevNr', 'integer', iptrw);
    RegisterProperty('MinorRevNr', 'integer', iptrw);
    RegisterProperty('BuildNr', 'integer', iptrw);
    RegisterProperty('HexLang', 'string', iptrw);
    RegisterProperty('HexCharSet', 'string', iptrw);
    RegisterProperty('DescriptionString', 'string', iptrw);
    RegisterProperty('CopyrightString', 'string', iptrw);
    RegisterProperty('CommentsString', 'string', iptrw);
    RegisterProperty('CompanyString', 'string', iptrw);
    RegisterProperty('InternalNameString', 'string', iptrw);
    RegisterProperty('TrademarksString', 'string', iptrw);
    RegisterProperty('OriginalFilenameString', 'string', iptrw);
    RegisterProperty('ProdNameString', 'string', iptrw);
    RegisterProperty('ProductVersionString', 'string', iptrw);
    RegisterProperty('VersionInfoMessages', 'TStringList', iptr);
    RegisterProperty('OnModified', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_W32VersionInfo(CL: TPSPascalCompiler);
begin
  SIRegister_TProjectVersionInfo(CL);
 CL.AddDelphiFunction('Function MSLanguageToHex( const s : string) : string');
 CL.AddDelphiFunction('Function MSHexToLanguage( const s : string) : string');
 CL.AddDelphiFunction('Function MSCharacterSetToHex( const s : string) : string');
 CL.AddDelphiFunction('Function MSHexToCharacterSet( const s : string) : string');
 CL.AddDelphiFunction('Function MSLanguages : TStringList');
 CL.AddDelphiFunction('Function MSHexLanguages : TStringList');
 CL.AddDelphiFunction('Function MSCharacterSets : TStringList');
 CL.AddDelphiFunction('Function MSHexCharacterSets : TStringList');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoOnModified_W(Self: TProjectVersionInfo; const T: TNotifyEvent);
begin Self.OnModified := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoOnModified_R(Self: TProjectVersionInfo; var T: TNotifyEvent);
begin T := Self.OnModified; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoVersionInfoMessages_R(Self: TProjectVersionInfo; var T: TStringList);
begin T := Self.VersionInfoMessages; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoProductVersionString_W(Self: TProjectVersionInfo; const T: string);
begin Self.ProductVersionString := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoProductVersionString_R(Self: TProjectVersionInfo; var T: string);
begin T := Self.ProductVersionString; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoProdNameString_W(Self: TProjectVersionInfo; const T: string);
begin Self.ProdNameString := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoProdNameString_R(Self: TProjectVersionInfo; var T: string);
begin T := Self.ProdNameString; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoOriginalFilenameString_W(Self: TProjectVersionInfo; const T: string);
begin Self.OriginalFilenameString := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoOriginalFilenameString_R(Self: TProjectVersionInfo; var T: string);
begin T := Self.OriginalFilenameString; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoTrademarksString_W(Self: TProjectVersionInfo; const T: string);
begin Self.TrademarksString := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoTrademarksString_R(Self: TProjectVersionInfo; var T: string);
begin T := Self.TrademarksString; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoInternalNameString_W(Self: TProjectVersionInfo; const T: string);
begin Self.InternalNameString := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoInternalNameString_R(Self: TProjectVersionInfo; var T: string);
begin T := Self.InternalNameString; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoCompanyString_W(Self: TProjectVersionInfo; const T: string);
begin Self.CompanyString := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoCompanyString_R(Self: TProjectVersionInfo; var T: string);
begin T := Self.CompanyString; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoCommentsString_W(Self: TProjectVersionInfo; const T: string);
begin Self.CommentsString := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoCommentsString_R(Self: TProjectVersionInfo; var T: string);
begin T := Self.CommentsString; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoCopyrightString_W(Self: TProjectVersionInfo; const T: string);
begin Self.CopyrightString := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoCopyrightString_R(Self: TProjectVersionInfo; var T: string);
begin T := Self.CopyrightString; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoDescriptionString_W(Self: TProjectVersionInfo; const T: string);
begin Self.DescriptionString := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoDescriptionString_R(Self: TProjectVersionInfo; var T: string);
begin T := Self.DescriptionString; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoHexCharSet_W(Self: TProjectVersionInfo; const T: string);
begin Self.HexCharSet := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoHexCharSet_R(Self: TProjectVersionInfo; var T: string);
begin T := Self.HexCharSet; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoHexLang_W(Self: TProjectVersionInfo; const T: string);
begin Self.HexLang := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoHexLang_R(Self: TProjectVersionInfo; var T: string);
begin T := Self.HexLang; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoBuildNr_W(Self: TProjectVersionInfo; const T: integer);
begin Self.BuildNr := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoBuildNr_R(Self: TProjectVersionInfo; var T: integer);
begin T := Self.BuildNr; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoMinorRevNr_W(Self: TProjectVersionInfo; const T: integer);
begin Self.MinorRevNr := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoMinorRevNr_R(Self: TProjectVersionInfo; var T: integer);
begin T := Self.MinorRevNr; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoMajorRevNr_W(Self: TProjectVersionInfo; const T: integer);
begin Self.MajorRevNr := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoMajorRevNr_R(Self: TProjectVersionInfo; var T: integer);
begin T := Self.MajorRevNr; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoVersionNr_W(Self: TProjectVersionInfo; const T: integer);
begin Self.VersionNr := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoVersionNr_R(Self: TProjectVersionInfo; var T: integer);
begin T := Self.VersionNr; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoAutoIncrementBuild_W(Self: TProjectVersionInfo; const T: boolean);
begin Self.AutoIncrementBuild := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoAutoIncrementBuild_R(Self: TProjectVersionInfo; var T: boolean);
begin T := Self.AutoIncrementBuild; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoUseVersionInfo_W(Self: TProjectVersionInfo; const T: boolean);
begin Self.UseVersionInfo := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoUseVersionInfo_R(Self: TProjectVersionInfo; var T: boolean);
begin T := Self.UseVersionInfo; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoModified_W(Self: TProjectVersionInfo; const T: boolean);
begin Self.Modified := T; end;

(*----------------------------------------------------------------------------*)
procedure TProjectVersionInfoModified_R(Self: TProjectVersionInfo; var T: boolean);
begin T := Self.Modified; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_W32VersionInfo_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@MSLanguageToHex, 'MSLanguageToHex', cdRegister);
 S.RegisterDelphiFunction(@MSHexToLanguage, 'MSHexToLanguage', cdRegister);
 S.RegisterDelphiFunction(@MSCharacterSetToHex, 'MSCharacterSetToHex', cdRegister);
 S.RegisterDelphiFunction(@MSHexToCharacterSet, 'MSHexToCharacterSet', cdRegister);
 S.RegisterDelphiFunction(@MSLanguages, 'MSLanguages', cdRegister);
 S.RegisterDelphiFunction(@MSHexLanguages, 'MSHexLanguages', cdRegister);
 S.RegisterDelphiFunction(@MSCharacterSets, 'MSCharacterSets', cdRegister);
 S.RegisterDelphiFunction(@MSHexCharacterSets, 'MSHexCharacterSets', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TProjectVersionInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TProjectVersionInfo) do begin
    RegisterConstructor(@TProjectVersionInfo.Create, 'Create');
      RegisterMethod(@TProjectVersionInfo.Destroy, 'Free');
      RegisterMethod(@TProjectVersionInfo.CompileRCFile, 'CompileRCFile');
    RegisterMethod(@TProjectVersionInfo.UpdateMainSourceFile, 'UpdateMainSourceFile');
    RegisterPropertyHelper(@TProjectVersionInfoModified_R,@TProjectVersionInfoModified_W,'Modified');
    RegisterPropertyHelper(@TProjectVersionInfoUseVersionInfo_R,@TProjectVersionInfoUseVersionInfo_W,'UseVersionInfo');
    RegisterPropertyHelper(@TProjectVersionInfoAutoIncrementBuild_R,@TProjectVersionInfoAutoIncrementBuild_W,'AutoIncrementBuild');
    RegisterPropertyHelper(@TProjectVersionInfoVersionNr_R,@TProjectVersionInfoVersionNr_W,'VersionNr');
    RegisterPropertyHelper(@TProjectVersionInfoMajorRevNr_R,@TProjectVersionInfoMajorRevNr_W,'MajorRevNr');
    RegisterPropertyHelper(@TProjectVersionInfoMinorRevNr_R,@TProjectVersionInfoMinorRevNr_W,'MinorRevNr');
    RegisterPropertyHelper(@TProjectVersionInfoBuildNr_R,@TProjectVersionInfoBuildNr_W,'BuildNr');
    RegisterPropertyHelper(@TProjectVersionInfoHexLang_R,@TProjectVersionInfoHexLang_W,'HexLang');
    RegisterPropertyHelper(@TProjectVersionInfoHexCharSet_R,@TProjectVersionInfoHexCharSet_W,'HexCharSet');
    RegisterPropertyHelper(@TProjectVersionInfoDescriptionString_R,@TProjectVersionInfoDescriptionString_W,'DescriptionString');
    RegisterPropertyHelper(@TProjectVersionInfoCopyrightString_R,@TProjectVersionInfoCopyrightString_W,'CopyrightString');
    RegisterPropertyHelper(@TProjectVersionInfoCommentsString_R,@TProjectVersionInfoCommentsString_W,'CommentsString');
    RegisterPropertyHelper(@TProjectVersionInfoCompanyString_R,@TProjectVersionInfoCompanyString_W,'CompanyString');
    RegisterPropertyHelper(@TProjectVersionInfoInternalNameString_R,@TProjectVersionInfoInternalNameString_W,'InternalNameString');
    RegisterPropertyHelper(@TProjectVersionInfoTrademarksString_R,@TProjectVersionInfoTrademarksString_W,'TrademarksString');
    RegisterPropertyHelper(@TProjectVersionInfoOriginalFilenameString_R,@TProjectVersionInfoOriginalFilenameString_W,'OriginalFilenameString');
    RegisterPropertyHelper(@TProjectVersionInfoProdNameString_R,@TProjectVersionInfoProdNameString_W,'ProdNameString');
    RegisterPropertyHelper(@TProjectVersionInfoProductVersionString_R,@TProjectVersionInfoProductVersionString_W,'ProductVersionString');
    RegisterPropertyHelper(@TProjectVersionInfoVersionInfoMessages_R,nil,'VersionInfoMessages');
    RegisterPropertyHelper(@TProjectVersionInfoOnModified_R,@TProjectVersionInfoOnModified_W,'OnModified');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_W32VersionInfo(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TProjectVersionInfo(CL);
end;

 
 
{ TPSImport_W32VersionInfo }
(*----------------------------------------------------------------------------*)
procedure TPSImport_W32VersionInfo.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_W32VersionInfo(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_W32VersionInfo.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_W32VersionInfo(ri);
  RIRegister_W32VersionInfo_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
