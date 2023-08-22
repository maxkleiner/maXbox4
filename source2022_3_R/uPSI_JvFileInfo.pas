unit uPSI_JvFileInfo;
{
  a lst fileinfo
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
  TPSImport_JvFileInfo = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvFileInfo(CL: TPSPascalCompiler);
procedure SIRegister_JvFileInfo(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvFileInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvFileInfo(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,Controls
  ,ShellAPI
  ,JvComponent
  ,JvTypes
  ,JvFileInfo
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvFileInfo]);
end;



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvFileInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvFileInfo') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvFileInfo') do begin
    RegisterProperty('LargeImages', 'TImageList', iptr);
    RegisterProperty('SmallImages', 'TImageList', iptr);
    RegisterProperty('IconHandle', 'THandle', iptr);
    RegisterProperty('Attributes', 'Integer', iptr);
    RegisterMethod('Function GetCustomInformation( Value : string) : TFileInformation');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterProperty('FileName', 'TFileName', iptrw);
    RegisterProperty('Modifier', 'TJvIconModifier', iptrw);
    RegisterProperty('IconIndex', 'Integer', iptrw);
    RegisterProperty('DisplayName', 'string', iptrw);
    RegisterProperty('ExeType', 'TJvExeType', iptrw);
    RegisterProperty('AttrString', 'string', iptrw);
    RegisterProperty('IconLocation', 'string', iptrw);
    RegisterProperty('TypeString', 'string', iptrw);
    RegisterProperty('Icon', 'TIcon', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvFileInfo(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvExeType', '( etNone, etMSDos, etWin16, etWin32, etConsole )');
  CL.AddTypeS('TJvIconModifier', '( imNormal, imOverlay, imSelected, imOpen, imShellSize, imSmall )');
   CL.AddTypeS('TFileInformation', 'record Attributes : DWord; '
   +'DisplayName : string; ExeType : Integer; Icon : HICON;'
   +'Location: string; TypeName : string; SysIconIndex : Integer; end');
   CL.AddTypeS('TAniHeader', 'record dwSizeof, dwFrames, dwsteps, dwCX, dwCY, '
   +' dwBitCount,  dwPlanes, dwJIFRate, dwFlags: Longint; end');

  SIRegister_TJvFileInfo(CL);
  //StrToFloatF(12.34, ffCurrency, 15, 2);
  //StrtoFloatFS
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvFileInfoIcon_W(Self: TJvFileInfo; const T: TIcon);
begin Self.Icon := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoIcon_R(Self: TJvFileInfo; var T: TIcon);
begin T := Self.Icon; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoTypeString_W(Self: TJvFileInfo; const T: string);
begin Self.TypeString := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoTypeString_R(Self: TJvFileInfo; var T: string);
begin T := Self.TypeString; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoIconLocation_W(Self: TJvFileInfo; const T: string);
begin Self.IconLocation := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoIconLocation_R(Self: TJvFileInfo; var T: string);
begin T := Self.IconLocation; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoAttrString_W(Self: TJvFileInfo; const T: string);
begin Self.AttrString := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoAttrString_R(Self: TJvFileInfo; var T: string);
begin T := Self.AttrString; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoExeType_W(Self: TJvFileInfo; const T: TJvExeType);
begin Self.ExeType := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoExeType_R(Self: TJvFileInfo; var T: TJvExeType);
begin T := Self.ExeType; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoDisplayName_W(Self: TJvFileInfo; const T: string);
begin Self.DisplayName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoDisplayName_R(Self: TJvFileInfo; var T: string);
begin T := Self.DisplayName; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoIconIndex_W(Self: TJvFileInfo; const T: Integer);
begin Self.IconIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoIconIndex_R(Self: TJvFileInfo; var T: Integer);
begin T := Self.IconIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoModifier_W(Self: TJvFileInfo; const T: TJvIconModifier);
begin Self.Modifier := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoModifier_R(Self: TJvFileInfo; var T: TJvIconModifier);
begin T := Self.Modifier; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoFileName_W(Self: TJvFileInfo; const T: TFileName);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoFileName_R(Self: TJvFileInfo; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoAttributes_R(Self: TJvFileInfo; var T: Integer);
begin T := Self.Attributes; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoIconHandle_R(Self: TJvFileInfo; var T: THandle);
begin T := Self.IconHandle; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoSmallImages_R(Self: TJvFileInfo; var T: TImageList);
begin T := Self.SmallImages; end;

(*----------------------------------------------------------------------------*)
procedure TJvFileInfoLargeImages_R(Self: TJvFileInfo; var T: TImageList);
begin T := Self.LargeImages; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvFileInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvFileInfo) do begin
    RegisterPropertyHelper(@TJvFileInfoLargeImages_R,nil,'LargeImages');
    RegisterPropertyHelper(@TJvFileInfoSmallImages_R,nil,'SmallImages');
    RegisterPropertyHelper(@TJvFileInfoIconHandle_R,nil,'IconHandle');
    RegisterPropertyHelper(@TJvFileInfoAttributes_R,nil,'Attributes');
    RegisterMethod(@TJvFileInfo.GetCustomInformation, 'GetCustomInformation');
    RegisterConstructor(@TJvFileInfo.Create, 'Create');
    RegisterMethod(@TJvFileInfo.Destroy, 'Free');
     RegisterPropertyHelper(@TJvFileInfoFileName_R,@TJvFileInfoFileName_W,'FileName');
    RegisterPropertyHelper(@TJvFileInfoModifier_R,@TJvFileInfoModifier_W,'Modifier');
    RegisterPropertyHelper(@TJvFileInfoIconIndex_R,@TJvFileInfoIconIndex_W,'IconIndex');
    RegisterPropertyHelper(@TJvFileInfoDisplayName_R,@TJvFileInfoDisplayName_W,'DisplayName');
    RegisterPropertyHelper(@TJvFileInfoExeType_R,@TJvFileInfoExeType_W,'ExeType');
    RegisterPropertyHelper(@TJvFileInfoAttrString_R,@TJvFileInfoAttrString_W,'AttrString');
    RegisterPropertyHelper(@TJvFileInfoIconLocation_R,@TJvFileInfoIconLocation_W,'IconLocation');
    RegisterPropertyHelper(@TJvFileInfoTypeString_R,@TJvFileInfoTypeString_W,'TypeString');
    RegisterPropertyHelper(@TJvFileInfoIcon_R,@TJvFileInfoIcon_W,'Icon');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvFileInfo(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvFileInfo(CL);
end;

 
 
{ TPSImport_JvFileInfo }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvFileInfo.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvFileInfo(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvFileInfo.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvFileInfo(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
