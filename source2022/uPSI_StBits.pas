unit uPSI_StBits;
{
  arduino bits
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
  TPSImport_StBits = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStBits(CL: TPSPascalCompiler);
procedure SIRegister_StBits(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStBits(CL: TPSRuntimeClassImporter);
procedure RIRegister_StBits(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StBase
  ,StConst
  ,StBits
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StBits]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStBits(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStContainer', 'TStBits') do
  with CL.AddClassN(CL.FindClass('TStContainer'),'TStBits') do begin
    RegisterMethod('Constructor Create( Max : LongInt)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure LoadFromStream( S : TStream)');
    RegisterMethod('Procedure StoreToStream( S : TStream)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure CopyBits( B : TStBits)');
    RegisterMethod('Procedure SetBits');
    RegisterMethod('Procedure InvertBits');
    RegisterMethod('Procedure OrBits( B : TStBits)');
    RegisterMethod('Procedure AndBits( B : TStBits)');
    RegisterMethod('Procedure SubBits( B : TStBits)');
    RegisterMethod('Procedure SetBit( N : LongInt)');
    RegisterMethod('Procedure ClearBit( N : LongInt)');
    RegisterMethod('Procedure ToggleBit( N : LongInt)');
    RegisterMethod('Procedure ControlBit( N : LongInt; State : Boolean)');
    RegisterMethod('Function BitIsSet( N : LongInt) : Boolean');
    RegisterMethod('Function FirstSet : LongInt');
    RegisterMethod('Function LastSet : LongInt');
    RegisterMethod('Function FirstClear : LongInt');
    RegisterMethod('Function LastClear : LongInt');
    RegisterMethod('Function NextSet( N : LongInt) : LongInt');
    RegisterMethod('Function PrevSet( N : LongInt) : LongInt');
    RegisterMethod('Function NextClear( N : LongInt) : LongInt');
    RegisterMethod('Function PrevClear( N : LongInt) : LongInt');
    RegisterMethod('Function Iterate( Action : TBitIterateFunc; UseSetBits, Up : Boolean; OtherData : Pointer) : LongInt');
    RegisterMethod('Function IterateFrom( Action : TBitIterateFunc; UseSetBits, Up : Boolean; OtherData : Pointer; From : LongInt) : LongInt');
    RegisterProperty('Max', 'LongInt', iptrw);
    RegisterProperty('Items', 'Boolean LongInt', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StBits(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TStBits');
  SIRegister_TStBits(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStBitsItems_W(Self: TStBits; const T: Boolean; const t1: LongInt);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBitsItems_R(Self: TStBits; var T: Boolean; const t1: LongInt);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStBitsMax_W(Self: TStBits; const T: LongInt);
begin Self.Max := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBitsMax_R(Self: TStBits; var T: LongInt);
begin T := Self.Max; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStBits(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStBits) do begin
    RegisterConstructor(@TStBits.Create, 'Create');
    RegisterMethod(@TStBits.Destroy, 'Free');
    RegisterMethod(@TStBits.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TStBits.StoreToStream, 'StoreToStream');
    RegisterMethod(@TStBits.Clear, 'Clear');
    RegisterMethod(@TStBits.CopyBits, 'CopyBits');
    RegisterMethod(@TStBits.SetBits, 'SetBits');
    RegisterMethod(@TStBits.InvertBits, 'InvertBits');
    RegisterMethod(@TStBits.OrBits, 'OrBits');
    RegisterMethod(@TStBits.AndBits, 'AndBits');
    RegisterMethod(@TStBits.SubBits, 'SubBits');
    RegisterMethod(@TStBits.SetBit, 'SetBit');
    RegisterMethod(@TStBits.ClearBit, 'ClearBit');
    RegisterMethod(@TStBits.ToggleBit, 'ToggleBit');
    RegisterMethod(@TStBits.ControlBit, 'ControlBit');
    RegisterMethod(@TStBits.BitIsSet, 'BitIsSet');
    RegisterMethod(@TStBits.FirstSet, 'FirstSet');
    RegisterMethod(@TStBits.LastSet, 'LastSet');
    RegisterMethod(@TStBits.FirstClear, 'FirstClear');
    RegisterMethod(@TStBits.LastClear, 'LastClear');
    RegisterMethod(@TStBits.NextSet, 'NextSet');
    RegisterMethod(@TStBits.PrevSet, 'PrevSet');
    RegisterMethod(@TStBits.NextClear, 'NextClear');
    RegisterMethod(@TStBits.PrevClear, 'PrevClear');
    RegisterMethod(@TStBits.Iterate, 'Iterate');
    RegisterMethod(@TStBits.IterateFrom, 'IterateFrom');
    RegisterPropertyHelper(@TStBitsMax_R,@TStBitsMax_W,'Max');
    RegisterPropertyHelper(@TStBitsItems_R,@TStBitsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StBits(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStBits) do
  RIRegister_TStBits(CL);
end;

 
 
{ TPSImport_StBits }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StBits.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StBits(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StBits.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StBits(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
