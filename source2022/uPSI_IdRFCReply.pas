unit uPSI_IdRFCReply;
{
   one of indy
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
  TPSImport_IdRFCReply = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdRFCReplies(CL: TPSPascalCompiler);
procedure SIRegister_TIdRFCReply(CL: TPSPascalCompiler);
procedure SIRegister_IdRFCReply(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdRFCReplies(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdRFCReply(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdRFCReply(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdRFCReply
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdRFCReply]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdRFCReplies(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TIdRFCReplies') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TIdRFCReplies') do begin
    RegisterMethod('Function Add : TIdRFCReply;');
    RegisterMethod('Function Add1( const ANumericCode : Integer; const AText : string) : TIdRFCReply;');
    RegisterMethod('Constructor Create( AOwner : TPersistent)');
    RegisterMethod('Function FindByNumber( const ANo : Integer) : TIdRFCReply');
    RegisterMethod('Function UpdateReply( const ANumericCode : Integer; const AText : string) : TIdRFCReply');
    RegisterMethod('Procedure UpdateText( AReply : TIdRFCReply)');
    RegisterProperty('Items', 'TIdRFCReply Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdRFCReply(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TIdRFCReply') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TIdRFCReply') do begin
    RegisterMethod('Procedure Clear');
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function GenerateReply : string');
    RegisterMethod('Procedure ParseResponse( const AStrings : TStrings)');
    RegisterMethod('Function ReplyExists : Boolean');
    RegisterMethod('Procedure SetReply( const ANumericCode : Integer; const AText : string)');
    RegisterProperty('NumericCode', 'Integer', iptrw);
    RegisterProperty('Text', 'TStrings', iptrw);
    RegisterProperty('TextCode', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdRFCReply(CL: TPSPascalCompiler);
begin
  SIRegister_TIdRFCReply(CL);
  SIRegister_TIdRFCReplies(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdRFCRepliesItems_W(Self: TIdRFCReplies; const T: TIdRFCReply; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdRFCRepliesItems_R(Self: TIdRFCReplies; var T: TIdRFCReply; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
Function TIdRFCRepliesAdd1_P(Self: TIdRFCReplies;  const ANumericCode : Integer; const AText : string) : TIdRFCReply;
Begin Result := Self.Add(ANumericCode, AText); END;

(*----------------------------------------------------------------------------*)
Function TIdRFCRepliesAdd_P(Self: TIdRFCReplies) : TIdRFCReply;
Begin Result := Self.Add; END;

(*----------------------------------------------------------------------------*)
procedure TIdRFCReplyTextCode_W(Self: TIdRFCReply; const T: string);
begin Self.TextCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdRFCReplyTextCode_R(Self: TIdRFCReply; var T: string);
begin T := Self.TextCode; end;

(*----------------------------------------------------------------------------*)
procedure TIdRFCReplyText_W(Self: TIdRFCReply; const T: TStrings);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdRFCReplyText_R(Self: TIdRFCReply; var T: TStrings);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TIdRFCReplyNumericCode_W(Self: TIdRFCReply; const T: Integer);
begin Self.NumericCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdRFCReplyNumericCode_R(Self: TIdRFCReply; var T: Integer);
begin T := Self.NumericCode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdRFCReplies(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdRFCReplies) do begin
    RegisterMethod(@TIdRFCRepliesAdd_P, 'Add');
    RegisterMethod(@TIdRFCRepliesAdd1_P, 'Add1');
    RegisterConstructor(@TIdRFCReplies.Create, 'Create');
    RegisterVirtualMethod(@TIdRFCReplies.FindByNumber, 'FindByNumber');
    RegisterMethod(@TIdRFCReplies.UpdateReply, 'UpdateReply');
    RegisterMethod(@TIdRFCReplies.UpdateText, 'UpdateText');
    RegisterPropertyHelper(@TIdRFCRepliesItems_R,@TIdRFCRepliesItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdRFCReply(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdRFCReply) do begin
    RegisterMethod(@TIdRFCReply.Clear, 'Clear');
    RegisterConstructor(@TIdRFCReply.Create, 'Create');
    RegisterMethod(@TIdRFCReply.Destroy, 'Free');
    RegisterMethod(@TIdRFCReply.GenerateReply, 'GenerateReply');
    RegisterMethod(@TIdRFCReply.ParseResponse, 'ParseResponse');
    RegisterMethod(@TIdRFCReply.ReplyExists, 'ReplyExists');
    RegisterMethod(@TIdRFCReply.SetReply, 'SetReply');
    RegisterPropertyHelper(@TIdRFCReplyNumericCode_R,@TIdRFCReplyNumericCode_W,'NumericCode');
    RegisterPropertyHelper(@TIdRFCReplyText_R,@TIdRFCReplyText_W,'Text');
    RegisterPropertyHelper(@TIdRFCReplyTextCode_R,@TIdRFCReplyTextCode_W,'TextCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdRFCReply(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdRFCReply(CL);
  RIRegister_TIdRFCReplies(CL);
end;

 
 
{ TPSImport_IdRFCReply }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdRFCReply.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdRFCReply(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdRFCReply.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdRFCReply(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
