unit uPSI_IdMessageCollection;
{
  collector
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
  TPSImport_IdMessageCollection = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdMessageCollection(CL: TPSPascalCompiler);
procedure SIRegister_TIdMessageItem(CL: TPSPascalCompiler);
procedure SIRegister_IdMessageCollection(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdMessageCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdMessageItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdMessageCollection(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdMessage
  ,IdMessageCollection
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdMessageCollection]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMessageCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TIdMessageCollection') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TIdMessageCollection') do begin
    RegisterMethod('Function Add : TIdMessageItem');
    RegisterProperty('Messages', 'TIdMessage Integer', iptrw);
    SetDefaultPropery('Messages');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMessageItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TIdMessageItem') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TIdMessageItem') do begin
    RegisterProperty('IdMessage', 'TIdMessage', iptrw);
    RegisterProperty('Attempt', 'Integer', iptrw);
    RegisterProperty('Queued', 'Boolean', iptrw);
    RegisterMethod('Constructor Create( Collection : TCollection)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdMessageCollection(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TIdMessageItems', 'class of TIdMessageItem');
  SIRegister_TIdMessageItem(CL);
  SIRegister_TIdMessageCollection(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdMessageCollectionMessages_W(Self: TIdMessageCollection; const T: TIdMessage; const t1: Integer);
begin Self.Messages[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageCollectionMessages_R(Self: TIdMessageCollection; var T: TIdMessage; const t1: Integer);
begin T := Self.Messages[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageItemQueued_W(Self: TIdMessageItem; const T: Boolean);
begin Self.Queued := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageItemQueued_R(Self: TIdMessageItem; var T: Boolean);
begin T := Self.Queued; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageItemAttempt_W(Self: TIdMessageItem; const T: Integer);
begin Self.Attempt := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageItemAttempt_R(Self: TIdMessageItem; var T: Integer);
begin T := Self.Attempt; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageItemIdMessage_W(Self: TIdMessageItem; const T: TIdMessage);
Begin Self.IdMessage := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageItemIdMessage_R(Self: TIdMessageItem; var T: TIdMessage);
Begin T := Self.IdMessage; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMessageCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMessageCollection) do begin
    RegisterMethod(@TIdMessageCollection.Add, 'Add');
    RegisterPropertyHelper(@TIdMessageCollectionMessages_R,@TIdMessageCollectionMessages_W,'Messages');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMessageItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMessageItem) do begin
    RegisterPropertyHelper(@TIdMessageItemIdMessage_R,@TIdMessageItemIdMessage_W,'IdMessage');
    RegisterPropertyHelper(@TIdMessageItemAttempt_R,@TIdMessageItemAttempt_W,'Attempt');
    RegisterPropertyHelper(@TIdMessageItemQueued_R,@TIdMessageItemQueued_W,'Queued');
    RegisterConstructor(@TIdMessageItem.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdMessageCollection(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdMessageItem(CL);
  RIRegister_TIdMessageCollection(CL);
end;

 
 
{ TPSImport_IdMessageCollection }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdMessageCollection.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdMessageCollection(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdMessageCollection.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdMessageCollection(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
