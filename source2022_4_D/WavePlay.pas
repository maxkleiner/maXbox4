{------------------------------------------------------------------------------}
{                                                                              }
{  TWavePlayer v1.02                                                           }
{  by Kambiz R. Khojasteh                                                      }
{                                                                              }
{  kambiz@delphiarea.com                                                       }
{  http://www.delphiarea.com                                                   }
{                                                                              }
{------------------------------------------------------------------------------}

unit WavePlay;

interface

uses
  Windows, Messages, Classes;

const
  DefaultResType = 'WAVE';

type

  TWave = TMemoryStream;

  TWavePlayer = class(TComponent)
  private
    FSound: TWave;
    FActive: Boolean;
    FLoop: Boolean;
    FStopOthers: Boolean;
    FWaitToStop: Boolean;
    procedure SetActive(Value: Boolean);
    function GetEmpty: Boolean;
    procedure ReadData(Stream: TStream);
    procedure WriteData(Stream: TStream);
  protected
    procedure DefineProperties(Filer: TFiler); override;
  public
    ResType: PChar;
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    procedure Play;
    procedure Stop;
    procedure LoadFromResourceName(Instance: THandle; const ResName: String);
    procedure LoadFromResourceID(Instance: THandle; const ResID: Integer);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromFile(const FileName: String);
    procedure SaveToFile(const FileName: String);
    property Empty: Boolean read GetEmpty;
  published
    property Active: Boolean read FActive write SetActive default False;
    property StopOthers: Boolean read FStopOthers write FStopOthers default False;
    property WaitToStop: Boolean read FWaitToStop write FWaitToStop default False;
    property Loop: Boolean read FLoop write FLoop default False;
    property Sound: TWave read FSound write FSound;
  end;

implementation

uses
  MMSystem;

constructor TWavePlayer.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  ResType := DefaultResType;
  Sound := TMemoryStream.Create;
  FStopOthers := False;
  FWaitToStop := False;
  FLoop := False;
  FActive := False;
end;

destructor TWavePlayer.Destroy;
begin
  Stop;
  Sound.Free;
  inherited Destroy;
end;

procedure TWavePlayer.Clear;
begin
  if Sound.Size > 0 then
  begin
    Stop;
    Sound.Clear;
  end;
end;

procedure TWavePlayer.LoadFromResourceName(Instance: THandle;
  const ResName: String);
var
  Stream: TResourceStream;
begin
  Clear;
  Stream := TResourceStream.Create(Instance, PChar(ResName), ResType);
  try
    Sound.CopyFrom(Stream, Stream.Size);
  finally
    Stream.Free;
  end;
end;

procedure TWavePlayer.LoadFromResourceID(Instance: THandle;
  const ResID: Integer);
var
  Stream: TResourceStream;
begin
  Clear;
  Stream := TResourceStream.CreateFromID(Instance, ResID, ResType);
  try
    Sound.CopyFrom(Stream, Stream.Size);
  finally
    Stream.Free;
  end;
end;

procedure TWavePlayer.LoadFromStream(Stream: TStream);
begin
  Clear;
  Sound.CopyFrom(Stream, 0);
end;

procedure TWavePlayer.SaveToStream(Stream: TStream);
begin
  Stream.CopyFrom(Sound, 0);
end;

procedure TWavePlayer.LoadFromFile(const FileName: String);
begin
  Clear;
  Sound.LoadFromFile(FileName);
end;

procedure TWavePlayer.SaveToFile(const FileName: String);
begin
  Sound.SaveToFile(FileName);
end;

procedure TWavePlayer.Play;
var
  Flags: Word;
begin
  if Sound.Size > 0 then
  begin
    Flags := SND_MEMORY or SND_NODEFAULT;
    if Loop then
      Flags := Flags or SND_LOOP;
    if WaitToStop then
      Flags := Flags or SND_SYNC
    else
      Flags := Flags or SND_ASYNC;
    if not StopOthers then
      Flags := Flags or SND_NOSTOP;
    FActive := sndPlaySound(Sound.Memory, Flags);
  end;
end;

procedure TWavePlayer.Stop;
begin
  FActive := False;
  sndPlaySound(nil, SND_MEMORY);
end;

procedure TWavePlayer.SetActive(Value: Boolean);
begin
  if Value then
    Play
  else
    Stop;
end;

function TWavePlayer.GetEmpty: Boolean;
begin
  Result := (Sound.Size = 0);
end;

procedure TWavePlayer.ReadData(Stream: TStream);
begin
  Sound.LoadFromStream(Stream);
end;

procedure TWavePlayer.WriteData(Stream: TStream);
begin
  Sound.SaveToStream(Stream);
end;

procedure TWavePlayer.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('Data', ReadData, WriteData, Sound.Size > 0);
end;

end.
