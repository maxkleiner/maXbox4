unit uPSI_ovctcary;
{
 cell hell     add free welcome to cellhell
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
  TPSImport_ovctcary = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOvcCellArray(CL: TPSPascalCompiler);
procedure SIRegister_ovctcary(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TOvcCellArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_ovctcary(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   OvcTCmmn
  ,ovctcary
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovctcary]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcCellArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TOvcCellArray') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TOvcCellArray') do begin
    RegisterMethod('Procedure AddCell( RowNum : TRowNum; ColNum : TColNum)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure AddUnusedBit');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function DeleteCell( RowNum : TRowNum; ColNum : TColNum) : boolean');
    RegisterMethod('Procedure GetCellAddr( Inx : Integer; var CellAddr : TOvcCellAddress)');
    RegisterMethod('Procedure Merge( CA : TOvcCellArray)');
    RegisterMethod('Function MustDoUnusedBit : boolean');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Empty', 'boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ovctcary(CL: TPSPascalCompiler);
begin
//type
  //TRowNum = longint;  {actually 0..2 billion}
  //TColNum = integer;  {actually 0..16K}
  CL.AddTypeS('TRowNum','longint');
  CL.AddTypeS('TColNum','integer');
  CL.AddTypeS('TOvcCellAddress', 'record Row : TRowNum; Col : TColNum; end');
  SIRegister_TOvcCellArray(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOvcCellArrayEmpty_R(Self: TOvcCellArray; var T: boolean);
begin T := Self.Empty; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCellArrayCount_R(Self: TOvcCellArray; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcCellArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcCellArray) do begin
    RegisterMethod(@TOvcCellArray.AddCell, 'AddCell');
        RegisterMethod(@TOvcCellArray.Destroy, 'Free');
     RegisterMethod(@TOvcCellArray.AddUnusedBit, 'AddUnusedBit');
    RegisterMethod(@TOvcCellArray.Clear, 'Clear');
    RegisterMethod(@TOvcCellArray.DeleteCell, 'DeleteCell');
    RegisterMethod(@TOvcCellArray.GetCellAddr, 'GetCellAddr');
    RegisterMethod(@TOvcCellArray.Merge, 'Merge');
    RegisterMethod(@TOvcCellArray.MustDoUnusedBit, 'MustDoUnusedBit');
    RegisterPropertyHelper(@TOvcCellArrayCount_R,nil,'Count');
    RegisterPropertyHelper(@TOvcCellArrayEmpty_R,nil,'Empty');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovctcary(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOvcCellArray(CL);
end;

 
 
{ TPSImport_ovctcary }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovctcary.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovctcary(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovctcary.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ovctcary(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
