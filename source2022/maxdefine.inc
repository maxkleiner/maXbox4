//*********************************************************
//Testframe , Snippets Prototypes, Pattern and Definition File for Functions or Units
//program testunit for include functions;
//TPas is defined outside! in example 36_pas_includetest.txt

{Stack := #0#0#0#0 + Stack;
          Pointer((@Stack[1])^) := VarPtr;}

const
  defWSDL = 'D:\Program Files\Apache Group\Apache2\cgi-bin\IVCLScanner.xml';
  defURL  = 'http://apsn21/cgi-bin/VCLScannerServer.exe/soap/IVCLScanner';
  defSvc  = 'IVCLScannerservice';
  defPrt  = 'IVCLScannerPort';


Function BoolToStr2(B: Boolean): string;
var
  cTrueFalseStr: array [0..1] of String;
begin
  cTrueFalseStr[0]:= 'False';
  cTrueFalseStr[1]:= 'True';
 if B then
    Result:= cTrueFalseStr[1]
  else
    Result:= cTrueFalseStr[0];
end;

FUNCTION HASH2 (X: string): INTEGER;
  //VAR I : 1..5;
  //N not defined
VAR I: byte;
    H: INTEGER;
BEGIN
   {TPas:=[a,c];
     if c in TPas then
       showmessage(' this is out from inside include ;)')}
  H:= 0;
  FOR I:= 1 TO 5 DO
      H:= (H * 10 + ORD(X[I]));
  result:= H MOD 20;
END;

