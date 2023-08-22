unit uPSI_FlyFilesUtils;
(*{
T{$IF Defined(ANDROID)}
  Result := ExtractFilePath(
    ExcludeTrailingPathDelimiter(
    System.IOUtils.TPath.GetHomePath));
{$ELSE}
  Result := ExtractFilePath(ParamStr(0));
{$IFEND ANDROID}

}  *)

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
  TPSImport_FlyFilesUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 

{ compile-time registration functions }
procedure SIRegister_FlyFilesUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_FlyFilesUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,FlyFilesUtils, strutils, MSHTML, Forms, SHDocVw,  activex;
 

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_FlyFilesUtils]);
end;

function TaskbarHandle: Windows.THandle;
begin
  Result := Windows.FindWindow('Shell_TrayWnd', nil);
end;

function TrayHandle: Windows.THandle;
begin
  Result := Windows.FindWindowEx(TaskbarHandle, 0, 'TrayNotifyWnd', nil);
end;


procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;



Procedure DosWipe(Path : string);
{ wipes Files according to Department of Defense standard DOD 5220.22-M }
Var
  DataFile : File;
  DirInfo  : TSearchRec;
 
  Procedure WipeFile(Var DataFile : File);
  Const
    NullByte : Byte = 0;
    FFByte   : Byte = $FF;
    F6Byte   : Byte = $F6;
  Var
    aResult : integer;
    Count  : Byte;
    Count2 : LongInt;
  begin
    Reset(DataFile, 1);
    For Count := 1 to 3 do
    begin
      Seek(DataFile,0);
      For Count2 := 0 to FileSize(DataFile) - 1 do
        BlockWrite(DataFile, FFByte, 1, aresult);
      Seek(DataFile,0);
      For Count2 := 0 to FileSize(DataFile) - 1 do
        BlockWrite(DataFile, NullByte, 1, aresult);
    end;
 
    Seek(DataFile, 0);
    For Count := 0 to FileSize(DataFile) - 1 do
      BlockWrite(DataFile, F6Byte, 1, aresult);
    Close(DataFile);
  end;
 
  Procedure ClearDirEntry;
  begin
    Reset(DataFile);
    Truncate(DataFile);                  { erase size entry }
    Close(DataFile);
    Rename(DataFile, 'TMP00000.$$$');    { erase name entry }
  end;
 
Var
  D : string;
  N : string;
  E : string;
begin
  //Split(Path, D, N, E);
  FindFirst(Path, faArchive, DirInfo);
 
  {While DosError = 0 do begin
    Assign(DataFile, D+DirInfo.Name);
    WipeFile(DataFile);
    ClearDirEntry;
    Erase(DataFile);
    FindNext(DirInfo);
  end;   }
end;


Procedure DOSWipeFile(fn: string);
Var
  size,
  total: longint;
  loop,towrite,numwritten: integer;
  f: file;
  buffer: array[1..1024] of byte;
begin
  assign(f,fn);
  filesetattr(fn,0);
  //if doserror = 0 then begin
    { DOS will normally keep the rest of the file name, and just truncate
      it with a null. But when the full filename is renamed then that can't
      be done. Then it renames it to ~ so that undelete will just show
      a question mark, and same with a sector editor on the hd }
    rename(f,'~~~~~~~~.~~~');
    rename(f,'~');
 
    { Randomize a buffer for later use when we erase the file }
    for loop := 1 to sizeof(buffer) do buffer[loop] := random(256);
 
    { Then we must completely rewrite the file, starting from byte one
      to the filesize, completely erasing all sector data. Very easily
      done, using a random buffer to write with. }
    reset(f,1);
    size := filesize(f);
    total := 0;
    repeat
      { Figure out how much to write }
      towrite := sizeof(buffer);
      if towrite+total > size then towrite := size - total;
      blockwrite(f,buffer,towrite,numwritten);
      inc(total,numwritten);
    until total = size;
 
    { Now we seek to the first byte of the file, and truncate it there,
      leaving it a measly 0 bytes }
    Seek(f,0);
    Truncate(f);
 
    { Now we will close up the file, and delete it }
    close(f);
    erase(f);
  //end;
end;


function ExecAndWait(sExe, sCommandLine: string): Boolean;
var
  dwExitCode: DWORD;
  tpiProcess: TProcessInformation;
  tsiStartup: TStartupInfo;
