unit uPSI_uSysTools;
{
a really cool one wiht regexpr

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
  TPSImport_uSysTools = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_uSysTools(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_uSysTools_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,StrUtils
  ,RegExpr
  ,DB
  ,Graphics
  ,Forms
  ,Dialogs
  ,ActiveX
  ,ShlObj
  ,ComObj
  ,Variants
  ,WideStrings
  ,WideStrUtils
  ,uSysTools , Controls, CommCtrl;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uSysTools]);
end;

function SerializeStream(const AStream : TStream) : String;
var
  SS : TStringStream;
  B : Byte;
begin
  SS:=TStringStream.Create('');
  try
    while AStream.Read(b,SizeOf(b))>0 do
      SS.WriteString(IntToHex(b,2));
    Result:=SS.DataString;
  finally
    SS.Free;
  end;
end;

procedure DeserializeToStream(const Data : String; const AStream : TStream);
var
  SS : TStringStream;
  Ser : array [0..1] of AnsiChar;
  B : Byte;
begin
  SS:=TStringStream.Create(Data);
  try
    while ss.Read(Ser,2)>0 do
    begin
      B:=StrToInt('$'+Ser);
      AStream.Write(B,1);
    end;
  finally
    SS.Free;
  end;
end;

procedure ReplaceImageInImageList(FromImageList: TImageList; FromIndex: Integer;
                                  ToImageList: TImageList; ToIndex: Integer);
var
  I: Integer;
  Image, Mask: TBitmap;
  ARect: TRect;
