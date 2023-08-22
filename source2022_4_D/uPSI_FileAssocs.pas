unit uPSI_FileAssocs;
{
   for ext reg
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
  TPSImport_FileAssocs = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_FileAssocs(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_FileAssocs_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Forms
  ,Registry
  ,ShlObj
  ,FileAssocs
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_FileAssocs]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_FileAssocs(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure CheckAssociations');
 CL.AddDelphiFunction('Procedure Associate( Index : integer)');
 CL.AddDelphiFunction('Procedure UnAssociate( Index : integer)');
 CL.AddDelphiFunction('Function IsAssociated( Index : integer) : boolean');
 CL.AddDelphiFunction('Function CheckFiletype( const extension, filetype, description, verb, serverapp : string) : boolean');
 CL.AddDelphiFunction('Procedure RegisterFiletype( const extension, filetype, description, verb, serverapp, IcoNum : string)');
 CL.AddDelphiFunction('Procedure RegisterDDEServer( const filetype, verb, topic, servername, macro : string)');
 CL.AddConstantN('AssociationsCount','LongInt').SetInt( 7);
 CL.AddDelphiFunction('Procedure RefreshIcons');


 CL.AddDelphiFunction('function GetShadeColor(ACanvas: TCanvas; clr: TColor; Value: integer): TColor');
CL.AddDelphiFunction('function MergColor(Colors: Array of TColor): TColor');
CL.AddDelphiFunction('function NewColor(ACanvas: TCanvas; clr: TColor; Value: integer): TColor');
CL.AddDelphiFunction('procedure DimBitmap(ABitmap: TBitmap; Value: integer)');

CL.AddDelphiFunction('function GrayColor(ACanvas: TCanvas; clr: TColor; Value: integer): TColor');
CL.AddDelphiFunction('function GetInverseColor(AColor: TColor): TColor');

CL.AddDelphiFunction('procedure GrayBitmap(ABitmap: TBitmap; Value: integer)');
CL.AddDelphiFunction('procedure DrawBitmapShadow(B: TBitmap; ACanvas: TCanvas; X, Y: integer; ShadowColor: TColor)');
CL.AddDelphiFunction('procedure DrawCheckMark(ACanvas: TCanvas; X, Y: integer)');
CL.AddDelphiFunction('procedure GetSystemMenuFont(Font: TFont)');


 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_FileAssocs_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CheckAssociations, 'CheckAssociations', cdRegister);
 S.RegisterDelphiFunction(@Associate, 'Associate', cdRegister);
 S.RegisterDelphiFunction(@RefreshIcons, 'RefreshIcons', cdRegister);
 S.RegisterDelphiFunction(@UnAssociate, 'UnAssociate', cdRegister);
 S.RegisterDelphiFunction(@IsAssociated, 'IsAssociated', cdRegister);
 S.RegisterDelphiFunction(@CheckFiletype, 'CheckFiletype', cdRegister);
 S.RegisterDelphiFunction(@RegisterFiletype, 'RegisterFiletype', cdRegister);
 S.RegisterDelphiFunction(@RegisterDDEServer, 'RegisterDDEServer', cdRegister);

 S.RegisterDelphiFunction(@GetShadeColor, 'GetShadeColor', cdRegister);
 S.RegisterDelphiFunction(@MergColor, 'MergColor', cdRegister);
 S.RegisterDelphiFunction(@NewColor, 'NewColor', cdRegister);
 S.RegisterDelphiFunction(@DimBitmap, 'DimBitmap', cdRegister);
S.RegisterDelphiFunction(@GrayColor, 'GrayColor', cdRegister);
 S.RegisterDelphiFunction(@GetInverseColor, 'GetInverseColor', cdRegister);
S.RegisterDelphiFunction(@GrayBitmap, 'GrayBitmap', cdRegister);
 S.RegisterDelphiFunction(@DrawBitmapShadow, 'DrawBitmapShadow', cdRegister);
S.RegisterDelphiFunction(@DrawCheckMark, 'DrawCheckMark', cdRegister);
 S.RegisterDelphiFunction(@GetSystemMenuFont, 'GetSystemMenuFont', cdRegister);





end;

 
 
{ TPSImport_FileAssocs }
(*----------------------------------------------------------------------------*)
procedure TPSImport_FileAssocs.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_FileAssocs(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_FileAssocs.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_FileAssocs(ri);
  RIRegister_FileAssocs_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
