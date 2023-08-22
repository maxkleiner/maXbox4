unit uPSI_JvUtils;
{
  mX3.8.6
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
  TPSImport_JvUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_JvUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Forms
  //,Controls
  //,Graphics
  //,StdCtrls
  //,ExtCtrls
  //,Dialogs
  //,Menus
  //,Clipbrd
  //,ShlObj
  //,ActiveX
  //,Ole2
  //,Variants
  ,TypInfo
  ,JvUtils
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvUtils]);
end;

function GetSysDir: String;
var
  dir: array [0..max_path] of char;
begin
  GetSystemDirectory(dir, max_path);
  result:=StrPas(dir);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JvUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('Longword', 'Cardinal');   //integer to cardinal
  CL.AddTypeS('TTickCount', 'Cardinal');
  CL.AddTypeS('TSetOfChar', 'set of Char');
 // CL.AddTypeS('TSetOfChar', 'string');

 //CL.AddDelphiFunction('Function SendRectMessage( Handle : THandle; Msg : Integer; wParam : longint; var R : TRect) : Integer');
// CL.AddDelphiFunction('Function SendStructMessage( Handle : THandle; Msg : Integer; wParam : longint; var Data) : Integer');
 //CL.AddDelphiFunction('Function ReadCharsFromStream( Stream : TStream; var Buf : array of PChar; BufSize : Integer) : Integer');
 //CL.AddDelphiFunction('Function WriteStringToStream( Stream : TStream; const Buf : AnsiString; BufSize : Integer) : Integer');

 CL.AddDelphiFunction('Function GetWordOnPos( const S : string; const P : Integer) : string');
 CL.AddDelphiFunction('Function GetWordOnPosEx( const S : string; const P : Integer; var iBeg, iEnd : Integer) : string');
 CL.AddDelphiFunction('Function SubStrJ( const S : string; const Index : Integer; const Separator : string) : string');
 CL.AddDelphiFunction('Function SubStrEnd( const S : string; const Index : Integer; const Separator : string) : string');
 CL.AddDelphiFunction('Function SubWord( P : PChar; var P2 : PChar) : string');
 CL.AddDelphiFunction('Function NumberByWord( const N : Longint) : string');
 CL.AddDelphiFunction('Function GetLineByPos( const S : string; const Pos : Integer) : Integer');
 CL.AddDelphiFunction('Procedure GetXYByPosJ( const S : string; const Pos : Integer; var X, Y : Integer)');
 CL.AddDelphiFunction('Function ReplaceStringJ( S : string; const OldPattern, NewPattern : string) : string');
 CL.AddDelphiFunction('Function ConcatSep( const S, S2, Separator : string) : string');
 CL.AddDelphiFunction('Function ConcatLeftSep( const S, S2, Separator : string) : string');
 CL.AddDelphiFunction('Function MinimizeString( const S : string; const MaxLen : Integer) : string');
 CL.AddDelphiFunction('Procedure Dos2Win( var S : string)');
 CL.AddDelphiFunction('Procedure Win2Dos( var S : string)');
 CL.AddDelphiFunction('Function Dos2WinRes( const S : string) : string');
 CL.AddDelphiFunction('Function Win2DosRes( const S : string) : string');
 CL.AddDelphiFunction('Function Win2Koi( const S : string) : string');
 //CL.AddDelphiFunction('Function Spaces( const N : Integer) : string');
 //CL.AddDelphiFunction('Function AddSpaces( const S : string; const N : Integer) : string');
 CL.AddDelphiFunction('Function LastDate( const Dat : TDateTime) : string');
 CL.AddDelphiFunction('Function CurrencyToStr( const Cur : currency) : string');
 CL.AddDelphiFunction('Function CmpJ( const S1, S2 : string) : Boolean');
 CL.AddDelphiFunction('Function StringCat( var S1 : string; S2 : string) : string');
 CL.AddDelphiFunction('Function HasChar( const Ch : Char; const S : string) : Boolean');
 CL.AddDelphiFunction('Function HasAnyChar( const Chars : string; const S : string) : Boolean');
 CL.AddDelphiFunction('Function CharInSet2( const Ch : Char; const SetOfChar : TSetOfChar) : Boolean');
 CL.AddDelphiFunction('Function CharInSet( const Ch : Char; const testSet: TSysCharSet): Boolean');
 CL.AddDelphiFunction('Function CountOfChar( const Ch : Char; const S : string) : Integer');
 CL.AddDelphiFunction('Function DefStr( const S : string; Default : string) : string');
 CL.AddDelphiFunction('Function GetWinDir : TFileName');
 CL.AddDelphiFunction('Function GetSysDir : TFileName');
 CL.AddDelphiFunction('Function GetTempDir : string');
 CL.AddDelphiFunction('Function GenTempFileName( FileName : string) : string');
 CL.AddDelphiFunction('Function GenTempFileNameExt( FileName : string; const FileExt : string) : string');
 //CL.AddDelphiFunction('Function ClearDir( const Dir : string) : Boolean');
 //CL.AddDelphiFunction('Function DeleteDir( const Dir : string) : Boolean');
 CL.AddDelphiFunction('Function FileEquMask( FileName, Mask : TFileName) : Boolean');
 CL.AddDelphiFunction('Function FileEquMasks( FileName, Masks : TFileName) : Boolean');
 CL.AddDelphiFunction('Procedure DeleteFiles( const Folder : TFileName; const Masks : string)');
 CL.AddDelphiFunction('Function LZFileExpand( const FileSource, FileDest : string) : Boolean');
 CL.AddDelphiFunction('Function FileGetInfo( FileName : TFileName; var SearchRec : TSearchRec) : Boolean');
 CL.AddDelphiFunction('Function HasSubFolder( APath : TFileName) : Boolean');
 CL.AddDelphiFunction('Function IsEmptyFolder( APath : TFileName) : Boolean');
 CL.AddDelphiFunction('Procedure AddSlash( var Dir : TFileName)');
 CL.AddDelphiFunction('Function AddSlash2( const Dir : TFileName) : string');
 CL.AddDelphiFunction('Function AddPath( const FileName, Path : TFileName) : TFileName');
 CL.AddDelphiFunction('Function AddPaths( const PathList, Path : string) : string');
 CL.AddDelphiFunction('Function ParentPath( const Path : TFileName) : TFileName');
 CL.AddDelphiFunction('Function FindInPath( const FileName, PathList : string) : TFileName');
 //CL.AddDelphiFunction('Function BrowseForFolder( const Handle : HWND; const Title : string; var Folder : string) : Boolean');
 CL.AddDelphiFunction('Function DeleteReadOnlyFile( const FileName : TFileName) : Boolean');
 CL.AddDelphiFunction('Function HasParam( const Param : string) : Boolean');
 CL.AddDelphiFunction('Function HasSwitch( const Param : string) : Boolean');
 CL.AddDelphiFunction('Function Switch( const Param : string) : string');
 CL.AddDelphiFunction('Function ExePathJ : TFileName');
 //CL.AddDelphiFunction('Function CopyDir( const SourceDir, DestDir : TFileName) : Boolean');
 CL.AddDelphiFunction('Function FileTimeToDateTime( const FT : TFileTime) : TDateTime');
 CL.AddDelphiFunction('Function MakeValidFileNameJ( const FileName : TFileName; const ReplaceBadChar : Char) : TFileName');
 CL.AddDelphiFunction('Function TTFontSelected( const DC : HDC) : Boolean');
 CL.AddDelphiFunction('Function TrueInflateRect( const R : TRect; const I : Integer) : TRect');
 CL.AddDelphiFunction('Procedure SetWindowTop( const Handle : HWND; const Top : Boolean)');
 CL.AddDelphiFunction('Function KeyPressed( VK : Integer) : Boolean');
 {CL.AddDelphiFunction('Procedure SwapIntJ( var Int1, Int2 : Integer)');
 CL.AddDelphiFunction('Function IntPowerJ( Base, Exponent : Integer) : Integer');
 CL.AddDelphiFunction('Function ChangeTopException( E : TObject) : TObject');
 CL.AddDelphiFunction('Function StrToBoolJ( const S : string) : Boolean'); }
 CL.AddDelphiFunction('Function AnsiStrLIComp( S1, S2 : PChar; MaxLen : Cardinal) : Integer');
 CL.AddDelphiFunction('Function AnsiStrIComp( S1, S2 : PChar) : Integer');
 {CL.AddDelphiFunction('Function Var2TypeJ( V : Variant; const VarType : Integer) : Variant');
 CL.AddDelphiFunction('Function VarToInt( V : Variant) : Integer');
 CL.AddDelphiFunction('Function VarToFloat( V : Variant) : Double');  }
 CL.AddDelphiFunction('Function ReplaceSokr1( S : string; const Word, Frase : string) : string');
 CL.AddDelphiFunction('Function GetSubStr( const S : string; const Index : Integer; const Separator : Char) : string');
 CL.AddDelphiFunction('Function GetParameter : string');
 CL.AddDelphiFunction('Function GetLongFileName( FileName : string) : string');
 CL.AddDelphiFunction('Function DirectoryExistsJ( const Name : string) : Boolean');
 CL.AddDelphiFunction('Procedure ForceDirectoriesJ( Dir : string)');
 CL.AddDelphiFunction('Function FileNewExt( const FileName, NewExt : TFileName) : TFileName');
 CL.AddDelphiFunction('Function GetComputerID : string');
 CL.AddDelphiFunction('Function GetComputerName : string');
 CL.AddDelphiFunction('Function ReplaceAllSokr( S : string; Words, Frases : TStrings) : string');
 CL.AddDelphiFunction('Function ReplaceSokr( S : string; PosBeg, Len : Integer; Words, Frases : TStrings; var NewSelStart : Integer) : string');
 CL.AddDelphiFunction('Function CountOfLines( const S : string) : Integer');
 CL.AddDelphiFunction('Procedure DeleteEmptyLines( Ss : TStrings)');
 CL.AddDelphiFunction('Procedure SQLAddWhere( SQL : TStrings; const Where : string)');
 //CL.AddDelphiFunction('Function ResSaveToFile( const Typ, Name : string; const Compressed : Boolean; const FileName : string) : Boolean');
 //CL.AddDelphiFunction('Function ResSaveToFileEx( Instance : HINST; Typ, Name : PChar; const Compressed : Boolean; const FileName : string) : Boolean');
 //CL.AddDelphiFunction('Function ResSaveToString( Instance : HINST; const Typ, Name : string; var S : string) : Boolean');
 CL.AddDelphiFunction('Function ExecuteJ( const CommandLine, WorkingDirectory : string) : Integer');
 CL.AddDelphiFunction('Function IniReadSection( const IniFileName : TFileName; const Section : string; Ss : TStrings) : Boolean');
 {CL.AddDelphiFunction('Function LoadTextFile( const FileName : TFileName) : string');
 CL.AddDelphiFunction('Procedure SaveTextFile( const FileName : TFileName; const Source : string)');
 CL.AddDelphiFunction('Function ReadFolder( const Folder, Mask : TFileName; FileList : TStrings) : Integer');
 CL.AddDelphiFunction('Function ReadFolders( const Folder : TFileName; FolderList : TStrings) : Integer');}
 CL.AddDelphiFunction('Function TargetFileName( const FileName : TFileName) : TFileName');
 CL.AddDelphiFunction('Function ResolveLink( const hWnd : HWND; const LinkFile : TFileName; var FileName : TFileName) : HRESULT');
 //CL.AddDelphiFunction('Procedure LoadIcoToImage( ALarge, ASmall : TImageList; const NameRes : string)');
 CL.AddDelphiFunction('Procedure RATextOut( Canvas : TCanvas; const R, RClip : TRect; const S : string)');
 CL.AddDelphiFunction('Function RATextOutEx( Canvas : TCanvas; const R, RClip : TRect; const S : string; const CalcHeight : Boolean) : Integer');
 CL.AddDelphiFunction('Function RATextCalcHeight( Canvas : TCanvas; const R : TRect; const S : string) : Integer');
 CL.AddDelphiFunction('Procedure Cinema( Canvas : TCanvas; rS, rD : TRect)');
 CL.AddDelphiFunction('Procedure Roughed( ACanvas : TCanvas; const ARect : TRect; const AVert : Boolean)');
 CL.AddDelphiFunction('Function BitmapFromBitmap( SrcBitmap : TBitmap; const AWidth, AHeight, Index : Integer) : TBitmap');
 CL.AddDelphiFunction('Function TextWidth( AStr : string) : Integer');
 CL.AddDelphiFunction('Function DefineCursorJ( Identifer : PChar) : TCursor');
 CL.AddDelphiFunction('Function FindFormByClass( FormClass : TFormClass) : TForm');
 CL.AddDelphiFunction('Function FindFormByClassName( FormClassName : string) : TForm');
 //CL.AddDelphiFunction('Function FindByTag( WinControl : TWinControl; ComponentClass : TComponentClass; const Tag : Integer) : TComponent');
 CL.AddDelphiFunction('Function ControlAtPos2( Parent : TWinControl; X, Y : Integer) : TControl');
 CL.AddDelphiFunction('Function RBTag( Parent : TWinControl) : Integer');
 CL.AddDelphiFunction('Function AppMinimized : Boolean');
 CL.AddDelphiFunction('Function MessageBoxJ( const Msg : string; Caption : string; const Flags : Integer) : Integer');
 CL.AddDelphiFunction('Function MsgDlg2( const Msg, ACaption : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; HelpContext : Integer; Control : TWinControl) : Integer');
 CL.AddDelphiFunction('Function MsgDlgDef( const Msg, ACaption : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; DefButton : TMsgDlgBtn; HelpContext : Integer; Control : TWinControl) : Integer');
 CL.AddDelphiFunction('Procedure DelayJ( MSec : Longword)');
 CL.AddDelphiFunction('Procedure CenterHor( Parent : TControl; MinLeft : Integer; Controls : array of TControl)');
 CL.AddDelphiFunction('Procedure EnableControls( Control : TWinControl; const Enable : Boolean)');
 CL.AddDelphiFunction('Procedure EnableMenuItems( MenuItem : TMenuItem; const Tag : Integer; const Enable : Boolean)');
 CL.AddDelphiFunction('Procedure ExpandWidth( Parent : TControl; MinWidth : Integer; Controls : array of TControl)');
 CL.AddDelphiFunction('Function PanelBorder( Panel : TCustomPanel) : Integer');
 CL.AddDelphiFunction('Function Pixels( Control : TControl; APixels : Integer) : Integer');
 CL.AddDelphiFunction('Procedure SetChildPropOrd( Owner : TComponent; PropName : string; Value : Longint)');
 CL.AddDelphiFunction('Procedure ErrorJ( const Msg : string)');
 CL.AddDelphiFunction('Procedure ItemHtDrawEx( Canvas : TCanvas; Rect : TRect; const State : TOwnerDrawState; const Text : string; const HideSelColor : Boolean; var PlainItem : string; var Width : Integer; CalcWidth : Boolean)');
 CL.AddDelphiFunction('Function ItemHtDraw( Canvas : TCanvas; Rect : TRect; const State : TOwnerDrawState; const Text : string; const HideSelColor : Boolean) : string');
 CL.AddDelphiFunction('Function ItemHtWidth( Canvas : TCanvas; Rect : TRect; const State : TOwnerDrawState; const Text : string; const HideSelColor : Boolean) : Integer');
 CL.AddDelphiFunction('Function ItemHtPlain( const Text : string) : string');
 //CL.AddDelphiFunction('Procedure ClearList( List : TList)');
 CL.AddDelphiFunction('Procedure MemStreamToClipBoard( MemStream : TMemoryStream; const Format : Word)');
 CL.AddDelphiFunction('Procedure ClipBoardToMemStream( MemStream : TMemoryStream; const Format : Word)');
 //CL.AddDelphiFunction('Function GetPropType( Obj : TObject; const PropName : string) : TTypeKind');
 CL.AddDelphiFunction('Function GetPropStr( Obj : TObject; const PropName : string) : string');
 CL.AddDelphiFunction('Function GetPropOrd( Obj : TObject; const PropName : string) : Integer');
 //CL.AddDelphiFunction('Function GetPropMethod( Obj : TObject; const PropName : string) : TMethod');
 CL.AddDelphiFunction('Procedure PrepareIniSection( SS : TStrings)');
 //CL.AddDelphiFunction('Function CompareMem( P1, P2 : ___Pointer; Length : Integer) : Boolean');
  CL.AddTypeS('TMenuAnimation', '( maNone, maRandom, maUnfold, maSlide )');
 CL.AddDelphiFunction('Procedure ShowMenu( Form : TForm; MenuAni : TMenuAnimation)');
  CL.AddTypeS('TProcObj', 'Procedure');
 CL.AddDelphiFunction('Procedure ExecAfterPause( Proc : TProcObj; Pause : Integer)');
 CL.AddConstantN('NoHelp','LongInt').SetInt( 0);
 CL.AddConstantN('MsgDlgCharSet','Integer').SetInt( DEFAULT_CHARSET);
 //CL.AddDelphiFunction('Function PointL( const X, Y : Longint) : TPointL');
 CL.AddDelphiFunction('Function iif( const Test : Boolean; const ATrue, AFalse : Variant) : Variant');
