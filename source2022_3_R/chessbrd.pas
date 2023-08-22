//--------------------------------------------------------------------------
// ChessBoard Component for Delphi2-5
// Version 3.03 - Feb 5, 2000
// Author: Daniel Terhell, Resplendence Sp
// Copyright (c) 1997-2000 Resplendence Sp
//
// Contains translated source from Tom's Simple Chess Program
//
// Contains graphics from Andrew Gate    adapt for mX4
//--------------------------------------------------------------------------

unit ChessBrd;

interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ExtCtrls, ImgList;

{$RESOURCE Chessbrd.res}

const

//  Resource Identifiers
    SetAndrew40Str='SETANDREW40';

    versionStr='3.02';

    NoPiece =-1;
    Black   =0;
    White   =1;

//  From Tom:

    MOVE_STACK=4096;
    HIST_STACK=64;

    LIGHT =0;
    DARK  =1;

    PAWN  =0;
    KNIGHT=1;
    BISHOP=2;
    ROOK  =3;
    QUEEN =4;
    KING  =5;
    EMPTY =6;

//  This is the basic description of a move. promote is what
//  piece to promote the pawn to, if the move is a pawn
//  promotion. bits is a bitfield that describes the move,
//  with the following bits:
//
//    1    capture
//    2    castle
//    4    en passant capture
//    8    pushing a pawn 2 squares
//   16    pawn move
//   32    promote
//

type
    EChessException = class(Exception);

    Square=(None, A8,B8,C8,D8,E8,F8,G8,H8,
                  A7,B7,C7,D7,E7,F7,G7,H7,
                  A6,B6,C6,D6,E6,F6,G6,H6,
                  A5,B5,C5,D5,E5,F5,G5,H5,
                  A4,B4,C4,D4,E4,F4,G4,H4,
                  A3,B3,C3,D3,E3,F3,G3,H3,
                  A2,B2,C2,D2,E2,F2,G2,H2,
                  A1,B1,C1,D1,E1,F1,G1,H1);

    DisplayCoords=(West, North, East, South);
    CanStillCastle=(WhiteKingSide, WhiteQueenSide, BlackKingSide, BlackQueenSide);
    CastleSet=set of CanStillCastle;
    CoordSet= set of DisplayCoords;

    MoveInfo = record
        position: String;
        Castling: CastleSet;
        OldSquare,NewSquare, EnPassant: Square;
    end;

    pieces=(BP,BN,BB,BR,BK,BQ,WP,WN,WB,WR,WQ,WK);

    pGenRec   = ^gen_rec;
    pSquare   = ^Square;
    pCastleSet= ^CastleSet;
    pBoolean  = ^Boolean;
    pThreadPriority= ^TThreadPriority;

    TMoveEvent     =procedure(Sender:TObject; oldSq, newSq: Square) of object;
    TCaptureEvent  =procedure(Sender:TObject; oldSq, newSq: Square; CapturedPiece: Char) of object;
    TOneSquareEvent=procedure(Sender:TObject; square: Square) of object;
    TPromotionEvent=procedure(Sender:TObject; oldSq, newSq: Square;var NewPiece: Char) of object;
    TMoveFunc      =function(oldsq, newsq: Square): Boolean of Object;
    TThinkEvent    =procedure(Sender: TObject; var oldsq,newsq: Square) of object;

//  From Tom:

    move_bytes = record
        src,dst,promote,bits: Byte;
    end;

    moverec = record
        b: move_bytes;
    end;

    // an element of the move stack. it's just a move with a
    // score, so it can be sorted by the search functions. */

    gen_rec = record
        m: moverec;
        score: Integer;
    end;

    // an element of the history stack, with the information
    // necessary to take a move back. */

    hist_rec = record
        m: moverec;
        capture,castle,ep,fifty: Integer;
    end;


    // The thinking thread contains mainly code from Tom's Simple Chess Program:
    TChessThread = class(TThread)
    private
        // pcsq stands for piece/square table. It's indexed by the piece's color,
        // type, and square. The value of pcsq[LIGHT,KNIGHT,e5] might be 310
        // one of the outer squares. //
        // instead of just 300 because a knight on e5 is better than one on

        pcsq:                Array [0..1,0..5,0..63] of Integer;
        flip:                Array [0..63] of Integer;
        pawn_pcsq:           Array [0..63] of Integer;
        kingside_pawn_pcsq:  Array [0..63] of Integer;
        queenside_pawn_pcsq: Array [0..63] of Integer;
        minor_pcsq:          Array [0..63] of Integer;
        king_pcsq:           Array [0..63] of Integer;
        endgame_king_pcsq:   Array[0..63] of Integer;
        color: Array [0..63] of Integer;  // LIGHT, DARK, or EMPTY
        piece: Array [0..63] of Integer;  // PAWN, KNIGHT, BISHOP, ROOK, QUEEN, KING, or EMPTY
        side:  Integer;  // the side to move
        xside: Integer;  // the side not to move
        castle: Integer; // a bitfield with the castle permissions. if 1 is set,
                         // white can still castle kingside. 2 is white queenside.
                         // 4 is black kingside. 8 is black queenside.
        ep: Integer ;    // the en passant square. if white moves e2e4, the en passant
                         // square is set to e3, because that's where a pawn would move
                         // in an en passant capture
        fifty: Integer;  // the number of moves since a capture or pawn move, used
                         //   to handle the fifty-move-draw rule
        ply: Integer;    // the half-move that we're on

        //   this is the move stack. gen_dat is basically a list of move lists,
        //   all stored back to back. gen_begin[x] is where the first move of the
        //   ply x move list is (in gen_dat). gen_end is right after the last move.

        gen_dat:   Array [0..MOVE_STACK-1] of gen_rec;
        gen_begin: Array [0..63] of Integer;
        gen_end:   Array [0..63] of Integer;

        history: Array [0..63,0..63] of Integer;

        // we need an array of hist_rec's so we can take back the
        //   moves we make
        hist_dat: Array [0..63] of hist_rec;

        nodes: Integer;  // the number of nodes we've searched

        // a triangular PV array
        pv: Array[0..63,0..63]of moverec;
        pv_length: Array [0..63] of Integer;
        follow_pv: Boolean;

        // Now we have the mailbox array, so called because it looks like a
        // mailbox, at least according to Bob Hyatt. This is useful when we
        // need to figure out what pieces can go where. Let's say we have a
        // rook on square a4 (32) and we want to know if it can move one
        // square to the left. We subtract 1, and we get 31 (h5). The rook
        // obviously can't move to h5, but we don't know that without doing
        // a lot of annoying work. Sooooo, what we do is figure out a4's
        // mailbox number, which is 61. Then we subtract 1 from 61 (60) and
        // see what mailbox[60] is. In this case, it's -1, so it's out of
        // bounds and we can forget it. You can see how mailbox[] is used
        // in attack() in board.c.

        mailbox: Array [0..119] of Integer;
        mailbox64:Array [0..63] of Integer;

        // slide, offsets, and offset are basically the vectors that
        // pieces can move in. If slide for the piece is FALSE, it can
        // only move one square in any one direction. offsets is the
        // number of directions it can move in, and offset is an array
        // of the actual directions.

        slide: Array[0..5] of Boolean;
        offsets: Array [0..5] of Integer;
        offset: Array[0..5,0..7] of Integer;

        // This is the castle_mask array. We can use it to determine
        // the castling permissions after a move. What we do is
        // logical-AND the castle bits with the castle_mask bits for
        // both of the move's squares. Let's say castle is 1, meaning
        // that white can still castle kingside. Now we play a move
        // where the rook on h1 gets captured. We AND castle with
        // castle_mask[63], so we have 1&14, and castle becomes 0 and
        // white can't castle kingside anymore.

        castle_mask: Array [0..63] of Integer;

        // values of the pieces
        value: Array [0..5] of Integer;

        // the piece letters, for print_board()
        piece_char: Array [0..5] of Char;

        // the initial board state

        init_color: Array [0..63] of Integer;
        init_piece: Array [0..63] of Integer;

        //---------------------------------------------------------------------
        Thinking: Boolean;
        WhiteToMove: pBoolean;
        ComputerPlaysWhite: pBoolean;
        ComputerPlaysBlack: pBoolean;
        StopThinkingNow: Boolean;
        Position: pChar;
        EnPassant: pSquare;
        Castling: pCastleSet;
        SearchDepth: PInt;
        ThinkingPriority: pThreadPriority;

        function eval: Integer;
        function attack(sq,s: Integer): Boolean;
        function ColorOfPiece (sq: Square): Integer;
        function in_check(s: Integer): Boolean;
        function makemove (m: move_bytes): Boolean;
        function quiesce(alpha,beta: Integer): Integer;
        function search(alpha,beta,depth: Integer): Integer;

        procedure ThinkAboutAMove;
        procedure ThinkingFinished;

        procedure gen;
        procedure gen_caps;
        procedure gen_promote(src,dst,bits: Integer);
        procedure gen_push(src,dst,bits: Integer);
        procedure InitValues;
        procedure init_eval;
        procedure IntCopy (dest,source: pInt; count: Integer);
        procedure PerformMove;
        procedure sort(src: Integer);
        procedure sort_pv;
        procedure takeback;

  protected
    procedure Execute; override;

  public
        MoveFunc: TMoveFunc;
        EndFunc:  TNotifyEvent;
        constructor Create;
  end;


  TChessBrd = class(TGraphicControl)
  private
    // Class members starting with a _
    // represent internal storage variables of properties

    timer: TTimer;
    stopThinking: Boolean;

    temp: MoveInfo;
    OldCursor: TCursor;

    Now: TChessThread;
    GameEnded: Boolean;
    FirstTime: Boolean;

    MoveList: Array[0..256,0..2]of MoveInfo;
    buf: Array[0..MAX_PATH] of Char;
    PromoteTo: Char;
    PieceIndex: Array[0..2,0..6] of Integer;
    Boardx,Boardy, PieceSize, _SizeOfSquare, _CurrentMove: Integer;
    ResizeState, _resizable: Boolean;
    _ResizeMinSize,_ResizeMaxSize: Integer;

    _ComputerPlaysWhite,_ComputerPlaysBlack: Boolean;
    _SearchDepth: Integer;
    _ThinkingPriority: TThreadPriority;

    _legalMove,_check,_mate,_staleMate,_castle,_failed :TMoveEvent;
    _paint,_draw,_noMatingMaterial,_threefoldPosition: TNotifyEvent;
    _calculate: TThinkEvent;
    _capture: TCaptureEvent;
    _illegalMove: TOneSquareEvent;
    _promotion: TPromotionEvent;
    _enPassant: Square;

    _position: Array[0..65] of Char;

    list: TImageList;
    _squareLight, _squareDark, _borderBitmap, _custompieceset, Default: TBitmap;
    _lineStyle: TPen;
    _coordFont: TFont;

    _castlingAllowed: CastleSet;
    _displayCoords: CoordSet;

    _customEngine: Boolean;

    SquareClick1, SquareClick2: Square;
    _SizeOfBorder,_animationDelay: Integer;
    _whiteOnTop,_whiteToMove,_boardlines, _animateMoves: Boolean;
    _squareColorLight, _squareColorDark, _bordercolor: TColor;

    _version: String;

    procedure TimerCallback (Sender: TObject);

    function CheckLegalBishopMove (oldsq, newsq: Square):Boolean;
    function CheckLegalKingMove   (oldsq, newsq: Square):Boolean;
    function CheckLegalKnightMove (oldsq, newsq: Square):Boolean;
    function CheckLegalPawnMove   (oldsq, newsq: Square):Boolean;
    function CheckLegalRookMove   (oldsq, newsq: Square):Boolean;
    function CheckLegalQueenMove  (oldsq, newsq: Square):Boolean;
    function BitmapExists         (bmp: TBitmap)        :Boolean;
    function BitmapIsValidPieceSet(bmp: TBitmap)        :Boolean;
    function CheckForThreefoldPosition: Boolean;
    function PieceToInt (piece: Char): Integer;
    procedure DoPromotion (sq: Square);
    procedure ThinkingComplete(Sender:TObject);
    procedure DrawBorder;
    procedure DrawBoard;
    procedure DrawBoardLines;
    procedure DrawPieces;
    procedure DrawPiece (sq: Square; piece: Char);
    procedure InitializeBitmap;
    procedure OrganizeBitmaps;
    procedure AnimateHorizontally (x1,x2,y,delay: Integer);
    procedure AnimateVertically   (y1,y2,x,delay: Integer);
    procedure AnimateDiagonally   (x1,y1,x2,y2,delay: Integer);
    procedure SetNewGame;

    //--Boring Write Methods--------------------------------------

    function  Get_Position: String;
    function  Get_Thinking: Boolean;
    procedure Set_BoardLines (show: Boolean);
    procedure Set_BorderBitmap (bmp: TBitmap);
    procedure Set_BorderColor (c: TColor);
    procedure Set_ComputerPlaysBlack (plays: Boolean);
    procedure Set_ComputerPlaysWhite (plays: Boolean);
    procedure Set_CoordFont (f: TFont);
    procedure Set_CurrentMove (moveno: Integer);
    procedure Set_CustomPieceSet (bmp: TBitmap);
    procedure Set_CustomEngine (use: Boolean);
    procedure Set_DarkSquare(bmp: TBitmap);
    procedure Set_DisplayCoords (cset: CoordSet);
    procedure Set_EnPassant(sq: Square);
    procedure Set_LightSquare(bmp: TBitmap);
    procedure Set_LineStyle (pen: TPen);
    procedure Set_Position (pos: String);
    procedure Set_ResizeMaxSize (size: Integer);
    procedure Set_ResizeMinSize (size: Integer);
    procedure Set_SearchDepth (depth: Integer);
    procedure Set_SizeOfBorder (border: Integer);
    procedure Set_SizeOfSquare (size: Integer);
    procedure Set_SquareColorDark (c: TColor);
    procedure Set_SquareColorLight (c: TColor);
    procedure Set_Thinking (thinking: Boolean);
    procedure Set_ThinkingPriority (priority: TThreadPriority);
    procedure Set_Version (str: String);
    procedure Set_WhiteOnTop (wabove: Boolean);
    procedure Set_WhiteToMove (wmove: Boolean);

  protected

   procedure Click; override;
   procedure DragCanceled;override;
   procedure DragDrop(Source: TObject;X,Y: Integer);override;
   procedure DragOver(Source: TObject;X,Y: Integer; State: TDragState;var Accept: Boolean );override;
   procedure EndDrag(drop:Boolean);
   procedure MouseDown(Button:TMouseButton; Shift:TShiftState;X,Y: Integer); override;
   procedure MouseMove(Shift:TShiftState; X,Y: Integer); override;
   procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X,Y: Integer);override;
   procedure Paint; override;
   procedure Promotion (Sender: TObject;oldSq,newSq: Square; var NewPiece: Char);
   procedure WndProc(var Message: TMessage); override;
  public
   FirstMove, LastMove: Integer;
   FirstTurn, LastTurn: Boolean;

   constructor Create(AOwner: TComponent); override;
   destructor  Destroy; override;

   function BlackInCheckAfter(oldsq, newsq: Square): Boolean;
   function ColorOfPiece (piece: Char): Integer;
   function ColorOfPieceOnSquare (sq: Square): Integer;
   function ColorOfSquare (sq: Square): Integer;
   function GetMove (moveno: Integer; whiteMoves: Boolean): MoveInfo;
   function GotoMove (moveno: Integer; whiteMoves:Boolean): Boolean;
   function LegalMoveAvailable: Boolean;
   function MouseToSquare (x, y: Integer): Square;
   function Move (oldsq, newsq: Square): Boolean;
   function MoveBackward: Boolean;
   function MoveForward: Boolean;
   function MoveIsLegal (oldsq, newsq: Square):Boolean;
   function PerformMove (oldsq, newsq: Square): Boolean;
   function SetUpPosition (pos: MoveInfo; moveno: Integer; whiteMoves:Boolean): Boolean;
   function StringToSquare (str: String): Square;
   function WhiteInCheckAfter(oldsq, newsq: Square):Boolean;
   function WindowToSquare (x, y: Integer): Square;
   function XPos (sq: Square): Integer;
   function YPos (sq: Square): Integer;

   procedure Animate (oldsq,newsq: Square; delay: Integer);
   procedure CancelThinking;
   procedure ClearSquare(sq: Square);
   procedure DrawChessPiece (canvas: TCanvas; x,y: Integer; piece: Char);
   procedure GetMoveList(var list: TStringList);
   procedure NewGame;
   procedure SquareToCoords (sq: Square; var x,y: Integer);
   procedure Think;
   procedure UpdateChessBoard (oldpos: String);

  published
   property AnimateMoves:Boolean read _animateMoves write _animateMoves;
   property AnimationDelay:Integer read _animationDelay write _animationDelay;
   property BoardLines:Boolean read _boardLines write Set_BoardLines;
   property BorderBitmap:TBitmap read _borderBitmap write Set_BorderBitmap;
   property BorderColor:TColor read _borderColor  write Set_BorderColor;
   property CastlingAllowed:CastleSet  read _castlingAllowed write _castlingAllowed;
   property ComputerPlaysBlack:Boolean  read _ComputerPlaysBlack  write  Set_ComputerPlaysBlack;
   property ComputerPlaysWhite:Boolean  read _ComputerPlaysWhite  write  Set_ComputerPlaysWhite;
   property Thinking: Boolean read Get_Thinking write Set_Thinking;
   property CoordFont:TFont  read _CoordFont write Set_CoordFont;
   property CurrentMove:Integer  read _CurrentMove write Set_CurrentMove;
   property CustomPieceSet: TBitmap  read _customPieceset write Set_CustomPieceSet;
   property DisplayCoords:CoordSet  read _displayCoords write Set_DisplayCoords;
   property CustomEngine: Boolean  read _customEngine write Set_CustomEngine;
   property EnPassant:Square read _EnPassant write Set_EnPassant;
   property LineStyle:TPen  read _lineStyle write Set_LineStyle;
   property Position:String read Get_position write Set_Position;
   property Resizable:Boolean  read _resizable write _resizable;
   property ResizeMinSize:Integer  read _ResizeMinSize write Set_ResizeMinSize;
   property ResizeMaxSize:Integer  read _ResizeMaxSize write Set_ResizeMaxSize;
   property SearchDepth: Integer read _SearchDepth  write set_SearchDepth;
   property SizeOfBorder:Integer  read _SizeOfBorder write Set_SizeOfBorder;
   property SizeOfSquare:Integer  read _SizeOfSquare write Set_SizeOfSquare;
   property SquareColorDark:TColor  read _squareColorDark write Set_SquareColorDark;
   property SquareColorLight:TColor  read _squareColorLight write Set_SquareColorLight;
   property SquareDark:TBitmap  read _SquareDark write Set_DarkSquare;
   property SquareLight:TBitmap  read _SquareLight write Set_LightSquare;
   property WhiteOnTop:Boolean  read _whiteOnTop write Set_WhiteOnTop;
   property WhiteToMove:Boolean  read _whiteToMove write Set_WhiteToMove;
   property ThinkingPriority: TThreadPriority read _ThinkingPriority  write set_ThinkingPriority;
   property Version: String read _version write Set_Version;

   property DragCursor;
   property DragMode;
   property Enabled;
   property Visible;

   property OnCapture: TCaptureEvent  read _capture write _capture;
   property OnCastle: TMoveEvent  read _castle write _castle;
   property OnCheck: TMoveEvent read _check write _check;
   property OnDraw: TNotifyEvent read _draw write _draw;
   property OnIllegalMove: TOneSquareEvent  read _illegalmove write _illegalmove;
   property OnLegalMove: TMoveEvent  read _legalmove write _legalmove;
   property OnMate: TMoveEvent  read _mate write _mate;
   property OnNoMatingMaterial: TNotifyEvent  read _noMatingMaterial write _noMatingMaterial;
   property OnPaint: TNotifyEvent  read _paint write _paint;
   property OnPromotion: TPromotionEvent read _promotion write _promotion;
   property OnStaleMate: TMoveEvent  read _stalemate write _stalemate;
   property OnCalculateMove: TThinkEvent read _calculate write _calculate;
   property OnCalculationFailed: TMoveEvent read _failed write _failed;
   property OnThreefoldPosition: TNotifyEvent  read _threefoldposition write _threefoldposition;

   property OnClick;
   property OnDblClick;
   property OnDragDrop;
   property OnDragOver;
   property OnEndDrag;
   property OnMouseDown;
   property OnMouseMove;
   property OnMouseUp;
   property OnStartDrag;

  end;

  ChessBrdError = class(Exception);

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Chess', [TChessBrd]);
end;

