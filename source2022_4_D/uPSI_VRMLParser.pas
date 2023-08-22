unit uPSI_VRMLParser;
{
  opengl
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
  TPSImport_VRMLParser = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TVRMLParser(CL: TPSPascalCompiler);
procedure SIRegister_TVRMLTransform(CL: TPSPascalCompiler);
procedure SIRegister_TVRMLShapeHints(CL: TPSPascalCompiler);
procedure SIRegister_TVRMLUse(CL: TPSPascalCompiler);
procedure SIRegister_TVRMLMaterial(CL: TPSPascalCompiler);
procedure SIRegister_TVRMLIntegerArray(CL: TPSPascalCompiler);
procedure SIRegister_TVRMLSingleArray(CL: TPSPascalCompiler);
procedure SIRegister_TVRMLNode(CL: TPSPascalCompiler);
procedure SIRegister_VRMLParser(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TVRMLParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVRMLTransform(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVRMLShapeHints(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVRMLUse(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVRMLMaterial(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVRMLIntegerArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVRMLSingleArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVRMLNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_VRMLParser(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   VectorTypes
  ,VectorLists
  ,GLUtils
  ,VRMLParser
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_VRMLParser]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TVRMLParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TVRMLParser') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TVRMLParser') do begin
    RegisterMethod('Constructor Create');
                 RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Parse( Text : String)');
    RegisterProperty('RootNode', 'TVRMLNode', iptr);
    RegisterProperty('AllowUnknownNodes', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TVRMLTransform(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TVRMLNode', 'TVRMLTransform') do
  with CL.AddClassN(CL.FindClass('TVRMLNode'),'TVRMLTransform') do
  begin
    RegisterProperty('Center', 'TVector3f', iptrw);
    RegisterProperty('Rotation', 'TVector4f', iptrw);
    RegisterProperty('ScaleFactor', 'TVector3f', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TVRMLShapeHints(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TVRMLNode', 'TVRMLShapeHints') do
  with CL.AddClassN(CL.FindClass('TVRMLNode'),'TVRMLShapeHints') do
  begin
    RegisterProperty('CreaseAngle', 'Single', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TVRMLUse(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TVRMLNode', 'TVRMLUse') do
  with CL.AddClassN(CL.FindClass('TVRMLNode'),'TVRMLUse') do
  begin
    RegisterProperty('Value', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TVRMLMaterial(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TVRMLNode', 'TVRMLMaterial') do
  with CL.AddClassN(CL.FindClass('TVRMLNode'),'TVRMLMaterial') do begin
    RegisterProperty('DiffuseColor', 'TVector3f', iptrw);
    RegisterProperty('AmbientColor', 'TVector3f', iptrw);
    RegisterProperty('SpecularColor', 'TVector3f', iptrw);
    RegisterProperty('EmissiveColor', 'TVector3f', iptrw);
    RegisterProperty('Transparency', 'Single', iptrw);
    RegisterProperty('Shininess', 'Single', iptrw);
    RegisterProperty('HasDiffuse', 'Boolean', iptrw);
    RegisterProperty('HasAmbient', 'Boolean', iptrw);
    RegisterProperty('HasSpecular', 'Boolean', iptrw);
    RegisterProperty('HasEmissive', 'Boolean', iptrw);
    RegisterProperty('HasTransparency', 'Boolean', iptrw);
    RegisterProperty('HasShininess', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TVRMLIntegerArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TVRMLNode', 'TVRMLIntegerArray') do
  with CL.AddClassN(CL.FindClass('TVRMLNode'),'TVRMLIntegerArray') do
  begin
    RegisterProperty('Values', 'TXIntegerList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TVRMLSingleArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TVRMLNode', 'TVRMLSingleArray') do
  with CL.AddClassN(CL.FindClass('TVRMLNode'),'TVRMLSingleArray') do
  begin
    RegisterProperty('Values', 'TSingleList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TVRMLNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TVRMLNode') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TVRMLNode') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
     RegisterMethod('Constructor CreateOwned( AParent : TVRMLNode)');
    RegisterMethod('Function Count : Integer');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Add( node : TVRMLNode)');
    RegisterMethod('Procedure Remove( node : TVRMLNode)');
    RegisterMethod('Procedure Delete( index : Integer)');
    RegisterProperty('Nodes', 'TVRMLNode Integer', iptr);
    SetDefaultPropery('Nodes');
    RegisterProperty('Parent', 'TVRMLNode', iptr);
    RegisterProperty('Name', 'String', iptrw);
    RegisterProperty('DefName', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_VRMLParser(CL: TPSPascalCompiler);
begin
  SIRegister_TVRMLNode(CL);
  SIRegister_TVRMLSingleArray(CL);
  SIRegister_TVRMLIntegerArray(CL);
  SIRegister_TVRMLMaterial(CL);
  SIRegister_TVRMLUse(CL);
  SIRegister_TVRMLShapeHints(CL);
  SIRegister_TVRMLTransform(CL);
  SIRegister_TVRMLParser(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TVRMLParserAllowUnknownNodes_W(Self: TVRMLParser; const T: Boolean);
begin Self.AllowUnknownNodes := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLParserAllowUnknownNodes_R(Self: TVRMLParser; var T: Boolean);
begin T := Self.AllowUnknownNodes; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLParserRootNode_R(Self: TVRMLParser; var T: TVRMLNode);
begin T := Self.RootNode; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLTransformScaleFactor_W(Self: TVRMLTransform; const T: TVector3f);
begin Self.ScaleFactor := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLTransformScaleFactor_R(Self: TVRMLTransform; var T: TVector3f);
begin T := Self.ScaleFactor; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLTransformRotation_W(Self: TVRMLTransform; const T: TVector4f);
begin Self.Rotation := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLTransformRotation_R(Self: TVRMLTransform; var T: TVector4f);
begin T := Self.Rotation; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLTransformCenter_W(Self: TVRMLTransform; const T: TVector3f);
begin Self.Center := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLTransformCenter_R(Self: TVRMLTransform; var T: TVector3f);
begin T := Self.Center; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLShapeHintsCreaseAngle_W(Self: TVRMLShapeHints; const T: Single);
begin Self.CreaseAngle := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLShapeHintsCreaseAngle_R(Self: TVRMLShapeHints; var T: Single);
begin T := Self.CreaseAngle; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLUseValue_W(Self: TVRMLUse; const T: String);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLUseValue_R(Self: TVRMLUse; var T: String);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialHasShininess_W(Self: TVRMLMaterial; const T: Boolean);
begin Self.HasShininess := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialHasShininess_R(Self: TVRMLMaterial; var T: Boolean);
begin T := Self.HasShininess; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialHasTransparency_W(Self: TVRMLMaterial; const T: Boolean);
begin Self.HasTransparency := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialHasTransparency_R(Self: TVRMLMaterial; var T: Boolean);
begin T := Self.HasTransparency; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialHasEmissive_W(Self: TVRMLMaterial; const T: Boolean);
begin Self.HasEmissive := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialHasEmissive_R(Self: TVRMLMaterial; var T: Boolean);
begin T := Self.HasEmissive; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialHasSpecular_W(Self: TVRMLMaterial; const T: Boolean);
begin Self.HasSpecular := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialHasSpecular_R(Self: TVRMLMaterial; var T: Boolean);
begin T := Self.HasSpecular; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialHasAmbient_W(Self: TVRMLMaterial; const T: Boolean);
begin Self.HasAmbient := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialHasAmbient_R(Self: TVRMLMaterial; var T: Boolean);
begin T := Self.HasAmbient; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialHasDiffuse_W(Self: TVRMLMaterial; const T: Boolean);
begin Self.HasDiffuse := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialHasDiffuse_R(Self: TVRMLMaterial; var T: Boolean);
begin T := Self.HasDiffuse; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialShininess_W(Self: TVRMLMaterial; const T: Single);
begin Self.Shininess := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialShininess_R(Self: TVRMLMaterial; var T: Single);
begin T := Self.Shininess; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialTransparency_W(Self: TVRMLMaterial; const T: Single);
begin Self.Transparency := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialTransparency_R(Self: TVRMLMaterial; var T: Single);
begin T := Self.Transparency; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialEmissiveColor_W(Self: TVRMLMaterial; const T: TVector3f);
begin Self.EmissiveColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialEmissiveColor_R(Self: TVRMLMaterial; var T: TVector3f);
begin T := Self.EmissiveColor; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialSpecularColor_W(Self: TVRMLMaterial; const T: TVector3f);
begin Self.SpecularColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialSpecularColor_R(Self: TVRMLMaterial; var T: TVector3f);
begin T := Self.SpecularColor; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialAmbientColor_W(Self: TVRMLMaterial; const T: TVector3f);
begin Self.AmbientColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialAmbientColor_R(Self: TVRMLMaterial; var T: TVector3f);
begin T := Self.AmbientColor; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialDiffuseColor_W(Self: TVRMLMaterial; const T: TVector3f);
begin Self.DiffuseColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLMaterialDiffuseColor_R(Self: TVRMLMaterial; var T: TVector3f);
begin T := Self.DiffuseColor; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLIntegerArrayValues_R(Self: TVRMLIntegerArray; var T: TXIntegerList);
begin T := Self.Values; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLSingleArrayValues_R(Self: TVRMLSingleArray; var T: TSingleList);
begin T := Self.Values; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLNodeDefName_W(Self: TVRMLNode; const T: String);
begin Self.DefName := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLNodeDefName_R(Self: TVRMLNode; var T: String);
begin T := Self.DefName; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLNodeName_W(Self: TVRMLNode; const T: String);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLNodeName_R(Self: TVRMLNode; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLNodeParent_R(Self: TVRMLNode; var T: TVRMLNode);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TVRMLNodeNodes_R(Self: TVRMLNode; var T: TVRMLNode; const t1: Integer);
begin T := Self.Nodes[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVRMLParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVRMLParser) do begin
    RegisterConstructor(@TVRMLParser.Create, 'Create');
       RegisterMethod(@TVRMLParser.Destroy, 'Free');
        RegisterMethod(@TVRMLParser.Parse, 'Parse');
    RegisterPropertyHelper(@TVRMLParserRootNode_R,nil,'RootNode');
    RegisterPropertyHelper(@TVRMLParserAllowUnknownNodes_R,@TVRMLParserAllowUnknownNodes_W,'AllowUnknownNodes');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVRMLTransform(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVRMLTransform) do begin
    RegisterPropertyHelper(@TVRMLTransformCenter_R,@TVRMLTransformCenter_W,'Center');
    RegisterPropertyHelper(@TVRMLTransformRotation_R,@TVRMLTransformRotation_W,'Rotation');
    RegisterPropertyHelper(@TVRMLTransformScaleFactor_R,@TVRMLTransformScaleFactor_W,'ScaleFactor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVRMLShapeHints(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVRMLShapeHints) do begin
    RegisterPropertyHelper(@TVRMLShapeHintsCreaseAngle_R,@TVRMLShapeHintsCreaseAngle_W,'CreaseAngle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVRMLUse(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVRMLUse) do
  begin
    RegisterPropertyHelper(@TVRMLUseValue_R,@TVRMLUseValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVRMLMaterial(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVRMLMaterial) do begin
    RegisterPropertyHelper(@TVRMLMaterialDiffuseColor_R,@TVRMLMaterialDiffuseColor_W,'DiffuseColor');
    RegisterPropertyHelper(@TVRMLMaterialAmbientColor_R,@TVRMLMaterialAmbientColor_W,'AmbientColor');
    RegisterPropertyHelper(@TVRMLMaterialSpecularColor_R,@TVRMLMaterialSpecularColor_W,'SpecularColor');
    RegisterPropertyHelper(@TVRMLMaterialEmissiveColor_R,@TVRMLMaterialEmissiveColor_W,'EmissiveColor');
    RegisterPropertyHelper(@TVRMLMaterialTransparency_R,@TVRMLMaterialTransparency_W,'Transparency');
    RegisterPropertyHelper(@TVRMLMaterialShininess_R,@TVRMLMaterialShininess_W,'Shininess');
    RegisterPropertyHelper(@TVRMLMaterialHasDiffuse_R,@TVRMLMaterialHasDiffuse_W,'HasDiffuse');
    RegisterPropertyHelper(@TVRMLMaterialHasAmbient_R,@TVRMLMaterialHasAmbient_W,'HasAmbient');
    RegisterPropertyHelper(@TVRMLMaterialHasSpecular_R,@TVRMLMaterialHasSpecular_W,'HasSpecular');
    RegisterPropertyHelper(@TVRMLMaterialHasEmissive_R,@TVRMLMaterialHasEmissive_W,'HasEmissive');
    RegisterPropertyHelper(@TVRMLMaterialHasTransparency_R,@TVRMLMaterialHasTransparency_W,'HasTransparency');
    RegisterPropertyHelper(@TVRMLMaterialHasShininess_R,@TVRMLMaterialHasShininess_W,'HasShininess');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVRMLIntegerArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVRMLIntegerArray) do
  begin
    RegisterPropertyHelper(@TVRMLIntegerArrayValues_R,nil,'Values');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVRMLSingleArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVRMLSingleArray) do
  begin
    RegisterPropertyHelper(@TVRMLSingleArrayValues_R,nil,'Values');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVRMLNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVRMLNode) do
  begin
    RegisterVirtualConstructor(@TVRMLNode.Create, 'Create');
       RegisterMethod(@TVRMLNode.Destroy, 'Free');
        RegisterConstructor(@TVRMLNode.CreateOwned, 'CreateOwned');
    RegisterMethod(@TVRMLNode.Count, 'Count');
    RegisterMethod(@TVRMLNode.Clear, 'Clear');
    RegisterMethod(@TVRMLNode.Add, 'Add');
    RegisterMethod(@TVRMLNode.Remove, 'Remove');
    RegisterMethod(@TVRMLNode.Delete, 'Delete');
    RegisterPropertyHelper(@TVRMLNodeNodes_R,nil,'Nodes');
    RegisterPropertyHelper(@TVRMLNodeParent_R,nil,'Parent');
    RegisterPropertyHelper(@TVRMLNodeName_R,@TVRMLNodeName_W,'Name');
    RegisterPropertyHelper(@TVRMLNodeDefName_R,@TVRMLNodeDefName_W,'DefName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_VRMLParser(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TVRMLNode(CL);
  RIRegister_TVRMLSingleArray(CL);
  RIRegister_TVRMLIntegerArray(CL);
  RIRegister_TVRMLMaterial(CL);
  RIRegister_TVRMLUse(CL);
  RIRegister_TVRMLShapeHints(CL);
  RIRegister_TVRMLTransform(CL);
  RIRegister_TVRMLParser(CL);
end;

 
 
{ TPSImport_VRMLParser }
(*----------------------------------------------------------------------------*)
procedure TPSImport_VRMLParser.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_VRMLParser(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_VRMLParser.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_VRMLParser(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
