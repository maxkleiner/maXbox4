unit WDosPlcUtils;

interface

type
  TErrorCode =Byte;

const
  { Error-Codes Master (TPlc) }
  ecmNoError      =0;  { kein Fehler }
  ecmWatchdogTime =1;  { Zykluszeit-Überschreitung }
  ecmInOutBase    =10; { ..17 Fehler in angeschlossenem Input/Output device }
  ecmNext         =18; { nächster freier Error-Code }

  { Error-Codes Slave (TCustomInOut) }
  ecsNoError       =0; { kein Fehler }
  ecsEmergencyStop =1; { Not-Aus }
  ecsHardware      =2; { Hardware-Fehler }
  ecsSoftware      =3; { Software-Fehler }
  ecsParameter     =4; { Parameter-Fehler }
  ecsShortCircuit  =5; { Kurzschluß }
  ecsProtocol      =6; { Protokoll-Fehler }
  ecsReport        =7; { Plc bzw. Bus-Station meldet sich nicht }
  ecsNext          =8; { nächster freier Error-Code }

const
  BitNum =8;      { a byte has 8 bit }
  StationNum =32; { max. 32 fieldbus stations connected
                    with one input/output device }
  StByteNum =8;   { max. 8 byte per fieldbus station }
  InOutNum =8;    { max. 8 input/output devices }

type
  TBitNo =0..BitNum -1;
  TStByteNo =0..StByteNum -1;
  TStationNo =0..StationNum -1;
  TInOutNo =0..InOutNum -1;
  TIo =(E, A, NE, NA);

  TBitSet =set of TBitNo;
  TIoData =array[Byte, Boolean] of TBitSet;

  TAddrKind =set of (akBit0, akBit1, akBit2, akOut, akNot, akBus);
  TBitAddrRec =packed record
    Kind:    TAddrKind;
    InOutNo: TInOutNo;
    ByteNo:  Byte;
  end;
  TBitAddr = type LongInt;

  TByteAddrRec =packed record
    Kind: TAddrKind;
    ByteNo: Byte;
  end;
  TByteAddr =type SmallInt;

  TInOutState =(iosInit, iosHalt, iosRun, iosError);

