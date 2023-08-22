unit uPSI_JvHtmlParser;
{
  for Expression Parser
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
  TPSImport_JvHtmlParser = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvHTMLParser(CL: TPSPascalCompiler);
procedure SIRegister_TTagInfoList(CL: TPSPascalCompiler);
procedure SIRegister_TJvParserInfo(CL: TPSPascalCompiler);
procedure SIRegister_JvHtmlParser(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvHTMLParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTagInfoList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvParserInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvHtmlParser(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //JclUnitVersioning
  JclStrings
  ,JvTypes
  ,JvComponentBase
  ,JvHtmlParser
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvHtmlParser]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvHTMLParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvHTMLParser') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvHTMLParser') do begin
   RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free');
   RegisterMethod('Procedure AnalyseString( const Str : string)');
    RegisterMethod('Procedure AnalyseFile');
    RegisterMethod('Procedure AddCondition( const Keyword : string; const StartTag : string; const EndTag : string; TextSelection : Integer)');
    RegisterMethod('Procedure RemoveCondition( Index : Integer)');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('ConditionsCount', 'Integer', iptr);
    RegisterMethod('Procedure ClearConditions');
    RegisterMethod('Procedure GetCondition( Index : Integer; var Keyword, StartTag, EndTag : string);');
    RegisterMethod('Procedure GetCondition1( Index : Integer; var Keyword, StartTag, EndTag : string; var TextSelection : Integer);');
    RegisterProperty('Content', 'string', iptr);
    RegisterProperty('FileName', 'TFileName', iptrw);
    RegisterProperty('Parser', 'TStrings', iptrw);
    RegisterProperty('OnKeyFound', 'TJvKeyFoundEvent', iptrw);
    RegisterProperty('OnKeyFoundEx', 'TJvKeyFoundExEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTagInfoList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TTagInfoList') do
  with CL.AddClassN(CL.FindClass('TList'),'TTagInfoList') do begin
    RegisterMethod('Procedure AddValue( const Value : TTagInfo)');
    RegisterMethod('procedure Clear;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvParserInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvParserInfo') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvParserInfo') do begin
    RegisterProperty('StartTag', 'string', iptrw);
    RegisterProperty('EndTag', 'string', iptrw);
    RegisterProperty('MustBe', 'Integer', iptrw);
    RegisterProperty('TakeText', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvHtmlParser(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PTagInfo', '^TTagInfo // will not work');
  CL.AddTypeS('TTagInfo', 'record BeginPos : Integer; EndPos : Integer; BeginCo'
   +'ntext : Integer; EndContext : Integer; Key : Integer; end');
  SIRegister_TJvParserInfo(CL);
  SIRegister_TTagInfoList(CL);
  CL.AddTypeS('TJvKeyFoundEvent', 'Procedure ( Sender : TObject; Key, Results, '
   +'OriginalLine : string)');
  CL.AddTypeS('TJvKeyFoundExEvent', 'Procedure ( Sender : TObject; Key, Results'
   +', OriginalLine : string; TagInfo : TTagInfo; Attributes : TStrings)');
  SIRegister_TJvHTMLParser(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserOnKeyFoundEx_W(Self: TJvHTMLParser; const T: TJvKeyFoundExEvent);
begin Self.OnKeyFoundEx := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserOnKeyFoundEx_R(Self: TJvHTMLParser; var T: TJvKeyFoundExEvent);
begin T := Self.OnKeyFoundEx; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserOnKeyFound_W(Self: TJvHTMLParser; const T: TJvKeyFoundEvent);
begin Self.OnKeyFound := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserOnKeyFound_R(Self: TJvHTMLParser; var T: TJvKeyFoundEvent);
begin T := Self.OnKeyFound; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserParser_W(Self: TJvHTMLParser; const T: TStrings);
begin Self.Parser := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserParser_R(Self: TJvHTMLParser; var T: TStrings);
begin T := Self.Parser; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFileName_W(Self: TJvHTMLParser; const T: TFileName);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserFileName_R(Self: TJvHTMLParser; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserContent_R(Self: TJvHTMLParser; var T: string);
begin T := Self.Content; end;

(*----------------------------------------------------------------------------*)
Procedure TJvHTMLParserGetCondition1_P(Self: TJvHTMLParser;  Index : Integer; var Keyword, StartTag, EndTag : string; var TextSelection : Integer);
Begin Self.GetCondition(Index, Keyword, StartTag, EndTag, TextSelection); END;

(*----------------------------------------------------------------------------*)
Procedure TJvHTMLParserGetCondition_P(Self: TJvHTMLParser;  Index : Integer; var Keyword, StartTag, EndTag : string);
Begin Self.GetCondition(Index, Keyword, StartTag, EndTag); END;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLParserConditionsCount_R(Self: TJvHTMLParser; var T: Integer);
begin T := Self.ConditionsCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvParserInfoTakeText_W(Self: TJvParserInfo; const T: Integer);
Begin Self.TakeText := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvParserInfoTakeText_R(Self: TJvParserInfo; var T: Integer);
Begin T := Self.TakeText; end;

(*----------------------------------------------------------------------------*)
procedure TJvParserInfoMustBe_W(Self: TJvParserInfo; const T: Integer);
Begin Self.MustBe := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvParserInfoMustBe_R(Self: TJvParserInfo; var T: Integer);
Begin T := Self.MustBe; end;

(*----------------------------------------------------------------------------*)
procedure TJvParserInfoEndTag_W(Self: TJvParserInfo; const T: string);
Begin Self.EndTag := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvParserInfoEndTag_R(Self: TJvParserInfo; var T: string);
Begin T := Self.EndTag; end;

(*----------------------------------------------------------------------------*)
procedure TJvParserInfoStartTag_W(Self: TJvParserInfo; const T: string);
Begin Self.StartTag := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvParserInfoStartTag_R(Self: TJvParserInfo; var T: string);
Begin T := Self.StartTag; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvHTMLParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvHTMLParser) do begin
    RegisterConstructor(@TJvHTMLParser.Create, 'Create');
    RegisterMethod(@TJvHTMLParser.Destroy, 'Free');
    RegisterMethod(@TJvHTMLParser.AnalyseString, 'AnalyseString');
    RegisterMethod(@TJvHTMLParser.AnalyseFile, 'AnalyseFile');
    RegisterMethod(@TJvHTMLParser.AddCondition, 'AddCondition');
    RegisterMethod(@TJvHTMLParser.RemoveCondition, 'RemoveCondition');
    RegisterConstructor(@TJvHTMLParser.Create, 'Create');
    RegisterPropertyHelper(@TJvHTMLParserConditionsCount_R,nil,'ConditionsCount');
    RegisterMethod(@TJvHTMLParser.ClearConditions, 'ClearConditions');
    RegisterMethod(@TJvHTMLParserGetCondition_P, 'GetCondition');
    RegisterMethod(@TJvHTMLParserGetCondition1_P, 'GetCondition1');
    RegisterPropertyHelper(@TJvHTMLParserContent_R,nil,'Content');
    RegisterPropertyHelper(@TJvHTMLParserFileName_R,@TJvHTMLParserFileName_W,'FileName');
    RegisterPropertyHelper(@TJvHTMLParserParser_R,@TJvHTMLParserParser_W,'Parser');
    RegisterPropertyHelper(@TJvHTMLParserOnKeyFound_R,@TJvHTMLParserOnKeyFound_W,'OnKeyFound');
    RegisterPropertyHelper(@TJvHTMLParserOnKeyFoundEx_R,@TJvHTMLParserOnKeyFoundEx_W,'OnKeyFoundEx');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTagInfoList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTagInfoList) do begin
    RegisterMethod(@TTagInfoList.AddValue, 'AddValue');
    RegisterMethod(@TTagInfoList.Clear, 'Clear');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvParserInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvParserInfo) do
  begin
    RegisterPropertyHelper(@TJvParserInfoStartTag_R,@TJvParserInfoStartTag_W,'StartTag');
    RegisterPropertyHelper(@TJvParserInfoEndTag_R,@TJvParserInfoEndTag_W,'EndTag');
    RegisterPropertyHelper(@TJvParserInfoMustBe_R,@TJvParserInfoMustBe_W,'MustBe');
    RegisterPropertyHelper(@TJvParserInfoTakeText_R,@TJvParserInfoTakeText_W,'TakeText');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvHtmlParser(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvParserInfo(CL);
  RIRegister_TTagInfoList(CL);
  RIRegister_TJvHTMLParser(CL);
end;

 
 
{ TPSImport_JvHtmlParser }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvHtmlParser.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvHtmlParser(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvHtmlParser.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvHtmlParser(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
