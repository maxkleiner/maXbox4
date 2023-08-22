unit uPSI_UTGraphSearch;
{
   as a node edge list     chNGE tnode to tnode2    fix tnode2
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
  TPSImport_UTGraphSearch = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 

{ compile-time registration functions }
procedure SIRegister_TGraphList(CL: TPSPascalCompiler);
procedure SIRegister_TNode2(CL: TPSPascalCompiler);
procedure SIRegister_UTGraphSearch(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TGraphList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNode2(CL: TPSRuntimeClassImporter);
procedure RIRegister_UTGraphSearch(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   windows
  ,forms
  ,dialogs
  ,UIntlist
  ,UGeometry
  ,UTGraphSearch
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UTGraphSearch]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TGraphList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TGraphList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TGraphList') do begin
    RegisterProperty('Q', 'TList', iptrw);
    RegisterProperty('maxlen', 'integer', iptrw);
    RegisterProperty('finalized', 'boolean', iptrw);
    RegisterProperty('stop', 'boolean', iptrw);
    RegisterProperty('nodesSearched', 'integer', iptrw);
    RegisterProperty('queuesize', 'integer', iptrw);
    RegisterProperty('edgecount', 'integer', iptrw);
    RegisterMethod('Constructor create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure clear');
    RegisterMethod('Function AddNode( const key : string) : boolean;');
    RegisterMethod('Function AddNode1( const key : string; const x, y : integer) : boolean;');
    RegisterMethod('Function DeleteNode( const key : string) : boolean');
    RegisterMethod('Function MoveNode( const key : string; const newpoint : TPoint) : boolean');
    RegisterMethod('Function AddEdge( const key1, key2 : string) : boolean;');
    RegisterMethod('Function AddEdge1( const key1, key2 : string; const newweight : integer) : boolean;');
    RegisterMethod('Function AddEdge2( const key1, key2 : string; const newweight, newweight2 : integer) : boolean;');
    RegisterMethod('Function AddEdge3( const node1, node2 : TNode2; const newweight : integer) : boolean;');
    RegisterMethod('Function AddEdge4( const node1, node2 : TNode2; const newweight, newWeight2 : integer) : boolean;');
    RegisterMethod('Function findedge( const V1, V2 : TNode2; var edgePtr : PTEdge) : boolean');
    RegisterMethod('Function deleteEdge( Edge : TEdge) : boolean');
    RegisterMethod('Function setHighlight( key1, key2 : string; OnOff : boolean) : boolean');
    RegisterMethod('Procedure ResetAllHighlight');
    RegisterMethod('Function closetoedge( xx, yy, d : integer; var edge : TEdge) : boolean');
    RegisterMethod('Procedure finalize');
    RegisterMethod('Procedure savegraph( filename : string)');
    RegisterMethod('Procedure loadgraph( filename : string)');
    RegisterMethod('Procedure MakePathsToDF( startkey, goal : string; maxdepth : integer; GoalFound : TMethodcall)');
    RegisterMethod('Procedure MakePathsToBF( startkey, goal : string; maxdepth : integer; GoalFound : TMethodcall)');
    RegisterMethod('Function Dijkstra( const FromNode, ToNode : string; var ExtPath : TIntList) : integer;');
    RegisterMethod('Function Dijkstra1( const FromNode, ToNode : string; var ExtPath : TIntList; Verbosecall : TVerbosecall) : integer;');
    RegisterMethod('Function Dijkstra2( const FromNode, ToNode : string; var ExtPath : TIntList; GoalFound : TMethodCall) : integer;');
    RegisterMethod('Function Dijkstra3( const FromNode, ToNode : string; var ExtPath : TIntList; Verbosecall : TVerbosecall; Goalfound : TMethodcall) : integer;');
    RegisterMethod('Procedure noverbose( s : string)');
    RegisterMethod('Procedure NoGoal');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNode2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'tObject', 'TNode') do
  with CL.AddClassN(CL.FindClass('tObject'),'TNode2') do begin
    RegisterProperty('adjacents', 'TEdgearray', iptrw);
    RegisterProperty('nbradjacents', 'integer', iptrw);
    RegisterProperty('index', 'integer', iptrw);
    RegisterProperty('x', 'integer', iptrw);
    RegisterProperty('y', 'integer', iptrw);
    RegisterMethod('Constructor create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_UTGraphSearch(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('tMethodCall', 'Procedure');
  CL.AddTypeS('tVerboseCall', 'Procedure ( s : string)');
  //CL.AddTypeS('tedgearray', 'array of TEdge)');
  //tedgearray
 // CL.AddTypeS('PTEdge', '^TEdge // will not work');
  CL.AddTypeS('TEdge', 'record FromNodeIndex : Integer; ToNodeIndex : Integer; '
   +'Weight : integer; work : integer; Len : integer; Highlight : boolean; end');
   CL.AddTypeS('Tedgearray', 'array of TEdge)');
  SIRegister_TNode2(CL);
  SIRegister_TGraphList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TGraphListDijkstra3_P(Self: TGraphList;  const FromNode, ToNode : string; var ExtPath : TIntList; Verbosecall : TVerbosecall; Goalfound : TMethodcall) : integer;
Begin Result := Self.Dijkstra(FromNode, ToNode, ExtPath, Verbosecall, Goalfound); END;

(*----------------------------------------------------------------------------*)
Function TGraphListDijkstra2_P(Self: TGraphList;  const FromNode, ToNode : string; var ExtPath : TIntList; GoalFound : TMethodCall) : integer;
Begin Result := Self.Dijkstra(FromNode, ToNode, ExtPath, GoalFound); END;

(*----------------------------------------------------------------------------*)
Function TGraphListDijkstra1_P(Self: TGraphList;  const FromNode, ToNode : string; var ExtPath : TIntList; Verbosecall : TVerbosecall) : integer;
Begin Result := Self.Dijkstra(FromNode, ToNode, ExtPath, Verbosecall); END;

(*----------------------------------------------------------------------------*)
Function TGraphListDijkstra_P(Self: TGraphList;  const FromNode, ToNode : string; var ExtPath : TIntList) : integer;
Begin Result := Self.Dijkstra(FromNode, ToNode, ExtPath); END;

(*----------------------------------------------------------------------------*)
Function TGraphListAddEdge4_P(Self: TGraphList;  const node1, node2 : TNode2; const newweight, newWeight2 : integer) : boolean;
Begin Result := Self.AddEdge(node1, node2, newweight, newWeight2); END;

(*----------------------------------------------------------------------------*)
Function TGraphListAddEdge3_P(Self: TGraphList;  const node1, node2 : TNode2; const newweight : integer) : boolean;
Begin Result := Self.AddEdge(node1, node2, newweight); END;

(*----------------------------------------------------------------------------*)
Function TGraphListAddEdge2_P(Self: TGraphList;  const key1, key2 : string; const newweight, newweight2 : integer) : boolean;
Begin Result := Self.AddEdge(key1, key2, newweight, newweight2); END;

(*----------------------------------------------------------------------------*)
Function TGraphListAddEdge1_P(Self: TGraphList;  const key1, key2 : string; const newweight : integer) : boolean;
Begin Result := Self.AddEdge(key1, key2, newweight); END;

(*----------------------------------------------------------------------------*)
Function TGraphListAddEdge_P(Self: TGraphList;  const key1, key2 : string) : boolean;
Begin Result := Self.AddEdge(key1, key2); END;

(*----------------------------------------------------------------------------*)
Function TGraphListAddNode1_P(Self: TGraphList;  const key : string; const x, y : integer) : boolean;
Begin Result := Self.AddNode(key, x, y); END;

(*----------------------------------------------------------------------------*)
Function TGraphListAddNode_P(Self: TGraphList;  const key : string) : boolean;
Begin Result := Self.AddNode(key); END;

(*----------------------------------------------------------------------------*)
procedure TGraphListedgecount_W(Self: TGraphList; const T: integer);
Begin Self.edgecount := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraphListedgecount_R(Self: TGraphList; var T: integer);
Begin T := Self.edgecount; end;

(*----------------------------------------------------------------------------*)
procedure TGraphListqueuesize_W(Self: TGraphList; const T: integer);
Begin Self.queuesize := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraphListqueuesize_R(Self: TGraphList; var T: integer);
Begin T := Self.queuesize; end;

(*----------------------------------------------------------------------------*)
procedure TGraphListnodesSearched_W(Self: TGraphList; const T: integer);
Begin Self.nodesSearched := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraphListnodesSearched_R(Self: TGraphList; var T: integer);
Begin T := Self.nodesSearched; end;

(*----------------------------------------------------------------------------*)
procedure TGraphListstop_W(Self: TGraphList; const T: boolean);
Begin Self.stop := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraphListstop_R(Self: TGraphList; var T: boolean);
Begin T := Self.stop; end;

(*----------------------------------------------------------------------------*)
procedure TGraphListfinalized_W(Self: TGraphList; const T: boolean);
Begin Self.finalized := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraphListfinalized_R(Self: TGraphList; var T: boolean);
Begin T := Self.finalized; end;

(*----------------------------------------------------------------------------*)
procedure TGraphListmaxlen_W(Self: TGraphList; const T: integer);
Begin Self.maxlen := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraphListmaxlen_R(Self: TGraphList; var T: integer);
Begin T := Self.maxlen; end;

(*----------------------------------------------------------------------------*)
procedure TGraphListQ_W(Self: TGraphList; const T: TList);
Begin Self.Q := T; end;

(*----------------------------------------------------------------------------*)
procedure TGraphListQ_R(Self: TGraphList; var T: TList);
Begin T := Self.Q; end;

(*----------------------------------------------------------------------------*)
procedure TNodey_W(Self: TNode2; const T: integer);
Begin Self.y := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodey_R(Self: TNode2; var T: integer);
Begin T := Self.y; end;

(*----------------------------------------------------------------------------*)
procedure TNodex_W(Self: TNode2; const T: integer);
Begin Self.x := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodex_R(Self: TNode2; var T: integer);
Begin T := Self.x; end;

(*----------------------------------------------------------------------------*)
procedure TNodeindex_W(Self: TNode2; const T: integer);
Begin Self.index := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodeindex_R(Self: TNode2; var T: integer);
Begin T := Self.index; end;

(*----------------------------------------------------------------------------*)
procedure TNodenbradjacents_W(Self: TNode2; const T: integer);
Begin Self.nbradjacents := T; end;

(*----------------------------------------------------------------------------*)
procedure TNodenbradjacents_R(Self: TNode2; var T: integer);
Begin T := Self.nbradjacents; end;

//type tedgearray = array of TEdge;

(*----------------------------------------------------------------------------*)
procedure TNodeadjacents_W(Self: TNode2; const T: tedgearray);
Begin Self.adjacents := T;
end;

(*----------------------------------------------------------------------------*)
procedure TNodeadjacents_R(Self: TNode2; var T: tedgearray);
Begin T := Self.adjacents;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGraphList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGraphList) do begin
    RegisterPropertyHelper(@TGraphListQ_R,@TGraphListQ_W,'Q');
    RegisterPropertyHelper(@TGraphListmaxlen_R,@TGraphListmaxlen_W,'maxlen');
    RegisterPropertyHelper(@TGraphListfinalized_R,@TGraphListfinalized_W,'finalized');
    RegisterPropertyHelper(@TGraphListstop_R,@TGraphListstop_W,'stop');
    RegisterPropertyHelper(@TGraphListnodesSearched_R,@TGraphListnodesSearched_W,'nodesSearched');
    RegisterPropertyHelper(@TGraphListqueuesize_R,@TGraphListqueuesize_W,'queuesize');
    RegisterPropertyHelper(@TGraphListedgecount_R,@TGraphListedgecount_W,'edgecount');
    RegisterConstructor(@TGraphList.create, 'create');
    RegisterMethod(@TGraphList.Destroy, 'Free');
    RegisterMethod(@TGraphList.clear, 'clear');
    RegisterMethod(@TGraphListAddNode_P, 'AddNode');
    RegisterMethod(@TGraphListAddNode1_P, 'AddNode1');
    RegisterMethod(@TGraphList.DeleteNode, 'DeleteNode');
    RegisterMethod(@TGraphList.MoveNode, 'MoveNode');
    RegisterMethod(@TGraphListAddEdge_P, 'AddEdge');
    RegisterMethod(@TGraphListAddEdge1_P, 'AddEdge1');
    RegisterMethod(@TGraphListAddEdge2_P, 'AddEdge2');
    RegisterMethod(@TGraphListAddEdge3_P, 'AddEdge3');
    RegisterMethod(@TGraphListAddEdge4_P, 'AddEdge4');
    RegisterMethod(@TGraphList.findedge, 'findedge');
    RegisterMethod(@TGraphList.deleteEdge, 'deleteEdge');
    RegisterMethod(@TGraphList.setHighlight, 'setHighlight');
    RegisterMethod(@TGraphList.ResetAllHighlight, 'ResetAllHighlight');
    RegisterMethod(@TGraphList.closetoedge, 'closetoedge');
    RegisterMethod(@TGraphList.finalize, 'finalize');
    RegisterMethod(@TGraphList.savegraph, 'savegraph');
    RegisterMethod(@TGraphList.loadgraph, 'loadgraph');
    RegisterMethod(@TGraphList.MakePathsToDF, 'MakePathsToDF');
    RegisterMethod(@TGraphList.MakePathsToBF, 'MakePathsToBF');
    RegisterMethod(@TGraphListDijkstra_P, 'Dijkstra');
    RegisterMethod(@TGraphListDijkstra1_P, 'Dijkstra1');
    RegisterMethod(@TGraphListDijkstra2_P, 'Dijkstra2');
    RegisterMethod(@TGraphListDijkstra3_P, 'Dijkstra3');
    RegisterMethod(@TGraphList.noverbose, 'noverbose');
    RegisterMethod(@TGraphList.NoGoal, 'NoGoal');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNode2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNode2) do
  begin
    RegisterPropertyHelper(@TNodeadjacents_R,@TNodeadjacents_W,'adjacents');
    RegisterPropertyHelper(@TNodenbradjacents_R,@TNodenbradjacents_W,'nbradjacents');
    RegisterPropertyHelper(@TNodeindex_R,@TNodeindex_W,'index');
    RegisterPropertyHelper(@TNodex_R,@TNodex_W,'x');
    RegisterPropertyHelper(@TNodey_R,@TNodey_W,'y');
    RegisterConstructor(@TNode2.create, 'create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_UTGraphSearch(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TNode2(CL);
  RIRegister_TGraphList(CL);
end;

 
 
{ TPSImport_UTGraphSearch }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UTGraphSearch.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UTGraphSearch(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UTGraphSearch.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_UTGraphSearch(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
