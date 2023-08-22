unit uPSI_cyTypes;
{
   type some types
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
  TPSImport_cyTypes = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cyTypes(CL: TPSPascalCompiler);

{ run-time registration functions }

procedure Register;

implementation


uses
   Windows
  ,StdCtrls
  ,cyTypes
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyTypes]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cyTypes(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TGlyphAlignment', '( gaLeft, gaCenter, gaRight )');
  CL.AddTypeS('TGlyphLayout', '( glTop, glCenter, glBottom )');
  CL.AddTypeS('TDisabledGlyphOptions', '( dgDoNotDraw, dgDrawNormal, dgDrawMonochrome )');
  CL.AddTypeS('TCaptionRender', '( crNormal, crPathEllipsis, crEndEllipsis, crWordEllipsis )');
  CL.AddTypeS('TCaptionOrientation', '( coHorizontal, coHorizontalReversed, coVertical, coVerticalReversed )');
  CL.AddTypeS('TBgPosition', '( bgCentered, bgTopLeft, bgTopCenter, bgTopRight,'
   +' bgCenterRight, bgBottomRight, bgBottomCenter, bgBottomLeft, bgCenterLeft)');
  CL.AddTypeS('TBgStyle', '( bgNone, bgNormal, bgMosaic, bgStretch, bgStretchProportional )');
  CL.AddTypeS('TcyBevelCut', '( bcLowered, bcRaised, bcNone, bcTransparent, bcGradientToNext )');
  CL.AddTypeS('TDgradOrientation', '( dgdVertical, dgdHorizontal, dgdAngle, dgdRadial, dgdRectangle )');
  CL.AddTypeS('TDgradOrientationShape', '( osRadial, osRectangle )');
  CL.AddTypeS('TDgradBalanceMode', '( bmNormal, bmMirror, bmReverse, bmReverseFromColor, bmInvertReverse, bmInvertReverseFromColor )');
  CL.AddTypeS('TRunTimeDesignJob', '( rjNothing, rjMove, rjResizeTop, rjResizeBottom, rjResizeLeft, rjResizeTopLeft, rjResizeBottomLeft, rjResizeRight, r'
   +'jResizeTopRight, rjResizeBottomRight )');
  CL.AddTypeS('TLineCoord', 'record BottomCoord : TPoint; TopCoord : TPoint; end');
 CL.AddConstantN('cCaptionOrientationWarning','String').SetString( 'Note that text orientation doesn''t work with all fonts!');
end;

(* === run-time registration functions === *)
 
 
{ TPSImport_cyTypes }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyTypes.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyTypes(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyTypes.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_cyTypes(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
