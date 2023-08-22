unit uPSI_JvgDigits;
{
another number cruncher       V2
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
  TPSImport_JvgDigits = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvgDigits(CL: TPSPascalCompiler);
procedure SIRegister_JvgDigits(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvgDigits(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvgDigits(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
 //  JclUnitVersioning
  Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,ExtCtrls
  //,JvComponent
  //,JvgTypes
  ,JvgUtils_max
  ,JvgCommClasses
  ,JvgDigits
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvgDigits]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgDigits(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvGraphicControl', 'TJvgDigits') do
  with CL.AddClassN(CL.FindClass('TJvGraphicControl'),'TJvgDigits') do begin
    RegisterMethod('Procedure Paint');
    RegisterMethod('Procedure PaintTo( Canvas : TCanvas)');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
     RegisterProperty('Value', 'Double', iptrw);
    RegisterProperty('DigitSize', 'TJvgPointClass', iptrw);
    RegisterProperty('ActiveColor', 'TColor', iptrw);
    RegisterProperty('PassiveColor', 'TColor', iptrw);
    RegisterProperty('BackgroundColor', 'TColor', iptrw);
    RegisterProperty('Positions', 'Word', iptrw);
    RegisterProperty('PenWidth', 'Word', iptrw);
    RegisterProperty('Gap', 'Word', iptrw);
    RegisterProperty('Interspace', 'Word', iptrw);
    RegisterProperty('Transparent', 'Boolean', iptrw);
    RegisterProperty('Alignment', 'TAlignment', iptrw);
    RegisterProperty('InteriorOffset', 'Word', iptrw);
    RegisterProperty('InsertSpecialSymbolAt', 'Integer', iptrw);
    RegisterProperty('PenStyle', 'TPenStyle', iptrw);
    RegisterProperty('SpecialSymbol', 'TJvgSpecialSymbol', iptrw);
    RegisterProperty('Bevel', 'TJvgExtBevelOptions', iptrw);
    RegisterProperty('Gradient', 'TJvgGradient', iptrw);
    RegisterProperty('DigitCount', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvgDigits(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('JvDefaultPassiveColor','LongWord').SetUInt( TColor ( $00202020 ));
  CL.AddTypeS('TJvgSpecialSymbol', '( ssyNone, ssyColon, ssySlash, ssyBackslash)');
  SIRegister_TJvgDigits(CL);
  CL.AddTypeS('TJvgGraphDigitsElem', '( dlT, dlC, dlB, dlTL, dlTR, dlBL, dlBR,dlDOT )');
  CL.AddTypeS('TJvgGraphDigitsElemSet', 'set of TJvgGraphDigitsElem');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvgDigitsDigitCount_W(Self: TJvgDigits; const T: Integer);
begin Self.DigitCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsDigitCount_R(Self: TJvgDigits; var T: Integer);
begin T := Self.DigitCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsGradient_W(Self: TJvgDigits; const T: TJvgGradient);
begin Self.Gradient := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsGradient_R(Self: TJvgDigits; var T: TJvgGradient);
begin T := Self.Gradient; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsBevel_W(Self: TJvgDigits; const T: TJvgExtBevelOptions);
begin Self.Bevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsBevel_R(Self: TJvgDigits; var T: TJvgExtBevelOptions);
begin T := Self.Bevel; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsSpecialSymbol_W(Self: TJvgDigits; const T: TJvgSpecialSymbol);
begin Self.SpecialSymbol := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsSpecialSymbol_R(Self: TJvgDigits; var T: TJvgSpecialSymbol);
begin T := Self.SpecialSymbol; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsPenStyle_W(Self: TJvgDigits; const T: TPenStyle);
begin Self.PenStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsPenStyle_R(Self: TJvgDigits; var T: TPenStyle);
begin T := Self.PenStyle; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsInsertSpecialSymbolAt_W(Self: TJvgDigits; const T: Integer);
begin Self.InsertSpecialSymbolAt := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsInsertSpecialSymbolAt_R(Self: TJvgDigits; var T: Integer);
begin T := Self.InsertSpecialSymbolAt; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsInteriorOffset_W(Self: TJvgDigits; const T: Word);
begin Self.InteriorOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsInteriorOffset_R(Self: TJvgDigits; var T: Word);
begin T := Self.InteriorOffset; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsAlignment_W(Self: TJvgDigits; const T: TAlignment);
begin Self.Alignment := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsAlignment_R(Self: TJvgDigits; var T: TAlignment);
begin T := Self.Alignment; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsTransparent_W(Self: TJvgDigits; const T: Boolean);
begin Self.Transparent := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsTransparent_R(Self: TJvgDigits; var T: Boolean);
begin T := Self.Transparent; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsInterspace_W(Self: TJvgDigits; const T: Word);
begin Self.Interspace := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsInterspace_R(Self: TJvgDigits; var T: Word);
begin T := Self.Interspace; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsGap_W(Self: TJvgDigits; const T: Word);
begin Self.Gap := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsGap_R(Self: TJvgDigits; var T: Word);
begin T := Self.Gap; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsPenWidth_W(Self: TJvgDigits; const T: Word);
begin Self.PenWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsPenWidth_R(Self: TJvgDigits; var T: Word);
begin T := Self.PenWidth; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsPositions_W(Self: TJvgDigits; const T: Word);
begin Self.Positions := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsPositions_R(Self: TJvgDigits; var T: Word);
begin T := Self.Positions; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsBackgroundColor_W(Self: TJvgDigits; const T: TColor);
begin Self.BackgroundColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsBackgroundColor_R(Self: TJvgDigits; var T: TColor);
begin T := Self.BackgroundColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsPassiveColor_W(Self: TJvgDigits; const T: TColor);
begin Self.PassiveColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsPassiveColor_R(Self: TJvgDigits; var T: TColor);
begin T := Self.PassiveColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsActiveColor_W(Self: TJvgDigits; const T: TColor);
begin Self.ActiveColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsActiveColor_R(Self: TJvgDigits; var T: TColor);
begin T := Self.ActiveColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsDigitSize_W(Self: TJvgDigits; const T: TJvgPointClass);
begin Self.DigitSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsDigitSize_R(Self: TJvgDigits; var T: TJvgPointClass);
begin T := Self.DigitSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsValue_W(Self: TJvgDigits; const T: Double);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgDigitsValue_R(Self: TJvgDigits; var T: Double);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgDigits(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgDigits) do begin
    RegisterMethod(@TJvgDigits.Paint, 'Paint');
    RegisterMethod(@TJvgDigits.PaintTo, 'PaintTo');
    RegisterConstructor(@TJvgDigits.Create, 'Create');
     RegisterMethod(@TJvgDigits.Destroy, 'Free');
     RegisterPropertyHelper(@TJvgDigitsValue_R,@TJvgDigitsValue_W,'Value');
    RegisterPropertyHelper(@TJvgDigitsDigitSize_R,@TJvgDigitsDigitSize_W,'DigitSize');
    RegisterPropertyHelper(@TJvgDigitsActiveColor_R,@TJvgDigitsActiveColor_W,'ActiveColor');
    RegisterPropertyHelper(@TJvgDigitsPassiveColor_R,@TJvgDigitsPassiveColor_W,'PassiveColor');
    RegisterPropertyHelper(@TJvgDigitsBackgroundColor_R,@TJvgDigitsBackgroundColor_W,'BackgroundColor');
    RegisterPropertyHelper(@TJvgDigitsPositions_R,@TJvgDigitsPositions_W,'Positions');
    RegisterPropertyHelper(@TJvgDigitsPenWidth_R,@TJvgDigitsPenWidth_W,'PenWidth');
    RegisterPropertyHelper(@TJvgDigitsGap_R,@TJvgDigitsGap_W,'Gap');
    RegisterPropertyHelper(@TJvgDigitsInterspace_R,@TJvgDigitsInterspace_W,'Interspace');
    RegisterPropertyHelper(@TJvgDigitsTransparent_R,@TJvgDigitsTransparent_W,'Transparent');
    RegisterPropertyHelper(@TJvgDigitsAlignment_R,@TJvgDigitsAlignment_W,'Alignment');
    RegisterPropertyHelper(@TJvgDigitsInteriorOffset_R,@TJvgDigitsInteriorOffset_W,'InteriorOffset');
    RegisterPropertyHelper(@TJvgDigitsInsertSpecialSymbolAt_R,@TJvgDigitsInsertSpecialSymbolAt_W,'InsertSpecialSymbolAt');
    RegisterPropertyHelper(@TJvgDigitsPenStyle_R,@TJvgDigitsPenStyle_W,'PenStyle');
    RegisterPropertyHelper(@TJvgDigitsSpecialSymbol_R,@TJvgDigitsSpecialSymbol_W,'SpecialSymbol');
    RegisterPropertyHelper(@TJvgDigitsBevel_R,@TJvgDigitsBevel_W,'Bevel');
    RegisterPropertyHelper(@TJvgDigitsGradient_R,@TJvgDigitsGradient_W,'Gradient');
    RegisterPropertyHelper(@TJvgDigitsDigitCount_R,@TJvgDigitsDigitCount_W,'DigitCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvgDigits(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvgDigits(CL);
end;

 
 
{ TPSImport_JvgDigits }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvgDigits.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvgDigits(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvgDigits.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvgDigits(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
