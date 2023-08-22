unit uPSI_SimpleRSS;
{
TmaXbox Sentiment Analysis Recorder Alerter Recommender Predictor

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
  TPSImport_SimpleRSS = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSimpleRSS(CL: TPSPascalCompiler);
procedure SIRegister_SimpleRSS(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SimpleRSS_Routines(S: TPSExec);
procedure RIRegister_TSimpleRSS(CL: TPSRuntimeClassImporter);
procedure RIRegister_SimpleRSS(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   SimpleRSSTypes
  ,XMLDoc
  ,XMLIntf
  ,XMLDOM
  ,Variants
  ,idHTTP
  ,SimpleRSS
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SimpleRSS]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimpleRSS(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TSimpleRSS') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TSimpleRSS') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure SaveToFile( Filename : string)');
    RegisterMethod('Function SaveToString : string');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Function SaveToStrings : TStrings');
    RegisterMethod('Procedure LoadFromHTTP( URL : String)');
    RegisterMethod('Procedure LoadFromString( S : string)');
    RegisterMethod('Procedure LoadFromFile( Filename : string)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromStrings( Strings : TStrings)');
    RegisterMethod('Procedure GenerateXML;');
    RegisterMethod('Procedure GenerateXML1( FeedType : TXMLTypeRSS);');
    RegisterMethod('Procedure GenerateComponent');
    RegisterMethod('Procedure ClearXML');
    RegisterProperty('Channel', 'TRSSChannel', iptrw);
    RegisterProperty('Items', 'TRSSItems', iptrw);
    RegisterProperty('Version', 'string', iptrw);
    RegisterProperty('XMLType', 'TXMLTypeRSS', iptrw);
    RegisterProperty('XMLFile', 'TXMLDocument', iptr);
    RegisterProperty('IndyHTTP', 'TIdHTTP', iptrw);
    RegisterProperty('SimpleRSSVersion', 'String', iptr);
    RegisterProperty('OnCreate', 'TNotifyEvent', iptrw);
    RegisterProperty('OnGenerateXML', 'TNotifyEvent', iptrw);
    RegisterProperty('OnParseXML', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SimpleRSS(CL: TPSPascalCompiler);
begin
  SIRegister_TSimpleRSS(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSimpleRSSOnParseXML_W(Self: TSimpleRSS; const T: TNotifyEvent);
begin Self.OnParseXML := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleRSSOnParseXML_R(Self: TSimpleRSS; var T: TNotifyEvent);
begin T := Self.OnParseXML; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleRSSOnGenerateXML_W(Self: TSimpleRSS; const T: TNotifyEvent);
begin Self.OnGenerateXML := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleRSSOnGenerateXML_R(Self: TSimpleRSS; var T: TNotifyEvent);
begin T := Self.OnGenerateXML; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleRSSOnCreate_W(Self: TSimpleRSS; const T: TNotifyEvent);
begin Self.OnCreate := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleRSSOnCreate_R(Self: TSimpleRSS; var T: TNotifyEvent);
begin T := Self.OnCreate; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleRSSSimpleRSSVersion_R(Self: TSimpleRSS; var T: String);
begin T := Self.SimpleRSSVersion; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleRSSIndyHTTP_W(Self: TSimpleRSS; const T: TIdHTTP);
begin Self.IndyHTTP := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleRSSIndyHTTP_R(Self: TSimpleRSS; var T: TIdHTTP);
begin T := Self.IndyHTTP; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleRSSXMLFile_R(Self: TSimpleRSS; var T: TXMLDocument);
begin T := Self.XMLFile; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleRSSXMLType_W(Self: TSimpleRSS; const T: TXMLTypeRSS);
begin Self.XMLType := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleRSSXMLType_R(Self: TSimpleRSS; var T: TXMLTypeRSS);
begin T := Self.XMLType; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleRSSVersion_W(Self: TSimpleRSS; const T: string);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleRSSVersion_R(Self: TSimpleRSS; var T: string);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleRSSItems_W(Self: TSimpleRSS; const T: TRSSItems);
begin Self.Items := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleRSSItems_R(Self: TSimpleRSS; var T: TRSSItems);
begin T := Self.Items; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleRSSChannel_W(Self: TSimpleRSS; const T: TRSSChannel);
begin Self.Channel := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimpleRSSChannel_R(Self: TSimpleRSS; var T: TRSSChannel);
begin T := Self.Channel; end;

(*----------------------------------------------------------------------------*)
Procedure TSimpleRSSGenerateXML1_P(Self: TSimpleRSS;  FeedType : TXMLTypeRSS);
Begin Self.GenerateXML(FeedType); END;

(*----------------------------------------------------------------------------*)
Procedure TSimpleRSSGenerateXML_P(Self: TSimpleRSS);
Begin Self.GenerateXML; END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SimpleRSS_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimpleRSS(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimpleRSS) do begin
    RegisterConstructor(@TSimpleRSS.Create, 'Create');
    RegisterMethod(@TSimpleRSS.Destroy, 'Free');
    RegisterMethod(@TSimpleRSS.SaveToFile, 'SaveToFile');
    RegisterMethod(@TSimpleRSS.SaveToString, 'SaveToString');
    RegisterMethod(@TSimpleRSS.SaveToStream, 'SaveToStream');
    RegisterMethod(@TSimpleRSS.SaveToStrings, 'SaveToStrings');
    RegisterMethod(@TSimpleRSS.LoadFromHTTP, 'LoadFromHTTP');
    RegisterMethod(@TSimpleRSS.LoadFromString, 'LoadFromString');
    RegisterMethod(@TSimpleRSS.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TSimpleRSS.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TSimpleRSS.LoadFromStrings, 'LoadFromStrings');
    RegisterMethod(@TSimpleRSSGenerateXML_P, 'GenerateXML');
    RegisterMethod(@TSimpleRSSGenerateXML1_P, 'GenerateXML1');
    RegisterMethod(@TSimpleRSS.GenerateComponent, 'GenerateComponent');
    RegisterMethod(@TSimpleRSS.ClearXML, 'ClearXML');
    RegisterPropertyHelper(@TSimpleRSSChannel_R,@TSimpleRSSChannel_W,'Channel');
    RegisterPropertyHelper(@TSimpleRSSItems_R,@TSimpleRSSItems_W,'Items');
    RegisterPropertyHelper(@TSimpleRSSVersion_R,@TSimpleRSSVersion_W,'Version');
    RegisterPropertyHelper(@TSimpleRSSXMLType_R,@TSimpleRSSXMLType_W,'XMLType');
    RegisterPropertyHelper(@TSimpleRSSXMLFile_R,nil,'XMLFile');
    RegisterPropertyHelper(@TSimpleRSSIndyHTTP_R,@TSimpleRSSIndyHTTP_W,'IndyHTTP');
    RegisterPropertyHelper(@TSimpleRSSSimpleRSSVersion_R,nil,'SimpleRSSVersion');
    RegisterPropertyHelper(@TSimpleRSSOnCreate_R,@TSimpleRSSOnCreate_W,'OnCreate');
    RegisterPropertyHelper(@TSimpleRSSOnGenerateXML_R,@TSimpleRSSOnGenerateXML_W,'OnGenerateXML');
    RegisterPropertyHelper(@TSimpleRSSOnParseXML_R,@TSimpleRSSOnParseXML_W,'OnParseXML');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SimpleRSS(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSimpleRSS(CL);
end;

 
 
{ TPSImport_SimpleRSS }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleRSS.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SimpleRSS(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleRSS.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SimpleRSS(ri);
  //RIRegister_SimpleRSS_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
