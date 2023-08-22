{*******************************************}
{ TeeChart Pro Constants                    }
{ Copyright (c) 1995-2007 by David Berneda  }
{         All Rights Reserved               }
{*******************************************}
unit TeeConst;
{$I TeeDefs.inc}

interface

uses Classes;

var
   TeeMsg_TeeExtension       :String='tee';

Const  { do not translate }
   TeeChartVersion           =String('8'); // Cast to String to force CPP *.hpp generation as AnsiString instead of AnsiChar

   {$IFDEF TEEOCX}

   {$IFDEF AXUNICODE}
   TeeAXMinorVersion         ='.0.0.1 Unicode version';
   {$ELSE}
   TeeAXMinorVersion         ='.0.0.1';
   {$ENDIF}
   AXVer = TeeChartVersion+TeeAXMinorVersion {$IFDEF TEEBETA}+' Beta'{$ENDIF};
   TeeAXBuildVersion         ='10507';

   {$ELSE}

   TeeVCLMinorVersion        ='.01';  // ie: '.01'  '.02' , etc
   TeeVCLBuildVersion        ='10798';

   {$ENDIF}

   TeeMsg_Version            ='TeeChart '+{$IFDEF TEELITE}'Standard'{$ELSE}'Pro'{$ENDIF}+' v'+
                               TeeChartVersion
                               +
                               {$IFDEF TEEOCX}TeeAXMinorVersion{$ELSE}TeeVCLMinorVersion{$ENDIF}
                               +'.'+
                               {$IFDEF TEEOCX}TeeAXBuildVersion{$ELSE}TeeVCLBuildVersion{$ENDIF}
                               
                               {$IFDEF D8}
                                  + {$IFDEF CLR}' .NET'{$ELSE}' Win32'{$ENDIF}
                               {$ENDIF};

   TeeMsg_EditorKey          ='SOFTWARE\Steema Software\TeeChart Pro\Editor';
   TeeMsg_GalleryChartName   ='TeeGalleryChart';
   TeeMsg_TeeChartIDWizard   ='TeeChart.TeeChartWizard';
   TeeMsg_TeeChartSL         ='Steema Software SL';
   TeeMsg_TeeChartPalette    ={$IFDEF CLX}'TeeChart '{$ELSE}'TeeChart'{$ENDIF}{$IFDEF TEELITE}+' Std'{$ENDIF};
   TeeMsg_DefaultEngFontName ={$IFDEF CLX}'Helvetica'{$ELSE}'Arial'{$ENDIF};
   TeeMsg_DefaultDemoTee     ='http://www.steema.com/demo.tee';

   TeeMsg_HHNNSS             ='[hh:nn:ss]';  // 7.0

