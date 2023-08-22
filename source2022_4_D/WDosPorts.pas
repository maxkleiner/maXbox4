
{*******************************************************}
{                                                       }
{       Borland Delphi Run-time Library                 }
{       WDOSX Port[] and Mem[] Unit                     }
{                                                       }
{       for Delphi 4, 5 WDosX DOS-Extender              }
{       Copyright (c) 2000 by Immo Wache                }
{       e-mail: immo.wache@t-online.de                  }
{                                                       }
{*******************************************************}

{
  Version history:
    IWA 11/20/00 Version 1.1
}

unit WDosPorts;

interface

type
  TWPort = class(TObject)
  private
    procedure SetPort(Index: Word; Data: Byte);
    function GetPort(Index: Word): Byte;
  public
    property Port[Index: Word]: Byte read GetPort write SetPort; default;
  end;

  TPortW = class(TObject)
  private
    procedure SetPortW(Index: Word; Value: Word);
    function GetPortW(Index: Word): Word;
  public
    property PortW[Index: Word]: Word read GetPortW write SetPortW; default;
  end;

  TPortL = class(TObject)
  private
    procedure SetPortL(Index: Word; Value: LongInt);
    function GetPortL(Index: Word): LongInt;
  public
    property PortL[Index: Word]: LongInt read GetPortL write SetPortL; default;
  end;

  TMemW = class(TObject)
  private
    function GetMemW(Index: LongInt): Word;
    procedure SetMemW(Index: LongInt; const Value: Word);
  public
    property MemW[Index: LongInt]: Word read GetMemW write SetMemW; default;
  end;

  TMemL = class(TObject)
  private
    function GetMemL(Index: LongInt): LongInt;
    procedure SetMemL(Index: LongInt; const Value: LongInt);
  public
    property MemL[Index: LongInt]: LongInt read GetMemL write SetMemL; default;
  end;

var
  Port: TWPort;
  PortW: TPortW;
  PortL: TPortL;
  Mem: array[0..$7FFFFFFE] of Byte; // absolute 0;
  MemW: TMemW;
  MemL: TMemL;

implementation

{ TWPort }

function TWPort.GetPort(Index: Word): Byte; register; assembler;
asm
        IN      AL,DX
end;

procedure TWPort.SetPort(Index: Word; Data: Byte); register; assembler;
asm
        MOV     EAX,ECX
        OUT     DX,AL
end;

{ TPortW }

function TPortW.GetPortW(Index: Word): Word; register; assembler;
asm
        IN      AX,DX
end;

procedure TPortW.SetPortW(Index: Word; Value: Word); register; assembler;
asm
        MOV     EAX,ECX
        OUT     DX,AX
end;

{ TPortL }

function TPortL.GetPortL(Index: Word): LongInt; register; assembler;
asm
       IN       EAX,DX
end;

procedure TPortL.SetPortL(Index: Word; Value: Integer); register; assembler;
asm
        MOV     EAX,ECX
        OUT     DX,EAX
end;

{ TMemW }

function TMemW.GetMemW(Index: LongInt): Word; register; assembler;
asm
        MOV     AX,[EDX]
end;

procedure TMemW.SetMemW(Index: LongInt; const Value: Word); register; assembler;
asm
        MOV     [EDX],CX
end;

{ TMemL }

function TMemL.GetMemL(Index: LongInt): LongInt; register; assembler;
asm
        MOV     EAX,[EDX]
end;

procedure TMemL.SetMemL(Index: LongInt; const Value: LongInt); register;
    assembler;
asm
        MOV     [EDX],ECX
end;

{initialization
  Port :=TPort.Create;
  PortW :=TPortW.Create;
  PortL :=TPortL.Create;
  MemW :=TMemW.Create;
  MemL :=TMemL.Create;

finalization
  Port.Free;
  PortW.Free;
  PortL.Free;
  MemW.Free;
  MemL.Free;}

end.
