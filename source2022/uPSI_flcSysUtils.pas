unit uPSI_flcSysUtils;
{
flcSysUtils.pas  //2 functions with cwindows possible + freqObj +TBytes utils

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
  TPSImport_flcSysUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TfreqObj(CL: TPSPascalCompiler);
procedure SIRegister_flcSysUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_flcSysUtils_Routines(S: TPSExec);
procedure RIRegister_TfreqObj(CL: TPSRuntimeClassImporter);
procedure RIRegister_flcSysUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   flcSysUtils, cfundamentutils
  ;
 

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_flcSysUtils]);
end;

procedure myinclude(var aset:tsyscharset; achar:char);
begin
   include(aset, achar) ;
end;

procedure myexclude(var aset:tsyscharset; achar:char);
begin
   exclude(aset, achar);
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TfreqObj(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TfreqObj') do
  with CL.AddClassN(CL.FindClass('TObject'),'TfreqObj') do begin
    RegisterProperty('ftemp', 'INTEGER', iptrw);
    RegisterProperty('f', 'INTEGER', iptrw);
    RegisterProperty('P', 'INTEGER', iptrw);
    RegisterProperty('a', 'INTEGER', iptrw);
    RegisterProperty('shape', 'INTEGER', iptrw);
    RegisterProperty('StringRep', 'String', iptrw);
    RegisterMethod('Constructor Create( newf, newP, newA, newshape : integer)');
    RegisterMethod('Procedure makestringrep');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_flcSysUtils(CL: TPSPascalCompiler);
begin
  SIRegister_TfreqObj(CL);
  CL.AddTypeS('MSArray','array[0..1] of tmemorystream;');
  CL.AddTypeS('TPoint3D2', 'record x : single; y : single; z : single; end;');
 CL.AddDelphiFunction('Function GetLastOSErrorCode : NativeInt');
 CL.AddDelphiFunction('Function GetLastOSErrorMessage : String');
 CL.AddDelphiFunction('Procedure TForm1msPlaySound( MS : MSArray; streaminuse : integer; aloop : boolean)');
 CL.AddDelphiFunction('Procedure BytesSetLengthAndZero( var V : TBytes; const NewLength : NativeInt)');
 CL.AddDelphiFunction('Procedure BytesInit( var V : TBytes; const R : Byte)');
 CL.AddDelphiFunction('Procedure BytesInit1( var V : TBytes; const S : String)');
 CL.AddDelphiFunction('Function BytesAppend( var V : TBytes; const R : Byte) : NativeInt');
 CL.AddDelphiFunction('Function BytesAppend1( var V : TBytes; const R : TBytes) : NativeInt');
 CL.AddDelphiFunction('Function BytesAppend2( var V : TBytes; const R : array of Byte) : NativeInt');
 CL.AddDelphiFunction('Function BytesAppend3( var V : TBytes; const R : String) : NativeInt');
 CL.AddDelphiFunction('Function BytesCompare( const A, B : TBytes) : Integer');
 CL.AddDelphiFunction('Function BytesEqual( const A, B : TBytes) : Boolean');
 CL.AddDelphiFunction('function StringRefCount2(const S: AnsiString): Integer;');
CL.AddDelphiFunction('function  hton16(const A: Word): Word;');
CL.AddDelphiFunction('function  ntoh16(const A: Word): Word;');
CL.AddDelphiFunction('function  hton32(const A: LongWord): LongWord;');
CL.AddDelphiFunction('function  ntoh32(const A: LongWord): LongWord;');
CL.AddDelphiFunction('function  hton64(const A: Int64): Int64;');
CL.AddDelphiFunction('function  ntoh64(const A: Int64): Int64;');
//CL.AddTypeS('CharSet', 'set of Char');
//CL.AddDelphiFunction('procedure Include(var aset:tsyscharset; achar:char)');     ---> cfundamentutils
//CL.AddDelphiFunction('procedure Exclude(var aset:tsyscharset; achar:char)');
{                                                                              }
{ Network byte order                                                           }
{                                                                              }

CL.AddDelphiFunction('function SphereTPoint3D(Phi, Lambda: Double): TPoint3D2;');
CL.AddDelphiFunction('function RotateAroundXTPoint3D(const P: TPoint3D2; Alfa: Double): TPoint3D2;');
CL.AddDelphiFunction('function RotateAroundYTPoint3D(const P: TPoint3D2; Beta: Double): TPoint3D2;');

CL.AddDelphiFunction('function ByteCharDigitToInt(const A: Char): Integer;');
CL.AddDelphiFunction('function WideCharDigitToInt(const A: WideChar): Integer;');
CL.AddDelphiFunction('function CharDigitToInt(const A: Char): Integer;');
CL.AddDelphiFunction('function IntToByteCharDigit(const A: Integer): Char;');
CL.AddDelphiFunction('function IntToWideCharDigit(const A: Integer): WideChar;');
CL.AddDelphiFunction('function IntToCharDigit(const A: Integer): Char;');
CL.AddDelphiFunction('function flcMinInt(const A, B: Int64): Int64;');
CL.AddDelphiFunction('function flcMaxInt(const A, B: Int64): Int64;');


//function RotateAroundXTPoint3D(const P: TPoint3D2; Alfa: Double): TPoint3D2;
//function RotateAroundYTPoint3D(const P: TPoint3D2; Beta: Double): TPoint3D2;
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TfreqObjStringRep_W(Self: TfreqObj; const T: String);
Begin Self.StringRep := T; end;

(*----------------------------------------------------------------------------*)
procedure TfreqObjStringRep_R(Self: TfreqObj; var T: String);
Begin T := Self.StringRep; end;

(*----------------------------------------------------------------------------*)
procedure TfreqObjshape_W(Self: TfreqObj; const T: INTEGER);
Begin Self.shape := T; end;

(*----------------------------------------------------------------------------*)
procedure TfreqObjshape_R(Self: TfreqObj; var T: INTEGER);
Begin T := Self.shape; end;

(*----------------------------------------------------------------------------*)
procedure TfreqObja_W(Self: TfreqObj; const T: INTEGER);
Begin Self.a := T; end;

(*----------------------------------------------------------------------------*)
procedure TfreqObja_R(Self: TfreqObj; var T: INTEGER);
Begin T := Self.a; end;

(*----------------------------------------------------------------------------*)
procedure TfreqObjP_W(Self: TfreqObj; const T: INTEGER);
Begin Self.P := T; end;

(*----------------------------------------------------------------------------*)
procedure TfreqObjP_R(Self: TfreqObj; var T: INTEGER);
Begin T := Self.P; end;

(*----------------------------------------------------------------------------*)
procedure TfreqObjf_W(Self: TfreqObj; const T: INTEGER);
Begin Self.f := T; end;

(*----------------------------------------------------------------------------*)
procedure TfreqObjf_R(Self: TfreqObj; var T: INTEGER);
Begin T := Self.f; end;

(*----------------------------------------------------------------------------*)
procedure TfreqObjftemp_W(Self: TfreqObj; const T: INTEGER);
Begin Self.ftemp := T; end;

(*----------------------------------------------------------------------------*)
procedure TfreqObjftemp_R(Self: TfreqObj; var T: INTEGER);
Begin T := Self.ftemp; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcSysUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetLastOSErrorCode, 'GetLastOSErrorCode', cdRegister);
 S.RegisterDelphiFunction(@GetLastOSErrorMessage, 'GetLastOSErrorMessage', cdRegister);
 S.RegisterDelphiFunction(@TForm1msPlaySound, 'TForm1msPlaySound', cdRegister);
 S.RegisterDelphiFunction(@BytesSetLengthAndZero, 'BytesSetLengthAndZero', cdRegister);
 S.RegisterDelphiFunction(@BytesInit, 'BytesInit', cdRegister);
 S.RegisterDelphiFunction(@BytesInit1, 'BytesInit1', cdRegister);
 S.RegisterDelphiFunction(@BytesAppend, 'BytesAppend', cdRegister);
 S.RegisterDelphiFunction(@BytesAppend1, 'BytesAppend1', cdRegister);
 S.RegisterDelphiFunction(@BytesAppend2, 'BytesAppend2', cdRegister);
 S.RegisterDelphiFunction(@BytesAppend3, 'BytesAppend3', cdRegister);
 S.RegisterDelphiFunction(@BytesCompare, 'BytesCompare', cdRegister);
 S.RegisterDelphiFunction(@BytesEqual, 'BytesEqual', cdRegister);
 S.RegisterDelphiFunction(@StringRefCount2, 'StringRefCount2', cdRegister);
 S.RegisterDelphiFunction(@hton16, 'hton16', cdRegister);
 S.RegisterDelphiFunction(@ntoh16, 'ntoh16', cdRegister);
 S.RegisterDelphiFunction(@hton32, 'hton32', cdRegister);
 S.RegisterDelphiFunction(@ntoh32, 'ntoh32', cdRegister);
 S.RegisterDelphiFunction(@hton64, 'hton64', cdRegister);
 S.RegisterDelphiFunction(@ntoh64, 'ntoh64', cdRegister);

 S.RegisterDelphiFunction(@SphereTPoint3D, 'SphereTPoint3D', cdRegister);
 S.RegisterDelphiFunction(@RotateAroundXTPoint3D, 'RotateAroundXTPoint3D', cdRegister);
 S.RegisterDelphiFunction(@RotateAroundYTPoint3D, 'RotateAroundYTPoint3D', cdRegister);
