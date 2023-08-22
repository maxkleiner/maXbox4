unit uPSI_JvDataEmbedded;
{
  date rate
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
  TPSImport_JvDataEmbedded = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvDataEmbedded(CL: TPSPascalCompiler);
procedure SIRegister_JvDataEmbedded(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvDataEmbedded(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvDataEmbedded(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   JvComponent
  ,JvDataEmbedded
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvDataEmbedded]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDataEmbedded(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvDataEmbedded') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvDataEmbedded') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure SaveToFile( FileName : TFileName)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterProperty('Size', 'Integer', iptrw);
    RegisterProperty('Data', 'TStream', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvDataEmbedded(CL: TPSPascalCompiler);
begin
  SIRegister_TJvDataEmbedded(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvDataEmbeddedData_W(Self: TJvDataEmbedded; const T: TStream);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDataEmbeddedData_R(Self: TJvDataEmbedded; var T: TStream);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TJvDataEmbeddedSize_W(Self: TJvDataEmbedded; const T: Integer);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDataEmbeddedSize_R(Self: TJvDataEmbedded; var T: Integer);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDataEmbedded(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDataEmbedded) do begin
    RegisterConstructor(@TJvDataEmbedded.Create, 'Create');
    RegisterMethod(@TJvDataEmbedded.Destroy, 'Free');
    RegisterMethod(@TJvDataEmbedded.SaveToFile, 'SaveToFile');
    RegisterMethod(@TJvDataEmbedded.SaveToStream, 'SaveToStream');
    RegisterPropertyHelper(@TJvDataEmbeddedSize_R,@TJvDataEmbeddedSize_W,'Size');
    RegisterPropertyHelper(@TJvDataEmbeddedData_R,@TJvDataEmbeddedData_W,'Data');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDataEmbedded(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvDataEmbedded(CL);
end;

 
 
{ TPSImport_JvDataEmbedded }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDataEmbedded.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvDataEmbedded(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDataEmbedded.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvDataEmbedded(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
