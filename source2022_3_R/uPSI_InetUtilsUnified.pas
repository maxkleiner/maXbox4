unit uPSI_InetUtilsUnified;
{
with draw utils unified wide

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
  TPSImport_InetUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_EInet(CL: TPSPascalCompiler);
procedure SIRegister_InetUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_InetUtils_Routines(S: TPSExec);
procedure RIRegister_EInet(CL: TPSRuntimeClassImporter);
procedure RIRegister_InetUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,WinInet, Graphics //, StringUtils
  ,InetUtilsunified
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_InetUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_EInet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EInet') do
  with CL.AddClassN(CL.FindClass('Exception'),'EInet') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_InetUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TNetUtilsSettings', 'record UserAgent : String; ProxyURL : Strin'
   +'g; OpenURLFlags : DWord; TrafficCounter : Dword; UploadedCounter : DWord; ReadBufferSize : DWord; end');
  CL.AddTypeS('TRawCharset', 'set of Char');
  CL.AddTypeS('TInetHeaders', 'array of String');
  SIRegister_EInet(CL);
  CL.AddTypeS('TInetDownloadCallback', 'Function ( Downloaded, TotalSize : DWord) : Boolean');
 CL.AddDelphiFunction('Function InetDownloadTo( const DestFile : WideString; const URL : String; Callback : TInetDownloadCallback) : Boolean;');
 CL.AddDelphiFunction('Function InetDownloadTo1( const DestFile : WideString; const URL : String; const Settings : TNetUtilsSettings; Callback : TInetDownloadCallback) : Boolean;');
 CL.AddDelphiFunction('Function InetDownload( const URL : String; Dest : TStream; Callback : TInetDownloadCallback) : Boolean;');
 CL.AddDelphiFunction('Function InetDownload3( const URL : String; Dest : TStream; const Settings : TNetUtilsSettings; Callback : TInetDownloadCallback) : Boolean;');
 CL.AddDelphiFunction('Function InetBufferedReadFrom( Handle : HInternet; Dest : TStream; const Settings : TNetUtilsSettings; Callback : TInetDownloadCallback) : DWord;');
 CL.AddDelphiFunction('Function InetBufferedReadFrom5( Handle : HInternet; const Settings : TNetUtilsSettings; Callback : TInetDownloadCallback) : String;');
 CL.AddDelphiFunction('Function IsResponseStatusOK( Handle : HInternet) : Boolean');
  CL.AddTypeS('TMultipartItem', 'record Headers : TInetHeaders; Data : TStream; end');

  {  TMaskMatchInfo = record
    Matched: Boolean;
    StrPos: Word;
    MatchLength: Word;
  end;}

  CL.AddTypeS('TMaskMatchInfo', 'record Matched: Boolean; StrPos: Word; MatchLength: Word; end');

  CL.AddTypeS('TMultipartItems', 'array of TMultipartItem');
  CL.AddTypeS('TUploadFile', 'record Name : String; SourceFileName : WideString; Data : TStream; end');
  CL.AddTypeS('TUploadFiles', 'array of TUploadFile');
 CL.AddDelphiFunction('Function FindBoundaryFor( const Items : TMultipartItems) : String');
 CL.AddDelphiFunction('Function RandomBoundary : String');
 CL.AddDelphiFunction('Function GenerateMultipartFormFrom( const Items : TMultipartItems; out ExtraHeaders : TInetHeaders) : String');
 CL.AddDelphiFunction('Function InetUploadTo( const ToURL : String; const Headers : TInetHeaders; const Items : TMultipartItems; const Settings : TNetUtilsSettings) : String;');
 CL.AddDelphiFunction('Function InetUploadTo7( const ToURL : String; const Items : TMultipartItems; const Settings : TNetUtilsSettings) : String;');
 CL.AddDelphiFunction('Function InetUploadTo8( const ToURL : String; const Items : TMultipartItems) : String;');
 CL.AddDelphiFunction('Function InetUploadStreamsTo( const ToURL : String; const Settings : TNetUtilsSettings; Streams : TUploadFiles) : String;');
 CL.AddDelphiFunction('Function InetUploadStreamsTo10( const ToURL : String; const Streams : TUploadFiles) : String;');
 CL.AddDelphiFunction('Function InetUploadFileTo( const ToURL : String; const Settings : TNetUtilsSettings; const ItemName : String; const FilePath : WideString) : String;');
 CL.AddDelphiFunction('Function InetUploadFileTo12( const ToURL : String; const ItemName : String; const FilePath : WideString) : String;');
 CL.AddDelphiFunction('Function InetUploadFilesTo( const ToURL : String; const Settings : TNetUtilsSettings; const Files : array of const) : String;');
 CL.AddDelphiFunction('Function InetUploadFilesTo14( const ToURL : String; const Files : array of const) : String;');
 CL.AddDelphiFunction('Function AppendQueryTo( const URL : String; const Arguments : array of const) : String');
 CL.AddDelphiFunction('Function HasQueryPart( const URL : String) : Boolean');
 CL.AddDelphiFunction('Function BuildQueryFrom( const Arguments : array of const) : String');
 CL.AddDelphiFunction('Function BuildURLW( Protocol, Host : String; Port : Word; Path, Script : String; const Arguments : array of const) : String');
 CL.AddDelphiFunction('Function CustomEncode( const Str : WideString; const RawChars : TRawCharset) : String');
 CL.AddDelphiFunction('Function EncodeURI( const Str : WideString) : String');
 CL.AddDelphiFunction('Function EncodeURIComponent( const Str : WideString) : String');
 CL.AddDelphiFunction('Procedure InetGetLastError( out ErrorCode : DWord; out ErrorMessage : String)');
 CL.AddDelphiFunction('Function InetGetLastErrorCode : DWord');
 CL.AddDelphiFunction('Function InetGetLastErrorMsg : String');
 CL.AddDelphiFunction('Function AbsoluteURLFrom( URL, BaseURL, BasePath : String) : String');
 CL.AddDelphiFunction('Procedure SplitURL( const URL : String; out Domain, Path : String)');
 CL.AddDelphiFunction('Function DomainOf( const URL : String) : String');
 CL.AddDelphiFunction('Function PathFromURL( const URL : String) : String');
 CL.AddDelphiFunction('Function InetHeaders( const NameValues : array of const) : TInetHeaders');
 CL.AddDelphiFunction('Function NoInetHeaders : TInetHeaders');
 CL.AddDelphiFunction('Function JoinHeaders( const Headers : TInetHeaders) : String');
 CL.AddConstantN('InetHeaderEOLN','String').SetString( #13#10);
 CL.AddDelphiFunction('Procedure SetDefaultNetUtilsSettings');
 CL.AddDelphiFunction('Procedure SetDefaultNetUtilsSettings2');
 CL.AddDelphiFunction('Procedure SetDefaultNetUtilsSettings3');

 CL.AddDelphiFunction('Function TotalDownTrafficThroughNetUtils : DWord');
  CL.AddTypeS('TDBDraw', 'record DisplayDC : HDC; MemDC : HDC; MemBitmap : HBIT'
   +'MAP; OldBitmap : HBITMAP; OldFont : HFONT; OldPen : HPEN; end');
  CL.AddTypeS('TPieceFormatData', 'record Position : TMaskMatchInfo; Color : TColor; end');
  CL.AddTypeS('TFormatData', 'array of TPieceFormatData');
  CL.AddTypeS('TDrawFormattedTextSettings', 'record Text : WideString; FormatDa'
   +'ta : TFormatData; Canvas : TCanvas; WrapText : Boolean; DestPos : TPoint; MaxWidth : Word; CharSpacing : Word; end');
  CL.AddTypeS('TWrapTextSettings', 'record DC : HDC; Str : WideString; Delimite'
   +'r : WideString; MaxWidth : Word; LeftMargin : Word; CharSpacing : Word; LastChar : TSize; end');
 CL.AddDelphiFunction('Function TextSize( const DC : HDC; const Str : WideString) : TSize');
 CL.AddDelphiFunction('Function TextWidthW2( const DC : HDC; const Str : WideString) : Integer');
 CL.AddDelphiFunction('Function TextHeightW2( const DC : HDC; const Str : WideString) : Integer');
 CL.AddDelphiFunction('Function GetLineHeightOf( const Font : HFONT) : Word');
 CL.AddDelphiFunction('Function TextWidthEx( const DC : HDC; const Str : WideString; const CharSpacing : Word) : Integer');
 CL.AddDelphiFunction('Function TextHeightEx( const DC : HDC; const Str : WideString; const CharSpacing : Word) : Integer');
 CL.AddDelphiFunction('Function TextSizeEx( const DC : HDC; const Str : WideString; const CharSpacing : Word) : TSize');
 CL.AddDelphiFunction('Function TextWithBreaksSize( Settings : TWrapTextSettings) : TSize;');
 CL.AddDelphiFunction('Function DoubleBufferedDraw( const DisplaySurface : HDC; const BufferSize : TPoint) : TDBDraw;');
 CL.AddDelphiFunction('Function DoubleBufferedDraw17( const Canvas : TCanvas; const BufferSize : TPoint) : TDBDraw;');
 CL.AddDelphiFunction('Function DoubleBufferedDraw2( const Canvas : TCanvas; const BufferSize : TPoint) : TDBDraw;');

 CL.AddDelphiFunction('Procedure DrawFormattedText( const Settings : TDrawFormattedTextSettings)');
 CL.AddDelphiFunction('Function GetLastCharPos( const DC : HDC; const Str : WideString; const MaxWidth : Word; const CharSpacing : Word) : TSize');
 CL.AddDelphiFunction('Function WrapNonMonospacedText( const DC : HDC; const Str : WideString; const Delimiter : WideString; const MaxWidth : Word; const CharSpacing : Word) : WideString;');
 CL.AddDelphiFunction('Function WrapNonMonospacedText2( var Settings : TWrapTextSettings) : WideString;');
 // CL.AddDelphiFunction('Function TrimWS( Str : WideString; const Chars : WideString) : WideString');
 //CL.AddDelphiFunction('Function TrimLeftWS( Str : WideString; const Chars : WideString) : WideString');
 //CL.AddDelphiFunction('Function TrimRightWS( Str : WideString; const Chars : WideString) : WideString');
 {CL.AddDelphiFunction('Function ConsistsOfChars( const Str, Chars : WideString) : Boolean');
 CL.AddDelphiFunction('Function UpperCaseW( const Str : WideString) : WideString');
 CL.AddDelphiFunction('Function LowerCaseW( const Str : WideString) : WideString');
 CL.AddDelphiFunction('Function UpperCaseFirst( const Str : WideString) : WideString');
 CL.AddDelphiFunction('Function LowerCaseFirst( const Str : WideString) : WideString');
 CL.AddDelphiFunction('Function StripAccelChars( const Str : WideString) : WideString'); }

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function WrapNonMonospacedText19_P( var Settings : TWrapTextSettings) : WideString;
Begin Result := InetUtilsunified.WrapNonMonospacedText(Settings); END;

(*----------------------------------------------------------------------------*)
Function WrapNonMonospacedText_P( const DC : HDC; const Str : WideString; const Delimiter : WideString; const MaxWidth : Word; const CharSpacing : Word) : WideString;
Begin Result := InetUtilsunified.WrapNonMonospacedText(DC, Str, Delimiter, MaxWidth, CharSpacing); END;

(*----------------------------------------------------------------------------*)
Function DoubleBufferedDraw17_P( const Canvas : TCanvas; const BufferSize : TPoint) : TDBDraw;
Begin Result := InetUtilsunified.DoubleBufferedDraw(Canvas, BufferSize); END;

(*----------------------------------------------------------------------------*)
Function DoubleBufferedDraw_P( const DisplaySurface : HDC; const BufferSize : TPoint) : TDBDraw;
Begin Result := InetUtilsunified.DoubleBufferedDraw(DisplaySurface, BufferSize); END;

(*----------------------------------------------------------------------------*)
Function TextWithBreaksSize_P( Settings : TWrapTextSettings) : TSize;
Begin Result := InetUtilsunified.TextWithBreaksSize(Settings); END;

(*----------------------------------------------------------------------------*)
Function InetUploadFilesTo14_P( const ToURL : String; const Files : array of const) : String;
Begin Result := InetUtilsunified.InetUploadFilesTo(ToURL, Files); END;

(*----------------------------------------------------------------------------*)
Function InetUploadFilesTo_P( const ToURL : String; const Settings : TNetUtilsSettings; const Files : array of const) : String;
Begin Result := InetUtilsunified.InetUploadFilesTo(ToURL, Settings, Files); END;

(*----------------------------------------------------------------------------*)
Function InetUploadFileTo12_P( const ToURL : String; const ItemName : String; const FilePath : WideString) : String;
Begin Result := InetUtilsunified.InetUploadFileTo(ToURL, ItemName, FilePath); END;

(*----------------------------------------------------------------------------*)
Function InetUploadFileTo_P( const ToURL : String; const Settings : TNetUtilsSettings; const ItemName : String; const FilePath : WideString) : String;
Begin Result := InetUtilsunified.InetUploadFileTo(ToURL, Settings, ItemName, FilePath); END;

(*----------------------------------------------------------------------------*)
Function InetUploadStreamsTo10_P( const ToURL : String; const Streams : TUploadFiles) : String;
Begin Result := InetUtilsunified.InetUploadStreamsTo(ToURL, Streams); END;

(*----------------------------------------------------------------------------*)
Function InetUploadStreamsTo_P( const ToURL : String; const Settings : TNetUtilsSettings; Streams : TUploadFiles) : String;
Begin Result := InetUtilsunified.InetUploadStreamsTo(ToURL, Settings, Streams); END;

(*----------------------------------------------------------------------------*)
Function InetUploadTo8_P( const ToURL : String; const Items : TMultipartItems) : String;
Begin Result := InetUtilsunified.InetUploadTo(ToURL, Items); END;

(*----------------------------------------------------------------------------*)
Function InetUploadTo7_P( const ToURL : String; const Items : TMultipartItems; const Settings : TNetUtilsSettings) : String;
Begin Result := InetUtilsunified.InetUploadTo(ToURL, Items, Settings); END;

(*----------------------------------------------------------------------------*)
Function InetUploadTo_P( const ToURL : String; const Headers : TInetHeaders; const Items : TMultipartItems; const Settings : TNetUtilsSettings) : String;
Begin Result := InetUtilsunified.InetUploadTo(ToURL, Headers, Items, Settings); END;

(*----------------------------------------------------------------------------*)
Function InetBufferedReadFrom5_P( Handle : HInternet; const Settings : TNetUtilsSettings; Callback : TInetDownloadCallback) : String;
Begin Result := InetUtilsunified.InetBufferedReadFrom(Handle, Settings, Callback); END;

(*----------------------------------------------------------------------------*)
Function InetBufferedReadFrom_P( Handle : HInternet; Dest : TStream; const Settings : TNetUtilsSettings; Callback : TInetDownloadCallback) : DWord;
Begin Result := InetUtilsunified.InetBufferedReadFrom(Handle, Dest, Settings, Callback); END;

(*----------------------------------------------------------------------------*)
Function InetDownload3_P( const URL : String; Dest : TStream; const Settings : TNetUtilsSettings; Callback : TInetDownloadCallback) : Boolean;
Begin Result := InetUtilsunified.InetDownload(URL, Dest, Settings, Callback); END;

(*----------------------------------------------------------------------------*)
Function InetDownload_P( const URL : String; Dest : TStream; Callback : TInetDownloadCallback) : Boolean;
Begin Result := InetUtilsunified.InetDownload(URL, Dest, Callback); END;

(*----------------------------------------------------------------------------*)
Function InetDownloadTo1_P( const DestFile : WideString; const URL : String; const Settings : TNetUtilsSettings; Callback : TInetDownloadCallback) : Boolean;
Begin Result := InetUtilsunified.InetDownloadTo(DestFile, URL, Settings, Callback); END;

(*----------------------------------------------------------------------------*)
Function InetDownloadTo_P( const DestFile : WideString; const URL : String; Callback : TInetDownloadCallback) : Boolean;
Begin Result := InetUtilsunified.InetDownloadTo(DestFile, URL, Callback); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_InetUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InetDownloadTo, 'InetDownloadTo', cdRegister);
 S.RegisterDelphiFunction(@InetDownloadTo1_P, 'InetDownloadTo1', cdRegister);
 S.RegisterDelphiFunction(@InetDownload, 'InetDownload', cdRegister);
 S.RegisterDelphiFunction(@InetDownload3_P, 'InetDownload3', cdRegister);
 S.RegisterDelphiFunction(@InetBufferedReadFrom, 'InetBufferedReadFrom', cdRegister);
 S.RegisterDelphiFunction(@InetBufferedReadFrom5_P, 'InetBufferedReadFrom5', cdRegister);
 S.RegisterDelphiFunction(@IsResponseStatusOK, 'IsResponseStatusOK', cdRegister);
 S.RegisterDelphiFunction(@FindBoundaryFor, 'FindBoundaryFor', cdRegister);
 S.RegisterDelphiFunction(@RandomBoundary, 'RandomBoundary', cdRegister);
 S.RegisterDelphiFunction(@GenerateMultipartFormFrom, 'GenerateMultipartFormFrom', cdRegister);
 S.RegisterDelphiFunction(@InetUploadTo, 'InetUploadTo', cdRegister);
 S.RegisterDelphiFunction(@InetUploadTo7_P, 'InetUploadTo7', cdRegister);
 S.RegisterDelphiFunction(@InetUploadTo8_P, 'InetUploadTo8', cdRegister);
 S.RegisterDelphiFunction(@InetUploadStreamsTo, 'InetUploadStreamsTo', cdRegister);
 S.RegisterDelphiFunction(@InetUploadStreamsTo10_P, 'InetUploadStreamsTo10', cdRegister);
 S.RegisterDelphiFunction(@InetUploadFileTo, 'InetUploadFileTo', cdRegister);
 S.RegisterDelphiFunction(@InetUploadFileTo12_P, 'InetUploadFileTo12', cdRegister);
 S.RegisterDelphiFunction(@InetUploadFilesTo, 'InetUploadFilesTo', cdRegister);
 S.RegisterDelphiFunction(@InetUploadFilesTo14_P, 'InetUploadFilesTo14', cdRegister);
 S.RegisterDelphiFunction(@AppendQueryTo, 'AppendQueryTo', cdRegister);
 S.RegisterDelphiFunction(@HasQueryPart, 'HasQueryPart', cdRegister);
 S.RegisterDelphiFunction(@BuildQueryFrom, 'BuildQueryFrom', cdRegister);
 S.RegisterDelphiFunction(@BuildURL, 'BuildURLW', cdRegister);
 S.RegisterDelphiFunction(@CustomEncode, 'CustomEncode', cdRegister);
 S.RegisterDelphiFunction(@EncodeURI, 'EncodeURI', cdRegister);
 S.RegisterDelphiFunction(@EncodeURIComponent, 'EncodeURIComponent', cdRegister);
 S.RegisterDelphiFunction(@InetGetLastError, 'InetGetLastError', cdRegister);
 S.RegisterDelphiFunction(@InetGetLastErrorCode, 'InetGetLastErrorCode', cdRegister);
 S.RegisterDelphiFunction(@InetGetLastErrorMsg, 'InetGetLastErrorMsg', cdRegister);
 S.RegisterDelphiFunction(@AbsoluteURLFrom, 'AbsoluteURLFrom', cdRegister);
 S.RegisterDelphiFunction(@SplitURL, 'SplitURL', cdRegister);
 S.RegisterDelphiFunction(@DomainOf, 'DomainOf', cdRegister);
 S.RegisterDelphiFunction(@PathFromURL, 'PathFromURL', cdRegister);
 S.RegisterDelphiFunction(@InetHeaders, 'InetHeaders', cdRegister);
 S.RegisterDelphiFunction(@NoInetHeaders, 'NoInetHeaders', cdRegister);
 S.RegisterDelphiFunction(@JoinHeaders, 'JoinHeaders', cdRegister);
 S.RegisterDelphiFunction(@SetDefaultNetUtilsSettings, 'SetDefaultNetUtilsSettings', cdRegister);
 S.RegisterDelphiFunction(@SetDefaultNetUtilsSettings2, 'SetDefaultNetUtilsSettings2', cdRegister);
 S.RegisterDelphiFunction(@SetDefaultNetUtilsSettings3, 'SetDefaultNetUtilsSettings3', cdRegister);

 S.RegisterDelphiFunction(@TotalDownTrafficThroughNetUtils, 'TotalDownTrafficThroughNetUtils', cdRegister);
 S.RegisterDelphiFunction(@TextSize, 'TextSize', cdRegister);
 S.RegisterDelphiFunction(@TextWidth, 'TextWidthW2', cdRegister);
 S.RegisterDelphiFunction(@TextHeight, 'TextHeightW2', cdRegister);
 S.RegisterDelphiFunction(@GetLineHeightOf, 'GetLineHeightOf', cdRegister);
 S.RegisterDelphiFunction(@TextWidthEx, 'TextWidthEx', cdRegister);
 S.RegisterDelphiFunction(@TextHeightEx, 'TextHeightEx', cdRegister);
 S.RegisterDelphiFunction(@TextSizeEx, 'TextSizeEx', cdRegister);
 S.RegisterDelphiFunction(@TextWithBreaksSize, 'TextWithBreaksSize', cdRegister);
 S.RegisterDelphiFunction(@DoubleBufferedDraw, 'DoubleBufferedDraw', cdRegister);
 S.RegisterDelphiFunction(@DoubleBufferedDraw17_P, 'DoubleBufferedDraw17', cdRegister);
 S.RegisterDelphiFunction(@DoubleBufferedDraw17_P, 'DoubleBufferedDraw2', cdRegister);

 S.RegisterDelphiFunction(@DrawFormattedText, 'DrawFormattedText', cdRegister);
 S.RegisterDelphiFunction(@GetLastCharPos, 'GetLastCharPos', cdRegister);
 S.RegisterDelphiFunction(@WrapNonMonospacedText, 'WrapNonMonospacedText', cdRegister);
 S.RegisterDelphiFunction(@WrapNonMonospacedText19_P, 'WrapNonMonospacedText2', cdRegister);
 //S.RegisterDelphiFunction(@Trim, 'TrimWS', cdRegister);
//S.RegisterDelphiFunction(@TrimLeft, 'TrimLeftWS', cdRegister);
 //S.RegisterDelphiFunction(@TrimRight, 'TrimRightWS', cdRegister);
 {S.RegisterDelphiFunction(@ConsistsOfChars, 'ConsistsOfChars', cdRegister);
 S.RegisterDelphiFunction(@MaskMatch, 'MaskMatch', cdRegister);
 S.RegisterDelphiFunction(@UpperCase, 'UpperCaseW', cdRegister);
 S.RegisterDelphiFunction(@LowerCase, 'LowerCaseW', cdRegister);
 S.RegisterDelphiFunction(@UpperCaseFirst, 'UpperCaseFirst', cdRegister);
 S.RegisterDelphiFunction(@LowerCaseFirst, 'LowerCaseFirst', cdRegister);
 S.RegisterDelphiFunction(@StripAccelChars, 'StripAccelChars', cdRegister);}

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EInet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EInet) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_InetUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_EInet(CL);
end;

 
 
{ TPSImport_InetUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_InetUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_InetUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_InetUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_InetUtils(ri);
  RIRegister_InetUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
