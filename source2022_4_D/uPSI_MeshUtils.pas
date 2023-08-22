unit uPSI_MeshUtils;
{
   from opengl
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
  TPSImport_MeshUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_MeshUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_MeshUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   PersistentClasses
  ,VectorLists
  ,VectorGeometry
  ,MeshUtils
  ;

  //type TXIntegerList = TIntegerlist;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MeshUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_MeshUtils(CL: TPSPascalCompiler);
begin

CL.AddTypeS('TSubdivideEdgeEvent', 'procedure(const idxA, idxB, newIdx : Integer);');

//type
  // TSubdivideEdgeEvent = procedure(const idxA, idxB, newIdx : Integer); register;

 CL.AddDelphiFunction('Procedure ConvertStripToList( const strip : TAffineVectorList; list : TAffineVectorList);');
 CL.AddDelphiFunction('Procedure ConvertStripToList1( const strip : TIntegerList; list : TXIntegerList);');
 CL.AddDelphiFunction('Procedure ConvertStripToList2( const strip : TAffineVectorList; const indices : TXIntegerList; list : TAffineVectorList);');
 CL.AddDelphiFunction('Procedure ConvertIndexedListToList( const data : TAffineVectorList; const indices : TXIntegerList; list : TAffineVectorList)');
 CL.AddDelphiFunction('Function BuildVectorCountOptimizedIndices( const vertices : TAffineVectorList; const normals : TAffineVectorList; const texCoords : TAffineVectorList) : TXIntegerList');
 CL.AddDelphiFunction('Procedure RemapReferences( reference : TAffineVectorList; const indices : TXIntegerList);');
 CL.AddDelphiFunction('Procedure RemapReferences1( reference : TXIntegerList; const indices : TXIntegerList);');
 CL.AddDelphiFunction('Procedure RemapAndCleanupReferences( reference : TAffineVectorList; indices : TXIntegerList)');
 CL.AddDelphiFunction('Function RemapIndicesToIndicesMap( remapIndices : TXIntegerList) : TXIntegerList');
 CL.AddDelphiFunction('Procedure RemapTrianglesIndices( indices, indicesMap : TXIntegerList)');
 CL.AddDelphiFunction('Procedure RemapIndices( indices, indicesMap : TXIntegerList)');
 CL.AddDelphiFunction('Procedure UnifyTrianglesWinding( indices : TXIntegerList)');
 CL.AddDelphiFunction('Procedure InvertTrianglesWinding( indices : TXIntegerList)');
 CL.AddDelphiFunction('Function BuildNormals( reference : TAffineVectorList; indices : TXIntegerList) : TAffineVectorList');
 CL.AddDelphiFunction('Function BuildNonOrientedEdgesList( triangleIndices : TXIntegerList; triangleEdges : TXIntegerList; edgesTriangles : TXIntegerList) : TXIntegerList');
 CL.AddDelphiFunction('Procedure WeldVertices( vertices : TAffineVectorList; indicesMap : TXIntegerList; weldRadius : Single)');
 CL.AddDelphiFunction('Function StripifyMesh( indices : TXIntegerList; maxVertexIndex : Integer; agglomerateLoneTriangles : Boolean) : TPersistentObjectList');
 CL.AddDelphiFunction('Procedure IncreaseCoherency( indices : TXIntegerList; cacheSize : Integer)');
 CL.AddDelphiFunction('Procedure SubdivideTriangles( smoothFactor : Single; vertices : TAffineVectorList; triangleIndices : TXIntegerList; normals : TAffineVectorList; onSubdivideEdge : TSubdivideEdgeEvent)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure RemapReferences1_P( reference : TXIntegerList; const indices : TXIntegerList);
Begin MeshUtils.RemapReferences(reference, indices); END;

(*----------------------------------------------------------------------------*)
Procedure RemapReferences_P( reference : TAffineVectorList; const indices : TXIntegerList);
Begin MeshUtils.RemapReferences(reference, indices); END;

(*----------------------------------------------------------------------------*)
Procedure ConvertStripToList2_P( const strip : TAffineVectorList; const indices : TXIntegerList; list : TAffineVectorList);
Begin MeshUtils.ConvertStripToList(strip, indices, list); END;

(*----------------------------------------------------------------------------*)
Procedure ConvertStripToList1_P( const strip : TXIntegerList; list : TXIntegerList);
Begin MeshUtils.ConvertStripToList(strip, list); END;

(*----------------------------------------------------------------------------*)
Procedure ConvertStripToList_P( const strip : TAffineVectorList; list : TAffineVectorList);
Begin MeshUtils.ConvertStripToList(strip, list); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MeshUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ConvertStripToList, 'ConvertStripToList', cdRegister);
 S.RegisterDelphiFunction(@ConvertStripToList1_P, 'ConvertStripToList1', cdRegister);
 S.RegisterDelphiFunction(@ConvertStripToList2_P, 'ConvertStripToList2', cdRegister);
 S.RegisterDelphiFunction(@ConvertIndexedListToList, 'ConvertIndexedListToList', cdRegister);
 S.RegisterDelphiFunction(@BuildVectorCountOptimizedIndices, 'BuildVectorCountOptimizedIndices', cdRegister);
 S.RegisterDelphiFunction(@RemapReferences, 'RemapReferences', cdRegister);
 S.RegisterDelphiFunction(@RemapReferences1_P, 'RemapReferences1', cdRegister);
 S.RegisterDelphiFunction(@RemapAndCleanupReferences, 'RemapAndCleanupReferences', cdRegister);
 S.RegisterDelphiFunction(@RemapIndicesToIndicesMap, 'RemapIndicesToIndicesMap', cdRegister);
 S.RegisterDelphiFunction(@RemapTrianglesIndices, 'RemapTrianglesIndices', cdRegister);
 S.RegisterDelphiFunction(@RemapIndices, 'RemapIndices', cdRegister);
 S.RegisterDelphiFunction(@UnifyTrianglesWinding, 'UnifyTrianglesWinding', cdRegister);
 S.RegisterDelphiFunction(@InvertTrianglesWinding, 'InvertTrianglesWinding', cdRegister);
 S.RegisterDelphiFunction(@BuildNormals, 'BuildNormals', cdRegister);
 S.RegisterDelphiFunction(@BuildNonOrientedEdgesList, 'BuildNonOrientedEdgesList', cdRegister);
 S.RegisterDelphiFunction(@WeldVertices, 'WeldVertices', cdRegister);
 S.RegisterDelphiFunction(@StripifyMesh, 'StripifyMesh', cdRegister);
 S.RegisterDelphiFunction(@IncreaseCoherency, 'IncreaseCoherency', cdRegister);
 S.RegisterDelphiFunction(@SubdivideTriangles, 'SubdivideTriangles', cdRegister);
end;

 
 
{ TPSImport_MeshUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MeshUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MeshUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MeshUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_MeshUtils(ri);
  RIRegister_MeshUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
