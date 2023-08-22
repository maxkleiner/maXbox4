unit uPSI_cyVirtualGrid;
{
   a grid to set
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
  TPSImport_cyVirtualGrid = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyVirtualGrid(CL: TPSPascalCompiler);
procedure SIRegister_cyVirtualGrid(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TcyVirtualGrid(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyVirtualGrid(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ExtCtrls
  ,Controls
  ,Messages
  ,Types
  ,cyVirtualGrid
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyVirtualGrid]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyVirtualGrid(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TcyVirtualGrid') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TcyVirtualGrid') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure GenerateCells( fromRect : TRect)');
    RegisterMethod('Function ColumnWidth( CoordX : Integer) : Integer');
    RegisterMethod('Function RowHeight( CoordY : Integer) : Integer');
    RegisterMethod('Function GetCellRect( CoordX, CoordY : Integer) : TRect');
    RegisterMethod('Function GetCellCoord( X, Y : Integer; var CoordX, CoordY : Integer) : Boolean');
    RegisterProperty('ValidCells', 'Boolean', iptr);
    RegisterProperty('CellWidth', 'Word', iptrw);
    RegisterProperty('CellHeight', 'Word', iptrw);
    RegisterProperty('CellWidthMode', 'TSizeMode', iptrw);
    RegisterProperty('CellHeightMode', 'TSizeMode', iptrw);
    RegisterProperty('FromCoordX', 'Integer', iptrw);
    RegisterProperty('ToCoordX', 'Integer', iptrw);
    RegisterProperty('FromCoordY', 'Integer', iptrw);
    RegisterProperty('ToCoordY', 'Integer', iptrw);
    RegisterProperty('OnRowSize', 'TProcRowSize', iptrw);
    RegisterProperty('OnColumnSize', 'TProcColumnSize', iptrw);
    RegisterProperty('OnGeneratedCell', 'TProcGeneratedCell', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyVirtualGrid(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TSizeMode', '( smManual, smAutoFixed, smAutoStretched )');
  CL.AddTypeS('TProcGeneratedCell','Procedure( Sender : TObject; Rect : TRect; CoordX, CoordY : Integer)');
  CL.AddTypeS('TProcRowSize', 'Procedure ( Sender : TObject; CoordY : Integer; var Size : Word)');
  CL.AddTypeS('TProcColumnSize', 'Procedure ( Sender : TObject; CoordX : Integer; var Size : Word)');
  SIRegister_TcyVirtualGrid(CL);
 CL.AddConstantN('MsgInvalidCells','String').SetString( 'Invalid generated cells!');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridOnGeneratedCell_W(Self: TcyVirtualGrid; const T: TProcGeneratedCell);
begin Self.OnGeneratedCell := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridOnGeneratedCell_R(Self: TcyVirtualGrid; var T: TProcGeneratedCell);
begin T := Self.OnGeneratedCell; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridOnColumnSize_W(Self: TcyVirtualGrid; const T: TProcColumnSize);
begin Self.OnColumnSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridOnColumnSize_R(Self: TcyVirtualGrid; var T: TProcColumnSize);
begin T := Self.OnColumnSize; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridOnRowSize_W(Self: TcyVirtualGrid; const T: TProcRowSize);
begin Self.OnRowSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridOnRowSize_R(Self: TcyVirtualGrid; var T: TProcRowSize);
begin T := Self.OnRowSize; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridToCoordY_W(Self: TcyVirtualGrid; const T: Integer);
begin Self.ToCoordY := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridToCoordY_R(Self: TcyVirtualGrid; var T: Integer);
begin T := Self.ToCoordY; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridFromCoordY_W(Self: TcyVirtualGrid; const T: Integer);
begin Self.FromCoordY := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridFromCoordY_R(Self: TcyVirtualGrid; var T: Integer);
begin T := Self.FromCoordY; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridToCoordX_W(Self: TcyVirtualGrid; const T: Integer);
begin Self.ToCoordX := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridToCoordX_R(Self: TcyVirtualGrid; var T: Integer);
begin T := Self.ToCoordX; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridFromCoordX_W(Self: TcyVirtualGrid; const T: Integer);
begin Self.FromCoordX := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridFromCoordX_R(Self: TcyVirtualGrid; var T: Integer);
begin T := Self.FromCoordX; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridCellHeightMode_W(Self: TcyVirtualGrid; const T: TSizeMode);
begin Self.CellHeightMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridCellHeightMode_R(Self: TcyVirtualGrid; var T: TSizeMode);
begin T := Self.CellHeightMode; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridCellWidthMode_W(Self: TcyVirtualGrid; const T: TSizeMode);
begin Self.CellWidthMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridCellWidthMode_R(Self: TcyVirtualGrid; var T: TSizeMode);
begin T := Self.CellWidthMode; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridCellHeight_W(Self: TcyVirtualGrid; const T: Word);
begin Self.CellHeight := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridCellHeight_R(Self: TcyVirtualGrid; var T: Word);
begin T := Self.CellHeight; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridCellWidth_W(Self: TcyVirtualGrid; const T: Word);
begin Self.CellWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridCellWidth_R(Self: TcyVirtualGrid; var T: Word);
begin T := Self.CellWidth; end;

(*----------------------------------------------------------------------------*)
procedure TcyVirtualGridValidCells_R(Self: TcyVirtualGrid; var T: Boolean);
begin T := Self.ValidCells; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyVirtualGrid(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyVirtualGrid) do
  begin
    RegisterConstructor(@TcyVirtualGrid.Create, 'Create');
    RegisterMethod(@TcyVirtualGrid.GenerateCells, 'GenerateCells');
    RegisterMethod(@TcyVirtualGrid.ColumnWidth, 'ColumnWidth');
    RegisterMethod(@TcyVirtualGrid.RowHeight, 'RowHeight');
    RegisterMethod(@TcyVirtualGrid.GetCellRect, 'GetCellRect');
    RegisterMethod(@TcyVirtualGrid.GetCellCoord, 'GetCellCoord');
    RegisterPropertyHelper(@TcyVirtualGridValidCells_R,nil,'ValidCells');
    RegisterPropertyHelper(@TcyVirtualGridCellWidth_R,@TcyVirtualGridCellWidth_W,'CellWidth');
    RegisterPropertyHelper(@TcyVirtualGridCellHeight_R,@TcyVirtualGridCellHeight_W,'CellHeight');
    RegisterPropertyHelper(@TcyVirtualGridCellWidthMode_R,@TcyVirtualGridCellWidthMode_W,'CellWidthMode');
    RegisterPropertyHelper(@TcyVirtualGridCellHeightMode_R,@TcyVirtualGridCellHeightMode_W,'CellHeightMode');
    RegisterPropertyHelper(@TcyVirtualGridFromCoordX_R,@TcyVirtualGridFromCoordX_W,'FromCoordX');
    RegisterPropertyHelper(@TcyVirtualGridToCoordX_R,@TcyVirtualGridToCoordX_W,'ToCoordX');
    RegisterPropertyHelper(@TcyVirtualGridFromCoordY_R,@TcyVirtualGridFromCoordY_W,'FromCoordY');
    RegisterPropertyHelper(@TcyVirtualGridToCoordY_R,@TcyVirtualGridToCoordY_W,'ToCoordY');
    RegisterPropertyHelper(@TcyVirtualGridOnRowSize_R,@TcyVirtualGridOnRowSize_W,'OnRowSize');
    RegisterPropertyHelper(@TcyVirtualGridOnColumnSize_R,@TcyVirtualGridOnColumnSize_W,'OnColumnSize');
    RegisterPropertyHelper(@TcyVirtualGridOnGeneratedCell_R,@TcyVirtualGridOnGeneratedCell_W,'OnGeneratedCell');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyVirtualGrid(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TcyVirtualGrid(CL);
end;

 
 
{ TPSImport_cyVirtualGrid }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyVirtualGrid.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyVirtualGrid(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyVirtualGrid.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyVirtualGrid(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
