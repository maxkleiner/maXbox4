unit uPSI_SysImg;
{
   seach for raspi
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
  TPSImport_SysImg = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TSysImageList(CL: TPSPascalCompiler);
procedure SIRegister_SysImg(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SysImg_Routines(S: TPSExec);
procedure RIRegister_TSysImageList(CL: TPSRuntimeClassImporter);
procedure RIRegister_SysImg(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,ImgList //, unixbase
  ,SysImg
  ;


procedure Register;
begin
  //RegisterComponents('Pascal Script', [TPSImport_SysImg]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSysImageList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomImageList', 'TSysImageList') do
  with CL.AddClassN(CL.FindClass('TCustomImageList'),'TSysImageList') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
          RegisterMethod('Procedure Free');
        RegisterMethod('Function ImageIndexOf( const Path : String; OpenIcon : Boolean) : Integer');
    RegisterProperty('IconSet', 'TIconSet', iptrw);
    RegisterProperty('IconSize', 'TIconSize', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SysImg(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIconSize', '( isSmallIcons, isLargeIcons )');
  CL.AddTypeS('TIconSet', '( isSystem, isToolbar )');
  SIRegister_TSysImageList(CL);
 CL.AddDelphiFunction('Function GetSpecialFolderID( const Path : String) : Integer');
 CL.AddDelphiFunction('Function GetSpecialFolderPath2( FolderID : Integer) : String');
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSysImageListIconSize_W(Self: TSysImageList; const T: TIconSize);
begin Self.IconSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TSysImageListIconSize_R(Self: TSysImageList; var T: TIconSize);
begin T := Self.IconSize; end;

(*----------------------------------------------------------------------------*)
procedure TSysImageListIconSet_W(Self: TSysImageList; const T: TIconSet);
begin Self.IconSet := T; end;

(*----------------------------------------------------------------------------*)
procedure TSysImageListIconSet_R(Self: TSysImageList; var T: TIconSet);
begin T := Self.IconSet; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SysImg_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetSpecialFolderID, 'GetSpecialFolderID', cdRegister);
 S.RegisterDelphiFunction(@GetSpecialFolderPath, 'GetSpecialFolderPath2', cdRegister);
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSysImageList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSysImageList) do begin
    RegisterConstructor(@TSysImageList.Create, 'Create');
        RegisterMethod(@TSysImageList.Destroy, 'Free');
        RegisterMethod(@TSysImageList.ImageIndexOf, 'ImageIndexOf');
    RegisterPropertyHelper(@TSysImageListIconSet_R,@TSysImageListIconSet_W,'IconSet');
    RegisterPropertyHelper(@TSysImageListIconSize_R,@TSysImageListIconSize_W,'IconSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SysImg(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSysImageList(CL);
end;

 
 
{ TPSImport_SysImg }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SysImg.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SysImg(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SysImg.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SysImg(ri);
  RIRegister_SysImg_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
