{
 * Unit that implements the class that extends TPJCustomConsoleApp for
 * DelphiDabbler Console Application Runner Classes demo program #9: Subclassing
 * TPJConsoleApp.
 *
 * $Rev: 1358 $
 * $Date: 2013-03-25 03:31:31 +0000 (Mon, 25 Mar 2013) $
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit UConsoleAppEx;

interface

uses
  Classes,
  PJConsoleApp, PJPipe;

type

  TConsoleAppEx = class(TPJCustomConsoleApp)
  private
    fOutPipe: TPJPipe;
    fOutStream: TStream;
  protected
    procedure DoWork; override;
  public
    function Execute(const CmdLine: string;
      const InStream, OutStream: TStream): Boolean;
    property ErrorCode;
    property ErrorMessage;
    property TimeSlice;
  end;

implementation

uses
  SysUtils;

{ TConsoleAppEx }

procedure TConsoleAppEx.DoWork;
begin
  fOutPipe.CopyToStream(fOutStream, 0);
end;

function TConsoleAppEx.Execute(const CmdLine: string; const InStream,
  OutStream: TStream): Boolean;
var
  InPipe: TPJPipe;
begin
  fOutStream := OutStream;
  InPipe := nil;
  fOutPipe := nil;
  try
    // Set up input pipe and associated with console app stdin
    InPipe := TPJPipe.Create(InStream.Size);
    InPipe.CopyFromStream(InStream, 0);
    InPipe.CloseWriteHandle;
    StdIn := InPipe.ReadHandle;
    // Set up output pipe and associate with console app stdout
    fOutPipe := TPJPipe.Create;
    StdOut := fOutPipe.WriteHandle;
    // Run the application
    Result := inherited Execute(CmdLine);
  finally
    StdIn := 0;
    StdOut := 0;
    FreeAndNil(fOutPipe);
    FreeAndNil(InPipe);
  end;
end;

end.

