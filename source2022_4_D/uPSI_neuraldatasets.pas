unit uPSI_neuraldatasets;
{
mindset let mindset set   - LoadImageIntoVolume convert to delphi
TClassesAndElements from fpc experimental   load images

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
  TPSImport_neuraldatasets = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TClassesAndElements(CL: TPSPascalCompiler);
procedure SIRegister_TFileNameList(CL: TPSPascalCompiler);
procedure SIRegister_neuraldatasets(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_neuraldatasets_Routines(S: TPSExec);
procedure RIRegister_TClassesAndElements(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFileNameList(CL: TPSRuntimeClassImporter);
procedure RIRegister_neuraldatasets(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   neuraldatasets, neuralnetworkCAI, neuralvolume , neuralthread ,math ,fmain
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_neuraldatasets]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TClassesAndElements(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringStringListVolume', 'TClassesAndElements') do
  with CL.AddClassN(CL.FindClass('TStringStringListVolume'),'TClassesAndElements') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function CountElements( ) : integer');
    RegisterMethod('Procedure LoadFoldersAsClasses( FolderName : string; pImageSubFolder : string; SkipFirst : integer; SkipLast : integer)');
    RegisterMethod('Procedure LoadFoldersAsClassesProportional( FolderName : string; pImageSubFolder : string; fSkipFirst : TNeuralFloat; fLoadLen : TNeuralFloat)');
    RegisterMethod('Procedure LoadImages0( color_encoding : integer; NewSizeX : integer; NewSizeY : integer);');
    RegisterMethod('Procedure LoadImages( color_encoding : integer; NewSizeX : integer; NewSizeY : integer);');
    RegisterMethod('Procedure LoadClass_FilenameFromFolder( FolderName : string)');
    RegisterMethod('Function GetRandomClassId( ) : integer');
    RegisterMethod('Function GetClassesCount( ) : integer');
    RegisterMethod('Procedure GetRandomFileId( out ClassId : integer; out FileId : integer; StartPos : TNeuralFloat; Range : TNeuralFloat)');
    RegisterMethod('Procedure GetRandomFileName( out ClassId : integer; out FileName : string; StartPos : TNeuralFloat; Range : TNeuralFloat)');
    RegisterMethod('Procedure GetRandomImgVolumes( vInput, vOutput : TNNetVolume; StartPos : TNeuralFloat; Range : TNeuralFloat)');
    RegisterMethod('Function GetFileName( ClassId, ElementId : integer) : string');
    RegisterMethod('Procedure AddVolumesTo( Volumes : TNNetVolumeList; EmptySource : boolean)');
    RegisterMethod('Procedure AddFileNamesTo( FileNames : TFileNameList)');
    RegisterMethod('Procedure MakeMonopolar( Divisor : TNeuralFloat)');
    RegisterMethod('Function FileCountAtClassId( ClassId : integer) : integer');
    RegisterMethod('Procedure LoadImages_NTL( index, threadnum : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFileNameList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringListInt', 'TFileNameList') do
  with CL.AddClassN(CL.FindClass('TStringListInt'),'TFileNameList') do
  begin
    RegisterMethod('Constructor Create( )');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure GetImageVolumePairFromId( ImageId : integer; vInput, vOutput : TNNetVolume; ThreadDangerous : boolean)');
    RegisterMethod('Procedure GetRandomImagePair( vInput, vOutput : TNNetVolume)');
    RegisterMethod('Function ThreadSafeLoadImageFromFileIntoVolume( ImageFileName : string; V : TNNetVolume) : boolean');
    RegisterProperty('ClassCount', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_neuraldatasets(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TTinyImageChannel','array [0..31] of array[0..31] of byte; ');
  CL.AddTypeS('TTinyImageChannel1D','array [0..32 * 32 - 1] of byte; ');
  CL.AddTypeS('TMNistImage','array [0..27] of array[0..27] of byte; ');

  //TTinyImageChannel1D = packed array [0..32 * 32 - 1] of byte;
  //TMNistImage = packed array [0..27, 0..27] of byte;

  CL.AddTypeS('TTinyImage', 'record bLabel : byte; R : TTinyImageChannel; G : T'
   +'TinyImageChannel; B : TTinyImageChannel; end');
  CL.AddTypeS('TCifar100Image', 'record bCoarseLabel : byte; bFineLabel : byte;'
   +' R : TTinyImageChannel; G : TTinyImageChannel; B : TTinyImageChannel; end');
  CL.AddTypeS('TTinySingleChannelImage', 'record bLabel : byte; Grey : TTinyImageChannel; end');
  CL.AddTypeS('TTinySingleChannelImage1D', 'record bLabel : byte; Grey : TTinyImageChannel1D; end');
  //CL.AddTypeS('TTinySingleChannelImagePtr', '^TTinySingleChannelImage // will not work');
  //CL.AddTypeS('TTinySingleChannelImage1DPtr', '^TTinySingleChannelImage1D // will not work');
  SIRegister_TFileNameList(CL);
  SIRegister_TClassesAndElements(CL);
 CL.AddDelphiFunction('Procedure CreateVolumesFromImagesFromFolder(out ImgTrainingVolumes,ImgValidationVolumes,ImgTestVolumes:TNNetVolumeList;FolderName,pImageSubFolder:string;color_encoding:integer;TrainingProp,ValidationProp,TestProp:single;'+
                                                 'NewSizeX:integer;NewSizeY:integer)');
 CL.AddDelphiFunction('Procedure CreateFileNameListsFromImagesFromFolder( out TrainingFileNames, ValidationFileNames, TestFileNames : TFileNameList; FolderName, pImageSubFolder : string; TrainingProp, ValidationProp, TestProp : single)');
 CL.AddDelphiFunction('Procedure LoadImageIntoVolume( M : TImage; Vol : TNNetVolume)');
 CL.AddDelphiFunction('Procedure LoadVolumeIntoImage( Vol : TNNetVolume; M : TImage)');
 CL.AddDelphiFunction('Function LoadImageFromFileIntoVolume( ImageFileName : string; V : TNNetVolume) : boolean');
 CL.AddDelphiFunction('Function SaveImageFromVolumeIntoFile( V : TNNetVolume; ImageFileName : string) : boolean');
 CL.AddDelphiFunction('Procedure ConfusionWriteCSVHeader( var CSVConfusion : TextFile; Labels : array of string)');
 CL.AddDelphiFunction('Procedure ConfusionWriteCSV( var CSVConfusion : TextFile; Vol : TNNetVolume; Digits : integer)');
 CL.AddDelphiFunction('Procedure LoadTinyImageIntoNNetVolume1( var TI : TTinyImage; Vol : TNNetVolume);');
 CL.AddDelphiFunction('Procedure LoadTinyImageIntoNNetVolume2( var TI : TCifar100Image; Vol : TNNetVolume);');
 CL.AddDelphiFunction('Procedure LoadTinyImageIntoNNetVolume3( var TI : TMNistImage; Vol : TNNetVolume);');
 CL.AddDelphiFunction('Procedure LoadNNetVolumeIntoTinyImage4( Vol : TNNetVolume; var TI : TTinyImage);');
 CL.AddDelphiFunction('Procedure LoadNNetVolumeIntoTinyImage5( Vol : TNNetVolume; var TI : TCifar100Image);');
 CL.AddDelphiFunction('Procedure LoadTinySingleChannelIntoNNetVolume( var SC : TTinySingleChannelImage; Vol : TNNetVolume)');
 CL.AddDelphiFunction('Procedure TinyImageCreateGrey( var TI : TTinyImage; var TIGrey : TTinySingleChannelImage)');
 CL.AddDelphiFunction('Procedure TinyImageHE( var TI, TIHE : TTinySingleChannelImage)');
 CL.AddDelphiFunction('Procedure TinyImageVE( var TI, TIVE : TTinySingleChannelImage)');
 CL.AddDelphiFunction('Procedure TinyImageRemoveZeroGradient( var TI : TTinySingleChannelImage; distance : byte)');
 CL.AddDelphiFunction('Procedure TinyImageHVE( var TI, TIHE : TTinySingleChannelImage)');
 CL.AddDelphiFunction('Function TinyImageTo1D( var TI : TTinySingleChannelImage) : TTinySingleChannelImage1D');
 CL.AddDelphiFunction('Procedure CreateCifar10Volumes( out ImgTrainingVolumes, ImgValidationVolumes, ImgTestVolumes : TNNetVolumeList; color_encoding : byte)');
 CL.AddDelphiFunction('Procedure CreateCifar100Volumes( out ImgTrainingVolumes, ImgValidationVolumes, ImgTestVolumes : TNNetVolumeList; color_encoding : byte; Verbose : boolean)');
 CL.AddDelphiFunction('Procedure CreateMNISTVolumes( out ImgTrainingVolumes, ImgValidationVolumes, ImgTestVolumes : TNNetVolumeList; TrainFileName, TestFileName : string; Verbose : boolean; IsFashion : boolean)');
 CL.AddDelphiFunction('Procedure loadCifar10Dataset6( ImgVolumes : TNNetVolumeList; idx : integer; base_pos : integer; color_encoding : byte);');
 CL.AddDelphiFunction('Procedure loadCifar10Dataset2( ImgVolumes : TNNetVolumeList; idx : integer; base_pos : integer; color_encoding : byte);');
 CL.AddDelphiFunction('Procedure loadCifar10Dataset7( ImgVolumes : TNNetVolumeList; fileName : string; base_pos : integer; color_encoding : byte);');
 CL.AddDelphiFunction('Procedure loadCifar10Dataset( ImgVolumes : TNNetVolumeList; fileName : string; base_pos : integer; color_encoding : byte);');

 CL.AddDelphiFunction('Procedure loadCifar100Dataset( ImgVolumes : TNNetVolumeList; fileName : string; color_encoding : byte; Verbose : boolean)');
 CL.AddDelphiFunction('Procedure loadMNISTDataset( ImgVolumes : TNNetVolumeList; fileName : string; Verbose : boolean; IsFashion : boolean; MaxLabel : integer);');
 CL.AddDelphiFunction('Function CheckCIFARFile( ) : boolean');
 CL.AddDelphiFunction('Function CheckCIFAR100File( ) : boolean');
 CL.AddDelphiFunction('Function CheckMNISTFile( fileName : string; IsFasion : boolean) : boolean');
 CL.AddDelphiFunction('Procedure TestBatch( NN : TNNet; ImgVolumes : TNNetVolumeList; SampleSize : integer; out Rate, Loss, ErrorSum : TNeuralFloat)');
 CL.AddDelphiFunction('Procedure TranslateCifar10VolumesToMachineAnimal( VolumeList : TNNetVolumeList)');
 CL.AddDelphiFunction('Function SwapEndian( I : integer) : integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure loadMNISTDataset8_P( ImgVolumes : TNNetVolumeList; fileName : string; Verbose : boolean; IsFashion : boolean; MaxLabel : integer);
Begin neuraldatasets.loadMNISTDataset(ImgVolumes, fileName, Verbose, IsFashion, MaxLabel); END;

(*----------------------------------------------------------------------------*)
Procedure loadCifar10Dataset7_P( ImgVolumes : TNNetVolumeList; fileName : string; base_pos : integer; color_encoding : byte);
Begin neuraldatasets.loadCifar10Dataset(ImgVolumes, fileName, base_pos, color_encoding); END;

(*----------------------------------------------------------------------------*)
Procedure loadCifar10Dataset6_P( ImgVolumes : TNNetVolumeList; idx : integer; base_pos : integer; color_encoding : byte);
Begin neuraldatasets.loadCifar10Dataset(ImgVolumes, idx, base_pos, color_encoding); END;

(*----------------------------------------------------------------------------*)
Procedure LoadNNetVolumeIntoTinyImage5_P( Vol : TNNetVolume; var TI : TCifar100Image);
Begin neuraldatasets.LoadNNetVolumeIntoTinyImage(Vol, TI); END;

(*----------------------------------------------------------------------------*)
Procedure LoadNNetVolumeIntoTinyImage4_P( Vol : TNNetVolume; var TI : TTinyImage);
Begin neuraldatasets.LoadNNetVolumeIntoTinyImage(Vol, TI); END;

(*----------------------------------------------------------------------------*)
Procedure LoadTinyImageIntoNNetVolume3_P( var TI : TMNistImage; Vol : TNNetVolume);
Begin neuraldatasets.LoadTinyImageIntoNNetVolume(TI, Vol); END;

(*----------------------------------------------------------------------------*)
Procedure LoadTinyImageIntoNNetVolume2_P( var TI : TCifar100Image; Vol : TNNetVolume);
Begin neuraldatasets.LoadTinyImageIntoNNetVolume(TI, Vol); END;

(*----------------------------------------------------------------------------*)
Procedure LoadTinyImageIntoNNetVolume1_P( var TI : TTinyImage; Vol : TNNetVolume);
Begin neuraldatasets.LoadTinyImageIntoNNetVolume(TI, Vol); END;

//(*----------------------------------------------------------------------------*)
Procedure TClassesAndElementsLoadImages0_P(Self: TClassesAndElements;  color_encoding : integer; NewSizeX : integer; NewSizeY : integer);
Begin Self.LoadImages(color_encoding, NewSizeX, NewSizeY); END;

(*----------------------------------------------------------------------------*)
procedure TFileNameListClassCount_W(Self: TFileNameList; const T: integer);
begin Self.ClassCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TFileNameListClassCount_R(Self: TFileNameList; var T: integer);
begin T := Self.ClassCount; end;


procedure LoadTinyImageIntoNNetVolume1(var TI: TTinyImage; Vol: TNNetVolume); //overload;
 var
  I, J: integer;
begin
  Vol.ReSize(32,32,3);
  for I := 0 to 31 do
  begin
    for J := 0 to 31 do
    begin
      Vol[J, I, 0] := TI.R[I, J];
      Vol[J, I, 1] := TI.G[I, J];
      Vol[J, I, 2] := TI.B[I, J];
    end;
  end;
  Vol.Tag := TI.bLabel;
end;

procedure LoadTinyImageIntoNNetVolume2(var TI: TCifar100Image; Vol: TNNetVolume); //overload;
var
  I, J: integer;
begin
  Vol.ReSize(32,32,3);
  for I := 0 to 31 do
  begin
    for J := 0 to 31 do
    begin
      Vol[J, I, 0] := TI.R[I, J];
      Vol[J, I, 1] := TI.G[I, J];
      Vol[J, I, 2] := TI.B[I, J];
    end;
  end;
  Vol.Tags[0] := TI.bFineLabel;
  Vol.Tags[1] := TI.bCoarseLabel;
end;


procedure LoadTinyImageIntoNNetVolume3(var TI: TMNistImage; Vol: TNNetVolume); //overload;
var
  I, J: integer;
begin
  Vol.ReSize(28, 28, 1);
  for I := 0 to 27 do
  begin
    for J := 0 to 27 do
    begin
      Vol[J, I, 0] := TI[I, J];
    end;
  end;
end;

procedure LoadNNetVolumeIntoTinyImage4(Vol: TNNetVolume; var TI: TTinyImage);
var
  I, J: integer;
begin
  for I := 0 to 31 do
  begin
    for J := 0 to 31 do
    begin
      TI.R[I, J] := Vol.AsByte[J, I, 0];
      TI.G[I, J] := Vol.AsByte[J, I, 1];
      TI.B[I, J] := Vol.AsByte[J, I, 2];
    end;
  end;
  TI.bLabel := Vol.Tag;
end;

procedure LoadNNetVolumeIntoTinyImage5(Vol: TNNetVolume; var TI: TCifar100Image);
var
  I, J: integer;
begin
  for I := 0 to 31 do
  begin
    for J := 0 to 31 do
    begin
      TI.R[I, J] := Vol.AsByte[J, I, 0];
      TI.G[I, J] := Vol.AsByte[J, I, 1];
      TI.B[I, J] := Vol.AsByte[J, I, 2];
    end;
  end;
  TI.bCoarseLabel := Vol.Tags[0];
  TI.bFineLabel := Vol.Tags[1];
end;

 // loads a CIFAR10 into TNNetVolumeList
procedure loadCifar10Dataset6(ImgVolumes: TNNetVolumeList; idx:integer; base_pos:integer = 0; color_encoding: byte = csEncodeRGB);
var
  fileName: string;
begin
  fileName := 'data_batch_'+IntToStr(idx)+'.bin';
  loadCifar10Dataset(ImgVolumes, fileName, base_pos, color_encoding);
end;

// loads a CIFAR10 into TNNetVolumeList
procedure loadCifar10Dataset7(ImgVolumes: TNNetVolumeList; fileName:string; base_pos:integer = 0; color_encoding: byte = csEncodeRGB);
var
  I, ImgPos: integer;
  Img: TTinyImage;
  cifarFile: TTInyImageFile;
  AuxVolume: TNNetVolume;
  pMin, pMax: TNeuralFloat;
  globalMin0, globalMax0: TNeuralFloat;
  globalMin1, globalMax1: TNeuralFloat;
  globalMin2, globalMax2: TNeuralFloat;

begin
  //Write('Loading 10K images from file "'+fileName+'" ...');
  maxForm1.memo2.lines.Add('Loading 10K images from file "'+fileName+'" ...');
  AssignFile(cifarFile, fileName);
  Reset(cifarFile);
  AuxVolume := TNNetVolume.Create();

  globalMin0 := 0;
  globalMax0 := 0;
  globalMin1 := 0;
  globalMax1 := 0;
  globalMin2 := 0;
  globalMax2 := 0;

  // binary CIFAR 10 file contains 10K images
  for I := 0 to 9999 do
  begin
    Read(cifarFile, Img);
    ImgPos := I + base_pos;
    LoadTinyImageIntoNNetVolume(Img, ImgVolumes[ImgPos]);

    if (color_encoding = csEncodeGray) then
    begin
      AuxVolume.Copy(ImgVolumes[ImgPos]);
      ImgVolumes[ImgPos].GetGrayFromRgb(AuxVolume);
    end;

    ImgVolumes[ImgPos].RgbImgToNeuronalInput(color_encoding);

    ImgVolumes[ImgPos].GetMinMaxAtDepth(0, pMin, pMax); //WriteLn  (I:8,' - #0 Min:',pMin, ' Max:',pMax);

    globalMin0 := Math.Min(pMin, globalMin0);
    globalMax0 := Math.Max(pMax, globalMax0);

    if (ImgVolumes[ImgPos].Depth >= 2) then
    begin
      ImgVolumes[ImgPos].GetMinMaxAtDepth(1, pMin, pMax); //Write  (' #1 Min:',pMin, ' Max:',pMax);

      globalMin1 := Math.Min(pMin, globalMin1);
      globalMax1 := Math.Max(pMax, globalMax1);
    end;

    if (ImgVolumes[ImgPos].Depth >= 3) then
    begin
      ImgVolumes[ImgPos].GetMinMaxAtDepth(2, pMin, pMax); //WriteLn(' #2 Min:',pMin, ' Max:',pMax);

      globalMin2 := Math.Min(pMin, globalMin2);
      globalMax2 := Math.Max(pMax, globalMax2);
    end;
  end;

  //Write(' GLOBAL MIN MAX ', globalMin0:8:4,globalMax0:8:4,globalMin1:8:4,globalMax1:8:4,globalMin2:8:4,globalMax2:8:4);
   maxForm1.memo2.lines.Add(' GLOBAL MIN MAX '+floattostr(globalMin0)+ '  '+floattostr(globalMax0));

  AuxVolume.Free;
  CloseFile(cifarFile);
  //WriteLn(' Done.');
end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_neuraldatasets_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateVolumesFromImagesFromFolder, 'CreateVolumesFromImagesFromFolder', cdRegister);
 S.RegisterDelphiFunction(@CreateFileNameListsFromImagesFromFolder, 'CreateFileNameListsFromImagesFromFolder', cdRegister);
 S.RegisterDelphiFunction(@LoadImageIntoVolume2, 'LoadImageIntoVolume', cdRegister);
 S.RegisterDelphiFunction(@LoadVolumeIntoImage2, 'LoadVolumeIntoImage', cdRegister);
 S.RegisterDelphiFunction(@LoadImageFromFileIntoVolume, 'LoadImageFromFileIntoVolume', cdRegister);
 S.RegisterDelphiFunction(@SaveImageFromVolumeIntoFile, 'SaveImageFromVolumeIntoFile', cdRegister);
 S.RegisterDelphiFunction(@ConfusionWriteCSVHeader, 'ConfusionWriteCSVHeader', cdRegister);
 S.RegisterDelphiFunction(@ConfusionWriteCSV, 'ConfusionWriteCSV', cdRegister);
 S.RegisterDelphiFunction(@LoadTinyImageIntoNNetVolume1, 'LoadTinyImageIntoNNetVolume1', cdRegister);
 S.RegisterDelphiFunction(@LoadTinyImageIntoNNetVolume2, 'LoadTinyImageIntoNNetVolume2', cdRegister);
 S.RegisterDelphiFunction(@LoadTinyImageIntoNNetVolume3, 'LoadTinyImageIntoNNetVolume3', cdRegister);
 S.RegisterDelphiFunction(@LoadNNetVolumeIntoTinyImage4, 'LoadNNetVolumeIntoTinyImage4', cdRegister);
 S.RegisterDelphiFunction(@LoadNNetVolumeIntoTinyImage5, 'LoadNNetVolumeIntoTinyImage5', cdRegister);
 S.RegisterDelphiFunction(@LoadTinySingleChannelIntoNNetVolume, 'LoadTinySingleChannelIntoNNetVolume', cdRegister);
 S.RegisterDelphiFunction(@TinyImageCreateGrey, 'TinyImageCreateGrey', cdRegister);
 S.RegisterDelphiFunction(@TinyImageHE, 'TinyImageHE', cdRegister);
 S.RegisterDelphiFunction(@TinyImageVE, 'TinyImageVE', cdRegister);
 S.RegisterDelphiFunction(@TinyImageRemoveZeroGradient, 'TinyImageRemoveZeroGradient', cdRegister);
 S.RegisterDelphiFunction(@TinyImageHVE, 'TinyImageHVE', cdRegister);
 S.RegisterDelphiFunction(@TinyImageTo1D, 'TinyImageTo1D', cdRegister);
 S.RegisterDelphiFunction(@CreateCifar10Volumes, 'CreateCifar10Volumes', cdRegister);
 S.RegisterDelphiFunction(@CreateCifar100Volumes, 'CreateCifar100Volumes', cdRegister);
 S.RegisterDelphiFunction(@CreateMNISTVolumes, 'CreateMNISTVolumes', cdRegister);
 S.RegisterDelphiFunction(@loadCifar10Dataset6, 'loadCifar10Dataset6', cdRegister);
 S.RegisterDelphiFunction(@loadCifar10Dataset6, 'loadCifar10Dataset2', cdRegister);
 S.RegisterDelphiFunction(@loadCifar10Dataset7, 'loadCifar10Dataset7', cdRegister);
 S.RegisterDelphiFunction(@loadCifar10Dataset7, 'loadCifar10Dataset', cdRegister);
 S.RegisterDelphiFunction(@loadCifar100Dataset, 'loadCifar100Dataset', cdRegister);
 S.RegisterDelphiFunction(@loadMNISTDataset, 'loadMNISTDataset', cdRegister);        //}
 S.RegisterDelphiFunction(@CheckCIFARFile, 'CheckCIFARFile', cdRegister);
 S.RegisterDelphiFunction(@CheckCIFAR100File, 'CheckCIFAR100File', cdRegister);
 S.RegisterDelphiFunction(@CheckMNISTFile, 'CheckMNISTFile', cdRegister);
 S.RegisterDelphiFunction(@TestBatch, 'TestBatch', cdRegister);
 S.RegisterDelphiFunction(@TranslateCifar10VolumesToMachineAnimal, 'TranslateCifar10VolumesToMachineAnimal', cdRegister);
 S.RegisterDelphiFunction(@SwapEndian, 'SwapEndian', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TClassesAndElements(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TClassesAndElements) do begin
    RegisterConstructor(@TClassesAndElements.Create, 'Create');
    RegisterMethod(@TClassesAndElements.Destroy, 'Free');
    RegisterMethod(@TClassesAndElements.CountElements, 'CountElements');
    RegisterMethod(@TClassesAndElements.LoadFoldersAsClasses, 'LoadFoldersAsClasses');
    RegisterMethod(@TClassesAndElements.LoadFoldersAsClassesProportional, 'LoadFoldersAsClassesProportional');
    RegisterMethod(@TClassesAndElementsLoadImages0_P, 'LoadImages0');
    RegisterMethod(@TClassesAndElementsLoadImages0_P, 'LoadImages');   //alias
    RegisterMethod(@TClassesAndElements.LoadClass_FilenameFromFolder, 'LoadClass_FilenameFromFolder');
    RegisterMethod(@TClassesAndElements.GetRandomClassId, 'GetRandomClassId');
    RegisterMethod(@TClassesAndElements.GetClassesCount, 'GetClassesCount');
    RegisterMethod(@TClassesAndElements.GetRandomFileId, 'GetRandomFileId');
    RegisterMethod(@TClassesAndElements.GetRandomFileName, 'GetRandomFileName');
    RegisterMethod(@TClassesAndElements.GetRandomImgVolumes, 'GetRandomImgVolumes');
    RegisterMethod(@TClassesAndElements.GetFileName, 'GetFileName');
    RegisterMethod(@TClassesAndElements.AddVolumesTo, 'AddVolumesTo');
    RegisterMethod(@TClassesAndElements.AddFileNamesTo, 'AddFileNamesTo');
    RegisterMethod(@TClassesAndElements.MakeMonopolar, 'MakeMonopolar');
    RegisterMethod(@TClassesAndElements.FileCountAtClassId, 'FileCountAtClassId');
    RegisterMethod(@TClassesAndElements.LoadImages_NTL, 'LoadImages_NTL');
  end; // }
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFileNameList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFileNameList) do
  begin
    RegisterConstructor(@TFileNameList.Create, 'Create');
    RegisterMethod(@TFileNameList.Destroy, 'Free');
    RegisterMethod(@TFileNameList.GetImageVolumePairFromId, 'GetImageVolumePairFromId');
    RegisterMethod(@TFileNameList.GetRandomImagePair, 'GetRandomImagePair');
    RegisterMethod(@TFileNameList.ThreadSafeLoadImageFromFileIntoVolume, 'ThreadSafeLoadImageFromFileIntoVolume');
    RegisterPropertyHelper(@TFileNameListClassCount_R,@TFileNameListClassCount_W,'ClassCount');
  end;  //}
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_neuraldatasets(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TFileNameList(CL);
  RIRegister_TClassesAndElements(CL);
end;

 
 
{ TPSImport_neuraldatasets }
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuraldatasets.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_neuraldatasets(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuraldatasets.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_neuraldatasets(ri);
  RIRegister_neuraldatasets_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
