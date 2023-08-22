unit uPSI_GLVectorFileObjects;
{
   a last crucade
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
  TPSImport_GLVectorFileObjects = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TVectorFileFormatsList(CL: TPSPascalCompiler);
procedure SIRegister_TVectorFileFormat(CL: TPSPascalCompiler);
procedure SIRegister_TGLActor(CL: TPSPascalCompiler);
procedure SIRegister_TGLAnimationControler(CL: TPSPascalCompiler);
procedure SIRegister_TGLBaseAnimationControler(CL: TPSPascalCompiler);
procedure SIRegister_TActorAnimations(CL: TPSPascalCompiler);
procedure SIRegister_TActorAnimation(CL: TPSPascalCompiler);
procedure SIRegister_TGLFreeForm(CL: TPSPascalCompiler);
procedure SIRegister_TGLBaseMesh(CL: TPSPascalCompiler);
procedure SIRegister_TGLGLSMVectorFile(CL: TPSPascalCompiler);
procedure SIRegister_TVectorFile(CL: TPSPascalCompiler);
procedure SIRegister_TFaceGroups(CL: TPSPascalCompiler);
procedure SIRegister_TFGIndexTexCoordList(CL: TPSPascalCompiler);
procedure SIRegister_TFGVertexNormalTexIndexList(CL: TPSPascalCompiler);
procedure SIRegister_TFGVertexIndexList(CL: TPSPascalCompiler);
procedure SIRegister_TFaceGroup(CL: TPSPascalCompiler);
procedure SIRegister_TSkeletonMeshObject(CL: TPSPascalCompiler);
procedure SIRegister_TMorphableMeshObject(CL: TPSPascalCompiler);
procedure SIRegister_TMeshMorphTargetList(CL: TPSPascalCompiler);
procedure SIRegister_TMeshMorphTarget(CL: TPSPascalCompiler);
procedure SIRegister_TMeshObjectList(CL: TPSPascalCompiler);
procedure SIRegister_TMeshObject(CL: TPSPascalCompiler);
procedure SIRegister_TSkeleton(CL: TPSPascalCompiler);
procedure SIRegister_TSkeletonColliderList(CL: TPSPascalCompiler);
procedure SIRegister_TSkeletonCollider(CL: TPSPascalCompiler);
procedure SIRegister_TSkeletonBone(CL: TPSPascalCompiler);
procedure SIRegister_TSkeletonRootBoneList(CL: TPSPascalCompiler);
procedure SIRegister_TSkeletonBoneList(CL: TPSPascalCompiler);
procedure SIRegister_TSkeletonFrameList(CL: TPSPascalCompiler);
procedure SIRegister_TSkeletonFrame(CL: TPSPascalCompiler);
procedure SIRegister_TBaseMeshObject(CL: TPSPascalCompiler);
procedure SIRegister_GLVectorFileObjects(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_GLVectorFileObjects_Routines(S: TPSExec);
procedure RIRegister_TVectorFileFormatsList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVectorFileFormat(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGLActor(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGLAnimationControler(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGLBaseAnimationControler(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActorAnimations(CL: TPSRuntimeClassImporter);
procedure RIRegister_TActorAnimation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGLFreeForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGLBaseMesh(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGLGLSMVectorFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVectorFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFaceGroups(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFGIndexTexCoordList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFGVertexNormalTexIndexList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFGVertexIndexList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFaceGroup(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSkeletonMeshObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMorphableMeshObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMeshMorphTargetList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMeshMorphTarget(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMeshObjectList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMeshObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSkeleton(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSkeletonColliderList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSkeletonCollider(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSkeletonBone(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSkeletonRootBoneList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSkeletonBoneList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSkeletonFrameList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSkeletonFrame(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBaseMeshObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_GLVectorFileObjects(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   GLScene
  ,OpenGL1x
  ,VectorGeometry
  ,GLMisc
  ,GLTexture
  ,GLMesh
  ,VectorLists
  ,PersistentClasses
  ,Octree
  ,GeometryBB
  ,ApplicationFileIO
  ,GLSilhouette
  ,GLVectorFileObjects
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GLVectorFileObjects]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TVectorFileFormatsList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistentObjectList', 'TVectorFileFormatsList') do
  with CL.AddClassN(CL.FindClass('TPersistentObjectList'),'TVectorFileFormatsList') do
  begin
    RegisterMethod('Procedure Add( const Ext, Desc : String; DescID : Integer; AClass : TVectorFileClass)');
    RegisterMethod('Function FindExt( ext : string) : TVectorFileClass');
    RegisterMethod('Function FindFromFileName( const fileName : String) : TVectorFileClass');
    RegisterMethod('Procedure Remove( AClass : TVectorFileClass)');
    RegisterMethod('Procedure BuildFilterStrings( vectorFileClass : TVectorFileClass; var descriptions, filters : String; formatsThatCanBeOpened : Boolean; formatsThatCanBeSaved : Boolean)');
    RegisterMethod('Function FindExtByIndex( index : Integer; formatsThatCanBeOpened : Boolean; formatsThatCanBeSaved : Boolean) : String');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TVectorFileFormat(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TVectorFileFormat') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TVectorFileFormat') do
  begin
    RegisterProperty('VectorFileClass', 'TVectorFileClass', iptrw);
    RegisterProperty('Extension', 'String', iptrw);
    RegisterProperty('Description', 'String', iptrw);
    RegisterProperty('DescResID', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGLActor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGLBaseMesh', 'TGLActor') do
  with CL.AddClassN(CL.FindClass('TGLBaseMesh'),'TGLActor') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure BuildList( var rci : TRenderContextInfo)');
    RegisterMethod('Procedure DoProgress( const progressTime : TProgressTimes)');
    RegisterMethod('Procedure LoadFromStream( const filename : String; aStream : TStream)');
    RegisterMethod('Procedure SwitchToAnimation( anAnimation : TActorAnimation; smooth : Boolean)');
    RegisterMethod('Procedure SwitchToAnimation( const animationName : String; smooth : Boolean)');
    RegisterMethod('Procedure SwitchToAnimation( animationIndex : Integer; smooth : Boolean)');
    RegisterMethod('Function CurrentAnimation : String');
    RegisterMethod('Procedure Synchronize( referenceActor : TGLActor)');
    RegisterMethod('Function NextFrameIndex : Integer');
    RegisterMethod('Procedure NextFrame( nbSteps : Integer)');
    RegisterMethod('Procedure PrevFrame( nbSteps : Integer)');
    RegisterMethod('Function FrameCount : Integer');
    RegisterMethod('Function isSwitchingAnimation : boolean');
    RegisterProperty('StartFrame', 'Integer', iptrw);
    RegisterProperty('EndFrame', 'Integer', iptrw);
    RegisterProperty('Reference', 'TActorAnimationReference', iptrw);
    RegisterProperty('CurrentFrame', 'Integer', iptrw);
    RegisterProperty('CurrentFrameDelta', 'Single', iptrw);
    RegisterProperty('FrameInterpolation', 'TActorFrameInterpolation', iptrw);
    RegisterProperty('AnimationMode', 'TActorAnimationMode', iptrw);
    RegisterProperty('Interval', 'Integer', iptrw);
    RegisterProperty('Options', 'TGLActorOptions', iptrw);
    RegisterProperty('OnFrameChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('OnEndFrameReached', 'TNotifyEvent', iptrw);
    RegisterProperty('OnStartFrameReached', 'TNotifyEvent', iptrw);
    RegisterProperty('Animations', 'TActorAnimations', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGLAnimationControler(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGLBaseAnimationControler', 'TGLAnimationControler') do
  with CL.AddClassN(CL.FindClass('TGLBaseAnimationControler'),'TGLAnimationControler') do
  begin
    RegisterProperty('AnimationName', 'String', iptrw);
    RegisterProperty('Ratio', 'Single', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGLBaseAnimationControler(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TGLBaseAnimationControler') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TGLBaseAnimationControler') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('Actor', 'TGLActor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActorAnimations(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TActorAnimations') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TActorAnimations') do
  begin
    RegisterMethod('Constructor Create( AOwner : TGLActor)');
    RegisterMethod('Function Add : TActorAnimation');
    RegisterMethod('Function FindItemID( ID : Integer) : TActorAnimation');
    RegisterMethod('Function FindName( const aName : String) : TActorAnimation');
    RegisterMethod('Function FindFrame( aFrame : Integer; aReference : TActorAnimationReference) : TActorAnimation');
    RegisterMethod('Procedure SetToStrings( aStrings : TStrings)');
    RegisterMethod('Procedure SaveToStream( aStream : TStream)');
    RegisterMethod('Procedure LoadFromStream( aStream : TStream)');
    RegisterMethod('Procedure SaveToFile( const fileName : String)');
    RegisterMethod('Procedure LoadFromFile( const fileName : String)');
    RegisterProperty('Items', 'TActorAnimation Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterMethod('Function Last : TActorAnimation');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TActorAnimation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TActorAnimation') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TActorAnimation') do
  begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('AsString', 'String', iptrw);
    RegisterMethod('Function OwnerActor : TGLActor');
    RegisterMethod('Procedure MakeSkeletalTranslationStatic');
    RegisterMethod('Procedure MakeSkeletalRotationDelta');
    RegisterProperty('Name', 'String', iptrw);
    RegisterProperty('StartFrame', 'Integer', iptrw);
    RegisterProperty('EndFrame', 'Integer', iptrw);
    RegisterProperty('Reference', 'TActorAnimationReference', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGLFreeForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGLBaseMesh', 'TGLFreeForm') do
  with CL.AddClassN(CL.FindClass('TGLBaseMesh'),'TGLFreeForm') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function OctreeRayCastIntersect( const rayStart, rayVector : TVector; intersectPoint : PVector; intersectNormal : PVector) : Boolean');
    RegisterMethod('Function OctreeSphereSweepIntersect( const rayStart, rayVector : TVector; const velocity, radius : Single; intersectPoint : PVector; intersectNormal : PVector) : Boolean');
    RegisterMethod('Function OctreeTriangleIntersect( const v1, v2, v3 : TAffineVector) : boolean');
    RegisterMethod('Function OctreePointInMesh( const Point : TVector) : boolean');
    RegisterMethod('Function OctreeAABBIntersect( const AABB : TAABB; objMatrix, invObjMatrix : TMatrix; triangles : TAffineVectorList) : boolean');
    RegisterProperty('Octree', 'TOctree', iptr);
    RegisterMethod('Procedure BuildOctree( TreeDepth : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGLBaseMesh(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGLSceneObject', 'TGLBaseMesh') do
  with CL.AddClassN(CL.FindClass('TGLSceneObject'),'TGLBaseMesh') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Notification( AComponent : TComponent; Operation : TOperation)');
    RegisterMethod('Function AxisAlignedDimensionsUnscaled : TVector');
    RegisterMethod('Procedure BuildList( var rci : TRenderContextInfo)');
    RegisterMethod('Procedure DoRender( var rci : TRenderContextInfo; renderSelf, renderChildren : Boolean)');
    RegisterMethod('Procedure StructureChanged');
    RegisterMethod('Procedure StructureChangedNoPrepare');
    RegisterMethod('Function RayCastIntersect( const rayStart, rayVector : TVector; intersectPoint : PVector; intersectNormal : PVector) : Boolean');
    RegisterMethod('Function GenerateSilhouette( const silhouetteParameters : TGLSilhouetteParameters) : TGLSilhouette');
    RegisterMethod('Procedure BuildSilhouetteConnectivityData');
    RegisterProperty('MeshObjects', 'TMeshObjectList', iptr);
    RegisterProperty('Skeleton', 'TSkeleton', iptr);
    RegisterMethod('Procedure GetExtents( var min, max : TAffineVector)');
    RegisterMethod('Function GetBarycenter : TAffineVector');
    RegisterMethod('Procedure PerformAutoCentering');
    RegisterMethod('Procedure PerformAutoScaling');
    RegisterMethod('Procedure LoadFromFile( const filename : String)');
    RegisterMethod('Procedure LoadFromStream( const filename : String; aStream : TStream)');
    RegisterMethod('Procedure SaveToFile( const fileName : String)');
    RegisterMethod('Procedure SaveToStream( const fileName : String; aStream : TStream)');
    RegisterMethod('Procedure AddDataFromFile( const filename : String)');
    RegisterMethod('Procedure AddDataFromStream( const filename : String; aStream : TStream)');
    RegisterMethod('Function LastLoadedFilename : string');
    RegisterProperty('AutoCentering', 'TMeshAutoCenterings', iptrw);
    RegisterProperty('AutoScaling', 'TGLCoordinates', iptrw);
    RegisterProperty('MaterialLibrary', 'TGLMaterialLibrary', iptrw);
    RegisterProperty('UseMeshMaterials', 'Boolean', iptrw);
    RegisterProperty('LightmapLibrary', 'TGLMaterialLibrary', iptrw);
    RegisterProperty('IgnoreMissingTextures', 'Boolean', iptrw);
    RegisterProperty('NormalsOrientation', 'TMeshNormalsOrientation', iptrw);
    RegisterProperty('OverlaySkeleton', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGLGLSMVectorFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TVectorFile', 'TGLGLSMVectorFile') do
  with CL.AddClassN(CL.FindClass('TVectorFile'),'TGLGLSMVectorFile') do
  begin
    RegisterMethod('Function Capabilities : TDataFileCapabilities');
    RegisterMethod('Procedure LoadFromStream( aStream : TStream)');
    RegisterMethod('Procedure SaveToStream( aStream : TStream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TVectorFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDataFile', 'TVectorFile') do
  with CL.AddClassN(CL.FindClass('TDataFile'),'TVectorFile') do
  begin
    RegisterMethod('Constructor Create( AOwner : TPersistent)');
    RegisterMethod('Function Owner : TGLBaseMesh');
    RegisterProperty('NormalsOrientation', 'TMeshNormalsOrientation', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFaceGroups(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistentObjectList', 'TFaceGroups') do
  with CL.AddClassN(CL.FindClass('TPersistentObjectList'),'TFaceGroups') do
  begin
    RegisterMethod('Constructor CreateOwned( AOwner : TMeshObject)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure PrepareMaterialLibraryCache( matLib : TGLMaterialLibrary)');
    RegisterMethod('Procedure DropMaterialLibraryCache');
    RegisterProperty('Owner', 'TMeshObject', iptr);
    RegisterMethod('Procedure Clear');
    RegisterProperty('Items', 'TFaceGroup Integer', iptr);
    SetDefaultPropery('Items');
    RegisterMethod('Procedure AddToTriangles( aList : TAffineVectorList; aTexCoords : TAffineVectorList; aNormals : TAffineVectorList)');
    RegisterMethod('Function MaterialLibrary : TGLMaterialLibrary');
    RegisterMethod('Procedure SortByMaterial');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFGIndexTexCoordList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TFGVertexIndexList', 'TFGIndexTexCoordList') do
  with CL.AddClassN(CL.FindClass('TFGVertexIndexList'),'TFGIndexTexCoordList') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure BuildList( var mrci : TRenderContextInfo)');
    RegisterMethod('Procedure AddToTriangles( aList : TAffineVectorList; aTexCoords : TAffineVectorList; aNormals : TAffineVectorList)');
    RegisterMethod('Procedure Add( idx : Integer; const texCoord : TAffineVector);');
    RegisterMethod('Procedure Add1( idx : Integer; const s, t : Single);');
    RegisterProperty('TexCoords', 'TAffineVectorList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFGVertexNormalTexIndexList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TFGVertexIndexList', 'TFGVertexNormalTexIndexList') do
  with CL.AddClassN(CL.FindClass('TFGVertexIndexList'),'TFGVertexNormalTexIndexList') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure BuildList( var mrci : TRenderContextInfo)');
    RegisterMethod('Procedure AddToTriangles( aList : TAffineVectorList; aTexCoords : TAffineVectorList; aNormals : TAffineVectorList)');
    RegisterMethod('Procedure Add( vertexIdx, normalIdx, texCoordIdx : Integer)');
    RegisterProperty('NormalIndices', 'TXIntegerList', iptrw);
    RegisterProperty('TexCoordIndices', 'TXIntegerList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFGVertexIndexList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TFaceGroup', 'TFGVertexIndexList') do
  with CL.AddClassN(CL.FindClass('TFaceGroup'),'TFGVertexIndexList') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure BuildList( var mrci : TRenderContextInfo)');
    RegisterMethod('Procedure AddToTriangles( aList : TAffineVectorList; aTexCoords : TAffineVectorList; aNormals : TAffineVectorList)');
    RegisterMethod('Procedure Add( idx : Integer)');
    RegisterMethod('Procedure GetExtents( var min, max : TAffineVector)');
    RegisterMethod('Procedure ConvertToList');
    RegisterMethod('Function GetNormal : TAffineVector');
    RegisterProperty('Mode', 'TFaceGroupMeshMode', iptrw);
    RegisterProperty('VertexIndices', 'TXIntegerList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFaceGroup(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistentObject', 'TFaceGroup') do
  with CL.AddClassN(CL.FindClass('TPersistentObject'),'TFaceGroup') do
  begin
    RegisterMethod('Constructor CreateOwned( AOwner : TFaceGroups)');
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure PrepareMaterialLibraryCache( matLib : TGLMaterialLibrary)');
    RegisterMethod('Procedure DropMaterialLibraryCache');
    RegisterMethod('Procedure BuildList( var mrci : TRenderContextInfo)');
    RegisterMethod('Procedure AddToTriangles( aList : TAffineVectorList; aTexCoords : TAffineVectorList; aNormals : TAffineVectorList)');
    RegisterMethod('Function TriangleCount : Integer');
    RegisterMethod('Procedure Reverse');
    RegisterMethod('Procedure Prepare');
    RegisterProperty('Owner', 'TFaceGroups', iptrw);
    RegisterProperty('MaterialName', 'String', iptrw);
    RegisterProperty('MaterialCache', 'TGLLibMaterial', iptr);
    RegisterProperty('LightMapIndex', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSkeletonMeshObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMorphableMeshObject', 'TSkeletonMeshObject') do
  with CL.AddClassN(CL.FindClass('TMorphableMeshObject'),'TSkeletonMeshObject') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure Clear');
    RegisterProperty('VerticesBonesWeights', 'PVerticesBoneWeights', iptr);
    RegisterProperty('VerticeBoneWeightCount', 'Integer', iptrw);
    RegisterProperty('VerticeBoneWeightCapacity', 'Integer', iptrw);
    RegisterProperty('BonesPerVertex', 'Integer', iptrw);
    RegisterMethod('Function FindOrAdd( boneID : Integer; const vertex, normal : TAffineVector) : Integer;');
    RegisterMethod('Function FindOrAdd1( const boneIDs : TVertexBoneWeightDynArray; const vertex, normal : TAffineVector) : Integer;');
    RegisterMethod('Procedure AddWeightedBone( aBoneID : Integer; aWeight : Single)');
    RegisterMethod('Procedure AddWeightedBones( const boneIDs : TVertexBoneWeightDynArray)');
    RegisterMethod('Procedure PrepareBoneMatrixInvertedMeshes');
    RegisterMethod('Procedure ApplyCurrentSkeletonFrame( normalize : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMorphableMeshObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMeshObject', 'TMorphableMeshObject') do
  with CL.AddClassN(CL.FindClass('TMeshObject'),'TMorphableMeshObject') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Translate( const delta : TAffineVector)');
    RegisterMethod('Procedure MorphTo( morphTargetIndex : Integer)');
    RegisterMethod('Procedure Lerp( morphTargetIndex1, morphTargetIndex2 : Integer; lerpFactor : Single)');
    RegisterProperty('MorphTargets', 'TMeshMorphTargetList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMeshMorphTargetList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistentObjectList', 'TMeshMorphTargetList') do
  with CL.AddClassN(CL.FindClass('TPersistentObjectList'),'TMeshMorphTargetList') do
  begin
    RegisterMethod('Constructor CreateOwned( AOwner : TPersistent)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure Translate( const delta : TAffineVector)');
    RegisterProperty('Owner', 'TPersistent', iptr);
    RegisterMethod('Procedure Clear');
    RegisterProperty('Items', 'TMeshMorphTarget Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMeshMorphTarget(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseMeshObject', 'TMeshMorphTarget') do
  with CL.AddClassN(CL.FindClass('TBaseMeshObject'),'TMeshMorphTarget') do
  begin
    RegisterMethod('Constructor CreateOwned( AOwner : TMeshMorphTargetList)');
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterProperty('Owner', 'TMeshMorphTargetList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMeshObjectList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistentObjectList', 'TMeshObjectList') do
  with CL.AddClassN(CL.FindClass('TPersistentObjectList'),'TMeshObjectList') do
  begin
    RegisterMethod('Constructor CreateOwned( aOwner : TGLBaseMesh)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure PrepareMaterialLibraryCache( matLib : TGLMaterialLibrary)');
    RegisterMethod('Procedure DropMaterialLibraryCache');
    RegisterMethod('Procedure PrepareBuildList( var mrci : TRenderContextInfo)');
    RegisterMethod('Procedure BuildList( var mrci : TRenderContextInfo)');
    RegisterMethod('Procedure MorphTo( morphTargetIndex : Integer)');
    RegisterMethod('Procedure Lerp( morphTargetIndex1, morphTargetIndex2 : Integer; lerpFactor : Single)');
    RegisterMethod('Function MorphTargetCount : Integer');
    RegisterMethod('Procedure GetExtents( var min, max : TAffineVector)');
    RegisterMethod('Procedure Translate( const delta : TAffineVector)');
    RegisterMethod('Function ExtractTriangles( texCoords : TAffineVectorList; normals : TAffineVectorList) : TAffineVectorList');
    RegisterMethod('Function TriangleCount : Integer');
    RegisterMethod('Procedure Prepare');
    RegisterMethod('Function FindMeshByName( MeshName : String) : TMeshObject');
    RegisterProperty('Owner', 'TGLBaseMesh', iptr);
    RegisterProperty('Items', 'TMeshObject Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMeshObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBaseMeshObject', 'TMeshObject') do
  with CL.AddClassN(CL.FindClass('TBaseMeshObject'),'TMeshObject') do
  begin
    RegisterMethod('Constructor CreateOwned( AOwner : TMeshObjectList)');
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function ExtractTriangles( texCoords : TAffineVectorList; normals : TAffineVectorList) : TAffineVectorList');
    RegisterMethod('Function TriangleCount : Integer');
    RegisterMethod('Procedure PrepareMaterialLibraryCache( matLib : TGLMaterialLibrary)');
    RegisterMethod('Procedure DropMaterialLibraryCache');
    RegisterMethod('Procedure PrepareBuildList( var mrci : TRenderContextInfo)');
    RegisterMethod('Procedure BuildList( var mrci : TRenderContextInfo)');
    RegisterMethod('Procedure GetExtents( var min, max : TAffineVector)');
    RegisterMethod('Procedure Prepare');
    RegisterMethod('Function PointInObject( const aPoint : TAffineVector) : Boolean');
    RegisterMethod('Procedure GetTriangleData( tri : Integer; list : TAffineVectorList; var v0, v1, v2 : TAffineVector);');
    RegisterMethod('Procedure GetTriangleData1( tri : Integer; list : TVectorList; var v0, v1, v2 : TVector);');
    RegisterMethod('Procedure SetTriangleData( tri : Integer; list : TAffineVectorList; const v0, v1, v2 : TAffineVector);');
    RegisterMethod('Procedure SetTriangleData1( tri : Integer; list : TVectorList; const v0, v1, v2 : TVector);');
    RegisterMethod('Procedure BuildTangentSpace( buildBinormals : Boolean; buildTangents : Boolean)');
    RegisterProperty('Owner', 'TMeshObjectList', iptr);
    RegisterProperty('Mode', 'TMeshObjectMode', iptrw);
    RegisterProperty('TexCoords', 'TAffineVectorList', iptrw);
    RegisterProperty('LightMapTexCoords', 'TTexPointList', iptrw);
    RegisterProperty('Colors', 'TVectorList', iptrw);
    RegisterProperty('FaceGroups', 'TFaceGroups', iptr);
    RegisterProperty('RenderingOptions', 'TMeshObjectRenderingOptions', iptrw);
    RegisterProperty('TexCoordsEx', 'TVectorList Integer', iptrw);
    RegisterProperty('Binormals', 'TVectorList', iptrw);
    RegisterProperty('Tangents', 'TVectorList', iptrw);
    RegisterProperty('BinormalsTexCoordIndex', 'Integer', iptrw);
    RegisterProperty('TangentsTexCoordIndex', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSkeleton(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistentObject', 'TSkeleton') do
  with CL.AddClassN(CL.FindClass('TPersistentObject'),'TSkeleton') do
  begin
    RegisterMethod('Constructor CreateOwned( AOwner : TGLBaseMesh)');
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterProperty('Owner', 'TGLBaseMesh', iptr);
    RegisterProperty('RootBones', 'TSkeletonRootBoneList', iptrw);
    RegisterProperty('Frames', 'TSkeletonFrameList', iptrw);
    RegisterProperty('CurrentFrame', 'TSkeletonFrame', iptrw);
    RegisterProperty('Colliders', 'TSkeletonColliderList', iptrw);
    RegisterMethod('Procedure FlushBoneByIDCache');
    RegisterMethod('Function BoneByID( anID : Integer) : TSkeletonBone');
    RegisterMethod('Function BoneByName( const aName : String) : TSkeletonBone');
    RegisterMethod('Function BoneCount : Integer');
    RegisterMethod('Procedure MorphTo( frameIndex : Integer);');
    RegisterMethod('Procedure MorphTo1( frame : TSkeletonFrame);');
    RegisterMethod('Procedure Lerp( frameIndex1, frameIndex2 : Integer; lerpFactor : Single)');
    RegisterMethod('Procedure BlendedLerps( const lerpInfos : array of TBlendedLerpInfo)');
    RegisterMethod('Procedure MakeSkeletalTranslationStatic( startFrame, endFrame : Integer)');
    RegisterMethod('Procedure MakeSkeletalRotationDelta( startFrame, endFrame : Integer)');
    RegisterMethod('Procedure MorphMesh( normalize : Boolean)');
    RegisterMethod('Procedure Synchronize( reference : TSkeleton)');
    RegisterMethod('Procedure Clear');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSkeletonColliderList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistentObjectList', 'TSkeletonColliderList') do
  with CL.AddClassN(CL.FindClass('TPersistentObjectList'),'TSkeletonColliderList') do
  begin
    RegisterMethod('Constructor CreateOwned( AOwner : TPersistent)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure AlignColliders');
    RegisterProperty('Owner', 'TPersistent', iptr);
    RegisterProperty('Items', 'TSkeletonCollider Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSkeletonCollider(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistentObject', 'TSkeletonCollider') do
  with CL.AddClassN(CL.FindClass('TPersistentObject'),'TSkeletonCollider') do
  begin
    RegisterMethod('Constructor CreateOwned( AOwner : TSkeletonColliderList)');
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure AlignCollider');
    RegisterProperty('Owner', 'TSkeletonColliderList', iptr);
    RegisterProperty('Bone', 'TSkeletonBone', iptrw);
    RegisterProperty('LocalMatrix', 'TMatrix', iptrw);
    RegisterProperty('GlobalMatrix', 'TMatrix', iptr);
    RegisterProperty('AutoUpdate', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSkeletonBone(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSkeletonBoneList', 'TSkeletonBone') do
  with CL.AddClassN(CL.FindClass('TSkeletonBoneList'),'TSkeletonBone') do
  begin
    RegisterMethod('Constructor CreateOwned( aOwner : TSkeletonBoneList)');
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure BuildList( var mrci : TRenderContextInfo)');
    RegisterProperty('Owner', 'TSkeletonBoneList', iptr);
    RegisterProperty('Name', 'String', iptrw);
    RegisterProperty('BoneID', 'Integer', iptrw);
    RegisterProperty('Color', 'Cardinal', iptrw);
    RegisterProperty('Items', 'TSkeletonBone Integer', iptr);
    SetDefaultPropery('Items');
    RegisterMethod('Function BoneByID( anID : Integer) : TSkeletonBone');
    RegisterMethod('Function BoneByName( const aName : String) : TSkeletonBone');
    RegisterProperty('GlobalMatrix', 'TMatrix', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSkeletonRootBoneList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSkeletonBoneList', 'TSkeletonRootBoneList') do
  with CL.AddClassN(CL.FindClass('TSkeletonBoneList'),'TSkeletonRootBoneList') do
  begin
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure BuildList( var mrci : TRenderContextInfo)');
    RegisterProperty('GlobalMatrix', 'TMatrix', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSkeletonBoneList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistentObjectList', 'TSkeletonBoneList') do
  with CL.AddClassN(CL.FindClass('TPersistentObjectList'),'TSkeletonBoneList') do
  begin
    RegisterMethod('Constructor CreateOwned( aOwner : TSkeleton)');
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterProperty('Skeleton', 'TSkeleton', iptr);
    RegisterProperty('Items', 'TSkeletonBone Integer', iptr);
    SetDefaultPropery('Items');
    RegisterMethod('Function BoneByID( anID : Integer) : TSkeletonBone');
    RegisterMethod('Function BoneByName( const aName : String) : TSkeletonBone');
    RegisterMethod('Function BoneCount : Integer');
    RegisterMethod('Procedure BuildList( var mrci : TRenderContextInfo)');
    RegisterMethod('Procedure PrepareGlobalMatrices');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSkeletonFrameList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistentObjectList', 'TSkeletonFrameList') do
  with CL.AddClassN(CL.FindClass('TPersistentObjectList'),'TSkeletonFrameList') do
  begin
    RegisterMethod('Constructor CreateOwned( AOwner : TPersistent)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure ConvertQuaternionsToRotations( KeepQuaternions : Boolean; SetTransformMode : Boolean)');
    RegisterMethod('Procedure ConvertRotationsToQuaternions( KeepRotations : Boolean; SetTransformMode : Boolean)');
    RegisterProperty('Owner', 'TPersistent', iptr);
    RegisterMethod('Procedure Clear');
    RegisterProperty('Items', 'TSkeletonFrame Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSkeletonFrame(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistentObject', 'TSkeletonFrame') do
  with CL.AddClassN(CL.FindClass('TPersistentObject'),'TSkeletonFrame') do
  begin
    RegisterMethod('Constructor CreateOwned( aOwner : TSkeletonFrameList)');
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterProperty('Owner', 'TSkeletonFrameList', iptr);
    RegisterProperty('Name', 'String', iptrw);
    RegisterProperty('Position', 'TAffineVectorList', iptrw);
    RegisterProperty('Rotation', 'TAffineVectorList', iptrw);
    RegisterProperty('Quaternion', 'TQuaternionList', iptrw);
    RegisterProperty('TransformMode', 'TSkeletonFrameTransform', iptrw);
    RegisterMethod('Function LocalMatrixList : PMatrixArray');
    RegisterMethod('Procedure FlushLocalMatrixList');
    RegisterMethod('Procedure ConvertQuaternionsToRotations( KeepQuaternions : Boolean)');
    RegisterMethod('Procedure ConvertRotationsToQuaternions( KeepRotations : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBaseMeshObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistentObject', 'TBaseMeshObject') do
  with CL.AddClassN(CL.FindClass('TPersistentObject'),'TBaseMeshObject') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Translate( const delta : TAffineVector)');
    RegisterMethod('Procedure BuildNormals( vertexIndices : TXIntegerList; mode : TMeshObjectMode; normalIndices : TXIntegerList)');
    RegisterMethod('Function ExtractTriangles( texCoords : TAffineVectorList; normals : TAffineVectorList) : TAffineVectorList');
    RegisterProperty('Name', 'String', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
    RegisterProperty('Vertices', 'TAffineVectorList', iptrw);
    RegisterProperty('Normals', 'TAffineVectorList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GLVectorFileObjects(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TMeshObjectList');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TFaceGroups');
  CL.AddTypeS('TMeshAutoCentering', '( macCenterX, macCenterY, macCenterZ, macUseBarycenter )');
  CL.AddTypeS('TMeshAutoCenterings', 'set of TMeshAutoCentering');
  CL.AddTypeS('TMeshObjectMode', '( momTriangles, momTriangleStrip, momFaceGroups )');
  SIRegister_TBaseMeshObject(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSkeletonFrameList');
  CL.AddTypeS('TSkeletonFrameTransform', '( sftRotation, sftQuaternion )');
  SIRegister_TSkeletonFrame(CL);
  SIRegister_TSkeletonFrameList(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSkeleton');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSkeletonBone');
  SIRegister_TSkeletonBoneList(CL);
  SIRegister_TSkeletonRootBoneList(CL);
  SIRegister_TSkeletonBone(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSkeletonColliderList');
  SIRegister_TSkeletonCollider(CL);
  SIRegister_TSkeletonColliderList(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TGLBaseMesh');
  CL.AddTypeS('TBlendedLerpInfo', 'record frameIndex1 : Integer; frameIndex2 : '
   +'Integer; lerpFactor : Single; weight : Single; externalPositions : TAffine'
   +'VectorList; externalRotations : TAffineVectorList; externalQuaternions : T'
   +'QuaternionList; end');
  SIRegister_TSkeleton(CL);
  CL.AddTypeS('TMeshObjectRenderingOption', '( moroGroupByMaterial )');
  CL.AddTypeS('TMeshObjectRenderingOptions', 'set of TMeshObjectRenderingOption');
  SIRegister_TMeshObject(CL);
  SIRegister_TMeshObjectList(CL);
  //CL.AddTypeS('TMeshObjectListClass', 'class of TMeshObjectList');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TMeshMorphTargetList');
  SIRegister_TMeshMorphTarget(CL);
  SIRegister_TMeshMorphTargetList(CL);
  SIRegister_TMorphableMeshObject(CL);
  CL.AddTypeS('TVertexBoneWeight', 'record BoneID : Integer; Weight : Single; end');
  //CL.AddTypeS('PVertexBoneWeightArray', '^TVertexBoneWeightArray // will not wo'rk');
  //CL.AddTypeS('PVerticesBoneWeights', '^TVerticesBoneWeights // will not work');
  CL.AddTypeS('TVertexBoneWeightDynArray', 'array of TVertexBoneWeight');
  SIRegister_TSkeletonMeshObject(CL);
  SIRegister_TFaceGroup(CL);
  CL.AddTypeS('TFaceGroupMeshMode', '( fgmmTriangles, fgmmTriangleStrip, fgmmFl'
   +'atTriangles, fgmmTriangleFan, fgmmQuads )');
  SIRegister_TFGVertexIndexList(CL);
  SIRegister_TFGVertexNormalTexIndexList(CL);
  SIRegister_TFGIndexTexCoordList(CL);
  SIRegister_TFaceGroups(CL);
  CL.AddTypeS('TMeshNormalsOrientation', '( mnoDefault, mnoInvert )');
  SIRegister_TVectorFile(CL);
  //CL.AddTypeS('TVectorFileClass', 'class of TVectorFile');
  SIRegister_TGLGLSMVectorFile(CL);
  SIRegister_TGLBaseMesh(CL);
  SIRegister_TGLFreeForm(CL);
  CL.AddTypeS('TGLActorOption', '( aoSkeletonNormalizeNormals )');
  CL.AddTypeS('TGLActorOptions', 'set of TGLActorOption');
 CL.AddConstantN('cDefaultGLActorOptions','LongInt').Value.ts32 := ord(aoSkeletonNormalizeNormals);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TGLActor');
  CL.AddTypeS('TActorAnimationReference', '( aarMorph, aarSkeleton, aarNone )');
  SIRegister_TActorAnimation(CL);
  CL.AddTypeS('TActorAnimationName', 'String');
  SIRegister_TActorAnimations(CL);
  SIRegister_TGLBaseAnimationControler(CL);
  SIRegister_TGLAnimationControler(CL);
  CL.AddTypeS('TActorFrameInterpolation', '( afpNone, afpLinear )');
  CL.AddTypeS('TActorAnimationMode', '( aamNone, aamPlayOnce, aamLoop, aamBounc'
   +'eForward, aamBounceBackward, aamLoopBackward, aamExternal )');
  SIRegister_TGLActor(CL);
  SIRegister_TVectorFileFormat(CL);
  SIRegister_TVectorFileFormatsList(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidVectorFile');
 CL.AddDelphiFunction('Function GetVectorFileFormats : TVectorFileFormatsList');
 CL.AddDelphiFunction('Function VectorFileFormatsFilter : String');
 CL.AddDelphiFunction('Function VectorFileFormatsSaveFilter : String');
 CL.AddDelphiFunction('Function VectorFileFormatExtensionByIndex( index : Integer) : String');
 //CL.AddDelphiFunction('Procedure RegisterVectorFileFormat( const aExtension, aDescription : String; aClass : TVectorFileClass)');
 //CL.AddDelphiFunction('Procedure UnregisterVectorFileClass( aClass : TVectorFileClass)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TVectorFileFormatDescResID_W(Self: TVectorFileFormat; const T: Integer);
Begin Self.DescResID := T; end;

(*----------------------------------------------------------------------------*)
procedure TVectorFileFormatDescResID_R(Self: TVectorFileFormat; var T: Integer);
Begin T := Self.DescResID; end;

(*----------------------------------------------------------------------------*)
procedure TVectorFileFormatDescription_W(Self: TVectorFileFormat; const T: String);
Begin Self.Description := T; end;

(*----------------------------------------------------------------------------*)
procedure TVectorFileFormatDescription_R(Self: TVectorFileFormat; var T: String);
Begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TVectorFileFormatExtension_W(Self: TVectorFileFormat; const T: String);
Begin Self.Extension := T; end;

(*----------------------------------------------------------------------------*)
procedure TVectorFileFormatExtension_R(Self: TVectorFileFormat; var T: String);
Begin T := Self.Extension; end;

(*----------------------------------------------------------------------------*)
procedure TVectorFileFormatVectorFileClass_W(Self: TVectorFileFormat; const T: TVectorFileClass);
Begin Self.VectorFileClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TVectorFileFormatVectorFileClass_R(Self: TVectorFileFormat; var T: TVectorFileClass);
Begin T := Self.VectorFileClass; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorAnimations_W(Self: TGLActor; const T: TActorAnimations);
begin Self.Animations := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorAnimations_R(Self: TGLActor; var T: TActorAnimations);
begin T := Self.Animations; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorOnStartFrameReached_W(Self: TGLActor; const T: TNotifyEvent);
begin Self.OnStartFrameReached := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorOnStartFrameReached_R(Self: TGLActor; var T: TNotifyEvent);
begin T := Self.OnStartFrameReached; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorOnEndFrameReached_W(Self: TGLActor; const T: TNotifyEvent);
begin Self.OnEndFrameReached := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorOnEndFrameReached_R(Self: TGLActor; var T: TNotifyEvent);
begin T := Self.OnEndFrameReached; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorOnFrameChanged_W(Self: TGLActor; const T: TNotifyEvent);
begin Self.OnFrameChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorOnFrameChanged_R(Self: TGLActor; var T: TNotifyEvent);
begin T := Self.OnFrameChanged; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorOptions_W(Self: TGLActor; const T: TGLActorOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorOptions_R(Self: TGLActor; var T: TGLActorOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorInterval_W(Self: TGLActor; const T: Integer);
begin Self.Interval := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorInterval_R(Self: TGLActor; var T: Integer);
begin T := Self.Interval; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorAnimationMode_W(Self: TGLActor; const T: TActorAnimationMode);
begin Self.AnimationMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorAnimationMode_R(Self: TGLActor; var T: TActorAnimationMode);
begin T := Self.AnimationMode; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorFrameInterpolation_W(Self: TGLActor; const T: TActorFrameInterpolation);
begin Self.FrameInterpolation := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorFrameInterpolation_R(Self: TGLActor; var T: TActorFrameInterpolation);
begin T := Self.FrameInterpolation; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorCurrentFrameDelta_W(Self: TGLActor; const T: Single);
begin Self.CurrentFrameDelta := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorCurrentFrameDelta_R(Self: TGLActor; var T: Single);
begin T := Self.CurrentFrameDelta; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorCurrentFrame_W(Self: TGLActor; const T: Integer);
begin Self.CurrentFrame := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorCurrentFrame_R(Self: TGLActor; var T: Integer);
begin T := Self.CurrentFrame; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorReference_W(Self: TGLActor; const T: TActorAnimationReference);
begin Self.Reference := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorReference_R(Self: TGLActor; var T: TActorAnimationReference);
begin T := Self.Reference; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorEndFrame_W(Self: TGLActor; const T: Integer);
begin Self.EndFrame := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorEndFrame_R(Self: TGLActor; var T: Integer);
begin T := Self.EndFrame; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorStartFrame_W(Self: TGLActor; const T: Integer);
begin Self.StartFrame := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLActorStartFrame_R(Self: TGLActor; var T: Integer);
begin T := Self.StartFrame; end;

(*----------------------------------------------------------------------------*)
procedure TGLAnimationControlerRatio_W(Self: TGLAnimationControler; const T: Single);
begin Self.Ratio := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLAnimationControlerRatio_R(Self: TGLAnimationControler; var T: Single);
begin T := Self.Ratio; end;

(*----------------------------------------------------------------------------*)
procedure TGLAnimationControlerAnimationName_W(Self: TGLAnimationControler; const T: String);
begin Self.AnimationName := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLAnimationControlerAnimationName_R(Self: TGLAnimationControler; var T: String);
begin T := Self.AnimationName; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseAnimationControlerActor_W(Self: TGLBaseAnimationControler; const T: TGLActor);
begin Self.Actor := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseAnimationControlerActor_R(Self: TGLBaseAnimationControler; var T: TGLActor);
begin T := Self.Actor; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseAnimationControlerEnabled_W(Self: TGLBaseAnimationControler; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseAnimationControlerEnabled_R(Self: TGLBaseAnimationControler; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TActorAnimationsItems_W(Self: TActorAnimations; const T: TActorAnimation; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TActorAnimationsItems_R(Self: TActorAnimations; var T: TActorAnimation; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TActorAnimationReference_W(Self: TActorAnimation; const T: TActorAnimationReference);
begin Self.Reference := T; end;

(*----------------------------------------------------------------------------*)
procedure TActorAnimationReference_R(Self: TActorAnimation; var T: TActorAnimationReference);
begin T := Self.Reference; end;

(*----------------------------------------------------------------------------*)
procedure TActorAnimationEndFrame_W(Self: TActorAnimation; const T: Integer);
begin Self.EndFrame := T; end;

(*----------------------------------------------------------------------------*)
procedure TActorAnimationEndFrame_R(Self: TActorAnimation; var T: Integer);
begin T := Self.EndFrame; end;

(*----------------------------------------------------------------------------*)
procedure TActorAnimationStartFrame_W(Self: TActorAnimation; const T: Integer);
begin Self.StartFrame := T; end;

(*----------------------------------------------------------------------------*)
procedure TActorAnimationStartFrame_R(Self: TActorAnimation; var T: Integer);
begin T := Self.StartFrame; end;

(*----------------------------------------------------------------------------*)
procedure TActorAnimationName_W(Self: TActorAnimation; const T: String);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TActorAnimationName_R(Self: TActorAnimation; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TActorAnimationAsString_W(Self: TActorAnimation; const T: String);
begin Self.AsString := T; end;

(*----------------------------------------------------------------------------*)
procedure TActorAnimationAsString_R(Self: TActorAnimation; var T: String);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TGLFreeFormOctree_R(Self: TGLFreeForm; var T: TOctree);
begin T := Self.Octree; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseMeshOverlaySkeleton_W(Self: TGLBaseMesh; const T: Boolean);
begin Self.OverlaySkeleton := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseMeshOverlaySkeleton_R(Self: TGLBaseMesh; var T: Boolean);
begin T := Self.OverlaySkeleton; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseMeshNormalsOrientation_W(Self: TGLBaseMesh; const T: TMeshNormalsOrientation);
begin Self.NormalsOrientation := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseMeshNormalsOrientation_R(Self: TGLBaseMesh; var T: TMeshNormalsOrientation);
begin T := Self.NormalsOrientation; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseMeshIgnoreMissingTextures_W(Self: TGLBaseMesh; const T: Boolean);
begin Self.IgnoreMissingTextures := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseMeshIgnoreMissingTextures_R(Self: TGLBaseMesh; var T: Boolean);
begin T := Self.IgnoreMissingTextures; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseMeshLightmapLibrary_W(Self: TGLBaseMesh; const T: TGLMaterialLibrary);
begin Self.LightmapLibrary := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseMeshLightmapLibrary_R(Self: TGLBaseMesh; var T: TGLMaterialLibrary);
begin T := Self.LightmapLibrary; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseMeshUseMeshMaterials_W(Self: TGLBaseMesh; const T: Boolean);
begin Self.UseMeshMaterials := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseMeshUseMeshMaterials_R(Self: TGLBaseMesh; var T: Boolean);
begin T := Self.UseMeshMaterials; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseMeshMaterialLibrary_W(Self: TGLBaseMesh; const T: TGLMaterialLibrary);
begin Self.MaterialLibrary := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseMeshMaterialLibrary_R(Self: TGLBaseMesh; var T: TGLMaterialLibrary);
begin T := Self.MaterialLibrary; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseMeshAutoScaling_W(Self: TGLBaseMesh; const T: TGLCoordinates);
begin Self.AutoScaling := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseMeshAutoScaling_R(Self: TGLBaseMesh; var T: TGLCoordinates);
begin T := Self.AutoScaling; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseMeshAutoCentering_W(Self: TGLBaseMesh; const T: TMeshAutoCenterings);
begin Self.AutoCentering := T; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseMeshAutoCentering_R(Self: TGLBaseMesh; var T: TMeshAutoCenterings);
begin T := Self.AutoCentering; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseMeshSkeleton_R(Self: TGLBaseMesh; var T: TSkeleton);
begin T := Self.Skeleton; end;

(*----------------------------------------------------------------------------*)
procedure TGLBaseMeshMeshObjects_R(Self: TGLBaseMesh; var T: TMeshObjectList);
begin T := Self.MeshObjects; end;

(*----------------------------------------------------------------------------*)
procedure TVectorFileNormalsOrientation_W(Self: TVectorFile; const T: TMeshNormalsOrientation);
begin Self.NormalsOrientation := T; end;

(*----------------------------------------------------------------------------*)
procedure TVectorFileNormalsOrientation_R(Self: TVectorFile; var T: TMeshNormalsOrientation);
begin T := Self.NormalsOrientation; end;

(*----------------------------------------------------------------------------*)
procedure TFaceGroupsItems_R(Self: TFaceGroups; var T: TFaceGroup; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TFaceGroupsOwner_R(Self: TFaceGroups; var T: TMeshObject);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TFGIndexTexCoordListTexCoords_W(Self: TFGIndexTexCoordList; const T: TAffineVectorList);
begin Self.TexCoords := T; end;

(*----------------------------------------------------------------------------*)
procedure TFGIndexTexCoordListTexCoords_R(Self: TFGIndexTexCoordList; var T: TAffineVectorList);
begin T := Self.TexCoords; end;

(*----------------------------------------------------------------------------*)
Procedure TFGIndexTexCoordListAdd1_P(Self: TFGIndexTexCoordList;  idx : Integer; const s, t : Single);
Begin Self.Add(idx, s, t); END;

(*----------------------------------------------------------------------------*)
Procedure TFGIndexTexCoordListAdd_P(Self: TFGIndexTexCoordList;  idx : Integer; const texCoord : TAffineVector);
Begin Self.Add(idx, texCoord); END;

(*----------------------------------------------------------------------------*)
procedure TFGVertexNormalTexIndexListTexCoordIndices_W(Self: TFGVertexNormalTexIndexList; const T: TXIntegerList);
begin Self.TexCoordIndices := T; end;

(*----------------------------------------------------------------------------*)
procedure TFGVertexNormalTexIndexListTexCoordIndices_R(Self: TFGVertexNormalTexIndexList; var T: TXIntegerList);
begin T := Self.TexCoordIndices; end;

(*----------------------------------------------------------------------------*)
procedure TFGVertexNormalTexIndexListNormalIndices_W(Self: TFGVertexNormalTexIndexList; const T: TXIntegerList);
begin Self.NormalIndices := T; end;

(*----------------------------------------------------------------------------*)
procedure TFGVertexNormalTexIndexListNormalIndices_R(Self: TFGVertexNormalTexIndexList; var T: TXIntegerList);
begin T := Self.NormalIndices; end;

(*----------------------------------------------------------------------------*)
procedure TFGVertexIndexListVertexIndices_W(Self: TFGVertexIndexList; const T: TXIntegerList);
begin Self.VertexIndices := T; end;

(*----------------------------------------------------------------------------*)
procedure TFGVertexIndexListVertexIndices_R(Self: TFGVertexIndexList; var T: TXIntegerList);
begin T := Self.VertexIndices; end;

(*----------------------------------------------------------------------------*)
procedure TFGVertexIndexListMode_W(Self: TFGVertexIndexList; const T: TFaceGroupMeshMode);
begin Self.Mode := T; end;

(*----------------------------------------------------------------------------*)
procedure TFGVertexIndexListMode_R(Self: TFGVertexIndexList; var T: TFaceGroupMeshMode);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure TFaceGroupLightMapIndex_W(Self: TFaceGroup; const T: Integer);
begin Self.LightMapIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TFaceGroupLightMapIndex_R(Self: TFaceGroup; var T: Integer);
begin T := Self.LightMapIndex; end;

(*----------------------------------------------------------------------------*)
procedure TFaceGroupMaterialCache_R(Self: TFaceGroup; var T: TGLLibMaterial);
begin T := Self.MaterialCache; end;

(*----------------------------------------------------------------------------*)
procedure TFaceGroupMaterialName_W(Self: TFaceGroup; const T: String);
begin Self.MaterialName := T; end;

(*----------------------------------------------------------------------------*)
procedure TFaceGroupMaterialName_R(Self: TFaceGroup; var T: String);
begin T := Self.MaterialName; end;

(*----------------------------------------------------------------------------*)
procedure TFaceGroupOwner_W(Self: TFaceGroup; const T: TFaceGroups);
begin Self.Owner := T; end;

(*----------------------------------------------------------------------------*)
procedure TFaceGroupOwner_R(Self: TFaceGroup; var T: TFaceGroups);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
Function TSkeletonMeshObjectFindOrAdd1_P(Self: TSkeletonMeshObject;  const boneIDs : TVertexBoneWeightDynArray; const vertex, normal : TAffineVector) : Integer;
Begin Result := Self.FindOrAdd(boneIDs, vertex, normal); END;

(*----------------------------------------------------------------------------*)
Function TSkeletonMeshObjectFindOrAdd_P(Self: TSkeletonMeshObject;  boneID : Integer; const vertex, normal : TAffineVector) : Integer;
Begin Result := Self.FindOrAdd(boneID, vertex, normal); END;

(*----------------------------------------------------------------------------*)
procedure TSkeletonMeshObjectBonesPerVertex_W(Self: TSkeletonMeshObject; const T: Integer);
begin Self.BonesPerVertex := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonMeshObjectBonesPerVertex_R(Self: TSkeletonMeshObject; var T: Integer);
begin T := Self.BonesPerVertex; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonMeshObjectVerticeBoneWeightCapacity_W(Self: TSkeletonMeshObject; const T: Integer);
begin Self.VerticeBoneWeightCapacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonMeshObjectVerticeBoneWeightCapacity_R(Self: TSkeletonMeshObject; var T: Integer);
begin T := Self.VerticeBoneWeightCapacity; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonMeshObjectVerticeBoneWeightCount_W(Self: TSkeletonMeshObject; const T: Integer);
begin Self.VerticeBoneWeightCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonMeshObjectVerticeBoneWeightCount_R(Self: TSkeletonMeshObject; var T: Integer);
begin T := Self.VerticeBoneWeightCount; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonMeshObjectVerticesBonesWeights_R(Self: TSkeletonMeshObject; var T: PVerticesBoneWeights);
begin T := Self.VerticesBonesWeights; end;

(*----------------------------------------------------------------------------*)
procedure TMorphableMeshObjectMorphTargets_R(Self: TMorphableMeshObject; var T: TMeshMorphTargetList);
begin T := Self.MorphTargets; end;

(*----------------------------------------------------------------------------*)
procedure TMeshMorphTargetListItems_R(Self: TMeshMorphTargetList; var T: TMeshMorphTarget; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMeshMorphTargetListOwner_R(Self: TMeshMorphTargetList; var T: TPersistent);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TMeshMorphTargetOwner_R(Self: TMeshMorphTarget; var T: TMeshMorphTargetList);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectListItems_R(Self: TMeshObjectList; var T: TMeshObject; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectListOwner_R(Self: TMeshObjectList; var T: TGLBaseMesh);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectTangentsTexCoordIndex_W(Self: TMeshObject; const T: Integer);
begin Self.TangentsTexCoordIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectTangentsTexCoordIndex_R(Self: TMeshObject; var T: Integer);
begin T := Self.TangentsTexCoordIndex; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectBinormalsTexCoordIndex_W(Self: TMeshObject; const T: Integer);
begin Self.BinormalsTexCoordIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectBinormalsTexCoordIndex_R(Self: TMeshObject; var T: Integer);
begin T := Self.BinormalsTexCoordIndex; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectTangents_W(Self: TMeshObject; const T: TVectorList);
begin Self.Tangents := T; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectTangents_R(Self: TMeshObject; var T: TVectorList);
begin T := Self.Tangents; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectBinormals_W(Self: TMeshObject; const T: TVectorList);
begin Self.Binormals := T; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectBinormals_R(Self: TMeshObject; var T: TVectorList);
begin T := Self.Binormals; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectTexCoordsEx_W(Self: TMeshObject; const T: TVectorList; const t1: Integer);
begin Self.TexCoordsEx[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectTexCoordsEx_R(Self: TMeshObject; var T: TVectorList; const t1: Integer);
begin T := Self.TexCoordsEx[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectRenderingOptions_W(Self: TMeshObject; const T: TMeshObjectRenderingOptions);
begin Self.RenderingOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectRenderingOptions_R(Self: TMeshObject; var T: TMeshObjectRenderingOptions);
begin T := Self.RenderingOptions; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectFaceGroups_R(Self: TMeshObject; var T: TFaceGroups);
begin T := Self.FaceGroups; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectColors_W(Self: TMeshObject; const T: TVectorList);
begin Self.Colors := T; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectColors_R(Self: TMeshObject; var T: TVectorList);
begin T := Self.Colors; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectLightMapTexCoords_W(Self: TMeshObject; const T: TTexPointList);
begin Self.LightMapTexCoords := T; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectLightMapTexCoords_R(Self: TMeshObject; var T: TTexPointList);
begin T := Self.LightMapTexCoords; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectTexCoords_W(Self: TMeshObject; const T: TAffineVectorList);
begin Self.TexCoords := T; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectTexCoords_R(Self: TMeshObject; var T: TAffineVectorList);
begin T := Self.TexCoords; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectMode_W(Self: TMeshObject; const T: TMeshObjectMode);
begin Self.Mode := T; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectMode_R(Self: TMeshObject; var T: TMeshObjectMode);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure TMeshObjectOwner_R(Self: TMeshObject; var T: TMeshObjectList);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
Procedure TMeshObjectSetTriangleData1_P(Self: TMeshObject;  tri : Integer; list : TVectorList; const v0, v1, v2 : TVector);
Begin Self.SetTriangleData(tri, list, v0, v1, v2); END;

(*----------------------------------------------------------------------------*)
Procedure TMeshObjectSetTriangleData_P(Self: TMeshObject;  tri : Integer; list : TAffineVectorList; const v0, v1, v2 : TAffineVector);
Begin Self.SetTriangleData(tri, list, v0, v1, v2); END;

(*----------------------------------------------------------------------------*)
Procedure TMeshObjectGetTriangleData1_P(Self: TMeshObject;  tri : Integer; list : TVectorList; var v0, v1, v2 : TVector);
Begin Self.GetTriangleData(tri, list, v0, v1, v2); END;

(*----------------------------------------------------------------------------*)
Procedure TMeshObjectGetTriangleData_P(Self: TMeshObject;  tri : Integer; list : TAffineVectorList; var v0, v1, v2 : TAffineVector);
Begin Self.GetTriangleData(tri, list, v0, v1, v2); END;

(*----------------------------------------------------------------------------*)
Procedure TSkeletonMorphTo1_P(Self: TSkeleton;  frame : TSkeletonFrame);
Begin Self.MorphTo(frame); END;

(*----------------------------------------------------------------------------*)
Procedure TSkeletonMorphTo_P(Self: TSkeleton;  frameIndex : Integer);
Begin Self.MorphTo(frameIndex); END;

(*----------------------------------------------------------------------------*)
procedure TSkeletonColliders_W(Self: TSkeleton; const T: TSkeletonColliderList);
begin Self.Colliders := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonColliders_R(Self: TSkeleton; var T: TSkeletonColliderList);
begin T := Self.Colliders; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonCurrentFrame_W(Self: TSkeleton; const T: TSkeletonFrame);
begin Self.CurrentFrame := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonCurrentFrame_R(Self: TSkeleton; var T: TSkeletonFrame);
begin T := Self.CurrentFrame; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonFrames_W(Self: TSkeleton; const T: TSkeletonFrameList);
begin Self.Frames := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonFrames_R(Self: TSkeleton; var T: TSkeletonFrameList);
begin T := Self.Frames; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonRootBones_W(Self: TSkeleton; const T: TSkeletonRootBoneList);
begin Self.RootBones := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonRootBones_R(Self: TSkeleton; var T: TSkeletonRootBoneList);
begin T := Self.RootBones; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonOwner_R(Self: TSkeleton; var T: TGLBaseMesh);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonColliderListItems_R(Self: TSkeletonColliderList; var T: TSkeletonCollider; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonColliderListOwner_R(Self: TSkeletonColliderList; var T: TPersistent);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonColliderAutoUpdate_W(Self: TSkeletonCollider; const T: Boolean);
begin Self.AutoUpdate := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonColliderAutoUpdate_R(Self: TSkeletonCollider; var T: Boolean);
begin T := Self.AutoUpdate; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonColliderGlobalMatrix_R(Self: TSkeletonCollider; var T: TMatrix);
begin T := Self.GlobalMatrix; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonColliderLocalMatrix_W(Self: TSkeletonCollider; const T: TMatrix);
begin Self.LocalMatrix := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonColliderLocalMatrix_R(Self: TSkeletonCollider; var T: TMatrix);
begin T := Self.LocalMatrix; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonColliderBone_W(Self: TSkeletonCollider; const T: TSkeletonBone);
begin Self.Bone := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonColliderBone_R(Self: TSkeletonCollider; var T: TSkeletonBone);
begin T := Self.Bone; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonColliderOwner_R(Self: TSkeletonCollider; var T: TSkeletonColliderList);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonBoneGlobalMatrix_R(Self: TSkeletonBone; var T: TMatrix);
begin T := Self.GlobalMatrix; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonBoneItems_R(Self: TSkeletonBone; var T: TSkeletonBone; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonBoneColor_W(Self: TSkeletonBone; const T: Cardinal);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonBoneColor_R(Self: TSkeletonBone; var T: Cardinal);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonBoneBoneID_W(Self: TSkeletonBone; const T: Integer);
begin Self.BoneID := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonBoneBoneID_R(Self: TSkeletonBone; var T: Integer);
begin T := Self.BoneID; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonBoneName_W(Self: TSkeletonBone; const T: String);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonBoneName_R(Self: TSkeletonBone; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonBoneOwner_R(Self: TSkeletonBone; var T: TSkeletonBoneList);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonRootBoneListGlobalMatrix_W(Self: TSkeletonRootBoneList; const T: TMatrix);
begin Self.GlobalMatrix := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonRootBoneListGlobalMatrix_R(Self: TSkeletonRootBoneList; var T: TMatrix);
begin T := Self.GlobalMatrix; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonBoneListItems_R(Self: TSkeletonBoneList; var T: TSkeletonBone; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonBoneListSkeleton_R(Self: TSkeletonBoneList; var T: TSkeleton);
begin T := Self.Skeleton; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonFrameListItems_R(Self: TSkeletonFrameList; var T: TSkeletonFrame; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonFrameListOwner_R(Self: TSkeletonFrameList; var T: TPersistent);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonFrameTransformMode_W(Self: TSkeletonFrame; const T: TSkeletonFrameTransform);
begin Self.TransformMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonFrameTransformMode_R(Self: TSkeletonFrame; var T: TSkeletonFrameTransform);
begin T := Self.TransformMode; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonFrameQuaternion_W(Self: TSkeletonFrame; const T: TQuaternionList);
begin Self.Quaternion := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonFrameQuaternion_R(Self: TSkeletonFrame; var T: TQuaternionList);
begin T := Self.Quaternion; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonFrameRotation_W(Self: TSkeletonFrame; const T: TAffineVectorList);
begin Self.Rotation := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonFrameRotation_R(Self: TSkeletonFrame; var T: TAffineVectorList);
begin T := Self.Rotation; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonFramePosition_W(Self: TSkeletonFrame; const T: TAffineVectorList);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonFramePosition_R(Self: TSkeletonFrame; var T: TAffineVectorList);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonFrameName_W(Self: TSkeletonFrame; const T: String);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonFrameName_R(Self: TSkeletonFrame; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TSkeletonFrameOwner_R(Self: TSkeletonFrame; var T: TSkeletonFrameList);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TBaseMeshObjectNormals_W(Self: TBaseMeshObject; const T: TAffineVectorList);
begin Self.Normals := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseMeshObjectNormals_R(Self: TBaseMeshObject; var T: TAffineVectorList);
begin T := Self.Normals; end;

(*----------------------------------------------------------------------------*)
procedure TBaseMeshObjectVertices_W(Self: TBaseMeshObject; const T: TAffineVectorList);
begin Self.Vertices := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseMeshObjectVertices_R(Self: TBaseMeshObject; var T: TAffineVectorList);
begin T := Self.Vertices; end;

(*----------------------------------------------------------------------------*)
procedure TBaseMeshObjectVisible_W(Self: TBaseMeshObject; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseMeshObjectVisible_R(Self: TBaseMeshObject; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TBaseMeshObjectName_W(Self: TBaseMeshObject; const T: String);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseMeshObjectName_R(Self: TBaseMeshObject; var T: String);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GLVectorFileObjects_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetVectorFileFormats, 'GetVectorFileFormats', cdRegister);
 S.RegisterDelphiFunction(@VectorFileFormatsFilter, 'VectorFileFormatsFilter', cdRegister);
 S.RegisterDelphiFunction(@VectorFileFormatsSaveFilter, 'VectorFileFormatsSaveFilter', cdRegister);
 S.RegisterDelphiFunction(@VectorFileFormatExtensionByIndex, 'VectorFileFormatExtensionByIndex', cdRegister);
 S.RegisterDelphiFunction(@RegisterVectorFileFormat, 'RegisterVectorFileFormat', cdRegister);
 S.RegisterDelphiFunction(@UnregisterVectorFileClass, 'UnregisterVectorFileClass', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVectorFileFormatsList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVectorFileFormatsList) do
  begin
    RegisterMethod(@TVectorFileFormatsList.Add, 'Add');
    RegisterMethod(@TVectorFileFormatsList.FindExt, 'FindExt');
    RegisterMethod(@TVectorFileFormatsList.FindFromFileName, 'FindFromFileName');
    RegisterMethod(@TVectorFileFormatsList.Remove, 'Remove');
    RegisterMethod(@TVectorFileFormatsList.BuildFilterStrings, 'BuildFilterStrings');
    RegisterMethod(@TVectorFileFormatsList.FindExtByIndex, 'FindExtByIndex');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVectorFileFormat(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVectorFileFormat) do
  begin
    RegisterPropertyHelper(@TVectorFileFormatVectorFileClass_R,@TVectorFileFormatVectorFileClass_W,'VectorFileClass');
    RegisterPropertyHelper(@TVectorFileFormatExtension_R,@TVectorFileFormatExtension_W,'Extension');
    RegisterPropertyHelper(@TVectorFileFormatDescription_R,@TVectorFileFormatDescription_W,'Description');
    RegisterPropertyHelper(@TVectorFileFormatDescResID_R,@TVectorFileFormatDescResID_W,'DescResID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGLActor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGLActor) do begin
    RegisterConstructor(@TGLActor.Create, 'Create');
    RegisterMethod(@TGLActor.Assign, 'Assign');
    RegisterMethod(@TGLActor.BuildList, 'BuildList');
    RegisterMethod(@TGLActor.DoProgress, 'DoProgress');
    RegisterMethod(@TGLActor.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TGLActor.SwitchToAnimation, 'SwitchToAnimation');
    RegisterMethod(@TGLActor.SwitchToAnimation, 'SwitchToAnimation');
    RegisterMethod(@TGLActor.SwitchToAnimation, 'SwitchToAnimation');
    RegisterMethod(@TGLActor.CurrentAnimation, 'CurrentAnimation');
    RegisterMethod(@TGLActor.Synchronize, 'Synchronize');
    RegisterMethod(@TGLActor.NextFrameIndex, 'NextFrameIndex');
    RegisterMethod(@TGLActor.NextFrame, 'NextFrame');
    RegisterMethod(@TGLActor.PrevFrame, 'PrevFrame');
    RegisterMethod(@TGLActor.FrameCount, 'FrameCount');
    RegisterMethod(@TGLActor.isSwitchingAnimation, 'isSwitchingAnimation');
    RegisterPropertyHelper(@TGLActorStartFrame_R,@TGLActorStartFrame_W,'StartFrame');
    RegisterPropertyHelper(@TGLActorEndFrame_R,@TGLActorEndFrame_W,'EndFrame');
    RegisterPropertyHelper(@TGLActorReference_R,@TGLActorReference_W,'Reference');
    RegisterPropertyHelper(@TGLActorCurrentFrame_R,@TGLActorCurrentFrame_W,'CurrentFrame');
    RegisterPropertyHelper(@TGLActorCurrentFrameDelta_R,@TGLActorCurrentFrameDelta_W,'CurrentFrameDelta');
    RegisterPropertyHelper(@TGLActorFrameInterpolation_R,@TGLActorFrameInterpolation_W,'FrameInterpolation');
    RegisterPropertyHelper(@TGLActorAnimationMode_R,@TGLActorAnimationMode_W,'AnimationMode');
    RegisterPropertyHelper(@TGLActorInterval_R,@TGLActorInterval_W,'Interval');
    RegisterPropertyHelper(@TGLActorOptions_R,@TGLActorOptions_W,'Options');
    RegisterPropertyHelper(@TGLActorOnFrameChanged_R,@TGLActorOnFrameChanged_W,'OnFrameChanged');
    RegisterPropertyHelper(@TGLActorOnEndFrameReached_R,@TGLActorOnEndFrameReached_W,'OnEndFrameReached');
    RegisterPropertyHelper(@TGLActorOnStartFrameReached_R,@TGLActorOnStartFrameReached_W,'OnStartFrameReached');
    RegisterPropertyHelper(@TGLActorAnimations_R,@TGLActorAnimations_W,'Animations');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGLAnimationControler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGLAnimationControler) do
  begin
    RegisterPropertyHelper(@TGLAnimationControlerAnimationName_R,@TGLAnimationControlerAnimationName_W,'AnimationName');
    RegisterPropertyHelper(@TGLAnimationControlerRatio_R,@TGLAnimationControlerRatio_W,'Ratio');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGLBaseAnimationControler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGLBaseAnimationControler) do
  begin
    RegisterConstructor(@TGLBaseAnimationControler.Create, 'Create');
    RegisterPropertyHelper(@TGLBaseAnimationControlerEnabled_R,@TGLBaseAnimationControlerEnabled_W,'Enabled');
    RegisterPropertyHelper(@TGLBaseAnimationControlerActor_R,@TGLBaseAnimationControlerActor_W,'Actor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActorAnimations(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActorAnimations) do
  begin
    RegisterConstructor(@TActorAnimations.Create, 'Create');
    RegisterMethod(@TActorAnimations.Add, 'Add');
    RegisterMethod(@TActorAnimations.FindItemID, 'FindItemID');
    RegisterMethod(@TActorAnimations.FindName, 'FindName');
    RegisterMethod(@TActorAnimations.FindFrame, 'FindFrame');
    RegisterMethod(@TActorAnimations.SetToStrings, 'SetToStrings');
    RegisterMethod(@TActorAnimations.SaveToStream, 'SaveToStream');
    RegisterMethod(@TActorAnimations.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TActorAnimations.SaveToFile, 'SaveToFile');
    RegisterMethod(@TActorAnimations.LoadFromFile, 'LoadFromFile');
    RegisterPropertyHelper(@TActorAnimationsItems_R,@TActorAnimationsItems_W,'Items');
    RegisterMethod(@TActorAnimations.Last, 'Last');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TActorAnimation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActorAnimation) do
  begin
    RegisterConstructor(@TActorAnimation.Create, 'Create');
    RegisterMethod(@TActorAnimation.Assign, 'Assign');
    RegisterPropertyHelper(@TActorAnimationAsString_R,@TActorAnimationAsString_W,'AsString');
    RegisterMethod(@TActorAnimation.OwnerActor, 'OwnerActor');
    RegisterMethod(@TActorAnimation.MakeSkeletalTranslationStatic, 'MakeSkeletalTranslationStatic');
    RegisterMethod(@TActorAnimation.MakeSkeletalRotationDelta, 'MakeSkeletalRotationDelta');
    RegisterPropertyHelper(@TActorAnimationName_R,@TActorAnimationName_W,'Name');
    RegisterPropertyHelper(@TActorAnimationStartFrame_R,@TActorAnimationStartFrame_W,'StartFrame');
    RegisterPropertyHelper(@TActorAnimationEndFrame_R,@TActorAnimationEndFrame_W,'EndFrame');
    RegisterPropertyHelper(@TActorAnimationReference_R,@TActorAnimationReference_W,'Reference');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGLFreeForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGLFreeForm) do
  begin
    RegisterConstructor(@TGLFreeForm.Create, 'Create');
    RegisterMethod(@TGLFreeForm.OctreeRayCastIntersect, 'OctreeRayCastIntersect');
    RegisterMethod(@TGLFreeForm.OctreeSphereSweepIntersect, 'OctreeSphereSweepIntersect');
    RegisterMethod(@TGLFreeForm.OctreeTriangleIntersect, 'OctreeTriangleIntersect');
    RegisterMethod(@TGLFreeForm.OctreePointInMesh, 'OctreePointInMesh');
    RegisterMethod(@TGLFreeForm.OctreeAABBIntersect, 'OctreeAABBIntersect');
    RegisterPropertyHelper(@TGLFreeFormOctree_R,nil,'Octree');
    RegisterMethod(@TGLFreeForm.BuildOctree, 'BuildOctree');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGLBaseMesh(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGLBaseMesh) do
  begin
    RegisterConstructor(@TGLBaseMesh.Create, 'Create');
    RegisterMethod(@TGLBaseMesh.Assign, 'Assign');
    RegisterMethod(@TGLBaseMesh.Notification, 'Notification');
    RegisterMethod(@TGLBaseMesh.AxisAlignedDimensionsUnscaled, 'AxisAlignedDimensionsUnscaled');
    RegisterMethod(@TGLBaseMesh.BuildList, 'BuildList');
    RegisterMethod(@TGLBaseMesh.DoRender, 'DoRender');
    RegisterMethod(@TGLBaseMesh.StructureChanged, 'StructureChanged');
    RegisterMethod(@TGLBaseMesh.StructureChangedNoPrepare, 'StructureChangedNoPrepare');
    RegisterMethod(@TGLBaseMesh.RayCastIntersect, 'RayCastIntersect');
    RegisterMethod(@TGLBaseMesh.GenerateSilhouette, 'GenerateSilhouette');
    RegisterMethod(@TGLBaseMesh.BuildSilhouetteConnectivityData, 'BuildSilhouetteConnectivityData');
    RegisterPropertyHelper(@TGLBaseMeshMeshObjects_R,nil,'MeshObjects');
    RegisterPropertyHelper(@TGLBaseMeshSkeleton_R,nil,'Skeleton');
    RegisterMethod(@TGLBaseMesh.GetExtents, 'GetExtents');
    RegisterMethod(@TGLBaseMesh.GetBarycenter, 'GetBarycenter');
    RegisterVirtualMethod(@TGLBaseMesh.PerformAutoCentering, 'PerformAutoCentering');
    RegisterVirtualMethod(@TGLBaseMesh.PerformAutoScaling, 'PerformAutoScaling');
    RegisterVirtualMethod(@TGLBaseMesh.LoadFromFile, 'LoadFromFile');
    RegisterVirtualMethod(@TGLBaseMesh.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TGLBaseMesh.SaveToFile, 'SaveToFile');
    RegisterVirtualMethod(@TGLBaseMesh.SaveToStream, 'SaveToStream');
    RegisterVirtualMethod(@TGLBaseMesh.AddDataFromFile, 'AddDataFromFile');
    RegisterVirtualMethod(@TGLBaseMesh.AddDataFromStream, 'AddDataFromStream');
    RegisterMethod(@TGLBaseMesh.LastLoadedFilename, 'LastLoadedFilename');
    RegisterPropertyHelper(@TGLBaseMeshAutoCentering_R,@TGLBaseMeshAutoCentering_W,'AutoCentering');
    RegisterPropertyHelper(@TGLBaseMeshAutoScaling_R,@TGLBaseMeshAutoScaling_W,'AutoScaling');
    RegisterPropertyHelper(@TGLBaseMeshMaterialLibrary_R,@TGLBaseMeshMaterialLibrary_W,'MaterialLibrary');
    RegisterPropertyHelper(@TGLBaseMeshUseMeshMaterials_R,@TGLBaseMeshUseMeshMaterials_W,'UseMeshMaterials');
    RegisterPropertyHelper(@TGLBaseMeshLightmapLibrary_R,@TGLBaseMeshLightmapLibrary_W,'LightmapLibrary');
    RegisterPropertyHelper(@TGLBaseMeshIgnoreMissingTextures_R,@TGLBaseMeshIgnoreMissingTextures_W,'IgnoreMissingTextures');
    RegisterPropertyHelper(@TGLBaseMeshNormalsOrientation_R,@TGLBaseMeshNormalsOrientation_W,'NormalsOrientation');
    RegisterPropertyHelper(@TGLBaseMeshOverlaySkeleton_R,@TGLBaseMeshOverlaySkeleton_W,'OverlaySkeleton');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGLGLSMVectorFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGLGLSMVectorFile) do
  begin
    RegisterMethod(@TGLGLSMVectorFile.Capabilities, 'Capabilities');
    RegisterMethod(@TGLGLSMVectorFile.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TGLGLSMVectorFile.SaveToStream, 'SaveToStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVectorFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVectorFile) do
  begin
    RegisterConstructor(@TVectorFile.Create, 'Create');
    RegisterMethod(@TVectorFile.Owner, 'Owner');
    RegisterPropertyHelper(@TVectorFileNormalsOrientation_R,@TVectorFileNormalsOrientation_W,'NormalsOrientation');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFaceGroups(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFaceGroups) do
  begin
    RegisterConstructor(@TFaceGroups.CreateOwned, 'CreateOwned');
    RegisterMethod(@TFaceGroups.ReadFromFiler, 'ReadFromFiler');
    RegisterMethod(@TFaceGroups.PrepareMaterialLibraryCache, 'PrepareMaterialLibraryCache');
    RegisterMethod(@TFaceGroups.DropMaterialLibraryCache, 'DropMaterialLibraryCache');
    RegisterPropertyHelper(@TFaceGroupsOwner_R,nil,'Owner');
    RegisterMethod(@TFaceGroups.Clear, 'Clear');
    RegisterPropertyHelper(@TFaceGroupsItems_R,nil,'Items');
    RegisterMethod(@TFaceGroups.AddToTriangles, 'AddToTriangles');
    RegisterMethod(@TFaceGroups.MaterialLibrary, 'MaterialLibrary');
    RegisterMethod(@TFaceGroups.SortByMaterial, 'SortByMaterial');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFGIndexTexCoordList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFGIndexTexCoordList) do
  begin
    RegisterConstructor(@TFGIndexTexCoordList.Create, 'Create');
    RegisterMethod(@TFGIndexTexCoordList.WriteToFiler, 'WriteToFiler');
    RegisterMethod(@TFGIndexTexCoordList.ReadFromFiler, 'ReadFromFiler');
    RegisterMethod(@TFGIndexTexCoordList.BuildList, 'BuildList');
    RegisterMethod(@TFGIndexTexCoordList.AddToTriangles, 'AddToTriangles');
    RegisterMethod(@TFGIndexTexCoordListAdd_P, 'Add');
    RegisterMethod(@TFGIndexTexCoordListAdd1_P, 'Add1');
    RegisterPropertyHelper(@TFGIndexTexCoordListTexCoords_R,@TFGIndexTexCoordListTexCoords_W,'TexCoords');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFGVertexNormalTexIndexList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFGVertexNormalTexIndexList) do
  begin
    RegisterConstructor(@TFGVertexNormalTexIndexList.Create, 'Create');
    RegisterMethod(@TFGVertexNormalTexIndexList.WriteToFiler, 'WriteToFiler');
    RegisterMethod(@TFGVertexNormalTexIndexList.ReadFromFiler, 'ReadFromFiler');
    RegisterMethod(@TFGVertexNormalTexIndexList.BuildList, 'BuildList');
    RegisterMethod(@TFGVertexNormalTexIndexList.AddToTriangles, 'AddToTriangles');
    RegisterMethod(@TFGVertexNormalTexIndexList.Add, 'Add');
    RegisterPropertyHelper(@TFGVertexNormalTexIndexListNormalIndices_R,@TFGVertexNormalTexIndexListNormalIndices_W,'NormalIndices');
    RegisterPropertyHelper(@TFGVertexNormalTexIndexListTexCoordIndices_R,@TFGVertexNormalTexIndexListTexCoordIndices_W,'TexCoordIndices');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFGVertexIndexList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFGVertexIndexList) do
  begin
    RegisterConstructor(@TFGVertexIndexList.Create, 'Create');
    RegisterMethod(@TFGVertexIndexList.WriteToFiler, 'WriteToFiler');
    RegisterMethod(@TFGVertexIndexList.ReadFromFiler, 'ReadFromFiler');
    RegisterMethod(@TFGVertexIndexList.BuildList, 'BuildList');
    RegisterMethod(@TFGVertexIndexList.AddToTriangles, 'AddToTriangles');
    RegisterMethod(@TFGVertexIndexList.Add, 'Add');
    RegisterMethod(@TFGVertexIndexList.GetExtents, 'GetExtents');
    RegisterMethod(@TFGVertexIndexList.ConvertToList, 'ConvertToList');
    RegisterMethod(@TFGVertexIndexList.GetNormal, 'GetNormal');
    RegisterPropertyHelper(@TFGVertexIndexListMode_R,@TFGVertexIndexListMode_W,'Mode');
    RegisterPropertyHelper(@TFGVertexIndexListVertexIndices_R,@TFGVertexIndexListVertexIndices_W,'VertexIndices');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFaceGroup(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFaceGroup) do
  begin
    RegisterVirtualConstructor(@TFaceGroup.CreateOwned, 'CreateOwned');
    RegisterMethod(@TFaceGroup.WriteToFiler, 'WriteToFiler');
    RegisterMethod(@TFaceGroup.ReadFromFiler, 'ReadFromFiler');
    RegisterMethod(@TFaceGroup.PrepareMaterialLibraryCache, 'PrepareMaterialLibraryCache');
    RegisterMethod(@TFaceGroup.DropMaterialLibraryCache, 'DropMaterialLibraryCache');
    //RegisterVirtualAbstractMethod(@TFaceGroup, @!.BuildList, 'BuildList');
    RegisterVirtualMethod(@TFaceGroup.AddToTriangles, 'AddToTriangles');
    //RegisterVirtualAbstractMethod(@TFaceGroup, @!.TriangleCount, 'TriangleCount');
    RegisterVirtualMethod(@TFaceGroup.Reverse, 'Reverse');
    RegisterVirtualMethod(@TFaceGroup.Prepare, 'Prepare');
    RegisterPropertyHelper(@TFaceGroupOwner_R,@TFaceGroupOwner_W,'Owner');
    RegisterPropertyHelper(@TFaceGroupMaterialName_R,@TFaceGroupMaterialName_W,'MaterialName');
    RegisterPropertyHelper(@TFaceGroupMaterialCache_R,nil,'MaterialCache');
    RegisterPropertyHelper(@TFaceGroupLightMapIndex_R,@TFaceGroupLightMapIndex_W,'LightMapIndex');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSkeletonMeshObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSkeletonMeshObject) do
  begin
    RegisterConstructor(@TSkeletonMeshObject.Create, 'Create');
    RegisterMethod(@TSkeletonMeshObject.WriteToFiler, 'WriteToFiler');
    RegisterMethod(@TSkeletonMeshObject.ReadFromFiler, 'ReadFromFiler');
    RegisterMethod(@TSkeletonMeshObject.Clear, 'Clear');
    RegisterPropertyHelper(@TSkeletonMeshObjectVerticesBonesWeights_R,nil,'VerticesBonesWeights');
    RegisterPropertyHelper(@TSkeletonMeshObjectVerticeBoneWeightCount_R,@TSkeletonMeshObjectVerticeBoneWeightCount_W,'VerticeBoneWeightCount');
    RegisterPropertyHelper(@TSkeletonMeshObjectVerticeBoneWeightCapacity_R,@TSkeletonMeshObjectVerticeBoneWeightCapacity_W,'VerticeBoneWeightCapacity');
    RegisterPropertyHelper(@TSkeletonMeshObjectBonesPerVertex_R,@TSkeletonMeshObjectBonesPerVertex_W,'BonesPerVertex');
    RegisterMethod(@TSkeletonMeshObjectFindOrAdd_P, 'FindOrAdd');
    RegisterMethod(@TSkeletonMeshObjectFindOrAdd1_P, 'FindOrAdd1');
    RegisterMethod(@TSkeletonMeshObject.AddWeightedBone, 'AddWeightedBone');
    RegisterMethod(@TSkeletonMeshObject.AddWeightedBones, 'AddWeightedBones');
    RegisterMethod(@TSkeletonMeshObject.PrepareBoneMatrixInvertedMeshes, 'PrepareBoneMatrixInvertedMeshes');
    RegisterMethod(@TSkeletonMeshObject.ApplyCurrentSkeletonFrame, 'ApplyCurrentSkeletonFrame');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMorphableMeshObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMorphableMeshObject) do
  begin
    RegisterConstructor(@TMorphableMeshObject.Create, 'Create');
    RegisterMethod(@TMorphableMeshObject.WriteToFiler, 'WriteToFiler');
    RegisterMethod(@TMorphableMeshObject.ReadFromFiler, 'ReadFromFiler');
    RegisterMethod(@TMorphableMeshObject.Clear, 'Clear');
    RegisterMethod(@TMorphableMeshObject.Translate, 'Translate');
    RegisterMethod(@TMorphableMeshObject.MorphTo, 'MorphTo');
    RegisterMethod(@TMorphableMeshObject.Lerp, 'Lerp');
    RegisterPropertyHelper(@TMorphableMeshObjectMorphTargets_R,nil,'MorphTargets');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMeshMorphTargetList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMeshMorphTargetList) do
  begin
    RegisterConstructor(@TMeshMorphTargetList.CreateOwned, 'CreateOwned');
    RegisterMethod(@TMeshMorphTargetList.ReadFromFiler, 'ReadFromFiler');
    RegisterMethod(@TMeshMorphTargetList.Translate, 'Translate');
    RegisterPropertyHelper(@TMeshMorphTargetListOwner_R,nil,'Owner');
    RegisterMethod(@TMeshMorphTargetList.Clear, 'Clear');
    RegisterPropertyHelper(@TMeshMorphTargetListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMeshMorphTarget(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMeshMorphTarget) do
  begin
    RegisterConstructor(@TMeshMorphTarget.CreateOwned, 'CreateOwned');
    RegisterMethod(@TMeshMorphTarget.WriteToFiler, 'WriteToFiler');
    RegisterMethod(@TMeshMorphTarget.ReadFromFiler, 'ReadFromFiler');
    RegisterPropertyHelper(@TMeshMorphTargetOwner_R,nil,'Owner');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMeshObjectList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMeshObjectList) do
  begin
    RegisterConstructor(@TMeshObjectList.CreateOwned, 'CreateOwned');
    RegisterMethod(@TMeshObjectList.ReadFromFiler, 'ReadFromFiler');
    RegisterMethod(@TMeshObjectList.PrepareMaterialLibraryCache, 'PrepareMaterialLibraryCache');
    RegisterMethod(@TMeshObjectList.DropMaterialLibraryCache, 'DropMaterialLibraryCache');
    RegisterVirtualMethod(@TMeshObjectList.PrepareBuildList, 'PrepareBuildList');
    RegisterVirtualMethod(@TMeshObjectList.BuildList, 'BuildList');
    RegisterMethod(@TMeshObjectList.MorphTo, 'MorphTo');
    RegisterMethod(@TMeshObjectList.Lerp, 'Lerp');
    RegisterMethod(@TMeshObjectList.MorphTargetCount, 'MorphTargetCount');
    RegisterMethod(@TMeshObjectList.GetExtents, 'GetExtents');
    RegisterMethod(@TMeshObjectList.Translate, 'Translate');
    RegisterMethod(@TMeshObjectList.ExtractTriangles, 'ExtractTriangles');
    RegisterMethod(@TMeshObjectList.TriangleCount, 'TriangleCount');
    RegisterVirtualMethod(@TMeshObjectList.Prepare, 'Prepare');
    RegisterMethod(@TMeshObjectList.FindMeshByName, 'FindMeshByName');
    RegisterPropertyHelper(@TMeshObjectListOwner_R,nil,'Owner');
    RegisterPropertyHelper(@TMeshObjectListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMeshObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMeshObject) do
  begin
    RegisterConstructor(@TMeshObject.CreateOwned, 'CreateOwned');
    RegisterConstructor(@TMeshObject.Create, 'Create');
    RegisterMethod(@TMeshObject.WriteToFiler, 'WriteToFiler');
    RegisterMethod(@TMeshObject.ReadFromFiler, 'ReadFromFiler');
    RegisterMethod(@TMeshObject.Clear, 'Clear');
    RegisterMethod(@TMeshObject.ExtractTriangles, 'ExtractTriangles');
    RegisterVirtualMethod(@TMeshObject.TriangleCount, 'TriangleCount');
    RegisterMethod(@TMeshObject.PrepareMaterialLibraryCache, 'PrepareMaterialLibraryCache');
    RegisterMethod(@TMeshObject.DropMaterialLibraryCache, 'DropMaterialLibraryCache');
    RegisterVirtualMethod(@TMeshObject.PrepareBuildList, 'PrepareBuildList');
    RegisterVirtualMethod(@TMeshObject.BuildList, 'BuildList');
    RegisterVirtualMethod(@TMeshObject.GetExtents, 'GetExtents');
    RegisterVirtualMethod(@TMeshObject.Prepare, 'Prepare');
    RegisterVirtualMethod(@TMeshObject.PointInObject, 'PointInObject');
    RegisterMethod(@TMeshObjectGetTriangleData_P, 'GetTriangleData');
    RegisterMethod(@TMeshObjectGetTriangleData1_P, 'GetTriangleData1');
    RegisterMethod(@TMeshObjectSetTriangleData_P, 'SetTriangleData');
    RegisterMethod(@TMeshObjectSetTriangleData1_P, 'SetTriangleData1');
    RegisterMethod(@TMeshObject.BuildTangentSpace, 'BuildTangentSpace');
    RegisterPropertyHelper(@TMeshObjectOwner_R,nil,'Owner');
    RegisterPropertyHelper(@TMeshObjectMode_R,@TMeshObjectMode_W,'Mode');
    RegisterPropertyHelper(@TMeshObjectTexCoords_R,@TMeshObjectTexCoords_W,'TexCoords');
    RegisterPropertyHelper(@TMeshObjectLightMapTexCoords_R,@TMeshObjectLightMapTexCoords_W,'LightMapTexCoords');
    RegisterPropertyHelper(@TMeshObjectColors_R,@TMeshObjectColors_W,'Colors');
    RegisterPropertyHelper(@TMeshObjectFaceGroups_R,nil,'FaceGroups');
    RegisterPropertyHelper(@TMeshObjectRenderingOptions_R,@TMeshObjectRenderingOptions_W,'RenderingOptions');
    RegisterPropertyHelper(@TMeshObjectTexCoordsEx_R,@TMeshObjectTexCoordsEx_W,'TexCoordsEx');
    RegisterPropertyHelper(@TMeshObjectBinormals_R,@TMeshObjectBinormals_W,'Binormals');
    RegisterPropertyHelper(@TMeshObjectTangents_R,@TMeshObjectTangents_W,'Tangents');
    RegisterPropertyHelper(@TMeshObjectBinormalsTexCoordIndex_R,@TMeshObjectBinormalsTexCoordIndex_W,'BinormalsTexCoordIndex');
    RegisterPropertyHelper(@TMeshObjectTangentsTexCoordIndex_R,@TMeshObjectTangentsTexCoordIndex_W,'TangentsTexCoordIndex');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSkeleton(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSkeleton) do
  begin
    RegisterConstructor(@TSkeleton.CreateOwned, 'CreateOwned');
    RegisterConstructor(@TSkeleton.Create, 'Create');
    RegisterMethod(@TSkeleton.WriteToFiler, 'WriteToFiler');
    RegisterMethod(@TSkeleton.ReadFromFiler, 'ReadFromFiler');
    RegisterPropertyHelper(@TSkeletonOwner_R,nil,'Owner');
    RegisterPropertyHelper(@TSkeletonRootBones_R,@TSkeletonRootBones_W,'RootBones');
    RegisterPropertyHelper(@TSkeletonFrames_R,@TSkeletonFrames_W,'Frames');
    RegisterPropertyHelper(@TSkeletonCurrentFrame_R,@TSkeletonCurrentFrame_W,'CurrentFrame');
    RegisterPropertyHelper(@TSkeletonColliders_R,@TSkeletonColliders_W,'Colliders');
    RegisterMethod(@TSkeleton.FlushBoneByIDCache, 'FlushBoneByIDCache');
    RegisterMethod(@TSkeleton.BoneByID, 'BoneByID');
    RegisterMethod(@TSkeleton.BoneByName, 'BoneByName');
    RegisterMethod(@TSkeleton.BoneCount, 'BoneCount');
    RegisterMethod(@TSkeletonMorphTo_P, 'MorphTo');
    RegisterMethod(@TSkeletonMorphTo1_P, 'MorphTo1');
    RegisterMethod(@TSkeleton.Lerp, 'Lerp');
    RegisterMethod(@TSkeleton.BlendedLerps, 'BlendedLerps');
    RegisterMethod(@TSkeleton.MakeSkeletalTranslationStatic, 'MakeSkeletalTranslationStatic');
    RegisterMethod(@TSkeleton.MakeSkeletalRotationDelta, 'MakeSkeletalRotationDelta');
    RegisterMethod(@TSkeleton.MorphMesh, 'MorphMesh');
    RegisterMethod(@TSkeleton.Synchronize, 'Synchronize');
    RegisterMethod(@TSkeleton.Clear, 'Clear');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSkeletonColliderList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSkeletonColliderList) do
  begin
    RegisterConstructor(@TSkeletonColliderList.CreateOwned, 'CreateOwned');
    RegisterMethod(@TSkeletonColliderList.ReadFromFiler, 'ReadFromFiler');
    RegisterMethod(@TSkeletonColliderList.Clear, 'Clear');
    RegisterMethod(@TSkeletonColliderList.AlignColliders, 'AlignColliders');
    RegisterPropertyHelper(@TSkeletonColliderListOwner_R,nil,'Owner');
    RegisterPropertyHelper(@TSkeletonColliderListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSkeletonCollider(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSkeletonCollider) do
  begin
    RegisterConstructor(@TSkeletonCollider.CreateOwned, 'CreateOwned');
    RegisterMethod(@TSkeletonCollider.WriteToFiler, 'WriteToFiler');
    RegisterMethod(@TSkeletonCollider.ReadFromFiler, 'ReadFromFiler');
    RegisterVirtualMethod(@TSkeletonCollider.AlignCollider, 'AlignCollider');
    RegisterPropertyHelper(@TSkeletonColliderOwner_R,nil,'Owner');
    RegisterPropertyHelper(@TSkeletonColliderBone_R,@TSkeletonColliderBone_W,'Bone');
    RegisterPropertyHelper(@TSkeletonColliderLocalMatrix_R,@TSkeletonColliderLocalMatrix_W,'LocalMatrix');
    RegisterPropertyHelper(@TSkeletonColliderGlobalMatrix_R,nil,'GlobalMatrix');
    RegisterPropertyHelper(@TSkeletonColliderAutoUpdate_R,@TSkeletonColliderAutoUpdate_W,'AutoUpdate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSkeletonBone(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSkeletonBone) do
  begin
    RegisterConstructor(@TSkeletonBone.CreateOwned, 'CreateOwned');
    RegisterConstructor(@TSkeletonBone.Create, 'Create');
    RegisterMethod(@TSkeletonBone.WriteToFiler, 'WriteToFiler');
    RegisterMethod(@TSkeletonBone.ReadFromFiler, 'ReadFromFiler');
    RegisterMethod(@TSkeletonBone.BuildList, 'BuildList');
    RegisterPropertyHelper(@TSkeletonBoneOwner_R,nil,'Owner');
    RegisterPropertyHelper(@TSkeletonBoneName_R,@TSkeletonBoneName_W,'Name');
    RegisterPropertyHelper(@TSkeletonBoneBoneID_R,@TSkeletonBoneBoneID_W,'BoneID');
    RegisterPropertyHelper(@TSkeletonBoneColor_R,@TSkeletonBoneColor_W,'Color');
    RegisterPropertyHelper(@TSkeletonBoneItems_R,nil,'Items');
    RegisterMethod(@TSkeletonBone.BoneByID, 'BoneByID');
    RegisterMethod(@TSkeletonBone.BoneByName, 'BoneByName');
    RegisterPropertyHelper(@TSkeletonBoneGlobalMatrix_R,nil,'GlobalMatrix');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSkeletonRootBoneList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSkeletonRootBoneList) do
  begin
    RegisterMethod(@TSkeletonRootBoneList.WriteToFiler, 'WriteToFiler');
    RegisterMethod(@TSkeletonRootBoneList.ReadFromFiler, 'ReadFromFiler');
    RegisterMethod(@TSkeletonRootBoneList.BuildList, 'BuildList');
    RegisterPropertyHelper(@TSkeletonRootBoneListGlobalMatrix_R,@TSkeletonRootBoneListGlobalMatrix_W,'GlobalMatrix');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSkeletonBoneList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSkeletonBoneList) do begin
    RegisterConstructor(@TSkeletonBoneList.CreateOwned, 'CreateOwned');
    RegisterConstructor(@TSkeletonBoneList.Create, 'Create');
    RegisterMethod(@TSkeletonBoneList.WriteToFiler, 'WriteToFiler');
    RegisterMethod(@TSkeletonBoneList.ReadFromFiler, 'ReadFromFiler');
    RegisterPropertyHelper(@TSkeletonBoneListSkeleton_R,nil,'Skeleton');
    RegisterPropertyHelper(@TSkeletonBoneListItems_R,nil,'Items');
    RegisterVirtualMethod(@TSkeletonBoneList.BoneByID, 'BoneByID');
    RegisterVirtualMethod(@TSkeletonBoneList.BoneByName, 'BoneByName');
    RegisterMethod(@TSkeletonBoneList.BoneCount, 'BoneCount');
    //RegisterVirtualAbstractMethod(@TSkeletonBoneList, @!.BuildList, 'BuildList');
    RegisterVirtualMethod(@TSkeletonBoneList.PrepareGlobalMatrices, 'PrepareGlobalMatrices');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSkeletonFrameList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSkeletonFrameList) do
  begin
    RegisterConstructor(@TSkeletonFrameList.CreateOwned, 'CreateOwned');
    RegisterMethod(@TSkeletonFrameList.ReadFromFiler, 'ReadFromFiler');
    RegisterMethod(@TSkeletonFrameList.ConvertQuaternionsToRotations, 'ConvertQuaternionsToRotations');
    RegisterMethod(@TSkeletonFrameList.ConvertRotationsToQuaternions, 'ConvertRotationsToQuaternions');
    RegisterPropertyHelper(@TSkeletonFrameListOwner_R,nil,'Owner');
    RegisterMethod(@TSkeletonFrameList.Clear, 'Clear');
    RegisterPropertyHelper(@TSkeletonFrameListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSkeletonFrame(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSkeletonFrame) do
  begin
    RegisterConstructor(@TSkeletonFrame.CreateOwned, 'CreateOwned');
    RegisterConstructor(@TSkeletonFrame.Create, 'Create');
    RegisterMethod(@TSkeletonFrame.WriteToFiler, 'WriteToFiler');
    RegisterMethod(@TSkeletonFrame.ReadFromFiler, 'ReadFromFiler');
    RegisterPropertyHelper(@TSkeletonFrameOwner_R,nil,'Owner');
    RegisterPropertyHelper(@TSkeletonFrameName_R,@TSkeletonFrameName_W,'Name');
    RegisterPropertyHelper(@TSkeletonFramePosition_R,@TSkeletonFramePosition_W,'Position');
    RegisterPropertyHelper(@TSkeletonFrameRotation_R,@TSkeletonFrameRotation_W,'Rotation');
    RegisterPropertyHelper(@TSkeletonFrameQuaternion_R,@TSkeletonFrameQuaternion_W,'Quaternion');
    RegisterPropertyHelper(@TSkeletonFrameTransformMode_R,@TSkeletonFrameTransformMode_W,'TransformMode');
    RegisterMethod(@TSkeletonFrame.LocalMatrixList, 'LocalMatrixList');
    RegisterMethod(@TSkeletonFrame.FlushLocalMatrixList, 'FlushLocalMatrixList');
    RegisterMethod(@TSkeletonFrame.ConvertQuaternionsToRotations, 'ConvertQuaternionsToRotations');
    RegisterMethod(@TSkeletonFrame.ConvertRotationsToQuaternions, 'ConvertRotationsToQuaternions');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBaseMeshObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBaseMeshObject) do
  begin
    RegisterConstructor(@TBaseMeshObject.Create, 'Create');
    RegisterMethod(@TBaseMeshObject.WriteToFiler, 'WriteToFiler');
    RegisterMethod(@TBaseMeshObject.ReadFromFiler, 'ReadFromFiler');
    RegisterVirtualMethod(@TBaseMeshObject.Clear, 'Clear');
    RegisterVirtualMethod(@TBaseMeshObject.Translate, 'Translate');
    RegisterMethod(@TBaseMeshObject.BuildNormals, 'BuildNormals');
    RegisterVirtualMethod(@TBaseMeshObject.ExtractTriangles, 'ExtractTriangles');
    RegisterPropertyHelper(@TBaseMeshObjectName_R,@TBaseMeshObjectName_W,'Name');
    RegisterPropertyHelper(@TBaseMeshObjectVisible_R,@TBaseMeshObjectVisible_W,'Visible');
    RegisterPropertyHelper(@TBaseMeshObjectVertices_R,@TBaseMeshObjectVertices_W,'Vertices');
    RegisterPropertyHelper(@TBaseMeshObjectNormals_R,@TBaseMeshObjectNormals_W,'Normals');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GLVectorFileObjects(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMeshObjectList) do
  with CL.Add(TFaceGroups) do
  RIRegister_TBaseMeshObject(CL);
  with CL.Add(TSkeletonFrameList) do
  RIRegister_TSkeletonFrame(CL);
  RIRegister_TSkeletonFrameList(CL);
  with CL.Add(TSkeleton) do
  with CL.Add(TSkeletonBone) do
  RIRegister_TSkeletonBoneList(CL);
  RIRegister_TSkeletonRootBoneList(CL);
  RIRegister_TSkeletonBone(CL);
  with CL.Add(TSkeletonColliderList) do
  RIRegister_TSkeletonCollider(CL);
  RIRegister_TSkeletonColliderList(CL);
  with CL.Add(TGLBaseMesh) do
  RIRegister_TSkeleton(CL);
  RIRegister_TMeshObject(CL);
  RIRegister_TMeshObjectList(CL);
  with CL.Add(TMeshMorphTargetList) do
  RIRegister_TMeshMorphTarget(CL);
  RIRegister_TMeshMorphTargetList(CL);
  RIRegister_TMorphableMeshObject(CL);
  RIRegister_TSkeletonMeshObject(CL);
  RIRegister_TFaceGroup(CL);
  RIRegister_TFGVertexIndexList(CL);
  RIRegister_TFGVertexNormalTexIndexList(CL);
  RIRegister_TFGIndexTexCoordList(CL);
  RIRegister_TFaceGroups(CL);
  RIRegister_TVectorFile(CL);
  RIRegister_TGLGLSMVectorFile(CL);
  RIRegister_TGLBaseMesh(CL);
  RIRegister_TGLFreeForm(CL);
  with CL.Add(TGLActor) do
  RIRegister_TActorAnimation(CL);
  RIRegister_TActorAnimations(CL);
  RIRegister_TGLBaseAnimationControler(CL);
  RIRegister_TGLAnimationControler(CL);
  RIRegister_TGLActor(CL);
  RIRegister_TVectorFileFormat(CL);
  RIRegister_TVectorFileFormatsList(CL);
  with CL.Add(EInvalidVectorFile) do
end;

 
 
{ TPSImport_GLVectorFileObjects }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GLVectorFileObjects.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GLVectorFileObjects(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GLVectorFileObjects.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GLVectorFileObjects(ri);
  RIRegister_GLVectorFileObjects_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
