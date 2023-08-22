unit uPSI_ovccmd;
{
  command processor
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
  TPSImport_ovccmd = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOvcCommandProcessor(CL: TPSPascalCompiler);
procedure SIRegister_TOvcCommandTable(CL: TPSPascalCompiler);
procedure SIRegister_ovccmd(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TOvcCommandProcessor(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcCommandTable(CL: TPSRuntimeClassImporter);
procedure RIRegister_ovccmd(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Forms
  ,Menus
  ,Messages
  ,OvcConst
  ,OvcData
  ,OvcExcpt
  ,OvcMisc
  ,ovccmd
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovccmd]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcCommandProcessor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TOvcCommandProcessor') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TOvcCommandProcessor') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Add( CT : TOvcCommandTable)');
    RegisterMethod('Procedure AddCommand( const TableName : string; Key1, ShiftState1, Key2, ShiftState2 : Byte; Command : Word)');
    RegisterMethod('Procedure AddCommandRec( const TableName : string; const CmdRec : TOvcCmdRec)');
    RegisterMethod('Procedure ChangeTableName( const OldName, NewName : string)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function CreateCommandTable( const TableName : string; Active : Boolean) : Integer');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure DeleteCommand( const TableName : string; Key1, ShiftState1, Key2, ShiftState2 : Byte)');
    RegisterMethod('Procedure DeleteCommandTable( const TableName : string)');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Function GetCommandCount( const TableName : string) : Integer');
    RegisterMethod('Function GetCommandTable( const TableName : string) : TOvcCommandTable');
    RegisterMethod('Procedure GetState( var State : TOvcProcessorState; var Key, Shift : Byte)');
    RegisterMethod('Function GetCommandTableIndex( const TableName : string) : Integer');
    RegisterMethod('Function LoadCommandTable( const FileName : string) : Integer');
    RegisterMethod('Procedure ResetCommandProcessor');
    RegisterMethod('Procedure SaveCommandTable( const TableName, FileName : string)');
    RegisterMethod('Procedure SetScanPriority( const Names : array of string)');
    RegisterMethod('Procedure SetState( State : TOvcProcessorState; Key, Shift : Byte)');
    RegisterMethod('Function Translate( var Msg : TMessage) : Word');
    RegisterMethod('Function TranslateUsing( const Tables : array of string; var Msg : TMessage) : Word');
    RegisterMethod('Function TranslateKey( Key : Word; ShiftState : TShiftState) : Word');
    RegisterMethod('Function TranslateKeyUsing( const Tables : array of string; Key : Word; ShiftState : TShiftState) : Word');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Table', 'TOvcCommandTable Integer', iptrw);
    SetDefaultPropery('Table');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcCommandTable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TOvcCommandTable') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TOvcCommandTable') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
     RegisterMethod('Function AddRec( const CmdRec : TOvcCmdRec) : Integer');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Function IndexOf( const CmdRec : TOvcCmdRec) : Integer');
    RegisterMethod('Procedure InsertRec( Index : Integer; const CmdRec : TOvcCmdRec)');
    RegisterMethod('Procedure LoadFromFile( const FileName : string)');
    RegisterMethod('Procedure Move( CurIndex, NewIndex : Integer)');
    RegisterMethod('Procedure SaveToFile( const FileName : string)');
    RegisterProperty('Commands', 'TOvcCmdRec Integer', iptrw);
    SetDefaultPropery('Commands');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('IsActive', 'Boolean', iptrw);
    RegisterProperty('TableName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ovccmd(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('DefWsMaxCommands','LongInt').SetInt( 40);
 CL.AddConstantN('DefGridMaxCommands','LongInt').SetInt( 38);
  CL.AddTypeS('TOvcProcessorState', '( stNone, stPartial, stLiteral )');
  CL.AddTypeS('TOvcCmdRec', 'record Keys: Longint; end');

  (*  TOvcCmdRec = packed record
    case Byte of
      0 : (Key1  : Byte;     {first keys' virtual key code}
           SS1   : Byte;     {shift state of first key}
           Key2  : Byte;     {second keys' virtual key code, if any}
           SS2   : Byte;     {shift state of second key}
           Cmd   : Word);    {command to return for this entry}
      1 : (Keys  : LongInt); {used for sorting, searching, and storing}
  end; *)

  CL.AddTypeS('TUserCommandEvent', 'Procedure ( Sender : TObject; Command : Word)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TOvcCommandProcessor');
  //SIRegister_TOvcCommandProcessor(CL);
  SIRegister_TOvcCommandTable(CL);
  SIRegister_TOvcCommandProcessor(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOvcCommandProcessorTable_W(Self: TOvcCommandProcessor; const T: TOvcCommandTable; const t1: Integer);
begin Self.Table[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCommandProcessorTable_R(Self: TOvcCommandProcessor; var T: TOvcCommandTable; const t1: Integer);
begin T := Self.Table[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCommandProcessorCount_R(Self: TOvcCommandProcessor; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCommandTableTableName_W(Self: TOvcCommandTable; const T: string);
begin Self.TableName := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCommandTableTableName_R(Self: TOvcCommandTable; var T: string);
begin T := Self.TableName; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCommandTableIsActive_W(Self: TOvcCommandTable; const T: Boolean);
begin Self.IsActive := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCommandTableIsActive_R(Self: TOvcCommandTable; var T: Boolean);
begin T := Self.IsActive; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCommandTableCount_R(Self: TOvcCommandTable; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCommandTableCommands_W(Self: TOvcCommandTable; const T: TOvcCmdRec; const t1: Integer);
begin Self.Commands[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcCommandTableCommands_R(Self: TOvcCommandTable; var T: TOvcCmdRec; const t1: Integer);
begin T := Self.Commands[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcCommandProcessor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcCommandProcessor) do begin
    RegisterConstructor(@TOvcCommandProcessor.Create, 'Create');
     RegisterMethod(@TOvcCommandProcessor.Destroy, 'Free');
     RegisterMethod(@TOvcCommandProcessor.Add, 'Add');
    RegisterMethod(@TOvcCommandProcessor.AddCommand, 'AddCommand');
    RegisterMethod(@TOvcCommandProcessor.AddCommandRec, 'AddCommandRec');
    RegisterMethod(@TOvcCommandProcessor.ChangeTableName, 'ChangeTableName');
    RegisterMethod(@TOvcCommandProcessor.Clear, 'Clear');
    RegisterMethod(@TOvcCommandProcessor.CreateCommandTable, 'CreateCommandTable');
    RegisterMethod(@TOvcCommandProcessor.Delete, 'Delete');
    RegisterMethod(@TOvcCommandProcessor.DeleteCommand, 'DeleteCommand');
    RegisterMethod(@TOvcCommandProcessor.DeleteCommandTable, 'DeleteCommandTable');
    RegisterMethod(@TOvcCommandProcessor.Exchange, 'Exchange');
    RegisterMethod(@TOvcCommandProcessor.GetCommandCount, 'GetCommandCount');
    RegisterMethod(@TOvcCommandProcessor.GetCommandTable, 'GetCommandTable');
    RegisterMethod(@TOvcCommandProcessor.GetState, 'GetState');
    RegisterMethod(@TOvcCommandProcessor.GetCommandTableIndex, 'GetCommandTableIndex');
    RegisterVirtualMethod(@TOvcCommandProcessor.LoadCommandTable, 'LoadCommandTable');
    RegisterMethod(@TOvcCommandProcessor.ResetCommandProcessor, 'ResetCommandProcessor');
    RegisterVirtualMethod(@TOvcCommandProcessor.SaveCommandTable, 'SaveCommandTable');
    RegisterMethod(@TOvcCommandProcessor.SetScanPriority, 'SetScanPriority');
    RegisterMethod(@TOvcCommandProcessor.SetState, 'SetState');
    RegisterMethod(@TOvcCommandProcessor.Translate, 'Translate');
    RegisterMethod(@TOvcCommandProcessor.TranslateUsing, 'TranslateUsing');
    RegisterMethod(@TOvcCommandProcessor.TranslateKey, 'TranslateKey');
    RegisterMethod(@TOvcCommandProcessor.TranslateKeyUsing, 'TranslateKeyUsing');
    RegisterPropertyHelper(@TOvcCommandProcessorCount_R,nil,'Count');
    RegisterPropertyHelper(@TOvcCommandProcessorTable_R,@TOvcCommandProcessorTable_W,'Table');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcCommandTable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcCommandTable) do begin
    RegisterConstructor(@TOvcCommandTable.Create, 'Create');
    RegisterMethod(@TOvcCommandTable.Destroy, 'Free');
    RegisterMethod(@TOvcCommandTable.AddRec, 'AddRec');
    RegisterMethod(@TOvcCommandTable.Clear, 'Clear');
    RegisterMethod(@TOvcCommandTable.Delete, 'Delete');
    RegisterMethod(@TOvcCommandTable.Exchange, 'Exchange');
    RegisterMethod(@TOvcCommandTable.IndexOf, 'IndexOf');
    RegisterMethod(@TOvcCommandTable.InsertRec, 'InsertRec');
    RegisterMethod(@TOvcCommandTable.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TOvcCommandTable.Move, 'Move');
    RegisterMethod(@TOvcCommandTable.SaveToFile, 'SaveToFile');
    RegisterPropertyHelper(@TOvcCommandTableCommands_R,@TOvcCommandTableCommands_W,'Commands');
    RegisterPropertyHelper(@TOvcCommandTableCount_R,nil,'Count');
    RegisterPropertyHelper(@TOvcCommandTableIsActive_R,@TOvcCommandTableIsActive_W,'IsActive');
    RegisterPropertyHelper(@TOvcCommandTableTableName_R,@TOvcCommandTableTableName_W,'TableName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovccmd(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcCommandProcessor) do
  RIRegister_TOvcCommandTable(CL);
  RIRegister_TOvcCommandProcessor(CL);
end;

 
 
{ TPSImport_ovccmd }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovccmd.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovccmd(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovccmd.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ovccmd(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
