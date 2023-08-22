unit uPSI_SimpleRSSTypes;
{
maxbox rss feed for sentiment analysis alerter

retype type system
  CL.AddTypeS('TXMLTypeRSS', '( xtRDFrss, xtRSSrss, xtAtomrss, xtiTunesrss )');
  CL.AddTypeS('TContentTypeRSS', '( ctText, ctHTML, ctXHTML )');
  CL.AddTypeS('TEncodingTypeRSS', '( etBase64rss, etEscapedrss, etXMLrss )');


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
  TPSImport_SimpleRSSTypes = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRSSItems(CL: TPSPascalCompiler);
procedure SIRegister_TRSSItem(CL: TPSPascalCompiler);
procedure SIRegister_TRSSAuthor(CL: TPSPascalCompiler);
procedure SIRegister_TRSSItemGUID(CL: TPSPascalCompiler);
procedure SIRegister_TRSSItemCategories(CL: TPSPascalCompiler);
procedure SIRegister_TRSSItemCategory(CL: TPSPascalCompiler);
procedure SIRegister_TRSSItemEnclosure(CL: TPSPascalCompiler);
procedure SIRegister_TRSSItemSource(CL: TPSPascalCompiler);
procedure SIRegister_TRSSChannel(CL: TPSPascalCompiler);
procedure SIRegister_TRSSChannelOpt(CL: TPSPascalCompiler);
procedure SIRegister_TRSSChannelSkipDays(CL: TPSPascalCompiler);
procedure SIRegister_TRSSChannelSkipHours(CL: TPSPascalCompiler);
procedure SIRegister_TRSSChannelCategories(CL: TPSPascalCompiler);
procedure SIRegister_TRSSChannelCategory(CL: TPSPascalCompiler);
procedure SIRegister_TRSSTextInput(CL: TPSPascalCompiler);
procedure SIRegister_TRSSCloud(CL: TPSPascalCompiler);
procedure SIRegister_TRSSImage(CL: TPSPascalCompiler);
procedure SIRegister_TRSSImageOpt(CL: TPSPascalCompiler);
procedure SIRegister_TRSSImageReq(CL: TPSPascalCompiler);
procedure SIRegister_TRSSChannelReq(CL: TPSPascalCompiler);
procedure SIRegister_TRFC822DateTime(CL: TPSPascalCompiler);
procedure SIRegister_SimpleRSSTypes(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TRSSItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSAuthor(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSItemGUID(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSItemCategories(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSItemCategory(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSItemEnclosure(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSItemSource(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSChannel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSChannelOpt(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSChannelSkipDays(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSChannelSkipHours(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSChannelCategories(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSChannelCategory(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSTextInput(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSCloud(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSImage(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSImageOpt(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSImageReq(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRSSChannelReq(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRFC822DateTime(CL: TPSRuntimeClassImporter);
procedure RIRegister_SimpleRSSTypes(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   iTunesTypes
  ,SimpleRSSTypes
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SimpleRSSTypes]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TRSSItems') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TRSSItems') do begin
    RegisterMethod('Function Add : TRSSItem');
    RegisterMethod('Function Insert( Index : Integer) : TRSSItem');
    RegisterProperty('Items', 'TRSSItem Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TRSSItem') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TRSSItem') do begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Function CommentsChanged : Boolean');
    RegisterMethod('Function AuthorChanged : Boolean');
    RegisterMethod('Function TitleChanged : Boolean');
    RegisterMethod('Function LinkChanged : Boolean');
    RegisterMethod('Function DescriptionChanged : Boolean');
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('Link', 'string', iptrw);
    RegisterProperty('Description', 'string', iptrw);
    RegisterProperty('Author', 'TRSSAuthor', iptrw);
    RegisterProperty('Categories', 'TRSSItemCategories', iptrw);
    RegisterProperty('Comments', 'string', iptrw);
    RegisterProperty('Enclosure', 'TRSSItemEnclosure', iptrw);
    RegisterProperty('GUID', 'TRSSITemGUID', iptrw);
    RegisterProperty('PubDate', 'TRFC822DateTime', iptrw);
    RegisterProperty('Source', 'TRSSItemSource', iptrw);
    RegisterProperty('ContentType', 'TContentTypeRSS', iptrw);
    RegisterProperty('iTunes', 'TiTunesItemExtra', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSAuthor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TRSSAuthor') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TRSSAuthor') do
  begin
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('EMail', 'string', iptrw);
    RegisterProperty('URL', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSItemGUID(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TRSSItemGUID') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TRSSItemGUID') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('GUID', 'string', iptrw);
    RegisterProperty('IsPermaLink', 'Boolean', iptrw);
    RegisterProperty('Include', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSItemCategories(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TRSSItemCategories') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TRSSItemCategories') do
  begin
    RegisterMethod('Function Add : TRSSItemCategory');
    RegisterMethod('Function Insert( Index : Integer) : TRSSItemCategory');
    RegisterProperty('Items', 'TRSSItemCategory Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSItemCategory(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TRSSItemCategory') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TRSSItemCategory') do
  begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Function DomainChanged : Boolean');
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('Domain', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSItemEnclosure(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TRSSItemEnclosure') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TRSSItemEnclosure') do
  begin
    RegisterProperty('URL', 'string', iptrw);
    RegisterProperty('Length', 'Integer', iptrw);
    RegisterProperty('EnclosureType', 'string', iptrw);
    RegisterProperty('Include', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSItemSource(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TRSSItemSource') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TRSSItemSource') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('URL', 'string', iptrw);
    RegisterProperty('Include', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSChannel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TRSSChannel') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TRSSChannel') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('Required', 'TRSSChannelReq', iptrw);
    RegisterProperty('Optional', 'TRSSChannelOpt', iptrw);
    RegisterProperty('iTunes', 'TiTunesChannelExtra', iptrw);
    RegisterProperty('AboutURL', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSChannelOpt(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TRSSChannelOpt') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TRSSChannelOpt') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function CopyrightChanged : Boolean');
    RegisterMethod('Function ManagingEditorChanged : Boolean');
    RegisterMethod('Function WebMasterChanged : Boolean');
    RegisterMethod('Function GeneratorChanged : Boolean');
    RegisterMethod('Function TTLChanged : Boolean');
    RegisterMethod('Function RatingChanged : Boolean');
    RegisterProperty('Language', 'TLanguages', iptrw);
    RegisterProperty('XLang', 'string', iptrw);
    RegisterProperty('Copyright', 'string', iptrw);
    RegisterProperty('ManagingEditor', 'string', iptrw);
    RegisterProperty('WebMaster', 'string', iptrw);
    RegisterProperty('PubDate', 'TRFC822DateTime', iptrw);
    RegisterProperty('LastBuildDate', 'TRFC822DateTime', iptrw);
    RegisterProperty('Categories', 'TRSSChannelCategories', iptrw);
    RegisterProperty('Generator', 'string', iptrw);
    RegisterProperty('Docs', 'string', iptrw);
    RegisterProperty('Cloud', 'TRSSCloud', iptrw);
    RegisterProperty('TTL', 'Integer', iptrw);
    RegisterProperty('Image', 'TRSSImage', iptrw);
    RegisterProperty('Rating', 'string', iptrw);
    RegisterProperty('TextInput', 'TRSSTextInput', iptrw);
    RegisterProperty('SkipHours', 'TRSSChannelSkipHours', iptrw);
    RegisterProperty('SkipDays', 'TRSSChannelSkipDays', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSChannelSkipDays(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TRSSChannelSkipDays') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TRSSChannelSkipDays') do
  begin
    RegisterProperty('Monday', 'Boolean', iptrw);
    RegisterProperty('Tuesday', 'Boolean', iptrw);
    RegisterProperty('Wednesday', 'Boolean', iptrw);
    RegisterProperty('Thursday', 'Boolean', iptrw);
    RegisterProperty('Friday', 'Boolean', iptrw);
    RegisterProperty('Saturday', 'Boolean', iptrw);
    RegisterProperty('Sunday', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSChannelSkipHours(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TRSSChannelSkipHours') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TRSSChannelSkipHours') do
  begin
    RegisterProperty('h01', 'Boolean', iptrw);
    RegisterProperty('h02', 'Boolean', iptrw);
    RegisterProperty('h03', 'Boolean', iptrw);
    RegisterProperty('h04', 'Boolean', iptrw);
    RegisterProperty('h05', 'Boolean', iptrw);
    RegisterProperty('h06', 'Boolean', iptrw);
    RegisterProperty('h07', 'Boolean', iptrw);
    RegisterProperty('h08', 'Boolean', iptrw);
    RegisterProperty('h09', 'Boolean', iptrw);
    RegisterProperty('h10', 'Boolean', iptrw);
    RegisterProperty('h11', 'Boolean', iptrw);
    RegisterProperty('h12', 'Boolean', iptrw);
    RegisterProperty('h13', 'Boolean', iptrw);
    RegisterProperty('h14', 'Boolean', iptrw);
    RegisterProperty('h15', 'Boolean', iptrw);
    RegisterProperty('h16', 'Boolean', iptrw);
    RegisterProperty('h17', 'Boolean', iptrw);
    RegisterProperty('h18', 'Boolean', iptrw);
    RegisterProperty('h19', 'Boolean', iptrw);
    RegisterProperty('h20', 'Boolean', iptrw);
    RegisterProperty('h21', 'Boolean', iptrw);
    RegisterProperty('h22', 'Boolean', iptrw);
    RegisterProperty('h23', 'Boolean', iptrw);
    RegisterProperty('h00', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSChannelCategories(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TRSSChannelCategories') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TRSSChannelCategories') do
  begin
    RegisterMethod('Function Add : TRSSChannelCategory');
    RegisterMethod('Function Insert( Index : Integer) : TRSSChannelCategory');
    RegisterProperty('Items', 'TRSSChannelCategory Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSChannelCategory(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TRSSChannelCategory') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TRSSChannelCategory') do
  begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Function DomainChanged : Boolean');
    RegisterProperty('Category', 'string', iptrw);
    RegisterProperty('Domain', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSTextInput(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TRSSTextInput') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TRSSTextInput') do
  begin
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('Description', 'string', iptrw);
    RegisterProperty('TextInputName', 'string', iptrw);
    RegisterProperty('Link', 'string', iptrw);
    RegisterProperty('Include', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSCloud(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TRSSCloud') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TRSSCloud') do
  begin
    RegisterProperty('Domain', 'string', iptrw);
    RegisterProperty('Port', 'Integer', iptrw);
    RegisterProperty('Path', 'string', iptrw);
    RegisterProperty('RegisterProcedure', 'string', iptrw);
    RegisterProperty('Protocol', 'string', iptrw);
    RegisterProperty('Include', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSImage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TRSSImage') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TRSSImage') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('Include', 'Boolean', iptrw);
    RegisterProperty('Required', 'TRSSImageReq', iptrw);
    RegisterProperty('Optional', 'TRSSImageOpt', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSImageOpt(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TRSSImageOpt') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TRSSImageOpt') do
  begin
    RegisterMethod('Function DescriptionChanged : Boolean');
    RegisterMethod('Function HeightChanged : Boolean');
    RegisterMethod('Function WidthChanged : Boolean');
    RegisterMethod('Constructor Create');
    RegisterProperty('Width', 'Integer', iptrw);
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('Description', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSImageReq(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TRSSImageReq') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TRSSImageReq') do
  begin
    RegisterProperty('URL', 'string', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('Link', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRSSChannelReq(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TRSSChannelReq') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TRSSChannelReq') do
  begin
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('Link', 'string', iptrw);
    RegisterProperty('Desc', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRFC822DateTime(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TRFC822DateTime') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TRFC822DateTime') do
  begin
    RegisterMethod('Function GetDateTime : string');
    RegisterMethod('Procedure LoadDateTime( S : string)');
    RegisterMethod('Procedure LoadDCDateTime( S : string)');
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Changed : Boolean');
    RegisterMethod('Function LastSpace( S : string) : Integer');
    RegisterProperty('DateTime', 'TDateTime', iptrw);
    RegisterProperty('TimeZone', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SimpleRSSTypes(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'ESimpleRSSException');
  CL.AddTypeS('TLanguagesRSS', '( langAF, langSQ, langEU, langBE, langBG, langCA, '
   +'langZH_CN, langZH_TW, langHR, langCS, langDA, langNL, langNL_BE, langNL_NL'
   +', langEN, langEN_AU, langEN_BZ, langEN_CA, langEN_IE, langEN_JM, langEN_NZ'
   +', langEN_PH, langEN_ZA, langEN_TT, langEN_GB, langEN_US, langEN_ZW, langET'
   +', langFO, langFI, langFR, langFR_BE, langFR_CA, langFR_FR, langFR_LU, lang'
   +'FR_MC, langFR_CH, langGL, langGD, langDE, langDE_AT, langDE_DE, langDE_LI,'
   +' langDE_LU, langDE_CH, langEL, langHAW, langHU, langIS, langIN, langGA, la'
   +'ngIT, langIT_IT, langIT_CH, langJA, langKO, langMK, langNO, langPL, langPT'
   +', langPT_BR, langPT_PT, langRO, langRO_MO, langRO_RP, langRU, langRU_MO, l'
   +'angRU_RU, langSR, langSK, langSL, langES, langES_AR, langES_BO, langES_CL,'
   +' langES_CO, langES_CR, langES_DO, langES_EC, langES_SV, langES_GT, langES_'
   +'HN, langES_MX, langES_NI, langES_PA, langES_PY, langES_PE, langES_PR, lang'
   +'ES_ES, langES_UY, langES_VE, langSV, langSV_FI, langSV_SE, langTR, langUK,langX )');
  CL.AddTypeS('TXMLTypeRSS', '( xtRDFrss, xtRSSrss, xtAtomrss, xtiTunesrss )');
  CL.AddTypeS('TContentTypeRSS', '( ctTextrss, ctHTMLrss, ctXHTMLrss )');
  CL.AddTypeS('TEncodingTypeRSS', '( etBase64rss, etEscapedrss, etXMLrss )');
  SIRegister_TRFC822DateTime(CL);
  SIRegister_TRSSChannelReq(CL);
  SIRegister_TRSSImageReq(CL);
  SIRegister_TRSSImageOpt(CL);
  SIRegister_TRSSImage(CL);
  SIRegister_TRSSCloud(CL);
  SIRegister_TRSSTextInput(CL);
  SIRegister_TRSSChannelCategory(CL);
  SIRegister_TRSSChannelCategories(CL);
  SIRegister_TRSSChannelSkipHours(CL);
  SIRegister_TRSSChannelSkipDays(CL);
  SIRegister_TRSSChannelOpt(CL);
  SIRegister_TRSSChannel(CL);
  SIRegister_TRSSItemSource(CL);
  SIRegister_TRSSItemEnclosure(CL);
  SIRegister_TRSSItemCategory(CL);
  SIRegister_TRSSItemCategories(CL);
  SIRegister_TRSSItemGUID(CL);
  SIRegister_TRSSAuthor(CL);
  SIRegister_TRSSItem(CL);
  SIRegister_TRSSItems(CL);
  CL.AddTypeS('TFormatSettingsRSS', 'record ShortDateFormat : string; LongDateForm'
   +'at : string; LongTimeFormat : string; ShortTimeFormat : string; end');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TRSSItemsItems_W(Self: TRSSItems; const T: TRSSItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemsItems_R(Self: TRSSItems; var T: TRSSItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemiTunes_W(Self: TRSSItem; const T: TiTunesItemExtra);
begin Self.iTunes := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemiTunes_R(Self: TRSSItem; var T: TiTunesItemExtra);
begin T := Self.iTunes; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemContentType_W(Self: TRSSItem; const T: TContentTypeRSS);
begin Self.ContentType := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemContentType_R(Self: TRSSItem; var T: TContentTypeRSS);
begin T := Self.ContentType; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemSource_W(Self: TRSSItem; const T: TRSSItemSource);
begin Self.Source := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemSource_R(Self: TRSSItem; var T: TRSSItemSource);
begin T := Self.Source; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemPubDate_W(Self: TRSSItem; const T: TRFC822DateTime);
begin Self.PubDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemPubDate_R(Self: TRSSItem; var T: TRFC822DateTime);
begin T := Self.PubDate; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemGUID_W(Self: TRSSItem; const T: TRSSITemGUID);
begin Self.GUID := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemGUID_R(Self: TRSSItem; var T: TRSSITemGUID);
begin T := Self.GUID; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemEnclosure_W(Self: TRSSItem; const T: TRSSItemEnclosure);
begin Self.Enclosure := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemEnclosure_R(Self: TRSSItem; var T: TRSSItemEnclosure);
begin T := Self.Enclosure; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemComments_W(Self: TRSSItem; const T: string);
begin Self.Comments := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemComments_R(Self: TRSSItem; var T: string);
begin T := Self.Comments; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemCategories_W(Self: TRSSItem; const T: TRSSItemCategories);
begin Self.Categories := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemCategories_R(Self: TRSSItem; var T: TRSSItemCategories);
begin T := Self.Categories; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemAuthor_W(Self: TRSSItem; const T: TRSSAuthor);
begin Self.Author := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemAuthor_R(Self: TRSSItem; var T: TRSSAuthor);
begin T := Self.Author; end;

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
procedure TRSSAuthorURL_W(Self: TRSSAuthor; const T: string);
begin Self.URL := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSAuthorURL_R(Self: TRSSAuthor; var T: string);
begin T := Self.URL; end;

(*----------------------------------------------------------------------------*)
procedure TRSSAuthorEMail_W(Self: TRSSAuthor; const T: string);
begin Self.EMail := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSAuthorEMail_R(Self: TRSSAuthor; var T: string);
begin T := Self.EMail; end;

(*----------------------------------------------------------------------------*)
procedure TRSSAuthorName_W(Self: TRSSAuthor; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSAuthorName_R(Self: TRSSAuthor; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemGUIDInclude_W(Self: TRSSItemGUID; const T: Boolean);
begin Self.Include := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemGUIDInclude_R(Self: TRSSItemGUID; var T: Boolean);
begin T := Self.Include; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemGUIDIsPermaLink_W(Self: TRSSItemGUID; const T: Boolean);
begin Self.IsPermaLink := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemGUIDIsPermaLink_R(Self: TRSSItemGUID; var T: Boolean);
begin T := Self.IsPermaLink; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemGUIDGUID_W(Self: TRSSItemGUID; const T: string);
begin Self.GUID := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemGUIDGUID_R(Self: TRSSItemGUID; var T: string);
begin T := Self.GUID; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemCategoriesItems_W(Self: TRSSItemCategories; const T: TRSSItemCategory; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemCategoriesItems_R(Self: TRSSItemCategories; var T: TRSSItemCategory; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemCategoryDomain_W(Self: TRSSItemCategory; const T: string);
begin Self.Domain := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemCategoryDomain_R(Self: TRSSItemCategory; var T: string);
begin T := Self.Domain; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemCategoryTitle_W(Self: TRSSItemCategory; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemCategoryTitle_R(Self: TRSSItemCategory; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemEnclosureInclude_W(Self: TRSSItemEnclosure; const T: Boolean);
begin Self.Include := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemEnclosureInclude_R(Self: TRSSItemEnclosure; var T: Boolean);
begin T := Self.Include; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemEnclosureEnclosureType_W(Self: TRSSItemEnclosure; const T: string);
begin Self.EnclosureType := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemEnclosureEnclosureType_R(Self: TRSSItemEnclosure; var T: string);
begin T := Self.EnclosureType; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemEnclosureLength_W(Self: TRSSItemEnclosure; const T: Integer);
begin Self.Length := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemEnclosureLength_R(Self: TRSSItemEnclosure; var T: Integer);
begin T := Self.Length; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemEnclosureURL_W(Self: TRSSItemEnclosure; const T: string);
begin Self.URL := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemEnclosureURL_R(Self: TRSSItemEnclosure; var T: string);
begin T := Self.URL; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemSourceInclude_W(Self: TRSSItemSource; const T: Boolean);
begin Self.Include := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemSourceInclude_R(Self: TRSSItemSource; var T: Boolean);
begin T := Self.Include; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemSourceURL_W(Self: TRSSItemSource; const T: string);
begin Self.URL := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemSourceURL_R(Self: TRSSItemSource; var T: string);
begin T := Self.URL; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemSourceTitle_W(Self: TRSSItemSource; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSItemSourceTitle_R(Self: TRSSItemSource; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelAboutURL_W(Self: TRSSChannel; const T: String);
begin Self.AboutURL := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelAboutURL_R(Self: TRSSChannel; var T: String);
begin T := Self.AboutURL; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChanneliTunes_W(Self: TRSSChannel; const T: TiTunesChannelExtra);
begin Self.iTunes := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChanneliTunes_R(Self: TRSSChannel; var T: TiTunesChannelExtra);
begin T := Self.iTunes; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptional_W(Self: TRSSChannel; const T: TRSSChannelOpt);
begin Self.Optional := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptional_R(Self: TRSSChannel; var T: TRSSChannelOpt);
begin T := Self.Optional; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelRequired_W(Self: TRSSChannel; const T: TRSSChannelReq);
begin Self.Required := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelRequired_R(Self: TRSSChannel; var T: TRSSChannelReq);
begin T := Self.Required; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptSkipDays_W(Self: TRSSChannelOpt; const T: TRSSChannelSkipDays);
begin Self.SkipDays := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptSkipDays_R(Self: TRSSChannelOpt; var T: TRSSChannelSkipDays);
begin T := Self.SkipDays; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptSkipHours_W(Self: TRSSChannelOpt; const T: TRSSChannelSkipHours);
begin Self.SkipHours := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptSkipHours_R(Self: TRSSChannelOpt; var T: TRSSChannelSkipHours);
begin T := Self.SkipHours; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptTextInput_W(Self: TRSSChannelOpt; const T: TRSSTextInput);
begin Self.TextInput := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptTextInput_R(Self: TRSSChannelOpt; var T: TRSSTextInput);
begin T := Self.TextInput; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptRating_W(Self: TRSSChannelOpt; const T: string);
begin Self.Rating := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptRating_R(Self: TRSSChannelOpt; var T: string);
begin T := Self.Rating; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptImage_W(Self: TRSSChannelOpt; const T: TRSSImage);
begin Self.Image := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptImage_R(Self: TRSSChannelOpt; var T: TRSSImage);
begin T := Self.Image; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptTTL_W(Self: TRSSChannelOpt; const T: Integer);
begin Self.TTL := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptTTL_R(Self: TRSSChannelOpt; var T: Integer);
begin T := Self.TTL; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptCloud_W(Self: TRSSChannelOpt; const T: TRSSCloud);
begin Self.Cloud := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptCloud_R(Self: TRSSChannelOpt; var T: TRSSCloud);
begin T := Self.Cloud; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptDocs_W(Self: TRSSChannelOpt; const T: string);
begin Self.Docs := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptDocs_R(Self: TRSSChannelOpt; var T: string);
begin T := Self.Docs; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptGenerator_W(Self: TRSSChannelOpt; const T: string);
begin Self.Generator := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptGenerator_R(Self: TRSSChannelOpt; var T: string);
begin T := Self.Generator; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptCategories_W(Self: TRSSChannelOpt; const T: TRSSChannelCategories);
begin Self.Categories := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptCategories_R(Self: TRSSChannelOpt; var T: TRSSChannelCategories);
begin T := Self.Categories; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptLastBuildDate_W(Self: TRSSChannelOpt; const T: TRFC822DateTime);
begin Self.LastBuildDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptLastBuildDate_R(Self: TRSSChannelOpt; var T: TRFC822DateTime);
begin T := Self.LastBuildDate; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptPubDate_W(Self: TRSSChannelOpt; const T: TRFC822DateTime);
begin Self.PubDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptPubDate_R(Self: TRSSChannelOpt; var T: TRFC822DateTime);
begin T := Self.PubDate; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptWebMaster_W(Self: TRSSChannelOpt; const T: string);
begin Self.WebMaster := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptWebMaster_R(Self: TRSSChannelOpt; var T: string);
begin T := Self.WebMaster; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptManagingEditor_W(Self: TRSSChannelOpt; const T: string);
begin Self.ManagingEditor := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptManagingEditor_R(Self: TRSSChannelOpt; var T: string);
begin T := Self.ManagingEditor; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptCopyright_W(Self: TRSSChannelOpt; const T: string);
begin Self.Copyright := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptCopyright_R(Self: TRSSChannelOpt; var T: string);
begin T := Self.Copyright; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptXLang_W(Self: TRSSChannelOpt; const T: string);
begin Self.XLang := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptXLang_R(Self: TRSSChannelOpt; var T: string);
begin T := Self.XLang; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptLanguage_W(Self: TRSSChannelOpt; const T: TLanguages);
begin Self.Language := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelOptLanguage_R(Self: TRSSChannelOpt; var T: TLanguages);
begin T := Self.Language; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipDaysSunday_W(Self: TRSSChannelSkipDays; const T: Boolean);
begin Self.Sunday := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipDaysSunday_R(Self: TRSSChannelSkipDays; var T: Boolean);
begin T := Self.Sunday; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipDaysSaturday_W(Self: TRSSChannelSkipDays; const T: Boolean);
begin Self.Saturday := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipDaysSaturday_R(Self: TRSSChannelSkipDays; var T: Boolean);
begin T := Self.Saturday; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipDaysFriday_W(Self: TRSSChannelSkipDays; const T: Boolean);
begin Self.Friday := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipDaysFriday_R(Self: TRSSChannelSkipDays; var T: Boolean);
begin T := Self.Friday; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipDaysThursday_W(Self: TRSSChannelSkipDays; const T: Boolean);
begin Self.Thursday := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipDaysThursday_R(Self: TRSSChannelSkipDays; var T: Boolean);
begin T := Self.Thursday; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipDaysWednesday_W(Self: TRSSChannelSkipDays; const T: Boolean);
begin Self.Wednesday := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipDaysWednesday_R(Self: TRSSChannelSkipDays; var T: Boolean);
begin T := Self.Wednesday; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipDaysTuesday_W(Self: TRSSChannelSkipDays; const T: Boolean);
begin Self.Tuesday := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipDaysTuesday_R(Self: TRSSChannelSkipDays; var T: Boolean);
begin T := Self.Tuesday; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipDaysMonday_W(Self: TRSSChannelSkipDays; const T: Boolean);
begin Self.Monday := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipDaysMonday_R(Self: TRSSChannelSkipDays; var T: Boolean);
begin T := Self.Monday; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh00_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h00 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh00_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h00; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh23_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h23 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh23_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h23; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh22_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h22 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh22_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h22; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh21_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h21 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh21_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h21; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh20_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h20 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh20_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h20; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh19_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h19 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh19_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h19; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh18_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h18 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh18_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h18; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh17_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h17 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh17_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h17; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh16_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h16 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh16_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h16; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh15_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h15 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh15_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h15; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh14_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h14 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh14_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h14; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh13_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h13 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh13_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h13; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh12_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h12 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh12_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h12; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh11_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h11 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh11_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h11; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh10_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h10 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh10_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h10; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh09_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h09 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh09_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h09; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh08_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h08 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh08_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h08; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh07_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h07 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh07_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h07; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh06_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h06 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh06_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h06; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh05_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h05 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh05_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h05; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh04_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h04 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh04_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h04; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh03_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h03 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh03_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h03; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh02_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h02 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh02_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h02; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh01_W(Self: TRSSChannelSkipHours; const T: Boolean);
begin Self.h01 := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelSkipHoursh01_R(Self: TRSSChannelSkipHours; var T: Boolean);
begin T := Self.h01; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelCategoriesItems_W(Self: TRSSChannelCategories; const T: TRSSChannelCategory; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelCategoriesItems_R(Self: TRSSChannelCategories; var T: TRSSChannelCategory; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelCategoryDomain_W(Self: TRSSChannelCategory; const T: string);
begin Self.Domain := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelCategoryDomain_R(Self: TRSSChannelCategory; var T: string);
begin T := Self.Domain; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelCategoryCategory_W(Self: TRSSChannelCategory; const T: string);
begin Self.Category := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelCategoryCategory_R(Self: TRSSChannelCategory; var T: string);
begin T := Self.Category; end;

(*----------------------------------------------------------------------------*)
procedure TRSSTextInputInclude_W(Self: TRSSTextInput; const T: Boolean);
begin Self.Include := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSTextInputInclude_R(Self: TRSSTextInput; var T: Boolean);
begin T := Self.Include; end;

(*----------------------------------------------------------------------------*)
procedure TRSSTextInputLink_W(Self: TRSSTextInput; const T: string);
begin Self.Link := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSTextInputLink_R(Self: TRSSTextInput; var T: string);
begin T := Self.Link; end;

(*----------------------------------------------------------------------------*)
procedure TRSSTextInputTextInputName_W(Self: TRSSTextInput; const T: string);
begin Self.TextInputName := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSTextInputTextInputName_R(Self: TRSSTextInput; var T: string);
begin T := Self.TextInputName; end;

(*----------------------------------------------------------------------------*)
procedure TRSSTextInputDescription_W(Self: TRSSTextInput; const T: string);
begin Self.Description := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSTextInputDescription_R(Self: TRSSTextInput; var T: string);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TRSSTextInputTitle_W(Self: TRSSTextInput; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSTextInputTitle_R(Self: TRSSTextInput; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TRSSCloudInclude_W(Self: TRSSCloud; const T: Boolean);
begin Self.Include := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSCloudInclude_R(Self: TRSSCloud; var T: Boolean);
begin T := Self.Include; end;

(*----------------------------------------------------------------------------*)
procedure TRSSCloudProtocol_W(Self: TRSSCloud; const T: string);
begin Self.Protocol := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSCloudProtocol_R(Self: TRSSCloud; var T: string);
begin T := Self.Protocol; end;

(*----------------------------------------------------------------------------*)
procedure TRSSCloudRegisterProcedure_W(Self: TRSSCloud; const T: string);
begin Self.RegisterProcedure := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSCloudRegisterProcedure_R(Self: TRSSCloud; var T: string);
begin T := Self.RegisterProcedure; end;

(*----------------------------------------------------------------------------*)
procedure TRSSCloudPath_W(Self: TRSSCloud; const T: string);
begin Self.Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSCloudPath_R(Self: TRSSCloud; var T: string);
begin T := Self.Path; end;

(*----------------------------------------------------------------------------*)
procedure TRSSCloudPort_W(Self: TRSSCloud; const T: Integer);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSCloudPort_R(Self: TRSSCloud; var T: Integer);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TRSSCloudDomain_W(Self: TRSSCloud; const T: string);
begin Self.Domain := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSCloudDomain_R(Self: TRSSCloud; var T: string);
begin T := Self.Domain; end;

(*----------------------------------------------------------------------------*)
procedure TRSSImageOptional_W(Self: TRSSImage; const T: TRSSImageOpt);
begin Self.Optional := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSImageOptional_R(Self: TRSSImage; var T: TRSSImageOpt);
begin T := Self.Optional; end;

(*----------------------------------------------------------------------------*)
procedure TRSSImageRequired_W(Self: TRSSImage; const T: TRSSImageReq);
begin Self.Required := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSImageRequired_R(Self: TRSSImage; var T: TRSSImageReq);
begin T := Self.Required; end;

(*----------------------------------------------------------------------------*)
procedure TRSSImageInclude_W(Self: TRSSImage; const T: Boolean);
begin Self.Include := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSImageInclude_R(Self: TRSSImage; var T: Boolean);
begin T := Self.Include; end;

(*----------------------------------------------------------------------------*)
procedure TRSSImageOptDescription_W(Self: TRSSImageOpt; const T: string);
begin Self.Description := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSImageOptDescription_R(Self: TRSSImageOpt; var T: string);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TRSSImageOptHeight_W(Self: TRSSImageOpt; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSImageOptHeight_R(Self: TRSSImageOpt; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TRSSImageOptWidth_W(Self: TRSSImageOpt; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSImageOptWidth_R(Self: TRSSImageOpt; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TRSSImageReqLink_W(Self: TRSSImageReq; const T: string);
begin Self.Link := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSImageReqLink_R(Self: TRSSImageReq; var T: string);
begin T := Self.Link; end;

(*----------------------------------------------------------------------------*)
procedure TRSSImageReqTitle_W(Self: TRSSImageReq; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSImageReqTitle_R(Self: TRSSImageReq; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TRSSImageReqURL_W(Self: TRSSImageReq; const T: string);
begin Self.URL := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSImageReqURL_R(Self: TRSSImageReq; var T: string);
begin T := Self.URL; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelReqDesc_W(Self: TRSSChannelReq; const T: string);
begin Self.Desc := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelReqDesc_R(Self: TRSSChannelReq; var T: string);
begin T := Self.Desc; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelReqLink_W(Self: TRSSChannelReq; const T: string);
begin Self.Link := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelReqLink_R(Self: TRSSChannelReq; var T: string);
begin T := Self.Link; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelReqTitle_W(Self: TRSSChannelReq; const T: string);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TRSSChannelReqTitle_R(Self: TRSSChannelReq; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TRFC822DateTimeTimeZone_W(Self: TRFC822DateTime; const T: string);
begin Self.TimeZone := T; end;

(*----------------------------------------------------------------------------*)
procedure TRFC822DateTimeTimeZone_R(Self: TRFC822DateTime; var T: string);
begin T := Self.TimeZone; end;

(*----------------------------------------------------------------------------*)
procedure TRFC822DateTimeDateTime_W(Self: TRFC822DateTime; const T: TDateTime);
begin Self.DateTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TRFC822DateTimeDateTime_R(Self: TRFC822DateTime; var T: TDateTime);
begin T := Self.DateTime; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSItems) do
  begin
    RegisterMethod(@TRSSItems.Add, 'Add');
    RegisterMethod(@TRSSItems.Insert, 'Insert');
    RegisterPropertyHelper(@TRSSItemsItems_R,@TRSSItemsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSItem) do
  begin
    RegisterConstructor(@TRSSItem.Create, 'Create');
    RegisterMethod(@TRSSItem.CommentsChanged, 'CommentsChanged');
    RegisterMethod(@TRSSItem.AuthorChanged, 'AuthorChanged');
    RegisterMethod(@TRSSItem.TitleChanged, 'TitleChanged');
    RegisterMethod(@TRSSItem.LinkChanged, 'LinkChanged');
    RegisterMethod(@TRSSItem.DescriptionChanged, 'DescriptionChanged');
    RegisterPropertyHelper(@TRSSItemTitle_R,@TRSSItemTitle_W,'Title');
    RegisterPropertyHelper(@TRSSItemLink_R,@TRSSItemLink_W,'Link');
    RegisterPropertyHelper(@TRSSItemDescription_R,@TRSSItemDescription_W,'Description');
    RegisterPropertyHelper(@TRSSItemAuthor_R,@TRSSItemAuthor_W,'Author');
    RegisterPropertyHelper(@TRSSItemCategories_R,@TRSSItemCategories_W,'Categories');
    RegisterPropertyHelper(@TRSSItemComments_R,@TRSSItemComments_W,'Comments');
    RegisterPropertyHelper(@TRSSItemEnclosure_R,@TRSSItemEnclosure_W,'Enclosure');
    RegisterPropertyHelper(@TRSSItemGUID_R,@TRSSItemGUID_W,'GUID');
    RegisterPropertyHelper(@TRSSItemPubDate_R,@TRSSItemPubDate_W,'PubDate');
    RegisterPropertyHelper(@TRSSItemSource_R,@TRSSItemSource_W,'Source');
    RegisterPropertyHelper(@TRSSItemContentType_R,@TRSSItemContentType_W,'ContentType');
    RegisterPropertyHelper(@TRSSItemiTunes_R,@TRSSItemiTunes_W,'iTunes');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSAuthor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSAuthor) do
  begin
    RegisterPropertyHelper(@TRSSAuthorName_R,@TRSSAuthorName_W,'Name');
    RegisterPropertyHelper(@TRSSAuthorEMail_R,@TRSSAuthorEMail_W,'EMail');
    RegisterPropertyHelper(@TRSSAuthorURL_R,@TRSSAuthorURL_W,'URL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSItemGUID(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSItemGUID) do
  begin
    RegisterConstructor(@TRSSItemGUID.Create, 'Create');
    RegisterPropertyHelper(@TRSSItemGUIDGUID_R,@TRSSItemGUIDGUID_W,'GUID');
    RegisterPropertyHelper(@TRSSItemGUIDIsPermaLink_R,@TRSSItemGUIDIsPermaLink_W,'IsPermaLink');
    RegisterPropertyHelper(@TRSSItemGUIDInclude_R,@TRSSItemGUIDInclude_W,'Include');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSItemCategories(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSItemCategories) do
  begin
    RegisterMethod(@TRSSItemCategories.Add, 'Add');
    RegisterMethod(@TRSSItemCategories.Insert, 'Insert');
    RegisterPropertyHelper(@TRSSItemCategoriesItems_R,@TRSSItemCategoriesItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSItemCategory(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSItemCategory) do
  begin
    RegisterConstructor(@TRSSItemCategory.Create, 'Create');
    RegisterMethod(@TRSSItemCategory.DomainChanged, 'DomainChanged');
    RegisterPropertyHelper(@TRSSItemCategoryTitle_R,@TRSSItemCategoryTitle_W,'Title');
    RegisterPropertyHelper(@TRSSItemCategoryDomain_R,@TRSSItemCategoryDomain_W,'Domain');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSItemEnclosure(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSItemEnclosure) do
  begin
    RegisterPropertyHelper(@TRSSItemEnclosureURL_R,@TRSSItemEnclosureURL_W,'URL');
    RegisterPropertyHelper(@TRSSItemEnclosureLength_R,@TRSSItemEnclosureLength_W,'Length');
    RegisterPropertyHelper(@TRSSItemEnclosureEnclosureType_R,@TRSSItemEnclosureEnclosureType_W,'EnclosureType');
    RegisterPropertyHelper(@TRSSItemEnclosureInclude_R,@TRSSItemEnclosureInclude_W,'Include');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSItemSource(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSItemSource) do
  begin
    RegisterConstructor(@TRSSItemSource.Create, 'Create');
    RegisterPropertyHelper(@TRSSItemSourceTitle_R,@TRSSItemSourceTitle_W,'Title');
    RegisterPropertyHelper(@TRSSItemSourceURL_R,@TRSSItemSourceURL_W,'URL');
    RegisterPropertyHelper(@TRSSItemSourceInclude_R,@TRSSItemSourceInclude_W,'Include');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSChannel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSChannel) do begin
    RegisterConstructor(@TRSSChannel.Create, 'Create');
    RegisterMethod(@TRSSChannel.Destroy, 'Free');
    RegisterPropertyHelper(@TRSSChannelRequired_R,@TRSSChannelRequired_W,'Required');
    RegisterPropertyHelper(@TRSSChannelOptional_R,@TRSSChannelOptional_W,'Optional');
    RegisterPropertyHelper(@TRSSChanneliTunes_R,@TRSSChanneliTunes_W,'iTunes');
    RegisterPropertyHelper(@TRSSChannelAboutURL_R,@TRSSChannelAboutURL_W,'AboutURL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSChannelOpt(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSChannelOpt) do begin
    RegisterConstructor(@TRSSChannelOpt.Create, 'Create');
    RegisterMethod(@TRSSChannelOpt.Destroy, 'Free');
    RegisterMethod(@TRSSChannelOpt.CopyrightChanged, 'CopyrightChanged');
    RegisterMethod(@TRSSChannelOpt.ManagingEditorChanged, 'ManagingEditorChanged');
    RegisterMethod(@TRSSChannelOpt.WebMasterChanged, 'WebMasterChanged');
    RegisterMethod(@TRSSChannelOpt.GeneratorChanged, 'GeneratorChanged');
    RegisterMethod(@TRSSChannelOpt.TTLChanged, 'TTLChanged');
    RegisterMethod(@TRSSChannelOpt.RatingChanged, 'RatingChanged');
    RegisterPropertyHelper(@TRSSChannelOptLanguage_R,@TRSSChannelOptLanguage_W,'Language');
    RegisterPropertyHelper(@TRSSChannelOptXLang_R,@TRSSChannelOptXLang_W,'XLang');
    RegisterPropertyHelper(@TRSSChannelOptCopyright_R,@TRSSChannelOptCopyright_W,'Copyright');
    RegisterPropertyHelper(@TRSSChannelOptManagingEditor_R,@TRSSChannelOptManagingEditor_W,'ManagingEditor');
    RegisterPropertyHelper(@TRSSChannelOptWebMaster_R,@TRSSChannelOptWebMaster_W,'WebMaster');
    RegisterPropertyHelper(@TRSSChannelOptPubDate_R,@TRSSChannelOptPubDate_W,'PubDate');
    RegisterPropertyHelper(@TRSSChannelOptLastBuildDate_R,@TRSSChannelOptLastBuildDate_W,'LastBuildDate');
    RegisterPropertyHelper(@TRSSChannelOptCategories_R,@TRSSChannelOptCategories_W,'Categories');
    RegisterPropertyHelper(@TRSSChannelOptGenerator_R,@TRSSChannelOptGenerator_W,'Generator');
    RegisterPropertyHelper(@TRSSChannelOptDocs_R,@TRSSChannelOptDocs_W,'Docs');
    RegisterPropertyHelper(@TRSSChannelOptCloud_R,@TRSSChannelOptCloud_W,'Cloud');
    RegisterPropertyHelper(@TRSSChannelOptTTL_R,@TRSSChannelOptTTL_W,'TTL');
    RegisterPropertyHelper(@TRSSChannelOptImage_R,@TRSSChannelOptImage_W,'Image');
    RegisterPropertyHelper(@TRSSChannelOptRating_R,@TRSSChannelOptRating_W,'Rating');
    RegisterPropertyHelper(@TRSSChannelOptTextInput_R,@TRSSChannelOptTextInput_W,'TextInput');
    RegisterPropertyHelper(@TRSSChannelOptSkipHours_R,@TRSSChannelOptSkipHours_W,'SkipHours');
    RegisterPropertyHelper(@TRSSChannelOptSkipDays_R,@TRSSChannelOptSkipDays_W,'SkipDays');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSChannelSkipDays(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSChannelSkipDays) do
  begin
    RegisterPropertyHelper(@TRSSChannelSkipDaysMonday_R,@TRSSChannelSkipDaysMonday_W,'Monday');
    RegisterPropertyHelper(@TRSSChannelSkipDaysTuesday_R,@TRSSChannelSkipDaysTuesday_W,'Tuesday');
    RegisterPropertyHelper(@TRSSChannelSkipDaysWednesday_R,@TRSSChannelSkipDaysWednesday_W,'Wednesday');
    RegisterPropertyHelper(@TRSSChannelSkipDaysThursday_R,@TRSSChannelSkipDaysThursday_W,'Thursday');
    RegisterPropertyHelper(@TRSSChannelSkipDaysFriday_R,@TRSSChannelSkipDaysFriday_W,'Friday');
    RegisterPropertyHelper(@TRSSChannelSkipDaysSaturday_R,@TRSSChannelSkipDaysSaturday_W,'Saturday');
    RegisterPropertyHelper(@TRSSChannelSkipDaysSunday_R,@TRSSChannelSkipDaysSunday_W,'Sunday');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSChannelSkipHours(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSChannelSkipHours) do
  begin
    RegisterPropertyHelper(@TRSSChannelSkipHoursh01_R,@TRSSChannelSkipHoursh01_W,'h01');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh02_R,@TRSSChannelSkipHoursh02_W,'h02');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh03_R,@TRSSChannelSkipHoursh03_W,'h03');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh04_R,@TRSSChannelSkipHoursh04_W,'h04');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh05_R,@TRSSChannelSkipHoursh05_W,'h05');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh06_R,@TRSSChannelSkipHoursh06_W,'h06');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh07_R,@TRSSChannelSkipHoursh07_W,'h07');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh08_R,@TRSSChannelSkipHoursh08_W,'h08');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh09_R,@TRSSChannelSkipHoursh09_W,'h09');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh10_R,@TRSSChannelSkipHoursh10_W,'h10');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh11_R,@TRSSChannelSkipHoursh11_W,'h11');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh12_R,@TRSSChannelSkipHoursh12_W,'h12');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh13_R,@TRSSChannelSkipHoursh13_W,'h13');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh14_R,@TRSSChannelSkipHoursh14_W,'h14');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh15_R,@TRSSChannelSkipHoursh15_W,'h15');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh16_R,@TRSSChannelSkipHoursh16_W,'h16');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh17_R,@TRSSChannelSkipHoursh17_W,'h17');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh18_R,@TRSSChannelSkipHoursh18_W,'h18');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh19_R,@TRSSChannelSkipHoursh19_W,'h19');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh20_R,@TRSSChannelSkipHoursh20_W,'h20');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh21_R,@TRSSChannelSkipHoursh21_W,'h21');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh22_R,@TRSSChannelSkipHoursh22_W,'h22');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh23_R,@TRSSChannelSkipHoursh23_W,'h23');
    RegisterPropertyHelper(@TRSSChannelSkipHoursh00_R,@TRSSChannelSkipHoursh00_W,'h00');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSChannelCategories(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSChannelCategories) do
  begin
    RegisterMethod(@TRSSChannelCategories.Add, 'Add');
    RegisterMethod(@TRSSChannelCategories.Insert, 'Insert');
    RegisterPropertyHelper(@TRSSChannelCategoriesItems_R,@TRSSChannelCategoriesItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSChannelCategory(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSChannelCategory) do
  begin
    RegisterConstructor(@TRSSChannelCategory.Create, 'Create');
    RegisterMethod(@TRSSChannelCategory.DomainChanged, 'DomainChanged');
    RegisterPropertyHelper(@TRSSChannelCategoryCategory_R,@TRSSChannelCategoryCategory_W,'Category');
    RegisterPropertyHelper(@TRSSChannelCategoryDomain_R,@TRSSChannelCategoryDomain_W,'Domain');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSTextInput(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSTextInput) do
  begin
    RegisterPropertyHelper(@TRSSTextInputTitle_R,@TRSSTextInputTitle_W,'Title');
    RegisterPropertyHelper(@TRSSTextInputDescription_R,@TRSSTextInputDescription_W,'Description');
    RegisterPropertyHelper(@TRSSTextInputTextInputName_R,@TRSSTextInputTextInputName_W,'TextInputName');
    RegisterPropertyHelper(@TRSSTextInputLink_R,@TRSSTextInputLink_W,'Link');
    RegisterPropertyHelper(@TRSSTextInputInclude_R,@TRSSTextInputInclude_W,'Include');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSCloud(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSCloud) do
  begin
    RegisterPropertyHelper(@TRSSCloudDomain_R,@TRSSCloudDomain_W,'Domain');
    RegisterPropertyHelper(@TRSSCloudPort_R,@TRSSCloudPort_W,'Port');
    RegisterPropertyHelper(@TRSSCloudPath_R,@TRSSCloudPath_W,'Path');
    RegisterPropertyHelper(@TRSSCloudRegisterProcedure_R,@TRSSCloudRegisterProcedure_W,'RegisterProcedure');
    RegisterPropertyHelper(@TRSSCloudProtocol_R,@TRSSCloudProtocol_W,'Protocol');
    RegisterPropertyHelper(@TRSSCloudInclude_R,@TRSSCloudInclude_W,'Include');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSImage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSImage) do begin
    RegisterConstructor(@TRSSImage.Create, 'Create');
    RegisterMethod(@TRSSImage.Destroy, 'Free');
    RegisterPropertyHelper(@TRSSImageInclude_R,@TRSSImageInclude_W,'Include');
    RegisterPropertyHelper(@TRSSImageRequired_R,@TRSSImageRequired_W,'Required');
    RegisterPropertyHelper(@TRSSImageOptional_R,@TRSSImageOptional_W,'Optional');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSImageOpt(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSImageOpt) do
  begin
    RegisterMethod(@TRSSImageOpt.DescriptionChanged, 'DescriptionChanged');
    RegisterMethod(@TRSSImageOpt.HeightChanged, 'HeightChanged');
    RegisterMethod(@TRSSImageOpt.WidthChanged, 'WidthChanged');
    RegisterConstructor(@TRSSImageOpt.Create, 'Create');
    RegisterPropertyHelper(@TRSSImageOptWidth_R,@TRSSImageOptWidth_W,'Width');
    RegisterPropertyHelper(@TRSSImageOptHeight_R,@TRSSImageOptHeight_W,'Height');
    RegisterPropertyHelper(@TRSSImageOptDescription_R,@TRSSImageOptDescription_W,'Description');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSImageReq(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSImageReq) do
  begin
    RegisterPropertyHelper(@TRSSImageReqURL_R,@TRSSImageReqURL_W,'URL');
    RegisterPropertyHelper(@TRSSImageReqTitle_R,@TRSSImageReqTitle_W,'Title');
    RegisterPropertyHelper(@TRSSImageReqLink_R,@TRSSImageReqLink_W,'Link');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRSSChannelReq(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRSSChannelReq) do
  begin
    RegisterPropertyHelper(@TRSSChannelReqTitle_R,@TRSSChannelReqTitle_W,'Title');
    RegisterPropertyHelper(@TRSSChannelReqLink_R,@TRSSChannelReqLink_W,'Link');
    RegisterPropertyHelper(@TRSSChannelReqDesc_R,@TRSSChannelReqDesc_W,'Desc');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRFC822DateTime(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRFC822DateTime) do
  begin
    RegisterMethod(@TRFC822DateTime.GetDateTime, 'GetDateTime');
    RegisterMethod(@TRFC822DateTime.LoadDateTime, 'LoadDateTime');
    RegisterMethod(@TRFC822DateTime.LoadDCDateTime, 'LoadDCDateTime');
    RegisterConstructor(@TRFC822DateTime.Create, 'Create');
    RegisterMethod(@TRFC822DateTime.Changed, 'Changed');
    RegisterMethod(@TRFC822DateTime.LastSpace, 'LastSpace');
    RegisterPropertyHelper(@TRFC822DateTimeDateTime_R,@TRFC822DateTimeDateTime_W,'DateTime');
    RegisterPropertyHelper(@TRFC822DateTimeTimeZone_R,@TRFC822DateTimeTimeZone_W,'TimeZone');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SimpleRSSTypes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ESimpleRSSException) do
  RIRegister_TRFC822DateTime(CL);
  RIRegister_TRSSChannelReq(CL);
  RIRegister_TRSSImageReq(CL);
  RIRegister_TRSSImageOpt(CL);
  RIRegister_TRSSImage(CL);
  RIRegister_TRSSCloud(CL);
  RIRegister_TRSSTextInput(CL);
  RIRegister_TRSSChannelCategory(CL);
  RIRegister_TRSSChannelCategories(CL);
  RIRegister_TRSSChannelSkipHours(CL);
  RIRegister_TRSSChannelSkipDays(CL);
  RIRegister_TRSSChannelOpt(CL);
  RIRegister_TRSSChannel(CL);
  RIRegister_TRSSItemSource(CL);
  RIRegister_TRSSItemEnclosure(CL);
  RIRegister_TRSSItemCategory(CL);
  RIRegister_TRSSItemCategories(CL);
  RIRegister_TRSSItemGUID(CL);
  RIRegister_TRSSAuthor(CL);
  RIRegister_TRSSItem(CL);
  RIRegister_TRSSItems(CL);
end;

 
 
{ TPSImport_SimpleRSSTypes }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleRSSTypes.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SimpleRSSTypes(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleRSSTypes.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SimpleRSSTypes(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
