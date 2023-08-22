unit uPSC_Grids;
{
code implementing the class wrapper is taken from Carlo Kok's conv utility
   canvas and parent and more properties in    mX3.1  EditorMode   , setfocus
   add invalidate  check rows   bidimode   - mousetocell, cellrect stringgrid
}
interface
Uses uPSCompiler;

procedure SIRegister_TInplaceEditList(CL: TPSPascalCompiler);
procedure SIRegister_TStringGridStrings(CL: TPSPascalCompiler);
procedure SIRegister_TCustomGrid(CL: TPSPascalCompiler);
procedure SIRegister_TCustomDrawGrid(CL: TPSPascalCompiler);
procedure SIRegister_TDrawGrid(CL: TPSPascalCompiler);
procedure SIRegister_TStringGrid(CL: TPSPascalCompiler);

procedure SIRegister_TInplaceEdit(CL: TPSPascalCompiler);
procedure SIRegister_Grids(CL: TPSPascalCompiler);



implementation
Uses Sysutils, Grids;

procedure SIRegister_TInplaceEditList(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TInPlaceEdit'),TInplaceEditList) do begin
    RegisterPublishedProperties;
    RegisterMethod('Procedure RestoreContents');
    RegisterProperty('ActiveList', 'TWinControl', iptrw);
    RegisterProperty('ButtonWidth', 'Integer', iptrw);
    RegisterProperty('DropDownRows', 'Integer', iptrw);
    RegisterProperty('EditStyle', 'TEditStyle', iptr);
    RegisterProperty('ListVisible', 'Boolean', iptrw);
    RegisterProperty('PickList', 'TCustomListbox', iptr);
    RegisterProperty('PickListLoaded', 'Boolean', iptrw);
    RegisterProperty('Pressed', 'Boolean', iptr);
    RegisterProperty('OnEditButtonClick', 'TNotifyEvent', iptrw);
    RegisterProperty('OnGetPickListitems', 'TOnGetPickListItems', iptrw);
  end;
end;

procedure SIRegister_TStringGrid(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TDrawGrid'),TStringGrid) do begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Repaint;');
    RegisterMethod('Procedure Update;');
    RegisterMethod('Procedure Refresh;');
    RegisterMethod('Procedure Invalidate');
    RegisterMethod('procedure SetBounds(x,y,w,h: Integer);virtual;');
    RegisterMethod('function MouseCoord(X, Y: Integer): TGridCoord;');
    RegisterMethod('Function CellRect( ACol, ARow : Longint) : TRect');
    RegisterMethod('Procedure MouseToCell( X, Y : Integer; var ACol, ARow : Longint)');
    RegisterMethod('Procedure SetFocus');
    RegisterProperty('Cells', 'string Integer Integer', iptrw);
    RegisterProperty('Cols', 'TStrings Integer', iptrw);
    RegisterProperty('Col', 'Integer', iptrw);
    RegisterProperty('Row', 'Integer', iptrw);
    RegisterProperty('Objects', 'TObject Integer Integer', iptrw);
    RegisterProperty('Rows', 'TStrings Integer', iptrw);
    RegisterProperty('Parent', 'TWinControl', iptRW);
    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterProperty('ColWidths', 'Integer Integer', iptrw);
    RegisterProperty('RowHeights', 'Integer Integer', iptrw);
    RegisterProperty('Selection', 'TGridRect', iptrw);
    RegisterProperty('Selection2', 'TGridRect2', iptrw);
    RegisterProperty('Selection3', 'TRect', iptrw);

    RegisterProperty('GridHeight', 'Integer', iptr);
    RegisterProperty('GridWidth', 'Integer', iptr);
    RegisterProperty('TopRow','Longint',iptrw);
    RegisterProperty('HitTest','TPoint',iptr);
    //    property TabStops;
    RegisterProperty('TopRow','integer',iptr);
    RegisterProperty('TabStops','integer boolean',iptrw);
    //RegisterProperty('ONDrawCell', 'TNOTIFYEVENT', iptrw);
  end;
end;

procedure SIRegister_TStringGridStrings(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TStrings'),TStringGridStrings) do begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create( AGrid : TStringGrid; AIndex : Longint)');
    RegisterMethod('Function Add(const S: string): Integer');
    RegisterMethod('Procedure Assign(Source: TPersistent)');
    RegisterMethod('Procedure Clear;');
    RegisterMethod('Procedure Delete(Index: Integer);');
    RegisterMethod('Procedure Insert(Index: Integer; const S: string);');
  end;
end;

procedure SIRegister_TDrawGrid(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TCustomDrawGrid'),TDrawGrid) do begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Repaint;');
    RegisterMethod('procedure SetBounds(x,y,w,h: Integer);virtual;');
    RegisterMethod('Procedure Invalidate');
    //RegisterMethod('Procedure Invalidate');
    RegisterMethod('Procedure Update;');
    RegisterMethod('Procedure Refresh;');
    RegisterMethod('Procedure SetFocus');
    RegisterMethod('procedure UpdateLoc(const Loc: TRect);');
     RegisterProperty('Parent', 'TWinControl', iptRW);
    RegisterProperty('Canvas', 'TCanvas', iptr);
    //RegisterProperty('Cells', 'string Integer Integer', iptrw);
    RegisterProperty('ColWidths', 'Integer Integer', iptrw);
    RegisterProperty('Col', 'Integer', iptrw);
    RegisterProperty('Row', 'Integer', iptrw);
    RegisterProperty('Objects', 'TObject Integer Integer', iptrw);
    RegisterProperty('RowHeights', 'Integer Integer', iptrw);
    RegisterProperty('GridHeight', 'Integer', iptr);
    RegisterProperty('GridWidth', 'Integer', iptr);
    //RegisterProperty('GridWidth', 'Integer', iptr);
    RegisterProperty('TopRow','Longint',iptrw);
    RegisterProperty('HitTest','TPoint',iptr);
    RegisterProperty('TabStops','integer boolean',iptrw);  //3.9
    RegisterProperty('EditorMode','boolean',iptrw);
    RegisterProperty('LeftCol','integer',iptrw);
    RegisterProperty('Taborder','integer',iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('FixedColor', 'TColor', iptrw);
     RegisterProperty('FixedCols', 'integer', iptrw);
     RegisterProperty('FixedRows', 'integer', iptrw);
     RegisterProperty('BidiMode', 'TBiDiMode', iptrw);
    RegisterProperty('ParentBidiMode', 'boolean', iptrw);


   { property RowCount;
    property Font;
    property GridLineWidth;}


    //RegisterProperty('ONDrawCell', 'TNOTIFYEVENT', iptrw);
   end;
end;

procedure SIRegister_TCustomDrawGrid(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TCustomGrid'),TCustomDrawGrid) do begin
   // RegisterPublishedProperties;
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function CellRect( ACol, ARow : Longint) : TRect');
    RegisterMethod('Procedure MouseToCell( X, Y : Integer; var ACol, ARow : Longint)');
    RegisterPublishedProperties;
    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterProperty('EditorMode', 'boolean', iptrw);
     //  property TabStop default True;


   { property Canvas;
    property Col;
    property ColWidths;
    property EditorMode;
    property GridHeight;
    property GridWidth;
    property LeftCol;
    property Selection;
    property Row;
    property RowHeights;
    property TabStops;
    property TopRow;   }

  end;
end;

procedure SIRegister_TCustomGrid(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TCustomControl'),TCustomGrid) do begin
    RegisterPublishedProperties;
  //      property TabStop default True;
    RegisterProperty('TabStop','boolean',iptrw);
    RegisterProperty('BorderStyle','TBorderStyle',iptrw);
    RegisterProperty('Options','TGridOptions',iptrw);
    //RegisterProperty('TabStops','integer boolean',iptrw);
    RegisterMethod('Function MouseCoord( X, Y : Integer) : TGridCoord');
    RegisterMethod('Procedure Free');
    RegisterMethod('Constructor CREATE(AOWNER : TCOMPONENT)');
  end;
end;

procedure SIRegister_TInplaceEdit(CL: TPSPascalCompiler);
begin
  with CL.AddClass(CL.FindClass('TCustomMaskEdit'),TInplaceEdit) do begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor CREATE( AOWNER : TCOMPONENT)');
    RegisterMethod('Procedure Deselect');
    RegisterMethod('Procedure Hide');
    RegisterMethod('Procedure Invalidate');
    RegisterMethod('Procedure Move( const Loc : TRect)');
    RegisterMethod('Function PosEqual( const Rect : TRect) : Boolean');
    RegisterMethod('Procedure SetFocus');
    RegisterMethod('Procedure UpdateLoc( const Loc : TRect)');
    RegisterMethod('Function Visible : Boolean');
  end;
end;

procedure SIRegister_Grids(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('MaxCustomExtents','').SetString(MaxCustomExtents);
  CL.AddClass(CL.FindClass('TOBJECT'),EInvalidGridOperation);
  CL.AddTypeS('TGetExtentsFunc', 'Function ( Index : Longint) : Integer');
  CL.AddTypeS('TGridAxisDrawInfo', 'record EffectiveLineWidth : Integer; FixedB'
   +'oundary : Integer; GridBoundary : Integer; GridExtent : Integer; LastFullV'
   +'isibleCell : Longint; FullVisBoundary : Integer; FixedCellCount : Integer;'
   +' FirstGridCell : Integer; GridCellCount : Integer; GetExtent : TGetExtentsFunc; end');
  CL.AddTypeS('TGridState', '( gsNormal, gsSelecting, gsRowSizing, gsColSizing,'
   +' gsRowMoving, gsColMoving )');
 // CL.AddClass(CL.FindClass('TOBJECT'),TCustomGrid);
  SIRegister_TInplaceEdit(CL);
  CL.AddTypeS('TGridOption', '( goFixedVertLine, goFixedHorzLine, goVertLine, g'
   +'oHorzLine, goRangeSelect, goDrawFocusSelected, goRowSizing, goColSizing, g'
   +'oRowMoving, goColMoving, goEditing, goTabs, goRowSelect, goAlwaysShowEditor, goThumbTracking )');
  CL.AddTypeS('TGridOptions', 'set of TGridOption');
  CL.AddTypeS('TGridDrawStates', '( gdSelected, gdFocused, gdFixed )');
   CL.AddTypeS('TGridDrawState', 'set of TGridDrawStates');
   CL.AddTypeS('TGridRect', 'TRect');
   CL.AddTypeS('TGridCoord', 'TPoint');

   CL.AddTypeS('TGridRect2', 'record Left, Top, Right, Bottom: Longint; end');
  { TGridRect = record
    case Integer of
      0: (Left, Top, Right, Bottom: Longint);
      1: (TopLeft, BottomRight: TGridCoord);
  end;}

   CL.AddTypeS('TGridRect3', 'record Left, Top, Right, Bottom: Longint; TopLeft, BottomRight: TGridCoord; end');

  { TGridCoord = record
    X: Longint;
    Y: Longint;
  end;}

  //gdselected
   // TGridDrawState = set of (gdSelected, gdFocused, gdFixed);
  //CL.AddTypeS('TGridDrawState', '( gdSelected, gdFocused, gdFixed )');
  //CL.AddTypeS('TGridDrawState', 'set of( gdSelected, gdFocused, gdFixed )');
  //CL.AddTypeS('TGridScrollDirection', 'set of ( sdLeft, sdRight, sdUp, sdDown )');
  CL.AddTypeS('TGridCoord', 'record X : Longint; Y : Longint; end');
  CL.AddTypeS('TEditStyle', '( esSimple, esEllipsis, esPickList )');
  CL.AddTypeS('TSelectCellEvent', 'Procedure ( Sender : TObject; ACol, ARow : L'
   +'ongint; var CanSelect : Boolean)');
  CL.AddTypeS('TDrawCellEvent', 'Procedure ( Sender : TObject; ACol, ARow : Lon'
   +'gint; Rect : TRect; State : TGridDrawState)');
  //SIRegister_TCustomGrid(CL);
  CL.AddTypeS('TGetEditEvent', 'Procedure ( Sender : TObject; ACol, ARow : Long'
   +'int; var Value : string)');
  CL.AddTypeS('TSetEditEvent', 'Procedure ( Sender : TObject; ACol, ARow : Long'
   +'int; const Value : string)');
  CL.AddTypeS('TMovedEvent', 'Procedure (Sender: TObject; FromIndex,ToIndex: Longint)');
  CL.AddClass(CL.FindClass('TOBJECT'),TCustomGrid);
  SIRegister_TCustomGrid(CL);
  SIRegister_TCustomDrawGrid(CL);
  SIRegister_TDrawGrid(CL);
  CL.AddClass(CL.FindClass('TOBJECT'),TStringGrid);
  SIRegister_TStringGridStrings(CL);
  SIRegister_TStringGrid(CL);
  CL.AddTypeS('TOnGetPickListItems','Procedure (ACol,ARow: Integer; Items: TStrings)');
  SIRegister_TInplaceEditList(CL);
  CL.AddDelphiFunction('procedure SwapGrid(grd: TStringGrid);');

end;

end.