begin
  ARect := Rect(0, 0, ToImageList.Width, ToImageList.Height);
  Image := TBitmap.Create;
  try
    with Image do
    begin
      Height := ToImageList.Height;
      Width := ToImageList.Width;
    end;
    Mask := TBitmap.Create;
    try
      with Mask do
      begin
        Monochrome := True;
        Height := ToImageList.Height;
        Width := ToImageList.Width;
      end;

      with Image.Canvas do
      begin
        FillRect(ARect);
        ImageList_Draw(FromImageList.Handle, I, Handle, 0, 0, ILD_NORMAL);
      end;
      with Mask.Canvas do
      begin
        FillRect(ARect);
        ImageList_Draw(FromImageList.Handle, I, Handle, 0, 0, ILD_MASK);
      end;
      ToImageList.Replace(ToIndex, Image, Mask);

    finally
      Mask.Free;
    end;
  finally
    Image.Free;
  end;
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_uSysTools(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function usGetRegExFileList( APath : String; APattern : String; ASubDirs : Boolean; AResultList : TStrings; AAttributes : Integer; AWithPath : Boolean; APathPattern : String) : Integer');
 CL.AddDelphiFunction('Procedure usFindFileInPaths( const AFileName : String; const ASearchPaths : String; AMinimumFileSize : Int64; const AResultList : TStrings)');
 CL.AddDelphiFunction('Procedure usPrintWindow( Wnd : HWND; ATo : TBitmap)');
 CL.AddDelphiFunction('Function usGetWindowByClassTree( const AClassTree : TStringList; AParent : HWND; AWithWildCards : Boolean) : HWND');
 CL.AddDelphiFunction('Function usGetTempFile( AExtension : String) : String');
 CL.AddDelphiFunction('Function usDeleteFileToWasteBin( AFileName : string) : boolean');
 CL.AddDelphiFunction('Function usExpandEnvVars( AInputString : String) : String');
 CL.AddDelphiFunction('Function usFileSize( AFileName : String) : Int64');
 CL.AddDelphiFunction('Function usIsMultiprocessor : Boolean');
 CL.AddDelphiFunction('Function usProcessorCount : Cardinal');
 CL.AddDelphiFunction('Function usIsAdmin : Boolean');
 CL.AddDelphiFunction('Function usMultipleStringReplace( AString : String; AOldPatterns, ANewPatterns : array of String; AFlags : TReplaceFlags) : String');
 CL.AddDelphiFunction('Function usMakeFileName( ADesiredFName : String) : String');
 CL.AddDelphiFunction('Function usIsLike( AString, APattern : String) : Boolean');
 //CL.AddDelphiFunction('Function usVarRecToVariant( AValue : TVarRec) : Variant');
 //CL.AddDelphiFunction('Function usVariantToTypedVarRec( const Item : Variant; VarType : TVarType) : TVarRec');
 //CL.AddDelphiFunction('Function usVariantToVarRec( const Item : Variant) : TVarRec');
 //CL.AddDelphiFunction('Procedure usFinalizeVarRec( var Item : TVarRec)');
 CL.AddDelphiFunction('Function usGetWindowText( wnd : HWND) : WideString');
 CL.AddDelphiFunction('Procedure usSetWindowText( wnd : HWND; txt : WideString)');
 CL.AddDelphiFunction('Function usMultipleWideStringReplace( AString : WideString; AOldPatterns, ANewPatterns : array of WideString; AFlags : TReplaceFlags) : WideString');
 CL.AddDelphiFunction('Procedure usAcceptNumericOnly( var Key : Char; Comma : Boolean)');
 CL.AddDelphiFunction('Function usSameGUID( AGUID1, AGUID2 : TGUID) : Boolean');
 CL.AddDelphiFunction('Function usIsBitSet( AValue : Integer; ABitIndex : Byte) : Boolean');
 CL.AddDelphiFunction('Function usClientToScreen( AWindow : HWND; var APoint : TPoint) : Boolean');
 //CL.AddDelphiFunction('Function usGetDataObjectFromFileList( const Directory : string; Files : TStrings) : IDataObject');
 //CL.AddDelphiFunction('Function usGetDataObjectFromFile( const Directory : string; AFile : String) : IDataObject');
 //CL.AddDelphiFunction('Function usGetFileListFromDataObject( const DataObject : IDataObject; Files : TStrings) : Integer');
 CL.AddDelphiFunction('Function usKeyPressed( AKey : Smallint) : Boolean;');
 CL.AddDelphiFunction('Function usKeyPressed1( AKey : Byte) : Boolean;');
 CL.AddDelphiFunction('Function usKeyToogled( AKey : Smallint) : Boolean;');
 CL.AddDelphiFunction('Function usKeyToogled1( AKey : Byte) : Boolean;');
 CL.AddDelphiFunction('Function usGetShellFolder( CSIDL : integer) : string');
 CL.AddDelphiFunction('function SerializeStream(const AStream : TStream) : String;');
 CL.AddDelphiFunction('procedure DeserializeToStream(const Data : String; const AStream : TStream);');
 CL.AddDelphiFunction('procedure ReplaceImageInImageList(FromImageList: TImageList; FromIndex: Integer; ToImageList: TImageList; ToIndex: Integer);');

 // procedure ReplaceImageInImageList(FromImageList: TImageList; FromIndex: Integer; ToImageList: TImageList; ToIndex: Integer);

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function KeyToogled1_P( AKey : Byte) : Boolean;
Begin Result := uSysTools.KeyToogled(AKey); END;

(*----------------------------------------------------------------------------*)
Function KeyToogled_P( AKey : Smallint) : Boolean;
Begin Result := uSysTools.KeyToogled(AKey); END;

(*----------------------------------------------------------------------------*)
Function KeyPressed1_P( AKey : Byte) : Boolean;
Begin Result := uSysTools.KeyPressed(AKey); END;

(*----------------------------------------------------------------------------*)
Function KeyPressed_P( AKey : Smallint) : Boolean;
Begin Result := uSysTools.KeyPressed(AKey); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uSysTools_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetRegExFileList, 'usGetRegExFileList', cdRegister);
 S.RegisterDelphiFunction(@FindFileInPaths, 'usFindFileInPaths', cdRegister);
 S.RegisterDelphiFunction(@PrintWindow, 'usPrintWindow', cdRegister);
 S.RegisterDelphiFunction(@GetWindowByClassTree, 'usGetWindowByClassTree', cdRegister);
 S.RegisterDelphiFunction(@GetTempFile, 'usGetTempFile', cdRegister);
 S.RegisterDelphiFunction(@DeleteFileToWasteBin, 'usDeleteFileToWasteBin', cdRegister);
 S.RegisterDelphiFunction(@ExpandEnvVars, 'usExpandEnvVars', cdRegister);
 S.RegisterDelphiFunction(@FileSize, 'usFileSize', cdRegister);
 S.RegisterDelphiFunction(@IsMultiprocessor, 'usIsMultiprocessor', cdRegister);
 S.RegisterDelphiFunction(@ProcessorCount, 'usProcessorCount', cdRegister);
 S.RegisterDelphiFunction(@IsAdmin, 'usIsAdmin', cdRegister);
 S.RegisterDelphiFunction(@MultipleStringReplace, 'usMultipleStringReplace', cdRegister);
 S.RegisterDelphiFunction(@MakeFileName, 'usMakeFileName', cdRegister);
 S.RegisterDelphiFunction(@IsLike, 'usIsLike', cdRegister);
 //S.RegisterDelphiFunction(@VarRecToVariant, 'usVarRecToVariant', cdRegister);
 //S.RegisterDelphiFunction(@VariantToTypedVarRec, 'usVariantToTypedVarRec', cdRegister);
 //S.RegisterDelphiFunction(@VariantToVarRec, 'usVariantToVarRec', cdRegister);
 //S.RegisterDelphiFunction(@FinalizeVarRec, 'usFinalizeVarRec', cdRegister);
 S.RegisterDelphiFunction(@GetWindowText, 'usGetWindowText', cdRegister);
 S.RegisterDelphiFunction(@SetWindowText, 'usSetWindowText', cdRegister);
 S.RegisterDelphiFunction(@MultipleWideStringReplace, 'usMultipleWideStringReplace', cdRegister);
 S.RegisterDelphiFunction(@AcceptNumericOnly, 'usAcceptNumericOnly', cdRegister);
 S.RegisterDelphiFunction(@SameGUID, 'usSameGUID', cdRegister);
 S.RegisterDelphiFunction(@IsBitSet, 'usIsBitSet', cdRegister);
 S.RegisterDelphiFunction(@ClientToScreen, 'usClientToScreen', cdRegister);
 //S.RegisterDelphiFunction(@GetDataObjectFromFileList, 'usGetDataObjectFromFileList', cdRegister);
 //S.RegisterDelphiFunction(@GetDataObjectFromFile, 'usGetDataObjectFromFile', cdRegister);
 //S.RegisterDelphiFunction(@GetFileListFromDataObject, 'usGetFileListFromDataObject', cdRegister);
 S.RegisterDelphiFunction(@KeyPressed, 'usKeyPressed', cdRegister);
 S.RegisterDelphiFunction(@KeyPressed1_P, 'usKeyPressed1', cdRegister);
 S.RegisterDelphiFunction(@KeyToogled, 'usKeyToogled', cdRegister);
 S.RegisterDelphiFunction(@KeyToogled1_P, 'usKeyToogled1', cdRegister);
 S.RegisterDelphiFunction(@GetShellFolder, 'usGetShellFolder', cdRegister);
 S.RegisterDelphiFunction(@SerializeStream, 'SerializeStream', cdRegister);
 S.RegisterDelphiFunction(@DeserializeToStream, 'DeserializeToStream', cdRegister);
 S.RegisterDelphiFunction(@ReplaceImageInImageList, 'ReplaceImageInImageList', cdRegister);
end;


 
{ TPSImport_uSysTools }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uSysTools.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uSysTools(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uSysTools.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uSysTools_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
