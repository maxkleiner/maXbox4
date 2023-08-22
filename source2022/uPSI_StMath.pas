unit uPSI_StMath;
{
  added functions of SysTools4   with dumpexception from unit StExpEng;
  and from unit uPSI_StCRC;
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
  TPSImport_StMath = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_StMath(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StMath_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,StDate
  ,StBase
  ,StConst
  ,StMath
  //,StExpLog
  ,StExpEng
  ,StCRC
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StMath]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StMath(CL: TPSPascalCompiler);
begin

 //CL.AddConstantN('OnHookInstaller','').SetString();
 CL.AddDelphiFunction('Procedure DumpException');
 CL.AddConstantN('RadCor','Double').setExtended( 57.29577951308232);
 CL.AddDelphiFunction('Function IntPowerS( Base : Extended; Exponent : Integer) : Extended');
 CL.AddDelphiFunction('Function PowerS( Base, Exponent : Extended) : Extended');
 CL.AddDelphiFunction('Function StInvCos( X : Double) : Double');
 CL.AddDelphiFunction('Function StInvSin( Y : Double) : Double');
 CL.AddDelphiFunction('Function StInvTan2( X, Y : Double) : Double');
 CL.AddDelphiFunction('Function StTan( A : Double) : Double');
 CL.AddConstantN('CrcBufSize','LongInt').SetInt( 2048);
 CL.AddDelphiFunction('Function Adler32Prim( var Data, DataSize : Cardinal; CurCrc : LongInt) : LongInt');
 CL.AddDelphiFunction('Function Adler32OfStream( Stream : TStream; CurCrc : LongInt) : LongInt');
 CL.AddDelphiFunction('Function Adler32OfFile( FileName : AnsiString) : LongInt');
 CL.AddDelphiFunction('Function Crc16Prim( var Data, DataSize, CurCrc : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function Crc16OfStream( Stream : TStream; CurCrc : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function Crc16OfFile( FileName : AnsiString) : Cardinal');
 CL.AddDelphiFunction('Function Crc32Prim( var Data, DataSize : Cardinal; CurCrc : LongInt) : LongInt');
 CL.AddDelphiFunction('Function Crc32OfStream( Stream : TStream; CurCrc : LongInt) : LongInt');
 CL.AddDelphiFunction('Function Crc32OfFile( FileName : AnsiString) : LongInt');
 CL.AddDelphiFunction('Function InternetSumPrim( var Data, DataSize, CurCrc : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function InternetSumOfStream( Stream : TStream; CurCrc : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function InternetSumOfFile( FileName : AnsiString) : Cardinal');
 CL.AddDelphiFunction('Function Kermit16Prim( var Data, DataSize, CurCrc : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function Kermit16OfStream( Stream : TStream; CurCrc : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function Kermit16OfFile( FileName : AnsiString) : Cardinal');


end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StMath_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IntPower, 'IntPowerS', cdRegister);
 S.RegisterDelphiFunction(@Power, 'PowerS', cdRegister);
 S.RegisterDelphiFunction(@StInvCos, 'StInvCos', cdRegister);
 S.RegisterDelphiFunction(@StInvSin, 'StInvSin', cdRegister);
 S.RegisterDelphiFunction(@StInvTan2, 'StInvTan2', cdRegister);
 S.RegisterDelphiFunction(@StTan, 'StTan', cdRegister);
 S.RegisterDelphiFunction(@DumpException, 'DumpException', cdRegister);

 S.RegisterDelphiFunction(@Adler32Prim, 'Adler32Prim', cdRegister);
 S.RegisterDelphiFunction(@Adler32OfStream, 'Adler32OfStream', cdRegister);
 S.RegisterDelphiFunction(@Adler32OfFile, 'Adler32OfFile', cdRegister);
 S.RegisterDelphiFunction(@Crc16Prim, 'Crc16Prim', cdRegister);
 S.RegisterDelphiFunction(@Crc16OfStream, 'Crc16OfStream', cdRegister);
 S.RegisterDelphiFunction(@Crc16OfFile, 'Crc16OfFile', cdRegister);
 S.RegisterDelphiFunction(@Crc32Prim, 'Crc32Prim', cdRegister);
 S.RegisterDelphiFunction(@Crc32OfStream, 'Crc32OfStream', cdRegister);
 S.RegisterDelphiFunction(@Crc32OfFile, 'Crc32OfFile', cdRegister);
 S.RegisterDelphiFunction(@InternetSumPrim, 'InternetSumPrim', cdRegister);
 S.RegisterDelphiFunction(@InternetSumOfStream, 'InternetSumOfStream', cdRegister);
 S.RegisterDelphiFunction(@InternetSumOfFile, 'InternetSumOfFile', cdRegister);
 S.RegisterDelphiFunction(@Kermit16Prim, 'Kermit16Prim', cdRegister);
 S.RegisterDelphiFunction(@Kermit16OfStream, 'Kermit16OfStream', cdRegister);
 S.RegisterDelphiFunction(@Kermit16OfFile, 'Kermit16OfFile', cdRegister);

end;



{ TPSImport_StMath }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StMath.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StMath(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StMath.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_StMath(ri);
  RIRegister_StMath_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