constructor TChessBrd.Create(AOwner: TComponent);
var
    p,q: pInt;
begin
    inherited Create(AOwner);

    list:=TImageList.CreateSize(40,40);
    Default:=TBitmap.Create;

    _lineStyle     :=TPen.Create;
    _coordfont     :=TFont.Create;
    _customPieceSet:=TBitmap.Create;
    _SquareLight   :=TBitmap.Create;
    _SquareDark    :=TBitmap.Create;
    _borderBitmap  :=TBitmap.Create;

    Timer:=TTimer.Create(Self);

    _ResizeMinSize:=100;
    _ResizeMaxSize:=1000;

    _animateMoves:=TRUE;
    _animationDelay:=20;   //old 0

    FirstMove:=1;
    LastMove:=1;
    LastTurn:=TRUE;

    PromoteTo:='q';

    InitializeBitmap;
    OrganizeBitmaps;

    _coordfont.Color:=clWhite;
    _coordfont.Name:='Arial';
    _coordfont.Size:=7;
    _coordfont.Pitch:=fpDefault;

    _SizeOfSquare:=40;
    _SizeOfBorder:=24;
    _bordercolor:=clBlack;
    _squareColorDark:=clGray;
    _squareColorLight:=clSilver;

    Boardx:=_SizeOfBorder;
    Boardy:=_SizeOfBorder;

    _ComputerPlaysWhite:=FALSE;
    _ComputerPlaysBlack:=FALSE;
    _SearchDepth:=1;
    _ThinkingPriority:=tpNormal;

    p:=@Width;
    p^:=8*_SizeOfSquare+2*_SizeOfBorder;
    q:=@Height;
    q^:=Width;

    SetNewGame;

    if ((csDesigning in ComponentState)=FALSE) then
    begin
        Now:=TChessThread.Create;
        Now.Castling:=@_CastlingAllowed;
        Now.EnPassant:=@_EnPassant;
        Now.MoveFunc:=PerformMove;
        Now.EndFunc:=ThinkingComplete;
        Now.Position:=@_position;
        Now.ComputerPlaysWhite:=@_ComputerPlaysWhite;
        Now.ComputerPlaysBlack:=@_ComputerPlaysBlack;
        Now.SearchDepth:=@_SearchDepth;
        Now.ThinkingPriority:=@_ThinkingPriority;
        Now.WhiteToMove:=@_WhiteToMove;
    end;

end;


destructor TChessBrd.destroy;
begin
    if(_customEngine=FALSE)and(Now<>nil) then
    begin
        Now.Suspend;
        Now.Free;
    end;

    inherited destroy;

    list.Destroy;
    _lineStyle.Destroy;
    _coordfont.Destroy;
    _SquareLight.Destroy;
    _SquareDark.Destroy;
    _borderBitmap.Destroy;
    _customPieceSet.Destroy;
    Default.Destroy;
end;

procedure TChessBrd.TimerCallback(Sender: TObject);
var
    msg: TMessage;
begin
    WndProc(msg);
end;

procedure TChessBrd.MouseDown(Button: TMouseButton; Shift: TShiftState;X,Y: Integer);
var
    sq: Square;
const
     space: Char=' ';
begin
    inherited MouseDown(Button,Shift,X,Y);

    sq:=WindowToSquare(X,Y);
    if (sq>=A8)AND(sq<=H1)AND
        (_position[Integer(sq)]<>' ') then
     begin
         SquareClick1:=sq;
         BeginDrag(FALSE);
     end;
end;

procedure TChessBrd.ThinkingComplete(Sender: TObject);
begin
    Now.Thinking:=FALSE;
    Now.Suspend;
    if (Now.StopThinkingNow=FALSE) then Think;
end;

procedure TChessBrd.WndProc (var Message: TMessage);
begin
    inherited WndProc (Message);
    if (stopThinking=FALSE)and(_customEngine)and(((_ComputerPlaysBlack)and(_WhiteToMove=FALSE))or
       ((_ComputerPlaysWhite)and(_WhiteToMove=TRUE)))and(csDesigning in ComponentState=FALSE)and
       (csLoading in ComponentState=FALSE) then
    Think;
end;


procedure TChessBrd.Paint;
var
    size: Integer;
begin
    if ((csLoading in ComponentState)=TRUE) then Exit;

    if ((csDesigning in ComponentState)=FALSE)and(@_paint<>nil)
        then _paint(Self);

    if (FirstTime=FALSE) then
    begin
        OrganizeBitmaps;
    end;

    size:=(Width+Height) shr 1;
    _SizeOfSquare:=(size-2*_SizeOfBorder) shr 3;
    Width:=8*_SizeOfSquare+2*_SizeOfBorder;
    Height:=Width;
    DrawBorder;
    DrawBoard;
    DrawPieces;

    if (FirstTime=FALSE) then begin
        FirstTime:=TRUE;
        Think;
        timer.Interval:=1000;  //change 1000
        timer.OnTimer:=TimerCallBack;
    end;
end;


// Displays an move animation
// It's up to the to user ensure there is a piece on oldSq
procedure TChessBrd.Animate (oldSq,newSq: Square; delay: Integer);
var
    x1,y1,x2,y2: Integer;
begin
    if (list.Dragging=FALSE)then
    begin
        list.SetDragImage(PieceToInt(_position[Integer(oldSq)]), 0,0);
        SquareToCoords(oldSq,x1,y1);
        SquareToCoords(newSq,x2,y2);
        x1:=x1+Left;
        y1:=y1+Top;
        x2:=x2+Left;
        y2:=y2+Top;
        list.DragLock  (Parent.Handle,x1,y1);
        list.ShowDragImage;
        list.BeginDrag (Parent.Handle,0,0);

        // Knights don't go diagonally
        if (_position[Integer(oldSq)]<>'n')and(_position[Integer(oldSq)]<>'N') then
            AnimateDiagonally(x1,y1,x2,y2,delay)
        else
        begin
            AnimateHorizontally(x1,x2,y1,delay);
            AnimateVertically(y1,y2,x2,delay);
        end;
    end;
    list.HideDragImage;
    list.EndDrag;
    list.DragUnlock;
end;

procedure TChessBrd.AnimateHorizontally(x1,x2,y,delay: Integer);
var
    x,v: Integer;
begin
    if (x2>x1) then
        for x:=x1 to x2 do
        begin
            v:=GetTickCount;
            list.DragMove(x,y);
            list.ShowDragImage;
            if (delay>0) then
            repeat
            until ((GetTickCount-v)>delay);
        end
    else
        for x:=x1 downto x2 do
        begin
            v:=GetTickCount;
            list.DragMove(x,y);
            list.ShowDragImage;
            if (delay>0) then
            repeat
            until ((GetTickCount-v)>delay);
        end;
end;

procedure TChessBrd.AnimateVertically(y1,y2,x,delay: Integer);
var
    y,v: Integer;
begin
    if (y2>y1) then
        for y:=y1 to y2 do
        begin
             v:=GetTickCount;
             list.DragMove(x,y);
             list.ShowDragImage;
             if (delay>0) then
             repeat
             until ((GetTickCount-v)>delay);
        end
    else
        for y:=y1 downto y2 do
        begin
             v:=GetTickCount;
             list.DragMove(x,y);
             list.ShowDragImage;
             if (delay>0) then
             repeat
             until ((GetTickCount-v)>delay);
        end;
end;

procedure TChessBrd.AnimateDiagonally(x1,y1,x2,y2,delay: Integer);
var
    y,v: Integer;
    x,step: Real;
begin
    if (x1-x2=0)and(y2-y1=0) then Exit;

    if(abs(y2-y1)>abs(x2-x1)) then
    begin
        if (y2>y1) then
        begin
            step:=(x2-x1)/(y2-y1);
            x:=x1;
            for y:=y1 to y2 do
            begin
                v:=GetTickCount;
                list.DragMove(Trunc(x),y);
                list.ShowDragImage;
                if (delay>0) then
                repeat
                until ((GetTickCount-v)>delay);
                x:=x+step;
            end;
        end
        else
        begin
            step:=(x2-x1)/(y1-y2);
            x:=x1;
            for y:=y1 downto y2 do
            begin
                v:=GetTickCount;
                list.DragMove(Trunc(x),y);
                list.ShowDragImage;
                if (delay>0) then
                repeat
                until ((GetTickCount-v)>delay);
                x:=x+step;
            end;
        end
    end
    else
    begin
        if (x2>x1) then
        begin
            step:=(y2-y1)/(x2-x1);
            x:=y1;
            for y:=x1 to x2 do
            begin
                v:=GetTickCount;
                list.DragMove(y,Trunc(x));
                list.ShowDragImage;
                if (delay>0) then
                repeat
                until ((GetTickCount-v)>delay);
                x:=x+step;
            end;
        end
        else
        begin
            step:=(y2-y1)/(x1-x2);
            x:=y1;
            for y:=x1 downto x2 do
            begin
                v:=GetTickCount;
                list.DragMove(y,Trunc(x));
                list.ShowDragImage;
                if (delay>0) then
                repeat
                until ((GetTickCount-v)>delay);
                x:=x+step;
            end;
        end
    end;
end;

procedure TChessBrd.DragOver(Source:TObject;
     X,Y: Integer; State: TDragState; var Accept: Boolean );
var
    sq: Square;
    mid: Integer;
begin
    inherited DragOver(Source, X, Y, State, Accept);

    sq:=WindowToSquare(X,Y);
    mid:=_SizeOfSquare shr 1;

    if (list.Dragging=FALSE)then
    begin
        ClearSquare(SquareClick1);
        DrawBoardLines;
        list.SetDragImage(PieceToInt(_position[Integer(SquareClick1)]), 0,0);
        list.DragLock  (Parent.Handle,X+Left-mid,Y+Top-mid);
        list.BeginDrag (Parent.Handle,0,0);
    end;

    list.DragMove(X+Left-mid,Y+Top-mid);

    if (Source=Self)then
    begin
        if (Thinking=FALSE)then
        begin
            if MoveIsLegal(SquareClick1,sq)or(SquareClick1=sq) then
            begin
                Accept:=TRUE;
            end;
        end;
    end;
end;

procedure TChessBrd.DragDrop(Source:TObject ;X,Y: Integer);
begin
    inherited DragDrop(Source,X,Y);
    if (list.Dragging)then
    begin
        list.HideDragImage;
        list.EndDrag;
        list.DragUnlock;
    end;

    SquareClick2:=WindowToSquare(X,Y);
    if (SquareClick1<>SquareClick2)then
        Move (SquareClick1,SquareClick2)
    else DrawPiece (SquareClick1,_position[Integer(SquareClick1)]);
end;

