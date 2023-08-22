unit uPSI_DPUtils;
{
  functions
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
  TPSImport_DPUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

 
{ compile-time registration functions }
procedure SIRegister_TThumbData(CL: TPSPascalCompiler);
procedure SIRegister_DPUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DPUtils_Routines(S: TPSExec);
procedure RIRegister_TThumbData(CL: TPSRuntimeClassImporter);
procedure RIRegister_DPUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,Jpeg
  ,Math
  ,DPUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DPUtils]);
end;

 function JustName(PathName : string) : string;
    {-Return just the name (no extension, no path) of a pathname}
  var
    DotPos : Byte;
  begin
    PathName := ExtractFileName(PathName);
    DotPos := Pos('.', PathName);
    if DotPos > 0 then
      PathName := Copy(PathName, 1, DotPos-1);
    Result := PathName;
  end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TThumbData(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TThumbData') do
  with CL.AddClassN(CL.FindClass('TObject'),'TThumbData') do
  begin
    RegisterProperty('Caption', 'string', iptrw);
    RegisterProperty('Bitmap', 'TBitmap', iptrw);
    RegisterMethod('Constructor Create( ACaption : string; ABitmap : TBitmap)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DPUtils(CL: TPSPascalCompiler);
begin
 // CL.AddTypeS('pRGBTripleArray', '^TRGBTripleArray // will not work');
  SIRegister_TThumbData(CL);
   CL.AddTypeS('tagRGBTRIPLE', 'record rgbtBlue : Byte; rgbtGreen : Byte; rgbtRed : Byte; end');
  CL.AddTypeS('TRGBTriple', 'tagRGBTRIPLE');
  CL.AddTypeS('RGBTRIPLE', 'tagRGBTRIPLE');

 CL.AddConstantN('PIC_BMP','LongInt').SetInt( 0);
 CL.AddConstantN('PIC_JPG','LongInt').SetInt( 1);
 CL.AddConstantN('THUMB_WIDTH','LongInt').SetInt( 60);
 CL.AddConstantN('THUMB_HEIGHT','LongInt').SetInt( 60);
 CL.AddDelphiFunction('Function IsEqualFile( Filename : string; Size : Integer; LastWriteTime : TDateTime) : Boolean');
 CL.AddDelphiFunction('Procedure GetFileInfo( Filename : string; var Size : Integer; var LastWriteTime : TDateTime)');
 CL.AddDelphiFunction('Function ReadBitmap( Filehandle : Integer; Width, Height : Integer) : TBitmap');
 CL.AddDelphiFunction('Procedure WriteBitmap( Filehandle : Integer; bmp : TBitmap)');
 CL.AddDelphiFunction('Function OpenPicture( fn : string; var tp : Integer) : Integer');
 CL.AddDelphiFunction('Function ConvertPicture( pi : Integer; tp : Integer) : TBitmap');
 CL.AddDelphiFunction('Function LoadPicture( fn : string; var w, h : Integer) : TBitmap');
 CL.AddDelphiFunction('Function TurnBitmap( bmp : TBitmap; ang : Integer) : TBitmap');
 CL.AddDelphiFunction('Function RotateBitmap( Bitmap : TBitmap; Direction : Integer) : TBitmap');
 CL.AddDelphiFunction('Function StretchBitmap( Canvas : TCanvas; re : TRect; bmp : TBitmap) : TRect');
 CL.AddDelphiFunction('Function ThumbBitmap( Bitmap : TBitmap; Width, Height : Integer) : TBitmap');
 CL.AddDelphiFunction('Procedure ClearFrame( Canvas : TCanvas; Rect : TRect; Width, Height : Integer)');
 CL.AddDelphiFunction('Procedure FindFiles( path, mask : string; items : TStringList)');
 CL.AddDelphiFunction('Function LetFileName( s : string) : string');
 CL.AddDelphiFunction('Function LetParentPath( path : string) : string');
 CL.AddDelphiFunction('Function AddBackSlash( path : string) : string');
 CL.AddDelphiFunction('Function CutBackSlash( path : string) : string');
  CL.AddDelphiFunction('function JustName(PathName : string) : string;');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TThumbDataBitmap_W(Self: TThumbData; const T: TBitmap);
Begin Self.Bitmap := T; end;

(*----------------------------------------------------------------------------*)
procedure TThumbDataBitmap_R(Self: TThumbData; var T: TBitmap);
Begin T := Self.Bitmap; end;

(*----------------------------------------------------------------------------*)
procedure TThumbDataCaption_W(Self: TThumbData; const T: string);
Begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TThumbDataCaption_R(Self: TThumbData; var T: string);
Begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DPUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IsEqualFile, 'IsEqualFile', cdRegister);
 S.RegisterDelphiFunction(@GetFileInfo, 'GetFileInfo', cdRegister);
 S.RegisterDelphiFunction(@ReadBitmap, 'ReadBitmap', cdRegister);
 S.RegisterDelphiFunction(@WriteBitmap, 'WriteBitmap', cdRegister);
 S.RegisterDelphiFunction(@OpenPicture, 'OpenPicture', cdRegister);
 S.RegisterDelphiFunction(@ConvertPicture, 'ConvertPicture', cdRegister);
 S.RegisterDelphiFunction(@LoadPicture, 'LoadPicture', cdRegister);
 S.RegisterDelphiFunction(@TurnBitmap, 'TurnBitmap', cdRegister);
 S.RegisterDelphiFunction(@RotateBitmap, 'RotateBitmap', cdRegister);
 S.RegisterDelphiFunction(@StretchBitmap, 'StretchBitmap', cdRegister);
 S.RegisterDelphiFunction(@ThumbBitmap, 'ThumbBitmap', cdRegister);
 S.RegisterDelphiFunction(@ClearFrame, 'ClearFrame', cdRegister);
 S.RegisterDelphiFunction(@FindFiles, 'FindFiles', cdRegister);
 S.RegisterDelphiFunction(@FileName, 'LetFileName', cdRegister);
 S.RegisterDelphiFunction(@ParentPath, 'LetParentPath', cdRegister);
 S.RegisterDelphiFunction(@AddBackSlash, 'AddBackSlash', cdRegister);
 S.RegisterDelphiFunction(@CutBackSlash, 'CutBackSlash', cdRegister);
 S.RegisterDelphiFunction(@JustName, 'JustName', cdRegister);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TThumbData(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TThumbData) do
  begin
    RegisterPropertyHelper(@TThumbDataCaption_R,@TThumbDataCaption_W,'Caption');
    RegisterPropertyHelper(@TThumbDataBitmap_R,@TThumbDataBitmap_W,'Bitmap');
    RegisterConstructor(@TThumbData.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DPUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TThumbData(CL);
end;

 
 
{ TPSImport_DPUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DPUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DPUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DPUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DPUtils(ri);
  RIRegister_DPUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
