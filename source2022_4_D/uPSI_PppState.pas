unit uPSI_PppState;
{
  ppp
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
  TPSImport_PppState = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSimplePppState(CL: TPSPascalCompiler);
procedure SIRegister_TPppState(CL: TPSPascalCompiler);
procedure SIRegister_PppState(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSimplePppState(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPppState(CL: TPSRuntimeClassImporter);
procedure RIRegister_PppState(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   JclStrHashMap
  ,PppState
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PppState]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSimplePppState(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPppState', 'TSimplePppState') do
  with CL.AddClassN(CL.FindClass('TPppState'),'TSimplePppState') do begin
    RegisterMethod('Constructor Create( AHashSize : Cardinal)');
        RegisterMethod('Procedure Free');
      RegisterProperty('Options', 'TPppOptions', iptrw);
    RegisterProperty('SearchPath', 'TStringList', iptr);
      RegisterMethod('Procedure PushState');
    RegisterMethod('Procedure PopState');
      RegisterMethod('Function IsDefined( const ASymbol : string) : Boolean');
    RegisterMethod('Procedure Define( const ASymbol : string)');
    RegisterMethod('Procedure Undef( const ASymbol : string)');
    RegisterMethod('Function IsPassThrough( const ASymbol : string) : Boolean');
    RegisterMethod('Procedure PassThrough( const ASymbol : string)');
    RegisterMethod('Function IsBypassInclude( const ASymbol : string) : Boolean');
    RegisterMethod('Procedure BypassInclude( const ASymbol : string)');
    RegisterMethod('Function IsSkipSomeDirectives( const ASymbol : string) : Boolean');
    RegisterMethod('Procedure SkipSomeDirectives( const ASymbol : string)');
    RegisterMethod('Function FindFile( const AName : string) : TStream');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPppState(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPppState') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPppState') do begin
    RegisterMethod('Procedure PushState');
    RegisterMethod('Procedure PopState');
    RegisterMethod('Function IsDefined( const ASymbol : string) : Boolean');
    RegisterMethod('Procedure Define( const ASymbol : string)');
    RegisterMethod('Procedure Undef( const ASymbol : string)');
    RegisterMethod('Function IsPassThrough( const ASymbol : string) : Boolean');
    RegisterMethod('Procedure PassThrough( const ASymbol : string)');
    RegisterMethod('Function IsBypassInclude( const ASymbol : string) : Boolean');
    RegisterMethod('Procedure BypassInclude( const ASymbol : string)');
    RegisterMethod('Function IsSkipSomeDirectives( const ASymbol : string) : Boolean');
    RegisterMethod('Procedure SkipSomeDirectives( const ASymbol : string)');
    RegisterMethod('Function FindFile( const AName : string) : TStream');
    RegisterProperty('Options', 'TPppOptions', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PppState(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPppState');
  CL.AddTypeS('TPppOption', '( poProcessIncludes, poProcessDefines, poStripComm'
   +'ents, poInvDefines, poInvPassthrough, poInvIncludes, poCountUsage, poRename, poTimestamps )');
  CL.AddTypeS('TPppOptions', 'set of TPppOption');
  SIRegister_TPppState(CL);
  SIRegister_TSimplePppState(CL);
 CL.AddConstantN('PathDelim','String').SetString( '\');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSimplePppStateSearchPath_R(Self: TSimplePppState; var T: TStringList);
begin T := Self.SearchPath; end;

(*----------------------------------------------------------------------------*)
procedure TSimplePppStateOptions_W(Self: TSimplePppState; const T: TPppOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TSimplePppStateOptions_R(Self: TSimplePppState; var T: TPppOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TPppStateOptions_R(Self: TPppState; var T: TPppOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSimplePppState(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSimplePppState) do begin
    RegisterConstructor(@TSimplePppState.Create, 'Create');
     RegisterMethod(@TSimplePppState.Destroy, 'Free');
    RegisterPropertyHelper(@TSimplePppStateOptions_R,@TSimplePppStateOptions_W,'Options');
    RegisterPropertyHelper(@TSimplePppStateSearchPath_R,nil,'SearchPath');
   RegisterMethod(@TSimplePppState.PushState, 'PushState');
    RegisterMethod(@TSimplePppState.PopState, 'PopState');
    RegisterMethod(@TSimplePppState.IsDefined, 'IsDefined');
    RegisterMethod(@TSimplePppState.Define, 'Define');
    RegisterMethod(@TSimplePppState.Undef, 'Undef');
    RegisterMethod(@TSimplePppState.IsPassThrough, 'IsPassThrough');
    RegisterMethod(@TSimplePppState.PassThrough, 'PassThrough');
    RegisterMethod(@TSimplePppState.IsBypassInclude, 'IsBypassInclude');
    RegisterMethod(@TSimplePppState.BypassInclude, 'BypassInclude');
    RegisterMethod(@TSimplePppState.IsSkipSomeDirectives, 'IsSkipSomeDirectives');
    RegisterMethod(@TSimplePppState.SkipSomeDirectives, 'SkipSomeDirectives');
    RegisterMethod(@TSimplePppState.FindFile, 'FindFile');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPppState(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPppState) do
  begin
    {RegisterVirtualAbstractMethod(@TPppState, @!.PushState, 'PushState');
    RegisterVirtualAbstractMethod(@TPppState, @!.PopState, 'PopState');
    RegisterVirtualAbstractMethod(@TPppState, @!.IsDefined, 'IsDefined');
    RegisterVirtualAbstractMethod(@TPppState, @!.Define, 'Define');
    RegisterVirtualAbstractMethod(@TPppState, @!.Undef, 'Undef');
    RegisterVirtualAbstractMethod(@TPppState, @!.IsPassThrough, 'IsPassThrough');
    RegisterVirtualAbstractMethod(@TPppState, @!.PassThrough, 'PassThrough');
    RegisterVirtualAbstractMethod(@TPppState, @!.IsBypassInclude, 'IsBypassInclude');
    RegisterVirtualAbstractMethod(@TPppState, @!.BypassInclude, 'BypassInclude');
    RegisterVirtualAbstractMethod(@TPppState, @!.IsSkipSomeDirectives, 'IsSkipSomeDirectives');
    RegisterVirtualAbstractMethod(@TPppState, @!.SkipSomeDirectives, 'SkipSomeDirectives');
    RegisterVirtualAbstractMethod(@TPppState, @!.FindFile, 'FindFile');}
    RegisterPropertyHelper(@TPppStateOptions_R,nil,'Options');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PppState(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EPppState) do
  RIRegister_TPppState(CL);
  RIRegister_TSimplePppState(CL);
end;

 
 
{ TPSImport_PppState }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PppState.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PppState(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PppState.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_PppState(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
