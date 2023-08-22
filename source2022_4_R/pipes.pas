Unit pipes;

Interface

Uses SysUtils,
     Classes,
{$ifdef linux}
     Libc
{$else}
     Windows
{$endif}
      ;

{$ifdef linux}
Type
  PSecurityAttributes = ^TSecurityAttributes;
  TSecurityAttributes = Record
    nlength : Integer; 
    lpSecurityDescriptor : Pointer;
    BinheritHandle : Boolean;
  end;  
{$endif}    
    
Const piInheritablePipe : TSecurityAttributes = (
                           nlength:SizeOF(TSecurityAttributes);
                           lpSecurityDescriptor:Nil;
                           Binherithandle:True);
      piNonInheritablePipe : TSecurityAttributes = (
                             nlength:SizeOF(TSecurityAttributes);
                             lpSecurityDescriptor:Nil;
                             Binherithandle:False);


Type

  ENoReadPipe = Class(ESTreamError);
  ENoWritePipe = Class (EStreamError);
  EPipeSeek = Class (EStreamError);
  EPipeCreation = Class (Exception);

  TPipeStream = Class (THandleStream)
    public
      Function Seek (Offset : Longint;Origin : Word) : longint;override;
      Destructor Destroy; override;
    end;

  TInputPipeStream = Class(TPipeStream)
    public
      Function Write (Const Buffer; Count : Longint) :Longint; Override;
    end;

  TOutputPipeStream = Class(TPipeStream)
    Public
      Function Read (Var Buffer; Count : Longint) : longint; Override;
    end;

Procedure CreatePipeStreams (Var InPipe : TInputPipeStream;
                             Var OutPipe : TOutputPipeStream;
                             SecAttr : PSecurityAttributes;
                             BufSize : Longint);

Implementation

Const EPipeMsg = 'Failed to create pipe : Windows reported error %d.';
      ENoReadMSg = 'Cannot read from OuputPipeStream.';
      ENoWriteMsg = 'Cannot write to InputPipeStream.';
      ENoSeekMsg = 'Cannot seek on pipes';

{$ifdef linux}
Function  CreatePipe (Var Inhandle,OutHandle : Integer; 
                      SecAttr : PSecurityAttributes; 
                      BufSize : Longint) : Boolean;
 
Var
  Pipes : Array[1..2] of Integer;
   
begin
  Result:=Libc.Pipe(@Pipes[1])=0;
  If Result Then
    begin
    InHandle:=Pipes[1];
    OutHandle:=Pipes[2];
    end;
end;
{$endif}

Procedure CreatePipeStreams (Var InPipe : TInputPipeStream;
                             Var OutPipe : TOutputPipeStream;
                             SecAttr : PSecurityAttributes;
                             BufSize : Longint);

Var InHandle,OutHandle : {$ifdef linux}Integer{$else}THandle{$endif};

begin
  if CreatePipe (InHandle, OutHandle, SecAttr, BufSize) then
    begin
    Inpipe:=TinputPipeStream.Create (InHandle);
    OutPipe:=ToutputPipeStream.Create (OutHandle);
    end
  Else
    Raise EPipeCreation.CreateFmt (EPipeMsg,[getlasterror])
end;

destructor TPipeStream.Destroy;
begin
  If Handle>=0 then
    FileClose(Handle);
end;

Function TPipeStream.Seek (Offset : Longint;Origin : Word) : longint;

begin
  Raise EPipeSeek.Create (ENoSeekMsg);
end;

Function TInputPipeStream.Write (Const Buffer; Count : Longint) : longint;

begin
  Raise ENoWritePipe.Create (ENoWriteMsg);
end;

Function TOutputPipeStream.Read(Var Buffer; Count : Longint) : longint;

begin
  Raise ENoReadPipe.Create (ENoReadMsg);
end;

end.
