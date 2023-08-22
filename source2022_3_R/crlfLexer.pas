unit crlfLexer;

interface

uses
  Classes, SysUtils;

type
  TclToken = (tokText, tokCRLF, tokLF, tokEOF);

  EPppLexerError = class(Exception);

  TPppLexer = class
  private
    FBuf: String;
    FCurrPos: PChar;
    FCurrLine: Integer;
    FCurrTok: TclToken;
    FTokenAsString: String;
  public
    constructor Create(AStream: TStream);
    destructor Destroy; override;

    procedure Error(const AMsg: String);
    procedure NextTok;
    procedure Reset;
    property CurrTok: TclToken read FCurrTok;
    property TokenAsString: String read FTokenAsString;
  end;

implementation

{ TPppLexer }

constructor TPppLexer.Create(AStream: TStream);
begin
  inherited Create;
  SetLength(FBuf, AStream.Size);
  AStream.ReadBuffer(Pointer(FBuf)^, Length(FBuf));
  Reset;
end;

destructor TPppLexer.Destroy;
begin
  inherited;

end;

procedure TPppLexer.Error(const AMsg: String);
begin
  raise EPppLexerError.CreateFmt('(%d): %s', [FCurrLine, AMsg]);
end;

procedure TPppLexer.NextTok;
var
  cp, start: PChar;
  Normal: Boolean;
begin
  { register variables optimization }
  cp := FCurrPos;

  start := cp;

  { determine token type }
  Normal:= not (cp^ in [#0, #10, #13]);
  case cp^ of
    #00: // We imply what no pascal files contain #0 ASCII chracters
    begin
      FCurrTok := tokEof;
      Exit;
    end;

    #10: // LF
    begin
      Inc(cp);
      FCurrTok := tokLF;
    end;

    #13: // CRLF
    begin
      if (cp + 1)^ <> #10 then Normal:= True else
      begin
        Inc(cp, 2);
        FCurrTok := tokCRLF;
      end
    end;
  end;

  if Normal then
  begin
    repeat
      Inc(cp);
    until (cp^ in [#0, #10, #13]);
    FCurrTok := tokText;
  end else Inc(fCurrLine);

  SetString(FTokenAsString, start, cp - start);
  { restore register variables }
  FCurrPos := cp;
end;

procedure TPppLexer.Reset;
begin
  FCurrPos := PChar(FBuf);
  FCurrLine := 1;
  NextTok;
end;

end.
