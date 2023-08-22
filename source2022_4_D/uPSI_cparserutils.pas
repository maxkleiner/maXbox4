unit uPSI_cparserutils;
{
   JUST A TEST
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
  TPSImport_cparserutils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TLineBreaker(CL: TPSPascalCompiler);
procedure SIRegister_cparserutils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TLineBreaker(CL: TPSRuntimeClassImporter);
procedure RIRegister_cparserutils_Routines(S: TPSExec);

procedure Register;

implementation


uses
  // cparsertypes
  cparserutils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cparserutils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TLineBreaker(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TLineBreaker') do
  with CL.AddClassN(CL.FindClass('TObject'),'TLineBreaker') do
  begin
    RegisterMethod('Procedure SetText( const AText : AnsiString)');
    RegisterMethod('Function LineNumber( Offset : Integer) : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cparserutils(CL: TPSPascalCompiler);
begin
 (*CL.AddDelphiFunction('Function isFunc( name : TNamePart) : Boolean');
 CL.AddDelphiFunction('Function isUnnamedFunc( name : TNamepart) : Boolean');
 CL.AddDelphiFunction('Function isPtrToFunc( name : TNamePart) : Boolean');
 CL.AddDelphiFunction('Function isFuncRetFuncPtr( name : TNamePart) : Boolean');
 CL.AddDelphiFunction('Function isPtrToFuncRetFuncPtr( name : TNamePart) : Boolean');
 CL.AddDelphiFunction('Function GetFuncParam( name : TNamePart) : TNamePart');
 CL.AddDelphiFunction('Function isArray( name : TNamePart) : Boolean');
 CL.AddDelphiFunction('Function GetArrayPart( name : TNamePart) : TNamePart');
 CL.AddDelphiFunction('Function GetIdFromPart( name : TNamePart) : AnsiString');
 CL.AddDelphiFunction('Function GetIdPart( name : TNamePart) : TNamePart');
 CL.AddDelphiFunction('Function isNamePartPtrToFunc( part : TNamePart) : Boolean');
 CL.AddDelphiFunction('Function isAnyBlock( part : TNamePart) : Boolean');*)
  CL.AddTypeS('TLineInfo', 'record linestart : Integer; lineend : Integer; end');
  SIRegister_TLineBreaker(CL);
  CL.AddTypeS('TNameKind', 'Integer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TNamePart');
  //CL.AddTypeS('TFuncParam', 'record prmtype : TEntity; name : TNamePart; end');
 CL.AddDelphiFunction('Function SphericalMod( X : Extended) : Extended');
 CL.AddDelphiFunction('Function cSign( Value : Extended) : Extended');
 CL.AddDelphiFunction('Function LimitFloat( const eValue, eMin, eMax : Extended) : Extended');
 CL.AddDelphiFunction('Function AngleToRadians( iAngle : Extended) : Extended');
 CL.AddDelphiFunction('Function RadiansToAngle( eRad : Extended) : Extended');
 CL.AddDelphiFunction('Function Cross180( iLong : Double) : Boolean');
 CL.AddDelphiFunction('Function Mod180( Value : integer) : Integer');
 CL.AddDelphiFunction('Function Mod180Float( Value : Extended) : Extended');
 CL.AddDelphiFunction('Function MulDivFloat( a, b, d : Extended) : Extended');
 CL.AddDelphiFunction('Function LongDiff( iLong1, iLong2 : Double) : Double');
 CL.AddDelphiFunction('Procedure Bmp_AssignFromPersistent( Source : TPersistent; Bmp : TbitMap)');
 CL.AddDelphiFunction('Function Bmp_CreateFromPersistent( Source : TPersistent) : TbitMap');
 CL.AddDelphiFunction('Function FixFilePath( const Inpath, CheckPath : string) : string');
 CL.AddDelphiFunction('Function UnFixFilePath( const Inpath, CheckPath : string) : string');
 CL.AddDelphiFunction('Procedure FillStringList( sl : TStringList; const aText : string)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TLineBreaker(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLineBreaker) do
  begin
    RegisterMethod(@TLineBreaker.SetText, 'SetText');
    RegisterMethod(@TLineBreaker.LineNumber, 'LineNumber');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cparserutils_Routines(S: TPSExec);
begin
 {S.RegisterDelphiFunction(@isFunc, 'isFunc', cdRegister);
 S.RegisterDelphiFunction(@isUnnamedFunc, 'isUnnamedFunc', cdRegister);
 S.RegisterDelphiFunction(@isPtrToFunc, 'isPtrToFunc', cdRegister);
 S.RegisterDelphiFunction(@isFuncRetFuncPtr, 'isFuncRetFuncPtr', cdRegister);
 S.RegisterDelphiFunction(@isPtrToFuncRetFuncPtr, 'isPtrToFuncRetFuncPtr', cdRegister);
 S.RegisterDelphiFunction(@GetFuncParam, 'GetFuncParam', cdRegister);
 S.RegisterDelphiFunction(@isArray, 'isArray', cdRegister);
 S.RegisterDelphiFunction(@GetArrayPart, 'GetArrayPart', cdRegister);
 S.RegisterDelphiFunction(@GetIdFromPart, 'GetIdFromPart', cdRegister);
 S.RegisterDelphiFunction(@GetIdPart, 'GetIdPart', cdRegister);
 S.RegisterDelphiFunction(@isNamePartPtrToFunc, 'isNamePartPtrToFunc', cdRegister);
 S.RegisterDelphiFunction(@isAnyBlock, 'isAnyBlock', cdRegister);}
 // RIRegister_TLineBreaker(CL);
  //with CL.Add(TNamePart) do
 S.RegisterDelphiFunction(@SphericalMod, 'SphericalMod', cdRegister);
 S.RegisterDelphiFunction(@Sign, 'CSign', cdRegister);
 S.RegisterDelphiFunction(@LimitFloat, 'LimitFloat', cdRegister);
 S.RegisterDelphiFunction(@AngleToRadians, 'AngleToRadians', cdRegister);
 S.RegisterDelphiFunction(@RadiansToAngle, 'RadiansToAngle', cdRegister);
 S.RegisterDelphiFunction(@Cross180, 'Cross180', cdRegister);
 S.RegisterDelphiFunction(@Mod180, 'Mod180', cdRegister);
 S.RegisterDelphiFunction(@Mod180Float, 'Mod180Float', cdRegister);
 S.RegisterDelphiFunction(@MulDivFloat, 'MulDivFloat', cdRegister);
 S.RegisterDelphiFunction(@LongDiff, 'LongDiff', cdRegister);
 S.RegisterDelphiFunction(@Bmp_AssignFromPersistent, 'Bmp_AssignFromPersistent', cdRegister);
 S.RegisterDelphiFunction(@Bmp_CreateFromPersistent, 'Bmp_CreateFromPersistent', cdRegister);
 S.RegisterDelphiFunction(@FixFilePath, 'FixFilePath', cdRegister);
 S.RegisterDelphiFunction(@UnFixFilePath, 'UnFixFilePath', cdRegister);
 S.RegisterDelphiFunction(@FillStringList, 'FillStringList', cdRegister);


end;

 
 
{ TPSImport_cparserutils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cparserutils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cparserutils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cparserutils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_cparserutils(ri);
  RIRegister_cparserutils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