var
  TeeMsg_Copyright,
  TeeMsg_Test,
  TeeMsg_LegendFirstValue,
  TeeMsg_LegendColorWidth,
  TeeMsg_SeriesSetDataSource,
  TeeMsg_SeriesInvDataSource,
  TeeMsg_FillSample,
  TeeMsg_AxisLogDateTime,
  TeeMsg_AxisLogNotPositive,
  TeeMsg_AxisLabelSep,
  TeeMsg_AxisIncrementNeg,
  TeeMsg_AxisMinMax,
  TeeMsg_AxisMaxMin,
  TeeMsg_AxisLogBase,
  TeeMsg_MaxPointsPerPage,
  TeeMsg_3dPercent,
  TeeMsg_CircularSeries,
  TeeMsg_WarningHiColor,

  TeeMsg_DefaultPercentOf,
  TeeMsg_DefaultPercentOf2,
  TeeMsg_DefPercentFormat,
  TeeMsg_DefValueFormat,
  TeeMsg_DefLogValueFormat,
  TeeMsg_AxisTitle,
  TeeMsg_AxisLabels,
  TeeMsg_RefreshInterval,
  TeeMsg_SeriesParentNoSelf,
  TeeMsg_GalleryLine,
  TeeMsg_GalleryPoint,
  TeeMsg_GalleryArea,
  TeeMsg_GalleryBar,
  TeeMsg_GalleryHorizBar,
  TeeMsg_Stack,
  TeeMsg_GalleryPie,
  TeeMsg_GalleryCircled,
  TeeMsg_GalleryFastLine,
  TeeMsg_GalleryHorizLine,

  TeeMsg_PieSample1,
  TeeMsg_PieSample2,
  TeeMsg_PieSample3,
  TeeMsg_PieSample4,
  TeeMsg_PieSample5,
  TeeMsg_PieSample6,
  TeeMsg_PieSample7,
  TeeMsg_PieSample8,

  TeeMsg_GalleryLogoFont,
  TeeMsg_Editing,

  TeeMsg_GalleryStandard,
  TeeMsg_GalleryExtended,
  TeeMsg_GalleryFunctions,

  TeeMsg_EditChart,
  TeeMsg_PrintPreview,
  TeeMsg_ExportChart,
  TeeMsg_CustomAxes,

  TeeMsg_InvalidEditorClass,
  TeeMsg_MissingEditorClass,

  TeeMsg_GalleryArrow,

  TeeMsg_ExpFinish,
  TeeMsg_ExpNext,

  TeeMsg_GalleryGantt,

  TeeMsg_GanttSample1,
  TeeMsg_GanttSample2,
  TeeMsg_GanttSample3,
  TeeMsg_GanttSample4,
  TeeMsg_GanttSample5,
  TeeMsg_GanttSample6,
  TeeMsg_GanttSample7,
  TeeMsg_GanttSample8,
  TeeMsg_GanttSample9,
  TeeMsg_GanttSample10,

  TeeMsg_ChangeSeriesTitle,
  TeeMsg_NewSeriesTitle,
  TeeMsg_DateTime,
  TeeMsg_TopAxis,
  TeeMsg_BottomAxis,
  TeeMsg_LeftAxis,
  TeeMsg_RightAxis,

  TeeMsg_SureToDelete,
  TeeMsg_DateTimeFormat,
  TeeMsg_Default,
  TeeMsg_ValuesFormat,
  TeeMsg_Maximum,
  TeeMsg_Minimum,
  TeeMsg_DesiredIncrement,

  TeeMsg_IncorrectMaxMinValue,
  TeeMsg_EnterDateTime,

  TeeMsg_SureToApply,
  TeeMsg_SelectedSeries,
  TeeMsg_RefreshData,

  TeeMsg_DefaultFontSize,
  TeeMsg_DefaultEditorSize,
  TeeMsg_DefaultEditorHeight,
  TeeMsg_FunctionAdd,
  TeeMsg_FunctionSubtract,
  TeeMsg_FunctionMultiply,
  TeeMsg_FunctionDivide,
  TeeMsg_FunctionHigh,
  TeeMsg_FunctionLow,
  TeeMsg_FunctionAverage,

  TeeMsg_GalleryShape,
  TeeMsg_GalleryBubble,
  TeeMsg_FunctionNone,

  TeeMsg_None,

  TeeMsg_PrivateDeclarations,
  TeeMsg_PublicDeclarations,
  TeeMsg_DefaultFontName,

  TeeMsg_CheckPointerSize,
  TeeMsg_About,

  tcAdditional,
  tcDControls,
  tcQReport,

  TeeMsg_DataSet,
  TeeMsg_AskDataSet,

  TeeMsg_SingleRecord,
  TeeMsg_AskDataSource,

  TeeMsg_Summary,

  TeeMsg_FunctionPeriod,

  TeeMsg_WizardTab,
  TeeMsg_TeeChartWizard,

  TeeMsg_ClearImage,
  TeeMsg_BrowseImage,

  TeeMsg_WizardSureToClose,
  TeeMsg_FieldNotFound,

  TeeMsg_DepthAxis,
  TeeMsg_PieOther,
  TeeMsg_ShapeGallery1,
  TeeMsg_ShapeGallery2,
  TeeMsg_ValuesX,
  TeeMsg_ValuesY,
  TeeMsg_ValuesPie,
  TeeMsg_ValuesBar,
  TeeMsg_ValuesAngle,
  TeeMsg_ValuesGanttStart,
  TeeMsg_ValuesGanttEnd,
  TeeMsg_ValuesGanttNextTask,
  TeeMsg_ValuesBubbleRadius,
  TeeMsg_ValuesArrowEndX,
  TeeMsg_ValuesArrowEndY,
  TeeMsg_Legend,
  TeeMsg_Title,
  TeeMsg_Foot,
  TeeMsg_Period,
  TeeMsg_PeriodRange,
  TeeMsg_CalcPeriod,
  TeeMsg_SmallDotsPen,

  TeeMsg_InvalidTeeFile,
  TeeMsg_WrongTeeFileFormat,
  TeeMsg_EmptyTeeFile,

  {$IFDEF D5}
  TeeMsg_ChartAxesCategoryName,
  TeeMsg_ChartAxesCategoryDesc,
  TeeMsg_ChartWallsCategoryName,
  TeeMsg_ChartWallsCategoryDesc,
  TeeMsg_ChartTitlesCategoryName,
  TeeMsg_ChartTitlesCategoryDesc,
  TeeMsg_Chart3DCategoryName,
  TeeMsg_Chart3DCategoryDesc,
  {$ENDIF}

  TeeMsg_CustomAxesEditor,
  TeeMsg_Series,
  TeeMsg_SeriesList,

  TeeMsg_PageOfPages,
  TeeMsg_FileSize,

  TeeMsg_First,
  TeeMsg_Prior,
  TeeMsg_Next,
  TeeMsg_Last,
  TeeMsg_Insert,
  TeeMsg_Delete,
  TeeMsg_Edit,
  TeeMsg_Post,
  TeeMsg_Cancel,

  TeeMsg_All,
  TeeMsg_Index,
  TeeMsg_Text,

  TeeMsg_AsBMP,
  TeeMsg_BMPFilter,
  TeeMsg_AsEMF,
  TeeMsg_EMFFilter,
  TeeMsg_ExportPanelNotSet,

  TeeMsg_Normal,
  TeeMsg_NoBorder,
  TeeMsg_Dotted,
  TeeMsg_Colors,
  TeeMsg_Filled,
  TeeMsg_Marks,
  TeeMsg_Stairs,
  TeeMsg_Points,
  TeeMsg_Height,
  TeeMsg_Hollow,
  TeeMsg_Point2D,
  TeeMsg_Triangle,
  TeeMsg_Star,
  TeeMsg_Circle,
  TeeMsg_DownTri,
  TeeMsg_Cross,
  TeeMsg_Diamond,
  TeeMsg_NoLines,
  TeeMsg_Stack100,
  TeeMsg_Pyramid,
  TeeMsg_Ellipse,
  TeeMsg_InvPyramid,
  TeeMsg_Sides,
  TeeMsg_SideAll,
  TeeMsg_Patterns,
  TeeMsg_Exploded,
  TeeMsg_Shadow,
  TeeMsg_SemiPie,
  TeeMsg_Rectangle,
  TeeMsg_VertLine,
  TeeMsg_HorizLine,
  TeeMsg_Line,
  TeeMsg_Cube,
  TeeMsg_DiagCross,

  TeeMsg_CanNotFindTempPath,
  TeeMsg_CanNotCreateTempChart,
  TeeMsg_CanNotEmailChart,

  TeeMsg_SeriesDelete,
  TeeMsg_NoSeriesSelected,
  TeeMsg_CannotLoadChartFromURL,
  TeeMsg_CannotLoadSeriesDataFromURL,


  { 5.02 } { Moved from TeeImageConstants.pas unit }

  TeeMsg_AsJPEG,
  TeeMsg_JPEGFilter,
  TeeMsg_AsGIF,
  TeeMsg_GIFFilter,
  TeeMsg_AsPNG,
  TeeMsg_PNGFilter,
  TeeMsg_AsPCX,
  TeeMsg_PCXFilter,
  TeeMsg_AsVML,
  TeeMsg_VMLFilter,

  { 5.02 }
  TeeMsg_AskLanguage,

  { 5.03 }
  TeeMsg_Gradient,
  TeeMsg_WantToSave,
  TeeMsg_NativeFilter,
  TeeMsg_Property,
  TeeMsg_Value,
  TeeMsg_Yes,
  TeeMsg_No,
  TeeMsg_Image,

  {OCX 5.0.4}
  {$IFDEF TEEOCX}
  TeeMsg_ActiveXVersion,
  TeeMsg_ActiveXCannotImport,
  TeeMsg_ActiveXVerbPrint,
  TeeMsg_ActiveXVerbExport,
  TeeMsg_ActiveXVerbImport,
  TeeMsg_ActiveXVerbHelp,
  TeeMsg_ActiveXVerbAbout,
  TeeMsg_ActiveXError,
  TeeMsg_DatasourceError,
  TeeMsg_SeriesTextSrcError,
  TeeMsg_AxisTextSrcError,
  TeeMsg_DelSeriesDatasource,
  TeeMsg_OCXNoPrinter,
  TeeMsg_ActiveXPictureNotValid,
  {$ENDIF}

  { 6.0 }
  TeeMsg_FunctionCustom,
  TeeMsg_AsPDF,
  TeeMsg_PDFFilter,
  TeeMsg_AsPS,
  TeeMsg_PSFilter,
  TeeMsg_GalleryHorizArea,
  TeeMsg_SelfStack,
  TeeMsg_DarkPen,
  TeeMsg_SelectFolder,
  TeeMsg_BDEAlias,
  TeeMsg_ADOConnection,

  // 6.02
  TeeMsg_Apply,
  TeeMsg_AddNewGroup,
  TeeMsg_ChangeGroupName,
  TeeMsg_GroupName,
  TeeMsg_FunctionMedian,
  TeeMsg_FunctionMode,
  TeeMsg_Options,
  TeeMsg_DepthTopAxis,

  // 7.0
  TeeMsg_View2D,
  TeeMsg_Outline,

  // 7.05
  TeeMsg_TextFilter1,
  TeeMsg_TextFilter2,
  TeeMsg_TextFilter3,
  TeeMsg_TextFilter4,
  TeeMsg_TextFilter5,
  TeeMsg_XMLFilter,
  TeeMsg_HTMLFilter,
  TeeMsg_ExcelFilter,

  TeeMsg_ViewOrthoRight,
  TeeMsg_ViewOrthoLeft,
  TeeMsg_View3DFront,
  TeeMsg_View3DRight,
  TeeMsg_View3DLeft,
  TeeMsg_AsSVG,
  TeeMsg_SVGFilter,

  TeeMsg_SubTitle,
  TeeMsg_SubFoot,

  // 8.0
  TeeMsg_FunctionSubset,
  TeeMsg_Hexagon,
  TeeMsg_AntiAlias,
  TeeMsg_Percent,
  TeeMsg_Smooth,
  TeeMsg_Blur,
  TeeMsg_Width,
  TeeMsg_Resize,
  TeeMsg_Left,
  TeeMsg_Top,
  TeeMsg_Crop,
  TeeMsg_Invert,
  TeeMsg_GrayScale,
  TeeMsg_Mosaic,
  TeeMsg_Flip,
  TeeMsg_Reverse,
  TeeMsg_Brightness,
  TeeMsg_Color,
  TeeMsg_HueLumSat,
  TeeMsg_Sharpen,
  TeeMsg_GammaCorrection,
  TeeMsg_Emboss,
  TeeMsg_Contrast,
  TeeMsg_Rotate,
  TeeMsg_Back,
  TeeMsg_Autosize,
  TeeMsg_Mirror,
  TeeMsg_Columns,
  TeeMsg_Rows,
  TeeMsg_Tile,
  TeeMsg_Bevel,
  TeeMsg_Zoom,
  TeeMsg_ThemeDefault,
  TeeMsg_ThemeTeeChart,
  TeeMsg_ThemeExcel,
  TeeMsg_ThemeVictorian,
  TeeMsg_ThemePastels,
  TeeMsg_ThemeSolid,
  TeeMsg_ThemeClassic,
  TeeMsg_ThemeWeb,
  TeeMsg_ThemeModern,
  TeeMsg_ThemeRainbow,
  TeeMsg_ThemeWinXP,
  TeeMsg_ThemeMacOS,
  TeeMsg_ThemeWinVista,
  TeeMsg_ThemeGrayScale,
  TeeMsg_ThemeOpera,
  TeeMsg_ThemeWarm,
  TeeMsg_ThemeCool,

  TeeMsg_MenuFilters,
  TeeMsg_CrossTab,
  TeeMsg_DBSumEditCaption

  : String;

