unit uPSI_JclStringLists;
{
second update with TJclStringlist  implement of V47520

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
procedure SIRegister_TJclStringList(CL: TPSPascalCompiler);
procedure SIRegister_TJclInterfacedStringList(CL: TPSPascalCompiler);
procedure SIRegister_IJclStringList(CL: TPSPascalCompiler);
procedure SIRegister_JclStringLists(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclStringLists_Routines(S: TPSExec);
procedure RIRegister_TJclStringList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclInterfacedStringList(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclStringLists(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //JclUnitVersioning
  Windows
  ,Variants
  ,JclBase
  ,JclPCRE
  ,JclStringLists, Math
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclStringLists]);
end;


procedure Swap(var X, Y: integer);
var F : integer;
begin
  F := X;
  X := Y;
  Y := F;
end;

{ Find the GCD using Euclid's algorithm                                        }
function GCD(const N1, N2: Integer): Integer;
var X, Y, J : Integer;
begin
  X := N1;
  Y := N2;
  if X < Y then Swap(X, Y);
  while (X <> 1) and (X <> 0) and (Y <> 1) and (Y <> 0) do begin
      J := (X - Y) mod Y;
      if J = 0 then begin
          Result := Abs(Y);
          exit;
        end;
      X := Y;
      Y := J;
    end;
  Result := 1;
end;

{ Find the modular inverse of A modulo N using Euclid's algorithm.             }
function InvMod(const A, N: Integer): Integer;
var g0, g1, v0, v1, y, z : Integer;
begin
  if N < 2 then
    raise (EInvalidArgument.CreateFmt('InvMod: n=%d < 2', [N]));
  if GCD (A, N) <> 1 then
    raise (EInvalidArgument.CreateFmt('InvMod: GCD (a=%d, n=%d) <> 1', [A, N])) ;
  g0 := N;  g1 := A;
  v0 := 0;  v1 := 1;
  while g1 <> 0 do begin
      y := g0 div g1;
      z := g1;
      g1 := g0 - y * g1;
      g0 := z;
      z := v1;
      v1 := v0 - y * v1;
      v0 := z;
    end;
  if v0 > 0 then
    Result := v0 else
    Result := v0 + N;
end;


{ Calculates x = a^z mod n                                                     }
function ExpMod(A, Z: Integer; const N: Integer): Integer;
var Signed : Boolean;
begin
  Signed := Z < 0;
  if Signed then
    Z := -Z;
  Result := 1;
  while Z <> 0 do begin
      while not Odd(Z) do begin
          Z := Z shr 1;
          A := (A * Int64(A)) mod N;
        end;
      Dec (Z);
      Result := (Result * Int64(A)) mod N;
    end;
  if Signed then
    Result := InvMod(Result, N);
end;

function CopyFrom(const S: String; const Index: Integer): String;
var L : Integer;
begin
  if Index <= 1 then
    Result := S
  else  begin
      L := Length(S);
      if (L = 0) or (Index > L) then
        Result := ''
      else
        Result := Copy(S, Index, L - Index + 1);
    end;
end;

{ TranslateStartStop translates Start, Stop parameters (negative values are    }
{ indexed from back of string) into StartIdx and StopIdx (relative to start).  }
{ Returns False if the Start, Stop does not specify a valid range.             }
function TranslateStart(const Len, Start: Integer; var StartIndex : Integer): Boolean;
begin
  if Len = 0 then
    Result := False
  else
    begin
      StartIndex := Start;
      if Start < 0 then
        Inc(StartIndex, Len + 1);
      if StartIndex > Len then
        Result := False
      else begin
          if StartIndex < 1 then
            StartIndex := 1;
          Result := True;
        end;
    end;
end;

function CopyEx2(const S: String; const Start, Count: Integer): String;
var I, L : Integer;
begin
  L := Length(S);
  if (Count < 0) or not TranslateStart(L, Start, I) then
    Result := '' else
    if (I = 1) and (Count >= L) then
      Result := S
    else
      Result := Copy(S, I, Count);
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclStringList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclInterfacedStringList', 'TJclStringList') do
  with CL.AddClassN(CL.FindClass('TJclInterfacedStringList'),'TJclStringList') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function _AddRef : Integer');
    RegisterMethod('Function _Release : Integer');
    RegisterMethod('Function GetObjects( Index : Integer) : TObject');
    RegisterMethod('Function GetValue( const Name : string) : string');
    RegisterMethod('Function GetCaseSensitive : Boolean');
    RegisterMethod('Function GetDuplicates : TDuplicates');
    RegisterMethod('Function GetOnChange : TNotifyEvent');
    RegisterMethod('Function GetOnChanging : TNotifyEvent');
    RegisterMethod('Function GetSorted : Boolean');
    RegisterMethod('Function LoadFromFile( const FileName : string) : IJclStringList');
    RegisterMethod('Function LoadFromStream( Stream : TStream) : IJclStringList');
    RegisterMethod('Function SaveToFile( const FileName : string) : IJclStringList');
    RegisterMethod('Function SaveToStream( Stream : TStream) : IJclStringList');
    RegisterMethod('Function GetCommaText : string');
    RegisterMethod('Function GetDelimitedText : string');
    RegisterMethod('Function GetDelimiter : Char');
    RegisterMethod('Function GetName( Index : Integer) : string');
    RegisterMethod('Function GetNameValueSeparator : Char');
    RegisterMethod('Function GetValueFromIndex( Index : Integer) : string');
    RegisterMethod('Function GetQuoteChar : Char');
    RegisterMethod('Procedure SetCommaText( const Value : string)');
    RegisterMethod('Procedure SetDelimitedText( const Value : string)');
    RegisterMethod('Procedure SetDelimiter( const Value : Char)');
    RegisterMethod('Procedure SetNameValueSeparator( const Value : Char)');
    RegisterMethod('Procedure SetValueFromIndex( Index : Integer; const Value : string)');
    RegisterMethod('Procedure SetQuoteChar( const Value : Char)');
    RegisterMethod('Procedure SetObjects( Index : Integer; const Value : TObject)');
    RegisterMethod('Procedure SetValue( const Name, Value : string)');
    RegisterMethod('Procedure SetCaseSensitive( const Value : Boolean)');
    RegisterMethod('Procedure SetDuplicates( const Value : TDuplicates)');
    RegisterMethod('Procedure SetOnChange( const Value : TNotifyEvent)');
    RegisterMethod('Procedure SetOnChanging( const Value : TNotifyEvent)');
    RegisterMethod('Procedure SetSorted( const Value : Boolean)');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Strings', 'string Integer', iptrw);
    SetDefaultPropery('Strings');
    RegisterProperty('Text', 'string', iptrw);
    RegisterProperty('Objects', 'TObject Integer', iptrw);
    RegisterProperty('Capacity', 'Integer', iptrw);
    RegisterProperty('Values', 'string string', iptrw);
    RegisterProperty('Duplicates', 'TDuplicates', iptrw);
    RegisterProperty('Sorted', 'Boolean', iptrw);
    RegisterProperty('CaseSensitive', 'Boolean', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChanging', 'TNotifyEvent', iptrw);
    RegisterProperty('DelimitedText', 'string', iptrw);
    RegisterProperty('Delimiter', 'Char', iptrw);
    RegisterProperty('Names', 'string Integer', iptr);
    RegisterProperty('QuoteChar', 'Char', iptrw);
    RegisterProperty('CommaText', 'string', iptrw);
    RegisterProperty('ValueFromIndex', 'string Integer', iptrw);
    RegisterProperty('NameValueSeparator', 'Char', iptrw);
    RegisterMethod('Function Assign( Source : TPersistent) : IJclStringList');
    RegisterMethod('Function LoadExeParams : IJclStringList');
    RegisterMethod('Function Exists( const S : string) : Boolean');
    RegisterMethod('Function ExistsName( const S : string) : Boolean');
    RegisterMethod('Function DeleteBlanks : IJclStringList');
    RegisterMethod('Function KeepIntegers : IJclStringList');
    RegisterMethod('Function DeleteIntegers : IJclStringList');
    RegisterMethod('Function ReleaseInterfaces : IJclStringList');
    RegisterMethod('Function FreeObjects( AFreeAndNil : Boolean) : IJclStringList');
    RegisterMethod('Function Clone : IJclStringList');
    RegisterMethod('Function Insert( Index : Integer; const S : string) : IJclStringList');
    RegisterMethod('Function InsertObject( Index : Integer; const S : string; AObject : TObject) : IJclStringList');
    RegisterMethod('Function Sort( ACompareFunction : TJclStringListSortCompare) : IJclStringList');
    RegisterMethod('Function SortAsInteger : IJclStringList');
    RegisterMethod('Function SortByName : IJclStringList');
    RegisterMethod('Function Delete( AIndex : Integer) : IJclStringList;');
    RegisterMethod('Function Delete1( const AString : string) : IJclStringList;');
    RegisterMethod('Function Exchange( Index1, Index2 : Integer) : IJclStringList');
    RegisterMethod('Function Add( const A : array of const) : IJclStringList;');
    RegisterMethod('Function AddStrings( const A : array of string) : IJclStringList;');
    RegisterMethod('Function BeginUpdate : IJclStringList');
    RegisterMethod('Function EndUpdate : IJclStringList');
    RegisterMethod('Function Trim : IJclStringList');
    RegisterMethod('Function Join( const ASeparator : string) : string');
    RegisterMethod('Function Split( const AText, ASeparator : string; AClearBeforeAdd : Boolean) : IJclStringList');
    RegisterMethod('Function ExtractWords( const AText : string; const ADelims : TSysCharset; AClearBeforeAdd : Boolean) : IJclStringList');
    RegisterMethod('Function Last : string');
    RegisterMethod('Function First : string');
    RegisterMethod('Function LastIndex : Integer');
    RegisterMethod('Function Clear : IJclStringList');
    RegisterMethod('Function DeleteRegEx( const APattern : string) : IJclStringList');
    RegisterMethod('Function KeepRegEx( const APattern : string) : IJclStringList');
    RegisterMethod('Function Files( const APattern : string; ARecursive : Boolean; const ARegExPattern : string) : IJclStringList');
    RegisterMethod('Function Directories( const APattern : string; ARecursive : Boolean; const ARegExPattern : string) : IJclStringList');
    RegisterMethod('Function GetStringsRef : TStrings');
    RegisterMethod('Function ConfigAsSet : IJclStringList');
    RegisterMethod('Function Delimit( const ADelimiter : string) : IJclStringList');
    RegisterMethod('Function GetInterfaceByIndex( Index : Integer) : IInterface');
    RegisterMethod('Function GetLists( Index : Integer) : IJclStringList');
    RegisterMethod('Function GetVariants( AIndex : Integer) : Variant');
    RegisterMethod('Function GetKeyInterface( const AKey : string) : IInterface');
    RegisterMethod('Function GetKeyObject( const AKey : string) : TObject');
    RegisterMethod('Function GetKeyVariant( const AKey : string) : Variant');
    RegisterMethod('Function GetKeyList( const AKey : string) : IJclStringList');
    RegisterMethod('Function GetObjectsMode : TJclStringListObjectsMode');
    RegisterMethod('Procedure SetInterfaceByIndex( Index : Integer; const Value : IInterface)');
    RegisterMethod('Procedure SetLists( Index : Integer; const Value : IJclStringList)');
    RegisterMethod('Procedure SetVariants( Index : Integer; const Value : Variant)');
    RegisterMethod('Procedure SetKeyInterface( const AKey : string; const Value : IInterface)');
    RegisterMethod('Procedure SetKeyObject( const AKey : string; const Value : TObject)');
    RegisterMethod('Procedure SetKeyVariant( const AKey : string; const Value : Variant)');
    RegisterMethod('Procedure SetKeyList( const AKey : string; const Value : IJclStringList)');
    RegisterProperty('Interfaces', 'IInterface Integer', iptrw);
    RegisterProperty('Lists', 'IJclStringList Integer', iptrw);
    RegisterProperty('Variants', 'Variant Integer', iptrw);
    RegisterProperty('KeyList', 'IJclStringList string', iptrw);
    RegisterProperty('KeyObject', 'TObject string', iptrw);
    RegisterProperty('KeyInterface', 'IInterface string', iptrw);
    RegisterProperty('KeyVariant', 'Variant string', iptrw);
    RegisterProperty('ObjectsMode', 'TJclStringListObjectsMode', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclInterfacedStringList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TJclInterfacedStringList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TJclInterfacedStringList') do
  begin
    RegisterMethod('Function _AddRef : Integer');
    RegisterMethod('Function _Release : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IJclStringList(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IInterface', 'IJclStringList') do
  with CL.AddInterface(CL.FindInterface('IInterface'),IJclStringList, 'IJclStringList') do begin
    RegisterMethod('Function Add( const S : string) : Integer;', cdRegister);
    RegisterMethod('Function AddObject( const S : string; AObject : TObject) : Integer', cdRegister);
    RegisterMethod('Function Get( Index : Integer) : string', cdRegister);
    RegisterMethod('Function GetCapacity : Integer', cdRegister);
    RegisterMethod('Function GetCount : Integer', cdRegister);
    RegisterMethod('Function GetObjects( Index : Integer) : TObject', cdRegister);
    RegisterMethod('Function GetTextStr : string', cdRegister);
    RegisterMethod('Function GetValue( const Name : string) : string', cdRegister);
    RegisterMethod('Function Find( const S : string; out Index : Integer) : Boolean', cdRegister);
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
    RegisterMethod('Function ExtractWords( const AText : string; const ADelims : TSysCharset; AClearBeforeAdd : Boolean) : IJclStringList', cdRegister);
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
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclStringListError');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IJclStringList, 'IJclStringList');
  CL.AddTypeS('TJclStringListObjectsMode', '( omNone, omObjects, omVariants, omInterfaces )');
  SIRegister_IJclStringList(CL);
  SIRegister_TJclInterfacedStringList(CL);
  SIRegister_TJclStringList(CL);
 CL.AddDelphiFunction('Function JclStringList : IJclStringList;');
 CL.AddDelphiFunction('Function JclStringListStrings( AStrings : TStrings) : IJclStringList;');
 CL.AddDelphiFunction('Function JclStringListStrings1( const A : array of string) : IJclStringList;');
 CL.AddDelphiFunction('Function JclStringList1( const A : array of const) : IJclStringList;');
 CL.AddDelphiFunction('Function JclStringList2( const AText : string) : IJclStringList;');
 CL.AddDelphiFunction('function InvMod(const A, N: Integer): Integer;');
 CL.AddDelphiFunction('function ExpMod(A, Z: Integer; const N: Integer): Integer;');
 CL.AddDelphiFunction('function CopyFrom(const S: String; const Index: Integer): String;');
 CL.AddDelphiFunction('function CopyEx(const S: String; const Start, Count: Integer): String;');
 CL.AddDelphiFunction('function loadForm2(vx, vy: smallint; acolor: TColor; aname: string): TForm;');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function JclStringList14_P( const AText : string) : IJclStringList;
Begin Result := JclStringLists.JclStringList(AText); END;

(*----------------------------------------------------------------------------*)
Function JclStringList13_P( const A : array of const) : IJclStringList;
Begin Result := JclStringLists.JclStringList(A); END;

(*----------------------------------------------------------------------------*)
Function JclStringListStrings12_P( const A : array of string) : IJclStringList;
Begin Result := JclStringLists.JclStringListStrings(A); END;

(*----------------------------------------------------------------------------*)
Function JclStringListStrings11_P( AStrings : TStrings) : IJclStringList;
Begin Result := JclStringLists.JclStringListStrings(AStrings); END;

(*----------------------------------------------------------------------------*)
Function JclStringList10_P : IJclStringList;
Begin Result := JclStringLists.JclStringList; END;

(*----------------------------------------------------------------------------*)
procedure TJclStringListObjectsMode_R(Self: TJclStringList; var T: TJclStringListObjectsMode);
begin T := Self.ObjectsMode; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListKeyVariant_W(Self: TJclStringList; const T: Variant; const t1: string);
begin Self.KeyVariant[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListKeyVariant_R(Self: TJclStringList; var T: Variant; const t1: string);
begin T := Self.KeyVariant[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListKeyInterface_W(Self: TJclStringList; const T: IInterface; const t1: string);
begin Self.KeyInterface[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListKeyInterface_R(Self: TJclStringList; var T: IInterface; const t1: string);
begin T := Self.KeyInterface[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListKeyObject_W(Self: TJclStringList; const T: TObject; const t1: string);
begin Self.KeyObject[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListKeyObject_R(Self: TJclStringList; var T: TObject; const t1: string);
begin T := Self.KeyObject[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListKeyList_W(Self: TJclStringList; const T: IJclStringList; const t1: string);
begin Self.KeyList[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListKeyList_R(Self: TJclStringList; var T: IJclStringList; const t1: string);
begin T := Self.KeyList[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListVariants_W(Self: TJclStringList; const T: Variant; const t1: Integer);
begin Self.Variants[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListVariants_R(Self: TJclStringList; var T: Variant; const t1: Integer);
begin T := Self.Variants[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListLists_W(Self: TJclStringList; const T: IJclStringList; const t1: Integer);
begin Self.Lists[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListLists_R(Self: TJclStringList; var T: IJclStringList; const t1: Integer);
begin T := Self.Lists[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListInterfaces_W(Self: TJclStringList; const T: IInterface; const t1: Integer);
begin Self.Interfaces[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListInterfaces_R(Self: TJclStringList; var T: IInterface; const t1: Integer);
begin T := Self.Interfaces[t1]; end;

(*----------------------------------------------------------------------------*)
Function TJclStringListAddStrings9_P(Self: TJclStringList;  const A : array of string) : IJclStringList;
Begin Result := Self.AddStrings(A); END;

(*----------------------------------------------------------------------------*)
Function TJclStringListAdd8_P(Self: TJclStringList;  const A : array of const) : IJclStringList;
Begin Result := Self.Add(A); END;

(*----------------------------------------------------------------------------*)
Function TJclStringListDelete7_P(Self: TJclStringList;  const AString : string) : IJclStringList;
Begin Result := Self.Delete(AString); END;

(*----------------------------------------------------------------------------*)
Function TJclStringListDelete6_P(Self: TJclStringList;  AIndex : Integer) : IJclStringList;
Begin Result := Self.Delete(AIndex); END;

(*----------------------------------------------------------------------------*)
procedure TJclStringListNameValueSeparator_W(Self: TJclStringList; const T: Char);
begin Self.NameValueSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListNameValueSeparator_R(Self: TJclStringList; var T: Char);
begin T := Self.NameValueSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListValueFromIndex_W(Self: TJclStringList; const T: string; const t1: Integer);
begin Self.ValueFromIndex[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListValueFromIndex_R(Self: TJclStringList; var T: string; const t1: Integer);
begin T := Self.ValueFromIndex[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListCommaText_W(Self: TJclStringList; const T: string);
begin Self.CommaText := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListCommaText_R(Self: TJclStringList; var T: string);
begin T := Self.CommaText; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListQuoteChar_W(Self: TJclStringList; const T: Char);
begin Self.QuoteChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListQuoteChar_R(Self: TJclStringList; var T: Char);
begin T := Self.QuoteChar; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListNames_R(Self: TJclStringList; var T: string; const t1: Integer);
begin T := Self.Names[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListDelimiter_W(Self: TJclStringList; const T: Char);
begin Self.Delimiter := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListDelimiter_R(Self: TJclStringList; var T: Char);
begin T := Self.Delimiter; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListDelimitedText_W(Self: TJclStringList; const T: string);
begin Self.DelimitedText := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListDelimitedText_R(Self: TJclStringList; var T: string);
begin T := Self.DelimitedText; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListOnChanging_W(Self: TJclStringList; const T: TNotifyEvent);
begin Self.OnChanging := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListOnChanging_R(Self: TJclStringList; var T: TNotifyEvent);
begin T := Self.OnChanging; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListOnChange_W(Self: TJclStringList; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListOnChange_R(Self: TJclStringList; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListCaseSensitive_W(Self: TJclStringList; const T: Boolean);
begin Self.CaseSensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListCaseSensitive_R(Self: TJclStringList; var T: Boolean);
begin T := Self.CaseSensitive; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListSorted_W(Self: TJclStringList; const T: Boolean);
begin Self.Sorted := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListSorted_R(Self: TJclStringList; var T: Boolean);
begin T := Self.Sorted; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListDuplicates_W(Self: TJclStringList; const T: TDuplicates);
begin Self.Duplicates := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListDuplicates_R(Self: TJclStringList; var T: TDuplicates);
begin T := Self.Duplicates; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListValues_W(Self: TJclStringList; const T: string; const t1: string);
begin Self.Values[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListValues_R(Self: TJclStringList; var T: string; const t1: string);
begin T := Self.Values[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListCapacity_W(Self: TJclStringList; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListCapacity_R(Self: TJclStringList; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListObjects_W(Self: TJclStringList; const T: TObject; const t1: Integer);
begin Self.Objects[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListObjects_R(Self: TJclStringList; var T: TObject; const t1: Integer);
begin T := Self.Objects[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListText_W(Self: TJclStringList; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListText_R(Self: TJclStringList; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListStrings_W(Self: TJclStringList; const T: string; const t1: Integer);
begin Self.Strings[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListStrings_R(Self: TJclStringList; var T: string; const t1: Integer);
begin T := Self.Strings[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclStringListCount_R(Self: TJclStringList; var T: Integer);
begin T := Self.Count; end;

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
 S.RegisterDelphiFunction(@JclStringList10_P, 'JclStringList', cdRegister);
 S.RegisterDelphiFunction(@JclStringListStrings11_P, 'JclStringListStrings', cdRegister);
 S.RegisterDelphiFunction(@JclStringListStrings12_P, 'JclStringListStrings1', cdRegister);
 S.RegisterDelphiFunction(@JclStringList13_P, 'JclStringList1', cdRegister);
 S.RegisterDelphiFunction(@JclStringList14_P, 'JclStringList2', cdRegister);
 S.RegisterDelphiFunction(@InvMod, 'InvMod', CdRegister);
 S.RegisterDelphiFunction(@ExpMod, 'ExpMod', CdRegister);
 S.RegisterDelphiFunction(@CopyFrom, 'CopyFrom', CdRegister);
 S.RegisterDelphiFunction(@CopyEx2, 'CopyEx', CdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclStringList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclStringList) do begin
    RegisterConstructor(@TJclStringList.Create, 'Create');
    RegisterMethod(@TJclStringList.Destroy, 'Free');
    RegisterMethod(@TJclStringList._AddRef, '_AddRef');
    RegisterMethod(@TJclStringList._Release, '_Release');
    RegisterMethod(@TJclStringList.GetObjects, 'GetObjects');
    RegisterMethod(@TJclStringList.GetValue, 'GetValue');
    RegisterMethod(@TJclStringList.GetCaseSensitive, 'GetCaseSensitive');
    RegisterMethod(@TJclStringList.GetDuplicates, 'GetDuplicates');
    RegisterMethod(@TJclStringList.GetOnChange, 'GetOnChange');
    RegisterMethod(@TJclStringList.GetOnChanging, 'GetOnChanging');
    RegisterMethod(@TJclStringList.GetSorted, 'GetSorted');
    RegisterMethod(@TJclStringList.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TJclStringList.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TJclStringList.SaveToFile, 'SaveToFile');
    RegisterMethod(@TJclStringList.SaveToStream, 'SaveToStream');
    RegisterMethod(@TJclStringList.GetCommaText, 'GetCommaText');
    RegisterMethod(@TJclStringList.GetDelimitedText, 'GetDelimitedText');
    RegisterMethod(@TJclStringList.GetDelimiter, 'GetDelimiter');
    RegisterMethod(@TJclStringList.GetName, 'GetName');
    RegisterMethod(@TJclStringList.GetNameValueSeparator, 'GetNameValueSeparator');
    RegisterMethod(@TJclStringList.GetValueFromIndex, 'GetValueFromIndex');
    RegisterMethod(@TJclStringList.GetQuoteChar, 'GetQuoteChar');
    RegisterMethod(@TJclStringList.SetCommaText, 'SetCommaText');
    RegisterMethod(@TJclStringList.SetDelimitedText, 'SetDelimitedText');
    RegisterMethod(@TJclStringList.SetDelimiter, 'SetDelimiter');
    RegisterMethod(@TJclStringList.SetNameValueSeparator, 'SetNameValueSeparator');
    RegisterMethod(@TJclStringList.SetValueFromIndex, 'SetValueFromIndex');
    RegisterMethod(@TJclStringList.SetQuoteChar, 'SetQuoteChar');
    RegisterMethod(@TJclStringList.SetObjects, 'SetObjects');
    RegisterMethod(@TJclStringList.SetValue, 'SetValue');
    RegisterMethod(@TJclStringList.SetCaseSensitive, 'SetCaseSensitive');
    RegisterMethod(@TJclStringList.SetDuplicates, 'SetDuplicates');
    RegisterMethod(@TJclStringList.SetOnChange, 'SetOnChange');
    RegisterMethod(@TJclStringList.SetOnChanging, 'SetOnChanging');
    RegisterMethod(@TJclStringList.SetSorted, 'SetSorted');
    RegisterPropertyHelper(@TJclStringListCount_R,nil,'Count');
    RegisterPropertyHelper(@TJclStringListStrings_R,@TJclStringListStrings_W,'Strings');
    RegisterPropertyHelper(@TJclStringListText_R,@TJclStringListText_W,'Text');
    RegisterPropertyHelper(@TJclStringListObjects_R,@TJclStringListObjects_W,'Objects');
    RegisterPropertyHelper(@TJclStringListCapacity_R,@TJclStringListCapacity_W,'Capacity');
    RegisterPropertyHelper(@TJclStringListValues_R,@TJclStringListValues_W,'Values');
    RegisterPropertyHelper(@TJclStringListDuplicates_R,@TJclStringListDuplicates_W,'Duplicates');
    RegisterPropertyHelper(@TJclStringListSorted_R,@TJclStringListSorted_W,'Sorted');
    RegisterPropertyHelper(@TJclStringListCaseSensitive_R,@TJclStringListCaseSensitive_W,'CaseSensitive');
    RegisterPropertyHelper(@TJclStringListOnChange_R,@TJclStringListOnChange_W,'OnChange');
    RegisterPropertyHelper(@TJclStringListOnChanging_R,@TJclStringListOnChanging_W,'OnChanging');
    RegisterPropertyHelper(@TJclStringListDelimitedText_R,@TJclStringListDelimitedText_W,'DelimitedText');
    RegisterPropertyHelper(@TJclStringListDelimiter_R,@TJclStringListDelimiter_W,'Delimiter');
    RegisterPropertyHelper(@TJclStringListNames_R,nil,'Names');
    RegisterPropertyHelper(@TJclStringListQuoteChar_R,@TJclStringListQuoteChar_W,'QuoteChar');
    RegisterPropertyHelper(@TJclStringListCommaText_R,@TJclStringListCommaText_W,'CommaText');
    RegisterPropertyHelper(@TJclStringListValueFromIndex_R,@TJclStringListValueFromIndex_W,'ValueFromIndex');
    RegisterPropertyHelper(@TJclStringListNameValueSeparator_R,@TJclStringListNameValueSeparator_W,'NameValueSeparator');
    RegisterMethod(@TJclStringList.Assign, 'Assign');
    RegisterMethod(@TJclStringList.LoadExeParams, 'LoadExeParams');
    RegisterMethod(@TJclStringList.Exists, 'Exists');
    RegisterMethod(@TJclStringList.ExistsName, 'ExistsName');
    RegisterMethod(@TJclStringList.DeleteBlanks, 'DeleteBlanks');
    RegisterMethod(@TJclStringList.KeepIntegers, 'KeepIntegers');
    RegisterMethod(@TJclStringList.DeleteIntegers, 'DeleteIntegers');
    RegisterMethod(@TJclStringList.ReleaseInterfaces, 'ReleaseInterfaces');
    RegisterMethod(@TJclStringList.FreeObjects, 'FreeObjects');
    RegisterMethod(@TJclStringList.Clone, 'Clone');
    RegisterMethod(@TJclStringList.Insert, 'Insert');
    RegisterMethod(@TJclStringList.InsertObject, 'InsertObject');
    RegisterMethod(@TJclStringList.Sort, 'Sort');
    RegisterMethod(@TJclStringList.SortAsInteger, 'SortAsInteger');
    RegisterMethod(@TJclStringList.SortByName, 'SortByName');
    RegisterMethod(@TJclStringListDelete6_P, 'Delete');
    RegisterMethod(@TJclStringListDelete7_P, 'Delete1');
    RegisterMethod(@TJclStringList.Exchange, 'Exchange');
    RegisterMethod(@TJclStringListAdd8_P, 'Add');
    RegisterMethod(@TJclStringListAddStrings9_P, 'AddStrings');
    RegisterMethod(@TJclStringList.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TJclStringList.EndUpdate, 'EndUpdate');
    RegisterMethod(@TJclStringList.Trim, 'Trim');
    RegisterMethod(@TJclStringList.Join, 'Join');
    RegisterMethod(@TJclStringList.Split, 'Split');
    RegisterMethod(@TJclStringList.ExtractWords, 'ExtractWords');
    RegisterMethod(@TJclStringList.Last, 'Last');
    RegisterMethod(@TJclStringList.First, 'First');
    RegisterMethod(@TJclStringList.LastIndex, 'LastIndex');
    RegisterMethod(@TJclStringList.Clear, 'Clear');
    RegisterMethod(@TJclStringList.DeleteRegEx, 'DeleteRegEx');
    RegisterMethod(@TJclStringList.KeepRegEx, 'KeepRegEx');
    RegisterMethod(@TJclStringList.Files, 'Files');
    RegisterMethod(@TJclStringList.Directories, 'Directories');
    RegisterMethod(@TJclStringList.GetStringsRef, 'GetStringsRef');
    RegisterMethod(@TJclStringList.ConfigAsSet, 'ConfigAsSet');
    RegisterMethod(@TJclStringList.Delimit, 'Delimit');
    RegisterMethod(@TJclStringList.GetInterfaceByIndex, 'GetInterfaceByIndex');
    RegisterMethod(@TJclStringList.GetLists, 'GetLists');
    RegisterMethod(@TJclStringList.GetVariants, 'GetVariants');
    RegisterMethod(@TJclStringList.GetKeyInterface, 'GetKeyInterface');
    RegisterMethod(@TJclStringList.GetKeyObject, 'GetKeyObject');
    RegisterMethod(@TJclStringList.GetKeyVariant, 'GetKeyVariant');
    RegisterMethod(@TJclStringList.GetKeyList, 'GetKeyList');
    RegisterMethod(@TJclStringList.GetObjectsMode, 'GetObjectsMode');
    RegisterMethod(@TJclStringList.SetInterfaceByIndex, 'SetInterfaceByIndex');
    RegisterMethod(@TJclStringList.SetLists, 'SetLists');
    RegisterMethod(@TJclStringList.SetVariants, 'SetVariants');
    RegisterMethod(@TJclStringList.SetKeyInterface, 'SetKeyInterface');
    RegisterMethod(@TJclStringList.SetKeyObject, 'SetKeyObject');
    RegisterMethod(@TJclStringList.SetKeyVariant, 'SetKeyVariant');
    RegisterMethod(@TJclStringList.SetKeyList, 'SetKeyList');
    RegisterPropertyHelper(@TJclStringListInterfaces_R,@TJclStringListInterfaces_W,'Interfaces');
    RegisterPropertyHelper(@TJclStringListLists_R,@TJclStringListLists_W,'Lists');
    RegisterPropertyHelper(@TJclStringListVariants_R,@TJclStringListVariants_W,'Variants');
    RegisterPropertyHelper(@TJclStringListKeyList_R,@TJclStringListKeyList_W,'KeyList');
    RegisterPropertyHelper(@TJclStringListKeyObject_R,@TJclStringListKeyObject_W,'KeyObject');
    RegisterPropertyHelper(@TJclStringListKeyInterface_R,@TJclStringListKeyInterface_W,'KeyInterface');
    RegisterPropertyHelper(@TJclStringListKeyVariant_R,@TJclStringListKeyVariant_W,'KeyVariant');
    RegisterPropertyHelper(@TJclStringListObjectsMode_R,nil,'ObjectsMode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclInterfacedStringList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclInterfacedStringList) do
  begin
    RegisterMethod(@TJclInterfacedStringList._AddRef, '_AddRef');
    RegisterMethod(@TJclInterfacedStringList._Release, '_Release');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclStringLists(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJclStringListError) do
  RIRegister_TJclInterfacedStringList(CL);
  RIRegister_TJclStringList(CL);
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
  RIRegister_JclStringLists(ri);
  RIRegister_JclStringLists_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
