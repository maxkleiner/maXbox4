unit MaxTokenizers;

(*
Copyright (C) 2007 Andrew Wozniewicz
*)

interface

const
  tkNULL    =  0;
  tkNONE    =  0;
  tkTAB     =  1;
  tkEOL     =  2;
  tkEOF     =  3;
  tkCOMMENT =  4;
  tkSPACE   =  5;


type
  TTokenID = Byte;
  TTokenSet = set of TTokenID;

  TTokenRec = packed record
    TokenID: TTokenID;
    Pos,
    Len: Integer;
    LineNo,
    ColNo: Integer;
  end;

  ITokenizer = interface
  ['{6026AFA3-1CF6-4BA0-8C0F-4777DE759F0B}']
    function GetTokenStr: String;
    function GetTokenName: String;
    function GetSourceBuffer: PChar;
    function GetTokenID: TTokenID;
    function GetLineNo: Integer;
    function GetTokenPosition: Integer;
    function GetTokenLen: Integer;
    function GetLineCount: Int64;
    function GetTokenCount: Int64;
    function GetLOCCount: Int64;
    function GetNonJunkCount: Int64;
    function GetToken: String;
    function IsJunk: Boolean;

    procedure Init(NewSource: PChar; NewSize: LongInt);
    procedure Clear;
    function EOF: Boolean;

    procedure NextToken;
    procedure NextNonComment;
    procedure NextNonJunk;
    procedure NextNonSpace;

    property Token: String read GetToken;
    property TokenID: TTokenID read GetTokenID;
    property TokenName: String read GetTokenName;
    property LineNo: Integer read GetLineNo;
    property TokenPosition: LongInt read GetTokenPosition;
    property TokenLen: LongInt read GetTokenLen;

    property TokenCount: Int64 read GetTokenCount;
    property LineCount: Int64 read GetLineCount;
    property LOCCount: Int64 read GetLOCCount;
    property NonJunkCount: Int64 read GetNonJunkCount;
  end;


  TBaseTokenizer = class(TInterfacedObject,ITokenizer)
  protected
    FSource: PChar;
    FSourceLength: Longint;
    FBufferCapacity: Longint;
    FCurrToken: TTokenRec;
    FInsideTag: Boolean;
    FBufferPos: LongInt;
    FPrevPos: Integer;
    FTokenCount: Int64;
    FLineCount: Int64;
    FLOCCount: Int64;
    FNonJunkCount: Int64;
    FLOCTokenNo: Int64;
  protected
    procedure NewLine; virtual;
    function GetTokenStr: String; virtual;
    function GetSourceBuffer: PChar; virtual;
    function IsJunk: Boolean; virtual;
    function GetTokenID: TTokenID; virtual;
    function GetLineNo: Integer; virtual;
    function GetTokenNo: Integer; virtual;
    function GetTokenPosition: Integer; virtual;
    function GetTokenLen: Integer; virtual;
    function GetTokenCount: Int64; virtual;
    function GetLineCount: Int64; virtual;
    function GetLOCCount: Int64; virtual;
    function GetNonJunkCount: Int64; virtual;
    function GetToken: String; virtual;
    function GetTokenName: String; virtual;
    function IsComment: Boolean; virtual;
    function IsWhiteSpace: Boolean; virtual;
    procedure Init(NewSource: PChar; NewSize: LongInt); virtual;
    procedure Clear; virtual;
    function EOF: Boolean; virtual;
    procedure NextToken; virtual;
    procedure NextNonComment;
    procedure NextNonJunk;
    procedure NextNonSpace;
    procedure EmitToken(AToken: TTokenID; AOffset, ALen, ALine, ACol: Integer);
  protected
    procedure Scan; virtual; abstract;
  public
    property Token: String read GetTokenStr;
    property Source: PChar read FSource;
    property SourceLength: Longint read fSourceLength;
    property BufferCapacity: Longint read fBufferCapacity;
    property TokenID: TTokenID read GetTokenID;
    property LineNo: Integer read GetLineNo;
    property TokenNo: Integer read GetTokenNo;
    property TokenPosition: Integer read GetTokenPosition;
    property TokenLen: Integer read GetTokenLen;
    property LineCount: Int64 read FLineCount;
    property LOCCount: Int64 read FLOCCount;
    property NonJunkCount: Int64 read GetNonJunkCount;
  end;


implementation

uses
  SysUtils;