procedure TChessBrd.DragCanceled;
begin
    list.HideDragImage;
    list.EndDrag;
    list.DragUnlock;
    DrawPiece (SquareClick1,_position[Integer(SquareClick1)]);
    if (@_illegalmove<>nil) then _illegalmove(Self, SquareClick1);
end;

procedure TChessBrd.MouseMove(Shift: TShiftState;X,Y: Integer);
var
    w: Integer;
begin
    inherited MouseMove(Shift,X,Y);

    if (Cursor<>crSizeNWSE)and(Cursor<>crSizeWE) and (Cursor<>crSizeNS)then
        OldCursor:=Cursor;

    if (_resizable)and(X>=(Width-10))and(X<=Width)and(Y>=(Height-10))
         and (Y<=Height) then
        begin
        Cursor:=crSizeNWSE;
        if (ssLeft in Shift)then
            ResizeState:=TRUE;
        end
    else if (_resizable) and(ResizeState=FALSE)then
        Cursor:=OldCursor;

    if (_resizable)and(ResizeState) then
    begin
        if (X>Y) then w:=X
          else w:=Y;
        if (w<_ResizeMinSize) then w:=_ResizeMinSize;
        if (w>_ResizeMaxSize) then w:=_ResizeMaxSize;
        if (w<>Width) then
            begin
            Width:=w;
            end;
    end;
end;

procedure TChessBrd.MouseUp(Button:TMouseButton;Shift:TShiftState;
          X,Y: Integer);
begin
    inherited MouseUp(Button,Shift,X,Y);
    if (ResizeState) then ResizeState:=FALSE;
end;

procedure TChessBrd.Click;
begin
    inherited Click();
end;

procedure TChessBrd.EndDrag(drop: Boolean);
begin
    inherited EndDrag(drop);
end;

procedure TChessBrd.Promotion (Sender:TObject; oldSq,newSq: Square;
     var NewPiece: Char);
var
    i: String;
    r: Integer;
begin
      i:='NBRQnbrq';

      for r:=1 to 8 do
      begin
          if (NewPiece=i[r])then
              Break;
          if (r=8) then NewPiece:='q';
      end;

    PromoteTo:=NewPiece;
end;

procedure TChessBrd.DoPromotion (sq: Square);
begin
    if YPos(sq)=8 then
        begin
        _position[Integer(sq)]:=UpCase(PromoteTo);
        end
    else if (YPos(sq)=1) then
        begin
        _position[Integer(sq)]:=Char(Integer(UpCase(PromoteTo))+32);
        end;

    ClearSquare(sq);
    DrawPiece(sq,_position[Integer(sq)]);
    DrawBoardLines;
end;

//-----------------------------------------------------------------------
// Boring Write Methods
//-----------------------------------------------------------------------

function TChessBrd.Get_Position: String;
begin
     Result:=StrPas(@_position[1]);
end;

procedure  TChessBrd.Set_ComputerPlaysBlack(plays: Boolean);
begin
    CancelThinking;
    _ComputerPlaysBlack:=plays;
    Think;
end;

procedure  TChessBrd.Set_ComputerPlaysWhite(plays: Boolean);
begin
    CancelThinking;
    _ComputerPlaysWhite:=plays;
    Think;
end;


procedure TChessBrd.Set_Position(pos:String);
var
    PieceStr: String;
    q,n,len: Integer;
begin
    CancelThinking;

    PieceStr:=' PNBRQKpnbrqk';

    len:=Length(pos);
    if (len>64) then len:=64;

    _position:='                                                                ';

    for q:=1 to len do
        begin
        if Integer(pos[q])>0 then
            begin
            for n:=1 to 13 do
                begin
                if PieceStr[n]=pos[q] then
                    begin
                    _position[q]:=pos[q];
                    Break;
                    end;
                end;
            end
        else Break;
        end;

    if (LowerCase(pos)='init')or(LowerCase(pos)='newgame') then
    begin
        _position:='_rnbqkbnrpppppppp                                PPPPPPPPRNBQKBNR';
    end;

    Paint;
end;

procedure TChessBrd.Set_ResizeMinSize (size: Integer);
begin
    if (size<_ResizeMaxSize) then _ResizeMinsize:=size
        else _ResizeMinSize:=_ResizeMaxSize;
end;

procedure TChessBrd.Set_ResizeMaxSize (size: Integer);
begin
    if (size > _ResizeMinsize) then
        _ResizeMaxSize:=size
    else _ResizeMaxSize:=_ResizeMinSize;
end;

procedure TChessBrd.Set_SearchDepth (depth: Integer);
begin
   if (depth<1) then _SearchDepth:=1
   else if (depth>=8) then _SearchDepth:=8
   else _SearchDepth:=depth;
end;

procedure  TChessBrd.Set_SizeOfSquare (size: Integer);
begin
    _SizeOfSquare:=size;
    Width:=8*_SizeOfSquare+2*_SizeOfBorder;
end;

procedure  TChessBrd.Set_CurrentMove (moveno: Integer);
begin
    // Read-Only
end;

procedure  TChessBrd.Set_EnPassant (sq: Square);
begin
    if ((sq>=A6)and(sq<=H6))or((sq>=A3)and(sq<=H3)) then
    begin
        CancelThinking;
        _EnPassant:=sq;
    end;
end;

procedure  TChessBrd.Set_BoardLines (show: Boolean);
begin
    _boardLines:=show;
    Paint;
end;

function TChessBrd.Get_Thinking: Boolean;
begin
    Result:=FALSE;
    if (Now<>nil)then
        Result:=Now.Thinking;
end;

procedure TChessBrd.Set_Thinking (thinking:Boolean);
begin
    // Read-Only
end;

procedure TChessBrd.Set_ThinkingPriority (priority: TThreadPriority);
begin
    _ThinkingPriority:=priority;
    if (Now<>nil) then Now.Priority:=_ThinkingPriority;
end;

procedure  TChessBrd.Set_DisplayCoords (cset: CoordSet);
begin
    _displayCoords:=cset;
    Paint;
end;

procedure  TChessBrd.Set_CoordFont(f: TFont);
begin
    _coordfont.Assign(f);
    Paint;
end;

procedure  TChessBrd.Set_CustomPieceSet(bmp: TBitmap);
begin
    if  (bmp=nil)or(BitmapIsValidPieceSet(bmp)) then
    begin
       _customPieceSet.Assign(bmp);
       OrganizeBitmaps;
       Paint;
    end;
end;

procedure  TChessBrd.Set_CustomEngine (use: Boolean);
begin
     _customEngine:=use;
end;

procedure  TChessBrd.Set_LineStyle (pen: TPen);
begin
    _lineStyle.Assign(pen);
    Paint;
end;

procedure  TChessBrd.Set_SizeOfBorder (border: Integer);
begin
    _SizeOfBorder:=border;
    Boardx:=_SizeOfBorder;
    Boardy:=_SizeOfBorder;

    Width:=8*_SizeOfSquare+2*_SizeOfBorder;
end;

procedure TChessBrd.Set_Version (str: String);
begin
    // Read-only
end;

procedure  TChessBrd.Set_WhiteOnTop (wabove: Boolean);
begin
    _whiteOnTop:=wabove;
    Paint;
end;

procedure  TChessBrd.Set_WhiteToMove (wmove: Boolean);
begin
    CancelThinking;
    _whiteToMove:=wmove;
end;

procedure  TChessBrd.Set_DarkSquare(bmp: TBitmap);
begin
    _SquareDark.Assign(bmp);
    Paint;
end;

procedure  TChessBrd.Set_LightSquare(bmp: TBitmap);
begin
    _SquareLight.Assign(bmp);
    Paint;
end;

procedure  TChessBrd.Set_BorderBitmap(bmp: TBitmap);
begin
    _borderBitmap.Assign(bmp);
    Paint;
end;

procedure  TChessBrd.Set_SquareColorDark(c: TColor);
begin
    _squareColorDark:=c;
    Paint;
end;

procedure  TChessBrd.Set_SquareColorLight(c: TColor);
begin
    _squareColorLight:=c;
    Paint;
end;

procedure  TChessBrd.Set_BorderColor(c: TColor);
begin
    _borderColor:=c;
    Paint;
end;

//---------------------------------------------------------------------
//-------PUBLIC Graphic Routines-----------------------------------------------
//---------------------------------------------------------------------

procedure TChessBrd.DrawChessPiece (canvas: TCanvas; x,y: Integer; piece: Char);
var
    v,i,j: Integer;
    c: Char;
begin
    i:=-1;
    c:=piece;

    if (c>='A')and(c<='Z')then
        c:=Char(Integer(c)+32);
    case c of
         'p': i:=0;
         'n': i:=1;
         'b': i:=2;
         'r': i:=3;
         'q': i:=4;
         'k': i:=5;
         end;
    if (piece>='A')and(piece<='Z')
        then j:=0 else j:=1;

    if (i>=0) then v:=PieceIndex[j,i]
        else v:=-1;

    list.Draw (canvas,x,y,v);
end;

procedure  TChessBrd.UpdateChessBoard (oldpos: String);
var
    sq: Square;
begin
    for sq:=A8 to H1 do
        begin
            if (oldpos[Integer(sq)]<>_position[Integer(sq)])then
            begin
                ClearSquare(sq);
                if (_position[Integer(sq)]<>' ')then
                    DrawPiece(sq,_position[Integer(sq)]);
            end;
        end;
    DrawBoardLines;
end;

procedure  TChessBrd.DrawPiece (sq: Square; piece: Char);
var
    x,y,adj: Integer;
begin
    x:=(Integer(sq)-1) mod 8;
    y:=(Integer(sq)-1) shr 3;

    if (_whiteOnTop)then
        begin
        x:=7-x;
        y:=7-y;
        end;

    adj:=Trunc ((_SizeOfSquare-PieceSize)/2);
    list.Draw(Canvas, Boardx+_SizeOfSquare*x+adj, Boardy+_SizeOfSquare*y+adj, PieceToInt(piece));
end;


procedure TChessBrd.ClearSquare(sq: Square);
var
    x,y,posx,posy,SavedDC: Integer;
    Pic: TBitmap;
begin
    SavedDC:=SaveDC(Canvas.Handle);

    Canvas.CopyMode:=cmSrcCopy;
    Canvas.Brush.Style:=bsSolid;

    x:=XPos(sq)-1;
    y:=8-YPos(sq);
    if (_whiteOnTop) then
        begin
        x:=7-x;
        y:=7-y;
        end;

    posx:=Boardx+x*_SizeOfSquare;
    posy:=Boardy+y*_SizeOfSquare;
    IntersectClipRect(Canvas.Handle,posx,posy,posx+_SizeOfSquare,
          posy+_SizeOfSquare);

    if (ColorOfSquare(sq)=Black) then
        if BitmapExists(_SquareDark) then
            Pic:=_SquareDark
        else
            begin
            Pic:=nil;
            Canvas.Brush.Color:=_SquareColorDark;
            Canvas.Pen.Color:=_SquareColorDark;
            end
    else
        if BitmapExists(_SquareLight) then
            Pic:=_SquareLight
        else
            begin
            Pic:=nil;
            Canvas.Brush.Color:=_SquareColorLight;
            Canvas.Pen.Color:=_SquareColorLight;
        end;

    if (Pic<>nil) then
        begin
        for Y:=0 to Height div Pic.Height do
            for X:=0 to Width div Pic.Width do
                Canvas.Draw(X*Pic.Width,Y*Pic.Height,Pic);
        end
    else
        Canvas.FillRect(Canvas.ClipRect);

    if (_boardLines)then
        begin
        Canvas.Pen.Color:=clBlack;
        for X:=1 to 7 do
            begin
            Canvas.MoveTo(BoardX+X*_SizeOfSquare,BoardY);
            Canvas.LineTo(BoardX+X*_SizeOfSquare,Height-BoardY);
            Canvas.MoveTo(BoardX,BoardY+X*_SizeOfSquare);
            Canvas.LineTo(Width-BoardX,BoardY+X*_SizeOfSquare);
            end;
        end;

    RestoreDC(Canvas.Handle,SavedDC);
end;



//Converts from Window Coordinates to square
//returns 0 if invalid else
// 1-64 as a int number
function TChessBrd.WindowToSquare (x,y: Integer): Square;
var
    xn,yn,xv,yv: Integer;
begin

    xv:=x-(Boardx);
    yv:=y-(Boardy);

    if ((xv<0)or(xv>=8*_SizeOfSquare)or(yv<0)or(yv>=8*_SizeOfSquare))then
       begin
       Result:=None;
       Exit;
       end;

    xn:=Trunc(xv/_SizeOfSquare);
    yn:=Trunc(yv/_SizeOfSquare);

    if (xn>7) then xn:=7;
    if (yn>7) then yn:=7;

    if (_whiteOnTop)then
    begin
        xn:=7-xn;
        yn:=7-yn;
    end;

    Result:=Square(8*yn+xn+1);
end;


//
//-PRIVATE Graphic Routines -----------------------------------------------
//
function TChessBrd.BitmapExists (bmp: TBitmap) : Boolean;
begin
    Result:=((bmp<>nil)and(bmp.Width>0)and(bmp.Height>0));
end;

function TChessBrd.BitmapIsValidPieceSet (bmp: TBitmap) : Boolean;
begin
    Result:=((bmp<>nil)and(bmp.Width>0)and(bmp.Height>0)and
             (bmp.Width*2=bmp.Height*3));
end;

procedure TChessBrd.OrganizeBitmaps;
var
    Bmp: TBitmap;
    tmp, tmpmask: TBitmap;
    r,n: Integer;
    src,dest: TRect;
begin
    if (BitmapIsValidPieceSet(_customPieceSet)) then Bmp:=_customPieceSet
        else Bmp:=Default;

    PieceSize:=Bmp.Height shr 2;

    list.Clear;
    list.Masked:=TRUE;
    list.DrawingStyle:=dsTransparent;
    list.Width:=PieceSize;
    list.Height:=PieceSize;

    tmp:=TBitmap.Create;
    tmpmask:=TBitmap.Create;

    tmp.Width:=PieceSize;
    tmp.Height:=PieceSize;
    tmpmask.Width:=PieceSize;
    tmpmask.Height:=PieceSize;

    for n:=0 to 1 do
    for r:=0 to 5 do
    begin
        src.Left:=r*PieceSize;
        src.Top:=n*(PieceSize*2);
        src.Right:=src.Left+PieceSize;
        src.Bottom:=n*(PieceSize*2)+PieceSize;
        dest.Left:=0;
        dest.Top:=0;
        dest.Right:=PieceSize;
        dest.Bottom:=PieceSize;
        tmp.Canvas.CopyRect(dest,Bmp.Canvas,src);

        src.Left:=r*PieceSize;
        src.Top:=n*(PieceSize*2)+PieceSize;
        src.Right:=src.Left+PieceSize;
        src.Bottom:=n*(PieceSize*2)+(PieceSize*2);
        tmpmask.Canvas.CopyRect(dest,Bmp.Canvas,src);

        PieceIndex[n,r]:=list.Add (tmp,tmpmask);
    end;

    tmpmask.Free;
    tmp.Free;
end;

procedure  TChessBrd.DrawBorder;
var
    abc: String;
    r, v, boffset, soffset,X,Y,SavedDC: Integer;
