unit uPSI_StMerge;
{
  mail merge
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
  TPSImport_StMerge = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStTextMerge(CL: TPSPascalCompiler);
procedure SIRegister_StMerge(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStTextMerge(CL: TPSRuntimeClassImporter);
procedure RIRegister_StMerge(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StMerge
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StMerge]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStTextMerge(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStTextMerge') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStTextMerge') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Merge');
    RegisterMethod('Procedure LoadTemplateFromFile( const AFile : TFileName)');
    RegisterMethod('Procedure LoadTemplateFromStream( AStream : TStream)');
    RegisterMethod('Procedure SaveTemplateToFile( const AFile : TFileName)');
    RegisterMethod('Procedure SaveTemplateToStream( AStream : TStream)');
    RegisterMethod('Procedure SaveMergeToFile( const AFile : TFileName)');
    RegisterMethod('Procedure SaveMergeToStream( AStream : TStream)');
    RegisterProperty('BadTag', 'AnsiString', iptrw);
    RegisterProperty('DefaultTags', 'TStrings', iptr);
    RegisterProperty('EscapeChar', 'AnsiChar', iptrw);
    RegisterProperty('MergedText', 'TStrings', iptr);
    RegisterProperty('MergeTags', 'TStrings', iptr);
    RegisterProperty('TagEnd', 'AnsiString', iptrw);
    RegisterProperty('TagStart', 'AnsiString', iptrw);
    RegisterProperty('Template', 'TStrings', iptr);
    RegisterProperty('OnGotMergeTag', 'TStGotMergeTagEvent', iptrw);
    RegisterProperty('OnGotUnknownTag', 'TStGotMergeTagEvent', iptrw);
    RegisterProperty('OnLineDone', 'TStMergeProgressEvent', iptrw);
    RegisterProperty('OnLineStart', 'TStMergeProgressEvent', iptrw);
    RegisterProperty('OnMergeDone', 'TNotifyEvent', iptrw);
    RegisterProperty('OnMergeStart', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StMerge(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('StDefaultTagStart','String').SetString( '<');
 CL.AddConstantN('StDefaultTagEnd','String').SetString( '>');
 CL.AddConstantN('StDefaultEscapeChar','String').SetString( '\');
  CL.AddTypeS('TStGotMergeTagEvent', 'Procedure ( Sender : TObject; Tag : AnsiS'
   +'tring; var Value : AnsiString; var Discard : Boolean)');
  SIRegister_TStTextMerge(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStTextMergeOnMergeStart_W(Self: TStTextMerge; const T: TNotifyEvent);
begin Self.OnMergeStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeOnMergeStart_R(Self: TStTextMerge; var T: TNotifyEvent);
begin T := Self.OnMergeStart; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeOnMergeDone_W(Self: TStTextMerge; const T: TNotifyEvent);
begin Self.OnMergeDone := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeOnMergeDone_R(Self: TStTextMerge; var T: TNotifyEvent);
begin T := Self.OnMergeDone; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeOnLineStart_W(Self: TStTextMerge; const T: TStMergeProgressEvent);
begin Self.OnLineStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeOnLineStart_R(Self: TStTextMerge; var T: TStMergeProgressEvent);
begin T := Self.OnLineStart; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeOnLineDone_W(Self: TStTextMerge; const T: TStMergeProgressEvent);
begin Self.OnLineDone := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeOnLineDone_R(Self: TStTextMerge; var T: TStMergeProgressEvent);
begin T := Self.OnLineDone; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeOnGotUnknownTag_W(Self: TStTextMerge; const T: TStGotMergeTagEvent);
begin Self.OnGotUnknownTag := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeOnGotUnknownTag_R(Self: TStTextMerge; var T: TStGotMergeTagEvent);
begin T := Self.OnGotUnknownTag; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeOnGotMergeTag_W(Self: TStTextMerge; const T: TStGotMergeTagEvent);
begin Self.OnGotMergeTag := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeOnGotMergeTag_R(Self: TStTextMerge; var T: TStGotMergeTagEvent);
begin T := Self.OnGotMergeTag; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeTemplate_R(Self: TStTextMerge; var T: TStrings);
begin T := Self.Template; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeTagStart_W(Self: TStTextMerge; const T: AnsiString);
begin Self.TagStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeTagStart_R(Self: TStTextMerge; var T: AnsiString);
begin T := Self.TagStart; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeTagEnd_W(Self: TStTextMerge; const T: AnsiString);
begin Self.TagEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeTagEnd_R(Self: TStTextMerge; var T: AnsiString);
begin T := Self.TagEnd; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeMergeTags_R(Self: TStTextMerge; var T: TStrings);
begin T := Self.MergeTags; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeMergedText_R(Self: TStTextMerge; var T: TStrings);
begin T := Self.MergedText; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeEscapeChar_W(Self: TStTextMerge; const T: AnsiChar);
begin Self.EscapeChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeEscapeChar_R(Self: TStTextMerge; var T: AnsiChar);
begin T := Self.EscapeChar; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeDefaultTags_R(Self: TStTextMerge; var T: TStrings);
begin T := Self.DefaultTags; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeBadTag_W(Self: TStTextMerge; const T: AnsiString);
begin Self.BadTag := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextMergeBadTag_R(Self: TStTextMerge; var T: AnsiString);
begin T := Self.BadTag; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStTextMerge(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStTextMerge) do begin
    RegisterConstructor(@TStTextMerge.Create, 'Create');
    RegisterMethod(@TStTextMerge.Destroy, 'Free');
    RegisterMethod(@TStTextMerge.Merge, 'Merge');
    RegisterMethod(@TStTextMerge.LoadTemplateFromFile, 'LoadTemplateFromFile');
    RegisterMethod(@TStTextMerge.LoadTemplateFromStream, 'LoadTemplateFromStream');
    RegisterMethod(@TStTextMerge.SaveTemplateToFile, 'SaveTemplateToFile');
    RegisterMethod(@TStTextMerge.SaveTemplateToStream, 'SaveTemplateToStream');
    RegisterMethod(@TStTextMerge.SaveMergeToFile, 'SaveMergeToFile');
    RegisterMethod(@TStTextMerge.SaveMergeToStream, 'SaveMergeToStream');
    RegisterPropertyHelper(@TStTextMergeBadTag_R,@TStTextMergeBadTag_W,'BadTag');
    RegisterPropertyHelper(@TStTextMergeDefaultTags_R,nil,'DefaultTags');
    RegisterPropertyHelper(@TStTextMergeEscapeChar_R,@TStTextMergeEscapeChar_W,'EscapeChar');
    RegisterPropertyHelper(@TStTextMergeMergedText_R,nil,'MergedText');
    RegisterPropertyHelper(@TStTextMergeMergeTags_R,nil,'MergeTags');
    RegisterPropertyHelper(@TStTextMergeTagEnd_R,@TStTextMergeTagEnd_W,'TagEnd');
    RegisterPropertyHelper(@TStTextMergeTagStart_R,@TStTextMergeTagStart_W,'TagStart');
    RegisterPropertyHelper(@TStTextMergeTemplate_R,nil,'Template');
    RegisterPropertyHelper(@TStTextMergeOnGotMergeTag_R,@TStTextMergeOnGotMergeTag_W,'OnGotMergeTag');
    RegisterPropertyHelper(@TStTextMergeOnGotUnknownTag_R,@TStTextMergeOnGotUnknownTag_W,'OnGotUnknownTag');
    RegisterPropertyHelper(@TStTextMergeOnLineDone_R,@TStTextMergeOnLineDone_W,'OnLineDone');
    RegisterPropertyHelper(@TStTextMergeOnLineStart_R,@TStTextMergeOnLineStart_W,'OnLineStart');
    RegisterPropertyHelper(@TStTextMergeOnMergeDone_R,@TStTextMergeOnMergeDone_W,'OnMergeDone');
    RegisterPropertyHelper(@TStTextMergeOnMergeStart_R,@TStTextMergeOnMergeStart_W,'OnMergeStart');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StMerge(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStTextMerge(CL);
end;

 
 
{ TPSImport_StMerge }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StMerge.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StMerge(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StMerge.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StMerge(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
