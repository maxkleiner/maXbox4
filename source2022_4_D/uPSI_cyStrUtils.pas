unit uPSI_cyStrUtils;
{
  string thing
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
  TPSImport_cyStrUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cyStrUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cyStrUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   cyStrUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyStrUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cyStrUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TStrLocateOption', '( strloCaseInsensitive, strloPartialKey )');
  CL.AddTypeS('TStrLocateOptions', 'set of TStrLocateOption');
  CL.AddTypeS('TStringRead', '( srFromLeft, srFromRight )');
  CL.AddTypeS('TStringReads', 'set of TStringRead');
  CL.AddTypeS('TCaseSensitive', '( csCaseSensitive, csCaseNotSensitive )');
  CL.AddTypeS('TWordsOption', '( woOnlyFirstWord, woOnlyFirstCar )');
  CL.AddTypeS('TWordsOptions', 'set of TWordsOption');
  CL.AddTypeS('TCarType', '( ctAlphabeticUppercase, ctAlphabeticLowercase, ctNumeric, ctOther )');
  CL.AddTypeS('TCarTypes', 'set of TCarType');
  //CL.AddTypeS('TUnicodeCategories', 'set of TUnicodeCategory');
 CL.AddConstantN('CarTypeAlphabetic','LongInt').Value.ts32 := ord(ctAlphabeticUppercase) or ord(ctAlphabeticLowercase);
 CL.AddDelphiFunction('Function Char_GetType( aChar : Char) : TCarType');
 CL.AddDelphiFunction('Function SubString_Count( Str : String; Separator : Char) : Integer');
 CL.AddDelphiFunction('Function SubString_AtPos( Str : String; Separator : Char; SubStringIndex : Word) : Integer');
 CL.AddDelphiFunction('Function SubString_Get( Str : String; Separator : Char; SubStringIndex : Word) : String');
 CL.AddDelphiFunction('Function SubString_Length( Str : String; Separator : Char; SubStringIndex : Word) : Integer');
 CL.AddDelphiFunction('Procedure SubString_Add( var Str : String; Separator : Char; Value : String)');
 CL.AddDelphiFunction('Procedure SubString_Insert( var Str : String; Separator : Char; SubStringIndex : Word; Value : String)');
 CL.AddDelphiFunction('Procedure SubString_Edit( var Str : String; Separator : Char; SubStringIndex : Word; NewValue : String)');
 CL.AddDelphiFunction('Function SubString_Remove( var Str : string; Separator : Char; SubStringIndex : Word) : Boolean');
 CL.AddDelphiFunction('Function SubString_Locate( Str : string; Separator : Char; SubString : String; Options : TStrLocateOptions) : Integer');
 CL.AddDelphiFunction('Function SubString_Ribbon( Str : string; Separator : Char; Current : Word; MoveBy : Integer) : Integer;');
 CL.AddDelphiFunction('Function SubString_Ribbon1( Str : string; Separator : Char; Current : String; MoveBy : Integer) : String;');
 CL.AddDelphiFunction('Function String_Quote( Str : String) : String');
 CL.AddDelphiFunction('Function String_GetCar( Str : String; Position : Word; ReturnCarIfNotExists : Char) : Char');
 CL.AddDelphiFunction('Function String_ExtractCars( fromStr : String; CarTypes : TCarTypes; IncludeCars, ExcludeCars : String) : String;');
 //CL.AddDelphiFunction('Function String_ExtractCars1( Str : String; CharCategories : TUnicodeCategories) : String;');
 CL.AddDelphiFunction('Function String_GetWord( Str : String; StringRead : TStringRead) : String');
 CL.AddDelphiFunction('Function String_GetInteger( Str : String; StringRead : TStringRead) : String');
 CL.AddDelphiFunction('Function String_ToInt( Str : String) : Integer');
 CL.AddDelphiFunction('Function String_Uppercase( Str : String; Options : TWordsOptions) : String');
 CL.AddDelphiFunction('Function String_Lowercase( Str : String; Options : TWordsOptions) : String');
 CL.AddDelphiFunction('Function String_Reverse( Str : String) : String');
 CL.AddDelphiFunction('Function String_Pos( SubStr : String; Str : String; fromPos : Integer; CaseSensitive : TCaseSensitive) : Integer;');
 CL.AddDelphiFunction('Function String_Pos1( SubStr : String; Str : String; StringRead : TStringRead; Occurrence : Word; CaseSensitive : TCaseSensitive) : Integer;');
 CL.AddDelphiFunction('Function String_Copy( Str : String; fromIndex : Integer; toIndex : Integer) : String;');
 CL.AddDelphiFunction('Function String_Copy1( Str : String; StringRead : TStringRead; UntilFind : String; _Inclusive : Boolean) : String;');
 CL.AddDelphiFunction('Function String_Copy2( Str : String; Between1 : String; Between1MustExist : Boolean; Between2 : String; Between2MustExist : Boolean; CaseSensitive : TCaseSensitive) : String;');
 CL.AddDelphiFunction('Function String_Delete( Str : String; fromIndex : Integer; toIndex : Integer) : String;');
 CL.AddDelphiFunction('Function String_Delete1( Str : String; delStr : String; CaseSensitive : TCaseSensitive) : String;');
 CL.AddDelphiFunction('Function String_BoundsCut( Str : String; CutCar : Char; Bounds : TStringReads) : String');
 CL.AddDelphiFunction('Function String_BoundsAdd( Str : String; AddCar : Char; ReturnLength : Integer) : String');
 CL.AddDelphiFunction('Function String_Add( Str : String; StringRead : TStringRead; aCar : Char; ReturnLength : Integer) : String');
 CL.AddDelphiFunction('Function String_End( Str : String; Cars : Word) : String');
 CL.AddDelphiFunction('Function String_Subst( OldStr : String; NewStr : String; Str : String; CaseSensitive : TCaseSensitive; AlwaysFindFromBeginning : Boolean) : String');
 CL.AddDelphiFunction('Function String_SubstCar( Str : String; Old, New : Char) : String');
 CL.AddDelphiFunction('Function String_Count( Str : String; SubStr : String; CaseSenSitive : TCaseSensitive) : Integer');
 CL.AddDelphiFunction('Function String_SameCars( Str1, Str2 : String; StopCount_IfDiferent : Boolean; CaseSensitive : TCaseSensitive) : Integer');
 CL.AddDelphiFunction('Function String_IsNumbers( Str : String) : Boolean');
 CL.AddDelphiFunction('Function SearchPos( SubStr : String; Str : String; MaxErrors : Integer) : Integer');
 CL.AddDelphiFunction('Function StringToCsvCell( aStr : String) : String');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function String_Delete1_P( Str : String; delStr : String; CaseSensitive : TCaseSensitive) : String;
Begin Result := cyStrUtils.String_Delete(Str, delStr, CaseSensitive); END;

(*----------------------------------------------------------------------------*)
Function String_Delete_P( Str : String; fromIndex : Integer; toIndex : Integer) : String;
Begin Result := cyStrUtils.String_Delete(Str, fromIndex, toIndex); END;

(*----------------------------------------------------------------------------*)
Function String_Copy2_P( Str : String; Between1 : String; Between1MustExist : Boolean; Between2 : String; Between2MustExist : Boolean; CaseSensitive : TCaseSensitive) : String;
Begin Result := cyStrUtils.String_Copy(Str, Between1, Between1MustExist, Between2, Between2MustExist, CaseSensitive); END;

(*----------------------------------------------------------------------------*)
Function String_Copy1_P( Str : String; StringRead : TStringRead; UntilFind : String; _Inclusive : Boolean) : String;
Begin Result := cyStrUtils.String_Copy(Str, StringRead, UntilFind, _Inclusive); END;

(*----------------------------------------------------------------------------*)
Function String_Copy_P( Str : String; fromIndex : Integer; toIndex : Integer) : String;
Begin Result := cyStrUtils.String_Copy(Str, fromIndex, toIndex); END;

(*----------------------------------------------------------------------------*)
Function String_Pos1_P( SubStr : String; Str : String; StringRead : TStringRead; Occurrence : Word; CaseSensitive : TCaseSensitive) : Integer;
Begin Result := cyStrUtils.String_Pos(SubStr, Str, StringRead, Occurrence, CaseSensitive); END;

(*----------------------------------------------------------------------------*)
Function String_Pos_P( SubStr : String; Str : String; fromPos : Integer; CaseSensitive : TCaseSensitive) : Integer;
Begin Result := cyStrUtils.String_Pos(SubStr, Str, fromPos, CaseSensitive); END;

(*----------------------------------------------------------------------------*)
//Function String_ExtractCars1_P( Str : String; CharCategories : TUnicodeCategories) : String;
//Begin Result := cyStrUtils.String_ExtractCars(Str, CharCategories); END;

(*----------------------------------------------------------------------------*)
Function String_ExtractCars_P( fromStr : String; CarTypes : TCarTypes; IncludeCars, ExcludeCars : String) : String;
Begin Result := cyStrUtils.String_ExtractCars(fromStr, CarTypes, IncludeCars, ExcludeCars); END;

(*----------------------------------------------------------------------------*)
Function SubString_Ribbon1_P( Str : string; Separator : Char; Current : String; MoveBy : Integer) : String;
Begin Result := cyStrUtils.SubString_Ribbon(Str, Separator, Current, MoveBy); END;

(*----------------------------------------------------------------------------*)
Function SubString_Ribbon_P( Str : string; Separator : Char; Current : Word; MoveBy : Integer) : Integer;
Begin Result := cyStrUtils.SubString_Ribbon(Str, Separator, Current, MoveBy); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyStrUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Char_GetType, 'Char_GetType', cdRegister);
 S.RegisterDelphiFunction(@SubString_Count, 'SubString_Count', cdRegister);
 S.RegisterDelphiFunction(@SubString_AtPos, 'SubString_AtPos', cdRegister);
 S.RegisterDelphiFunction(@SubString_Get, 'SubString_Get', cdRegister);
 S.RegisterDelphiFunction(@SubString_Length, 'SubString_Length', cdRegister);
 S.RegisterDelphiFunction(@SubString_Add, 'SubString_Add', cdRegister);
 S.RegisterDelphiFunction(@SubString_Insert, 'SubString_Insert', cdRegister);
 S.RegisterDelphiFunction(@SubString_Edit, 'SubString_Edit', cdRegister);
 S.RegisterDelphiFunction(@SubString_Remove, 'SubString_Remove', cdRegister);
 S.RegisterDelphiFunction(@SubString_Locate, 'SubString_Locate', cdRegister);
 S.RegisterDelphiFunction(@SubString_Ribbon, 'SubString_Ribbon', cdRegister);
 S.RegisterDelphiFunction(@SubString_Ribbon1_P, 'SubString_Ribbon1', cdRegister);
 S.RegisterDelphiFunction(@String_Quote, 'String_Quote', cdRegister);
 S.RegisterDelphiFunction(@String_GetCar, 'String_GetCar', cdRegister);
 S.RegisterDelphiFunction(@String_ExtractCars, 'String_ExtractCars', cdRegister);
 //S.RegisterDelphiFunction(@String_ExtractCars1, 'String_ExtractCars1', cdRegister);
 S.RegisterDelphiFunction(@String_GetWord, 'String_GetWord', cdRegister);
 S.RegisterDelphiFunction(@String_GetInteger, 'String_GetInteger', cdRegister);
 S.RegisterDelphiFunction(@String_ToInt, 'String_ToInt', cdRegister);
 S.RegisterDelphiFunction(@String_Uppercase, 'String_Uppercase', cdRegister);
 S.RegisterDelphiFunction(@String_Lowercase, 'String_Lowercase', cdRegister);
 S.RegisterDelphiFunction(@String_Reverse, 'String_Reverse', cdRegister);
 S.RegisterDelphiFunction(@String_Pos, 'String_Pos', cdRegister);
 S.RegisterDelphiFunction(@String_Pos1_P, 'String_Pos1', cdRegister);
 S.RegisterDelphiFunction(@String_Copy, 'String_Copy', cdRegister);
 S.RegisterDelphiFunction(@String_Copy1_P, 'String_Copy1', cdRegister);
 S.RegisterDelphiFunction(@String_Copy2_P, 'String_Copy2', cdRegister);
 S.RegisterDelphiFunction(@String_Delete, 'String_Delete', cdRegister);
 S.RegisterDelphiFunction(@String_Delete1_P, 'String_Delete1', cdRegister);
 S.RegisterDelphiFunction(@String_BoundsCut, 'String_BoundsCut', cdRegister);
 S.RegisterDelphiFunction(@String_BoundsAdd, 'String_BoundsAdd', cdRegister);
 S.RegisterDelphiFunction(@String_Add, 'String_Add', cdRegister);
 S.RegisterDelphiFunction(@String_End, 'String_End', cdRegister);
 S.RegisterDelphiFunction(@String_Subst, 'String_Subst', cdRegister);
 S.RegisterDelphiFunction(@String_SubstCar, 'String_SubstCar', cdRegister);
 S.RegisterDelphiFunction(@String_Count, 'String_Count', cdRegister);
 S.RegisterDelphiFunction(@String_SameCars, 'String_SameCars', cdRegister);
 S.RegisterDelphiFunction(@String_IsNumbers, 'String_IsNumbers', cdRegister);
 S.RegisterDelphiFunction(@SearchPos, 'SearchPos', cdRegister);
 S.RegisterDelphiFunction(@StringToCsvCell, 'StringToCsvCell', cdRegister);
end;

 
 
{ TPSImport_cyStrUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyStrUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyStrUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyStrUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_cyStrUtils(ri);
  RIRegister_cyStrUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
