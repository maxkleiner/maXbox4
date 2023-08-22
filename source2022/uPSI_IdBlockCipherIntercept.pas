unit uPSI_IdBlockCipherIntercept;
{

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
  TPSImport_IdBlockCipherIntercept = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdBlockCipherIntercept(CL: TPSPascalCompiler);
procedure SIRegister_IdBlockCipherIntercept(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdBlockCipherIntercept(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdBlockCipherIntercept(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdIntercept
  ,IdException
  ,IdBlockCipherIntercept
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdBlockCipherIntercept]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdBlockCipherIntercept(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdConnectionIntercept', 'TIdBlockCipherIntercept') do
  with CL.AddClassN(CL.FindClass('TIdConnectionIntercept'),'TIdBlockCipherIntercept') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Receive( ABuffer : TStream)');
    RegisterMethod('Procedure Send( ABuffer : TStream)');
    RegisterMethod('Procedure CopySettingsFrom( ASrcBlockCipherIntercept : TIdBlockCipherIntercept)');
    RegisterProperty('Data', 'TObject', iptrw);
    RegisterProperty('BlockSize', 'Integer', iptrw);
    RegisterProperty('OnReceive', 'TIdBlockCipherInterceptDataEvent', iptrw);
    RegisterProperty('OnSend', 'TIdBlockCipherInterceptDataEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdBlockCipherIntercept(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('IdBlockCipherBlockSizeDefault','LongInt').SetInt( 16);
 CL.AddConstantN('IdBlockCipherBlockSizeMax','LongInt').SetInt( 256);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdBlockCipherIntercept');
  CL.AddTypeS('TIdBlockCipherInterceptDataEvent', 'Procedure ( ASender : TIdBlo'
   +'ckCipherIntercept; ASrcData, ADstData : ___Pointer)');
  SIRegister_TIdBlockCipherIntercept(CL);
  CL.AddTypeS('EIdBlockCipherInterceptException', 'EIdException');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdBlockCipherInterceptOnSend_W(Self: TIdBlockCipherIntercept; const T: TIdBlockCipherInterceptDataEvent);
begin Self.OnSend := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdBlockCipherInterceptOnSend_R(Self: TIdBlockCipherIntercept; var T: TIdBlockCipherInterceptDataEvent);
begin T := Self.OnSend; end;

(*----------------------------------------------------------------------------*)
procedure TIdBlockCipherInterceptOnReceive_W(Self: TIdBlockCipherIntercept; const T: TIdBlockCipherInterceptDataEvent);
begin Self.OnReceive := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdBlockCipherInterceptOnReceive_R(Self: TIdBlockCipherIntercept; var T: TIdBlockCipherInterceptDataEvent);
begin T := Self.OnReceive; end;

(*----------------------------------------------------------------------------*)
procedure TIdBlockCipherInterceptBlockSize_W(Self: TIdBlockCipherIntercept; const T: Integer);
begin Self.BlockSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdBlockCipherInterceptBlockSize_R(Self: TIdBlockCipherIntercept; var T: Integer);
begin T := Self.BlockSize; end;

(*----------------------------------------------------------------------------*)
procedure TIdBlockCipherInterceptData_W(Self: TIdBlockCipherIntercept; const T: TObject);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdBlockCipherInterceptData_R(Self: TIdBlockCipherIntercept; var T: TObject);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdBlockCipherIntercept(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdBlockCipherIntercept) do
  begin
    RegisterConstructor(@TIdBlockCipherIntercept.Create, 'Create');
    RegisterMethod(@TIdBlockCipherIntercept.Receive, 'Receive');
    RegisterMethod(@TIdBlockCipherIntercept.Send, 'Send');
    RegisterMethod(@TIdBlockCipherIntercept.CopySettingsFrom, 'CopySettingsFrom');
    RegisterPropertyHelper(@TIdBlockCipherInterceptData_R,@TIdBlockCipherInterceptData_W,'Data');
    RegisterPropertyHelper(@TIdBlockCipherInterceptBlockSize_R,@TIdBlockCipherInterceptBlockSize_W,'BlockSize');
    RegisterPropertyHelper(@TIdBlockCipherInterceptOnReceive_R,@TIdBlockCipherInterceptOnReceive_W,'OnReceive');
    RegisterPropertyHelper(@TIdBlockCipherInterceptOnSend_R,@TIdBlockCipherInterceptOnSend_W,'OnSend');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdBlockCipherIntercept(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdBlockCipherIntercept) do
  RIRegister_TIdBlockCipherIntercept(CL);
end;

 
 
{ TPSImport_IdBlockCipherIntercept }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdBlockCipherIntercept.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdBlockCipherIntercept(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdBlockCipherIntercept.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdBlockCipherIntercept(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