begin
    SavedDC:=SaveDC(Canvas.Handle);

    Canvas.CopyMode:=cmSrcCopy;
    Canvas.Brush.Style:=bsSolid;
    Canvas.Brush.Color:=_bordercolor;
    ExcludeClipRect(Canvas.Handle,_SizeOfBorder,_SizeOfBorder,Width-_SizeOfBorder,Height-_SizeOfBorder);
    if (BitmapExists(_borderBitmap))then begin
        for Y:=0 to Height div _borderBitmap.Height do
            for X:=0 to Width div _borderBitmap.Width do
                Canvas.Draw(X*_borderBitmap.Width,Y*_borderBitmap.Height,_borderBitmap);
    end else
        Canvas.FillRect(Canvas.ClipRect);
    Canvas.Font:=_coordfont;

    if (_WhiteOnTop=FALSE) then abc:='ABCDEFGH' else abc:='HGFEDCBA';

    boffset:=((_SizeOfBorder-_coordfont.Size)shr 1)+1;
    soffset:=(Integer(_SizeOfSquare-_coordfont.Size) shr 1);

    Y:=Canvas.TextHeight('0') div 4;
    SetBkMode(Canvas.Handle,TRANSPARENT);

    for r:=0 to 7 do
        begin
        if _WhiteOnTop then v:=r+1 else
            v:=8-r;
        if (West in _displayCoords)then
            Canvas.TextOut(boffset,_SizeOfBorder+r*_SizeOfSquare+soffset,IntToStr(v));
        if (East in _displayCoords)then
            Canvas.TextOut(Width-_SizeOfBorder+boffset,_SizeOfBorder+r*_SizeOfSquare+soffset,IntToStr(v));
        if (North in _displayCoords)then
            Canvas.TextOut(_SizeOfBorder+r*_SizeOfSquare+soffset,boffset-y,abc[r+1]);
        if (South in _displayCoords)then
            Canvas.TextOut(_SizeOfBorder+r*_SizeOfSquare+soffset,Height-_SizeOfBorder+boffset-y,abc[r+1]);
        end;

    Canvas.Pen:=_lineStyle;
    Canvas.MoveTo(0,0);
    Canvas.LineTo(Width-1,0);
    Canvas.LineTo(Width-1,Width-1);
    Canvas.LineTo(0,Width-1);
    Canvas.LineTo(0,0);

    Canvas.MoveTo(_SizeOfBorder-1,_SizeOfBorder-1);
    Canvas.LineTo(Width-_SizeOfBorder,_SizeOfBorder-1);
    Canvas.LineTo(Width-_SizeOfBorder,Width-_SizeOfBorder);
    Canvas.LineTo(_SizeOfBorder-1,Width-_SizeOfBorder);
    Canvas.LineTo(_SizeOfBorder-1,_SizeOfBorder-1);

    RestoreDC(Canvas.Handle,SavedDC);
end;

procedure  TChessBrd.DrawPieces;
var
    sq: Square;
    len: Integer;
begin
    if (Length(_position)<64) then len:=Length(_position)
        else len:=64;
    for sq:=A8 to Square(len) do
    begin
        if (_position[Integer(sq)]<>' ') then
            DrawPiece(sq,_position[Integer(sq)]);
    end;
end;

procedure  TChessBrd.DrawBoard;
var
    n,x,y,posx,posy,SavedDC,TempDC: Integer;
    Pic: TBitmap;
begin
    SavedDC:=SaveDC(Canvas.Handle);

    Canvas.CopyMode:=cmSrcCopy;
    Canvas.Brush.Style:=bsSolid;
    IntersectClipRect(Canvas.Handle,_SizeOfBorder,_SizeOfBorder,Width-_SizeOfBorder,Height-_SizeOfBorder);

    for n:=0 to 1 do
        begin
        TempDC:=SaveDC(Canvas.Handle);
        for x:=0 to 3 do
            for y:=0 to 7 do
            begin
                posx:=Boardx+(x*2+(n xor (y and 1)))*_SizeOfSquare;
                posy:=Boardy+y*_SizeOfSquare;
                ExcludeClipRect(Canvas.Handle,posx,posy,posx+_SizeOfSquare,posy+_SizeOfSquare);
            end;
        if n=0 then
            if BitmapExists(_SquareDark) then
                Pic:=_SquareDark
            else
            begin
                Pic:=nil;
                Canvas.Brush.Color:=_SquareColorDark;
                Canvas.Pen.Color:=_SquareColorDark;
            end
        else
            if BitmapExists(_SquareLight) then
                Pic:=_SquareLight
            else
            begin
                Pic:=nil;
                Canvas.Brush.Color:=_SquareColorLight;
                Canvas.Pen.Color:=_SquareColorLight;
            end;
        if (Pic<>nil) then
        begin
            for Y:=0 to Height div Pic.Height do
                for X:=0 to Width div Pic.Width do
                    Canvas.Draw(X*Pic.Width,Y*Pic.Height,Pic);
        end
        else
            Canvas.FillRect(Canvas.ClipRect);

        RestoreDC(Canvas.Handle,TempDC);
        end;

    DrawBoardLines;

    RestoreDC(Canvas.Handle,SavedDC);

end;

procedure  TChessBrd.DrawBoardLines;
var
    x: Integer;
begin
    if (_boardLines)then
    begin
        Canvas.Pen.Color:=_lineStyle.Color;
        for x:=1 to 7 do
        begin
            Canvas.MoveTo(BoardX+X*_SizeOfSquare,BoardY);
            Canvas.LineTo(BoardX+X*_SizeOfSquare,Height-BoardY);
            Canvas.MoveTo(BoardX,BoardY+X*_SizeOfSquare);
            Canvas.LineTo(Width-BoardX,BoardY+X*_SizeOfSquare);
        end;
    end;
end;


//-----------------------------------------------------------------------
// PUBLIC, Chess
//-----------------------------------------------------------------------

procedure TChessBrd.CancelThinking;
begin
    if(_CustomEngine=FALSE)and(Now<>nil)and(GameEnded=FALSE)then
    begin
        Now.StopThinkingNow:=TRUE;
        while (Now.Suspended=FALSE) do Application.ProcessMessages;
    end;
    StopThinking:=TRUE;
end;

procedure TChessBrd.Think;
var
    oldsq, newsq: Square;
begin
    if ((csDesigning in ComponentState)=FALSE)and
       ((csLoading in ComponentState)=FALSE) then
    begin
        if (_customEngine=FALSE) then
        begin
            Now.StopThinkingNow:=FALSE;
            Now.Resume;
        end
        else
        begin
            if (((_ComputerPlaysBlack)and(_WhiteToMove=FALSE))or
                ((_ComputerPlaysWhite)and(_WhiteToMove=TRUE)))and
                (@_calculate<>nil)and(stopThinking=FALSE) then
            begin
                oldSq:=None;
                newSq:=None;
                _calculate(Self,oldsq,newsq);
                if (stopThinking=FALSE)and(PerformMove(oldsq,newsq)=FALSE) then
                begin
                     if (@_failed<>nil) then
                         _failed(Self,oldsq,newsq);
                end;
            end;
        end;
    end;
end;


procedure TChessBrd.GetMoveList(var list:TStringList);
var
    c: Char;
    s: String;
    r,side: Integer;
    Label BreakOut;
begin
    for r:=FirstMove to LastMove do
     for side:=0 to 1 do
     begin
        if (r=LastMove)and(side=0)and(LastTurn=TRUE) then Exit;
        if (r>LastMove)or((r=LastMove)and(side=1)and(LastTurn=FALSE))then Exit;

        if (side=0) then  s:=IntToStr(r)+'. '
            else s:='              ';

        if (r=FirstMove)and(side=0)and(FirstTurn=FALSE)then
            s:=s+' ...   '
        else
            begin
            c:=Char(Integer('A')+XPos(MoveList[r,side].OldSquare)-1);
            s:=s+c;
            c:=char(Integer('0')+YPos(MoveList[r,side].OldSquare));
            s:=s+c;
            end;

        s:=s+'-';

        c:=char(Integer('A')+XPos(MoveList[r,side].NewSquare)-1);
        s:=s+c;
        c:=char(Integer('0')+YPos(MoveList[r,side].NewSquare));
        s:=s+c;
        list.Add(s);
    end;
end;

function TChessBrd.GetMove (moveno:Integer;whiteMoves: Boolean): MoveInfo;
begin
    temp.OldSquare:=None;
    temp.NewSquare:=None;
    temp.position:='init';
    temp.EnPassant:=None;

    if (moveno>LastMove)or((moveno=LastMove)and(LastTurn)and(whiteMoves=FALSE)) then
        begin
        Result:=temp;
        Exit;
        end;

    if (moveno<FirstMove)or((moveno=FirstMove)and(FirstTurn=FALSE)and(whiteMoves=TRUE))then
        begin
        Result:=temp;
        Exit;
        end;

    Result:=MoveList[moveno,1-Integer(whiteMoves)];
end;

//Squares are numbered from 1 - 64 (a8,b8...h1)
function TChessBrd.ColorOfSquare (sq:Square): Integer;
begin
    Result:=Integer (((Integer(sq)-1) and 1)=(((Integer(sq)-1) shr 3) and 1));
end;

function  TChessBrd.PieceToInt (piece: Char): Integer;
var
    i: String;
    r: Integer;
begin
    i:='PNBRQKpnbrqk';

    for r:=1 to 12 do
        if (piece=i[r]) then
            begin
            Result:=(PieceIndex[Trunc((r-1)/6),(r-1) mod 6]);
            Exit;
            end;
    Result:=-1;
end;


//returns color of the PIECE on a square
function TChessBrd.ColorOfPieceOnSquare (sq: Square): Integer;
begin
    Result:=NoPiece;
      if ((_position[Integer(sq)]>='b')and(_position[Integer(sq)]<='r'))then Result:=Black
 else if ((_position[Integer(sq)]>='B')and(_position[Integer(sq)]<='R'))then Result:=White;
end;

function TChessBrd.ColorOfPiece (piece:Char): Integer;
var
    i: String;
    r: Integer;
begin
    i:='NBRQnbrq';

    Result:=NoPiece;

    for r:=1 to 8 do
    begin
         if (piece=i[r]) then Break;
         if (r=8) then Exit;
    end;

    Result:=Integer ((piece>='B')and(piece<='R'));
end;


// Returns XPos of a int according to ChessBoard coordinates (A-H)
function TChessBrd.XPos (sq: Square): Integer;
begin
    Result:=(1+(Integer(sq)-1) mod 8);
end;

// Returns YPos of a int according to ChessBoard coordinates (1-8)
function TChessBrd.YPos (sq: Square): Integer;
begin
    Result:=8-((Integer(sq)-1) shr 3);
end;

function TChessBrd.MouseToSquare (x,y: Integer): Square;
begin
    if (x>=1)and(x<=8)and(y>=1)and (y<=8) then
        Result:=Square(8*(8-y)+x)
    else Result:=None;
end;


// Expects a two character string, for instance 'e4' and returns a Square value
function TChessBrd.StringToSquare (str: String): Square;
begin
   str:=Lowercase(str);
   Result:=None;
   if (Length(str)=2)and
      (Integer(str[1])>=Integer('a'))and
      (Integer(str[1])<=Integer('h'))and
      (Integer(str[2])>=Integer('1'))and
      (Integer(str[2])<=Integer('8')) then
       Result:=Square(Integer(str[1])-Integer('a')+1+8*(8-Integer(str[2])-Integer('0')));
end;

// Retrieves the coords of the upperleft corner of a square
// writes into x and y
procedure TChessBrd.SquareToCoords (sq: Square; var x,y: Integer);
var
    a,b: Integer;
begin
    a:=XPos(sq)-1;
    b:=8-YPos(sq);
    if (_whiteOnTop) then
    begin
        a:=7-a;
        b:=7-b;
    end;

    x:=BoardX+a*_SizeOfSquare;
    y:=BoardY+b*_SizeOfSquare;
end;

function TChessBrd.SetupPosition (pos: MoveInfo; moveno: Integer; whiteMoves:Boolean): Boolean;
var
    i: String;
    r,n: Integer;
    Label BreakOut;
begin
    Result:=FALSE;

    CancelThinking;

    i:=' pnbrqkPNBRQK';

    if  (moveno>200)or
        ((pos.EnPassant<>None)and(YPos(pos.EnPassant)<>3)and
         (YPos(pos.EnPassant)<>6)) then Exit;

    for r:=1 to 64 do
    begin
        for n:=1 to 13 do
        begin
            if (pos.position[r]=i[n]) then goto BreakOut;
        end;
        Exit;

    BreakOut:
    end;

    StrPCopy(@_position,pos.position);
    _whiteToMove:=_whiteToMove;
    FirstTurn:=_whiteToMove;
    _CurrentMove:=moveno;
    FirstMove:=moveno;

    _castlingallowed:=pos.Castling;
    _EnPassant:=pos.EnPassant;

    Paint;
    Result:=TRUE;
end;

procedure  TChessBrd.NewGame;
begin
    SetNewGame;
    Paint;
end;

procedure TChessbrd.SetNewGame;
begin
    CancelThinking;
    _position:='_rnbqkbnrpppppppp                                PPPPPPPPRNBQKBNR';

    _whiteToMove:=TRUE;
    _CurrentMove:=1;
    FirstMove:=1;
    FirstTurn:=TRUE;
    LastMove:=1;
    LastTurn:=TRUE;

    _EnPassant:=None;

    Include (_castlingallowed,WhiteKingSide);
    Include (_castlingallowed,WhiteQueenSide);
    Include (_castlingallowed,BlackKingSide);
    Include (_castlingallowed,BlackQueenSide);
end;



function TChessBrd.Move(oldSq,newSq: Square): Boolean;
begin
    CancelThinking;
    Result:=PerformMove(oldsq,newsq);
    stopThinking:=FALSE;
    Think;

end;


function TChessBrd.PerformMove (oldsq, newsq: Square): Boolean;
var
    check,draw,stillmove: Boolean;
    oldpiece: Char;
    sq: Square;
    r: Integer;
    bcount,wcount: Integer;
