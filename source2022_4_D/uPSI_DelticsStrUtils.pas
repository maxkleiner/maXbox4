unit uPSI_DelticsStrUtils;
{
for commandline switcher

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
  TPSImport_DelticsStrUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
//procedure SIRegister_TManagedStringList(CL: TPSPascalCompiler);
procedure SIRegister_TStringTool(CL: TPSPascalCompiler);
procedure SIRegister_IStringTool(CL: TPSPascalCompiler);
procedure SIRegister_IStringList(CL: TPSPascalCompiler);
procedure SIRegister_DelticsStrUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
//procedure RIRegister_TManagedStringList(CL: TPSRuntimeClassImporter);
procedure RIRegister_DelticsStrUtils_Routines(S: TPSExec);
procedure RIRegister_TStringTool(CL: TPSRuntimeClassImporter);
procedure RIRegister_DelticsStrUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   DelticsStrUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DelticsStrUtils]);
end;

{
(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TManagedStringList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCOMInterfacedObject', 'TManagedStringList') do
  with CL.AddClassN(CL.FindClass('TCOMInterfacedObject'),'TManagedStringList') do
  begin
    RegisterMethod('Function get_Count : Integer');
    RegisterMethod('Function get_Item( const aIndex : Integer) : String');
    RegisterMethod('Function get_List : TStringList');
    RegisterMethod('Function get_Name( const aIndex : Integer) : String');
    RegisterMethod('Function get_Value( const aName : String) : String');
    RegisterMethod('Function Add( const aString : String) : Integer');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Contains( const aString : String) : Boolean');
    RegisterMethod('Procedure Delete( const aIndex : Integer)');
    RegisterMethod('Procedure Insert( const aIndex : Integer; const aString : String)');
  end;
end;    }

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStringTool(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TStringTool') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TStringTool') do
  begin
    RegisterMethod('Constructor Create( const aString : String)');
    RegisterMethod('Function Contains( const aSubStr : String) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IStringTool(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IStringTool') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IStringTool, 'IStringTool') do
  begin
    RegisterMethod('Function Contains( const aSubStr : String) : Boolean', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IStringList(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IStringList') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IStringList, 'IStringList') do
  begin
    RegisterMethod('Function get_Count : Integer', cdRegister);
    RegisterMethod('Function get_Item( const aIndex : Integer) : String', cdRegister);
    RegisterMethod('Function get_List : TStringList', cdRegister);
    RegisterMethod('Function get_Name( const aIndex : Integer) : String', cdRegister);
    RegisterMethod('Function get_Value( const aName : String) : String', cdRegister);
    RegisterMethod('Function Add( const aString : String) : Integer', cdRegister);
    RegisterMethod('Procedure Clear', cdRegister);
    RegisterMethod('Function Contains( const aString : String) : Boolean', cdRegister);
    RegisterMethod('Procedure Delete( const aIndex : Integer)', cdRegister);
    RegisterMethod('Procedure Insert( const aIndex : Integer; const aString : String)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DelticsStrUtils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('LIKENESS_MATCH','Char').SetString( #255);
  CL.AddTypeS('TANSIStringArray', 'array of ANSIString');
  //CL.AddTypeS('TStringArray', 'array of String');
  SIRegister_IStringList(CL);
  SIRegister_IStringTool(CL);
  SIRegister_TStringTool(CL);
 CL.AddDelphiFunction('Procedure dArrayInit( var aArray : TANSIStringArray; const aSize : Integer);');
 CL.AddDelphiFunction('Procedure ArrayAdd1( var aArray : TANSIStringArray; const aValue : ANSIString);');
 CL.AddDelphiFunction('Procedure ArrayAdd2( var aArray : TANSIStringArray; const aValue : array of ANSIString);');
 CL.AddDelphiFunction('Procedure ArrayExtend( var aArray : TANSIStringArray; const aCount : Integer);');
 CL.AddDelphiFunction('Function Likeness( const A : ANSIString; const B : ANSIString) : Integer');
 CL.AddDelphiFunction('Function LikenessEx( const A : ANSIString; const B : ANSIString; var strA : ANSIString; var strB : ANSIString) : Integer;');
 CL.AddDelphiFunction('Function LikenessEx2( const A : ANSIString; const B : ANSIString; var strA : ANSIString; var strB : ANSIString; var iSame : Integer; var iTotal : Integer) : Integer;');
 CL.AddDelphiFunction('Function CamelCapsToWords( const aString : String) : String');
 CL.AddDelphiFunction('Function ReverseStr( const aString : String) : String;');
 CL.AddDelphiFunction('Function ReverseStr2( const aString : ANSIString) : ANSIString;');
 CL.AddDelphiFunction('Function dSplit( const aString : String; const aDelim : Char; const aSlices : TStrings) : Integer;');
 CL.AddDelphiFunction('Function dSplit1( const aString : String; const aDelim : Char; var aSlices : TStringArray) : Integer;');
 CL.AddDelphiFunction('Procedure dSplit2( const aString : ANSIString; const aDelim : ANSIChar; var aSlices : TANSIStringArray);');
 CL.AddDelphiFunction('Function StrBeginsWith( const aString : String; const aBeginning : String) : Boolean');
 CL.AddDelphiFunction('Function StrBeginsWithText( const aString : String; const aBeginning : String) : Boolean');
 CL.AddDelphiFunction('Function dStrContains( const aString : String; const aSubString : String) : Boolean');
 CL.AddDelphiFunction('Function StrContainsText( const aString : String; const aSubString : String) : Boolean');
 CL.AddDelphiFunction('Function StrEndsWith( const aString : String; const aEnd : String) : Boolean');
 CL.AddDelphiFunction('Function StrEndsWithText( const aString : String; const aEnd : String) : Boolean');
 CL.AddDelphiFunction('Function StrLPad( const aString : String; const aWidth : Integer; const aTrunc : Boolean) : String');
 CL.AddDelphiFunction('Function StrRPad( const aString : String; const aWidth : Integer; const aTrunc : Boolean) : String');
 CL.AddDelphiFunction('Function StrDequote( const aString : String) : String');
 CL.AddDelphiFunction('Function StrPop( var aString : String; const aDelim : Char) : String');
 CL.AddDelphiFunction('Function StrPopQuoted( var aString : String; const aDelim : Char) : String');
 CL.AddDelphiFunction('Function dIsAlpha( const aChar : Char) : Boolean');
 CL.AddDelphiFunction('Function dIsDigit( const aChar : Char) : Boolean');
 CL.AddDelphiFunction('Function dIsLower( const aChar : Char) : Boolean');
 CL.AddDelphiFunction('Function dIsUpper( const aChar : Char) : Boolean');
 CL.AddDelphiFunction('function delticsExplode(const Separator, S: string; Limit: Integer): TStringArray;');
 CL.AddDelphiFunction('function delticsImplode(const Glue: string; const Pieces: array of string): string;');

   //SIRegister_TManagedStringList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure Split10_P( const aString : ANSIString; const aDelim : ANSIChar; var aSlices : TANSIStringArray);
Begin DelticsStrUtils.Split(aString, aDelim, aSlices); END;

(*----------------------------------------------------------------------------*)
Function Split9_P( const aString : String; const aDelim : Char; var aSlices : TStringArray) : Integer;
Begin Result := DelticsStrUtils.Split(aString, aDelim, aSlices); END;

(*----------------------------------------------------------------------------*)
Function Split_P( const aString : String; const aDelim : Char; const aSlices : TStrings) : Integer;
Begin Result := DelticsStrUtils.Split(aString, aDelim, aSlices); END;

(*----------------------------------------------------------------------------*)
Function ReverseStr7_P( const aString : ANSIString) : ANSIString;
Begin Result := DelticsStrUtils.ReverseStr(aString); END;

(*----------------------------------------------------------------------------*)
Function ReverseStr_P( const aString : String) : String;
Begin Result := DelticsStrUtils.ReverseStr(aString); END;

(*----------------------------------------------------------------------------*)
Function LikenessEx5_P( const A : ANSIString; const B : ANSIString; var strA : ANSIString; var strB : ANSIString; var iSame : Integer; var iTotal : Integer) : Integer;
Begin Result := DelticsStrUtils.LikenessEx(A, B, strA, strB, iSame, iTotal); END;

(*----------------------------------------------------------------------------*)
Function LikenessEx_P( const A : ANSIString; const B : ANSIString; var strA : ANSIString; var strB : ANSIString) : Integer;
Begin Result := DelticsStrUtils.LikenessEx(A, B, strA, strB); END;

(*----------------------------------------------------------------------------*)
Procedure ArrayExtend_P( var aArray : TANSIStringArray; const aCount : Integer);
Begin DelticsStrUtils.ArrayExtend(aArray, aCount); END;

(*----------------------------------------------------------------------------*)
Procedure ArrayAdd2_P( var aArray : TANSIStringArray; const aValue : array of ANSIString);
Begin DelticsStrUtils.ArrayAdd(aArray, aValue); END;

(*----------------------------------------------------------------------------*)
Procedure ArrayAdd1_P( var aArray : TANSIStringArray; const aValue : ANSIString);
Begin DelticsStrUtils.ArrayAdd(aArray, aValue); END;

(*----------------------------------------------------------------------------*)
Procedure ArrayInit_P( var aArray : TANSIStringArray; const aSize : Integer);
Begin DelticsStrUtils.ArrayInit(aArray, aSize); END;

{
//(*----------------------------------------------------------------------------*)
procedure RIRegister_TManagedStringList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TManagedStringList) do
  begin
    RegisterMethod(@TManagedStringList.get_Count, 'get_Count');
    RegisterMethod(@TManagedStringList.get_Item, 'get_Item');
    RegisterMethod(@TManagedStringList.get_List, 'get_List');
    RegisterMethod(@TManagedStringList.get_Name, 'get_Name');
    RegisterMethod(@TManagedStringList.get_Value, 'get_Value');
    RegisterMethod(@TManagedStringList.Add, 'Add');
    RegisterMethod(@TManagedStringList.Clear, 'Clear');
    RegisterMethod(@TManagedStringList.Contains, 'Contains');
    RegisterMethod(@TManagedStringList.Delete, 'Delete');
    RegisterMethod(@TManagedStringList.Insert, 'Insert');
  end;
end;    }

(*----------------------------------------------------------------------------*)
procedure RIRegister_DelticsStrUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ArrayInit, 'dArrayInit', cdRegister);
 S.RegisterDelphiFunction(@ArrayAdd1_P, 'ArrayAdd1', cdRegister);
 S.RegisterDelphiFunction(@ArrayAdd2_P, 'ArrayAdd2', cdRegister);
 S.RegisterDelphiFunction(@ArrayExtend, 'ArrayExtend', cdRegister);
 S.RegisterDelphiFunction(@Likeness, 'Likeness', cdRegister);
 S.RegisterDelphiFunction(@LikenessEx_P, 'LikenessEx', cdRegister);
 S.RegisterDelphiFunction(@LikenessEx5_P, 'LikenessEx2', cdRegister);
 S.RegisterDelphiFunction(@CamelCapsToWords, 'CamelCapsToWords', cdRegister);
 S.RegisterDelphiFunction(@ReverseStr_P, 'ReverseStr', cdRegister);
 S.RegisterDelphiFunction(@ReverseStr7_P, 'ReverseStr2', cdRegister);
 S.RegisterDelphiFunction(@Split_P, 'dSplit', cdRegister);
 S.RegisterDelphiFunction(@Split9_P, 'dSplit1', cdRegister);
 S.RegisterDelphiFunction(@Split10_P, 'dSplit2', cdRegister);
 S.RegisterDelphiFunction(@StrBeginsWith, 'StrBeginsWith', cdRegister);
 S.RegisterDelphiFunction(@StrBeginsWithText, 'StrBeginsWithText', cdRegister);
 S.RegisterDelphiFunction(@StrContains, 'dStrContains', cdRegister);
 S.RegisterDelphiFunction(@StrContainsText, 'StrContainsText', cdRegister);
 S.RegisterDelphiFunction(@StrEndsWith, 'StrEndsWith', cdRegister);
 S.RegisterDelphiFunction(@StrEndsWithText, 'StrEndsWithText', cdRegister);
 S.RegisterDelphiFunction(@StrLPad, 'StrLPad', cdRegister);
 S.RegisterDelphiFunction(@StrRPad, 'StrRPad', cdRegister);
 S.RegisterDelphiFunction(@StrDequote, 'StrDequote', cdRegister);
 S.RegisterDelphiFunction(@StrPop, 'StrPop', cdRegister);
 S.RegisterDelphiFunction(@StrPopQuoted, 'StrPopQuoted', cdRegister);
 S.RegisterDelphiFunction(@IsAlpha, 'dIsAlpha', cdRegister);
 S.RegisterDelphiFunction(@IsDigit, 'dIsDigit', cdRegister);
 S.RegisterDelphiFunction(@IsLower, 'dIsLower', cdRegister);
 S.RegisterDelphiFunction(@IsUpper, 'dIsUpper', cdRegister);
 S.RegisterDelphiFunction(@delticsExplode, 'delticsExplode', cdRegister);
 S.RegisterDelphiFunction(@delticsImplode, 'delticsImplode', cdRegister);
 //RIRegister_TManagedStringList(CL);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStringTool(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStringTool) do
  begin
    RegisterConstructor(@TStringTool.Create, 'Create');
    RegisterMethod(@TStringTool.Contains, 'Contains');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DelticsStrUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStringTool(CL);
end;

 
 
{ TPSImport_DelticsStrUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DelticsStrUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DelticsStrUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DelticsStrUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DelticsStrUtils(ri);
  RIRegister_DelticsStrUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
