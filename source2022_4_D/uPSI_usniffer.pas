unit uPSI_usniffer;
{
   from template
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
  TPSImport_usniffer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TsniffForm(CL: TPSPascalCompiler);
procedure SIRegister_usniffer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TsniffForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_usniffer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,ComCtrls
  ,Winsock
  ,usniffer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_usniffer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TsniffForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TsniffForm') do
  with CL.AddClassN(CL.FindClass('TForm'),'TSniffForm') do begin
    RegisterProperty('ListView1', 'TListView', iptrw);
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure ListView1Change( Sender : TObject; Item : TListItem; Change : TItemChange)');
    RegisterMethod('Procedure FormClose( Sender : TObject; var Action : TCloseAction)');
    RegisterMethod('Procedure ListView1DblClick( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_usniffer(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MAX_PACKET_SIZE','LongWord').SetUInt( $10000);
 CL.AddConstantN('SIO_RCVALL','LongWord').SetUInt( $98000001);
  SIRegister_TsniffForm(CL);
  CL.AddTypeS('USHORT', 'Word');
  CL.AddTypeS('TIPHeader', 'record iph_verlen : UCHAR; iph_tos : UCHAR; iph_len'
   +'gth : USHORT; iph_id : USHORT; iph_offset : USHORT; iph_ttl : UCHAR; iph_p'
   +'rotocol : UCHAR; iph_xsum : USHORT; iph_src : ULONG; iph_dest : ULONG; end');
  //CL.AddTypeS('PIPHeader', '^TIPHeader // will not work');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TsniffFormListView1_W(Self: TsniffForm; const T: TListView);
Begin Self.ListView1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TsniffFormListView1_R(Self: TsniffForm; var T: TListView);
Begin T := Self.ListView1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TsniffForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TsniffForm) do
  begin
    RegisterPropertyHelper(@TsniffFormListView1_R,@TsniffFormListView1_W,'ListView1');
    RegisterMethod(@TsniffForm.FormCreate, 'FormCreate');
    RegisterMethod(@TsniffForm.ListView1Change, 'ListView1Change');
    RegisterMethod(@TsniffForm.FormClose, 'FormClose');
    RegisterMethod(@TsniffForm.ListView1DblClick, 'ListView1DblClick');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_usniffer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TsniffForm(CL);
end;

 
 
{ TPSImport_usniffer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_usniffer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_usniffer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_usniffer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_usniffer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
