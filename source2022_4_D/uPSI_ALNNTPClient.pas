unit uPSI_ALNNTPClient;
{
   with multipartmixedparser
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
  TPSImport_ALNNTPClient = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAlNNTPClient(CL: TPSPascalCompiler);
procedure SIRegister_ALNNTPClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAlNNTPClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALNNTPClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // WinSock2
  WinSock
  ,ALInternetMessageCommon
  ,ALMultiPartMixedParser
  ,ALStringList
  ,ALNNTPClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALNNTPClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAlNNTPClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAlNNTPClient') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAlNNTPClient') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');
    RegisterMethod('Function Connect( const aHost : AnsiString; const APort : integer) : AnsiString');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Function GetStatusCodeFromResponse( aResponse : AnsiString) : Integer');
    RegisterMethod('Procedure AUTHINFO( UserName, Password : AnsiString)');
    RegisterMethod('Function List : AnsiString;');
    RegisterMethod('Procedure List1( ALst : TALStrings);');
    RegisterMethod('Function ListDistributions : AnsiString;');
    RegisterMethod('Procedure ListDistributions1( ALst : TALStrings);');
    RegisterMethod('Function ListNewsGroups( wildmat : AnsiString) : AnsiString;');
    RegisterMethod('Procedure ListNewsGroups1( ALst : TALStrings; wildmat : AnsiString);');
    RegisterMethod('Function ListGroup( NewsGroup : AnsiString) : AnsiString;');
    RegisterMethod('Procedure ListGroup1( ALst : TALStrings; NewsGroup : AnsiString);');
    RegisterMethod('Function NewsGroups( FromGMTDate : TdateTime; distributions : AnsiString) : AnsiString;');
    RegisterMethod('Procedure NewsGroups1( FromGMTDate : TdateTime; distributions : AnsiString; ALst : TALStrings);');
    RegisterMethod('Function NewNews( NewsGroups : AnsiString; FromGMTDate : TdateTime; distributions : AnsiString) : AnsiString;');
    RegisterMethod('Procedure NewNews1( NewsGroups : AnsiString; FromGMTDate : TdateTime; distributions : AnsiString; ALst : TALStrings);');
    RegisterMethod('Function Group( NewsGroupName : AnsiString) : AnsiString;');
    RegisterMethod('Procedure Group1( NewsGroupName : AnsiString; var EstimatedNumberArticles, FirstArticleNumber, LastArticleNumber : Integer);');
    RegisterMethod('Function ArticleByNumber( ArticleNumber : Integer) : AnsiString;');
    RegisterMethod('Procedure ArticleByNumber1( ArticleNumber : Integer; var ArticleContent : AnsiString);');
    RegisterMethod('Procedure ArticleByNumber2( ArticleNumber : Integer; var ArticleBodyContent : AnsiString; ArticleHeaderContent : TALNewsArticleHeader);');
    RegisterMethod('Function ArticleByID( ArticleID : AnsiString) : AnsiString;');
    RegisterMethod('Procedure ArticleByID1( ArticleID : AnsiString; var ArticleContent : AnsiString);');
    RegisterMethod('Procedure ArticleByID2( ArticleID : AnsiString; var ArticleBodyContent : AnsiString; ArticleHeaderContent : TALNewsArticleHeader);');
    RegisterMethod('Function Article : AnsiString;');
    RegisterMethod('Procedure Article1( var ArticleContent : AnsiString);');
    RegisterMethod('Procedure Article2( var ArticleBodyContent : AnsiString; ArticleHeaderContent : TALNewsArticleHeader);');
    RegisterMethod('Function HeadByID( ArticleID : AnsiString) : AnsiString;');
    RegisterMethod('Procedure HeadByID1( ArticleID : AnsiString; var HeadContent : AnsiString);');
    RegisterMethod('Procedure HeadByID2( ArticleID : AnsiString; HeadContent : TALNewsArticleHeader);');
    RegisterMethod('Function HeadByNumber( ArticleNumber : Integer) : AnsiString;');
    RegisterMethod('Procedure HeadByNumber1( ArticleNumber : Integer; var HeadContent : AnsiString);');
    RegisterMethod('Procedure HeadByNumber2( ArticleNumber : Integer; HeadContent : TALNewsArticleHeader);');
    RegisterMethod('Function Head : AnsiString;');
    RegisterMethod('Procedure Head1( var HeadContent : AnsiString);');
    RegisterMethod('Procedure Head2( HeadContent : TALNewsArticleHeader);');
    RegisterMethod('Function BodyByID( ArticleID : AnsiString) : AnsiString;');
    RegisterMethod('Procedure BodyByID1( ArticleID : AnsiString; var BodyContent : AnsiString);');
    RegisterMethod('Function BodyByNumber( ArticleNumber : Integer) : AnsiString;');
    RegisterMethod('Procedure BodyByNumber1( ArticleNumber : Integer; var BodyContent : AnsiString);');
    RegisterMethod('Function Body : AnsiString;');
    RegisterMethod('Procedure Body1( var BodyContent : AnsiString);');
    RegisterMethod('Function StatByID( ArticleID : AnsiString) : AnsiString;');
    RegisterMethod('Procedure StatByID1( ArticleID : AnsiString; var ArticleNumber : integer);');
    RegisterMethod('Function StatByNumber( ArticleNumber : Integer) : AnsiString;');
    RegisterMethod('Procedure StatByNumber1( ArticleNumber : Integer; var ArticleID : AnsiString);');
    RegisterMethod('Function Stat : AnsiString;');
    RegisterMethod('Procedure Stat1( var ArticleID : AnsiString; var ArticleNumber : integer);');
    RegisterMethod('Function XHDRByID( HeaderName : AnsiString; ArticleID : AnsiString) : AnsiString;');
    RegisterMethod('Procedure XHDRByID1( HeaderName : AnsiString; ArticleID : AnsiString; var HeaderContent : AnsiString);');
    RegisterMethod('Function XHDRByNumber( HeaderName : AnsiString; ArticleNumber : integer) : AnsiString;');
    RegisterMethod('Procedure XHDRByNumber1( HeaderName : AnsiString; ArticleNumber : integer; var HeaderContent : AnsiString);');
    RegisterMethod('Function XHDR( HeaderName : AnsiString) : AnsiString;');
    RegisterMethod('Procedure XHDR1( HeaderName : AnsiString; var HeaderContent : AnsiString);');
    RegisterMethod('Function Next : Boolean;');
    RegisterMethod('Procedure Next1( var ArticleNumber : Integer; var ArticleID : AnsiString);');
    RegisterMethod('Function Last : Boolean;');
    RegisterMethod('Procedure Last1( var ArticleNumber : Integer; var ArticleID : AnsiString);');
    RegisterMethod('Function IHave( ArticleID : AnsiString; ArticleContent : AnsiString) : Boolean');
    RegisterMethod('Procedure Post( ArticleContent : AnsiString);');
    RegisterMethod('Procedure Post1( HeaderContent, BodyContent : AnsiString);');
    RegisterMethod('Procedure Post2( HeaderContent : TALNewsArticleHeader; BodyContent : AnsiString);');
    RegisterMethod('Procedure PostMultipartMixed( HeaderContent : TALNewsArticleHeader; InlineText, InlineTextContentType : AnsiString; Attachments : TALMultiPartMixedContents)');
    RegisterMethod('Function Slave : AnsiString');
    RegisterMethod('Function Quit : AnsiString');
    RegisterProperty('Connected', 'Boolean', iptr);
    RegisterProperty('SendTimeout', 'Integer', iptrw);
    RegisterProperty('ReceiveTimeout', 'Integer', iptrw);
    RegisterProperty('KeepAlive', 'Boolean', iptrw);
    RegisterProperty('TcpNoDelay', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALNNTPClient(CL: TPSPascalCompiler);
begin
  SIRegister_TAlNNTPClient(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAlNNTPClientTcpNoDelay_W(Self: TAlNNTPClient; const T: Boolean);
begin Self.TcpNoDelay := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlNNTPClientTcpNoDelay_R(Self: TAlNNTPClient; var T: Boolean);
begin T := Self.TcpNoDelay; end;

(*----------------------------------------------------------------------------*)
procedure TAlNNTPClientKeepAlive_W(Self: TAlNNTPClient; const T: Boolean);
begin Self.KeepAlive := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlNNTPClientKeepAlive_R(Self: TAlNNTPClient; var T: Boolean);
begin T := Self.KeepAlive; end;

(*----------------------------------------------------------------------------*)
procedure TAlNNTPClientReceiveTimeout_W(Self: TAlNNTPClient; const T: Integer);
begin Self.ReceiveTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlNNTPClientReceiveTimeout_R(Self: TAlNNTPClient; var T: Integer);
begin T := Self.ReceiveTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TAlNNTPClientSendTimeout_W(Self: TAlNNTPClient; const T: Integer);
begin Self.SendTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TAlNNTPClientSendTimeout_R(Self: TAlNNTPClient; var T: Integer);
begin T := Self.SendTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TAlNNTPClientConnected_R(Self: TAlNNTPClient; var T: Boolean);
begin T := Self.Connected; end;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientPost2_P(Self: TAlNNTPClient;  HeaderContent : TALNewsArticleHeader; BodyContent : AnsiString);
Begin Self.Post(HeaderContent, BodyContent); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientPost1_P(Self: TAlNNTPClient;  HeaderContent, BodyContent : AnsiString);
Begin Self.Post(HeaderContent, BodyContent); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientPost_P(Self: TAlNNTPClient;  ArticleContent : AnsiString);
Begin Self.Post(ArticleContent); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientLast1_P(Self: TAlNNTPClient;  var ArticleNumber : Integer; var ArticleID : AnsiString);
Begin Self.Last(ArticleNumber, ArticleID); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientLast_P(Self: TAlNNTPClient) : Boolean;
Begin Result := Self.Last; END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientNext1_P(Self: TAlNNTPClient;  var ArticleNumber : Integer; var ArticleID : AnsiString);
Begin Self.Next(ArticleNumber, ArticleID); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientNext_P(Self: TAlNNTPClient) : Boolean;
Begin Result := Self.Next; END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientXHDR1_P(Self: TAlNNTPClient;  HeaderName : AnsiString; var HeaderContent : AnsiString);
Begin Self.XHDR(HeaderName, HeaderContent); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientXHDR_P(Self: TAlNNTPClient;  HeaderName : AnsiString) : AnsiString;
Begin Result := Self.XHDR(HeaderName); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientXHDRByNumber1_P(Self: TAlNNTPClient;  HeaderName : AnsiString; ArticleNumber : integer; var HeaderContent : AnsiString);
Begin Self.XHDRByNumber(HeaderName, ArticleNumber, HeaderContent); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientXHDRByNumber_P(Self: TAlNNTPClient;  HeaderName : AnsiString; ArticleNumber : integer) : AnsiString;
Begin Result := Self.XHDRByNumber(HeaderName, ArticleNumber); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientXHDRByID1_P(Self: TAlNNTPClient;  HeaderName : AnsiString; ArticleID : AnsiString; var HeaderContent : AnsiString);
Begin Self.XHDRByID(HeaderName, ArticleID, HeaderContent); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientXHDRByID_P(Self: TAlNNTPClient;  HeaderName : AnsiString; ArticleID : AnsiString) : AnsiString;
Begin Result := Self.XHDRByID(HeaderName, ArticleID); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientStat1_P(Self: TAlNNTPClient;  var ArticleID : AnsiString; var ArticleNumber : integer);
Begin Self.Stat(ArticleID, ArticleNumber); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientStat_P(Self: TAlNNTPClient) : AnsiString;
Begin Result := Self.Stat; END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientStatByNumber1_P(Self: TAlNNTPClient;  ArticleNumber : Integer; var ArticleID : AnsiString);
Begin Self.StatByNumber(ArticleNumber, ArticleID); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientStatByNumber_P(Self: TAlNNTPClient;  ArticleNumber : Integer) : AnsiString;
Begin Result := Self.StatByNumber(ArticleNumber); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientStatByID1_P(Self: TAlNNTPClient;  ArticleID : AnsiString; var ArticleNumber : integer);
Begin Self.StatByID(ArticleID, ArticleNumber); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientStatByID_P(Self: TAlNNTPClient;  ArticleID : AnsiString) : AnsiString;
Begin Result := Self.StatByID(ArticleID); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientBody1_P(Self: TAlNNTPClient;  var BodyContent : AnsiString);
Begin Self.Body(BodyContent); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientBody_P(Self: TAlNNTPClient) : AnsiString;
Begin Result := Self.Body; END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientBodyByNumber1_P(Self: TAlNNTPClient;  ArticleNumber : Integer; var BodyContent : AnsiString);
Begin Self.BodyByNumber(ArticleNumber, BodyContent); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientBodyByNumber_P(Self: TAlNNTPClient;  ArticleNumber : Integer) : AnsiString;
Begin Result := Self.BodyByNumber(ArticleNumber); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientBodyByID1_P(Self: TAlNNTPClient;  ArticleID : AnsiString; var BodyContent : AnsiString);
Begin Self.BodyByID(ArticleID, BodyContent); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientBodyByID_P(Self: TAlNNTPClient;  ArticleID : AnsiString) : AnsiString;
Begin Result := Self.BodyByID(ArticleID); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientHead2_P(Self: TAlNNTPClient;  HeadContent : TALNewsArticleHeader);
Begin Self.Head(HeadContent); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientHead1_P(Self: TAlNNTPClient;  var HeadContent : AnsiString);
Begin Self.Head(HeadContent); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientHead_P(Self: TAlNNTPClient) : AnsiString;
Begin Result := Self.Head; END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientHeadByNumber2_P(Self: TAlNNTPClient;  ArticleNumber : Integer; HeadContent : TALNewsArticleHeader);
Begin Self.HeadByNumber(ArticleNumber, HeadContent); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientHeadByNumber1_P(Self: TAlNNTPClient;  ArticleNumber : Integer; var HeadContent : AnsiString);
Begin Self.HeadByNumber(ArticleNumber, HeadContent); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientHeadByNumber_P(Self: TAlNNTPClient;  ArticleNumber : Integer) : AnsiString;
Begin Result := Self.HeadByNumber(ArticleNumber); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientHeadByID2_P(Self: TAlNNTPClient;  ArticleID : AnsiString; HeadContent : TALNewsArticleHeader);
Begin Self.HeadByID(ArticleID, HeadContent); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientHeadByID1_P(Self: TAlNNTPClient;  ArticleID : AnsiString; var HeadContent : AnsiString);
Begin Self.HeadByID(ArticleID, HeadContent); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientHeadByID_P(Self: TAlNNTPClient;  ArticleID : AnsiString) : AnsiString;
Begin Result := Self.HeadByID(ArticleID); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientArticle2_P(Self: TAlNNTPClient;  var ArticleBodyContent : AnsiString; ArticleHeaderContent : TALNewsArticleHeader);
Begin Self.Article(ArticleBodyContent, ArticleHeaderContent); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientArticle1_P(Self: TAlNNTPClient;  var ArticleContent : AnsiString);
Begin Self.Article(ArticleContent); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientArticle_P(Self: TAlNNTPClient) : AnsiString;
Begin Result := Self.Article; END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientArticleByID2_P(Self: TAlNNTPClient;  ArticleID : AnsiString; var ArticleBodyContent : AnsiString; ArticleHeaderContent : TALNewsArticleHeader);
Begin Self.ArticleByID(ArticleID, ArticleBodyContent, ArticleHeaderContent); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientArticleByID1_P(Self: TAlNNTPClient;  ArticleID : AnsiString; var ArticleContent : AnsiString);
Begin Self.ArticleByID(ArticleID, ArticleContent); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientArticleByID_P(Self: TAlNNTPClient;  ArticleID : AnsiString) : AnsiString;
Begin Result := Self.ArticleByID(ArticleID); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientArticleByNumber2_P(Self: TAlNNTPClient;  ArticleNumber : Integer; var ArticleBodyContent : AnsiString; ArticleHeaderContent : TALNewsArticleHeader);
Begin Self.ArticleByNumber(ArticleNumber, ArticleBodyContent, ArticleHeaderContent); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientArticleByNumber1_P(Self: TAlNNTPClient;  ArticleNumber : Integer; var ArticleContent : AnsiString);
Begin Self.ArticleByNumber(ArticleNumber, ArticleContent); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientArticleByNumber_P(Self: TAlNNTPClient;  ArticleNumber : Integer) : AnsiString;
Begin Result := Self.ArticleByNumber(ArticleNumber); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientGroup1_P(Self: TAlNNTPClient;  NewsGroupName : AnsiString; var EstimatedNumberArticles, FirstArticleNumber, LastArticleNumber : Integer);
Begin Self.Group(NewsGroupName, EstimatedNumberArticles, FirstArticleNumber, LastArticleNumber); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientGroup_P(Self: TAlNNTPClient;  NewsGroupName : AnsiString) : AnsiString;
Begin Result := Self.Group(NewsGroupName); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientNewNews1_P(Self: TAlNNTPClient;  NewsGroups : AnsiString; FromGMTDate : TdateTime; distributions : AnsiString; ALst : TALStrings);
Begin Self.NewNews(NewsGroups, FromGMTDate, distributions, ALst); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientNewNews_P(Self: TAlNNTPClient;  NewsGroups : AnsiString; FromGMTDate : TdateTime; distributions : AnsiString) : AnsiString;
Begin Result := Self.NewNews(NewsGroups, FromGMTDate, distributions); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientNewsGroups1_P(Self: TAlNNTPClient;  FromGMTDate : TdateTime; distributions : AnsiString; ALst : TALStrings);
Begin Self.NewsGroups(FromGMTDate, distributions, ALst); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientNewsGroups_P(Self: TAlNNTPClient;  FromGMTDate : TdateTime; distributions : AnsiString) : AnsiString;
Begin Result := Self.NewsGroups(FromGMTDate, distributions); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientListGroup1_P(Self: TAlNNTPClient;  ALst : TALStrings; NewsGroup : AnsiString);
Begin Self.ListGroup(ALst, NewsGroup); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientListGroup_P(Self: TAlNNTPClient;  NewsGroup : AnsiString) : AnsiString;
Begin Result := Self.ListGroup(NewsGroup); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientListNewsGroups1_P(Self: TAlNNTPClient;  ALst : TALStrings; wildmat : AnsiString);
Begin Self.ListNewsGroups(ALst, wildmat); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientListNewsGroups_P(Self: TAlNNTPClient;  wildmat : AnsiString) : AnsiString;
Begin Result := Self.ListNewsGroups(wildmat); END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientListDistributions1_P(Self: TAlNNTPClient;  ALst : TALStrings);
Begin Self.ListDistributions(ALst); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientListDistributions_P(Self: TAlNNTPClient) : AnsiString;
Begin Result := Self.ListDistributions; END;

(*----------------------------------------------------------------------------*)
Procedure TAlNNTPClientList1_P(Self: TAlNNTPClient;  ALst : TALStrings);
Begin Self.List(ALst); END;

(*----------------------------------------------------------------------------*)
Function TAlNNTPClientList_P(Self: TAlNNTPClient) : AnsiString;
Begin Result := Self.List; END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAlNNTPClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAlNNTPClient) do begin
    RegisterVirtualConstructor(@TAlNNTPClient.Create, 'Create');
       RegisterMethod(@TALNNTPClient.Destroy, 'Free');
      RegisterVirtualMethod(@TAlNNTPClient.Connect, 'Connect');
    RegisterVirtualMethod(@TAlNNTPClient.Disconnect, 'Disconnect');
    RegisterMethod(@TAlNNTPClient.GetStatusCodeFromResponse, 'GetStatusCodeFromResponse');
    RegisterVirtualMethod(@TAlNNTPClient.AUTHINFO, 'AUTHINFO');
    RegisterVirtualMethod(@TAlNNTPClientList_P, 'List');
    RegisterVirtualMethod(@TAlNNTPClientList1_P, 'List1');
    RegisterVirtualMethod(@TAlNNTPClientListDistributions_P, 'ListDistributions');
    RegisterVirtualMethod(@TAlNNTPClientListDistributions1_P, 'ListDistributions1');
    RegisterVirtualMethod(@TAlNNTPClientListNewsGroups_P, 'ListNewsGroups');
    RegisterVirtualMethod(@TAlNNTPClientListNewsGroups1_P, 'ListNewsGroups1');
    RegisterVirtualMethod(@TAlNNTPClientListGroup_P, 'ListGroup');
    RegisterVirtualMethod(@TAlNNTPClientListGroup1_P, 'ListGroup1');
    RegisterVirtualMethod(@TAlNNTPClientNewsGroups_P, 'NewsGroups');
    RegisterVirtualMethod(@TAlNNTPClientNewsGroups1_P, 'NewsGroups1');
    RegisterVirtualMethod(@TAlNNTPClientNewNews_P, 'NewNews');
    RegisterVirtualMethod(@TAlNNTPClientNewNews1_P, 'NewNews1');
    RegisterVirtualMethod(@TAlNNTPClientGroup_P, 'Group');
    RegisterVirtualMethod(@TAlNNTPClientGroup1_P, 'Group1');
    RegisterVirtualMethod(@TAlNNTPClientArticleByNumber_P, 'ArticleByNumber');
    RegisterVirtualMethod(@TAlNNTPClientArticleByNumber1_P, 'ArticleByNumber1');
    RegisterVirtualMethod(@TAlNNTPClientArticleByNumber2_P, 'ArticleByNumber2');
    RegisterVirtualMethod(@TAlNNTPClientArticleByID_P, 'ArticleByID');
    RegisterVirtualMethod(@TAlNNTPClientArticleByID1_P, 'ArticleByID1');
    RegisterVirtualMethod(@TAlNNTPClientArticleByID2_P, 'ArticleByID2');
    RegisterVirtualMethod(@TAlNNTPClientArticle_P, 'Article');
    RegisterVirtualMethod(@TAlNNTPClientArticle1_P, 'Article1');
    RegisterVirtualMethod(@TAlNNTPClientArticle2_P, 'Article2');
    RegisterVirtualMethod(@TAlNNTPClientHeadByID_P, 'HeadByID');
    RegisterVirtualMethod(@TAlNNTPClientHeadByID1_P, 'HeadByID1');
    RegisterVirtualMethod(@TAlNNTPClientHeadByID2_P, 'HeadByID2');
    RegisterVirtualMethod(@TAlNNTPClientHeadByNumber_P, 'HeadByNumber');
    RegisterVirtualMethod(@TAlNNTPClientHeadByNumber1_P, 'HeadByNumber1');
    RegisterVirtualMethod(@TAlNNTPClientHeadByNumber2_P, 'HeadByNumber2');
    RegisterVirtualMethod(@TAlNNTPClientHead_P, 'Head');
    RegisterVirtualMethod(@TAlNNTPClientHead1_P, 'Head1');
    RegisterVirtualMethod(@TAlNNTPClientHead2_P, 'Head2');
    RegisterVirtualMethod(@TAlNNTPClientBodyByID_P, 'BodyByID');
    RegisterVirtualMethod(@TAlNNTPClientBodyByID1_P, 'BodyByID1');
    RegisterVirtualMethod(@TAlNNTPClientBodyByNumber_P, 'BodyByNumber');
    RegisterVirtualMethod(@TAlNNTPClientBodyByNumber1_P, 'BodyByNumber1');
    RegisterVirtualMethod(@TAlNNTPClientBody_P, 'Body');
    RegisterVirtualMethod(@TAlNNTPClientBody1_P, 'Body1');
    RegisterVirtualMethod(@TAlNNTPClientStatByID_P, 'StatByID');
    RegisterVirtualMethod(@TAlNNTPClientStatByID1_P, 'StatByID1');
    RegisterVirtualMethod(@TAlNNTPClientStatByNumber_P, 'StatByNumber');
    RegisterVirtualMethod(@TAlNNTPClientStatByNumber1_P, 'StatByNumber1');
    RegisterVirtualMethod(@TAlNNTPClientStat_P, 'Stat');
    RegisterVirtualMethod(@TAlNNTPClientStat1_P, 'Stat1');
    RegisterVirtualMethod(@TAlNNTPClientXHDRByID_P, 'XHDRByID');
    RegisterVirtualMethod(@TAlNNTPClientXHDRByID1_P, 'XHDRByID1');
    RegisterVirtualMethod(@TAlNNTPClientXHDRByNumber_P, 'XHDRByNumber');
    RegisterVirtualMethod(@TAlNNTPClientXHDRByNumber1_P, 'XHDRByNumber1');
    RegisterVirtualMethod(@TAlNNTPClientXHDR_P, 'XHDR');
    RegisterVirtualMethod(@TAlNNTPClientXHDR1_P, 'XHDR1');
    RegisterVirtualMethod(@TAlNNTPClientNext_P, 'Next');
    RegisterVirtualMethod(@TAlNNTPClientNext1_P, 'Next1');
    RegisterVirtualMethod(@TAlNNTPClientLast_P, 'Last');
    RegisterVirtualMethod(@TAlNNTPClientLast1_P, 'Last1');
    RegisterVirtualMethod(@TAlNNTPClient.IHave, 'IHave');
    RegisterVirtualMethod(@TAlNNTPClientPost_P, 'Post');
    RegisterVirtualMethod(@TAlNNTPClientPost1_P, 'Post1');
    RegisterVirtualMethod(@TAlNNTPClientPost2_P, 'Post2');
    RegisterVirtualMethod(@TAlNNTPClient.PostMultipartMixed, 'PostMultipartMixed');
    RegisterVirtualMethod(@TAlNNTPClient.Slave, 'Slave');
    RegisterVirtualMethod(@TAlNNTPClient.Quit, 'Quit');
    RegisterPropertyHelper(@TAlNNTPClientConnected_R,nil,'Connected');
    RegisterPropertyHelper(@TAlNNTPClientSendTimeout_R,@TAlNNTPClientSendTimeout_W,'SendTimeout');
    RegisterPropertyHelper(@TAlNNTPClientReceiveTimeout_R,@TAlNNTPClientReceiveTimeout_W,'ReceiveTimeout');
    RegisterPropertyHelper(@TAlNNTPClientKeepAlive_R,@TAlNNTPClientKeepAlive_W,'KeepAlive');
    RegisterPropertyHelper(@TAlNNTPClientTcpNoDelay_R,@TAlNNTPClientTcpNoDelay_W,'TcpNoDelay');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALNNTPClient(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAlNNTPClient(CL);
end;

 
 
{ TPSImport_ALNNTPClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALNNTPClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALNNTPClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALNNTPClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALNNTPClient(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
