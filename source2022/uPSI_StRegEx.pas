unit uPSI_StRegEx;
{
  regex of Systools4     add TStNodeHeap = class
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
  TPSImport_StRegEx = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStRegEx(CL: TPSPascalCompiler);
procedure SIRegister_TStStreamRegEx(CL: TPSPascalCompiler);
procedure SIRegister_TStNodeHeap(CL: TPSPascalCompiler);
procedure SIRegister_StRegEx(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStRegEx(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStStreamRegEx(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStNodeHeap(CL: TPSRuntimeClassImporter);
procedure RIRegister_StRegEx(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  //,Messages
  {,Graphics
  ,Controls
  ,Forms
  ,Dialogs}
  ,StConst
  ,StBase
  ,StStrms
  ,StRegEx
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StRegEx]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStRegEx(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStComponent', 'TStRegEx') do
  with CL.AddClassN(CL.FindClass('TStComponent'),'TStRegEx') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Function CheckString( const S : AnsiString; var REPosition : TMatchPosition) : Boolean');
    RegisterMethod('Function FileMasksToRegEx( const Masks : AnsiString) : Boolean');
    RegisterMethod('Function Execute : Boolean');
    RegisterMethod('Function ReplaceString( var S : AnsiString; var REPosition : TMatchPosition) : Boolean');
    RegisterProperty('LineCount', 'Cardinal', iptr);
    RegisterProperty('LinesMatched', 'Cardinal', iptr);
    RegisterProperty('LinesPerSecond', 'Cardinal', iptr);
    RegisterProperty('LinesReplaced', 'Cardinal', iptr);
    RegisterProperty('LinesSelected', 'Cardinal', iptr);
    RegisterProperty('MaxLineLength', 'Cardinal', iptrw);
    RegisterProperty('Avoid', 'Boolean', iptrw);
    RegisterProperty('IgnoreCase', 'Boolean', iptrw);
    RegisterProperty('InFixedLineLength', 'Integer', iptrw);
    RegisterProperty('InLineTermChar', 'AnsiChar', iptrw);
    RegisterProperty('InLineTerminator', 'TStLineTerminator', iptrw);
    RegisterProperty('InputFile', 'AnsiString', iptrw);
    RegisterProperty('LineNumbers', 'Boolean', iptrw);
    RegisterProperty('MatchPattern', 'TStringList', iptrw);
    RegisterProperty('OnMatch', 'TStOnMatchEvent', iptrw);
    RegisterProperty('OnProgress', 'TStOnRegExProgEvent', iptrw);
    RegisterProperty('OutFixedLineLength', 'Integer', iptrw);
    RegisterProperty('OutLineTermChar', 'AnsiChar', iptrw);
    RegisterProperty('OutLineTerminator', 'TStLineTerminator', iptrw);
    RegisterProperty('OutputFile', 'AnsiString', iptrw);
    RegisterProperty('OutputOptions', 'TStOutputOptions', iptrw);
    RegisterProperty('ReplacePattern', 'TStringList', iptrw);
    RegisterProperty('SelAvoidPattern', 'TStringList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStStreamRegEx(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TStStreamRegEx') do
  with CL.AddClassN(CL.FindClass('TObject'),'TStStreamRegEx') do begin
    RegisterProperty('InputStream', 'TStream', iptrw);
    RegisterProperty('OutputStream', 'TStream', iptrw);
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
    RegisterMethod('Function CheckString( const S : AnsiString; var REPosition : TMatchPosition) : Boolean');
    RegisterMethod('Function FileMasksToRegEx( Masks : AnsiString) : Boolean');
    RegisterMethod('Function Execute : Boolean');
    RegisterMethod('Function ReplaceString( var S : AnsiString; var REPosition : TMatchPosition) : Boolean');
    RegisterProperty('Avoid', 'Boolean', iptrw);
    RegisterProperty('IgnoreCase', 'Boolean', iptrw);
    RegisterProperty('InFixedLineLength', 'integer', iptrw);
    RegisterProperty('InLineTermChar', 'AnsiChar', iptrw);
    RegisterProperty('InLineTerminator', 'TStLineTerminator', iptrw);
    RegisterProperty('LineCount', 'Cardinal', iptr);
    RegisterProperty('LineNumbers', 'Boolean', iptrw);
    RegisterProperty('LinesMatched', 'Cardinal', iptr);
    RegisterProperty('LinesPerSecond', 'Cardinal', iptr);
    RegisterProperty('LinesReplaced', 'Cardinal', iptr);
    RegisterProperty('LinesSelected', 'Cardinal', iptr);
    RegisterProperty('MatchPattern', 'TStringList', iptrw);
    RegisterProperty('MaxLineLength', 'Cardinal', iptrw);
    RegisterProperty('OnMatch', 'TStOnMatchEvent', iptrw);
    RegisterProperty('OnProgress', 'TStOnRegExProgEvent', iptrw);
    RegisterProperty('OutFixedLineLength', 'integer', iptrw);
    RegisterProperty('OutLineTermChar', 'AnsiChar', iptrw);
    RegisterProperty('OutLineTerminator', 'TStLineTerminator', iptrw);
    RegisterProperty('OutputOptions', 'TStOutputOptions', iptrw);
    RegisterProperty('ReplacePattern', 'TStringList', iptrw);
    RegisterProperty('SelAvoidPattern', 'TStringList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStNodeHeap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStNodeHeap') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStNodeHeap') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
     RegisterMethod('Function AllocNode : PStPatRecord');
    RegisterMethod('Procedure FreeNode( aNode : PStPatRecord)');
    RegisterMethod('Function CloneNode( aNode : PStPatRecord) : PStPatRecord');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StRegEx(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TMatchPosition', 'record StartPos : Cardinal; EndPos : Cardinal;'
   +' Length : Cardinal; LineNum : Cardinal; end');
  CL.AddTypeS('TStOutputOption', '( ooUnselected, ooModified, ooCountOnly )');
  CL.AddTypeS('TStOutputOptions', 'set of TStOutputOption');
  CL.AddTypeS('TStTokens', '( tknNil, tknLitChar, tknCharClass, tknNegCharClass'
   +', tknClosure, tknMaybeOne, tknAnyChar, tknBegOfLine, tknEndOfLine, tknGrou'
   +'p, tknBegTag, tknEndTag, tknDitto )');
  //CL.AddTypeS('PStPatRecord', '^TStPatRecord // will not work');
  //CL.AddTypeS('TStPatRecord', 'record StrPtr :  ^ShortString // will not work; '
   //+'NestedPattern : PStPatRecord; NextPattern : PStPatRecord; Token : TStToken'
   //+'s; OneChar : AnsiChar; NextOK : Boolean; end');
  CL.AddTypeS('TStOnRegExProgEvent', 'Procedure (Sender : TObject; Percent: Word)');
  CL.AddTypeS('TStOnMatchEvent', 'Procedure (Sender: TObject; REPosition: TMatchPosition)');
  SIRegister_TStNodeHeap(CL);
  SIRegister_TStStreamRegEx(CL);
  SIRegister_TStRegEx(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStRegExSelAvoidPattern_W(Self: TStRegEx; const T: TStringList);
begin Self.SelAvoidPattern := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExSelAvoidPattern_R(Self: TStRegEx; var T: TStringList);
begin T := Self.SelAvoidPattern; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExReplacePattern_W(Self: TStRegEx; const T: TStringList);
begin Self.ReplacePattern := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExReplacePattern_R(Self: TStRegEx; var T: TStringList);
begin T := Self.ReplacePattern; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExOutputOptions_W(Self: TStRegEx; const T: TStOutputOptions);
begin Self.OutputOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExOutputOptions_R(Self: TStRegEx; var T: TStOutputOptions);
begin T := Self.OutputOptions; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExOutputFile_W(Self: TStRegEx; const T: AnsiString);
begin Self.OutputFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExOutputFile_R(Self: TStRegEx; var T: AnsiString);
begin T := Self.OutputFile; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExOutLineTerminator_W(Self: TStRegEx; const T: TStLineTerminator);
begin Self.OutLineTerminator := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExOutLineTerminator_R(Self: TStRegEx; var T: TStLineTerminator);
begin T := Self.OutLineTerminator; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExOutLineTermChar_W(Self: TStRegEx; const T: AnsiChar);
begin Self.OutLineTermChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExOutLineTermChar_R(Self: TStRegEx; var T: AnsiChar);
begin T := Self.OutLineTermChar; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExOutFixedLineLength_W(Self: TStRegEx; const T: Integer);
begin Self.OutFixedLineLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExOutFixedLineLength_R(Self: TStRegEx; var T: Integer);
begin T := Self.OutFixedLineLength; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExOnProgress_W(Self: TStRegEx; const T: TStOnRegExProgEvent);
begin Self.OnProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExOnProgress_R(Self: TStRegEx; var T: TStOnRegExProgEvent);
begin T := Self.OnProgress; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExOnMatch_W(Self: TStRegEx; const T: TStOnMatchEvent);
begin Self.OnMatch := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExOnMatch_R(Self: TStRegEx; var T: TStOnMatchEvent);
begin T := Self.OnMatch; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExMatchPattern_W(Self: TStRegEx; const T: TStringList);
begin Self.MatchPattern := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExMatchPattern_R(Self: TStRegEx; var T: TStringList);
begin T := Self.MatchPattern; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExLineNumbers_W(Self: TStRegEx; const T: Boolean);
begin Self.LineNumbers := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExLineNumbers_R(Self: TStRegEx; var T: Boolean);
begin T := Self.LineNumbers; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExInputFile_W(Self: TStRegEx; const T: AnsiString);
begin Self.InputFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExInputFile_R(Self: TStRegEx; var T: AnsiString);
begin T := Self.InputFile; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExInLineTerminator_W(Self: TStRegEx; const T: TStLineTerminator);
begin Self.InLineTerminator := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExInLineTerminator_R(Self: TStRegEx; var T: TStLineTerminator);
begin T := Self.InLineTerminator; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExInLineTermChar_W(Self: TStRegEx; const T: AnsiChar);
begin Self.InLineTermChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExInLineTermChar_R(Self: TStRegEx; var T: AnsiChar);
begin T := Self.InLineTermChar; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExInFixedLineLength_W(Self: TStRegEx; const T: Integer);
begin Self.InFixedLineLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExInFixedLineLength_R(Self: TStRegEx; var T: Integer);
begin T := Self.InFixedLineLength; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExIgnoreCase_W(Self: TStRegEx; const T: Boolean);
begin Self.IgnoreCase := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExIgnoreCase_R(Self: TStRegEx; var T: Boolean);
begin T := Self.IgnoreCase; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExAvoid_W(Self: TStRegEx; const T: Boolean);
begin Self.Avoid := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExAvoid_R(Self: TStRegEx; var T: Boolean);
begin T := Self.Avoid; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExMaxLineLength_W(Self: TStRegEx; const T: Cardinal);
begin Self.MaxLineLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExMaxLineLength_R(Self: TStRegEx; var T: Cardinal);
begin T := Self.MaxLineLength; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExLinesSelected_R(Self: TStRegEx; var T: Cardinal);
begin T := Self.LinesSelected; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExLinesReplaced_R(Self: TStRegEx; var T: Cardinal);
begin T := Self.LinesReplaced; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExLinesPerSecond_R(Self: TStRegEx; var T: Cardinal);
begin T := Self.LinesPerSecond; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExLinesMatched_R(Self: TStRegEx; var T: Cardinal);
begin T := Self.LinesMatched; end;

(*----------------------------------------------------------------------------*)
procedure TStRegExLineCount_R(Self: TStRegEx; var T: Cardinal);
begin T := Self.LineCount; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExSelAvoidPattern_W(Self: TStStreamRegEx; const T: TStringList);
begin Self.SelAvoidPattern := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExSelAvoidPattern_R(Self: TStStreamRegEx; var T: TStringList);
begin T := Self.SelAvoidPattern; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExReplacePattern_W(Self: TStStreamRegEx; const T: TStringList);
begin Self.ReplacePattern := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExReplacePattern_R(Self: TStStreamRegEx; var T: TStringList);
begin T := Self.ReplacePattern; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExOutputOptions_W(Self: TStStreamRegEx; const T: TStOutputOptions);
begin Self.OutputOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExOutputOptions_R(Self: TStStreamRegEx; var T: TStOutputOptions);
begin T := Self.OutputOptions; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExOutLineTerminator_W(Self: TStStreamRegEx; const T: TStLineTerminator);
begin Self.OutLineTerminator := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExOutLineTerminator_R(Self: TStStreamRegEx; var T: TStLineTerminator);
begin T := Self.OutLineTerminator; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExOutLineTermChar_W(Self: TStStreamRegEx; const T: AnsiChar);
begin Self.OutLineTermChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExOutLineTermChar_R(Self: TStStreamRegEx; var T: AnsiChar);
begin T := Self.OutLineTermChar; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExOutFixedLineLength_W(Self: TStStreamRegEx; const T: integer);
begin Self.OutFixedLineLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExOutFixedLineLength_R(Self: TStStreamRegEx; var T: integer);
begin T := Self.OutFixedLineLength; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExOnProgress_W(Self: TStStreamRegEx; const T: TStOnRegExProgEvent);
begin Self.OnProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExOnProgress_R(Self: TStStreamRegEx; var T: TStOnRegExProgEvent);
begin T := Self.OnProgress; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExOnMatch_W(Self: TStStreamRegEx; const T: TStOnMatchEvent);
begin Self.OnMatch := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExOnMatch_R(Self: TStStreamRegEx; var T: TStOnMatchEvent);
begin T := Self.OnMatch; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExMaxLineLength_W(Self: TStStreamRegEx; const T: Cardinal);
begin Self.MaxLineLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExMaxLineLength_R(Self: TStStreamRegEx; var T: Cardinal);
begin T := Self.MaxLineLength; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExMatchPattern_W(Self: TStStreamRegEx; const T: TStringList);
begin Self.MatchPattern := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExMatchPattern_R(Self: TStStreamRegEx; var T: TStringList);
begin T := Self.MatchPattern; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExLinesSelected_R(Self: TStStreamRegEx; var T: Cardinal);
begin T := Self.LinesSelected; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExLinesReplaced_R(Self: TStStreamRegEx; var T: Cardinal);
begin T := Self.LinesReplaced; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExLinesPerSecond_R(Self: TStStreamRegEx; var T: Cardinal);
begin T := Self.LinesPerSecond; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExLinesMatched_R(Self: TStStreamRegEx; var T: Cardinal);
begin T := Self.LinesMatched; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExLineNumbers_W(Self: TStStreamRegEx; const T: Boolean);
begin Self.LineNumbers := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExLineNumbers_R(Self: TStStreamRegEx; var T: Boolean);
begin T := Self.LineNumbers; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExLineCount_R(Self: TStStreamRegEx; var T: Cardinal);
begin T := Self.LineCount; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExInLineTerminator_W(Self: TStStreamRegEx; const T: TStLineTerminator);
begin Self.InLineTerminator := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExInLineTerminator_R(Self: TStStreamRegEx; var T: TStLineTerminator);
begin T := Self.InLineTerminator; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExInLineTermChar_W(Self: TStStreamRegEx; const T: AnsiChar);
begin Self.InLineTermChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExInLineTermChar_R(Self: TStStreamRegEx; var T: AnsiChar);
begin T := Self.InLineTermChar; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExInFixedLineLength_W(Self: TStStreamRegEx; const T: integer);
begin Self.InFixedLineLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExInFixedLineLength_R(Self: TStStreamRegEx; var T: integer);
begin T := Self.InFixedLineLength; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExIgnoreCase_W(Self: TStStreamRegEx; const T: Boolean);
begin Self.IgnoreCase := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExIgnoreCase_R(Self: TStStreamRegEx; var T: Boolean);
begin T := Self.IgnoreCase; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExAvoid_W(Self: TStStreamRegEx; const T: Boolean);
begin Self.Avoid := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExAvoid_R(Self: TStStreamRegEx; var T: Boolean);
begin T := Self.Avoid; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExOutputStream_W(Self: TStStreamRegEx; const T: TStream);
begin Self.OutputStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExOutputStream_R(Self: TStStreamRegEx; var T: TStream);
begin T := Self.OutputStream; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExInputStream_W(Self: TStStreamRegEx; const T: TStream);
begin Self.InputStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStreamRegExInputStream_R(Self: TStStreamRegEx; var T: TStream);
begin T := Self.InputStream; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStRegEx(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStRegEx) do begin
    RegisterConstructor(@TStRegEx.Create, 'Create');
    RegisterMethod(@TStRegEx.Destroy, 'Free');
    RegisterMethod(@TStRegEx.CheckString, 'CheckString');
    RegisterMethod(@TStRegEx.FileMasksToRegEx, 'FileMasksToRegEx');
    RegisterMethod(@TStRegEx.Execute, 'Execute');
    RegisterMethod(@TStRegEx.ReplaceString, 'ReplaceString');
    RegisterPropertyHelper(@TStRegExLineCount_R,nil,'LineCount');
    RegisterPropertyHelper(@TStRegExLinesMatched_R,nil,'LinesMatched');
    RegisterPropertyHelper(@TStRegExLinesPerSecond_R,nil,'LinesPerSecond');
    RegisterPropertyHelper(@TStRegExLinesReplaced_R,nil,'LinesReplaced');
    RegisterPropertyHelper(@TStRegExLinesSelected_R,nil,'LinesSelected');
    RegisterPropertyHelper(@TStRegExMaxLineLength_R,@TStRegExMaxLineLength_W,'MaxLineLength');
    RegisterPropertyHelper(@TStRegExAvoid_R,@TStRegExAvoid_W,'Avoid');
    RegisterPropertyHelper(@TStRegExIgnoreCase_R,@TStRegExIgnoreCase_W,'IgnoreCase');
    RegisterPropertyHelper(@TStRegExInFixedLineLength_R,@TStRegExInFixedLineLength_W,'InFixedLineLength');
    RegisterPropertyHelper(@TStRegExInLineTermChar_R,@TStRegExInLineTermChar_W,'InLineTermChar');
    RegisterPropertyHelper(@TStRegExInLineTerminator_R,@TStRegExInLineTerminator_W,'InLineTerminator');
    RegisterPropertyHelper(@TStRegExInputFile_R,@TStRegExInputFile_W,'InputFile');
    RegisterPropertyHelper(@TStRegExLineNumbers_R,@TStRegExLineNumbers_W,'LineNumbers');
    RegisterPropertyHelper(@TStRegExMatchPattern_R,@TStRegExMatchPattern_W,'MatchPattern');
    RegisterPropertyHelper(@TStRegExOnMatch_R,@TStRegExOnMatch_W,'OnMatch');
    RegisterPropertyHelper(@TStRegExOnProgress_R,@TStRegExOnProgress_W,'OnProgress');
    RegisterPropertyHelper(@TStRegExOutFixedLineLength_R,@TStRegExOutFixedLineLength_W,'OutFixedLineLength');
    RegisterPropertyHelper(@TStRegExOutLineTermChar_R,@TStRegExOutLineTermChar_W,'OutLineTermChar');
    RegisterPropertyHelper(@TStRegExOutLineTerminator_R,@TStRegExOutLineTerminator_W,'OutLineTerminator');
    RegisterPropertyHelper(@TStRegExOutputFile_R,@TStRegExOutputFile_W,'OutputFile');
    RegisterPropertyHelper(@TStRegExOutputOptions_R,@TStRegExOutputOptions_W,'OutputOptions');
    RegisterPropertyHelper(@TStRegExReplacePattern_R,@TStRegExReplacePattern_W,'ReplacePattern');
    RegisterPropertyHelper(@TStRegExSelAvoidPattern_R,@TStRegExSelAvoidPattern_W,'SelAvoidPattern');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStStreamRegEx(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStStreamRegEx) do begin
    RegisterPropertyHelper(@TStStreamRegExInputStream_R,@TStStreamRegExInputStream_W,'InputStream');
    RegisterPropertyHelper(@TStStreamRegExOutputStream_R,@TStStreamRegExOutputStream_W,'OutputStream');
    RegisterConstructor(@TStStreamRegEx.Create, 'Create');
    RegisterMethod(@TStStreamRegEx.Destroy, 'Free');
    RegisterMethod(@TStStreamRegEx.CheckString, 'CheckString');
    RegisterMethod(@TStStreamRegEx.FileMasksToRegEx, 'FileMasksToRegEx');
    RegisterMethod(@TStStreamRegEx.Execute, 'Execute');
    RegisterMethod(@TStStreamRegEx.ReplaceString, 'ReplaceString');
    RegisterPropertyHelper(@TStStreamRegExAvoid_R,@TStStreamRegExAvoid_W,'Avoid');
    RegisterPropertyHelper(@TStStreamRegExIgnoreCase_R,@TStStreamRegExIgnoreCase_W,'IgnoreCase');
    RegisterPropertyHelper(@TStStreamRegExInFixedLineLength_R,@TStStreamRegExInFixedLineLength_W,'InFixedLineLength');
    RegisterPropertyHelper(@TStStreamRegExInLineTermChar_R,@TStStreamRegExInLineTermChar_W,'InLineTermChar');
    RegisterPropertyHelper(@TStStreamRegExInLineTerminator_R,@TStStreamRegExInLineTerminator_W,'InLineTerminator');
    RegisterPropertyHelper(@TStStreamRegExLineCount_R,nil,'LineCount');
    RegisterPropertyHelper(@TStStreamRegExLineNumbers_R,@TStStreamRegExLineNumbers_W,'LineNumbers');
    RegisterPropertyHelper(@TStStreamRegExLinesMatched_R,nil,'LinesMatched');
    RegisterPropertyHelper(@TStStreamRegExLinesPerSecond_R,nil,'LinesPerSecond');
    RegisterPropertyHelper(@TStStreamRegExLinesReplaced_R,nil,'LinesReplaced');
    RegisterPropertyHelper(@TStStreamRegExLinesSelected_R,nil,'LinesSelected');
    RegisterPropertyHelper(@TStStreamRegExMatchPattern_R,@TStStreamRegExMatchPattern_W,'MatchPattern');
    RegisterPropertyHelper(@TStStreamRegExMaxLineLength_R,@TStStreamRegExMaxLineLength_W,'MaxLineLength');
    RegisterPropertyHelper(@TStStreamRegExOnMatch_R,@TStStreamRegExOnMatch_W,'OnMatch');
    RegisterPropertyHelper(@TStStreamRegExOnProgress_R,@TStStreamRegExOnProgress_W,'OnProgress');
    RegisterPropertyHelper(@TStStreamRegExOutFixedLineLength_R,@TStStreamRegExOutFixedLineLength_W,'OutFixedLineLength');
    RegisterPropertyHelper(@TStStreamRegExOutLineTermChar_R,@TStStreamRegExOutLineTermChar_W,'OutLineTermChar');
    RegisterPropertyHelper(@TStStreamRegExOutLineTerminator_R,@TStStreamRegExOutLineTerminator_W,'OutLineTerminator');
    RegisterPropertyHelper(@TStStreamRegExOutputOptions_R,@TStStreamRegExOutputOptions_W,'OutputOptions');
    RegisterPropertyHelper(@TStStreamRegExReplacePattern_R,@TStStreamRegExReplacePattern_W,'ReplacePattern');
    RegisterPropertyHelper(@TStStreamRegExSelAvoidPattern_R,@TStStreamRegExSelAvoidPattern_W,'SelAvoidPattern');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStNodeHeap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStNodeHeap) do begin
    RegisterConstructor(@TStNodeHeap.Create, 'Create');
      RegisterMethod(@TStNodeHeap.Destroy, 'Free');
      RegisterMethod(@TStNodeHeap.AllocNode, 'AllocNode');
    RegisterMethod(@TStNodeHeap.FreeNode, 'FreeNode');
    RegisterMethod(@TStNodeHeap.CloneNode, 'CloneNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StRegEx(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStNodeHeap(CL);
  RIRegister_TStStreamRegEx(CL);
  RIRegister_TStRegEx(CL);
end;

 
 
{ TPSImport_StRegEx }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StRegEx.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StRegEx(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StRegEx.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StRegEx(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
