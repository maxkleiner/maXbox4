unit uPSI_StList;
{
  unit 668
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
  TPSImport_StList = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStList(CL: TPSPascalCompiler);
procedure SIRegister_TStListNode(CL: TPSPascalCompiler);
procedure SIRegister_StList(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStListNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_StList(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StConst
  ,StBase
  ,StList
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StList]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStContainer', 'TStList') do
  with CL.AddClassN(CL.FindClass('TStContainer'),'TStList') do begin
    RegisterMethod('Constructor Create( NodeClass : TStNodeClass)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure LoadFromStream( S : TStream)');
    RegisterMethod('Procedure StoreToStream( S : TStream)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Append( Data : Pointer) : TStListNode');
    RegisterMethod('Function Insert( Data : Pointer) : TStListNode');
    RegisterMethod('Function Place( Data : Pointer; P : TStListNode) : TStListNode');
    RegisterMethod('Function PlaceBefore( Data : Pointer; P : TStListNode) : TStListNode');
    RegisterMethod('Function InsertSorted( Data : Pointer) : TStListNode');
    RegisterMethod('Procedure MoveToHead( P : TStListNode)');
    RegisterMethod('Procedure Join( P : TStListNode; L : TStList)');
    RegisterMethod('Function Split( P : TStListNode) : TStList');
    RegisterMethod('Procedure Sort');
    RegisterMethod('Procedure Delete( P : TStListNode)');
    RegisterMethod('Function Next( P : TStListNode) : TStListNode');
    RegisterMethod('Function Prev( P : TStListNode) : TStListNode');
    RegisterMethod('Function Nth( Index : LongInt) : TStListNode');
    RegisterMethod('Function NthFrom( P : TStListNode; Index : LongInt) : TStListNode');
    RegisterMethod('Function Posn( P : TStListNode) : LongInt');
    RegisterMethod('Function Distance( P1, P2 : TStListNode) : LongInt');
    RegisterMethod('Function Find( Data : Pointer) : TStListNode');
    RegisterMethod('Function Iterate( Action : TIterateFunc; Up : Boolean; OtherData : Pointer) : TStListNode');
    RegisterProperty('Head', 'TStListNode', iptr);
    RegisterProperty('Tail', 'TStListNode', iptr);
    RegisterProperty('Items', 'TStListNode LongInt', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStListNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStNode', 'TStListNode') do
  with CL.AddClassN(CL.FindClass('TStNode'),'TStListNode') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StList(CL: TPSPascalCompiler);
begin
  SIRegister_TStListNode(CL);
  SIRegister_TStList(CL);
  //CL.AddTypeS('TStListClass', 'class of TStList');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStListItems_R(Self: TStList; var T: TStListNode; const t1: LongInt);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStListTail_R(Self: TStList; var T: TStListNode);
begin T := Self.Tail; end;

(*----------------------------------------------------------------------------*)
procedure TStListHead_R(Self: TStList; var T: TStListNode);
begin T := Self.Head; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStList) do begin
    RegisterVirtualConstructor(@TStList.Create, 'Create');
    RegisterMethod(@TStList.Destroy, 'Free');
    RegisterMethod(@TStList.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TStList.StoreToStream, 'StoreToStream');
    RegisterMethod(@TStList.Clear, 'Clear');
    RegisterMethod(@TStList.Append, 'Append');
    RegisterMethod(@TStList.Insert, 'Insert');
    RegisterMethod(@TStList.Place, 'Place');
    RegisterMethod(@TStList.PlaceBefore, 'PlaceBefore');
    RegisterMethod(@TStList.InsertSorted, 'InsertSorted');
    RegisterMethod(@TStList.MoveToHead, 'MoveToHead');
    RegisterMethod(@TStList.Join, 'Join');
    RegisterMethod(@TStList.Split, 'Split');
    RegisterMethod(@TStList.Sort, 'Sort');
    RegisterMethod(@TStList.Delete, 'Delete');
    RegisterMethod(@TStList.Next, 'Next');
    RegisterMethod(@TStList.Prev, 'Prev');
    RegisterMethod(@TStList.Nth, 'Nth');
    RegisterMethod(@TStList.NthFrom, 'NthFrom');
    RegisterMethod(@TStList.Posn, 'Posn');
    RegisterMethod(@TStList.Distance, 'Distance');
    RegisterMethod(@TStList.Find, 'Find');
    RegisterMethod(@TStList.Iterate, 'Iterate');
    RegisterPropertyHelper(@TStListHead_R,nil,'Head');
    RegisterPropertyHelper(@TStListTail_R,nil,'Tail');
    RegisterPropertyHelper(@TStListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStListNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStListNode) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StList(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStListNode(CL);
  RIRegister_TStList(CL);
end;

 
 
{ TPSImport_StList }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StList.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StList(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StList.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StList(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
