unit uPSI_ImgList;
{
   also custom to imagelist in controls! , add
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
  TPSImport_ImgList = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCustomImageList(CL: TPSPascalCompiler);
procedure SIRegister_TChangeLink(CL: TPSPascalCompiler);
procedure SIRegister_ImgList(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCustomImageList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChangeLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_ImgList(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,CommCtrl
  ,ImgList
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ImgList]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomImageList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustomImageList') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustomImageList') do begin
   RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Constructor CreateSize( AWidth, AHeight : Integer)');
    RegisterMethod('procedure Assign(Source: TPersistent);');
   RegisterMethod('Procedure Free');
     RegisterMethod('Function Add( Image, Mask : TBitmap) : Integer');
    RegisterMethod('Function AddIcon( Image : TIcon) : Integer');
    RegisterMethod('Function AddImage( Value : TCustomImageList; Index : Integer) : Integer');
    RegisterMethod('Procedure AddImages( Value : TCustomImageList)');
    RegisterMethod('Function AddMasked( Image : TBitmap; MaskColor : TColor) : Integer');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure Draw( Canvas : TCanvas; X, Y, Index : Integer; Enabled : Boolean);');
    RegisterMethod('Procedure Draw1( Canvas : TCanvas; X, Y, Index : Integer; ADrawingStyle : TDrawingStyle; AImageType : TImageType; Enabled : Boolean);');
    RegisterMethod('Procedure DrawOverlay( Canvas : TCanvas; X, Y : Integer; ImageIndex : Integer; Overlay : TOverlay; Enabled : Boolean);');
    RegisterMethod('Procedure DrawOverlay1( Canvas : TCanvas; X, Y : Integer; ImageIndex : Integer; Overlay : TOverlay; ADrawingStyle : TDrawingStyle; AImageType : TImageType; Enabled : Boolean);');
    RegisterMethod('Function FileLoad( ResType : TResType; const Name : string; MaskColor : TColor) : Boolean');
    RegisterMethod('Function GetBitmap( Index : Integer; Image : TBitmap) : Boolean');
    RegisterMethod('Function GetHotSpot : TPoint');
    RegisterMethod('Procedure GetIcon( Index : Integer; Image : TIcon);');
    RegisterMethod('Procedure GetIcon1( Index : Integer; Image : TIcon; ADrawingStyle : TDrawingStyle; AImageType : TImageType);');
    RegisterMethod('Function GetImageBitmap : HBITMAP');
    RegisterMethod('Function GetMaskBitmap : HBITMAP');
    RegisterMethod('Function GetResource( ResType : TResType; const Name : string; Width : Integer; LoadFlags : TLoadResources; MaskColor : TColor) : Boolean');
    RegisterMethod('Function GetInstRes( Instance : THandle; ResType : TResType; const Name : string; Width : Integer; LoadFlags : TLoadResources; MaskColor : TColor) : Boolean;');
    RegisterMethod('Function GetInstRes1( Instance : THandle; ResType : TResType; ResID : DWORD; Width : Integer; LoadFlags : TLoadResources; MaskColor : TColor) : Boolean;');
    RegisterMethod('Function HandleAllocated : Boolean');
    RegisterMethod('Procedure Insert( Index : Integer; Image, Mask : TBitmap)');
    RegisterMethod('Procedure InsertIcon( Index : Integer; Image : TIcon)');
    RegisterMethod('Procedure InsertMasked( Index : Integer; Image : TBitmap; MaskColor : TColor)');
    RegisterMethod('Procedure Move( CurIndex, NewIndex : Integer)');
    RegisterMethod('Function Overlay( ImageIndex : Integer; Overlay : TOverlay) : Boolean');
    RegisterMethod('Procedure RegisterChanges( Value : TChangeLink)');
    RegisterMethod('Function ResourceLoad( ResType : TResType; const Name : string; MaskColor : TColor) : Boolean');
    RegisterMethod('Function ResInstLoad( Instance : THandle; ResType : TResType; const Name : string; MaskColor : TColor) : Boolean');
    RegisterMethod('Procedure Replace( Index : Integer; Image, Mask : TBitmap)');
    RegisterMethod('Procedure ReplaceIcon( Index : Integer; Image : TIcon)');
    RegisterMethod('Procedure ReplaceMasked( Index : Integer; NewImage : TBitmap; MaskColor : TColor)');
    RegisterMethod('Procedure UnRegisterChanges( Value : TChangeLink)');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Handle', 'HImageList', iptrw);
    RegisterProperty('AllocBy', 'Integer', iptrw);
    RegisterProperty('BlendColor', 'TColor', iptrw);
    RegisterProperty('BkColor', 'TColor', iptrw);
    RegisterProperty('DrawingStyle', 'TDrawingStyle', iptrw);
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('ImageType', 'TImageType', iptrw);
    RegisterProperty('Masked', 'Boolean', iptrw);
    RegisterProperty('ShareImages', 'Boolean', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChangeLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TChangeLink') do
  with CL.AddClassN(CL.FindClass('TObject'),'TChangeLink') do
  begin
    RegisterMethod('Procedure Change');
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('Sender', 'TCustomImageList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ImgList(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomImageList');
  SIRegister_TChangeLink(CL);
  CL.AddTypeS('TDrawingStyle', '( dsFocus, dsSelected, dsNormal, dsTransparent)');
  CL.AddTypeS('TImageType', '( itImage, itMask )');
  CL.AddTypeS('TResType', '( rtBitmap, rtCursor, rtIcon )');
  CL.AddTypeS('TOverlay', 'Integer');
  CL.AddTypeS('TLoadResource', '( lrDefaultColor, lrDefaultSize, lrFromFile, lr'
   +'Map3DColors, lrTransparent, lrMonoChrome )');
  CL.AddTypeS('TLoadResources', 'set of TLoadResource');
  CL.AddTypeS('TImageIndex', 'Integer');
  SIRegister_TCustomImageList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomImageListOnChange_W(Self: TCustomImageList; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListOnChange_R(Self: TCustomImageList; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListWidth_W(Self: TCustomImageList; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListWidth_R(Self: TCustomImageList; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListShareImages_W(Self: TCustomImageList; const T: Boolean);
begin Self.ShareImages := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListShareImages_R(Self: TCustomImageList; var T: Boolean);
begin T := Self.ShareImages; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListMasked_W(Self: TCustomImageList; const T: Boolean);
begin Self.Masked := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListMasked_R(Self: TCustomImageList; var T: Boolean);
begin T := Self.Masked; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListImageType_W(Self: TCustomImageList; const T: TImageType);
begin Self.ImageType := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListImageType_R(Self: TCustomImageList; var T: TImageType);
begin T := Self.ImageType; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListHeight_W(Self: TCustomImageList; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListHeight_R(Self: TCustomImageList; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListDrawingStyle_W(Self: TCustomImageList; const T: TDrawingStyle);
begin Self.DrawingStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListDrawingStyle_R(Self: TCustomImageList; var T: TDrawingStyle);
begin T := Self.DrawingStyle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListBkColor_W(Self: TCustomImageList; const T: TColor);
begin Self.BkColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListBkColor_R(Self: TCustomImageList; var T: TColor);
begin T := Self.BkColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListBlendColor_W(Self: TCustomImageList; const T: TColor);
begin Self.BlendColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListBlendColor_R(Self: TCustomImageList; var T: TColor);
begin T := Self.BlendColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListAllocBy_W(Self: TCustomImageList; const T: Integer);
begin Self.AllocBy := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListAllocBy_R(Self: TCustomImageList; var T: Integer);
begin T := Self.AllocBy; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListHandle_W(Self: TCustomImageList; const T: HImageList);
begin Self.Handle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListHandle_R(Self: TCustomImageList; var T: HImageList);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImageListCount_R(Self: TCustomImageList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
Function TCustomImageListGetInstRes1_P(Self: TCustomImageList;  Instance : THandle; ResType : TResType; ResID : DWORD; Width : Integer; LoadFlags : TLoadResources; MaskColor : TColor) : Boolean;
Begin Result := Self.GetInstRes(Instance, ResType, ResID, Width, LoadFlags, MaskColor); END;

(*----------------------------------------------------------------------------*)
Function TCustomImageListGetInstRes_P(Self: TCustomImageList;  Instance : THandle; ResType : TResType; const Name : string; Width : Integer; LoadFlags : TLoadResources; MaskColor : TColor) : Boolean;
Begin Result := Self.GetInstRes(Instance, ResType, Name, Width, LoadFlags, MaskColor); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomImageListGetIcon1_P(Self: TCustomImageList;  Index : Integer; Image : TIcon; ADrawingStyle : TDrawingStyle; AImageType : TImageType);
Begin Self.GetIcon(Index, Image, ADrawingStyle, AImageType); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomImageListGetIcon_P(Self: TCustomImageList;  Index : Integer; Image : TIcon);
Begin Self.GetIcon(Index, Image); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomImageListDrawOverlay1_P(Self: TCustomImageList;  Canvas : TCanvas; X, Y : Integer; ImageIndex : Integer; Overlay : TOverlay; ADrawingStyle : TDrawingStyle; AImageType : TImageType; Enabled : Boolean);
Begin Self.DrawOverlay(Canvas, X, Y, ImageIndex, Overlay, ADrawingStyle, AImageType, Enabled); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomImageListDrawOverlay_P(Self: TCustomImageList;  Canvas : TCanvas; X, Y : Integer; ImageIndex : Integer; Overlay : TOverlay; Enabled : Boolean);
Begin Self.DrawOverlay(Canvas, X, Y, ImageIndex, Overlay, Enabled); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomImageListDraw1_P(Self: TCustomImageList;  Canvas : TCanvas; X, Y, Index : Integer; ADrawingStyle : TDrawingStyle; AImageType : TImageType; Enabled : Boolean);
Begin Self.Draw(Canvas, X, Y, Index, ADrawingStyle, AImageType, Enabled); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomImageListDraw_P(Self: TCustomImageList;  Canvas : TCanvas; X, Y, Index : Integer; Enabled : Boolean);
Begin Self.Draw(Canvas, X, Y, Index, Enabled); END;

(*----------------------------------------------------------------------------*)
procedure TChangeLinkSender_W(Self: TChangeLink; const T: TCustomImageList);
begin Self.Sender := T; end;

(*----------------------------------------------------------------------------*)
procedure TChangeLinkSender_R(Self: TChangeLink; var T: TCustomImageList);
begin T := Self.Sender; end;

(*----------------------------------------------------------------------------*)
procedure TChangeLinkOnChange_W(Self: TChangeLink; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TChangeLinkOnChange_R(Self: TChangeLink; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomImageList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomImageList) do begin
    RegisterConstructor(@TCustomImageList.Create, 'Create');
    RegisterConstructor(@TCustomImageList.CreateSize, 'CreateSize');
    RegisterMethod(@TCustomImageList.Assign, 'Assign');
  RegisterMethod(@TCustomImageList.Free, 'Free');
     RegisterMethod(@TCustomImageList.Add, 'Add');
    RegisterMethod(@TCustomImageList.AddIcon, 'AddIcon');
    RegisterMethod(@TCustomImageList.AddImage, 'AddImage');
    RegisterMethod(@TCustomImageList.AddImages, 'AddImages');
    RegisterMethod(@TCustomImageList.AddMasked, 'AddMasked');
    RegisterMethod(@TCustomImageList.Clear, 'Clear');
    RegisterMethod(@TCustomImageList.Delete, 'Delete');
    RegisterMethod(@TCustomImageListDraw_P, 'Draw');
    RegisterMethod(@TCustomImageListDraw1_P, 'Draw1');
    RegisterMethod(@TCustomImageListDrawOverlay_P, 'DrawOverlay');
    RegisterMethod(@TCustomImageListDrawOverlay1_P, 'DrawOverlay1');
    RegisterMethod(@TCustomImageList.FileLoad, 'FileLoad');
    RegisterMethod(@TCustomImageList.GetBitmap, 'GetBitmap');
    RegisterVirtualMethod(@TCustomImageList.GetHotSpot, 'GetHotSpot');
    RegisterMethod(@TCustomImageListGetIcon_P, 'GetIcon');
    RegisterMethod(@TCustomImageListGetIcon1_P, 'GetIcon1');
    RegisterMethod(@TCustomImageList.GetImageBitmap, 'GetImageBitmap');
    RegisterMethod(@TCustomImageList.GetMaskBitmap, 'GetMaskBitmap');
    RegisterMethod(@TCustomImageList.GetResource, 'GetResource');
    RegisterMethod(@TCustomImageListGetInstRes_P, 'GetInstRes');
    RegisterMethod(@TCustomImageListGetInstRes1_P, 'GetInstRes1');
    RegisterMethod(@TCustomImageList.HandleAllocated, 'HandleAllocated');
    RegisterMethod(@TCustomImageList.Insert, 'Insert');
    RegisterMethod(@TCustomImageList.InsertIcon, 'InsertIcon');
    RegisterMethod(@TCustomImageList.InsertMasked, 'InsertMasked');
    RegisterMethod(@TCustomImageList.Move, 'Move');
    RegisterMethod(@TCustomImageList.Overlay, 'Overlay');
    RegisterMethod(@TCustomImageList.RegisterChanges, 'RegisterChanges');
    RegisterMethod(@TCustomImageList.ResourceLoad, 'ResourceLoad');
    RegisterMethod(@TCustomImageList.ResInstLoad, 'ResInstLoad');
    RegisterMethod(@TCustomImageList.Replace, 'Replace');
    RegisterMethod(@TCustomImageList.ReplaceIcon, 'ReplaceIcon');
    RegisterMethod(@TCustomImageList.ReplaceMasked, 'ReplaceMasked');
    RegisterMethod(@TCustomImageList.UnRegisterChanges, 'UnRegisterChanges');
    RegisterPropertyHelper(@TCustomImageListCount_R,nil,'Count');
    RegisterPropertyHelper(@TCustomImageListHandle_R,@TCustomImageListHandle_W,'Handle');
    RegisterPropertyHelper(@TCustomImageListAllocBy_R,@TCustomImageListAllocBy_W,'AllocBy');
    RegisterPropertyHelper(@TCustomImageListBlendColor_R,@TCustomImageListBlendColor_W,'BlendColor');
    RegisterPropertyHelper(@TCustomImageListBkColor_R,@TCustomImageListBkColor_W,'BkColor');
    RegisterPropertyHelper(@TCustomImageListDrawingStyle_R,@TCustomImageListDrawingStyle_W,'DrawingStyle');
    RegisterPropertyHelper(@TCustomImageListHeight_R,@TCustomImageListHeight_W,'Height');
    RegisterPropertyHelper(@TCustomImageListImageType_R,@TCustomImageListImageType_W,'ImageType');
    RegisterPropertyHelper(@TCustomImageListMasked_R,@TCustomImageListMasked_W,'Masked');
    RegisterPropertyHelper(@TCustomImageListShareImages_R,@TCustomImageListShareImages_W,'ShareImages');
    RegisterPropertyHelper(@TCustomImageListWidth_R,@TCustomImageListWidth_W,'Width');
    RegisterPropertyHelper(@TCustomImageListOnChange_R,@TCustomImageListOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChangeLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChangeLink) do
  begin
    RegisterVirtualMethod(@TChangeLink.Change, 'Change');
    RegisterPropertyHelper(@TChangeLinkOnChange_R,@TChangeLinkOnChange_W,'OnChange');
    RegisterPropertyHelper(@TChangeLinkSender_R,@TChangeLinkSender_W,'Sender');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ImgList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomImageList) do
  RIRegister_TChangeLink(CL);
  RIRegister_TCustomImageList(CL);
end;

 
 
{ TPSImport_ImgList }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ImgList.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ImgList(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ImgList.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ImgList(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
