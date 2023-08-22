unit uPSI_ovccoco;
{
  coco mac max parser  add free
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
  TPSImport_ovccoco = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCocoRGrammar(CL: TPSPascalCompiler);
procedure SIRegister_TCocoRScanner(CL: TPSPascalCompiler);
procedure SIRegister_TSymbolPosition(CL: TPSPascalCompiler);
procedure SIRegister_TCommentList(CL: TPSPascalCompiler);
procedure SIRegister_TCommentItem(CL: TPSPascalCompiler);
procedure SIRegister_TCocoError(CL: TPSPascalCompiler);
procedure SIRegister_ovccoco(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ovccoco_Routines(S: TPSExec);
procedure RIRegister_TCocoRGrammar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCocoRScanner(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSymbolPosition(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCommentList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCommentItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCocoError(CL: TPSRuntimeClassImporter);
procedure RIRegister_ovccoco(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ovccoco
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovccoco]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCocoRGrammar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCocoRGrammar') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCocoRGrammar') do begin
    RegisterMethod('Function ErrorStr( const ErrorCode : integer; const Data : string) : string');
    RegisterProperty('ErrorList', 'TList', iptrw);
    RegisterProperty('SourceStream', 'TMemoryStream', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure GetLine( var pos : Integer; var line : string; var eof : boolean)');
    RegisterMethod('Function LexName : string');
    RegisterMethod('Function LexString : string');
    RegisterMethod('Function LookAheadName : string');
    RegisterMethod('Function LookAheadString : string');
    RegisterMethod('Procedure _StreamLine( s : string)');
    RegisterMethod('Procedure _StreamLn( const s : string)');
    RegisterMethod('Procedure SemError( const errNo : integer; const Data : string)');
    RegisterMethod('Procedure SynError( const errNo : integer)');
    RegisterProperty('Scanner', 'TCocoRScanner', iptrw);
    RegisterProperty('LineCount', 'integer', iptr);
    RegisterProperty('CharacterCount', 'integer', iptr);
    RegisterProperty('OnError', 'TErrorEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCocoRScanner(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TCocoRScanner') do
  with CL.AddClassN(CL.FindClass('TObject'),'TCocoRScanner') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function CharAt( pos : longint) : char');
    RegisterMethod('Function GetName( Symbol : TSymbolPosition) : string');
    RegisterMethod('Function GetString( Symbol : TSymbolPosition) : string');
    RegisterMethod('Procedure _Reset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSymbolPosition(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSymbolPosition') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSymbolPosition') do begin
    RegisterMethod('Procedure Clear');
    RegisterProperty('Line', 'integer', iptrw);
    RegisterProperty('Col', 'integer', iptrw);
    RegisterProperty('Len', 'integer', iptrw);
    RegisterProperty('Pos', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCommentList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TCommentList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TCommentList') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Add( const S : string; const aLine : integer; const aColumn : integer)');
    RegisterProperty('Comments', 'string integer', iptrw);
    SetDefaultPropery('Comments');
    RegisterProperty('Line', 'integer integer', iptrw);
    RegisterProperty('Column', 'integer integer', iptrw);
    RegisterProperty('Count', 'integer', iptr);
    RegisterProperty('Text', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCommentItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TCommentItem') do
  with CL.AddClassN(CL.FindClass('TObject'),'TCommentItem') do begin
    RegisterProperty('Comment', 'string', iptrw);
    RegisterProperty('Line', 'integer', iptrw);
    RegisterProperty('Column', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCocoError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TCocoError') do
  with CL.AddClassN(CL.FindClass('TObject'),'TCocoError') do
  begin
    RegisterProperty('ErrorType', 'integer', iptrw);
    RegisterProperty('ErrorCode', 'integer', iptrw);
    RegisterProperty('Line', 'integer', iptrw);
    RegisterProperty('Col', 'integer', iptrw);
    RegisterProperty('Data', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ovccoco(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ovsetsize','LongInt').SetInt( 16);
 CL.AddConstantN('etSyntax','LongInt').SetInt( 0);
 CL.AddConstantN('etSymantic','LongInt').SetInt( 1);
 CL.AddConstantN('chCR','Char').SetString( #13);
 CL.AddConstantN('chLF','Char').SetString( #10);
 CL.AddConstantN('chLineSeparator','Char').SetString( chCR);
  SIRegister_TCocoError(CL);
  SIRegister_TCommentItem(CL);
  SIRegister_TCommentList(CL);
  SIRegister_TSymbolPosition(CL);
  CL.AddTypeS('TGenListType', '( glNever, glAlways, glOnError )');
  //CL.AddTypeS('TovBitSet', 'set of Integer');
  //CL.AddTypeS('PStartTable', '^TStartTable // will not work');
  CL.AddTypeS('TovCharSet', 'set of Char');
  CL.AddTypeS('TAfterGenListEvent', 'Procedure ( Sender : TObject; var PrintErrorCount : boolean)');
  CL.AddTypeS('TCommentEvent', 'Procedure ( Sender : TObject; CommentList : TCommentList)');
  CL.AddTypeS('TCustomErrorEvent', 'Function(Sender: TObject; const ErrorCode: longint; const Data: string): string');
  CL.AddTypeS('TovErrorEvent', 'Procedure ( Sender : TObject; Error : TCocoError)');
  CL.AddTypeS('TovErrorProc', 'Procedure ( ErrorCode : integer; Symbol : TSymbolP'
   +'osition; const Data : string; ErrorType : integer)');
  CL.AddTypeS('TFailureEvent', 'Procedure ( Sender : TObject; NumErrors : integer)');
  CL.AddTypeS('TGetCH', 'Function ( pos : longint) : char');
  CL.AddTypeS('TStatusUpdateProc', 'Procedure ( Sender : TObject; Status : string; LineNum : integer)');
  SIRegister_TCocoRScanner(CL);
  SIRegister_TCocoRGrammar(CL);
 CL.AddConstantN('_EF','Char').SetString( #0);
 CL.AddConstantN('_TAB','Char').SetString( #09);
 CL.AddConstantN('_CR','Char').SetString( #13);
 CL.AddConstantN('_LF','Char').SetString( #10);
 CL.AddConstantN('_EL','char').SetString( #13);
 CL.AddConstantN('_EOF','Char').SetString( #26);
 //CL.AddConstantN('LineEnds','TovCharSet').SetInt(ord(_CR) or ord(_LF) or ord(_EF));
 CL.AddConstantN('minErrDist','LongInt').SetInt( 2);
 CL.AddDelphiFunction('Function ovPadL( S : string; ch : char; L : integer) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCocoRGrammarOnError_W(Self: TCocoRGrammar; const T: TErrorEvent);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TCocoRGrammarOnError_R(Self: TCocoRGrammar; var T: TErrorEvent);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TCocoRGrammarCharacterCount_R(Self: TCocoRGrammar; var T: integer);
begin T := Self.CharacterCount; end;

(*----------------------------------------------------------------------------*)
procedure TCocoRGrammarLineCount_R(Self: TCocoRGrammar; var T: integer);
begin T := Self.LineCount; end;

(*----------------------------------------------------------------------------*)
procedure TCocoRGrammarScanner_W(Self: TCocoRGrammar; const T: TCocoRScanner);
begin Self.Scanner := T; end;

(*----------------------------------------------------------------------------*)
procedure TCocoRGrammarScanner_R(Self: TCocoRGrammar; var T: TCocoRScanner);
begin T := Self.Scanner; end;

(*----------------------------------------------------------------------------*)
procedure TCocoRGrammarSourceStream_W(Self: TCocoRGrammar; const T: TMemoryStream);
begin Self.SourceStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TCocoRGrammarSourceStream_R(Self: TCocoRGrammar; var T: TMemoryStream);
begin T := Self.SourceStream; end;

(*----------------------------------------------------------------------------*)
procedure TCocoRGrammarErrorList_W(Self: TCocoRGrammar; const T: TList);
begin Self.ErrorList := T; end;

(*----------------------------------------------------------------------------*)
procedure TCocoRGrammarErrorList_R(Self: TCocoRGrammar; var T: TList);
begin T := Self.ErrorList; end;

(*----------------------------------------------------------------------------*)
procedure TSymbolPositionPos_W(Self: TSymbolPosition; const T: integer);
begin Self.Pos := T; end;

(*----------------------------------------------------------------------------*)
procedure TSymbolPositionPos_R(Self: TSymbolPosition; var T: integer);
begin T := Self.Pos; end;

(*----------------------------------------------------------------------------*)
procedure TSymbolPositionLen_W(Self: TSymbolPosition; const T: integer);
begin Self.Len := T; end;

(*----------------------------------------------------------------------------*)
procedure TSymbolPositionLen_R(Self: TSymbolPosition; var T: integer);
begin T := Self.Len; end;

(*----------------------------------------------------------------------------*)
procedure TSymbolPositionCol_W(Self: TSymbolPosition; const T: integer);
begin Self.Col := T; end;

(*----------------------------------------------------------------------------*)
procedure TSymbolPositionCol_R(Self: TSymbolPosition; var T: integer);
begin T := Self.Col; end;

(*----------------------------------------------------------------------------*)
procedure TSymbolPositionLine_W(Self: TSymbolPosition; const T: integer);
begin Self.Line := T; end;

(*----------------------------------------------------------------------------*)
procedure TSymbolPositionLine_R(Self: TSymbolPosition; var T: integer);
begin T := Self.Line; end;

(*----------------------------------------------------------------------------*)
procedure TCommentListText_R(Self: TCommentList; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TCommentListCount_R(Self: TCommentList; var T: integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TCommentListColumn_W(Self: TCommentList; const T: integer; const t1: integer);
begin Self.Column[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCommentListColumn_R(Self: TCommentList; var T: integer; const t1: integer);
begin T := Self.Column[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCommentListLine_W(Self: TCommentList; const T: integer; const t1: integer);
begin Self.Line[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCommentListLine_R(Self: TCommentList; var T: integer; const t1: integer);
begin T := Self.Line[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCommentListComments_W(Self: TCommentList; const T: string; const t1: integer);
begin Self.Comments[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCommentListComments_R(Self: TCommentList; var T: string; const t1: integer);
begin T := Self.Comments[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCommentItemColumn_W(Self: TCommentItem; const T: integer);
begin Self.Column := T; end;

(*----------------------------------------------------------------------------*)
procedure TCommentItemColumn_R(Self: TCommentItem; var T: integer);
begin T := Self.Column; end;

(*----------------------------------------------------------------------------*)
procedure TCommentItemLine_W(Self: TCommentItem; const T: integer);
begin Self.Line := T; end;

(*----------------------------------------------------------------------------*)
procedure TCommentItemLine_R(Self: TCommentItem; var T: integer);
begin T := Self.Line; end;

(*----------------------------------------------------------------------------*)
procedure TCommentItemComment_W(Self: TCommentItem; const T: string);
begin Self.Comment := T; end;

(*----------------------------------------------------------------------------*)
procedure TCommentItemComment_R(Self: TCommentItem; var T: string);
begin T := Self.Comment; end;

(*----------------------------------------------------------------------------*)
procedure TCocoErrorData_W(Self: TCocoError; const T: string);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TCocoErrorData_R(Self: TCocoError; var T: string);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TCocoErrorCol_W(Self: TCocoError; const T: integer);
begin Self.Col := T; end;

(*----------------------------------------------------------------------------*)
procedure TCocoErrorCol_R(Self: TCocoError; var T: integer);
begin T := Self.Col; end;

(*----------------------------------------------------------------------------*)
procedure TCocoErrorLine_W(Self: TCocoError; const T: integer);
begin Self.Line := T; end;

(*----------------------------------------------------------------------------*)
procedure TCocoErrorLine_R(Self: TCocoError; var T: integer);
begin T := Self.Line; end;

(*----------------------------------------------------------------------------*)
procedure TCocoErrorErrorCode_W(Self: TCocoError; const T: integer);
begin Self.ErrorCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TCocoErrorErrorCode_R(Self: TCocoError; var T: integer);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure TCocoErrorErrorType_W(Self: TCocoError; const T: integer);
begin Self.ErrorType := T; end;

(*----------------------------------------------------------------------------*)
procedure TCocoErrorErrorType_R(Self: TCocoError; var T: integer);
begin T := Self.ErrorType; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovccoco_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@PadL, 'ovPadL', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCocoRGrammar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCocoRGrammar) do begin
    //RegisterVirtualAbstractMethod(@TCocoRGrammar, @!.ErrorStr, 'ErrorStr');
    RegisterPropertyHelper(@TCocoRGrammarErrorList_R,@TCocoRGrammarErrorList_W,'ErrorList');
    RegisterPropertyHelper(@TCocoRGrammarSourceStream_R,@TCocoRGrammarSourceStream_W,'SourceStream');
    RegisterConstructor(@TCocoRGrammar.Create, 'Create');
      RegisterMethod(@TCocoRGrammar.Destroy, 'Free');
      RegisterMethod(@TCocoRGrammar.GetLine, 'GetLine');
    RegisterMethod(@TCocoRGrammar.LexName, 'LexName');
    RegisterMethod(@TCocoRGrammar.LexString, 'LexString');
    RegisterMethod(@TCocoRGrammar.LookAheadName, 'LookAheadName');
    RegisterMethod(@TCocoRGrammar.LookAheadString, 'LookAheadString');
    RegisterMethod(@TCocoRGrammar._StreamLine, '_StreamLine');
    RegisterMethod(@TCocoRGrammar._StreamLn, '_StreamLn');
    RegisterMethod(@TCocoRGrammar.SemError, 'SemError');
    RegisterMethod(@TCocoRGrammar.SynError, 'SynError');
    RegisterPropertyHelper(@TCocoRGrammarScanner_R,@TCocoRGrammarScanner_W,'Scanner');
    RegisterPropertyHelper(@TCocoRGrammarLineCount_R,nil,'LineCount');
    RegisterPropertyHelper(@TCocoRGrammarCharacterCount_R,nil,'CharacterCount');
    RegisterPropertyHelper(@TCocoRGrammarOnError_R,@TCocoRGrammarOnError_W,'OnError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCocoRScanner(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCocoRScanner) do begin
    RegisterConstructor(@TCocoRScanner.Create, 'Create');
      RegisterMethod(@TCocoRScanner.Destroy, 'Free');
      RegisterMethod(@TCocoRScanner.CharAt, 'CharAt');
    RegisterMethod(@TCocoRScanner.GetName, 'GetName');
    RegisterMethod(@TCocoRScanner.GetString, 'GetString');
    RegisterMethod(@TCocoRScanner._Reset, '_Reset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSymbolPosition(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSymbolPosition) do begin
    RegisterMethod(@TSymbolPosition.Clear, 'Clear');
    RegisterPropertyHelper(@TSymbolPositionLine_R,@TSymbolPositionLine_W,'Line');
    RegisterPropertyHelper(@TSymbolPositionCol_R,@TSymbolPositionCol_W,'Col');
    RegisterPropertyHelper(@TSymbolPositionLen_R,@TSymbolPositionLen_W,'Len');
    RegisterPropertyHelper(@TSymbolPositionPos_R,@TSymbolPositionPos_W,'Pos');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCommentList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCommentList) do begin
    RegisterConstructor(@TCommentList.Create, 'Create');
      RegisterMethod(@TCommentList.Destroy, 'Free');
      RegisterMethod(@TCommentList.Clear, 'Clear');
    RegisterMethod(@TCommentList.Add, 'Add');
    RegisterPropertyHelper(@TCommentListComments_R,@TCommentListComments_W,'Comments');
    RegisterPropertyHelper(@TCommentListLine_R,@TCommentListLine_W,'Line');
    RegisterPropertyHelper(@TCommentListColumn_R,@TCommentListColumn_W,'Column');
    RegisterPropertyHelper(@TCommentListCount_R,nil,'Count');
    RegisterPropertyHelper(@TCommentListText_R,nil,'Text');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCommentItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCommentItem) do begin
    RegisterPropertyHelper(@TCommentItemComment_R,@TCommentItemComment_W,'Comment');
    RegisterPropertyHelper(@TCommentItemLine_R,@TCommentItemLine_W,'Line');
    RegisterPropertyHelper(@TCommentItemColumn_R,@TCommentItemColumn_W,'Column');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCocoError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCocoError) do
  begin
    RegisterPropertyHelper(@TCocoErrorErrorType_R,@TCocoErrorErrorType_W,'ErrorType');
    RegisterPropertyHelper(@TCocoErrorErrorCode_R,@TCocoErrorErrorCode_W,'ErrorCode');
    RegisterPropertyHelper(@TCocoErrorLine_R,@TCocoErrorLine_W,'Line');
    RegisterPropertyHelper(@TCocoErrorCol_R,@TCocoErrorCol_W,'Col');
    RegisterPropertyHelper(@TCocoErrorData_R,@TCocoErrorData_W,'Data');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovccoco(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCocoError(CL);
  RIRegister_TCommentItem(CL);
  RIRegister_TCommentList(CL);
  RIRegister_TSymbolPosition(CL);
  RIRegister_TCocoRScanner(CL);
  RIRegister_TCocoRGrammar(CL);
end;

 
 
{ TPSImport_ovccoco }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovccoco.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovccoco(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovccoco.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ovccoco(ri);
  RIRegister_ovccoco_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
