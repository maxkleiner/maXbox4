unit uPSI_GLCrossPlatform;
{
   crossGL  with GLTextureCombiners;
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
  TPSImport_GLCrossPlatform = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_GLCrossPlatform(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_GLCrossPlatform_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StdCtrls
  ,ExtDlgs
  ,Consts
  ,GLTextureCombiners
  ,BumpMapping
  ,GLCrossPlatform
  ;


procedure Register;
begin
  //RegisterComponents('Pascal Script', [TPSImport_GLCrossPlatform]);
end;

function RemoveSpaces(const str : String) : String;
var
   c : Char;
   i, p, n : Integer;
begin
   n:=Length(str);
   SetLength(Result, n);
   p:=1;
   for i:=1 to n do begin
      c:=str[i];
      if c<>' ' then begin
         Result[p]:=c;
         Inc(p);
      end;
   end;
   SetLength(Result, p-1);
end;




(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_GLCrossPlatform(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TGLPoint', 'TPoint');
  //CL.AddTypeS('PGLPoint', '^TGLPoint // will not work');
  CL.AddTypeS('TGLRect', 'TRect');
  //CL.AddTypeS('PGLRect', '^TGLRect // will not work');
  CL.AddTypeS('TDelphiColor', 'TColor');
  CL.AddTypeS('TGLPicture', 'TPicture');
  CL.AddTypeS('TGLGraphic', 'TGraphic');
  CL.AddTypeS('TGLBitmap', 'TBitmap');
  //CL.AddTypeS('TGraphicClass', 'class of TGraphic');
  CL.AddTypeS('TGLTextLayout', '( tlTop, tlCenter, tlBottom )');
  CL.AddTypeS('TGLMouseButton', '( mbLeft, mbRight, mbMiddle )');
  CL.AddTypeS('TGLMouseEvent', 'Procedure ( Sender : TObject; Button : TGLMouse'
   +'Button; Shift : TShiftState; X, Y : Integer)');
  CL.AddTypeS('TGLMouseMoveEvent', 'TMouseMoveEvent');
  CL.AddTypeS('TGLKeyEvent', 'TKeyEvent');
  CL.AddTypeS('TGLKeyPressEvent', 'TKeyPressEvent');
  CL.AddTypeS('EGLOSError', 'EWin32Error');
  CL.AddTypeS('EGLOSError', 'EWin32Error');
  CL.AddTypeS('EGLOSError', 'EOSError');
 {CL.AddConstantN('glpf8Bit','').SetString( pf8bit);
 CL.AddConstantN('glpf24bit','').SetString( pf24bit);
 CL.AddConstantN('glpf32Bit','').SetString( pf32bit);
 CL.AddConstantN('glpfDevice','').SetString( pfDevice);
 CL.AddConstantN('glpf8Bit','').SetString( pf8bit);
 CL.AddConstantN('glpf24bit','').SetString( pf32bit);
 CL.AddConstantN('glpf32Bit','').SetString( pf32bit);
 CL.AddConstantN('glpfDevice','').SetString( pf32bit);
 CL.AddConstantN('glKey_TAB','').SetString( VK_TAB);
 CL.AddConstantN('glKey_SPACE','').SetString( VK_SPACE);
 CL.AddConstantN('glKey_RETURN','').SetString( VK_RETURN);
 CL.AddConstantN('glKey_DELETE','').SetString( VK_DELETE);
 CL.AddConstantN('glKey_LEFT','').SetString( VK_LEFT);
 CL.AddConstantN('glKey_RIGHT','').SetString( VK_RIGHT);
 CL.AddConstantN('glKey_HOME','').SetString( VK_HOME);
 CL.AddConstantN('glKey_END','').SetString( VK_END);
 CL.AddConstantN('glKey_CANCEL','').SetString( VK_CANCEL);
 CL.AddConstantN('glKey_UP','').SetString( VK_UP);
 CL.AddConstantN('glKey_DOWN','').SetString( VK_DOWN);
 CL.AddConstantN('glKey_TAB','').SetString( Key_Tab);
 CL.AddConstantN('glKey_SPACE','').SetString( Key_Space);
 CL.AddConstantN('glKey_RETURN','').SetString( Key_Return);
 CL.AddConstantN('glKey_DELETE','').SetString( Key_Delete);
 CL.AddConstantN('glKey_LEFT','').SetString( Key_Left);
 CL.AddConstantN('glKey_RIGHT','').SetString( Key_Right);
 CL.AddConstantN('glKey_HOME','').SetString( Key_Home);
 CL.AddConstantN('glKey_END','').SetString( Key_End);
 CL.AddConstantN('glKey_CANCEL','').SetString( Key_Escape);
 CL.AddConstantN('glKey_UP','').SetString( Key_Up);
 CL.AddConstantN('glKey_DOWN','').SetString( Key_DOWN);  }
 CL.AddConstantN('glsAllFilter','string').SetString('All'); // sAllFilter
 CL.AddDelphiFunction('Function GLPoint( const x, y : Integer) : TGLPoint');
 CL.AddDelphiFunction('Function GLRGB( const r, g, b : Byte) : TColor');
 CL.AddDelphiFunction('Function GLColorToRGB( color : TColor) : TColor');
 CL.AddDelphiFunction('Function GLGetRValue( rgb : DWORD) : Byte');
 CL.AddDelphiFunction('Function GLGetGValue( rgb : DWORD) : Byte');
 CL.AddDelphiFunction('Function GLGetBValue( rgb : DWORD) : Byte');
 CL.AddDelphiFunction('Procedure GLInitWinColors');
 CL.AddDelphiFunction('Function GLRect( const aLeft, aTop, aRight, aBottom : Integer) : TGLRect');
 CL.AddDelphiFunction('Procedure GLInflateGLRect( var aRect : TGLRect; dx, dy : Integer)');
 CL.AddDelphiFunction('Procedure GLIntersectGLRect( var aRect : TGLRect; const rect2 : TGLRect)');
 CL.AddDelphiFunction('Procedure GLInformationDlg( const msg : String)');
 CL.AddDelphiFunction('Function GLQuestionDlg( const msg : String) : Boolean');
 CL.AddDelphiFunction('Function GLInputDlg( const aCaption, aPrompt, aDefault : String) : String');
 CL.AddDelphiFunction('Function GLSavePictureDialog( var aFileName : String; const aTitle : String) : Boolean');
 CL.AddDelphiFunction('Function GLOpenPictureDialog( var aFileName : String; const aTitle : String) : Boolean');
 CL.AddDelphiFunction('Function GLApplicationTerminated : Boolean');
 CL.AddDelphiFunction('Procedure GLRaiseLastOSError');
 CL.AddDelphiFunction('Procedure GLFreeAndNil( var anObject: TObject)');
 CL.AddDelphiFunction('Function GLGetDeviceLogicalPixelsX( device : Cardinal) : Integer');
 CL.AddDelphiFunction('Function GLGetCurrentColorDepth : Integer');
 CL.AddDelphiFunction('Function GLPixelFormatToColorBits( aPixelFormat : TPixelFormat) : Integer');
 CL.AddDelphiFunction('Function GLBitmapScanLine( aBitmap : TGLBitmap; aRow : Integer) : TObject');
 CL.AddDelphiFunction('Procedure GLSleep( length : Cardinal)');
 CL.AddDelphiFunction('Procedure GLQueryPerformanceCounter( var val : Int64)');
 CL.AddDelphiFunction('Function GLQueryPerformanceFrequency( var val : Int64) : Boolean');
 CL.AddDelphiFunction('Function GLStartPrecisionTimer : Int64');
 CL.AddDelphiFunction('Function GLPrecisionTimerLap( const precisionTimer : Int64) : Double');
 CL.AddDelphiFunction('Function GLStopPrecisionTimer( const precisionTimer : Int64) : Double');
 CL.AddDelphiFunction('Function GLRDTSC : Int64');
 CL.AddDelphiFunction('Procedure GLLoadBitmapFromInstance( ABitmap : TBitmap; AName : string)');
 CL.AddDelphiFunction('Function GLOKMessageBox( const Text, Caption : string) : Integer');
 CL.AddDelphiFunction('Procedure GLShowHTMLUrl( Url : String)');
 CL.AddDelphiFunction('Procedure GLShowCursor( AShow : boolean)');
 CL.AddDelphiFunction('Procedure GLSetCursorPos( AScreenX, AScreenY : integer)');
 CL.AddDelphiFunction('Procedure GLGetCursorPos( var point : TGLPoint)');
 CL.AddDelphiFunction('Function GLGetScreenWidth : integer');
 CL.AddDelphiFunction('Function GLGetScreenHeight : integer');
 CL.AddDelphiFunction('Function GLGetTickCount : int64');
 CL.AddDelphiFunction('function RemoveSpaces(const str : String) : String;');
 CL.AddClassN(CL.FindClass('TOBJECT'),'ETextureCombinerError');
 CL.AddDelphiFunction('Procedure SetupTextureCombiners( const tcCode : String)');
   CL.AddTypeS('TNormalMapSpace', '( nmsObject, nmsTangent )');
 CL.AddDelphiFunction('Procedure CalcObjectSpaceLightVectors( Light : TAffineVector; Vertices : TAffineVectorList; Colors : TVectorList)');
 CL.AddDelphiFunction('Procedure SetupTangentSpace( Vertices, Normals, TexCoords, Tangents, BiNormals : TAffineVectorList)');
 CL.AddDelphiFunction('Procedure CalcTangentSpaceLightVectors( Light : TAffineVector; Vertices, Normals, Tangents, BiNormals : TAffineVectorList; Colors : TVectorList)');
 CL.AddDelphiFunction('Function CreateObjectSpaceNormalMap( Width, Height : Integer; HiNormals, HiTexCoords : TAffineVectorList) : TGLBitmap');
 CL.AddDelphiFunction('Function CreateTangentSpaceNormalMap( Width, Height : Integer; HiNormals, HiTexCoords, LoNormals, LoTexCoords, Tangents, BiNormals : TAffineVectorList) : TGLBitmap');



end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_GLCrossPlatform_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GLPoint, 'GLPoint', cdRegister);
 S.RegisterDelphiFunction(@RGB, 'glRGB', cdRegister);
 S.RegisterDelphiFunction(@ColorToRGB, 'glColorToRGB', cdRegister);
 S.RegisterDelphiFunction(@GetRValue, 'glGetRValue', cdRegister);
 S.RegisterDelphiFunction(@GetGValue, 'glGetGValue', cdRegister);
 S.RegisterDelphiFunction(@GetBValue, 'glGetBValue', cdRegister);
 S.RegisterDelphiFunction(@InitWinColors, 'glInitWinColors', cdRegister);
 S.RegisterDelphiFunction(@GLRect, 'GLRect', cdRegister);
 S.RegisterDelphiFunction(@InflateGLRect, 'glInflateGLRect', cdRegister);
 S.RegisterDelphiFunction(@IntersectGLRect, 'glIntersectGLRect', cdRegister);
 S.RegisterDelphiFunction(@InformationDlg, 'glInformationDlg', cdRegister);
 S.RegisterDelphiFunction(@QuestionDlg, 'glQuestionDlg', cdRegister);
 S.RegisterDelphiFunction(@InputDlg, 'glInputDlg', cdRegister);
 S.RegisterDelphiFunction(@SavePictureDialog, 'glSavePictureDialog', cdRegister);
 S.RegisterDelphiFunction(@OpenPictureDialog, 'glOpenPictureDialog', cdRegister);
 S.RegisterDelphiFunction(@ApplicationTerminated, 'glApplicationTerminated', cdRegister);
 S.RegisterDelphiFunction(@RaiseLastOSError, 'glRaiseLastOSError', cdRegister);
 S.RegisterDelphiFunction(@FreeAndNil, 'glFreeAndNil', cdRegister);
 S.RegisterDelphiFunction(@GetDeviceLogicalPixelsX, 'glGetDeviceLogicalPixelsX', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentColorDepth, 'glGetCurrentColorDepth', cdRegister);
 S.RegisterDelphiFunction(@PixelFormatToColorBits, 'glPixelFormatToColorBits', cdRegister);
 S.RegisterDelphiFunction(@BitmapScanLine, 'glBitmapScanLine', cdRegister);
 S.RegisterDelphiFunction(@Sleep, 'glSleep', cdRegister);
 S.RegisterDelphiFunction(@QueryPerformanceCounter, 'glQueryPerformanceCounter', cdRegister);
 S.RegisterDelphiFunction(@QueryPerformanceFrequency, 'glQueryPerformanceFrequency', cdRegister);
 S.RegisterDelphiFunction(@StartPrecisionTimer, 'glStartPrecisionTimer', cdRegister);
 S.RegisterDelphiFunction(@PrecisionTimerLap, 'glPrecisionTimerLap', cdRegister);
 S.RegisterDelphiFunction(@StopPrecisionTimer, 'glStopPrecisionTimer', cdRegister);
 S.RegisterDelphiFunction(@RDTSC, 'glRDTSC', cdRegister);
 S.RegisterDelphiFunction(@GLLoadBitmapFromInstance, 'GLLoadBitmapFromInstance', cdRegister);
 S.RegisterDelphiFunction(@GLOKMessageBox, 'GLOKMessageBox', cdRegister);
 S.RegisterDelphiFunction(@ShowHTMLUrl, 'glShowHTMLUrl', cdRegister);
 S.RegisterDelphiFunction(@GLShowCursor, 'GLShowCursor', cdRegister);
 S.RegisterDelphiFunction(@GLSetCursorPos, 'GLSetCursorPos', cdRegister);
 S.RegisterDelphiFunction(@GLGetCursorPos, 'GLGetCursorPos', cdRegister);
 S.RegisterDelphiFunction(@GLGetScreenWidth, 'GLGetScreenWidth', cdRegister);
 S.RegisterDelphiFunction(@GLGetScreenHeight, 'GLGetScreenHeight', cdRegister);
 S.RegisterDelphiFunction(@GLGetTickCount, 'GLGetTickCount', cdRegister);
  S.RegisterDelphiFunction(@RemoveSpaces, 'RemoveSpaces', cdRegister);
  S.RegisterDelphiFunction(@SetupTextureCombiners, 'SetupTextureCombiners', cdRegister);
  S.RegisterDelphiFunction(@CalcObjectSpaceLightVectors, 'CalcObjectSpaceLightVectors', cdRegister);
 S.RegisterDelphiFunction(@SetupTangentSpace, 'SetupTangentSpace', cdRegister);
 S.RegisterDelphiFunction(@CalcTangentSpaceLightVectors, 'CalcTangentSpaceLightVectors', cdRegister);
 S.RegisterDelphiFunction(@CreateObjectSpaceNormalMap, 'CreateObjectSpaceNormalMap', cdRegister);
 S.RegisterDelphiFunction(@CreateTangentSpaceNormalMap, 'CreateTangentSpaceNormalMap', cdRegister);


 end;



{ TPSImport_GLCrossPlatform }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GLCrossPlatform.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GLCrossPlatform(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GLCrossPlatform.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_GLCrossPlatform(ri);
  RIRegister_GLCrossPlatform_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
