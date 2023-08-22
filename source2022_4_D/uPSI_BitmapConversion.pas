unit uPSI_BitmapConversion;
{
  bezta
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
  TPSImport_BitmapConversion = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_BitmapConversion(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_BitmapConversion_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,MemUtils
  ,LinarBitmap
  ,Math
  ,Monitor
  ,MathUtils
  ,BitmapConversion
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BitmapConversion]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_BitmapConversion(CL: TPSPascalCompiler);
begin

 // TMatrix3x3 = array[1..3,1..3] of Double;
 // TMatrix4x4 = array[1..4,1..4] of Double;
 CL.AddTypeS('TMatrix3x31', 'array[1..3] of Double');
 CL.AddTypeS('TMatrix3x3', 'array[1..3] of TMatrix3x31');
 CL.AddTypeS('TMatrix4x41', 'array[1..4] of Double');
 CL.AddTypeS('TMatrix4x4', 'array[1..4] of TMatrix4x41');

 CL.AddDelphiFunction('Procedure ColorTransform( A, B, C : Byte; out X, Y, Z : Byte; const T : TMatrix4x4);');
 CL.AddDelphiFunction('Procedure ColorTransform1( A, B, C : Byte; out X, Y, Z : Float; const T : TMatrix4x4);');
 CL.AddDelphiFunction('Procedure ColorTransform2( const A, B, C : Float; out X, Y, Z : Byte; const T : TMatrix4x4);');
 CL.AddDelphiFunction('Procedure ColorTransformHSI2RGB( H, S, I : Byte; out R, G, B : Byte)');
 CL.AddDelphiFunction('Procedure ColorTransformRGB2HSI( R, G, B : Byte; out H, S, I : Byte)');
 CL.AddDelphiFunction('Procedure ColorTransformRGB2Lab( R, G, B : Byte; out L, a_, b_ : Byte)');
 CL.AddDelphiFunction('Procedure ColorTransformLab2RGB( L, a_, b_ : Byte; out R, G, B : Byte)');
 CL.AddDelphiFunction('Procedure ColorTransformRGB2LOCO( R, G, B : Byte; out S0, S1, S2 : Byte)');
 CL.AddDelphiFunction('Procedure ColorTransformLOCO2RGB( S0, S1, S2 : Byte; out R, G, B : Byte)');
 CL.AddDelphiFunction('Procedure ConvertColorSpace( Image : TLinarBitmap; const T : TMatrix4x4; NewImage : TLinarBitmap);');
 //CL.AddDelphiFunction('Procedure ConvertColorSpace1( Image : TLinarBitmap; ColorTransform : TColorTransformProc; NewImage : TLinarBitmap);');
 CL.AddDelphiFunction('Procedure ConvertToGrayscale( const Image, GrayImage : TLinarBitmap);');
 CL.AddDelphiFunction('Procedure ConvertToGrayscale1( const Image : TLinarBitmap);');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure ConvertToGrayscale1_P( const Image : TLinarBitmap);
Begin BitmapConversion.ConvertToGrayscale(Image); END;

(*----------------------------------------------------------------------------*)
Procedure ConvertToGrayscale_P( const Image, GrayImage : TLinarBitmap);
Begin BitmapConversion.ConvertToGrayscale(Image, GrayImage); END;

(*----------------------------------------------------------------------------*)
Procedure ConvertColorSpace1_P( Image : TLinarBitmap; ColorTransform : TColorTransformProc; NewImage : TLinarBitmap);
Begin BitmapConversion.ConvertColorSpace(Image, ColorTransform, NewImage); END;

(*----------------------------------------------------------------------------*)
Procedure ConvertColorSpace_P( Image : TLinarBitmap; const T : TMatrix4x4; NewImage : TLinarBitmap);
Begin BitmapConversion.ConvertColorSpace(Image, T, NewImage); END;

(*----------------------------------------------------------------------------*)
Procedure ColorTransform2_P( const A, B, C : Float; out X, Y, Z : Byte; const T : TMatrix4x4);
Begin BitmapConversion.ColorTransform(A, B, C, X, Y, Z, T); END;

(*----------------------------------------------------------------------------*)
Procedure ColorTransform1_P( A, B, C : Byte; out X, Y, Z : Float; const T : TMatrix4x4);
Begin BitmapConversion.ColorTransform(A, B, C, X, Y, Z, T); END;

(*----------------------------------------------------------------------------*)
Procedure ColorTransform_P( A, B, C : Byte; out X, Y, Z : Byte; const T : TMatrix4x4);
Begin BitmapConversion.ColorTransform(A, B, C, X, Y, Z, T); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BitmapConversion_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ColorTransform, 'ColorTransform', cdRegister);
 S.RegisterDelphiFunction(@ColorTransform1_P, 'ColorTransform1', cdRegister);
 S.RegisterDelphiFunction(@ColorTransform2_P, 'ColorTransform2', cdRegister);
 S.RegisterDelphiFunction(@ColorTransformHSI2RGB, 'ColorTransformHSI2RGB', cdRegister);
 S.RegisterDelphiFunction(@ColorTransformRGB2HSI, 'ColorTransformRGB2HSI', cdRegister);
 S.RegisterDelphiFunction(@ColorTransformRGB2Lab, 'ColorTransformRGB2Lab', cdRegister);
 S.RegisterDelphiFunction(@ColorTransformLab2RGB, 'ColorTransformLab2RGB', cdRegister);
 S.RegisterDelphiFunction(@ColorTransformRGB2LOCO, 'ColorTransformRGB2LOCO', cdRegister);
 S.RegisterDelphiFunction(@ColorTransformLOCO2RGB, 'ColorTransformLOCO2RGB', cdRegister);
 S.RegisterDelphiFunction(@ConvertColorSpace, 'ConvertColorSpace', cdRegister);
 S.RegisterDelphiFunction(@ConvertColorSpace1_P, 'ConvertColorSpace1', cdRegister);
 S.RegisterDelphiFunction(@ConvertToGrayscale, 'ConvertToGrayscale', cdRegister);
 S.RegisterDelphiFunction(@ConvertToGrayscale1_P, 'ConvertToGrayscale1', cdRegister);
end;

 
 
{ TPSImport_BitmapConversion }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BitmapConversion.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BitmapConversion(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BitmapConversion.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_BitmapConversion(ri);
  RIRegister_BitmapConversion_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