{ TBaseTokenizer }


procedure TBaseTokenizer.Clear;
begin
  FillChar(FCurrToken,SizeOf(FCurrToken),0);
end;


procedure TBaseTokenizer.EmitToken(AToken: TTokenID; AOffset, ALen, ALine, ACol: Integer);
begin
  FCurrToken.TokenID := AToken;
  FCurrToken.Pos := AOffset;
  FCurrToken.Len := ALen;
  FCurrToken.LineNo := ALine;
  FCurrToken.ColNo := ACol;
  Inc(FTokenCount);
end;


function TBaseTokenizer.GetTokenID: TTokenID;
begin
  Result := FCurrToken.TokenID;
end;


procedure TBaseTokenizer.Init(NewSource: PChar; NewSize: LongInt);
begin
  Clear;
  FSource := NewSource;
  FSourceLength := NewSize;
  FBufferCapacity := FSourceLength;
  FBufferPos := 0;
  FPrevPos := -1;
  FInsideTag := False;
  FLineCount := 1;
  FLOCCount := 0;
  FNonJunkCount := 0;
end;



procedure TBaseTokenizer.NextToken;
begin
  Clear;
  Scan;
end;



function TBaseTokenizer.GetTokenStr: String;
begin
  if FCurrToken.Len > 0 then
    SetString(Result, (FSource + FCurrToken.Pos), FCurrToken.Len)
  else
    Result := '';
end;




function TBaseTokenizer.GetTokenPosition: Integer;
begin
  Result := FCurrToken.Pos;
end;



function TBaseTokenizer.GetLineNo: Integer;
begin
  Result := FLineCount;
end;


function TBaseTokenizer.GetTokenNo: Integer;
begin
  Result := FTokenCount;
end;


procedure TBaseTokenizer.NextNonComment;
begin
  repeat
    case TokenID of
      tkNull:
        Break;
    else
      Inc(FBufferPos);
    end;
  until not IsComment;
end;



procedure TBaseTokenizer.NextNonJunk;
begin
  repeat
    NextToken;
  until not IsJunk;
end;


procedure TBaseTokenizer.NextNonSpace;
begin
  repeat
    case TokenID of
      tkNull:
        Break;
      else
        Inc(FBufferPos);
    end;
  until not IsWhiteSpace;
end;



function TBaseTokenizer.GetToken: String;
begin
  Result := GetTokenStr;
end;



function TBaseTokenizer.GetTokenLen: Integer;
begin
  Result := FCurrToken.Len;
end;


function TBaseTokenizer.GetNonJunkCount: Int64;
begin
  if FTokenCount > 0 then
    Result := FNonJunkCount
  else
    Result := 0;
end;


function TBaseTokenizer.EOF: Boolean;
begin
  Result := (FSource[FBufferPos] = #0)
    or (FBufferPos >= FSourceLength) or (TokenID = tkEOF);
end;


function TBaseTokenizer.GetSourceBuffer: PChar;
begin
  Result := FSource;
end;


function TBaseTokenizer.GetLineCount: Int64;
begin
  Result := FLineCount;
end;


function TBaseTokenizer.GetLOCCount: Int64;
begin
  Result := FLOCCount;
end;


function TBaseTokenizer.IsJunk: Boolean;
begin
  case FCurrToken.TokenID of
    tkEOL,
    tkComment,
    tkSpace:
      Result := True;
    else
      Result := False;
  end;
end;


function TBaseTokenizer.GetTokenCount: Int64;
begin
  Result := FTokenCount;
end;


procedure TBaseTokenizer.NewLine;
begin
  Inc(FLineCount);
  //Remember the token no. at the beginning of line
  FLOCTokenNo := FNonJunkCount;
end;


function TBaseTokenizer.IsComment: Boolean;
begin
  Result := False;
end;


function TBaseTokenizer.IsWhiteSpace: Boolean;
begin
  Result := (TokenID = tkSPACE) or (TokenID = tkTAB);
end;




function TBaseTokenizer.GetTokenName: String;
begin
  case TokenID of
    tkNULL:   Result := 'NULL';
    tkTAB:    Result := 'TAB';
    tkEOL:    Result := 'EOL';
    tkEOF:    Result := 'EOF';
    tkSPACE:  Result := 'SPACE';
    else      Result := Format('UNKNOWN(%d)',[TokenID]);
  end;

end;

end.
