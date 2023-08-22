unit uPSI_SOAPLinked;
{
  to link
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
  TPSImport_SOAPLinked = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TLinkedRIO(CL: TPSPascalCompiler);
procedure SIRegister_TLogLinkedWebNode(CL: TPSPascalCompiler);
procedure SIRegister_TLinkedWebNode(CL: TPSPascalCompiler);
procedure SIRegister_SOAPLinked(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TLinkedRIO(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLogLinkedWebNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLinkedWebNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_SOAPLinked(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Rio
  ,TypInfo
  ,WebNode
  ,SOAPPasInv
  ,IntfInfo
  ,WSDLIntf
  ,SOAPAttachIntf
  ,XMLDoc
  ,SOAPLinked
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SOAPLinked]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TLinkedRIO(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRIO', 'TLinkedRIO') do
  with CL.AddClassN(CL.FindClass('TRIO'),'TLinkedRIO') do begin
     RegisterMethod('Procedure Free');
     RegisterMethod('Function QueryInterface( const IID : TGUID; out Obj) : HResult');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Constructor CreateFile( AOwner : TComponent; ReqFile, RespFile : string)');
    RegisterProperty('WebNode', 'TLinkedWebNode', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLogLinkedWebNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TLinkedWebNode', 'TLogLinkedWebNode') do
  with CL.AddClassN(CL.FindClass('TLinkedWebNode'),'TLogLinkedWebNode') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Execute( const Request : TStream; Response : TStream)');
    RegisterProperty('ReqFile', 'string', iptrw);
    RegisterProperty('RespFile', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLinkedWebNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TLinkedWebNode') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TLinkedWebNode') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure BeforeExecute( const IntfMetaData : TIntfMetaData; const MethodMetaData : TIntfMethEntry; MethodIndex : Integer; AttachHandler : IMimeAttachmentHandler)');
    RegisterMethod('Procedure Execute( const DataMsg : String; Resp : TStream);');
    RegisterMethod('Procedure Execute1( const Request : TStream; Response : TStream);');
    RegisterMethod('Function Execute2( const Request : TStream) : TStream;');
    RegisterProperty('Invoker', 'TSoapPascalInvoker', iptr);
    RegisterProperty('MimeBoundary', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SOAPLinked(CL: TPSPascalCompiler);
begin
  SIRegister_TLinkedWebNode(CL);
  SIRegister_TLogLinkedWebNode(CL);
  SIRegister_TLinkedRIO(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TLinkedRIOWebNode_R(Self: TLinkedRIO; var T: TLinkedWebNode);
begin T := Self.WebNode; end;

(*----------------------------------------------------------------------------*)
procedure TLogLinkedWebNodeRespFile_W(Self: TLogLinkedWebNode; const T: string);
begin Self.RespFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TLogLinkedWebNodeRespFile_R(Self: TLogLinkedWebNode; var T: string);
begin T := Self.RespFile; end;

(*----------------------------------------------------------------------------*)
procedure TLogLinkedWebNodeReqFile_W(Self: TLogLinkedWebNode; const T: string);
begin Self.ReqFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TLogLinkedWebNodeReqFile_R(Self: TLogLinkedWebNode; var T: string);
begin T := Self.ReqFile; end;

(*----------------------------------------------------------------------------*)
procedure TLinkedWebNodeMimeBoundary_W(Self: TLinkedWebNode; const T: string);
begin Self.MimeBoundary := T; end;

(*----------------------------------------------------------------------------*)
procedure TLinkedWebNodeMimeBoundary_R(Self: TLinkedWebNode; var T: string);
begin T := Self.MimeBoundary; end;

(*----------------------------------------------------------------------------*)
procedure TLinkedWebNodeInvoker_R(Self: TLinkedWebNode; var T: TSoapPascalInvoker);
begin T := Self.Invoker; end;

(*----------------------------------------------------------------------------*)
Function TLinkedWebNodeExecute2_P(Self: TLinkedWebNode;  const Request : TStream) : TStream;
Begin Result := Self.Execute(Request); END;

(*----------------------------------------------------------------------------*)
Procedure TLinkedWebNodeExecute1_P(Self: TLinkedWebNode;  const Request : TStream; Response : TStream);
Begin Self.Execute(Request, Response); END;

(*----------------------------------------------------------------------------*)
Procedure TLinkedWebNodeExecute_P(Self: TLinkedWebNode;  const DataMsg : String; Resp : TStream);
Begin Self.Execute(DataMsg, Resp); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLinkedRIO(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLinkedRIO) do begin
    RegisterMethod(@TLinkedRIO.QueryInterface, 'QueryInterface');
    RegisterConstructor(@TLinkedRIO.Create, 'Create');
    RegisterMethod(@TLinkedRIO.Destroy, 'Free');
     RegisterConstructor(@TLinkedRIO.CreateFile, 'CreateFile');
    RegisterPropertyHelper(@TLinkedRIOWebNode_R,nil,'WebNode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLogLinkedWebNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLogLinkedWebNode) do begin
    RegisterConstructor(@TLogLinkedWebNode.Create, 'Create');
       RegisterMethod(@TLogLinkedWebNode.Destroy, 'Free');
     RegisterMethod(@TLogLinkedWebNode.Execute, 'Execute');
    RegisterPropertyHelper(@TLogLinkedWebNodeReqFile_R,@TLogLinkedWebNodeReqFile_W,'ReqFile');
    RegisterPropertyHelper(@TLogLinkedWebNodeRespFile_R,@TLogLinkedWebNodeRespFile_W,'RespFile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLinkedWebNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLinkedWebNode) do begin
    RegisterConstructor(@TLinkedWebNode.Create, 'Create');
       RegisterMethod(@TLinkedWebNode.Destroy, 'Free');
     RegisterVirtualMethod(@TLinkedWebNode.BeforeExecute, 'BeforeExecute');
    RegisterVirtualMethod(@TLinkedWebNodeExecute_P, 'Execute');
    RegisterVirtualMethod(@TLinkedWebNodeExecute1_P, 'Execute1');
    RegisterMethod(@TLinkedWebNodeExecute2_P, 'Execute2');
    RegisterPropertyHelper(@TLinkedWebNodeInvoker_R,nil,'Invoker');
    RegisterPropertyHelper(@TLinkedWebNodeMimeBoundary_R,@TLinkedWebNodeMimeBoundary_W,'MimeBoundary');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SOAPLinked(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TLinkedWebNode(CL);
  RIRegister_TLogLinkedWebNode(CL);
  RIRegister_TLinkedRIO(CL);
end;

 
 
{ TPSImport_SOAPLinked }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SOAPLinked.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SOAPLinked(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SOAPLinked.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SOAPLinked(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
