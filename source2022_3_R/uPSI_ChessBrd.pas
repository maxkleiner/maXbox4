unit uPSI_ChessBrd;
{
 the chess engine maxpawn   - square modificatin A1-H8 A11-H88
 also pieces  br --> b_r

}
interface
 

 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_ChessBrd = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TChessBrd(CL: TPSPascalCompiler);
procedure SIRegister_TChessThread(CL: TPSPascalCompiler);
procedure SIRegister_ChessBrd(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ChessBrd_Routines(S: TPSExec);
procedure RIRegister_TChessBrd(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChessThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_ChessBrd(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,Grids
  ,ExtCtrls
  ,ImgList
  ,ChessBrd
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ChessBrd]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TChessBrd(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TChessBrd') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TChessBrd') do begin
    RegisterProperty('FirstMove', 'Integer', iptrw);
    RegisterProperty('LastMove', 'Integer', iptrw);
    RegisterProperty('FirstTurn', 'Boolean', iptrw);
    RegisterProperty('LastTurn', 'Boolean', iptrw);
       RegisterMethod('Procedure Free');
     RegisterMethod('Constructor Create');
    RegisterMethod('Function BlackInCheckAfter( oldsq, newsq : Square) : Boolean');
    RegisterMethod('Function ColorOfPiece( piece : Char) : Integer');
    RegisterMethod('Function ColorOfPieceOnSquare( sq : Square) : Integer');
    RegisterMethod('Function ColorOfSquare( sq : Square) : Integer');
    RegisterMethod('Function GetMove( moveno : Integer; whiteMoves : Boolean) : MoveInfo');
    RegisterMethod('Function GotoMove( moveno : Integer; whiteMoves : Boolean) : Boolean');
    RegisterMethod('Function LegalMoveAvailable : Boolean');
    RegisterMethod('Function MouseToSquare( x, y : Integer) : Square');
    RegisterMethod('Function Move( oldsq, newsq : Square) : Boolean');
    RegisterMethod('Function MoveBackward : Boolean');
    RegisterMethod('Function MoveForward : Boolean');
    RegisterMethod('Function MoveIsLegal( oldsq, newsq : Square) : Boolean');
    RegisterMethod('Function PerformMove( oldsq, newsq : Square) : Boolean');
    RegisterMethod('Function SetUpPosition( pos : MoveInfo; moveno : Integer; whiteMoves : Boolean) : Boolean');
    RegisterMethod('Function StringToSquare( str : String) : Square');
    RegisterMethod('Function WhiteInCheckAfter( oldsq, newsq : Square) : Boolean');
    RegisterMethod('Function WindowToSquare( x, y : Integer) : Square');
    RegisterMethod('Function XPos( sq : Square) : Integer');
    RegisterMethod('Function YPos( sq : Square) : Integer');
    RegisterMethod('Procedure Animate( oldsq, newsq : Square; delay : Integer)');
    RegisterMethod('Procedure CancelThinking');
    RegisterMethod('Procedure ClearSquare( sq : Square)');
    RegisterMethod('Procedure DrawChessPiece( canvas : TCanvas; x, y : Integer; piece : Char)');
    RegisterMethod('Procedure GetMoveList( var list : TStringList)');
    RegisterMethod('Procedure NewGame');
    RegisterMethod('Procedure SquareToCoords( sq : Square; var x, y : Integer)');
    RegisterMethod('Procedure Think');
    RegisterMethod('Procedure UpdateChessBoard( oldpos : String)');
    RegisterProperty('AnimateMoves', 'Boolean', iptrw);
    RegisterProperty('AnimationDelay', 'Integer', iptrw);
    RegisterProperty('BoardLines', 'Boolean', iptrw);
    RegisterProperty('BorderBitmap', 'TBitmap', iptrw);
    RegisterProperty('BorderColor', 'TColor', iptrw);
    RegisterProperty('CastlingAllowed', 'CastleSet', iptrw);
    RegisterProperty('ComputerPlaysBlack', 'Boolean', iptrw);
    RegisterProperty('ComputerPlaysWhite', 'Boolean', iptrw);
    RegisterProperty('Thinking', 'Boolean', iptrw);
    RegisterProperty('CoordFont', 'TFont', iptrw);
    RegisterProperty('CurrentMove', 'Integer', iptrw);
    RegisterProperty('CustomPieceSet', 'TBitmap', iptrw);
    RegisterProperty('DisplayCoords', 'CoordSet', iptrw);
    RegisterProperty('CustomEngine', 'Boolean', iptrw);
    RegisterProperty('EnPassant', 'Square', iptrw);
    RegisterProperty('LineStyle', 'TPen', iptrw);
    RegisterProperty('Position', 'String', iptrw);
    RegisterProperty('Resizable', 'Boolean', iptrw);
    RegisterProperty('ResizeMinSize', 'Integer', iptrw);
    RegisterProperty('ResizeMaxSize', 'Integer', iptrw);
    RegisterProperty('SearchDepth', 'Integer', iptrw);
    RegisterProperty('SizeOfBorder', 'Integer', iptrw);
    RegisterProperty('SizeOfSquare', 'Integer', iptrw);
    RegisterProperty('SquareColorDark', 'TColor', iptrw);
    RegisterProperty('SquareColorLight', 'TColor', iptrw);
    RegisterProperty('SquareDark', 'TBitmap', iptrw);
    RegisterProperty('SquareLight', 'TBitmap', iptrw);
    RegisterProperty('WhiteOnTop', 'Boolean', iptrw);
    RegisterProperty('WhiteToMove', 'Boolean', iptrw);
    RegisterProperty('ThinkingPriority', 'TThreadPriority', iptrw);
    RegisterProperty('Version', 'String', iptrw);
    RegisterProperty('OnCapture', 'TCaptureEvent', iptrw);
    RegisterProperty('OnCastle', 'TMoveEvent', iptrw);
    RegisterProperty('OnCheck', 'TMoveEvent', iptrw);
    RegisterProperty('OnDraw', 'TNotifyEvent', iptrw);
    RegisterProperty('OnIllegalMove', 'TOneSquareEvent', iptrw);
    RegisterProperty('OnLegalMove', 'TMoveEvent', iptrw);
    RegisterProperty('OnMate', 'TMoveEvent', iptrw);
    RegisterProperty('OnNoMatingMaterial', 'TNotifyEvent', iptrw);
    RegisterProperty('OnPaint', 'TNotifyEvent', iptrw);
    RegisterProperty('OnPromotion', 'TPromotionEvent', iptrw);
    RegisterProperty('OnStaleMate', 'TMoveEvent', iptrw);
    RegisterProperty('OnCalculateMove', 'TThinkEvent', iptrw);
    RegisterProperty('OnCalculationFailed', 'TMoveEvent', iptrw);
    RegisterProperty('OnThreefoldPosition', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChessThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TChessThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TChessThread') do
  begin
    RegisterProperty('MoveFunc', 'TMoveFunc', iptrw);
    RegisterProperty('EndFunc', 'TNotifyEvent', iptrw);
    RegisterMethod('Constructor Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ChessBrd(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('SetAndrew40Str','String').SetString( 'SETANDREW40');
 CL.AddConstantN('versionStr','String').SetString( '3.02');
 CL.AddConstantN('NoPiece','LongInt').SetInt( - 1);
 CL.AddConstantN('chessBlack','LongInt').SetInt( 0);
 CL.AddConstantN('chessWhite','LongInt').SetInt( 1);
 CL.AddConstantN('MOVE_STACK','LongInt').SetInt( 4096);
 CL.AddConstantN('HIST_STACK','LongInt').SetInt( 64);
 CL.AddConstantN('LIGHT','LongInt').SetInt( 0);
 CL.AddConstantN('DARK','LongInt').SetInt( 1);
 CL.AddConstantN('PAWN','LongInt').SetInt( 0);
 CL.AddConstantN('KNIGHT','LongInt').SetInt( 1);
 CL.AddConstantN('BISHOP','LongInt').SetInt( 2);
 CL.AddConstantN('ROOK','LongInt').SetInt( 3);
 CL.AddConstantN('QUEEN','LongInt').SetInt( 4);
 CL.AddConstantN('KING','LongInt').SetInt( 5);
 CL.AddConstantN('EMPTY','LongInt').SetInt( 6);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EChessException');
  CL.AddTypeS('Square', '( None, A_8, B_8, C_8, D_8, E_8, F_8, G_8, H_8, A_7, B_7, C_7, D_7'
   +', E_7, F_7, G_7, H_7, A_6, B_6, C_6, D_6, E_6, F_6, G_6, H_6, A_5, B_5, C_5, D_5, E_5, F_5, '
   +'G_5, H_5, A_4, B_4, C_4, D_4, E_4, F_4, G_4, H_4, A_3, B_3, C_3, D_3, E_3, F_3, G_3, H_3, A_2'
   +', B_2, C_2, D_2, E_2, F_2, G_2, H_2, A_1, B_1, C_1, D_1, E_1, F_1, G_1, H_1 )');
  CL.AddTypeS('DisplayCoords', '( West, North, East, South )');
  CL.AddTypeS('CanStillCastle', '( WhiteKingSide, WhiteQueenSide, BlackKingSide, BlackQueenSide )');
  CL.AddTypeS('CastleSet', 'set of CanStillCastle');
  CL.AddTypeS('CoordSet', 'set of DisplayCoords');
  CL.AddTypeS('MoveInfo', 'record position : String; Castling : CastleSet; OldS'
   +'quare : square; NewSquare : square; EnPassant : Square; end');
  //CL.AddTypeS('pieces', '( BP, BN, BB, BR, BK, BQ, WP, WN, WB, WR, WQ, WK )');
  CL.AddTypeS('pieces', '( B_P, B_N, B_B, B_R, B_K, B_Q, W_P, W_N, W_B, W_R, W_Q, W_K )');

  {CL.AddTypeS('pGenRec', '^gen_rec // will not work');
  CL.AddTypeS('pSquare', '^Square // will not work');
  CL.AddTypeS('pCastleSet', '^CastleSet // will not work');
  CL.AddTypeS('pBoolean', '^Boolean // will not work');
  CL.AddTypeS('pThreadPriority', '^TThreadPriority // will not work');
  }
  CL.AddTypeS('TMoveEventChess', 'Procedure ( Sender : TObject; oldSq, newSq : Square)');
  CL.AddTypeS('TCaptureEvent', 'Procedure ( Sender : TObject; oldSq, newSq : Sq'
   +'uare; CapturedPiece : Char)');
  CL.AddTypeS('TOneSquareEvent', 'Procedure ( Sender : TObject; square : Square)');
  CL.AddTypeS('TPromotionEvent', 'Procedure ( Sender : TObject; oldSq, newSq : '
   +'Square; var NewPiece : Char)');
  CL.AddTypeS('TMoveFunc', 'Function ( oldsq, newsq : Square) : Boolean');
  CL.AddTypeS('TThinkEvent', 'Procedure ( Sender : TObject; var oldsq, newsq : Square)');
  CL.AddTypeS('move_bytes', 'record src : byte; dst : byte; promote : byte; bits : Byte; end');
  CL.AddTypeS('moverec', 'record b : move_bytes; end');
  CL.AddTypeS('gen_rec', 'record m : moverec; score : Integer; end');
  CL.AddTypeS('hist_rec', 'record m : moverec; capture : integer; castle : integer; ep : integer; fifty : Integer; end');
  SIRegister_TChessThread(CL);
  SIRegister_TChessBrd(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'ChessBrdError');
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TChessBrdOnThreefoldPosition_W(Self: TChessBrd; const T: TNotifyEvent);
begin Self.OnThreefoldPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnThreefoldPosition_R(Self: TChessBrd; var T: TNotifyEvent);
begin T := Self.OnThreefoldPosition; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnCalculationFailed_W(Self: TChessBrd; const T: TMoveEvent);
begin Self.OnCalculationFailed := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnCalculationFailed_R(Self: TChessBrd; var T: TMoveEvent);
begin T := Self.OnCalculationFailed; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnCalculateMove_W(Self: TChessBrd; const T: TThinkEvent);
begin Self.OnCalculateMove := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnCalculateMove_R(Self: TChessBrd; var T: TThinkEvent);
begin T := Self.OnCalculateMove; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnStaleMate_W(Self: TChessBrd; const T: TMoveEvent);
begin Self.OnStaleMate := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnStaleMate_R(Self: TChessBrd; var T: TMoveEvent);
begin T := Self.OnStaleMate; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnPromotion_W(Self: TChessBrd; const T: TPromotionEvent);
begin Self.OnPromotion := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnPromotion_R(Self: TChessBrd; var T: TPromotionEvent);
begin T := Self.OnPromotion; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnPaint_W(Self: TChessBrd; const T: TNotifyEvent);
begin Self.OnPaint := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnPaint_R(Self: TChessBrd; var T: TNotifyEvent);
begin T := Self.OnPaint; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnNoMatingMaterial_W(Self: TChessBrd; const T: TNotifyEvent);
begin Self.OnNoMatingMaterial := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnNoMatingMaterial_R(Self: TChessBrd; var T: TNotifyEvent);
begin T := Self.OnNoMatingMaterial; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnMate_W(Self: TChessBrd; const T: TMoveEvent);
begin Self.OnMate := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnMate_R(Self: TChessBrd; var T: TMoveEvent);
begin T := Self.OnMate; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnLegalMove_W(Self: TChessBrd; const T: TMoveEvent);
begin Self.OnLegalMove := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnLegalMove_R(Self: TChessBrd; var T: TMoveEvent);
begin T := Self.OnLegalMove; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnIllegalMove_W(Self: TChessBrd; const T: TOneSquareEvent);
begin Self.OnIllegalMove := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnIllegalMove_R(Self: TChessBrd; var T: TOneSquareEvent);
begin T := Self.OnIllegalMove; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnDraw_W(Self: TChessBrd; const T: TNotifyEvent);
begin Self.OnDraw := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnDraw_R(Self: TChessBrd; var T: TNotifyEvent);
begin T := Self.OnDraw; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnCheck_W(Self: TChessBrd; const T: TMoveEvent);
begin Self.OnCheck := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnCheck_R(Self: TChessBrd; var T: TMoveEvent);
begin T := Self.OnCheck; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnCastle_W(Self: TChessBrd; const T: TMoveEvent);
begin Self.OnCastle := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnCastle_R(Self: TChessBrd; var T: TMoveEvent);
begin T := Self.OnCastle; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnCapture_W(Self: TChessBrd; const T: TCaptureEvent);
begin Self.OnCapture := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdOnCapture_R(Self: TChessBrd; var T: TCaptureEvent);
begin T := Self.OnCapture; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdVersion_W(Self: TChessBrd; const T: String);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdVersion_R(Self: TChessBrd; var T: String);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdThinkingPriority_W(Self: TChessBrd; const T: TThreadPriority);
begin Self.ThinkingPriority := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdThinkingPriority_R(Self: TChessBrd; var T: TThreadPriority);
begin T := Self.ThinkingPriority; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdWhiteToMove_W(Self: TChessBrd; const T: Boolean);
begin Self.WhiteToMove := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdWhiteToMove_R(Self: TChessBrd; var T: Boolean);
begin T := Self.WhiteToMove; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdWhiteOnTop_W(Self: TChessBrd; const T: Boolean);
begin Self.WhiteOnTop := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdWhiteOnTop_R(Self: TChessBrd; var T: Boolean);
begin T := Self.WhiteOnTop; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdSquareLight_W(Self: TChessBrd; const T: TBitmap);
begin Self.SquareLight := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdSquareLight_R(Self: TChessBrd; var T: TBitmap);
begin T := Self.SquareLight; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdSquareDark_W(Self: TChessBrd; const T: TBitmap);
begin Self.SquareDark := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdSquareDark_R(Self: TChessBrd; var T: TBitmap);
begin T := Self.SquareDark; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdSquareColorLight_W(Self: TChessBrd; const T: TColor);
begin Self.SquareColorLight := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdSquareColorLight_R(Self: TChessBrd; var T: TColor);
begin T := Self.SquareColorLight; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdSquareColorDark_W(Self: TChessBrd; const T: TColor);
begin Self.SquareColorDark := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdSquareColorDark_R(Self: TChessBrd; var T: TColor);
begin T := Self.SquareColorDark; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdSizeOfSquare_W(Self: TChessBrd; const T: Integer);
begin Self.SizeOfSquare := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdSizeOfSquare_R(Self: TChessBrd; var T: Integer);
begin T := Self.SizeOfSquare; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdSizeOfBorder_W(Self: TChessBrd; const T: Integer);
begin Self.SizeOfBorder := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdSizeOfBorder_R(Self: TChessBrd; var T: Integer);
begin T := Self.SizeOfBorder; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdSearchDepth_W(Self: TChessBrd; const T: Integer);
begin Self.SearchDepth := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdSearchDepth_R(Self: TChessBrd; var T: Integer);
begin T := Self.SearchDepth; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdResizeMaxSize_W(Self: TChessBrd; const T: Integer);
begin Self.ResizeMaxSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdResizeMaxSize_R(Self: TChessBrd; var T: Integer);
begin T := Self.ResizeMaxSize; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdResizeMinSize_W(Self: TChessBrd; const T: Integer);
begin Self.ResizeMinSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdResizeMinSize_R(Self: TChessBrd; var T: Integer);
begin T := Self.ResizeMinSize; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdResizable_W(Self: TChessBrd; const T: Boolean);
begin Self.Resizable := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdResizable_R(Self: TChessBrd; var T: Boolean);
begin T := Self.Resizable; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdPosition_W(Self: TChessBrd; const T: String);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdPosition_R(Self: TChessBrd; var T: String);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdLineStyle_W(Self: TChessBrd; const T: TPen);
begin Self.LineStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdLineStyle_R(Self: TChessBrd; var T: TPen);
begin T := Self.LineStyle; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdEnPassant_W(Self: TChessBrd; const T: Square);
begin Self.EnPassant := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdEnPassant_R(Self: TChessBrd; var T: Square);
begin T := Self.EnPassant; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdCustomEngine_W(Self: TChessBrd; const T: Boolean);
begin Self.CustomEngine := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdCustomEngine_R(Self: TChessBrd; var T: Boolean);
begin T := Self.CustomEngine; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdDisplayCoords_W(Self: TChessBrd; const T: CoordSet);
begin Self.DisplayCoords := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdDisplayCoords_R(Self: TChessBrd; var T: CoordSet);
begin T := Self.DisplayCoords; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdCustomPieceSet_W(Self: TChessBrd; const T: TBitmap);
begin Self.CustomPieceSet := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdCustomPieceSet_R(Self: TChessBrd; var T: TBitmap);
begin T := Self.CustomPieceSet; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdCurrentMove_W(Self: TChessBrd; const T: Integer);
begin Self.CurrentMove := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdCurrentMove_R(Self: TChessBrd; var T: Integer);
begin T := Self.CurrentMove; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdCoordFont_W(Self: TChessBrd; const T: TFont);
begin Self.CoordFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdCoordFont_R(Self: TChessBrd; var T: TFont);
begin T := Self.CoordFont; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdThinking_W(Self: TChessBrd; const T: Boolean);
begin Self.Thinking := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdThinking_R(Self: TChessBrd; var T: Boolean);
begin T := Self.Thinking; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdComputerPlaysWhite_W(Self: TChessBrd; const T: Boolean);
begin Self.ComputerPlaysWhite := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdComputerPlaysWhite_R(Self: TChessBrd; var T: Boolean);
begin T := Self.ComputerPlaysWhite; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdComputerPlaysBlack_W(Self: TChessBrd; const T: Boolean);
begin Self.ComputerPlaysBlack := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdComputerPlaysBlack_R(Self: TChessBrd; var T: Boolean);
begin T := Self.ComputerPlaysBlack; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdCastlingAllowed_W(Self: TChessBrd; const T: CastleSet);
begin Self.CastlingAllowed := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdCastlingAllowed_R(Self: TChessBrd; var T: CastleSet);
begin T := Self.CastlingAllowed; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdBorderColor_W(Self: TChessBrd; const T: TColor);
begin Self.BorderColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdBorderColor_R(Self: TChessBrd; var T: TColor);
begin T := Self.BorderColor; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdBorderBitmap_W(Self: TChessBrd; const T: TBitmap);
begin Self.BorderBitmap := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdBorderBitmap_R(Self: TChessBrd; var T: TBitmap);
begin T := Self.BorderBitmap; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdBoardLines_W(Self: TChessBrd; const T: Boolean);
begin Self.BoardLines := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdBoardLines_R(Self: TChessBrd; var T: Boolean);
begin T := Self.BoardLines; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdAnimationDelay_W(Self: TChessBrd; const T: Integer);
begin Self.AnimationDelay := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdAnimationDelay_R(Self: TChessBrd; var T: Integer);
begin T := Self.AnimationDelay; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdAnimateMoves_W(Self: TChessBrd; const T: Boolean);
begin Self.AnimateMoves := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdAnimateMoves_R(Self: TChessBrd; var T: Boolean);
begin T := Self.AnimateMoves; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdLastTurn_W(Self: TChessBrd; const T: Boolean);
Begin Self.LastTurn := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdLastTurn_R(Self: TChessBrd; var T: Boolean);
Begin T := Self.LastTurn; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdFirstTurn_W(Self: TChessBrd; const T: Boolean);
Begin Self.FirstTurn := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdFirstTurn_R(Self: TChessBrd; var T: Boolean);
Begin T := Self.FirstTurn; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdLastMove_W(Self: TChessBrd; const T: Integer);
Begin Self.LastMove := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdLastMove_R(Self: TChessBrd; var T: Integer);
Begin T := Self.LastMove; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdFirstMove_W(Self: TChessBrd; const T: Integer);
Begin Self.FirstMove := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessBrdFirstMove_R(Self: TChessBrd; var T: Integer);
Begin T := Self.FirstMove; end;

(*----------------------------------------------------------------------------*)
procedure TChessThreadEndFunc_W(Self: TChessThread; const T: TNotifyEvent);
Begin Self.EndFunc := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessThreadEndFunc_R(Self: TChessThread; var T: TNotifyEvent);
Begin T := Self.EndFunc; end;

(*----------------------------------------------------------------------------*)
procedure TChessThreadMoveFunc_W(Self: TChessThread; const T: TMoveFunc);
Begin Self.MoveFunc := T; end;

(*----------------------------------------------------------------------------*)
procedure TChessThreadMoveFunc_R(Self: TChessThread; var T: TMoveFunc);
Begin T := Self.MoveFunc; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ChessBrd_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChessBrd(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChessBrd) do begin
    RegisterPropertyHelper(@TChessBrdFirstMove_R,@TChessBrdFirstMove_W,'FirstMove');
    RegisterPropertyHelper(@TChessBrdLastMove_R,@TChessBrdLastMove_W,'LastMove');
    RegisterPropertyHelper(@TChessBrdFirstTurn_R,@TChessBrdFirstTurn_W,'FirstTurn');
    RegisterPropertyHelper(@TChessBrdLastTurn_R,@TChessBrdLastTurn_W,'LastTurn');
     RegisterMethod(@TChessBrd.Destroy, 'Free');
     RegisterConstructor(@TChessBrd.Create, 'Create');
      RegisterMethod(@TChessBrd.BlackInCheckAfter, 'BlackInCheckAfter');
    RegisterMethod(@TChessBrd.ColorOfPiece, 'ColorOfPiece');
    RegisterMethod(@TChessBrd.ColorOfPieceOnSquare, 'ColorOfPieceOnSquare');
    RegisterMethod(@TChessBrd.ColorOfSquare, 'ColorOfSquare');
    RegisterMethod(@TChessBrd.GetMove, 'GetMove');
    RegisterMethod(@TChessBrd.GotoMove, 'GotoMove');
    RegisterMethod(@TChessBrd.LegalMoveAvailable, 'LegalMoveAvailable');
    RegisterMethod(@TChessBrd.MouseToSquare, 'MouseToSquare');
    RegisterMethod(@TChessBrd.Move, 'Move');
    RegisterMethod(@TChessBrd.MoveBackward, 'MoveBackward');
    RegisterMethod(@TChessBrd.MoveForward, 'MoveForward');
    RegisterMethod(@TChessBrd.MoveIsLegal, 'MoveIsLegal');
    RegisterMethod(@TChessBrd.PerformMove, 'PerformMove');
    RegisterMethod(@TChessBrd.SetUpPosition, 'SetUpPosition');
    RegisterMethod(@TChessBrd.StringToSquare, 'StringToSquare');
    RegisterMethod(@TChessBrd.WhiteInCheckAfter, 'WhiteInCheckAfter');
    RegisterMethod(@TChessBrd.WindowToSquare, 'WindowToSquare');
    RegisterMethod(@TChessBrd.XPos, 'XPos');
    RegisterMethod(@TChessBrd.YPos, 'YPos');
    RegisterMethod(@TChessBrd.Animate, 'Animate');
    RegisterMethod(@TChessBrd.CancelThinking, 'CancelThinking');
    RegisterMethod(@TChessBrd.ClearSquare, 'ClearSquare');
    RegisterMethod(@TChessBrd.DrawChessPiece, 'DrawChessPiece');
    RegisterMethod(@TChessBrd.GetMoveList, 'GetMoveList');
    RegisterMethod(@TChessBrd.NewGame, 'NewGame');
    RegisterMethod(@TChessBrd.SquareToCoords, 'SquareToCoords');
    RegisterMethod(@TChessBrd.Think, 'Think');
    RegisterMethod(@TChessBrd.UpdateChessBoard, 'UpdateChessBoard');
    RegisterPropertyHelper(@TChessBrdAnimateMoves_R,@TChessBrdAnimateMoves_W,'AnimateMoves');
    RegisterPropertyHelper(@TChessBrdAnimationDelay_R,@TChessBrdAnimationDelay_W,'AnimationDelay');
    RegisterPropertyHelper(@TChessBrdBoardLines_R,@TChessBrdBoardLines_W,'BoardLines');
    RegisterPropertyHelper(@TChessBrdBorderBitmap_R,@TChessBrdBorderBitmap_W,'BorderBitmap');
    RegisterPropertyHelper(@TChessBrdBorderColor_R,@TChessBrdBorderColor_W,'BorderColor');
    RegisterPropertyHelper(@TChessBrdCastlingAllowed_R,@TChessBrdCastlingAllowed_W,'CastlingAllowed');
    RegisterPropertyHelper(@TChessBrdComputerPlaysBlack_R,@TChessBrdComputerPlaysBlack_W,'ComputerPlaysBlack');
    RegisterPropertyHelper(@TChessBrdComputerPlaysWhite_R,@TChessBrdComputerPlaysWhite_W,'ComputerPlaysWhite');
    RegisterPropertyHelper(@TChessBrdThinking_R,@TChessBrdThinking_W,'Thinking');
    RegisterPropertyHelper(@TChessBrdCoordFont_R,@TChessBrdCoordFont_W,'CoordFont');
    RegisterPropertyHelper(@TChessBrdCurrentMove_R,@TChessBrdCurrentMove_W,'CurrentMove');
    RegisterPropertyHelper(@TChessBrdCustomPieceSet_R,@TChessBrdCustomPieceSet_W,'CustomPieceSet');
    RegisterPropertyHelper(@TChessBrdDisplayCoords_R,@TChessBrdDisplayCoords_W,'DisplayCoords');
    RegisterPropertyHelper(@TChessBrdCustomEngine_R,@TChessBrdCustomEngine_W,'CustomEngine');
    RegisterPropertyHelper(@TChessBrdEnPassant_R,@TChessBrdEnPassant_W,'EnPassant');
    RegisterPropertyHelper(@TChessBrdLineStyle_R,@TChessBrdLineStyle_W,'LineStyle');
    RegisterPropertyHelper(@TChessBrdPosition_R,@TChessBrdPosition_W,'Position');
    RegisterPropertyHelper(@TChessBrdResizable_R,@TChessBrdResizable_W,'Resizable');
    RegisterPropertyHelper(@TChessBrdResizeMinSize_R,@TChessBrdResizeMinSize_W,'ResizeMinSize');
    RegisterPropertyHelper(@TChessBrdResizeMaxSize_R,@TChessBrdResizeMaxSize_W,'ResizeMaxSize');
    RegisterPropertyHelper(@TChessBrdSearchDepth_R,@TChessBrdSearchDepth_W,'SearchDepth');
    RegisterPropertyHelper(@TChessBrdSizeOfBorder_R,@TChessBrdSizeOfBorder_W,'SizeOfBorder');
    RegisterPropertyHelper(@TChessBrdSizeOfSquare_R,@TChessBrdSizeOfSquare_W,'SizeOfSquare');
    RegisterPropertyHelper(@TChessBrdSquareColorDark_R,@TChessBrdSquareColorDark_W,'SquareColorDark');
    RegisterPropertyHelper(@TChessBrdSquareColorLight_R,@TChessBrdSquareColorLight_W,'SquareColorLight');
    RegisterPropertyHelper(@TChessBrdSquareDark_R,@TChessBrdSquareDark_W,'SquareDark');
    RegisterPropertyHelper(@TChessBrdSquareLight_R,@TChessBrdSquareLight_W,'SquareLight');
    RegisterPropertyHelper(@TChessBrdWhiteOnTop_R,@TChessBrdWhiteOnTop_W,'WhiteOnTop');
    RegisterPropertyHelper(@TChessBrdWhiteToMove_R,@TChessBrdWhiteToMove_W,'WhiteToMove');
    RegisterPropertyHelper(@TChessBrdThinkingPriority_R,@TChessBrdThinkingPriority_W,'ThinkingPriority');
    RegisterPropertyHelper(@TChessBrdVersion_R,@TChessBrdVersion_W,'Version');
    RegisterPropertyHelper(@TChessBrdOnCapture_R,@TChessBrdOnCapture_W,'OnCapture');
    RegisterPropertyHelper(@TChessBrdOnCastle_R,@TChessBrdOnCastle_W,'OnCastle');
    RegisterPropertyHelper(@TChessBrdOnCheck_R,@TChessBrdOnCheck_W,'OnCheck');
    RegisterPropertyHelper(@TChessBrdOnDraw_R,@TChessBrdOnDraw_W,'OnDraw');
    RegisterPropertyHelper(@TChessBrdOnIllegalMove_R,@TChessBrdOnIllegalMove_W,'OnIllegalMove');
    RegisterPropertyHelper(@TChessBrdOnLegalMove_R,@TChessBrdOnLegalMove_W,'OnLegalMove');
    RegisterPropertyHelper(@TChessBrdOnMate_R,@TChessBrdOnMate_W,'OnMate');
    RegisterPropertyHelper(@TChessBrdOnNoMatingMaterial_R,@TChessBrdOnNoMatingMaterial_W,'OnNoMatingMaterial');
    RegisterPropertyHelper(@TChessBrdOnPaint_R,@TChessBrdOnPaint_W,'OnPaint');
    RegisterPropertyHelper(@TChessBrdOnPromotion_R,@TChessBrdOnPromotion_W,'OnPromotion');
    RegisterPropertyHelper(@TChessBrdOnStaleMate_R,@TChessBrdOnStaleMate_W,'OnStaleMate');
    RegisterPropertyHelper(@TChessBrdOnCalculateMove_R,@TChessBrdOnCalculateMove_W,'OnCalculateMove');
    RegisterPropertyHelper(@TChessBrdOnCalculationFailed_R,@TChessBrdOnCalculationFailed_W,'OnCalculationFailed');
    RegisterPropertyHelper(@TChessBrdOnThreefoldPosition_R,@TChessBrdOnThreefoldPosition_W,'OnThreefoldPosition');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChessThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChessThread) do
  begin
    RegisterPropertyHelper(@TChessThreadMoveFunc_R,@TChessThreadMoveFunc_W,'MoveFunc');
    RegisterPropertyHelper(@TChessThreadEndFunc_R,@TChessThreadEndFunc_W,'EndFunc');
    RegisterConstructor(@TChessThread.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ChessBrd(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EChessException) do
  RIRegister_TChessThread(CL);
  RIRegister_TChessBrd(CL);
  with CL.Add(ChessBrdError) do
end;

 
 
{ TPSImport_ChessBrd }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ChessBrd.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ChessBrd(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ChessBrd.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ChessBrd(ri);
  RIRegister_ChessBrd_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
