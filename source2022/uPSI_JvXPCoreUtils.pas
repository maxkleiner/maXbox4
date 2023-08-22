unit uPSI_JvXPCoreUtils;
{
   with XPCore
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
  TPSImport_JvXPCoreUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JvXPCoreUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvXPCoreUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
  // JclUnitVersioning
  //,TypInfo
  //,Windows
  //Graphics
  Controls
  ,JvJCLUtils
  ,JvXPCore
  ,JvXPCoreUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvXPCoreUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JvXPCoreUtils(CL: TPSPascalCompiler);
begin
// CL.AddDelphiFunction('Function JvXPMethodsEqual( const Method1, Method2 : TMethod) : Boolean');
 CL.AddDelphiFunction('Procedure JvXPDrawLine( const ACanvas : TCanvas; const X1, Y1, X2, Y2 : Integer)');
 CL.AddDelphiFunction('Procedure JvXPCreateGradientRect( const AWidth, AHeight : Integer; const StartColor, EndColor : TColor; const Colors : TJvXPGradientColors; const Style : TJvXPGradientStyle; const Dithered : Boolean; var Bitmap : TBitmap)');
 CL.AddDelphiFunction('Procedure JvXPAdjustBoundRect( const BorderWidth : Byte; const ShowBoundLines : Boolean; const BoundLines : TJvXPBoundLines; var Rect : TRect)');
 CL.AddDelphiFunction('Procedure JvXPDrawBoundLines( const ACanvas : TCanvas; const BoundLines : TJvXPBoundLines; const AColor : TColor; const Rect : TRect)');
 CL.AddDelphiFunction('Procedure JvXPConvertToGray2( Bitmap : TBitmap)');
 CL.AddDelphiFunction('Procedure JvXPRenderText( const AParent : TControl; const ACanvas : TCanvas; ACaption : TCaption; const AFont : TFont; const AEnabled, AShowAccelChar : Boolean; var ARect : TRect; AFlags : Integer)');
 CL.AddDelphiFunction('Procedure JvXPFrame3D( const ACanvas : TCanvas; const Rect : TRect; const TopColor, BottomColor : TColor; const Swapped : Boolean)');
 CL.AddDelphiFunction('Procedure JvXPColorizeBitmap( Bitmap : TBitmap; const AColor : TColor)');
 CL.AddDelphiFunction('Procedure JvXPSetDrawFlags( const AAlignment : TAlignment; const AWordWrap : Boolean; var Flags : Integer)');
 CL.AddDelphiFunction('Procedure JvXPPlaceText( const AParent : TControl; const ACanvas : TCanvas; const AText : TCaption; const AFont : TFont; const AEnabled, AShowAccelChar : Boolean; const AAlignment : TAlignment; const AWordWrap : Boolean; var Rect : TRect)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JvXPCoreUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@JvXPMethodsEqual, 'JvXPMethodsEqual', cdRegister);
 S.RegisterDelphiFunction(@JvXPDrawLine, 'JvXPDrawLine', cdRegister);
 S.RegisterDelphiFunction(@JvXPCreateGradientRect, 'JvXPCreateGradientRect', cdRegister);
 S.RegisterDelphiFunction(@JvXPAdjustBoundRect, 'JvXPAdjustBoundRect', cdRegister);
 S.RegisterDelphiFunction(@JvXPDrawBoundLines, 'JvXPDrawBoundLines', cdRegister);
 S.RegisterDelphiFunction(@JvXPConvertToGray2, 'JvXPConvertToGray2', cdRegister);
 S.RegisterDelphiFunction(@JvXPRenderText, 'JvXPRenderText', cdRegister);
 S.RegisterDelphiFunction(@JvXPFrame3D, 'JvXPFrame3D', cdRegister);
 S.RegisterDelphiFunction(@JvXPColorizeBitmap, 'JvXPColorizeBitmap', cdRegister);
 S.RegisterDelphiFunction(@JvXPSetDrawFlags, 'JvXPSetDrawFlags', cdRegister);
 S.RegisterDelphiFunction(@JvXPPlaceText, 'JvXPPlaceText', cdRegister);
end;

 
 
{ TPSImport_JvXPCoreUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvXPCoreUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvXPCoreUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvXPCoreUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JvXPCoreUtils(ri);
  RIRegister_JvXPCoreUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