begin
  Result := False;
  FillChar(tsiStartup, SizeOf(TStartupInfo), 0);
  tsiStartup.cb := SizeOf(TStartupInfo);
  if CreateProcess(PChar(sExe), PChar(sCommandLine), nil, nil, False, 0,
    nil, nil, tsiStartup, tpiprocess) then
  begin
    if WAIT_OBJECT_0 = WaitForSingleObject(tpiProcess.hProcess, INFINITE) then
    begin
      if GetExitCodeProcess(tpiProcess.hProcess, dwExitCode) then
      begin
        if dwExitCode = 0 then
          Result := True
        else
          SetLastError(dwExitCode + $2000);
      end;
    end;
    dwExitCode := GetLastError;
    CloseHandle(tpiProcess.hProcess);
    CloseHandle(tpiProcess.hThread);
    SetLastError(dwExitCode);
  end;
end;

const
HTMLStrGoogle: String = //i put The code for the web page page wich load the google maps in a string const, you can use an external html file too or embed the page in a resource and then load in a stream
'<html> '+
'<head> '+
'<meta name="viewport" content="initial-scale=1.0, user-scalable=yes" /> '+
'<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script> '+
'<script type="text/javascript"> '+
''+
''+//Declare the globals vars to be used in the javascript functions
'  var geocoder; '+
'  var map;  '+
'  var trafficLayer;'+
'  var bikeLayer;'+
''+
''+
'  function initialize() { '+
'    geocoder = new google.maps.Geocoder();'+
'    var latlng = new google.maps.LatLng(40.714776,-74.019213); '+ //Set the initial coordinates for the map
'    var myOptions = { '+
'      zoom: 13, '+
'      center: latlng, '+
'      mapTypeId: google.maps.MapTypeId.ROADMAP '+ //Set the default type map
'    }; '+
'    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions); '+
'    trafficLayer = new google.maps.TrafficLayer();'+ //Create the traffic Layer instance
'    bikeLayer = new google.maps.BicyclingLayer();'+ //Create the Bicycling Layer instance
'  } '+
''+
''+
'  function codeAddress(address) { '+ //function to translate an address to coordinates and put and marker.
'    if (geocoder) {'+
'      geocoder.geocode( { address: address}, function(results, status) { '+
'        if (status == google.maps.GeocoderStatus.OK) {'+
'          map.setCenter(results[0].geometry.location);'+
'          var marker = new google.maps.Marker({'+
'              map: map,'+
'              position: results[0].geometry.location'+
'          });'+
'        } else {'+
'          alert("Geocode was not successful for the following reason: " + status);'+
'        }'+
'      });'+
'    }'+
'  }'+
''+
''+
'  function GotoLatLng(Lat, Lang) { '+ //Set the map in the coordinates and put a marker
'   var latlng = new google.maps.LatLng(Lat,Lang);'+
'   map.setCenter(latlng);'+
'   var marker = new google.maps.Marker({'+
'      position: latlng, '+
'      map: map,'+
'      title:Lat+","+Lang'+
'  });'+
'  }'+
''+
''+
'  function TrafficOn()   { trafficLayer.setMap(map); }'+ //Activate the Traffic layer
''+
'  function TrafficOff()  { trafficLayer.setMap(null); }'+
''+''+
'  function BicyclingOn() { bikeLayer.setMap(map); }'+//Activate the Bicycling layer
''+
'  function BicyclingOff(){ bikeLayer.setMap(null);}'+
''+
'  function StreetViewOn() { map.set("streetViewControl", true); }'+//Activate the streeview control
''+
'  function StreetViewOff() { map.set("streetViewControl", false); }'+
''+
''+'</script> '+
'</head> '+
'<body onload="initialize()"> '+
'  <div id="map_canvas" style="width:100%; height:100%"></div> '+
'</body> '+
'</html> ';


var HTMLWindow2: IHTMLWindow2;

procedure GoogleMapsFormCreate(Sender: TObject; aform: TForm; webbrowser1: TWebbrowser; HTMLStr, navdoc: string);
var
  aStream     : TMemoryStream;