// S.RegisterDelphiFunction(@myinclude, 'Include', cdRegister);
// S.RegisterDelphiFunction(@myexclude, 'Exclude', cdRegister);
  S.RegisterDelphiFunction(@ByteCharDigitToInt, 'ByteCharDigitToInt', cdRegister);
  S.RegisterDelphiFunction(@WideCharDigitToInt, 'WideCharDigitToInt', cdRegister);
  S.RegisterDelphiFunction(@CharDigitToInt, 'CharDigitToInt', cdRegister);
  S.RegisterDelphiFunction(@IntToByteCharDigit, 'IntToByteCharDigit', cdRegister);
  S.RegisterDelphiFunction(@IntToWideCharDigit, 'IntToWideCharDigit', cdRegister);
  S.RegisterDelphiFunction(@IntToCharDigit, 'IntToCharDigit', cdRegister);
  S.RegisterDelphiFunction(@MinInt, 'flcMinInt', cdRegister);
 S.RegisterDelphiFunction(@MaxInt, 'flcMaxInt', cdRegister);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TfreqObj(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TfreqObj) do begin
    RegisterPropertyHelper(@TfreqObjftemp_R,@TfreqObjftemp_W,'ftemp');
    RegisterPropertyHelper(@TfreqObjf_R,@TfreqObjf_W,'f');
    RegisterPropertyHelper(@TfreqObjP_R,@TfreqObjP_W,'P');
    RegisterPropertyHelper(@TfreqObja_R,@TfreqObja_W,'a');
    RegisterPropertyHelper(@TfreqObjshape_R,@TfreqObjshape_W,'shape');
    RegisterPropertyHelper(@TfreqObjStringRep_R,@TfreqObjStringRep_W,'StringRep');
    RegisterConstructor(@TfreqObj.Create, 'Create');
    RegisterMethod(@TfreqObj.makestringrep, 'makestringrep');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcSysUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TfreqObj(CL);
end;

 
 
{ TPSImport_flcSysUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcSysUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_flcSysUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcSysUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_flcSysUtils(ri);
  RIRegister_flcSysUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