begin
    GameEnded:=FALSE;

    if (MoveIsLegal(oldsq,newsq)=FALSE)then
    begin
        Result:=FALSE;
        Exit;
    end;

    check:=(WhiteInCheckAfter(oldsq,newsq)or BlackInCheckAfter(oldsq,newsq));
    draw:=FALSE;

    MoveList[_CurrentMove,1-Integer(_whiteToMove)].position:=StrPas(@_position[1]);
    MoveList[_CurrentMove,1-Integer(_whiteToMove)].Castling:=_castlingallowed;
    MoveList[_CurrentMove,1-Integer(_whiteToMove)].EnPassant:=_EnPassant;
    MoveList[_CurrentMove,1-Integer(_whiteToMove)].OldSquare:=Square(oldsq);
    MoveList[_CurrentMove,1-Integer(_whiteToMove)].NewSquare:=Square(newsq);

    ClearSquare(oldsq);

    if (_AnimateMoves) and ((oldSq<>squareClick1)or(newSq<>squareClick2)) then
    begin
        DrawBoardLines;
        Animate (oldSq,newSq,_animationDelay);
    end;

    oldpiece:=_position[Integer(newsq)];
    _position[Integer(newsq)]:=_position[Integer(oldsq)];
    _position[Integer(oldsq)]:=' ';

    ClearSquare(newsq);
    DrawPiece(newsq,_position[Integer(newsq)]);
    DrawBoardLines;

    if (_whiteToMove=FALSE) then _CurrentMove:=_CurrentMove+1;
    _whiteToMove:=not _whiteToMove;

    LastMove:=_CurrentMove;
    LastTurn:=_whiteToMove;

    //Call OnLegalMove event handler
    if (@_legalmove<>nil) then
        _legalmove(Self,oldsq,newsq);

    //Eventually call OnCapture event handler (also in En Passant)
    if (oldpiece<>' ')and(@_capture<>nil)then
        _capture(Self,oldsq,newsq,oldpiece);

    //More to do if last move was a promotion
    if ((((_position[Integer(newsq)])='p')or(_position[Integer(newsq)]='P'))and
        ((YPos(newsq)=8) or (YPos(newsq)=1)))then
    begin
        if (@_promotion<>nil)then
        begin
             _promotion(Self,oldsq,newsq,PromoteTo);
        end;

        DoPromotion(newsq);
        check:=(WhiteInCheckAfter(newsq,newsq))or(BlackInCheckAfter(newsq,newsq));
    end;

    //More to do if last move was En Passant capture
    if (_EnPassant=newsq)then
    begin
        if (YPos(newsq)=6)and (_position[Integer(newsq)]='P') then
        begin
            sq:=MouseToSquare(XPos(newsq),5);
            if (@_capture<>nil)then
                _capture(Self,oldsq,newsq,_position[Integer(sq)]);
            _position[Integer(sq)]:=' ';
            ClearSquare(sq);
            DrawBoardLines;
        end
        else if (YPos(newsq)=3)and (_position[Integer(newsq)]='p')then
        begin
            sq:=MouseToSquare(XPos(newsq),4);
            if (@_capture<>nil)then
                _capture(Self,oldsq,newsq,_position[Integer(sq)]);
            _position[Integer(sq)]:=' ';
            ClearSquare(sq);
            DrawBoardLines;
        end;
    end;

    //More to do if last move allows En Passant continuation
    if (((_position[Integer(newsq)]='P')and(YPos(oldsq)=2)and(YPos(newsq)=4))or
        ((_position[Integer(newsq)]='p')and(YPos(oldsq)=7)and(YPos(newsq)=5)))then
    begin
        _EnPassant:=Square ((Integer(oldsq)+Integer(newsq)) shr 1);
    end

    else _EnPassant:=None;

    //More to do if last move was castling
    if (_position[Integer(newsq)]='K')and(oldsq=E1) then
    begin
        if (Square(newsq)=G1)then
        begin
            _position[Integer(F1)]:='R';
            _position[Integer(H1)]:=' ';
            ClearSquare(H1);
            DrawPiece(F1,'R');
            DrawBoardLines;
            if (@_castle<>nil)then
                _castle(Self,oldsq,newsq);
        end
        else if (Square(newsq)=C1)then
        begin
            _position[Integer(D1)]:='R';
            _position[Integer(A1)]:=' ';
            ClearSquare(A1);
            DrawPiece(D1,'R');
            DrawBoardLines;
            if (@_castle<>nil)then
                _castle(Self,oldsq,newsq);
        end;
    end
    else if (_position[Integer(newsq)]='k')and(Square(oldsq)=E8)then
    begin
        if (Square(newsq)=G8)then
        begin
            _position[Integer(F8)]:='r';
            _position[Integer(H8)]:=' ';
            ClearSquare(H8);
            DrawPiece(F8,'r');
            DrawBoardLines;
            if (@_castle<>nil)then
                _castle(Self,oldsq,newsq);
        end
        else if (Square(newsq)=C8)then
        begin
            _position[Integer(D8)]:='r';
            _position[Integer(A8)]:=' ';
            ClearSquare(A8);
            DrawPiece(D8,'r');
            DrawBoardLines;
            if (@_castle<>nil)then
                _castle(Self,oldsq,newsq);
        end;
    end;

    //Eventually Remove Castling Allowance

    case Square(oldsq) of
        //if a rook moved
        A1: begin
            Exclude(_castlingallowed,WhiteQueenSide);
            end;
        H1: begin
            Exclude (_castlingallowed,WhiteKingSide);
            end;
        A8: begin
            Exclude (_castlingallowed,BlackQueenSide);
            end;
        H8: begin
            Exclude (_castlingallowed,BlackKingSide);
            end;

        //or if a king moved
        E1: begin
            Exclude (_castlingallowed,WhiteQueenSide);
            Exclude (_castlingallowed,WhiteKingSide);
            end;
        E8: begin
            Exclude (_castlingallowed,BlackQueenSide);
            Exclude (_castlingallowed,BlackKingSide);
            end;
    end;

    //More to do if there's mate or stalemate

    stillmove:=LegalMoveAvailable();
    if (check)then
    begin
        if (@_check<>nil)then
            _check(Self,oldsq,newsq);
        if (stillmove=FALSE)and(@_mate<>nil)then
        begin
            GameEnded:=TRUE;
            _mate(Self,oldsq,newsq);
        end;
    end
    else
    begin
        if (stillmove=FALSE) then
        begin
            if (@_stalemate<>nil) then _stalemate(Self,oldsq,newsq);
            draw:=TRUE;

        end;
    end;

    //More to do if there's only no more mating material at all on the board
    bcount:=0;
    wcount:=0;
    for r:=1 to 64 do
    begin
         case _position[r] of
            'r': wcount:=wcount+5;
            'q': wcount:=wcount+5;
            'p': wcount:=wcount+5;
            'b': wcount:=wcount+3;
            'n': wcount:=wcount+2;
            'R': bcount:=bcount+5;
            'Q': bcount:=bcount+5;
            'P': bcount:=bcount+5;
            'B': bcount:=bcount+3;
            'N': bcount:=bcount+2;
        end;
    end;

    if (wcount<5)and(bcount<5) then
    begin
        if (@_noMatingMaterial<>nil) then _noMatingMaterial(Self);
        draw:=TRUE;
    end;

    MoveList[_CurrentMove,1-Integer(_whiteToMove)].position:=StrPas(@_position[1]);
    MoveList[_CurrentMove,1-Integer(_whiteToMove)].Castling:=_castlingallowed;
    MoveList[_CurrentMove,1-Integer(_whiteToMove)].enPassant:=_EnPassant;
    LastMove:=_CurrentMove;
    LastTurn:=_whiteToMove;

    // Or a Threefold Position in the game
    if (CheckForThreefoldPosition=TRUE) then
    begin
        if (@_threefoldPosition<>nil) then _threefoldPosition(Self);
        draw:=TRUE;
    end;

    if (draw)and(@_draw<>nil) then
    begin
        GameEnded:=TRUE;
        _draw(Self);
    end;

    if (@_paint<>nil) then _paint(Self);

    Result:=TRUE;
end;

function TChessBrd.MoveBackward: Boolean;
begin
     if (_whiteToMove)then
        Result:=(GotoMove  (_CurrentMove-1, FALSE))
     else Result:=(GotoMove (_CurrentMove, TRUE));
end;

function TChessBrd.MoveForward: Boolean;
begin
    if (_whiteToMove)then
        Result:=GotoMove  (_CurrentMove, FALSE)
    else Result:=GotoMove (_CurrentMove+1, TRUE);
end;


function TChessBrd.GotoMove (moveno: Integer; whiteMoves: Boolean): Boolean;
var
    oldpos: String;
begin

    Result:=FALSE;

    CancelThinking;

    if (moveno>LastMove)or((moveno=LastMove)and(LastTurn)and(whiteMoves=FALSE))then
    begin
        Exit;
    end;

    if (moveno<FirstMove)or((moveno=FirstMove)and(FirstTurn=FALSE)and(whiteMoves))then
    begin
        Exit;
    end;

    _CurrentMove:=moveno;
    _whiteToMove:=whiteMoves;

    oldpos   :=StrPas(@_position[1]);
    StrPCopy(@_position[1],MoveList[_CurrentMove,1-Integer(_whiteToMove)].position);
    _EnPassant:=MoveList[_CurrentMove,1-Integer(_whiteToMove)].EnPassant;
    _castlingallowed :=MoveList[_CurrentMove,1-Integer(_whiteToMove)].Castling;

    UpdateChessBoard(oldpos);

    Result:=TRUE;
end;

function  TChessBrd.LegalMoveAvailable: Boolean;
var
    r,n: Square;
begin
    Result:=TRUE;

    if (_whiteToMove)then
        begin
        for r:=A8 to H1 do
        if (ColorOfPieceOnSquare(Square(r))=White)then
            begin
            for n:=A8 to H1 do
                 if (MoveIsLegal(r,n)and (WhiteInCheckAfter(r,n)=FALSE))then
                     Exit;
            end;
        end
    else
        begin
        for r:=A8 to H1 do
        if (ColorOfPieceOnSquare(r)=Black)then
            begin
            for n:=A8 to H1 do
                 if (MoveIsLegal(r,n)and (BlackInCheckAfter(r,n)=FALSE))then
                    Exit;
            end;
        end;

    Result:=FALSE;
end;

//-------------------------------------------------------------
//-------------------PRIVATE Stuff here------------------------
//-------------------------------------------------------------

function TChessBrd.CheckForThreefoldPosition: Boolean;
var
    turn,t,move,m: Integer;
    count: Integer;
begin
    count:=0;

    move:=_CurrentMove;
    m:=move;

    if _WhiteToMove then turn:=0 else turn:=1;
    t:=turn;

    while (TRUE) do
        begin
        t:=t-1;
        if (t<0) then
            begin
            t:=1;
            m:=m-1;
            end;
        if (m<1) then Break;
        if MoveList[move,turn].position=MoveList[m,t].position then
            count:=count+1;
        end;

    Result:=(count>=2);
end;



function TChessBrd.MoveIsLegal (oldsq, newsq: Square): Boolean;
var
    piece: Char;
begin
    Result:=FALSE;

    piece:=Char(Integer(UpCase(_position[Integer(oldsq)]))+32);

    if (oldsq<A8)or(oldsq>H1)or(newsq<A8)or(newsq>H1)or
       (CheckForThreefoldPosition=TRUE) then
        Exit;

    //Turn to the right color ?
    if (_whiteToMove)then
        begin
        if (ColorOfPieceOnSquare(oldsq)<>White) then Exit;
        end
    else
        begin
        if (ColorOfPieceOnSquare(oldsq)<>Black) then Exit;
        end;
    // Old int does't contain a piece ?
    if (ColorOfPieceOnSquare(oldsq)=NoPiece) then
         Exit;

    // Can't take piece of own color
    if (ColorOfPieceOnSquare(oldsq)=ColorOfPieceOnSquare(newsq)) then
           Exit;

    Result:=TRUE;

    case piece of
        'p':  begin
              Result:=CheckLegalPawnMove(oldsq,newsq);
              end;
        'n':  begin
              Result:=CheckLegalKnightMove(oldsq,newsq);
              end;
        'b':  begin
              Result:=CheckLegalBishopMove(oldsq,newsq);
              end;
        'r':  begin
              Result:=CheckLegalRookMove(oldsq,newsq);
              end;
        'q':  begin
              Result:=CheckLegalQueenMove(oldsq,newsq);
              end;
        'k':  begin
              Result:=CheckLegalKingMove(oldsq,newsq);
              end;
    end;

    if (Result)then
        begin
        if (ColorOfPieceOnSquare(oldsq)=Black)and
            (BlackInCheckAfter(oldsq,newsq)=TRUE)then
             Result:=FALSE
        else if (ColorOfPieceOnSquare(oldsq)=White)and
            (WhiteInCheckAfter(oldsq,newsq)=TRUE)then
             Result:=FALSE;
        end;
end;

//Checks whether black is in check after the specified move
function TChessBrd.BlackInCheckAfter(oldsq, newsq: Square): Boolean;
var
    v: Char;
    pos: String;
    x,y,r,res: Integer;
    kingsq: Square;
begin
    Result:=TRUE;

    pos:=StrPas(@_position[1]);

    v:=pos[Integer(oldsq)];
    pos[Integer(oldsq)]:=' ';
    pos[Integer(newsq)]:=v;

    for r:=1 to 65 do
     begin
     res:=r;
     if (pos[r]='k') then
         Break;
     end;

    kingsq:=Square(res);
    if (res>64) then
        Exit;

    //pawn check
    for x:=-1 to 1 do
     if (x<>0)and(pos[Integer(MouseToSquare(XPos(kingsq)+x,YPos(kingsq)-1))]='P') then
       Exit;

    //knight check
    for y:=-1 to 1 do
     if (abs(y)=1) then
      for x:=-2 to 2 do
       if (abs(x)=2)and(pos[Integer(MouseToSquare(XPos(kingsq)+x,YPos(kingsq)+y))]='N')then
         Exit;

    for y:=-2 to 2 do
     if (abs(y)=2) then
      for x:=-1 to 1 do
       if (x<>0)and(pos[Integer(MouseToSquare(XPos(kingsq)+x,YPos(kingsq)+y))]='N')then
            Exit;

    //bishop (and queen) check
    for y:=-1 to 1 do
     if (y<>0) then
      for x:=-1 to 1 do
       if (x<>0) then
        for r:=1 to 7 do
         begin
          v:=pos[Integer(MouseToSquare(XPos(kingsq)+x*r,YPos(kingsq)+y*r))];
          if (v='Q')or(v='B')or((v='K')and(r=1))then
             Exit;
          if (v<>' ') then
             Break;
         end;

    //rook (and queen) check
    for x:=-1 to 1 do
     if (x<>0) then
        for r:=1 to 7 do
        begin
             v:=pos[Integer(MouseToSquare(XPos(kingsq)+x*r,YPos(kingsq)))];
             if (v='Q')or(v='R')or((v='K')and(r=1))then
             begin
                Exit;
             end;
             if (v<>' ')then
               Break;
        end;

    for y:=-1  to 1 do
      begin
      if (y<>0) then
        for r:=1  to 7 do
        begin
             v:=pos[Integer(MouseToSquare(XPos(kingsq),YPos(kingsq)+r*y))];
             if (v='Q')or(v='R')or ((v='K')and(r=1))then
                 begin
                 Result:=TRUE;
                 Exit;
                 end;
             if (v<>' ')then
                 Break;
        end;
      end;

Result:=FALSE;
end;

//Checks whether white is in check after the specified move
function TChessBrd.WhiteInCheckAfter(oldsq, newsq: Square): Boolean;
var
    x,y,r,res: Integer;
    kingsq: Square;
    v: Char;
    pos: String;
begin
    Result:=TRUE;

    pos:=StrPas(@_position[1]);

    //Can move to same Square
    v:=pos[Integer(oldsq)];
    pos[Integer(oldsq)]:=' ';
    pos[Integer(newsq)]:=v;

    for r:=1 to 65 do
       begin
       res:=r;
       if (pos[r]='K') then
          Break;
       end;
    kingsq:=Square(res);
    if (res>64) then
        begin
        Result:=FALSE;
        Exit;
        end;

    //pawn check
    for x:=-1 to 1 do
        if (x<>0)and(pos[Integer(MouseToSquare(XPos(kingsq)+x,YPos(kingsq)+1))]='p') then
            Exit;

    //knight check
    for y:=-1 to 1 do
     if(y<>0) then
      for x:=-2 to 2 do
        if (abs(x)=2)and(pos[Integer(MouseToSquare(XPos(kingsq)+x,YPos(kingsq)+y))]='n')then
            Exit;

    for y:=-2 to 2 do
     if (abs(y)=2)then
      for x:=-1 to 1 do
        if (x<>0)and (pos[Integer(MouseToSquare(XPos(kingsq)+x,YPos(kingsq)+y))]='n')then
          Exit;


    //bishop (and queen) check
    for y:=-1  to 1 do
      if (y<>0) then
        for x:=-1 to 1 do
            if (x<>0) then
             for r:=1 to 7 do
             begin
                  v:=pos[Integer(MouseToSquare(XPos(kingsq)+x*r,YPos(kingsq)+y*r))];
                  if (v='q')or(v='b')or ((v='k')and(r=1))then
                     Exit;
                  if (v<>' ') then
                    Break;
             end;

    //rook (and queen) check
    for x:=-1 to 1 do
     if (x<>0) then
       for r:=1 to 7 do
        begin
             v:=pos[Integer(MouseToSquare(XPos(kingsq)+x*r,YPos(kingsq)))];
             if (v='q')or(v='r')or((v='k')and(r=1))then
                Exit;
             if (v<>' ')then
                 break;
        end;

    for y:=-1 to 1 do
      if (y<>0) then
        for r:=1 to 7 do
          begin
            v:=pos[Integer(MouseToSquare(XPos(kingsq),YPos(kingsq)+r*y))];
            if (v='q')or(v='r')or((v='k')and(r=1))then
              Exit;
            if (v<>' ') then
              Break;
          end;

