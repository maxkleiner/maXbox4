unit uPSI_FIFO;
{
   testbed for video stream
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
  TPSImport_FIFO = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TFIFO(CL: TPSPascalCompiler);
procedure SIRegister_FIFO(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TFIFO(CL: TPSRuntimeClassImporter);
procedure RIRegister_FIFO(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   FIFO
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_FIFO]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TFIFO(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TFIFO') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TFIFO') do
  begin
    RegisterMethod('Procedure WriteData( var Data : TMemoryStream; Size : Cardinal)');
    RegisterMethod('Procedure ReadData( var Data : TMemoryStream; Size : Cardinal)');
    RegisterMethod('Procedure RemoveData( Size : Cardinal)');
    RegisterMethod('Procedure Clear');
    RegisterProperty('Data', 'TMemoryStream', iptr);
    RegisterProperty('Size', 'Cardinal', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_FIFO(CL: TPSPascalCompiler);
begin
  SIRegister_TFIFO(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EFIFO');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ENotEnoughData');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TFIFOSize_R(Self: TFIFO; var T: Cardinal);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TFIFOData_R(Self: TFIFO; var T: TMemoryStream);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFIFO(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFIFO) do
  begin
    RegisterMethod(@TFIFO.WriteData, 'WriteData');
    RegisterMethod(@TFIFO.ReadData, 'ReadData');
    RegisterMethod(@TFIFO.RemoveData, 'RemoveData');
    RegisterMethod(@TFIFO.Clear, 'Clear');
    RegisterPropertyHelper(@TFIFOData_R,nil,'Data');
    RegisterPropertyHelper(@TFIFOSize_R,nil,'Size');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_FIFO(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TFIFO(CL);
  with CL.Add(EFIFO) do
  with CL.Add(ENotEnoughData) do
end;

 
 
{ TPSImport_FIFO }
(*----------------------------------------------------------------------------*)
procedure TPSImport_FIFO.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_FIFO(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_FIFO.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_FIFO(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
