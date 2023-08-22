unit uPSI_Barcode;
{
   for scholz industries
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
  TPSImport_Barcode = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAsBarcode(CL: TPSPascalCompiler);
procedure SIRegister_Barcode(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Barcode_Routines(S: TPSExec);
procedure RIRegister_TAsBarcode(CL: TPSRuntimeClassImporter);
procedure RIRegister_Barcode(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Graphics
  ,Barcode
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Barcode]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAsBarcode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TAsBarcode') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TAsBarcode') do begin
    RegisterMethod('Constructor Create( Owner : TComponent)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
   RegisterMethod('Procedure Free');
     RegisterMethod('Procedure DrawBarcode( Canvas : TCanvas)');
    RegisterMethod('Procedure DrawText( Canvas : TCanvas)');
    RegisterProperty('CanvasHeight', 'Integer', iptr);
    RegisterProperty('CanvasWidth', 'Integer', iptr);
    RegisterProperty('Height', 'integer', iptrw);
    RegisterProperty('Text', 'string', iptrw);
    RegisterProperty('Top', 'Integer', iptrw);
    RegisterProperty('Left', 'Integer', iptrw);
    RegisterProperty('Modul', 'integer', iptrw);
    RegisterProperty('Ratio', 'Double', iptrw);
    RegisterProperty('Typ', 'TBarcodeType', iptrw);
    RegisterProperty('Checksum', 'boolean', iptrw);
    RegisterProperty('CheckSumMethod', 'TCheckSumMethod', iptrw);
    RegisterProperty('Angle', 'double', iptrw);
    RegisterProperty('ShowText', 'TBarcodeOption', iptrw);
    RegisterProperty('ShowTextFont', 'TFont', iptrw);
    RegisterProperty('ShowTextPosition', 'TShowTextPosition', iptrw);
    RegisterProperty('Width', 'integer', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('ColorBar', 'TColor', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Barcode(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('mmPerInch','Extended').setExtended( 25.4);
  CL.AddTypeS('TBarcodeType', '( bcCode_2_5_interleaved, bcCode_2_5_industrial,'
   +' bcCode_2_5_matrix, bcCode39, bcCode39Extended, bcCode128A, bcCode128B, bc'
   +'Code128C, bcCode93, bcCode93Extended, bcCodeMSI, bcCodePostNet, bcCodeCoda'
   +'bar, bcCodeEAN8, bcCodeEAN13, bcCodeUPC_A, bcCodeUPC_E0, bcCodeUPC_E1, bcC'
   +'odeUPC_Supp2, bcCodeUPC_Supp5, bcCodeEAN128A, bcCodeEAN128B, bcCodeEAN128C)');
  CL.AddTypeS('TBarLineType', '( white, black, black_half )');
  CL.AddTypeS('TBarcodeOption', '( bcoNone, bcoCode, bcoTyp, bcoBoth )');
  CL.AddTypeS('TShowTextPosition', '( stpTopLeft, stpTopRight, stpTopCenter, st'
   +'pBottomLeft, stpBottomRight, stpBottomCenter )');
  CL.AddTypeS('TCheckSumMethod', '( csmNone, csmModulo10 )');
  SIRegister_TAsBarcode(CL);
 CL.AddDelphiFunction('Function CheckSumModulo10( const data : string) : string');
 CL.AddDelphiFunction('Function ConvertMmToPixelsX( const Value : Double) : Integer');
 CL.AddDelphiFunction('Function ConvertMmToPixelsY( const Value : Double) : Integer');
 CL.AddDelphiFunction('Function ConvertInchToPixelsX( const Value : Double) : Integer');
 CL.AddDelphiFunction('Function ConvertInchToPixelsY( const Value : Double) : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAsBarcodeOnChange_W(Self: TAsBarcode; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeOnChange_R(Self: TAsBarcode; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeColorBar_W(Self: TAsBarcode; const T: TColor);
begin Self.ColorBar := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeColorBar_R(Self: TAsBarcode; var T: TColor);
begin T := Self.ColorBar; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeColor_W(Self: TAsBarcode; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeColor_R(Self: TAsBarcode; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeWidth_W(Self: TAsBarcode; const T: integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeWidth_R(Self: TAsBarcode; var T: integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeShowTextPosition_W(Self: TAsBarcode; const T: TShowTextPosition);
begin Self.ShowTextPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeShowTextPosition_R(Self: TAsBarcode; var T: TShowTextPosition);
begin T := Self.ShowTextPosition; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeShowTextFont_W(Self: TAsBarcode; const T: TFont);
begin Self.ShowTextFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeShowTextFont_R(Self: TAsBarcode; var T: TFont);
begin T := Self.ShowTextFont; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeShowText_W(Self: TAsBarcode; const T: TBarcodeOption);
begin Self.ShowText := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeShowText_R(Self: TAsBarcode; var T: TBarcodeOption);
begin T := Self.ShowText; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeAngle_W(Self: TAsBarcode; const T: double);
begin Self.Angle := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeAngle_R(Self: TAsBarcode; var T: double);
begin T := Self.Angle; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeCheckSumMethod_W(Self: TAsBarcode; const T: TCheckSumMethod);
begin Self.CheckSumMethod := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeCheckSumMethod_R(Self: TAsBarcode; var T: TCheckSumMethod);
begin T := Self.CheckSumMethod; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeChecksum_W(Self: TAsBarcode; const T: boolean);
begin Self.Checksum := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeChecksum_R(Self: TAsBarcode; var T: boolean);
begin T := Self.Checksum; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeTyp_W(Self: TAsBarcode; const T: TBarcodeType);
begin Self.Typ := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeTyp_R(Self: TAsBarcode; var T: TBarcodeType);
begin T := Self.Typ; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeRatio_W(Self: TAsBarcode; const T: Double);
begin Self.Ratio := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeRatio_R(Self: TAsBarcode; var T: Double);
begin T := Self.Ratio; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeModul_W(Self: TAsBarcode; const T: integer);
begin Self.Modul := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeModul_R(Self: TAsBarcode; var T: integer);
begin T := Self.Modul; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeLeft_W(Self: TAsBarcode; const T: Integer);
begin Self.Left := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeLeft_R(Self: TAsBarcode; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeTop_W(Self: TAsBarcode; const T: Integer);
begin Self.Top := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeTop_R(Self: TAsBarcode; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeText_W(Self: TAsBarcode; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeText_R(Self: TAsBarcode; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeHeight_W(Self: TAsBarcode; const T: integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeHeight_R(Self: TAsBarcode; var T: integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeCanvasWidth_R(Self: TAsBarcode; var T: Integer);
begin T := Self.CanvasWidth; end;

(*----------------------------------------------------------------------------*)
procedure TAsBarcodeCanvasHeight_R(Self: TAsBarcode; var T: Integer);
begin T := Self.CanvasHeight; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Barcode_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CheckSumModulo10, 'CheckSumModulo10', cdRegister);
 S.RegisterDelphiFunction(@ConvertMmToPixelsX, 'ConvertMmToPixelsX', cdRegister);
 S.RegisterDelphiFunction(@ConvertMmToPixelsY, 'ConvertMmToPixelsY', cdRegister);
 S.RegisterDelphiFunction(@ConvertInchToPixelsX, 'ConvertInchToPixelsX', cdRegister);
 S.RegisterDelphiFunction(@ConvertInchToPixelsY, 'ConvertInchToPixelsY', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAsBarcode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAsBarcode) do begin
    RegisterConstructor(@TAsBarcode.Create, 'Create');
    RegisterMethod(@TAsBarcode.Assign, 'Assign');
    RegisterMethod(@TAsBarcode.Destroy, 'Free');

    RegisterMethod(@TAsBarcode.DrawBarcode, 'DrawBarcode');
    RegisterMethod(@TAsBarcode.DrawText, 'DrawText');
    RegisterPropertyHelper(@TAsBarcodeCanvasHeight_R,nil,'CanvasHeight');
    RegisterPropertyHelper(@TAsBarcodeCanvasWidth_R,nil,'CanvasWidth');
    RegisterPropertyHelper(@TAsBarcodeHeight_R,@TAsBarcodeHeight_W,'Height');
    RegisterPropertyHelper(@TAsBarcodeText_R,@TAsBarcodeText_W,'Text');
    RegisterPropertyHelper(@TAsBarcodeTop_R,@TAsBarcodeTop_W,'Top');
    RegisterPropertyHelper(@TAsBarcodeLeft_R,@TAsBarcodeLeft_W,'Left');
    RegisterPropertyHelper(@TAsBarcodeModul_R,@TAsBarcodeModul_W,'Modul');
    RegisterPropertyHelper(@TAsBarcodeRatio_R,@TAsBarcodeRatio_W,'Ratio');
    RegisterPropertyHelper(@TAsBarcodeTyp_R,@TAsBarcodeTyp_W,'Typ');
    RegisterPropertyHelper(@TAsBarcodeChecksum_R,@TAsBarcodeChecksum_W,'Checksum');
    RegisterPropertyHelper(@TAsBarcodeCheckSumMethod_R,@TAsBarcodeCheckSumMethod_W,'CheckSumMethod');
    RegisterPropertyHelper(@TAsBarcodeAngle_R,@TAsBarcodeAngle_W,'Angle');
    RegisterPropertyHelper(@TAsBarcodeShowText_R,@TAsBarcodeShowText_W,'ShowText');
    RegisterPropertyHelper(@TAsBarcodeShowTextFont_R,@TAsBarcodeShowTextFont_W,'ShowTextFont');
    RegisterPropertyHelper(@TAsBarcodeShowTextPosition_R,@TAsBarcodeShowTextPosition_W,'ShowTextPosition');
    RegisterPropertyHelper(@TAsBarcodeWidth_R,@TAsBarcodeWidth_W,'Width');
    RegisterPropertyHelper(@TAsBarcodeColor_R,@TAsBarcodeColor_W,'Color');
    RegisterPropertyHelper(@TAsBarcodeColorBar_R,@TAsBarcodeColorBar_W,'ColorBar');
    RegisterPropertyHelper(@TAsBarcodeOnChange_R,@TAsBarcodeOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Barcode(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAsBarcode(CL);
end;

 
 
{ TPSImport_Barcode }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Barcode.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Barcode(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Barcode.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Barcode(ri);
  RIRegister_Barcode_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
