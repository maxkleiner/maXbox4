unit uPSI_Hashes;
{
  just a dictionary for python pascal   - to hash the trash
  renAME all to 2 thash --> thash2   free hash

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
  TPSImport_Hashes = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TObjectHash2(CL: TPSPascalCompiler);
procedure SIRegister_TIntegerHash2(CL: TPSPascalCompiler);
procedure SIRegister_TStringHash2(CL: TPSPascalCompiler);
procedure SIRegister_THash2(CL: TPSPascalCompiler);
procedure SIRegister_Hashes(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TObjectHash2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIntegerHash2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStringHash2(CL: TPSRuntimeClassImporter);
procedure RIRegister_THash2(CL: TPSRuntimeClassImporter);
procedure RIRegister_Hashes(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Hashes
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Hashes]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TObjectHash2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THash', 'TObjectHash') do
  with CL.AddClassN(CL.FindClass('THash2'),'TObjectHash2') do begin
    RegisterMethod('Procedure Free');
    RegisterProperty('Items', 'TObject string', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIntegerHash2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THash', 'TIntegerHash') do
  with CL.AddClassN(CL.FindClass('THash2'),'TIntegerHash2') do
  begin
    RegisterProperty('Items', 'integer string', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStringHash2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THash', 'TStringHash') do
  with CL.AddClassN(CL.FindClass('THash2'),'TStringHash2') do
  begin
    RegisterProperty('Items', 'string string', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THash2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THash') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THash2') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Exists( const Key : string) : boolean');
    RegisterMethod('Procedure Rename( const Key, NewName : string)');
    RegisterMethod('Procedure Delete( const Key : string)');
    RegisterMethod('Procedure Restart');
    RegisterMethod('Function Next : boolean');
    RegisterMethod('Function Previous : boolean');
    RegisterMethod('Function CurrentKey : string');
    RegisterProperty('ItemCount', 'integer', iptr);
    RegisterMethod('Procedure Compact');
    RegisterMethod('Procedure Clear');
    RegisterProperty('AllowCompact', 'boolean', iptrw);
    RegisterProperty('CurrentIterator', 'THashIterator', iptrw);
    RegisterMethod('Function NewIterator : THashIterator');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Hashes(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('c_HashInitialItemShift','LongInt').SetInt( 7);
 CL.AddConstantN('c_HashCompactR','LongInt').SetInt( 2);
 CL.AddConstantN('c_HashCompactM','LongInt').SetInt( 100);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EHashError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EHashFindError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EHashIterateError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EHashInvalidKeyError');
  CL.AddTypeS('THashRecord', 'record Hash : Cardinal; ItemIndex : integer; Key : string; end');
  CL.AddTypeS('THashIterator', 'record ck : integer; cx : integer; end');
  SIRegister_THash2(CL);
  SIRegister_TStringHash2(CL);
  SIRegister_TIntegerHash2(CL);
  SIRegister_TObjectHash2(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TObjectHashItems_W(Self: TObjectHash2; const T: TObject; const t1: string);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TObjectHashItems_R(Self: TObjectHash2; var T: TObject; const t1: string);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIntegerHashItems_W(Self: TIntegerHash2; const T: integer; const t1: string);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntegerHashItems_R(Self: TIntegerHash2; var T: integer; const t1: string);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStringHashItems_W(Self: TStringHash2; const T: string; const t1: string);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringHashItems_R(Self: TStringHash2; var T: string; const t1: string);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure THashCurrentIterator_W(Self: THash2; const T: THashIterator);
begin Self.CurrentIterator := T; end;

(*----------------------------------------------------------------------------*)
procedure THashCurrentIterator_R(Self: THash2; var T: THashIterator);
begin T := Self.CurrentIterator; end;

(*----------------------------------------------------------------------------*)
procedure THashAllowCompact_W(Self: THash2; const T: boolean);
begin Self.AllowCompact := T; end;

(*----------------------------------------------------------------------------*)
procedure THashAllowCompact_R(Self: THash2; var T: boolean);
begin T := Self.AllowCompact; end;

(*----------------------------------------------------------------------------*)
procedure THashItemCount_R(Self: THash2; var T: integer);
begin T := Self.ItemCount; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TObjectHash2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TObjectHash2) do begin
   RegisterMethod(@TObjectHash2.Destroy, 'Free');
   RegisterPropertyHelper(@TObjectHashItems_R,@TObjectHashItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIntegerHash2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIntegerHash2) do
  begin
    RegisterPropertyHelper(@TIntegerHashItems_R,@TIntegerHashItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStringHash2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStringHash2) do
  begin
    RegisterPropertyHelper(@TStringHashItems_R,@TStringHashItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THash2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THash2) do begin
    RegisterConstructor(@THash2.Create, 'Create');
    RegisterMethod(@THash2.Destroy, 'Free');
    RegisterMethod(@THash2.Exists, 'Exists');
    RegisterMethod(@THash2.Rename, 'Rename');
    RegisterMethod(@THash2.Delete, 'Delete');
    RegisterMethod(@THash2.Restart, 'Restart');
    RegisterMethod(@THash2.Next, 'Next');
    RegisterMethod(@THash2.Previous, 'Previous');
    RegisterMethod(@THash2.CurrentKey, 'CurrentKey');
    RegisterPropertyHelper(@THashItemCount_R,nil,'ItemCount');
    RegisterMethod(@THash2.Compact, 'Compact');
    RegisterMethod(@THash2.Clear, 'Clear');
    RegisterPropertyHelper(@THashAllowCompact_R,@THashAllowCompact_W,'AllowCompact');
    RegisterPropertyHelper(@THashCurrentIterator_R,@THashCurrentIterator_W,'CurrentIterator');
    RegisterMethod(@THash2.NewIterator, 'NewIterator');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Hashes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EHashError) do
  with CL.Add(EHashFindError) do
  with CL.Add(EHashIterateError) do
  with CL.Add(EHashInvalidKeyError) do
  RIRegister_THash2(CL);
  RIRegister_TStringHash2(CL);
  RIRegister_TIntegerHash2(CL);
  RIRegister_TObjectHash2(CL);
end;

 
 
{ TPSImport_Hashes }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Hashes.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Hashes(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Hashes.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Hashes(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