Result:=FALSE;
end;

//Checks whether a pawn move is legal, assuming the king isn't in check
function TChessBrd.CheckLegalPawnMove(oldsq,newsq: Square): Boolean;
var
    deltax: Integer;
begin
    Result:=TRUE;

    deltax:=abs(XPos(newsq)-XPos(oldsq));

    if (ColorOfPieceOnSquare(oldsq)=White)then
    begin
        if (YPos(newsq)=YPos(oldsq)+1)then
        begin
            if (deltax=0)then
                begin
                if (_position[Integer(newsq)]=' ')then
                    Exit;
                end
            else if (deltax=1)then
                begin
                if (ColorOfPieceOnSquare(newsq)=Black)or
                    (_EnPassant=newsq)then
                    Exit;
                end;
        end
        else if ((YPos(oldsq)=2)and (YPos(newsq)=4))then
        begin
            if (deltax=0)and(_position[Integer(newsq)]=' ')
               and  (_position[(Integer(oldsq)+Integer(newsq)) shr 1]=' ') then Exit;
        end;

    end
    else if (ColorOfPieceOnSquare(oldsq)=Black)then
    begin
        if (YPos(newsq)=YPos(oldsq)-1)then
        begin
            if (deltax=0)then
                begin
                if (_position[Integer(newsq)]=' ') then Exit;
                end
            else if (deltax=1)then
                begin
                if (ColorOfPieceOnSquare(newsq)=White)or
                    (_EnPassant=newsq)then
                     Exit;
                end;
        end
        else if (YPos(oldsq)=7)and(YPos(newsq)=5)then
        begin
            if (deltax=0)and(_position[Integer(newsq)]=' ')and
                (_position[Integer((Integer(oldsq)+Integer(newsq)) shr 1)]=' ')then
                    Exit;
        end;
    end;

Result:=FALSE;
end;

//Checks whether a knight move is legal, assuming the king isn't in check
function TChessBrd.CheckLegalKnightMove(oldsq,newsq: Square): Boolean;
var
    deltax,deltay: Integer;
begin
    deltax:=abs(XPos(oldsq)-XPos(newsq));
    deltay:=abs(YPos(oldsq)-YPos(newsq));
    Result:=(((deltax=2)and(deltay=1))or((deltax=1)and (deltay=2)));
end;

//Checks whether a bishop move is legal, assuming the king isn't in check
function  TChessBrd.CheckLegalBishopMove(oldsq, newsq: Square): Boolean;
var
    x,y,r,n,m,p: Integer;
    v: Square;
begin
    Result:=TRUE;

    x:=XPos(oldsq);
    y:=YPos(oldsq);
    p:=ColorOfPieceOnSquare(oldsq);

    for n:=-1 to 1 do
      if (n<>0) then
        for m:=-1 to 1 do
          if (m<>0) then
            for r:=1 to 7 do
             begin
              v:=MouseToSquare(x+n*r,y+m*r);
              if ((ColorOfPieceOnSquare(v)=NoPiece)or(ColorOfPieceOnSquare(v)<>p))then
               begin
                if (v=newsq) then Exit;
               end;
              if (ColorOfPieceOnSquare(v)<>NoPiece)then break;
             end;

    Result:=FALSE;
end;

//Checks whether a rook move is legal, assuming the king isn't in check
function TChessBrd.CheckLegalRookMove(oldsq, newsq: Square): Boolean;
var
    x,y,r,n,p: Integer;
    v: Square;
begin
    Result:=TRUE;

    x:=XPos(oldsq);
    y:=YPos(oldsq);
    p:=ColorOfPieceOnSquare(oldsq);

    for n:=-1 to 1 do
     if (n<>0) then
        for r:=1 to 7 do
         begin
            v:=MouseToSquare(x+n*r,y);
            if ((ColorOfPieceOnSquare(v)=NoPiece)or(ColorOfPieceOnSquare(v)<>p))then
            begin
                if (v=newsq) then Exit;
            end;
            if (ColorOfPieceOnSquare(v)<>NoPiece) then Break;
        end;

    for n:=-1 to 1 do
     if (n<>0) then
        for r:=1 to 7 do
        begin
            v:=MouseToSquare(x,y+n*r);
            if ((ColorOfPieceOnSquare(v)=NoPiece)or(ColorOfPieceOnSquare(v)<>p))then
            begin
                if (v=newsq) then Exit;
            end;
            if (ColorOfPieceOnSquare(v)<>NoPiece) then Break;
        end;

    Result:=FALSE;
end;

//Checks whether a queen move is legal, assuming the king isn't in check
function TChessBrd.CheckLegalQueenMove(oldsq, newsq: Square): Boolean;
begin
    Result:=CheckLegalBishopMove(oldsq,newsq);
    if (Result=FALSE) then Result:=CheckLegalRookMove(oldsq,newsq);
end;

//Checks whether a king move is legal, assuming the king isn't in check
function TChessBrd.CheckLegalKingMove(oldsq,newsq: Square): Boolean;
var
    deltax,deltay: Integer;
begin
    Result:=TRUE;

    deltax:=abs(XPos(oldsq)-XPos(newsq));
    deltay:=abs(YPos(oldsq)-YPos(newsq));

    if ((deltax<=1)and (deltay<=1))then
        Exit;

    if (Square(oldsq)=E1)and(Square(newsq)=G1)then
    begin
        if (WhiteKingSide in _castlingallowed) and  (_position[Integer(H1)]='R') and
            (_position[Integer(G1)]=' ') and  (_position[Integer(F1)]=' ') and
            (not WhiteInCheckAfter(E1,E1)) and
            (not WhiteInCheckAfter(E1,F1)) and
            (not WhiteInCheckAfter(E1,G1)) then
                Exit;
    end;
    if (oldsq=E1)and(newsq=C1) then
    begin
        if (WhiteQueenSide in _castlingallowed) and(_position[Integer(A1)]='R')and
           (_position[Integer(B1)]=' ')and(_position[Integer(C1)]=' ')and (_position[Integer(D1)]=' ') and
            (not WhiteInCheckAfter(E1,E1)) and
            (not WhiteInCheckAfter(E1,D1)) and
            (not WhiteInCheckAfter(E1,C1)) then
                Exit;
    end;
    if (oldsq=E8)and(newsq=G8)then
    begin
        if (BlackKingSide in _castlingallowed)and(_position[Integer(H8)]='r')and
            (_position[Integer(G8)]=' ')and(_position[Integer(F8)]=' ') and
            (not BlackInCheckAfter(E8,E8)) and
            (not BlackInCheckAfter(E8,F8))and
            (not BlackInCheckAfter(E8,G8)) then
                Exit;
    end;
    if (oldsq=E8)and(newsq=C8)then
    begin
        if (BlackQueenSide in _castlingallowed) and (_position[Integer(A8)]='r') and
           (_position[Integer(B8)]=' ')and(_position[Integer(C8)]=' ')and
           (_position[Integer(D8)]=' ')and
            (not BlackInCheckAfter(E8,E8)) and
            (not BlackInCheckAfter(E8,D8)) and
            (not BlackInCheckAfter(E8,C8)) then
                Exit;
    end;

    Result:=FALSE;
end;

procedure  TChessBrd.InitializeBitmap;
begin
      Default.Handle:=LoadBitmap(hInstance, StrPCopy(@buf,SetAndrew40Str));
end;

//-------------------------------------------------------------------------------
// Implementation of TChessThread (containing mainly Tom's Source)
//-------------------------------------------------------------------------------

constructor TChessThread.Create;
begin
    InitValues;
    inherited Create(TRUE);
end;


// The execution point of the thread
procedure TChessThread.Execute;
begin
    repeat
    begin
        if ((ComputerPlaysWhite^)and(WhiteToMove^))or
           ((ComputerPlaysBlack^)and(WhiteToMove^=FALSE)) then
        begin
             Priority:=ThinkingPriority^;
             Thinking:=TRUE;
             ThinkAboutAMove;
             if (StopThinkingNow=FALSE) then
             begin
                 makemove(pv[0,0].b);
                 gen;
                 Thinking:=FALSE;
                 Synchronize(PerformMove);
             end;
        end;
        Synchronize (ThinkingFinished)
    end;
    until (Terminated=TRUE);
end;

procedure TChessThread.ThinkAboutAMove;
var
    x,y,r,v,i: Integer;
    ch: Char;
begin
    for r:=0 to 63 do
    begin
        v:=ColorOfPiece(Square(r+1));
        if (v=Black) then color[r]:=DARK
        else if (v=White) then color[r]:=LIGHT
        else color[r]:=EMPTY;
        ch:=Position[r+1];
        if (Integer(ch)>=Integer('A'))and(Integer(ch)<=Integer('Z')) then
            ch:=Char(Byte(ch)+32);
        case ch of
            'p':piece[r]:=PAWN;
            'n':piece[r]:=KNIGHT;
            'b':piece[r]:=BISHOP;
            'r':piece[r]:=ROOK;
            'q':piece[r]:=QUEEN;
            'k':piece[r]:=KING;
           else piece[r]:=EMPTY;
        end;
    end;

    if (WhiteToMove^=TRUE)then
    begin
        side:=LIGHT;
        xside:=DARK;
    end
    else
    begin
        side:=DARK;
        xside:=LIGHT;
    end;

    castle:=0;
    if (WhiteKingSide in Castling^) then
        castle:=castle or 1;
    if (WhiteQueenSide in Castling^) then
        castle:=castle or 2;
    if (BlackKingSIde in Castling^) then
        castle:=castle or 4;
    if (BlackQueenSide in Castling^) then
        castle:=castle or 8;

    ep:=Integer(EnPassant^)-1;
    fifty:=0;
    ply:=0;
    gen_begin[0]:=0;

    nodes:=0;
    init_eval;

    for x:=0 to 63 do
    for y:=0 to 63 do
        history[x,y]:=0;

    follow_pv:=TRUE;

    for i:=1 to SearchDepth^ do
    begin
        if (StopThinkingNow=FALSE) then
        begin
            follow_pv:=TRUE;
            search(-10000,10000,i);
        end;
    end;

end;

//---------------------------------------------------------------------------
// Synchronized Methods
//---------------------------------------------------------------------------

procedure TChessThread.ThinkingFinished;
begin
    EndFunc(Self);
end;

// Synchronizer - Modifies VCL
procedure TChessThread.PerformMove;
begin
     if (Movefunc(Square(Integer(pv[0,0].b.src)+1),Square(Integer(pv[0,0].b.dst)+1))=FALSE) then
     begin
//       Tom's engine does not recognize the threefold position rule
//       so the exception may occur after a draw.
//
//       raise EChessException.Create('Engine tried to perform illegal move');
     end
end;

procedure TChessThread.IntCopy (dest,source: pInt; count: Integer);
var
   r: Integer;
begin
    if (dest=nil)or(source=nil) then Exit;
    for r:=1 to count do
    begin
        dest^:=source^;
        Inc(source);
        Inc(dest);
    end;
end;


function TChessThread.ColorOfPiece (sq: Square): Integer;
begin
    if (Position[Integer(sq)]>='b')and(Position[Integer(sq)]<='r') then Result:=Black
    else if (Position[Integer(sq)]>='B')and(Position[Integer(sq)]<='R') then Result:=White
    else Result:=NoPiece;
end;


// sort_pv() is called when the search function is following
// the PV (Principal Variation). It looks through the current
// ply's move list to see if the PV move is there. If so,
// it adds 10,000,000 to the move's score so it's played first
// by the search function. If not, follow_pv remains FALSE and
// search() stops calling sort_pv().

procedure TChessThread.sort_pv;
var
    i: Integer;
    m1,m2: Move_Bytes;
begin
    follow_pv:=FALSE;
    for i:=gen_begin[ply] to gen_end[ply]-1 do
    begin
        m1:=gen_dat[i].m.b;
        m2:=pv[0,ply].b;

        if(m1.src=m2.src)and(m2.dst=m2.dst)then
//            (m1.promote=m2.promote)and(m1.bits=m2.bits)then
        begin
            follow_pv:=TRUE;
            gen_dat[i].score:=gen_dat[i].score+10000000;
            Exit;
        end;
    end;
end;

// sort() searches the current ply's move list from 'from'
// to the end to find the move with the highest score. Then it
// swaps that move and the 'from' move so the move with the
// highest score gets searched next, and hopefully produces
// a cutoff.
procedure TChessThread.sort(src: Integer);
var
   i:  Integer;
   bs: Integer;  // best score
   bi: Integer;  // best i
   g:  gen_rec;
begin
    bs:=-1;
    bi:=0;
    for i:=src to gen_end[ply]-1 do
    begin
        if(gen_dat[i].score>bs) then
        begin
            bs:=gen_dat[i].score;
            bi:=i;
        end;
    end;

    g:=gen_dat[src];
    gen_dat[src]:=gen_dat[bi];
    gen_dat[bi]:=g;
end;


// quiesce() is a recursive minimax search function with
// alpha-beta cutoffs. In other words, negamax. It basically
// only searches capture sequences and allows the evaluation
// function to cut the search off (and set alpha). The idea
// is to find a position where there isn't a lot going on
// so the static evaluation function will work.
function TChessThread.quiesce(alpha,beta: Integer): Integer;
var
    i,j,x: Integer;
    c,f: Boolean;
begin
    nodes:=nodes+1;
    pv_length[ply]:=ply;
    c:=in_check(side);

    // if we're in check, try all moves to get out. (not
    // necessary, just something I decided to do)
    // otherwise, use the evaluation function.

    if(c) then
    begin
        gen;
    end
    else
    begin
        x:=eval;
        if(x>=beta) then
        begin
            Result:=beta;
            Exit;
        end;
        if(x>alpha) then
            alpha:=x;
        gen_caps;
    end;

    if(follow_pv) then  sort_pv;     // are we following the PV?

    f:=FALSE;

    // loop through the moves
    for i:=gen_begin[ply] to gen_end[ply]-1 do
    begin
        sort(i);
        if(makemove(gen_dat[i].m.b)=FALSE) then
            continue;
        f:=TRUE;  // we found a legal move!
        x:=-quiesce(-beta,-alpha);
        takeback;
        if(x>alpha) then
        begin
            if(x>=beta) then
            begin
                Result:=beta;
                Exit;
            end;

            alpha:=x;

            // update the PV
            pv[ply,ply]:=gen_dat[i].m;
            for j:=ply+1 to pv_length[ply+1]-1 do
            begin
                pv[ply,j]:=pv[ply+1,j];
            end;
            pv_length[ply]:=pv_length[ply+1];
        end;
    end;

    // if we're in check and there aren't any legal moves,
    // well, we lost

    if(f=false)and(c=true) then
        Result:=(-10000+ply)
    else Result:=alpha;
end;

// search() does just that, in negamax fashion
function TChessThread.search(alpha,beta,depth: Integer): Integer;
var
    i,j,x: Integer;
    c,f: Boolean;
