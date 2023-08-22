unit uPSI_IdTCPConnection;
{
    writestream1, 3.9.9.91 and more events  like on work, use idcomponent
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
  TPSImport_IdTCPConnection = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdTCPConnection(CL: TPSPascalCompiler);
procedure SIRegister_TIdManagedBuffer(CL: TPSPascalCompiler);
procedure SIRegister_TIdSimpleBuffer(CL: TPSPascalCompiler);
procedure SIRegister_IdTCPConnection(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdTCPConnection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdManagedBuffer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdSimpleBuffer(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdTCPConnection(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdException
  ,IdComponent
  ,IdGlobal
  ,IdSocketHandle
  ,IdIntercept
  ,IdIOHandler
  ,IdRFCReply
  ,IdIOHandlerSocket
  ,IdTCPConnection
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdTCPConnection]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdTCPConnection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdComponent', 'TIdTCPConnection') do
  with CL.AddClassN(CL.FindClass('TIdComponent'),'TIdTCPConnection') do begin
    RegisterMethod('Function AllData : string');
    RegisterMethod('Procedure CancelWriteBuffer');
    RegisterMethod('Constructor Create(AOwner: TComponent);');  //3.1
    RegisterMethod('Procedure Free;');

    RegisterMethod('Procedure Capture( ADest : TStream; const ADelim : string; const AIsRFCMessage : Boolean);');
    RegisterMethod('Procedure Capture1( ADest : TStream; out VLineCount : Integer; const ADelim : string; const AIsRFCMessage : Boolean);');
    RegisterMethod('Procedure Capture2( ADest : TStrings; const ADelim : string; const AIsRFCMessage : Boolean);');
    RegisterMethod('Procedure Capture3( ADest : TStrings; out VLineCount : Integer; const ADelim : string; const AIsRFCMessage : Boolean);');
    RegisterMethod('Procedure CheckForDisconnect( const ARaiseExceptionIfDisconnected : boolean; const AIgnoreBuffer : boolean)');
    RegisterMethod('Procedure CheckForGracefulDisconnect( const ARaiseExceptionIfDisconnected : Boolean)');
    RegisterMethod('Function CheckResponse( const AResponse : SmallInt; const AAllowedResponses : array of SmallInt) : SmallInt');
    RegisterMethod('Procedure ClearWriteBuffer');
    RegisterMethod('Procedure CloseWriteBuffer');
    RegisterMethod('Function Connected : Boolean');
    RegisterMethod('Function CurrentReadBuffer : string');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Procedure DisconnectSocket');
    RegisterMethod('Procedure FlushWriteBuffer( const AByteCount : Integer)');
    RegisterMethod('Procedure GetInternalResponse');
    RegisterMethod('Function GetResponse( const AAllowedResponses : array of SmallInt) : SmallInt;');
    RegisterMethod('Function GetResponse1( const AAllowedResponse : SmallInt) : SmallInt;');
    RegisterProperty('Greeting', 'TIdRFCReply', iptrw);
    RegisterMethod('Function InputLn( const AMask : string; AEcho : Boolean; ATabWidth : Integer; AMaxLineLength : Integer) : string');
    RegisterMethod('Procedure OpenWriteBuffer( const AThreshhold : Integer)');
    RegisterMethod('Procedure RaiseExceptionForLastCmdResult;');
    RegisterMethod('Procedure RaiseExceptionForLastCmdResult1( AException : TClassIdException);');
    RegisterMethod('Function ReadCardinal( const AConvert : boolean) : Cardinal');
    RegisterMethod('Function ReadChar : Char');
    RegisterMethod('Function ReadFromStack( const ARaiseExceptionIfDisconnected : Boolean; ATimeout : Integer; const ARaiseExceptionOnTimeout : Boolean) : Integer');
    RegisterMethod('Function ReadInteger( const AConvert : boolean) : Integer');
    RegisterMethod('Function ReadLn( ATerminator : string; const ATimeout : Integer; AMaxLineLength : Integer) : string');
    RegisterMethod('Function ReadLnWait( AFailCount : Integer) : string');
    RegisterMethod('Function ReadSmallInt( const AConvert : boolean) : SmallInt');
    RegisterMethod('Procedure ReadStream( AStream : TStream; AByteCount : LongInt; const AReadUntilDisconnect : boolean)');
    RegisterMethod('Function ReadString( const ABytes : Integer) : string');
    RegisterMethod('Procedure ReadStrings( ADest : TStrings; AReadLinesCount : Integer)');
    RegisterMethod('Function SendCmd( const AOut : string; const AResponse : SmallInt) : SmallInt;');
    RegisterMethod('Function SendCmd1( const AOut : string; const AResponse : array of SmallInt) : SmallInt;');
    RegisterMethod('Function WaitFor( const AString : string) : string');
    RegisterMethod('Procedure Write( const AOut : string)');
    RegisterMethod('Procedure WriteBuffer( const ABuffer, AByteCount : Longint; const AWriteNow : Boolean)');
    RegisterMethod('Procedure WriteCardinal( AValue : Cardinal; const AConvert : Boolean)');
    RegisterMethod('Procedure WriteChar( AValue : Char)');
    RegisterMethod('Procedure WriteHeader( AHeader : TStrings)');
    RegisterMethod('Procedure WriteInteger( AValue : Integer; const AConvert : Boolean)');
    RegisterMethod('Procedure WriteLn( const AOut : string)');
    RegisterMethod('Procedure WriteRFCReply( AReply : TIdRFCReply)');
    RegisterMethod('Procedure WriteRFCStrings( AStrings : TStrings)');
    RegisterMethod('Procedure WriteSmallInt( AValue : SmallInt; const AConvert : Boolean)');
    //  procedure WriteStream(AStream: TStream; const AAll: Boolean = True;
      //const AWriteByteCount: Boolean = False; const ASize: Integer = 0); virtual;

    RegisterMethod('Procedure WriteStream( AStream : TStream; const AAll : Boolean; const AWriteByteCount : Boolean; const ASize : Integer)');
    RegisterMethod('Procedure WriteStream1( AStream : TStream)');
    RegisterMethod('Procedure WriteStrings( AValue : TStrings; const AWriteLinesCount : Boolean)');
    RegisterMethod('Function WriteFile( const AFile : string; const AEnableTransferFile : Boolean) : Cardinal');
    RegisterProperty('ClosedGracefully', 'Boolean', iptr);
    RegisterProperty('InputBuffer', 'TIdManagedBuffer', iptr);
    RegisterProperty('LastCmdResult', 'TIdRFCReply', iptr);
    RegisterProperty('ReadLnSplit', 'Boolean', iptr);
    RegisterProperty('ReadLnTimedOut', 'Boolean', iptr);
    RegisterProperty('Socket', 'TIdIOHandlerSocket', iptr);
    RegisterProperty('ASCIIFilter', 'boolean', iptrw);
    RegisterProperty('Intercept', 'TIdConnectionIntercept', iptrw);
    RegisterProperty('IOHandler', 'TIdIOHandler', iptrw);
    RegisterProperty('MaxLineLength', 'Integer', iptrw);
    RegisterProperty('MaxLineAction', 'TIdMaxLineAction', iptrw);
    RegisterProperty('ReadTimeout', 'Integer', iptrw);
    RegisterProperty('RecvBufferSize', 'Integer', iptrw);
    RegisterProperty('SendBufferSize', 'Integer', iptrw);
    RegisterProperty('OnDisconnected', 'TNotifyEvent', iptrw);
    RegisterProperty('OnWork', 'TWorkEvent', iptrw);
  RegisterProperty('OnWorkBegin', 'TWorkBeginEvent', iptrw);
  RegisterProperty('OnWorkEnd', 'TWorkEndEvent', iptrw);

 {      FOnWork: TWorkEvent;
    FOnWorkBegin: TWorkBeginEvent;
    FOnWorkEnd: TWorkEndEvent;}

    {property OnWork;
    property OnWorkBegin;
    property OnWorkEnd;}


  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdManagedBuffer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdSimpleBuffer', 'TIdManagedBuffer') do
  with CL.AddClassN(CL.FindClass('TIdSimpleBuffer'),'TIdManagedBuffer') do begin
    RegisterMethod('Constructor Create( AOnBytesRemoved : TIdBufferBytesRemoved)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Memory : Pointer');
    RegisterMethod('Procedure PackBuffer');
    RegisterProperty('PackReadedSize', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdSimpleBuffer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMemoryStream', 'TIdSimpleBuffer') do
  with CL.AddClassN(CL.FindClass('TMemoryStream'),'TIdSimpleBuffer') do
  begin
    RegisterMethod('Constructor Create( AOnBytesRemoved : TIdBufferBytesRemoved)');
    RegisterMethod('Function Extract( const AByteCount : Integer) : string');
    RegisterMethod('Procedure Remove( const AByteCount : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdTCPConnection(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('GRecvBufferSizeDefault','LongInt').SetInt( 32 * 1024);
 CL.AddConstantN('GSendBufferSizeDefault','LongInt').SetInt( 32 * 1024);
 CL.AddConstantN('IdMaxLineLengthDefault','LongInt').SetInt( 16 * 1024);
 CL.AddConstantN('IdInBufCacheSizeDefault','LongInt').SetInt( 32 * 1024);
 CL.AddConstantN('IdDefTimeout','LongInt').SetInt( 0);
  CL.AddTypeS('TIdBufferBytesRemoved', 'Procedure (ASender: TObject; const ABytes : Integer)');
  SIRegister_TIdSimpleBuffer(CL);
  SIRegister_TIdManagedBuffer(CL);
  SIRegister_TIdTCPConnection(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdTCPConnectionError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdObjectTypeNotSupported');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdNotEnoughDataInBuffer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdInterceptPropIsNil');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdInterceptPropInvalid');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdIOHandlerPropInvalid');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdNoDataToRead');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdNotConnected');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdFileNotFound');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionOnDisconnected_W(Self: TIdTCPConnection; const T: TNotifyEvent);
begin Self.OnDisconnected := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionOnDisconnected_R(Self: TIdTCPConnection; var T: TNotifyEvent);
begin T := Self.OnDisconnected; end;


(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionOnWork_W(Self: TIdTCPConnection; const T: TWorkEvent);
begin Self.OnWork:= T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionOnWork_R(Self: TIdTCPConnection; var T: TWorkEvent);
begin T:= Self.OnWork; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionOnWorkBegin_W(Self: TIdTCPConnection; const T: TWorkBeginEvent);
begin Self.OnWorkBegin:= T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionOnWorkBegin_R(Self: TIdTCPConnection; var T: TWorkBeginEvent);
begin T:= Self.OnWorkBegin; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionOnWorkEnd_W(Self: TIdTCPConnection; const T: TWorkEndEvent);
begin Self.OnWorkEnd:= T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionOnWorkEnd_R(Self: TIdTCPConnection; var T: TWorkEndEvent);
begin T:= Self.OnWorkEnd; end;

   {property OnWork;
    property OnWorkBegin;
    property OnWorkEnd;}

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionSendBufferSize_W(Self: TIdTCPConnection; const T: Integer);
begin Self.SendBufferSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionSendBufferSize_R(Self: TIdTCPConnection; var T: Integer);
begin T := Self.SendBufferSize; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionRecvBufferSize_W(Self: TIdTCPConnection; const T: Integer);
begin Self.RecvBufferSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionRecvBufferSize_R(Self: TIdTCPConnection; var T: Integer);
begin T := Self.RecvBufferSize; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionReadTimeout_W(Self: TIdTCPConnection; const T: Integer);
begin Self.ReadTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionReadTimeout_R(Self: TIdTCPConnection; var T: Integer);
begin T := Self.ReadTimeout; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionMaxLineAction_W(Self: TIdTCPConnection; const T: TIdMaxLineAction);
begin Self.MaxLineAction := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionMaxLineAction_R(Self: TIdTCPConnection; var T: TIdMaxLineAction);
begin T := Self.MaxLineAction; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionMaxLineLength_W(Self: TIdTCPConnection; const T: Integer);
begin Self.MaxLineLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionMaxLineLength_R(Self: TIdTCPConnection; var T: Integer);
begin T := Self.MaxLineLength; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionIOHandler_W(Self: TIdTCPConnection; const T: TIdIOHandler);
begin Self.IOHandler := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionIOHandler_R(Self: TIdTCPConnection; var T: TIdIOHandler);
begin T := Self.IOHandler; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionIntercept_W(Self: TIdTCPConnection; const T: TIdConnectionIntercept);
begin Self.Intercept := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionIntercept_R(Self: TIdTCPConnection; var T: TIdConnectionIntercept);
begin T := Self.Intercept; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionASCIIFilter_W(Self: TIdTCPConnection; const T: boolean);
begin Self.ASCIIFilter := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionASCIIFilter_R(Self: TIdTCPConnection; var T: boolean);
begin T := Self.ASCIIFilter; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionSocket_R(Self: TIdTCPConnection; var T: TIdIOHandlerSocket);
begin T := Self.Socket; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionReadLnTimedOut_R(Self: TIdTCPConnection; var T: Boolean);
begin T := Self.ReadLnTimedOut; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionReadLnSplit_R(Self: TIdTCPConnection; var T: Boolean);
begin T := Self.ReadLnSplit; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionLastCmdResult_R(Self: TIdTCPConnection; var T: TIdRFCReply);
begin T := Self.LastCmdResult; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionInputBuffer_R(Self: TIdTCPConnection; var T: TIdManagedBuffer);
begin T := Self.InputBuffer; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionClosedGracefully_R(Self: TIdTCPConnection; var T: Boolean);
begin T := Self.ClosedGracefully; end;

(*----------------------------------------------------------------------------*)
Function TIdTCPConnectionSendCmd1_P(Self: TIdTCPConnection;  const AOut : string; const AResponse : array of SmallInt) : SmallInt;
Begin Result := Self.SendCmd(AOut, AResponse); END;

(*----------------------------------------------------------------------------*)
Function TIdTCPConnectionSendCmd_P(Self: TIdTCPConnection;  const AOut : string; const AResponse : SmallInt) : SmallInt;
Begin Result := Self.SendCmd(AOut, AResponse); END;

(*----------------------------------------------------------------------------*)
Procedure TIdTCPConnectionRaiseExceptionForLastCmdResult1_P(Self: TIdTCPConnection;  AException : TClassIdException);
Begin Self.RaiseExceptionForLastCmdResult(AException); END;

(*----------------------------------------------------------------------------*)
Procedure TIdTCPConnectionRaiseExceptionForLastCmdResult_P(Self: TIdTCPConnection);
Begin Self.RaiseExceptionForLastCmdResult; END;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionGreeting_W(Self: TIdTCPConnection; const T: TIdRFCReply);
begin Self.Greeting := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTCPConnectionGreeting_R(Self: TIdTCPConnection; var T: TIdRFCReply);
begin T := Self.Greeting; end;

(*----------------------------------------------------------------------------*)
Function TIdTCPConnectionGetResponse1_P(Self: TIdTCPConnection;  const AAllowedResponse : SmallInt) : SmallInt;
Begin Result := Self.GetResponse(AAllowedResponse); END;

(*----------------------------------------------------------------------------*)
Function TIdTCPConnectionGetResponse_P(Self: TIdTCPConnection;  const AAllowedResponses : array of SmallInt) : SmallInt;
Begin Result := Self.GetResponse(AAllowedResponses); END;

(*----------------------------------------------------------------------------*)
Procedure TIdTCPConnectionCapture3_P(Self: TIdTCPConnection;  ADest : TStrings; out VLineCount : Integer; const ADelim : string; const AIsRFCMessage : Boolean);
Begin Self.Capture(ADest, VLineCount, ADelim, AIsRFCMessage); END;

(*----------------------------------------------------------------------------*)
Procedure TIdTCPConnectionCapture2_P(Self: TIdTCPConnection;  ADest : TStrings; const ADelim : string; const AIsRFCMessage : Boolean);
Begin Self.Capture(ADest, ADelim, AIsRFCMessage); END;

(*----------------------------------------------------------------------------*)
Procedure TIdTCPConnectionCapture1_P(Self: TIdTCPConnection;  ADest : TStream; out VLineCount : Integer; const ADelim : string; const AIsRFCMessage : Boolean);
Begin Self.Capture(ADest, VLineCount, ADelim, AIsRFCMessage); END;

(*----------------------------------------------------------------------------*)
Procedure TIdTCPConnectionCapture_P(Self: TIdTCPConnection;  ADest : TStream; const ADelim : string; const AIsRFCMessage : Boolean);
Begin Self.Capture(ADest, ADelim, AIsRFCMessage); END;

(*----------------------------------------------------------------------------*)
procedure TIdManagedBufferPackReadedSize_W(Self: TIdManagedBuffer; const T: Integer);
begin Self.PackReadedSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdManagedBufferPackReadedSize_R(Self: TIdManagedBuffer; var T: Integer);
begin T := Self.PackReadedSize; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdTCPConnection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdTCPConnection) do begin
    RegisterVirtualMethod(@TIdTCPConnection.AllData, 'AllData');
    RegisterMethod(@TIdTCPConnection.CancelWriteBuffer, 'CancelWriteBuffer');
    RegisterConstructor(@TIdTCPConnection.Create, 'Create'); //virtual constructor
    RegisterMethod(@TIdTCPConnection.Destroy, 'Free');
    RegisterMethod(@TIdTCPConnectionCapture_P, 'Capture');
    RegisterMethod(@TIdTCPConnectionCapture1_P, 'Capture1');
    RegisterMethod(@TIdTCPConnectionCapture2_P, 'Capture2');
    RegisterMethod(@TIdTCPConnectionCapture3_P, 'Capture3');
    RegisterVirtualMethod(@TIdTCPConnection.CheckForDisconnect, 'CheckForDisconnect');
    RegisterVirtualMethod(@TIdTCPConnection.CheckForGracefulDisconnect, 'CheckForGracefulDisconnect');
    RegisterVirtualMethod(@TIdTCPConnection.CheckResponse, 'CheckResponse');
    RegisterMethod(@TIdTCPConnection.ClearWriteBuffer, 'ClearWriteBuffer');
    RegisterMethod(@TIdTCPConnection.CloseWriteBuffer, 'CloseWriteBuffer');
    RegisterVirtualMethod(@TIdTCPConnection.Connected, 'Connected');
    RegisterMethod(@TIdTCPConnection.CurrentReadBuffer, 'CurrentReadBuffer');
    RegisterVirtualMethod(@TIdTCPConnection.Disconnect, 'Disconnect');
    RegisterVirtualMethod(@TIdTCPConnection.DisconnectSocket, 'DisconnectSocket');
    RegisterMethod(@TIdTCPConnection.FlushWriteBuffer, 'FlushWriteBuffer');
    RegisterMethod(@TIdTCPConnection.GetInternalResponse, 'GetInternalResponse');
    RegisterVirtualMethod(@TIdTCPConnectionGetResponse_P, 'GetResponse');
    RegisterMethod(@TIdTCPConnectionGetResponse1_P, 'GetResponse1');
    RegisterPropertyHelper(@TIdTCPConnectionGreeting_R,@TIdTCPConnectionGreeting_W,'Greeting');
    RegisterMethod(@TIdTCPConnection.InputLn, 'InputLn');
    RegisterMethod(@TIdTCPConnection.OpenWriteBuffer, 'OpenWriteBuffer');
    RegisterVirtualMethod(@TIdTCPConnectionRaiseExceptionForLastCmdResult_P, 'RaiseExceptionForLastCmdResult');
    RegisterVirtualMethod(@TIdTCPConnectionRaiseExceptionForLastCmdResult1_P, 'RaiseExceptionForLastCmdResult1');
    RegisterMethod(@TIdTCPConnection.ReadCardinal, 'ReadCardinal');
    RegisterMethod(@TIdTCPConnection.ReadChar, 'ReadChar');
    RegisterVirtualMethod(@TIdTCPConnection.ReadFromStack, 'ReadFromStack');
    RegisterMethod(@TIdTCPConnection.ReadInteger, 'ReadInteger');
    RegisterVirtualMethod(@TIdTCPConnection.ReadLn, 'ReadLn');
    RegisterMethod(@TIdTCPConnection.ReadLnWait, 'ReadLnWait');
    RegisterMethod(@TIdTCPConnection.ReadSmallInt, 'ReadSmallInt');
    RegisterMethod(@TIdTCPConnection.ReadStream, 'ReadStream');
    RegisterMethod(@TIdTCPConnection.ReadString, 'ReadString');
    RegisterMethod(@TIdTCPConnection.ReadStrings, 'ReadStrings');
    RegisterMethod(@TIdTCPConnectionSendCmd_P, 'SendCmd');
    RegisterVirtualMethod(@TIdTCPConnectionSendCmd1_P, 'SendCmd1');
    RegisterMethod(@TIdTCPConnection.WaitFor, 'WaitFor');
    RegisterVirtualMethod(@TIdTCPConnection.Write, 'Write');
    RegisterMethod(@TIdTCPConnection.WriteBuffer, 'WriteBuffer');
    RegisterMethod(@TIdTCPConnection.WriteCardinal, 'WriteCardinal');
    RegisterMethod(@TIdTCPConnection.WriteChar, 'WriteChar');
    RegisterMethod(@TIdTCPConnection.WriteHeader, 'WriteHeader');
    RegisterMethod(@TIdTCPConnection.WriteInteger, 'WriteInteger');
    RegisterVirtualMethod(@TIdTCPConnection.WriteLn, 'WriteLn');
    RegisterMethod(@TIdTCPConnection.WriteRFCReply, 'WriteRFCReply');
    RegisterMethod(@TIdTCPConnection.WriteRFCStrings, 'WriteRFCStrings');
    RegisterMethod(@TIdTCPConnection.WriteSmallInt, 'WriteSmallInt');
    RegisterVirtualMethod(@TIdTCPConnection.WriteStream, 'WriteStream');
    RegisterVirtualMethod(@TIdTCPConnection.WriteStream, 'WriteStream1');
    RegisterMethod(@TIdTCPConnection.WriteStrings, 'WriteStrings');
    RegisterVirtualMethod(@TIdTCPConnection.WriteFile, 'WriteFile');
    RegisterPropertyHelper(@TIdTCPConnectionClosedGracefully_R,nil,'ClosedGracefully');
    RegisterPropertyHelper(@TIdTCPConnectionInputBuffer_R,nil,'InputBuffer');
    RegisterPropertyHelper(@TIdTCPConnectionLastCmdResult_R,nil,'LastCmdResult');
    RegisterPropertyHelper(@TIdTCPConnectionReadLnSplit_R,nil,'ReadLnSplit');
    RegisterPropertyHelper(@TIdTCPConnectionReadLnTimedOut_R,nil,'ReadLnTimedOut');
    RegisterPropertyHelper(@TIdTCPConnectionSocket_R,nil,'Socket');
    RegisterPropertyHelper(@TIdTCPConnectionASCIIFilter_R,@TIdTCPConnectionASCIIFilter_W,'ASCIIFilter');
    RegisterPropertyHelper(@TIdTCPConnectionIntercept_R,@TIdTCPConnectionIntercept_W,'Intercept');
    RegisterPropertyHelper(@TIdTCPConnectionIOHandler_R,@TIdTCPConnectionIOHandler_W,'IOHandler');
    RegisterPropertyHelper(@TIdTCPConnectionMaxLineLength_R,@TIdTCPConnectionMaxLineLength_W,'MaxLineLength');
    RegisterPropertyHelper(@TIdTCPConnectionMaxLineAction_R,@TIdTCPConnectionMaxLineAction_W,'MaxLineAction');
    RegisterPropertyHelper(@TIdTCPConnectionReadTimeout_R,@TIdTCPConnectionReadTimeout_W,'ReadTimeout');
    RegisterPropertyHelper(@TIdTCPConnectionRecvBufferSize_R,@TIdTCPConnectionRecvBufferSize_W,'RecvBufferSize');
    RegisterPropertyHelper(@TIdTCPConnectionSendBufferSize_R,@TIdTCPConnectionSendBufferSize_W,'SendBufferSize');
    RegisterPropertyHelper(@TIdTCPConnectionOnDisconnected_R,@TIdTCPConnectionOnDisconnected_W,'OnDisconnected');
    RegisterPropertyHelper(@TIdTCPConnectionOnWork_R,@TIdTCPConnectionOnWork_W,'OnWork');
    RegisterPropertyHelper(@TIdTCPConnectionOnWorkBegin_R,@TIdTCPConnectionOnWorkBegin_W,'OnWorkBegin');
    RegisterPropertyHelper(@TIdTCPConnectionOnWorkEnd_R,@TIdTCPConnectionOnWorkEnd_W,'OnWorkEnd');

    {property OnWork;
    property OnWorkBegin;
    property OnWorkEnd;}

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdManagedBuffer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdManagedBuffer) do begin
    RegisterConstructor(@TIdManagedBuffer.Create, 'Create');
    RegisterMethod(@TIdManagedBuffer.Clear, 'Clear');
    RegisterMethod(@TIdManagedBuffer.Memory, 'Memory');
    RegisterMethod(@TIdManagedBuffer.PackBuffer, 'PackBuffer');
    RegisterPropertyHelper(@TIdManagedBufferPackReadedSize_R,@TIdManagedBufferPackReadedSize_W,'PackReadedSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdSimpleBuffer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdSimpleBuffer) do
  begin
    RegisterConstructor(@TIdSimpleBuffer.Create, 'Create');
    RegisterVirtualMethod(@TIdSimpleBuffer.Extract, 'Extract');
    RegisterVirtualMethod(@TIdSimpleBuffer.Remove, 'Remove');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdTCPConnection(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdSimpleBuffer(CL);
  RIRegister_TIdManagedBuffer(CL);
  RIRegister_TIdTCPConnection(CL);
  with CL.Add(EIdTCPConnectionError) do
  with CL.Add(EIdObjectTypeNotSupported) do
  with CL.Add(EIdNotEnoughDataInBuffer) do
  with CL.Add(EIdInterceptPropIsNil) do
  with CL.Add(EIdInterceptPropInvalid) do
  with CL.Add(EIdIOHandlerPropInvalid) do
  with CL.Add(EIdNoDataToRead) do
  with CL.Add(EIdNotConnected) do
  with CL.Add(EIdFileNotFound) do
end;

 
 
{ TPSImport_IdTCPConnection }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdTCPConnection.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdTCPConnection(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdTCPConnection.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdTCPConnection(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
