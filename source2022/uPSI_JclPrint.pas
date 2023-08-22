unit uPSI_JclPrint;
{
  direct print   add free
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
  TPSImport_JclPrint = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJclPrintSet(CL: TPSPascalCompiler);
procedure SIRegister_JclPrint(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclPrint_Routines(S: TPSExec);
procedure RIRegister_TJclPrintSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclPrint(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StdCtrls
  ,JclBase
  ,JclPrint
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclPrint]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPrintSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclPrintSet') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclPrintSet') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
     RegisterMethod('Function GetBinSourceList : TStringList');
    RegisterMethod('Function GetPaperList : TStringList');
    RegisterMethod('Procedure SetDeviceMode( Creating : Boolean)');
    RegisterMethod('Procedure UpdateDeviceMode');
    RegisterMethod('Procedure SaveToDefaults');
    RegisterMethod('Procedure SavePrinterAsDefault');
    RegisterMethod('Procedure ResetPrinterDialogs');
    RegisterMethod('Function XInchToDot( const Inches : Double) : Integer');
    RegisterMethod('Function YInchToDot( const Inches : Double) : Integer');
    RegisterMethod('Function XCmToDot( const Cm : Double) : Integer');
    RegisterMethod('Function YCmToDot( const Cm : Double) : Integer');
    RegisterMethod('Function CpiToDot( const Cpi, Chars : Double) : Integer');
    RegisterMethod('Function LpiToDot( const Lpi, Lines : Double) : Integer');
    RegisterMethod('Procedure TextOutInch( const X, Y : Double; const Text : string)');
    RegisterMethod('Procedure TextOutCm( const X, Y : Double; const Text : string)');
    RegisterMethod('Procedure TextOutCpiLpi( const Cpi, Chars, Lpi, Lines : Double; const Text : string)');
    RegisterMethod('Procedure CustomPageSetup( const Width, Height : Double)');
    RegisterMethod('Procedure SaveToIniFile( const IniFileName, Section : string)');
    RegisterMethod('Function ReadFromIniFile( const IniFileName, Section : string) : Boolean');
    RegisterProperty('Orientation', 'Integer', iptrw);
    RegisterProperty('PaperSize', 'Integer', iptrw);
    RegisterProperty('PaperLength', 'Integer', iptrw);
    RegisterProperty('PaperWidth', 'Integer', iptrw);
    RegisterProperty('Scale', 'Integer', iptrw);
    RegisterProperty('Copies', 'Integer', iptrw);
    RegisterProperty('DefaultSource', 'Integer', iptrw);
    RegisterProperty('PrintQuality', 'Integer', iptrw);
    RegisterProperty('Color', 'Integer', iptrw);
    RegisterProperty('Duplex', 'Integer', iptrw);
    RegisterProperty('YResolution', 'Integer', iptrw);
    RegisterProperty('TrueTypeOption', 'Integer', iptrw);
    RegisterProperty('PrinterName', 'string', iptr);
    RegisterProperty('PrinterPort', 'string', iptrw);
    RegisterProperty('PrinterDriver', 'string', iptr);
    RegisterProperty('BinIndex', 'Byte', iptrw);
    RegisterProperty('PaperIndex', 'Byte', iptrw);
    RegisterProperty('DpiX', 'Integer', iptrw);
    RegisterProperty('DpiY', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclPrint(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('CCHBinName','LongInt').SetInt( 24);
 CL.AddConstantN('CCHPaperName','LongInt').SetInt( 64);
 CL.AddConstantN('CBinMax','LongInt').SetInt( 256);
 CL.AddConstantN('CPaperNames','LongInt').SetInt( 256);
  //CL.AddTypeS('PWordArray', '^TWordArray // will not work');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclPrinterError');
  SIRegister_TJclPrintSet(CL);
 CL.AddDelphiFunction('Procedure DirectPrint( const Printer, Data : string)');
 CL.AddDelphiFunction('Procedure SetPrinterPixelsPerInch');
 CL.AddDelphiFunction('Function GetPrinterResolution : TPoint');
 CL.AddDelphiFunction('Function CharFitsWithinDots( const Text : string; const Dots : Integer) : Integer');
 CL.AddDelphiFunction('Procedure PrintMemo( const Memo : TMemo; const Rect : TRect)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJclPrintSetDpiY_W(Self: TJclPrintSet; const T: Integer);
begin Self.DpiY := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetDpiY_R(Self: TJclPrintSet; var T: Integer);
begin T := Self.DpiY; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetDpiX_W(Self: TJclPrintSet; const T: Integer);
begin Self.DpiX := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetDpiX_R(Self: TJclPrintSet; var T: Integer);
begin T := Self.DpiX; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetPaperIndex_W(Self: TJclPrintSet; const T: Byte);
begin Self.PaperIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetPaperIndex_R(Self: TJclPrintSet; var T: Byte);
begin T := Self.PaperIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetBinIndex_W(Self: TJclPrintSet; const T: Byte);
begin Self.BinIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetBinIndex_R(Self: TJclPrintSet; var T: Byte);
begin T := Self.BinIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetPrinterDriver_R(Self: TJclPrintSet; var T: string);
begin T := Self.PrinterDriver; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetPrinterPort_W(Self: TJclPrintSet; const T: string);
begin Self.PrinterPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetPrinterPort_R(Self: TJclPrintSet; var T: string);
begin T := Self.PrinterPort; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetPrinterName_R(Self: TJclPrintSet; var T: string);
begin T := Self.PrinterName; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetTrueTypeOption_W(Self: TJclPrintSet; const T: Integer);
begin Self.TrueTypeOption := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetTrueTypeOption_R(Self: TJclPrintSet; var T: Integer);
begin T := Self.TrueTypeOption; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetYResolution_W(Self: TJclPrintSet; const T: Integer);
begin Self.YResolution := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetYResolution_R(Self: TJclPrintSet; var T: Integer);
begin T := Self.YResolution; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetDuplex_W(Self: TJclPrintSet; const T: Integer);
begin Self.Duplex := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetDuplex_R(Self: TJclPrintSet; var T: Integer);
begin T := Self.Duplex; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetColor_W(Self: TJclPrintSet; const T: Integer);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetColor_R(Self: TJclPrintSet; var T: Integer);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetPrintQuality_W(Self: TJclPrintSet; const T: Integer);
begin Self.PrintQuality := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetPrintQuality_R(Self: TJclPrintSet; var T: Integer);
begin T := Self.PrintQuality; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetDefaultSource_W(Self: TJclPrintSet; const T: Integer);
begin Self.DefaultSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetDefaultSource_R(Self: TJclPrintSet; var T: Integer);
begin T := Self.DefaultSource; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetCopies_W(Self: TJclPrintSet; const T: Integer);
begin Self.Copies := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetCopies_R(Self: TJclPrintSet; var T: Integer);
begin T := Self.Copies; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetScale_W(Self: TJclPrintSet; const T: Integer);
begin Self.Scale := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetScale_R(Self: TJclPrintSet; var T: Integer);
begin T := Self.Scale; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetPaperWidth_W(Self: TJclPrintSet; const T: Integer);
begin Self.PaperWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetPaperWidth_R(Self: TJclPrintSet; var T: Integer);
begin T := Self.PaperWidth; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetPaperLength_W(Self: TJclPrintSet; const T: Integer);
begin Self.PaperLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetPaperLength_R(Self: TJclPrintSet; var T: Integer);
begin T := Self.PaperLength; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetPaperSize_W(Self: TJclPrintSet; const T: Integer);
begin Self.PaperSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetPaperSize_R(Self: TJclPrintSet; var T: Integer);
begin T := Self.PaperSize; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetOrientation_W(Self: TJclPrintSet; const T: Integer);
begin Self.Orientation := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclPrintSetOrientation_R(Self: TJclPrintSet; var T: Integer);
begin T := Self.Orientation; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclPrint_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DirectPrint, 'DirectPrint', cdRegister);
 S.RegisterDelphiFunction(@SetPrinterPixelsPerInch, 'SetPrinterPixelsPerInch', cdRegister);
 S.RegisterDelphiFunction(@GetPrinterResolution, 'GetPrinterResolution', cdRegister);
 S.RegisterDelphiFunction(@CharFitsWithinDots, 'CharFitsWithinDots', cdRegister);
 S.RegisterDelphiFunction(@PrintMemo, 'PrintMemo', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPrintSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPrintSet) do begin
    RegisterConstructor(@TJclPrintSet.Create, 'Create');
       RegisterMethod(@TJclPrintSet.Destroy, 'Free');
     RegisterMethod(@TJclPrintSet.GetBinSourceList, 'GetBinSourceList');
    RegisterMethod(@TJclPrintSet.GetPaperList, 'GetPaperList');
    RegisterMethod(@TJclPrintSet.SetDeviceMode, 'SetDeviceMode');
    RegisterMethod(@TJclPrintSet.UpdateDeviceMode, 'UpdateDeviceMode');
    RegisterMethod(@TJclPrintSet.SaveToDefaults, 'SaveToDefaults');
    RegisterMethod(@TJclPrintSet.SavePrinterAsDefault, 'SavePrinterAsDefault');
    RegisterMethod(@TJclPrintSet.ResetPrinterDialogs, 'ResetPrinterDialogs');
    RegisterMethod(@TJclPrintSet.XInchToDot, 'XInchToDot');
    RegisterMethod(@TJclPrintSet.YInchToDot, 'YInchToDot');
    RegisterMethod(@TJclPrintSet.XCmToDot, 'XCmToDot');
    RegisterMethod(@TJclPrintSet.YCmToDot, 'YCmToDot');
    RegisterMethod(@TJclPrintSet.CpiToDot, 'CpiToDot');
    RegisterMethod(@TJclPrintSet.LpiToDot, 'LpiToDot');
    RegisterMethod(@TJclPrintSet.TextOutInch, 'TextOutInch');
    RegisterMethod(@TJclPrintSet.TextOutCm, 'TextOutCm');
    RegisterMethod(@TJclPrintSet.TextOutCpiLpi, 'TextOutCpiLpi');
    RegisterMethod(@TJclPrintSet.CustomPageSetup, 'CustomPageSetup');
    RegisterMethod(@TJclPrintSet.SaveToIniFile, 'SaveToIniFile');
    RegisterMethod(@TJclPrintSet.ReadFromIniFile, 'ReadFromIniFile');
    RegisterPropertyHelper(@TJclPrintSetOrientation_R,@TJclPrintSetOrientation_W,'Orientation');
    RegisterPropertyHelper(@TJclPrintSetPaperSize_R,@TJclPrintSetPaperSize_W,'PaperSize');
    RegisterPropertyHelper(@TJclPrintSetPaperLength_R,@TJclPrintSetPaperLength_W,'PaperLength');
    RegisterPropertyHelper(@TJclPrintSetPaperWidth_R,@TJclPrintSetPaperWidth_W,'PaperWidth');
    RegisterPropertyHelper(@TJclPrintSetScale_R,@TJclPrintSetScale_W,'Scale');
    RegisterPropertyHelper(@TJclPrintSetCopies_R,@TJclPrintSetCopies_W,'Copies');
    RegisterPropertyHelper(@TJclPrintSetDefaultSource_R,@TJclPrintSetDefaultSource_W,'DefaultSource');
    RegisterPropertyHelper(@TJclPrintSetPrintQuality_R,@TJclPrintSetPrintQuality_W,'PrintQuality');
    RegisterPropertyHelper(@TJclPrintSetColor_R,@TJclPrintSetColor_W,'Color');
    RegisterPropertyHelper(@TJclPrintSetDuplex_R,@TJclPrintSetDuplex_W,'Duplex');
    RegisterPropertyHelper(@TJclPrintSetYResolution_R,@TJclPrintSetYResolution_W,'YResolution');
    RegisterPropertyHelper(@TJclPrintSetTrueTypeOption_R,@TJclPrintSetTrueTypeOption_W,'TrueTypeOption');
    RegisterPropertyHelper(@TJclPrintSetPrinterName_R,nil,'PrinterName');
    RegisterPropertyHelper(@TJclPrintSetPrinterPort_R,@TJclPrintSetPrinterPort_W,'PrinterPort');
    RegisterPropertyHelper(@TJclPrintSetPrinterDriver_R,nil,'PrinterDriver');
    RegisterPropertyHelper(@TJclPrintSetBinIndex_R,@TJclPrintSetBinIndex_W,'BinIndex');
    RegisterPropertyHelper(@TJclPrintSetPaperIndex_R,@TJclPrintSetPaperIndex_W,'PaperIndex');
    RegisterPropertyHelper(@TJclPrintSetDpiX_R,@TJclPrintSetDpiX_W,'DpiX');
    RegisterPropertyHelper(@TJclPrintSetDpiY_R,@TJclPrintSetDpiY_W,'DpiY');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclPrint(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJclPrinterError) do
  RIRegister_TJclPrintSet(CL);
end;

 
 
{ TPSImport_JclPrint }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclPrint.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclPrint(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclPrint.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclPrint(ri);
  RIRegister_JclPrint_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
