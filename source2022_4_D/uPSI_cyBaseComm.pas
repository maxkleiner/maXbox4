unit uPSI_cyBaseComm;
{
  com on lan
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
  TPSImport_cyBaseComm = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TcyBaseComm(CL: TPSPascalCompiler);
procedure SIRegister_cyBaseComm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cyBaseComm_Routines(S: TPSExec);
procedure RIRegister_TcyBaseComm(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyBaseComm(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,Messages
  ,cyBaseComm
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyBaseComm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyBaseComm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TcyBaseComm') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TcyBaseComm') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function SendCommand( ToBaseCommHandle : THandle; aCommand : Word; UserParam : Integer) : Boolean');
    RegisterMethod('Function SendStream( ToBaseCommHandle : THandle; aMemoryStream : TMemoryStream; UserParam : Integer) : Boolean');
    RegisterMethod('Function SendString( ToBaseCommHandle : THandle; aString : String; UserParam : Integer) : Boolean');
    RegisterMethod('Function MemoryStreamToString( Stream : TMemoryStream) : String');
    RegisterProperty('Handle', 'HWND', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyBaseComm(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TcyCommandType', '( ctDevelopperDefined, ctUserDefined )');
  CL.AddTypeS('TStreamContentType', '( scDevelopperDefined, scUserDefined, scString )');
  CL.AddTypeS('TProcOnReceiveCommand', 'Procedure (Sender : TObject; aCommand: Word; userParam : Integer)');
  CL.AddTypeS('TProcOnReceiveString', 'Procedure ( Sender : TObject; fromBaseCo'
   +'mmHandle : THandle; aString : String; userParam : Integer)');
  CL.AddTypeS('TProcOnReceiveMemoryStream', 'Procedure ( Sender : TObject; from'
   +'BaseCommHandle : THandle; aStream : TMemoryStream; userParam : Integer)');
  SIRegister_TcyBaseComm(CL);
 CL.AddConstantN('MsgCommand','LongInt').SetInt( WM_USER + 1);
 CL.AddConstantN('MsgResultOk','LongInt').SetInt( 99);
 CL.AddDelphiFunction('Function ValidateFileMappingName( aName : String) : String');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TcyBaseCommHandle_R(Self: TcyBaseComm; var T: HWND);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
Function TcyBaseCommDevelopperSendStream1_P(Self: TcyBaseComm;  ToBaseCommHandle : THandle; aString : String; Param : Integer) : Boolean;
Begin //Result := Self.DevelopperSendStream(ToBaseCommHandle, aString, Param);
END;

(*----------------------------------------------------------------------------*)
Function TcyBaseCommDevelopperSendStream_P(Self: TcyBaseComm;  ToBaseCommHandle : THandle; aMemoryStream : TMemoryStream; Param : Integer) : Boolean;
Begin //Result := Self.DevelopperSendStream(ToBaseCommHandle, aMemoryStream, Param);
END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyBaseComm_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ValidateFileMappingName, 'ValidateFileMappingName', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyBaseComm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyBaseComm) do begin
    RegisterConstructor(@TcyBaseComm.Create, 'Create');
      RegisterMethod(@TcyBaseComm.Destroy, 'Free');
    RegisterMethod(@TcyBaseComm.SendCommand, 'SendCommand');
    RegisterMethod(@TcyBaseComm.SendStream, 'SendStream');
    RegisterMethod(@TcyBaseComm.SendString, 'SendString');
    RegisterMethod(@TcyBaseComm.MemoryStreamToString, 'MemoryStreamToString');
    RegisterPropertyHelper(@TcyBaseCommHandle_R,nil,'Handle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyBaseComm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TcyBaseComm(CL);
end;

 
 
{ TPSImport_cyBaseComm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyBaseComm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyBaseComm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyBaseComm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyBaseComm(ri);
  RIRegister_cyBaseComm_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
