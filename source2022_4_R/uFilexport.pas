{-Modulename and path: uFilexport
//
//D:\franktech\UMLbook\UMLbook2\designPattern\dpatterns\patterns7.mpb
//Category    Entity
//
//Developer kleiner kommunikation, LoC=250
//Last Modification on 05.06.03 21:15:44:
//Last Modification on 12.12.2013 convert to maXbox  21:15:44:
//patterns: wrapper, mediator
  mediator simulates an SMS engine, in real with late bound webservice
  ('http://sal006.salNetwork.com:83/lucin/SMSmessaging/process.xml');
  Ex. wrapper:
      q:= TTxtFile.Create(sd1.FileName);
      q.ReWrite;
      q.Write(intToStr(i));
      q.Close; q.Free;
//==========================================================================}
unit uFilexport;
{$D-,L-,Y-}
{TTxtFile - object-oriented wrapper
 for standard Pascal/Delphi TextFile type. }
(*
 RRRRR    EEEEEE   AAAA   DDDDD    MM     MM   EEEEEE 
 RR  RR   EE       AA AA  DD  DD   MMMM MMMM   EE    
 RRRRR    EEEE    AAAAAA  DD   DD  MM MMM MM   EEEE
 RR  RR   EE      AA   AA DD   DD  MM  M  MM   EE
 RR   RR  EEEEEE AA    AA DDDDD    MM  M  MM   EEEEEE
*)
 
interface

uses
  sysutils, classes;

 type
  TFileMode = fmClosed..fmOutput;
  TFileExt = string[3]; 
//Pattern: mediator
  TTrigger = array of boolean;
  TTriggerEvent = procedure (Sender: TObject; Trigger: TTrigger) of object;

  TTxtFile = class (TObject)
  private
    strlit18: string;
    FDefaultExt: TFileExt;
    FTextFile: TextFile;
    function GetActive: Boolean;
    function GetEof: Boolean;
    function GetEoln: Boolean;
    function GetMode: TFileMode;
    function GetName: string;
    function GetSeekEoln: Boolean;
    procedure SetActive(state: Boolean);
    procedure SetMode(const NewMode: TFileMode);
  public
    constructor Create(Name : TFileName);
    destructor Destroy; override;
    procedure Append;
    procedure Assign(FName: string);
    procedure Close; virtual;
    procedure Flush;
    //function loadfromStreamFile(const aFileName: string; memStream:
    //                                  TMemoryStream ): Boolean;
    procedure ReadLn(var S : string);
    procedure ReSet; virtual;
    procedure ReWrite; virtual;
    procedure SetTextBuf(var Buf; Size : Word);
    procedure Write(const S : string);
    procedure WriteLn(const S : String);
    property Active: Boolean read GetActive write SetActive;
    property DefaultExt: TFileExt read FDefaultExt write FDefaultExt;
    property Eof: Boolean read GetEof;
    property Eoln: Boolean read GetEoln;
    property FileName: string read GetName write Assign;
    property SeekEoln: Boolean read GetSeekEoln;
    property state: TFileMode read GetMode write SetMode;
  end;
  
  
implementation

uses dialogs;

{
*********************************** TTxtFile ***********************************
}
constructor TTxtFile.Create(Name : TFileName);
begin
  inherited Create;
  TTextRec(FTextFile).mode := fmClosed;
  FDefaultExt := 'txt';
  if Length(Name) > 0 then
     Assign(Name);

  strLit18:='No open file allowed';

end;

destructor TTxtFile.Destroy;
begin
  {if the user forgot to close the file
  (*but did not forget to destroy it - good kleiner boy*)
   then close it for him/her}
  if state <> fmClosed then
     Close;
  inherited Destroy
end;

procedure TTxtFile.Append;
begin
  System.Append(FTextFile);
end;

procedure TTxtFile.Assign(FName: string);
begin
  if state <> fmClosed then
     raise EInOutError.Create(
        'Cannot perform this operation on open text file');
  if (Length(ExtractFileExt(FName)) = 0) and
     {maybe the user doesn't want an extension}
     (FName[Length(FName)] <> '.') then
     //AppendStr(FName, '.'+ DefaultExt);
     FName:= FName + '.'+DefaultExt;
  AssignFile(FTextFile, FName)
end;

procedure TTxtFile.Close;
begin
  state:= fmClosed
end;

procedure TTxtFile.Flush;
begin
  System.Flush(FTextFile)
end;

function TTxtFile.GetActive: Boolean;
begin
  Result:= (state <> fmClosed)
end;

function TTxtFile.GetEof: Boolean;
begin
  Result:= System.Eof(FTextFile)
end;

function TTxtFile.GetEoln: Boolean;
begin
  Result:= System.Eoln(FTextFile)
end;

function TTxtFile.GetMode: TFileMode;
begin
  Result:= TTextRec(FTextFile).mode // mode aus sysutils
end;

function TTxtFile.GetName: string;
begin
  Result:= StrPas(TTextRec(FTextFile).Name)  //!
end;

function TTxtFile.GetSeekEoln: Boolean;
begin
  Result:= System.SeekEoln(FTextFile)
end;

{function TTxtFile.loadfromStreamFile(const aFileName: string; memStream:
        TMemoryStream ): Boolean;
var
  aStream: TFileStream;
  iSize: Integer;
begin
  result:= false;
  if not FileExists(aFileName) then exit;
  aStream:= TfileStream.create(aFileName, fmopenRead or fmshareDenyWrite);
  try
    aStream.seek(sizeof(integer), soFromBeginning);
    aStream.read(iSize, sizeOf(iSize));
    if iSize > aStream.size then begin
      aStream.free;
      exit;
    end;
    aStream.seek(iSize, soFromBeginning);
    memStream.setSize(iSize - sizeof(integer));
    memStream.copyFrom(aStream, iSize - sizeof(iSize));
    memStream.seek(0, soFromBeginning);
  finally
    aStream.free;
  end;
  result:= true;
end;}

procedure TTxtFile.ReadLn(var S : string);
begin
  system.Read(FTextFile, S);
  if system.Eoln(FTextFile) then system.ReadLn(FTextFile);
end;

procedure TTxtFile.ReSet;
begin
  state:= fmInput
end;

procedure TTxtFile.ReWrite;
begin
  state:= fmOutPut
end;

procedure TTxtFile.SetActive(state: Boolean);
begin
  if State then
     if FileExists(FileName) then ReSet
     else ReWrite
  else Close
end;

procedure TTxtFile.SetMode(const NewMode: TFileMode);
var
  CurMod: Word;
begin
  CurMod:= state;
  if NewMode <> CurMod then begin
     if (NewMode = fmClosed) then begin
        if CurMod = fmOutPut then Self.Flush;
        System.CloseFile(FTextFile)
     end
     else if CurMod > fmClosed{file is currently open} then
        raise EInOutError.Create(strLit18)
     else case NewMode of
        fmInput  : System.ReSet(FTextFile);
        fmOutput : System.ReWrite(FTextFile);
     end;{case}
  end{if}
end;

procedure TTxtFile.SetTextBuf(var Buf; Size : Word);
begin
  System.SetTextBuf(FTextFile, Buf, Size)
end;

procedure TTxtFile.Write(const S : string);
begin
  System.Write(FTextFile, S)
end;

procedure TTxtFile.WriteLn(const S : String);
begin
  system.WriteLn(FTextFile, S)
end;

{
*********************************** TSMSPort ***********************************
}

end.
