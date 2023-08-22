unit uPSI_cBlaiseParserLexer;
{
this is for a interactive command shell of maXbox  like jupyter

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
  TPSImport_cBlaiseParserLexer = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_EBlaiseLexer(CL: TPSPascalCompiler);
procedure SIRegister_TBlaiseLexer(CL: TPSPascalCompiler);
procedure SIRegister_cBlaiseParserLexer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_EBlaiseLexer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBlaiseLexer(CL: TPSRuntimeClassImporter);
procedure RIRegister_cBlaiseParserLexer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   cUtils
  ,cBlaiseParserLexer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cBlaiseParserLexer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_EBlaiseLexer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EBlaiseLexer') do
  with CL.AddClassN(CL.FindClass('Exception'),'EBlaiseLexer') do
  begin
    RegisterProperty('Parser', 'TBlaiseLexer', iptrw);
    RegisterProperty('LineNr', 'Integer', iptrw);
    RegisterProperty('Column', 'Integer', iptrw);
    RegisterProperty('Position', 'Integer', iptrw);
    RegisterMethod('Constructor Create( const Parser : TBlaiseLexer; const Msg : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBlaiseLexer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TBlaiseLexer') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TBlaiseLexer') do begin
    RegisterProperty('TokenCount', 'Integer', iptrw);
    RegisterProperty('IdenCount', 'Integer', iptrw);
    RegisterProperty('SymbolCount', 'Integer', iptrw);
    RegisterProperty('IgnoreCount', 'Integer', iptrw);
    RegisterProperty('ReservedCount', 'Integer', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Reset');
    RegisterMethod('Procedure SetData( const Data : pchar; const Size : Integer)');
    RegisterMethod('Procedure SetText( const S : String; const StartPosition : Integer)');
    RegisterMethod('Function EOF : Boolean');
    RegisterMethod('Procedure GetToken');
    RegisterProperty('TokenLen', 'Integer', iptr);
    RegisterProperty('TokenType', 'Integer', iptr);
    RegisterMethod('Function TokenText : String');
    RegisterProperty('TokenPos', 'Integer', iptr);
    RegisterProperty('LastTokenEnd', 'Integer', iptr);
    RegisterProperty('Position', 'Integer', iptrw);
    RegisterProperty('LineNr', 'Integer', iptr);
    RegisterProperty('Column', 'Integer', iptr);
    RegisterProperty('CurrentLine', 'String', iptr);
    RegisterMethod('Function MatchType( const TokenType : Integer; const Skip : Boolean) : Boolean');
    RegisterMethod('Function MatchTokenText( const Token : String; const Skip : Boolean; const CaseSensitive : Boolean) : Boolean');
    RegisterMethod('Function TokenAsInteger : Int64');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cBlaiseParserLexer(CL: TPSPascalCompiler);
begin
{ CL.AddConstantN('c_True','String').SetString( 'True');
 CL.AddConstantN('c_False','String').SetString( 'False');
 CL.AddConstantN('c_Or','String').SetString( 'or');
 CL.AddConstantN('c_Xor','String').SetString( 'xor');
 CL.AddConstantN('c_And','String').SetString( 'and');
 CL.AddConstantN('c_Not','String').SetString( 'not');
 CL.AddConstantN('c_EqualTo','String').SetString( '=');
 CL.AddConstantN('c_NotEqual','String').SetString( '<>');
 CL.AddConstantN('c_LessThan','String').SetString( '<');
 CL.AddConstantN('c_GreaterThan','String').SetString( '>');
 CL.AddConstantN('c_LessOrEqual','String').SetString( '<=');
 CL.AddConstantN('c_GreaterOrEqual','String').SetString( '>=');
 CL.AddConstantN('c_RDiv','String').SetString( 'rdiv');
 CL.AddConstantN('c_Div','String').SetString( 'div');
 CL.AddConstantN('c_Mod','String').SetString( 'mod');
 CL.AddConstantN('c_Shl','String').SetString( 'shl');
 CL.AddConstantN('c_Shr','String').SetString( 'shr');
 CL.AddConstantN('c_Plus','String').SetString( '+');
 CL.AddConstantN('c_Minus','String').SetString( '-');
 CL.AddConstantN('c_Multiply','String').SetString( '*');
 CL.AddConstantN('c_Divide','String').SetString( '/');
 CL.AddConstantN('c_Power','String').SetString( '**');
 CL.AddConstantN('c_Concatenate','String').SetString( '&');
 CL.AddConstantN('c_nil','String').SetString( 'nil');
 CL.AddConstantN('c_self','String').SetString( 'self');
 CL.AddConstantN('c_inherited','String').SetString( 'inherited');
 CL.AddConstantN('c_Is','String').SetString( 'is');
 CL.AddConstantN('c_Named','String').SetString( 'named');
 CL.AddConstantN('c_Exists','String').SetString( 'exists');
 CL.AddConstantN('c_Delete','String').SetString( 'delete');
 CL.AddConstantN('c_Dir','String').SetString( 'dir');
 CL.AddConstantN('c_SDelim','String').SetString( ';');
 CL.AddConstantN('c_Assign','String').SetString( ':=');
 CL.AddConstantN('c_Begin','String').SetString( 'begin');
 CL.AddConstantN('c_End','String').SetString( 'end');
 CL.AddConstantN('c_If','String').SetString( 'if');
 CL.AddConstantN('c_Then','String').SetString( 'then');
 CL.AddConstantN('c_Else','String').SetString( 'else');
 CL.AddConstantN('c_Write','String').SetString( 'write');
 CL.AddConstantN('c_Writeln','String').SetString( 'writeln');
 CL.AddConstantN('c_Read','String').SetString( 'read');
 CL.AddConstantN('c_While','String').SetString( 'while');
 CL.AddConstantN('c_Do','String').SetString( 'do');
 CL.AddConstantN('c_Repeat','String').SetString( 'repeat');
 CL.AddConstantN('c_Until','String').SetString( 'until');
 CL.AddConstantN('c_For','String').SetString( 'for');
 CL.AddConstantN('c_To','String').SetString( 'to');
 CL.AddConstantN('c_In','String').SetString( 'in');
 CL.AddConstantN('c_Downto','String').SetString( 'downto');
 CL.AddConstantN('c_Step','String').SetString( 'step');
 CL.AddConstantN('c_Where','String').SetString( 'where');
 CL.AddConstantN('c_Case','String').SetString( 'case');
 CL.AddConstantN('c_Of','String').SetString( 'of');
 CL.AddConstantN('c_raise','String').SetString( 'raise');
 CL.AddConstantN('c_Try','String').SetString( 'try');
 CL.AddConstantN('c_Except','String').SetString( 'except');
 CL.AddConstantN('c_Finally','String').SetString( 'finally');
 CL.AddConstantN('c_On','String').SetString( 'on');
 CL.AddConstantN('c_Exit','String').SetString( 'exit');
 CL.AddConstantN('c_Break','String').SetString( 'break');
 CL.AddConstantN('c_Continue','String').SetString( 'continue');
 CL.AddConstantN('c_Return','String').SetString( 'return');
 CL.AddConstantN('c_Import','String').SetString( 'import');
 CL.AddConstantN('c_From','String').SetString( 'from');
 CL.AddConstantN('c_Program','String').SetString( 'program');
 CL.AddConstantN('c_Unit','String').SetString( 'unit');
 CL.AddConstantN('c_Interface','String').SetString( 'interface');
 CL.AddConstantN('c_Implementation','String').SetString( 'implementation');
 CL.AddConstantN('c_Initialization','String').SetString( 'initialization');
 CL.AddConstantN('c_Finalization','String').SetString( 'finalization');
 CL.AddConstantN('c_Uses','String').SetString( 'uses');
 CL.AddConstantN('c_Const','String').SetString( 'const');
 CL.AddConstantN('c_Var','String').SetString( 'var');
 CL.AddConstantN('c_Type','String').SetString( 'type');
 CL.AddConstantN('c_Function','String').SetString( 'function');
 CL.AddConstantN('c_Procedure','String').SetString( 'procedure');
 CL.AddConstantN('c_Task','String').SetString( 'task');
 CL.AddConstantN('c_Class','String').SetString( 'class');
 CL.AddConstantN('c_Public','String').SetString( 'public');
 CL.AddConstantN('c_Protected','String').SetString( 'protected');
 CL.AddConstantN('c_Private','String').SetString( 'private');
 CL.AddConstantN('c_Constructor','String').SetString( 'constructor');
 CL.AddConstantN('c_Destructor','String').SetString( 'destructor');
 CL.AddConstantN('c_Property','String').SetString( 'property');
 CL.AddConstantN('c_Record','String').SetString( 'record');
 CL.AddConstantN('c_overload','String').SetString( 'overload');
 CL.AddConstantN('c_virtual','String').SetString( 'virtual');
 CL.AddConstantN('c_abstract','String').SetString( 'abstract');
 CL.AddConstantN('c_override','String').SetString( 'override');
 CL.AddConstantN('c_reintroduce','String').SetString( 'reintroduce');
 CL.AddConstantN('c_Array','String').SetString( 'array');
 CL.AddConstantN('c_Dictionary','String').SetString( 'dictionary');
 CL.AddConstantN('c_Stream','String').SetString( 'stream');
 CL.AddConstantN('c_packed','String').SetString( 'packed');
 CL.AddConstantN('c_External','String').SetString( 'external');
 CL.AddConstantN('c_Name','String').SetString( 'name');
 CL.AddConstantN('c_CDecl','String').SetString( 'cdecl');
 CL.AddConstantN('c_StdCall','String').SetString( 'stdcall');
 CL.AddConstantN('c_SafeCall','String').SetString( 'safecall');
 CL.AddConstantN('c_Pascal','String').SetString( 'pascal');
 CL.AddConstantN('c_Register','String').SetString( 'register');
 CL.AddConstantN('ttEOF','LongWord').SetUInt( $00);
 CL.AddConstantN('ttInvalid','LongWord').SetUInt( $01);
 CL.AddConstantN('ttIgnore','LongWord').SetUInt( $02);
 CL.AddConstantN('ttSpace','LongWord').SetUInt( $03);
 CL.AddConstantN('ttEOL','LongWord').SetUInt( $04);
 CL.AddConstantN('ttIdentifier','LongWord').SetUInt( $05);
 CL.AddConstantN('ttNumber','LongWord').SetUInt( $10);
 CL.AddConstantN('ttHexNumber','LongWord').SetUInt( $11);
 CL.AddConstantN('ttHexNumber2','LongWord').SetUInt( $12);
 CL.AddConstantN('ttBinaryNumber','LongWord').SetUInt( $13);
 CL.AddConstantN('ttRealNumber','LongWord').SetUInt( $14);
 CL.AddConstantN('ttSciRealNumber','LongWord').SetUInt( $15);
 CL.AddConstantN('ttComplexNumber','LongWord').SetUInt( $16);
 CL.AddConstantN('ttStringLiteral','LongWord').SetUInt( $20);
 CL.AddConstantN('ttRegExLiteral','LongWord').SetUInt( $21);
 CL.AddConstantN('ttBlockComment1','LongWord').SetUInt( $30);
 CL.AddConstantN('ttBlockComment2','LongWord').SetUInt( $31);
 CL.AddConstantN('ttLineComment','LongWord').SetUInt( $32);
 CL.AddConstantN('ttReservedWord','LongWord').SetUInt( $40);
 CL.AddConstantN('ttBegin','LongInt').SetInt( ttReservedWord + 0);
 CL.AddConstantN('ttEnd','LongInt').SetInt( ttReservedWord + 1);
 CL.AddConstantN('ttIf','LongInt').SetInt( ttReservedWord + 2);
 CL.AddConstantN('ttThen','LongInt').SetInt( ttReservedWord + 3);
 CL.AddConstantN('ttElse','LongInt').SetInt( ttReservedWord + 4);
 CL.AddConstantN('ttConst','LongInt').SetInt( ttReservedWord + 5);
 CL.AddConstantN('ttType','LongInt').SetInt( ttReservedWord + 6);
 CL.AddConstantN('ttVar','LongInt').SetInt( ttReservedWord + 7);
 CL.AddConstantN('ttRepeat','LongInt').SetInt( ttReservedWord + 8);
 CL.AddConstantN('ttUntil','LongInt').SetInt( ttReservedWord + 9);
 CL.AddConstantN('ttFor','LongInt').SetInt( ttReservedWord + 10);
 CL.AddConstantN('ttTo','LongInt').SetInt( ttReservedWord + 11);
 CL.AddConstantN('ttDownto','LongInt').SetInt( ttReservedWord + 12);
 CL.AddConstantN('ttStep','LongInt').SetInt( ttReservedWord + 13);
 CL.AddConstantN('ttIn','LongInt').SetInt( ttReservedWord + 14);
 CL.AddConstantN('ttWhile','LongInt').SetInt( ttReservedWord + 15);
 CL.AddConstantN('ttDo','LongInt').SetInt( ttReservedWord + 16);
 CL.AddConstantN('ttCase','LongInt').SetInt( ttReservedWord + 17);
 CL.AddConstantN('ttOf','LongInt').SetInt( ttReservedWord + 18);
 CL.AddConstantN('ttProcedure','LongInt').SetInt( ttReservedWord + 19);
 CL.AddConstantN('ttFunction','LongInt').SetInt( ttReservedWord + 20);
 CL.AddConstantN('ttTask','LongInt').SetInt( ttReservedWord + 21);
 CL.AddConstantN('ttClass','LongInt').SetInt( ttReservedWord + 22);
 CL.AddConstantN('ttConstructor','LongInt').SetInt( ttReservedWord + 23);
 CL.AddConstantN('ttProgram','LongInt').SetInt( ttReservedWord + 24);
 CL.AddConstantN('ttUses','LongInt').SetInt( ttReservedWord + 25);
 CL.AddConstantN('ttPrivate','LongInt').SetInt( ttReservedWord + 26);
 CL.AddConstantN('ttProtected','LongInt').SetInt( ttReservedWord + 27);
 CL.AddConstantN('ttPublic','LongInt').SetInt( ttReservedWord + 28);
 CL.AddConstantN('ttUnit','LongInt').SetInt( ttReservedWord + 29);
 CL.AddConstantN('ttInterface','LongInt').SetInt( ttReservedWord + 30);
 CL.AddConstantN('ttImplementation','LongInt').SetInt( ttReservedWord + 31);
 CL.AddConstantN('ttInitialization','LongInt').SetInt( ttReservedWord + 32);
 CL.AddConstantN('ttFinalization','LongInt').SetInt( ttReservedWord + 33);
 CL.AddConstantN('ttVirtual','LongInt').SetInt( ttReservedWord + 34);
 CL.AddConstantN('ttAbstract','LongInt').SetInt( ttReservedWord + 35);
 CL.AddConstantN('ttOverride','LongInt').SetInt( ttReservedWord + 36);
 CL.AddConstantN('ttOverload','LongInt').SetInt( ttReservedWord + 37);
 CL.AddConstantN('ttReintroduce','LongInt').SetInt( ttReservedWord + 38);
 CL.AddConstantN('ttRecord','LongInt').SetInt( ttReservedWord + 39);
 CL.AddConstantN('ttTrue','LongInt').SetInt( ttReservedWord + 40);
 CL.AddConstantN('ttFalse','LongInt').SetInt( ttReservedWord + 41);
 CL.AddConstantN('ttOr','LongInt').SetInt( ttReservedWord + 42);
 CL.AddConstantN('ttXor','LongInt').SetInt( ttReservedWord + 43);
 CL.AddConstantN('ttDiv','LongInt').SetInt( ttReservedWord + 44);
 CL.AddConstantN('ttMod','LongInt').SetInt( ttReservedWord + 45);
 CL.AddConstantN('ttShl','LongInt').SetInt( ttReservedWord + 46);
 CL.AddConstantN('ttShr','LongInt').SetInt( ttReservedWord + 47);
 CL.AddConstantN('ttAnd','LongInt').SetInt( ttReservedWord + 48);
 CL.AddConstantN('ttNot','LongInt').SetInt( ttReservedWord + 49);
 CL.AddConstantN('ttProperty','LongInt').SetInt( ttReservedWord + 50);
 CL.AddConstantN('ttDestructor','LongInt').SetInt( ttReservedWord + 51);
 CL.AddConstantN('ttArray','LongInt').SetInt( ttReservedWord + 52);
 CL.AddConstantN('ttInherited','LongInt').SetInt( ttReservedWord + 53);
 CL.AddConstantN('ttPacked','LongInt').SetInt( ttReservedWord + 54);
 CL.AddConstantN('ttRaise','LongInt').SetInt( ttReservedWord + 55);
 CL.AddConstantN('ttIs','LongInt').SetInt( ttReservedWord + 56);
 CL.AddConstantN('ttTry','LongInt').SetInt( ttReservedWord + 57);
 CL.AddConstantN('ttExcept','LongInt').SetInt( ttReservedWord + 58);
 CL.AddConstantN('ttFinally','LongInt').SetInt( ttReservedWord + 59);
 CL.AddConstantN('ttOn','LongInt').SetInt( ttReservedWord + 60);
 CL.AddConstantN('ttSelf','LongInt').SetInt( ttReservedWord + 61);
 CL.AddConstantN('ttNil','LongInt').SetInt( ttReservedWord + 62);
 CL.AddConstantN('ttRDiv','LongInt').SetInt( ttReservedWord + 63);
 CL.AddConstantN('ttExit','LongInt').SetInt( ttReservedWord + 64);
 CL.AddConstantN('ttBreak','LongInt').SetInt( ttReservedWord + 65);
 CL.AddConstantN('ttContinue','LongInt').SetInt( ttReservedWord + 66);
 CL.AddConstantN('ttDictionary','LongInt').SetInt( ttReservedWord + 67);
 CL.AddConstantN('ttNamed','LongInt').SetInt( ttReservedWord + 68);
 CL.AddConstantN('ttWhere','LongInt').SetInt( ttReservedWord + 69);
 CL.AddConstantN('ttStream','LongInt').SetInt( ttReservedWord + 70);
 CL.AddConstantN('ttReturn','LongInt').SetInt( ttReservedWord + 71);
 CL.AddConstantN('ttImport','LongInt').SetInt( ttReservedWord + 72);
 CL.AddConstantN('ttFrom','LongInt').SetInt( ttReservedWord + 73);
 CL.AddConstantN('ttExternal','LongInt').SetInt( ttReservedWord + 74);
 CL.AddConstantN('ttCDecl','LongInt').SetInt( ttReservedWord + 75);
 CL.AddConstantN('ttPascal','LongInt').SetInt( ttReservedWord + 76);
 CL.AddConstantN('ttRegister','LongInt').SetInt( ttReservedWord + 77);
 CL.AddConstantN('ttStdCall','LongInt').SetInt( ttReservedWord + 78);
 CL.AddConstantN('ttSafeCall','LongInt').SetInt( ttReservedWord + 79);
 CL.AddConstantN('ttSymbol','LongWord').SetUInt( $C0);
 CL.AddConstantN('ttStatementDelim','LongInt').SetInt( ttSymbol + 0);
 CL.AddConstantN('ttDot','LongInt').SetInt( ttSymbol + 1);
 CL.AddConstantN('ttDotDot','LongInt').SetInt( ttSymbol + 2);
 CL.AddConstantN('ttDotDotDot','LongInt').SetInt( ttSymbol + 3);
 CL.AddConstantN('ttOpenBlockBracket','LongInt').SetInt( ttSymbol + 4);
 CL.AddConstantN('ttCloseBlockBracket','LongInt').SetInt( ttSymbol + 5);
 CL.AddConstantN('ttQuestionMark','LongInt').SetInt( ttSymbol + 6);
 CL.AddConstantN('ttComma','LongInt').SetInt( ttSymbol + 7);
 CL.AddConstantN('ttOpenBracket','LongInt').SetInt( ttSymbol + 8);
 CL.AddConstantN('ttCloseBracket','LongInt').SetInt( ttSymbol + 9);
 CL.AddConstantN('ttExclamationMark','LongInt').SetInt( ttSymbol + 10);
 CL.AddConstantN('ttCaret','LongInt').SetInt( ttSymbol + 11);
 CL.AddConstantN('ttBackSlash','LongInt').SetInt( ttSymbol + 12);
 CL.AddConstantN('ttAssignment','LongInt').SetInt( ttSymbol + 13);
 CL.AddConstantN('ttLessOrEqual','LongInt').SetInt( ttSymbol + 14);
 CL.AddConstantN('ttGreaterOrEqual','LongInt').SetInt( ttSymbol + 15);
 CL.AddConstantN('ttNotEqual','LongInt').SetInt( ttSymbol + 16);
 CL.AddConstantN('ttLess','LongInt').SetInt( ttSymbol + 17);
 CL.AddConstantN('ttGreater','LongInt').SetInt( ttSymbol + 18);
 CL.AddConstantN('ttEqual','LongInt').SetInt( ttSymbol + 19);
 CL.AddConstantN('ttPlus','LongInt').SetInt( ttSymbol + 20);
 CL.AddConstantN('ttMinus','LongInt').SetInt( ttSymbol + 21);
 CL.AddConstantN('ttMultiply','LongInt').SetInt( ttSymbol + 22);
 CL.AddConstantN('ttDivide','LongInt').SetInt( ttSymbol + 23);
 CL.AddConstantN('ttPower','LongInt').SetInt( ttSymbol + 24);
 CL.AddConstantN('ttHash','LongInt').SetInt( ttSymbol + 25);
 CL.AddConstantN('ttColon','LongInt').SetInt( ttSymbol + 26);  }
  CL.AddTypeS('TLexCharProc', 'Procedure ( const Ch : Char)');
  SIRegister_TBlaiseLexer(CL);
  SIRegister_EBlaiseLexer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure EBlaiseLexerPosition_W(Self: EBlaiseLexer; const T: Integer);
Begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure EBlaiseLexerPosition_R(Self: EBlaiseLexer; var T: Integer);
Begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure EBlaiseLexerColumn_W(Self: EBlaiseLexer; const T: Integer);
Begin Self.Column := T; end;

(*----------------------------------------------------------------------------*)
procedure EBlaiseLexerColumn_R(Self: EBlaiseLexer; var T: Integer);
Begin T := Self.Column; end;

(*----------------------------------------------------------------------------*)
procedure EBlaiseLexerLineNr_W(Self: EBlaiseLexer; const T: Integer);
Begin Self.LineNr := T; end;

(*----------------------------------------------------------------------------*)
procedure EBlaiseLexerLineNr_R(Self: EBlaiseLexer; var T: Integer);
Begin T := Self.LineNr; end;

(*----------------------------------------------------------------------------*)
procedure EBlaiseLexerParser_W(Self: EBlaiseLexer; const T: TBlaiseLexer);
Begin Self.Parser := T; end;

(*----------------------------------------------------------------------------*)
procedure EBlaiseLexerParser_R(Self: EBlaiseLexer; var T: TBlaiseLexer);
Begin T := Self.Parser; end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerCurrentLine_R(Self: TBlaiseLexer; var T: String);
begin T := Self.CurrentLine; end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerColumn_R(Self: TBlaiseLexer; var T: Integer);
begin T := Self.Column; end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerLineNr_R(Self: TBlaiseLexer; var T: Integer);
begin T := Self.LineNr; end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerPosition_W(Self: TBlaiseLexer; const T: Integer);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerPosition_R(Self: TBlaiseLexer; var T: Integer);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerLastTokenEnd_R(Self: TBlaiseLexer; var T: Integer);
begin T := Self.LastTokenEnd; end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerTokenPos_R(Self: TBlaiseLexer; var T: Integer);
begin T := Self.TokenPos; end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerTokenType_R(Self: TBlaiseLexer; var T: Integer);
begin T := Self.TokenType; end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerTokenLen_R(Self: TBlaiseLexer; var T: Integer);
begin T := Self.TokenLen; end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerReservedCount_W(Self: TBlaiseLexer; const T: Integer);
Begin Self.ReservedCount := T;
end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerReservedCount_R(Self: TBlaiseLexer; var T: Integer);
Begin T := Self.ReservedCount;
end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerIgnoreCount_W(Self: TBlaiseLexer; const T: Integer);
Begin Self.IgnoreCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerIgnoreCount_R(Self: TBlaiseLexer; var T: Integer);
Begin T := Self.IgnoreCount; end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerSymbolCount_W(Self: TBlaiseLexer; const T: Integer);
Begin Self.SymbolCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerSymbolCount_R(Self: TBlaiseLexer; var T: Integer);
Begin T := Self.SymbolCount; end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerIdenCount_W(Self: TBlaiseLexer; const T: Integer);
Begin Self.IdenCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerIdenCount_R(Self: TBlaiseLexer; var T: Integer);
Begin T := Self.IdenCount; end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerTokenCount_W(Self: TBlaiseLexer; const T: Integer);
Begin Self.TokenCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlaiseLexerTokenCount_R(Self: TBlaiseLexer; var T: Integer);
Begin T := Self.TokenCount; end;
 {
(*----------------------------------------------------------------------------*)
Function TBlaiseLexerExtractOne4_P(Self: TBlaiseLexer;  const C : CharSet) : Boolean;
Begin Result := Self.ExtractOne(C); END;   }

(*----------------------------------------------------------------------------*)
Function TBlaiseLexerExtractOne3_P(Self: TBlaiseLexer;  const C : Char) : Boolean;
Begin Result := Self.ExtractOne(C); END;

(*----------------------------------------------------------------------------*)
Function TBlaiseLexerRunTo2_P(Self: TBlaiseLexer;  const Delim : String; const SkipDelim : Boolean) : Boolean;
Begin Result := Self.RunTo(Delim, SkipDelim); END;
 {
(*----------------------------------------------------------------------------*)
Function TBlaiseLexerRunTo1_P(Self: TBlaiseLexer;  const C : CharSet) : Boolean;
Begin Result := Self.RunTo(C); END;   }

(*----------------------------------------------------------------------------*)
Function TBlaiseLexerRunTo0_P(Self: TBlaiseLexer;  const C : Char) : Boolean;
Begin Result := Self.RunTo(C); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EBlaiseLexer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EBlaiseLexer) do
  begin
    RegisterPropertyHelper(@EBlaiseLexerParser_R,@EBlaiseLexerParser_W,'Parser');
    RegisterPropertyHelper(@EBlaiseLexerLineNr_R,@EBlaiseLexerLineNr_W,'LineNr');
    RegisterPropertyHelper(@EBlaiseLexerColumn_R,@EBlaiseLexerColumn_W,'Column');
    RegisterPropertyHelper(@EBlaiseLexerPosition_R,@EBlaiseLexerPosition_W,'Position');
    RegisterConstructor(@EBlaiseLexer.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBlaiseLexer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBlaiseLexer) do
  begin
    RegisterPropertyHelper(@TBlaiseLexerTokenCount_R,@TBlaiseLexerTokenCount_W,'TokenCount');
    RegisterPropertyHelper(@TBlaiseLexerIdenCount_R,@TBlaiseLexerIdenCount_W,'IdenCount');
    RegisterPropertyHelper(@TBlaiseLexerSymbolCount_R,@TBlaiseLexerSymbolCount_W,'SymbolCount');
    RegisterPropertyHelper(@TBlaiseLexerIgnoreCount_R,@TBlaiseLexerIgnoreCount_W,'IgnoreCount');
    RegisterPropertyHelper(@TBlaiseLexerReservedCount_R,@TBlaiseLexerReservedCount_W,'ReservedCount');
    RegisterConstructor(@TBlaiseLexer.Create, 'Create');
    RegisterMethod(@TBlaiseLexer.Reset, 'Reset');
    RegisterMethod(@TBlaiseLexer.SetData, 'SetData');
    RegisterMethod(@TBlaiseLexer.SetText, 'SetText');
    RegisterMethod(@TBlaiseLexer.EOF, 'EOF');
    RegisterMethod(@TBlaiseLexer.GetToken, 'GetToken');
    RegisterPropertyHelper(@TBlaiseLexerTokenLen_R,nil,'TokenLen');
    RegisterPropertyHelper(@TBlaiseLexerTokenType_R,nil,'TokenType');
    RegisterMethod(@TBlaiseLexer.TokenText, 'TokenText');
    RegisterPropertyHelper(@TBlaiseLexerTokenPos_R,nil,'TokenPos');
    RegisterPropertyHelper(@TBlaiseLexerLastTokenEnd_R,nil,'LastTokenEnd');
    RegisterPropertyHelper(@TBlaiseLexerPosition_R,@TBlaiseLexerPosition_W,'Position');
    RegisterPropertyHelper(@TBlaiseLexerLineNr_R,nil,'LineNr');
    RegisterPropertyHelper(@TBlaiseLexerColumn_R,nil,'Column');
    RegisterPropertyHelper(@TBlaiseLexerCurrentLine_R,nil,'CurrentLine');
    RegisterMethod(@TBlaiseLexer.MatchType, 'MatchType');
    RegisterMethod(@TBlaiseLexer.MatchTokenText, 'MatchTokenText');
    RegisterMethod(@TBlaiseLexer.TokenAsInteger, 'TokenAsInteger');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cBlaiseParserLexer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBlaiseLexer(CL);
  RIRegister_EBlaiseLexer(CL);
end;

 
 
{ TPSImport_cBlaiseParserLexer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cBlaiseParserLexer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cBlaiseParserLexer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cBlaiseParserLexer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cBlaiseParserLexer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