{ create a bit address for a input/output device without fieldbus system }
function BitAddr(aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte;
    aBitNo: TBitNo): TBitAddr;
{ create a bit address for a input/output device with fieldbus system }
function BusBitAddr(aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo;
    aStByteNo: TStByteNo; aBitNo: TBitNo): TBitAddr;
{ converts a bit address into it's parts }
procedure BitAddrToValues(aBitAddr: TBitAddr; var aIo: TIo;
    var aInOutNo: TInOutNo; var aByteNo: Byte; var aBitNo: TBitNo);
{ converts a bit address into a string with format e.g. 'NE0.1.7.5'
  input/output devices with fieldbus are automatic detected }
function BitAddrToStr(Value: TBitAddr): string;
{ converts a string of format 'NE0.1.7.5' into a bit address }
function StrToBitAddr(const Value: string): TBitAddr;

{ create a byte address for a input/output device without fieldbus system }
function ByteAddr(aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte): TByteAddr;
{ create a byte address for a input/output device with fieldbus system }
function BusByteAddr(aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo;
    aStByteNo: TStByteNo): TByteAddr;
{ wandelt eine Byteadresse in ihre einzelnen Bestandteile um }
procedure ByteAddrToValues(aByteAddr: TByteAddr; var aIo: TIo;
    var aInOutNo: TInOutNo; var aByteNo: Byte);
{wandelt eine Byteadresse in einen String der Form 'NE0.1.7' bzw. 'A0.15' um}
{PLC mit Feldbus-System werden berücksichtigt}
function ByteAddrToStr(Value: TByteAddr): string;
{wandelt einen String der Form 'NE0.1.7' in eine Byteadresse um}
function StrToByteAddr(const Value: string): TByteAddr;
{erhöht den Byte-Wert innerhalb einer Byte-Adresse um den Wert Increment}
procedure IncByteAddr(var ByteAddr: TByteAddr; Increment: Integer =1);
{verringert den Byte-Wert innerhalb einer Byte-Adresse um den Wert Decrement}
procedure DecByteAddr(var ByteAddr: TByteAddr; Decrement: Integer =1);

function InOutStateToStr(State: TInOutState): string;
function MasterErrorToStr(ErrorCode: TErrorCode): string;
function SlaveErrorToStr(ErrorCode: TErrorCode): string;

implementation

uses
  SysUtils;

const
  Ios: array[TIo] of PChar =('E', 'A', 'NE', 'NA');

type
  TFB = array[0..3] of Byte; { 4 byte array }

{ help functions }

procedure ConvertBitError(const Value: string);
begin
  raise EConvertError.CreateFmt('''%s'' is not a PLC bit address', [Value]);
end;

procedure ConvertByteError(const Value: string);
begin
  raise EConvertError.CreateFmt('''%s'' is not a PLC byte address', [Value]);
end;

function FirstChar(var aValue: string): Char;
begin
  Result :=UpCase(aValue[1]);
  Delete(aValue, 1, 1);
end;

function ParseChar(var aValue: string; aChar: Char): Boolean;
begin
  Result :=False;
  if Length(aValue) =0 then Exit;
  Result :=UpCase(aValue[1]) =UpCase(aChar);
  if Result then
    Delete(aValue, 1, 1);
end;

function DotStrToFB(Value: string; var Count: Integer; var FB: TFB): Boolean;
var
  S: string;
  C, I, K, B: Integer;
  Code: Integer;

  function Error: Boolean;
  begin
    Result :=(Code <>0) or not (B in [0..255]);
    FB[C] :=B;
    Inc(C);
  end;

begin
  Result :=False;
  C :=0;
  for K :=0 to Count -2 do
  begin
    I :=Pos('.', Value);
    if I =0 then Break;
    S :=Copy(Value, 1, I -1);
    Value :=Copy(Value, I +1, Length(Value));
    Val(S, B, Code);
    if Error then Exit;
  end;
  Val(Value, B, Code);
  if Error then Exit;
  Count :=C;
  Result :=True;
end;

{ address functions for bit adresses }

{erzeugt eine PlcAddr für ein PLC ohne Feldbus-System}
function BitAddr(aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte;
    aBitNo: TBitNo): TBitAddr;
var
  AddrResult: TBitAddrRec absolute Result;
begin
  with AddrResult do
  begin
    InOutNo :=aInOutNo;
    ByteNo :=aByteNo;
    Byte(Kind) :=aBitNo or Byte(aIo) shl 3;
  end;
end;

{erzeugt eine PlcAddr für ein PLC mit Feldbus-System}
function BusBitAddr(aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo;
    aStByteNo: TStByteNo; aBitNo: TBitNo): TBitAddr;
var
  AddrResult: TBitAddrRec absolute Result;
begin
  with AddrResult do
  begin
    InOutNo :=aInOutNo;
    ByteNo :=aStByteNo or aStation shl 3;
    Byte(Kind) :=$20 or aBitNo or Byte(aIo) shl 3;
  end;
end;

{ converts a bit address into it's parts }
procedure BitAddrToValues(aBitAddr: TBitAddr; var aIo: TIo;
    var aInOutNo: TInOutNo; var aByteNo: Byte; var aBitNo: TBitNo);
var
  BitAddr: TBitAddrRec absolute aBitAddr;
begin
  with BitAddr do
  begin
    Byte(aIo) :=Byte(Kind) shr 3 and $03;
    aInOutNo :=InOutNo;
    aByteNo :=ByteNo;
    aBitNo :=Byte(Kind) and $07;
  end;
end;

{wandelt eine PlcAddr in einen String der Form 'NE0.1.7.5' um}
{PLC mit Feldbus-System werden berücksichtigt}
function BitAddrToStr(Value: TBitAddr): string;
var
  aIo: TIo;
  aInOutNo: TInOutNo;
  aByteNo: Byte;
  aStation: Byte;
  aStByteNo: Byte;
  aBitNo: TBitNo;
  AddrValue: TBitAddrRec absolute Value;
begin
  BitAddrToValues(Value, aIo, aInOutNo, aByteNo, aBitNo);
  aStation :=aByteNo shr 3;
  aStByteNo :=aByteNo and $07;
  {testen ob PLC mit Feldbus-System arbeitet}
  if akBus in AddrValue.Kind then
    Result :=Format('%s%d.%d.%d.%d',[Ios[aIo], aInOutNo, aStation,
        aStByteNo, aBitNo])
  else
    Result :=Format('%s%d.%d.%d',[Ios[aIo], aInOutNo, aByteNo,
        aBitNo]);
end;

{wandelt einen String der Form 'NE0.1.7.5' in eine PlcAddr um}
function StrToBitAddr(const Value: string): TBitAddr;
var
  sValue: string;
  FB: TFB;
  Count: Integer;
  InOut: TIo;
begin
  Result :=0;
  sValue :=Value;
  InOut :=E;
  { check for a not adress }
  if ParseChar(sValue, 'N') then
    Inc(InOut, 2);
  { is it a input or output }
  case FirstChar(sValue) of
    'A': Inc(InOut);
    'E': ;
  else
    ConvertBitError(Value);
  end;
  { max. 4 numerical values seperatet by dots }
  Count :=4;
  if not DotStrToFB(sValue, Count, FB) then
    ConvertBitError(Value);
  {prüfen, ob Adresse für PLC mit Feldbus-System}
  if Count =4 then
  begin
    if (FB[0] >High(TInOutNo)) or (FB[1] >High(TStationNo))
        or (FB[2] >High(TStByteNo)) or (FB[3] >High(TBitNo)) then
      ConvertBitError(Value);
    Result :=BusBitAddr(InOut, FB[0], FB[1], FB[2], FB[3]);
  end
  else if Count =3 then
  begin
    if (FB[0] >High(TInOutNo)) or (FB[2] >High(TBitNo)) then
      ConvertBitError(Value);
    Result :=BitAddr(InOut, FB[0], FB[1], FB[2]);
  end
  else ConvertBitError(Value);
end;

{--- Adressprozeduren für Byte-Adressen ---}

{erzeugt eine Byteadresse für eine PLC ohne Feldbus-System}
function ByteAddr(aIo: TIo; aInOutNo: TInOutNo; aByteNo: Byte): TByteAddr;
var
  AddrResult: TByteAddrRec absolute Result;
begin
  with AddrResult do
  begin
    Byte(Kind) :=aInOutNo or Byte(aIo) shl 3;
    ByteNo :=aByteNo;
  end;
end;

{erzeugt eine Byteadresse für eine PLC mit Feldbus-System}
function BusByteAddr(aIo: TIo; aInOutNo: TInOutNo; aStation: TStationNo;
    aStByteNo: TStByteNo): TByteAddr;
var
  AddrResult: TByteAddrRec absolute Result;
begin
  with AddrResult do
  begin
    ByteNo :=aStByteNo or aStation shl 3;
    Byte(Kind) :=$20 or aInOutNo or Byte(aIo) shl 3;
  end;
end;

{wandelt eine Byteadresse in ihre einzelnen Bestandteile um }
procedure ByteAddrToValues(aByteAddr: TByteAddr; var aIo: TIo;
    var aInOutNo: TInOutNo; var aByteNo: Byte);
var
  ByteAddr: TByteAddrRec absolute aByteAddr;
begin
  with ByteAddr do
  begin
    aByteNo :=ByteNo;
    aIo :=TIo(Byte(Kind) shr 3 and $03);
    aInOutNo :=Byte(Kind) and $07
  end;
end;

{wandelt eine Byteadresse in einen String der Form 'NE0.1.7' bzw. 'A0.15' um}
{PLC mit Feldbus-System werden berücksichtigt}
function ByteAddrToStr(Value: TByteAddr): string;
var
  aIo: TIo;
  aInOutNo: TInOutNo;
  aByteNo: Byte;
  aStation: Byte;
  aStByteNo: Byte;
  AddrValue: TByteAddrRec absolute Value;
begin
  ByteAddrToValues(Value, aIo, aInOutNo, aByteNo);
  aStByteNo :=aByteNo and $07;
  aStation :=aByteNo shr 3;
  if akBus in AddrValue.Kind then
    Result :=Format('%s%d.%d.%d',[Ios[aIo], aInOutNo, aStation, aStByteNo])
  else
    Result :=Format('%s%d.%d',[Ios[aIo], aInOutNo, aByteNo]);
end;

{wandelt einen String der Form 'NE0.1.7' in eine Byteadresse um}
function StrToByteAddr(const Value: string): TByteAddr;
var
  sValue: string;
  FB: TFB;
  Count: Integer;
  InOut: TIo;
begin
  Result :=0;
  sValue :=Value;
  InOut :=E;
  { check for a not adress }
  if ParseChar(sValue, 'N') then
    Inc(InOut, 2);
  { is it a input or output }
  case FirstChar(sValue) of
    'A': Inc(InOut);
    'E': ;
  else
    ConvertByteError(Value);
  end;
  { max. 3 numerical values seperatet by dots }
  Count :=3;
  if not DotStrToFB(sValue, Count, FB) then
    ConvertByteError(Value);
  { check for a address with fieldbus }
  if Count =3 then
  begin
    if (FB[0] >High(TInOutNo)) or (FB[1] >High(TStationNo))
        or (FB[2] >High(TStByteNo)) then
      ConvertByteError(Value);
    Result :=BusByteAddr(InOut, FB[0], FB[1], FB[2]);
  end
  else if Count =2 then
  begin
    if FB[0] >High(TInOutNo) then ConvertByteError(Value);
    Result :=ByteAddr(InOut, FB[0], FB[1]);
  end
  else ConvertByteError(Value);
end;

{erhöht den Byte-Wert innerhalb einer Byte-Adresse um den Wert Increment}
procedure IncByteAddr(var ByteAddr: TByteAddr; Increment: Integer);
var
  ByteAddrRec: TByteAddrRec absolute ByteAddr;
begin
  Inc(ByteAddrRec.ByteNo, Increment);
end;

{verringert den Byte-Wert innerhalb einer Byte-Adresse um den Wert Decrement}
procedure DecByteAddr(var ByteAddr: TByteAddr; Decrement: Integer);
var
  ByteAddrRec: TByteAddrRec absolute ByteAddr;
begin
  Dec(ByteAddrRec.ByteNo, Decrement);
end;


function InOutStateToStr(State: TInOutState): string;
const
  sState: array[TInOutState] of string =('Init', 'Halt', 'Run', 'Error');
begin
  Result :=sState[State];
end;

function MasterErrorToStr(ErrorCode: TErrorCode): string;
begin
  case ErrorCode of
    ecmNoError: Result :='kein Fehler';
    ecmWatchdogTime: Result :='Zykluszeit-Überschreitung';
    ecmInOutBase..ecmInOutBase +7: Result :=Format('Fehler in IO-Device %d',
        [ErrorCode -ecmInOutBase]);
  else
    Result :='unbekannter Fehler';
  end; { case }
end;

function SlaveErrorToStr(ErrorCode: TErrorCode): string;
begin
  case ErrorCode of
    ecsNoError: Result :='kein Fehler';
    ecsEmergencyStop: Result :='Not-Aus';
    ecsHardware: Result :='Hardware-Fehler';
    ecsSoftware: Result :='Software-Fehler';
    ecsParameter: Result :='Parameter-Fehler';
    ecsShortCircuit: Result :='Kurzschluss';
    ecsProtocol: Result :='Protokoll-Fehler';
    ecsReport: Result :='Bus-Station meldet nicht';
  else
    Result :='unbekannter Fehler';
  end; { case }
end;

end.
