unit crlfParser;

interface

uses
  Classes, SysUtils, crlfLexer;

type
  EPppParserError = class(Exception);

  TcrlfFlow = (flAuto, flCRLFtoLF, flLFtoCRLF);

  TcrlfParser = class
  private
    FLexer: TPppLexer;
    fFlow: TcrlfFlow;
  protected
    function ParseText: String;
    property Lexer: TPppLexer read FLexer;
    property Flow: TcrlfFlow read fFlow;
  public
    constructor Create(AStream: TStream; aFlow: TcrlfFlow = flAuto);
    destructor Destroy; override;
    function Parse: String;
  end;

implementation

{ TPppParser }

constructor TcrlfParser.Create(AStream: TStream; aFlow: TcrlfFlow = flAuto);
begin
  Assert(AStream <> nil);

  FLexer := TPppLexer.Create(AStream);
  fFlow:= aFlow;
end;

destructor TcrlfParser.Destroy;
begin
  FLexer.Free;
  inherited;
end;

function TcrlfParser.Parse: String;
begin
  try
    FLexer.Reset;
    Result := ParseText;
  except
    on EPppLexerError do
      raise; // already has error line info
    on e: Exception do
      Lexer.Error(e.Message);
  end;
end;

function TcrlfParser.ParseText: String;
begin
  Result:= '';
  while True do
  begin
    if Lexer.CurrTok in [tokCRLF, tokLF] then
    begin // Convert
      if (Flow = flAuto) then
      begin
        if (Lexer.CurrTok = tokCRLF) then fFlow:= flCRLFtoLF
        else fFlow:= flLFtoCRLF;
      end;

      if (Flow = flLFtoCRLF) then
        Result:= Result + #13#10
      else
        Result:= Result + #10;
      Lexer.NextTok;
    end
    else if Lexer.CurrTok = tokText then
    begin // Stream out
      Result:= Result + Lexer.TokenAsString;
      Lexer.NextTok;
    end else
    begin
      Break;
    end;
  end;
end;

end.
