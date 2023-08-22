unit uPSI_JclCOM;
{
  com and dcom
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
  TPSImport_JclCOM = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JclCOM(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclCOM_Routines(S: TPSExec);
procedure RIRegister_JclCOM(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ActiveX
  ,JclBase
  ,JclCOM
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclCOM]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JclCOM(CL: TPSPascalCompiler);
begin
// CL.AddConstantN('CLSID_StdComponentCategoriesMgr','TGUID').SetString( '{0002E005-0000-0000-C000-000000000046}');
// CL.AddConstantN('CATID_SafeForInitializing','TGUID').SetString( '{7DD95802-9882-11CF-9FA9-00AA006C42C4}');
// CL.AddConstantN('CATID_SafeForScripting','TGUID').SetString( '{7DD95801-9882-11CF-9FA9-00AA006C42C4}');
 CL.AddConstantN('icMAX_CATEGORY_DESC_LEN','LongInt').SetInt( 128);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidParam');
   CL.AddTypeS('TIID', 'TGUID');
  //TIID = TGUID;
 CL.AddDelphiFunction('Function IsDCOMInstalled : Boolean');
 CL.AddDelphiFunction('Function IsDCOMEnabled : Boolean');
 CL.AddDelphiFunction('Function GetDCOMVersion : string');
 CL.AddDelphiFunction('Function GetMDACVersion : string');
 CL.AddDelphiFunction('Function MarshalInterThreadInterfaceInVarArray( const iid : TIID; unk : IUnknown; var VarArray : OleVariant) : HResult');
 CL.AddDelphiFunction('Function MarshalInterProcessInterfaceInStream( const iid : TIID; unk : IUnknown; var stm : IStream) : HResult');
 CL.AddDelphiFunction('Function MarshalInterProcessInterfaceInVarArray( const iid : TIID; unk : IUnknown; var VarArray : OleVariant) : HResult');
 CL.AddDelphiFunction('Function MarshalInterMachineInterfaceInStream( const iid : TIID; unk : IUnknown; var stm : IStream) : HResult');
 CL.AddDelphiFunction('Function MarshalInterMachineInterfaceInVarArray( const iid : TIID; unk : IUnknown; var VarArray : OleVariant) : HResult');
 CL.AddDelphiFunction('Function CreateComponentCategory( const CatID : TGUID; const sDescription : string) : HResult');
 CL.AddDelphiFunction('Function RegisterCLSIDInCategory( const ClassID : TGUID; const CatID : TGUID) : HResult');
 CL.AddDelphiFunction('Function UnRegisterCLSIDInCategory( const ClassID : TGUID; const CatID : TGUID) : HResult');
 CL.AddDelphiFunction('Function ResetIStreamToStart( Stream : IStream) : Boolean');
 CL.AddDelphiFunction('Function SizeOfIStreamContents( Stream : IStream) : Largeint');
 CL.AddDelphiFunction('Function StreamToVariantArray( Stream : TStream) : OleVariant;');
 CL.AddDelphiFunction('Function StreamToVariantArray1( Stream : IStream) : OleVariant;');
 CL.AddDelphiFunction('Procedure VariantArrayToStream( VarArray : OleVariant; var Stream : TStream);');
 CL.AddDelphiFunction('Procedure VariantArrayToStream1( VarArray : OleVariant; var Stream : IStream);');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure VariantArrayToStream1_P( VarArray : OleVariant; var Stream : IStream);
Begin JclCOM.VariantArrayToStream(VarArray, Stream); END;

(*----------------------------------------------------------------------------*)
Procedure VariantArrayToStream_P( VarArray : OleVariant; var Stream : TStream);
Begin JclCOM.VariantArrayToStream(VarArray, Stream); END;

(*----------------------------------------------------------------------------*)
Function StreamToVariantArray1_P( Stream : IStream) : OleVariant;
Begin Result := JclCOM.StreamToVariantArray(Stream); END;

(*----------------------------------------------------------------------------*)
Function StreamToVariantArray_P( Stream : TStream) : OleVariant;
Begin Result := JclCOM.StreamToVariantArray(Stream); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclCOM_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IsDCOMInstalled, 'IsDCOMInstalled', cdRegister);
 S.RegisterDelphiFunction(@IsDCOMEnabled, 'IsDCOMEnabled', cdRegister);
 S.RegisterDelphiFunction(@GetDCOMVersion, 'GetDCOMVersion', cdRegister);
 S.RegisterDelphiFunction(@GetMDACVersion, 'GetMDACVersion', cdRegister);
 S.RegisterDelphiFunction(@MarshalInterThreadInterfaceInVarArray, 'MarshalInterThreadInterfaceInVarArray', cdRegister);
 S.RegisterDelphiFunction(@MarshalInterProcessInterfaceInStream, 'MarshalInterProcessInterfaceInStream', cdRegister);
 S.RegisterDelphiFunction(@MarshalInterProcessInterfaceInVarArray, 'MarshalInterProcessInterfaceInVarArray', cdRegister);
 S.RegisterDelphiFunction(@MarshalInterMachineInterfaceInStream, 'MarshalInterMachineInterfaceInStream', cdRegister);
 S.RegisterDelphiFunction(@MarshalInterMachineInterfaceInVarArray, 'MarshalInterMachineInterfaceInVarArray', cdRegister);
 S.RegisterDelphiFunction(@CreateComponentCategory, 'CreateComponentCategory', cdRegister);
 S.RegisterDelphiFunction(@RegisterCLSIDInCategory, 'RegisterCLSIDInCategory', cdRegister);
 S.RegisterDelphiFunction(@UnRegisterCLSIDInCategory, 'UnRegisterCLSIDInCategory', cdRegister);
 S.RegisterDelphiFunction(@ResetIStreamToStart, 'ResetIStreamToStart', cdRegister);
 S.RegisterDelphiFunction(@SizeOfIStreamContents, 'SizeOfIStreamContents', cdRegister);
 S.RegisterDelphiFunction(@StreamToVariantArray, 'StreamToVariantArray', cdRegister);
 S.RegisterDelphiFunction(@StreamToVariantArray, 'StreamToVariantArray1', cdRegister);
 S.RegisterDelphiFunction(@VariantArrayToStream, 'VariantArrayToStream', cdRegister);
 S.RegisterDelphiFunction(@VariantArrayToStream, 'VariantArrayToStream1', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclCOM(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EInvalidParam) do
end;

 
 
{ TPSImport_JclCOM }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclCOM.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclCOM(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclCOM.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclCOM(ri);
  RIRegister_JclCOM_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
