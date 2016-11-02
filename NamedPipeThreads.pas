{ *********************************************************************** }
{                                                                         }
{ Named Pipes Client/Server demo                                          }
{                                                                         }
{ Named Pipes Thread                                                      }
{                                                                         }
{ Chua Chee Wee, Singapore   - packed thread debug Max                    }
{                                                                         }
{ *********************************************************************** }
unit NamedPipeThreads;

interface
uses Classes, StdCtrls, NamedPipesImpl {DebugThreadSupport};

{$IFDEF MSWINDOWS}
type
  TThreadNameInfo = record
    FType: LongWord; // must be 0x1000
    FName: PChar; // pointer to name (in user address space)
    FThreadID: LongWord; // thread ID (-1 indicates caller thread)
    FFlags: LongWord; // reserved for future use, must be zero
  end;

  TNamedThread = class(TThread)
  public
    class procedure SetName(const AThreadName: string;
      const AThreadID: LongWord = $FFFFFFFF); overload;
  end;
{$ENDIF}


type
 TNamedPipeThread = class(TNamedThread)
 protected
   FNamedPipe: TNamedPipe2;
   FMemo: TMemo;
   FMessage: WideString;
   procedure WriteMessage;
 public
   constructor Create(NamedPipe: TNamedPipe2; Memo: TMemo);
   procedure Execute; override;
 end;

implementation
    uses windows;

function IsDebuggerPresent: Boolean; external 'KERNEL32.DLL';

{ TNamedThread }

class procedure TNamedThread.SetName(const AThreadName: string;
  const AThreadID: Longword = $FFFFFFFF);
var
  ThreadNameInfo: TThreadNameInfo;
begin
 if IsDebuggerPresent then
  try
    ThreadNameInfo.FType := $1000;
    ThreadNameInfo.FName := PChar(AThreadName);
    ThreadNameInfo.FThreadID := AThreadID;
    ThreadNameInfo.FFlags := 0;

    RaiseException($406D1388, 0, sizeof(ThreadNameInfo) div sizeof(LongWord), @ThreadNameInfo);
  except
  end;
end;



{ TNamedPipeThread }

constructor TNamedPipeThread.Create(NamedPipe: TNamedPipe2; Memo: TMemo);
begin
  inherited Create(True);
  FNamedPipe := NamedPipe;
  FMemo := Memo;
  FreeOnTerminate := True;
  Resume;
  TNamedThread.SetName('Main NamedPipe2 Thread');   //instead of initialize
end;

procedure TNamedPipeThread.Execute;
begin
  SetName(ClassName);
  while not Terminated do
    begin
      if FNamedPipe.Connected then
        begin
          FNamedPipe.Read(FMessage);
          Synchronize(WriteMessage);
        end;
    end;
end;

procedure TNamedPipeThread.WriteMessage;
begin
  FMemo.Lines.Add(FMessage);
end;

end.
