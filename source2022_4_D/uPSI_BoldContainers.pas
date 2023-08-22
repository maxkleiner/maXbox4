unit uPSI_BoldContainers;
{
  FIRST ORM of Delphi 
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
  TPSImport_BoldContainers = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TBoldIntegerArray(CL: TPSPascalCompiler);
procedure SIRegister_TBoldInterfaceArray(CL: TPSPascalCompiler);
procedure SIRegister_TBoldObjectArray(CL: TPSPascalCompiler);
procedure SIRegister_TBoldPointerArray(CL: TPSPascalCompiler);
procedure SIRegister_TBoldArray(CL: TPSPascalCompiler);
procedure SIRegister_TBoldContainer(CL: TPSPascalCompiler);
procedure SIRegister_BoldContainers(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TBoldIntegerArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBoldInterfaceArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBoldObjectArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBoldPointerArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBoldArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBoldContainer(CL: TPSRuntimeClassImporter);
procedure RIRegister_BoldContainers(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   BoldDefs
  ,BoldBase
  ,BoldContainers
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BoldContainers]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBoldIntegerArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBoldArray', 'TBoldIntegerArray') do
  with CL.AddClassN(CL.FindClass('TBoldArray'),'TBoldIntegerArray') do begin
    RegisterMethod('Function Add( const Item : integer) : Integer');
    RegisterMethod('Function IndexOf( const Item : integer) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; const Item : integer)');
    RegisterMethod('Function Remove( const Item : integer) : Integer');
    RegisterProperty('Items', 'integer Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBoldInterfaceArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBoldArray', 'TBoldInterfaceArray') do
 with CL.AddClassN(CL.FindClass('TBoldArray'),'TBoldInterfaceArray') do begin
    RegisterMethod('Function Add( const Item : IUnknown) : Integer');
    RegisterMethod('Function IndexOf( const Item : IUnknown) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; const Item : IUnknown)');
    RegisterMethod('Function Remove( const Item : IUnknown) : Integer');
    RegisterMethod('Function RemoveWithNil( const Item : IUnknown) : Integer');
    RegisterProperty('Items', 'IUnknown Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBoldObjectArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBoldArray', 'TBoldObjectArray') do
  with CL.AddClassN(CL.FindClass('TBoldArray'),'TBoldObjectArray') do begin
    RegisterMethod('Function Add( Item : TObject) : Integer');
    RegisterMethod('Function IndexOf( Item : TObject) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; Item : TObject)');
    RegisterMethod('Function Remove( Item : TObject) : Integer');
    RegisterMethod('Function RemoveWithNil( Item : TObject) : Integer');
    RegisterProperty('Items', 'TObject Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBoldPointerArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBoldArray', 'TBoldPointerArray') do
  with CL.AddClassN(CL.FindClass('TBoldArray'),'TBoldPointerArray') do begin
    RegisterMethod('Function Add( Item : TObject) : Integer');
    RegisterMethod('Function IndexOf( Item : TObject) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; Item : TObject)');
    RegisterMethod('Function Remove( Item : TObject) : Integer');
    RegisterMethod('Function RemoveWithNil( Item : TObject) : Integer');
    RegisterProperty('Items', 'TObject Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBoldArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBoldContainer', 'TBoldArray') do
  with CL.AddClassN(CL.FindClass('TBoldContainer'),'TBoldArray') do begin
    RegisterMethod('Constructor Create( InitialCapacity : Integer; Options : TBoldContainerOptions)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure DeleteRange( FromIndex, ToIndex : integer)');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Procedure Move( FromIndex, ToIndex : Integer)');
    RegisterMethod('Procedure Pack');
    RegisterMethod('Procedure Sort( Compare : TBoldArraySortCompare)');
    RegisterProperty('Capacity', 'Integer', iptrw);
    RegisterProperty('ItemSize', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBoldContainer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBoldNonRefCountedObject', 'TBoldContainer') do
  with CL.AddClassN(CL.FindClass('TBoldNonRefCountedObject'),'TBoldContainer') do begin
    RegisterMethod('Constructor Create( Options : TBoldContainerOptions)');
    RegisterMethod('Procedure Clear');
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterProperty('Options', 'TBoldContainerOptions', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_BoldContainers(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBoldContainer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBoldArray');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBoldPointerArray');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBoldObjectArray');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBoldInterfaceArray');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBoldIntegerArray');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EBoldContainerError');
  CL.AddTypeS('TBoldContainerOption', '( bcoDataOwner, bcoThreadSafe )');
  CL.AddTypeS('TBoldContainerOptions', 'set of TBoldContainerOption');
  //CL.AddTypeS('PByteArray', '^TByteArray // will not work');
  SIRegister_TBoldContainer(CL);
  SIRegister_TBoldArray(CL);
  SIRegister_TBoldPointerArray(CL);
  SIRegister_TBoldObjectArray(CL);
  SIRegister_TBoldInterfaceArray(CL);
  SIRegister_TBoldIntegerArray(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TBoldIntegerArrayItems_W(Self: TBoldIntegerArray; const T: integer; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TBoldIntegerArrayItems_R(Self: TBoldIntegerArray; var T: integer; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TBoldInterfaceArrayItems_W(Self: TBoldInterfaceArray; const T: IUnknown; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TBoldInterfaceArrayItems_R(Self: TBoldInterfaceArray; var T: IUnknown; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TBoldObjectArrayItems_W(Self: TBoldObjectArray; const T: TObject; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TBoldObjectArrayItems_R(Self: TBoldObjectArray; var T: TObject; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TBoldPointerArrayItems_W(Self: TBoldPointerArray; const T: Pointer; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TBoldPointerArrayItems_R(Self: TBoldPointerArray; var T: Pointer; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TBoldArrayItemSize_R(Self: TBoldArray; var T: Integer);
begin T := Self.ItemSize; end;

(*----------------------------------------------------------------------------*)
procedure TBoldArrayCapacity_W(Self: TBoldArray; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TBoldArrayCapacity_R(Self: TBoldArray; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
procedure TBoldContainerOptions_R(Self: TBoldContainer; var T: TBoldContainerOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TBoldContainerCount_W(Self: TBoldContainer; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TBoldContainerCount_R(Self: TBoldContainer; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBoldIntegerArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBoldIntegerArray) do begin
    RegisterMethod(@TBoldIntegerArray.Add, 'Add');
    RegisterMethod(@TBoldIntegerArray.IndexOf, 'IndexOf');
    RegisterMethod(@TBoldIntegerArray.Insert, 'Insert');
    RegisterMethod(@TBoldIntegerArray.Remove, 'Remove');
    RegisterPropertyHelper(@TBoldIntegerArrayItems_R,@TBoldIntegerArrayItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBoldInterfaceArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBoldInterfaceArray) do begin
    RegisterMethod(@TBoldInterfaceArray.Add, 'Add');
    RegisterMethod(@TBoldInterfaceArray.IndexOf, 'IndexOf');
    RegisterMethod(@TBoldInterfaceArray.Insert, 'Insert');
    RegisterMethod(@TBoldInterfaceArray.Remove, 'Remove');
    RegisterMethod(@TBoldInterfaceArray.RemoveWithNil, 'RemoveWithNil');
    RegisterPropertyHelper(@TBoldInterfaceArrayItems_R,@TBoldInterfaceArrayItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBoldObjectArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBoldObjectArray) do begin
    RegisterMethod(@TBoldObjectArray.Add, 'Add');
    RegisterMethod(@TBoldObjectArray.IndexOf, 'IndexOf');
    RegisterMethod(@TBoldObjectArray.Insert, 'Insert');
    RegisterMethod(@TBoldObjectArray.Remove, 'Remove');
    RegisterMethod(@TBoldObjectArray.RemoveWithNil, 'RemoveWithNil');
    RegisterPropertyHelper(@TBoldObjectArrayItems_R,@TBoldObjectArrayItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBoldPointerArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBoldPointerArray) do begin
    RegisterMethod(@TBoldPointerArray.Add, 'Add');
    RegisterMethod(@TBoldPointerArray.IndexOf, 'IndexOf');
    RegisterMethod(@TBoldPointerArray.Insert, 'Insert');
    RegisterMethod(@TBoldPointerArray.Remove, 'Remove');
    RegisterMethod(@TBoldPointerArray.RemoveWithNil, 'RemoveWithNil');
    RegisterPropertyHelper(@TBoldPointerArrayItems_R,@TBoldPointerArrayItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBoldArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBoldArray) do begin
    RegisterConstructor(@TBoldArray.Create, 'Create');
    RegisterMethod(@TBoldArray.Destroy, 'Free');
    RegisterMethod(@TBoldArray.Clear, 'Clear');
    RegisterMethod(@TBoldArray.Delete, 'Delete');
    RegisterMethod(@TBoldArray.DeleteRange, 'DeleteRange');
    RegisterMethod(@TBoldArray.Exchange, 'Exchange');
    RegisterMethod(@TBoldArray.Move, 'Move');
    RegisterMethod(@TBoldArray.Pack, 'Pack');
    RegisterMethod(@TBoldArray.Sort, 'Sort');
    RegisterPropertyHelper(@TBoldArrayCapacity_R,@TBoldArrayCapacity_W,'Capacity');
    RegisterPropertyHelper(@TBoldArrayItemSize_R,nil,'ItemSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBoldContainer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBoldContainer) do begin
    RegisterConstructor(@TBoldContainer.Create, 'Create');
    //RegisterVirtualAbstractMethod(@TBoldContainer, @!.Clear, 'Clear');
    RegisterPropertyHelper(@TBoldContainerCount_R,@TBoldContainerCount_W,'Count');
    RegisterPropertyHelper(@TBoldContainerOptions_R,nil,'Options');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BoldContainers(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBoldContainer) do
  with CL.Add(TBoldArray) do
  with CL.Add(TBoldPointerArray) do
  with CL.Add(TBoldObjectArray) do
  with CL.Add(TBoldInterfaceArray) do
  with CL.Add(TBoldIntegerArray) do
  with CL.Add(EBoldContainerError) do
  RIRegister_TBoldContainer(CL);
  RIRegister_TBoldArray(CL);
  RIRegister_TBoldPointerArray(CL);
  RIRegister_TBoldObjectArray(CL);
  RIRegister_TBoldInterfaceArray(CL);
  RIRegister_TBoldIntegerArray(CL);
end;

 
 
{ TPSImport_BoldContainers }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldContainers.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BoldContainers(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldContainers.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BoldContainers(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
