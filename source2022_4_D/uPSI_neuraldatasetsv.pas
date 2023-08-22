unit uPSI_neuraldatasetsv;
{
Tneural mindset

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
  TPSImport_neuraldatasetsv = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_neuraldatasetsv(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_neuraldatasetsv_Routines(S: TPSExec);

procedure Register;

implementation


uses
   neuraldatasets
  ,ExtCtrls
  ,Graphics
  ,neuralvolume
  ,neuralnetwork
  ,StdCtrls
  ,Windows
  ,neuraldatasetsv
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_neuraldatasetsv]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_neuraldatasetsv(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TImageDynArr', 'array of TImage');
  CL.AddTypeS('TLabelDynArr', 'array of TLabel');
 CL.AddDelphiFunction('Procedure LoadTinyImageIntoTImage( var TI : TTinyImage; var Image : TImage)');
 CL.AddDelphiFunction('Procedure LoadTISingleChannelIntoImage( var TI : TTinySingleChannelImage; var Image : TImage)');
 CL.AddDelphiFunction('Procedure ShowNeurons( pNeuronList : TNNetNeuronList; var pImage : TImageDynArr; startImage, filterSize, color_encoding : integer; ScalePerImage : boolean)');
 CL.AddDelphiFunction('Procedure CreateAscentImages( GrBoxNeurons : TGroupBox; var pImage : TImageDynArr; var pLabelX, pLabelY : TLabelDynArr; ImagesNum : integer; inputSize, displaySize, imagesPerRow : integer)');
 CL.AddDelphiFunction('Procedure CreateNeuronImages( GrBoxNeurons : TGroupBox; var pImage : TImageDynArr; var pLabelX, pLabelY : TLabelDynArr; pNeuronList : TNNetNeuronList; filterSize, imagesPerRow, NeuronNum : integer)');
 CL.AddDelphiFunction('Procedure FreeNeuronImages( var pImage : TImageDynArr; var pLabelX, pLabelY : TLabelDynArr)');
 CL.AddDelphiFunction('Procedure LoadNNLayersIntoCombo( NN : TNNet; Combo : TComboBox)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_neuraldatasetsv_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@LoadTinyImageIntoTImage, 'LoadTinyImageIntoTImage', cdRegister);
 S.RegisterDelphiFunction(@LoadTISingleChannelIntoImage, 'LoadTISingleChannelIntoImage', cdRegister);
 S.RegisterDelphiFunction(@ShowNeurons, 'ShowNeurons', cdRegister);
 S.RegisterDelphiFunction(@CreateAscentImages, 'CreateAscentImages', cdRegister);
 S.RegisterDelphiFunction(@CreateNeuronImages, 'CreateNeuronImages', cdRegister);
 S.RegisterDelphiFunction(@FreeNeuronImages, 'FreeNeuronImages', cdRegister);
 S.RegisterDelphiFunction(@LoadNNLayersIntoCombo, 'LoadNNLayersIntoCombo', cdRegister);
end;

 
 
{ TPSImport_neuraldatasetsv }
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuraldatasetsv.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_neuraldatasetsv(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuraldatasetsv.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_neuraldatasetsv_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