Procedure TeeSetConstants;

Const TeeEnglishLanguage:TStringList=nil;
Var   TeeLanguage:TStringList=nil;

    { When True, shortcut hotkeys are appended to the end of the translated string.
      This is necessary for example in Japanese translation. }
    TeeLanguageHotKeyAtEnd:Boolean=False;

    { Necessary at Calendar Series editor (uppercase properties) }
    TeeLanguageCanUpper:Boolean=True;

implementation

Procedure TeeSetConstants;
begin
  TeeMsg_Copyright          :='© 1995-2007 by Steema Software';

  TeeMsg_Test               :='Test...';
  TeeMsg_LegendFirstValue   :='First Legend Value must be > 0';
  TeeMsg_LegendColorWidth   :='Legend Color Width must be > 0%';
  TeeMsg_SeriesSetDataSource:='No ParentChart to validate DataSource';
  TeeMsg_SeriesInvDataSource:='No valid DataSource: %s';
  TeeMsg_FillSample         :='FillSampleValues NumValues must be > 0';
  TeeMsg_AxisLogDateTime    :='DateTime Axis cannot be Logarithmic';
  TeeMsg_AxisLogNotPositive :='Logarithmic Axis Min and Max values should be >= 0';
  TeeMsg_AxisLabelSep       :='Labels Separation % must be greater than 0';
  TeeMsg_AxisIncrementNeg   :='Axis increment must be >= 0';
  TeeMsg_AxisMinMax         :='Axis Minimum Value must be <= Maximum';
  TeeMsg_AxisMaxMin         :='Axis Maximum Value must be >= Minimum';
  TeeMsg_AxisLogBase        :='Axis Logarithmic Base should be <> 1 and > 0';
  TeeMsg_MaxPointsPerPage   :='MaxPointsPerPage must be >= 0';
  TeeMsg_3dPercent          :='3D effect percent must be between %d and %d';
  TeeMsg_CircularSeries     :='Circular Series dependences are not allowed';
  TeeMsg_WarningHiColor     :='16k Color or greater required to get better look';

  TeeMsg_DefaultPercentOf   :='%s of %s';
  TeeMsg_DefaultPercentOf2  :='%s'+#13+'of %s';
  TeeMsg_DefPercentFormat   :='##0.## %';
  TeeMsg_DefValueFormat     :='#,##0.###';
  TeeMsg_DefLogValueFormat  :='#.0 "x10" E+0';
  TeeMsg_AxisTitle          :='Axis Title';
  TeeMsg_AxisLabels         :='Axis Labels';
  TeeMsg_RefreshInterval    :='Refresh Interval must be between 0 and 60';
  TeeMsg_SeriesParentNoSelf :='Series.ParentChart is not myself!';
  TeeMsg_GalleryLine        :='Line';
  TeeMsg_GalleryPoint       :='Point';
  TeeMsg_GalleryArea        :='Area';
  TeeMsg_GalleryBar         :='Bar';
  TeeMsg_GalleryHorizBar    :='Horizontal'#13'Bar';
  TeeMsg_Stack              :='Stack';
  TeeMsg_GalleryPie         :='Pie';
  TeeMsg_GalleryCircled     :='Circled';
  TeeMsg_GalleryFastLine    :='Fast Line';
  TeeMsg_GalleryHorizLine   :='Horizontal'#13'Line';

  TeeMsg_PieSample1         :='Cars';
  TeeMsg_PieSample2         :='Phones';
  TeeMsg_PieSample3         :='Tables';
  TeeMsg_PieSample4         :='Monitors';
  TeeMsg_PieSample5         :='Lamps';
  TeeMsg_PieSample6         :='Keyboards';
  TeeMsg_PieSample7         :='Bikes';
  TeeMsg_PieSample8         :='Chairs';

  TeeMsg_GalleryLogoFont    :='Courier New';
  TeeMsg_Editing            :='Editing %s';

  TeeMsg_GalleryStandard    :='Standard';
  TeeMsg_GalleryExtended    :='Extended';
  TeeMsg_GalleryFunctions   :='Functions';

  TeeMsg_EditChart          :='E&dit Chart...';
  TeeMsg_PrintPreview       :='&Print Preview...';
  TeeMsg_ExportChart        :='E&xport Chart...';
  TeeMsg_CustomAxes         :='Custom Axes...';

  TeeMsg_InvalidEditorClass :='%s: Invalid Editor Class: %s';
  TeeMsg_MissingEditorClass :='%s: has no Editor Dialog';

  TeeMsg_GalleryArrow       :='Arrow';

  TeeMsg_ExpFinish          :='&Finish';
  TeeMsg_ExpNext            :='&Next >';

  TeeMsg_GalleryGantt       :='Gantt';

  TeeMsg_GanttSample1       :='Design';
  TeeMsg_GanttSample2       :='Prototyping';
  TeeMsg_GanttSample3       :='Development';
  TeeMsg_GanttSample4       :='Sales';
  TeeMsg_GanttSample5       :='Marketing';
  TeeMsg_GanttSample6       :='Testing';
  TeeMsg_GanttSample7       :='Manufac.';
  TeeMsg_GanttSample8       :='Debugging';
  TeeMsg_GanttSample9       :='New Version';
  TeeMsg_GanttSample10      :='Banking';

  TeeMsg_ChangeSeriesTitle  :='Change Series Title';
  TeeMsg_NewSeriesTitle     :='New Series Title:';
  TeeMsg_DateTime           :='DateTime';
  TeeMsg_TopAxis            :='Top Axis';
  TeeMsg_BottomAxis         :='Bottom Axis';
  TeeMsg_LeftAxis           :='Left Axis';
  TeeMsg_RightAxis          :='Right Axis';

  TeeMsg_SureToDelete       :='Delete %s ?';
  TeeMsg_DateTimeFormat     :='DateTime For&mat:';
  TeeMsg_Default            :='Default';
  TeeMsg_ValuesFormat       :='Values For&mat:';
  TeeMsg_Maximum            :='Maximum';
  TeeMsg_Minimum            :='Minimum';
  TeeMsg_DesiredIncrement   :='Desired %s Increment';

  TeeMsg_IncorrectMaxMinValue:='Incorrect value. Reason: %s';
  TeeMsg_EnterDateTime      :='Enter [Number of Days] '+TeeMsg_HHNNSS;

  TeeMsg_SureToApply        :='Apply Changes ?';
  TeeMsg_SelectedSeries     :='(Selected Series)';
  TeeMsg_RefreshData        :='&Refresh Data';

  TeeMsg_DefaultFontSize    :={$IFDEF LINUX}'10'{$ELSE}'8'{$ENDIF};
  TeeMsg_DefaultEditorSize  :='414';
  TeeMsg_DefaultEditorHeight:='347';

  TeeMsg_FunctionAdd        :='Add';
  TeeMsg_FunctionSubtract   :='Subtract';
  TeeMsg_FunctionMultiply   :='Multiply';
  TeeMsg_FunctionDivide     :='Divide';
  TeeMsg_FunctionHigh       :='High';
  TeeMsg_FunctionLow        :='Low';
  TeeMsg_FunctionAverage    :='Average';

  TeeMsg_GalleryShape       :='Shape';
  TeeMsg_GalleryBubble      :='Bubble';
  TeeMsg_FunctionNone       :='Copy';

  TeeMsg_None               :='(none)';

  TeeMsg_PrivateDeclarations:='{ Private declarations }';
  TeeMsg_PublicDeclarations :='{ Public declarations }';
  TeeMsg_DefaultFontName    :=TeeMsg_DefaultEngFontName;

  TeeMsg_CheckPointerSize   :='Pointer size must be greater than zero';
  TeeMsg_About              :='Abo&ut TeeChart...';

  tcAdditional              :='Additional';
  tcDControls               :='Data Controls';
  tcQReport                 :='QReport';

  TeeMsg_DataSet            :='Dataset';
  TeeMsg_AskDataSet         :='&Dataset:';

  TeeMsg_SingleRecord       :='Single Record';
  TeeMsg_AskDataSource      :='&DataSource:';

  TeeMsg_Summary            :='Summary';

  TeeMsg_FunctionPeriod     :='Function Period should be >= 0';

  TeeMsg_WizardTab          :='Business';
  TeeMsg_TeeChartWizard     :='TeeChart Wizard';

  TeeMsg_ClearImage         :='Clea&r';
  TeeMsg_BrowseImage        :='B&rowse...';

  TeeMsg_WizardSureToClose  :='Are you sure that you want to close the TeeChart Wizard ?';
  TeeMsg_FieldNotFound      :='Field %s does not exist';

  TeeMsg_DepthAxis          :='Depth Right';
  TeeMsg_PieOther           :='Other';
  TeeMsg_ShapeGallery1      :='abc';
  TeeMsg_ShapeGallery2      :='123';
  TeeMsg_ValuesX            :='X';
  TeeMsg_ValuesY            :='Y';
  TeeMsg_ValuesPie          :='Pie';
  TeeMsg_ValuesBar          :='Bar';
  TeeMsg_ValuesAngle        :='Angle';
  TeeMsg_ValuesGanttStart   :='Start';
  TeeMsg_ValuesGanttEnd     :='End';
  TeeMsg_ValuesGanttNextTask:='NextTask';
  TeeMsg_ValuesBubbleRadius :='Radius';
  TeeMsg_ValuesArrowEndX    :='EndX';
  TeeMsg_ValuesArrowEndY    :='EndY';
  TeeMsg_Legend             :='Legend';
  TeeMsg_Title              :='Title';
  TeeMsg_Foot               :='Footer';
  TeeMsg_Period		    :='Period';
  TeeMsg_PeriodRange        :='Period range';
  TeeMsg_CalcPeriod         :='Calculate %s every:';
  TeeMsg_SmallDotsPen       :='Small Dots';

  TeeMsg_InvalidTeeFile     :='Invalid Chart in *.'+TeeMsg_TeeExtension+' file';
  TeeMsg_WrongTeeFileFormat :='Wrong *.'+TeeMsg_TeeExtension+' file format';
  TeeMsg_EmptyTeeFile       :='Empty *.'+TeeMsg_TeeExtension+' file';  { 5.01 }

  {$IFDEF D5}
  TeeMsg_ChartAxesCategoryName   := 'Chart Axes';
  TeeMsg_ChartAxesCategoryDesc   := 'Chart Axes properties and events';
  TeeMsg_ChartWallsCategoryName  := 'Chart Walls';
  TeeMsg_ChartWallsCategoryDesc  := 'Chart Walls properties and events';
  TeeMsg_ChartTitlesCategoryName := 'Chart Titles';
  TeeMsg_ChartTitlesCategoryDesc := 'Chart Titles properties and events';
  TeeMsg_Chart3DCategoryName     := 'Chart 3D';
  TeeMsg_Chart3DCategoryDesc     := 'Chart 3D properties and events';
  {$ENDIF}

  TeeMsg_CustomAxesEditor       :='Custom ';
  TeeMsg_Series                 :='Series';
  TeeMsg_SeriesList             :='Series...';

  TeeMsg_PageOfPages            :='Page %d of %d';
  TeeMsg_FileSize               :='%d bytes';

  TeeMsg_First  :='First';
  TeeMsg_Prior  :='Prior';
  TeeMsg_Next   :='Next';
  TeeMsg_Last   :='Last';
  TeeMsg_Insert :='Insert';
  TeeMsg_Delete :='Delete';
  TeeMsg_Edit   :='Edit';
  TeeMsg_Post   :='Post';
  TeeMsg_Cancel :='Cancel';

  TeeMsg_All    :='(all)';
  TeeMsg_Index  :='Index';
  TeeMsg_Text   :='Text';

  TeeMsg_AsBMP        :='as &Bitmap';
  TeeMsg_BMPFilter    :='Bitmaps (*.bmp)|*.bmp';
  TeeMsg_AsEMF        :='as &Metafile';
  TeeMsg_EMFFilter    :='Enhanced Metafiles (*.emf)|*.emf|Metafiles (*.wmf)|*.wmf';
  TeeMsg_ExportPanelNotSet := 'Panel property is not set in Export format';

  TeeMsg_Normal    :='Normal';
  TeeMsg_NoBorder  :='No Border';
  TeeMsg_Dotted    :='Dotted';
  TeeMsg_Colors    :='Colors';
  TeeMsg_Filled    :='Filled';
  TeeMsg_Marks     :='Marks';
  TeeMsg_Stairs    :='Stairs';
  TeeMsg_Points    :='Points';
  TeeMsg_Height    :='Height';
  TeeMsg_Hollow    :='Hollow';
  TeeMsg_Point2D   :='Point 2D';
  TeeMsg_Triangle  :='Triangle';
  TeeMsg_Star      :='Star';
  TeeMsg_Circle    :='Circle';
  TeeMsg_DownTri   :='Down Tri.';
  TeeMsg_Cross     :='Cross';
  TeeMsg_Diamond   :='Diamond';
  TeeMsg_NoLines   :='No Lines';
  TeeMsg_Stack100  :='Stack 100%';
  TeeMsg_Pyramid   :='Pyramid';
  TeeMsg_Ellipse   :='Ellipse';
  TeeMsg_InvPyramid:='Inv. Pyramid';
  TeeMsg_Sides     :='Sides';
  TeeMsg_SideAll   :='Side All';
  TeeMsg_Patterns  :='Patterns';
  TeeMsg_Exploded  :='Exploded';
  TeeMsg_Shadow    :='Shadow';
  TeeMsg_SemiPie   :='Semi Pie';
  TeeMsg_Rectangle :='Rectangle';
  TeeMsg_VertLine  :='Vert.Line';
  TeeMsg_HorizLine :='Horiz.Line';
  TeeMsg_Line      :='Line';
  TeeMsg_Cube      :='Cube';
  TeeMsg_DiagCross :='Diag.Cross';

  TeeMsg_CanNotFindTempPath    :='Can not find Temp folder';
  TeeMsg_CanNotCreateTempChart :='Can not create Temp file';
  TeeMsg_CanNotEmailChart      :='Can not email TeeChart. Mapi Error: %d';

  TeeMsg_SeriesDelete :='Series Delete: ValueIndex %d out of bounds (0 to %d).';
  TeeMsg_NoSeriesSelected :='No Series selected';
  TeeMsg_CannotLoadChartFromURL:='Error code: %d downloading Chart from URL: %s';
  TeeMsg_CannotLoadSeriesDataFromURL:='Error code: %d downloading Series data from URL: %s';

  { 5.02 } { Moved from TeeImageConstants.pas unit }

  TeeMsg_AsJPEG        :='as &JPEG';
  TeeMsg_JPEGFilter    :='JPEG files (*.jpg)|*.jpg';
  TeeMsg_AsGIF         :='as &GIF';
  TeeMsg_GIFFilter     :='GIF files (*.gif)|*.gif';
  TeeMsg_AsPNG         :='as &PNG';
  TeeMsg_PNGFilter     :='PNG files (*.png)|*.png';
  TeeMsg_AsPCX         :='as PC&X';
  TeeMsg_PCXFilter     :='PCX files (*.pcx)|*.pcx';
  TeeMsg_AsVML         :='as &VML (HTM)';
  TeeMsg_VMLFilter     :='VML files (*.htm)|*.htm';

  { 5.02 }
  TeeMsg_AskLanguage  :='&Language...';

  { 5.03 }
  TeeMsg_Gradient     :='Gradient';
  TeeMsg_WantToSave   :='Do you want to save %s?';
  TeeMsg_NativeFilter :='TeeChart files';

  TeeMsg_Property     :='Property';
  TeeMsg_Value        :='Value';
  TeeMsg_Yes          :='Yes';
  TeeMsg_No           :='No';
  TeeMsg_Image        :='(image)';

  {AX 5.0.4}
  {$IFDEF TEEOCX}
  TeeMsg_ActiveXVersion      := 'ActiveX Release ' + AXVer;
  TeeMsg_ActiveXCannotImport := 'Cannot import TeeChart from %s';
  TeeMsg_ActiveXVerbPrint    := '&Print Preview...';
  TeeMsg_ActiveXVerbExport   := 'E&xport...';
  TeeMsg_ActiveXVerbImport   := '&Import...';
  TeeMsg_ActiveXVerbHelp     := '&Help...';
  TeeMsg_ActiveXVerbAbout    := '&About TeeChart...';
  TeeMsg_ActiveXError        := 'TeeChart: Error code: %d downloading: %s';
  TeeMsg_DatasourceError     := 'TeeChart DataSource is not a Series or RecordSet';
  TeeMsg_SeriesTextSrcError  := 'Invalid Series type';
  TeeMsg_AxisTextSrcError    := 'Invalid Axis type';
  TeeMsg_DelSeriesDatasource := 'Are you sure you want to delete %s ?';
  TeeMsg_OCXNoPrinter        := 'No default printer installed.';
  TeeMsg_ActiveXPictureNotValid :='Picture not valid';
  {$ENDIF}

  { 6.0 }
  TeeMsg_FunctionCustom   :='y = f(x)';
  TeeMsg_AsPDF            :='as &PDF';
  TeeMsg_PDFFilter        :='PDF files (*.pdf)|*.pdf';
  TeeMsg_AsPS             :='as PostScript';
  TeeMsg_PSFilter         :='PostScript files (*.eps)|*.eps';
  TeeMsg_GalleryHorizArea :='Horizontal'#13'Area';
  TeeMsg_SelfStack        :='Self Stacked';
  TeeMsg_DarkPen          :='Dark Border';
  TeeMsg_SelectFolder     :='Select database folder';
  TeeMsg_BDEAlias         :='&Alias:';
  TeeMsg_ADOConnection    :='&Connection:';

  // 6.02
  TeeMsg_Apply            :='&Apply';
  TeeMsg_AddNewGroup      :='Add new group';
  TeeMsg_ChangeGroupName  :='Change group name';
  TeeMsg_GroupName        :='Group name:';
  TeeMsg_FunctionMedian   :='Median';
  TeeMsg_FunctionMode     :='Mode';
  TeeMsg_Options          :='&Options...';
  TeeMsg_DepthTopAxis     :='Depth Top';

  // 7.0
  TeeMsg_View2D           :='2D';
  TeeMsg_Outline          :='Outline';

  // 7.05
  TeeMsg_TextFilter1  :='Space delimited text files (*.txt)|*.txt';
  TeeMsg_TextFilter2  :='Tab delimited text files (*.txt)|*.txt';
  TeeMsg_TextFilter3  :='Comma delimited text files (*.csv)|*.csv';
  TeeMsg_TextFilter4  :='Colon delimited text files (*.txt)|*.txt';
  TeeMsg_TextFilter5  :='Custom delimited text files (*.txt)|*.txt';
  TeeMsg_XMLFilter    :='XML files (*.xml)|*.xml';
  TeeMsg_HTMLFilter   :='HTML files (*.htm)|*.htm';
  TeeMsg_ExcelFilter  :='Microsoft Excel files (*.xls)|*.xls';

  TeeMsg_ViewOrthoRight   :='Ortho Right';
  TeeMsg_ViewOrthoLeft    :='Ortho Left';
  TeeMsg_View3DFront      :='3D Front';
  TeeMsg_View3DRight      :='3D Right';
  TeeMsg_View3DLeft       :='3D Left';
  TeeMsg_AsSVG            :='as &SVG';
  TeeMsg_SVGFilter        :='SVG files (*.svg)|*.svg';

  TeeMsg_SubTitle := 'SubTitle';
  TeeMsg_SubFoot  := 'SubFoot';

  // 8.0
  TeeMsg_FunctionSubset   :='Subset';
  TeeMsg_Hexagon          :='Hexagon';
  TeeMsg_AntiAlias        :='Antialias';
  TeeMsg_Percent          :='Percent';
  TeeMsg_Smooth           :='Smooth';
  TeeMsg_Blur             :='Blur';
  TeeMsg_Width            :='Width';
  TeeMsg_Resize           :='Resize';
  TeeMsg_Left             :='Left';
  TeeMsg_Top              :='Top';
  TeeMsg_Crop             :='Crop';
  TeeMsg_Invert           :='Invert';
  TeeMsg_GrayScale        :='Gray scale';
  TeeMsg_Mosaic           :='Mosaic';
  TeeMsg_Flip             :='Flip';
  TeeMsg_Reverse          :='Reverse';
  TeeMsg_Brightness       :='Brightness';
  TeeMsg_Color            :='Color';
  TeeMsg_HueLumSat        :='Hue,Lum,Sat';
  TeeMsg_Sharpen          :='Sharpen';
  TeeMsg_GammaCorrection  :='Gamma correction';
  TeeMsg_Emboss           :='Emboss';
  TeeMsg_Contrast         :='Contrast';
  TeeMsg_Rotate           :='Rotate';
  TeeMsg_Back             :='Back';
  TeeMsg_Autosize         :='Autosize';
  TeeMsg_Mirror           :='Mirror';
  TeeMsg_Columns          :='Columns';
  TeeMsg_Rows             :='Rows';
  TeeMsg_Tile             :='Tile';
  TeeMsg_Bevel            :='Bevel';
  TeeMsg_Zoom             :='Zoom';
  TeeMsg_ThemeDefault     :='Default';
  TeeMsg_ThemeTeeChart    :='TeeChart';
  TeeMsg_ThemeExcel       :='Excel';
  TeeMsg_ThemeVictorian   :='Victorian';
  TeeMsg_ThemePastels     :='Pastels';
  TeeMsg_ThemeSolid       :='Solid';
  TeeMsg_ThemeClassic     :='Classic';
  TeeMsg_ThemeWeb         :='Web';
  TeeMsg_ThemeModern      :='Modern';
  TeeMsg_ThemeRainbow     :='Rainbow';
  TeeMsg_ThemeWinXP       :='Win. XP';
  TeeMsg_ThemeMacOS       :='Mac OS';
  TeeMsg_ThemeWinVista    :='Win. Vista';
  TeeMsg_ThemeGrayScale   :='Gray scale';
  TeeMsg_ThemeOpera       :='Opera';
  TeeMsg_ThemeWarm        :='Warm';
  TeeMsg_ThemeCool        :='Cool';


  TeeMsg_MenuFilters      :='&Filters...';
  TeeMsg_CrossTab         :='CrossTab';
  TeeMsg_DBSumEditCaption :='Summary properties';

end;

initialization
  TeeSetConstants;
end.
