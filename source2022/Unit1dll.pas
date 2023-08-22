unit Unit1dll;
// for mX4
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ImageHlp;

type
  TDLLForm1 = class(TForm)
    SpeedButton1: TSpeedButton;
    Edit1: TEdit;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    ListBox1: TListBox;
    Label2: TLabel;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
  public
  end;

  procedure ListDLLExports(const FileName: string; List: TStrings);


var DLLForm1: TDLLForm1;

implementation

{$R *.dfm}

{
procedure ListDLLExports(const FileName: string; List: TStrings);
type TDWordArray = array [0..$FFFFF] of DWORD;
var
  imageinfo: LoadedImage;
  pExportDirectory: PImageExportDirectory;
  dirsize: Cardinal;
  pDummy: PImageSectionHeader;
  i: Cardinal;
  pNameRVAs: ^TDWordArray;
  Name: string;
begin
  List.Clear;
  if MapAndLoad(PChar(FileName), nil, @imageinfo, True, True) then
  try
     pExportDirectory := ImageDirectoryEntryToData(imageinfo.MappedAddress, False, IMAGE_DIRECTORY_ENTRY_EXPORT, dirsize);
     if (pExportDirectory <> nil) then begin
         pNameRVAs := ImageRvaToVa(imageinfo.FileHeader, imageinfo.MappedAddress, DWORD(pExportDirectory^.AddressOfNames), pDummy);
         for i := 0 to pExportDirectory^.NumberOfNames - 1 do begin
             Name := PChar(ImageRvaToVa(imageinfo.FileHeader, imageinfo.MappedAddress, pNameRVAs^[i], pDummy));
             List.Add(Name);
         end;
     end;
  finally
     UnMapAndLoad(@imageinfo);
  end;
end;
}

procedure ListDLLExports(const FileName: string; List: TStrings);
type
_IMAGE_EXPORT_DIRECTORY = packed record
  Characteristics: DWord;
  TimeDateStamp: DWord;
  MajorVersion: Word;
  MinorVersion: Word;
  Name: DWord;
  Base: DWord;
  NumberOfFunctions: DWord;
  NumberOfNames: DWord;
  AddressOfFunctions: ^PDWORD;
  AddressOfNames: ^PDWORD;
  AddressOfNameOrdinals: ^PWord;
end;
PImageExportDirectory = ^_IMAGE_EXPORT_DIRECTORY;

TDWordArray = array [0..$FFFFF] of DWORD;
PTDWordArray = ^TDWordArray;

var imageinfo: LoadedImage;
    pExportDirectory: PImageExportDirectory;
    dirsize: Cardinal;
    i: Cardinal;
    pDummy: PImageSectionHeader;
    pNameRVAs: pTDWordArray;
    Name: string;
begin
  List.Clear;
  if MapAndLoad(PChar(FileName), nil, @imageinfo, True, True) then
  try
    pExportDirectory := PImageExportDirectory( ImageDirectoryEntryToData( imageinfo.MappedAddress, False, IMAGE_DIRECTORY_ENTRY_EXPORT, dirsize));
    if (pExportDirectory <> nil) then begin
       pDummy := NIL;
       pNameRVAs := ImageRvaToVa(imageinfo.FileHeader, imageinfo.MappedAddress, DWORD(pExportDirectory^.AddressOfNames), pDummy);
       for i := 0 to pExportDirectory^.NumberOfNames - 1 do begin
           Name := PChar(ImageRvaToVa(imageinfo.FileHeader, imageinfo.MappedAddress, pNameRVAs^[i], pDummy));
           List.Add(Name);
       end;
    end;
  finally
     UnMapAndLoad(@imageinfo);
  end;
end;

procedure TDLLForm1.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
     Edit1.Text:=OpenDialog1.Filename;
     ListDLLExports(Edit1.Text, ListBox1.Items);
  end;
end;

procedure TDLLForm1.SpeedButton2Click(Sender: TObject);
type TFunction = function(aFileName:string) : integer; stdcall;
//zlib
var LibHandle:THandle;
    DLLFileName:PAnsiChar;
    fProcedure:procedure;
    fFunction:TFunction;
