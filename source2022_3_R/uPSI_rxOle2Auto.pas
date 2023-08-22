unit uPSI_rxOle2Auto;
{
       olecontroller  and free    counittialize 4.7.1.80
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
  TPSImport_rxOle2Auto = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOleController(CL: TPSPascalCompiler);
procedure SIRegister_rxOle2Auto(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_rxOle2Auto_Routines(S: TPSExec);
procedure RIRegister_TOleController(CL: TPSRuntimeClassImporter);
procedure RIRegister_rxOle2Auto(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ActiveX
  ,ComObj
  ,rxOle2Auto
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_rxOle2Auto]);
end;


function ProgIDExists(const ProgID:WideString):Boolean;
var
   tmp : TGUID;
begin
   Result := Succeeded(CLSIDFromProgID(PWideChar(ProgID), tmp));
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOleController(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TOleController') do
  with CL.AddClassN(CL.FindClass('TObject'),'TOleController') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure CreateObject( const ClassName : string)');
    RegisterMethod('Procedure AssignIDispatch( V : Variant)');
    RegisterMethod('Procedure GetActiveObject( const ClassName : string)');
    RegisterMethod('Function GetPropertyByID( ID : TDispID) : PVariant');
    RegisterMethod('Procedure SetPropertyByID( ID : TDispID; const Prop : array of const)');
    RegisterMethod('Function GetProperty( const AName : string) : PVariant');
    RegisterMethod('Procedure SetProperty( const AName : string; const Prop : array of const)');
    RegisterMethod('Function CallFunctionByID( ID : TDispID; const Params : array of const) : PVariant');
    RegisterMethod('Function CallFunctionByIDsNamedParams( const IDs : TDispIDList; const Params : array of const; Cnt : Byte) : PVariant');
    RegisterMethod('Function CallFunctionNoParamsByID( ID : TDispID) : PVariant');
    RegisterMethod('Procedure CallProcedureByID( ID : TDispID; const Params : array of const)');
    RegisterMethod('Procedure CallProcedureByIDsNamedParams( const IDs : TDispIDList; const Params : array of const; Cnt : Byte)');
    RegisterMethod('Procedure CallProcedureNoParamsByID( ID : TDispID)');
    RegisterMethod('Function CallFunction( const AName : string; const Params : array of const) : PVariant');
    RegisterMethod('Function CallFunctionNamedParams( const AName : string; const Params : array of const; const ParamNames : array of string) : PVariant');
    RegisterMethod('Function CallFunctionNoParams( const AName : string) : PVariant');
    RegisterMethod('Procedure CallProcedure( const AName : string; const Params : array of const)');
    RegisterMethod('Procedure CallProcedureNamedParams( const AName : string; const Params : array of const; const ParamNames : array of string)');
    RegisterMethod('Procedure CallProcedureNoParams( const AName : string)');
    RegisterMethod('Procedure SetLocale( PrimaryLangID, SubLangID : Word)');
    RegisterProperty('Locale', 'TLCID', iptrw);
    RegisterProperty('OleObject', 'Variant', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_rxOle2Auto(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MaxDispArgs2','LongInt').SetInt( 64);
 CL.AddConstantN('COINIT_MULTITHREADED ','LongInt').SetInt(0);
 CL.AddConstantN('COINIT_APARTMENTTHREADED','LongInt').SetInt(2);
 CL.AddConstantN('COINIT_DISABLE_OLE1DDE','LongInt').SetInt(4);
 CL.AddConstantN('COINIT_SPEED_OVER_MEMORY','LongInt').SetInt(8);

 (* // flags passed as the coInit parameter to CoInitializeEx.
  {$EXTERNALSYM COINIT_MULTITHREADED}
  COINIT_MULTITHREADED      = 0;      // OLE calls objects on any thread.
  {$EXTERNALSYM COINIT_APARTMENTTHREADED}
  COINIT_APARTMENTTHREADED  = 2;      // Apartment model
  {$EXTERNALSYM COINIT_DISABLE_OLE1DDE}
  COINIT_DISABLE_OLE1DDE    = 4;      // Dont use DDE for Ole1 support.
  {$EXTERNALSYM COINIT_SPEED_OVER_MEMORY}
  COINIT_SPEED_OVER_MEMORY  = 8;      //     *)

 //CL.AddConstantN('MaxDispArgs','LongInt').SetInt( 32);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPropReadOnly');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPropWriteOnly');
  CL.AddTypeS('TLCID', 'DWORD');
  // TLCID = DWORD;
  SIRegister_TOleController(CL);
 CL.AddDelphiFunction('Procedure InitOLE2');
 CL.AddDelphiFunction('Procedure DoneOLE');
 CL.AddDelphiFunction('Function OleInitialized : Boolean');
 CL.AddDelphiFunction('Function MakeLangID( PrimaryLangID, SubLangID : Word) : Word');
 CL.AddDelphiFunction('Function MakeLCID( LangID : Word) : TLCID');
 CL.AddDelphiFunction('Function CreateLCID( PrimaryLangID, SubLangID : Word) : TLCID');
 CL.AddDelphiFunction('Function ExtractLangID( LCID : TLCID) : Word');
 CL.AddDelphiFunction('Function ExtractSubLangID( LCID : TLCID) : Word');
 CL.AddDelphiFunction('function CLSIDFromProgID(pszProgID: widestring; out clsid: TGUID): Longint'); //stdcall;
 CL.AddDelphiFunction('function ProgIDFromCLSID(const clsid: TGUID; out pszProgID: widestring): Longint'); //stdcall;
 CL.AddDelphiFunction('function StringFromCLSID(const clsid: TGUID; out psz: widestring): longint'); //stdcall;
//{$EXTERNALSYM CLSIDFromString}
 CL.AddDelphiFunction('function CLSIDFromString(psz: widestring; out clsid: TGUID): longint'); //stdcall;
 CL.AddDelphiFunction('function StringFromGUID2(const guid: TGUID; psz: widestring; cbMax: Integer): Integer'); //stdcall;
 CL.AddDelphiFunction('function ProgIDExists(const ProgID:WideString):Boolean');
  CL.AddDelphiFunction('Procedure CoUninitialize');
  CL.AddDelphiFunction('Procedure OleUninitialize');


 //procedure CoUninitialize; stdcall;

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOleControllerOleObject_R(Self: TOleController; var T: Variant);
begin T := Self.OleObject; end;

(*----------------------------------------------------------------------------*)
procedure TOleControllerLocale_W(Self: TOleController; const T: TLCID);
begin Self.Locale := T; end;

(*----------------------------------------------------------------------------*)
procedure TOleControllerLocale_R(Self: TOleController; var T: TLCID);
begin T := Self.Locale; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_rxOle2Auto_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InitOLE, 'InitOLE2', cdRegister);
 S.RegisterDelphiFunction(@DoneOLE, 'DoneOLE', cdRegister);
 S.RegisterDelphiFunction(@OleInitialized, 'OleInitialized', cdRegister);
 S.RegisterDelphiFunction(@MakeLangID, 'MakeLangID', cdRegister);
 S.RegisterDelphiFunction(@MakeLCID, 'MakeLCID', cdRegister);
 S.RegisterDelphiFunction(@CreateLCID, 'CreateLCID', cdRegister);
 S.RegisterDelphiFunction(@ExtractLangID, 'ExtractLangID', cdRegister);
 S.RegisterDelphiFunction(@ExtractSubLangID, 'ExtractSubLangID', cdRegister);
 S.RegisterDelphiFunction(@CLSIDFromProgID, 'CLSIDFromProgID', CdStdCall);
 S.RegisterDelphiFunction(@ProgIDFromCLSID, 'ProgIDFromCLSID', CdStdCall);
 S.RegisterDelphiFunction(@StringFromCLSID, 'StringFromCLSID', CdStdCall);
 S.RegisterDelphiFunction(@CLSIDFromString, 'CLSIDFromString', CdStdCall);
 S.RegisterDelphiFunction(@StringFromGUID2, 'StringFromGUID2', CdStdCall);
 S.RegisterDelphiFunction(@ProgIDExists, 'ProgIDExists', cdRegister);
 S.RegisterDelphiFunction(@CoUninitialize, 'CoUninitialize', CdStdCall);
 S.RegisterDelphiFunction(@OleUninitialize, 'OleUninitialize', CdStdCall);

 // CL.AddDelphiFunction('Procedure CoUninitialize');

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOleController(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOleController) do begin
    RegisterConstructor(@TOleController.Create, 'Create');
       RegisterMethod(@TOleController.Destroy, 'Free');
    RegisterVirtualMethod(@TOleController.CreateObject, 'CreateObject');
    RegisterVirtualMethod(@TOleController.AssignIDispatch, 'AssignIDispatch');
    RegisterVirtualMethod(@TOleController.GetActiveObject, 'GetActiveObject');
    RegisterMethod(@TOleController.GetPropertyByID, 'GetPropertyByID');
    RegisterMethod(@TOleController.SetPropertyByID, 'SetPropertyByID');
    RegisterMethod(@TOleController.GetProperty, 'GetProperty');
    RegisterMethod(@TOleController.SetProperty, 'SetProperty');
    RegisterMethod(@TOleController.CallFunctionByID, 'CallFunctionByID');
    RegisterMethod(@TOleController.CallFunctionByIDsNamedParams, 'CallFunctionByIDsNamedParams');
    RegisterMethod(@TOleController.CallFunctionNoParamsByID, 'CallFunctionNoParamsByID');
    RegisterMethod(@TOleController.CallProcedureByID, 'CallProcedureByID');
    RegisterMethod(@TOleController.CallProcedureByIDsNamedParams, 'CallProcedureByIDsNamedParams');
    RegisterMethod(@TOleController.CallProcedureNoParamsByID, 'CallProcedureNoParamsByID');
    RegisterMethod(@TOleController.CallFunction, 'CallFunction');
    RegisterMethod(@TOleController.CallFunctionNamedParams, 'CallFunctionNamedParams');
    RegisterMethod(@TOleController.CallFunctionNoParams, 'CallFunctionNoParams');
    RegisterMethod(@TOleController.CallProcedure, 'CallProcedure');
    RegisterMethod(@TOleController.CallProcedureNamedParams, 'CallProcedureNamedParams');
    RegisterMethod(@TOleController.CallProcedureNoParams, 'CallProcedureNoParams');
    RegisterMethod(@TOleController.SetLocale, 'SetLocale');
    RegisterPropertyHelper(@TOleControllerLocale_R,@TOleControllerLocale_W,'Locale');
    RegisterPropertyHelper(@TOleControllerOleObject_R,nil,'OleObject');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_rxOle2Auto(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EPropReadOnly) do
  with CL.Add(EPropWriteOnly) do
  RIRegister_TOleController(CL);
end;

 
 
{ TPSImport_rxOle2Auto }
(*----------------------------------------------------------------------------*)
procedure TPSImport_rxOle2Auto.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_rxOle2Auto(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_rxOle2Auto.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_rxOle2Auto(ri);
  RIRegister_rxOle2Auto_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
