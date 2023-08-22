unit uPSI_RssParser;
{
then functional without interface

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
  TPSImport_RssParser = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_RssParser(CL: TPSPascalCompiler);

{ compile-time registration functions }
procedure SIRegister_TRSSFeed(CL: TPSPascalCompiler);
//procedure SIRegister_TRSSItem(CL: TPSPascalCompiler);
procedure SIRegister_RssModel(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_RssParser_Routines(S: TPSExec);

{ run-time registration functions }
procedure RIRegister_TRSSFeed(CL: TPSRuntimeClassImporter);
//procedure RIRegister_TRSSItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_RssModel(CL: TPSRuntimeClassImporter);


procedure Register;

implementation


uses
   RssModel
  ,RssParser, contnrs
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_RssParser]);
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSFeed(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TRSSFeed') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TRSSFeed') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function AddItem : TRSSItem');
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('Description', 'string', iptrw);
    RegisterProperty('Link', 'string', iptrw);
    RegisterProperty('Items', 'TObjectList', iptr);
  end;
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_RssParser(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function ParseRSSDate( DateStr : string) : TDateTime');
 CL.AddDelphiFunction('Function ParseRSSFeed( XML : string) : TRSSFeed');
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_RssModel(CL: TPSPascalCompiler);
begin
  //SIRegister_TRSSItem(CL);
  SIRegister_TRSSFeed(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_RssParser_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ParseRSSDate, 'ParseRSSDate', cdRegister);
 S.RegisterDelphiFunction(@ParseRSSFeed, 'ParseRSSFeed', cdRegister);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TRSSFeedItems_R(Self: TRSSFeed; var T: TObjectList);
begin T := Self.Items; end;

(*----------------------------------------------------------------------------*)
procedure TRSSFeedLink_W(Self: TRSSFeed; const T: string);
begin Self.Link := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSFeedLink_R(Self: TRSSFeed; var T: string);
begin T := Self.Link; end;

(*----------------------------------------------------------------------------*)
procedure TRSSFeedDescription_W(Self: TRSSFeed; const T: string);
begin Self.Description := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSFeedDescription_R(Self: TRSSFeed; var T: string);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TRSSFeedTitle_W(Self: TRSSFeed; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSFeedTitle_R(Self: TRSSFeed; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemPubDate_W(Self: TRSSItem; const T: TDatetime);
begin Self.PubDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemPubDate_R(Self: TRSSItem; var T: TDatetime);
begin T := Self.PubDate; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemDescription_W(Self: TRSSItem; const T: string);
begin Self.Description := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemDescription_R(Self: TRSSItem; var T: string);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemLink_W(Self: TRSSItem; const T: string);
begin Self.Link := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemLink_R(Self: TRSSItem; var T: string);
begin T := Self.Link; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemTitle_W(Self: TRSSItem; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemTitle_R(Self: TRSSItem; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSFeed(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSFeed) do
  begin
    RegisterConstructor(@TRSSFeed.Create, 'Create');
    RegisterMethod(@TRSSFeed.Destroy, 'Free');
    RegisterMethod(@TRSSFeed.AddItem, 'AddItem');
    RegisterPropertyHelper(@TRSSFeedTitle_R,@TRSSFeedTitle_W,'Title');
    RegisterPropertyHelper(@TRSSFeedDescription_R,@TRSSFeedDescription_W,'Description');
    RegisterPropertyHelper(@TRSSFeedLink_R,@TRSSFeedLink_W,'Link');
    RegisterPropertyHelper(@TRSSFeedItems_R,nil,'Items');
  end;
end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_RssModel(CL: TPSRuntimeClassImporter);
begin
  //RIRegister_TRSSItem(CL);
  RIRegister_TRSSFeed(CL);
end;

 
{ TPSImport_RssParser }
(*----------------------------------------------------------------------------*)
procedure TPSImport_RssParser.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_RssParser(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_RssParser.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_RssParser_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