begin
    if (StopThinkingNow=FALSE) then
    begin
        // we're as deep as we want to be; call quiesce() to get
        // a reasonable score and return it.

        if(depth=0) then
        begin
            Result:=quiesce(alpha,beta);
            Exit;
        end;

        nodes:=nodes+1;
        pv_length[ply]:=ply;

        // are we in check? if so, we want to search deeper
        c:=in_check(side);
        if(c) then
            depth:=depth+1;

        gen;
        if(follow_pv) then  // are we following the PV?
            sort_pv;
        f:=FALSE;

        // loop through the moves
        for i:=gen_begin[ply] to gen_end[ply]-1 do
        begin
            if (StopThinkingNow) then Break;

            sort(i);
            if(makemove(gen_dat[i].m.b)=FALSE)then
                continue;

            f:=TRUE;

            x:=-search(-beta,-alpha,depth-1);

            takeback;

            if(x>alpha) then
            begin
                // this move caused a cutoff, so increase the history
                // value so it gets ordered high next time we can
                // search it

                history[Integer(gen_dat[i].m.b.src),Integer(gen_dat[i].m.b.dst)]:=
                history[Integer(gen_dat[i].m.b.src),Integer(gen_dat[i].m.b.dst)]+depth;

                if(x>=beta) then
                begin
                    Result:=beta;
                    Exit;
                end;

                alpha:=x;

                // update the PV
                pv[ply,ply]:=gen_dat[i].m;
                for j:=ply+1 to pv_length[ply+1]-1 do
                begin
                    pv[ply,j]:=pv[ply+1,j];
                end;

                pv_length[ply]:=pv_length[ply+1];
            end;
        end;

        // no legal moves? then we're in checkmate or stalemate
        if(f=false) then
        begin
            if(c) then
            begin
                Result:=(-10000+ply);
                Exit;
            end
            else
            begin
                Result:=0;
                Exit;
            end;
        end;

        // fifty move draw rule

        if(fifty>100) then
            Result:=0 else
        Result:=alpha;
    end
    else Result:=0;
end;

// in_check() returns TRUE if side s is in check and FALSE
// otherwise. It just scans the board to find side s's king
// and calls attack() to see if it's being attacked.
function TChessThread.in_check(s: Integer): Boolean;
var
    i: Integer;
begin
    for i:=0 to 63 do
    begin
        if(color[i]=s)and(piece[i]=KING)then
        begin
            Result:=attack(i,s xor 1);
            Exit;
        end;
    end;
    Result:=FALSE;
end;

// attack returns TRUE if square sq is being attacked by side
// s and FALSE otherwise.
function TChessThread.attack(sq,s: Integer ): Boolean;
var
    r,i,j,n: Integer;
begin
    for i:=0 to 63 do
    begin
        if(color[i]=s) then
         begin
            if(piece[i]=PAWN)then
             begin
                if(s=LIGHT) then
                begin
                    if ((i and 7)<>0)and(i-9=sq) then
                    begin
                        Result:=TRUE;
                        Exit;
                    end;
                    if((i and 7)<>7)and(i-7=sq) then
                    begin
                        Result:=TRUE;
                        Exit;
                    end;
                end
                else
                begin
                    if((i and 7)<>0)and(i+7=sq) then
                    begin
                        Result:=TRUE;
                        Exit;
                    end;
                    if((i and 7)<>7)and(i+9=sq) then
                    begin
                        Result:=TRUE;
                        Exit;
                    end;
                end;
            end
            else
                for j:=0 to offsets[piece[i]]-1 do
                begin
                    n:=i;
                    for r:=1 to $FFFF do
                    begin
                        n:=mailbox[mailbox64[n]+offset[piece[i],j]];
                        if (n=-1) then Break;
                        if (n=sq) then
                        begin
                            Result:=TRUE;
                            Exit;
                        end;
                        if(color[n]<>EMPTY)or(slide[piece[i]]=FALSE) then Break;
                    end;
                end;
         end;
    end;
    Result:=FALSE;
end;


// gen() generates pseudo-legal moves for the current position.
// It scans the board to find friendly pieces and then determines
// what squares they attack. When it finds a piece/square
// combination, it calls gen_push to put the move on the "move
// stack."

procedure TChessThread.gen;
var
    r,i,j,n: Integer;
begin

    // so far, we have no moves for the current ply
    gen_end[ply]:=gen_begin[ply];
    for i:=0 to 63 do
    begin
        if(color[i]=side) then
        begin
            if(piece[i]=PAWN) then
            begin
                if(side=LIGHT) then
                 begin
                    if((i and 7)<>0)and(color[i-9]=DARK) then
                        gen_push(i,i-9,17);

                    if((i and 7)<>7) and (color[i-7]=DARK) then
                        gen_push(i,i-7,17);
                    if(color[i-8]=EMPTY) then
                    begin
                        gen_push(i,i-8,16);
                        if(i>=48)and(color[i-16]=EMPTY) then
                            gen_push(i,i-16,24);
                    end;
                end
                else
                begin
                    if((i and 7)<>0)and(color[i+7]=LIGHT) then
                        gen_push(i,i+7,17);
                    if((i and 7)<>7)and(color[i+9]=LIGHT) then
                        gen_push(i,i+9,17);
                    if(color[i+8]=EMPTY) then
                    begin
                        gen_push(i,i+8,16);
                        if(i<=15)and(color[i+16]=EMPTY) then
                            gen_push(i,i+16,24);
                    end;
                end;
            end
            else
            begin
                for j:=0 to offsets[piece[i]]-1 do
                begin
                    n:=i;
                    for r:=1 to $FFFF do
                    begin
                        n:=mailbox[mailbox64[n]+offset[piece[i],j]];
                        if(n=-1) then  Break;
                        if(color[n]<>EMPTY) then
                        begin
                            if(color[n]=xside) then
                                gen_push(i,n,1);
                            break;
                        end;
                        gen_push(i,n,0);

                        if (slide[piece[i]]=FALSE) then Break;
                    end;
                end;
            end;
        end;
    end;


    // generate castle moves
    if(side=LIGHT) then
    begin
     if((castle and 1)<>0) then
            gen_push(60,62,2);
        if((castle and 2)<>0) then
            gen_push(60,58,2);
    end
    else
    begin
        if((castle and 4)<>0)then
            gen_push(4,6,2);
        if((castle and 8)<>0) then
            gen_push(4,2,2);
    end;

    // generate en passant moves
    if(ep<>-1) then
    begin
        if(side=LIGHT) then
        begin
            if((ep and 7)<>0) and(color[ep+7]=LIGHT)and(piece[ep+7]=PAWN)then
                gen_push(ep+7,ep,21);
            if((ep and 7)<>7)and(color[ep+9]=LIGHT)and(piece[ep+9]=PAWN)then
                gen_push(ep+9,ep,21);
        end
        else
        begin
            if((ep and 7)<>0)and(color[ep-9]=DARK)and(piece[ep-9]=PAWN)then
                gen_push(ep-9,ep,21);
            if((ep and 7)<>7)and(color[ep-7]=DARK)and(piece[ep-7]=PAWN)then
                gen_push(ep-7,ep,21);
        end;
    end;

    // the next ply's moves need to start where the current
    // ply's end
    gen_begin[ply+1]:=gen_end[ply];
end;


// gen_caps() is basically a copy of gen() that's modified to
// only generate capture and promote moves. It's used by the
// quiescence search.
procedure TChessThread.gen_caps;
var
    r,i,j,n: Integer;
begin
    gen_end[ply]:=gen_begin[ply];
    for i:=0 to 63 do
    begin
        if(color[i]=side) then
        begin
            if(piece[i]=PAWN) then
            begin
                if(side=LIGHT) then
                begin
                    if((i and 7)<>0)and(color[i-9]=DARK)then
                        gen_push(i,i-9,17);
                    if((i and 7)<>7)and(color[i-7]=DARK)then
                        gen_push(i,i-7,17);
                    if(i<=15)and(color[i-8]=EMPTY)then
                        gen_push(i,i-8,16);
                end;
                if(side=DARK) then
                begin
                    if((i and 7)<>0)and(color[i+7]=LIGHT)then
                        gen_push(i,i+7,17);
                    if((i and 7)<>7)and(color[i+9]=LIGHT)then
                        gen_push(i,i+9,17);
                    if(i>=48)and(color[i+8]=EMPTY)then
                        gen_push(i,i+8,16);
                end;
            end
            else
                for j:=0 to offsets[piece[i]]-1 do
                begin
                    n:=i;
                    for r:=1 to $FFFF do
                    begin
                        n:=mailbox[mailbox64[n]+offset[piece[i],j]];
                        if(n=-1) then Break;
                        if(color[n]<>EMPTY) then
                        begin
                            if(color[n]=xside)then
                                gen_push(i,n,1);
                            break;
                        end;
                        if (slide[piece[i]]=FALSE) then Break;
                    end;
                end;
        end;
    end;

    if(ep<>-1) then
    begin
        if(side=LIGHT) then
        begin
            if((ep and 7)<>0)and(color[ep+7]=LIGHT)and(piece[ep+7]=PAWN)then
                gen_push(ep+7,ep,21);
            if((ep and 7)<>7)and(color[ep+9]=LIGHT)and(piece[ep+9]=PAWN)then
                gen_push(ep+9,ep,21);
        end
        else
        begin
            if((ep and 7)<>0)and(color[ep-9]=DARK)and(piece[ep-9]=PAWN)then
                gen_push(ep-9,ep,21);
            if((ep and 7)<>7)and(color[ep-7]=DARK)and(piece[ep-7]=PAWN)then
                gen_push(ep-7,ep,21);
        end;
    end;
    gen_begin[ply+1]:=gen_end[ply];
end;


// gen_push() puts a move on the move stack, unless it's a
// pawn promotion that needs to be handled by gen_promote().
// It also assigns a score to the move for alpha-beta move
// ordering. If the move is a capture, it uses MVV/LVA
// (Most Valuable Victim/Least Valuable Attacker). Otherwise,
// it uses the move's history heuristic value. Note that
// 1,000,000 is added to a capture move's score, so it
// always gets ordered above a "normal" move.

procedure TChessThread.gen_push(src,dst,bits: Integer);
var
    g: pGenRec;
begin
    if((bits and 16)<>0) then
    begin
        if(side=LIGHT) then
        begin
            if(dst<=8) then
            begin
                gen_promote(src,dst,bits);
                Exit;
            end;
        end
        else
        begin
            if(dst>=56) then
            begin
                gen_promote(src,dst,bits);
                Exit;
            end;
        end;
    end;

    g:=@gen_dat[gen_end[ply]];
    gen_end[ply]:=gen_end[ply]+1;
    g^.m.b.src:=src;
    g^.m.b.dst:=dst;
    g^.m.b.promote:=0;
    g^.m.b.bits:=bits;
    if((bits and 1)<>0) then
        g^.score:=1000000+(piece[dst]*10)-piece[src]
    else
        g^.score:=history[src,dst];
end;


// gen_promote() is just like gen_push(), only it puts 4 moves
// on the move stack, one for each possible promotion piece
procedure TChessThread.gen_promote(src,dst,bits: Integer);
var
    i: Integer;
    g: pGenRec;
begin
    for i:=KNIGHT to QUEEN do
    begin
        g:=@gen_dat[gen_end[ply]];
        gen_end[ply]:=gen_end[ply]+1;
        g^.m.b.src:=src;
        g^.m.b.dst:=dst;
        g^.m.b.promote:=i;
        g^.m.b.bits:=(bits or 32);
        g^.score:=1000000+(i*10);
    end;
end;


// makemove() makes a move. If the move is illegal, it
// undoes whatever it did and returns FALSE. Otherwise, it
// returns TRUE.
function TChessThread.makemove(m: move_bytes): Boolean;
begin

    // test to see if a castle move is legal and move the rook
    // (the king is moved with the usual move code later)

    if((m.bits and 2)<>0) then
    begin
        if(in_check(side)) then
        begin
            Result:=FALSE;
            Exit;
        end;
        case (m.dst) of
            62: begin;
                    if(color[61]<>EMPTY)or(color[62]<>EMPTY)or
                      (attack(61,xside))or(attack(62,xside)) then
                    begin
                        Result:=FALSE;
                        Exit;
                    end;
                    color[61]:=LIGHT;
                    piece[61]:=ROOK;
                    color[63]:=EMPTY;
                    piece[63]:=EMPTY;
                end;
            58: begin
                    if(color[57]<>EMPTY)or(color[58]<>EMPTY)or(color[59]<>EMPTY)or
                        (attack(58,xside))or(attack(59,xside)) then
                    begin
                        Result:=FALSE;
                        Exit;
                    end;
                    color[59]:=LIGHT;
                    piece[59]:=ROOK;
                    color[56]:=EMPTY;
                    piece[56]:=EMPTY;
                end;
            6:  begin
                    if(color[5]<>EMPTY)or(color[6]<>EMPTY)or
                      (attack(5,xside))or(attack(6,xside)) then
                    begin
                        Result:=FALSE;
                        Exit;
                    end;
                    color[5]:=DARK;
                    piece[5]:=ROOK;
                    color[7]:=EMPTY;
                    piece[7]:=EMPTY;
                end;
            2:  begin
                if(color[1]<>EMPTY)or(color[2]<>EMPTY)or(color[3]<>EMPTY)or
                        attack(2,xside)or attack(3,xside) then
                begin
                    Result:=FALSE;
                    Exit;
                end;
                color[3]:=DARK;
                piece[3]:=ROOK;
                color[0]:=EMPTY;
                piece[0]:=EMPTY;
                end;
        end;
    end;

    // back up information so we can take the move back later.
    hist_dat[ply].m.b:=m;
    hist_dat[ply].capture:=piece[m.dst];
    hist_dat[ply].castle:=castle;
    hist_dat[ply].ep:=ep;
    hist_dat[ply].fifty:=fifty;
    ply:=ply+1;

    // update the castle, en passant, and
    // fifty-move-draw variables
    castle:=castle and (castle_mask[m.src] and castle_mask[m.dst]);
    if((m.bits and 8)<>0) then
    begin
        if(side=LIGHT) then
            ep:=m.dst+8
        else
            ep:=m.dst-8;
    end
    else
        ep:=-1;
    if((m.bits and 17)<>0) then
        fifty:=0
    else
        fifty:=fifty+1;

    // move the piece
    color[m.dst]:=side;
    if((m.bits and 32)<>0) then
        piece[m.dst]:=m.promote
    else
        piece[m.dst]:=piece[m.src];
    color[m.src]:=EMPTY;
    piece[m.src]:=EMPTY;

    // erase the pawn if this is an en passant move
    if((m.bits and 4)<>0) then
    begin
        if(side=LIGHT) then
        begin
            color[m.dst+8]:=EMPTY;
            piece[m.dst+8]:=EMPTY;
        end
        else
        begin
            color[m.dst-8]:=EMPTY;
            piece[m.dst-8]:=EMPTY;
        end;
    end;

    // switch sides and test for legality (if we can capture
    // the other guy's king, it's an illegal position and
    // we need to take the move back)
    side:=side xor 1;
    xside:=xside xor 1;
    if(in_check(xside)) then
    begin
        takeback();
        Result:=FALSE;
        Exit;
    end;
    Result:=TRUE;
end;


// takeback() is very similar to makemove(), only backwards :)
procedure TChessThread.takeback;
var
    m: move_bytes;
    src,dst: Integer;
