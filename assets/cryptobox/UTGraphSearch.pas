unit UTGraphSearch;
 {Copyright  © 2000-2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {An Adjacency list Graph Object }


interface
  uses windows,forms, classes, dialogs, sysutils, UIntlist, UGeometry;

 type
  tMethodCall = procedure of object;
  tVerboseCall= procedure(s:string) of object;

  PTEdge=^TEdge;

  TEdge= record
    FromNodeIndex:Integer;
    ToNodeIndex:Integer; {location of nodes in a headnodes list}
    Weight, work:integer;
    Len:integer; {length of this edge}
    Highlight:boolean;  {Hightlight this edge when drawing (width color, etc.}
  end;

  TNode= class(tObject) {A node of the graph}
    adjacents:array of TEdge; {the edges to adjacent nodes}
    nbradjacents:integer;
    index:integer; { location of this node in headnodes list}
    x,y:integer;  {graphic display coordinates, node center}
    constructor create;
  end;

  {The adjacency graph object}
  TGraphList=class(TStringList) {list of head nodes}
  public
    Q:TList;  {list to hold search results}
    maxlen:integer;  {maximum key length}
    finalized:boolean; {true=nodes have been sorted and ready for adding edges}
    stop:boolean;   {stop flag checked during searching}
    nodesSearched, queuesize:integer; {counts kept by search routines}
    edgecount:integer;
    constructor create;
    destructor destroy;    override;
    procedure clear;  {a version of clear to free node objects as well as clearing the list}
    function AddNode(const key:string):boolean; overload;
    function AddNode(const key:string; const x,y:integer):boolean; overload;
    {delete node and all edges connecting to it}
    function DeleteNode(const key:string):boolean;

    function MoveNode(const key:string; const newpoint:TPoint):boolean;


    {several versions of "addedge", by key or by node, no weights, directed one way,
    directed two way (for weigthed non-directed use same weights both directions)}
    function AddEdge(const key1,key2:string):boolean; overload;
    function AddEdge(const key1,key2:string; const newweight:integer):boolean; overload;
    function AddEdge(const key1,key2:string; const newweight,newweight2:integer):boolean; overload;
    function AddEdge(const node1,node2:TNode; const newweight:integer):boolean; overload;
    function AddEdge(const node1,node2:TNode; const newweight,newWeight2:integer):boolean; overload;

    {Find the edgerec connecting two given nodes (if it exists)}
    function findedge(const V1,V2:TNode; var edgePtr:PTEdge):boolean;

    {delete an edge}
    function deleteEdge(Edge:TEdge):boolean;

    {Set a highlight flag for an edge}
    function setHighlight(key1,key2:string; OnOff:boolean):boolean;
    procedure ResetAllHighlight;

    {search edges for first found that comes within distance "d" of point xx,yy}
    function closetoedge(xx,yy,d:integer; var edge:TEdge):boolean;

    procedure finalize;

    procedure savegraph(filename:string);
    procedure loadgraph(filename:string);



    {depth first search}
    procedure MakePathsToDF(startkey,goal:string;
                            maxdepth:integer;
                            GoalFound:TMethodcall);
    {breadth first search}
    procedure MakePathsToBF(startkey,goal:string;
                            maxdepth:integer;
                            GoalFound:TMethodcall);

    {Dijkstra Shortest Path search}
    {Overloaded Dijkstra with no Verbose procedure or final Goalfound procedure calls}
    function Dijkstra(const FromNode, ToNode:string;  var ExtPath:TIntList):integer; overload;
    {Overloaded Dijkstra with Verbose procedure calls only}
    function Dijkstra(const FromNode, ToNode:string;  var ExtPath:TIntList;
                                    Verbosecall:TVerbosecall):integer; overload;
    {Overloaded Dijkstra with final Goalfound procedure call only}
    function Dijkstra(const FromNode, ToNode:string;  var ExtPath:TIntList;
                                    GoalFound:TMethodCall):integer; overload;
    {Overloaded Dijkstra with Verbose procedure and a final Goalfound procedure call}
    function Dijkstra(const FromNode, ToNode:string; var ExtPath:TIntList;
                     Verbosecall:TVerbosecall; Goalfound:TMethodcall):integer; overload;


    procedure noverbose(s:string);   {dummy verbosecall}
    procedure NoGoal;   {dummy goalfound call}
     {future functions}
    //function GetTreeRoot(key1:string):string;
    //function GetTreeCount:integer;
    //function connected:boolean;
   end;

implementation

constructor TNode.create;
begin
  inherited create;
  setlength(adjacents,2); {we'll start with room for 2, then add 2 at a time}
  nbradjacents:=0;
  
  index:=0;{this serves as a link back to key info, could use key field instead}
end;


{**************  Create ********}
constructor TGraphList.create;
begin
  inherited;
  q:=Tlist.create;
  finalized:=false;
  edgecount:=0;
end;

{*********** Destroy *********}
destructor TGraphList.destroy;
var
  i:integer;
begin
 (*{free all nodes}
  q.free;
  if count>0 then
  for i:=0 to count-1 do TNode(objects[i]).free;
  *)
  q.free;
  clear;
  inherited;
end;

{************ Clear ************}
procedure TGraphlist.clear;
{override stringlist clear to free nodes as well as clearing entries}
var
  i:integer;
begin
  {free all nodes}
  if count>0 then
  for i:=0 to count-1 do TNode(objects[i]).free;
  edgecount:=0;  
  inherited;
end;


{************** Addnode **********}
function TGraphList.AddNode(const key:string):boolean;
begin
  result:=addnode(key,0,0);
end;


{*********** Addnode (with coordinates) ***********}
function TGraphList.AddNode(const key:string;const x,y:integer):boolean;
{add a new node}
var
  node:TNode;
begin
  if (count=0) or (edgecount=0) or((count>0) and (key>strings[count-1])) then
  begin
    node:=TNode.create;
    node.x:=x;
    node.y:=y;
    node.index:=addobject(key,node);
    result:=true;
    finalized:=false;
  end
  else
  begin
    showmessage('Not added - if edges exist, new node id must be greater than existing nodes');
    result:=false;
  end;
end;

{*************** DeleteNode ***********}
function TGraphList.DeleteNode(const key:string):boolean;
{delete node and all edges connecting to it}
var
  i,j,k:integer;
  ix:integer;
begin
  result:=false;
  if find(key,ix) then
  begin
    for i:=0 to count-1 do
    with TNode(objects[i]) do
    begin
      result:=true;
      j:=0;
      while j<=nbradjacents-1 do
      with adjacents[j] do
      begin
        if tonodeindex=ix then
        begin
          for k:=j to nbradjacents-2 do adjacents[k]:=adjacents[k+1];
          dec(nbradjacents);
          dec(edgecount);   {added Feb 2008}
        end
        else
        begin
          if fromnodeindex>ix then dec(fromnodeindex);
          if tonodeindex>ix then dec(tonodeindex); {edge  pointers adjusted
                                     back to account for delete node}
          inc(j);
        end
      end;
      if index>ix then  dec(index);  {head node pointers adjusted back to account
                                      for deleted node}
    end;
    tnode(objects[ix]).free;
    delete(ix);
  end;
end;

{*************** MoveNode ***************}
function TGraphlist.MoveNode(const key:string; const newpoint:TPoint):boolean;
var
  ix:integer;
begin
  result:=false;
  if find(key,ix) then
  begin
    with tnode(objects[ix]) do
    begin
      x:=newpoint.x;
      y:=newpoint.y;
      result:=true;
    end;
  end;
end;


{**************** AddEdge (By key, 0 weights) *********}
function TGraphList.AddEdge(const key1,key2:string):boolean;
{For compatibility - add an edge to a node with weight of 0}
begin
  result:=Addedge(key1, key2, 0,0);
end;

{************** AddEdge (By key, directed one-way) ***********}
function TGraphList.AddEdge(const key1,key2:string; const newWeight:integer):boolean;
begin
  result:=Addedge(key1,key2,newweight,maxint);
end;

{**************** AddEdge (By Key, (directed two-way)}
function TGraphList.AddEdge(const key1,key2:string; const newWeight,newweight2:integer):boolean;
{add an edge to a node}
var
  k1,k2:integer;
  node1,node2:TNode;
begin
  if not finalized then
  begin
    finalize;
    (*
    showmessage('Nodes must be added and list finalized before edges are added');
    result:=false;
    exit;
    *)
  end;
  result:=false;
  If find(key1,k1) and find(key2,k2)
  then
  begin
    node1:=TNode(objects[k1]);
    node2:=TNode(objects[k2]);
    result:=addedge(node1,node2, newweight,newweight2);
  end;
end;

{*************** AddEgde (By node, (directed one-way) ****}
function TGraphlist.AddEdge(const Node1,Node2:TNode; const newweight:integer):boolean;
begin
  result:=AddEdge(Node1,Node2, newweight,maxint);
end;


{************* AddEdge   (By node,  (directed two-way) ***********}
function TGraphlist.AddEdge(const node1,node2:TNode; const newweight,newWeight2:integer):boolean;
var
  j:integer;
  found:boolean;
  k1,k2:integer;
begin
  if not finalized then finalize;
  result:=true;
  k1:=node1.index;
  k2:=node2.index;
  if newweight<>maxint then
  begin
    with node1 do
    begin
      found:=false;
      for j:=0 to nbradjacents-1 do
      if adjacents[j].tonodeindex=k2 then
      begin
        found:=true;
        break;
      end;
      if not found then
      begin
        inc(nbradjacents);
        inc(edgecount);
        if nbradjacents>length(adjacents)
        then setlength(adjacents,length(adjacents)+3);
        with adjacents[nbradjacents-1] do
        begin
          FromNodeindex:=K1;
          ToNodeIndex:=K2;
          Weight:=NewWeight;
          Len:=intdist(point(node1.x,node1.y),point(node2.x,node2.y));
        end;
      end
      else result:=false; {edge already exists}
    end;
    if newWeight2<>maxint then
    begin
      with node2 do
      begin
        found:=false;
        for j:=0 to nbradjacents-1 do
        if adjacents[j].ToNodeIndex=k1 then
        begin
          found:=true;
         break;
        end;
        if not found then
        begin
          inc(nbradjacents);
          inc(edgecount);
          if nbradjacents>length(adjacents)
          then setlength(adjacents,length(adjacents)+3);
          with adjacents[nbradjacents-1] do
          begin
            fromNodeIndex:=K2;
            ToNodeIndex:=K1;
            Weight:=NewWeight2;
            Len:=intdist(point(node1.x,node1.y),point(node2.x,node2.y));
            Highlight:=false;  {default}
          end;
        end
        else result:=false; {edge already exists};
      end;
    end;
  end;
end;



{*************** FindEdge ************}
function TGraphlist.Findedge(const V1,V2:TNode; var edgePtr:PTEdge):boolean;
{Find the edge, if any, connecting two nodes and return pointer to the edge}
var
  i:integer;
  temp:TNode;
begin
  result:=false;
  temp:= TNode(objects[v1.index]);
  with temp do
  begin
    for i:= 0 to nbradjacents-1 do
    if adjacents[i].toNodeindex=v2.index then
    begin
      edgePtr:=@adjacents[i];
      result:=true;
      break;
    end;
  end;
end;

{************ DeleteEdge ***********}
function TGraphList.deleteEdge(Edge:TEdge):boolean;
    {delete an edge}
var
  i,j:integer;
begin
  result:=false;
  with edge do
  with tnode(objects[fromnodeindex]) do
  begin
    for i:= 0 to nbradjacents-1 do
    if adjacents[i].tonodeindex=edge.tonodeindex then
    begin
      for j:=i to nbradjacents-2 do adjacents[j]:=adjacents[j+1];
      dec(nbradjacents);
      dec(edgecount);
    end;
  end;
end;


{**************** CloseToEdge ***********}
function TGraphlist.closetoedge(xx,yy,d:integer; var edge:TEdge):boolean;
{returns true if point("x","y") is within distance "d" of "edge"}
var
  i,j:integer;
  n:integer;
  L:TLine;
  temp:TNode;
begin
  result:=false;
  if count>0 then
  for i:= 0 to count-1 do
  with Tnode(objects[i]) do
  begin
    L.p1:=point(x,y);
    if nbradjacents>0 then
    for j:=0 to nbradjacents-1 do
    with adjacents[j] do
    begin
      temp:=TNode(objects[tonodeindex]);
      L.p2:=point(temp.x,temp.y);
      n:=perpdistance(L,point(xx,yy));
      if n<d then
      begin
        edge:=adjacents[j];
        result:=true;
        break;
      end;
      //if result then break;
    end;
    if result then break;
  end;
end;

{*************** SetHighlight *************}
function TGraphlist.setHighlight(key1,key2:string; OnOff:boolean):boolean;
{Set high field to true for edge connecting two given nodes}
var
  k1,k2:integer;
  EdgePtr:PTEdge;
  node1,node2:TNode;

begin
  result:=false;
  If find(key1,k1) and find(key2,k2)
  then
  begin
    node1:=TNode(objects[k1]);
    node2:=TNode(objects[k2]);
    if findedge(node1,node2,Edgeptr)
    then edgeptr^.highlight:=OnOff;
    if findedge(node2,node1,Edgeptr)
    then edgeptr^.highlight:=OnOff;
  end;
end;

{************* ResetAllHighLight  ************}
procedure TGraphList.ResetAllHighlight;
var
  i,j:integer;
begin
  for i:=0 to count-1 do
  with TNode(objects[i]) do
  for j:=0 to nbradjacents-1 do adjacents[j].highlight:=false;
end;


{*********** Finalize ***********}
procedure TGraphlist.finalize;
{sort nodes and fill in index values}
var
  i:integer;
begin
  sort;
  for i:= 0 to count-1 do
    TNode(objects[i]).index:=i;
  finalized:=true;
end;

{************** Savegraph *************}
procedure TGraphlist.savegraph(filename:string);
var
  stream:TFileStream;
  i,j,len:integer;
  s:string;
  n:integer;
begin
  stream:=TFileStream.create(filename,fmCreate);
  with stream do
  begin
    n:=count;
    writebuffer(n,sizeof(n));
    for i:=0 to count-1 do
    with TNode(objects[i]) do
    begin
      s:=strings[i];
      len:=length(s);
      writebuffer(len,sizeof(len));
      writebuffer(s[1],len);
      writebuffer(x,sizeof (x));
      writebuffer(y,sizeof(y));
      writebuffer(nbradjacents,sizeof(nbradjacents));
      for j:=0 to nbradjacents-1 do
      with adjacents[j] do
      begin
        writebuffer(tonodeindex,sizeof(tonodeindex));
        writebuffer(weight,sizeof(weight));
        writebuffer(len,sizeof(len));
      end;
    end;
  end;
  stream.free;
end;

{************** LoadGraph *************}
procedure TGraphlist.loadgraph(filename:string);
var
  stream:TFileStream;
  i,j:integer;
  n:integer;
  node:TNode;
  key:string;
  len:integer;
begin
  for i:=count-1 downto 0 do
  begin
    tnode(objects[i]).free;
    delete(i);
  end;

  stream:=TFileStream.create(filename,fmOpenRead);
  with stream do
  begin
    readbuffer(n,sizeof(count));
    for i:=0 to n-1 do
    begin
      node:=tnode.create;
      readbuffer(len,sizeof(len));
      setlength(key,len);
      readbuffer(key[1],len);
      with node do
      begin
        index:=count;
        readbuffer(x,sizeof (x));
        readbuffer(y,sizeof(y));
        readbuffer(nbradjacents,sizeof(nbradjacents));
        setlength(adjacents,nbradjacents);
        for j:=0 to nbradjacents-1 do
        with adjacents[j] do
        begin
          fromnodeindex:=count;
          readbuffer(tonodeindex,sizeof(tonodeindex));
          readbuffer(weight,sizeof(weight));
          readbuffer(len,sizeof(len));
        end;
      end;
      addobject(key,Tobject(node));
    end;
  end;
  stream.free;
end;


{***************** MakePathsToDF *****************}
procedure TGraphList.MakePathsToDF(startkey,goal:string;
                                   maxdepth:integer;
                                   GoalFound:TMethodCall);
{depth first search for goal}
var
  visited:array of boolean;
  nodenbr:integer;

 procedure dfs(v:integer;LEVEL:INTEGER); {recursive depth first search}
 var
   temp:TNode;
   i:integer;
 begin

   if stop then exit;
   inc(nodesSearched);
   temp:=TNode(objects[v]);  {get the node}
   Q.add(temp);              {add it to the queue}
   visited[temp.index]:=true;
   if (strings[v]=goal)  then
   begin
     queuesize:=q.count; {stats for goalfound routine}
     GoalFound;
     stop:=true;
   end;
   if (Q.Count<maxdepth) then  {if not at max depth}
   with temp do      {iterate through adjacents recursively}
     for i:= 0 to nbradjacents-1 do
     if (not visited[adjacents[i].ToNodeIndex]) then
     BEGIN
       (*
       IF STRINGS[V]='FDDMS.TP'
       THEN APPLICATION.MAINFORM.MEMO1.LINES.ADD(CHECKING '+STRINGS[TEMP.ADJACENTS[I].TONODEINDEX]);*)
       dfs(adjacents[i].ToNodeIndex,LEVEL+1);
       (*IF STRINGS[V]='FDDMS.TP'
       THEN FORM1.MEMO1.LINES.ADD(BACK FROM CHECKING '+STRINGS[TEMP.ADJACENTS[I].TONODEINDEX]);
       *)
     END;

   q.delete(Q.count-1);    {delete temp}
   visited[temp.index]:=false; {unvisit the node}
   if nodessearched mod 1024=0 then application.processmessages;
 end;

begin {MakePathsToDF}
  if not finalized then finalize{exit};
  setlength(visited,0);   {reset 'visited' array}
  setlength(visited,count);
  Q.clear;
  find(startkey,nodenbr);
  stop:=false;
  nodessearched:=0;
  dfs(nodenbr,0);  {start recursive  search}
end;

Type
  {object to use for breadth first searches that saves the
   node and the path that got us here}
  TBreadthObj = class(TObject)
    Path:array of integer;
    PathLength:integer;
    Node:TNode;
  end;


{*************** MakepathsToBF ***********}
procedure TGraphList.MakePathsToBF(startkey,goal:string;
                        maxdepth:integer;
                        GoalFound:TMethodCall);
{breadth first search for goal}
var
  i,j:integer;
  temp, temp2:TBreadthObj;
  node2:TNode;
  nodenbr:integer;
  LocalQ:TList;
  inpath:boolean;
begin
  if not finalized then finalize{exit};
  LocalQ:=TList.create;
  try
    {make the initial breadth object}
    temp:=TBreadthObj.create;
    find(startkey,nodenbr);
    if nodenbr<0 then exit;
    temp.node:=TNode(objects[nodenbr]);
    temp.pathlength:=1;
    setlength(temp.path,maxdepth+1);
    temp.path[0]:=temp.node.index;
    LocalQ.add(temp);  {put it in the queue}
    stop:=false;    {in case user presses stop button}
    nodessearched:=0;
    if startkey=goal then
    begin
      q.clear;
      q.add(TNode(objects[nodenbr]));
      queuesize:=q.count;
      GoalFound;
      stop:=true;
    end
    else
    While (not stop) and (LocalQ.count>0) do
    begin
      inc(nodessearched);
      temp:=Localq.items[0];{get the oldest beadthobj}
      Localq.delete(0);
      application.processmessages;  {is this often enough?}
      If temp.pathlength>=maxdepth {maxdepth reached, we're done}
      then
      begin
        if localQ.count>0 then
        for i:= 0 to localq.count-1 do TBreadthObj(Localq[i]).free;
        Localq.clear; {stop when we get to maxdepth}
      end
      else
      with temp.node do
      begin {go through adjacents and make new breadth objects for them}
        for i:= 0 to nbradjacents-1 do
        begin
          inpath:=false; {make sure this adjacent is not already in the path}
          for j:=0 to temp.pathlength-1 do
          if temp.path[j]=adjacents[i].ToNodeIndex then
          begin
            inpath:=true;
            break;
          end;
          if  not inpath then {not inpath, so we can add it}
          begin
            temp2:=TBreadthObj.create;
            with temp2 do
            begin
              node:=TNode(objects[temp.node.adjacents[i].ToNodeIndex]);
              path:=copy(temp.path,0,temp.pathlength);
              setlength(path,maxdepth);
              pathlength:=temp.pathlength+1;
              if pathlength>length(path)
               then
               begin
                 setlength(path,length(path)+1);
                 showmessage('Path depth extended - shouldn''t get here');
               end;
              path[pathlength-1]:=temp.node.adjacents[i].ToNodeIndex;
            end;

            {was this a goal node?}
            if strings[temp2.Node.index]=goal then
            begin
              q.clear;
              for j:=0 to temp2.pathlength-1 do
              begin
                node2:=TNode(objects[temp2.path[j]]);
                q.add(node2);
              end;
              queuesize:=localq.count;
              GoalFound;
              temp2.free;
              stop:=true;
            end
            else LocalQ.add(temp2);
          end;
        end;
        temp.free;
      end;
      If nodesSearched mod 1024 = 0 then application.processmessages;
    end;
    finally
      if localQ.count>0 then
      for i:= 0 to localq.count-1 do TBreadthObj(Localq[i]).free;
      localQ.free;
    end;
end;

{*************** NoVerbose ********8}
procedure TGraphlist.NoVerbose(s:string);
{Dummy Verbosecall procedure if not provided by Dijkstra caller}
begin
end;

{*************** NoGoal ********8}
procedure TGraphlist.NoGoal;
{Dummy Goalfound procedure if not provided by Dijkstra caller}
begin
end;

{**************   Dijkstra *************}
function TGraphList.Dijkstra(const FromNode, ToNode:string; var ExtPath:TIntList):integer;
{Overloaded call with no Verbosecall or Goalfound parameters}
begin
  result:=Dijkstra( FromNode, ToNode, Extpath, noverbose, nogoal);
end;

function TGraphList.Dijkstra(const FromNode, ToNode:string;  var ExtPath:TIntList;
                                    GoalFound:TMethodCall):integer;
{Overloaded call with no Verbosecall  parameter}
begin
  result:=Dijkstra(FromNode, ToNode, ExtPath, noverbose, goalfound);
end;

function TGraphList.Dijkstra(const FromNode, ToNode:string; var ExtPath:TIntList;
                     Verbosecall:TVerbosecall):integer;
{Overloaded call with no GoalFound  parameter}
begin
  result:=Dijkstra(FromNode, ToNode, ExtPath, Verbosecall, NoGoal);
end;


{***************** Dijkstra (verbose callback procedure) *********}
function TGraphList.Dijkstra(const FromNode, ToNode:string; var ExtPath:TIntList;
                     Verbosecall:TVerbosecall; Goalfound:TMethodcall):integer;
{find shortest path (based on sum of edge weights) from FromNode to ToNode}
(*
Dijkstra's algorithm: pseudocode
for all vertices v,
dist(v) = infinity;
dist(first) = 0;
place all vertices in set toBeChecked;
while toBeChecked is not empty
  {in this version, also stop when shortest path to a specific destination is found}
  select v: min(dist(v)) in toBeChecked;
  remove v from toBeChecked;
  for u in toBeChecked, and path from v to u exists
  {i.e. for unchecked adjacents to v}
  do
    if dist(u) > dist(v) + weight({u,v}),
    then
       dist(u) = dist(v) + weight({u,v});
       set predecessor of u to v
       save minimum distance to u in array "d"
     endif
  enddo
endwhile
*)

var
  dist:TIntlist;
  v,dv,u,du:integer;
  i,m,ix:integer;
  fromNodeIndex, ToNodeIndex:integer;
  path,d:array of integer;
  //verbose:TVerboseCall;


    function Minx:integer;
    var
      i,mind:integer;
    {return the minimal distance still in ToBeChecked list}
    {The values are index pointer to the nodes, the objects are minimal distances
     from source to that node - these are all initialized with high values, so
     only nodes whoise minimal distance from source has been determined will qualify}
    begin
      result:=0;
      mind:=integer(dist.objects[0]);
      with dist do
      for i:=1 to count-1 do
      if integer(objects[i])<mind then
      begin
        result:=i;
        mind:=integer(objects[i]);
      end;
    end;

begin
  result:=0;
  //verbose:=verbosecall;
  if not finalized then begin finalize{result:=-1; exit;} end;  {-1 'Not finalized'}
  if (not find(fromNode, FromNodeIndex)) or (not find(toNode,ToNodeIndex)) then
  begin
    result:=-2;   {-2 : 'FROM or TO node does not exist'}
    exit;
  end;
  dist:=TIntList.create;
  setlength(path, count); setlength(d,count);
  for i:=0 to count-1 do
  begin
    dist.addobject(i,TObject(maxint));
    path[i]:=i;
    if i and $FFF = 0 then application.processmessages;
  end;
  dist.objects[fromNodeindex]:=tobject(0);
  v:=0;
  {Search until all reachable nodes have been processed or the "To" node is reached}
  while (dist.count>=0) do
  begin
    application.processmessages;
    m:=minx; {node index of smallest unchecked distance}
    v:=dist[m]; {node index # of min dist}
    dv:=integer(dist.objects[m]); {min dist}
    if dv=maxint then
    begin
      result:=-3;
      break;
    end;
    dist.delete(m);
    verbosecall('1. "Closest" unchecked is  node ' + strings[v]
                                              + ' with weight to it = '+inttostr(dv));
    if (v=tonodeindex) then
    {solution found}
    begin
      verbosecall('5.  Destination node '+ strings[v]+' found!');
      break; {path complete, we can stop}
    end;
    with TNode(objects[v]) do
    for i:= 0 to nbradjacents-1 do
    begin
      du:=dv+adjacents[i].weight; {new distance= minimum to adjacent plus its weight}
      u:=adjacents[i].tonodeIndex; {the node to which this applies}
      verbosecall('2. Node '+strings[u]+' through node '
                                    +strings[v]+' has path weight ' +inttostr(du));
      if (dist.find(u,ix)) and (du<integer(dist.objects[ix]))
      then  {this is a new shortest distance to this node}
      begin  {so...}
        dist.objects[ix]:=TObject(du); {update the distance list with the new distance}
        path[u]:=v;  {set the path to this node to the node that got us here}
        d[u]:=du; {put the distance in the distance array}
       verbosecall('3. *** It is the smallest path so far from start to '+strings[u]);
      end;
    end;
    verbosecall('4. All paths from '+ strings[v]+' checked');
  end;

  if (result>=0) and (v=ToNodeIndex) then
  begin
    result:=v;
    extpath.clear;
    i:=tonodeindex;
    while (path[i]<>i)  do
    begin
      extpath.addobject(i,TObject(d[i]));
      i:=path[i];
    end;
    extpath.addobject(fromnodeindex,TObject(0));
    q.clear;
     {put solution nodes in "Q" before calling Goalfound to provide
     compatibility with breadth first and depth first searches}
    for i:=extpath.count-1 downto 0 do
          q.add(TNode(objects[extpath[i]]));
    queuesize:=q.count;
    goalfound;
  end
  else result:=-3; {err -3 ='No path found'}
  dist.free;
end;


end.
