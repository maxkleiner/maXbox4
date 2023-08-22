unit uPSI_flcCharSet;
{
a bit is from cfundamentutils to test code red - redundancy

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
  TPSImport_flcCharSet = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_flcCharSet(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_flcCharSet_Routines(S: TPSExec);

procedure Register;

implementation


uses
   flcStdTypes
  ,flcCharSet
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_flcCharSet]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_flcCharSet(CL: TPSPascalCompiler);
begin

//type
  //ByteSet = set of Byte;
  //ByteCharSet = Charset; /
   CL.AddTypeS('ByteCharSet', 'Charset');
   // CL.AddTypeS('ByteCharSet', 'charset');
 CL.AddDelphiFunction('Function flcAsAnsiCharSet( const C : array of Char) : ByteCharSet');
 CL.AddDelphiFunction('Function flcAsByteSet( const C : array of Byte) : ByteSet');
 CL.AddDelphiFunction('Function flcAsByteCharSet( const C : array of Char) : ByteCharSet');
 CL.AddDelphiFunction('Procedure flcComplementChar( var C : ByteCharSet; const Ch : Char)');
 CL.AddDelphiFunction('Procedure flcClearCharSet( var C : ByteCharSet)');
 CL.AddDelphiFunction('Procedure flcFillCharSet( var C : ByteCharSet)');
 CL.AddDelphiFunction('Procedure flcComplementCharSet( var C : ByteCharSet)');
 CL.AddDelphiFunction('Procedure flcAssignCharSet( var DestSet : ByteCharSet; const SourceSet : ByteCharSet)');
 CL.AddDelphiFunction('Procedure flcUnion( var DestSet : ByteCharSet; const SourceSet : ByteCharSet)');
 CL.AddDelphiFunction('Procedure flcDifference( var DestSet : ByteCharSet; const SourceSet : ByteCharSet)');
 CL.AddDelphiFunction('Procedure flcIntersection( var DestSet : ByteCharSet; const SourceSet : ByteCharSet)');
 CL.AddDelphiFunction('Procedure flcXORCharSet( var DestSet : ByteCharSet; const SourceSet : ByteCharSet)');
 CL.AddDelphiFunction('Function flcIsSubSet( const A, B : ByteCharSet) : Boolean');
 CL.AddDelphiFunction('Function flcIsEqual( const A, B : ByteCharSet) : Boolean');
 CL.AddDelphiFunction('Function flcIsEmpty( const C : ByteCharSet) : Boolean');
 CL.AddDelphiFunction('Function flcIsComplete( const C : ByteCharSet) : Boolean');
 CL.AddDelphiFunction('Function flcCharCount( const C : ByteCharSet) : Integer');
 CL.AddDelphiFunction('Procedure flcConvertCaseInsensitive( var C : ByteCharSet)');
 CL.AddDelphiFunction('Function flcCaseInsensitiveCharSet( const C : ByteCharSet) : ByteCharSet');
 CL.AddDelphiFunction('Function flcCharSetToStrB( const C : ByteCharSet) : RawByteString');
 CL.AddDelphiFunction('Function flcStrToCharSetB( const S : String) : ByteCharSet');
 CL.AddDelphiFunction('Function flcCharSetToCharClassStr( const C : ByteCharSet) : AnsiString');
 CL.AddDelphiFunction('Procedure TestCharset');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_flcCharSet_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AsAnsiCharSet, 'flcAsAnsiCharSet', cdRegister);
 //S.RegisterDelphiFunction(@AsByteSet, 'AsByteSet', cdRegister);
 S.RegisterDelphiFunction(@AsByteCharSet, 'flcAsByteCharSet', cdRegister);
 S.RegisterDelphiFunction(@ComplementChar, 'flcComplementChar', cdRegister);
 S.RegisterDelphiFunction(@ClearCharSet, 'flcClearCharSet', cdRegister);
 S.RegisterDelphiFunction(@FillCharSet, 'flcFillCharSet', cdRegister);
 S.RegisterDelphiFunction(@ComplementCharSet, 'flcComplementCharSet', cdRegister);
 S.RegisterDelphiFunction(@AssignCharSet, 'flcAssignCharSet', cdRegister);
 S.RegisterDelphiFunction(@Union, 'flcUnion', cdRegister);
 S.RegisterDelphiFunction(@Difference, 'flcDifference', cdRegister);
 S.RegisterDelphiFunction(@Intersection, 'flcIntersection', cdRegister);
 S.RegisterDelphiFunction(@XORCharSet, 'flcXORCharSet', cdRegister);
 S.RegisterDelphiFunction(@IsSubSet, 'flcIsSubSet', cdRegister);
 S.RegisterDelphiFunction(@IsEqual, 'flcIsEqual', cdRegister);
 S.RegisterDelphiFunction(@IsEmpty, 'flcIsEmpty', cdRegister);
 S.RegisterDelphiFunction(@IsComplete, 'flcIsComplete', cdRegister);
 S.RegisterDelphiFunction(@CharCount, 'flcCharCount', cdRegister);
 S.RegisterDelphiFunction(@ConvertCaseInsensitive, 'flcConvertCaseInsensitive', cdRegister);
 S.RegisterDelphiFunction(@CaseInsensitiveCharSet, 'flcCaseInsensitiveCharSet', cdRegister);
 S.RegisterDelphiFunction(@CharSetToStrB, 'flcCharSetToStrB', cdRegister);
 S.RegisterDelphiFunction(@StrToCharSetB, 'flcStrToCharSetB', cdRegister);
 //S.RegisterDelphiFunction(@CharSetToCharClassStr, 'CharSetToCharClassStr', cdRegister);
 S.RegisterDelphiFunction(@Test, 'TestCharset', cdRegister);
end;

 
 
{ TPSImport_flcCharSet }
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcCharSet.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_flcCharSet(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcCharSet.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_flcCharSet_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
