unit uPSI_BitmapImage;
{
  more bitmap
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
  TPSImport_BitmapImage = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TBitmapImage(CL: TPSPascalCompiler);
procedure SIRegister_BitmapImage(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_BitmapImage_Routines(S: TPSExec);
procedure RIRegister_TBitmapImage(CL: TPSRuntimeClassImporter);
procedure RIRegister_BitmapImage(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,Graphics
  ,BitmapImage
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BitmapImage]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBitmapImage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TBitmapImage') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TBitmapImage') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterProperty('AutoSize', 'Boolean', iptrw);
    RegisterProperty('BackColor', 'TColor', iptrw);
    RegisterProperty('Center', 'Boolean', iptrw);
    RegisterProperty('Bitmap', 'TBitmap', iptrw);
    RegisterProperty('Stretch', 'Boolean', iptrw);
    RegisterProperty('ReplaceColor', 'TColor', iptrw);
    RegisterProperty('ReplaceWithColor', 'TColor', iptrw);
    RegisterPublishedProperties;
       RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
     RegisterProperty('ParentColor', 'TColor', iptrw);
    RegisterProperty('BevelWidth','TBevelWidth',iptrw);
    //RegisterProperty('Parent','TWinControl',iptrw);
    // property Parent: TWinControl read FParent write SetParent;
     //RegisterProperty('Options', 'TAfComOptions', iptrw);
    //  RegisterProperty('TermColorMode', 'TAfTRMColorMode', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_BitmapImage(CL: TPSPascalCompiler);
begin
  SIRegister_TBitmapImage(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TBitmapImageReplaceWithColor_W(Self: TBitmapImage; const T: TColor);
begin Self.ReplaceWithColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapImageReplaceWithColor_R(Self: TBitmapImage; var T: TColor);
begin T := Self.ReplaceWithColor; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapImageReplaceColor_W(Self: TBitmapImage; const T: TColor);
begin Self.ReplaceColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapImageReplaceColor_R(Self: TBitmapImage; var T: TColor);
begin T := Self.ReplaceColor; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapImageStretch_W(Self: TBitmapImage; const T: Boolean);
begin Self.Stretch := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapImageStretch_R(Self: TBitmapImage; var T: Boolean);
begin T := Self.Stretch; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapImageBitmap_W(Self: TBitmapImage; const T: TBitmap);
begin Self.Bitmap := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapImageBitmap_R(Self: TBitmapImage; var T: TBitmap);
begin T := Self.Bitmap; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapImageCenter_W(Self: TBitmapImage; const T: Boolean);
begin Self.Center := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapImageCenter_R(Self: TBitmapImage; var T: Boolean);
begin T := Self.Center; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapImageBackColor_W(Self: TBitmapImage; const T: TColor);
begin Self.BackColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapImageBackColor_R(Self: TBitmapImage; var T: TColor);
begin T := Self.BackColor; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapImageAutoSize_W(Self: TBitmapImage; const T: Boolean);
begin Self.AutoSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmapImageAutoSize_R(Self: TBitmapImage; var T: Boolean);
begin T := Self.AutoSize; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BitmapImage_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBitmapImage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBitmapImage) do begin
    RegisterConstructor(@TBitmapImage.Create, 'Create');
    RegisterMethod(@TBitmapImage.Destroy, 'Free');
    RegisterPropertyHelper(@TBitmapImageAutoSize_R,@TBitmapImageAutoSize_W,'AutoSize');
    RegisterPropertyHelper(@TBitmapImageBackColor_R,@TBitmapImageBackColor_W,'BackColor');
    RegisterPropertyHelper(@TBitmapImageCenter_R,@TBitmapImageCenter_W,'Center');
    RegisterPropertyHelper(@TBitmapImageBitmap_R,@TBitmapImageBitmap_W,'Bitmap');
    RegisterPropertyHelper(@TBitmapImageStretch_R,@TBitmapImageStretch_W,'Stretch');
    RegisterPropertyHelper(@TBitmapImageReplaceColor_R,@TBitmapImageReplaceColor_W,'ReplaceColor');
    RegisterPropertyHelper(@TBitmapImageReplaceWithColor_R,@TBitmapImageReplaceWithColor_W,'ReplaceWithColor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BitmapImage(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBitmapImage(CL);
end;

 
 
{ TPSImport_BitmapImage }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BitmapImage.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BitmapImage(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BitmapImage.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BitmapImage(ri);
  RIRegister_BitmapImage_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
