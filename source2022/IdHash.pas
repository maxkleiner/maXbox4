{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10177: IdHash.pas 
{
{   Rev 1.0    2002.11.12 10:40:00 PM  czhower
        1.1    2010 max, pass abstract error
        1.2    2011 max, SHA1 (idhash160) implement from indy 10
        1.3    2011 max. small changes of abstract for maXbox
        1.4.   2013 max, add hash160 in uPSI Register
}
unit IdHash;

interface

uses
  Classes;

type
  TIdHash = class(TObject);

  TIdStream = TStream;

  TIdHash16 = class(TIdHash)
  public
    function HashValue(const ASrc: string): Word; overload;
    function HashValue(AStream: TStream): Word; overload; virtual; abstract;
  end;

  TIdHash32 = class(TIdHash)
  public
    function HashValue(const ASrc: string): LongWord; overload;
    function HashValue(AStream: TStream): LongWord; overload; virtual; abstract;
  end;

(*$HPPEMIT 'namespace Idhash {' *)
(*$HPPEMIT '  typedef System::StaticArray<LongWord, 4> T4x4LongWordRecord;'*)
(*$HPPEMIT '}' *)
{$NODEFINE T4x4LongWordRecord}  

  T4x4LongWordRecord = array [0..3] of LongWord;
  T5x4LongWordRecord = array [0..4] of LongWord;


  TIdHash160 = class(TIdHash)
  public
    class function AsHex(const AValue: T5x4LongWordRecord): string;
    function HashValue(const ASrc: string): T5x4LongWordRecord; overload;
    function HashValue(AStream: TStream): T5x4LongWordRecord; overload; virtual; abstract;
  end;


  TIdHash128 = class(TIdHash)
  public
    class function AsHex(const AValue: T4x4LongWordRecord): string;
    function HashValue(const ASrc: string): T4x4LongWordRecord; overload;
    function HashValue(AStream: TStream): T4x4LongWordRecord; overload; virtual; abstract;
  end;

implementation

uses
  IdGlobal_max,
  //idProtocols,
  SysUtils;  //IdHashMessageDigest

{ TIdHash32 }


//function ToHex(const AValue: TIdBytes): AnsiString; overload;
//function ToHex(const AValue: array of LongWord): AnsiString; overload; // for IdHash
function ToHex(const AValue: array of LongWord): AnsiString;
var
  P: PChar;
  i: Integer;
begin
  P:=PChar(@AValue);
  SetString(Result,NIL,Length(AValue)*4*2);//40
  for i:=0 to Length(AValue)*4-1 do begin
    Result[i*2+1]:= IdHexDigits[Ord(P[i]) shr 4];
    Result[i*2+2]:= IdHexDigits[Ord(P[i]) and $F];
  end;//for
end;


function TIdHash32.HashValue(const ASrc: string): LongWord;
var
  LStream: TIdReadMemoryStream;
begin
  LStream := TIdReadMemoryStream.Create;
  try
    LStream.SetPointer(Pointer(ASrc),Length(ASrc));
    Result := HashValue(LStream);
  finally
    FreeAndNil(LStream);
  end;
end;

{ TIdHash16 }

function TIdHash16.HashValue(const ASrc: string): Word;
var
  LStream: TIdReadMemoryStream;
begin
  LStream := TIdReadMemoryStream.Create;
  try
    LStream.SetPointer(Pointer(ASrc),Length(ASrc));
    Result := HashValue(LStream);
  finally
    FreeAndNil(LStream);
  end;
end;

{ TIdHash128 }

function TIdHash128.HashValue(const ASrc: string): T4x4LongWordRecord;
var
  LStream: TIdReadMemoryStream;
begin
  LStream := TIdReadMemoryStream.Create; try
    LStream.SetPointer(Pointer(ASrc),Length(ASrc));
    //Result := idhm4.HashValue4(LStream);
    Result:= HashValue(LStream);
  finally FreeAndNil(LStream); end;
end;

class function TIdHash128.AsHex(const AValue: T4x4LongWordRecord): string;
var
  P: PChar;
  i: Integer;
Begin
  P:=PChar(@AValue);
  SetString(Result,NIL,4*4*2);//32
  for i:=0 to 15 do begin
    Result[i*2+1]:=IdHexDigits[ord(P[i]) shr 4];
    Result[i*2+2]:=IdHexDigits[ord(P[i]) and $F];
  end;//for
end;

function TIdHash160.HashValue(const ASrc: string): T5x4LongWordRecord;
var
  LStream: TIdReadMemoryStream;  // not TIdStringStream -  Unicode on DotNet!
begin
  LStream := TIdReadMemoryStream.Create; try
    //WriteStringToStream(LStream, ASrc);
    LStream.SetPointer(Pointer(ASrc),Length(ASrc));
    LStream.Position := 0;
    Result := HashValue(LStream);
  finally FreeAndNil(LStream); end;
end;

class function TIdHash160.AsHex(const AValue: T5x4LongWordRecord): string;
Begin
  result:= ToHex(AValue);
end;


end.
