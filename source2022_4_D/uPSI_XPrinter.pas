unit uPSI_XPrinter;
{
   to print the hint
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
  TPSImport_XPrinter = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TXPrint(CL: TPSPascalCompiler);
procedure SIRegister_XPrinter(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_XPrinter_Routines(S: TPSExec);
procedure RIRegister_TXPrint(CL: TPSRuntimeClassImporter);
procedure RIRegister_XPrinter(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   WinTypes
  ,WinSpool
  ,WinProcs
  ,Graphics
  ,Printers
  ,XPrinter
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_XPrinter]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXPrint(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TXPrint') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TXPrint') do begin
    RegisterProperty('Canvas', 'TCanvas', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
          RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Abort');
    RegisterMethod('Procedure BeginDoc');
    RegisterMethod('Procedure EndDoc');
    RegisterMethod('Procedure NewPage');
    RegisterMethod('Procedure SetFontSize( FontSize : integer)');
    RegisterMethod('Procedure SelectFont( AFont : TFont)');
    RegisterMethod('Function XBounds( ALeft, ATop, AWidth, AHeight : Integer) : TRect');
    RegisterMethod('Procedure SetConfig( XPrintConfig : TXPrintConfig)');
    RegisterMethod('Procedure SyncIndex');
    RegisterMethod('Function GetConfig : TXPrintConfig');
    RegisterMethod('Function ConfigToStr( XPrintConfig : TXPrintConfig) : string');
    RegisterMethod('Function StrToConfig( CfgStr : string) : TXPrintConfig');
    RegisterProperty('PrinterAvailable', 'boolean', iptr);
    RegisterProperty('CurrentPrinter', 'integer', iptrw);
    RegisterProperty('PrintWidth', 'integer', iptr);
    RegisterProperty('PrintHeight', 'integer', iptr);
    RegisterProperty('MinMarginLeft', 'integer', iptr);
    RegisterProperty('MinMarginTop', 'integer', iptr);
    RegisterProperty('MinMarginRight', 'integer', iptr);
    RegisterProperty('MinMarginBottom', 'integer', iptr);
    RegisterProperty('Capabilities', 'TXPrinterCapabilities', iptr);
    RegisterProperty('Fonts', 'TStrings', iptr);
    RegisterProperty('Handle', 'HDC', iptr);
    RegisterProperty('PageNumber', 'integer', iptr);
    RegisterProperty('Printers', 'TStrings', iptr);
    RegisterProperty('Printing', 'boolean', iptr);
    RegisterProperty('XResolution', 'integer', iptr);
    RegisterProperty('YResolution', 'integer', iptr);
    RegisterProperty('TextRotation', 'boolean', iptrw);
    RegisterProperty('ColorDepth', 'integer', iptr);
    RegisterProperty('CanUserDefFill', 'boolean', iptr);
    RegisterProperty('Scaling', 'TScaling', iptrw);
    RegisterProperty('MarginLeft', 'integer', iptrw);
    RegisterProperty('MarginTop', 'integer', iptrw);
    RegisterProperty('MarginRight', 'integer', iptrw);
    RegisterProperty('MarginBottom', 'integer', iptrw);
    RegisterProperty('Font', 'TFont', iptrw);
    RegisterProperty('Aborted', 'boolean', iptr);
    RegisterProperty('Copies', 'integer', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('Orientation', 'TXPrinterOrientation', iptrw);
    RegisterProperty('Angle10', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_XPrinter(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TXPrinterOrientation', '( xpoPortrait, xpoLandscape )');
  CL.AddTypeS('TXPrinterCapability', '( xpcCopies, xpcOrientation, xpcCollation)');
  CL.AddTypeS('TXPrinterCapabilities', 'set of TXPrinterCapability');
  CL.AddTypeS('TScaling', '( pscDot, pscMil, pscMetric10, pscMetric100 )');
  CL.AddTypeS('TFontstring', 'string');
  CL.AddTypeS('TXTitleString', 'string');

  CL.AddTypeS('TXPrintConfig', 'record Valid : boolean; CurrentPrinter : intege'
   +'r; Scaling : TScaling; MarginLeft : integer; MarginTop : integer; MarginRi'
   +'ght : integer; MarginBottom : integer; Font_Charset : integer; Font_Color '
   +': TColor; Font_Height : integer; Font_Name : TFontString; Font_Pitch : TFo'
   +'ntPitch; Font_Size : integer; Font_Style : TFontStyles; Copies : integer; '
   +'Orientation : TXPrinterOrientation; Angle10 : integer; TextRotation : bool'
   +'ean; Title : TXTitleString; end');
  SIRegister_TXPrint(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TXPrintAngle10_W(Self: TXPrint; const T: integer);
begin Self.Angle10 := T; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintAngle10_R(Self: TXPrint; var T: integer);
begin T := Self.Angle10; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintOrientation_W(Self: TXPrint; const T: TXPrinterOrientation);
begin Self.Orientation := T; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintOrientation_R(Self: TXPrint; var T: TXPrinterOrientation);
begin T := Self.Orientation; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintTitle_W(Self: TXPrint; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintTitle_R(Self: TXPrint; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintCopies_W(Self: TXPrint; const T: integer);
begin Self.Copies := T; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintCopies_R(Self: TXPrint; var T: integer);
begin T := Self.Copies; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintAborted_R(Self: TXPrint; var T: boolean);
begin T := Self.Aborted; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintFont_W(Self: TXPrint; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintFont_R(Self: TXPrint; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintMarginBottom_W(Self: TXPrint; const T: integer);
begin Self.MarginBottom := T; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintMarginBottom_R(Self: TXPrint; var T: integer);
begin T := Self.MarginBottom; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintMarginRight_W(Self: TXPrint; const T: integer);
begin Self.MarginRight := T; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintMarginRight_R(Self: TXPrint; var T: integer);
begin T := Self.MarginRight; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintMarginTop_W(Self: TXPrint; const T: integer);
begin Self.MarginTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintMarginTop_R(Self: TXPrint; var T: integer);
begin T := Self.MarginTop; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintMarginLeft_W(Self: TXPrint; const T: integer);
begin Self.MarginLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintMarginLeft_R(Self: TXPrint; var T: integer);
begin T := Self.MarginLeft; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintScaling_W(Self: TXPrint; const T: TScaling);
begin Self.Scaling := T; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintScaling_R(Self: TXPrint; var T: TScaling);
begin T := Self.Scaling; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintCanUserDefFill_R(Self: TXPrint; var T: boolean);
begin T := Self.CanUserDefFill; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintColorDepth_R(Self: TXPrint; var T: integer);
begin T := Self.ColorDepth; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintTextRotation_W(Self: TXPrint; const T: boolean);
begin Self.TextRotation := T; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintTextRotation_R(Self: TXPrint; var T: boolean);
begin T := Self.TextRotation; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintYResolution_R(Self: TXPrint; var T: integer);
begin T := Self.YResolution; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintXResolution_R(Self: TXPrint; var T: integer);
begin T := Self.XResolution; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintPrinting_R(Self: TXPrint; var T: boolean);
begin T := Self.Printing; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintPrinters_R(Self: TXPrint; var T: TStrings);
begin T := Self.Printers; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintPageNumber_R(Self: TXPrint; var T: integer);
begin T := Self.PageNumber; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintHandle_R(Self: TXPrint; var T: HDC);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintFonts_R(Self: TXPrint; var T: TStrings);
begin T := Self.Fonts; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintCapabilities_R(Self: TXPrint; var T: TXPrinterCapabilities);
begin T := Self.Capabilities; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintMinMarginBottom_R(Self: TXPrint; var T: integer);
begin T := Self.MinMarginBottom; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintMinMarginRight_R(Self: TXPrint; var T: integer);
begin T := Self.MinMarginRight; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintMinMarginTop_R(Self: TXPrint; var T: integer);
begin T := Self.MinMarginTop; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintMinMarginLeft_R(Self: TXPrint; var T: integer);
begin T := Self.MinMarginLeft; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintPrintHeight_R(Self: TXPrint; var T: integer);
begin T := Self.PrintHeight; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintPrintWidth_R(Self: TXPrint; var T: integer);
begin T := Self.PrintWidth; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintCurrentPrinter_W(Self: TXPrint; const T: integer);
begin Self.CurrentPrinter := T; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintCurrentPrinter_R(Self: TXPrint; var T: integer);
begin T := Self.CurrentPrinter; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintPrinterAvailable_R(Self: TXPrint; var T: boolean);
begin T := Self.PrinterAvailable; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintCanvas_W(Self: TXPrint; const T: TCanvas);
Begin Self.Canvas := T; end;

(*----------------------------------------------------------------------------*)
procedure TXPrintCanvas_R(Self: TXPrint; var T: TCanvas);
Begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_XPrinter_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXPrint(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXPrint) do begin
    RegisterPropertyHelper(@TXPrintCanvas_R,@TXPrintCanvas_W,'Canvas');
    RegisterConstructor(@TXPrint.Create, 'Create');
       RegisterMethod(@TXPrint.Destroy, 'Free');
      RegisterMethod(@TXPrint.Abort, 'Abort');
    RegisterMethod(@TXPrint.BeginDoc, 'BeginDoc');
    RegisterMethod(@TXPrint.EndDoc, 'EndDoc');
    RegisterMethod(@TXPrint.NewPage, 'NewPage');
    RegisterMethod(@TXPrint.SetFontSize, 'SetFontSize');
    RegisterMethod(@TXPrint.SelectFont, 'SelectFont');
    RegisterMethod(@TXPrint.XBounds, 'XBounds');
    RegisterMethod(@TXPrint.SetConfig, 'SetConfig');
    RegisterMethod(@TXPrint.SyncIndex, 'SyncIndex');
    RegisterMethod(@TXPrint.GetConfig, 'GetConfig');
    RegisterMethod(@TXPrint.ConfigToStr, 'ConfigToStr');
    RegisterMethod(@TXPrint.StrToConfig, 'StrToConfig');
    RegisterPropertyHelper(@TXPrintPrinterAvailable_R,nil,'PrinterAvailable');
    RegisterPropertyHelper(@TXPrintCurrentPrinter_R,@TXPrintCurrentPrinter_W,'CurrentPrinter');
    RegisterPropertyHelper(@TXPrintPrintWidth_R,nil,'PrintWidth');
    RegisterPropertyHelper(@TXPrintPrintHeight_R,nil,'PrintHeight');
    RegisterPropertyHelper(@TXPrintMinMarginLeft_R,nil,'MinMarginLeft');
    RegisterPropertyHelper(@TXPrintMinMarginTop_R,nil,'MinMarginTop');
    RegisterPropertyHelper(@TXPrintMinMarginRight_R,nil,'MinMarginRight');
    RegisterPropertyHelper(@TXPrintMinMarginBottom_R,nil,'MinMarginBottom');
    RegisterPropertyHelper(@TXPrintCapabilities_R,nil,'Capabilities');
    RegisterPropertyHelper(@TXPrintFonts_R,nil,'Fonts');
    RegisterPropertyHelper(@TXPrintHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TXPrintPageNumber_R,nil,'PageNumber');
    RegisterPropertyHelper(@TXPrintPrinters_R,nil,'Printers');
    RegisterPropertyHelper(@TXPrintPrinting_R,nil,'Printing');
    RegisterPropertyHelper(@TXPrintXResolution_R,nil,'XResolution');
    RegisterPropertyHelper(@TXPrintYResolution_R,nil,'YResolution');
    RegisterPropertyHelper(@TXPrintTextRotation_R,@TXPrintTextRotation_W,'TextRotation');
    RegisterPropertyHelper(@TXPrintColorDepth_R,nil,'ColorDepth');
    RegisterPropertyHelper(@TXPrintCanUserDefFill_R,nil,'CanUserDefFill');
    RegisterPropertyHelper(@TXPrintScaling_R,@TXPrintScaling_W,'Scaling');
    RegisterPropertyHelper(@TXPrintMarginLeft_R,@TXPrintMarginLeft_W,'MarginLeft');
    RegisterPropertyHelper(@TXPrintMarginTop_R,@TXPrintMarginTop_W,'MarginTop');
    RegisterPropertyHelper(@TXPrintMarginRight_R,@TXPrintMarginRight_W,'MarginRight');
    RegisterPropertyHelper(@TXPrintMarginBottom_R,@TXPrintMarginBottom_W,'MarginBottom');
    RegisterPropertyHelper(@TXPrintFont_R,@TXPrintFont_W,'Font');
    RegisterPropertyHelper(@TXPrintAborted_R,nil,'Aborted');
    RegisterPropertyHelper(@TXPrintCopies_R,@TXPrintCopies_W,'Copies');
    RegisterPropertyHelper(@TXPrintTitle_R,@TXPrintTitle_W,'Title');
    RegisterPropertyHelper(@TXPrintOrientation_R,@TXPrintOrientation_W,'Orientation');
    RegisterPropertyHelper(@TXPrintAngle10_R,@TXPrintAngle10_W,'Angle10');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_XPrinter(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TXPrint(CL);
end;

 
 
{ TPSImport_XPrinter }
(*----------------------------------------------------------------------------*)
procedure TPSImport_XPrinter.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_XPrinter(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_XPrinter.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_XPrinter(ri);
  RIRegister_XPrinter_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
