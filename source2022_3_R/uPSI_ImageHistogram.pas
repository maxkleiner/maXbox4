unit uPSI_ImageHistogram;
{
for histo analyse patterns recog  - map functions

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
  TPSImport_ImageHistogram = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_THistogram(CL: TPSPascalCompiler);
procedure SIRegister_ImageHistogram(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ImageHistogram_Routines(S: TPSExec);
procedure RIRegister_THistogram(CL: TPSRuntimeClassImporter);
procedure RIRegister_ImageHistogram(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Graphics
  ,ImageHistogram
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ImageHistogram]);
end;

procedure AdjustBitmap1(Bmp: TBitmap; Hist: THistogram; Channel: THistogramChannel = hclGray;
                        Tolerance: Cardinal = 0); //overload;
begin
   AdjustBitmap(Bmp, Hist, Channel, Tolerance);

end;

procedure AdjustBitmap2(Bmp: TBitmap; Low, High: Byte; Channel: THistogramChannel = hclGray); //overload;
begin
   AdjustBitmap(Bmp, low, high, Channel);
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_THistogram(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'THistogram') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'THistogram') do begin
    RegisterMethod('Constructor Create( Bmp : TBitmap)');
    RegisterMethod('Procedure Init( Bmp : TBitmap)');
    RegisterProperty('Channel', 'THistogramArray THistogramChannel', iptr);
    SetDefaultPropery('Channel');
    RegisterProperty('Pixels', 'Cardinal', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ImageHistogram(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('THistogramChannel', '( hclGray, hclRed, hclGreen, hclBlue )');
   CL.AddTypeS('THistogramArray', 'array[0..255] of Cardinal;');

  //THistogramArray = array[0..255] of Cardinal;
  SIRegister_THistogram(CL);
 CL.AddDelphiFunction('Procedure AdjustBitmap( Bmp : TBitmap; Channel : THistogramChannel; Tolerance : Cardinal);');
 CL.AddDelphiFunction('Procedure AdjustBitmap1( Bmp : TBitmap; Hist : THistogram; Channel : THistogramChannel; Tolerance : Cardinal);');
 CL.AddDelphiFunction('Procedure AdjustBitmap2( Bmp : TBitmap; Low, High : Byte; Channel : THistogramChannel);');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure AdjustBitmap2_P( Bmp : TBitmap; Low, High : Byte; Channel : THistogramChannel);
Begin ImageHistogram.AdjustBitmap(Bmp, Low, High, Channel); END;

(*----------------------------------------------------------------------------*)
Procedure AdjustBitmap1_P( Bmp : TBitmap; Hist : THistogram; Channel : THistogramChannel; Tolerance : Cardinal);
Begin ImageHistogram.AdjustBitmap(Bmp, Hist, Channel, Tolerance); END;

(*----------------------------------------------------------------------------*)
Procedure AdjustBitmap0_P( Bmp : TBitmap; Channel : THistogramChannel; Tolerance : Cardinal);
Begin ImageHistogram.AdjustBitmap(Bmp, Channel, Tolerance); END;

(*----------------------------------------------------------------------------*)
procedure THistogramPixels_R(Self: THistogram; var T: Cardinal);
begin T := Self.Pixels; end;

(*----------------------------------------------------------------------------*)
procedure THistogramChannel_R(Self: THistogram; var T: THistogramArray; const t1: THistogramChannel);
begin T := Self.Channel[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ImageHistogram_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AdjustBitmap0_P, 'AdjustBitmap', cdRegister);
 S.RegisterDelphiFunction(@AdjustBitmap1_P, 'AdjustBitmap1', cdRegister);
 S.RegisterDelphiFunction(@AdjustBitmap2_P, 'AdjustBitmap2', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THistogram(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THistogram) do begin
    RegisterConstructor(@THistogram.Create, 'Create');
    RegisterMethod(@THistogram.Init, 'Init');
    RegisterPropertyHelper(@THistogramChannel_R,nil,'Channel');
    RegisterPropertyHelper(@THistogramPixels_R,nil,'Pixels');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ImageHistogram(CL: TPSRuntimeClassImporter);
begin
  RIRegister_THistogram(CL);
end;

 
 
{ TPSImport_ImageHistogram }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ImageHistogram.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ImageHistogram(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ImageHistogram.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ImageHistogram(ri);
  RIRegister_ImageHistogram_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
