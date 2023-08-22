unit uPSI_StLArr;
{
  matrix functions!
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
  TPSImport_StLArr = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStLMatrix(CL: TPSPascalCompiler);
procedure SIRegister_TStLArray(CL: TPSPascalCompiler);
procedure SIRegister_StLArr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStLMatrix(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStLArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_StLArr(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StConst
  ,StBase
  ,StLArr
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StLArr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStLMatrix(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStContainer', 'TStLMatrix') do
  with CL.AddClassN(CL.FindClass('TStContainer'),'TStLMatrix') do begin
    RegisterMethod('Constructor Create( Rows, Cols, ElementSize : Cardinal)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure LoadFromStream( S : TStream)');
    RegisterMethod('Procedure StoreToStream( S : TStream)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Fill( const Value : integer)');
    RegisterMethod('Procedure Put( Row, Col : Cardinal; const Value : integer)');
    RegisterMethod('Procedure Get( Row, Col : Cardinal; var Value : integer)');
    RegisterMethod('Procedure PutRow( Row : Cardinal; const RowValue)');
    RegisterMethod('Procedure GetRow( Row : Cardinal; var RowValue)');
    RegisterMethod('Procedure ExchangeRows( Row1, Row2 : Cardinal)');
    RegisterMethod('Procedure SortRows( KeyCol : Cardinal; Compare : TUntypedCompareFunc)');
    RegisterProperty('Rows', 'Cardinal', iptrw);
    RegisterProperty('Cols', 'Cardinal', iptrw);
    RegisterProperty('ElementSize', 'Integer', iptr);
    RegisterProperty('ElementsStorable', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStLArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStContainer', 'TStLArray') do
  with CL.AddClassN(CL.FindClass('TStContainer'),'TStLArray') do begin
    RegisterMethod('Constructor Create( Elements : LongInt; ElementSize : Cardinal)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure LoadFromStream( S : TStream)');
    RegisterMethod('Procedure StoreToStream( S : TStream)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Clear');
     RegisterMethod('Procedure Fill( const Value : integer)');
    RegisterMethod('Procedure Put( El : LongInt; const Value : integer)');
    RegisterMethod('Procedure Get( El : LongInt; var Value : integer)');
    RegisterMethod('Procedure Exchange( El1, El2 : LongInt)');
    RegisterMethod('Procedure Sort( Compare : TUntypedCompareFunc)');
    RegisterProperty('Count', 'LongInt', iptrw);
    RegisterProperty('ElementSize', 'Integer', iptr);
    RegisterProperty('ElementsStorable', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StLArr(CL: TPSPascalCompiler);
begin
  SIRegister_TStLArray(CL);
  SIRegister_TStLMatrix(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStLMatrixElementsStorable_W(Self: TStLMatrix; const T: boolean);
begin Self.ElementsStorable := T; end;

(*----------------------------------------------------------------------------*)
procedure TStLMatrixElementsStorable_R(Self: TStLMatrix; var T: boolean);
begin T := Self.ElementsStorable; end;

(*----------------------------------------------------------------------------*)
procedure TStLMatrixElementSize_R(Self: TStLMatrix; var T: Integer);
begin T := Self.ElementSize; end;

(*----------------------------------------------------------------------------*)
procedure TStLMatrixCols_W(Self: TStLMatrix; const T: Cardinal);
begin Self.Cols := T; end;

(*----------------------------------------------------------------------------*)
procedure TStLMatrixCols_R(Self: TStLMatrix; var T: Cardinal);
begin T := Self.Cols; end;

(*----------------------------------------------------------------------------*)
procedure TStLMatrixRows_W(Self: TStLMatrix; const T: Cardinal);
begin Self.Rows := T; end;

(*----------------------------------------------------------------------------*)
procedure TStLMatrixRows_R(Self: TStLMatrix; var T: Cardinal);
begin T := Self.Rows; end;

(*----------------------------------------------------------------------------*)
procedure TStLArrayElementsStorable_W(Self: TStLArray; const T: boolean);
begin Self.ElementsStorable := T; end;

(*----------------------------------------------------------------------------*)
procedure TStLArrayElementsStorable_R(Self: TStLArray; var T: boolean);
begin T := Self.ElementsStorable; end;

(*----------------------------------------------------------------------------*)
procedure TStLArrayElementSize_R(Self: TStLArray; var T: Integer);
begin T := Self.ElementSize; end;

(*----------------------------------------------------------------------------*)
procedure TStLArrayCount_W(Self: TStLArray; const T: LongInt);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TStLArrayCount_R(Self: TStLArray; var T: LongInt);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStLMatrix(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStLMatrix) do begin
    RegisterConstructor(@TStLMatrix.Create, 'Create');
    RegisterMethod(@TStLMatrix.Destroy, 'Free');
    RegisterMethod(@TStLMatrix.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TStLMatrix.StoreToStream, 'StoreToStream');
    RegisterMethod(@TStLMatrix.Assign, 'Assign');
    RegisterMethod(@TStLMatrix.Clear, 'Clear');
    RegisterMethod(@TStLMatrix.Fill, 'Fill');
    RegisterMethod(@TStLMatrix.Put, 'Put');
    RegisterMethod(@TStLMatrix.Get, 'Get');
    RegisterMethod(@TStLMatrix.PutRow, 'PutRow');
    RegisterMethod(@TStLMatrix.GetRow, 'GetRow');
    RegisterMethod(@TStLMatrix.ExchangeRows, 'ExchangeRows');
    RegisterMethod(@TStLMatrix.SortRows, 'SortRows');
    RegisterPropertyHelper(@TStLMatrixRows_R,@TStLMatrixRows_W,'Rows');
    RegisterPropertyHelper(@TStLMatrixCols_R,@TStLMatrixCols_W,'Cols');
    RegisterPropertyHelper(@TStLMatrixElementSize_R,nil,'ElementSize');
    RegisterPropertyHelper(@TStLMatrixElementsStorable_R,@TStLMatrixElementsStorable_W,'ElementsStorable');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStLArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStLArray) do begin
    RegisterConstructor(@TStLArray.Create, 'Create');
    RegisterMethod(@TStLMatrix.Destroy, 'Free');
    RegisterMethod(@TStLArray.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TStLArray.StoreToStream, 'StoreToStream');
    RegisterMethod(@TStLArray.Assign, 'Assign');
    RegisterMethod(@TStLArray.Clear, 'Clear');
     RegisterMethod(@TStLArray.Fill, 'Fill');
    RegisterMethod(@TStLArray.Put, 'Put');
    RegisterMethod(@TStLArray.Get, 'Get');
    RegisterMethod(@TStLArray.Exchange, 'Exchange');
    RegisterMethod(@TStLArray.Sort, 'Sort');
    RegisterPropertyHelper(@TStLArrayCount_R,@TStLArrayCount_W,'Count');
    RegisterPropertyHelper(@TStLArrayElementSize_R,nil,'ElementSize');
    RegisterPropertyHelper(@TStLArrayElementsStorable_R,@TStLArrayElementsStorable_W,'ElementsStorable');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StLArr(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStLArray(CL);
  RIRegister_TStLMatrix(CL);
end;

 
 
{ TPSImport_StLArr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StLArr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StLArr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StLArr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StLArr(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
