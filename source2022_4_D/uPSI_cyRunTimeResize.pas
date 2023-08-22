unit uPSI_cyRunTimeResize;
{
  resizer
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
  TPSImport_cyRunTimeResize = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyRunTimeResize(CL: TPSPascalCompiler);
procedure SIRegister_cyRunTimeResize(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TcyRunTimeResize(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyRunTimeResize(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   cyTypes
  ,cyClasses
  ,Controls
  ,cyRunTimeResize
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyRunTimeResize]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyRunTimeResize(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TcyRunTimeResize') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TcyRunTimeResize') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
     RegisterMethod('Procedure StartJob( X, Y : Integer)');
    RegisterMethod('Procedure DoJob( X, Y : Integer)');
    RegisterMethod('Procedure EndJob( X, Y : Integer)');
    RegisterProperty('Control', 'TControl', iptrw);
    RegisterProperty('Options', 'TcyRunTimeDesign', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyRunTimeResize(CL: TPSPascalCompiler);
begin
  SIRegister_TcyRunTimeResize(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TcyRunTimeResizeOptions_W(Self: TcyRunTimeResize; const T: TcyRunTimeDesign);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeResizeOptions_R(Self: TcyRunTimeResize; var T: TcyRunTimeDesign);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeResizeControl_W(Self: TcyRunTimeResize; const T: TControl);
begin Self.Control := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyRunTimeResizeControl_R(Self: TcyRunTimeResize; var T: TControl);
begin T := Self.Control; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyRunTimeResize(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyRunTimeResize) do begin
    RegisterConstructor(@TcyRunTimeResize.Create, 'Create');
    RegisterMethod(@TcyRunTimeResize.Destroy, 'Free');
    RegisterMethod(@TcyRunTimeResize.StartJob, 'StartJob');
    RegisterMethod(@TcyRunTimeResize.DoJob, 'DoJob');
    RegisterMethod(@TcyRunTimeResize.EndJob, 'EndJob');
    RegisterPropertyHelper(@TcyRunTimeResizeControl_R,@TcyRunTimeResizeControl_W,'Control');
    RegisterPropertyHelper(@TcyRunTimeResizeOptions_R,@TcyRunTimeResizeOptions_W,'Options');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyRunTimeResize(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TcyRunTimeResize(CL);
end;

 
 
{ TPSImport_cyRunTimeResize }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyRunTimeResize.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyRunTimeResize(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyRunTimeResize.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyRunTimeResize(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
