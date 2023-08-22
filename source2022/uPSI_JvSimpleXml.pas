unit uPSI_JvSimpleXml;
{
 in comparison to jclsimpleXML   , added with maxpixel
 add domtotree , domtotreeJ for REST
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
  TPSImport_JvSimpleXml = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvItemsSearchs(CL: TPSPascalCompiler);
procedure SIRegister_TJvMaxPixel(CL: TPSPascalCompiler);

procedure SIRegister_TJvSimpleXML(CL: TPSPascalCompiler);
procedure SIRegister_TJclHackSimpleXML(CL: TPSPascalCompiler);
procedure SIRegister_JvSimpleXml(CL: TPSPascalCompiler);

{ run-time registration functions }

procedure RIRegister_TJvItemsSearchs(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvMaxPixel(CL: TPSRuntimeClassImporter);

procedure RIRegister_TJvSimpleXML(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclHackSimpleXML(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvSimpleXml(CL: TPSRuntimeClassImporter);

procedure RIRegister_JvSimpleXml_Routines(S: TPSExec);


procedure Register;

implementation


uses
   Windows
  ,Variants
  ,Graphics
  //,JclUnitVersioning
  ,JclSimpleXml
  //,JclStreams
  ,JvSimpleXml
  ,JvMaxPixel
  ,JvItemsSearchs
  ,xmldom, XMLIntf, XMLDoc, ComCtrls, JvXmlTree

  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvSimpleXml]);
end;


procedure DomToTree(anXmlNode: IXMLNode; aTreeNode: TTreeNode; aTreeView: TTreeView);
var
  I: Integer;
  NewTreeNode: TTreeNode;
  NodeText: string;
  AttrNode: IXMLNode;
begin
  // skip text nodes and other special cases
  if anXmlNode.NodeType <> ntElement then
    Exit;
  // add the node itself
  NodeText := anXmlNode.NodeName;
  if anXmlNode.IsTextElement then
    NodeText := NodeText + ' = ' + anXmlNode.NodeValue;
  NewTreeNode := aTreeView.Items.AddChild(aTreeNode, NodeText);
  // add attributes
  for I := 0 to anXmlNode.AttributeNodes.Count - 1 do begin
    AttrNode := anXmlNode.AttributeNodes.Nodes[I];
    aTreeView.Items.AddChild(NewTreeNode,
      '[' + AttrNode.NodeName + ' = "' + AttrNode.Text + '"]');
  end;
  // add each child node
  if anXmlNode.HasChildNodes then
    for I := 0 to anXmlNode.ChildNodes.Count - 1 do
      DomToTree (anXmlNode.ChildNodes.Nodes [I], NewTreeNode, aTreeView);
end;

procedure DomToTreeJ(anXmlNode: TJvXMLTree; aTreeNode: TTreeNode; aTreeView: TTreeView);
var
  I: Integer;
  NewTreeNode: TTreeNode;
  NodeText: string;
  //AttrNode: TJVXMLTree;
  AttrNode: TJVXMLNode;

begin
  // skip text nodes and other special cases
  if anXmlNode.NodeCount = 0 then
    Exit;
  // add the node itself
  NodeText := anXmlNode.Name;
  if anXmlNode.ValueType = xvtString then
    NodeText := NodeText + ' = ' + anXmlNode.Value;
  NewTreeNode := aTreeView.Items.AddChild(aTreeNode, NodeText);
  // add attributes
  for I := 0 to anXmlNode.Attributes.Count - 1 do begin
    AttrNode := anXmlNode.Attributes[I];
    aTreeView.Items.AddChild(NewTreeNode,
      '[' + AttrNode.Name + ' = "' + AttrNode.Value + '"]');
  end;
  // add each child node
  if anXmlNode.HasChildNodes then
    for I := 0 to anXmlNode.NodeCount - 1 do
      DomToTreeJ(anXmlNode.Nodes[I], NewTreeNode, aTreeView);
    //for I := 0 to anXmlNode.NodeCount - 1 do
      //DomToTreeJ(TJVXMLNode(anXmlNode.Nodes[i]).NextSibling, NewTreeNode, aTreeView);

end;

const numNamesA:array[1..17] of string =
	(
	('ein'),
	('zwei'),
	('drei'),
	('vier'),
	('fünf'),
	('sechs'),
	('sieben'),
	('acht'),
	('neun'),
	('zehn'),
	('elf'),
	('zwölf'),
	('dreizehn'),
	('vierzehn'),
	('fünfzehn'),
	('sechzehn'),
	('siebzehn')
	);



const numNamesB:array[1..9] of string =
	(
	('zehn'),
	('zwanzig'),
	('dreissig'),
	('vierzig'),
	('fünfzig'),
	('sechzig'),
	('siebzig'),
	('achtzig'),
	('neunzig')
	);

const hundert:string = 'hundert';
const tausend = 'tausend';
const und = 'und';
const million = 'million';




function ConvInteger(i : integer):string;
var
	j : integer;
begin
	if i = 0 then
		Result := ''
	else if i <= 17 then
		Result := numNamesA[i]
	else if i < 20 then
		Result := numNamesA[i mod 10] + numNamesB[1]
	else if i < 100 then
	begin
		if (i mod 10) = 0 then
			Result := numNamesB[i div 10]
		else
			Result := numNamesA[i mod 10] + und + numNamesB[i div 10];
	end
	else if i < 1000 then
		Result := convinteger(i div 100) + hundert + convinteger(i mod 100)
	else if i < 1000000 then
		Result := convinteger(i div 1000) + tausend + convinteger(i mod 1000)
	else
	begin
		j:= i div 1000000;

		if j = 1 then
			Result := 'eine'
		else
			 Result := convinteger(j);
		Result := Result + million;
		if j > 1 then
			Result := Result +'en';
		Result := Result + convinteger(i mod 1000000);
	end;
end;


function IntegerToText(i : integer):string;
begin
	if i < 0 then
		Result := 'minus ' + IntegerToText(-i)
	else if i = 0 then
		Result := 'null'
	else if i = 1 then
		Result := 'eins'
	else
		Result := convinteger(i);
end;




(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvMaxPixel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvMaxPixel') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvMaxPixel') do begin
    RegisterProperty('OnChanged', 'TNotifyEvent', iptrw);
    RegisterMethod('Procedure Test( var Value : string; ParentFont : TFont)');
    RegisterMethod('Constructor Create( AOwner : TControl)');
    RegisterProperty('Length', 'Integer', iptrw);
    RegisterProperty('UseControlFont', 'Boolean', iptrw);
    RegisterProperty('Font', 'TFont', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvMaxPixel(CL: TPSPascalCompiler);
begin
  SIRegister_TJvMaxPixel(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvMaxPixelFont_W(Self: TJvMaxPixel; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMaxPixelFont_R(Self: TJvMaxPixel; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TJvMaxPixelUseControlFont_W(Self: TJvMaxPixel; const T: Boolean);
begin Self.UseControlFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMaxPixelUseControlFont_R(Self: TJvMaxPixel; var T: Boolean);
begin T := Self.UseControlFont; end;

(*----------------------------------------------------------------------------*)
procedure TJvMaxPixelLength_W(Self: TJvMaxPixel; const T: Integer);
begin Self.Length := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMaxPixelLength_R(Self: TJvMaxPixel; var T: Integer);
begin T := Self.Length; end;

(*----------------------------------------------------------------------------*)
procedure TJvMaxPixelOnChanged_W(Self: TJvMaxPixel; const T: TNotifyEvent);
begin Self.OnChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMaxPixelOnChanged_R(Self: TJvMaxPixel; var T: TNotifyEvent);
begin T := Self.OnChanged; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvMaxPixel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvMaxPixel) do begin
    RegisterPropertyHelper(@TJvMaxPixelOnChanged_R,@TJvMaxPixelOnChanged_W,'OnChanged');
    RegisterMethod(@TJvMaxPixel.Test, 'Test');
    RegisterConstructor(@TJvMaxPixel.Create, 'Create');
    RegisterPropertyHelper(@TJvMaxPixelLength_R,@TJvMaxPixelLength_W,'Length');
    RegisterPropertyHelper(@TJvMaxPixelUseControlFont_R,@TJvMaxPixelUseControlFont_W,'UseControlFont');
    RegisterPropertyHelper(@TJvMaxPixelFont_R,@TJvMaxPixelFont_W,'Font');
  end;
end;

procedure SIRegister_TJvItemsSearchs(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvItemsSearchs') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvItemsSearchs') do begin
    RegisterMethod('Function SearchExactString( Items : TStrings; Value : string; CaseSensitive : Boolean) : Integer');
    RegisterMethod('Function SearchPrefix( Items : TStrings; Value : string; CaseSensitive : Boolean) : Integer');
    RegisterMethod('Function SearchSubString( Items : TStrings; Value : string; CaseSensitive : Boolean) : Integer');
    RegisterMethod('Function DeleteExactString( Items : TStrings; Value : string; All : Boolean; CaseSensitive : Boolean) : Integer');
  end;
end;

procedure RIRegister_TJvItemsSearchs(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvItemsSearchs) do begin
    RegisterMethod(@TJvItemsSearchs.SearchExactString, 'SearchExactString');
    RegisterMethod(@TJvItemsSearchs.SearchPrefix, 'SearchPrefix');
    RegisterMethod(@TJvItemsSearchs.SearchSubString, 'SearchSubString');
    RegisterMethod(@TJvItemsSearchs.DeleteExactString, 'DeleteExactString');
  end;
end;



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSimpleXML(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TJvSimpleXML') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TJvSimpleXML') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure LoadFromString( const Value : string)');
    RegisterMethod('Procedure LoadFromFile( const FileName : TFileName)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromResourceName( Instance : THandle; const ResName : string)');
    RegisterMethod('Procedure SaveToFile( FileName : TFileName; Encoding : TJclStringEncoding; CodePage : Word)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream; Encoding : TJclStringEncoding; CodePage : Word)');
    RegisterMethod('Function SaveToString : string');
    RegisterProperty('Prolog', 'TJvSimpleXMLElemsProlog', iptrw);
    RegisterProperty('Root', 'TJvSimpleXMLElemClassic', iptrw);
    RegisterProperty('XMLData', 'string', iptrw);
    RegisterProperty('FileName', 'TFileName', iptrw);
    RegisterProperty('IndentString', 'string', iptrw);
    RegisterProperty('Options', 'TJvSimpleXMLOptions', iptrw);
    RegisterProperty('OnSaveProgress', 'TJvOnSimpleProgress', iptrw);
    RegisterProperty('OnLoadProgress', 'TJvOnSimpleProgress', iptrw);
    RegisterProperty('OnTagParsed', 'TJvOnSimpleXMLParsed', iptrw);
    RegisterProperty('OnValueParsed', 'TJvOnValueParsed', iptrw);
    RegisterProperty('OnEncodeValue', 'TJvSimpleXMLEncodeEvent', iptrw);
    RegisterProperty('OnDecodeValue', 'TJvSimpleXMLEncodeEvent', iptrw);
    RegisterProperty('OnEncodeStream', 'TJvSimpleXMLEncodeStreamEvent', iptrw);
    RegisterProperty('OnDecodeStream', 'TJvSimpleXMLEncodeStreamEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclHackSimpleXML(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclSimpleXML', 'TJclHackSimpleXML') do
  with CL.AddClassN(CL.FindClass('TJclSimpleXML'),'TJclHackSimpleXML') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvSimpleXml(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('IXMLNode', 'IInterface');
  //CL.AddTypeS('IXMLNode', 'Interface');
  CL.AddTypeS('TJclStringEncoding','(seAnsi,seUTF8,seUTF16,seAuto)');
  CL.AddTypeS('TJvOnSimpleXMLParsed', 'TJclOnSimpleXMLParsed');
  CL.AddTypeS('TJvOnValueParsed', 'TJclOnValueParsed');
  CL.AddTypeS('TJvOnSimpleProgress', 'TJclOnSimpleProgress');
  CL.AddTypeS('TJvSimpleXMLElem', 'TJclSimpleXMLElem');
  CL.AddTypeS('TJvSimpleXMLElemCData', 'TJclSimpleXMLElemCData');
  //CL.AddTypeS('TJvSimpleXMLElemClass', 'TJclSimpleXMLElemClass');
  CL.AddTypeS('TJvSimpleXMLElemClassic', 'TJclSimpleXMLElemClassic');
  CL.AddTypeS('TJvSimpleXMLElemComment', 'TJclSimpleXMLElemComment');
  CL.AddTypeS('TJvSimpleXMLElemCompare', 'TJclSimpleXMLElemCompare');
  CL.AddTypeS('TJvSimpleXMLElemDocType', 'TJclSimpleXMLElemDocType');
  CL.AddTypeS('TJvSimpleXMLElemHeader', 'TJclSimpleXMLElemHeader');
  CL.AddTypeS('TJvSimpleXMLElemText', 'TJclSimpleXMLElemText');
  CL.AddTypeS('TJvSimpleXMLElems', 'TJclSimpleXMLElems');
  CL.AddTypeS('TJvSimpleXMLElemSheet', 'TJclSimpleXMLElemSheet');
  CL.AddTypeS('TJvSimpleXMLElemsProlog', 'TJclSimpleXMLElemsProlog');
  CL.AddTypeS('EJvSimpleXMLError', 'EJclSimpleXMLError');
  CL.AddTypeS('TJvSimpleXMLProp', 'TJclSimpleXMLProp');
  CL.AddTypeS('TJvSimpleXMLProps', 'TJclSimpleXMLProps');
  CL.AddTypeS('TJvHashKind', 'TJclHashKind');
  //CL.AddTypeS('TJvHashElem', 'TJclHashElem');
 // CL.AddTypeS('PJvHashElem', 'PJclHashElem');
  CL.AddTypeS('TJvHashRecord', 'TJclHashRecord');
  //CL.AddTypeS('PJvHashRecord', 'PJclHashRecord');
  //CL.AddTypeS('TJvHashList', 'TJclHashList');
  //CL.AddTypeS('PJvHashList', 'PJclHashList');
  CL.AddClassN(CL.FindClass('TJvXMLNode'),'TJvXMLTree');
  CL.AddTypeS('TJvSimpleXMLOptions', 'TJclSimpleXMLOptions');
  CL.AddTypeS('TJvSimpleXMLEncodeEvent', 'TJclSimpleXMLEncodeEvent');
  CL.AddTypeS('TJvSimpleXMLEncodeStreamEvent', 'TJclSimpleXMLEncodeStreamEvent');
  SIRegister_TJclHackSimpleXML(CL);
  SIRegister_TJvSimpleXML(CL);
  SIRegister_TJvMaxPixel(CL);  //-->TJvMaxPixel(CL);
  SIRegister_TJvItemsSearchs(CL);
  CL.AddDelphiFunction('Procedure DomToTree(anXmlNode:IXMLNode; aTreeNode:TTreeNode; aTreeView: TTreeView)');
  CL.AddDelphiFunction('Procedure DomToTreeJ(anXmlNode:TJvXMLTree; aTreeNode:TTreeNode; aTreeView: TTreeView)');
  CL.AddDelphiFunction('function convinteger(i : integer):string;');
 CL.AddDelphiFunction('function IntegerToText(i : integer):string;');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLOnDecodeStream_W(Self: TJvSimpleXML; const T: TJvSimpleXMLEncodeStreamEvent);
begin Self.OnDecodeStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLOnDecodeStream_R(Self: TJvSimpleXML; var T: TJvSimpleXMLEncodeStreamEvent);
begin T := Self.OnDecodeStream; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLOnEncodeStream_W(Self: TJvSimpleXML; const T: TJvSimpleXMLEncodeStreamEvent);
begin Self.OnEncodeStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLOnEncodeStream_R(Self: TJvSimpleXML; var T: TJvSimpleXMLEncodeStreamEvent);
begin T := Self.OnEncodeStream; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLOnDecodeValue_W(Self: TJvSimpleXML; const T: TJvSimpleXMLEncodeEvent);
begin Self.OnDecodeValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLOnDecodeValue_R(Self: TJvSimpleXML; var T: TJvSimpleXMLEncodeEvent);
begin T := Self.OnDecodeValue; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLOnEncodeValue_W(Self: TJvSimpleXML; const T: TJvSimpleXMLEncodeEvent);
begin Self.OnEncodeValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLOnEncodeValue_R(Self: TJvSimpleXML; var T: TJvSimpleXMLEncodeEvent);
begin T := Self.OnEncodeValue; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLOnValueParsed_W(Self: TJvSimpleXML; const T: TJvOnValueParsed);
begin Self.OnValueParsed := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLOnValueParsed_R(Self: TJvSimpleXML; var T: TJvOnValueParsed);
begin T := Self.OnValueParsed; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLOnTagParsed_W(Self: TJvSimpleXML; const T: TJvOnSimpleXMLParsed);
begin Self.OnTagParsed := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLOnTagParsed_R(Self: TJvSimpleXML; var T: TJvOnSimpleXMLParsed);
begin T := Self.OnTagParsed; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLOnLoadProgress_W(Self: TJvSimpleXML; const T: TJvOnSimpleProgress);
begin Self.OnLoadProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLOnLoadProgress_R(Self: TJvSimpleXML; var T: TJvOnSimpleProgress);
begin T := Self.OnLoadProgress; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLOnSaveProgress_W(Self: TJvSimpleXML; const T: TJvOnSimpleProgress);
begin Self.OnSaveProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLOnSaveProgress_R(Self: TJvSimpleXML; var T: TJvOnSimpleProgress);
begin T := Self.OnSaveProgress; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLOptions_W(Self: TJvSimpleXML; const T: TJvSimpleXMLOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLOptions_R(Self: TJvSimpleXML; var T: TJvSimpleXMLOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLIndentString_W(Self: TJvSimpleXML; const T: string);
begin Self.IndentString := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLIndentString_R(Self: TJvSimpleXML; var T: string);
begin T := Self.IndentString; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLFileName_W(Self: TJvSimpleXML; const T: TFileName);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLFileName_R(Self: TJvSimpleXML; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLXMLData_W(Self: TJvSimpleXML; const T: string);
begin Self.XMLData := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLXMLData_R(Self: TJvSimpleXML; var T: string);
begin T := Self.XMLData; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLRoot_W(Self: TJvSimpleXML; const T: TJvSimpleXMLElemClassic);
begin Self.Root := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLRoot_R(Self: TJvSimpleXML; var T: TJvSimpleXMLElemClassic);
begin T := Self.Root; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLProlog_W(Self: TJvSimpleXML; const T: TJvSimpleXMLElemsProlog);
begin Self.Prolog := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimpleXMLProlog_R(Self: TJvSimpleXML; var T: TJvSimpleXMLElemsProlog);
begin T := Self.Prolog; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSimpleXML(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSimpleXML) do begin
    RegisterConstructor(@TJvSimpleXML.Create, 'Create');
    RegisterMethod(@TJvSimpleXML.Destroy, 'Free');
    RegisterMethod(@TJvSimpleXML.LoadFromString, 'LoadFromString');
    RegisterMethod(@TJvSimpleXML.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TJvSimpleXML.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TJvSimpleXML.LoadFromResourceName, 'LoadFromResourceName');
    RegisterMethod(@TJvSimpleXML.SaveToFile, 'SaveToFile');
    RegisterMethod(@TJvSimpleXML.SaveToStream, 'SaveToStream');
    RegisterMethod(@TJvSimpleXML.SaveToString, 'SaveToString');
    RegisterPropertyHelper(@TJvSimpleXMLProlog_R,@TJvSimpleXMLProlog_W,'Prolog');
    RegisterPropertyHelper(@TJvSimpleXMLRoot_R,@TJvSimpleXMLRoot_W,'Root');
    RegisterPropertyHelper(@TJvSimpleXMLXMLData_R,@TJvSimpleXMLXMLData_W,'XMLData');
    RegisterPropertyHelper(@TJvSimpleXMLFileName_R,@TJvSimpleXMLFileName_W,'FileName');
    RegisterPropertyHelper(@TJvSimpleXMLIndentString_R,@TJvSimpleXMLIndentString_W,'IndentString');
    RegisterPropertyHelper(@TJvSimpleXMLOptions_R,@TJvSimpleXMLOptions_W,'Options');
    RegisterPropertyHelper(@TJvSimpleXMLOnSaveProgress_R,@TJvSimpleXMLOnSaveProgress_W,'OnSaveProgress');
    RegisterPropertyHelper(@TJvSimpleXMLOnLoadProgress_R,@TJvSimpleXMLOnLoadProgress_W,'OnLoadProgress');
    RegisterPropertyHelper(@TJvSimpleXMLOnTagParsed_R,@TJvSimpleXMLOnTagParsed_W,'OnTagParsed');
    RegisterPropertyHelper(@TJvSimpleXMLOnValueParsed_R,@TJvSimpleXMLOnValueParsed_W,'OnValueParsed');
    RegisterPropertyHelper(@TJvSimpleXMLOnEncodeValue_R,@TJvSimpleXMLOnEncodeValue_W,'OnEncodeValue');
    RegisterPropertyHelper(@TJvSimpleXMLOnDecodeValue_R,@TJvSimpleXMLOnDecodeValue_W,'OnDecodeValue');
    RegisterPropertyHelper(@TJvSimpleXMLOnEncodeStream_R,@TJvSimpleXMLOnEncodeStream_W,'OnEncodeStream');
    RegisterPropertyHelper(@TJvSimpleXMLOnDecodeStream_R,@TJvSimpleXMLOnDecodeStream_W,'OnDecodeStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclHackSimpleXML(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclHackSimpleXML) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvSimpleXml(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJclHackSimpleXML(CL);
  RIRegister_TJvSimpleXML(CL);
  RIRegister_TJvMaxPixel(CL);
  RIRegister_TJvItemsSearchs(CL);

end;

procedure RIRegister_JvSimpleXml_Routines(S: TPSExec);
begin
  S.RegisterDelphiFunction(@DomToTree, 'DomToTree', CdRegister);
  S.RegisterDelphiFunction(@DomToTreeJ, 'DomToTreeJ', CdRegister);
  S.RegisterDelphiFunction(@convinteger, 'convinteger', CdRegister);
  S.RegisterDelphiFunction(@IntegerToText, 'IntegerToText', CdRegister);



end;



{ TPSImport_JvSimpleXml }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSimpleXml.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvSimpleXml(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSimpleXml.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvSimpleXml(ri);
  RIRegister_JvSimpleXml_Routines(CompExec.Exec); // add to domtree

end;
(*----------------------------------------------------------------------------*)
 
 
end.
