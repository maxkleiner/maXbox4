unit uPSI_DBXChannel;
{
  for indydbx
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
  TPSImport_DBXChannel = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDBXChannel(CL: TPSPascalCompiler);
procedure SIRegister_DBXChannel(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDBXChannel(CL: TPSRuntimeClassImporter);
procedure RIRegister_DBXChannel(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   DBXCommon
  ,DBXChannel
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DBXChannel]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXChannel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TDBXChannel') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TDBXChannel') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Open');
    RegisterMethod('Procedure Close');
    RegisterMethod('Function Read( const Buffer : TBytes; Offset : Integer; Count : Integer) : Integer');
    RegisterMethod('Function Write( const Buffer : TBytes; Offset : Integer; Count : Integer) : Integer');
    RegisterProperty('DbxProperties', 'TDBXProperties', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DBXChannel(CL: TPSPascalCompiler);
begin
  SIRegister_TDBXChannel(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDBXChannelDbxProperties_W(Self: TDBXChannel; const T: TDBXProperties);
begin Self.DbxProperties := T; end;

(*----------------------------------------------------------------------------*)
procedure TDBXChannelDbxProperties_R(Self: TDBXChannel; var T: TDBXProperties);
begin T := Self.DbxProperties; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXChannel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXChannel) do begin
    RegisterConstructor(@TDBXChannel.Create, 'Create');
    //IIRegisterVirtualAbstractMethod(@TDBXChannel, @!.Open, 'Open');
    //RegisterVirtualAbstractMethod(@TDBXChannel, @!.Close, 'Close');
    //RegisterVirtualAbstractMethod(@TDBXChannel, @!.Read, 'Read');
    //RegisterVirtualAbstractMethod(@TDBXChannel, @!.Write, 'Write');
    RegisterPropertyHelper(@TDBXChannelDbxProperties_R,@TDBXChannelDbxProperties_W,'DbxProperties');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DBXChannel(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDBXChannel(CL);
end;

 
 
{ TPSImport_DBXChannel }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBXChannel.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DBXChannel(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBXChannel.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DBXChannel(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
