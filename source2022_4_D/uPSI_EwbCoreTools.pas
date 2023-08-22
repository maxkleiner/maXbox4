unit uPSI_EwbCoreTools;
{
Tfrorm embedded browser
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
  TPSImport_EwbCoreTools = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_EwbCoreTools(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_EwbCoreTools_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Graphics
  ,ActiveX
 // ,Mshtml_Ewb
  ,Windows
  ,EwbCoreTools
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_EwbCoreTools]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_EwbCoreTools(CL: TPSPascalCompiler);
begin
 //CL.AddDelphiFunction('Function IsWinXPSP2OrLater( ) : Boolean');
 CL.AddDelphiFunction('Function ColorToHTML2( const Color : TColor) : string');
 //CL.AddDelphiFunction('Function WideStringToLPOLESTR( const Source : Widestring) : POleStr');
 //CL.AddDelphiFunction('Function XPath4Node( node : IHTMLElement) : string');
 //CL.AddDelphiFunction('Function TaskAllocWideString( const S : string) : PWChar');
 CL.AddDelphiFunction('Function AnsiIndexStr2( const AText : string; const AValues : array of string) : Integer');
 CL.AddDelphiFunction('Function GetPos( const SubSt, Text : string; StartPos : Integer) : Integer');
 CL.AddDelphiFunction('Function _CharPos( const C : Char; const S : string) : Integer');
 CL.AddDelphiFunction('Function CutString( var Text : string; const Delimiter : string; const Remove : Boolean) : string');
 CL.AddDelphiFunction('Procedure FormatPath( Path : string)');
 CL.AddDelphiFunction('Function GetWinText( WinHandle : THandle) : string');
 CL.AddDelphiFunction('Function GetWinClass( Handle : Hwnd) : WideString');
 CL.AddDelphiFunction('Function GetParentWinByClass( ChildHandle : HWND; const ClassName : string) : HWND');
 CL.AddDelphiFunction('Function DirectoryExists2( const Directory : string) : Boolean');
 //CL.AddDelphiFunction('Function VarSupports( const V : Variant; const IID : TGUID; out Intf) : Boolean');
 CL.AddDelphiFunction('Function CharInSet3( C : Char; const CharSet : TSysCharSet) : Boolean');
 CL.AddDelphiFunction('Function AddBackSlash2( const S : string) : string');
 CL.AddConstantN('WM_SETWBFOCUS','LongWord').SetUInt( $0400 + $44);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_EwbCoreTools_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@IsWinXPSP2OrLater, 'IsWinXPSP2OrLater', cdRegister);
 S.RegisterDelphiFunction(@ColorToHTML, 'ColorToHTML2', cdRegister);
 //S.RegisterDelphiFunction(@WideStringToLPOLESTR, 'WideStringToLPOLESTR', cdRegister);
 //S.RegisterDelphiFunction(@XPath4Node, 'XPath4Node', cdRegister);
 //S.RegisterDelphiFunction(@TaskAllocWideString, 'TaskAllocWideString', cdRegister);
 S.RegisterDelphiFunction(@AnsiIndexStr, 'AnsiIndexStr2', cdRegister);
 S.RegisterDelphiFunction(@GetPos, 'GetPos', cdRegister);
 S.RegisterDelphiFunction(@_CharPos, '_CharPos', cdRegister);
 S.RegisterDelphiFunction(@CutString, 'CutString', cdRegister);
 S.RegisterDelphiFunction(@FormatPath, 'FormatPath', cdRegister);
 S.RegisterDelphiFunction(@GetWinText, 'GetWinText', cdRegister);
 S.RegisterDelphiFunction(@GetWinClass, 'GetWinClass', cdRegister);
 S.RegisterDelphiFunction(@GetParentWinByClass, 'GetParentWinByClass', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExists, 'DirectoryExists2', cdRegister);
 //S.RegisterDelphiFunction(@VarSupports, 'VarSupports', cdRegister);
 S.RegisterDelphiFunction(@CharInSet, 'CharInSet3', cdRegister);
 S.RegisterDelphiFunction(@AddBackSlash, 'AddBackSlash2', cdRegister);
end;

 
 
{ TPSImport_EwbCoreTools }
(*----------------------------------------------------------------------------*)
procedure TPSImport_EwbCoreTools.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_EwbCoreTools(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_EwbCoreTools.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_EwbCoreTools_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
