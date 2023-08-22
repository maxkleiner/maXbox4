unit uPSI_JclStrHashMap;
{
  for TFileIterate Interface   add free   overrides
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
  TPSImport_JclStrHashMap = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCaseInsensitiveTraits(CL: TPSPascalCompiler);
procedure SIRegister_TCaseSensitiveTraits(CL: TPSPascalCompiler);
procedure SIRegister_TStringHashMap(CL: TPSPascalCompiler);
procedure SIRegister_TStringHashMapTraits(CL: TPSPascalCompiler);
procedure SIRegister_JclStrHashMap(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclStrHashMap_Routines(S: TPSExec);
procedure RIRegister_TCaseInsensitiveTraits(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCaseSensitiveTraits(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStringHashMap(CL: TPSRuntimeClassImporter);
//procedure RIRegister_JclStrHashMap_Routines(S: TPSExec);
procedure RIRegister_TStringHashMapTraits(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclStrHashMap(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   JclBase
  ,JclResources
  ,JclStrHashMap
  ;
 

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclStrHashMap]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCaseInsensitiveTraits(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringHashMapTraits', 'TCaseInsensitiveTraits') do
  with CL.AddClassN(CL.FindClass('TStringHashMapTraits'),'TCaseInsensitiveTraits') do begin
    RegisterMethod('function Hash(const s: string): Cardinal;');
    RegisterMethod('function Compare(const l, r: string): Integer;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCaseSensitiveTraits(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringHashMapTraits', 'TCaseSensitiveTraits') do
  with CL.AddClassN(CL.FindClass('TStringHashMapTraits'),'TCaseSensitiveTraits') do begin
    RegisterMethod('function Hash(const s: string): Cardinal;');
    RegisterMethod('function Compare(const l, r: string): Integer;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStringHashMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TStringHashMap') do
  with CL.AddClassN(CL.FindClass('TObject'),'TStringHashMap') do begin
    RegisterMethod('Constructor Create( ATraits : TStringHashMapTraits; AHashSize : Cardinal)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Add( const s : string; const p)');
    RegisterMethod('Function Remove( const s : string) : Pointer');
    RegisterMethod('Procedure RemoveData( const p)');
    RegisterMethod('Procedure Iterate( AUserData : Pointer; AIterateFunc : TIterateFunc)');
    RegisterMethod('Procedure IterateMethod( AUserData : Pointer; AIterateMethod : TIterateMethod)');
    RegisterMethod('Function Has( const s : string) : Boolean');
    RegisterMethod('Function Find( const s : string; var p) : Boolean');
    RegisterMethod('Procedure Clear');
    RegisterProperty('Count', 'Cardinal', iptr);
    RegisterProperty('Data', 'string string', iptrw);
    SetDefaultPropery('Data');
    RegisterProperty('Traits', 'TStringHashMapTraits', iptr);
    RegisterProperty('HashSize', 'Cardinal', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStringHashMapTraits(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TStringHashMapTraits') do
  with CL.AddClassN(CL.FindClass('TObject'),'TStringHashMapTraits') do
  begin
    RegisterMethod('Function Hash( const s : string) : Cardinal');
    RegisterMethod('Function Compare( const l, r : string) : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclStrHashMap(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclStringHashMapError');
  CL.AddTypeS('THashValue', 'Cardinal');
  SIRegister_TStringHashMapTraits(CL);
 CL.AddDelphiFunction('Function CaseSensitiveTraits : TStringHashMapTraits');
 CL.AddDelphiFunction('Function CaseInsensitiveTraits : TStringHashMapTraits');
  CL.AddTypeS('TIterateMethod', 'Function ( AUserData : String; const AStr : string; var APtr : String) : Boolean');
  //CL.AddTypeS('PPHashNode', '^PHashNode // will not work');
  //CL.AddTypeS('PHashNode', '^THashNode // will not work');
  //CL.AddTypeS('THashNode', 'record Str : string; Ptr : string; Left : PHashNod'
   //+'e; Right : PHashNode; end');
  //CL.AddTypeS('PHashArray', '^THashArray // will not work');
  SIRegister_TStringHashMap(CL);
 CL.AddDelphiFunction('Function StrHash( const s : string) : THashValue');
 CL.AddDelphiFunction('Function TextHash( const s : string) : THashValue');
 CL.AddDelphiFunction('Function DataHash( var AValue, ASize : Cardinal) : THashValue');
 CL.AddDelphiFunction('Function Iterate_FreeObjects( AUserData : TObject; const AStr : string; var AData : TObject) : Boolean');
 CL.AddDelphiFunction('Function Iterate_Dispose( AUserData : TObject; const AStr : string; var AData : TObject) : Boolean');
 CL.AddDelphiFunction('Function Iterate_FreeMem( AUserData : TObject; const AStr : string; var AData : TObject) : Boolean');
  SIRegister_TCaseSensitiveTraits(CL);
  SIRegister_TCaseInsensitiveTraits(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStringHashMapHashSize_W(Self: TStringHashMap; const T: Cardinal);
begin Self.HashSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringHashMapHashSize_R(Self: TStringHashMap; var T: Cardinal);
begin T := Self.HashSize; end;

(*----------------------------------------------------------------------------*)
procedure TStringHashMapTraits_R(Self: TStringHashMap; var T: TStringHashMapTraits);
begin T := Self.Traits; end;

(*----------------------------------------------------------------------------*)
procedure TStringHashMapData_W(Self: TStringHashMap; const T: Pointer; const t1: string);
begin Self.Data[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringHashMapData_R(Self: TStringHashMap; var T: Pointer; const t1: string);
begin T := Self.Data[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStringHashMapCount_R(Self: TStringHashMap; var T: Cardinal);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCaseInsensitiveTraits(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCaseInsensitiveTraits) do begin
    RegisterMethod(@TCaseInsensitiveTraits.Hash, 'Hash');
    RegisterMethod(@TCaseInsensitiveTraits.Compare, 'Compare');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCaseSensitiveTraits(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCaseSensitiveTraits) do begin
   RegisterMethod(@TCaseSensitiveTraits.Hash, 'Hash');
    RegisterMethod(@TCaseSensitiveTraits.Compare, 'Compare');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStringHashMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStringHashMap) do begin
    RegisterConstructor(@TStringHashMap.Create, 'Create');
    RegisterMethod(@TStringHashMap.Destroy, 'Free');
    RegisterMethod(@TStringHashMap.Add, 'Add');
    RegisterMethod(@TStringHashMap.Remove, 'Remove');
    RegisterMethod(@TStringHashMap.RemoveData, 'RemoveData');
    RegisterMethod(@TStringHashMap.Iterate, 'Iterate');
    RegisterMethod(@TStringHashMap.IterateMethod, 'IterateMethod');
    RegisterMethod(@TStringHashMap.Has, 'Has');
    RegisterMethod(@TStringHashMap.Find, 'Find');
    RegisterMethod(@TStringHashMap.Clear, 'Clear');
    RegisterPropertyHelper(@TStringHashMapCount_R,nil,'Count');
    RegisterPropertyHelper(@TStringHashMapData_R,@TStringHashMapData_W,'Data');
    RegisterPropertyHelper(@TStringHashMapTraits_R,nil,'Traits');
    RegisterPropertyHelper(@TStringHashMapHashSize_R,@TStringHashMapHashSize_W,'HashSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclStrHashMap_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CaseSensitiveTraits, 'CaseSensitiveTraits', cdRegister);
 S.RegisterDelphiFunction(@CaseInsensitiveTraits, 'CaseInsensitiveTraits', cdRegister);
  //RIRegister_TStringHashMap(CL);
 S.RegisterDelphiFunction(@StrHash, 'StrHash', cdRegister);
 S.RegisterDelphiFunction(@TextHash, 'TextHash', cdRegister);
 S.RegisterDelphiFunction(@DataHash, 'DataHash', cdRegister);
 S.RegisterDelphiFunction(@Iterate_FreeObjects, 'Iterate_FreeObjects', cdRegister);
 S.RegisterDelphiFunction(@Iterate_Dispose, 'Iterate_Dispose', cdRegister);
 S.RegisterDelphiFunction(@Iterate_FreeMem, 'Iterate_FreeMem', cdRegister);
  //RIRegister_TCaseSensitiveTraits(CL);
  //RIRegister_TCaseInsensitiveTraits(CL);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStringHashMapTraits(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStringHashMapTraits) do begin
    //RegisterVirtualAbstractMethod(@TStringHashMapTraits, @!.Hash, 'Hash');
    //RegisterVirtualAbstractMethod(@TStringHashMapTraits, @!.Compare, 'Compare');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclStrHashMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJclStringHashMapError) do
  RIRegister_TStringHashMapTraits(CL);
    RIRegister_TStringHashMap(CL);
  RIRegister_TCaseSensitiveTraits(CL);
  RIRegister_TCaseInsensitiveTraits(CL);

end;

 
 
{ TPSImport_JclStrHashMap }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclStrHashMap.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclStrHashMap(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclStrHashMap.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclStrHashMap(ri);
  RIRegister_JclStrHashMap_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
