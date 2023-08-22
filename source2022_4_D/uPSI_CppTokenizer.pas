unit uPSI_CppTokenizer;
{
   for multilang code
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
  TPSImport_CppTokenizer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCppTokenizer(CL: TPSPascalCompiler);
procedure SIRegister_CppTokenizer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCppTokenizer(CL: TPSRuntimeClassImporter);
procedure RIRegister_CppTokenizer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StrUtils
  ,ComCtrls
  ,CppTokenizer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CppTokenizer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCppTokenizer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCppTokenizer') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCppTokenizer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Reset');
    RegisterMethod('Procedure Tokenize( StartAt : PChar);');
    RegisterMethod('Procedure Tokenize1( FileName : TFilename);');
    RegisterMethod('Procedure Tokenize2( Stream : TStream);');
    RegisterProperty('LogTokens', 'boolean', iptrw);
    RegisterProperty('OnLogToken', 'TLogTokenEvent', iptrw);
    RegisterProperty('OnProgress', 'TProgressEvent', iptrw);
    RegisterProperty('Tokens', 'TList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CppTokenizer(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MAX_TOKEN_SIZE','LongInt').SetInt( 32768);
  CL.AddTypeS('TSetOfChars', 'set of Char');
  CL.AddTypeS('TLogTokenEvent', 'Procedure ( Sender : TObject; Msg : string)');
  CL.AddTypeS('TProgressEvent', 'Procedure (Sender: TObject; FileName: string; Total, Current : integer)');
  //CL.AddTypeS('PToken', '^CTToken // will not work');
  CL.AddTypeS('CTToken', 'record Text : string; Line : integer; end');
  SIRegister_TCppTokenizer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCppTokenizerTokens_R(Self: TCppTokenizer; var T: TList);
begin T := Self.Tokens; end;

(*----------------------------------------------------------------------------*)
procedure TCppTokenizerOnProgress_W(Self: TCppTokenizer; const T: TProgressEvent);
begin Self.OnProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TCppTokenizerOnProgress_R(Self: TCppTokenizer; var T: TProgressEvent);
begin T := Self.OnProgress; end;

(*----------------------------------------------------------------------------*)
procedure TCppTokenizerOnLogToken_W(Self: TCppTokenizer; const T: TLogTokenEvent);
begin Self.OnLogToken := T; end;

(*----------------------------------------------------------------------------*)
procedure TCppTokenizerOnLogToken_R(Self: TCppTokenizer; var T: TLogTokenEvent);
begin T := Self.OnLogToken; end;

(*----------------------------------------------------------------------------*)
procedure TCppTokenizerLogTokens_W(Self: TCppTokenizer; const T: boolean);
begin Self.LogTokens := T; end;

(*----------------------------------------------------------------------------*)
procedure TCppTokenizerLogTokens_R(Self: TCppTokenizer; var T: boolean);
begin T := Self.LogTokens; end;

(*----------------------------------------------------------------------------*)
Procedure TCppTokenizerTokenize2_P(Self: TCppTokenizer;  Stream : TStream);
Begin Self.Tokenize(Stream); END;

(*----------------------------------------------------------------------------*)
Procedure TCppTokenizerTokenize1_P(Self: TCppTokenizer;  FileName : TFilename);
Begin Self.Tokenize(FileName); END;

(*----------------------------------------------------------------------------*)
Procedure TCppTokenizerTokenize_P(Self: TCppTokenizer;  StartAt : PChar);
Begin Self.Tokenize(StartAt); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCppTokenizer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCppTokenizer) do begin
    RegisterConstructor(@TCppTokenizer.Create, 'Create');
    RegisterMethod(@TCppTokenizer.Destroy, 'Free');
    RegisterMethod(@TCppTokenizer.Reset, 'Reset');
    RegisterMethod(@TCppTokenizerTokenize_P, 'Tokenize');
    RegisterMethod(@TCppTokenizerTokenize1_P, 'Tokenize1');
    RegisterMethod(@TCppTokenizerTokenize2_P, 'Tokenize2');
    RegisterPropertyHelper(@TCppTokenizerLogTokens_R,@TCppTokenizerLogTokens_W,'LogTokens');
    RegisterPropertyHelper(@TCppTokenizerOnLogToken_R,@TCppTokenizerOnLogToken_W,'OnLogToken');
    RegisterPropertyHelper(@TCppTokenizerOnProgress_R,@TCppTokenizerOnProgress_W,'OnProgress');
    RegisterPropertyHelper(@TCppTokenizerTokens_R,nil,'Tokens');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CppTokenizer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCppTokenizer(CL);
end;

 
 
{ TPSImport_CppTokenizer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CppTokenizer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CppTokenizer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CppTokenizer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CppTokenizer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
