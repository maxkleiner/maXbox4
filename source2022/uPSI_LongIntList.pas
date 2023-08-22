unit uPSI_LongIntList;
{
  big data exprimador
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
  TPSImport_LongIntList = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TLongIntList(CL: TPSPascalCompiler);
procedure SIRegister_LongIntList(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TLongIntList(CL: TPSRuntimeClassImporter);
procedure RIRegister_LongIntList(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  { Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,Menus
  ,StdCtrls
  ,ExtCtrls }
  LongIntList
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_LongIntList]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TLongIntList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TLongIntList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TLongIntList') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Add( Item : LongInt) : Integer');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Function First : LongInt');
    RegisterMethod('Function IndexOf( Item : LongInt) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; Item : LongInt)');
    RegisterMethod('Function Last : LongInt');
    RegisterMethod('Procedure Move( CurIndex, NewIndex : Integer)');
    RegisterMethod('Function Remove( Item : LongInt) : Integer');
    RegisterMethod('Procedure Sort');
    RegisterMethod('Procedure DeleteGroup( StartIndex : LongInt; GroupCount : LongInt)');
    RegisterProperty('Capacity', 'Integer', iptrw);
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterProperty('Items', 'LongInt Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('LongIntList', 'LongIntArray', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_LongIntList(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PLongIntArray', '^TLongIntArray // will not work');
  SIRegister_TLongIntList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TLongIntListLongIntList_R(Self: TLongIntList; var T: PLongIntArray);
begin T := Self.LongIntList; end;

(*----------------------------------------------------------------------------*)
procedure TLongIntListItems_W(Self: TLongIntList; const T: LongInt; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TLongIntListItems_R(Self: TLongIntList; var T: LongInt; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLongIntListCount_W(Self: TLongIntList; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TLongIntListCount_R(Self: TLongIntList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TLongIntListCapacity_W(Self: TLongIntList; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TLongIntListCapacity_R(Self: TLongIntList; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLongIntList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLongIntList) do begin
    RegisterConstructor(@TLongIntList.Create, 'Create');
    RegisterMethod(@TLongIntList.Destroy, 'Free');
    RegisterMethod(@TLongIntList.Add, 'Add');
    RegisterMethod(@TLongIntList.Clear, 'Clear');
    RegisterMethod(@TLongIntList.Delete, 'Delete');
    RegisterMethod(@TLongIntList.Exchange, 'Exchange');
    RegisterMethod(@TLongIntList.First, 'First');
    RegisterMethod(@TLongIntList.IndexOf, 'IndexOf');
    RegisterMethod(@TLongIntList.Insert, 'Insert');
    RegisterMethod(@TLongIntList.Last, 'Last');
    RegisterMethod(@TLongIntList.Move, 'Move');
    RegisterMethod(@TLongIntList.Remove, 'Remove');
    RegisterMethod(@TLongIntList.Sort, 'Sort');
    RegisterMethod(@TLongIntList.DeleteGroup, 'DeleteGroup');
    RegisterPropertyHelper(@TLongIntListCapacity_R,@TLongIntListCapacity_W,'Capacity');
    RegisterPropertyHelper(@TLongIntListCount_R,@TLongIntListCount_W,'Count');
    RegisterPropertyHelper(@TLongIntListItems_R,@TLongIntListItems_W,'Items');
    RegisterPropertyHelper(@TLongIntListLongIntList_R,nil,'LongIntList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_LongIntList(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TLongIntList(CL);
end;

 
 
{ TPSImport_LongIntList }
(*----------------------------------------------------------------------------*)
procedure TPSImport_LongIntList.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_LongIntList(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_LongIntList.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_LongIntList(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