PROCEDURE showAboutBox;
begin
  showMessage('for more information on maXbox please visit'+#13+#10
               +'http://www.softwareschule.ch/maxbox.htm'+#13+#10)
end;  

{procedure FreeAndNilData(var P);
var
  Ptr : Pointer;
begin
  if Assigned(Pointer(P)) then
  begin
    Ptr:=Pointer(P);
    Pointer(P):=nil;
    FreeMem(Ptr);
  end;
end;} 


function SafeStr2(const s: string): string;
var
 i : Longint;
begin
  Result:= s;
  for i:= 1 to length(s) do begin
    //if s[i] in [#0..#31] then begin
    if ord(s[i]) < 31 then begin
      Result := Copy(s, 1, i-1);
      exit;
    end;
  end;
end;

{procedure Set_Union(Dest, Src: PByteArray; ByteSize: Integer);
var
  i: Longint;
begin
  for i := ByteSize -1 downto 0 do
    Dest^[i] := Dest^[i] or Src^[i];
end;

procedure Set_Diff(Dest, Src: PByteArray; ByteSize: Integer);
var
  i: Longint;
begin
  for i := ByteSize -1 downto 0 do
    Dest^[i] := Dest^[i] and not Src^[i];
end;

procedure Set_Intersect(Dest, Src: PByteArray; ByteSize: Integer);
var
  i: Longint;
begin
  for i := ByteSize -1 downto 0 do
    Dest^[i] := Dest^[i] and Src^[i];
end;}  


{procedure GetResourceHeader(var ResourceHeader: String; const FormName: String; const FileSize: Integer);
var RT_RCDATA: char;
begin
  RT_RCDATA:= 'R';
  ResourceHeader := #$FF + Char(RT_RCDATA) + #$00 + FormName +
                    #$00 + #$30 + #$10 + Char(Low(Low(FileSize))) +
                    Char(High(Low(FileSize))) +
                    Char(Low(High(FileSize))) +
                    Char(High(High(FileSize)));
end;}

{function TfrmMain.OpenResource(const FileName : String) : Boolean;
begin
  Result := False;
  try
    hProcess := LoadLibraryEx(PChar(FileName),0,LOAD_LIBRARY_AS_DATAFILE);
    if GetLastError = ERROR_BAD_FORMAT then
      raise Exception.Create('Error loading executable module. Bad format.');
    if hProcess <> 0 then
      Result := GetResourceNames > 0;
  except
  end;
end;}


function GetIVCLScanner(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): IVCLScanner;
{const
  defWSDL = 'D:\Program Files\Apache Group\Apache2\cgi-bin\IVCLScanner.xml';
  defURL  = 'http://apsn21/cgi-bin/VCLScannerServer.exe/soap/IVCLScanner';
  defSvc  = 'IVCLScannerservice';
  defPrt  = 'IVCLScannerPort';}
var
  RIO: THTTPRIO;
begin
  Result:= NIL;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr:= defWSDL
    else
      Addr:= defURL;
  end;
  if HTTPRIO = NIL then
    RIO:= THTTPRIO.Create(NIL)
  else
    RIO:= HTTPRIO;
  try
    Result:= (RIO as IVCLScanner);
    if UseWSDL then
    begin
      RIO.WSDLLocation:= Addr;
      RIO.Service := defSvc;
      RIO.Port:= defPrt;
    end else
      RIO.URL:= Addr;
  finally
    if (Result = NIL) and (HTTPRIO = NIL) then
      RIO.Free;
  end;
end;

function TVCLScannerPostData(const UserData: WideString; const CheckSum: DWORD): Boolean;
var
  SL: TStringList;
  FileName: String;
begin
  {with TWebModule1.Create(NIL) do begin
    getFile_DatabasePath;
    FileName:= filePath+FormatDateTime('yyyymmdd-hhnnsszzz',Now)+'.txt';
    Free
  end;}
  SL:= TStringList.Create;
  SL.Text:= UserData;
  SL.SaveToFile(FileName);
  SL.Free;
  Result:= True;
end;

function ExcludeDir(Dir : String) : Boolean;
var
  i : Integer;
  excludes: TStringlist;
  programfilesdir: string;
begin
  Result := False;
  Dir := UpperCase(Dir);
  for i:= 0 to Excludes.Count-1 do
    if Pos(UpperCase(Excludes[i]),Dir) > 0 then begin
      Result := True;
      Exit;
    end;
  // Try to exclude even unknown Delphi/BCB and beta installations
  if ((Pos(ProgramFilesDir+'\BORLAND\DELPHI',Dir) <> 0) or
      (Pos(ProgramFilesDir+'\BORLAND\POLARIS',Dir) <> 0) or // Delphi 2 beta
      (Pos(ProgramFilesDir+'\BORLAND\IVORY',Dir) <> 0) or // Delphi 3 beta
      (Pos(ProgramFilesDir+'\BORLAND\ALLEGRO',Dir) <> 0) or // Delphi 4 beta
      (Pos(ProgramFilesDir+'\BORLAND\ARGUS',Dir) <> 0) or // Delphi 5 beta
      (Pos(ProgramFilesDir+'\BORLAND\ILIAD',Dir) <> 0)) and // Delphi 6 beta
     ((Pos('BIN',Dir) <> 0) or (Pos('DEMOS',Dir) <> 0) or
      (Pos('HELP',Dir) <> 0) or (Pos('IMPORTS',Dir) <> 0) or
      (Pos('LIB',Dir) <> 0) or (Pos('SOURCE',Dir) <> 0)) then
    Result := True;
  if ((Pos(ProgramFilesDir+'\BORLAND\CBUILDER',Dir) <> 0) or
      (Pos(ProgramFilesDir+'\BORLAND\EBONY',Dir) <> 0) or // BCB 1 beta
      (Pos(ProgramFilesDir+'\BORLAND\PRESTO',Dir) <> 0) or // BCB 3 beta
      (Pos(ProgramFilesDir+'\BORLAND\THUNDER',Dir) <> 0) or // BCB 4 beta
      (Pos(ProgramFilesDir+'\BORLAND\RAMPAGE',Dir) <> 0)) and // BCB 5 beta
     ((Pos('BIN',Dir) <> 0) or (Pos('EXAMPLES',Dir) <> 0) or
      (Pos('HELP',Dir) <> 0) or (Pos('IMPORTS',Dir) <> 0) or
      (Pos('LIB',Dir) <> 0) or (Pos('SOURCE',Dir) <> 0)) then
    Result := True;
  // Exclude Delphi 1
  if (Pos('DELPHI\BIN',Dir) <> 0) or (Pos('DELPHI\DEMOS',Dir) <> 0) or
     (Pos('DELPHI\HELP',Dir) <> 0) or (Pos('DELPHI\LIB',Dir) <> 0) or
     (Pos('DELPHI\SOURCE',Dir) <> 0) then
    Result := True;
  // Exclude other Win/System
  if (Pos('WINDOWS\SYSTEM',Dir) <> 0) or (Pos('WINNT\SYSTEM',Dir) <> 0) then
    Result := True;
  // Exclude all Recycle Bins
  if (Pos('\RECYCLED',Dir) <> 0) then
    Result := True;
end;

function GetResourceFormFile(List: TStrings; const FormName, FileName: String) : Boolean;
var
  InStream,
  OutStream      : TMemoryStream;
  ResourceSize   : Integer;
  ResourceHeader : String;
  Buffer         : PChar;
  hprocess: HWND;
begin
  Result := True;
  if hProcess <> 0 then begin
    InStream := TMemoryStream.Create;
    OutStream := TMemoryStream.Create;
    try
      //Buffer := LockResource(LoadResource(hProcess,FindResource(hProcess,PChar(FormName),RT_RCDATA)));
      if Pos('TPF0', Buffer) <> 0 then begin
        //ResourceSize := SizeOfResource(hProcess,FindResource(hProcess,PChar(FormName),RT_RCDATA));
        //GetResourceHeader(ResourceHeader,FormName,ResourceSize);
        InStream.Size := ResourceSize;
        OutStream.Size := 2*ResourceSize; // Rough estimate
        InStream.Write(ResourceHeader[1],Length(ResourceHeader));
        //InStream.Write(Buffer^,ResourceSize);
        InStream.Seek(0,soFromBeginning);
{
        Worker := TWorker.Create(InStream,OutStream);
        while not Worker.Done do
          Application.ProcessMessages;
        Result := not Worker.SRError;
        Worker.Free;
}

        try
          //ObjectResourceToText(InStream,OutStream);
        except
          {on E: Exception do begin
            ShowMessage('Exception ('+E.ClassName+') caught while processing a resource ('+
                        FormName+') in '+UpperCase(FileName)+'. Scanning will continue, but the end result '+
                        'may be slightly off due to the black box nature of this resource.');
            Result := False;
          end; }
{      on E: EConvertError do begin
            Result := False;
          end;
          on E: EOutOfMemory do begin
            Result := False;
          end; }
        end;

        OutStream.Seek(0,soFromBeginning);
        List.BeginUpdate;
        List.LoadFromStream(OutStream);
        List.EndUpdate;
      end;
    finally
      InStream.Free;
      OutStream.Free;
    end;
  end;
end;


          

//begin
//end.

//------------------------------------------
//In Delphi, False and True are an enumeration of a boolean set.  As such, they have //implied numeric values that are indexes into their positions in the [False, True] set.

