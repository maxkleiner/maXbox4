unit uPSI_cyBaseColorMatrix;
{
   base color
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
  TPSImport_cyBaseColorMatrix = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyBaseColorMatrix(CL: TPSPascalCompiler);
procedure SIRegister_cyBaseColorMatrix(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TcyBaseColorMatrix(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyBaseColorMatrix(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Types
  ,Controls
  ,Graphics
  ,Messages
  ,ExtCtrls
  ,cyTypes
  ,cyClasses
  ,cyGraphics
  ,cyBaseColorMatrix
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyBaseColorMatrix]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyBaseColorMatrix(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TcyBaseColorMatrix') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TcyBaseColorMatrix') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
        RegisterMethod('Procedure Free');
     RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Procedure EndUpdate');
    RegisterMethod('Procedure DrawText( aText : String; fromRow, fromCol, toRow, toCol : Integer; TextFormat : LongInt)');
    RegisterMethod('Procedure DrawCanvas( StartRow, StartColumn : Integer; Canvas : TCanvas; CanvasRect : TRect; TransparentColor : TColor; Transparent : Boolean)');
    RegisterMethod('Procedure DrawGraphic( StartRow, StartColumn : Integer; Graphic : TGraphic; TransparentColor : TColor; Transparent : Boolean)');
    RegisterMethod('Procedure LoadFromGraphic( aGraphic : TGraphic)');
    RegisterMethod('Procedure SaveToBitmap( Bitmap : TBitmap)');
    RegisterMethod('Function FindCellColor( fromRow, toRow, fromCol, toCol : Integer; aColor : TColor; var aRow : Integer; var aCol : Integer) : Boolean');
    RegisterMethod('Function GetCellAtPos( aPoint : TPoint; var aRow : Integer; var aCol : Integer; ExactPos : Boolean) : Boolean');
    RegisterMethod('Function GetColumnPosition( aCol : Integer) : Integer');
    RegisterMethod('Function GetRowPosition( aRow : Integer) : Integer');
    RegisterMethod('Function GetColorGrid( aRow : Integer; aCol : integer) : TColor');
    RegisterMethod('Procedure DrawCell( CellRect : TRect; CellColor : TColor; Row, Column : Integer; CustomDrawCell : Boolean)');
    RegisterMethod('Procedure DefaultDrawCell( aRect : TRect; aRow, aCol : integer; aColor : TColor)');
    RegisterMethod('Procedure ReplaceColor( old, New : TColor)');
    RegisterMethod('Procedure SetColorGrid( aRow : Integer; aCol : integer; withColor : TColor)');
    RegisterMethod('Procedure SetColorGridRange( fromRow, toRow, fromCol, toCol : Integer; withColor : TColor)');
    RegisterMethod('Function RowToValue( Row : Integer) : Double');
    RegisterMethod('Function ValueToRow( Value : Double) : Integer');
    RegisterMethod('Function ColumnToValue( Column : Integer) : Double');
    RegisterMethod('Function ValueToColumn( Value : Double) : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyBaseColorMatrix(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TRGBQuadArray', 'Array[0..0] of TRGBQuad;'); //, '^TRGBQuadArray // will not work');
  CL.AddTypeS('TProcOnDrawCell', 'Procedure ( Sender: TObject; aRect : TRect; aRow:integer; aCol: integer; aColor : TColor)');
  CL.AddTypeS('TProcOnCellClick', 'Procedure ( Sender : TObject; aRow : integer'
   +'; aCol : integer; aColor : TColor)');
  SIRegister_TcyBaseColorMatrix(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyBaseColorMatrix(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyBaseColorMatrix) do begin
    RegisterConstructor(@TcyBaseColorMatrix.Create, 'Create');
    RegisterMethod(@TcyBaseColorMatrix.Destroy, 'Free');
    RegisterMethod(@TcyBaseColorMatrix.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TcyBaseColorMatrix.EndUpdate, 'EndUpdate');
    RegisterMethod(@TcyBaseColorMatrix.DrawText, 'DrawText');
    RegisterMethod(@TcyBaseColorMatrix.DrawCanvas, 'DrawCanvas');
    RegisterMethod(@TcyBaseColorMatrix.DrawGraphic, 'DrawGraphic');
    RegisterMethod(@TcyBaseColorMatrix.LoadFromGraphic, 'LoadFromGraphic');
    RegisterMethod(@TcyBaseColorMatrix.SaveToBitmap, 'SaveToBitmap');
    RegisterMethod(@TcyBaseColorMatrix.FindCellColor, 'FindCellColor');
    RegisterMethod(@TcyBaseColorMatrix.GetCellAtPos, 'GetCellAtPos');
    RegisterMethod(@TcyBaseColorMatrix.GetColumnPosition, 'GetColumnPosition');
    RegisterMethod(@TcyBaseColorMatrix.GetRowPosition, 'GetRowPosition');
    RegisterVirtualMethod(@TcyBaseColorMatrix.GetColorGrid, 'GetColorGrid');
    RegisterMethod(@TcyBaseColorMatrix.DrawCell, 'DrawCell');
    RegisterMethod(@TcyBaseColorMatrix.DefaultDrawCell, 'DefaultDrawCell');
    RegisterVirtualMethod(@TcyBaseColorMatrix.ReplaceColor, 'ReplaceColor');
    RegisterMethod(@TcyBaseColorMatrix.SetColorGrid, 'SetColorGrid');
    RegisterMethod(@TcyBaseColorMatrix.SetColorGridRange, 'SetColorGridRange');
    RegisterMethod(@TcyBaseColorMatrix.RowToValue, 'RowToValue');
    RegisterMethod(@TcyBaseColorMatrix.ValueToRow, 'ValueToRow');
    RegisterMethod(@TcyBaseColorMatrix.ColumnToValue, 'ColumnToValue');
    RegisterMethod(@TcyBaseColorMatrix.ValueToColumn, 'ValueToColumn');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyBaseColorMatrix(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TcyBaseColorMatrix(CL);
end;

 
 
{ TPSImport_cyBaseColorMatrix }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyBaseColorMatrix.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyBaseColorMatrix(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyBaseColorMatrix.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyBaseColorMatrix(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
