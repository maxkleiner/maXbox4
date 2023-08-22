unit uPSI_Console;
{
   to console to terminal
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
  TPSImport_Console = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_Console(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Console_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Console
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Console]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_Console(CL: TPSPascalCompiler);
begin
 {CL.AddConstantN('Black','LongInt').SetInt( 0);
 CL.AddConstantN('Blue','LongInt').SetInt( 1);
 CL.AddConstantN('Green','LongInt').SetInt( 2);
 CL.AddConstantN('Cyan','LongInt').SetInt( 3);
 CL.AddConstantN('Red','LongInt').SetInt( 4);
 CL.AddConstantN('Magenta','LongInt').SetInt( 5);
 CL.AddConstantN('Brown','LongInt').SetInt( 6);
 CL.AddConstantN('LightGray','LongInt').SetInt( 7);
 CL.AddConstantN('DarkGray','LongInt').SetInt( 8);
 CL.AddConstantN('LightBlue','LongInt').SetInt( 9);
 CL.AddConstantN('LightGreen','LongInt').SetInt( 10);
 CL.AddConstantN('LightCyan','LongInt').SetInt( 11);
 CL.AddConstantN('LightRed','LongInt').SetInt( 12);
 CL.AddConstantN('LightMagenta','LongInt').SetInt( 13);
 CL.AddConstantN('Yellow','LongInt').SetInt( 14);
 CL.AddConstantN('White','LongInt').SetInt( 15); }
// CL.AddConstantN('Blink','LongInt').SetInt( 128);
 CL.AddConstantN('conBW40','LongInt').SetInt( 0);
 CL.AddConstantN('conCO40','LongInt').SetInt( 1);
 CL.AddConstantN('conBW80','LongInt').SetInt( 2);
 CL.AddConstantN('conCO80','LongInt').SetInt( 3);
 CL.AddConstantN('conMono','LongInt').SetInt( 7);
 CL.AddConstantN('conFont8x8','LongInt').SetInt( 256);
 //CL.AddConstantN('C40','').SetString( CO40);
 //CL.AddConstantN('C80','').SetString( CO80);
 CL.AddDelphiFunction('Function conReadKey : Char');
 CL.AddDelphiFunction('Function conKeyPressed : Boolean');
 CL.AddDelphiFunction('Procedure conGotoXY( X, Y : Smallint)');
 CL.AddDelphiFunction('Function conWhereX : Integer');
 CL.AddDelphiFunction('Function conWhereY : Integer');
 CL.AddDelphiFunction('Procedure conTextColor( Color : Byte);');
 CL.AddDelphiFunction('Function conTextColor1 : Byte;');
 CL.AddDelphiFunction('Procedure conTextBackground( Color : Byte);');
 CL.AddDelphiFunction('Function conTextBackground1 : Byte;');
 CL.AddDelphiFunction('Procedure conTextMode( Mode : Word)');
 CL.AddDelphiFunction('Procedure conLowVideo');
 CL.AddDelphiFunction('Procedure conHighVideo');
 CL.AddDelphiFunction('Procedure conNormVideo');
 CL.AddDelphiFunction('Procedure conClrScr');
 CL.AddDelphiFunction('Procedure conClrEol');
 CL.AddDelphiFunction('Procedure conInsLine');
 CL.AddDelphiFunction('Procedure conDelLine');
 CL.AddDelphiFunction('Procedure conWindow( Left, Top, Right, Bottom : Integer)');
 CL.AddDelphiFunction('Function conScreenWidth : Smallint');
 CL.AddDelphiFunction('Function conScreenHeight : Smallint');
 CL.AddDelphiFunction('Function conBufferWidth : Smallint');
 CL.AddDelphiFunction('Function conBufferHeight : Smallint');
 CL.AddDelphiFunction('procedure InitScreenMode;');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TextBackground1_P : Byte;
Begin Result := Console.TextBackground; END;

(*----------------------------------------------------------------------------*)
Procedure TextBackground_P( Color : Byte);
Begin Console.TextBackground(Color); END;

(*----------------------------------------------------------------------------*)
Function TextColor1_P : Byte;
Begin Result := Console.TextColor; END;

(*----------------------------------------------------------------------------*)
Procedure TextColor_P( Color : Byte);
Begin Console.TextColor(Color); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Console_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ReadKey, 'conReadKey', cdRegister);
 S.RegisterDelphiFunction(@KeyPressed, 'conKeyPressed', cdRegister);
 S.RegisterDelphiFunction(@GotoXY, 'conGotoXY', cdRegister);
 S.RegisterDelphiFunction(@WhereX, 'conWhereX', cdRegister);
 S.RegisterDelphiFunction(@WhereY, 'conWhereY', cdRegister);
 S.RegisterDelphiFunction(@TextColor, 'conTextColor', cdRegister);
 S.RegisterDelphiFunction(@TextColor1_P, 'conTextColor1', cdRegister);
 S.RegisterDelphiFunction(@TextBackground, 'conTextBackground', cdRegister);
 S.RegisterDelphiFunction(@TextBackground1_P, 'conTextBackground1', cdRegister);
 S.RegisterDelphiFunction(@TextMode, 'conTextMode', cdRegister);
 S.RegisterDelphiFunction(@LowVideo, 'conLowVideo', cdRegister);
 S.RegisterDelphiFunction(@HighVideo, 'conHighVideo', cdRegister);
 S.RegisterDelphiFunction(@NormVideo, 'conNormVideo', cdRegister);
 S.RegisterDelphiFunction(@ClrScr, 'conClrScr', cdRegister);
 S.RegisterDelphiFunction(@ClrEol, 'conClrEol', cdRegister);
 S.RegisterDelphiFunction(@InsLine, 'conInsLine', cdRegister);
 S.RegisterDelphiFunction(@DelLine, 'conDelLine', cdRegister);
 S.RegisterDelphiFunction(@Window, 'conWindow', cdRegister);
 S.RegisterDelphiFunction(@ScreenWidth, 'conScreenWidth', cdRegister);
 S.RegisterDelphiFunction(@ScreenHeight, 'conScreenHeight', cdRegister);
 S.RegisterDelphiFunction(@BufferWidth, 'conBufferWidth', cdRegister);
 S.RegisterDelphiFunction(@BufferHeight, 'conBufferHeight', cdRegister);
 S.RegisterDelphiFunction(@InitScreenMode, 'InitScreenMode', cdRegister);
// procedure InitScreenMode; from initialize
end;


 
{ TPSImport_Console }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Console.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Console(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Console.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_Console(ri);
  RIRegister_Console_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
