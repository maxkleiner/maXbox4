unit uPSI_U_IntList;
{
 a secoxn list
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
  TPSImport_U_IntList = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIntList2(CL: TPSPascalCompiler);
procedure SIRegister_U_IntList2(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIntList2(CL: TPSRuntimeClassImporter);
procedure RIRegister_U_IntList2(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   SysConst
  ,U_IntList
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_U_IntList]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIntList2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TIntList') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TIntList2') do begin
    RegisterMethod('Function Add( const S : int64) : Integer');
    RegisterMethod('Function AddObject( const S : int64; AObject : TObject) : Integer');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Function Find( const S : int64; var Index : Integer) : Boolean');
    RegisterMethod('Function IndexOf( const S : int64) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; const S : int64)');
    RegisterMethod('Procedure Sort');
    RegisterMethod('Procedure CustomSort( Compare : TIntListSortCompare)');
    RegisterMethod('Procedure LoadFromFile( const FileName : string)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToFile( const FileName : string)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterProperty('Duplicates', 'TDuplicates', iptrw);
    RegisterProperty('Sorted', 'Boolean', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChanging', 'TNotifyEvent', iptrw);
    RegisterProperty('Integers', 'int64 Integer', iptrw);
    SetDefaultPropery('Integers');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Objects', 'TObject Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_U_IntList2(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('maxlistsize2','LongInt').SetInt( maxint div 32);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIntList2');
  //CL.AddTypeS('int64', 'integer');
  //CL.AddTypeS('PIntItem', '^TIntItem // will not work');
  CL.AddTypeS('TIntItem', 'record FInt : int64; FObject : TObject; end');
  //CL.AddTypeS('PIntItemList', '^TIntItemList // will not work');
  SIRegister_TIntList2(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIntListObjects_W(Self: TIntList2; const T: TObject; const t1: Integer);
begin Self.Objects[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntListObjects_R(Self: TIntList2; var T: TObject; const t1: Integer);
begin T := Self.Objects[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIntListCount_R(Self: TIntList2; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TIntListIntegers_W(Self: TIntList2; const T: int64; const t1: Integer);
begin Self.Integers[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntListIntegers_R(Self: TIntList2; var T: int64; const t1: Integer);
begin T := Self.Integers[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIntListOnChanging_W(Self: TIntList2; const T: TNotifyEvent);
begin Self.OnChanging := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntListOnChanging_R(Self: TIntList2; var T: TNotifyEvent);
begin T := Self.OnChanging; end;

(*----------------------------------------------------------------------------*)
procedure TIntListOnChange_W(Self: TIntList2; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntListOnChange_R(Self: TIntList2; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TIntListSorted_W(Self: TIntList2; const T: Boolean);
begin Self.Sorted := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntListSorted_R(Self: TIntList2; var T: Boolean);
begin T := Self.Sorted; end;

(*----------------------------------------------------------------------------*)
procedure TIntListDuplicates_W(Self: TIntList2; const T: TDuplicates);
begin Self.Duplicates := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntListDuplicates_R(Self: TIntList2; var T: TDuplicates);
begin T := Self.Duplicates; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIntList2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIntList2) do begin
    RegisterMethod(@TIntList2.Add, 'Add');
    RegisterVirtualMethod(@TIntList2.AddObject, 'AddObject');
    RegisterMethod(@TIntList2.Clear, 'Clear');
    RegisterMethod(@TIntList2.Destroy, 'Free');
    RegisterMethod(@TIntList2.Delete, 'Delete');
    RegisterMethod(@TIntList2.Exchange, 'Exchange');
    RegisterVirtualMethod(@TIntList2.Find, 'Find');
    RegisterMethod(@TIntList2.IndexOf, 'IndexOf');
    RegisterMethod(@TIntList2.Insert, 'Insert');
    RegisterVirtualMethod(@TIntList2.Sort, 'Sort');
    RegisterVirtualMethod(@TIntList2.CustomSort, 'CustomSort');
    RegisterVirtualMethod(@TIntList2.LoadFromFile, 'LoadFromFile');
    RegisterVirtualMethod(@TIntList2.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TIntList2.SaveToFile, 'SaveToFile');
    RegisterMethod(@TIntList2.SaveToStream, 'SaveToStream');
    RegisterPropertyHelper(@TIntListDuplicates_R,@TIntListDuplicates_W,'Duplicates');
    RegisterPropertyHelper(@TIntListSorted_R,@TIntListSorted_W,'Sorted');
    RegisterPropertyHelper(@TIntListOnChange_R,@TIntListOnChange_W,'OnChange');
    RegisterPropertyHelper(@TIntListOnChanging_R,@TIntListOnChanging_W,'OnChanging');
    RegisterPropertyHelper(@TIntListIntegers_R,@TIntListIntegers_W,'Integers');
    RegisterPropertyHelper(@TIntListCount_R,nil,'Count');
    RegisterPropertyHelper(@TIntListObjects_R,@TIntListObjects_W,'Objects');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_U_IntList2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIntList2) do
  RIRegister_TIntList2(CL);
end;

 
 
{ TPSImport_U_IntList }
(*----------------------------------------------------------------------------*)
procedure TPSImport_U_IntList.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_U_IntList2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_U_IntList.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_U_IntList2(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
