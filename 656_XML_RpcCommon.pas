unit uPSI_XmlRpcCommon;
{
Intermediate transformations to and from the client - needs the interface type
   #sign:Max: MAXBOX10: 18/05/2016 10:20:10 

}
interface
 

 
{uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ; }
  
  
  type
  TRC4Data = record
    Key: array[0..255] of Byte; { current key }
    OrgKey: array[0..255] of Byte; { original key }
  end;

  {TRC4 = class(TObject)
  private
    FData: TRC4Data;
    procedure RC4Init(var Data: TRC4Data; Key: Pointer; Len: Integer);
    procedure RC4Burn(var Data: TRC4Data);
    procedure RC4Crypt(var Data: TRC4Data; InData, OutData: Pointer; Len:
      Integer);
    procedure RC4Reset(var Data: TRC4Data);
  public
    constructor Create(const EncryptionKey: string);
    procedure EncryptStream(InStream, OutStream: TMemoryStream);
    function EncryptString(const Value: string): string;
    procedure DecryptStream(InStream, OutStream: TMemoryStream);
    function DecryptString(const Value: string): string;
    procedure BurnKey;
  end; }

  { xml-rpc data types }
  TRPCDataType3 = (rpNone, rpString, rpInteger, rpBoolean, rpDouble,
    rpDate, rpBase64, rpStruct, rpArray, rpName, rpError);

function GetTempDir: string;

function FileIsExpired(const FileName: string; Elapsed: Integer): Boolean;

function EncodeEntities(const Data: string): string;

function DecodeEntities(const Data: string): string;

function Replace(const Data: string; const Find: string; const aReplace: string): string;

function InStr(Start: Integer; const Data: string;
  const Find: string): Integer;

function Mid(const Data: string; Start: Integer): string;

function DateTimeToISO(ConvertDate: TDateTime): string;

function IsoToDateTime(const ISOStringDate: string): TDateTime;

function ParseString(const SearchString: string; Delimiter: Char;
  Substrings: TStrings; const AllowEmptyStrings: Boolean;
  ClearBeforeParse: Boolean): Integer;

function ParseStream(SearchStream: TStream; Delimiter: Char;
  Substrings: TStrings; AllowEmptyStrings: Boolean;
  ClearBeforeParse: Boolean): Integer;

function FixEmptyString(const Value: string): string;

function URLEncode(const Value: string): string;

function StreamToString(Stream: TStream): string;

procedure StringToStream(const Text: string; Stream: TStream);

{$IFDEF ACTIVEX}
function StreamToVariant(Stream: TStream): OleVariant;

procedure VariantToStream(V: OleVariant; Stream: TStream);
{$ENDIF}

{$IFDEF INDY9}
function Hash128AsHex(const Hash128Value: T4x4LongWordRecord): string;
{$ENDIF}

const
  ValidURLChars2 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$-_@.&+-!''*"(),;/#?:';

 
type 

   TRPCDataTypeX = ( rpNone, rpString, rpInteger, rpBoolean, rpDouble, rpDate, rpBase64, rpStruct, rpArray, rpName, rpError );
