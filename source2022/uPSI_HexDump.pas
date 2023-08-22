unit uPSI_HexDump;
{
 the hexer of hex edit
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
  TPSImport_HexDump = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_THexDump(CL: TPSPascalCompiler);
procedure SIRegister_HexDump(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_HexDump_Routines(S: TPSExec);
procedure RIRegister_THexDump(CL: TPSRuntimeClassImporter);
procedure RIRegister_HexDump(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StdCtrls
  ,HexDump
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_HexDump]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_THexDump(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'THexDump') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'THexDump') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('CurrentLine', 'Integer', iptrw);
    RegisterProperty('Address', '___Pointer', iptrw);
    RegisterProperty('DataSize', 'Integer', iptrw);
    RegisterProperty('Border', 'TBorderStyle', iptrw);
    RegisterProperty('ShowAddress', 'Boolean', iptrw);
    RegisterProperty('ShowCharacters', 'Boolean', iptrw);
    RegisterProperty('AddressColor', 'TColor', iptrw);
    RegisterProperty('HexDataColor', 'TColor', iptrw);
    RegisterProperty('AnsiCharColor', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_HexDump(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MAXDIGITS','LongInt').SetInt( 16);
  SIRegister_THexDump(CL);
 CL.AddDelphiFunction('Function CreateHexDump( AOwner : TWinControl) : THexDump');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure THexDumpAnsiCharColor_W(Self: THexDump; const T: TColor);
begin Self.AnsiCharColor := T; end;

(*----------------------------------------------------------------------------*)
procedure THexDumpAnsiCharColor_R(Self: THexDump; var T: TColor);
begin T := Self.AnsiCharColor; end;

(*----------------------------------------------------------------------------*)
procedure THexDumpHexDataColor_W(Self: THexDump; const T: TColor);
begin Self.HexDataColor := T; end;

(*----------------------------------------------------------------------------*)
procedure THexDumpHexDataColor_R(Self: THexDump; var T: TColor);
begin T := Self.HexDataColor; end;

(*----------------------------------------------------------------------------*)
procedure THexDumpAddressColor_W(Self: THexDump; const T: TColor);
begin Self.AddressColor := T; end;

(*----------------------------------------------------------------------------*)
procedure THexDumpAddressColor_R(Self: THexDump; var T: TColor);
begin T := Self.AddressColor; end;

(*----------------------------------------------------------------------------*)
procedure THexDumpShowCharacters_W(Self: THexDump; const T: Boolean);
begin Self.ShowCharacters := T; end;

(*----------------------------------------------------------------------------*)
procedure THexDumpShowCharacters_R(Self: THexDump; var T: Boolean);
begin T := Self.ShowCharacters; end;

(*----------------------------------------------------------------------------*)
procedure THexDumpShowAddress_W(Self: THexDump; const T: Boolean);
begin Self.ShowAddress := T; end;

(*----------------------------------------------------------------------------*)
procedure THexDumpShowAddress_R(Self: THexDump; var T: Boolean);
begin T := Self.ShowAddress; end;

(*----------------------------------------------------------------------------*)
procedure THexDumpBorder_W(Self: THexDump; const T: TBorderStyle);
begin Self.Border := T; end;

(*----------------------------------------------------------------------------*)
procedure THexDumpBorder_R(Self: THexDump; var T: TBorderStyle);
begin T := Self.Border; end;

(*----------------------------------------------------------------------------*)
procedure THexDumpDataSize_W(Self: THexDump; const T: Integer);
begin Self.DataSize := T; end;

(*----------------------------------------------------------------------------*)
procedure THexDumpDataSize_R(Self: THexDump; var T: Integer);
begin T := Self.DataSize; end;

(*----------------------------------------------------------------------------*)
procedure THexDumpAddress_W(Self: THexDump; const T: Pointer);
begin Self.Address := T; end;

(*----------------------------------------------------------------------------*)
procedure THexDumpAddress_R(Self: THexDump; var T: Pointer);
begin T := Self.Address; end;

(*----------------------------------------------------------------------------*)
procedure THexDumpCurrentLine_W(Self: THexDump; const T: Integer);
begin Self.CurrentLine := T; end;

(*----------------------------------------------------------------------------*)
procedure THexDumpCurrentLine_R(Self: THexDump; var T: Integer);
begin T := Self.CurrentLine; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_HexDump_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateHexDump, 'CreateHexDump', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THexDump(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THexDump) do
  begin
    RegisterConstructor(@THexDump.Create, 'Create');
    RegisterPropertyHelper(@THexDumpCurrentLine_R,@THexDumpCurrentLine_W,'CurrentLine');
    RegisterPropertyHelper(@THexDumpAddress_R,@THexDumpAddress_W,'Address');
    RegisterPropertyHelper(@THexDumpDataSize_R,@THexDumpDataSize_W,'DataSize');
    RegisterPropertyHelper(@THexDumpBorder_R,@THexDumpBorder_W,'Border');
    RegisterPropertyHelper(@THexDumpShowAddress_R,@THexDumpShowAddress_W,'ShowAddress');
    RegisterPropertyHelper(@THexDumpShowCharacters_R,@THexDumpShowCharacters_W,'ShowCharacters');
    RegisterPropertyHelper(@THexDumpAddressColor_R,@THexDumpAddressColor_W,'AddressColor');
    RegisterPropertyHelper(@THexDumpHexDataColor_R,@THexDumpHexDataColor_W,'HexDataColor');
    RegisterPropertyHelper(@THexDumpAnsiCharColor_R,@THexDumpAnsiCharColor_W,'AnsiCharColor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_HexDump(CL: TPSRuntimeClassImporter);
begin
  RIRegister_THexDump(CL);
end;

 
 
{ TPSImport_HexDump }
(*----------------------------------------------------------------------------*)
procedure TPSImport_HexDump.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_HexDump(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_HexDump.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_HexDump(ri);
  RIRegister_HexDump_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
