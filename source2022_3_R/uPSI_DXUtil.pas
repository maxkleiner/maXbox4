unit uPSI_DXUtil;
{
just one of the whole DirectX 9

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
  TPSImport_DXUtil = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_CArrayList(CL: TPSPascalCompiler);
procedure SIRegister_DXUtil(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_CArrayList(CL: TPSRuntimeClassImporter);
procedure RIRegister_DXUtil_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  //,D3DX9
  ,DXUtil
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DXUtil]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_CArrayList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CArrayList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CArrayList') do begin
    RegisterMethod('Constructor Create( _Type : TArrayListType; BytesPerEntry : Integer)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Add( pEntry : Integer) : HRESULT');
    RegisterMethod('Procedure Remove( Entry : Integer)');
    RegisterMethod('Function GetPtr( Entry : Integer) : Integer');
    RegisterMethod('Function Contains( pEntryData : Integer) : Boolean');
    RegisterMethod('Procedure Clear');
    RegisterProperty('Count', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DXUtil(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure SAFE_RELEASE( var i: integer)');
 CL.AddDelphiFunction('Procedure SAFE_DELETE( var Obj: TObject)');
 CL.AddDelphiFunction('Function DXUtil_GetDXSDKMediaPathCb( szDest : PChar; cbDest : Integer) : HRESULT');
 CL.AddDelphiFunction('Function DXUtil_FindMediaFileCch( strDestPath : PChar; cchDest : Integer; strFilename : PChar) : HRESULT');
 CL.AddDelphiFunction('Function DXUtil_FindMediaFileCb( szDestPath : PChar; cbDest : Integer; strFilename : PChar) : HRESULT');
 CL.AddDelphiFunction('Function DXUtil_WriteStringRegKey( hKey_ : HKEY; strRegName : PChar; strValue : PChar) : HRESULT');
  CL.AddTypeS('TIMER_COMMAND', 'DWORD');
 CL.AddConstantN('TIMER_RESET','LongInt').SetInt( 0);
 CL.AddConstantN('TIMER_START','LongInt').SetInt( 1);
 CL.AddConstantN('TIMER_STOP','LongInt').SetInt( 2);
 CL.AddConstantN('TIMER_ADVANCE','LongInt').SetInt( 3);
 CL.AddConstantN('TIMER_GETABSOLUTETIME','LongInt').SetInt( 4);
 CL.AddConstantN('TIMER_GETAPPTIME','LongInt').SetInt( 5);
 CL.AddConstantN('TIMER_GETELAPSEDTIME','LongInt').SetInt( 6);
 CL.AddDelphiFunction('Function DXUtil_Timer( command : TIMER_COMMAND) : Single');
 CL.AddDelphiFunction('Function DXUtil_ConvertGenericStringToAnsiCch( strDestination : PChar; const tstrSource : PChar; cchDestChar : Integer) : HRESULT');
 CL.AddDelphiFunction('Function DXUtil_ConvertAnsiStringToGenericCch( tstrDestination : PChar; const strSource : PChar; cchDestChar : Integer) : HRESULT');
 CL.AddDelphiFunction('Function DXUtil_ConvertGenericStringToAnsiCb( strDestination : PChar; const tstrSource : PChar; cbDestChar : Integer) : HRESULT');
 CL.AddDelphiFunction('Function DXUtil_ConvertAnsiStringToGenericCb( tstrDestination : PChar; const strSource : PChar; cbDestChar : Integer) : HRESULT');
  CL.AddTypeS('TArrayListType', '( AL_VALUE, AL_REFERENCE )');
  SIRegister_CArrayList(CL);
 CL.AddDelphiFunction('Function GETTIMESTAMP : DWORD');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure CArrayListCount_R(Self: CArrayList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CArrayList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CArrayList) do begin
    RegisterConstructor(@CArrayList.Create, 'Create');
    RegisterMethod(@CArrayList.Destroy, 'Free');
    RegisterMethod(@CArrayList.Add, 'Add');
    RegisterMethod(@CArrayList.Remove, 'Remove');
    RegisterMethod(@CArrayList.GetPtr, 'GetPtr');
    RegisterMethod(@CArrayList.Contains, 'Contains');
    RegisterMethod(@CArrayList.Clear, 'Clear');
    RegisterPropertyHelper(@CArrayListCount_R,nil,'Count');
  end;
  // RIRegister_CArrayList(CL);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DXUtil_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SAFE_RELEASE, 'SAFE_RELEASE', cdRegister);
 S.RegisterDelphiFunction(@SAFE_DELETE, 'SAFE_DELETE', cdRegister);
 S.RegisterDelphiFunction(@DXUtil_GetDXSDKMediaPathCb, 'DXUtil_GetDXSDKMediaPathCb', cdRegister);
 S.RegisterDelphiFunction(@DXUtil_FindMediaFileCch, 'DXUtil_FindMediaFileCch', cdRegister);
 S.RegisterDelphiFunction(@DXUtil_FindMediaFileCb, 'DXUtil_FindMediaFileCb', cdRegister);
 S.RegisterDelphiFunction(@DXUtil_WriteStringRegKey, 'DXUtil_WriteStringRegKey', cdRegister);
 S.RegisterDelphiFunction(@DXUtil_Timer, 'DXUtil_Timer', CdStdCall);
 S.RegisterDelphiFunction(@DXUtil_ConvertGenericStringToAnsiCch, 'DXUtil_ConvertGenericStringToAnsiCch', cdRegister);
 S.RegisterDelphiFunction(@DXUtil_ConvertAnsiStringToGenericCch, 'DXUtil_ConvertAnsiStringToGenericCch', cdRegister);
 S.RegisterDelphiFunction(@DXUtil_ConvertGenericStringToAnsiCb, 'DXUtil_ConvertGenericStringToAnsiCb', cdRegister);
 S.RegisterDelphiFunction(@DXUtil_ConvertAnsiStringToGenericCb, 'DXUtil_ConvertAnsiStringToGenericCb', cdRegister);
 // RIRegister_CArrayList(CL);
 S.RegisterDelphiFunction(@GETTIMESTAMP, 'GETTIMESTAMP', cdRegister);
end;

 
 
{ TPSImport_DXUtil }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DXUtil.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DXUtil(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DXUtil.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DXUtil_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