(*----------------------------------------------------------------------------*)
 (* TPSImport_XmlRpcCommon = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRC4(CL: TPSPascalCompiler);
procedure SIRegister_XmlRpcCommon(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_XmlRpcCommon_Routines(S: TPSExec);
procedure RIRegister_TRC4(CL: TPSRuntimeClassImporter);
procedure RIRegister_XmlRpcCommon(CL: TPSRuntimeClassImporter);

procedure Register;        *)

implementation


{------------------------------------------------------------------------------}

function URLEncode(const Value: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Value) do
  begin
    if Pos(UpperCase(Value[I]), ValidURLChars) > 0 then
      Result := Result + Value[I]
    else
    begin
      if Value[I] = ' ' then
        Result := Result + '+'
      else
      begin
        Result := Result + '%';
        Result := Result + IntToHex(ord(Value[I]), 2);
      end;
    end;
  end;
end;

{------------------------------------------------------------------------------}

function EncodeEntities(const Data: string): string;
begin
  Result := StringReplace(Data, '&', '&amp;', [rfReplaceAll]);
  Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll]);
  Result := StringReplace(Result, '>', '&gt;', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll]);
  Result := StringReplace(Result, #39, '&apos;', [rfReplaceAll]);
end;

{------------------------------------------------------------------------------}

function DecodeEntities(const Data: string): string;
begin
  Result := StringReplace(Data, '&lt;', '<', [rfReplaceAll]);
  Result := StringReplace(Result, '&gt;', '>', [rfReplaceAll]);
  Result := StringReplace(Result, '&quot;', '"', [rfReplaceAll]);
  Result := StringReplace(Result, '&apos;', #39, [rfReplaceAll]);
  Result := StringReplace(Result, '&amp;', '&', [rfReplaceAll]);
end;

{------------------------------------------------------------------------------}
{ String Parsing Routine                                                       }
{------------------------------------------------------------------------------}

function ParseString(const SearchString: string; Delimiter: Char; Substrings: 
    TStrings; const AllowEmptyStrings: Boolean; ClearBeforeParse: 
    Boolean): Integer;
var
  Index: Integer;
  PrevCount: Integer;
  TempStr: string;
begin
  if (ClearBeforeParse) then
    Substrings.Clear;

  PrevCount := Substrings.Count;

  { ensure that the last substring is found }
  TempStr := SearchString + Delimiter;

  while (Length(TempStr) > 0) do
  begin
    Index := Pos(Delimiter, TempStr);
    if ((Index > 1) or AllowEmptyStrings) then
      Substrings.Add(Copy(TempStr, 1, Index - 1));
    Delete(TempStr, 1, Index);
  end;

  Result := Substrings.Count - PrevCount;
end;

{------------------------------------------------------------------------------}
{ stream parser                                                                }
{------------------------------------------------------------------------------}

function ParseStream(SearchStream: TStream; Delimiter: Char; Substrings: 
    TStrings; AllowEmptyStrings: Boolean; ClearBeforeParse: Boolean): Integer;
begin
  Result := ParseString(StreamToString(SearchStream), Delimiter, Substrings,
    AllowEmptyStrings, ClearBeforeParse);
end;

{------------------------------------------------------------------------------}
{ convert stream to a string                                                   }
{------------------------------------------------------------------------------}

function StreamToString(Stream: TStream): string;
begin
  Result := '';
  Stream.Seek(0, soFromBeginning);
  SetLength(Result, Stream.Size);
  Stream.Read(Result[1], Stream.Size);
end;

{------------------------------------------------------------------------------}
{  Converts a string to a stream                                               }
{------------------------------------------------------------------------------}

procedure StringToStream(const Text: string; Stream: TStream);
begin
  Stream.Write(Text[1], Length(Text));
end;

{------------------------------------------------------------------------------}
{  Converts a date time to iso 8601 format                                     }
{------------------------------------------------------------------------------}

function DateTimeToISO(ConvertDate: TDateTime): string;
begin
  Result := FormatDateTime('yyyymmdd"T"hh:mm:ss', ConvertDate);
end;

{------------------------------------------------------------------------------}
{  Converts a ISO 8601 data to TDateTime                                       }
{------------------------------------------------------------------------------}

function IsoToDateTime(const ISOStringDate: string): TDateTime;
begin
  Result := EncodeDate(StrToInt(ISOStringDate[1] +
    ISOStringDate[2] +
    ISOStringDate[3] +
    ISOStringDate[4]),
    StrToInt(ISOStringDate[5] +
    ISOStringDate[6]),
    StrToInt(ISOStringDate[7] +
    ISOStringDate[8])) +
    EncodeTime(StrToInt(ISOStringDate[10] +
    ISOStringDate[11]),
    StrToInt(ISOStringDate[13] +
    ISOStringDate[14]),
    StrToInt(ISOStringDate[16] +
    ISOStringDate[17]), 0);
end;

{------------------------------------------------------------------------------}
{  Returns part of a string                                                    }
{------------------------------------------------------------------------------}

function Mid(const Data: string; Start: Integer): string;
begin
  Result := Copy(Data, Start, Length(Data) - (Start - 1));
end;

{------------------------------------------------------------------------------}
{  Find position of string in sub string                                       }
{------------------------------------------------------------------------------}

function InStr(Start: Integer; const Data: string; const
  Find: string): Integer;
var
  C: Integer;
label
  SkipFind;
begin
  C := Start - 1;
  //repeat
    if C > Length(Data) then begin
      C := 0;
      goto SkipFind;
    end;
    Inc(C);
 // until (Copy(Data, C, Length(Find)) = Find);
  //until data = Find;
   skipFind:
  Result := C;
end;

{------------------------------------------------------------------------------}
{  replace item in string                                                      }
{------------------------------------------------------------------------------}

function Replace(const Data: string; const Find: string;
  const aReplace: string): string;
var
  C: Integer;
  Temp, Temp2: string;
begin
  Temp := Data;
  C := InStr(1, Temp, Find);
  while C <> 0 do
  begin
    Temp2 := Copy(Temp, 1, C - 1) + aReplace + Mid(Temp, C + Length(Find));
    Temp := Temp2;
    C := InStr(C + Length(aReplace), Temp, Find);
  end;
  Result := Temp;
end;

{------------------------------------------------------------------------------}
{Initialize the RC4 Engine                                                     }
{------------------------------------------------------------------------------}

var FData: TRC4Data;

procedure TRC4_RC4Init(var Data: TRC4Data; Key: ___Pointer; Len: Integer);
var
  XKey: array[0..255] of Byte;
  I, J: Integer;
  T: Byte;
begin
  if (Len <= 0) or (Len > 256) then
    raise; //Exception.Create('RC4: Invalid key length');
  for I := 0 to 255 do
  begin
    Data.Key[I] := I;
    //XKey[I] := PByte(Integer(Key) + (I mod Len))^;
  end;
  J := 0;
  for I := 0 to 255 do begin
    J := (J + Data.Key[I] + XKey[I]) and $FF;
    T := Data.Key[I];
    Data.Key[I] := Data.Key[J];
    Data.Key[J] := T;
  end;
  //Move(Data.Key, Data.OrgKey, 256);
end;

{------------------------------------------------------------------------------}
{Burn Key data from memory                                                     }
{------------------------------------------------------------------------------}

procedure TRC4_RC4Burn(var Data: TRC4Data);
begin
  //FillChar(Data, Sizeof(Data), $FF);
end;

{------------------------------------------------------------------------------}
{Crypt and decrypt routine                                                     }
{------------------------------------------------------------------------------}

procedure TRC4_RC4Crypt(var Data: TRC4Data; InData, OutData: string {___Pointer}; Len:
  Integer);
var
  T, I, J: Byte;
  K: Integer;
begin
  I := 0;
  J := 0;
  for K := 0 to Len - 1 do
  begin
    I := (I + 1) and $FF;
    J := (J + Data.Key[I]) and $FF;
    T := Data.Key[I];
    Data.Key[I] := Data.Key[J];
    Data.Key[J] := T;
    T := (Data.Key[I] + Data.Key[J]) and $FF;
    //PByteArray(OutData)[K] := PByteArray(InData)[K] xor Data.Key[T];
  end;
end;

{------------------------------------------------------------------------------}
{Reset the data keys                                                           }
{------------------------------------------------------------------------------}

procedure TRC4_RC4Reset(var Data: TRC4Data);
begin
  //Move(Data.OrgKey, Data.Key, 256);
end;

{------------------------------------------------------------------------------}
{Remove keys from memory                                                       }
{------------------------------------------------------------------------------}

procedure TRC4_BurnKey;
begin
  TRC4_RC4Burn(FData);
end;

{------------------------------------------------------------------------------}
{Decrypt a memory stream                                                       }
{------------------------------------------------------------------------------}

procedure TRC4_DecryptStream(InStream, OutStream: TMemoryStream);
begin
  OutStream.SetSize(InStream.Size);
  TRC4_RC4Crypt(FData, 'InStream.Memory', 'OutStream.Memory', InStream.Size);
  TRC4_RC4Reset(FData);
end;

{------------------------------------------------------------------------------}
{Secrypt a string value                                                        }
{------------------------------------------------------------------------------}

function TRC4_DecryptString(const Value: string): string;
begin
  SetLength(Result, Length(Value));
  //TRC4_RC4Crypt(FData, PByteArray(Value), PByteArray(Result), Length(Result));
end;

{------------------------------------------------------------------------------}
{Encrypt stream data                                                           }
{------------------------------------------------------------------------------}

procedure TRC4_EncryptStream(InStream, OutStream: TMemoryStream);
begin
  OutStream.SetSize(InStream.Size);
  TRC4_RC4Crypt(FData, 'InStream.Memory', 'OutStream.Memory', InStream.Size);
  TRC4_RC4Reset(FData);
end;

{------------------------------------------------------------------------------}
{Encrypt a string value                                                        }
{------------------------------------------------------------------------------}

function TRC4_EncryptString(const Value: string): string;
begin
  SetLength(Result, Length(Value));
  //TRC4_RC4Crypt(FData, PByteArray(Value), PByteArray(Result), Length(Result));
  Result := Result;
  TRC4_RC4Reset(FData);
end;

{------------------------------------------------------------------------------}

procedure{constructor} TRC4_Create(const EncryptionKey: string);
begin
  {initialize encryption engine}
  //RC4Init(FData, PByteArray(EncryptionKey), Length(EncryptionKey));
end;

{------------------------------------------------------------------------------}
//check a file to see if the elapsed time is expired

function FileIsExpired(const FileName: string; Elapsed: Integer): Boolean;
var
  FHandle: Integer;
  FDate: TDateTime;
  FileTime: TTimeStamp;
  CurrentTime: TTimeStamp;
  DeltaTime: Integer;
begin
  FHandle := FileOpen(FileName, 0);
  try
    FDate := FileDateToDateTime(FileGetDate(FHandle));
    FileTime := DateTimeToTimeStamp(FDate);
    CurrentTime := DateTimeToTimeStamp(Now);
    DeltaTime := Round((CurrentTime.Time - FileTime.Time) / 60000);
    if (DeltaTime > Elapsed) then
      Result := True
    else
      Result := False;
  finally
    FileClose(FHandle);
  end;
end;

{------------------------------------------------------------------------------}

function GetTempDir: string;
{$IFDEF WIN32}
var
  Buf: array[0..MAX_PATH] of Char;
{$ENDIF}
begin
{$IFDEF WIN32}
  GetTempPath(Sizeof(Buf), Buf);
  Result := Buf;
  if Result[Length(Result)] <> '\' then
    Result := Result + '\';
{$ENDIF}
{$IFDEF LINUX}
  Result := '/var/tmp/';
{$ENDIF}
end;

{------------------------------------------------------------------------------}
{$IFDEF INDY9}

function Hash128AsHex(const Hash128Value: T4x4LongWordRecord): string;
begin
  Result := IntToHex(Hash128Value[0], 4) +
    IntToHex(Hash128Value[1], 4) +
    IntToHex(Hash128Value[2], 4) +
    IntToHex(Hash128Value[3], 4);
end;

{$ENDIF}
{------------------------------------------------------------------------------}

function FixEmptyString(const Value: string): string;
begin
  Result := StringReplace(Value, '<string></string>', '<string>[NULL]</string>',
    [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '<string></nil></string>',
    '<string>[NULL]</string>', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '<string></null></string>',
    '<string>[NULL]</string>', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '<string> </string>',
    '<string>[NULL]</string>', [rfReplaceAll, rfIgnoreCase]);

  // CLINTON 16/9/2003 - <string></string> was not compatable with XML-RPC spec.
  Result := StringReplace(Result,'<value></value>',
      '<value>[NULL]</value>', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result,'<value></nil></value>',
      '<value>[NULL]</value>', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result,'<value></null></value>',
      '<value>[NULL]</value>', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result,'<value> </value>',
      '<value>[NULL]</value>', [rfReplaceAll, rfIgnoreCase]);
end;

{$IFDEF ACTIVEX}

function StreamToVariant(Stream: TStream): OleVariant;
var
  V: OleVariant;
  P: Pointer;
begin
  V := VarArrayCreate([0, Stream.Size - 1], varByte);
  Stream.Position := 0;
  P := VarArrayLock(V);
  try
    Stream.Read(P^, Stream.Size);
  finally
    VarArrayUnlock(V);
  end;
  Result := V;
end;

procedure VariantToStream(V: OleVariant; Stream: TStream);
var
  P: Pointer;
begin
  Stream.Position := 0;
  Stream.Size := VarArrayHighBound(V, 1) - VarArrayLowBound(V, 1) + 1;
  P := VarArrayLock(V);
  Stream.Write(P^, Stream.Size);
  VarArrayUnlock(V);
  Stream.Position := 0;
end;

{$ENDIF}


//begin

 //GetTempDir
 //FileIsExpired

End.




{uses
   Windows
  ,IdHash
  ,Variants
  ,XmlRpcCommon
  ;   }
 
 
procedure Register;
begin
  //RegisterComponents('Pascal Script', [TPSImport_XmlRpcCommon]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TRC4(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TRC4') do
  with CL.AddClassN(CL.FindClass('TObject'),'TRC4') do
  begin
    RegisterMethod('Constructor Create( const EncryptionKey : string)');
    RegisterMethod('Procedure EncryptStream( InStream, OutStream : TMemoryStream)');
    RegisterMethod('Function EncryptString( const Value : string) : string');
    RegisterMethod('Procedure DecryptStream( InStream, OutStream : TMemoryStream)');
    RegisterMethod('Function DecryptString( const Value : string) : string');
    RegisterMethod('Procedure BurnKey');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_XmlRpcCommon(CL: TPSPascalCompiler);
begin
  SIRegister_TRC4(CL);
  CL.AddTypeS('
 CL.AddDelphiFunction('Function GetTempDirRPC : string');
 CL.AddDelphiFunction('Function FileIsExpired( const FileName : string; Elapsed : Integer) : Boolean');
 CL.AddDelphiFunction('Function EncodeEntities( const Data : string) : string');
 CL.AddDelphiFunction('Function DecodeEntities( const Data : string) : string');
 CL.AddDelphiFunction('Function ReplaceRPC( const Data : string; const Find : string; const Replace : string) : string');
 CL.AddDelphiFunction('Function InStr( Start : Integer; const Data : string; const Find : string) : Integer');
 CL.AddDelphiFunction('Function Mid( const Data : string; Start : Integer) : string');
 CL.AddDelphiFunction('Function DateTimeToISO( ConvertDate : TDateTime) : string');
 CL.AddDelphiFunction('Function IsoToDateTime(const ISOStringDate : string) : TDateTime');
 CL.AddDelphiFunction('Function ParseStringRPC( const SearchString : string; Delimiter : Char; Substrings : TStrings; const AllowEmptyStrings : Boolean; ClearBeforeParse : Boolean) : Integer');
 CL.AddDelphiFunction('Function ParseStream( SearchStream : TStream; Delimiter : Char; Substrings : TStrings; AllowEmptyStrings:Boolean;ClearBeforeParse : Boolean) : Integer');
 CL.AddDelphiFunction('Function FixEmptyString( const Value : string) : string');
 CL.AddDelphiFunction('Function URLEncodeRPC( const Value : string) : string');
 CL.AddDelphiFunction('Function StreamToStringRPC( Stream : TStream) : string');
 CL.AddDelphiFunction('Procedure StringToStream(const Text: string;Stream:TStream)');
 CL.AddDelphiFunction('Function StreamToVariant( Stream : TStream) : OleVariant');
 CL.AddDelphiFunction('Procedure VariantToStream( V : OleVariant; Stream : TStream)');
 CL.AddDelphiFunction('Function Hash128AsHex(const Hash128Value : T4x4LongWordRecord) : string');
 CL.AddConstantN('ValidURLChars','String').SetString('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$-_@.&+-!''*"(),;/#?:');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_XmlRpcCommon_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetTempDir, 'GetTempDirRPC', cdRegister);
 S.RegisterDelphiFunction(@FileIsExpired, 'FileIsExpired', cdRegister);
 S.RegisterDelphiFunction(@EncodeEntities, 'EncodeEntities', cdRegister);
 S.RegisterDelphiFunction(@DecodeEntities, 'DecodeEntities', cdRegister);
 S.RegisterDelphiFunction(@Replace, 'ReplaceRPC', cdRegister);
 S.RegisterDelphiFunction(@InStr, 'InStr', cdRegister);
 S.RegisterDelphiFunction(@Mid, 'Mid', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToISO, 'DateTimeToISO', cdRegister);
 S.RegisterDelphiFunction(@IsoToDateTime, 'IsoToDateTime', cdRegister);
 S.RegisterDelphiFunction(@ParseString, 'ParseStringRPC', cdRegister);
 S.RegisterDelphiFunction(@ParseStream, 'ParseStream', cdRegister);
 S.RegisterDelphiFunction(@FixEmptyString, 'FixEmptyString', cdRegister);
 S.RegisterDelphiFunction(@URLEncode, 'URLEncodeRPC', cdRegister);
 S.RegisterDelphiFunction(@StreamToString, 'StreamToStringRPC', cdRegister);
 S.RegisterDelphiFunction(@StringToStream, 'StringToStream', cdRegister);
 S.RegisterDelphiFunction(@StreamToVariant, 'StreamToVariant', cdRegister);
 S.RegisterDelphiFunction(@VariantToStream, 'VariantToStream', cdRegister);
 S.RegisterDelphiFunction(@Hash128AsHex, 'Hash128AsHex', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRC4(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRC4) do
  begin
    RegisterConstructor(@TRC4.Create, 'Create');
    RegisterMethod(@TRC4.EncryptStream, 'EncryptStream');
    RegisterMethod(@TRC4.EncryptString, 'EncryptString');
    RegisterMethod(@TRC4.DecryptStream, 'DecryptStream');
    RegisterMethod(@TRC4.DecryptString, 'DecryptString');
    RegisterMethod(@TRC4.BurnKey, 'BurnKey');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_XmlRpcCommon(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TRC4(CL);
end;

 
 
{ TPSImport_XmlRpcCommon }
(*----------------------------------------------------------------------------*)
procedure TPSImport_XmlRpcCommon.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_XmlRpcCommon(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_XmlRpcCommon.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_XmlRpcCommon(ri);
  RIRegister_XmlRpcCommon_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
