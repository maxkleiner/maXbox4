unit uPSI_GR32_Backends_VCL;
{
  back in the end
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
  TPSImport_GR32_Backends_VCL = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TGDIMemoryBackend(CL: TPSPascalCompiler);
procedure SIRegister_TGDIMMFBackend(CL: TPSPascalCompiler);
procedure SIRegister_TGDIBackend(CL: TPSPascalCompiler);
procedure SIRegister_GR32_Backends_VCL(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TGDIMemoryBackend(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGDIMMFBackend(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGDIBackend(CL: TPSRuntimeClassImporter);
procedure RIRegister_GR32_Backends_VCL(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,GR32
  ,GR32_Backends
  ,GR32_Containers
  ,GR32_Image
  ,GR32_Backends_Generic
  ,GR32_Backends_VCL
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GR32_Backends_VCL]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TGDIMemoryBackend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMemoryBackend', 'TGDIMemoryBackend') do
  with CL.AddClassN(CL.FindClass('TMemoryBackend'),'TGDIMemoryBackend') do begin
    RegisterMethod('Constructor Create');
         RegisterMethod('Procedure Free');
      RegisterMethod('Procedure ImageNeeded');
    RegisterMethod('Procedure CheckPixmap');
    RegisterMethod('Procedure DoPaint( ABuffer : TBitmap32; AInvalidRects : TRectList; ACanvas : TCanvas; APaintBox : TCustomPaintBox32)');
    RegisterMethod('Procedure Draw( const DstRect, SrcRect : TRect; hSrc : CardinalHDC);');
    RegisterMethod('Procedure DrawTo( hDst : CardinalHDC, DstX, DstY : Integer);');
    RegisterMethod('Procedure DrawTo1( hDst : Cardinal; const DstRect, SrcRect : TRect);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGDIMMFBackend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGDIBackend', 'TGDIMMFBackend') do
  with CL.AddClassN(CL.FindClass('TGDIBackend'),'TGDIMMFBackend') do begin
    RegisterMethod('Constructor Create( Owner : TBitmap32; IsTemporary : Boolean; const MapFileName : string)');
      RegisterMethod('Procedure Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGDIBackend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomBackend', 'TGDIBackend') do
  with CL.AddClassN(CL.FindClass('TCustomBackend'),'TGDIBackend') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Changed');
    RegisterMethod('Function Empty : Boolean');
    RegisterMethod('Procedure ImageNeeded');
    RegisterMethod('Procedure CheckPixmap');
    RegisterMethod('Procedure DoPaint( ABuffer : TBitmap32; AInvalidRects : TRectList; ACanvas : TCanvas; APaintBox : TCustomPaintBox32)');
    RegisterMethod('Function GetBitmapInfo : TBitmapInfo');
    RegisterMethod('Function GetBitmapHandle : THandle');
    RegisterProperty('BitmapInfo', 'TBitmapInfo', iptr);
    RegisterProperty('BitmapHandle', 'THandle', iptr);
    RegisterMethod('Function GetHandle : HDC');
    RegisterMethod('Procedure Draw( const DstRect, SrcRect : TRect; hSrc : HDC);');
    RegisterMethod('Procedure DrawTo( hDst : CardinalHDC, DstX, DstY : Integer);');
    RegisterMethod('Procedure DrawTo1( hDst : Cardinal; const DstRect, SrcRect : TRect);');
    RegisterProperty('Handle', 'HDC', iptr);
    RegisterMethod('Procedure Textout( X, Y : Integer; const Text : String);');
    RegisterMethod('Procedure Textout1( X, Y : Integer; const ClipRect : TRect; const Text : String);');
    RegisterMethod('Procedure Textout2( var DstRect : TRect; const Flags : Cardinal; const Text : String);');
    RegisterMethod('Function TextExtent( const Text : String) : TSize');
    RegisterMethod('Procedure TextoutW( X, Y : Integer; const Text : Widestring);');
    RegisterMethod('Procedure TextoutW1( X, Y : Integer; const ClipRect : TRect; const Text : Widestring);');
    RegisterMethod('Procedure TextoutW2( var DstRect : TRect; const Flags : Cardinal; const Text : Widestring);');
    RegisterMethod('Function TextExtentW( const Text : Widestring) : TSize');
    RegisterMethod('Function GetOnFontChange : TNotifyEvent');
    RegisterMethod('Procedure SetOnFontChange( Handler : TNotifyEvent)');
    RegisterMethod('Function GetFont : TFont');
    RegisterMethod('Procedure SetFont( const Font : TFont)');
    RegisterMethod('Procedure UpdateFont');
    RegisterProperty('Font', 'TFont', iptrw);
    RegisterProperty('OnFontChange', 'TNotifyEvent', iptrw);
    RegisterMethod('Function GetCanvasChange : TNotifyEvent');
    RegisterMethod('Procedure SetCanvasChange( Handler : TNotifyEvent)');
    RegisterMethod('Function GetCanvas : TCanvas');
    RegisterMethod('Procedure DeleteCanvas');
    RegisterMethod('Function CanvasAllocated : Boolean');
    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterProperty('OnCanvasChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GR32_Backends_VCL(CL: TPSPascalCompiler);
begin
  SIRegister_TGDIBackend(CL);
  SIRegister_TGDIMMFBackend(CL);
  SIRegister_TGDIMemoryBackend(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure TGDIMemoryBackendDrawTo1_P(Self: TGDIMemoryBackend;  hDst : Cardinal; const DstRect, SrcRect : TRect);
Begin Self.DrawTo(hDst, DstRect, SrcRect); END;

(*----------------------------------------------------------------------------*)
Procedure TGDIMemoryBackendDrawTo_P(Self: TGDIMemoryBackend;  hDst : HDC; DstX, DstY : Integer);
Begin Self.DrawTo(hDst, DstX, DstY); END;

(*----------------------------------------------------------------------------*)
Procedure TGDIMemoryBackendDraw_P(Self: TGDIMemoryBackend;  const DstRect, SrcRect : TRect; hSrc : HDC);
Begin Self.Draw(DstRect, SrcRect, hSrc); END;

(*----------------------------------------------------------------------------*)
procedure TGDIBackendOnCanvasChange_W(Self: TGDIBackend; const T: TNotifyEvent);
begin Self.OnCanvasChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIBackendOnCanvasChange_R(Self: TGDIBackend; var T: TNotifyEvent);
begin T := Self.OnCanvasChange; end;

(*----------------------------------------------------------------------------*)
procedure TGDIBackendCanvas_R(Self: TGDIBackend; var T: TCanvas);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
procedure TGDIBackendOnFontChange_W(Self: TGDIBackend; const T: TNotifyEvent);
begin Self.OnFontChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIBackendOnFontChange_R(Self: TGDIBackend; var T: TNotifyEvent);
begin T := Self.OnFontChange; end;

(*----------------------------------------------------------------------------*)
procedure TGDIBackendFont_W(Self: TGDIBackend; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TGDIBackendFont_R(Self: TGDIBackend; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
Procedure TGDIBackendTextoutW2_P(Self: TGDIBackend;  var DstRect : TRect; const Flags : Cardinal; const Text : Widestring);
Begin Self.TextoutW(DstRect, Flags, Text); END;

(*----------------------------------------------------------------------------*)
Procedure TGDIBackendTextoutW1_P(Self: TGDIBackend;  X, Y : Integer; const ClipRect : TRect; const Text : Widestring);
Begin Self.TextoutW(X, Y, ClipRect, Text); END;

(*----------------------------------------------------------------------------*)
Procedure TGDIBackendTextoutW_P(Self: TGDIBackend;  X, Y : Integer; const Text : Widestring);
Begin Self.TextoutW(X, Y, Text); END;

(*----------------------------------------------------------------------------*)
Procedure TGDIBackendTextout2_P(Self: TGDIBackend;  var DstRect : TRect; const Flags : Cardinal; const Text : String);
Begin Self.Textout(DstRect, Flags, Text); END;

(*----------------------------------------------------------------------------*)
Procedure TGDIBackendTextout1_P(Self: TGDIBackend;  X, Y : Integer; const ClipRect : TRect; const Text : String);
Begin Self.Textout(X, Y, ClipRect, Text); END;

(*----------------------------------------------------------------------------*)
Procedure TGDIBackendTextout_P(Self: TGDIBackend;  X, Y : Integer; const Text : String);
Begin Self.Textout(X, Y, Text); END;

(*----------------------------------------------------------------------------*)
procedure TGDIBackendHandle_R(Self: TGDIBackend; var T: HDC);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
Procedure TGDIBackendDrawTo1_P(Self: TGDIBackend;  hDst : Cardinal; const DstRect, SrcRect : TRect);
Begin Self.DrawTo(hDst, DstRect, SrcRect); END;

(*----------------------------------------------------------------------------*)
Procedure TGDIBackendDrawTo_P(Self: TGDIBackend;  hDst : HDC; DstX, DstY : Integer);
Begin Self.DrawTo(hDst, DstX, DstY); END;

(*----------------------------------------------------------------------------*)
Procedure TGDIBackendDraw_P(Self: TGDIBackend;  const DstRect, SrcRect : TRect; hSrc : HDC);
Begin Self.Draw(DstRect, SrcRect, hSrc); END;

(*----------------------------------------------------------------------------*)
procedure TGDIBackendBitmapHandle_R(Self: TGDIBackend; var T: THandle);
begin T := Self.BitmapHandle; end;

(*----------------------------------------------------------------------------*)
procedure TGDIBackendBitmapInfo_R(Self: TGDIBackend; var T: TBitmapInfo);
begin T := Self.BitmapInfo; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGDIMemoryBackend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGDIMemoryBackend) do begin
    RegisterConstructor(@TGDIMemoryBackend.Create, 'Create');
    RegisterMethod(@TGDIMemoryBackend.Destroy, 'Free');
    RegisterMethod(@TGDIMemoryBackend.ImageNeeded, 'ImageNeeded');
    RegisterMethod(@TGDIMemoryBackend.CheckPixmap, 'CheckPixmap');
    RegisterMethod(@TGDIMemoryBackend.DoPaint, 'DoPaint');
    RegisterMethod(@TGDIMemoryBackendDraw_P, 'Draw');
    RegisterMethod(@TGDIMemoryBackendDrawTo_P, 'DrawTo');
    RegisterMethod(@TGDIMemoryBackendDrawTo1_P, 'DrawTo1');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGDIMMFBackend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGDIMMFBackend) do begin
    RegisterVirtualConstructor(@TGDIMMFBackend.Create, 'Create');
    RegisterMethod(@TGDIMMFBackend.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGDIBackend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGDIBackend) do begin
    RegisterConstructor(@TGDIBackend.Create, 'Create');
    RegisterMethod(@TGDIBackend.Destroy, 'Free');
    RegisterMethod(@TGDIBackend.Changed, 'Changed');
    RegisterMethod(@TGDIBackend.Empty, 'Empty');
    RegisterMethod(@TGDIBackend.ImageNeeded, 'ImageNeeded');
    RegisterMethod(@TGDIBackend.CheckPixmap, 'CheckPixmap');
    RegisterMethod(@TGDIBackend.DoPaint, 'DoPaint');
    RegisterMethod(@TGDIBackend.GetBitmapInfo, 'GetBitmapInfo');
    RegisterMethod(@TGDIBackend.GetBitmapHandle, 'GetBitmapHandle');
    RegisterPropertyHelper(@TGDIBackendBitmapInfo_R,nil,'BitmapInfo');
    RegisterPropertyHelper(@TGDIBackendBitmapHandle_R,nil,'BitmapHandle');
    RegisterMethod(@TGDIBackend.GetHandle, 'GetHandle');
    RegisterMethod(@TGDIBackendDraw_P, 'Draw');
    RegisterMethod(@TGDIBackendDrawTo_P, 'DrawTo');
    RegisterMethod(@TGDIBackendDrawTo1_P, 'DrawTo1');
    RegisterPropertyHelper(@TGDIBackendHandle_R,nil,'Handle');
    RegisterMethod(@TGDIBackendTextout_P, 'Textout');
    RegisterMethod(@TGDIBackendTextout1_P, 'Textout1');
    RegisterMethod(@TGDIBackendTextout2_P, 'Textout2');
    RegisterMethod(@TGDIBackend.TextExtent, 'TextExtent');
    RegisterMethod(@TGDIBackendTextoutW_P, 'TextoutW');
    RegisterMethod(@TGDIBackendTextoutW1_P, 'TextoutW1');
    RegisterMethod(@TGDIBackendTextoutW2_P, 'TextoutW2');
    RegisterMethod(@TGDIBackend.TextExtentW, 'TextExtentW');
    RegisterMethod(@TGDIBackend.GetOnFontChange, 'GetOnFontChange');
    RegisterMethod(@TGDIBackend.SetOnFontChange, 'SetOnFontChange');
    RegisterMethod(@TGDIBackend.GetFont, 'GetFont');
    RegisterMethod(@TGDIBackend.SetFont, 'SetFont');
    RegisterMethod(@TGDIBackend.UpdateFont, 'UpdateFont');
    RegisterPropertyHelper(@TGDIBackendFont_R,@TGDIBackendFont_W,'Font');
    RegisterPropertyHelper(@TGDIBackendOnFontChange_R,@TGDIBackendOnFontChange_W,'OnFontChange');
    RegisterMethod(@TGDIBackend.GetCanvasChange, 'GetCanvasChange');
    RegisterMethod(@TGDIBackend.SetCanvasChange, 'SetCanvasChange');
    RegisterMethod(@TGDIBackend.GetCanvas, 'GetCanvas');
    RegisterMethod(@TGDIBackend.DeleteCanvas, 'DeleteCanvas');
    RegisterMethod(@TGDIBackend.CanvasAllocated, 'CanvasAllocated');
    RegisterPropertyHelper(@TGDIBackendCanvas_R,nil,'Canvas');
    RegisterPropertyHelper(@TGDIBackendOnCanvasChange_R,@TGDIBackendOnCanvasChange_W,'OnCanvasChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GR32_Backends_VCL(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TGDIBackend(CL);
  RIRegister_TGDIMMFBackend(CL);
  RIRegister_TGDIMemoryBackend(CL);
end;

 
 
{ TPSImport_GR32_Backends_VCL }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_Backends_VCL.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GR32_Backends_VCL(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_Backends_VCL.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GR32_Backends_VCL(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
