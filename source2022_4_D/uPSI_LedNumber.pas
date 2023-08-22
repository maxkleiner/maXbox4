unit uPSI_LedNumber;
{
   bcd led
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
  TPSImport_LedNumber = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TLEDNumber(CL: TPSPascalCompiler);
procedure SIRegister_TCustomLEDNumber(CL: TPSPascalCompiler);
procedure SIRegister_LedNumber(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TLEDNumber(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomLEDNumber(CL: TPSRuntimeClassImporter);
procedure RIRegister_LedNumber(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Messages
  ,Controls
  ,Graphics
  ,LedNumber
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_LedNumber]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TLEDNumber(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomLEDNumber', 'TLEDNumber') do
  with CL.AddClassN(CL.FindClass('TCustomLEDNumber'),'TLEDNumber') do begin
       RegisterpublishedProperties;
    RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('CANVAS', 'TCanvas', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     //RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('Bevels', 'tcyBevels', iptrw);
    RegisterProperty('Wallpaper', 'TcyBgPicture', iptrw);
      RegisterProperty('onClick', 'TNotifyEvent', iptrw);
    RegisterProperty('onDblClick', 'TNotifyEvent', iptrw);
    RegisterProperty('Background', 'TcyGradient', iptrw);
    RegisterProperty('BorderWidth', 'Integer', iptrw);
    RegisterProperty('CellHeight', 'integer', iptrw);
    RegisterProperty('CellWidth', 'Integer', iptrw);
    RegisterProperty('ColCount', 'integer', iptrw);
    RegisterProperty('RowCount', 'Integer', iptrw);
    RegisterProperty('CellFrameColor', 'TColor', iptrw);
    RegisterProperty('CellFrameWidth', 'Integer', iptrw);
    RegisterProperty('CellSpacingWidth', 'integer', iptrw);
    RegisterProperty('CellSpacingHeight', 'Integer', iptrw);
    RegisterProperty('DefaultColor', 'TColor', iptrw);
    RegisterProperty('TopRowValue', 'Double', iptrw);
    RegisterProperty('OnPaint', 'TNotifyEvent', iptrw);
    RegisterProperty('OnCellClick', 'TProcOnCellClick', iptrw);
    RegisterProperty('OnCustomDrawCell', 'TProcOnDrawCell', iptrw);
    RegisterProperty('LeftColumnValue', 'Double', iptrw);
    RegisterProperty('BottomRowValue', 'Double', iptrw);
    RegisterProperty('RightColumnValue', 'Double', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomLEDNumber(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TCustomLEDNumber') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TCustomLEDNumber') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
        RegisterMethod('Procedure Free');
     RegisterProperty('Version', 'string', iptrw);
    RegisterProperty('BorderStyle', 'TLedNumberBorderStyle', iptrw);
    RegisterProperty('Columns', 'Integer', iptrw);
    RegisterProperty('Rows', 'Integer', iptrw);
    RegisterProperty('BgColor', 'TColor', iptrw);
    RegisterProperty('OffColor', 'TColor', iptrw);
    RegisterProperty('OnColor', 'TColor', iptrw);
    RegisterProperty('Size', 'TSegmentSize', iptrw);
    RegisterProperty('Transparent', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_LedNumber(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TLedSegmentSize', 'Integer');
  CL.AddTypeS('TLedNumberBorderStyle', '( lnbNone, lnbSingle, lnbSunken, lnbRaised )');
  SIRegister_TCustomLEDNumber(CL);
  SIRegister_TLEDNumber(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomLEDNumberTransparent_W(Self: TCustomLEDNumber; const T: boolean);
begin Self.Transparent := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLEDNumberTransparent_R(Self: TCustomLEDNumber; var T: boolean);
begin T := Self.Transparent; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLEDNumberSize_W(Self: TCustomLEDNumber; const T: TSegmentSize);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLEDNumberSize_R(Self: TCustomLEDNumber; var T: TSegmentSize);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLEDNumberOnColor_W(Self: TCustomLEDNumber; const T: TColor);
begin Self.OnColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLEDNumberOnColor_R(Self: TCustomLEDNumber; var T: TColor);
begin T := Self.OnColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLEDNumberOffColor_W(Self: TCustomLEDNumber; const T: TColor);
begin Self.OffColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLEDNumberOffColor_R(Self: TCustomLEDNumber; var T: TColor);
begin T := Self.OffColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLEDNumberBgColor_W(Self: TCustomLEDNumber; const T: TColor);
begin Self.BgColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLEDNumberBgColor_R(Self: TCustomLEDNumber; var T: TColor);
begin T := Self.BgColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLEDNumberRows_W(Self: TCustomLEDNumber; const T: Integer);
begin Self.Rows := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLEDNumberRows_R(Self: TCustomLEDNumber; var T: Integer);
begin T := Self.Rows; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLEDNumberColumns_W(Self: TCustomLEDNumber; const T: Integer);
begin Self.Columns := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLEDNumberColumns_R(Self: TCustomLEDNumber; var T: Integer);
begin T := Self.Columns; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLEDNumberBorderStyle_W(Self: TCustomLEDNumber; const T: TLedNumberBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLEDNumberBorderStyle_R(Self: TCustomLEDNumber; var T: TLedNumberBorderStyle);
begin T := Self.BorderStyle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLEDNumberVersion_W(Self: TCustomLEDNumber; const T: string);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLEDNumberVersion_R(Self: TCustomLEDNumber; var T: string);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLEDNumber(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLEDNumber) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomLEDNumber(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomLEDNumber) do begin
    RegisterConstructor(@TCustomLEDNumber.Create, 'Create');
      RegisterMethod(@TCustomLEDNumber.Destroy, 'Free');
    RegisterPropertyHelper(@TCustomLEDNumberVersion_R,@TCustomLEDNumberVersion_W,'Version');
    RegisterPropertyHelper(@TCustomLEDNumberBorderStyle_R,@TCustomLEDNumberBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@TCustomLEDNumberColumns_R,@TCustomLEDNumberColumns_W,'Columns');
    RegisterPropertyHelper(@TCustomLEDNumberRows_R,@TCustomLEDNumberRows_W,'Rows');
    RegisterPropertyHelper(@TCustomLEDNumberBgColor_R,@TCustomLEDNumberBgColor_W,'BgColor');
    RegisterPropertyHelper(@TCustomLEDNumberOffColor_R,@TCustomLEDNumberOffColor_W,'OffColor');
    RegisterPropertyHelper(@TCustomLEDNumberOnColor_R,@TCustomLEDNumberOnColor_W,'OnColor');
    RegisterPropertyHelper(@TCustomLEDNumberSize_R,@TCustomLEDNumberSize_W,'Size');
    RegisterPropertyHelper(@TCustomLEDNumberTransparent_R,@TCustomLEDNumberTransparent_W,'Transparent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_LedNumber(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCustomLEDNumber(CL);
  RIRegister_TLEDNumber(CL);
end;

 
 
{ TPSImport_LedNumber }
(*----------------------------------------------------------------------------*)
procedure TPSImport_LedNumber.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_LedNumber(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_LedNumber.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_LedNumber(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