begin

   //WebBrowser1.parent:= aform;
   //WebBrowser1.Navigate('about:blank');
   WebBrowser1.Navigate(navdoc);

    if Assigned(WebBrowser1.Document) then
    begin
      aStream := TMemoryStream.Create;
      try
         aStream.WriteBuffer(Pointer(HTMLStr)^, Length(HTMLStr));
         //aStream.Write(HTMLStr[1], Length(HTMLStr));
         aStream.Seek(0, soFromBeginning);
         (WebBrowser1.Document as IPersistStreamInit).Load(TStreamAdapter.Create(aStream));
      finally
         aStream.Free;
      end;
      HTMLWindow2 := (WebBrowser1.Document as IHTMLDocument2).parentWindow;

    end;
end;

procedure GoogleMapsGotoLocationClick(Sender: TObject; LatitudeText, LongitudeText: string );
begin
   HTMLWindow2.execScript(Format('GotoLatLng(%s,%s)',[LatitudeText,LongitudeText]), 'JavaScript');
end;

procedure GoogleMapsGotoAddressClick(Sender: TObject; vaddress: string);
var
   address    : string;
begin
   address := vaddress;
   address := StringReplace(StringReplace(Trim(address), #13, ' ', [rfReplaceAll]), #10, ' ', [rfReplaceAll]);
   HTMLWindow2.execScript(Format('codeAddress(%s)',[QuotedStr(address)]), 'JavaScript');
end;



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_FlyFilesUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function GetCaseSensitiveFileName( const FileName : string; RootPath : string) : string');
 CL.AddConstantN('OTGDeivceCount','LongInt').SetInt( 16);
 CL.AddConstantN('UsbDiskStartIndex','LongInt').SetInt( 255);
 CL.AddConstantN('DeleteDirectories_WaitMinSecond','LongInt').SetInt( 2000);
 CL.AddConstantN('HTMLStrGoogle','string').SetString(HTMLStrGoogle);

 CL.AddDelphiFunction('Function isPathCanUseNow( const PathOrDir : string; const Default : Boolean) : Boolean');
 CL.AddDelphiFunction('Function TestPathCanWrite( const PathOrDir : string) : Boolean');
 CL.AddDelphiFunction('Function GetSDCardPath( Index : Integer) : string');
 CL.AddDelphiFunction('Function FindSDCardSubPath( SubPath : string; Index : Integer) : string');
 CL.AddDelphiFunction('Function GetAppPath : string');
 CL.AddDelphiFunction('Function BuildFileListInAPath( const Path : string; const Attr : Integer; const List : TStrings; JustFile : Boolean) : Boolean;');
 CL.AddDelphiFunction('Function BuildFileListInAPath1( const Path : string; const Attr : Integer; JustFile : Boolean) : string;');
 CL.AddDelphiFunction('Function GetFileNamesFromDirectory( const DirName : string; const SearchFilter : string; const FileAttribs : Integer; const isIncludeSubDirName : Boolean; const Recursion : Boolean; const FullName : Boolean) : string');
 CL.AddDelphiFunction('Function DeleteDirectoryByEcho( const Source : string; AbortOnFailure : Boolean; YesToAll : Boolean; WaitMinSecond : Integer) : Boolean');
 CL.AddDelphiFunction('Function GetTotalSpaceSize( Path : string) : UInt64');
 CL.AddDelphiFunction('Function GetAvailableSpaceSize( Path : string) : UInt64');
 CL.AddDelphiFunction('Function GetFreeSpaceSize( Path : string) : UInt64');
 CL.AddDelphiFunction('Function GetTotalMemorySize : UInt64');
 CL.AddDelphiFunction('Function GetFreeMemorySize : UInt64');
 CL.AddDelphiFunction('Function IsPadOrPC : Boolean');
 CL.AddDelphiFunction('Function OpenFileOnExtApp( const FileName : string; Https : Boolean) : Boolean');
 CL.AddDelphiFunction('Function NowGMT_UTC : TDateTime');
 CL.AddDelphiFunction('Function EncodeURLWithSchemeOrProtocol( const URL : string) : string');
 CL.AddDelphiFunction('Function GetVolumePaths : string');
 CL.AddDelphiFunction('Function GetExternalStoragePath : string');
 CL.AddDelphiFunction('Function GetExterStoragePath : string');
 CL.AddDelphiFunction('Function GetInnerStoragePath : string');
 CL.AddDelphiFunction('Function GetIsExternalStorageRemovable : Boolean');
 CL.AddDelphiFunction('Function GetScreenClientInches : Single');
 CL.AddDelphiFunction('Function IsCanFindJavaClass( const NamePath : string) : Boolean');
 CL.AddDelphiFunction('Function IsCanFindJavaMethod( const MethodName, Signature : string; const CalssNamePath : string) : Boolean');
 CL.AddDelphiFunction('Function IsCanFindJavaStaticMethod( const MethodName, Signature : string; const CalssNamePath : string) : Boolean');
  CL.AddTypeS('TGetFileNameLIsternerMethod', 'Procedure ( const IsOK : Boolean; const FileName : string)');
 CL.AddDelphiFunction('Function OpenFileDialog( Title, FileExtension : string; GetFileNameCallBack : TGetFileNameLIsternerMethod) : Boolean');
 CL.AddDelphiFunction('Function CheckPermission( const APermissionName : string) : Boolean');
 CL.AddConstantN('C_android_permission_EXTERNAL_STORAGE','String').SetString( 'android.permission.WRITE_EXTERNAL_STORAGE');
 CL.AddDelphiFunction('Function CanWriteExterStorage : Boolean');
 CL.AddDelphiFunction('Procedure UpdateAlbum( FileNames : string)');
 CL.AddDelphiFunction('Function ReadNoSizeFileToString( const AFileName : string) : string');
 CL.AddDelphiFunction('Function ReadFileToString1( const AFileName : string) : string');
 CL.AddDelphiFunction('Function TaskbarHandle: THandle');
 CL.AddDelphiFunction('Function TrayHandle: THandle');
 CL.AddDelphiFunction('Procedure DOSWipeFile(fn: string);');
 CL.AddDelphiFunction('Procedure DOSFileWipe(fn: string);');
 CL.AddDelphiFunction('function ExecAndWait(sExe, sCommandLine: string): Boolean;');

 CL.AddDelphiFunction('procedure GoogleMapsFormCreate(Sender: TObject; aform: TForm; webbrowser1: TWebbrowser; HTMLStr, navdoc: string);');
 CL.AddDelphiFunction('procedure GoogleMapsGotoLocationClick(Sender: TObject; LatitudeText, LongitudeText: string );');
 CL.AddDelphiFunction('procedure GoogleMapsGotoAddressClick(Sender: TObject; vaddress: string);');



end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BuildFileListInAPath1_P( const Path : string; const Attr : Integer; JustFile : Boolean) : string;
Begin Result := FlyFilesUtils.BuildFileListInAPath(Path, Attr, JustFile); END;

(*----------------------------------------------------------------------------*)
Function BuildFileListInAPath_P( const Path : string; const Attr : Integer; const List : TStrings; JustFile : Boolean) : Boolean;
Begin Result := FlyFilesUtils.BuildFileListInAPath(Path, Attr, List, JustFile); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_FlyFilesUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetCaseSensitiveFileName, 'GetCaseSensitiveFileName', cdRegister);
 S.RegisterDelphiFunction(@isPathCanUseNow, 'isPathCanUseNow', cdRegister);
 S.RegisterDelphiFunction(@TestPathCanWrite, 'TestPathCanWrite', cdRegister);
 S.RegisterDelphiFunction(@GetSDCardPath, 'GetSDCardPath', cdRegister);
 S.RegisterDelphiFunction(@FindSDCardSubPath, 'FindSDCardSubPath', cdRegister);
 S.RegisterDelphiFunction(@GetAppPath, 'GetAppPath', cdRegister);
 S.RegisterDelphiFunction(@BuildFileListInAPath, 'BuildFileListInAPath', cdRegister);
 //S.RegisterDelphiFunction(@BuildFileListInAPath1, 'BuildFileListInAPath1', cdRegister);
 S.RegisterDelphiFunction(@GetFileNamesFromDirectory, 'GetFileNamesFromDirectory', cdRegister);
 S.RegisterDelphiFunction(@DeleteDirectoryByEcho, 'DeleteDirectoryByEcho', cdRegister);
 S.RegisterDelphiFunction(@GetTotalSpaceSize, 'GetTotalSpaceSize', cdRegister);
 S.RegisterDelphiFunction(@GetAvailableSpaceSize, 'GetAvailableSpaceSize', cdRegister);
 S.RegisterDelphiFunction(@GetFreeSpaceSize, 'GetFreeSpaceSize', cdRegister);
 S.RegisterDelphiFunction(@GetTotalMemorySize, 'GetTotalMemorySize', cdRegister);
 S.RegisterDelphiFunction(@GetFreeMemorySize, 'GetFreeMemorySize', cdRegister);
 S.RegisterDelphiFunction(@IsPadOrPC, 'IsPadOrPC', cdRegister);
 S.RegisterDelphiFunction(@OpenFileOnExtApp, 'OpenFileOnExtApp', cdRegister);
 S.RegisterDelphiFunction(@NowGMT_UTC, 'NowGMT_UTC', cdRegister);
 S.RegisterDelphiFunction(@EncodeURLWithSchemeOrProtocol, 'EncodeURLWithSchemeOrProtocol', cdRegister);
 //S.RegisterDelphiFunction(@GetVolumePaths, 'GetVolumePaths', cdRegister);
 //S.RegisterDelphiFunction(@GetExternalStoragePath, 'GetExternalStoragePath', cdRegister);
 //S.RegisterDelphiFunction(@GetExterStoragePath, 'GetExterStoragePath', cdRegister);
 //S.RegisterDelphiFunction(@GetInnerStoragePath, 'GetInnerStoragePath', cdRegister);
 //S.RegisterDelphiFunction(@GetIsExternalStorageRemovable, 'GetIsExternalStorageRemovable', cdRegister);
 //S.RegisterDelphiFunction(@GetScreenClientInches, 'GetScreenClientInches', cdRegister);
 //S.RegisterDelphiFunction(@IsCanFindJavaClass, 'IsCanFindJavaClass', cdRegister);
 //S.RegisterDelphiFunction(@IsCanFindJavaMethod, 'IsCanFindJavaMethod', cdRegister);
 //S//.RegisterDelphiFunction(@IsCanFindJavaStaticMethod, 'IsCanFindJavaStaticMethod', cdRegister);
 //S.RegisterDelphiFunction(@OpenFileDialog, 'OpenFileDialog', cdRegister);
 //S.RegisterDelphiFunction(@CheckPermission, 'CheckPermission', cdRegister);
 //S.RegisterDelphiFunction(@CanWriteExterStorage, 'CanWriteExterStorage', cdRegister);
 //S.RegisterDelphiFunction(@UpdateAlbum, 'UpdateAlbum', cdRegister);
 //S.RegisterDelphiFunction(@ReadNoSizeFileToString, 'ReadNoSizeFileToString', cdRegister);
 //S.RegisterDelphiFunction(@ReadFileToString, 'ReadFileToString1', cdRegister);

 S.RegisterDelphiFunction(@TaskbarHandle, 'TaskbarHandle', cdRegister);
 S.RegisterDelphiFunction(@TrayHandle, 'TrayHandle', cdRegister);
 S.RegisterDelphiFunction(@DOSWipeFile, 'DOSWipeFile', cdRegister);
 S.RegisterDelphiFunction(@DOSWipeFile, 'DOSFileWipe', cdRegister);
 S.RegisterDelphiFunction(@ExecAndWait, 'ExecAndWait', cdRegister);
 S.RegisterDelphiFunction(@GoogleMapsFormCreate, 'GoogleMapsFormCreate', cdRegister);
 S.RegisterDelphiFunction(@GoogleMapsGotoLocationClick, 'GoogleMapsGotoLocationClick', cdRegister);
 S.RegisterDelphiFunction(@GoogleMapsGotoAddressClick, 'GoogleMapsGotoAddressClick', cdRegister);


 // CL.AddDelphiFunction('procedure GoogleMapsFormCreate(Sender: TObject; aform: TForm; webbrowser1: TWebbrowser; HTMLStr: string);');
 //CL.AddDelphiFunction('procedure GoogleMapsGotoLocationClick(Sender: TObject; LatitudeText, LongitudeText: string );');
 //CL.AddDelphiFunction('procedure GoogleMapsGotoAddressClick(Sender: TObject; vaddress: string);');


 //CL.AddDelphiFunction('Procedure DOSWipeFile(fn: string);');
 //CL.AddDelphiFunction('Procedure DOSFileWipe(fn: string);');

 //CL.AddDelphiFunction('TaskbarHandle: THandle');
 //CL.AddDelphiFunction('TrayHandle: THandle');

end;

 
 
{ TPSImport_FlyFilesUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_FlyFilesUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_FlyFilesUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_FlyFilesUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_FlyFilesUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
