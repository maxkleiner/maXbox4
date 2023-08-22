unit uPSI_DelphiZXingQRCode;
{
TmyQRFaster
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_DelphiZXingQRCode = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDelphiZXingQRCode(CL: TPSPascalCompiler);
procedure SIRegister_DelphiZXingQRCode(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDelphiZXingQRCode(CL: TPSRuntimeClassImporter);
procedure RIRegister_DelphiZXingQRCode(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   DelphiZXingQRCode
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DelphiZXingQRCode]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDelphiZXingQRCode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TDelphiZXingQRCode') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TDelphiZXingQRCode') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('Data', 'WideString', iptrw);
    RegisterProperty('Encoding', 'TQRCodeEncoding', iptrw);
    RegisterProperty('QuietZone', 'Integer', iptrw);
    RegisterProperty('Rows', 'Integer', iptr);
    RegisterProperty('Columns', 'Integer', iptr);
    RegisterProperty('IsBlack', 'Boolean Integer Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DelphiZXingQRCode(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TQRCodeEncoding', '( qrcAuto, qrcNumeric, qrcAlphanumeric, qrcISO88591, qrcUTF8NoBOM, qrcUTF8BOM )');
  CL.AddTypeS('T2DBooleanArray', 'array of array of Boolean');
  SIRegister_TDelphiZXingQRCode(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDelphiZXingQRCodeIsBlack_R(Self: TDelphiZXingQRCode; var T: Boolean; const t1: Integer; const t2: Integer);
begin T := Self.IsBlack[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TDelphiZXingQRCodeColumns_R(Self: TDelphiZXingQRCode; var T: Integer);
begin T := Self.Columns; end;

(*----------------------------------------------------------------------------*)
procedure TDelphiZXingQRCodeRows_R(Self: TDelphiZXingQRCode; var T: Integer);
begin T := Self.Rows; end;

(*----------------------------------------------------------------------------*)
procedure TDelphiZXingQRCodeQuietZone_W(Self: TDelphiZXingQRCode; const T: Integer);
begin Self.QuietZone := T; end;

(*----------------------------------------------------------------------------*)
procedure TDelphiZXingQRCodeQuietZone_R(Self: TDelphiZXingQRCode; var T: Integer);
begin T := Self.QuietZone; end;

(*----------------------------------------------------------------------------*)
procedure TDelphiZXingQRCodeEncoding_W(Self: TDelphiZXingQRCode; const T: TQRCodeEncoding);
begin Self.Encoding := T; end;

(*----------------------------------------------------------------------------*)
procedure TDelphiZXingQRCodeEncoding_R(Self: TDelphiZXingQRCode; var T: TQRCodeEncoding);
begin T := Self.Encoding; end;

(*----------------------------------------------------------------------------*)
procedure TDelphiZXingQRCodeData_W(Self: TDelphiZXingQRCode; const T: WideString);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TDelphiZXingQRCodeData_R(Self: TDelphiZXingQRCode; var T: WideString);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDelphiZXingQRCode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDelphiZXingQRCode) do
  begin
    RegisterConstructor(@TDelphiZXingQRCode.Create, 'Create');
    RegisterPropertyHelper(@TDelphiZXingQRCodeData_R,@TDelphiZXingQRCodeData_W,'Data');
    RegisterPropertyHelper(@TDelphiZXingQRCodeEncoding_R,@TDelphiZXingQRCodeEncoding_W,'Encoding');
    RegisterPropertyHelper(@TDelphiZXingQRCodeQuietZone_R,@TDelphiZXingQRCodeQuietZone_W,'QuietZone');
    RegisterPropertyHelper(@TDelphiZXingQRCodeRows_R,nil,'Rows');
    RegisterPropertyHelper(@TDelphiZXingQRCodeColumns_R,nil,'Columns');
    RegisterPropertyHelper(@TDelphiZXingQRCodeIsBlack_R,nil,'IsBlack');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DelphiZXingQRCode(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDelphiZXingQRCode(CL);
end;

 
 
{ TPSImport_DelphiZXingQRCode }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DelphiZXingQRCode.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DelphiZXingQRCode(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DelphiZXingQRCode.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DelphiZXingQRCode(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
