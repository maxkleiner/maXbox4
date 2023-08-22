unit uPSI_FileMask;
{
the mask of pinvoke the mask task

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
  TPSImport_FileMask = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMultipleMasksResolver(CL: TPSPascalCompiler);
procedure SIRegister_TMaskResolver(CL: TPSPascalCompiler);
procedure SIRegister_TFMStack(CL: TPSPascalCompiler);
procedure SIRegister_FileMask(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMultipleMasksResolver(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMaskResolver(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFMStack(CL: TPSRuntimeClassImporter);
procedure RIRegister_FileMask(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Math
  ,StringUtils
  ,FileMask
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_FileMask]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMultipleMasksResolver(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMaskResolver', 'TMultipleMasksResolver') do
  with CL.AddClassN(CL.FindClass('TMaskResolver'),'TMultipleMasksResolver') do
  begin
    RegisterProperty('Masks', 'WideString', iptrw);
    RegisterProperty('MaskArray', 'TWideStringArray', iptrw);
    RegisterMethod('Function MaskCount : Integer');
    RegisterProperty('CurrentMask', 'Integer', iptrw);
    RegisterMethod('Procedure SetFromString( const Value : WideString; const Delim : WideString)');
    RegisterMethod('Function AsString( const Delim : WideString) : WideString');
    RegisterMethod('Procedure ToStart');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMaskResolver(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TMaskResolver') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TMaskResolver') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure ToStart');
    RegisterProperty('MaxRecursionDepth', 'Word', iptrw);
    RegisterProperty('Recursive', 'Boolean', iptrw);
    RegisterProperty('CaseSensitive', 'Boolean', iptrw);
    RegisterProperty('Mask', 'WideString', iptrw);
    RegisterMethod('Function Next : WideString');
    RegisterMethod('Function NextTo( out NextFile : WideString) : Boolean');
    RegisterProperty('Current', 'WideString', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFMStack(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TFMStack') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TFMStack') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Push( const BasePath : WideString; Handle : DWord; const Rec : TWin32FindDataW)');
    RegisterMethod('Procedure Pop');
    RegisterProperty('Height', 'Integer', iptr);
    RegisterMethod('Function TopHandle : DWord');
    RegisterProperty('TopRec', 'TWin32FindDataW', iptrw);
    RegisterMethod('Function TopBasePath : WideString');
    RegisterMethod('Function IsEmpty : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_FileMask(CL: TPSPascalCompiler);
begin
  SIRegister_TFMStack(CL);
  SIRegister_TMaskResolver(CL);
  SIRegister_TMultipleMasksResolver(CL);
  CL.AddTypeS('TFileMask', 'TMaskResolver');
  CL.AddTypeS('TFileMasks', 'TMultipleMasksResolver');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMultipleMasksResolverCurrentMask_W(Self: TMultipleMasksResolver; const T: Integer);
begin Self.CurrentMask := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultipleMasksResolverCurrentMask_R(Self: TMultipleMasksResolver; var T: Integer);
begin T := Self.CurrentMask; end;

(*----------------------------------------------------------------------------*)
procedure TMultipleMasksResolverMaskArray_W(Self: TMultipleMasksResolver; const T: TWideStringArray);
begin Self.MaskArray := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultipleMasksResolverMaskArray_R(Self: TMultipleMasksResolver; var T: TWideStringArray);
begin T := Self.MaskArray; end;

(*----------------------------------------------------------------------------*)
procedure TMultipleMasksResolverMasks_W(Self: TMultipleMasksResolver; const T: WideString);
begin Self.Masks := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultipleMasksResolverMasks_R(Self: TMultipleMasksResolver; var T: WideString);
begin T := Self.Masks; end;

(*----------------------------------------------------------------------------*)
procedure TMaskResolverCurrent_R(Self: TMaskResolver; var T: WideString);
begin T := Self.Current; end;

(*----------------------------------------------------------------------------*)
procedure TMaskResolverMask_W(Self: TMaskResolver; const T: WideString);
begin Self.Mask := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaskResolverMask_R(Self: TMaskResolver; var T: WideString);
begin T := Self.Mask; end;

(*----------------------------------------------------------------------------*)
procedure TMaskResolverCaseSensitive_W(Self: TMaskResolver; const T: Boolean);
begin Self.CaseSensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaskResolverCaseSensitive_R(Self: TMaskResolver; var T: Boolean);
begin T := Self.CaseSensitive; end;

(*----------------------------------------------------------------------------*)
procedure TMaskResolverRecursive_W(Self: TMaskResolver; const T: Boolean);
begin Self.Recursive := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaskResolverRecursive_R(Self: TMaskResolver; var T: Boolean);
begin T := Self.Recursive; end;

(*----------------------------------------------------------------------------*)
procedure TMaskResolverMaxRecursionDepth_W(Self: TMaskResolver; const T: Word);
begin Self.MaxRecursionDepth := T; end;

(*----------------------------------------------------------------------------*)
procedure TMaskResolverMaxRecursionDepth_R(Self: TMaskResolver; var T: Word);
begin T := Self.MaxRecursionDepth; end;

(*----------------------------------------------------------------------------*)
procedure TFMStackTopRec_W(Self: TFMStack; const T: TWin32FindDataW);
begin Self.TopRec := T; end;

(*----------------------------------------------------------------------------*)
procedure TFMStackTopRec_R(Self: TFMStack; var T: TWin32FindDataW);
begin T := Self.TopRec; end;

(*----------------------------------------------------------------------------*)
procedure TFMStackHeight_R(Self: TFMStack; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMultipleMasksResolver(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMultipleMasksResolver) do
  begin
    RegisterPropertyHelper(@TMultipleMasksResolverMasks_R,@TMultipleMasksResolverMasks_W,'Masks');
    RegisterPropertyHelper(@TMultipleMasksResolverMaskArray_R,@TMultipleMasksResolverMaskArray_W,'MaskArray');
    RegisterMethod(@TMultipleMasksResolver.MaskCount, 'MaskCount');
    RegisterPropertyHelper(@TMultipleMasksResolverCurrentMask_R,@TMultipleMasksResolverCurrentMask_W,'CurrentMask');
    RegisterMethod(@TMultipleMasksResolver.SetFromString, 'SetFromString');
    RegisterMethod(@TMultipleMasksResolver.AsString, 'AsString');
    RegisterMethod(@TMultipleMasksResolver.ToStart, 'ToStart');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMaskResolver(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMaskResolver) do begin
    RegisterConstructor(@TMaskResolver.Create, 'Create');
     RegisterMethod(@TMaskResolver.Destroy, 'Free');

    RegisterMethod(@TMaskResolver.ToStart, 'ToStart');
    RegisterPropertyHelper(@TMaskResolverMaxRecursionDepth_R,@TMaskResolverMaxRecursionDepth_W,'MaxRecursionDepth');
    RegisterPropertyHelper(@TMaskResolverRecursive_R,@TMaskResolverRecursive_W,'Recursive');
    RegisterPropertyHelper(@TMaskResolverCaseSensitive_R,@TMaskResolverCaseSensitive_W,'CaseSensitive');
    RegisterPropertyHelper(@TMaskResolverMask_R,@TMaskResolverMask_W,'Mask');
    RegisterVirtualMethod(@TMaskResolver.Next, 'Next');
    RegisterMethod(@TMaskResolver.NextTo, 'NextTo');
    RegisterPropertyHelper(@TMaskResolverCurrent_R,nil,'Current');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFMStack(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFMStack) do begin
    RegisterConstructor(@TFMStack.Create, 'Create');
     RegisterMethod(@TFMStack.Destroy, 'Free');
   RegisterMethod(@TFMStack.Clear, 'Clear');
    RegisterMethod(@TFMStack.Push, 'Push');
    RegisterMethod(@TFMStack.Pop, 'Pop');
    RegisterPropertyHelper(@TFMStackHeight_R,nil,'Height');
    RegisterMethod(@TFMStack.TopHandle, 'TopHandle');
    RegisterPropertyHelper(@TFMStackTopRec_R,@TFMStackTopRec_W,'TopRec');
    RegisterMethod(@TFMStack.TopBasePath, 'TopBasePath');
    RegisterMethod(@TFMStack.IsEmpty, 'IsEmpty');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_FileMask(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TFMStack(CL);
  RIRegister_TMaskResolver(CL);
  RIRegister_TMultipleMasksResolver(CL);
end;

 
 
{ TPSImport_FileMask }
(*----------------------------------------------------------------------------*)
procedure TPSImport_FileMask.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_FileMask(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_FileMask.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_FileMask(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
