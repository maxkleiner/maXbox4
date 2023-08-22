unit uPSI_neuralab;
{
  neuromancer II for https://sourceforge.net/projects/cai/
  done instead of destructor
  change array of byte to TBytes

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
  TPSImport_neuralab = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TABHash(CL: TPSPascalCompiler);
procedure SIRegister_neuralab(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_neuralab_Routines(S: TPSExec);
procedure RIRegister_TABHash(CL: TPSRuntimeClassImporter);
procedure RIRegister_neuralab(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   neuralab
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_neuralab]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TABHash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TABHash') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TABHash') do begin
    RegisterProperty('A', 'array of byte', iptrw);
    RegisterProperty('FLength', 'longint', iptrw);
    RegisterMethod('Constructor Init( PLength : longint)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Done');
    RegisterMethod('Procedure Include( var S : TBytes)');
    RegisterMethod('Function Test( var S : TBytes) : boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_neuralab(CL: TPSPascalCompiler);
begin
 CL.AddTypeS('TBytes', 'array of Byte');
  SIRegister_TABHash(CL);
 CL.AddDelphiFunction('Function ABKey( S : TBytes; Divisor : longint) : longint');
 CL.AddDelphiFunction('Function ABCmp( var X, Y : TBytes) : boolean');
 CL.AddDelphiFunction('Function ABCmp2( var X, Y : TBytes) : boolean');

 CL.AddDelphiFunction('Function ABGetNext1( var AB : TBytes; ST : word) : word');
 CL.AddDelphiFunction('Function ABCountDif( var X, Y : TBytes) : longint');
 CL.AddDelphiFunction('Function ABCountDifZero( var X : TBytes) : longint');
 CL.AddDelphiFunction('Procedure ABAnd( var A, B : TBytes)');
 CL.AddDelphiFunction('Function ABGetEqual( var Equal, X, Y : TBytes) : longint');
 CL.AddDelphiFunction('Procedure ABShiftLogicalLeft( var X : TBytes)');
 CL.AddDelphiFunction('Procedure ABShiftLogicalRight( var X : TBytes)');
 CL.AddDelphiFunction('Function ABGetDif( var Dif, X, Y : TBytes) : longint');
 CL.AddDelphiFunction('Function ABToString( var AB : TBytes) : string');
 CL.AddDelphiFunction('Function ABToStringR( var AB : TBytes) : string');
 CL.AddDelphiFunction('Procedure ABClear( var AB : TBytes)');
 CL.AddDelphiFunction('Procedure ABFull( var AB : TBytes)');
 CL.AddDelphiFunction('Procedure ABBitOnPos( var AB : TBytes; POS : longint)');
 CL.AddDelphiFunction('Procedure ABBitOnPosAtPos( var AB : TBytes; X, Start, Len : longint)');
 CL.AddDelphiFunction('Function ABReadBitOnPosAtPos( var AB : array of single; Start, Len : longint) : longint');
 CL.AddDelphiFunction('Procedure ABCopy( var A, B : TBytes)');
 CL.AddDelphiFunction('Procedure ABTriPascal( var A, B : TBytes)');
 CL.AddDelphiFunction('Procedure ABSet( var A : TBytes; B : TBytes)');
 CL.AddDelphiFunction('Procedure ABSet2(var A : TBytes; B : TBytes)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TABHashFLength_W(Self: TABHash; const T: longint);
Begin Self.FLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TABHashFLength_R(Self: TABHash; var T: longint);
Begin T := Self.FLength; end;

(*----------------------------------------------------------------------------*)
procedure TABHashA_W(Self: TABHash; const T: TBytes);
Begin Self.A := T;
end;

(*----------------------------------------------------------------------------*)
procedure TABHashA_R(Self: TABHash; var T: TBytes);
Begin T := Self.A;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_neuralab_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ABKey, 'ABKey', cdRegister);
 S.RegisterDelphiFunction(@ABCmp, 'ABCmp', cdRegister);
 S.RegisterDelphiFunction(@ABCmp2, 'ABCmp2', cdRegister);
 S.RegisterDelphiFunction(@ABGetNext1, 'ABGetNext1', cdRegister);
 S.RegisterDelphiFunction(@ABCountDif, 'ABCountDif', cdRegister);
 S.RegisterDelphiFunction(@ABCountDifZero, 'ABCountDifZero', cdRegister);
 S.RegisterDelphiFunction(@ABAnd, 'ABAnd', cdRegister);
 S.RegisterDelphiFunction(@ABGetEqual, 'ABGetEqual', cdRegister);
 S.RegisterDelphiFunction(@ABShiftLogicalLeft, 'ABShiftLogicalLeft', cdRegister);
 S.RegisterDelphiFunction(@ABShiftLogicalRight, 'ABShiftLogicalRight', cdRegister);
 S.RegisterDelphiFunction(@ABGetDif, 'ABGetDif', cdRegister);
 S.RegisterDelphiFunction(@ABToString, 'ABToString', cdRegister);
 S.RegisterDelphiFunction(@ABToStringR, 'ABToStringR', cdRegister);
 S.RegisterDelphiFunction(@ABClear, 'ABClear', cdRegister);
 S.RegisterDelphiFunction(@ABFull, 'ABFull', cdRegister);
 S.RegisterDelphiFunction(@ABBitOnPos, 'ABBitOnPos', cdRegister);
 S.RegisterDelphiFunction(@ABBitOnPosAtPos, 'ABBitOnPosAtPos', cdRegister);
 S.RegisterDelphiFunction(@ABReadBitOnPosAtPos, 'ABReadBitOnPosAtPos', cdRegister);
 S.RegisterDelphiFunction(@ABCopy, 'ABCopy', cdRegister);
 S.RegisterDelphiFunction(@ABTriPascal, 'ABTriPascal', cdRegister);
 S.RegisterDelphiFunction(@ABSet, 'ABSet', cdRegister);
 S.RegisterDelphiFunction(@ABSet2, 'ABSet2', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TABHash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TABHash) do begin
    RegisterPropertyHelper(@TABHashA_R,@TABHashA_W,'A');
    RegisterPropertyHelper(@TABHashFLength_R,@TABHashFLength_W,'FLength');
    RegisterConstructor(@TABHash.Init, 'Init');
    RegisterMethod(@TABHash.Clear, 'Clear');
    RegisterMethod(@TABHash.Done, 'Done');
    RegisterMethod(@TABHash.Include, 'Include');
    RegisterMethod(@TABHash.Test, 'Test');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_neuralab(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TABHash(CL);
end;

 
 
{ TPSImport_neuralab }
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralab.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_neuralab(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralab.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_neuralab(ri);
  RIRegister_neuralab_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
