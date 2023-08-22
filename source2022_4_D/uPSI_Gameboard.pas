unit uPSI_Gameboard;
{
 the game is on done - string SaveStringToStream

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
  TPSImport_Gameboard = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TGameboardControl(CL: TPSPascalCompiler);
procedure SIRegister_TGameHistory(CL: TPSPascalCompiler);
procedure SIRegister_TGameHistoryRec(CL: TPSPascalCompiler);
procedure SIRegister_TAnimator(CL: TPSPascalCompiler);
procedure SIRegister_TGameSolver(CL: TPSPascalCompiler);
procedure SIRegister_TGameboard(CL: TPSPascalCompiler);
procedure SIRegister_TPositionTable(CL: TPSPascalCompiler);
procedure SIRegister_Gameboard(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Gameboard_Routines(S: TPSExec);
procedure RIRegister_TGameboardControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGameHistory(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGameHistoryRec(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAnimator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGameSolver(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGameboard(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPositionTable(CL: TPSRuntimeClassImporter);
procedure RIRegister_Gameboard(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Contnrs
  ,Controls
  ,Graphics
  ,ImgList
  ,Forms
  ,Gameboard
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Gameboard]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TGameboardControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TGameboardControl') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TGameboardControl') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure StartNewGame');
    RegisterMethod('Procedure ClearBoard');
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Procedure EndUpdate');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToFile( const FileName : String; const Signature : String)');
    RegisterMethod('Procedure LoadFromFile( const FileName : String; const Signature : String)');
    RegisterMethod('Function IsGameEnded : Boolean');
    RegisterMethod('Function IsGameDraw : Boolean');
    RegisterMethod('Function CanMoveBackward : Boolean');
    RegisterMethod('Function MoveBackward : Boolean');
    RegisterMethod('Function MoveToFirst : Boolean');
    RegisterMethod('Function CanMoveForward : Boolean');
    RegisterMethod('Function MoveForward : Boolean');
    RegisterMethod('Function MoveToLast : Boolean');
    RegisterMethod('Function CanRetrieve( Player : TPlayer; TurnNo : Integer) : Boolean');
    RegisterMethod('Function Retrieve( Player : TPlayer; TurnNo : Integer) : Boolean');
    RegisterMethod('Procedure ClearHistory');
    RegisterMethod('Function IsComputerTurn : Boolean');
    RegisterMethod('Function PlayComputerTurnNow : Boolean');
    RegisterMethod('Function CancelThinking : Boolean');
    RegisterMethod('Function SuggestMove( ASearchDepth : ShortInt) : Integer');
    RegisterMethod('Function ClientToSquare( X, Y : Integer) : Integer');
    RegisterMethod('Function ClearSelection : Boolean');
    RegisterMethod('Function CompleteSelection : Boolean');
    RegisterMethod('Function IsSelectionComplete : Boolean');
    RegisterMethod('Function CanPlaySelection : Boolean');
    RegisterMethod('Function PlaySelection : Boolean');
    RegisterMethod('Function MoveOf( Player : TPlayer; TurnNo : Integer) : String');
    RegisterMethod('Function TimeOf( Player : TPlayer; TurnNo : Integer) : Cardinal');
    RegisterMethod('Function PlayerScore : Integer');
    RegisterMethod('Function MoveScore( MoveIndex : Integer) : Integer');
    RegisterProperty('BoardBounds', 'TRect', iptr);
    RegisterProperty('FullBoardBounds', 'TRect', iptr);
    RegisterProperty('SquareBounds', 'TRect TSquare', iptr);
    RegisterProperty('DraggingSquare', 'TSquare', iptr);
    RegisterProperty('Animating', 'Boolean', iptr);
    RegisterProperty('Moving', 'Boolean', iptr);
    RegisterProperty('Thinking', 'Boolean', iptr);
    RegisterProperty('Playing', 'Boolean', iptr);
    RegisterProperty('ElapsedTime', 'Cardinal', iptr);
    RegisterProperty('CurrentTurn', 'Integer', iptr);
    RegisterProperty('CurrentTime', 'Cardinal', iptr);
    RegisterProperty('PlayedTurns', 'Integer', iptr);
    RegisterProperty('PlayedTime', 'Cardinal', iptr);
    RegisterProperty('CurrentTurnOf', 'Integer TPlayer', iptr);
    RegisterProperty('CurrentTimeOf', 'Cardinal TPlayer', iptr);
    RegisterProperty('PlayedTurnsOf', 'Integer TPlayer', iptr);
    RegisterProperty('PlayedTimeOf', 'Cardinal TPlayer', iptr);
    RegisterProperty('LegalMovesCount', 'Integer', iptr);
    RegisterProperty('WinnerPlayer', 'TPlayer', iptr);
    RegisterProperty('LooserPlayer', 'TPlayer', iptr);
    RegisterProperty('OpenerPlayer', 'TPlayer', iptr);
    RegisterProperty('CurrentPlayer', 'TPlayer', iptrw);
    RegisterProperty('Selection', 'TMovementPath', iptrw);
    RegisterProperty('SelSquares', 'TSquare Integer', iptr);
    RegisterProperty('SelSquareCount', 'Integer', iptr);
    RegisterProperty('Modified', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGameHistory(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectList', 'TGameHistory') do
  with CL.AddClassN(CL.FindClass('TObjectList'),'TGameHistory') do begin
    RegisterMethod('Constructor Create( AGameboardClass : TGameboardClass)');
      RegisterMethod('Procedure Free');
       RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Procedure EndUpdate');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Add( AItem : TGameHistoryRec)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Function IndexOf0( AGameHistoryRec : TGameHistoryRec) : Integer;');
    RegisterMethod('Function IndexOf1( Player : TPlayer; TurnNo : Integer) : Integer;');
    RegisterMethod('Function TurnOf( Player : TPlayer; Index : Integer) : Integer');
    RegisterMethod('Function TotalTimeOf( Player : TPlayer; TurnNo : Integer) : Cardinal');
    RegisterMethod('Function CurrentTurnOf( Player : TPlayer) : Integer');
    RegisterMethod('Function PlayedTurnsOf( Player : TPlayer) : Integer');
    RegisterMethod('Function PlayedTurns : Integer');
    RegisterMethod('Function IsCurrentStillRunning : Boolean');
    RegisterProperty('IsClosed', 'Boolean', iptr);
    RegisterProperty('InitialBoard', 'TGameboard', iptr);
    RegisterProperty('Current', 'Integer', iptrw);
    RegisterProperty('Players', 'TPlayer Integer', iptr);
    RegisterProperty('Items', 'TGameHistoryRec Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGameHistoryRec(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TGameHistoryRec') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TGameHistoryRec') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
       RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure AssignTo( Dest : TPersistent)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure AppendMove( const Path : array of TSquare)');
    RegisterMethod('Function IsEmpty : Boolean');
    RegisterProperty('BoardAfterMove', 'TMemoryStream', iptr);
    RegisterProperty('MovementPath', 'TMovementPath', iptrw);
    RegisterProperty('ElapsedTime', 'Cardinal', iptrw);
    RegisterProperty('Completed', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAnimator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TAnimator') do
  with CL.AddClassN(CL.FindClass('TThread'),'TAnimator') do begin
    RegisterMethod('Constructor Create( AControl : TGameboardControl)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Terminate');
    RegisterMethod('Function IsBusy : Boolean');
    RegisterMethod('Function WaitForIdle( BlockInputs : Boolean) : Boolean');
    RegisterMethod('Function Animate( const Path : array of TSquare; Reverse : Boolean) : Boolean');
    RegisterMethod('Procedure CancelAnimation');
    RegisterProperty('AnimateDelay', 'Byte', iptrw);
    RegisterProperty('AnimateStep', 'Byte', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGameSolver(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TGameSolver') do
  with CL.AddClassN(CL.FindClass('TThread'),'TGameSolver') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Terminate');
    RegisterMethod('Function IsBusy : Boolean');
    RegisterMethod('Function WaitForIdle : Boolean');
    RegisterMethod('Function Solve( AGameboard : TGameboard) : Boolean');
    RegisterProperty('NotifyWnd', 'HWND', iptrw);
    RegisterProperty('State', 'TSearchControl', iptrw);
    RegisterProperty('SearchDepth', 'Byte', iptrw);
    RegisterProperty('MaxMemory', 'Cardinal', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGameboard(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TGameboard') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TGameboard') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure GetTextPresentation( out Board, Moves : String)');
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Procedure EndUpdate');
    RegisterMethod('Procedure StartNewGame');
    RegisterMethod('Procedure ClearBoard');
    RegisterMethod('Function ApplyLegalMove( Index : Integer) : Boolean');
    RegisterMethod('Function SearchForBestMove( SearchDepth : Byte; MaxMemory : Cardinal; pControl : PSearchControl) : Integer');
    RegisterProperty('Winner', 'TPlayer', iptr);
    RegisterProperty('Looser', 'TPlayer', iptr);
    RegisterProperty('EndState', 'TGameEndState', iptr);
    RegisterProperty('LegalMovesCount', 'Integer', iptr);
    RegisterProperty('BoardAsText', 'String', iptrw);
    RegisterProperty('Player', 'TPlayer', iptrw);
    RegisterProperty('OnTurn', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPositionTable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPositionTable') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPositionTable') do begin
    RegisterMethod('Procedure Clear');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Function BestMoveOf( const Key : TPositionKey) : Integer');
    RegisterMethod('Function Retrieve( const Key : TPositionKey; Depth : Integer; var Alpha, Beta : Integer; var Value : Integer; var BestMove : Integer) : Boolean');
    RegisterMethod('Procedure Store( const Key : TPositionKey; Depth : Integer; Flag : TPositionFlag; const Value : Integer; BestMove : Integer)');
    RegisterProperty('NumOfCells', 'Cardinal', iptrw);
    RegisterProperty('NumOfUsedCells', 'Cardinal', iptr);
    RegisterProperty('Size', 'Cardinal', iptrw);
    RegisterProperty('UsedSize', 'Cardinal', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Gameboard(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('WM_SOLVER_START','LongWord').SetUInt( WM_USER + $0001);
 CL.AddConstantN('WM_SOLVER_STOP','LongWord').SetUInt( WM_USER + $0002);
 CL.AddConstantN('WM_ANIMATOR_START','LongWord').SetUInt( WM_USER + $0003);
 CL.AddConstantN('WM_ANIMATOR_STOP','LongWord').SetUInt( WM_USER + $0004);
 CL.AddConstantN('WM_THINKABOUTMOVE','LongWord').SetUInt( WM_USER + $0005);
 CL.AddConstantN('WM_BOARDCHANGE','LongWord').SetUInt( WM_USER + $0006);
 CL.AddConstantN('WM_TURNCHANGE','LongWord').SetUInt( WM_USER + $0007);
 CL.AddConstantN('WM_HISTORYCHANGE','LongWord').SetUInt( WM_USER + $0008);
 CL.AddConstantN('WM_SELECTIONCHANGE','LongWord').SetUInt( WM_USER + $0009);
 CL.AddConstantN('WM_BOARDMODECHANGE','LongWord').SetUInt( WM_USER + $000A);
 CL.AddConstantN('WM_PAUSESTATECHANGE','LongWord').SetUInt( WM_USER + $000B);
 CL.AddConstantN('WM_PLAYINGSTATECHANGE','LongWord').SetUInt( WM_USER + $000C);
 CL.AddConstantN('WM_GAMEENDED','LongWord').SetUInt( WM_USER + $000D);
 CL.AddConstantN('WM_FLUSHSQUARE','LongWord').SetUInt( WM_USER + $000E);
 CL.AddConstantN('NONE','LongWord').SetUInt( $00);
 CL.AddConstantN('LIGHT_PLAYER','LongWord').SetUInt( $01);
 CL.AddConstantN('DARK_PLAYER','LongWord').SetUInt( $02);
 CL.AddConstantN('NO_SQUARE','LongInt').SetInt( - 1);
 CL.AddConstantN('MAX_VALUE','LongInt').SetInt( 1000000);
 CL.AddConstantN('MAX_SEARCH_DEPTH','LongInt').SetInt( 64);
 CL.AddConstantN('PlayerZobristMask','LongWord').SetUInt( $456EBD66E88271CE);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidGameFile');
  CL.AddTypeS('TPlayer', 'Byte');
  CL.AddTypeS('TPiece', 'Byte');
  CL.AddTypeS('TSquare', 'Integer');
  CL.AddTypeS('TMovementPath', 'array of TSquare');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TGameboard');
  //CL.AddTypeS('TGameboardClass', 'class of TGameboard');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TGameboardControl');
  CL.AddTypeS('TPositionKey', 'Int64');
  CL.AddTypeS('TPositionFlag', '( tfNone, tfExact, tfUpper, tfLower )');
  //CL.AddTypeS('PPositionNode', '^TPositionNode // will not work');
  CL.AddTypeS('TPositionNode', 'record Key : TPositionKey; Value : Integer; Depth_Flag : Byte; BestMove : ShortInt; end');
  SIRegister_TPositionTable(CL);
  //CL.AddTypeS('PSearchControl', '^TSearchControl // will not work');
  CL.AddTypeS('TSearchControl', '( scContinue, scStop, scAbort )');
  CL.AddTypeS('TGameEndState', '( gesUnknown, gesDraw, gesLightWon, gesDarkWon )');
  CL.AddTypeS('TGameStage', '( gsStartGame, gsMidGame, gsEndGame )');
  SIRegister_TGameboard(CL);
  SIRegister_TGameSolver(CL);
  SIRegister_TAnimator(CL);
  SIRegister_TGameHistoryRec(CL);
  SIRegister_TGameHistory(CL);
  CL.AddTypeS('TSelectionOption', '( soAutoComplete, soAutoPlayStep, soAutoPlayComplete )');
  CL.AddTypeS('TSelectionOptions', 'set of TSelectionOption');
  CL.AddTypeS('TBoardLabel', '( blLeft, blTop, blRight, blBottom )');
  CL.AddTypeS('TBoardLabels', 'set of TBoardLabel');
  CL.AddTypeS('TSquareLabel', '( slNone, slCenter, slLeftCenter, slLeftTop, slT'
   +'opCenter, slRightTop, slRightCenter, slRightBottom, slBottomCenter, slLeftBottom )');
  CL.AddTypeS('TGameboardMode', '( gbmSetup, gbmPlay )');
  CL.AddTypeS('TSquareDrawState', '( sdsSelected, sdsMarked, sdsFocused, sdsNoC'
   +'ache, sdsReserved1, sdsReserved2, sdsReserved3 )');
  CL.AddTypeS('TSquareDrawStates', 'set of TSquareDrawState');
  CL.AddTypeS('TSquareDragOverEvent', 'Procedure ( Sender : TObject; Source, Ta'
   +'rget : TSquare; var Accept : Boolean)');
  CL.AddTypeS('TSquareDragDropEvent', 'Procedure ( Sender : TObject; Source, Target : TSquare)');
  CL.AddTypeS('TSquareInfoTipEvent', 'Procedure ( Sender : TObject; Square : TS'
   +'quare; var InfoTip : String)');
  CL.AddTypeS('TSquareActionEvent', 'Procedure ( Sender : TObject; Square : TSq'
   +'uare; var Handled : Boolean)');
  CL.AddTypeS('TSquareEvent', 'Procedure ( Sender : TObject; Square : TSquare)');
  CL.AddTypeS('TMoveVarEvent', 'Procedure ( Sender : TObject; var Index : Integer)');
  CL.AddTypeS('TMoveEvent', 'Procedure ( Sender : TObject; Index : Integer)');
  CL.AddTypeS('TSquareDrawInfo', 'record States : TSquareDrawStates; ImageIndex : Integer; end');
  SIRegister_TGameboardControl(CL);
 CL.AddDelphiFunction('Function Opponent( Player : TPlayer) : TPlayer');
 CL.AddDelphiFunction('Procedure InitZobritsNumbers( var ZobristNumbers, Count : Integer)');
 CL.AddDelphiFunction('Procedure SaveStringToStream( const Str : String; Stream : TStream)');
 CL.AddDelphiFunction('Function LoadStringFromStream( Stream : TStream) : String');
 CL.AddDelphiFunction('Function WaitForSyncObject2( SyncObject : THandle; Timeout : Cardinal; BlockInput : Boolean) : Cardinal');
 CL.AddDelphiFunction('Function ProcessMessage : Boolean');
 CL.AddDelphiFunction('Procedure ProcessMessages( Timeout : DWORD)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TGameboardControlModified_W(Self: TGameboardControl; const T: Boolean);
begin Self.Modified := T; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlModified_R(Self: TGameboardControl; var T: Boolean);
begin T := Self.Modified; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlSelSquareCount_R(Self: TGameboardControl; var T: Integer);
begin T := Self.SelSquareCount; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlSelSquares_R(Self: TGameboardControl; var T: TSquare; const t1: Integer);
begin T := Self.SelSquares[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlSelection_W(Self: TGameboardControl; const T: TMovementPath);
begin Self.Selection := T; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlSelection_R(Self: TGameboardControl; var T: TMovementPath);
begin T := Self.Selection; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlCurrentPlayer_W(Self: TGameboardControl; const T: TPlayer);
begin Self.CurrentPlayer := T; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlCurrentPlayer_R(Self: TGameboardControl; var T: TPlayer);
begin T := Self.CurrentPlayer; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlOpenerPlayer_R(Self: TGameboardControl; var T: TPlayer);
begin T := Self.OpenerPlayer; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlLooserPlayer_R(Self: TGameboardControl; var T: TPlayer);
begin T := Self.LooserPlayer; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlWinnerPlayer_R(Self: TGameboardControl; var T: TPlayer);
begin T := Self.WinnerPlayer; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlLegalMovesCount_R(Self: TGameboardControl; var T: Integer);
begin T := Self.LegalMovesCount; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlPlayedTimeOf_R(Self: TGameboardControl; var T: Cardinal; const t1: TPlayer);
begin T := Self.PlayedTimeOf[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlPlayedTurnsOf_R(Self: TGameboardControl; var T: Integer; const t1: TPlayer);
begin T := Self.PlayedTurnsOf[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlCurrentTimeOf_R(Self: TGameboardControl; var T: Cardinal; const t1: TPlayer);
begin T := Self.CurrentTimeOf[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlCurrentTurnOf_R(Self: TGameboardControl; var T: Integer; const t1: TPlayer);
begin T := Self.CurrentTurnOf[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlPlayedTime_R(Self: TGameboardControl; var T: Cardinal);
begin T := Self.PlayedTime; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlPlayedTurns_R(Self: TGameboardControl; var T: Integer);
begin T := Self.PlayedTurns; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlCurrentTime_R(Self: TGameboardControl; var T: Cardinal);
begin T := Self.CurrentTime; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlCurrentTurn_R(Self: TGameboardControl; var T: Integer);
begin T := Self.CurrentTurn; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlElapsedTime_R(Self: TGameboardControl; var T: Cardinal);
begin T := Self.ElapsedTime; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlPlaying_R(Self: TGameboardControl; var T: Boolean);
begin T := Self.Playing; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlThinking_R(Self: TGameboardControl; var T: Boolean);
begin T := Self.Thinking; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlMoving_R(Self: TGameboardControl; var T: Boolean);
begin T := Self.Moving; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlAnimating_R(Self: TGameboardControl; var T: Boolean);
begin T := Self.Animating; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlDraggingSquare_R(Self: TGameboardControl; var T: TSquare);
begin T := Self.DraggingSquare; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlSquareBounds_R(Self: TGameboardControl; var T: TRect; const t1: TSquare);
begin T := Self.SquareBounds[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlFullBoardBounds_R(Self: TGameboardControl; var T: TRect);
begin T := Self.FullBoardBounds; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardControlBoardBounds_R(Self: TGameboardControl; var T: TRect);
begin T := Self.BoardBounds; end;

(*----------------------------------------------------------------------------*)
procedure TGameHistoryOnChange_W(Self: TGameHistory; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TGameHistoryOnChange_R(Self: TGameHistory; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TGameHistoryItems_R(Self: TGameHistory; var T: TGameHistoryRec; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TGameHistoryPlayers_R(Self: TGameHistory; var T: TPlayer; const t1: Integer);
begin T := Self.Players[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TGameHistoryCurrent_W(Self: TGameHistory; const T: Integer);
begin Self.Current := T; end;

(*----------------------------------------------------------------------------*)
procedure TGameHistoryCurrent_R(Self: TGameHistory; var T: Integer);
begin T := Self.Current; end;

(*----------------------------------------------------------------------------*)
procedure TGameHistoryInitialBoard_R(Self: TGameHistory; var T: TGameboard);
begin T := Self.InitialBoard; end;

(*----------------------------------------------------------------------------*)
procedure TGameHistoryIsClosed_R(Self: TGameHistory; var T: Boolean);
begin T := Self.IsClosed; end;

(*----------------------------------------------------------------------------*)
Function TGameHistoryIndexOf1_P(Self: TGameHistory;  Player : TPlayer; TurnNo : Integer) : Integer;
Begin Result := Self.IndexOf(Player, TurnNo); END;

(*----------------------------------------------------------------------------*)
Function TGameHistoryIndexOf0_P(Self: TGameHistory;  AGameHistoryRec : TGameHistoryRec) : Integer;
Begin Result := Self.IndexOf(AGameHistoryRec); END;

(*----------------------------------------------------------------------------*)
procedure TGameHistoryRecCompleted_W(Self: TGameHistoryRec; const T: Boolean);
begin Self.Completed := T; end;

(*----------------------------------------------------------------------------*)
procedure TGameHistoryRecCompleted_R(Self: TGameHistoryRec; var T: Boolean);
begin T := Self.Completed; end;

(*----------------------------------------------------------------------------*)
procedure TGameHistoryRecElapsedTime_W(Self: TGameHistoryRec; const T: Cardinal);
begin Self.ElapsedTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TGameHistoryRecElapsedTime_R(Self: TGameHistoryRec; var T: Cardinal);
begin T := Self.ElapsedTime; end;

(*----------------------------------------------------------------------------*)
procedure TGameHistoryRecMovementPath_W(Self: TGameHistoryRec; const T: TMovementPath);
begin Self.MovementPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TGameHistoryRecMovementPath_R(Self: TGameHistoryRec; var T: TMovementPath);
begin T := Self.MovementPath; end;

(*----------------------------------------------------------------------------*)
procedure TGameHistoryRecBoardAfterMove_R(Self: TGameHistoryRec; var T: TMemoryStream);
begin T := Self.BoardAfterMove; end;

(*----------------------------------------------------------------------------*)
procedure TAnimatorAnimateStep_W(Self: TAnimator; const T: Byte);
begin Self.AnimateStep := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimatorAnimateStep_R(Self: TAnimator; var T: Byte);
begin T := Self.AnimateStep; end;

(*----------------------------------------------------------------------------*)
procedure TAnimatorAnimateDelay_W(Self: TAnimator; const T: Byte);
begin Self.AnimateDelay := T; end;

(*----------------------------------------------------------------------------*)
procedure TAnimatorAnimateDelay_R(Self: TAnimator; var T: Byte);
begin T := Self.AnimateDelay; end;

(*----------------------------------------------------------------------------*)
procedure TGameSolverMaxMemory_W(Self: TGameSolver; const T: Cardinal);
begin Self.MaxMemory := T; end;

(*----------------------------------------------------------------------------*)
procedure TGameSolverMaxMemory_R(Self: TGameSolver; var T: Cardinal);
begin T := Self.MaxMemory; end;

(*----------------------------------------------------------------------------*)
procedure TGameSolverSearchDepth_W(Self: TGameSolver; const T: Byte);
begin Self.SearchDepth := T; end;

(*----------------------------------------------------------------------------*)
procedure TGameSolverSearchDepth_R(Self: TGameSolver; var T: Byte);
begin T := Self.SearchDepth; end;

(*----------------------------------------------------------------------------*)
procedure TGameSolverState_W(Self: TGameSolver; const T: TSearchControl);
begin Self.State := T; end;

(*----------------------------------------------------------------------------*)
procedure TGameSolverState_R(Self: TGameSolver; var T: TSearchControl);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure TGameSolverNotifyWnd_W(Self: TGameSolver; const T: HWND);
begin Self.NotifyWnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TGameSolverNotifyWnd_R(Self: TGameSolver; var T: HWND);
begin T := Self.NotifyWnd; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardOnChange_W(Self: TGameboard; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardOnChange_R(Self: TGameboard; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardOnTurn_W(Self: TGameboard; const T: TNotifyEvent);
begin Self.OnTurn := T; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardOnTurn_R(Self: TGameboard; var T: TNotifyEvent);
begin T := Self.OnTurn; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardPlayer_W(Self: TGameboard; const T: TPlayer);
begin Self.Player := T; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardPlayer_R(Self: TGameboard; var T: TPlayer);
begin T := Self.Player; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardBoardAsText_W(Self: TGameboard; const T: String);
begin Self.BoardAsText := T; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardBoardAsText_R(Self: TGameboard; var T: String);
begin T := Self.BoardAsText; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardLegalMovesCount_R(Self: TGameboard; var T: Integer);
begin T := Self.LegalMovesCount; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardEndState_R(Self: TGameboard; var T: TGameEndState);
begin T := Self.EndState; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardLooser_R(Self: TGameboard; var T: TPlayer);
begin T := Self.Looser; end;

(*----------------------------------------------------------------------------*)
procedure TGameboardWinner_R(Self: TGameboard; var T: TPlayer);
begin T := Self.Winner; end;

(*----------------------------------------------------------------------------*)
procedure TPositionTableUsedSize_R(Self: TPositionTable; var T: Cardinal);
begin T := Self.UsedSize; end;

(*----------------------------------------------------------------------------*)
procedure TPositionTableSize_W(Self: TPositionTable; const T: Cardinal);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TPositionTableSize_R(Self: TPositionTable; var T: Cardinal);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TPositionTableNumOfUsedCells_R(Self: TPositionTable; var T: Cardinal);
begin T := Self.NumOfUsedCells; end;

(*----------------------------------------------------------------------------*)
procedure TPositionTableNumOfCells_W(Self: TPositionTable; const T: Cardinal);
begin Self.NumOfCells := T; end;

(*----------------------------------------------------------------------------*)
procedure TPositionTableNumOfCells_R(Self: TPositionTable; var T: Cardinal);
begin T := Self.NumOfCells; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Gameboard_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Opponent, 'Opponent', cdRegister);
 S.RegisterDelphiFunction(@InitZobritsNumbers, 'InitZobritsNumbers', cdRegister);
 S.RegisterDelphiFunction(@SaveStringToStream, 'SaveStringToStream', cdRegister);
 S.RegisterDelphiFunction(@LoadStringFromStream, 'LoadStringFromStream', cdRegister);
 S.RegisterDelphiFunction(@WaitForSyncObject, 'WaitForSyncObject2', cdRegister);
 S.RegisterDelphiFunction(@ProcessMessage, 'ProcessMessage', cdRegister);
 S.RegisterDelphiFunction(@ProcessMessages, 'ProcessMessages', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGameboardControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGameboardControl) do begin
    RegisterConstructor(@TGameboardControl.Create, 'Create');
    RegisterMethod(@TGameboardControl.Destroy, 'Free');

    RegisterVirtualMethod(@TGameboardControl.StartNewGame, 'StartNewGame');
    RegisterVirtualMethod(@TGameboardControl.ClearBoard, 'ClearBoard');
    RegisterVirtualMethod(@TGameboardControl.BeginUpdate, 'BeginUpdate');
    RegisterVirtualMethod(@TGameboardControl.EndUpdate, 'EndUpdate');
    RegisterVirtualMethod(@TGameboardControl.SaveToStream, 'SaveToStream');
    RegisterVirtualMethod(@TGameboardControl.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TGameboardControl.SaveToFile, 'SaveToFile');
    RegisterVirtualMethod(@TGameboardControl.LoadFromFile, 'LoadFromFile');
    RegisterVirtualMethod(@TGameboardControl.IsGameEnded, 'IsGameEnded');
    RegisterVirtualMethod(@TGameboardControl.IsGameDraw, 'IsGameDraw');
    RegisterVirtualMethod(@TGameboardControl.CanMoveBackward, 'CanMoveBackward');
    RegisterVirtualMethod(@TGameboardControl.MoveBackward, 'MoveBackward');
    RegisterVirtualMethod(@TGameboardControl.MoveToFirst, 'MoveToFirst');
    RegisterVirtualMethod(@TGameboardControl.CanMoveForward, 'CanMoveForward');
    RegisterVirtualMethod(@TGameboardControl.MoveForward, 'MoveForward');
    RegisterVirtualMethod(@TGameboardControl.MoveToLast, 'MoveToLast');
    RegisterVirtualMethod(@TGameboardControl.CanRetrieve, 'CanRetrieve');
    RegisterVirtualMethod(@TGameboardControl.Retrieve, 'Retrieve');
    RegisterVirtualMethod(@TGameboardControl.ClearHistory, 'ClearHistory');
    RegisterVirtualMethod(@TGameboardControl.IsComputerTurn, 'IsComputerTurn');
    RegisterVirtualMethod(@TGameboardControl.PlayComputerTurnNow, 'PlayComputerTurnNow');
    RegisterVirtualMethod(@TGameboardControl.CancelThinking, 'CancelThinking');
    RegisterVirtualMethod(@TGameboardControl.SuggestMove, 'SuggestMove');
    RegisterVirtualMethod(@TGameboardControl.ClientToSquare, 'ClientToSquare');
    RegisterVirtualMethod(@TGameboardControl.ClearSelection, 'ClearSelection');
    RegisterVirtualMethod(@TGameboardControl.CompleteSelection, 'CompleteSelection');
    RegisterVirtualMethod(@TGameboardControl.IsSelectionComplete, 'IsSelectionComplete');
    RegisterVirtualMethod(@TGameboardControl.CanPlaySelection, 'CanPlaySelection');
    RegisterVirtualMethod(@TGameboardControl.PlaySelection, 'PlaySelection');
    //RegisterVirtualAbstractMethod(@TGameboardControl, @!.MoveOf, 'MoveOf');
    RegisterVirtualMethod(@TGameboardControl.TimeOf, 'TimeOf');
    RegisterVirtualMethod(@TGameboardControl.PlayerScore, 'PlayerScore');
    RegisterVirtualMethod(@TGameboardControl.MoveScore, 'MoveScore');
    RegisterPropertyHelper(@TGameboardControlBoardBounds_R,nil,'BoardBounds');
    RegisterPropertyHelper(@TGameboardControlFullBoardBounds_R,nil,'FullBoardBounds');
    RegisterPropertyHelper(@TGameboardControlSquareBounds_R,nil,'SquareBounds');
    RegisterPropertyHelper(@TGameboardControlDraggingSquare_R,nil,'DraggingSquare');
    RegisterPropertyHelper(@TGameboardControlAnimating_R,nil,'Animating');
    RegisterPropertyHelper(@TGameboardControlMoving_R,nil,'Moving');
    RegisterPropertyHelper(@TGameboardControlThinking_R,nil,'Thinking');
    RegisterPropertyHelper(@TGameboardControlPlaying_R,nil,'Playing');
    RegisterPropertyHelper(@TGameboardControlElapsedTime_R,nil,'ElapsedTime');
    RegisterPropertyHelper(@TGameboardControlCurrentTurn_R,nil,'CurrentTurn');
    RegisterPropertyHelper(@TGameboardControlCurrentTime_R,nil,'CurrentTime');
    RegisterPropertyHelper(@TGameboardControlPlayedTurns_R,nil,'PlayedTurns');
    RegisterPropertyHelper(@TGameboardControlPlayedTime_R,nil,'PlayedTime');
    RegisterPropertyHelper(@TGameboardControlCurrentTurnOf_R,nil,'CurrentTurnOf');
    RegisterPropertyHelper(@TGameboardControlCurrentTimeOf_R,nil,'CurrentTimeOf');
    RegisterPropertyHelper(@TGameboardControlPlayedTurnsOf_R,nil,'PlayedTurnsOf');
    RegisterPropertyHelper(@TGameboardControlPlayedTimeOf_R,nil,'PlayedTimeOf');
    RegisterPropertyHelper(@TGameboardControlLegalMovesCount_R,nil,'LegalMovesCount');
    RegisterPropertyHelper(@TGameboardControlWinnerPlayer_R,nil,'WinnerPlayer');
    RegisterPropertyHelper(@TGameboardControlLooserPlayer_R,nil,'LooserPlayer');
    RegisterPropertyHelper(@TGameboardControlOpenerPlayer_R,nil,'OpenerPlayer');
    RegisterPropertyHelper(@TGameboardControlCurrentPlayer_R,@TGameboardControlCurrentPlayer_W,'CurrentPlayer');
    RegisterPropertyHelper(@TGameboardControlSelection_R,@TGameboardControlSelection_W,'Selection');
    RegisterPropertyHelper(@TGameboardControlSelSquares_R,nil,'SelSquares');
    RegisterPropertyHelper(@TGameboardControlSelSquareCount_R,nil,'SelSquareCount');
    RegisterPropertyHelper(@TGameboardControlModified_R,@TGameboardControlModified_W,'Modified');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGameHistory(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGameHistory) do begin
    RegisterConstructor(@TGameHistory.Create, 'Create');
   RegisterMethod(@TGameHistory.Destroy, 'Free');
     RegisterMethod(@TGameHistory.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TGameHistory.EndUpdate, 'EndUpdate');
    RegisterMethod(@TGameHistory.Clear, 'Clear');
    RegisterVirtualMethod(@TGameHistory.Add, 'Add');
    RegisterVirtualMethod(@TGameHistory.SaveToStream, 'SaveToStream');
    RegisterVirtualMethod(@TGameHistory.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TGameHistoryIndexOf0_P, 'IndexOf0');
    RegisterMethod(@TGameHistoryIndexOf1_P, 'IndexOf1');
    RegisterMethod(@TGameHistory.TurnOf, 'TurnOf');
    RegisterMethod(@TGameHistory.TotalTimeOf, 'TotalTimeOf');
    RegisterMethod(@TGameHistory.CurrentTurnOf, 'CurrentTurnOf');
    RegisterMethod(@TGameHistory.PlayedTurnsOf, 'PlayedTurnsOf');
    RegisterMethod(@TGameHistory.PlayedTurns, 'PlayedTurns');
    RegisterMethod(@TGameHistory.IsCurrentStillRunning, 'IsCurrentStillRunning');
    RegisterPropertyHelper(@TGameHistoryIsClosed_R,nil,'IsClosed');
    RegisterPropertyHelper(@TGameHistoryInitialBoard_R,nil,'InitialBoard');
    RegisterPropertyHelper(@TGameHistoryCurrent_R,@TGameHistoryCurrent_W,'Current');
    RegisterPropertyHelper(@TGameHistoryPlayers_R,nil,'Players');
    RegisterPropertyHelper(@TGameHistoryItems_R,nil,'Items');
    RegisterPropertyHelper(@TGameHistoryOnChange_R,@TGameHistoryOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGameHistoryRec(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGameHistoryRec) do begin
    RegisterConstructor(@TGameHistoryRec.Create, 'Create');
   RegisterMethod(@TGameHistoryRec.Destroy, 'Free');

    RegisterVirtualMethod(@TGameHistoryRec.Clear, 'Clear');
    RegisterMethod(@TGameHistoryRec.Assign, 'Assign');
    RegisterMethod(@TGameHistoryRec.AssignTo, 'AssignTo');
    RegisterVirtualMethod(@TGameHistoryRec.SaveToStream, 'SaveToStream');
    RegisterVirtualMethod(@TGameHistoryRec.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TGameHistoryRec.AppendMove, 'AppendMove');
    RegisterVirtualMethod(@TGameHistoryRec.IsEmpty, 'IsEmpty');
    RegisterPropertyHelper(@TGameHistoryRecBoardAfterMove_R,nil,'BoardAfterMove');
    RegisterPropertyHelper(@TGameHistoryRecMovementPath_R,@TGameHistoryRecMovementPath_W,'MovementPath');
    RegisterPropertyHelper(@TGameHistoryRecElapsedTime_R,@TGameHistoryRecElapsedTime_W,'ElapsedTime');
    RegisterPropertyHelper(@TGameHistoryRecCompleted_R,@TGameHistoryRecCompleted_W,'Completed');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAnimator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAnimator) do begin
    RegisterConstructor(@TAnimator.Create, 'Create');
   RegisterMethod(@TAnimator.Destroy, 'Free');

    RegisterMethod(@TAnimator.Terminate, 'Terminate');
    RegisterMethod(@TAnimator.IsBusy, 'IsBusy');
    RegisterMethod(@TAnimator.WaitForIdle, 'WaitForIdle');
    RegisterMethod(@TAnimator.Animate, 'Animate');
    RegisterMethod(@TAnimator.CancelAnimation, 'CancelAnimation');
    RegisterPropertyHelper(@TAnimatorAnimateDelay_R,@TAnimatorAnimateDelay_W,'AnimateDelay');
    RegisterPropertyHelper(@TAnimatorAnimateStep_R,@TAnimatorAnimateStep_W,'AnimateStep');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGameSolver(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGameSolver) do begin
    RegisterConstructor(@TGameSolver.Create, 'Create');
   RegisterMethod(@TGameSolver.Destroy, 'Free');

    RegisterMethod(@TGameSolver.Terminate, 'Terminate');
    RegisterMethod(@TGameSolver.IsBusy, 'IsBusy');
    RegisterMethod(@TGameSolver.WaitForIdle, 'WaitForIdle');
    RegisterMethod(@TGameSolver.Solve, 'Solve');
    RegisterPropertyHelper(@TGameSolverNotifyWnd_R,@TGameSolverNotifyWnd_W,'NotifyWnd');
    RegisterPropertyHelper(@TGameSolverState_R,@TGameSolverState_W,'State');
    RegisterPropertyHelper(@TGameSolverSearchDepth_R,@TGameSolverSearchDepth_W,'SearchDepth');
    RegisterPropertyHelper(@TGameSolverMaxMemory_R,@TGameSolverMaxMemory_W,'MaxMemory');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGameboard(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGameboard) do
  begin
    RegisterVirtualConstructor(@TGameboard.Create, 'Create');
    RegisterVirtualMethod(@TGameboard.SaveToStream, 'SaveToStream');
    RegisterVirtualMethod(@TGameboard.LoadFromStream, 'LoadFromStream');
    //RegisterVirtualAbstractMethod(@TGameboard, @!.GetTextPresentation, 'GetTextPresentation');
    RegisterVirtualMethod(@TGameboard.BeginUpdate, 'BeginUpdate');
    RegisterVirtualMethod(@TGameboard.EndUpdate, 'EndUpdate');
    //RegisterVirtualAbstractMethod(@TGameboard, @!.StartNewGame, 'StartNewGame');
    RegisterVirtualMethod(@TGameboard.ClearBoard, 'ClearBoard');
    //RegisterVirtualAbstractMethod(@TGameboard, @!.ApplyLegalMove, 'ApplyLegalMove');
    RegisterVirtualMethod(@TGameboard.SearchForBestMove, 'SearchForBestMove');
    RegisterPropertyHelper(@TGameboardWinner_R,nil,'Winner');
    RegisterPropertyHelper(@TGameboardLooser_R,nil,'Looser');
    RegisterPropertyHelper(@TGameboardEndState_R,nil,'EndState');
    RegisterPropertyHelper(@TGameboardLegalMovesCount_R,nil,'LegalMovesCount');
    RegisterPropertyHelper(@TGameboardBoardAsText_R,@TGameboardBoardAsText_W,'BoardAsText');
    RegisterPropertyHelper(@TGameboardPlayer_R,@TGameboardPlayer_W,'Player');
    RegisterPropertyHelper(@TGameboardOnTurn_R,@TGameboardOnTurn_W,'OnTurn');
    RegisterPropertyHelper(@TGameboardOnChange_R,@TGameboardOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPositionTable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPositionTable) do begin
    RegisterMethod(@TPositionTable.Clear, 'Clear');
   RegisterMethod(@TPositionTable.Destroy, 'Free');
     RegisterMethod(@TPositionTable.SaveToStream, 'SaveToStream');
    RegisterMethod(@TPositionTable.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TPositionTable.BestMoveOf, 'BestMoveOf');
    RegisterMethod(@TPositionTable.Retrieve, 'Retrieve');
    RegisterMethod(@TPositionTable.Store, 'Store');
    RegisterPropertyHelper(@TPositionTableNumOfCells_R,@TPositionTableNumOfCells_W,'NumOfCells');
    RegisterPropertyHelper(@TPositionTableNumOfUsedCells_R,nil,'NumOfUsedCells');
    RegisterPropertyHelper(@TPositionTableSize_R,@TPositionTableSize_W,'Size');
    RegisterPropertyHelper(@TPositionTableUsedSize_R,nil,'UsedSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Gameboard(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EInvalidGameFile) do
  with CL.Add(TGameboard) do
  with CL.Add(TGameboardControl) do
  RIRegister_TPositionTable(CL);
  RIRegister_TGameboard(CL);
  RIRegister_TGameSolver(CL);
  RIRegister_TAnimator(CL);
  RIRegister_TGameHistoryRec(CL);
  RIRegister_TGameHistory(CL);
  RIRegister_TGameboardControl(CL);
end;



{ TPSImport_Gameboard }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Gameboard.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Gameboard(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Gameboard.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Gameboard(ri);
  RIRegister_Gameboard_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
