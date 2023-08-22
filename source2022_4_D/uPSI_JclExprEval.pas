unit uPSI_JclExprEval;
{
   to eval a maxtex lang
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
  TPSImport_JclExprEval = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


  { Brief: The type of token found by TExprLexer. }
 (* TExprToken2 = (

    // specials
    etEof,
    etNumber,
    etIdentifier,

    // user extension tokens
    etUser0, etUser1, etUser2, etUser3, etUser4, etUser5, etUser6, etUser7,
    etUser8, etUser9, etUser10, etUser11, etUser12, etUser13, etUser14, etUser15,
    etUser16, etUser17, etUser18, etUser19, etUser20, etUser21, etUser22, etUser23,
    etUser24, etUser25, etUser26, etUser27, etUser28, etUser29, etUser30, etUser31,

    // compound tokens
    etNotEqual, // <>
    etLessEqual, // <=
    etGreaterEqual, // >=

    // ASCII normal & ordinals

    etBang, // '!' #$21 33
    etDoubleQuote, // '"' #$22 34
    etHash, // '#' #$23 35
    etDollar, // '$' #$24 36
    etPercent, // '%' #$25 37
    etAmpersand, // '&' #$26 38
    etSingleQuote, // '''' #$27 39
    etLParen, // '(' #$28 40
    etRParen, // ')' #$29 41
    etAsterisk, // '*' #$2A 42
    etPlus, // '+' #$2B 43
    etComma, // ',' #$2C 44
    etMinus, // '-' #$2D 45
    etDot, // '.' #$2E 46
    etForwardSlash, // '/' #$2F 47

    // 48..57 - numbers...

    etColon, // ':' #$3A 58
    etSemiColon, // ';' #$3B 59
    etLessThan, // '<' #$3C 60
    etEqualTo, // '=' #$3D 61
    etGreaterThan, // '>' #$3E 62
    etQuestion, // '?' #$3F 63
    etAt, // '@' #$40 64

    // 65..90 - capital letters...

    etLBracket, // '[' #$5B 91
    etBackSlash, // '\' #$5C 92
    etRBracket, // ']' #$5D 93
    etArrow, // '^' #$5E 94
    // 95 - underscore
    etBackTick, // '`' #$60 96

    // 97..122 - small letters...

    etLBrace, // '{' #$7B 123
    etPipe, // '|' #$7C 124
    etRBrace, // '}' #$7D 125
    etTilde, // '~' #$7E 126
    et127, // '' #$7F 127
    etEuro, // 'Ä' #$80 128
    et129, // 'Å' #$81 129
    et130, // 'Ç' #$82 130
    et131, // 'É' #$83 131
    et132, // 'Ñ' #$84 132
    et133, // 'Ö' #$85 133
    et134, // 'Ü' #$86 134
    et135, // 'á' #$87 135
    et136, // 'à' #$88 136
    et137, // 'â' #$89 137
    et138, // 'ä' #$8A 138
    et139, // 'ã' #$8B 139
    et140, // 'å' #$8C 140
    et141, // 'ç' #$8D 141
    et142, // 'é' #$8E 142
    et143, // 'è' #$8F 143
    et144, // 'ê' #$90 144
    et145, // 'ë' #$91 145
    et146, // 'í' #$92 146
    et147, // 'ì' #$93 147
    et148, // 'î' #$94 148
    et149, // 'ï' #$95 149
    et150, // 'ñ' #$96 150
    et151, // 'ó' #$97 151
    et152, // 'ò' #$98 152
    et153, // 'ô' #$99 153
    et154, // 'ö' #$9A 154
    et155, // 'õ' #$9B 155
    et156, // 'ú' #$9C 156
    et157, // 'ù' #$9D 157
    et158, // 'û' #$9E 158
    et159, // 'ü' #$9F 159
    et160, // '†' #$A0 160
    et161, // '°' #$A1 161
    et162, // '¢' #$A2 162
    et163, // '£' #$A3 163
    et164, // '§' #$A4 164
    et165, // '•' #$A5 165
    et166, // '¶' #$A6 166
    et167, // 'ß' #$A7 167
    et168, // '®' #$A8 168
    et169, // '©' #$A9 169
    et170, // '™' #$AA 170
    et171, // '´' #$AB 171
    et172, // '¨' #$AC 172
    et173, // '≠' #$AD 173
    et174, // 'Æ' #$AE 174
    et175, // 'Ø' #$AF 175
    et176, // '∞' #$B0 176
    et177, // '±' #$B1 177
    et178, // '≤' #$B2 178
    et179, // '≥' #$B3 179
    et180, // '¥' #$B4 180
    et181, // 'µ' #$B5 181
    et182, // '∂' #$B6 182
    et183, // '∑' #$B7 183
    et184, // '∏' #$B8 184
    et185, // 'π' #$B9 185
    et186, // '∫' #$BA 186
    et187, // 'ª' #$BB 187
    et188, // 'º' #$BC 188
    et189, // 'Ω' #$BD 189
    et190, // 'æ' #$BE 190
    et191, // 'ø' #$BF 191
    et192, // '¿' #$C0 192
    et193, // '¡' #$C1 193
    et194, // '¬' #$C2 194
    et195, // '√' #$C3 195
    et196, // 'ƒ' #$C4 196
    et197, // '≈' #$C5 197
    et198, // '∆' #$C6 198
    et199, // '«' #$C7 199
    et200, // '»' #$C8 200
    et201, // '…' #$C9 201
    et202, // ' ' #$CA 202
    et203, // 'À' #$CB 203
    et204, // 'Ã' #$CC 204
    et205, // 'Õ' #$CD 205
    et206, // 'Œ' #$CE 206
    et207, // 'œ' #$CF 207
    et208, // '–' #$D0 208
    et209, // '—' #$D1 209
    et210, // '“' #$D2 210
    et211, // '”' #$D3 211
    et212, // '‘' #$D4 212
    et213, // '’' #$D5 213
    et214, // '÷' #$D6 214
    et215, // '◊' #$D7 215
    et216, // 'ÿ' #$D8 216
    et217, // 'Ÿ' #$D9 217
    et218, // '⁄' #$DA 218
    et219, // '€' #$DB 219
    et220, // '‹' #$DC 220
    et221, // '›' #$DD 221
    et222, // 'ﬁ' #$DE 222
    et223, // 'ﬂ' #$DF 223
    et224, // '‡' #$E0 224
    et225, // '·' #$E1 225
    et226, // '‚' #$E2 226
    et227, // '„' #$E3 227
    et228, // '‰' #$E4 228
    et229, // 'Â' #$E5 229
    et230, // 'Ê' #$E6 230
    et231, // 'Á' #$E7 231
    et232, // 'Ë' #$E8 232
    et233, // 'È' #$E9 233
    et234, // 'Í' #$EA 234
    et235, // 'Î' #$EB 235
    et236, // 'Ï' #$EC 236
    et237, // 'Ì' #$ED 237
    et238, // 'Ó' #$EE 238
    et239, // 'Ô' #$EF 239
    et240, // '' #$F0 240
    et241, // 'Ò' #$F1 241
    et242, // 'Ú' #$F2 242
    et243, // 'Û' #$F3 243
    et244, // 'Ù' #$F4 244
    et245, // 'ı' #$F5 245
    et246, // 'ˆ' #$F6 246
    et247, // '˜' #$F7 247
    et248, // '¯' #$F8 248
    et249, // '˘' #$F9 249
    et250, // '˙' #$FA 250
    et251, // '˚' #$FB 251
    et252, // '¸' #$FC 252
    et253, // '˝' #$FD 253
    et254, // '˛' #$FE 254
    et255, // 'ˇ' #$FF 255
    etInvalid // invalid token type
  );


  type TExprToken = TExprToken2;     *)
 
 
{ compile-time registration functions }
procedure SIRegister_TExpressionCompiler(CL: TPSPascalCompiler);
procedure SIRegister_TCompiledEvaluator(CL: TPSPascalCompiler);
procedure SIRegister_TEvaluator(CL: TPSPascalCompiler);
procedure SIRegister_TEasyEvaluator(CL: TPSPascalCompiler);
procedure SIRegister_TExprTernary80FuncSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprTernary64FuncSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprTernary32FuncSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprTernaryFuncSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprBinary80FuncSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprBinary64FuncSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprBinary32FuncSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprBinaryFuncSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprUnary80FuncSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprUnary64FuncSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprUnary32FuncSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprUnaryFuncSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprFloat80FuncSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprFloat64FuncSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprFloat32FuncSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprFuncSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprAbstractFuncSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprVar80Sym(CL: TPSPascalCompiler);
procedure SIRegister_TExprVar64Sym(CL: TPSPascalCompiler);
procedure SIRegister_TExprVar32Sym(CL: TPSPascalCompiler);
procedure SIRegister_TExprConst80Sym(CL: TPSPascalCompiler);
procedure SIRegister_TExprConst64Sym(CL: TPSPascalCompiler);
procedure SIRegister_TExprConst32Sym(CL: TPSPascalCompiler);
procedure SIRegister_TExprConstSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprVirtMachNodeFactory(CL: TPSPascalCompiler);
procedure SIRegister_TExprVirtMach(CL: TPSPascalCompiler);
procedure SIRegister_TExprVirtMachOp(CL: TPSPascalCompiler);
procedure SIRegister_TExprSimpleLexer(CL: TPSPascalCompiler);
procedure SIRegister_TExprEvalParser(CL: TPSPascalCompiler);
procedure SIRegister_TExprCompileParser(CL: TPSPascalCompiler);
procedure SIRegister_TExprNodeFactory(CL: TPSPascalCompiler);
procedure SIRegister_TExprNode(CL: TPSPascalCompiler);
procedure SIRegister_TExprLexer(CL: TPSPascalCompiler);
procedure SIRegister_TExprSym(CL: TPSPascalCompiler);
procedure SIRegister_TExprSetContext(CL: TPSPascalCompiler);
procedure SIRegister_TExprHashContext(CL: TPSPascalCompiler);
procedure SIRegister_TExprContext(CL: TPSPascalCompiler);
procedure SIRegister_JclExprEval(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TExpressionCompiler(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCompiledEvaluator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEvaluator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEasyEvaluator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprTernary80FuncSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprTernary64FuncSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprTernary32FuncSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprTernaryFuncSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprBinary80FuncSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprBinary64FuncSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprBinary32FuncSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprBinaryFuncSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprUnary80FuncSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprUnary64FuncSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprUnary32FuncSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprUnaryFuncSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprFloat80FuncSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprFloat64FuncSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprFloat32FuncSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprFuncSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprAbstractFuncSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprVar80Sym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprVar64Sym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprVar32Sym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprConst80Sym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprConst64Sym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprConst32Sym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprConstSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprVirtMachNodeFactory(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprVirtMach(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprVirtMachOp(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprSimpleLexer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprEvalParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprCompileParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprNodeFactory(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprLexer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprSym(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprSetContext(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprHashContext(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExprContext(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclExprEval(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   JclBase
  ,JclSysUtils
  ,JclStrHashMap
  ,JclResources
  ,JclExprEval
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclExprEval]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TExpressionCompiler(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEasyEvaluator', 'TExpressionCompiler') do
  with CL.AddClassN(CL.FindClass('TEasyEvaluator'),'TExpressionCompiler') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
     RegisterMethod('Function Compile( const AExpr : string) : TCompiledExpression');
    RegisterMethod('Procedure Remove( const AExpr : string)');
    RegisterMethod('Procedure Delete( ACompiledExpression : TCompiledExpression)');
    RegisterMethod('Procedure Clear');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCompiledEvaluator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEasyEvaluator', 'TCompiledEvaluator') do
  with CL.AddClassN(CL.FindClass('TEasyEvaluator'),'TCompiledEvaluator') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Compile( const AExpr : string)');
    RegisterMethod('Function Evaluate : TFloat');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEvaluator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEasyEvaluator', 'TEvaluator') do
  with CL.AddClassN(CL.FindClass('TEasyEvaluator'),'TEvaluator') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
     RegisterMethod('Function Evaluate( const AExpr : string) : TFloat');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEasyEvaluator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TEasyEvaluator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TEasyEvaluator') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure AddVar6( const AName : string; var AVar : TFloat32);');
    RegisterMethod('Procedure AddVar7( const AName : string; var AVar : TFloat64);');
    RegisterMethod('Procedure AddVar8( const AName : string; var AVar : TFloat80);');
    RegisterMethod('Procedure AddConst9( const AName : string; AConst : TFloat32);');
    RegisterMethod('Procedure AddConst10( const AName : string; AConst : TFloat64);');
    RegisterMethod('Procedure AddConst11( const AName : string; AConst : TFloat80);');
    RegisterMethod('Procedure AddFunc12( const AName : string; AFunc : TFloat32Func);');
    RegisterMethod('Procedure AddFunc13( const AName : string; AFunc : TFloat64Func);');
    RegisterMethod('Procedure AddFunc14( const AName : string; AFunc : TFloat80Func);');
    RegisterMethod('Procedure AddFunc15( const AName : string; AFunc : TUnary32Func);');
    RegisterMethod('Procedure AddFunc16( const AName : string; AFunc : TUnary64Func);');
    RegisterMethod('Procedure AddFunc17( const AName : string; AFunc : TUnary80Func);');
    RegisterMethod('Procedure AddFunc18( const AName : string; AFunc : TBinary32Func);');
    RegisterMethod('Procedure AddFunc19( const AName : string; AFunc : TBinary64Func);');
    RegisterMethod('Procedure AddFunc20( const AName : string; AFunc : TBinary80Func);');
    RegisterMethod('Procedure AddFunc21( const AName : string; AFunc : TTernary32Func);');
    RegisterMethod('Procedure AddFunc22( const AName : string; AFunc : TTernary64Func);');
    RegisterMethod('Procedure AddFunc23( const AName : string; AFunc : TTernary80Func);');
    RegisterMethod('Procedure Remove( const AName : string)');
    RegisterMethod('Procedure Clear');
    RegisterProperty('ExtContextSet', 'TExprSetContext', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprTernary80FuncSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprAbstractFuncSym', 'TExprTernary80FuncSym') do
  with CL.AddClassN(CL.FindClass('TExprAbstractFuncSym'),'TExprTernary80FuncSym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AFunc : TTernary80Func)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprTernary64FuncSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprAbstractFuncSym', 'TExprTernary64FuncSym') do
  with CL.AddClassN(CL.FindClass('TExprAbstractFuncSym'),'TExprTernary64FuncSym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AFunc : TTernary64Func)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprTernary32FuncSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprAbstractFuncSym', 'TExprTernary32FuncSym') do
  with CL.AddClassN(CL.FindClass('TExprAbstractFuncSym'),'TExprTernary32FuncSym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AFunc : TTernary32Func)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprTernaryFuncSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprAbstractFuncSym', 'TExprTernaryFuncSym') do
  with CL.AddClassN(CL.FindClass('TExprAbstractFuncSym'),'TExprTernaryFuncSym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AFunc : TTernaryFunc)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprBinary80FuncSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprAbstractFuncSym', 'TExprBinary80FuncSym') do
  with CL.AddClassN(CL.FindClass('TExprAbstractFuncSym'),'TExprBinary80FuncSym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AFunc : TBinary80Func)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprBinary64FuncSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprAbstractFuncSym', 'TExprBinary64FuncSym') do
  with CL.AddClassN(CL.FindClass('TExprAbstractFuncSym'),'TExprBinary64FuncSym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AFunc : TBinary64Func)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprBinary32FuncSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprAbstractFuncSym', 'TExprBinary32FuncSym') do
  with CL.AddClassN(CL.FindClass('TExprAbstractFuncSym'),'TExprBinary32FuncSym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AFunc : TBinary32Func)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprBinaryFuncSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprAbstractFuncSym', 'TExprBinaryFuncSym') do
  with CL.AddClassN(CL.FindClass('TExprAbstractFuncSym'),'TExprBinaryFuncSym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AFunc : TBinaryFunc)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprUnary80FuncSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprAbstractFuncSym', 'TExprUnary80FuncSym') do
  with CL.AddClassN(CL.FindClass('TExprAbstractFuncSym'),'TExprUnary80FuncSym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AFunc : TUnary80Func)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprUnary64FuncSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprAbstractFuncSym', 'TExprUnary64FuncSym') do
  with CL.AddClassN(CL.FindClass('TExprAbstractFuncSym'),'TExprUnary64FuncSym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AFunc : TUnary64Func)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprUnary32FuncSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprAbstractFuncSym', 'TExprUnary32FuncSym') do
  with CL.AddClassN(CL.FindClass('TExprAbstractFuncSym'),'TExprUnary32FuncSym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AFunc : TUnary32Func)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprUnaryFuncSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprAbstractFuncSym', 'TExprUnaryFuncSym') do
  with CL.AddClassN(CL.FindClass('TExprAbstractFuncSym'),'TExprUnaryFuncSym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AFunc : TUnaryFunc)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprFloat80FuncSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprAbstractFuncSym', 'TExprFloat80FuncSym') do
  with CL.AddClassN(CL.FindClass('TExprAbstractFuncSym'),'TExprFloat80FuncSym') do
  begin
    RegisterMethod('Constructor Create( const AIdent7 : string; AFunc : TFloat80Func)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprFloat64FuncSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprAbstractFuncSym', 'TExprFloat64FuncSym') do
  with CL.AddClassN(CL.FindClass('TExprAbstractFuncSym'),'TExprFloat64FuncSym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AFunc : TFloat64Func)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprFloat32FuncSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprAbstractFuncSym', 'TExprFloat32FuncSym') do
  with CL.AddClassN(CL.FindClass('TExprAbstractFuncSym'),'TExprFloat32FuncSym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AFunc : TFloat32Func)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprFuncSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprAbstractFuncSym', 'TExprFuncSym') do
  with CL.AddClassN(CL.FindClass('TExprAbstractFuncSym'),'TExprFuncSym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AFunc : TFloatFunc)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprAbstractFuncSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprSym', 'TExprAbstractFuncSym') do
  with CL.AddClassN(CL.FindClass('TExprSym'),'TExprAbstractFuncSym') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprVar80Sym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprSym', 'TExprVar80Sym') do
  with CL.AddClassN(CL.FindClass('TExprSym'),'TExprVar80Sym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; ALoc : PFloat80)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprVar64Sym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprSym', 'TExprVar64Sym') do
  with CL.AddClassN(CL.FindClass('TExprSym'),'TExprVar64Sym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; ALoc : PFloat64)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprVar32Sym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprSym', 'TExprVar32Sym') do
  with CL.AddClassN(CL.FindClass('TExprSym'),'TExprVar32Sym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; ALoc : PFloat32)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprConst80Sym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprSym', 'TExprConst80Sym') do
  with CL.AddClassN(CL.FindClass('TExprSym'),'TExprConst80Sym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AValue : TFloat80)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprConst64Sym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprSym', 'TExprConst64Sym') do
  with CL.AddClassN(CL.FindClass('TExprSym'),'TExprConst64Sym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AValue : TFloat64)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprConst32Sym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprSym', 'TExprConst32Sym') do
  with CL.AddClassN(CL.FindClass('TExprSym'),'TExprConst32Sym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AValue : TFloat32)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprConstSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprSym', 'TExprConstSym') do
  with CL.AddClassN(CL.FindClass('TExprSym'),'TExprConstSym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string; AValue : TFloat)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprVirtMachNodeFactory(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprNodeFactory', 'TExprVirtMachNodeFactory') do
  with CL.AddClassN(CL.FindClass('TExprNodeFactory'),'TExprVirtMachNodeFactory') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
      RegisterMethod('Procedure GenCode( AVirtMach : TExprVirtMach)');
    RegisterMethod('Function LoadVar32( ALoc : PFloat32) : TExprNode');
    RegisterMethod('Function LoadVar64( ALoc : PFloat64) : TExprNode');
    RegisterMethod('Function LoadVar80( ALoc : PFloat80) : TExprNode');
    RegisterMethod('Function LoadConst32( AValue : TFloat32) : TExprNode');
    RegisterMethod('Function LoadConst64( AValue : TFloat64) : TExprNode');
    RegisterMethod('Function LoadConst80( AValue : TFloat80) : TExprNode');
    RegisterMethod('Function CallFloatFunc( AFunc : TFloatFunc) : TExprNode');
    RegisterMethod('Function CallFloat32Func( AFunc : TFloat32Func) : TExprNode');
    RegisterMethod('Function CallFloat64Func( AFunc : TFloat64Func) : TExprNode');
    RegisterMethod('Function CallFloat80Func( AFunc : TFloat80Func) : TExprNode');
    RegisterMethod('Function CallUnaryFunc( AFunc : TUnaryFunc; x : TExprNode) : TExprNode');
    RegisterMethod('Function CallUnary32Func( AFunc : TUnary32Func; x : TExprNode) : TExprNode');
    RegisterMethod('Function CallUnary64Func( AFunc : TUnary64Func; x : TExprNode) : TExprNode');
    RegisterMethod('Function CallUnary80Func( AFunc : TUnary80Func; x : TExprNode) : TExprNode');
    RegisterMethod('Function CallBinaryFunc( AFunc : TBinaryFunc; x, y : TExprNode) : TExprNode');
    RegisterMethod('Function CallBinary32Func( AFunc : TBinary32Func; x, y : TExprNode) : TExprNode');
    RegisterMethod('Function CallBinary64Func( AFunc : TBinary64Func; x, y : TExprNode) : TExprNode');
    RegisterMethod('Function CallBinary80Func( AFunc : TBinary80Func; x, y : TExprNode) : TExprNode');
    RegisterMethod('Function CallTernaryFunc( AFunc : TTernaryFunc; x, y, z : TExprNode) : TExprNode');
    RegisterMethod('Function CallTernary32Func( AFunc : TTernary32Func; x, y, z : TExprNode) : TExprNode');
    RegisterMethod('Function CallTernary64Func( AFunc : TTernary64Func; x, y, z : TExprNode) : TExprNode');
    RegisterMethod('Function CallTernary80Func( AFunc : TTernary80Func; x, y, z : TExprNode) : TExprNode');
    RegisterMethod('Function Add( ALeft, ARight : TExprNode) : TExprNode');
    RegisterMethod('Function Subtract( ALeft, ARight : TExprNode) : TExprNode');
    RegisterMethod('Function Multiply( ALeft, ARight : TExprNode) : TExprNode');
    RegisterMethod('Function Divide( ALeft, ARight : TExprNode) : TExprNode');
    RegisterMethod('Function Negate( AValue : TExprNode) : TExprNode');
    RegisterMethod('Function Compare( ALeft, ARight : TExprNode) : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprVirtMach(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TExprVirtMach') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TExprVirtMach') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Add( AOp : TExprVirtMachOp)');
    RegisterMethod('Procedure AddConst( AOp : TExprVirtMachOp)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Execute : TFloat');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprVirtMachOp(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TExprVirtMachOp') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TExprVirtMachOp') do
  begin
    RegisterMethod('Procedure Execute');
    RegisterProperty('OutputLoc', 'PFloat', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprSimpleLexer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprLexer', 'TExprSimpleLexer') do
  with CL.AddClassN(CL.FindClass('TExprLexer'),'TExprSimpleLexer') do
  begin
    RegisterMethod('Constructor Create( const ABuf : string)');
    RegisterMethod('Procedure NextTok');
    RegisterMethod('Procedure Reset');
    RegisterProperty('Buf', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprEvalParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TExprEvalParser') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TExprEvalParser') do
  begin
    RegisterMethod('Constructor Create( ALexer : TExprLexer)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterProperty('Lexer', 'TExprLexer', iptr);
    RegisterProperty('Context', 'TExprContext', iptrw);
    RegisterMethod('Function eval_expr( ASkip : Boolean) : TFloat');
    RegisterMethod('Function eval_simple_expr( ASkip : Boolean) : TFloat');
    RegisterMethod('Function eval_term( ASkip : Boolean) : TFloat');
    RegisterMethod('Function eval_signed_factor( ASkip : Boolean) : TFloat');
    RegisterMethod('Function eval_factor : TFloat');
    RegisterMethod('Function eval_ident_factor : TFloat');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprCompileParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TExprCompileParser') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TExprCompileParser') do
  begin
    RegisterMethod('Constructor Create( ALexer : TExprLexer; ANodeFactory : TExprNodeFactory)');
    RegisterMethod('Function Compile : TExprNode');
    RegisterProperty('Lexer', 'TExprLexer', iptr);
    RegisterProperty('NodeFactory', 'TExprNodeFactory', iptr);
    RegisterProperty('Context', 'TExprContext', iptrw);
    RegisterMethod('Function compile_expr( ASkip : Boolean) : TExprNode');
    RegisterMethod('Function compile_simple_expr( ASkip : Boolean) : TExprNode');
    RegisterMethod('Function compile_term( ASkip : Boolean) : TExprNode');
    RegisterMethod('Function compile_signed_factor( ASkip : Boolean) : TExprNode');
    RegisterMethod('Function compile_factor : TExprNode');
    RegisterMethod('Function compile_ident_factor : TExprNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprNodeFactory(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TExprNodeFactory') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TExprNodeFactory') do
  begin
    RegisterMethod('Function LoadVar32( ALoc : PFloat32) : TExprNode');
    RegisterMethod('Function LoadVar64( ALoc : PFloat64) : TExprNode');
    RegisterMethod('Function LoadVar80( ALoc : PFloat80) : TExprNode');
    RegisterMethod('Function LoadConst32( AValue : TFloat32) : TExprNode');
    RegisterMethod('Function LoadConst64( AValue : TFloat64) : TExprNode');
    RegisterMethod('Function LoadConst80( AValue : TFloat80) : TExprNode');
    RegisterMethod('Function CallFloatFunc( AFunc : TFloatFunc) : TExprNode');
    RegisterMethod('Function CallFloat32Func( AFunc : TFloat32Func) : TExprNode');
    RegisterMethod('Function CallFloat64Func( AFunc : TFloat64Func) : TExprNode');
    RegisterMethod('Function CallFloat80Func( AFunc : TFloat80Func) : TExprNode');
    RegisterMethod('Function CallUnaryFunc( AFunc : TUnaryFunc; x : TExprNode) : TExprNode');
    RegisterMethod('Function CallUnary32Func( AFunc : TUnary32Func; x : TExprNode) : TExprNode');
    RegisterMethod('Function CallUnary64Func( AFunc : TUnary64Func; x : TExprNode) : TExprNode');
    RegisterMethod('Function CallUnary80Func( AFunc : TUnary80Func; x : TExprNode) : TExprNode');
    RegisterMethod('Function CallBinaryFunc( AFunc : TBinaryFunc; x, y : TExprNode) : TExprNode');
    RegisterMethod('Function CallBinary32Func( AFunc : TBinary32Func; x, y : TExprNode) : TExprNode');
    RegisterMethod('Function CallBinary64Func( AFunc : TBinary64Func; x, y : TExprNode) : TExprNode');
    RegisterMethod('Function CallBinary80Func( AFunc : TBinary80Func; x, y : TExprNode) : TExprNode');
    RegisterMethod('Function CallTernaryFunc( AFunc : TTernaryFunc; x, y, z : TExprNode) : TExprNode');
    RegisterMethod('Function CallTernary32Func( AFunc : TTernary32Func; x, y, z : TExprNode) : TExprNode');
    RegisterMethod('Function CallTernary64Func( AFunc : TTernary64Func; x, y, z : TExprNode) : TExprNode');
    RegisterMethod('Function CallTernary80Func( AFunc : TTernary80Func; x, y, z : TExprNode) : TExprNode');
    RegisterMethod('Function Add( ALeft, ARight : TExprNode) : TExprNode');
    RegisterMethod('Function Subtract( ALeft, ARight : TExprNode) : TExprNode');
    RegisterMethod('Function Multiply( ALeft, ARight : TExprNode) : TExprNode');
    RegisterMethod('Function Divide( ALeft, ARight : TExprNode) : TExprNode');
    RegisterMethod('Function Negate( AValue : TExprNode) : TExprNode');
    RegisterMethod('Function Compare( ALeft, ARight : TExprNode) : TExprNode');
    RegisterMethod('Function LoadVar0( ALoc : PFloat32) : TExprNode;');
    RegisterMethod('Function LoadVar1( ALoc : PFloat64) : TExprNode;');
    RegisterMethod('Function LoadVar2( ALoc : PFloat80) : TExprNode;');
    RegisterMethod('Function LoadConst3( AValue : TFloat32) : TExprNode;');
    RegisterMethod('Function LoadConst4( AValue : TFloat64) : TExprNode;');
    RegisterMethod('Function LoadConst5( AValue : TFloat80) : TExprNode;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TExprNode') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TExprNode') do begin
    RegisterMethod('Constructor Create( const ADepList : array of TExprNode)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure AddDep( ADep : TExprNode)');
    RegisterProperty('DepCount', 'Integer', iptr);
    RegisterProperty('Deps', 'TExprNode Integer', iptr);
    SetDefaultPropery('Deps');
    RegisterProperty('DepList', 'TList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprLexer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TExprLexer') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TExprLexer') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure NextTok');
    RegisterMethod('Procedure Reset');
    RegisterProperty('TokenAsString', 'string', iptr);
    RegisterProperty('TokenAsNumber', 'TFloat', iptr);
    RegisterProperty('CurrTok', 'TExprTokenJ', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprSym(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TExprSym') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TExprSym') do
  begin
    RegisterMethod('Constructor Create( const AIdent : string)');
    RegisterMethod('Function Evaluate : TFloat');
    RegisterMethod('Function Compile : TExprNode');
    RegisterProperty('Ident', 'string', iptr);
    RegisterProperty('Lexer', 'TExprLexer', iptrw);
    RegisterProperty('CompileParser', 'TExprCompileParser', iptrw);
    RegisterProperty('EvalParser', 'TExprEvalParser', iptrw);
    RegisterProperty('NodeFactory', 'TExprNodeFactory', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprSetContext(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprContext', 'TExprSetContext') do
  with CL.AddClassN(CL.FindClass('TExprContext'),'TExprSetContext') do
  begin
    RegisterMethod('Constructor Create( AOwnsContexts : Boolean)');
    RegisterMethod('Procedure Add( AContext : TExprContext)');
    RegisterMethod('Procedure Remove( AContext : TExprContext)');
    RegisterMethod('Procedure Delete( AIndex : Integer)');
    RegisterMethod('Function Extract( AContext : TExprContext) : TExprContext');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Contexts', 'TExprContext Integer', iptr);
    RegisterProperty('InternalList', 'TList', iptr);
    RegisterMethod('Function Find( const AName : string) : TExprSym');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprHashContext(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExprContext', 'TExprHashContext') do
  with CL.AddClassN(CL.FindClass('TExprContext'),'TExprHashContext') do begin
    RegisterMethod('Constructor Create( ACaseSensitive : Boolean; AHashSize : Integer)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Add( ASymbol : TExprSym)');
    RegisterMethod('Procedure Remove( const AName : string)');
    RegisterMethod('Function Find( const AName : string) : TExprSym');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExprContext(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TExprContext') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TExprContext') do
  begin
    RegisterMethod('Function Find( const AName : string) : TExprSym');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclExprEval(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('C_ExprEval_HashSize','LongInt').SetInt( 127);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclExprEvalError');
  CL.AddTypeS('TFloat', 'Double');
  //CL.AddTypeS('PFloat', '^TFloat // will not work');
  CL.AddTypeS('TFloat32', 'Single');
  //CL.AddTypeS('PFloat32', '^TFloat32 // will not work');
  CL.AddTypeS('TFloat64', 'Double');
  //CL.AddTypeS('PFloat64', '^TFloat64 // will not work');
  CL.AddTypeS('TFloat80', 'Extended');
  //CL.AddTypeS('PFloat80', '^TFloat80 // will not work');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExprLexer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExprCompileParser');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExprEvalParser');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExprSym');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExprNode');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExprNodeFactory');
  SIRegister_TExprContext(CL);
  SIRegister_TExprHashContext(CL);
  SIRegister_TExprSetContext(CL);
  SIRegister_TExprSym(CL);
  CL.AddTypeS('TExprTokenJ', '( etEof, etNumber, etIdentifier, etUser0, etUser1,'
   +' etUser2, etUser3, etUser4, etUser5, etUser6, etUser7, etUser8, etUser9, e'
   +'tUser10, etUser11, etUser12, etUser13, etUser14, etUser15, etUser16, etUse'
   +'r17, etUser18, etUser19, etUser20, etUser21, etUser22, etUser23, etUser24,'
   +' etUser25, etUser26, etUser27, etUser28, etUser29, etUser30, etUser31, etN'
   +'otEqual, etLessEqual, etGreaterEqual, etBang, etDoubleQuote, etHash, etDol'
   +'lar, etPercent, etAmpersand, etSingleQuote, etLParen, etRParen, etAsterisk'
   +', etPlus, etComma, etMinus, etDot, etForwardSlash, etColon, etSemiColon, e'
   +'tLessThan, etEqualTo, etGreaterThan, etQuestion, etAt, etLBracket, etBackS'
   +'lash, etRBracket, etArrow, etBackTick, etLBrace, etPipe, etRBrace, etTilde'
   +', et127, etEuro, et129, et130, et131, et132, et133, et134, et135, et136, e'
   +'t137, et138, et139, et140, et141, et142, et143, et144, et145, et146, et147'
   +', et148, et149, et150, et151, et152, et153, et154, et155, et156, et157, et'
   +'158, et159, et160, et161, et162, et163, et164, et165, et166, et167, et168,'
   +' et169, et170, et171, et172, et173, et174, et175, et176, et177, et178, et1'
   +'79, et180, et181, et182, et183, et184, et185, et186, et187, et188, et189, '
   +'et190, et191, et192, et193, et194, et195, et196, et197, et198, et199, et20'
   +'0, et201, et202, et203, et204, et205, et206, et207, et208, et209, et210, e'
   +'t211, et212, et213, et214, et215, et216, et217, et218, et219, et220, et221'
   +', et222, et223, et224, et225, et226, et227, et228, et229, et230, et231, et'
   +'232, et233, et234, et235, et236, et237, et238, et239, et240, et241, et242,'
   +' et243, et244, et245, et246, et247, et248, et249, et250, et251, et252, et2'
   +'53, et254, et255, etInvalid )');
  SIRegister_TExprLexer(CL);
  SIRegister_TExprNode(CL);
  SIRegister_TExprNodeFactory(CL);
  SIRegister_TExprCompileParser(CL);
  SIRegister_TExprEvalParser(CL);
  SIRegister_TExprSimpleLexer(CL);
  SIRegister_TExprVirtMachOp(CL);
  SIRegister_TExprVirtMach(CL);
  SIRegister_TExprVirtMachNodeFactory(CL);
  SIRegister_TExprConstSym(CL);
  SIRegister_TExprConst32Sym(CL);
  SIRegister_TExprConst64Sym(CL);
  SIRegister_TExprConst80Sym(CL);
  SIRegister_TExprVar32Sym(CL);
  SIRegister_TExprVar64Sym(CL);
  SIRegister_TExprVar80Sym(CL);
  SIRegister_TExprAbstractFuncSym(CL);
  SIRegister_TExprFuncSym(CL);
  SIRegister_TExprFloat32FuncSym(CL);
  SIRegister_TExprFloat64FuncSym(CL);
  SIRegister_TExprFloat80FuncSym(CL);
  SIRegister_TExprUnaryFuncSym(CL);
  SIRegister_TExprUnary32FuncSym(CL);
  SIRegister_TExprUnary64FuncSym(CL);
  SIRegister_TExprUnary80FuncSym(CL);
  SIRegister_TExprBinaryFuncSym(CL);
  SIRegister_TExprBinary32FuncSym(CL);
  SIRegister_TExprBinary64FuncSym(CL);
  SIRegister_TExprBinary80FuncSym(CL);
  SIRegister_TExprTernaryFuncSym(CL);
  SIRegister_TExprTernary32FuncSym(CL);
  SIRegister_TExprTernary64FuncSym(CL);
  SIRegister_TExprTernary80FuncSym(CL);
  SIRegister_TEasyEvaluator(CL);
  SIRegister_TEvaluator(CL);
  SIRegister_TCompiledEvaluator(CL);
  CL.AddTypeS('TCompiledExpression', 'Function  : TFloat');
  SIRegister_TExpressionCompiler(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TEasyEvaluatorExtContextSet_R(Self: TEasyEvaluator; var T: TExprSetContext);
begin T := Self.ExtContextSet; end;

(*----------------------------------------------------------------------------*)
Procedure TEasyEvaluatorAddFunc23_P(Self: TEasyEvaluator;  const AName : string; AFunc : TTernary80Func);
Begin Self.AddFunc(AName, AFunc); END;

(*----------------------------------------------------------------------------*)
Procedure TEasyEvaluatorAddFunc22_P(Self: TEasyEvaluator;  const AName : string; AFunc : TTernary64Func);
Begin Self.AddFunc(AName, AFunc); END;

(*----------------------------------------------------------------------------*)
Procedure TEasyEvaluatorAddFunc21_P(Self: TEasyEvaluator;  const AName : string; AFunc : TTernary32Func);
Begin Self.AddFunc(AName, AFunc); END;

(*----------------------------------------------------------------------------*)
Procedure TEasyEvaluatorAddFunc20_P(Self: TEasyEvaluator;  const AName : string; AFunc : TBinary80Func);
Begin Self.AddFunc(AName, AFunc); END;

(*----------------------------------------------------------------------------*)
Procedure TEasyEvaluatorAddFunc19_P(Self: TEasyEvaluator;  const AName : string; AFunc : TBinary64Func);
Begin Self.AddFunc(AName, AFunc); END;

(*----------------------------------------------------------------------------*)
Procedure TEasyEvaluatorAddFunc18_P(Self: TEasyEvaluator;  const AName : string; AFunc : TBinary32Func);
Begin Self.AddFunc(AName, AFunc); END;

(*----------------------------------------------------------------------------*)
Procedure TEasyEvaluatorAddFunc17_P(Self: TEasyEvaluator;  const AName : string; AFunc : TUnary80Func);
Begin Self.AddFunc(AName, AFunc); END;

(*----------------------------------------------------------------------------*)
Procedure TEasyEvaluatorAddFunc16_P(Self: TEasyEvaluator;  const AName : string; AFunc : TUnary64Func);
Begin Self.AddFunc(AName, AFunc); END;

(*----------------------------------------------------------------------------*)
Procedure TEasyEvaluatorAddFunc15_P(Self: TEasyEvaluator;  const AName : string; AFunc : TUnary32Func);
Begin Self.AddFunc(AName, AFunc); END;

(*----------------------------------------------------------------------------*)
Procedure TEasyEvaluatorAddFunc14_P(Self: TEasyEvaluator;  const AName : string; AFunc : TFloat80Func);
Begin Self.AddFunc(AName, AFunc); END;

(*----------------------------------------------------------------------------*)
Procedure TEasyEvaluatorAddFunc13_P(Self: TEasyEvaluator;  const AName : string; AFunc : TFloat64Func);
Begin Self.AddFunc(AName, AFunc); END;

(*----------------------------------------------------------------------------*)
Procedure TEasyEvaluatorAddFunc12_P(Self: TEasyEvaluator;  const AName : string; AFunc : TFloat32Func);
Begin Self.AddFunc(AName, AFunc); END;

(*----------------------------------------------------------------------------*)
Procedure TEasyEvaluatorAddConst11_P(Self: TEasyEvaluator;  const AName : string; AConst : TFloat80);
Begin Self.AddConst(AName, AConst); END;

(*----------------------------------------------------------------------------*)
Procedure TEasyEvaluatorAddConst10_P(Self: TEasyEvaluator;  const AName : string; AConst : TFloat64);
Begin Self.AddConst(AName, AConst); END;

(*----------------------------------------------------------------------------*)
Procedure TEasyEvaluatorAddConst9_P(Self: TEasyEvaluator;  const AName : string; AConst : TFloat32);
Begin Self.AddConst(AName, AConst); END;

(*----------------------------------------------------------------------------*)
Procedure TEasyEvaluatorAddVar8_P(Self: TEasyEvaluator;  const AName : string; var AVar : TFloat80);
Begin Self.AddVar(AName, AVar); END;

(*----------------------------------------------------------------------------*)
Procedure TEasyEvaluatorAddVar7_P(Self: TEasyEvaluator;  const AName : string; var AVar : TFloat64);
Begin Self.AddVar(AName, AVar); END;

(*----------------------------------------------------------------------------*)
Procedure TEasyEvaluatorAddVar6_P(Self: TEasyEvaluator;  const AName : string; var AVar : TFloat32);
Begin Self.AddVar(AName, AVar); END;

(*----------------------------------------------------------------------------*)
procedure TExprVirtMachOpOutputLoc_R(Self: TExprVirtMachOp; var T: PFloat);
begin T := Self.OutputLoc; end;

(*----------------------------------------------------------------------------*)
procedure TExprSimpleLexerBuf_W(Self: TExprSimpleLexer; const T: string);
begin Self.Buf := T; end;

(*----------------------------------------------------------------------------*)
procedure TExprSimpleLexerBuf_R(Self: TExprSimpleLexer; var T: string);
begin T := Self.Buf; end;

(*----------------------------------------------------------------------------*)
procedure TExprEvalParserContext_W(Self: TExprEvalParser; const T: TExprContext);
begin Self.Context := T; end;

(*----------------------------------------------------------------------------*)
procedure TExprEvalParserContext_R(Self: TExprEvalParser; var T: TExprContext);
begin T := Self.Context; end;

(*----------------------------------------------------------------------------*)
procedure TExprEvalParserLexer_R(Self: TExprEvalParser; var T: TExprLexer);
begin T := Self.Lexer; end;

(*----------------------------------------------------------------------------*)
procedure TExprCompileParserContext_W(Self: TExprCompileParser; const T: TExprContext);
begin Self.Context := T; end;

(*----------------------------------------------------------------------------*)
procedure TExprCompileParserContext_R(Self: TExprCompileParser; var T: TExprContext);
begin T := Self.Context; end;

(*----------------------------------------------------------------------------*)
procedure TExprCompileParserNodeFactory_R(Self: TExprCompileParser; var T: TExprNodeFactory);
begin T := Self.NodeFactory; end;

(*----------------------------------------------------------------------------*)
procedure TExprCompileParserLexer_R(Self: TExprCompileParser; var T: TExprLexer);
begin T := Self.Lexer; end;

(*----------------------------------------------------------------------------*)
Function TExprNodeFactoryLoadConst5_P(Self: TExprNodeFactory;  AValue : TFloat80) : TExprNode;
Begin Result := Self.LoadConst(AValue); END;

(*----------------------------------------------------------------------------*)
Function TExprNodeFactoryLoadConst4_P(Self: TExprNodeFactory;  AValue : TFloat64) : TExprNode;
Begin Result := Self.LoadConst(AValue); END;

(*----------------------------------------------------------------------------*)
Function TExprNodeFactoryLoadConst3_P(Self: TExprNodeFactory;  AValue : TFloat32) : TExprNode;
Begin Result := Self.LoadConst(AValue); END;

(*----------------------------------------------------------------------------*)
Function TExprNodeFactoryLoadVar2_P(Self: TExprNodeFactory;  ALoc : PFloat80) : TExprNode;
Begin Result := Self.LoadVar(ALoc); END;

(*----------------------------------------------------------------------------*)
Function TExprNodeFactoryLoadVar1_P(Self: TExprNodeFactory;  ALoc : PFloat64) : TExprNode;
Begin Result := Self.LoadVar(ALoc); END;

(*----------------------------------------------------------------------------*)
Function TExprNodeFactoryLoadVar0_P(Self: TExprNodeFactory;  ALoc : PFloat32) : TExprNode;
Begin Result := Self.LoadVar(ALoc); END;

(*----------------------------------------------------------------------------*)
procedure TExprNodeDepList_R(Self: TExprNode; var T: TList);
begin T := Self.DepList; end;

(*----------------------------------------------------------------------------*)
procedure TExprNodeDeps_R(Self: TExprNode; var T: TExprNode; const t1: Integer);
begin T := Self.Deps[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TExprNodeDepCount_R(Self: TExprNode; var T: Integer);
begin T := Self.DepCount; end;

(*----------------------------------------------------------------------------*)
procedure TExprLexerCurrTok_R(Self: TExprLexer; var T: TExprTokenJ);
begin T := Self.CurrTok; end;

(*----------------------------------------------------------------------------*)
procedure TExprLexerTokenAsNumber_R(Self: TExprLexer; var T: TFloat);
begin T := Self.TokenAsNumber; end;

(*----------------------------------------------------------------------------*)
procedure TExprLexerTokenAsString_R(Self: TExprLexer; var T: string);
begin T := Self.TokenAsString; end;

(*----------------------------------------------------------------------------*)
procedure TExprSymNodeFactory_W(Self: TExprSym; const T: TExprNodeFactory);
begin Self.NodeFactory := T; end;

(*----------------------------------------------------------------------------*)
procedure TExprSymNodeFactory_R(Self: TExprSym; var T: TExprNodeFactory);
begin T := Self.NodeFactory; end;

(*----------------------------------------------------------------------------*)
procedure TExprSymEvalParser_W(Self: TExprSym; const T: TExprEvalParser);
begin Self.EvalParser := T; end;

(*----------------------------------------------------------------------------*)
procedure TExprSymEvalParser_R(Self: TExprSym; var T: TExprEvalParser);
begin T := Self.EvalParser; end;

(*----------------------------------------------------------------------------*)
procedure TExprSymCompileParser_W(Self: TExprSym; const T: TExprCompileParser);
begin Self.CompileParser := T; end;

(*----------------------------------------------------------------------------*)
procedure TExprSymCompileParser_R(Self: TExprSym; var T: TExprCompileParser);
begin T := Self.CompileParser; end;

(*----------------------------------------------------------------------------*)
procedure TExprSymLexer_W(Self: TExprSym; const T: TExprLexer);
begin Self.Lexer := T; end;

(*----------------------------------------------------------------------------*)
procedure TExprSymLexer_R(Self: TExprSym; var T: TExprLexer);
begin T := Self.Lexer; end;

(*----------------------------------------------------------------------------*)
procedure TExprSymIdent_R(Self: TExprSym; var T: string);
begin T := Self.Ident; end;

(*----------------------------------------------------------------------------*)
procedure TExprSetContextInternalList_R(Self: TExprSetContext; var T: TList);
begin T := Self.InternalList; end;

(*----------------------------------------------------------------------------*)
procedure TExprSetContextContexts_R(Self: TExprSetContext; var T: TExprContext; const t1: Integer);
begin T := Self.Contexts[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TExprSetContextCount_R(Self: TExprSetContext; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExpressionCompiler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExpressionCompiler) do begin
    RegisterConstructor(@TExpressionCompiler.Create, 'Create');
      RegisterMethod(@TExpressionCompiler.Destroy, 'Free');
      RegisterMethod(@TExpressionCompiler.Compile, 'Compile');
    RegisterMethod(@TExpressionCompiler.Remove, 'Remove');
    RegisterMethod(@TExpressionCompiler.Delete, 'Delete');
    RegisterMethod(@TExpressionCompiler.Clear, 'Clear');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCompiledEvaluator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCompiledEvaluator) do begin
    RegisterConstructor(@TCompiledEvaluator.Create, 'Create');
      RegisterMethod(@TCompiledEvaluator.Destroy, 'Free');
      RegisterMethod(@TCompiledEvaluator.Compile, 'Compile');
    RegisterMethod(@TCompiledEvaluator.Evaluate, 'Evaluate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEvaluator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEvaluator) do begin
    RegisterConstructor(@TEvaluator.Create, 'Create');
   RegisterMethod(@TEvaluator.Destroy, 'Free');
      RegisterMethod(@TEvaluator.Evaluate, 'Evaluate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEasyEvaluator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEasyEvaluator) do begin
    RegisterConstructor(@TEasyEvaluator.Create, 'Create');
   RegisterMethod(@TEasyEvaluator.Destroy, 'Free');
      RegisterMethod(@TEasyEvaluatorAddVar6_P, 'AddVar6');
    RegisterMethod(@TEasyEvaluatorAddVar7_P, 'AddVar7');
    RegisterMethod(@TEasyEvaluatorAddVar8_P, 'AddVar8');
    RegisterMethod(@TEasyEvaluatorAddConst9_P, 'AddConst9');
    RegisterMethod(@TEasyEvaluatorAddConst10_P, 'AddConst10');
    RegisterMethod(@TEasyEvaluatorAddConst11_P, 'AddConst11');
    RegisterMethod(@TEasyEvaluatorAddFunc12_P, 'AddFunc12');
    RegisterMethod(@TEasyEvaluatorAddFunc13_P, 'AddFunc13');
    RegisterMethod(@TEasyEvaluatorAddFunc14_P, 'AddFunc14');
    RegisterMethod(@TEasyEvaluatorAddFunc15_P, 'AddFunc15');
    RegisterMethod(@TEasyEvaluatorAddFunc16_P, 'AddFunc16');
    RegisterMethod(@TEasyEvaluatorAddFunc17_P, 'AddFunc17');
    RegisterMethod(@TEasyEvaluatorAddFunc18_P, 'AddFunc18');
    RegisterMethod(@TEasyEvaluatorAddFunc19_P, 'AddFunc19');
    RegisterMethod(@TEasyEvaluatorAddFunc20_P, 'AddFunc20');
    RegisterMethod(@TEasyEvaluatorAddFunc21_P, 'AddFunc21');
    RegisterMethod(@TEasyEvaluatorAddFunc22_P, 'AddFunc22');
    RegisterMethod(@TEasyEvaluatorAddFunc23_P, 'AddFunc23');
    RegisterMethod(@TEasyEvaluator.Remove, 'Remove');
    RegisterMethod(@TEasyEvaluator.Clear, 'Clear');
    RegisterPropertyHelper(@TEasyEvaluatorExtContextSet_R,nil,'ExtContextSet');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprTernary80FuncSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprTernary80FuncSym) do
  begin
    RegisterConstructor(@TExprTernary80FuncSym.Create, 'Create');
    RegisterMethod(@TExprTernary80FuncSym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprTernary80FuncSym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprTernary64FuncSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprTernary64FuncSym) do
  begin
    RegisterConstructor(@TExprTernary64FuncSym.Create, 'Create');
    RegisterMethod(@TExprTernary64FuncSym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprTernary64FuncSym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprTernary32FuncSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprTernary32FuncSym) do
  begin
    RegisterConstructor(@TExprTernary32FuncSym.Create, 'Create');
    RegisterMethod(@TExprTernary32FuncSym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprTernary32FuncSym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprTernaryFuncSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprTernaryFuncSym) do
  begin
    RegisterConstructor(@TExprTernaryFuncSym.Create, 'Create');
    RegisterMethod(@TExprTernaryFuncSym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprTernaryFuncSym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprBinary80FuncSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprBinary80FuncSym) do
  begin
    RegisterConstructor(@TExprBinary80FuncSym.Create, 'Create');
    RegisterMethod(@TExprBinary80FuncSym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprBinary80FuncSym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprBinary64FuncSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprBinary64FuncSym) do
  begin
    RegisterConstructor(@TExprBinary64FuncSym.Create, 'Create');
    RegisterMethod(@TExprBinary64FuncSym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprBinary64FuncSym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprBinary32FuncSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprBinary32FuncSym) do
  begin
    RegisterConstructor(@TExprBinary32FuncSym.Create, 'Create');
    RegisterMethod(@TExprBinary32FuncSym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprBinary32FuncSym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprBinaryFuncSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprBinaryFuncSym) do
  begin
    RegisterConstructor(@TExprBinaryFuncSym.Create, 'Create');
    RegisterMethod(@TExprBinaryFuncSym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprBinaryFuncSym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprUnary80FuncSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprUnary80FuncSym) do
  begin
    RegisterConstructor(@TExprUnary80FuncSym.Create, 'Create');
    RegisterMethod(@TExprUnary80FuncSym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprUnary80FuncSym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprUnary64FuncSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprUnary64FuncSym) do
  begin
    RegisterConstructor(@TExprUnary64FuncSym.Create, 'Create');
    RegisterMethod(@TExprUnary64FuncSym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprUnary64FuncSym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprUnary32FuncSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprUnary32FuncSym) do
  begin
    RegisterConstructor(@TExprUnary32FuncSym.Create, 'Create');
    RegisterMethod(@TExprUnary32FuncSym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprUnary32FuncSym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprUnaryFuncSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprUnaryFuncSym) do
  begin
    RegisterConstructor(@TExprUnaryFuncSym.Create, 'Create');
    RegisterMethod(@TExprUnaryFuncSym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprUnaryFuncSym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprFloat80FuncSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprFloat80FuncSym) do
  begin
    RegisterConstructor(@TExprFloat80FuncSym.Create, 'Create');
    RegisterMethod(@TExprFloat80FuncSym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprFloat80FuncSym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprFloat64FuncSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprFloat64FuncSym) do
  begin
    RegisterConstructor(@TExprFloat64FuncSym.Create, 'Create');
    RegisterMethod(@TExprFloat64FuncSym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprFloat64FuncSym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprFloat32FuncSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprFloat32FuncSym) do
  begin
    RegisterConstructor(@TExprFloat32FuncSym.Create, 'Create');
    RegisterMethod(@TExprFloat32FuncSym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprFloat32FuncSym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprFuncSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprFuncSym) do
  begin
    RegisterConstructor(@TExprFuncSym.Create, 'Create');
    RegisterMethod(@TExprFuncSym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprFuncSym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprAbstractFuncSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprAbstractFuncSym) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprVar80Sym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprVar80Sym) do
  begin
    RegisterConstructor(@TExprVar80Sym.Create, 'Create');
    RegisterMethod(@TExprVar80Sym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprVar80Sym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprVar64Sym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprVar64Sym) do
  begin
    RegisterConstructor(@TExprVar64Sym.Create, 'Create');
    RegisterMethod(@TExprVar64Sym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprVar64Sym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprVar32Sym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprVar32Sym) do
  begin
    RegisterConstructor(@TExprVar32Sym.Create, 'Create');
    RegisterMethod(@TExprVar32Sym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprVar32Sym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprConst80Sym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprConst80Sym) do
  begin
    RegisterConstructor(@TExprConst80Sym.Create, 'Create');
    RegisterMethod(@TExprConst80Sym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprConst80Sym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprConst64Sym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprConst64Sym) do
  begin
    RegisterConstructor(@TExprConst64Sym.Create, 'Create');
    RegisterMethod(@TExprConst64Sym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprConst64Sym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprConst32Sym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprConst32Sym) do
  begin
    RegisterConstructor(@TExprConst32Sym.Create, 'Create');
    RegisterMethod(@TExprConst32Sym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprConst32Sym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprConstSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprConstSym) do
  begin
    RegisterConstructor(@TExprConstSym.Create, 'Create');
    RegisterMethod(@TExprConstSym.Evaluate, 'Evaluate');
    RegisterMethod(@TExprConstSym.Compile, 'Compile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprVirtMachNodeFactory(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprVirtMachNodeFactory) do begin
    RegisterConstructor(@TExprVirtMachNodeFactory.Create, 'Create');
  RegisterMethod(@TExprVirtMachNodeFactory.Destroy, 'Free');
      RegisterMethod(@TExprVirtMachNodeFactory.GenCode, 'GenCode');
    RegisterMethod(@TExprVirtMachNodeFactory.LoadVar32, 'LoadVar32');
    RegisterMethod(@TExprVirtMachNodeFactory.LoadVar64, 'LoadVar64');
    RegisterMethod(@TExprVirtMachNodeFactory.LoadVar80, 'LoadVar80');
    RegisterMethod(@TExprVirtMachNodeFactory.LoadConst32, 'LoadConst32');
    RegisterMethod(@TExprVirtMachNodeFactory.LoadConst64, 'LoadConst64');
    RegisterMethod(@TExprVirtMachNodeFactory.LoadConst80, 'LoadConst80');
    RegisterMethod(@TExprVirtMachNodeFactory.CallFloatFunc, 'CallFloatFunc');
    RegisterMethod(@TExprVirtMachNodeFactory.CallFloat32Func, 'CallFloat32Func');
    RegisterMethod(@TExprVirtMachNodeFactory.CallFloat64Func, 'CallFloat64Func');
    RegisterMethod(@TExprVirtMachNodeFactory.CallFloat80Func, 'CallFloat80Func');
    RegisterMethod(@TExprVirtMachNodeFactory.CallUnaryFunc, 'CallUnaryFunc');
    RegisterMethod(@TExprVirtMachNodeFactory.CallUnary32Func, 'CallUnary32Func');
    RegisterMethod(@TExprVirtMachNodeFactory.CallUnary64Func, 'CallUnary64Func');
    RegisterMethod(@TExprVirtMachNodeFactory.CallUnary80Func, 'CallUnary80Func');
    RegisterMethod(@TExprVirtMachNodeFactory.CallBinaryFunc, 'CallBinaryFunc');
    RegisterMethod(@TExprVirtMachNodeFactory.CallBinary32Func, 'CallBinary32Func');
    RegisterMethod(@TExprVirtMachNodeFactory.CallBinary64Func, 'CallBinary64Func');
    RegisterMethod(@TExprVirtMachNodeFactory.CallBinary80Func, 'CallBinary80Func');
    RegisterMethod(@TExprVirtMachNodeFactory.CallTernaryFunc, 'CallTernaryFunc');
    RegisterMethod(@TExprVirtMachNodeFactory.CallTernary32Func, 'CallTernary32Func');
    RegisterMethod(@TExprVirtMachNodeFactory.CallTernary64Func, 'CallTernary64Func');
    RegisterMethod(@TExprVirtMachNodeFactory.CallTernary80Func, 'CallTernary80Func');
    RegisterMethod(@TExprVirtMachNodeFactory.Add, 'Add');
    RegisterMethod(@TExprVirtMachNodeFactory.Subtract, 'Subtract');
    RegisterMethod(@TExprVirtMachNodeFactory.Multiply, 'Multiply');
    RegisterMethod(@TExprVirtMachNodeFactory.Divide, 'Divide');
    RegisterMethod(@TExprVirtMachNodeFactory.Negate, 'Negate');
    RegisterMethod(@TExprVirtMachNodeFactory.Compare, 'Compare');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprVirtMach(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprVirtMach) do begin
    RegisterConstructor(@TExprVirtMach.Create, 'Create');
  RegisterMethod(@TExprVirtMach.Destroy, 'Free');
      RegisterMethod(@TExprVirtMach.Add, 'Add');
    RegisterMethod(@TExprVirtMach.AddConst, 'AddConst');
    RegisterMethod(@TExprVirtMach.Clear, 'Clear');
    RegisterMethod(@TExprVirtMach.Execute, 'Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprVirtMachOp(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprVirtMachOp) do
  begin
    //RegisterVirtualAbstractMethod(@TExprVirtMachOp, @!.Execute, 'Execute');
    RegisterPropertyHelper(@TExprVirtMachOpOutputLoc_R,nil,'OutputLoc');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprSimpleLexer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprSimpleLexer) do
  begin
    RegisterConstructor(@TExprSimpleLexer.Create, 'Create');
    RegisterMethod(@TExprSimpleLexer.NextTok, 'NextTok');
    RegisterMethod(@TExprSimpleLexer.Reset, 'Reset');
    RegisterPropertyHelper(@TExprSimpleLexerBuf_R,@TExprSimpleLexerBuf_W,'Buf');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprEvalParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprEvalParser) do
  begin
    RegisterConstructor(@TExprEvalParser.Create, 'Create');
    RegisterVirtualMethod(@TExprEvalParser.Evaluate, 'Evaluate');
    RegisterPropertyHelper(@TExprEvalParserLexer_R,nil,'Lexer');
    RegisterPropertyHelper(@TExprEvalParserContext_R,@TExprEvalParserContext_W,'Context');
    RegisterVirtualMethod(@TExprEvalParser.eval_expr, 'eval_expr');
    RegisterMethod(@TExprEvalParser.eval_simple_expr, 'eval_simple_expr');
    RegisterMethod(@TExprEvalParser.eval_term, 'eval_term');
    RegisterMethod(@TExprEvalParser.eval_signed_factor, 'eval_signed_factor');
    RegisterMethod(@TExprEvalParser.eval_factor, 'eval_factor');
    RegisterMethod(@TExprEvalParser.eval_ident_factor, 'eval_ident_factor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprCompileParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprCompileParser) do
  begin
    RegisterConstructor(@TExprCompileParser.Create, 'Create');
    RegisterVirtualMethod(@TExprCompileParser.Compile, 'Compile');
    RegisterPropertyHelper(@TExprCompileParserLexer_R,nil,'Lexer');
    RegisterPropertyHelper(@TExprCompileParserNodeFactory_R,nil,'NodeFactory');
    RegisterPropertyHelper(@TExprCompileParserContext_R,@TExprCompileParserContext_W,'Context');
    RegisterVirtualMethod(@TExprCompileParser.compile_expr, 'compile_expr');
    RegisterMethod(@TExprCompileParser.compile_simple_expr, 'compile_simple_expr');
    RegisterMethod(@TExprCompileParser.compile_term, 'compile_term');
    RegisterMethod(@TExprCompileParser.compile_signed_factor, 'compile_signed_factor');
    RegisterMethod(@TExprCompileParser.compile_factor, 'compile_factor');
    RegisterMethod(@TExprCompileParser.compile_ident_factor, 'compile_ident_factor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprNodeFactory(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprNodeFactory) do begin
    {RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.LoadVar32, 'LoadVar32');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.LoadVar64, 'LoadVar64');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.LoadVar80, 'LoadVar80');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.LoadConst32, 'LoadConst32');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.LoadConst64, 'LoadConst64');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.LoadConst80, 'LoadConst80');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.CallFloatFunc, 'CallFloatFunc');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.CallFloat32Func, 'CallFloat32Func');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.CallFloat64Func, 'CallFloat64Func');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.CallFloat80Func, 'CallFloat80Func');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.CallUnaryFunc, 'CallUnaryFunc');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.CallUnary32Func, 'CallUnary32Func');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.CallUnary64Func, 'CallUnary64Func');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.CallUnary80Func, 'CallUnary80Func');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.CallBinaryFunc, 'CallBinaryFunc');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.CallBinary32Func, 'CallBinary32Func');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.CallBinary64Func, 'CallBinary64Func');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.CallBinary80Func, 'CallBinary80Func');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.CallTernaryFunc, 'CallTernaryFunc');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.CallTernary32Func, 'CallTernary32Func');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.CallTernary64Func, 'CallTernary64Func');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.CallTernary80Func, 'CallTernary80Func');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.Add, 'Add');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.Subtract, 'Subtract');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.Multiply, 'Multiply');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.Divide, 'Divide');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.Negate, 'Negate');
    RegisterVirtualAbstractMethod(@TExprNodeFactory, @!.Compare, 'Compare');
    }
    RegisterMethod(@TExprNodeFactoryLoadVar0_P, 'LoadVar0');
    RegisterMethod(@TExprNodeFactoryLoadVar1_P, 'LoadVar1');
    RegisterMethod(@TExprNodeFactoryLoadVar2_P, 'LoadVar2');
    RegisterMethod(@TExprNodeFactoryLoadConst3_P, 'LoadConst3');
    RegisterMethod(@TExprNodeFactoryLoadConst4_P, 'LoadConst4');
    RegisterMethod(@TExprNodeFactoryLoadConst5_P, 'LoadConst5');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprNode) do begin
    RegisterConstructor(@TExprNode.Create, 'Create');
  RegisterMethod(@TExprNode.Destroy, 'Free');
    RegisterMethod(@TExprNode.AddDep, 'AddDep');
    RegisterPropertyHelper(@TExprNodeDepCount_R,nil,'DepCount');
    RegisterPropertyHelper(@TExprNodeDeps_R,nil,'Deps');
    RegisterPropertyHelper(@TExprNodeDepList_R,nil,'DepList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprLexer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprLexer) do begin
    RegisterConstructor(@TExprLexer.Create, 'Create');
   // RegisterVirtualAbstractMethod(@TExprLexer, @!.NextTok, 'NextTok');
    RegisterVirtualMethod(@TExprLexer.Reset, 'Reset');
    RegisterPropertyHelper(@TExprLexerTokenAsString_R,nil,'TokenAsString');
    RegisterPropertyHelper(@TExprLexerTokenAsNumber_R,nil,'TokenAsNumber');
    RegisterPropertyHelper(@TExprLexerCurrTok_R,nil,'CurrTok');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprSym(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprSym) do
  begin
    RegisterConstructor(@TExprSym.Create, 'Create');
    //RegisterVirtualAbstractMethod(@TExprSym, @!.Evaluate, 'Evaluate');
    //RegisterVirtualAbstractMethod(@TExprSym, @!.Compile, 'Compile');
    RegisterPropertyHelper(@TExprSymIdent_R,nil,'Ident');
    RegisterPropertyHelper(@TExprSymLexer_R,@TExprSymLexer_W,'Lexer');
    RegisterPropertyHelper(@TExprSymCompileParser_R,@TExprSymCompileParser_W,'CompileParser');
    RegisterPropertyHelper(@TExprSymEvalParser_R,@TExprSymEvalParser_W,'EvalParser');
    RegisterPropertyHelper(@TExprSymNodeFactory_R,@TExprSymNodeFactory_W,'NodeFactory');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprSetContext(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprSetContext) do
  begin
    RegisterConstructor(@TExprSetContext.Create, 'Create');
    RegisterMethod(@TExprSetContext.Add, 'Add');
    RegisterMethod(@TExprSetContext.Remove, 'Remove');
    RegisterMethod(@TExprSetContext.Delete, 'Delete');
    RegisterMethod(@TExprSetContext.Extract, 'Extract');
    RegisterPropertyHelper(@TExprSetContextCount_R,nil,'Count');
    RegisterPropertyHelper(@TExprSetContextContexts_R,nil,'Contexts');
    RegisterPropertyHelper(@TExprSetContextInternalList_R,nil,'InternalList');
    RegisterMethod(@TExprSetContext.Find, 'Find');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprHashContext(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprHashContext) do begin
    RegisterConstructor(@TExprHashContext.Create, 'Create');
   RegisterMethod(@TExprHashContext.Destroy, 'Free');
    RegisterMethod(@TExprHashContext.Add, 'Add');
    RegisterMethod(@TExprHashContext.Remove, 'Remove');
    RegisterMethod(@TExprHashContext.Find, 'Find');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExprContext(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExprContext) do
  begin
    //RegisterVirtualAbstractMethod(@TExprContext, @!.Find, 'Find');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclExprEval(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJclExprEvalError) do
  with CL.Add(TExprLexer) do
  with CL.Add(TExprCompileParser) do
  with CL.Add(TExprEvalParser) do
  with CL.Add(TExprSym) do
  with CL.Add(TExprNode) do
  with CL.Add(TExprNodeFactory) do
  RIRegister_TExprContext(CL);
  RIRegister_TExprHashContext(CL);
  RIRegister_TExprSetContext(CL);
  RIRegister_TExprSym(CL);
  RIRegister_TExprLexer(CL);
  RIRegister_TExprNode(CL);
  RIRegister_TExprNodeFactory(CL);
  RIRegister_TExprCompileParser(CL);
  RIRegister_TExprEvalParser(CL);
  RIRegister_TExprSimpleLexer(CL);
  RIRegister_TExprVirtMachOp(CL);
  RIRegister_TExprVirtMach(CL);
  RIRegister_TExprVirtMachNodeFactory(CL);
  RIRegister_TExprConstSym(CL);
  RIRegister_TExprConst32Sym(CL);
  RIRegister_TExprConst64Sym(CL);
  RIRegister_TExprConst80Sym(CL);
  RIRegister_TExprVar32Sym(CL);
  RIRegister_TExprVar64Sym(CL);
  RIRegister_TExprVar80Sym(CL);
  RIRegister_TExprAbstractFuncSym(CL);
  RIRegister_TExprFuncSym(CL);
  RIRegister_TExprFloat32FuncSym(CL);
  RIRegister_TExprFloat64FuncSym(CL);
  RIRegister_TExprFloat80FuncSym(CL);
  RIRegister_TExprUnaryFuncSym(CL);
  RIRegister_TExprUnary32FuncSym(CL);
  RIRegister_TExprUnary64FuncSym(CL);
  RIRegister_TExprUnary80FuncSym(CL);
  RIRegister_TExprBinaryFuncSym(CL);
  RIRegister_TExprBinary32FuncSym(CL);
  RIRegister_TExprBinary64FuncSym(CL);
  RIRegister_TExprBinary80FuncSym(CL);
  RIRegister_TExprTernaryFuncSym(CL);
  RIRegister_TExprTernary32FuncSym(CL);
  RIRegister_TExprTernary64FuncSym(CL);
  RIRegister_TExprTernary80FuncSym(CL);
  RIRegister_TEasyEvaluator(CL);
  RIRegister_TEvaluator(CL);
  RIRegister_TCompiledEvaluator(CL);
  RIRegister_TExpressionCompiler(CL);
end;



{ TPSImport_JclExprEval }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclExprEval.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclExprEval(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclExprEval.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclExprEval(ri);
end;
(*----------------------------------------------------------------------------*)


end.
