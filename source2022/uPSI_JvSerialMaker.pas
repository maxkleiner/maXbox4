unit uPSI_JvSerialMaker;
{
  checker
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
  TPSImport_JvSerialMaker = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvSerialMaker(CL: TPSPascalCompiler);
procedure SIRegister_JvSerialMaker(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvSerialMaker(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvSerialMaker(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  JvTypes
  ,JvComponentBase
  ,JvSerialMaker
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvSerialMaker]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSerialMaker(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvSerialMaker') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvSerialMaker') do begin
    RegisterMethod('Function GiveSerial( ABase : Integer; AUserName : string) : string');
    RegisterMethod('Function SerialIsCorrect( ABase : Integer; AUserName : string; Serial : string) : Boolean');
    RegisterProperty('UserName', 'string', iptrw);
    RegisterProperty('Base', 'Integer', iptrw);
    RegisterProperty('Serial', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvSerialMaker(CL: TPSPascalCompiler);
begin
  SIRegister_TJvSerialMaker(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvSerialMakerSerial_W(Self: TJvSerialMaker; const T: string);
begin Self.Serial := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSerialMakerSerial_R(Self: TJvSerialMaker; var T: string);
begin T := Self.Serial; end;

(*----------------------------------------------------------------------------*)
procedure TJvSerialMakerBase_W(Self: TJvSerialMaker; const T: Integer);
begin Self.Base := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSerialMakerBase_R(Self: TJvSerialMaker; var T: Integer);
begin T := Self.Base; end;

(*----------------------------------------------------------------------------*)
procedure TJvSerialMakerUserName_W(Self: TJvSerialMaker; const T: string);
begin Self.UserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSerialMakerUserName_R(Self: TJvSerialMaker; var T: string);
begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSerialMaker(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSerialMaker) do begin
    RegisterMethod(@TJvSerialMaker.GiveSerial, 'GiveSerial');
    RegisterMethod(@TJvSerialMaker.SerialIsCorrect, 'SerialIsCorrect');
    RegisterPropertyHelper(@TJvSerialMakerUserName_R,@TJvSerialMakerUserName_W,'UserName');
    RegisterPropertyHelper(@TJvSerialMakerBase_R,@TJvSerialMakerBase_W,'Base');
    RegisterPropertyHelper(@TJvSerialMakerSerial_R,@TJvSerialMakerSerial_W,'Serial');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvSerialMaker(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvSerialMaker(CL);
end;

 
 
{ TPSImport_JvSerialMaker }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSerialMaker.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvSerialMaker(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSerialMaker.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvSerialMaker(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
