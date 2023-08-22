unit uPSI_Chart;
{
  a long story to TEE, include BDE mX4 utils
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
  TPSImport_Chart = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TChartTheme(CL: TPSPascalCompiler);
procedure SIRegister_TColorPalettes(CL: TPSPascalCompiler);
procedure SIRegister_TTeeDragObject(CL: TPSPascalCompiler);
procedure SIRegister_TTeeToolTypes(CL: TPSPascalCompiler);
procedure SIRegister_TTeeSeriesTypes(CL: TPSPascalCompiler);
procedure SIRegister_TChart(CL: TPSPascalCompiler);
procedure SIRegister_TCustomChart(CL: TPSPascalCompiler);
procedure SIRegister_TChartWalls(CL: TPSPascalCompiler);
procedure SIRegister_TChartLeftWall(CL: TPSPascalCompiler);
procedure SIRegister_TChartBottomWall(CL: TPSPascalCompiler);
procedure SIRegister_TChartRightWall(CL: TPSPascalCompiler);
procedure SIRegister_TChartBackWall(CL: TPSPascalCompiler);
procedure SIRegister_TChartFootTitle(CL: TPSPascalCompiler);
procedure SIRegister_TChartTitle(CL: TPSPascalCompiler);
procedure SIRegister_TChartLegend(CL: TPSPascalCompiler);
procedure SIRegister_TCustomChartLegend(CL: TPSPascalCompiler);
procedure SIRegister_TLegendItems(CL: TPSPascalCompiler);
procedure SIRegister_TLegendItem(CL: TPSPascalCompiler);
procedure SIRegister_TLegendTitle(CL: TPSPascalCompiler);
procedure SIRegister_TTeeCustomShapePosition(CL: TPSPascalCompiler);
procedure SIRegister_TLegendSymbol(CL: TPSPascalCompiler);
procedure SIRegister_TChartLegendGradient(CL: TPSPascalCompiler);
procedure SIRegister_TChartWall(CL: TPSPascalCompiler);
procedure SIRegister_TCustomChartWall(CL: TPSPascalCompiler);
procedure SIRegister_Chart(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TChartTheme(CL: TPSRuntimeClassImporter);
procedure RIRegister_Chart_Routines(S: TPSExec);
procedure RIRegister_TColorPalettes(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeDragObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeToolTypes(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeSeriesTypes(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChart(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomChart(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartWalls(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartLeftWall(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartBottomWall(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartRightWall(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartBackWall(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartFootTitle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartTitle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartLegend(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomChartLegend(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLegendItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLegendItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLegendTitle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeCustomShapePosition(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLegendSymbol(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartLegendGradient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartWall(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomChartWall(CL: TPSRuntimeClassImporter);
procedure RIRegister_Chart(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  //,QGraphics
  //,QControls
  //,QExtCtrls
  //,QForms
  //,QButtons
  ,Types
  //,Qt
  ,Graphics
  ,Controls
  ,Buttons
  ,TeeProcs
  ,TeEngine
  ,TeCanvas
  ,TEEHTML
  ,Chart
  ,Registry, ShlObj, ActiveX, ComObj, DbiProcs,
   DbiTypes, DbiErrs, DBTables, Winprocs, WinTypes, Variants;

function RestartDialog(Wnd: HWnd; Reason: PChar; Flags: Integer): Integer; stdcall; external 'shell32.dll' index 59;


 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Chart]);
end;

procedure SetAlias (aAlias,aDirectory:String);
var aParams: TStringList;
    Dir: string;
begin
  if not Session.IsAlias(aAlias)
  then begin
//      ShowMessage('Alias '+aAlias+' ist nicht vorhanden');
      Session.AddStandardAlias(aAlias, aDirectory, 'PARADOX');
      Session.SaveConfigFile;
  end
  else try
//      ShowMessage('Alias '+aAlias+' ist schon vorhanden');
           aParams:=TStringList.Create;
           Session.GetAliasParams(aAlias, aParams); // den aktuellen Parameter PATH ermitteln
           Dir:=aParams.values['PATH'];
           if Dir<>aDirectory then begin
              AParams.Clear;
              aParams.Add('PATH=' + aDirectory);
              Session.ModifyAlias(aAlias, aParams);
              Session.SaveConfigFile;
           end;
       finally
           AParams.Free;
       end;
end;

procedure SetBDE (aPath,aNode,aValue:String);
var Cursor: HDbiCur;
    ConfigDesc: CfgDesc;
    OldValue:String;
begin
   Check(DbiInit(nil));
   Check(DbiOpenCfgInfoList(nil, dbiReadWrite, cfgPersistent, PChar(aPath), Cursor));
   try
       while DbiGetNextRecord(Cursor, dbiNoLock, @ConfigDesc, nil) = 0 do begin
             if StrIComp(ConfigDesc.szNodeName, PChar(aNode)) = 0 then begin
                if StrIComp(ConfigDesc.szValue, PChar(aValue)) <> 0 then begin
                   Check(DbiGetRecord(Cursor, dbiWriteLock, @ConfigDesc, nil));
                   OldValue:=ConfigDesc.szValue;
                   StrPCopy(ConfigDesc.szValue, PChar(aValue));
                   Check(DbiModifyRecord(Cursor, @ConfigDesc, True));
//                   ShowMessage(format('Geändert: %s = %s --> %s',[aNode,OldValue,aValue]));
                end;
                break;
             end;
       end;
   finally
       DbiCloseCursor(Cursor);
       DbiExit;
   end;
end;

type
  TVersionNo = record
    MS, LS: Cardinal;
  end;

function GetFileVersionNumber (const FileName: String): TVersionNo;
var VerInfo: Pointer;
    Len, BufSize: Cardinal;
    Dest: PVSFixedFileInfo;
begin
  FillChar(Result, SizeOf(Result), 0);
  //How big is version info?
  BufSize := GetFileVersionInfoSize(PChar(FileName), Len);
  if BufSize > 0 then begin
    //Reserve sufficient memory
    GetMem(VerInfo, BufSize);
    try
      //Get version information
      if GetFileVersionInfo(PChar(FileName), 0, BufSize, VerInfo) then
        //Get translation table
        if VerQueryValue(VerInfo, '\', Pointer(Dest), Len) then
          with Dest^ do
          begin
            Result.MS := dwFileVersionMS;
            Result.LS := dwFileVersionLS
          end
    finally
      //Free sufficient memory
      FreeMem(VerInfo, BufSize)
    end
  end
end;

var RebootRequired: Boolean = False;


procedure CheckRegistryEntry(Reg: TRegistry; const Path, Value: String; const Default, Desired: Variant; Size: Byte);
var TmpInt: Cardinal;
    TmpStr: String;
begin
  with Reg do
       if OpenKey(Path, True) then
       try
           case VarType(Desired) of
             varInteger:
               // Some numbers need to be stored as DWORD values, while some need to be stored as binary values
               if Size = 0
               then begin
                    if not ValueExists(Value) or (ReadInteger(Value) = Default) then begin
                       WriteInteger(Value, Desired);
                       RebootRequired := True
                    end
                    end
               else begin
                    TmpInt := Default;
                    if ValueExists(Value) then ReadBinaryData(Value, TmpInt, Size);
                    if TmpInt = Default then begin
                       TmpInt := Desired;
                       WriteBinaryData(Value, TmpInt, Size);
                       RebootRequired := True
                    end
               end;
             varString:
               begin
                 if not ValueExists(Value) or (ReadString(Value) = Default) then begin
                    WriteString(Value, Desired);
                    RebootRequired := True
                 end;
               end;
           end;
       finally
         CloseKey
       end;
end;



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartTheme(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TChartTheme') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TChartTheme') do begin
    RegisterProperty('Chart', 'TCustomChart', iptrw);
    RegisterMethod('Constructor Create( AChart : TCustomChart);');
    RegisterMethod('Procedure Apply');
    RegisterMethod('Function Description : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TColorPalettes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TColorPalettes') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TColorPalettes') do
  begin
    RegisterMethod('Procedure AddTo( const Items : TStrings; AddDefault : Boolean)');
    RegisterMethod('Procedure ApplyPalette( Chart : TCustomAxisPanel; Index : Integer);');
    RegisterMethod('Procedure ApplyPalette1( Chart : TCustomAxisPanel; const Palette : array of TColor);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeDragObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDragObject', 'TTeeDragObject') do
  with CL.AddClassN(CL.FindClass('TDragObject'),'TTeeDragObject') do
  begin
    RegisterMethod('Constructor Create( const APart : TChartClickedPart)');
    RegisterProperty('Part', 'TChartClickedPart', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeToolTypes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TTeeToolTypes') do
  with CL.AddClassN(CL.FindClass('TList'),'TTeeToolTypes') do
  begin
    RegisterProperty('Items', 'TTeeCustomToolClass Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeSeriesTypes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TTeeSeriesTypes') do
  with CL.AddClassN(CL.FindClass('TList'),'TTeeSeriesTypes') do
  begin
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Find( ASeriesClass : TChartSeriesClass) : TTeeSeriesType');
    RegisterProperty('Items', 'TTeeSeriesType Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChart(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomChart', 'TChart') do
  with CL.AddClassN(CL.FindClass('TCustomChart'),'TChart') do begin
    RegisterPublishedProperties;
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomChart(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomAxisPanel', 'TCustomChart') do
  with CL.AddClassN(CL.FindClass('TCustomAxisPanel'),'TCustomChart') do begin
    RegisterProperty('FColorPaletteIndex', 'Integer', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free;');

    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function AxisTitleOrName( Axis : TChartAxis) : String');
    RegisterMethod('Procedure CalcClickedPart( Pos : TPoint; var Part : TChartClickedPart)');
    RegisterMethod('Function DrawLeftWallFirst : Boolean');
    RegisterMethod('Function DrawRightWallAfter : Boolean');
    RegisterMethod('Procedure FillSeriesSourceItems( ASeries : TChartSeries; Proc : TGetStrProc)');
    RegisterMethod('Procedure FillValueSourceItems( ValueList : TChartValueList; Proc : TGetStrProc)');
    RegisterMethod('Function GetASeries : TChartSeries');
    RegisterMethod('Procedure NextPage');
    RegisterMethod('Procedure PreviousPage');
    RegisterMethod('Procedure RemoveAllSeries');
    RegisterMethod('Procedure SeriesDown( ASeries : TChartSeries)');
    RegisterMethod('Procedure SeriesUp( ASeries : TChartSeries)');
    RegisterMethod('Procedure ZoomPercent( const PercentZoom : Double)');
    RegisterMethod('Procedure ZoomRect( const Rect : TRect)');
    RegisterMethod('Function FormattedLegend( SeriesOrValueIndex : Integer) : String');
    RegisterProperty('BackColor', 'TColor', iptrw);
    RegisterProperty('ColorPaletteIndex', 'Integer', iptrw);
    RegisterProperty('Walls', 'TChartWalls', iptrw);
    RegisterProperty('BackWall', 'TChartBackWall', iptrw);
    RegisterProperty('Frame', 'TChartPen', iptrw);
    RegisterProperty('BottomWall', 'TChartBottomWall', iptrw);
    RegisterProperty('Foot', 'TChartTitle', iptrw);
    RegisterProperty('LeftWall', 'TChartLeftWall', iptrw);
    RegisterProperty('Legend', 'TChartLegend', iptrw);
    RegisterProperty('RightWall', 'TChartRightWall', iptrw);
    RegisterProperty('ScrollMouseButton', 'TMouseButton', iptrw);
    RegisterProperty('SubFoot', 'TChartTitle', iptrw);
    RegisterProperty('SubTitle', 'TChartTitle', iptrw);
    RegisterProperty('Title', 'TChartTitle', iptrw);
    RegisterProperty('OnAllowScroll', 'TChartAllowScrollEvent', iptrw);
    RegisterProperty('OnClickAxis', 'TChartClickAxis', iptrw);
    RegisterProperty('OnClickBackground', 'TChartClick', iptrw);
    RegisterProperty('OnClickLegend', 'TChartClick', iptrw);
    RegisterProperty('OnClickSeries', 'TChartClickSeries', iptrw);
    RegisterProperty('OnClickTitle', 'TChartClickTitle', iptrw);
    RegisterProperty('OnGetLegendPos', 'TOnGetLegendPos', iptrw);
    RegisterProperty('OnGetLegendRect', 'TOnGetLegendRect', iptrw);
    RegisterProperty('OnGetLegendText', 'TOnGetLegendText', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartWalls(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TChartWalls') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TChartWalls') do
  begin
    RegisterMethod('Constructor Create( Chart : TCustomChart)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Back', 'TChartBackWall', iptrw);
    RegisterProperty('Bottom', 'TChartBottomWall', iptrw);
    RegisterProperty('Left', 'TChartLeftWall', iptrw);
    RegisterProperty('Right', 'TChartRightWall', iptrw);
    RegisterProperty('Size', 'Integer', iptw);
    RegisterProperty('Visible', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartLeftWall(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TChartWall', 'TChartLeftWall') do
  with CL.AddClassN(CL.FindClass('TChartWall'),'TChartLeftWall') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartBottomWall(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TChartWall', 'TChartBottomWall') do
  with CL.AddClassN(CL.FindClass('TChartWall'),'TChartBottomWall') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartRightWall(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TChartWall', 'TChartRightWall') do
  with CL.AddClassN(CL.FindClass('TChartWall'),'TChartRightWall') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartBackWall(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TChartWall', 'TChartBackWall') do
  with CL.AddClassN(CL.FindClass('TChartWall'),'TChartBackWall') do
  begin
    RegisterMethod('Constructor Create( AOwner : TCustomTeePanel)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartFootTitle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TChartTitle', 'TChartFootTitle') do
  with CL.AddClassN(CL.FindClass('TChartTitle'),'TChartFootTitle') do
  begin
    RegisterMethod('Constructor Create( AOwner : TCustomTeePanel)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartTitle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeeCustomShapePosition', 'TChartTitle') do
  with CL.AddClassN(CL.FindClass('TTeeCustomShapePosition'),'TChartTitle') do begin
    RegisterMethod('Constructor Create( AOwner : TCustomTeePanel)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Clicked( x, y : Integer) : Boolean');
    RegisterMethod('Procedure DrawTitle');
    RegisterProperty('Caption', 'String', iptrw);
    RegisterProperty('TitleRect', 'TRect', iptr);
    RegisterProperty('AdjustFrame', 'Boolean', iptrw);
    RegisterProperty('Alignment', 'TAlignment', iptrw);
    RegisterProperty('Text', 'TStrings', iptrw);
    RegisterProperty('VertMargin', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartLegend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomChartLegend', 'TChartLegend') do
  with CL.AddClassN(CL.FindClass('TCustomChartLegend'),'TChartLegend') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomChartLegend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeeCustomShapePosition', 'TCustomChartLegend') do
  with CL.AddClassN(CL.FindClass('TTeeCustomShapePosition'),'TCustomChartLegend') do
  begin
    RegisterProperty('NumCols', 'Integer', iptrw);
    RegisterProperty('NumRows', 'Integer', iptrw);
    RegisterProperty('ColumnWidthAuto', 'Boolean', iptrw);
    RegisterProperty('ColumnWidths', '', iptrw);
    RegisterMethod('Constructor Create( AOwner : TCustomTeePanel)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function Clicked( x, y : Integer) : Integer');
    RegisterMethod('Procedure DrawLegend');
    RegisterMethod('Function FormattedValue( ASeries : TChartSeries; ValueIndex : Integer) : String');
    RegisterMethod('Function FormattedLegend( Index : Integer) : String');
    RegisterMethod('Function ShouldDraw : Boolean');
    RegisterProperty('TotalLegendItems', 'Integer', iptr);
    RegisterProperty('RectLegend', 'TRect', iptr);
    RegisterProperty('Vertical', 'Boolean', iptr);
    RegisterProperty('Alignment', 'TLegendAlignment', iptrw);
    RegisterProperty('CheckBoxes', 'Boolean', iptrw);
    RegisterProperty('CheckBoxesStyle', 'TCheckBoxesStyle', iptrw);
    RegisterProperty('ColorWidth', 'Integer', iptrw);
    RegisterProperty('CurrentPage', 'Boolean', iptrw);
    RegisterProperty('DividingLines', 'TChartHiddenPen', iptrw);
    RegisterProperty('FirstValue', 'Integer', iptrw);
    RegisterProperty('FontSeriesColor', 'Boolean', iptrw);
    RegisterProperty('HorizMargin', 'Integer', iptrw);
    RegisterProperty('Inverted', 'Boolean', iptrw);
    RegisterProperty('Item', 'TLegendItem Integer', iptr);
    SetDefaultPropery('Item');
    RegisterProperty('Items', 'TLegendItems', iptr);
    RegisterProperty('LastValue', 'Integer', iptr);
    RegisterProperty('LeftPercent', 'Integer', iptrw);
    RegisterProperty('LegendStyle', 'TLegendStyle', iptrw);
    RegisterProperty('MaxNumRows', 'Integer', iptrw);
    RegisterProperty('PositionUnits', 'TTeeUnits', iptrw);
    RegisterProperty('ResizeChart', 'Boolean', iptrw);
    RegisterProperty('Series', 'TChartSeries', iptrw);
    RegisterProperty('Symbol', 'TLegendSymbol', iptrw);
    RegisterProperty('TextStyle', 'TLegendTextStyle', iptrw);
    RegisterProperty('Title', 'TLegendTitle', iptrw);
    RegisterProperty('TopPercent', 'Integer', iptrw);
    RegisterProperty('TopPos', 'Integer', iptrw);
    RegisterProperty('VertMargin', 'Integer', iptrw);
    RegisterProperty('VertSpacing', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLegendItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TLegendItems') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TLegendItems') do
  begin
    RegisterMethod('Procedure Clear');
    RegisterProperty('Custom', 'Boolean', iptrw);
    RegisterProperty('Items', 'TLegendItem Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLegendItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TLegendItem') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TLegendItem') do
  begin
    RegisterProperty('SymbolRect', 'TRect', iptrw);
    RegisterProperty('Align', 'Integer', iptr);
    RegisterProperty('Left', 'Integer', iptr);
    RegisterProperty('Text', 'String', iptrw);
    RegisterProperty('Text2', 'String', iptrw);
    RegisterProperty('Top', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLegendTitle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeeShape', 'TLegendTitle') do
  with CL.AddClassN(CL.FindClass('TTeeShape'),'TLegendTitle') do
  begin
    RegisterMethod('Constructor Create( AOwner : TCustomTeePanel)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Caption', 'String', iptrw);
    RegisterProperty('Text', 'TStringList', iptrw);
    RegisterProperty('TextAlignment', 'TAlignment', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeCustomShapePosition(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeeCustomShape', 'TTeeCustomShapePosition') do
  with CL.AddClassN(CL.FindClass('TTeeCustomShape'),'TTeeCustomShapePosition') do begin
    RegisterProperty('DefaultCustom', 'Boolean', iptrw);
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('CustomPosition', 'Boolean', iptrw);
    RegisterProperty('Left', 'Integer', iptrw);
    RegisterProperty('Top', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLegendSymbol(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TLegendSymbol') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TLegendSymbol') do begin
    RegisterProperty('Parent', 'TCustomTeePanel', iptrw);
    RegisterMethod('Constructor Create( AParent : TCustomTeePanel)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Continuous', 'Boolean', iptrw);
    RegisterProperty('DefaultPen', 'Boolean', iptrw);
    RegisterProperty('Gradient', 'TTeeGradient', iptrw);
    RegisterProperty('Pen', 'TChartPen', iptrw);
    RegisterProperty('Position', 'TLegendSymbolPosition', iptrw);
    RegisterProperty('Shadow', 'TTeeShadow', iptrw);
    RegisterProperty('Squared', 'Boolean', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
    RegisterProperty('WidthUnits', 'TLegendSymbolSize', iptrw);
    RegisterProperty('OnDraw', 'TSymbolDrawEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartLegendGradient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TChartGradient', 'TChartLegendGradient') do
  with CL.AddClassN(CL.FindClass('TChartGradient'),'TChartLegendGradient') do
  begin
    RegisterMethod('Constructor Create( ChangedEvent : TNotifyEvent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartWall(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomChartWall', 'TChartWall') do
  with CL.AddClassN(CL.FindClass('TCustomChartWall'),'TChartWall') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomChartWall(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeeCustomShape', 'TCustomChartWall') do
  with CL.AddClassN(CL.FindClass('TTeeCustomShape'),'TCustomChartWall') do begin
    RegisterMethod('Constructor Create( AOwner : TCustomTeePanel)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('AutoHide', 'Boolean', iptrw);
    RegisterProperty('Dark3D', 'Boolean', iptrw);
    RegisterProperty('EndPosition', 'Integer', iptrw);
    RegisterProperty('Pen', 'TChartPen', iptrw);
    RegisterProperty('Size', 'Integer', iptrw);
    RegisterProperty('StartPosition', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Chart(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('TeeMsg_DefaultFunctionName','String').SetString( 'TeeFunction');
 CL.AddConstantN('TeeMsg_DefaultSeriesName','String').SetString( 'Series');
 CL.AddConstantN('TeeMsg_DefaultToolName','String').SetString( 'ChartTool');
 CL.AddConstantN('ChartComponentPalette','String').SetString( 'TeeChart');
 CL.AddConstantN('TeeMaxLegendColumns','LongInt').SetInt( 2);
 CL.AddConstantN('TeeDefaultLegendSymbolWidth','LongInt').SetInt( 20);
 CL.AddConstantN('TeeTitleFootDistance','LongInt').SetInt( 5);
  SIRegister_TCustomChartWall(CL);
  SIRegister_TChartWall(CL);
  SIRegister_TChartLegendGradient(CL);
  CL.AddTypeS('TLegendStyle', '( lsAuto, lsSeries, lsValues, lsLastValues, lsSeriesGroups )');
  CL.AddTypeS('TLegendAlignment', '( laLeft, laRight, laTop, laBottom )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'LegendException');
  //CL.AddTypeS('TOnGetLegendText', 'Procedure ( Sender : TCustomAxisPanel; Legen'
  // +'dStyle : TLegendStyle; Index : Integer; var LegendText : String)');
  //CL.AddClassN(CL.FindClass('TCustomChartSeries'),'TChartSeries');
  //CL.AddClassN(CL.FindClass('TCustomTeePanelExtended'),'TCustomAxisPanel');

  //TCustomAxisPanel=class(TCustomTeePanelExtended)
   //TChartSeries=class(TCustomChartSeries)
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomChartLegend');
  CL.AddTypeS('TLegendSymbolSize', '( lcsPercent, lcsPixels )');
  CL.AddTypeS('TLegendSymbolPosition', '( spLeft, spRight )');
  //CL.AddTypeS('TSymbolDrawEvent', 'Procedure ( Sender : TObject; Series : TChartSeries; ValueIndex : Integer; R : TRect)');
  CL.AddTypeS('TSymbolCalcHeight', 'Function  : Integer');
  SIRegister_TLegendSymbol(CL);
  SIRegister_TTeeCustomShapePosition(CL);
  CL.AddTypeS('TCheckBoxesStyle', '( cbsCheck, cbsRadio )');
  CL.AddTypeS('TVersionNo', 'record MS, LS: Cardinal; end;');

  SIRegister_TLegendTitle(CL);
  SIRegister_TLegendItem(CL);
  SIRegister_TLegendItems(CL);
  //CL.AddTypeS('TLegendCalcSize', 'Procedure ( Sender : TCustomChartLegend; var ASize : Integer)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomChart');
  SIRegister_TCustomChartLegend(CL);
  SIRegister_TChartLegend(CL);
  SIRegister_TChartTitle(CL);
  SIRegister_TChartFootTitle(CL);
  CL.AddTypeS('TLegendCalcSize', 'Procedure ( Sender : TCustomChartLegend; var ASize : Integer)');
  SIRegister_TCustomChart(CL);
   CL.AddTypeS('TChartClick', 'Procedure ( Sender : TCustomChart; Button : TMous'
   +'eButton; Shift : TShiftState; X, Y : Integer)');
  //CL.AddTypeS('TChartClickAxis', 'Procedure ( Sender : TCustomChart; Axis : TCh'
  // +'artAxis; Button : TMouseButton; Shift : TShiftState; X, Y : Integer)');
  //CL.AddTypeS('TChartClickSeries', 'Procedure ( Sender : TCustomChart; Series :'
   //+' TChartSeries; ValueIndex : Integer; Button : TMouseButton; Shift : TShiftState; X, Y : Integer)');
  CL.AddTypeS('TChartClickTitle', 'Procedure ( Sender : TCustomChart; ATitle : '
   +'TChartTitle; Button : TMouseButton; Shift : TShiftState; X, Y : Integer)');
  CL.AddTypeS('TOnGetLegendPos', 'Procedure ( Sender : TCustomChart; Index : In'
   +'teger; var X, Y, XColor : Integer)');
  CL.AddTypeS('TOnGetLegendRect', 'Procedure ( Sender : TCustomChart; var Rect : TRect)');
  CL.AddTypeS('TAxisSavedScales', 'record Auto : Boolean; AutoMin : Boolean; Au'
   +'toMax : Boolean; Min : Double; Max : Double; end');
  CL.AddTypeS('TAllAxisSavedScales', 'array of TAxisSavedScales');
  SIRegister_TChartBackWall(CL);
  SIRegister_TChartRightWall(CL);
  SIRegister_TChartBottomWall(CL);
  SIRegister_TChartLeftWall(CL);
  SIRegister_TChartWalls(CL);
  //CL.AddTypeS('TChartAllowScrollEvent', 'Procedure ( Sender : TChartAxis; var AMin, AMax : Double; var AllowScroll : Boolean)');
  //SIRegister_TCustomChart(CL);
  SIRegister_TChart(CL);
  {SIRegister_TTeeSeriesTypes(CL);
  SIRegister_TTeeToolTypes(CL);
  SIRegister_TTeeDragObject(CL);
  SIRegister_TColorPalettes(CL); }
 {CL.AddDelphiFunction('Procedure RegisterTeeSeries( ASeriesClass : TChartSeriesClass; ADescription, AGalleryPage : PString; ANumGallerySeries : Integer);');
 CL.AddDelphiFunction('Procedure RegisterTeeSeries1( ASeriesClass : TChartSeriesClass; ADescription : PString);');
 CL.AddDelphiFunction('Procedure RegisterTeeFunction( AFunctionClass : TTeeFunctionClass; ADescription, AGalleryPage : PString; ANumGallerySeries : Integer)');
 CL.AddDelphiFunction('Procedure RegisterTeeBasicFunction( AFunctionClass : TTeeFunctionClass; ADescription : PString)');
 CL.AddDelphiFunction('Procedure RegisterTeeSeriesFunction( ASeriesClass : TChartSeriesClass; AFunctionClass : TTeeFunctionClass; ADescription, AGalleryPage : PString; ANumGallerySeries : Integer; ASubIndex : Integer)');
 CL.AddDelphiFunction('Procedure UnRegisterTeeSeries( const ASeriesList : array of TChartSeriesClass)');
 CL.AddDelphiFunction('Procedure UnRegisterTeeFunctions( const AFunctionList : array of TTeeFunctionClass)'); }
 CL.AddDelphiFunction('Procedure AssignSeries( var OldSeries, NewSeries : TChartSeries)');
// CL.AddDelphiFunction('Function CreateNewTeeFunction( ASeries : TChartSeries; AClass : TTeeFunctionClass) : TTeeFunction');
 //CL.AddDelphiFunction('Function CreateNewSeries( AOwner : TComponent; AChart : TCustomAxisPanel; AClass : TChartSeriesClass; AFunctionClass : TTeeFunctionClass) : TChartSeries');
 CL.AddDelphiFunction('Function CloneChartSeries( ASeries : TChartSeries) : TChartSeries;');
 CL.AddDelphiFunction('Function CloneChartSeries1( ASeries : TChartSeries; AChart : TCustomAxisPanel) : TChartSeries;');
 CL.AddDelphiFunction('Function CloneChartSeries2( ASeries : TChartSeries; AOwner : TComponent; AChart : TCustomAxisPanel) : TChartSeries;');
// CL.AddDelphiFunction('Function CloneChartTool( ATool : TTeeCustomTool; AOwner : TComponent) : TTeeCustomTool');
 //CL.AddDelphiFunction('Function ChangeSeriesType( var ASeries : TChartSeries; NewType : TChartSeriesClass) : TChartSeries');
 //CL.AddDelphiFunction('Procedure ChangeAllSeriesType( AChart : TCustomChart; AClass : TChartSeriesClass)');
 //CL.AddDelphiFunction('Function GetNewSeriesName( AOwner : TComponent) : TComponentName');
 //CL.AddDelphiFunction('Procedure RegisterTeeTools( const ATools : array of TTeeCustomToolClass)');
 //CL.AddDelphiFunction('Procedure UnRegisterTeeTools( const ATools : array of TTeeCustomToolClass)');
 CL.AddDelphiFunction('Function GetGallerySeriesName( ASeries : TChartSeries) : String');
 CL.AddDelphiFunction('Procedure PaintSeriesLegend( ASeries : TChartSeries; ACanvas : TCanvas; const R : TRect; ReferenceChart : TCustomChart)');
        //SIRegister_TCustomChart(CL);
  //SIRegister_TCustomChart(CL);

  //SIRegister_TChartTheme(CL);
  //CL.AddTypeS('TChartThemeClass', 'class of TChartTheme');
  //CL.AddTypeS('TCanvasClass', 'class of TCanvas3D');

 CL.AddDelphiFunction('Procedure SetAlias( aAlias, aDirectory : String)');
 CL.AddDelphiFunction('Procedure CheckRegistryEntry( Reg : TRegistry; const Path, Value : String; const Default, Desired : Variant; Size : Byte)');
 CL.AddDelphiFunction('Function GetFileVersionNumber( const FileName : String) : TVersionNo');
 CL.AddDelphiFunction('Procedure SetBDE( aPath, aNode, aValue : String)');
 CL.AddDelphiFunction('function RestartDialog(Wnd: HWnd; Reason: PChar; Flags: Integer): Integer; stdcall;');
 CL.AddDelphiFunction('Function GetSystemDirectory( lpBuffer : string; uSize : UINT) : UINT');
 CL.AddDelphiFunction('Function GetSystemDirectoryW( lpBuffer : pchar; uSize : UINT) : UINT');
 CL.AddDelphiFunction('Function GetTempPath( nBufferLength : DWORD; lpBuffer : string) : DWORD');
 CL.AddDelphiFunction('Function GetWindowsDirectoryW( nBufferLength : DWORD; lpBuffer : string) : DWORD');
 CL.AddDelphiFunction('Function GetTempFileName( lpPathName, lpPrefixString : string; uUnique : UINT; lpTempFileName : string) : UINT');
 CL.AddDelphiFunction('Procedure HtmlTextOut( ACanvas : TCanvas; x, y : Integer; Text : String)');
 CL.AddDelphiFunction('Function HtmlTextExtent( ACanvas : TCanvas; const Text : String) : TSize');


      //GetWindowsDirectory( lpBuffer : PChar; uSize : UINT) : UINT');   getsystemdirectory

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TChartThemeCreate_P(Self: TClass; CreateNewInstance: Boolean;  AChart : TCustomChart):TObject;
Begin Result := TChartTheme.Create(AChart); END;

(*----------------------------------------------------------------------------*)
procedure TChartThemeChart_W(Self: TChartTheme; const T: TCustomChart);
Begin Self.Chart := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartThemeChart_R(Self: TChartTheme; var T: TCustomChart);
Begin T := Self.Chart; end;

(*----------------------------------------------------------------------------*)
Function CloneChartSeries2_P( ASeries : TChartSeries; AOwner : TComponent; AChart : TCustomAxisPanel) : TChartSeries;
Begin Result := Chart.CloneChartSeries(ASeries, AOwner, AChart); END;

(*----------------------------------------------------------------------------*)
Function CloneChartSeries1_P( ASeries : TChartSeries; AChart : TCustomAxisPanel) : TChartSeries;
Begin Result := Chart.CloneChartSeries(ASeries, AChart); END;

(*----------------------------------------------------------------------------*)
Function CloneChartSeries_P( ASeries : TChartSeries) : TChartSeries;
Begin Result := Chart.CloneChartSeries(ASeries); END;

(*----------------------------------------------------------------------------*)
Procedure RegisterTeeSeries1_P( ASeriesClass : TChartSeriesClass; ADescription : PString);
Begin Chart.RegisterTeeSeries(ASeriesClass, ADescription); END;

(*----------------------------------------------------------------------------*)
Procedure RegisterTeeSeries_P( ASeriesClass : TChartSeriesClass; ADescription, AGalleryPage : PString; ANumGallerySeries : Integer);
Begin Chart.RegisterTeeSeries(ASeriesClass, ADescription, AGalleryPage, ANumGallerySeries); END;

(*----------------------------------------------------------------------------*)
Procedure TColorPalettesApplyPalette1_P(Self: TColorPalettes;  Chart : TCustomAxisPanel; const Palette : array of TColor);
Begin Self.ApplyPalette(Chart, Palette); END;

(*----------------------------------------------------------------------------*)
Procedure TColorPalettesApplyPalette_P(Self: TColorPalettes;  Chart : TCustomAxisPanel; Index : Integer);
Begin Self.ApplyPalette(Chart, Index); END;

(*----------------------------------------------------------------------------*)
procedure TTeeDragObjectPart_R(Self: TTeeDragObject; var T: TChartClickedPart);
begin T := Self.Part; end;

(*----------------------------------------------------------------------------*)
procedure TTeeToolTypesItems_R(Self: TTeeToolTypes; var T: TTeeCustomToolClass; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TTeeSeriesTypesItems_R(Self: TTeeSeriesTypes; var T: TTeeSeriesType; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartOnGetLegendText_W(Self: TCustomChart; const T: TOnGetLegendText);
begin Self.OnGetLegendText := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartOnGetLegendText_R(Self: TCustomChart; var T: TOnGetLegendText);
begin T := Self.OnGetLegendText; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartOnGetLegendRect_W(Self: TCustomChart; const T: TOnGetLegendRect);
begin Self.OnGetLegendRect := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartOnGetLegendRect_R(Self: TCustomChart; var T: TOnGetLegendRect);
begin T := Self.OnGetLegendRect; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartOnGetLegendPos_W(Self: TCustomChart; const T: TOnGetLegendPos);
begin Self.OnGetLegendPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartOnGetLegendPos_R(Self: TCustomChart; var T: TOnGetLegendPos);
begin T := Self.OnGetLegendPos; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartOnClickTitle_W(Self: TCustomChart; const T: TChartClickTitle);
begin Self.OnClickTitle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartOnClickTitle_R(Self: TCustomChart; var T: TChartClickTitle);
begin T := Self.OnClickTitle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartOnClickSeries_W(Self: TCustomChart; const T: TChartClickSeries);
begin Self.OnClickSeries := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartOnClickSeries_R(Self: TCustomChart; var T: TChartClickSeries);
begin T := Self.OnClickSeries; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartOnClickLegend_W(Self: TCustomChart; const T: TChartClick);
begin Self.OnClickLegend := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartOnClickLegend_R(Self: TCustomChart; var T: TChartClick);
begin T := Self.OnClickLegend; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartOnClickBackground_W(Self: TCustomChart; const T: TChartClick);
begin Self.OnClickBackground := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartOnClickBackground_R(Self: TCustomChart; var T: TChartClick);
begin T := Self.OnClickBackground; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartOnClickAxis_W(Self: TCustomChart; const T: TChartClickAxis);
begin Self.OnClickAxis := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartOnClickAxis_R(Self: TCustomChart; var T: TChartClickAxis);
begin T := Self.OnClickAxis; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartOnAllowScroll_W(Self: TCustomChart; const T: TChartAllowScrollEvent);
begin Self.OnAllowScroll := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartOnAllowScroll_R(Self: TCustomChart; var T: TChartAllowScrollEvent);
begin T := Self.OnAllowScroll; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartTitle_W(Self: TCustomChart; const T: TChartTitle);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartTitle_R(Self: TCustomChart; var T: TChartTitle);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartSubTitle_W(Self: TCustomChart; const T: TChartTitle);
begin Self.SubTitle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartSubTitle_R(Self: TCustomChart; var T: TChartTitle);
begin T := Self.SubTitle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartSubFoot_W(Self: TCustomChart; const T: TChartTitle);
begin Self.SubFoot := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartSubFoot_R(Self: TCustomChart; var T: TChartTitle);
begin T := Self.SubFoot; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartScrollMouseButton_W(Self: TCustomChart; const T: TMouseButton);
begin Self.ScrollMouseButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartScrollMouseButton_R(Self: TCustomChart; var T: TMouseButton);
begin T := Self.ScrollMouseButton; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartRightWall_W(Self: TCustomChart; const T: TChartRightWall);
begin Self.RightWall := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartRightWall_R(Self: TCustomChart; var T: TChartRightWall);
begin T := Self.RightWall; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegend_W(Self: TCustomChart; const T: TChartLegend);
begin Self.Legend := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegend_R(Self: TCustomChart; var T: TChartLegend);
begin T := Self.Legend; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLeftWall_W(Self: TCustomChart; const T: TChartLeftWall);
begin Self.LeftWall := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLeftWall_R(Self: TCustomChart; var T: TChartLeftWall);
begin T := Self.LeftWall; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartFoot_W(Self: TCustomChart; const T: TChartTitle);
begin Self.Foot := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartFoot_R(Self: TCustomChart; var T: TChartTitle);
begin T := Self.Foot; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartBottomWall_W(Self: TCustomChart; const T: TChartBottomWall);
begin Self.BottomWall := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartBottomWall_R(Self: TCustomChart; var T: TChartBottomWall);
begin T := Self.BottomWall; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartFrame_W(Self: TCustomChart; const T: TChartPen);
begin Self.Frame := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartFrame_R(Self: TCustomChart; var T: TChartPen);
begin T := Self.Frame; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartBackWall_W(Self: TCustomChart; const T: TChartBackWall);
begin Self.BackWall := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartBackWall_R(Self: TCustomChart; var T: TChartBackWall);
begin T := Self.BackWall; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartWalls_W(Self: TCustomChart; const T: TChartWalls);
begin Self.Walls := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartWalls_R(Self: TCustomChart; var T: TChartWalls);
begin T := Self.Walls; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartColorPaletteIndex_W(Self: TCustomChart; const T: Integer);
begin Self.ColorPaletteIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartColorPaletteIndex_R(Self: TCustomChart; var T: Integer);
begin T := Self.ColorPaletteIndex; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartBackColor_W(Self: TCustomChart; const T: TColor);
begin Self.BackColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartBackColor_R(Self: TCustomChart; var T: TColor);
begin T := Self.BackColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartFColorPaletteIndex_W(Self: TCustomChart; const T: Integer);
Begin //Self.FColorPaletteIndex := T;
 end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartFColorPaletteIndex_R(Self: TCustomChart; var T: Integer);
Begin //T := Self.FColorPaletteIndex;
end;

(*----------------------------------------------------------------------------*)
procedure TChartWallsVisible_W(Self: TChartWalls; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartWallsVisible_R(Self: TChartWalls; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TChartWallsSize_W(Self: TChartWalls; const T: Integer);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartWallsRight_W(Self: TChartWalls; const T: TChartRightWall);
begin Self.Right := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartWallsRight_R(Self: TChartWalls; var T: TChartRightWall);
begin T := Self.Right; end;

(*----------------------------------------------------------------------------*)
procedure TChartWallsLeft_W(Self: TChartWalls; const T: TChartLeftWall);
begin Self.Left := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartWallsLeft_R(Self: TChartWalls; var T: TChartLeftWall);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TChartWallsBottom_W(Self: TChartWalls; const T: TChartBottomWall);
begin Self.Bottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartWallsBottom_R(Self: TChartWalls; var T: TChartBottomWall);
begin T := Self.Bottom; end;

(*----------------------------------------------------------------------------*)
procedure TChartWallsBack_W(Self: TChartWalls; const T: TChartBackWall);
begin Self.Back := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartWallsBack_R(Self: TChartWalls; var T: TChartBackWall);
begin T := Self.Back; end;

(*----------------------------------------------------------------------------*)
procedure TChartTitleVertMargin_W(Self: TChartTitle; const T: Integer);
begin Self.VertMargin := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartTitleVertMargin_R(Self: TChartTitle; var T: Integer);
begin T := Self.VertMargin; end;

(*----------------------------------------------------------------------------*)
procedure TChartTitleText_W(Self: TChartTitle; const T: TStrings);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartTitleText_R(Self: TChartTitle; var T: TStrings);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TChartTitleAlignment_W(Self: TChartTitle; const T: TAlignment);
begin Self.Alignment := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartTitleAlignment_R(Self: TChartTitle; var T: TAlignment);
begin T := Self.Alignment; end;

(*----------------------------------------------------------------------------*)
procedure TChartTitleAdjustFrame_W(Self: TChartTitle; const T: Boolean);
begin Self.AdjustFrame := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartTitleAdjustFrame_R(Self: TChartTitle; var T: Boolean);
begin T := Self.AdjustFrame; end;

(*----------------------------------------------------------------------------*)
procedure TChartTitleTitleRect_R(Self: TChartTitle; var T: TRect);
begin T := Self.TitleRect; end;

(*----------------------------------------------------------------------------*)
procedure TChartTitleCaption_W(Self: TChartTitle; const T: String);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartTitleCaption_R(Self: TChartTitle; var T: String);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendVertSpacing_W(Self: TCustomChartLegend; const T: Integer);
begin Self.VertSpacing := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendVertSpacing_R(Self: TCustomChartLegend; var T: Integer);
begin T := Self.VertSpacing; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendVertMargin_W(Self: TCustomChartLegend; const T: Integer);
begin Self.VertMargin := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendVertMargin_R(Self: TCustomChartLegend; var T: Integer);
begin T := Self.VertMargin; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendTopPos_W(Self: TCustomChartLegend; const T: Integer);
begin Self.TopPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendTopPos_R(Self: TCustomChartLegend; var T: Integer);
begin T := Self.TopPos; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendTopPercent_W(Self: TCustomChartLegend; const T: Integer);
begin Self.TopPercent := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendTopPercent_R(Self: TCustomChartLegend; var T: Integer);
begin T := Self.TopPercent; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendTitle_W(Self: TCustomChartLegend; const T: TLegendTitle);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendTitle_R(Self: TCustomChartLegend; var T: TLegendTitle);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendTextStyle_W(Self: TCustomChartLegend; const T: TLegendTextStyle);
begin Self.TextStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendTextStyle_R(Self: TCustomChartLegend; var T: TLegendTextStyle);
begin T := Self.TextStyle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendSymbol_W(Self: TCustomChartLegend; const T: TLegendSymbol);
begin Self.Symbol := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendSymbol_R(Self: TCustomChartLegend; var T: TLegendSymbol);
begin T := Self.Symbol; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendSeries_W(Self: TCustomChartLegend; const T: TChartSeries);
begin Self.Series := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendSeries_R(Self: TCustomChartLegend; var T: TChartSeries);
begin T := Self.Series; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendResizeChart_W(Self: TCustomChartLegend; const T: Boolean);
begin Self.ResizeChart := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendResizeChart_R(Self: TCustomChartLegend; var T: Boolean);
begin T := Self.ResizeChart; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendPositionUnits_W(Self: TCustomChartLegend; const T: TTeeUnits);
begin Self.PositionUnits := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendPositionUnits_R(Self: TCustomChartLegend; var T: TTeeUnits);
begin T := Self.PositionUnits; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendMaxNumRows_W(Self: TCustomChartLegend; const T: Integer);
begin Self.MaxNumRows := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendMaxNumRows_R(Self: TCustomChartLegend; var T: Integer);
begin T := Self.MaxNumRows; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendLegendStyle_W(Self: TCustomChartLegend; const T: TLegendStyle);
begin Self.LegendStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendLegendStyle_R(Self: TCustomChartLegend; var T: TLegendStyle);
begin T := Self.LegendStyle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendLeftPercent_W(Self: TCustomChartLegend; const T: Integer);
begin Self.LeftPercent := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendLeftPercent_R(Self: TCustomChartLegend; var T: Integer);
begin T := Self.LeftPercent; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendLastValue_R(Self: TCustomChartLegend; var T: Integer);
begin T := Self.LastValue; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendItems_R(Self: TCustomChartLegend; var T: TLegendItems);
begin T := Self.Items; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendItem_R(Self: TCustomChartLegend; var T: TLegendItem; const t1: Integer);
begin T := Self.Item[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendInverted_W(Self: TCustomChartLegend; const T: Boolean);
begin Self.Inverted := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendInverted_R(Self: TCustomChartLegend; var T: Boolean);
begin T := Self.Inverted; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendHorizMargin_W(Self: TCustomChartLegend; const T: Integer);
begin Self.HorizMargin := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendHorizMargin_R(Self: TCustomChartLegend; var T: Integer);
begin T := Self.HorizMargin; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendFontSeriesColor_W(Self: TCustomChartLegend; const T: Boolean);
begin Self.FontSeriesColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendFontSeriesColor_R(Self: TCustomChartLegend; var T: Boolean);
begin T := Self.FontSeriesColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendFirstValue_W(Self: TCustomChartLegend; const T: Integer);
begin Self.FirstValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendFirstValue_R(Self: TCustomChartLegend; var T: Integer);
begin T := Self.FirstValue; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendDividingLines_W(Self: TCustomChartLegend; const T: TChartHiddenPen);
begin Self.DividingLines := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendDividingLines_R(Self: TCustomChartLegend; var T: TChartHiddenPen);
begin T := Self.DividingLines; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendCurrentPage_W(Self: TCustomChartLegend; const T: Boolean);
begin Self.CurrentPage := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendCurrentPage_R(Self: TCustomChartLegend; var T: Boolean);
begin T := Self.CurrentPage; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendColorWidth_W(Self: TCustomChartLegend; const T: Integer);
begin Self.ColorWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendColorWidth_R(Self: TCustomChartLegend; var T: Integer);
begin T := Self.ColorWidth; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendCheckBoxesStyle_W(Self: TCustomChartLegend; const T: TCheckBoxesStyle);
begin Self.CheckBoxesStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendCheckBoxesStyle_R(Self: TCustomChartLegend; var T: TCheckBoxesStyle);
begin T := Self.CheckBoxesStyle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendCheckBoxes_W(Self: TCustomChartLegend; const T: Boolean);
begin Self.CheckBoxes := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendCheckBoxes_R(Self: TCustomChartLegend; var T: Boolean);
begin T := Self.CheckBoxes; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendAlignment_W(Self: TCustomChartLegend; const T: TLegendAlignment);
begin Self.Alignment := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendAlignment_R(Self: TCustomChartLegend; var T: TLegendAlignment);
begin T := Self.Alignment; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendVertical_R(Self: TCustomChartLegend; var T: Boolean);
begin T := Self.Vertical; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendRectLegend_R(Self: TCustomChartLegend; var T: TRect);
begin T := Self.RectLegend; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendTotalLegendItems_R(Self: TCustomChartLegend; var T: Integer);
begin T := Self.TotalLegendItems; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendColumnWidths_W(Self: TCustomChartLegend; const T: integer);
Begin //Self.ColumnWidths := T;
end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendColumnWidths_R(Self: TCustomChartLegend; var T: integer);
Begin //T := Self.ColumnWidths;
end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendColumnWidthAuto_W(Self: TCustomChartLegend; const T: Boolean);
Begin Self.ColumnWidthAuto := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendColumnWidthAuto_R(Self: TCustomChartLegend; var T: Boolean);
Begin T := Self.ColumnWidthAuto; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendNumRows_W(Self: TCustomChartLegend; const T: Integer);
Begin Self.NumRows := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendNumRows_R(Self: TCustomChartLegend; var T: Integer);
Begin T := Self.NumRows; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendNumCols_W(Self: TCustomChartLegend; const T: Integer);
Begin Self.NumCols := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartLegendNumCols_R(Self: TCustomChartLegend; var T: Integer);
Begin T := Self.NumCols; end;

(*----------------------------------------------------------------------------*)
procedure TLegendItemsItems_R(Self: TLegendItems; var T: TLegendItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLegendItemsCustom_W(Self: TLegendItems; const T: Boolean);
begin Self.Custom := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendItemsCustom_R(Self: TLegendItems; var T: Boolean);
begin T := Self.Custom; end;

(*----------------------------------------------------------------------------*)
procedure TLegendItemTop_R(Self: TLegendItem; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TLegendItemText2_W(Self: TLegendItem; const T: String);
begin Self.Text2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendItemText2_R(Self: TLegendItem; var T: String);
begin T := Self.Text2; end;

(*----------------------------------------------------------------------------*)
procedure TLegendItemText_W(Self: TLegendItem; const T: String);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendItemText_R(Self: TLegendItem; var T: String);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TLegendItemLeft_R(Self: TLegendItem; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TLegendItemAlign_R(Self: TLegendItem; var T: Integer);
begin T := Self.Align; end;

(*----------------------------------------------------------------------------*)
procedure TLegendItemSymbolRect_W(Self: TLegendItem; const T: TRect);
begin Self.SymbolRect := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendItemSymbolRect_R(Self: TLegendItem; var T: TRect);
begin T := Self.SymbolRect; end;

(*----------------------------------------------------------------------------*)
procedure TLegendTitleTextAlignment_W(Self: TLegendTitle; const T: TAlignment);
begin Self.TextAlignment := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendTitleTextAlignment_R(Self: TLegendTitle; var T: TAlignment);
begin T := Self.TextAlignment; end;

(*----------------------------------------------------------------------------*)
procedure TLegendTitleText_W(Self: TLegendTitle; const T: TStringList);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendTitleText_R(Self: TLegendTitle; var T: TStringList);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TLegendTitleCaption_W(Self: TLegendTitle; const T: String);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendTitleCaption_R(Self: TLegendTitle; var T: String);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapePositionTop_W(Self: TTeeCustomShapePosition; const T: Integer);
begin Self.Top := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapePositionTop_R(Self: TTeeCustomShapePosition; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapePositionLeft_W(Self: TTeeCustomShapePosition; const T: Integer);
begin Self.Left := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapePositionLeft_R(Self: TTeeCustomShapePosition; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapePositionCustomPosition_W(Self: TTeeCustomShapePosition; const T: Boolean);
begin Self.CustomPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapePositionCustomPosition_R(Self: TTeeCustomShapePosition; var T: Boolean);
begin T := Self.CustomPosition; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapePositionDefaultCustom_W(Self: TTeeCustomShapePosition; const T: Boolean);
Begin //Self.DefaultCustom := T;
end;

(*----------------------------------------------------------------------------*)
procedure TTeeCustomShapePositionDefaultCustom_R(Self: TTeeCustomShapePosition; var T: Boolean);
Begin //T := Self.DefaultCustom;
end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolOnDraw_W(Self: TLegendSymbol; const T: TSymbolDrawEvent);
begin Self.OnDraw := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolOnDraw_R(Self: TLegendSymbol; var T: TSymbolDrawEvent);
begin T := Self.OnDraw; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolWidthUnits_W(Self: TLegendSymbol; const T: TLegendSymbolSize);
begin Self.WidthUnits := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolWidthUnits_R(Self: TLegendSymbol; var T: TLegendSymbolSize);
begin T := Self.WidthUnits; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolWidth_W(Self: TLegendSymbol; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolWidth_R(Self: TLegendSymbol; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolVisible_W(Self: TLegendSymbol; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolVisible_R(Self: TLegendSymbol; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolSquared_W(Self: TLegendSymbol; const T: Boolean);
begin Self.Squared := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolSquared_R(Self: TLegendSymbol; var T: Boolean);
begin T := Self.Squared; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolShadow_W(Self: TLegendSymbol; const T: TTeeShadow);
begin Self.Shadow := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolShadow_R(Self: TLegendSymbol; var T: TTeeShadow);
begin T := Self.Shadow; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolPosition_W(Self: TLegendSymbol; const T: TLegendSymbolPosition);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolPosition_R(Self: TLegendSymbol; var T: TLegendSymbolPosition);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolPen_W(Self: TLegendSymbol; const T: TChartPen);
begin Self.Pen := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolPen_R(Self: TLegendSymbol; var T: TChartPen);
begin T := Self.Pen; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolGradient_W(Self: TLegendSymbol; const T: TTeeGradient);
begin Self.Gradient := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolGradient_R(Self: TLegendSymbol; var T: TTeeGradient);
begin T := Self.Gradient; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolDefaultPen_W(Self: TLegendSymbol; const T: Boolean);
begin Self.DefaultPen := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolDefaultPen_R(Self: TLegendSymbol; var T: Boolean);
begin T := Self.DefaultPen; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolContinuous_W(Self: TLegendSymbol; const T: Boolean);
begin Self.Continuous := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolContinuous_R(Self: TLegendSymbol; var T: Boolean);
begin T := Self.Continuous; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolParent_W(Self: TLegendSymbol; const T: TCustomTeePanel);
Begin Self.Parent := T; end;

(*----------------------------------------------------------------------------*)
procedure TLegendSymbolParent_R(Self: TLegendSymbol; var T: TCustomTeePanel);
Begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartWallStartPosition_W(Self: TCustomChartWall; const T: Integer);
begin Self.StartPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartWallStartPosition_R(Self: TCustomChartWall; var T: Integer);
begin T := Self.StartPosition; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartWallSize_W(Self: TCustomChartWall; const T: Integer);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartWallSize_R(Self: TCustomChartWall; var T: Integer);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartWallPen_W(Self: TCustomChartWall; const T: TChartPen);
begin Self.Pen := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartWallPen_R(Self: TCustomChartWall; var T: TChartPen);
begin T := Self.Pen; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartWallEndPosition_W(Self: TCustomChartWall; const T: Integer);
begin Self.EndPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartWallEndPosition_R(Self: TCustomChartWall; var T: Integer);
begin T := Self.EndPosition; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartWallDark3D_W(Self: TCustomChartWall; const T: Boolean);
begin Self.Dark3D := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartWallDark3D_R(Self: TCustomChartWall; var T: Boolean);
begin T := Self.Dark3D; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartWallAutoHide_W(Self: TCustomChartWall; const T: Boolean);
begin Self.AutoHide := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomChartWallAutoHide_R(Self: TCustomChartWall; var T: Boolean);
begin T := Self.AutoHide; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartTheme(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartTheme) do begin
    RegisterPropertyHelper(@TChartThemeChart_R,@TChartThemeChart_W,'Chart');
    RegisterVirtualConstructor(@TChartThemeCreate_P, 'Create');
    RegisterVirtualMethod(@TChartTheme.Apply, 'Apply');
    RegisterVirtualMethod(@TChartTheme.Description, 'Description');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Chart_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@RegisterTeeSeries, 'RegisterTeeSeries', cdRegister);
 S.RegisterDelphiFunction(@RegisterTeeSeries1_P, 'RegisterTeeSeries1', cdRegister);
 S.RegisterDelphiFunction(@RegisterTeeFunction, 'RegisterTeeFunction', cdRegister);
 S.RegisterDelphiFunction(@RegisterTeeBasicFunction, 'RegisterTeeBasicFunction', cdRegister);
 S.RegisterDelphiFunction(@RegisterTeeSeriesFunction, 'RegisterTeeSeriesFunction', cdRegister);
 S.RegisterDelphiFunction(@UnRegisterTeeSeries, 'UnRegisterTeeSeries', cdRegister);
 S.RegisterDelphiFunction(@UnRegisterTeeFunctions, 'UnRegisterTeeFunctions', cdRegister);
 S.RegisterDelphiFunction(@AssignSeries, 'AssignSeries', cdRegister);
 S.RegisterDelphiFunction(@CreateNewTeeFunction, 'CreateNewTeeFunction', cdRegister);
 S.RegisterDelphiFunction(@CreateNewSeries, 'CreateNewSeries', cdRegister);
 S.RegisterDelphiFunction(@CloneChartSeries, 'CloneChartSeries', cdRegister);
 S.RegisterDelphiFunction(@CloneChartSeries1_P, 'CloneChartSeries1', cdRegister);
 S.RegisterDelphiFunction(@CloneChartSeries2_P, 'CloneChartSeries2', cdRegister);
 S.RegisterDelphiFunction(@CloneChartTool, 'CloneChartTool', cdRegister);
 S.RegisterDelphiFunction(@ChangeSeriesType, 'ChangeSeriesType', cdRegister);
 S.RegisterDelphiFunction(@ChangeAllSeriesType, 'ChangeAllSeriesType', cdRegister);
 S.RegisterDelphiFunction(@GetNewSeriesName, 'GetNewSeriesName', cdRegister);
 S.RegisterDelphiFunction(@RegisterTeeTools, 'RegisterTeeTools', cdRegister);
 S.RegisterDelphiFunction(@UnRegisterTeeTools, 'UnRegisterTeeTools', cdRegister);
 S.RegisterDelphiFunction(@GetGallerySeriesName, 'GetGallerySeriesName', cdRegister);
 S.RegisterDelphiFunction(@PaintSeriesLegend, 'PaintSeriesLegend', cdRegister);
  //RIRegister_TChartTheme(CL);
  
 S.RegisterDelphiFunction(@SetAlias, 'SetAlias', cdRegister);
 S.RegisterDelphiFunction(@CheckRegistryEntry, 'CheckRegistryEntry', cdRegister);
 S.RegisterDelphiFunction(@GetFileVersionNumber, 'GetFileVersionNumber', cdRegister);
 S.RegisterDelphiFunction(@SetBDE, 'SetBDE', cdRegister);
 S.RegisterDelphiFunction(@RestartDialog, 'RestartDialog', cdRegister);
  S.RegisterDelphiFunction(@GetSystemDirectory, 'GetSystemDirectory', CdStdCall);
  S.RegisterDelphiFunction(@GetSystemDirectory, 'GetSystemDirectoryW', CdStdCall);
 S.RegisterDelphiFunction(@GetTempPath, 'GetTempPath', CdStdCall);
 S.RegisterDelphiFunction(@GetWindowsDirectoryW, 'GetWindowsDirectoryW', CdStdCall);
 S.RegisterDelphiFunction(@GetTempFileName, 'GetTempFileName', CdStdCall);
 S.RegisterDelphiFunction(@HtmlTextOut, 'HtmlTextOut', cdRegister);
 S.RegisterDelphiFunction(@HtmlTextExtent, 'HtmlTextExtent', cdRegister);


end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TColorPalettes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TColorPalettes) do
  begin
    RegisterMethod(@TColorPalettes.AddTo, 'AddTo');
    RegisterMethod(@TColorPalettesApplyPalette_P, 'ApplyPalette');
    RegisterMethod(@TColorPalettesApplyPalette1_P, 'ApplyPalette1');
  end;
  RIRegister_TChartTheme(CL);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeDragObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeDragObject) do
  begin
    RegisterConstructor(@TTeeDragObject.Create, 'Create');
    RegisterPropertyHelper(@TTeeDragObjectPart_R,nil,'Part');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeToolTypes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeToolTypes) do
  begin
    RegisterPropertyHelper(@TTeeToolTypesItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeSeriesTypes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeSeriesTypes) do
  begin
    RegisterMethod(@TTeeSeriesTypes.Clear, 'Clear');
    RegisterMethod(@TTeeSeriesTypes.Find, 'Find');
    RegisterPropertyHelper(@TTeeSeriesTypesItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChart(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChart) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomChart(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomChart) do begin
    RegisterPropertyHelper(@TCustomChartFColorPaletteIndex_R,@TCustomChartFColorPaletteIndex_W,'FColorPaletteIndex');
    RegisterConstructor(@TCustomChart.Create, 'Create');
    RegisterMethod(@TCustomChart.Destroy, 'Free');
   RegisterMethod(@TCustomChart.Assign, 'Assign');
    RegisterMethod(@TCustomChart.AxisTitleOrName, 'AxisTitleOrName');
    RegisterMethod(@TCustomChart.CalcClickedPart, 'CalcClickedPart');
    //RegisterMethod(@TCustomChart.DrawLeftWallFirst, 'DrawLeftWallFirst');
    //RegisterMethod(@TCustomChart.DrawRightWallAfter, 'DrawRightWallAfter');
    RegisterVirtualMethod(@TCustomChart.FillSeriesSourceItems, 'FillSeriesSourceItems');
    RegisterVirtualMethod(@TCustomChart.FillValueSourceItems, 'FillValueSourceItems');
    RegisterMethod(@TCustomChart.GetASeries, 'GetASeries');
    RegisterMethod(@TCustomChart.NextPage, 'NextPage');
    RegisterMethod(@TCustomChart.PreviousPage, 'PreviousPage');
    RegisterMethod(@TCustomChart.RemoveAllSeries, 'RemoveAllSeries');
    RegisterMethod(@TCustomChart.SeriesDown, 'SeriesDown');
    RegisterMethod(@TCustomChart.SeriesUp, 'SeriesUp');
    RegisterMethod(@TCustomChart.ZoomPercent, 'ZoomPercent');
    RegisterMethod(@TCustomChart.ZoomRect, 'ZoomRect');
    RegisterMethod(@TCustomChart.FormattedLegend, 'FormattedLegend');
    RegisterPropertyHelper(@TCustomChartBackColor_R,@TCustomChartBackColor_W,'BackColor');
    RegisterPropertyHelper(@TCustomChartColorPaletteIndex_R,@TCustomChartColorPaletteIndex_W,'ColorPaletteIndex');
    RegisterPropertyHelper(@TCustomChartWalls_R,@TCustomChartWalls_W,'Walls');
    RegisterPropertyHelper(@TCustomChartBackWall_R,@TCustomChartBackWall_W,'BackWall');
    RegisterPropertyHelper(@TCustomChartFrame_R,@TCustomChartFrame_W,'Frame');
    RegisterPropertyHelper(@TCustomChartBottomWall_R,@TCustomChartBottomWall_W,'BottomWall');
    RegisterPropertyHelper(@TCustomChartFoot_R,@TCustomChartFoot_W,'Foot');
    RegisterPropertyHelper(@TCustomChartLeftWall_R,@TCustomChartLeftWall_W,'LeftWall');
    RegisterPropertyHelper(@TCustomChartLegend_R,@TCustomChartLegend_W,'Legend');
    RegisterPropertyHelper(@TCustomChartRightWall_R,@TCustomChartRightWall_W,'RightWall');
    RegisterPropertyHelper(@TCustomChartScrollMouseButton_R,@TCustomChartScrollMouseButton_W,'ScrollMouseButton');
    RegisterPropertyHelper(@TCustomChartSubFoot_R,@TCustomChartSubFoot_W,'SubFoot');
    RegisterPropertyHelper(@TCustomChartSubTitle_R,@TCustomChartSubTitle_W,'SubTitle');
    RegisterPropertyHelper(@TCustomChartTitle_R,@TCustomChartTitle_W,'Title');
    RegisterPropertyHelper(@TCustomChartOnAllowScroll_R,@TCustomChartOnAllowScroll_W,'OnAllowScroll');
    RegisterPropertyHelper(@TCustomChartOnClickAxis_R,@TCustomChartOnClickAxis_W,'OnClickAxis');
    RegisterPropertyHelper(@TCustomChartOnClickBackground_R,@TCustomChartOnClickBackground_W,'OnClickBackground');
    RegisterPropertyHelper(@TCustomChartOnClickLegend_R,@TCustomChartOnClickLegend_W,'OnClickLegend');
    RegisterPropertyHelper(@TCustomChartOnClickSeries_R,@TCustomChartOnClickSeries_W,'OnClickSeries');
    RegisterPropertyHelper(@TCustomChartOnClickTitle_R,@TCustomChartOnClickTitle_W,'OnClickTitle');
    RegisterPropertyHelper(@TCustomChartOnGetLegendPos_R,@TCustomChartOnGetLegendPos_W,'OnGetLegendPos');
    RegisterPropertyHelper(@TCustomChartOnGetLegendRect_R,@TCustomChartOnGetLegendRect_W,'OnGetLegendRect');
    RegisterPropertyHelper(@TCustomChartOnGetLegendText_R,@TCustomChartOnGetLegendText_W,'OnGetLegendText');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartWalls(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartWalls) do begin
    RegisterConstructor(@TChartWalls.Create, 'Create');
    RegisterMethod(@TChartWalls.Assign, 'Assign');
    RegisterPropertyHelper(@TChartWallsBack_R,@TChartWallsBack_W,'Back');
    RegisterPropertyHelper(@TChartWallsBottom_R,@TChartWallsBottom_W,'Bottom');
    RegisterPropertyHelper(@TChartWallsLeft_R,@TChartWallsLeft_W,'Left');
    RegisterPropertyHelper(@TChartWallsRight_R,@TChartWallsRight_W,'Right');
    RegisterPropertyHelper(nil,@TChartWallsSize_W,'Size');
    RegisterPropertyHelper(@TChartWallsVisible_R,@TChartWallsVisible_W,'Visible');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartLeftWall(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartLeftWall) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartBottomWall(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartBottomWall) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartRightWall(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartRightWall) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartBackWall(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartBackWall) do
  begin
    RegisterConstructor(@TChartBackWall.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartFootTitle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartFootTitle) do
  begin
    RegisterConstructor(@TChartFootTitle.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartTitle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartTitle) do begin
    RegisterConstructor(@TChartTitle.Create, 'Create');
    RegisterMethod(@TChartTitle.Assign, 'Assign');
    RegisterMethod(@TChartTitle.Clear, 'Clear');
    RegisterMethod(@TChartTitle.Clicked, 'Clicked');
    RegisterMethod(@TChartTitle.DrawTitle, 'DrawTitle');
    RegisterPropertyHelper(@TChartTitleCaption_R,@TChartTitleCaption_W,'Caption');
    RegisterPropertyHelper(@TChartTitleTitleRect_R,nil,'TitleRect');
    RegisterPropertyHelper(@TChartTitleAdjustFrame_R,@TChartTitleAdjustFrame_W,'AdjustFrame');
    RegisterPropertyHelper(@TChartTitleAlignment_R,@TChartTitleAlignment_W,'Alignment');
    RegisterPropertyHelper(@TChartTitleText_R,@TChartTitleText_W,'Text');
    RegisterPropertyHelper(@TChartTitleVertMargin_R,@TChartTitleVertMargin_W,'VertMargin');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartLegend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartLegend) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomChartLegend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomChartLegend) do begin
    RegisterPropertyHelper(@TCustomChartLegendNumCols_R,@TCustomChartLegendNumCols_W,'NumCols');
    RegisterPropertyHelper(@TCustomChartLegendNumRows_R,@TCustomChartLegendNumRows_W,'NumRows');
    RegisterPropertyHelper(@TCustomChartLegendColumnWidthAuto_R,@TCustomChartLegendColumnWidthAuto_W,'ColumnWidthAuto');
    RegisterPropertyHelper(@TCustomChartLegendColumnWidths_R,@TCustomChartLegendColumnWidths_W,'ColumnWidths');
    RegisterConstructor(@TCustomChartLegend.Create, 'Create');
    RegisterMethod(@TCustomChartLegend.Assign, 'Assign');
    RegisterMethod(@TCustomChartLegend.Clicked, 'Clicked');
    RegisterMethod(@TCustomChartLegend.DrawLegend, 'DrawLegend');
    RegisterMethod(@TCustomChartLegend.FormattedValue, 'FormattedValue');
    RegisterMethod(@TCustomChartLegend.FormattedLegend, 'FormattedLegend');
    RegisterMethod(@TCustomChartLegend.ShouldDraw, 'ShouldDraw');
    RegisterPropertyHelper(@TCustomChartLegendTotalLegendItems_R,nil,'TotalLegendItems');
    RegisterPropertyHelper(@TCustomChartLegendRectLegend_R,nil,'RectLegend');
    RegisterPropertyHelper(@TCustomChartLegendVertical_R,nil,'Vertical');
    RegisterPropertyHelper(@TCustomChartLegendAlignment_R,@TCustomChartLegendAlignment_W,'Alignment');
    RegisterPropertyHelper(@TCustomChartLegendCheckBoxes_R,@TCustomChartLegendCheckBoxes_W,'CheckBoxes');
    RegisterPropertyHelper(@TCustomChartLegendCheckBoxesStyle_R,@TCustomChartLegendCheckBoxesStyle_W,'CheckBoxesStyle');
    RegisterPropertyHelper(@TCustomChartLegendColorWidth_R,@TCustomChartLegendColorWidth_W,'ColorWidth');
    RegisterPropertyHelper(@TCustomChartLegendCurrentPage_R,@TCustomChartLegendCurrentPage_W,'CurrentPage');
    RegisterPropertyHelper(@TCustomChartLegendDividingLines_R,@TCustomChartLegendDividingLines_W,'DividingLines');
    RegisterPropertyHelper(@TCustomChartLegendFirstValue_R,@TCustomChartLegendFirstValue_W,'FirstValue');
    RegisterPropertyHelper(@TCustomChartLegendFontSeriesColor_R,@TCustomChartLegendFontSeriesColor_W,'FontSeriesColor');
    RegisterPropertyHelper(@TCustomChartLegendHorizMargin_R,@TCustomChartLegendHorizMargin_W,'HorizMargin');
    RegisterPropertyHelper(@TCustomChartLegendInverted_R,@TCustomChartLegendInverted_W,'Inverted');
    RegisterPropertyHelper(@TCustomChartLegendItem_R,nil,'Item');
    RegisterPropertyHelper(@TCustomChartLegendItems_R,nil,'Items');
    RegisterPropertyHelper(@TCustomChartLegendLastValue_R,nil,'LastValue');
    RegisterPropertyHelper(@TCustomChartLegendLeftPercent_R,@TCustomChartLegendLeftPercent_W,'LeftPercent');
    RegisterPropertyHelper(@TCustomChartLegendLegendStyle_R,@TCustomChartLegendLegendStyle_W,'LegendStyle');
    RegisterPropertyHelper(@TCustomChartLegendMaxNumRows_R,@TCustomChartLegendMaxNumRows_W,'MaxNumRows');
    RegisterPropertyHelper(@TCustomChartLegendPositionUnits_R,@TCustomChartLegendPositionUnits_W,'PositionUnits');
    RegisterPropertyHelper(@TCustomChartLegendResizeChart_R,@TCustomChartLegendResizeChart_W,'ResizeChart');
    RegisterPropertyHelper(@TCustomChartLegendSeries_R,@TCustomChartLegendSeries_W,'Series');
    RegisterPropertyHelper(@TCustomChartLegendSymbol_R,@TCustomChartLegendSymbol_W,'Symbol');
    RegisterPropertyHelper(@TCustomChartLegendTextStyle_R,@TCustomChartLegendTextStyle_W,'TextStyle');
    RegisterPropertyHelper(@TCustomChartLegendTitle_R,@TCustomChartLegendTitle_W,'Title');
    RegisterPropertyHelper(@TCustomChartLegendTopPercent_R,@TCustomChartLegendTopPercent_W,'TopPercent');
    RegisterPropertyHelper(@TCustomChartLegendTopPos_R,@TCustomChartLegendTopPos_W,'TopPos');
    RegisterPropertyHelper(@TCustomChartLegendVertMargin_R,@TCustomChartLegendVertMargin_W,'VertMargin');
    RegisterPropertyHelper(@TCustomChartLegendVertSpacing_R,@TCustomChartLegendVertSpacing_W,'VertSpacing');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLegendItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLegendItems) do begin
    RegisterMethod(@TLegendItems.Clear, 'Clear');
    RegisterPropertyHelper(@TLegendItemsCustom_R,@TLegendItemsCustom_W,'Custom');
    RegisterPropertyHelper(@TLegendItemsItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLegendItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLegendItem) do begin
    RegisterPropertyHelper(@TLegendItemSymbolRect_R,@TLegendItemSymbolRect_W,'SymbolRect');
    RegisterPropertyHelper(@TLegendItemAlign_R,nil,'Align');
    RegisterPropertyHelper(@TLegendItemLeft_R,nil,'Left');
    RegisterPropertyHelper(@TLegendItemText_R,@TLegendItemText_W,'Text');
    RegisterPropertyHelper(@TLegendItemText2_R,@TLegendItemText2_W,'Text2');
    RegisterPropertyHelper(@TLegendItemTop_R,nil,'Top');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLegendTitle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLegendTitle) do begin
    RegisterConstructor(@TLegendTitle.Create, 'Create');
    RegisterMethod(@TLegendTitle.Assign, 'Assign');
    RegisterPropertyHelper(@TLegendTitleCaption_R,@TLegendTitleCaption_W,'Caption');
    RegisterPropertyHelper(@TLegendTitleText_R,@TLegendTitleText_W,'Text');
    RegisterPropertyHelper(@TLegendTitleTextAlignment_R,@TLegendTitleTextAlignment_W,'TextAlignment');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeCustomShapePosition(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeCustomShapePosition) do begin
    RegisterPropertyHelper(@TTeeCustomShapePositionDefaultCustom_R,@TTeeCustomShapePositionDefaultCustom_W,'DefaultCustom');
    RegisterMethod(@TTeeCustomShapePosition.Assign, 'Assign');
    RegisterPropertyHelper(@TTeeCustomShapePositionCustomPosition_R,@TTeeCustomShapePositionCustomPosition_W,'CustomPosition');
    RegisterPropertyHelper(@TTeeCustomShapePositionLeft_R,@TTeeCustomShapePositionLeft_W,'Left');
    RegisterPropertyHelper(@TTeeCustomShapePositionTop_R,@TTeeCustomShapePositionTop_W,'Top');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLegendSymbol(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLegendSymbol) do begin
    RegisterPropertyHelper(@TLegendSymbolParent_R,@TLegendSymbolParent_W,'Parent');
    RegisterConstructor(@TLegendSymbol.Create, 'Create');
    RegisterMethod(@TLegendSymbol.Assign, 'Assign');
    RegisterPropertyHelper(@TLegendSymbolContinuous_R,@TLegendSymbolContinuous_W,'Continuous');
    RegisterPropertyHelper(@TLegendSymbolDefaultPen_R,@TLegendSymbolDefaultPen_W,'DefaultPen');
    RegisterPropertyHelper(@TLegendSymbolGradient_R,@TLegendSymbolGradient_W,'Gradient');
    RegisterPropertyHelper(@TLegendSymbolPen_R,@TLegendSymbolPen_W,'Pen');
    RegisterPropertyHelper(@TLegendSymbolPosition_R,@TLegendSymbolPosition_W,'Position');
    RegisterPropertyHelper(@TLegendSymbolShadow_R,@TLegendSymbolShadow_W,'Shadow');
    RegisterPropertyHelper(@TLegendSymbolSquared_R,@TLegendSymbolSquared_W,'Squared');
    RegisterPropertyHelper(@TLegendSymbolVisible_R,@TLegendSymbolVisible_W,'Visible');
    RegisterPropertyHelper(@TLegendSymbolWidth_R,@TLegendSymbolWidth_W,'Width');
    RegisterPropertyHelper(@TLegendSymbolWidthUnits_R,@TLegendSymbolWidthUnits_W,'WidthUnits');
    RegisterPropertyHelper(@TLegendSymbolOnDraw_R,@TLegendSymbolOnDraw_W,'OnDraw');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartLegendGradient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartLegendGradient) do
  begin
    RegisterConstructor(@TChartLegendGradient.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartWall(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartWall) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomChartWall(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomChartWall) do begin
    RegisterConstructor(@TCustomChartWall.Create, 'Create');
    RegisterMethod(@TCustomChartWall.Assign, 'Assign');
    RegisterPropertyHelper(@TCustomChartWallAutoHide_R,@TCustomChartWallAutoHide_W,'AutoHide');
    RegisterPropertyHelper(@TCustomChartWallDark3D_R,@TCustomChartWallDark3D_W,'Dark3D');
    RegisterPropertyHelper(@TCustomChartWallEndPosition_R,@TCustomChartWallEndPosition_W,'EndPosition');
    RegisterPropertyHelper(@TCustomChartWallPen_R,@TCustomChartWallPen_W,'Pen');
    RegisterPropertyHelper(@TCustomChartWallSize_R,@TCustomChartWallSize_W,'Size');
    RegisterPropertyHelper(@TCustomChartWallStartPosition_R,@TCustomChartWallStartPosition_W,'StartPosition');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Chart(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCustomChartWall(CL);
  RIRegister_TChartWall(CL);
  RIRegister_TChartLegendGradient(CL);
  with CL.Add(LegendException) do
  with CL.Add(TCustomChartLegend) do
  RIRegister_TLegendSymbol(CL);
  RIRegister_TTeeCustomShapePosition(CL);
  RIRegister_TLegendTitle(CL);
  RIRegister_TLegendItem(CL);
  RIRegister_TLegendItems(CL);
  with CL.Add(TCustomChart) do
  RIRegister_TCustomChartLegend(CL);
  RIRegister_TChartLegend(CL);
  RIRegister_TChartTitle(CL);
  RIRegister_TChartFootTitle(CL);
  RIRegister_TChartBackWall(CL);
  RIRegister_TChartRightWall(CL);
  RIRegister_TChartBottomWall(CL);
  RIRegister_TChartLeftWall(CL);
  RIRegister_TChartWalls(CL);
  RIRegister_TCustomChart(CL);
  RIRegister_TChart(CL);
  RIRegister_TTeeSeriesTypes(CL);
  RIRegister_TTeeToolTypes(CL);
  RIRegister_TTeeDragObject(CL);
  RIRegister_TColorPalettes(CL);
end;

 
 
{ TPSImport_Chart }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Chart.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Chart(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Chart.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Chart(ri);
  RIRegister_Chart_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
