unit uPSI_JclStringLists;
{
    a last lost list
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
  TPSImport_JclStringLists = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_IJclStringList(CL: TPSPascalCompiler);
procedure SIRegister_JclStringLists(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclStringLists_Routines(S: TPSExec);

procedure Register;

implementation


uses
   //JclUnitVersioning
  Windows
  ,Variants
  ,JclBase
  ,JclStringLists
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclStringLists]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IJclStringList(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IInterface', 'IJclStringList') do
  with CL.AddInterface(CL.FindInterface('IInterface'),IJclStringList, 'IJclStringList') do
  begin
    RegisterMethod('Function Add0( const S : string) : Integer;', cdRegister);
    RegisterMethod('Function AddObject( const S : string; AObject : TObject) : Integer', cdRegister);
    RegisterMethod('Function Get( Index : Integer) : string', cdRegister);
    RegisterMethod('Function GetCapacity : Integer', cdRegister);
    RegisterMethod('Function GetCount : Integer', cdRegister);
    RegisterMethod('Function GetObjects( Index : Integer) : TObject', cdRegister);
    RegisterMethod('Function GetTextStr : string', cdRegister);
    RegisterMethod('Function GetValue( const Name : string) : string', cdRegister);
    RegisterMethod('Function Find( const S : string; var Index : Integer) : Boolean', cdRegister);
    RegisterMethod('Function IndexOf( const S : string) : Integer', cdRegister);
    RegisterMethod('Function GetCaseSensitive : Boolean', cdRegister);
    RegisterMethod('Function GetDuplicates : TDuplicates', cdRegister);
    RegisterMethod('Function GetOnChange : TNotifyEvent', cdRegister);
    RegisterMethod('Function GetOnChanging : TNotifyEvent', cdRegister);
    RegisterMethod('Function GetSorted : Boolean', cdRegister);
    RegisterMethod('Function Equals( Strings : TStrings) : Boolean', cdRegister);
    RegisterMethod('Function IndexOfName( const Name : string) : Integer', cdRegister);
    RegisterMethod('Function IndexOfObject( AObject : TObject) : Integer', cdRegister);
    RegisterMethod('Function LoadFromFile( const FileName : string) : IJclStringList', cdRegister);
    RegisterMethod('Function LoadFromStream( Stream : TStream) : IJclStringList', cdRegister);
    RegisterMethod('Function SaveToFile( const FileName : string) : IJclStringList', cdRegister);
    RegisterMethod('Function SaveToStream( Stream : TStream) : IJclStringList', cdRegister);
    RegisterMethod('Function GetCommaText : string', cdRegister);
    RegisterMethod('Function GetDelimitedText : string', cdRegister);
    RegisterMethod('Function GetDelimiter : Char', cdRegister);
    RegisterMethod('Function GetName( Index : Integer) : string', cdRegister);
    RegisterMethod('Function GetNameValueSeparator : Char', cdRegister);
    RegisterMethod('Function GetValueFromIndex( Index : Integer) : string', cdRegister);
    RegisterMethod('Function GetQuoteChar : Char', cdRegister);
    RegisterMethod('Procedure SetCommaText( const Value : string)', cdRegister);
    RegisterMethod('Procedure SetDelimitedText( const Value : string)', cdRegister);
    RegisterMethod('Procedure SetDelimiter( const Value : Char)', cdRegister);
    RegisterMethod('Procedure SetNameValueSeparator( const Value : Char)', cdRegister);
    RegisterMethod('Procedure SetValueFromIndex( Index : Integer; const Value : string)', cdRegister);
    RegisterMethod('Procedure SetQuoteChar( const Value : Char)', cdRegister);
    RegisterMethod('Procedure AddStrings1( Strings : TStrings);', cdRegister);
    RegisterMethod('Procedure SetObjects( Index : Integer; const Value : TObject)', cdRegister);
    RegisterMethod('Procedure Put( Index : Integer; const S : string)', cdRegister);
    RegisterMethod('Procedure SetCapacity( NewCapacity : Integer)', cdRegister);
    RegisterMethod('Procedure SetTextStr( const Value : string)', cdRegister);
    RegisterMethod('Procedure SetValue( const Name, Value : string)', cdRegister);
    RegisterMethod('Procedure SetCaseSensitive( const Value : Boolean)', cdRegister);
    RegisterMethod('Procedure SetDuplicates( const Value : TDuplicates)', cdRegister);
    RegisterMethod('Procedure SetOnChange( const Value : TNotifyEvent)', cdRegister);
    RegisterMethod('Procedure SetOnChanging( const Value : TNotifyEvent)', cdRegister);
    RegisterMethod('Procedure SetSorted( const Value : Boolean)', cdRegister);
    RegisterMethod('Function Assign( Source : TPersistent) : IJclStringList', cdRegister);
    RegisterMethod('Function LoadExeParams : IJclStringList', cdRegister);
    RegisterMethod('Function Exists( const S : string) : Boolean', cdRegister);
    RegisterMethod('Function ExistsName( const S : string) : Boolean', cdRegister);
    RegisterMethod('Function DeleteBlanks : IJclStringList', cdRegister);
    RegisterMethod('Function KeepIntegers : IJclStringList', cdRegister);
    RegisterMethod('Function DeleteIntegers : IJclStringList', cdRegister);
    RegisterMethod('Function ReleaseInterfaces : IJclStringList', cdRegister);
    RegisterMethod('Function FreeObjects( AFreeAndNil : Boolean) : IJclStringList', cdRegister);
    RegisterMethod('Function Clone : IJclStringList', cdRegister);
    RegisterMethod('Function Insert( Index : Integer; const S : string) : IJclStringList', cdRegister);
    RegisterMethod('Function InsertObject( Index : Integer; const S : string; AObject : TObject) : IJclStringList', cdRegister);
    RegisterMethod('Function Sort( ACompareFunction : TJclStringListSortCompare) : IJclStringList', cdRegister);
    RegisterMethod('Function SortAsInteger : IJclStringList', cdRegister);
    RegisterMethod('Function SortByName : IJclStringList', cdRegister);
    RegisterMethod('Function Delete2( AIndex : Integer) : IJclStringList;', cdRegister);
    RegisterMethod('Function Delete3( const AString : string) : IJclStringList;', cdRegister);
    RegisterMethod('Function Exchange( Index1, Index2 : Integer) : IJclStringList', cdRegister);
    RegisterMethod('Function Add4( const A : array of const) : IJclStringList;', cdRegister);
    RegisterMethod('Function AddStrings5( const A : array of string) : IJclStringList;', cdRegister);
    RegisterMethod('Function BeginUpdate : IJclStringList', cdRegister);
    RegisterMethod('Function EndUpdate : IJclStringList', cdRegister);
    RegisterMethod('Function Trim : IJclStringList', cdRegister);
    RegisterMethod('Function Join( const ASeparator : string) : string', cdRegister);
    RegisterMethod('Function Split( const AText, ASeparator : string; AClearBeforeAdd : Boolean) : IJclStringList', cdRegister);
    RegisterMethod('Function ExtractWords6( const AText : string) : IJclStringList;', cdRegister);
    RegisterMethod('Function ExtractWords7( const AText : string; const ADelims : TSetOfAnsiChar; AClearBeforeAdd : Boolean) : IJclStringList;', cdRegister);
    RegisterMethod('Function ExtractWords( const AText : string; const ADelims : TSetOfAnsiChar; AClearBeforeAdd : Boolean) : IJclStringList', cdRegister);
    RegisterMethod('Function Last : string', cdRegister);
    RegisterMethod('Function First : string', cdRegister);
    RegisterMethod('Function LastIndex : Integer', cdRegister);
    RegisterMethod('Function Clear : IJclStringList', cdRegister);
    RegisterMethod('Function DeleteRegEx( const APattern : string) : IJclStringList', cdRegister);
    RegisterMethod('Function KeepRegEx( const APattern : string) : IJclStringList', cdRegister);
    RegisterMethod('Function Files( const APattern : string; ARecursive : Boolean; const ARegExPattern : string) : IJclStringList', cdRegister);
    RegisterMethod('Function Directories( const APattern : string; ARecursive : Boolean; const ARegExPattern : string) : IJclStringList', cdRegister);
    RegisterMethod('Function GetStringsRef : TStrings', cdRegister);
    RegisterMethod('Function ConfigAsSet : IJclStringList', cdRegister);
    RegisterMethod('Function Delimit( const ADelimiter : string) : IJclStringList', cdRegister);
    RegisterMethod('Function GetInterfaceByIndex( Index : Integer) : IInterface', cdRegister);
    RegisterMethod('Function GetLists( Index : Integer) : IJclStringList', cdRegister);
    RegisterMethod('Function GetVariants( AIndex : Integer) : Variant', cdRegister);
    RegisterMethod('Function GetKeyInterface( const AKey : string) : IInterface', cdRegister);
    RegisterMethod('Function GetKeyObject( const AKey : string) : TObject', cdRegister);
    RegisterMethod('Function GetKeyVariant( const AKey : string) : Variant', cdRegister);
    RegisterMethod('Function GetKeyList( const AKey : string) : IJclStringList', cdRegister);
    RegisterMethod('Function GetObjectsMode : TJclStringListObjectsMode', cdRegister);
    RegisterMethod('Procedure SetInterfaceByIndex( Index : Integer; const Value : IInterface)', cdRegister);
    RegisterMethod('Procedure SetLists( Index : Integer; const Value : IJclStringList)', cdRegister);
    RegisterMethod('Procedure SetVariants( Index : Integer; const Value : Variant)', cdRegister);
    RegisterMethod('Procedure SetKeyInterface( const AKey : string; const Value : IInterface)', cdRegister);
    RegisterMethod('Procedure SetKeyObject( const AKey : string; const Value : TObject)', cdRegister);
    RegisterMethod('Procedure SetKeyVariant( const AKey : string; const Value : Variant)', cdRegister);
    RegisterMethod('Procedure SetKeyList( const AKey : string; const Value : IJclStringList)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclStringLists(CL: TPSPascalCompiler);
begin
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IJclStringList, 'IJclStringList');
  CL.AddTypeS('TJclStringListObjectsMode', '( omNone, omObjects, omVariants, omInterfaces )');
  SIRegister_IJclStringList(CL);
 CL.AddDelphiFunction('Function JclStringList : IJclStringList;');
 CL.AddDelphiFunction('Function JclStringListStrings( AStrings : TStrings) : IJclStringList;');
 CL.AddDelphiFunction('Function JclStringListStrings10( const A : array of string) : IJclStringList;');
 CL.AddDelphiFunction('Function JclStringList11( const A : array of const) : IJclStringList;');
 CL.AddDelphiFunction('Function JclStringList12( const AText : string) : IJclStringList;');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function JclStringList12_P( const AText : string) : IJclStringList;
Begin Result := JclStringLists.JclStringList(AText); END;

(*----------------------------------------------------------------------------*)
Function JclStringList11_P( const A : array of const) : IJclStringList;
Begin Result := JclStringLists.JclStringList(A); END;

(*----------------------------------------------------------------------------*)
Function JclStringListStrings10_P( const A : array of string) : IJclStringList;
Begin Result := JclStringLists.JclStringListStrings(A); END;

(*----------------------------------------------------------------------------*)
Function JclStringListStrings9_P( AStrings : TStrings) : IJclStringList;
Begin Result := JclStringLists.JclStringListStrings(AStrings); END;

(*----------------------------------------------------------------------------*)
Function JclStringList8_P : IJclStringList;
Begin Result := JclStringLists.JclStringList; END;

(*----------------------------------------------------------------------------*)
Function IJclStringListExtractWords7_P(Self: IJclStringList;  const AText : string; const ADelims : Tsyscharset; AClearBeforeAdd : Boolean) : IJclStringList;
Begin Result := Self.ExtractWords(AText, ADelims, AClearBeforeAdd); END;

(*----------------------------------------------------------------------------*)
Function IJclStringListExtractWords6_P(Self: IJclStringList;  const AText : string) : IJclStringList;
Begin Result := Self.ExtractWords(AText); END;

(*----------------------------------------------------------------------------*)
Function IJclStringListAddStrings5_P(Self: IJclStringList;  const A : array of string) : IJclStringList;
Begin Result := Self.AddStrings(A); END;

(*----------------------------------------------------------------------------*)
Function IJclStringListAdd4_P(Self: IJclStringList;  const A : array of const) : IJclStringList;
Begin Result := Self.Add(A); END;

(*----------------------------------------------------------------------------*)
Function IJclStringListDelete3_P(Self: IJclStringList;  const AString : string) : IJclStringList;
Begin Result := Self.Delete(AString); END;

(*----------------------------------------------------------------------------*)
Function IJclStringListDelete2_P(Self: IJclStringList;  AIndex : Integer) : IJclStringList;
Begin Result := Self.Delete(AIndex); END;

(*----------------------------------------------------------------------------*)
Procedure IJclStringListAddStrings1_P(Self: IJclStringList;  Strings : TStrings);
Begin Self.AddStrings(Strings); END;

(*----------------------------------------------------------------------------*)
Function IJclStringListAdd0_P(Self: IJclStringList;  const S : string) : Integer;
Begin Result := Self.Add(S); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclStringLists_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@JclStringList8_P, 'JclStringList', cdRegister);
 S.RegisterDelphiFunction(@JclStringListStrings9_P, 'JclStringListStrings', cdRegister);
 S.RegisterDelphiFunction(@JclStringListStrings10_P, 'JclStringListStrings10', cdRegister);
 S.RegisterDelphiFunction(@JclStringList11_P, 'JclStringList11', cdRegister);
 S.RegisterDelphiFunction(@JclStringList12_P, 'JclStringList12', cdRegister);
end;

 
 
{ TPSImport_JclStringLists }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclStringLists.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclStringLists(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclStringLists.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclStringLists_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
