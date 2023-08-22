unit uPSI_xrtl_net_URI;
{

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
  TPSImport_xrtl_net_URI = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TXRTLURI(CL: TPSPascalCompiler);
procedure SIRegister_xrtl_net_URI(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TXRTLURI(CL: TPSRuntimeClassImporter);
procedure RIRegister_xrtl_net_URI(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   xrtl_net_URI
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_net_URI]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLURI(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TXRTLURI') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TXRTLURI') do begin
    RegisterMethod('Constructor Create( const AURI : WideString)');
    RegisterProperty('Bookmark', 'WideString', iptrw);
    RegisterProperty('Document', 'WideString', iptrw);
    RegisterProperty('Host', 'WideString', iptrw);
    RegisterProperty('Password', 'WideString', iptrw);
    RegisterProperty('Path', 'WideString', iptrw);
    RegisterProperty('Port', 'WideString', iptrw);
    RegisterProperty('Protocol', 'WideString', iptrw);
    RegisterProperty('URI', 'WideString', iptrw);
    RegisterProperty('Username', 'WideString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_net_URI(CL: TPSPascalCompiler);
begin
  SIRegister_TXRTLURI(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TXRTLURIUsername_W(Self: TXRTLURI; const T: WideString);
begin Self.Username := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLURIUsername_R(Self: TXRTLURI; var T: WideString);
begin T := Self.Username; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLURIURI_W(Self: TXRTLURI; const T: WideString);
begin Self.URI := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLURIURI_R(Self: TXRTLURI; var T: WideString);
begin T := Self.URI; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLURIProtocol_W(Self: TXRTLURI; const T: WideString);
begin Self.Protocol := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLURIProtocol_R(Self: TXRTLURI; var T: WideString);
begin T := Self.Protocol; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLURIPort_W(Self: TXRTLURI; const T: WideString);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLURIPort_R(Self: TXRTLURI; var T: WideString);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLURIPath_W(Self: TXRTLURI; const T: WideString);
begin Self.Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLURIPath_R(Self: TXRTLURI; var T: WideString);
begin T := Self.Path; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLURIPassword_W(Self: TXRTLURI; const T: WideString);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLURIPassword_R(Self: TXRTLURI; var T: WideString);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLURIHost_W(Self: TXRTLURI; const T: WideString);
begin Self.Host := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLURIHost_R(Self: TXRTLURI; var T: WideString);
begin T := Self.Host; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLURIDocument_W(Self: TXRTLURI; const T: WideString);
begin Self.Document := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLURIDocument_R(Self: TXRTLURI; var T: WideString);
begin T := Self.Document; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLURIBookmark_W(Self: TXRTLURI; const T: WideString);
begin Self.Bookmark := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLURIBookmark_R(Self: TXRTLURI; var T: WideString);
begin T := Self.Bookmark; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLURI(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLURI) do begin
    RegisterConstructor(@TXRTLURI.Create, 'Create');
    RegisterPropertyHelper(@TXRTLURIBookmark_R,@TXRTLURIBookmark_W,'Bookmark');
    RegisterPropertyHelper(@TXRTLURIDocument_R,@TXRTLURIDocument_W,'Document');
    RegisterPropertyHelper(@TXRTLURIHost_R,@TXRTLURIHost_W,'Host');
    RegisterPropertyHelper(@TXRTLURIPassword_R,@TXRTLURIPassword_W,'Password');
    RegisterPropertyHelper(@TXRTLURIPath_R,@TXRTLURIPath_W,'Path');
    RegisterPropertyHelper(@TXRTLURIPort_R,@TXRTLURIPort_W,'Port');
    RegisterPropertyHelper(@TXRTLURIProtocol_R,@TXRTLURIProtocol_W,'Protocol');
    RegisterPropertyHelper(@TXRTLURIURI_R,@TXRTLURIURI_W,'URI');
    RegisterPropertyHelper(@TXRTLURIUsername_R,@TXRTLURIUsername_W,'Username');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_net_URI(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TXRTLURI(CL);
end;

 
 
{ TPSImport_xrtl_net_URI }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_net_URI.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_net_URI(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_net_URI.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_xrtl_net_URI(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
