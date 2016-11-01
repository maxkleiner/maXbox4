unit uPSI_xutils;
{
  from ataria pascal

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
  TPSImport_xutils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_xutils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_xutils_Routines(S: TPSExec);

procedure Register;

implementation


uses
  { tpautils
  ,vpautils
  ,fpautils
  ,dpautils
  ,gpautils
  ,objects    }
  xutils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xutils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_xutils(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PshortString', '^ShortString // will not work');
 CL.AddConstantN('EXIT_DOSERROR','LongInt').SetInt( 2);
 CL.AddConstantN('EXIT_ERROR','LongInt').SetInt( 1);
 CL.AddConstantN('adCmdTxt','LongInt').SetInt($00000001);
 CL.AddConstantN('adExecNoRecords','LongInt').SetInt($00000080);
  CL.AddConstantN('BOM_UTF8','String').SetString( #$EF#$BB#$BF);
 CL.AddConstantN('BOM_UTF32_BE','String').SetString( #00#00#$FE#$FF);
 CL.AddConstantN('BOM_UTF32_LE','String').SetString( #$FF#$FE#00#00);
 CL.AddConstantN('BOM_UTF16_BE','String').SetString( #$FE#$FF);
 CL.AddConstantN('BOM_UTF16_LE','String').SetString( #$FF#$FE);

 //const adCmdTxt = $00000001;
      //adExecNoRecords = $00000080;
 CL.AddDelphiFunction('Function AnsiFileExists( const FName : string) : Boolean');
 CL.AddDelphiFunction('Function AnsiDirectoryExists( DName : string) : Boolean');
 CL.AddDelphiFunction('Procedure SwapLong2( var x : longword)');
 CL.AddDelphiFunction('Procedure SwapWord2( var x : word)');
 CL.AddDelphiFunction('Function UpString( s : string) : string');
 CL.AddDelphiFunction('Function LowString( s : string) : string');
 CL.AddDelphiFunction('Function AddDoubleQuotes( s : string) : string');
 CL.AddDelphiFunction('Function RemoveDoubleQuotes( s : string) : string');
 CL.AddDelphiFunction('Procedure StreamErrorProcedure( var S : TStream)');
 CL.AddDelphiFunction('Function StrToken( var Text : String; Delimiter : Char; UseQuotes : boolean) : String');
 CL.AddDelphiFunction('Function StrGetNextLine( var Text : String) : String');
 CL.AddDelphiFunction('Function TrimLeftx( const S : string) : string');
 CL.AddDelphiFunction('Function TrimRightx( const S : string) : string');
 CL.AddDelphiFunction('Function hexstr( val : longint; cnt : byte) : string');
 CL.AddDelphiFunction('Function decstr( val : longint; cnt : byte) : string');
 CL.AddDelphiFunction('Function decstrunsigned( l : longword; cnt : byte) : string');
 CL.AddDelphiFunction('Function boolstr( val : boolean; cnt : byte) : string');
 CL.AddDelphiFunction('Function CompareByte( buf1, buf2 : pchar; len : longint) : integer');
 CL.AddDelphiFunction('Function Trimx( const S : string) : string');
 CL.AddDelphiFunction('Function Printf2( const s : string; var Buf: string; size : word) : string');
 CL.AddDelphiFunction('Function Printfx( const s : string; var Buf: string; size : word) : string');

 CL.AddDelphiFunction('Function FillTo( s : string; tolength : integer) : string');
 CL.AddDelphiFunction('Function stringdup( const s : string) : string');
 //CL.AddDelphiFunction('Procedure stringdispose( var p : pShortstring)');
 CL.AddDelphiFunction('Function EscapeToPascal( const s : string; var code : integer) : string');
 CL.AddDelphiFunction('Function ValDecimal( const S : String; var code : integer) : longint');
 CL.AddDelphiFunction('Function ValUnsignedDecimal( const S : String; var code : integer) : longword');
 CL.AddDelphiFunction('Function ValOctal( const S : String; var code : integer) : longint');
 CL.AddDelphiFunction('Function ValBinary( const S : String; var code : integer) : longint');
 CL.AddDelphiFunction('Function ValHexadecimal( const S : String; var code : integer) : longint');
 CL.AddDelphiFunction('Function CleanString( const s : string) : string');
 CL.AddDelphiFunction('Function ChangeFileExt2( const FileName, Extension : string) : string');
 CL.AddDelphiFunction('Function fillwithzero( s : string; newlength : integer) : string');
 CL.AddDelphiFunction('Function removenulls( const s : string) : string');
 //CL.AddConstantN('WhiteSpace','Char').SetString( ' ' or  #10 or  #13 or  #9);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_xutils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AnsiFileExists, 'AnsiFileExists', cdRegister);
 S.RegisterDelphiFunction(@AnsiDirectoryExists, 'AnsiDirectoryExists', cdRegister);
 S.RegisterDelphiFunction(@SwapLong, 'SwapLong2', cdRegister);
 S.RegisterDelphiFunction(@SwapWord, 'SwapWord2', cdRegister);
 S.RegisterDelphiFunction(@UpString, 'UpString', cdRegister);
 S.RegisterDelphiFunction(@LowString, 'LowString', cdRegister);
 S.RegisterDelphiFunction(@AddDoubleQuotes, 'AddDoubleQuotes', cdRegister);
 S.RegisterDelphiFunction(@RemoveDoubleQuotes, 'RemoveDoubleQuotes', cdRegister);
 S.RegisterDelphiFunction(@StreamErrorProcedure, 'StreamErrorProcedure', cdRegister);
 S.RegisterDelphiFunction(@StrToken, 'StrToken', cdRegister);
 S.RegisterDelphiFunction(@StrGetNextLine, 'StrGetNextLine', cdRegister);
 S.RegisterDelphiFunction(@TrimLeft, 'TrimLeftx', cdRegister);
 S.RegisterDelphiFunction(@TrimRight, 'TrimRightx', cdRegister);
 S.RegisterDelphiFunction(@hexstr, 'hexstr', cdRegister);
 S.RegisterDelphiFunction(@decstr, 'decstr', cdRegister);
 S.RegisterDelphiFunction(@decstrunsigned, 'decstrunsigned', cdRegister);
 S.RegisterDelphiFunction(@boolstr, 'boolstr', cdRegister);
 S.RegisterDelphiFunction(@CompareByte, 'CompareByte', cdRegister);
 S.RegisterDelphiFunction(@Trim, 'Trimx', cdRegister);
 S.RegisterDelphiFunction(@Printf, 'Printf2', cdRegister);
 S.RegisterDelphiFunction(@Printf, 'Printfx', cdRegister);

 S.RegisterDelphiFunction(@FillTo, 'FillTo', cdRegister);
 S.RegisterDelphiFunction(@stringdup, 'stringdup', cdRegister);
 //S.RegisterDelphiFunction(@stringdispose, 'stringdispose', cdRegister);
 S.RegisterDelphiFunction(@EscapeToPascal, 'EscapeToPascal', cdRegister);
 S.RegisterDelphiFunction(@ValDecimal, 'ValDecimal', cdRegister);
 S.RegisterDelphiFunction(@ValUnsignedDecimal, 'ValUnsignedDecimal', cdRegister);
 S.RegisterDelphiFunction(@ValOctal, 'ValOctal', cdRegister);
 S.RegisterDelphiFunction(@ValBinary, 'ValBinary', cdRegister);
 S.RegisterDelphiFunction(@ValHexadecimal, 'ValHexadecimal', cdRegister);
 S.RegisterDelphiFunction(@CleanString, 'CleanString', cdRegister);
 S.RegisterDelphiFunction(@ChangeFileExt, 'ChangeFileExt2', cdRegister);
 S.RegisterDelphiFunction(@fillwithzero, 'fillwithzero', cdRegister);
 S.RegisterDelphiFunction(@removenulls, 'removenulls', cdRegister);
end;

 
 
{ TPSImport_xutils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xutils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xutils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xutils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_xutils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
