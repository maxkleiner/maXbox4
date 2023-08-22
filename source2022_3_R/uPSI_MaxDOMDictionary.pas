unit uPSI_MaxDOMDictionary;
{
max dom dic   change tnode

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
  TPSImport_MaxDOMDictionary = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDictionary(CL: TPSPascalCompiler);
procedure SIRegister_IDictionary(CL: TPSPascalCompiler);
procedure SIRegister_MaxDOMDictionary(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_MaxDOMDictionary_Routines(S: TPSExec);
procedure RIRegister_TDictionary(CL: TPSRuntimeClassImporter);
procedure RIRegister_MaxDOMDictionary(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   INIFiles
  ,MaxDOM
  ,MaxDOMDictionary
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MaxDOMDictionary]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDictionary(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TNode', 'TDictionary') do
  with CL.AddClassN(CL.FindClass('TNode'),'TDictionary') do begin
    RegisterMethod('Constructor Create( const AName : String; ADuplicates : TDuplicates)');
    RegisterMethod('Procedure Clear');
      RegisterMethod('Procedure Free');
      RegisterProperty('AsString', 'String', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDictionary(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'INode', 'IDictionary') do
  with CL.AddInterface(CL.FindInterface('INode'),IDictionary, 'IDictionary') do
  begin
    RegisterMethod('Function GetItem( AKey : String) : INode', cdRegister);
    RegisterMethod('Function GetCount : Integer', cdRegister);
    RegisterMethod('Function GetDuplicates : TDuplicates', cdRegister);
    RegisterMethod('Function GetHashFunction : THashFunction', cdRegister);
    RegisterMethod('Procedure SetHashFunction( AValue : THashFunction)', cdRegister);
    RegisterMethod('Function GetAsNode : INode', cdRegister);
    RegisterMethod('Function GetAsString : String', cdRegister);
    RegisterMethod('Function GetSymbols : INode', cdRegister);
    RegisterMethod('Function GetItems : INode', cdRegister);
    RegisterMethod('Function Find( const AKey : String) : Boolean', cdRegister);
    RegisterMethod('Function Contains( const AKey : String) : Boolean', cdRegister);
    RegisterMethod('Function Add( AnItem : INode) : Boolean', cdRegister);
    RegisterMethod('Function Delete( const AKey : String) : Boolean', cdRegister);
    RegisterMethod('Function Extract( const AKey : String) : INode', cdRegister);
    RegisterMethod('Procedure ForEach( AIteratorFn : TDictionaryIterateProc);', cdRegister);
    RegisterMethod('Procedure ForEachEx( AIteratorFn : TDictionaryIterateProcEx; var AParam)', cdRegister);
    RegisterMethod('Procedure Clear', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_MaxDOMDictionary(CL: TPSPascalCompiler);
begin
//THashFunction = function(const S: String): Cardinal;
 CL.AddTypeS('THashFunction', 'function(const S: String): Cardinal;');

  SIRegister_IDictionary(CL);
  SIRegister_TDictionary(CL);
 CL.AddDelphiFunction('Function HashFast( const AKey : String) : Cardinal');
 CL.AddDelphiFunction('Function HashCarlos( const AKey : String) : Cardinal');
 CL.AddDelphiFunction('Function BorlandHashOf( const AKey : String) : Cardinal');
 CL.AddDelphiFunction('Function HashSumOfChars( const AKey : String) : Cardinal');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDictionaryAsString_R(Self: TDictionary; var T: String);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
Function TDictionaryHash2_P(Self: TDictionary;  ANode : INode) : Integer;
Begin //Result := Self.Hash(ANode);
END;

(*----------------------------------------------------------------------------*)
Function TDictionaryHash_P(Self: TDictionary;  const AKey : String) : Integer;
Begin //Result := Self.Hash(AKey);
END;

(*----------------------------------------------------------------------------*)
Procedure IDictionaryForEach_P(Self: IDictionary;  AIteratorFn : TDictionaryIterateProc);
Begin Self.ForEach(AIteratorFn); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MaxDOMDictionary_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@HashFast, 'HashFast', cdRegister);
 S.RegisterDelphiFunction(@HashCarlos, 'HashCarlos', cdRegister);
 S.RegisterDelphiFunction(@BorlandHashOf, 'BorlandHashOf', cdRegister);
 S.RegisterDelphiFunction(@HashSumOfChars, 'HashSumOfChars', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDictionary(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDictionary) do begin
    RegisterConstructor(@TDictionary.Create, 'Create');
        RegisterMethod(@TDictionary.Destroy, 'Free');
    RegisterMethod(@TDictionary.Clear, 'Clear');
    RegisterPropertyHelper(@TDictionaryAsString_R,nil,'AsString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MaxDOMDictionary(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDictionary(CL);
end;

 
 
{ TPSImport_MaxDOMDictionary }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MaxDOMDictionary.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MaxDOMDictionary(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MaxDOMDictionary.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_MaxDOMDictionary(ri);
  RIRegister_MaxDOMDictionary_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
