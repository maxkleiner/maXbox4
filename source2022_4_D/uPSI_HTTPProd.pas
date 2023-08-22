unit uPSI_HTTPProd;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_HTTPProd = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAbstractScriptEnginesList(CL: TPSPascalCompiler);
procedure SIRegister_TAbstractScriptProducer(CL: TPSPascalCompiler);
procedure SIRegister_IScriptProducer(CL: TPSPascalCompiler);
procedure SIRegister_IScriptContext(CL: TPSPascalCompiler);
procedure SIRegister_TAbstractScriptErrors(CL: TPSPascalCompiler);
procedure SIRegister_TAbstractScriptError(CL: TPSPascalCompiler);
procedure SIRegister_EScriptError(CL: TPSPascalCompiler);
procedure SIRegister_TPageProducer(CL: TPSPascalCompiler);
procedure SIRegister_TCustomPageProducer(CL: TPSPascalCompiler);
procedure SIRegister_TBasePageProducer(CL: TPSPascalCompiler);
procedure SIRegister_IGetProducerTemplate(CL: TPSPascalCompiler);
procedure SIRegister_THTMLTableHeaderAttributes(CL: TPSPascalCompiler);
procedure SIRegister_THTMLTableElementAttributes(CL: TPSPascalCompiler);
procedure SIRegister_THTMLTableAttributes(CL: TPSPascalCompiler);
procedure SIRegister_THTMLTagAttributes(CL: TPSPascalCompiler);
procedure SIRegister_IDesignerFileManager(CL: TPSPascalCompiler);
procedure SIRegister_IGetLocateFileService(CL: TPSPascalCompiler);
procedure SIRegister_IWebVariablesContainer(CL: TPSPascalCompiler);
procedure SIRegister_IWebVariableName(CL: TPSPascalCompiler);
procedure SIRegister_ILocateFileService(CL: TPSPascalCompiler);
procedure SIRegister_HTTPProd(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_HTTPProd_Routines(S: TPSExec);
procedure RIRegister_TAbstractScriptEnginesList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAbstractScriptProducer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAbstractScriptErrors(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAbstractScriptError(CL: TPSRuntimeClassImporter);
procedure RIRegister_EScriptError(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPageProducer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomPageProducer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBasePageProducer(CL: TPSRuntimeClassImporter);
procedure RIRegister_THTMLTableHeaderAttributes(CL: TPSRuntimeClassImporter);
procedure RIRegister_THTMLTableElementAttributes(CL: TPSRuntimeClassImporter);
procedure RIRegister_THTMLTableAttributes(CL: TPSRuntimeClassImporter);
procedure RIRegister_THTMLTagAttributes(CL: TPSRuntimeClassImporter);
procedure RIRegister_HTTPProd(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   HTTPApp
  ,Masks
  ,Contnrs
  ,HTTPProd
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_HTTPProd]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAbstractScriptEnginesList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAbstractScriptEnginesList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAbstractScriptEnginesList') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function FindScriptProducerClass( const ALanguageName : string) : TScriptProducerClass');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAbstractScriptProducer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TAbstractScriptProducer') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TAbstractScriptProducer') do
  begin
    RegisterMethod('Constructor Create( AWebModuleContext : TWebModuleContext; AStripParamQuotes : Boolean; AHandleTag : THandleTagProc; const AScriptEngine : string; ALocateFileService : ILocateFileService)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IScriptProducer(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IScriptContext', 'IScriptProducer') do
  with CL.AddInterface(CL.FindInterface('IScriptContext'),IScriptProducer, 'IScriptProducer') do
  begin
    RegisterMethod('Function GetErrors : TAbstractScriptErrors', cdRegister);
    RegisterMethod('Function GetHTMLBlock( I : Integer) : string', cdRegister);
    RegisterMethod('Function GetHTMLBlockCount : Integer', cdRegister);
    RegisterMethod('Procedure ParseStream( Stream : TStream; Owned : Boolean)', cdRegister);
    RegisterMethod('Procedure ParseString( const S : string)', cdRegister);
    RegisterMethod('Function ReplaceTags( const S : string) : string', cdRegister);
    RegisterMethod('Function Evaluate : string', cdRegister);
    RegisterMethod('Function HandleScriptError( const ScriptError : IUnknown) : HRESULT', cdRegister);
    RegisterMethod('Procedure Write0( const Value : PWideChar; ALength : Integer);', cdRegister);
    RegisterMethod('Procedure Write1( const Value : string);', cdRegister);
    RegisterMethod('Procedure WriteItem( Index : Integer)', cdRegister);
    RegisterMethod('Function GetContent : string', cdRegister);
    RegisterMethod('Procedure SetContent( const Value : string)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IScriptContext(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IScriptContext') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IScriptContext, 'IScriptContext') do
  begin
    RegisterMethod('Function GetWebModuleContext : TWebModuleContext', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAbstractScriptErrors(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAbstractScriptErrors') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAbstractScriptErrors') do
  begin
    RegisterMethod('Procedure Add( const AError : TAbstractScriptError)');
    RegisterProperty('Errors', 'TAbstractScriptError Integer', iptr);
    SetDefaultPropery('Errors');
    RegisterProperty('Count', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAbstractScriptError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAbstractScriptError') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAbstractScriptError') do
  begin
    RegisterProperty('Line', 'Integer', iptr);
    RegisterProperty('CharPos', 'Integer', iptr);
    RegisterProperty('Description', 'string', iptrw);
    RegisterProperty('SourceLine', 'string', iptr);
    RegisterProperty('FileName', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EScriptError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EWebBrokerException', 'EScriptError') do
  with CL.AddClassN(CL.FindClass('EWebBrokerException'),'EScriptError') do
  begin
    RegisterMethod('Constructor Create( const AErrors : TAbstractScriptErrors; const AContent : string)');
    RegisterProperty('Errors', 'TAbstractScriptErrors', iptr);
    RegisterProperty('Content', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPageProducer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomPageProducer', 'TPageProducer') do
  with CL.AddClassN(CL.FindClass('TCustomPageProducer'),'TPageProducer') do begin
     RegisterPublishedProperties;
    { property HTMLDoc;
    property HTMLFile;
    property StripParamQuotes;
    property OnHTMLTag;
    property ScriptEngine;
    }

    RegisterProperty('HTMLDoc', 'TStrings', iptrw);
    RegisterProperty('HTMLFile', 'TFilename', iptrw);
    RegisterProperty('StripParamQuotes', 'Boolean', iptrw);
    RegisterProperty('ScriptEngine', 'string', iptrw);
    RegisterProperty('OnHTMLTag', 'THTMLTagEvent', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomPageProducer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBasePageProducer', 'TCustomPageProducer') do
  with CL.AddClassN(CL.FindClass('TBasePageProducer'),'TCustomPageProducer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
  RegisterMethod('Procedure Free');
      RegisterProperty('HTMLDoc', 'TStrings', iptrw);
    RegisterProperty('HTMLFile', 'TFileName', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBasePageProducer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomContentProducer', 'TBasePageProducer') do
  with CL.AddClassN(CL.FindClass('TCustomContentProducer'),'TBasePageProducer') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Content : string');
    RegisterMethod('Function ContentFromStream( Stream : TStream) : string');
    RegisterMethod('Function ContentFromString( const S : string) : string');
    RegisterProperty('WebModuleContext', 'TWebModuleContext', iptr);
    RegisterProperty('StripParamQuotes', 'Boolean', iptrw);
    RegisterProperty('ScriptEngine', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IGetProducerTemplate(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IGetProducerTemplate') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IGetProducerTemplate, 'IGetProducerTemplate') do
  begin
    RegisterMethod('Function GetProducerTemplateStream( out AOwned : Boolean) : TStream', cdRegister);
    RegisterMethod('Function GetProducerTemplateFileName : string', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THTMLTableHeaderAttributes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THTMLTableElementAttributes', 'THTMLTableHeaderAttributes') do
  with CL.AddClassN(CL.FindClass('THTMLTableElementAttributes'),'THTMLTableHeaderAttributes') do
  begin
    RegisterProperty('Caption', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THTMLTableElementAttributes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THTMLTagAttributes', 'THTMLTableElementAttributes') do
  with CL.AddClassN(CL.FindClass('THTMLTagAttributes'),'THTMLTableElementAttributes') do
  begin
    RegisterMethod('Procedure RestoreDefaults');
    RegisterProperty('Align', 'THTMLAlign', iptrw);
    RegisterProperty('BgColor', 'THTMLBgColor', iptrw);
    RegisterProperty('VAlign', 'THTMLVAlign', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THTMLTableAttributes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THTMLTagAttributes', 'THTMLTableAttributes') do
  with CL.AddClassN(CL.FindClass('THTMLTagAttributes'),'THTMLTableAttributes') do
  begin
    RegisterMethod('Constructor Create( Producer : TCustomContentProducer)');
    RegisterMethod('Procedure RestoreDefaults');
    RegisterProperty('Align', 'THTMLAlign', iptrw);
    RegisterProperty('BgColor', 'THTMLBgColor', iptrw);
    RegisterProperty('Border', 'Integer', iptrw);
    RegisterProperty('CellSpacing', 'Integer', iptrw);
    RegisterProperty('CellPadding', 'Integer', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THTMLTagAttributes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'THTMLTagAttributes') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'THTMLTagAttributes') do
  begin
    RegisterMethod('Constructor Create( Producer : TCustomContentProducer)');
    RegisterMethod('Procedure RestoreDefaults');
    RegisterProperty('Producer', 'TCustomContentProducer', iptr);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('Custom', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDesignerFileManager(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IDesignerFileManager') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDesignerFileManager, 'IDesignerFileManager') do
  begin
    RegisterMethod('Function QualifyFileName( const AFileName : string) : string', cdRegister);
    RegisterMethod('Function GetStream( const AFileName : string; var AOwned : Boolean) : TStream', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IGetLocateFileService(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IGetLocateFileService') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IGetLocateFileService, 'IGetLocateFileService') do
  begin
    RegisterMethod('Function GetLocateFileService : ILocateFileService', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IWebVariablesContainer(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IWebVariablesContainer') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IWebVariablesContainer, 'IWebVariablesContainer') do
  begin
    RegisterMethod('Function FindVariable( const AName : string) : TComponent', cdRegister);
    RegisterMethod('Function FindVariableContainer( const AName : string) : TComponent', cdRegister);
    RegisterMethod('Function GetVariableCount : Integer', cdRegister);
    RegisterMethod('Function GetVariable( I : Integer) : TComponent', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IWebVariableName(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IWebVariableName') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IWebVariableName, 'IWebVariableName') do
  begin
    RegisterMethod('Function GetVariableName : string', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ILocateFileService(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'ILocateFileService') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),ILocateFileService, 'ILocateFileService') do
  begin
    RegisterMethod('Function GetTemplateStream( AComponent : TComponent; AFileName : string; out AOwned : Boolean) : TStream', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_HTTPProd(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('THTMLAlign', '( haDefault, haLeft, haRight, haCenter )');
  CL.AddTypeS('THTMLVAlign', '( haVDefault, haTop, haMiddle, haBottom, haBaseline )');
  CL.AddTypeS('THTMLBgColor', 'string');
  SIRegister_ILocateFileService(CL);
  SIRegister_IWebVariableName(CL);
  SIRegister_IWebVariablesContainer(CL);
  SIRegister_IGetLocateFileService(CL);
  SIRegister_IDesignerFileManager(CL);
  SIRegister_THTMLTagAttributes(CL);
  SIRegister_THTMLTableAttributes(CL);
  SIRegister_THTMLTableElementAttributes(CL);
  SIRegister_THTMLTableHeaderAttributes(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'THTMLTableRowAttributes');
  CL.AddClassN(CL.FindClass('TOBJECT'),'THTMLTableCellAttributes');
  CL.AddTypeS('TTag', '( tgCustom, tgLink, tgImage, tgTable, tgImageMap, tgObject, tgEmbed )');
  CL.AddTypeS('THTMLTagEvent', 'Procedure ( Sender : TObject; Tag : TTag; const'
   +' TagString : string; TagParams : TStrings; var ReplaceText : string)');
  SIRegister_IGetProducerTemplate(CL);
  SIRegister_TBasePageProducer(CL);
  SIRegister_TCustomPageProducer(CL);
  SIRegister_TPageProducer(CL);
  CL.AddTypeS('THandleTagProc', 'Function ( const TagString : string; TagParams : TStrings) : string');
  CL.AddTypeS('THandledTagProc', 'Function ( const TagString: string; TagParams: TStrings; var ReplaceString : string) : Boolean');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TAbstractScriptProducer');
  //CL.AddTypeS('TScriptProducerClass', 'class of TAbstractScriptProducer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TAbstractScriptErrors');
  SIRegister_EScriptError(CL);
  SIRegister_TAbstractScriptError(CL);
  SIRegister_TAbstractScriptErrors(CL);
  SIRegister_IScriptContext(CL);
  SIRegister_IScriptProducer(CL);
  SIRegister_TAbstractScriptProducer(CL);
  SIRegister_TAbstractScriptEnginesList(CL);
 CL.AddDelphiFunction('Function ContentFromScriptStream( AStream : TStream; AWebModuleContext : TWebModuleContext; AStripParamQuotes : Boolean; AHandleTag : THandleTagProc; AHandleScriptTag : THandledTagProc; const AScriptEngine : string; '+
                                 'ALocateFileService : ILocateFileService) : string');
 CL.AddDelphiFunction('Function ContentFromScriptFile( const AFileName : TFileName; AWebModuleContext : TWebModuleContext; AStripParamQuotes : Boolean; AHandleTag : THandleTagProc; AHandleScriptTag : THandledTagProc; '+
                                'const AScriptEngine : string; ALocateFileService : ILocateFileService) : string');
 CL.AddDelphiFunction('Function FindComponentWebModuleContext( AComponent : TComponent) : TWebModuleContext');
 CL.AddDelphiFunction('Function GetTagID( const TagString : string) : TTag');
 CL.AddDelphiFunction('Function ContentFromStream( AStream : TStream; AStripParamQuotes : Boolean; AHandleTag : THandleTagProc; AHandledTag : THandledTagProc) : string');
 CL.AddDelphiFunction('Function ContentFromString( const AValue : string; AStripParamQuotes : Boolean; AHandleTag : THandleTagProc; AHandledTag : THandledTagProc) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure IScriptProducerWrite1_P(Self: IScriptProducer;  const Value : string);
Begin Self.Write(Value); END;

(*----------------------------------------------------------------------------*)
Procedure IScriptProducerWrite0_P(Self: IScriptProducer;  const Value : PWideChar; ALength : Integer);
Begin Self.Write(Value, ALength); END;

(*----------------------------------------------------------------------------*)
procedure TAbstractScriptErrorsCount_R(Self: TAbstractScriptErrors; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TAbstractScriptErrorsErrors_R(Self: TAbstractScriptErrors; var T: TAbstractScriptError; const t1: Integer);
begin T := Self.Errors[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TAbstractScriptErrorFileName_R(Self: TAbstractScriptError; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TAbstractScriptErrorSourceLine_R(Self: TAbstractScriptError; var T: string);
begin T := Self.SourceLine; end;

(*----------------------------------------------------------------------------*)
procedure TAbstractScriptErrorDescription_W(Self: TAbstractScriptError; const T: string);
begin Self.Description := T; end;

(*----------------------------------------------------------------------------*)
procedure TAbstractScriptErrorDescription_R(Self: TAbstractScriptError; var T: string);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TAbstractScriptErrorCharPos_R(Self: TAbstractScriptError; var T: Integer);
begin T := Self.CharPos; end;

(*----------------------------------------------------------------------------*)
procedure TAbstractScriptErrorLine_R(Self: TAbstractScriptError; var T: Integer);
begin T := Self.Line; end;

(*----------------------------------------------------------------------------*)
procedure EScriptErrorContent_R(Self: EScriptError; var T: string);
begin T := Self.Content; end;

(*----------------------------------------------------------------------------*)
procedure EScriptErrorErrors_R(Self: EScriptError; var T: TAbstractScriptErrors);
begin T := Self.Errors; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPageProducerHTMLFile_W(Self: TCustomPageProducer; const T: TFileName);
begin Self.HTMLFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPageProducerHTMLFile_R(Self: TCustomPageProducer; var T: TFileName);
begin T := Self.HTMLFile; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPageProducerHTMLDoc_W(Self: TCustomPageProducer; const T: TStrings);
begin Self.HTMLDoc := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPageProducerHTMLDoc_R(Self: TCustomPageProducer; var T: TStrings);
begin T := Self.HTMLDoc; end;

(*----------------------------------------------------------------------------*)
procedure TBasePageProducerScriptEngine_W(Self: TBasePageProducer; const T: string);
begin Self.ScriptEngine := T; end;

(*----------------------------------------------------------------------------*)
procedure TBasePageProducerScriptEngine_R(Self: TBasePageProducer; var T: string);
begin T := Self.ScriptEngine; end;

(*----------------------------------------------------------------------------*)
procedure TBasePageProducerStripParamQuotes_W(Self: TBasePageProducer; const T: Boolean);
begin Self.StripParamQuotes := T; end;

(*----------------------------------------------------------------------------*)
procedure TBasePageProducerStripParamQuotes_R(Self: TBasePageProducer; var T: Boolean);
begin T := Self.StripParamQuotes; end;

(*----------------------------------------------------------------------------*)
procedure TBasePageProducerWebModuleContext_R(Self: TBasePageProducer; var T: TWebModuleContext);
begin T := Self.WebModuleContext; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableHeaderAttributesCaption_W(Self: THTMLTableHeaderAttributes; const T: string);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableHeaderAttributesCaption_R(Self: THTMLTableHeaderAttributes; var T: string);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableElementAttributesVAlign_W(Self: THTMLTableElementAttributes; const T: THTMLVAlign);
begin Self.VAlign := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableElementAttributesVAlign_R(Self: THTMLTableElementAttributes; var T: THTMLVAlign);
begin T := Self.VAlign; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableElementAttributesBgColor_W(Self: THTMLTableElementAttributes; const T: THTMLBgColor);
begin Self.BgColor := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableElementAttributesBgColor_R(Self: THTMLTableElementAttributes; var T: THTMLBgColor);
begin T := Self.BgColor; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableElementAttributesAlign_W(Self: THTMLTableElementAttributes; const T: THTMLAlign);
begin Self.Align := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableElementAttributesAlign_R(Self: THTMLTableElementAttributes; var T: THTMLAlign);
begin T := Self.Align; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableAttributesWidth_W(Self: THTMLTableAttributes; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableAttributesWidth_R(Self: THTMLTableAttributes; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableAttributesCellPadding_W(Self: THTMLTableAttributes; const T: Integer);
begin Self.CellPadding := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableAttributesCellPadding_R(Self: THTMLTableAttributes; var T: Integer);
begin T := Self.CellPadding; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableAttributesCellSpacing_W(Self: THTMLTableAttributes; const T: Integer);
begin Self.CellSpacing := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableAttributesCellSpacing_R(Self: THTMLTableAttributes; var T: Integer);
begin T := Self.CellSpacing; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableAttributesBorder_W(Self: THTMLTableAttributes; const T: Integer);
begin Self.Border := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableAttributesBorder_R(Self: THTMLTableAttributes; var T: Integer);
begin T := Self.Border; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableAttributesBgColor_W(Self: THTMLTableAttributes; const T: THTMLBgColor);
begin Self.BgColor := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableAttributesBgColor_R(Self: THTMLTableAttributes; var T: THTMLBgColor);
begin T := Self.BgColor; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableAttributesAlign_W(Self: THTMLTableAttributes; const T: THTMLAlign);
begin Self.Align := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTableAttributesAlign_R(Self: THTMLTableAttributes; var T: THTMLAlign);
begin T := Self.Align; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTagAttributesCustom_W(Self: THTMLTagAttributes; const T: string);
begin Self.Custom := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTagAttributesCustom_R(Self: THTMLTagAttributes; var T: string);
begin T := Self.Custom; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTagAttributesOnChange_W(Self: THTMLTagAttributes; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTagAttributesOnChange_R(Self: THTMLTagAttributes; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure THTMLTagAttributesProducer_R(Self: THTMLTagAttributes; var T: TCustomContentProducer);
begin T := Self.Producer; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_HTTPProd_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ContentFromScriptStream, 'ContentFromScriptStream', cdRegister);
 S.RegisterDelphiFunction(@ContentFromScriptFile, 'ContentFromScriptFile', cdRegister);
 S.RegisterDelphiFunction(@FindComponentWebModuleContext, 'FindComponentWebModuleContext', cdRegister);
 S.RegisterDelphiFunction(@GetTagID, 'GetTagID', cdRegister);
 S.RegisterDelphiFunction(@ContentFromStream, 'ContentFromStream', cdRegister);
 S.RegisterDelphiFunction(@ContentFromString, 'ContentFromString', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAbstractScriptEnginesList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAbstractScriptEnginesList) do
  begin
    RegisterConstructor(@TAbstractScriptEnginesList.Create, 'Create');
    //RegisterVirtualAbstractMethod(@TAbstractScriptEnginesList, @!.FindScriptProducerClass, 'FindScriptProducerClass');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAbstractScriptProducer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAbstractScriptProducer) do
  begin
    RegisterVirtualConstructor(@TAbstractScriptProducer.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAbstractScriptErrors(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAbstractScriptErrors) do
  begin
    //RegisterVirtualAbstractMethod(@TAbstractScriptErrors, @!.Add, 'Add');
    RegisterPropertyHelper(@TAbstractScriptErrorsErrors_R,nil,'Errors');
    RegisterPropertyHelper(@TAbstractScriptErrorsCount_R,nil,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAbstractScriptError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAbstractScriptError) do
  begin
    RegisterPropertyHelper(@TAbstractScriptErrorLine_R,nil,'Line');
    RegisterPropertyHelper(@TAbstractScriptErrorCharPos_R,nil,'CharPos');
    RegisterPropertyHelper(@TAbstractScriptErrorDescription_R,@TAbstractScriptErrorDescription_W,'Description');
    RegisterPropertyHelper(@TAbstractScriptErrorSourceLine_R,nil,'SourceLine');
    RegisterPropertyHelper(@TAbstractScriptErrorFileName_R,nil,'FileName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EScriptError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EScriptError) do
  begin
    RegisterConstructor(@EScriptError.Create, 'Create');
    RegisterPropertyHelper(@EScriptErrorErrors_R,nil,'Errors');
    RegisterPropertyHelper(@EScriptErrorContent_R,nil,'Content');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPageProducer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPageProducer) do begin
   {  RegisterPublishedProperties;

    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('ShowButtons', 'Boolean', iptrw);
    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    }
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomPageProducer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomPageProducer) do begin
    RegisterConstructor(@TCustomPageProducer.Create, 'Create');
      RegisterMethod(@TCustomPageProducer.Destroy, 'Free');
     RegisterPropertyHelper(@TCustomPageProducerHTMLDoc_R,@TCustomPageProducerHTMLDoc_W,'HTMLDoc');
    RegisterPropertyHelper(@TCustomPageProducerHTMLFile_R,@TCustomPageProducerHTMLFile_W,'HTMLFile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBasePageProducer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBasePageProducer) do
  begin
    RegisterConstructor(@TBasePageProducer.Create, 'Create');
    RegisterMethod(@TBasePageProducer.Content, 'Content');
    RegisterMethod(@TBasePageProducer.ContentFromStream, 'ContentFromStream');
    RegisterMethod(@TBasePageProducer.ContentFromString, 'ContentFromString');
    RegisterPropertyHelper(@TBasePageProducerWebModuleContext_R,nil,'WebModuleContext');
    RegisterPropertyHelper(@TBasePageProducerStripParamQuotes_R,@TBasePageProducerStripParamQuotes_W,'StripParamQuotes');
    RegisterPropertyHelper(@TBasePageProducerScriptEngine_R,@TBasePageProducerScriptEngine_W,'ScriptEngine');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTMLTableHeaderAttributes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTMLTableHeaderAttributes) do
  begin
    RegisterPropertyHelper(@THTMLTableHeaderAttributesCaption_R,@THTMLTableHeaderAttributesCaption_W,'Caption');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTMLTableElementAttributes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTMLTableElementAttributes) do
  begin
    RegisterMethod(@THTMLTableElementAttributes.RestoreDefaults, 'RestoreDefaults');
    RegisterPropertyHelper(@THTMLTableElementAttributesAlign_R,@THTMLTableElementAttributesAlign_W,'Align');
    RegisterPropertyHelper(@THTMLTableElementAttributesBgColor_R,@THTMLTableElementAttributesBgColor_W,'BgColor');
    RegisterPropertyHelper(@THTMLTableElementAttributesVAlign_R,@THTMLTableElementAttributesVAlign_W,'VAlign');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTMLTableAttributes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTMLTableAttributes) do
  begin
    RegisterConstructor(@THTMLTableAttributes.Create, 'Create');
    RegisterMethod(@THTMLTableAttributes.RestoreDefaults, 'RestoreDefaults');
    RegisterPropertyHelper(@THTMLTableAttributesAlign_R,@THTMLTableAttributesAlign_W,'Align');
    RegisterPropertyHelper(@THTMLTableAttributesBgColor_R,@THTMLTableAttributesBgColor_W,'BgColor');
    RegisterPropertyHelper(@THTMLTableAttributesBorder_R,@THTMLTableAttributesBorder_W,'Border');
    RegisterPropertyHelper(@THTMLTableAttributesCellSpacing_R,@THTMLTableAttributesCellSpacing_W,'CellSpacing');
    RegisterPropertyHelper(@THTMLTableAttributesCellPadding_R,@THTMLTableAttributesCellPadding_W,'CellPadding');
    RegisterPropertyHelper(@THTMLTableAttributesWidth_R,@THTMLTableAttributesWidth_W,'Width');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTMLTagAttributes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTMLTagAttributes) do
  begin
    RegisterConstructor(@THTMLTagAttributes.Create, 'Create');
    RegisterVirtualMethod(@THTMLTagAttributes.RestoreDefaults, 'RestoreDefaults');
    RegisterPropertyHelper(@THTMLTagAttributesProducer_R,nil,'Producer');
    RegisterPropertyHelper(@THTMLTagAttributesOnChange_R,@THTMLTagAttributesOnChange_W,'OnChange');
    RegisterPropertyHelper(@THTMLTagAttributesCustom_R,@THTMLTagAttributesCustom_W,'Custom');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_HTTPProd(CL: TPSRuntimeClassImporter);
begin
  RIRegister_THTMLTagAttributes(CL);
  RIRegister_THTMLTableAttributes(CL);
  RIRegister_THTMLTableElementAttributes(CL);
  RIRegister_THTMLTableHeaderAttributes(CL);
  with CL.Add(THTMLTableRowAttributes) do
  with CL.Add(THTMLTableCellAttributes) do
  RIRegister_TBasePageProducer(CL);
  RIRegister_TCustomPageProducer(CL);
  RIRegister_TPageProducer(CL);
  with CL.Add(TAbstractScriptProducer) do
  with CL.Add(TAbstractScriptErrors) do
  RIRegister_EScriptError(CL);
  RIRegister_TAbstractScriptError(CL);
  RIRegister_TAbstractScriptErrors(CL);
  RIRegister_TAbstractScriptProducer(CL);
  RIRegister_TAbstractScriptEnginesList(CL);
end;

 
 
{ TPSImport_HTTPProd }
(*----------------------------------------------------------------------------*)
procedure TPSImport_HTTPProd.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_HTTPProd(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_HTTPProd.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_HTTPProd(ri);
  RIRegister_HTTPProd_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.