begin
 //ListBox1.Items[1];
 ListBox1.selected[1]:= true;
  DLLFileName:=PAnsiChar(Edit1.Text);
  LibHandle:=LoadLibrary(DLLFileName);
  if LibHandle=0 then raise Exception.Create('Could not load DLL');

  try
     @fFunction:=GetProcAddress(LibHandle,PChar(ListBox1.Items[ListBox1.ItemIndex]));
      if @fFunction<>NIL then
        ListBox1.Items.Add('DLL Function test loaded and unload at: '+
              format('%p ',[@fFunction]));
        //Showmessage
     //     if @fFunction<>nil then fFunction;
  finally
     FreeLibrary(LibHandle);
  end;
end;

(*
procedure CompressFiles(Files : TStrings; const Filename : String);
var
  infile, outfile, tmpFile : TFileStream;
  compr : TCompressionStream;
  i,l : Integer;
  s : String;

begin
  if Files.Count > 0 then
  begin
    outFile := TFileStream.Create(Filename,fmCreate);
    try
      { the number of files }
      l := Files.Count;
      outfile.Write(l,SizeOf(l));
      for i := 0 to Files.Count-1 do
      begin
        infile := TFileStream.Create(Files[i],fmOpenRead);
        try
          { the original filename }
          s := ExtractFilename(Files[i]);
          l := Length(s);
          outfile.Write(l,SizeOf(l));
          outfile.Write(s[1],l);
          { the original filesize }
          l := infile.Size;
          outfile.Write(l,SizeOf(l));
          { compress and store the file temporary}
          tmpFile := TFileStream.Create('tmp',fmCreate);
          compr := TCompressionStream.Create(clMax,tmpfile);
          try
            compr.CopyFrom(infile,l);
          finally
            compr.Free;
            tmpFile.Free;
          end;
          { append the compressed file to the destination file }
          tmpFile := TFileStream.Create('tmp',fmOpenRead);
          try
            outfile.CopyFrom(tmpFile,0);
          finally
            tmpFile.Free;
          end;
        finally
          infile.Free;
        end;
      end;
    finally
      outfile.Free;
    end;
    DeleteFile('tmp');
  end;
end;
*)

{procedure DecompressFiles(const Filename, DestDirectory : String);
var                // ZLib
  dest,s : String;
  decompr : TDecompressionStream;
  infile, outfile : TMemoryStream;
  i,c : Integer; // 4 Bytes
//  l:Int64;
  Buffer, BufferOut:Pointer;
  l,dummy:integer;
begin
  // IncludeTrailingPathDelimiter (D6/D7 only)
  dest := IncludeTrailingPathDelimiter(DestDirectory);

  try
    infile := TMemoryStream.Create;//(Filename,fmOpenRead);
    inFile.LoadFromFile(Filename);
    infile.Position:=0;
    l:=infile.Size;
    buffer:=nil;
    BufferOut:=nil;
    GetMem(buffer,l);
    infile.Read(buffer^,l);
    DecompressBuf(buffer,l,0,BufferOut,dummy);

    outfile := TMemoryStream.Create;//(DestDirectory,fmCreate);
    outfile.Write(BufferOut^,dummy);
    OutFile.SaveToFile(DestDirectory);
  finally
    infile.Free;
    outfile.Free;
    if buffer<>nil then FreeMem(buffer);
    if BufferOut<>nil then FreeMem(bufferOut);
  end; }

(*
  try
//    infile.Read(c,SizeOf(c)); // number of files
//    ShowMessage(intToStr(c));

//    c:=1;
//    for i := 1 to c do begin
        // read filename
        infile.Read(l,SizeOf(l));
        SetLength(s,l);
        infile.Read(s[1],l);

        // read filesize
        infile.Read(l,SizeOf(l));

        // decompress the files and store it
        s := dest + s; //include the path
        outfile := TFileStream.Create(s,fmCreate);
        decompr := TDecompressionStream.Create(infile);

        try
          outfile.CopyFrom(decompr,l);
        finally
          outfile.Free;
          decompr.Free;
        end;
//    end;
  finally
    infile.Free;
  end;
*)
//end;


end.
