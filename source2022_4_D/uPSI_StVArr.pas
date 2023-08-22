unit uPSI_StVArr;
{
   matrixx   add free asign
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
  TPSImport_StVArr = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStVMatrix(CL: TPSPascalCompiler);
procedure SIRegister_StVArr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStVMatrix(CL: TPSRuntimeClassImporter);
procedure RIRegister_StVArr(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StConst
  ,StBase
  ,StUtils
  ,StVArr
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StVArr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStVMatrix(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStContainer', 'TStVMatrix') do
  with CL.AddClassN(CL.FindClass('TStContainer'),'TStVMatrix') do begin
    RegisterMethod('Constructor Create( Rows, Cols, ElementSize : Cardinal; CacheRows : Integer; const DataFile : string; OpenMode : Word)');
    RegisterMethod('Procedure FlushCache');
      RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Clear');
      RegisterMethod('Function HeaderSize : LongInt');
    RegisterMethod('Procedure WriteHeader');
    RegisterMethod('Procedure ReadHeader');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Fill( const Value)');
    RegisterMethod('Procedure Put( Row, Col : Cardinal; const Value)');
    RegisterMethod('Procedure Get( Row, Col : Cardinal; var Value)');
    RegisterMethod('Procedure PutRow( Row : Cardinal; const RowValue)');
    RegisterMethod('Procedure GetRow( Row : Cardinal; var RowValue)');
    RegisterMethod('Procedure ExchangeRows( Row1, Row2 : Cardinal)');
    RegisterMethod('Procedure SortRows( KeyCol : Cardinal; Compare : TUntypedCompareFunc)');
    RegisterProperty('Rows', 'Cardinal', iptrw);
    RegisterProperty('CacheRows', 'Integer', iptrw);
    RegisterProperty('Cols', 'Cardinal', iptr);
    RegisterProperty('ElementSize', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StVArr(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TStCacheRec', 'record crRow : Cardinal; crRowData : ___Pointer; crT'
   +'ime : LongInt; crDirty : Integer; end');
  //CL.AddTypeS('PStCacheArray', '^TStCacheArray // will not work');
  SIRegister_TStVMatrix(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStVMatrixElementSize_R(Self: TStVMatrix; var T: Integer);
begin T := Self.ElementSize; end;

(*----------------------------------------------------------------------------*)
procedure TStVMatrixCols_R(Self: TStVMatrix; var T: Cardinal);
begin T := Self.Cols; end;

(*----------------------------------------------------------------------------*)
procedure TStVMatrixCacheRows_W(Self: TStVMatrix; const T: Integer);
begin Self.CacheRows := T; end;

(*----------------------------------------------------------------------------*)
procedure TStVMatrixCacheRows_R(Self: TStVMatrix; var T: Integer);
begin T := Self.CacheRows; end;

(*----------------------------------------------------------------------------*)
procedure TStVMatrixRows_W(Self: TStVMatrix; const T: Cardinal);
begin Self.Rows := T; end;

(*----------------------------------------------------------------------------*)
procedure TStVMatrixRows_R(Self: TStVMatrix; var T: Cardinal);
begin T := Self.Rows; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStVMatrix(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStVMatrix) do begin
    RegisterConstructor(@TStVMatrix.Create, 'Create');
     RegisterMethod(@TStVMatrix.Destroy, 'Free');
    RegisterMethod(@TStVMatrix.Assign, 'Assign');
    RegisterMethod(@TStVMatrix.Clear, 'Clear');
     RegisterMethod(@TStVMatrix.FlushCache, 'FlushCache');
    RegisterVirtualMethod(@TStVMatrix.HeaderSize, 'HeaderSize');
    RegisterVirtualMethod(@TStVMatrix.WriteHeader, 'WriteHeader');
    RegisterVirtualMethod(@TStVMatrix.ReadHeader, 'ReadHeader');
    RegisterMethod(@TStVMatrix.Assign, 'Assign');
    RegisterMethod(@TStVMatrix.Clear, 'Clear');
    RegisterMethod(@TStVMatrix.Fill, 'Fill');
    RegisterMethod(@TStVMatrix.Put, 'Put');
    RegisterMethod(@TStVMatrix.Get, 'Get');
    RegisterMethod(@TStVMatrix.PutRow, 'PutRow');
    RegisterMethod(@TStVMatrix.GetRow, 'GetRow');
    RegisterMethod(@TStVMatrix.ExchangeRows, 'ExchangeRows');
    RegisterMethod(@TStVMatrix.SortRows, 'SortRows');
    RegisterPropertyHelper(@TStVMatrixRows_R,@TStVMatrixRows_W,'Rows');
    RegisterPropertyHelper(@TStVMatrixCacheRows_R,@TStVMatrixCacheRows_W,'CacheRows');
    RegisterPropertyHelper(@TStVMatrixCols_R,nil,'Cols');
    RegisterPropertyHelper(@TStVMatrixElementSize_R,nil,'ElementSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StVArr(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStVMatrix(CL);
end;

 
 
{ TPSImport_StVArr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StVArr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StVArr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StVArr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StVArr(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
