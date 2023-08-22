unit uPSI_XmlVerySimple;
{
  for REST Framework mXREST   change node name txmlnodesimple
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
  TPSImport_XmlVerySimple = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

 
{ compile-time registration functions }
procedure SIRegister_TXmlVerySimple(CL: TPSPascalCompiler);
procedure SIRegister_TXmlNodeSimple(CL: TPSPascalCompiler);
procedure SIRegister_TXmlAttributeList(CL: TPSPascalCompiler);
procedure SIRegister_TXmlAttribute(CL: TPSPascalCompiler);
procedure SIRegister_XmlVerySimple(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TXmlVerySimple(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXmlNodeSimple(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXmlAttributeList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXmlAttribute(CL: TPSRuntimeClassImporter);
procedure RIRegister_XmlVerySimple(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // Defaults
  //,Collections
  XmlVerySimple
  ;
 

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_XmlVerySimple]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXmlVerySimple(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TXmlVerySimple') do
  with CL.AddClassN(CL.FindClass('TObject'),'TXmlVerySimple') do begin
    RegisterProperty('Root', 'TXmlNodeSimple', iptrw);
    RegisterProperty('Header', 'TXmlNodeSimple', iptrw);
    RegisterProperty('Ident', 'String', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure LoadFromFile( const FileName : String)');
    RegisterMethod('Procedure LoadFromStream( const Stream : TStream)');
    RegisterMethod('Procedure SaveToStream( const Stream : TStream)');
    RegisterMethod('Procedure SaveToFile( const FileName : String)');
    RegisterMethod('Procedure DefaultOnNodeSetText( Sender : TObject; Node : TXmlNodeSimple; Text : String)');
    RegisterMethod('Procedure DefaultOnNodeSetName( Sender : TObject; Node : TXmlNodeSimple; Name : String)');
    RegisterProperty('Text', 'String', iptrw);
    RegisterProperty('OnNodeSetText', 'TXmlOnNodeSetText', iptrw);
    RegisterProperty('OnNodeSetName', 'TXmlOnNodeSetText', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXmlNodeSimple(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectlist', 'TXmlNode') do
  with CL.AddClassN(CL.FindClass('TObject'),'TXmlNodeSimple') do begin
    RegisterProperty('Parent', 'TXmlNodeSimple', iptrw);
    RegisterProperty('NodeName', 'String', iptrw);
    RegisterProperty('ChildNodes', 'TXmlNodeListSimple', iptrw);
    RegisterProperty('Text', 'String', iptrw);
    RegisterProperty('Obj', 'TObject', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Find( Name : String) : TXmlNodeSimple;');
    RegisterMethod('Function Find1( Name, Attribute : String) : TXmlNodeSimple;');
    RegisterMethod('Function Find2( Name, Attribute, Value : String) : TXmlNodeSimple;');
    RegisterMethod('Function FindNodes( Name : String) : TXmlNodeListSimple');
    RegisterMethod('Function HasAttribute( const Name : String) : Boolean');
    RegisterMethod('Function HasChild( const Name : String) : Boolean');
    RegisterMethod('Function AddChild( const Name : String) : TXmlNodeSimple');
    RegisterMethod('Function InsertChild( const Name : String; Pos : Integer) : TXmlNodeSimple');
    RegisterMethod('Function SetText( Value : String) : TXmlNodeSimple');
    RegisterMethod('Function SetAttribute( const AttrName : String; const Value : String) : TXmlNodeSimple');
    RegisterProperty('Attribute', 'String String', iptrw);
    RegisterProperty('Attributes', 'TXMLAttributeList', iptr);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXmlAttributeList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXmlAttribute', 'TXmlAttributeList') do
  with CL.AddClassN(CL.FindClass('TObjectList'),'TXmlAttributeList') do begin
    RegisterMethod('Function Find( AttrName : String) : TXmlAttribute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXmlAttribute(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectlist', 'TXmlAttribute') do
  with CL.AddClassN(CL.FindClass('TObject'),'TXmlAttribute') do begin
    RegisterProperty('Name', 'String', iptrw);
    RegisterProperty('Value', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_XmlVerySimple(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECTlist'),'TXmlNodeListSimple');
  SIRegister_TXmlAttribute(CL);
  SIRegister_TXmlAttributeList(CL);
  SIRegister_TXmlNodeSimple(CL);
  CL.AddClassN(CL.FindClass('TOBJECTlist'),'TXmlNodeListSimple');
  CL.AddTypeS('TXmlOnNodeSetText', 'Procedure(Sender: TObject; Node : TXmlNodeSimple; Text : String)');
  SIRegister_TXmlVerySimple(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TXmlVerySimpleOnNodeSetName_W(Self: TXmlVerySimple; const T: TXmlOnNodeSetText);
begin Self.OnNodeSetName := T; end;

(*----------------------------------------------------------------------------*)
procedure TXmlVerySimpleOnNodeSetName_R(Self: TXmlVerySimple; var T: TXmlOnNodeSetText);
begin T := Self.OnNodeSetName; end;

(*----------------------------------------------------------------------------*)
procedure TXmlVerySimpleOnNodeSetText_W(Self: TXmlVerySimple; const T: TXmlOnNodeSetText);
begin Self.OnNodeSetText := T; end;

(*----------------------------------------------------------------------------*)
procedure TXmlVerySimpleOnNodeSetText_R(Self: TXmlVerySimple; var T: TXmlOnNodeSetText);
begin T := Self.OnNodeSetText; end;

(*----------------------------------------------------------------------------*)
procedure TXmlVerySimpleText_W(Self: TXmlVerySimple; const T: String);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TXmlVerySimpleText_R(Self: TXmlVerySimple; var T: String);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TXmlVerySimpleIdent_W(Self: TXmlVerySimple; const T: String);
Begin Self.Ident := T; end;

(*----------------------------------------------------------------------------*)
procedure TXmlVerySimpleIdent_R(Self: TXmlVerySimple; var T: String);
Begin T := Self.Ident; end;

(*----------------------------------------------------------------------------*)
procedure TXmlVerySimpleHeader_W(Self: TXmlVerySimple; const T: TXmlNodeSimple);
Begin Self.Header := T; end;

(*----------------------------------------------------------------------------*)
procedure TXmlVerySimpleHeader_R(Self: TXmlVerySimple; var T: TXmlNodeSimple);
Begin T := Self.Header; end;

(*----------------------------------------------------------------------------*)
procedure TXmlVerySimpleRoot_W(Self: TXmlVerySimple; const T: TXmlNodeSimple);
Begin Self.Root := T; end;

(*----------------------------------------------------------------------------*)
procedure TXmlVerySimpleRoot_R(Self: TXmlVerySimple; var T: TXmlNodeSimple);
Begin T := Self.Root; end;

(*----------------------------------------------------------------------------*)
procedure TXmlNodeAttribute_W(Self: TXmlNodeSimple; const T: String; const t1: String);
begin Self.Attribute[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TXmlNodeAttribute_R(Self: TXmlNodeSimple; var T: String; const t1: String);
begin T := Self.Attribute[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TXmlNodeAttributes_R(Self: TXmlNodeSimple; var T: TXMLAttributeList);
begin T := Self.Attributes; end;

(*----------------------------------------------------------------------------*)
Function TXmlNodeFind2_P(Self: TXmlNodeSimple;  Name, Attribute, Value : String) : TXmlNodeSimple;
Begin Result := Self.Find(Name, Attribute, Value); END;

(*----------------------------------------------------------------------------*)
Function TXmlNodeFind1_P(Self: TXmlNodeSimple;  Name, Attribute : String) : TXmlNodeSimple;
Begin Result := Self.Find(Name, Attribute); END;

(*----------------------------------------------------------------------------*)
Function TXmlNodeFind_P(Self: TXmlNodeSimple;  Name : String) : TXmlNodeSimple;
Begin Result := Self.Find(Name); END;

(*----------------------------------------------------------------------------*)
procedure TXmlNodeObj_W(Self: TXmlNodeSimple; const T: TObject);
Begin Self.Obj := T; end;

(*----------------------------------------------------------------------------*)
procedure TXmlNodeObj_R(Self: TXmlNodeSimple; var T: TObject);
Begin T := Self.Obj; end;

(*----------------------------------------------------------------------------*)
procedure TXmlNodeText_W(Self: TXmlNodeSimple; const T: String);
Begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TXmlNodeText_R(Self: TXmlNodeSimple; var T: String);
Begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TXmlNodeChildNodes_W(Self: TXmlNodeSimple; const T: TXmlNodeListSimple);
Begin Self.ChildNodes := T; end;

(*----------------------------------------------------------------------------*)
procedure TXmlNodeChildNodes_R(Self: TXmlNodeSimple; var T: TXmlNodeListSimple);
Begin T := Self.ChildNodes; end;

(*----------------------------------------------------------------------------*)
procedure TXmlNodeNodeName_W(Self: TXmlNodeSimple; const T: String);
Begin Self.NodeName := T; end;

(*----------------------------------------------------------------------------*)
procedure TXmlNodeNodeName_R(Self: TXmlNodeSimple; var T: String);
Begin T := Self.NodeName; end;

(*----------------------------------------------------------------------------*)
procedure TXmlNodeParent_W(Self: TXmlNodeSimple; const T: TXmlNodeSimple);
Begin Self.Parent := T; end;

(*----------------------------------------------------------------------------*)
procedure TXmlNodeParent_R(Self: TXmlNodeSimple; var T: TXmlNodeSimple);
Begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TXmlAttributeValue_W(Self: TXmlAttribute; const T: String);
Begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TXmlAttributeValue_R(Self: TXmlAttribute; var T: String);
Begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TXmlAttributeName_W(Self: TXmlAttribute; const T: String);
Begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TXmlAttributeName_R(Self: TXmlAttribute; var T: String);
Begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXmlVerySimple(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXmlVerySimple) do begin
    RegisterPropertyHelper(@TXmlVerySimpleRoot_R,@TXmlVerySimpleRoot_W,'Root');
    RegisterPropertyHelper(@TXmlVerySimpleHeader_R,@TXmlVerySimpleHeader_W,'Header');
    RegisterPropertyHelper(@TXmlVerySimpleIdent_R,@TXmlVerySimpleIdent_W,'Ident');
    RegisterConstructor(@TXmlVerySimple.Create, 'Create');
    RegisterMethod(@TXmlVerySimple.Destroy, 'Free');
    RegisterVirtualMethod(@TXmlVerySimple.Clear, 'Clear');
    RegisterVirtualMethod(@TXmlVerySimple.LoadFromFile, 'LoadFromFile');
    RegisterVirtualMethod(@TXmlVerySimple.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TXmlVerySimple.SaveToStream, 'SaveToStream');
    RegisterVirtualMethod(@TXmlVerySimple.SaveToFile, 'SaveToFile');
    RegisterMethod(@TXmlVerySimple.DefaultOnNodeSetText, 'DefaultOnNodeSetText');
    RegisterMethod(@TXmlVerySimple.DefaultOnNodeSetName, 'DefaultOnNodeSetName');
    RegisterPropertyHelper(@TXmlVerySimpleText_R,@TXmlVerySimpleText_W,'Text');
    RegisterPropertyHelper(@TXmlVerySimpleOnNodeSetText_R,@TXmlVerySimpleOnNodeSetText_W,'OnNodeSetText');
    RegisterPropertyHelper(@TXmlVerySimpleOnNodeSetName_R,@TXmlVerySimpleOnNodeSetName_W,'OnNodeSetName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXmlNodeSimple(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXmlNodeSimple) do begin
    RegisterPropertyHelper(@TXmlNodeParent_R,@TXmlNodeParent_W,'Parent');
    RegisterPropertyHelper(@TXmlNodeNodeName_R,@TXmlNodeNodeName_W,'NodeName');
    RegisterPropertyHelper(@TXmlNodeChildNodes_R,@TXmlNodeChildNodes_W,'ChildNodes');
    RegisterPropertyHelper(@TXmlNodeText_R,@TXmlNodeText_W,'Text');
    RegisterPropertyHelper(@TXmlNodeObj_R,@TXmlNodeObj_W,'Obj');
    RegisterConstructor(@TXmlNodeSimple.Create, 'Create');
    RegisterMethod(@TXmlNodeSimple.Destroy, 'Free');
    RegisterMethod(@TXmlNodeFind_P, 'Find');
    RegisterMethod(@TXmlNodeFind1_P, 'Find1');
    RegisterMethod(@TXmlNodeFind2_P, 'Find2');
    RegisterVirtualMethod(@TXmlNodeSimple.FindNodes, 'FindNodes');
    RegisterVirtualMethod(@TXmlNodeSimple.HasAttribute, 'HasAttribute');
    RegisterVirtualMethod(@TXmlNodeSimple.HasChild, 'HasChild');
    RegisterVirtualMethod(@TXmlNodeSimple.AddChild, 'AddChild');
    RegisterVirtualMethod(@TXmlNodeSimple.InsertChild, 'InsertChild');
    RegisterVirtualMethod(@TXmlNodeSimple.SetText, 'SetText');
    RegisterVirtualMethod(@TXmlNodeSimple.SetAttribute, 'SetAttribute');
    RegisterPropertyHelper(@TXmlNodeAttribute_R,@TXmlNodeAttribute_W,'Attribute');
    RegisterPropertyHelper(@TXmlNodeAttributes_R,NIL,'Attributes');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXmlAttributeList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXmlAttributeList) do begin
    RegisterMethod(@TXmlAttributeList.Find, 'Find');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXmlAttribute(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXmlAttribute) do begin
    RegisterPropertyHelper(@TXmlAttributeName_R,@TXmlAttributeName_W,'Name');
    RegisterPropertyHelper(@TXmlAttributeValue_R,@TXmlAttributeValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_XmlVerySimple(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXmlNodeListSimple) do
  RIRegister_TXmlAttribute(CL);
  RIRegister_TXmlAttributeList(CL);
  RIRegister_TXmlNodeSimple(CL);
  with CL.Add(TXmlNodeListSimple) do
  RIRegister_TXmlVerySimple(CL);
end;

 
 
{ TPSImport_XmlVerySimple }
(*----------------------------------------------------------------------------*)
procedure TPSImport_XmlVerySimple.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_XmlVerySimple(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_XmlVerySimple.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_XmlVerySimple(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