end;


function CharInSetmax(const C: Char; const testSet: TSysCharSet): boolean;
begin
  Result := C in testSet;
end;


(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JvUtils_Routines(S: TPSExec);
begin

 //S.RegisterDelphiFunction(@SendRectMessage, 'SendRectMessage', cdRegister);
 //S.RegisterDelphiFunction(@SendStructMessage, 'SendStructMessage', cdRegister);
 //S.RegisterDelphiFunction(@ReadCharsFromStream, 'ReadCharsFromStream', cdRegister);
 //S.RegisterDelphiFunction(@WriteStringToStream, 'WriteStringToStream', cdRegister);

 S.RegisterDelphiFunction(@GetWordOnPos, 'GetWordOnPos', cdRegister);
 S.RegisterDelphiFunction(@GetWordOnPosEx, 'GetWordOnPosEx', cdRegister);
 S.RegisterDelphiFunction(@SubStr, 'SubStrJ', cdRegister);
 S.RegisterDelphiFunction(@SubStrEnd, 'SubStrEnd', cdRegister);
 S.RegisterDelphiFunction(@SubWord, 'SubWord', cdRegister);
 S.RegisterDelphiFunction(@NumberByWord, 'NumberByWord', cdRegister);
 S.RegisterDelphiFunction(@GetLineByPos, 'GetLineByPos', cdRegister);
 S.RegisterDelphiFunction(@GetXYByPos, 'GetXYByPosJ', cdRegister);
 S.RegisterDelphiFunction(@ReplaceString, 'ReplaceStringJ', cdRegister);
 S.RegisterDelphiFunction(@ConcatSep, 'ConcatSep', cdRegister);
 S.RegisterDelphiFunction(@ConcatLeftSep, 'ConcatLeftSep', cdRegister);
 S.RegisterDelphiFunction(@MinimizeString, 'MinimizeString', cdRegister);
 S.RegisterDelphiFunction(@Dos2Win, 'Dos2Win', cdRegister);
 S.RegisterDelphiFunction(@Win2Dos, 'Win2Dos', cdRegister);
 S.RegisterDelphiFunction(@Dos2WinRes, 'Dos2WinRes', cdRegister);
 S.RegisterDelphiFunction(@Win2DosRes, 'Win2DosRes', cdRegister);
 S.RegisterDelphiFunction(@Win2Koi, 'Win2Koi', cdRegister);
 //S.RegisterDelphiFunction(@Spaces, 'Spaces', cdRegister);
 //S.RegisterDelphiFunction(@AddSpaces, 'AddSpaces', cdRegister);
 S.RegisterDelphiFunction(@LastDate, 'LastDate', cdRegister);
 S.RegisterDelphiFunction(@CurrencyToStr, 'CurrencyToStr', cdRegister);
 S.RegisterDelphiFunction(@Cmp, 'CmpJ', cdRegister);
 S.RegisterDelphiFunction(@StringCat, 'StringCat', cdRegister);
 S.RegisterDelphiFunction(@HasChar, 'HasChar', cdRegister);
 S.RegisterDelphiFunction(@HasAnyChar, 'HasAnyChar', cdRegister);
 S.RegisterDelphiFunction(@jvutils.CharInSet, 'CharInSet2', cdRegister);
 S.RegisterDelphiFunction(@CharInSetmax, 'CharInSet', cdRegister);

 S.RegisterDelphiFunction(@CountOfChar, 'CountOfChar', cdRegister);
 S.RegisterDelphiFunction(@DefStr, 'DefStr', cdRegister);
 S.RegisterDelphiFunction(@GetWinDir, 'GetWinDir', cdRegister);
 S.RegisterDelphiFunction(@GetSysDir, 'GetSysDir', cdRegister);
 S.RegisterDelphiFunction(@GetTempDir, 'GetTempDir', cdRegister);
 S.RegisterDelphiFunction(@GenTempFileName, 'GenTempFileName', cdRegister);
 S.RegisterDelphiFunction(@GenTempFileNameExt, 'GenTempFileNameExt', cdRegister);
 //S.RegisterDelphiFunction(@ClearDir, 'ClearDir', cdRegister);
 //S.RegisterDelphiFunction(@DeleteDir, 'DeleteDir', cdRegister);
 S.RegisterDelphiFunction(@FileEquMask, 'FileEquMask', cdRegister);
 S.RegisterDelphiFunction(@FileEquMasks, 'FileEquMasks', cdRegister);
 S.RegisterDelphiFunction(@DeleteFiles, 'DeleteFiles', cdRegister);
 S.RegisterDelphiFunction(@LZFileExpand, 'LZFileExpand', cdRegister);
 S.RegisterDelphiFunction(@FileGetInfo, 'FileGetInfo', cdRegister);
 S.RegisterDelphiFunction(@HasSubFolder, 'HasSubFolder', cdRegister);
 S.RegisterDelphiFunction(@IsEmptyFolder, 'IsEmptyFolder', cdRegister);
 S.RegisterDelphiFunction(@AddSlash, 'AddSlash', cdRegister);
 S.RegisterDelphiFunction(@AddSlash2, 'AddSlash2', cdRegister);
 S.RegisterDelphiFunction(@AddPath, 'AddPath', cdRegister);
 S.RegisterDelphiFunction(@AddPaths, 'AddPaths', cdRegister);
 S.RegisterDelphiFunction(@ParentPath, 'ParentPath', cdRegister);
 S.RegisterDelphiFunction(@FindInPath, 'FindInPath', cdRegister);
 //S.RegisterDelphiFunction(@BrowseForFolder, 'BrowseForFolder', cdRegister);
 S.RegisterDelphiFunction(@DeleteReadOnlyFile, 'DeleteReadOnlyFile', cdRegister);
 S.RegisterDelphiFunction(@HasParam, 'HasParam', cdRegister);
 S.RegisterDelphiFunction(@HasSwitch, 'HasSwitch', cdRegister);
 S.RegisterDelphiFunction(@Switch, 'Switch', cdRegister);
 S.RegisterDelphiFunction(@ExePath, 'ExePathJ', cdRegister);
 //S.RegisterDelphiFunction(@CopyDir, 'CopyDir', cdRegister);
 S.RegisterDelphiFunction(@FileTimeToDateTime, 'FileTimeToDateTime', cdRegister);
 S.RegisterDelphiFunction(@MakeValidFileName, 'MakeValidFileNameJ', cdRegister);
 S.RegisterDelphiFunction(@TTFontSelected, 'TTFontSelected', cdRegister);
 S.RegisterDelphiFunction(@TrueInflateRect, 'TrueInflateRect', cdRegister);
 S.RegisterDelphiFunction(@SetWindowTop, 'SetWindowTop', cdRegister);
 S.RegisterDelphiFunction(@KeyPressed, 'KeyPressed', cdRegister);
 S.RegisterDelphiFunction(@SwapInt, 'SwapIntJ', cdRegister);
 //S.RegisterDelphiFunction(@IntPower, 'IntPowerJ', cdRegister);
 //S.RegisterDelphiFunction(@ChangeTopException, 'ChangeTopException', cdRegister);
 //S.RegisterDelphiFunction(@StrToBool, 'StrToBoolJ', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrLIComp, 'AnsiStrLIComp', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrIComp, 'AnsiStrIComp', cdRegister);
 //S.RegisterDelphiFunction(@Var2Type, 'Var2TypeJ', cdRegister);
 //S.RegisterDelphiFunction(@VarToInt, 'VarToInt', cdRegister);
 //S.RegisterDelphiFunction(@VarToFloat, 'VarToFloat', cdRegister);
 S.RegisterDelphiFunction(@ReplaceSokr1, 'ReplaceSokr1', cdRegister);
 S.RegisterDelphiFunction(@GetSubStr, 'GetSubStr', cdRegister);
 S.RegisterDelphiFunction(@GetParameter, 'GetParameter', cdRegister);
 S.RegisterDelphiFunction(@GetLongFileName, 'GetLongFileName', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExists, 'DirectoryExistsJ', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectories, 'ForceDirectoriesJ', cdRegister);
 S.RegisterDelphiFunction(@FileNewExt, 'FileNewExt', cdRegister);
 S.RegisterDelphiFunction(@GetComputerID, 'GetComputerID', cdRegister);
 S.RegisterDelphiFunction(@GetComputerName, 'GetComputerName', cdRegister);
 S.RegisterDelphiFunction(@ReplaceAllSokr, 'ReplaceAllSokr', cdRegister);
 S.RegisterDelphiFunction(@ReplaceSokr, 'ReplaceSokr', cdRegister);
 S.RegisterDelphiFunction(@CountOfLines, 'CountOfLines', cdRegister);
 S.RegisterDelphiFunction(@DeleteEmptyLines, 'DeleteEmptyLines', cdRegister);
 S.RegisterDelphiFunction(@SQLAddWhere, 'SQLAddWhere', cdRegister);
 //S.RegisterDelphiFunction(@ResSaveToFile, 'ResSaveToFile', cdRegister);
 //S.RegisterDelphiFunction(@ResSaveToFileEx, 'ResSaveToFileEx', cdRegister);
 //S.RegisterDelphiFunction(@ResSaveToString, 'ResSaveToString', cdRegister);
 S.RegisterDelphiFunction(@Execute, 'ExecuteJ', cdRegister);
 S.RegisterDelphiFunction(@IniReadSection, 'IniReadSection', cdRegister);
 //S.RegisterDelphiFunction(@LoadTextFile, 'LoadTextFile', cdRegister);    in jvJCLUtils
 //S.RegisterDelphiFunction(@SaveTextFile, 'SaveTextFile', cdRegister);
 //S.RegisterDelphiFunction(@ReadFolder, 'ReadFolder', cdRegister);
 //S.RegisterDelphiFunction(@ReadFolders, 'ReadFolders', cdRegister);
// S.RegisterDelphiFunction(@TargetFileName, 'TargetFileName', cdRegister);
 //S.RegisterDelphiFunction(@ResolveLink, 'ResolveLink', cdRegister);
 S.RegisterDelphiFunction(@LoadIcoToImage, 'LoadIcoToImage', cdRegister);
 S.RegisterDelphiFunction(@RATextOut, 'RATextOut', cdRegister);
 S.RegisterDelphiFunction(@RATextOutEx, 'RATextOutEx', cdRegister);
 S.RegisterDelphiFunction(@RATextCalcHeight, 'RATextCalcHeight', cdRegister);
 S.RegisterDelphiFunction(@Cinema, 'Cinema', cdRegister);
 S.RegisterDelphiFunction(@Roughed, 'Roughed', cdRegister);
 S.RegisterDelphiFunction(@BitmapFromBitmap, 'BitmapFromBitmap', cdRegister);
 S.RegisterDelphiFunction(@TextWidth, 'TextWidth', cdRegister);
 S.RegisterDelphiFunction(@DefineCursor, 'DefineCursorJ', cdRegister);
 S.RegisterDelphiFunction(@FindFormByClass, 'FindFormByClass', cdRegister);
 S.RegisterDelphiFunction(@FindFormByClassName, 'FindFormByClassName', cdRegister);
 S.RegisterDelphiFunction(@FindByTag, 'FindByTag', cdRegister);
 S.RegisterDelphiFunction(@ControlAtPos2, 'ControlAtPos2', cdRegister);
 S.RegisterDelphiFunction(@RBTag, 'RBTag', cdRegister);
 S.RegisterDelphiFunction(@AppMinimized, 'AppMinimized', cdRegister);
 S.RegisterDelphiFunction(@MessageBox, 'MessageBoxJ', cdRegister);
 S.RegisterDelphiFunction(@MsgDlg2, 'MsgDlg2', cdRegister);
 S.RegisterDelphiFunction(@MsgDlgDef, 'MsgDlgDef', cdRegister);
 S.RegisterDelphiFunction(@Delay, 'DelayJ', cdRegister);
 S.RegisterDelphiFunction(@CenterHor, 'CenterHor', cdRegister);
 S.RegisterDelphiFunction(@EnableControls, 'EnableControls', cdRegister);
 S.RegisterDelphiFunction(@EnableMenuItems, 'EnableMenuItems', cdRegister);
 S.RegisterDelphiFunction(@ExpandWidth, 'ExpandWidth', cdRegister);
 S.RegisterDelphiFunction(@PanelBorder, 'PanelBorder', cdRegister);
 S.RegisterDelphiFunction(@Pixels, 'Pixels', cdRegister);
 S.RegisterDelphiFunction(@SetChildPropOrd, 'SetChildPropOrd', cdRegister);
 S.RegisterDelphiFunction(@Error, 'ErrorJ', cdRegister);
 S.RegisterDelphiFunction(@ItemHtDrawEx, 'ItemHtDrawEx', cdRegister);
 S.RegisterDelphiFunction(@ItemHtDraw, 'ItemHtDraw', cdRegister);
 S.RegisterDelphiFunction(@ItemHtWidth, 'ItemHtWidth', cdRegister);
 S.RegisterDelphiFunction(@ItemHtPlain, 'ItemHtPlain', cdRegister);
 S.RegisterDelphiFunction(@ClearList, 'ClearList', cdRegister);
 S.RegisterDelphiFunction(@MemStreamToClipBoard, 'MemStreamToClipBoard', cdRegister);
 S.RegisterDelphiFunction(@ClipBoardToMemStream, 'ClipBoardToMemStream', cdRegister);
 S.RegisterDelphiFunction(@GetPropType, 'GetPropType', cdRegister);
 S.RegisterDelphiFunction(@GetPropStr, 'GetPropStr', cdRegister);
 S.RegisterDelphiFunction(@GetPropOrd, 'GetPropOrd', cdRegister);
 S.RegisterDelphiFunction(@GetPropMethod, 'GetPropMethod', cdRegister);
 S.RegisterDelphiFunction(@PrepareIniSection, 'PrepareIniSection', cdRegister);
 //S.RegisterDelphiFunction(@CompareMem, 'CompareMem', cdRegister);
 S.RegisterDelphiFunction(@ShowMenu, 'ShowMenu', cdRegister);
 S.RegisterDelphiFunction(@ExecAfterPause, 'ExecAfterPause', cdRegister);
 S.RegisterDelphiFunction(@PointL, 'PointL', cdRegister);
 S.RegisterDelphiFunction(@iif, 'iif', cdRegister);
end;



{ TPSImport_JvUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JvUtils(ri);
  RIRegister_JvUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 

end.
