unit uPSI_RotImg;
{
TRotateImage

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
  TPSImport_RotImg = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRotateImage(CL: TPSPascalCompiler);
procedure SIRegister_RotImg(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_RotImg_Routines(S: TPSExec);
procedure RIRegister_TRotateImage(CL: TPSRuntimeClassImporter);
procedure RIRegister_RotImg(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,RotImg
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_RotImg]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TRotateImage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TRotateImage') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TRotateImage') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Function RotatedPoint( const Pt : TPoint) : TPoint');
    RegisterMethod('Procedure RotatePoints( var Points : array of TPoint)');
    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterProperty('RotatedBitmap', 'TBitmap', iptr);
    RegisterProperty('MaxSize', 'Integer', iptr);
    RegisterProperty('ImageRect', 'TRect', iptr);
    RegisterProperty('ImageRgn', 'HRGN', iptr);
    RegisterProperty('Angle', 'Extended', iptrw);
    RegisterProperty('AutoSize', 'Boolean', iptrw);
    RegisterProperty('Center', 'Boolean', iptrw);
    RegisterProperty('Picture', 'TPicture', iptrw);
    RegisterProperty('Proportional', 'Boolean', iptrw);
    RegisterProperty('Stretch', 'Boolean', iptrw);
    RegisterProperty('Transparent', 'Boolean', iptrw);
    RegisterProperty('UniqueSize', 'Boolean', iptrw);
    RegisterProperty('OnRotation', 'TNotifyEvent', iptrw);
    RegisterPublishedProperties;
     RegisterProperty('EditMask', 'string', iptrw);
    RegisterProperty('Font', 'Tfont', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
       RegisterProperty('ALIGN', 'TALIGN', iptrw);
      RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);
    RegisterProperty('SCROLLBARS', 'TScrollStyle', iptrw);
    RegisterProperty('ONCHANGE', 'TNotifyEvent', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONMouseDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONMouseUP', 'TKeyEvent', iptrw);
    RegisterProperty('OEMConvert', 'Boolean', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_RotImg(CL: TPSPascalCompiler);
begin
  SIRegister_TRotateImage(CL);
 CL.AddDelphiFunction('Function CreateRotatedBitmap(Bitmap: TBitmap; const Angle: Extended; bgColor : TColor): TBitmap');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TRotateImageOnRotation_W(Self: TRotateImage; const T: TNotifyEvent);
begin Self.OnRotation := T; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageOnRotation_R(Self: TRotateImage; var T: TNotifyEvent);
begin T := Self.OnRotation; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageUniqueSize_W(Self: TRotateImage; const T: Boolean);
begin Self.UniqueSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageUniqueSize_R(Self: TRotateImage; var T: Boolean);
begin T := Self.UniqueSize; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageTransparent_W(Self: TRotateImage; const T: Boolean);
begin Self.Transparent := T; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageTransparent_R(Self: TRotateImage; var T: Boolean);
begin T := Self.Transparent; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageStretch_W(Self: TRotateImage; const T: Boolean);
begin Self.Stretch := T; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageStretch_R(Self: TRotateImage; var T: Boolean);
begin T := Self.Stretch; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageProportional_W(Self: TRotateImage; const T: Boolean);
begin Self.Proportional := T; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageProportional_R(Self: TRotateImage; var T: Boolean);
begin T := Self.Proportional; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImagePicture_W(Self: TRotateImage; const T: TPicture);
begin Self.Picture := T; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImagePicture_R(Self: TRotateImage; var T: TPicture);
begin T := Self.Picture; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageCenter_W(Self: TRotateImage; const T: Boolean);
begin Self.Center := T; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageCenter_R(Self: TRotateImage; var T: Boolean);
begin T := Self.Center; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageAutoSize_W(Self: TRotateImage; const T: Boolean);
begin Self.AutoSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageAutoSize_R(Self: TRotateImage; var T: Boolean);
begin T := Self.AutoSize; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageAngle_W(Self: TRotateImage; const T: Extended);
begin Self.Angle := T; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageAngle_R(Self: TRotateImage; var T: Extended);
begin T := Self.Angle; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageImageRgn_R(Self: TRotateImage; var T: HRGN);
begin T := Self.ImageRgn; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageImageRect_R(Self: TRotateImage; var T: TRect);
begin T := Self.ImageRect; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageMaxSize_R(Self: TRotateImage; var T: Integer);
begin T := Self.MaxSize; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageRotatedBitmap_R(Self: TRotateImage; var T: TBitmap);
begin T := Self.RotatedBitmap; end;

(*----------------------------------------------------------------------------*)
procedure TRotateImageCanvas_R(Self: TRotateImage; var T: TCanvas);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_RotImg_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateRotatedBitmap, 'CreateRotatedBitmap', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRotateImage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRotateImage) do begin
    RegisterConstructor(@TRotateImage.Create, 'Create');
    RegisterMethod(@TRotateImage.Destroy, 'Free');
    RegisterMethod(@TRotateImage.RotatedPoint, 'RotatedPoint');
    RegisterMethod(@TRotateImage.RotatePoints, 'RotatePoints');
    RegisterPropertyHelper(@TRotateImageCanvas_R,nil,'Canvas');
    RegisterPropertyHelper(@TRotateImageRotatedBitmap_R,nil,'RotatedBitmap');
    RegisterPropertyHelper(@TRotateImageMaxSize_R,nil,'MaxSize');
    RegisterPropertyHelper(@TRotateImageImageRect_R,nil,'ImageRect');
    RegisterPropertyHelper(@TRotateImageImageRgn_R,nil,'ImageRgn');
    RegisterPropertyHelper(@TRotateImageAngle_R,@TRotateImageAngle_W,'Angle');
    RegisterPropertyHelper(@TRotateImageAutoSize_R,@TRotateImageAutoSize_W,'AutoSize');
    RegisterPropertyHelper(@TRotateImageCenter_R,@TRotateImageCenter_W,'Center');
    RegisterPropertyHelper(@TRotateImagePicture_R,@TRotateImagePicture_W,'Picture');
    RegisterPropertyHelper(@TRotateImageProportional_R,@TRotateImageProportional_W,'Proportional');
    RegisterPropertyHelper(@TRotateImageStretch_R,@TRotateImageStretch_W,'Stretch');
    RegisterPropertyHelper(@TRotateImageTransparent_R,@TRotateImageTransparent_W,'Transparent');
    RegisterPropertyHelper(@TRotateImageUniqueSize_R,@TRotateImageUniqueSize_W,'UniqueSize');
    RegisterPropertyHelper(@TRotateImageOnRotation_R,@TRotateImageOnRotation_W,'OnRotation');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_RotImg(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TRotateImage(CL);
end;

 
 
{ TPSImport_RotImg }
(*----------------------------------------------------------------------------*)
procedure TPSImport_RotImg.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_RotImg(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_RotImg.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_RotImg(ri);
  RIRegister_RotImg_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
