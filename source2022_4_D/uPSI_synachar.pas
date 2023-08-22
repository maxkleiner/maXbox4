unit uPSI_synachar;
{
   synapse
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
  TPSImport_synachar = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_synachar(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_synachar_Routines(S: TPSExec);

procedure Register;

implementation


uses
  // Libc
  Windows
  ,synautil
  ,synacode
  ,synaicnv
  ,synachar
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_synachar]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_synachar(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TMimeChar', '( ISO_8859_1, ISO_8859_2, ISO_8859_3, ISO_8859_4, I'
   +'SO_8859_5, ISO_8859_6, ISO_8859_7, ISO_8859_8, ISO_8859_9, ISO_8859_10, IS'
   +'O_8859_13, ISO_8859_14, ISO_8859_15, CP1250, CP1251, CP1252, CP1253, CP125'
   +'4, CP1255, CP1256, CP1257, CP1258, KOI8_R, CP895, CP852, UCS_2, UCS_4, UTF'
   +'_8, UTF_7, UTF_7mod, UCS_2LE, UCS_4LE, UTF_16, UTF_16LE, UTF_32, UTF_32LE,'
   +' C99, JAVA, ISO_8859_16, KOI8_U, KOI8_RU, CP862, CP866, MAC, MACCE, MACICE'
   +', MACCRO, MACRO, MACCYR, MACUK, MACGR, MACTU, MACHEB, MACAR, MACTH, ROMAN8'
   +', NEXTSTEP, ARMASCII, GEORGIAN_AC, GEORGIAN_PS, KOI8_T, MULELAO, CP1133, T'
   +'IS620, CP874, VISCII, TCVN, ISO_IR_14, JIS_X0201, JIS_X0208, JIS_X0212, GB'
   +'1988_80, GB2312_80, ISO_IR_165, ISO_IR_149, EUC_JP, SHIFT_JIS, CP932, ISO_'
   +'2022_JP, ISO_2022_JP1, ISO_2022_JP2, GB2312, CP936, GB18030, ISO_2022_CN, '
   +'ISO_2022_CNE, HZ, EUC_TW, BIG5, CP950, BIG5_HKSCS, EUC_KR, CP949, CP1361, '
   +'ISO_2022_KR, CP737, CP775, CP853, CP855, CP857, CP858, CP860, CP861, CP863'
   +', CP864, CP865, CP869, CP1125 )');
  CL.AddTypeS('TMimeSetChar', 'set of TMimeChar');
 CL.AddDelphiFunction('Function CharsetConversion( const Value : AnsiString; CharFrom : TMimeChar; CharTo : TMimeChar) : AnsiString');
 CL.AddDelphiFunction('Function CharsetConversionEx( const Value : AnsiString; CharFrom : TMimeChar; CharTo : TMimeChar; const TransformTable : array of Word) : AnsiString');
 CL.AddDelphiFunction('Function CharsetConversionTrans( Value : AnsiString; CharFrom : TMimeChar; CharTo : TMimeChar; const TransformTable : array of Word; Translit : Boolean) : AnsiString');
 CL.AddDelphiFunction('Function GetCurCP : TMimeChar');
 CL.AddDelphiFunction('Function GetCurOEMCP : TMimeChar');
 CL.AddDelphiFunction('Function GetCPFromID( Value : AnsiString) : TMimeChar');
 CL.AddDelphiFunction('Function GetIDFromCP( Value : TMimeChar) : AnsiString');
 CL.AddDelphiFunction('Function NeedCharsetConversion( const Value : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function IdealCharsetCoding( const Value : AnsiString; CharFrom : TMimeChar; CharTo : TMimeSetChar) : TMimeChar');
 CL.AddDelphiFunction('Function GetBOM( Value : TMimeChar) : AnsiString');
 CL.AddDelphiFunction('Function StringToWide( const Value : AnsiString) : WideString');
 CL.AddDelphiFunction('Function WideToString( const Value : WideString) : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_synachar_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CharsetConversion, 'CharsetConversion', cdRegister);
 S.RegisterDelphiFunction(@CharsetConversionEx, 'CharsetConversionEx', cdRegister);
 S.RegisterDelphiFunction(@CharsetConversionTrans, 'CharsetConversionTrans', cdRegister);
 S.RegisterDelphiFunction(@GetCurCP, 'GetCurCP', cdRegister);
 S.RegisterDelphiFunction(@GetCurOEMCP, 'GetCurOEMCP', cdRegister);
 S.RegisterDelphiFunction(@GetCPFromID, 'GetCPFromID', cdRegister);
 S.RegisterDelphiFunction(@GetIDFromCP, 'GetIDFromCP', cdRegister);
 S.RegisterDelphiFunction(@NeedCharsetConversion, 'NeedCharsetConversion', cdRegister);
 S.RegisterDelphiFunction(@IdealCharsetCoding, 'IdealCharsetCoding', cdRegister);
 S.RegisterDelphiFunction(@GetBOM, 'GetBOM', cdRegister);
 S.RegisterDelphiFunction(@StringToWide, 'StringToWide', cdRegister);
 S.RegisterDelphiFunction(@WideToString, 'WideToString', cdRegister);
end;



{ TPSImport_synachar }
(*----------------------------------------------------------------------------*)
procedure TPSImport_synachar.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_synachar(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_synachar.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_synachar(ri);
  RIRegister_synachar_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
