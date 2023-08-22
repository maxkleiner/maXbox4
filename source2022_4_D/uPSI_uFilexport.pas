unit uPSI_uFilexport;
{
  on of my first classes of UML Bank
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
  TPSImport_uFilexport = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTxtFile(CL: TPSPascalCompiler);
procedure SIRegister_uFilexport(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TTxtFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_uFilexport(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   uFilexport
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uFilexport]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTxtFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TTxtFile') do
  with CL.AddClassN(CL.FindClass('TObject'),'TTxtFile') do begin
    RegisterMethod('Constructor Create( Name : TFileName)');
    RegisterMethod('Procedure Append');
    RegisterMethod('Procedure Assign( FName : string)');
    RegisterMethod('Procedure Close');
    RegisterMethod('Procedure Flush');
    RegisterMethod('Procedure ReadLn( var S : string)');
    RegisterMethod('Procedure ReSet');
    RegisterMethod('Procedure ReWrite');
    RegisterMethod('Procedure SetTextBuf( var Buf, Size : Word)');
    RegisterMethod('Procedure Write( const S : string)');
    RegisterMethod('Procedure WriteLn( const S : String)');
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('DefaultExt', 'TFileExt', iptrw);
    RegisterProperty('Eof', 'Boolean', iptr);
    RegisterProperty('Eoln', 'Boolean', iptr);
    RegisterProperty('FileName', 'string', iptrw);
    RegisterProperty('SeekEoln', 'Boolean', iptr);
    RegisterProperty('state', 'TFileMode', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uFilexport(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TTrigger', 'array of boolean');
  CL.AddTypeS('TTriggerEvent', 'Procedure (Sender : TObject; Trigger : TTrigger)');
  SIRegister_TTxtFile(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TTxtFilestate_W(Self: TTxtFile; const T: TFileMode);
begin Self.state := T; end;

(*----------------------------------------------------------------------------*)
procedure TTxtFilestate_R(Self: TTxtFile; var T: TFileMode);
begin T := Self.state; end;

(*----------------------------------------------------------------------------*)
procedure TTxtFileSeekEoln_R(Self: TTxtFile; var T: Boolean);
begin T := Self.SeekEoln; end;

(*----------------------------------------------------------------------------*)
procedure TTxtFileFileName_W(Self: TTxtFile; const T: string);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TTxtFileFileName_R(Self: TTxtFile; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TTxtFileEoln_R(Self: TTxtFile; var T: Boolean);
begin T := Self.Eoln; end;

(*----------------------------------------------------------------------------*)
procedure TTxtFileEof_R(Self: TTxtFile; var T: Boolean);
begin T := Self.Eof; end;

(*----------------------------------------------------------------------------*)
procedure TTxtFileDefaultExt_W(Self: TTxtFile; const T: TFileExt);
begin Self.DefaultExt := T; end;

(*----------------------------------------------------------------------------*)
procedure TTxtFileDefaultExt_R(Self: TTxtFile; var T: TFileExt);
begin T := Self.DefaultExt; end;

(*----------------------------------------------------------------------------*)
procedure TTxtFileActive_W(Self: TTxtFile; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TTxtFileActive_R(Self: TTxtFile; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTxtFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTxtFile) do begin
    RegisterConstructor(@TTxtFile.Create, 'Create');
    RegisterMethod(@TTxtFile.Append, 'Append');
    RegisterMethod(@TTxtFile.Assign, 'Assign');
    RegisterVirtualMethod(@TTxtFile.Close, 'Close');
    RegisterMethod(@TTxtFile.Flush, 'Flush');
    RegisterMethod(@TTxtFile.ReadLn, 'ReadLn');
    RegisterVirtualMethod(@TTxtFile.ReSet, 'ReSet');
    RegisterVirtualMethod(@TTxtFile.ReWrite, 'ReWrite');
    RegisterMethod(@TTxtFile.SetTextBuf, 'SetTextBuf');
    RegisterMethod(@TTxtFile.Write, 'Write');
    RegisterMethod(@TTxtFile.WriteLn, 'WriteLn');
    RegisterPropertyHelper(@TTxtFileActive_R,@TTxtFileActive_W,'Active');
    RegisterPropertyHelper(@TTxtFileDefaultExt_R,@TTxtFileDefaultExt_W,'DefaultExt');
    RegisterPropertyHelper(@TTxtFileEof_R,nil,'Eof');
    RegisterPropertyHelper(@TTxtFileEoln_R,nil,'Eoln');
    RegisterPropertyHelper(@TTxtFileFileName_R,@TTxtFileFileName_W,'FileName');
    RegisterPropertyHelper(@TTxtFileSeekEoln_R,nil,'SeekEoln');
    RegisterPropertyHelper(@TTxtFilestate_R,@TTxtFilestate_W,'state');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uFilexport(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TTxtFile(CL);
end;

 
 
{ TPSImport_uFilexport }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uFilexport.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uFilexport(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uFilexport.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uFilexport(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