begin
    src:=0;
    dst:=0;
    side:=side xor 1;
    xside:=xside xor 1;
    ply:=ply-1;
    m:=hist_dat[ply].m.b;
    castle:=hist_dat[ply].castle;
    ep:=hist_dat[ply].ep;
    fifty:=hist_dat[ply].fifty;
    color[m.src]:=side;
    if((m.bits and 32)<>0) then
        piece[m.src]:=PAWN
    else
        piece[m.src]:=piece[m.dst];
    if(hist_dat[ply].capture=EMPTY) then
    begin
        color[m.dst]:=EMPTY;
        piece[m.dst]:=EMPTY;
    end
    else
    begin
        color[m.dst]:=xside;
        piece[m.dst]:=hist_dat[ply].capture;
    end;
    if((m.bits and 2)<>0) then
    begin
        case(m.dst) of
            62: begin src:=61; dst:=63; end;
            58: begin src:=59; dst:=56; end;
            6:  begin src:=5;  dst:=7; end;
            2:  begin src:=3;  dst:=0; end;
        end;
        color[dst]:=side;
        piece[dst]:=ROOK;
        color[src]:=EMPTY;
        piece[src]:=EMPTY;
    end;
    if((m.bits and 4)<>0) then
    begin
        if(side=LIGHT) then
        begin
            color[m.dst+8]:=xside;
            piece[m.dst+8]:=PAWN;
        end
        else
        begin
            color[m.dst-8]:=xside;
            piece[m.dst-8]:=PAWN;
        end;
    end;
end;


function TChessThread.eval: Integer;
var
    x,y,i,c,xc,f: Integer;
    score: Array[0..1]of Integer; //score for each side
    pawns: Array[0..1,0..9] of Integer; // the number of pawns of each color on each file
begin
    score[DARK]:=0;
    score[LIGHT]:=0;

    //memset(pawns,0,sizeof(pawns));

    for x:=0 to 1 do
    for y:=0 to 9 do
        pawns[x,y]:=0;

    // loop through to set up the pawns array and to add up the
    // piece/square table values for each piece.
    for i:=0 to 63 do
    begin
        if(color[i]=EMPTY) then continue;
        if(piece[i]=PAWN) then
            pawns[color[i],(i and 7)+1]:=
            pawns[color[i],(i and 7)+1]+1;
        score[color[i]]:=score[color[i]]+pcsq[color[i],piece[i],i];
    end;

    // now that we have the pawns array set up, evaluate the pawns and rooks
    for i:=0 to 63 do
    begin
        if(color[i]=EMPTY) then continue;
        c:=color[i];  // set up c, xc, and f so we don't have to type a lot
        xc:=c xor 1;
        f:=(i and 7)+1;
        if(piece[i]=PAWN) then
        begin
            if(pawns[c,f]>1) then  // this pawn is doubled
                score[c]:=score[c]-5;
            if(pawns[c,f-1]=0)and(pawns[c,f+1]=0)then
            begin                  // isolated
                score[c]:=score[c]-20;
                if(pawns[xc,f]=0) then
                    score[c]:=score[c]-10;
            end;
            if(pawns[xc,f-1]=0)and  // passed
                    (pawns[xc,f]=0)and(pawns[xc,f+1]=0) then
                score[c]:=score[c]+2*pcsq[c,PAWN,i];
        end;
        if(piece[i]=ROOK) then
        begin
            if(pawns[c,f]=0) then
            begin  // the rook is on a half-open file
                score[c]:=score[c]+10;
                if(pawns[xc,f]=0) then // actually, it's totally open
                    score[c]:=score[c]+5;
            end;
        end;
    end;

    // return the score relative to the side to move (i.e.,
    // a positive score means the side to move is winning)
    if(side=LIGHT) then
    begin
        Result:=(score[LIGHT]-score[DARK]);
    end
    else Result:=(score[DARK]-score[LIGHT]);
end;

procedure TChessThread.init_eval;
var
    x,y,z,i,material,king_sq: Integer;
begin
    king_sq:=0;

    for x:=0 to 1 do
    for y:=0 to 5 do
    for z:=0 to 63 do
        pcsq[x,y,z]:=0;


    // initialize the no-brainer piece/square tables
    for i:=0 to 63 do
    begin
        pcsq[LIGHT,BISHOP,i]:=value[BISHOP]+minor_pcsq[i];
        pcsq[LIGHT,KNIGHT,i]:=value[KNIGHT]+minor_pcsq[i];
        pcsq[LIGHT,PAWN,i]  :=value[PAWN]+pawn_pcsq[i];
        pcsq[LIGHT,QUEEN,i] :=value[QUEEN];
        pcsq[LIGHT,ROOK,i]  :=value[ROOK];
        pcsq[DARK,BISHOP,i] :=value[BISHOP]+minor_pcsq[flip[i]];
        pcsq[DARK,KNIGHT,i] :=value[KNIGHT]+minor_pcsq[flip[i]];
        pcsq[DARK,PAWN,i]   :=value[PAWN]+pawn_pcsq[flip[i]];
        pcsq[DARK,QUEEN,i]  :=value[QUEEN];
        pcsq[DARK,ROOK,i]   :=value[ROOK];
    end;

    // now scan the board to see how much piece material the
    //   enemy has and figure out what side of the board the
    //   king is on
    material:=0;
    for i:=0 to 63 do
    begin
        if(color[i]=DARK)and(piece[i]<>PAWN)then
            material:=material+value[piece[i]];
        if(color[i]=LIGHT)and(piece[i]=KING)then
            king_sq:=i;
    end;
    if(material>1400)then
     begin  // use the middlegame tables
        for i:=0 to 63 do
            pcsq[LIGHT,KING,i]:=king_pcsq[i];
        if((king_sq and 7)>=5) then
            for i:=0 to 63 do
                pcsq[LIGHT,PAWN,i]:=
                pcsq[LIGHT,PAWN,i]+kingside_pawn_pcsq[i];
        if((king_sq and 7)<=2) then
            for i:=0 to 63 do
                pcsq[LIGHT,PAWN,i]:=
                pcsq[LIGHT,PAWN,i]+queenside_pawn_pcsq[i];
    end
    else
        for i:=0 to 63 do
            pcsq[LIGHT,KING,i]:=endgame_king_pcsq[i];

    // do the same for black
    material:=0;
    for i:=0 to 63 do
    begin
        if(color[i]=LIGHT)and(piece[i]<>PAWN)then
            material:=material+value[piece[i]];
        if(color[i]=DARK)and(piece[i]=KING)then
            king_sq:=i;
    end;
    if(material>1400) then
    begin
        for i:=0 to 63 do
            pcsq[DARK,KING,i]:=king_pcsq[flip[i]];
        if((king_sq and 7)>=5) then
            for i:=0 to 63 do
                pcsq[DARK,PAWN,i]:=
                pcsq[DARK,PAWN,i]+kingside_pawn_pcsq[flip[i]];
        if((king_sq and 7)<=2) then
            for i:=0 to 63 do
                pcsq[DARK,PAWN,i]:=
                pcsq[DARK,PAWN,i]+queenside_pawn_pcsq[flip[i]];
    end
    else
        for i:=0 to 63 do
            pcsq[DARK,KING,i]:=endgame_king_pcsq[flip[i]];
end;

procedure TChessThread.InitValues;
const
    _flip: Array[0..63] of Integer=(
              56,  57,  58,  59,  60,  61,  62,  63,
              48,  49,  50,  51,  52,  53,  54,  55,
              40,  41,  42,  43,  44,  45,  46,  47,
              32,  33,  34,  35,  36,  37,  38,  39,
              24,  25,  26,  27,  28,  29,  30,  31,
              16,  17,  18,  19,  20,  21,  22,  23,
               8,   9,  10,  11,  12,  13,  14,  15,
               0,   1,   2,   3,   4,   5,   6,   7);

    _pawn_pcsq: Array[0..63] of Integer=(
              0,   0,   0,   0,   0,   0,   0,   0,
              5,  10,  15,  20,  20,  15,  10,   5,
              4,   8,  12,  16,  16,  12,   8,   4,
              3,   6,   9,  12,  12,   9,   6,   3,
              2,   4,   6,   8,   8,   6,   4,   2,
              1,   2,   3,   4,   4,   3,   2,   1,
              0,   0,   0, -20, -20,   0,   0,   0,
              0,   0,   0,   0,   0,   0,   0,   0);

    _kingside_pawn_pcsq: Array[0..63] of Integer=(
              0,   0,   0,   0,   0,   0,   0,   0,
              0,   0,   0,   0,   0,   0,   0,   0,
              0,   0,   0,   0,   0,   0,   0,   0,
              0,   0,   0,   0,   0,   0,   0,   0,
              0,   0,   0,   0,   0,   5,   5,   5,
              0,   0,   0,   0,   0,  10,  10,  10,
              0,   0,   0,   0,   0,  20,  20,  20,
              0,   0,   0,   0,   0,   0,   0,   0);

    _queenside_pawn_pcsq: Array[0..63] of Integer=(
              0,   0,   0,   0,   0,   0,   0,   0,
              0,   0,   0,   0,   0,   0,   0,   0,
              0,   0,   0,   0,   0,   0,   0,   0,
              0,   0,   0,   0,   0,   0,   0,   0,
              5,   5,   5,   0,   0,   0,   0,   0,
             10,  10,  10,   0,   0,   0,   0,   0,
             20,  20,  20,   0,   0,   0,   0,   0,
              0,   0,   0,   0,   0,   0,   0,   0);
   _minor_pcsq: Array[0..63] of Integer=(
            -10, -10, -10, -10, -10, -10, -10, -10,
            -10,   0,   0,   0,   0,   0,   0, -10,
            -10,   0,   5,   5,   5,   5,   0, -10,
            -10,   0,   5,  10,  10,   5,   0, -10,
            -10,   0,   5,  10,  10,   5,   0, -10,
            -10,   0,   5,   5,   5,   5,   0, -10,
            -10,   0,   0,   0,   0,   0,   0, -10,
            -20, -20, -20, -20, -20, -20, -20, -20);
   _king_pcsq: Array[0..63] of Integer=(
            -40, -40, -40, -40, -40, -40, -40, -40,
            -40, -40, -40, -40, -40, -40, -40, -40,
            -40, -40, -40, -40, -40, -40, -40, -40,
            -40, -40, -40, -40, -40, -40, -40, -40,
            -40, -40, -40, -40, -40, -40, -40, -40,
            -40, -40, -40, -40, -40, -40, -40, -40,
            -20, -20, -20, -20, -20, -20, -20, -20,
            -10,   0,  10, -20,   0, -20,  10,   0);

    _endgame_king_pcsq: Array[0..63] of Integer=(
             -5,  -5,  -5,  -5,  -5,  -5,  -5,  -5,
             -5,   0,   0,   0,   0,   0,   0,  -5,
             -5,   0,   5,   5,   5,   5,   0,  -5,
             -5,   0,   5,  10,  10,   5,   0,  -5,
             -5,   0,   5,  10,  10,   5,   0,  -5,
             -5,   0,   5,   5,   5,   5,   0,  -5,
             -5,   0,   0,   0,   0,   0,   0,  -5,
             -5,  -5,  -5,  -5,  -5,  -5,  -5,  -5);

    _mailbox: Array[0..119] of Integer=(
             -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
             -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
             -1,  0,  1,  2,  3,  4,  5,  6,  7, -1,
             -1,  8,  9, 10, 11, 12, 13, 14, 15, -1,
             -1, 16, 17, 18, 19, 20, 21, 22, 23, -1,
             -1, 24, 25, 26, 27, 28, 29, 30, 31, -1,
             -1, 32, 33, 34, 35, 36, 37, 38, 39, -1,
             -1, 40, 41, 42, 43, 44, 45, 46, 47, -1,
             -1, 48, 49, 50, 51, 52, 53, 54, 55, -1,
             -1, 56, 57, 58, 59, 60, 61, 62, 63, -1,
             -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
             -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);

   _mailbox64: Array[0..63] of Integer=(
             21, 22, 23, 24, 25, 26, 27, 28,
             31, 32, 33, 34, 35, 36, 37, 38,
             41, 42, 43, 44, 45, 46, 47, 48,
             51, 52, 53, 54, 55, 56, 57, 58,
             61, 62, 63, 64, 65, 66, 67, 68,
             71, 72, 73, 74, 75, 76, 77, 78,
             81, 82, 83, 84, 85, 86, 87, 88,
             91, 92, 93, 94, 95, 96, 97, 98);

    _offsets: Array[0..5] of Integer=(0, 8, 4, 4, 8, 8);

    _offset: Array[0..5,0..7] of Integer=(
             (0, 0, 0, 0, 0, 0, 0, 0),
             (-21, -19, -12, -8, 8, 12, 19, 21),
             (-11, -9, 9, 11, 0, 0, 0, 0),
             (-10, -1, 1, 10, 0, 0, 0, 0),
             (-11, -10, -9, -1, 1, 9, 10, 11),
             (-11, -10, -9, -1, 1, 9, 10, 11));

    _castle_mask: Array[0..63] of Integer=(
             7, 15, 15, 15,  3, 15, 15, 11,
            15, 15, 15, 15, 15, 15, 15, 15,
            15, 15, 15, 15, 15, 15, 15, 15,
            15, 15, 15, 15, 15, 15, 15, 15,
            15, 15, 15, 15, 15, 15, 15, 15,
            15, 15, 15, 15, 15, 15, 15, 15,
            15, 15, 15, 15, 15, 15, 15, 15,
            13, 15, 15, 15, 12, 15, 15, 14);

    _value: Array[0..5] of Integer=(100, 300, 300, 500, 900, 10000);

    _init_color: Array[0..63] of Integer=(
            1, 1, 1, 1, 1, 1, 1, 1,
            1, 1, 1, 1, 1, 1, 1, 1,
            6, 6, 6, 6, 6, 6, 6, 6,
            6, 6, 6, 6, 6, 6, 6, 6,
            6, 6, 6, 6, 6, 6, 6, 6,
            6, 6, 6, 6, 6, 6, 6, 6,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0);

    _init_piece: Array[0..63] of Integer=(
            3, 1, 2, 4, 5, 2, 1, 3,
            0, 0, 0, 0, 0, 0, 0, 0,
            6, 6, 6, 6, 6, 6, 6, 6,
            6, 6, 6, 6, 6, 6, 6, 6,
            6, 6, 6, 6, 6, 6, 6, 6,
            6, 6, 6, 6, 6, 6, 6, 6,
            0, 0, 0, 0, 0, 0, 0, 0,
            3, 1, 2, 4, 5, 2, 1, 3);
begin

    IntCopy (@flip[0],@_flip[0],64);
    IntCopy (@pawn_pcsq[0],@_pawn_pcsq[0],64);
    IntCopy (@kingside_pawn_pcsq[0],@_kingside_pawn_pcsq[0],64);
    IntCopy (@queenside_pawn_pcsq[0],@_queenside_pawn_pcsq[0],64);
    IntCopy (@minor_pcsq[0],@_minor_pcsq[0],64);
    IntCopy (@king_pcsq[0],@_king_pcsq[0],64);
    IntCopy (@endgame_king_pcsq[0],@_endgame_king_pcsq[0],64);
    IntCopy (@mailbox[0],@_mailbox[0],120);
    IntCopy (@mailbox64[0],@_mailbox64[0],64);

    slide[0]:=FALSE;
    slide[1]:=FALSE;
    slide[2]:=TRUE;
    slide[3]:=TRUE;
    slide[4]:=TRUE;
    slide[5]:=FALSE;

    IntCopy (@offsets[0],@_offsets[0],6);
    IntCopy (@offset[0,0],@_offset[0,0],48);
    IntCopy (@castle_mask[0],@_castle_mask[0],64);
    IntCopy (@value[0],@_value[0],6);

    piece_char[0]:='P';
    piece_char[1]:='N';
    piece_char[2]:='B';
    piece_char[3]:='R';
    piece_char[4]:='Q';
    piece_char[5]:='K';

    IntCopy (@init_color[0],@_init_color[0],64);
    IntCopy (@init_piece[0],@_init_piece[0],64);

end;

end.

