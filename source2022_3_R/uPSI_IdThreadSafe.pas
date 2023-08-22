unit uPSI_IdThreadSafe;
{
freeze stream safe list

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
  TPSImport_IdThreadSafe = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdThreadSafeList(CL: TPSPascalCompiler);
procedure SIRegister_TIdThreadSafeStringList(CL: TPSPascalCompiler);
procedure SIRegister_TIdThreadSafeString(CL: TPSPascalCompiler);
procedure SIRegister_TIdThreadSafeCardinal(CL: TPSPascalCompiler);
procedure SIRegister_TIdThreadSafeInteger(CL: TPSPascalCompiler);
procedure SIRegister_TIdThreadSafe(CL: TPSPascalCompiler);
procedure SIRegister_IdThreadSafe(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdThreadSafeList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdThreadSafeStringList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdThreadSafeString(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdThreadSafeCardinal(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdThreadSafeInteger(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdThreadSafe(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdThreadSafe(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   SyncObjs
  ,IdThreadSafe
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdThreadSafe]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdThreadSafeList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThreadList', 'TIdThreadSafeList') do
  with CL.AddClassN(CL.FindClass('TThreadList'),'TIdThreadSafeList') do
  begin
    RegisterMethod('Function IsCountLessThan( const AValue : Cardinal) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdThreadSafeStringList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdThreadSafe', 'TIdThreadSafeStringList') do
  with CL.AddClassN(CL.FindClass('TIdThreadSafe'),'TIdThreadSafeStringList') do begin
    RegisterMethod('Constructor Create( const ASorted : Boolean)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Add( const AItem : string)');
    RegisterMethod('Procedure AddObject( const AItem : string; AObject : TObject)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Lock : TStringList');
    RegisterMethod('Function ObjectByItem( const AItem : string) : TObject');
    RegisterMethod('Procedure Remove( const AItem : string)');
    RegisterMethod('Procedure Unlock');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdThreadSafeString(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdThreadSafe', 'TIdThreadSafeString') do
  with CL.AddClassN(CL.FindClass('TIdThreadSafe'),'TIdThreadSafeString') do
  begin
    RegisterMethod('Procedure Append( const AValue : string)');
    RegisterMethod('Procedure Prepend( const AValue : string)');
    RegisterProperty('Value', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdThreadSafeCardinal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdThreadSafe', 'TIdThreadSafeCardinal') do
  with CL.AddClassN(CL.FindClass('TIdThreadSafe'),'TIdThreadSafeCardinal') do
  begin
    RegisterMethod('Function Decrement : Cardinal');
    RegisterMethod('Function Increment : Cardinal');
    RegisterProperty('Value', 'Cardinal', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdThreadSafeInteger(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdThreadSafe', 'TIdThreadSafeInteger') do
  with CL.AddClassN(CL.FindClass('TIdThreadSafe'),'TIdThreadSafeInteger') do
  begin
    RegisterMethod('Function Decrement : Integer');
    RegisterMethod('Function Increment : Integer');
    RegisterProperty('Value', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdThreadSafe(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TIdThreadSafe') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TIdThreadSafe') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Lock');
    RegisterMethod('Procedure Unlock');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdThreadSafe(CL: TPSPascalCompiler);
begin
  SIRegister_TIdThreadSafe(CL);
  SIRegister_TIdThreadSafeInteger(CL);
  SIRegister_TIdThreadSafeCardinal(CL);
  SIRegister_TIdThreadSafeString(CL);
  SIRegister_TIdThreadSafeStringList(CL);
  SIRegister_TIdThreadSafeList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdThreadSafeStringValue_W(Self: TIdThreadSafeString; const T: string);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadSafeStringValue_R(Self: TIdThreadSafeString; var T: string);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadSafeCardinalValue_W(Self: TIdThreadSafeCardinal; const T: Cardinal);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadSafeCardinalValue_R(Self: TIdThreadSafeCardinal; var T: Cardinal);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadSafeIntegerValue_W(Self: TIdThreadSafeInteger; const T: Integer);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdThreadSafeIntegerValue_R(Self: TIdThreadSafeInteger; var T: Integer);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdThreadSafeList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdThreadSafeList) do
  begin
    RegisterMethod(@TIdThreadSafeList.IsCountLessThan, 'IsCountLessThan');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdThreadSafeStringList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdThreadSafeStringList) do  begin
    RegisterConstructor(@TIdThreadSafeStringList.Create, 'Create');
    RegisterMethod(@TIdThreadSafeStringList.Destroy, 'Free');

    RegisterMethod(@TIdThreadSafeStringList.Add, 'Add');
    RegisterMethod(@TIdThreadSafeStringList.AddObject, 'AddObject');
    RegisterMethod(@TIdThreadSafeStringList.Clear, 'Clear');
    RegisterMethod(@TIdThreadSafeStringList.Lock, 'Lock');
    RegisterMethod(@TIdThreadSafeStringList.ObjectByItem, 'ObjectByItem');
    RegisterMethod(@TIdThreadSafeStringList.Remove, 'Remove');
    RegisterMethod(@TIdThreadSafeStringList.Unlock, 'Unlock');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdThreadSafeString(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdThreadSafeString) do
  begin
    RegisterMethod(@TIdThreadSafeString.Append, 'Append');
    RegisterMethod(@TIdThreadSafeString.Prepend, 'Prepend');
    RegisterPropertyHelper(@TIdThreadSafeStringValue_R,@TIdThreadSafeStringValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdThreadSafeCardinal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdThreadSafeCardinal) do
  begin
    RegisterMethod(@TIdThreadSafeCardinal.Decrement, 'Decrement');
    RegisterMethod(@TIdThreadSafeCardinal.Increment, 'Increment');
    RegisterPropertyHelper(@TIdThreadSafeCardinalValue_R,@TIdThreadSafeCardinalValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdThreadSafeInteger(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdThreadSafeInteger) do
  begin
    RegisterMethod(@TIdThreadSafeInteger.Decrement, 'Decrement');
    RegisterMethod(@TIdThreadSafeInteger.Increment, 'Increment');
    RegisterPropertyHelper(@TIdThreadSafeIntegerValue_R,@TIdThreadSafeIntegerValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdThreadSafe(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdThreadSafe) do begin
    RegisterVirtualConstructor(@TIdThreadSafe.Create, 'Create');
     RegisterMethod(@TIdThreadSafe.Destroy, 'Free');
     RegisterMethod(@TIdThreadSafe.Lock, 'Lock');
    RegisterMethod(@TIdThreadSafe.Unlock, 'Unlock');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdThreadSafe(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdThreadSafe(CL);
  RIRegister_TIdThreadSafeInteger(CL);
  RIRegister_TIdThreadSafeCardinal(CL);
  RIRegister_TIdThreadSafeString(CL);
  RIRegister_TIdThreadSafeStringList(CL);
  RIRegister_TIdThreadSafeList(CL);
end;

 
 
{ TPSImport_IdThreadSafe }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdThreadSafe.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdThreadSafe(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdThreadSafe.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdThreadSafe(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
