unit DataSendToWeb;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ShellAPI;

type
  TDataSendToWeb = class(TComponent)
  private
    FWebAddress, FProtocolDirectory, FProtocolFilename: String;
    FStation: Integer;
    FTestOn: Boolean;
    procedure SetStation(i: Integer);
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    ProtocolStarted: Boolean;
    ft: TextFile;
    ActNo: Integer;
    function FillNull(i,n: Integer): String;
    procedure StartProtocol;
    procedure StopProtocol;
    function GetChiffre(n,p: Integer): Char;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DataSend(rS: String);
    destructor Destroy;
    { Public-Deklarationen }
  published
    property WebAddress: String Read FWebAddress Write FWebAddress;
    property ProtocolDirectory: String Read FProtocolDirectory Write FProtocolDirectory;
    property ProtocolFilename: String Read FProtocolFilename Write FProtocolFilename;
    property Station: Integer Read FStation Write SetStation;
    property TestOn: Boolean Read FTestOn Write FTestOn;
    { Published-Deklarationen }
  end;

procedure Register;

implementation

constructor TDataSendToWeb.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProtocolStarted := False;
  ActNo := 0;
end;

function TDataSendToWeb.FillNull(i,n: Integer): String;
var
  j: Integer;
  s, s0: String;
begin
  Str(i,s);
  s0 := '';
  for j := 1 to n do s0 := s0 + '0';
  s := s0 + s;
  Result := Copy(s,Length(s)-n+1,n);
end;

procedure TDataSendToWeb.StartProtocol;
var
  s1, s2, Filename: String;
  l: Integer;
begin
  l := Length(FProtocolDirectory);
  if l > 1 then
    if FProtocolDirectory[l] <> '\' then FProtocolDirectory := FProtocolDirectory + '\';
  if FProtocolFilename = '' then FProtocolFilename := 'DATAEX';
  Filename := FProtocolDirectory + FProtocolFilename + FillNull(FStation,3);
  AssignFile(ft,Filename);
  if FileExists(Filename) then begin
    Reset(ft);
    while not Eof(ft) do begin
      readln(ft,s1);
    end;
    if Length(s1) >= 21 then
      ActNo := StrToInt(Copy(s1,4,6))
    else
      ActNo := 1;
  end else
    ActNo := 1;
  Rewrite(ft);
  ProtocolStarted := True;
end;

procedure TDataSendToWeb.StopProtocol;
begin
  CloseFile(ft);
  ProtocolStarted := False;
end;

procedure TDataSendToWeb.SetStation(i: Integer);
begin
  if i <> FStation then
    if (i > 0) and (i <= 999) then
      FStation := i;
end;

function TDataSendToWeb.GetChiffre(n,p: Integer): Char;
var
  i: Integer;
begin
  i := ((n + p - 1) * 3) mod 52 + 1;
  if i <= 26 then
    i := i + 64
  else
    i := i + 70;
  Result := Chr(i);
end;

procedure TDataSendToWeb.DataSend(rS: String);
var
  sStation, sActNo, sDateTime1, sDateTime2: String;
  sProto, sSend, sOut, sCheckSum, sError: String;
  t: TDateTime;
  Handle: hWnd;
  i, j, k, CheckSum: Integer;
  s0: String;
  ch: Char;
begin
  if ProtocolStarted = False then StartProtocol;
  Str(FStation,s0);
  sStation := FillNull(FStation,3);

  Inc(ActNo);
  if ActNo = 1000000 then ActNo := 1;
  sActNo := FillNull(ActNo,6);

  t := Now;
  sDateTime1 := FormatDateTime('yyyy-mm-dd hh:nn',t);
  sDateTime2 := FormatDateTime('yymmddhhnn',t);

  sProto := sStation + ' ' + sActNo + ' ' + sDateTime1 + ' ' + rS;
  sSend := sStation + sActNo + sDateTime2 + rS;

  Append(ft);
  if Length(rS) > 16 then begin
    sError := ' WERT ZU LANG!';
    writeln(ft,sProto + ' ' + sError);
  end else begin
    writeln(ft,sProto);

    sOut := '';

    CheckSum := 0;

    for j := 1 to Length(sSend) do begin
      ch := sSend[j];
      case ch of
        '.': i := 10;
        '-': i := 11;
      else
        i := StrToInt(sSend[j]);
      end;
      sOut := sOut + GetChiffre(i,j);
      Inc(CheckSum,i);
    end;

    sOut := sOut + GetChiffre(12,j);

    Str(CheckSum,sCheckSum);

    for k := 1 to Length(sCheckSum) do begin
      i := StrToInt(sCheckSum[k]);
      sOut := sOut + GetChiffre(i,j+k);
    end;

    if TestOn then sOut := sOut + GetChiffre(12,j+k);

    ShellExecute(Handle, 'open', PChar(WebAddress + '?' + sOut), '', NIL, 7);
  end;
end;

destructor TDataSendToWeb.Destroy;
begin
  StopProtocol;
  inherited Destroy;
end;

procedure Register;
begin
  RegisterComponents('Toolbox', [TDataSendToWeb]);
end;

end.



