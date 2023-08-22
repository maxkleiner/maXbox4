unit uPSI_neuralvolumev;
{
ane CAI mistake on history   - load image 3
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
  TPSImport_neuralvolumev = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_neuralvolumev(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_neuralvolumev_Routines(S: TPSExec);

procedure Register;

implementation


uses
   ExtCtrls
  ,Graphics
  ,neuralvolume
  ,neuralvolumev
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_neuralvolumev]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_neuralvolumev(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure SaveHandleToBitmap( OutputFileName : string; hWnd : HWND)');
 CL.AddDelphiFunction('Procedure LoadVolumeIntoTImage( V : TNNetVolume; Image : TImage; color_encoding : integer)');
 CL.AddDelphiFunction('Procedure LoadRGBVolumeIntoTImage( V : TNNetVolume; Image : TImage)');
 CL.AddDelphiFunction('Procedure LoadPictureIntoVolume( LocalPicture : TPicture; Vol : TNNetVolume)');
 CL.AddDelphiFunction('Procedure LoadBitmapIntoVolume( LocalBitmap : TBitmap; Vol : TNNetVolume)');
 CL.AddDelphiFunction('Procedure LoadImageFromFileIntoVolume( ImageFileName : string; V : TNNetVolume)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_neuralvolumev_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SaveHandleToBitmap, 'SaveHandleToBitmap', cdRegister);
 S.RegisterDelphiFunction(@LoadVolumeIntoTImage, 'LoadVolumeIntoTImage', cdRegister);
 S.RegisterDelphiFunction(@LoadRGBVolumeIntoTImage, 'LoadRGBVolumeIntoTImage', cdRegister);
 S.RegisterDelphiFunction(@LoadPictureIntoVolume, 'LoadPictureIntoVolume', cdRegister);
 S.RegisterDelphiFunction(@LoadBitmapIntoVolume, 'LoadBitmapIntoVolume', cdRegister);
 S.RegisterDelphiFunction(@LoadImageFromFileIntoVolume, 'LoadImageFromFileIntoVolume', cdRegister);
end;

 
 
{ TPSImport_neuralvolumev }
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralvolumev.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_neuralvolumev(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralvolumev.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_neuralvolumev_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
