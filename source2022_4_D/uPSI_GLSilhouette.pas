unit uPSI_GLSilhouette;
{
   add to GL
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
  TPSImport_GLSilhouette = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TConnectivity(CL: TPSPascalCompiler);
procedure SIRegister_TBaseConnectivity(CL: TPSPascalCompiler);
procedure SIRegister_TGLSilhouette(CL: TPSPascalCompiler);
procedure SIRegister_GLSilhouette(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TConnectivity(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBaseConnectivity(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGLSilhouette(CL: TPSRuntimeClassImporter);
procedure RIRegister_GLSilhouette(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   GLMisc
  ,VectorGeometry
  ,VectorLists
  ,GLSilhouette
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GLSilhouette]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TConnectivity(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseConnectivity', 'TConnectivity') do
  with CL.AddClassN(CL.FindClass('TBaseConnectivity'),'TConnectivity') do begin
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function AddIndexedEdge( vertexIndex0, vertexIndex1 : integer; FaceID : integer) : integer');
    RegisterMethod('Function AddIndexedFace( vi0, vi1, vi2 : integer) : integer');
    RegisterMethod('Function AddFace( const vertex0, vertex1, vertex2 : TAffineVector) : integer');
    RegisterMethod('Function AddQuad( const vertex0, vertex1, vertex2, vertex3 : TAffineVector) : integer');
    RegisterProperty('EdgeCount', 'integer', iptr);
    RegisterProperty('FaceCount', 'integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBaseConnectivity(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TBaseConnectivity') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TBaseConnectivity') do begin
    RegisterProperty('EdgeCount', 'integer', iptr);
    RegisterProperty('FaceCount', 'integer', iptr);
    RegisterProperty('PrecomputeFaceNormal', 'boolean', iptr);
    RegisterMethod('Procedure CreateSilhouette( const silhouetteParameters : TGLSilhouetteParameters; var aSilhouette : TGLSilhouette; AddToSilhouette : boolean)');
    RegisterMethod('Constructor Create( PrecomputeFaceNormal : boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGLSilhouette(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TGLSilhouette') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TGLSilhouette') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('Parameters', 'TGLSilhouetteParameters', iptrw);
    RegisterProperty('Vertices', 'TVectorList', iptrw);
    RegisterProperty('Indices', 'TXIntegerList', iptrw);
    RegisterProperty('CapIndices', 'TXIntegerList', iptrw);
    RegisterMethod('Procedure Flush');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure ExtrudeVerticesToInfinity( const origin : TAffineVector)');
    RegisterMethod('Procedure AddEdgeToSilhouette( const v0, v1 : TAffineVector; tightButSlow : Boolean)');
    RegisterMethod('Procedure AddIndexedEdgeToSilhouette( const Vi0, Vi1 : integer)');
    RegisterMethod('Procedure AddCapToSilhouette( const v0, v1, v2 : TAffineVector; tightButSlow : Boolean)');
    RegisterMethod('Procedure AddIndexedCapToSilhouette( const vi0, vi1, vi2 : Integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GLSilhouette(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TGLSilhouetteStyle', '( ssOmni, ssParallel )');
  CL.AddTypeS('TGLSilhouetteParameters', 'record SeenFrom : TAffineVector; Ligh'
   +'tDirection: TAffineVector; Style: TGLSilhouetteStyle; CappingRequired: Boolean; end');
  SIRegister_TGLSilhouette(CL);
  SIRegister_TBaseConnectivity(CL);
  SIRegister_TConnectivity(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TConnectivityFaceCount_R(Self: TConnectivity; var T: integer);
begin T := Self.FaceCount; end;

(*----------------------------------------------------------------------------*)
procedure TConnectivityEdgeCount_R(Self: TConnectivity; var T: integer);
begin T := Self.EdgeCount; end;

(*----------------------------------------------------------------------------*)
procedure TBaseConnectivityPrecomputeFaceNormal_R(Self: TBaseConnectivity; var T: boolean);
begin T := Self.PrecomputeFaceNormal; end;

(*----------------------------------------------------------------------------*)
procedure TBaseConnectivityFaceCount_R(Self: TBaseConnectivity; var T: integer);
begin T := Self.FaceCount; end;

(*----------------------------------------------------------------------------*)
procedure TBaseConnectivityEdgeCount_R(Self: TBaseConnectivity; var T: integer);
begin T := Self.EdgeCount; end;

(*----------------------------------------------------------------------------*)
procedure TGLSilhouetteCapIndices_W(Self: TGLSilhouette; const T: TXIntegerList);
begin Self.CapIndices := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLSilhouetteCapIndices_R(Self: TGLSilhouette; var T: TXIntegerList);
begin T := Self.CapIndices; end;

(*----------------------------------------------------------------------------*)
procedure TGLSilhouetteIndices_W(Self: TGLSilhouette; const T: TXIntegerList);
begin Self.Indices := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLSilhouetteIndices_R(Self: TGLSilhouette; var T: TXIntegerList);
begin T := Self.Indices; end;

(*----------------------------------------------------------------------------*)
procedure TGLSilhouetteVertices_W(Self: TGLSilhouette; const T: TVectorList);
begin Self.Vertices := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLSilhouetteVertices_R(Self: TGLSilhouette; var T: TVectorList);
begin T := Self.Vertices; end;

(*----------------------------------------------------------------------------*)
procedure TGLSilhouetteParameters_W(Self: TGLSilhouette; const T: TGLSilhouetteParameters);
begin Self.Parameters := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLSilhouetteParameters_R(Self: TGLSilhouette; var T: TGLSilhouetteParameters);
begin T := Self.Parameters; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TConnectivity(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TConnectivity) do begin
    RegisterMethod(@TConnectivity.Clear, 'Clear');
    RegisterMethod(@TConnectivity.AddIndexedEdge, 'AddIndexedEdge');
    RegisterMethod(@TConnectivity.AddIndexedFace, 'AddIndexedFace');
    RegisterMethod(@TConnectivity.AddFace, 'AddFace');
    RegisterMethod(@TConnectivity.AddQuad, 'AddQuad');
    RegisterPropertyHelper(@TConnectivityEdgeCount_R,nil,'EdgeCount');
    RegisterPropertyHelper(@TConnectivityFaceCount_R,nil,'FaceCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBaseConnectivity(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBaseConnectivity) do begin
    RegisterPropertyHelper(@TBaseConnectivityEdgeCount_R,nil,'EdgeCount');
    RegisterPropertyHelper(@TBaseConnectivityFaceCount_R,nil,'FaceCount');
    RegisterPropertyHelper(@TBaseConnectivityPrecomputeFaceNormal_R,nil,'PrecomputeFaceNormal');
    RegisterVirtualMethod(@TBaseConnectivity.CreateSilhouette, 'CreateSilhouette');
    RegisterVirtualConstructor(@TBaseConnectivity.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGLSilhouette(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGLSilhouette) do begin
    RegisterConstructor(@TGLSilhouette.Create, 'Create');
          RegisterMethod(@TGLSilhouette.Destroy, 'Free');
     RegisterPropertyHelper(@TGLSilhouetteParameters_R,@TGLSilhouetteParameters_W,'Parameters');
    RegisterPropertyHelper(@TGLSilhouetteVertices_R,@TGLSilhouetteVertices_W,'Vertices');
    RegisterPropertyHelper(@TGLSilhouetteIndices_R,@TGLSilhouetteIndices_W,'Indices');
    RegisterPropertyHelper(@TGLSilhouetteCapIndices_R,@TGLSilhouetteCapIndices_W,'CapIndices');
    RegisterMethod(@TGLSilhouette.Flush, 'Flush');
    RegisterMethod(@TGLSilhouette.Clear, 'Clear');
    RegisterMethod(@TGLSilhouette.ExtrudeVerticesToInfinity, 'ExtrudeVerticesToInfinity');
    RegisterMethod(@TGLSilhouette.AddEdgeToSilhouette, 'AddEdgeToSilhouette');
    RegisterMethod(@TGLSilhouette.AddIndexedEdgeToSilhouette, 'AddIndexedEdgeToSilhouette');
    RegisterMethod(@TGLSilhouette.AddCapToSilhouette, 'AddCapToSilhouette');
    RegisterMethod(@TGLSilhouette.AddIndexedCapToSilhouette, 'AddIndexedCapToSilhouette');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GLSilhouette(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TGLSilhouette(CL);
  RIRegister_TBaseConnectivity(CL);
  RIRegister_TConnectivity(CL);
end;

 
 
{ TPSImport_GLSilhouette }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GLSilhouette.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GLSilhouette(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GLSilhouette.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GLSilhouette(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
