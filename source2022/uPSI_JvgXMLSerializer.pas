unit uPSI_JvgXMLSerializer;
{
   XML to Persistent
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
  TPSImport_JvgXMLSerializer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvgXMLSerializer(CL: TPSPascalCompiler);
procedure SIRegister_JvgXMLSerializer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvgXMLSerializer(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvgXMLSerializer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
 //  JclUnitVersioning
  Windows
  //,Messages
  //,Graphics
  //,Controls
  //,Forms
  //,Dialogs
  //,ComCtrls
  //,TypInfo
  ,JvComponentBase
  ,JvgXMLSerializer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvgXMLSerializer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvgXMLSerializer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvgXMLSerializer') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvgXMLSerializer') do begin
    RegisterProperty('DefaultXMLHeader', 'string', iptrw);
    RegisterProperty('tickCounter', 'DWORD', iptrw);
    RegisterProperty('tickCount', 'DWORD', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Serialize( Component : TObject; Stream : TStream)');
    RegisterMethod('Procedure DeSerialize( Component : TObject; Stream : TStream)');
    RegisterMethod('Procedure GenerateDTD( Component : TObject; Stream : TStream)');
    RegisterProperty('GenerateFormattedXML', 'Boolean', iptrw);
    RegisterProperty('ExcludeEmptyValues', 'Boolean', iptrw);
    RegisterProperty('ExcludeDefaultValues', 'Boolean', iptrw);
    RegisterProperty('ReplaceReservedSymbols', 'Boolean', iptrw);
    RegisterProperty('StrongConformity', 'Boolean', iptrw);
    RegisterProperty('IgnoreUnknownTags', 'Boolean', iptrw);
    RegisterProperty('WrapCollections', 'Boolean', iptrw);
    RegisterProperty('OnGetXMLHeader', 'TOnGetXMLHeader', iptrw);
    RegisterProperty('BeforeParsing', 'TBeforeParsingEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvgXMLSerializer(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TOnGetXMLHeader', 'Procedure ( Sender : TObject; var Value : string)');
  CL.AddTypeS('TBeforeParsingEvent', 'Procedure ( Sender : TObject; Buffer : PChar)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJvgXMLSerializerException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'XMLSerializerException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJvgXMLOpenTagNotFoundException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJvgXMLCloseTagNotFoundException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJvgXMLUnknownPropertyException');
  //CL.AddTypeS('TJvgXMLSerializerException', 'class of XMLSerializerException');
  SIRegister_TJvgXMLSerializer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerBeforeParsing_W(Self: TJvgXMLSerializer; const T: TBeforeParsingEvent);
begin Self.BeforeParsing := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerBeforeParsing_R(Self: TJvgXMLSerializer; var T: TBeforeParsingEvent);
begin T := Self.BeforeParsing; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerOnGetXMLHeader_W(Self: TJvgXMLSerializer; const T: TOnGetXMLHeader);
begin Self.OnGetXMLHeader := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerOnGetXMLHeader_R(Self: TJvgXMLSerializer; var T: TOnGetXMLHeader);
begin T := Self.OnGetXMLHeader; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerWrapCollections_W(Self: TJvgXMLSerializer; const T: Boolean);
begin Self.WrapCollections := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerWrapCollections_R(Self: TJvgXMLSerializer; var T: Boolean);
begin T := Self.WrapCollections; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerIgnoreUnknownTags_W(Self: TJvgXMLSerializer; const T: Boolean);
begin Self.IgnoreUnknownTags := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerIgnoreUnknownTags_R(Self: TJvgXMLSerializer; var T: Boolean);
begin T := Self.IgnoreUnknownTags; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerStrongConformity_W(Self: TJvgXMLSerializer; const T: Boolean);
begin Self.StrongConformity := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerStrongConformity_R(Self: TJvgXMLSerializer; var T: Boolean);
begin T := Self.StrongConformity; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerReplaceReservedSymbols_W(Self: TJvgXMLSerializer; const T: Boolean);
begin Self.ReplaceReservedSymbols := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerReplaceReservedSymbols_R(Self: TJvgXMLSerializer; var T: Boolean);
begin T := Self.ReplaceReservedSymbols; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerExcludeDefaultValues_W(Self: TJvgXMLSerializer; const T: Boolean);
begin Self.ExcludeDefaultValues := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerExcludeDefaultValues_R(Self: TJvgXMLSerializer; var T: Boolean);
begin T := Self.ExcludeDefaultValues; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerExcludeEmptyValues_W(Self: TJvgXMLSerializer; const T: Boolean);
begin Self.ExcludeEmptyValues := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerExcludeEmptyValues_R(Self: TJvgXMLSerializer; var T: Boolean);
begin T := Self.ExcludeEmptyValues; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerGenerateFormattedXML_W(Self: TJvgXMLSerializer; const T: Boolean);
begin Self.GenerateFormattedXML := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerGenerateFormattedXML_R(Self: TJvgXMLSerializer; var T: Boolean);
begin T := Self.GenerateFormattedXML; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializertickCount_W(Self: TJvgXMLSerializer; const T: DWORD);
Begin Self.tickCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializertickCount_R(Self: TJvgXMLSerializer; var T: DWORD);
Begin T := Self.tickCount; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializertickCounter_W(Self: TJvgXMLSerializer; const T: DWORD);
Begin Self.tickCounter := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializertickCounter_R(Self: TJvgXMLSerializer; var T: DWORD);
Begin T := Self.tickCounter; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerDefaultXMLHeader_W(Self: TJvgXMLSerializer; const T: string);
Begin Self.DefaultXMLHeader := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvgXMLSerializerDefaultXMLHeader_R(Self: TJvgXMLSerializer; var T: string);
Begin T := Self.DefaultXMLHeader; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvgXMLSerializer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvgXMLSerializer) do
  begin
    RegisterPropertyHelper(@TJvgXMLSerializerDefaultXMLHeader_R,@TJvgXMLSerializerDefaultXMLHeader_W,'DefaultXMLHeader');
    RegisterPropertyHelper(@TJvgXMLSerializertickCounter_R,@TJvgXMLSerializertickCounter_W,'tickCounter');
    RegisterPropertyHelper(@TJvgXMLSerializertickCount_R,@TJvgXMLSerializertickCount_W,'tickCount');
    RegisterConstructor(@TJvgXMLSerializer.Create, 'Create');
    RegisterMethod(@TJvgXMLSerializer.Serialize, 'Serialize');
    RegisterMethod(@TJvgXMLSerializer.DeSerialize, 'DeSerialize');
    RegisterMethod(@TJvgXMLSerializer.GenerateDTD, 'GenerateDTD');
    RegisterPropertyHelper(@TJvgXMLSerializerGenerateFormattedXML_R,@TJvgXMLSerializerGenerateFormattedXML_W,'GenerateFormattedXML');
    RegisterPropertyHelper(@TJvgXMLSerializerExcludeEmptyValues_R,@TJvgXMLSerializerExcludeEmptyValues_W,'ExcludeEmptyValues');
    RegisterPropertyHelper(@TJvgXMLSerializerExcludeDefaultValues_R,@TJvgXMLSerializerExcludeDefaultValues_W,'ExcludeDefaultValues');
    RegisterPropertyHelper(@TJvgXMLSerializerReplaceReservedSymbols_R,@TJvgXMLSerializerReplaceReservedSymbols_W,'ReplaceReservedSymbols');
    RegisterPropertyHelper(@TJvgXMLSerializerStrongConformity_R,@TJvgXMLSerializerStrongConformity_W,'StrongConformity');
    RegisterPropertyHelper(@TJvgXMLSerializerIgnoreUnknownTags_R,@TJvgXMLSerializerIgnoreUnknownTags_W,'IgnoreUnknownTags');
    RegisterPropertyHelper(@TJvgXMLSerializerWrapCollections_R,@TJvgXMLSerializerWrapCollections_W,'WrapCollections');
    RegisterPropertyHelper(@TJvgXMLSerializerOnGetXMLHeader_R,@TJvgXMLSerializerOnGetXMLHeader_W,'OnGetXMLHeader');
    RegisterPropertyHelper(@TJvgXMLSerializerBeforeParsing_R,@TJvgXMLSerializerBeforeParsing_W,'BeforeParsing');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvgXMLSerializer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJvgXMLSerializerException) do
  with CL.Add(XMLSerializerException) do
  with CL.Add(EJvgXMLOpenTagNotFoundException) do
  with CL.Add(EJvgXMLCloseTagNotFoundException) do
  with CL.Add(EJvgXMLUnknownPropertyException) do
  RIRegister_TJvgXMLSerializer(CL);
end;

 
 
{ TPSImport_JvgXMLSerializer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvgXMLSerializer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvgXMLSerializer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvgXMLSerializer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvgXMLSerializer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
