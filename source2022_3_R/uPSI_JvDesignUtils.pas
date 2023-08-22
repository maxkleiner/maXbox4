unit uPSI_JvDesignUtils;
{
   function pack
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
  TPSImport_JvDesignUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JvDesignUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvDesignUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,Controls
  ,Graphics
  ,Forms
  ,JvDesignUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvDesignUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JvDesignUtils(CL: TPSPascalCompiler);
begin

  CL.AddTypeS('TReaderError', 'procedure (Reader: TReader; const Message: string; var Handled: Boolean) of object;');
  CL.AddTypeS('TReferenceNameEvent','procedure (Reader: TReader; var Name: string) of object;');

 CL.AddDelphiFunction('Function DesignClientToParent( const APt : TPoint; AControl, AParent : TControl) : TPoint');
 CL.AddDelphiFunction('Function DesignMin( AA, AB : Integer) : Integer');
 CL.AddDelphiFunction('Function DesignMax( AA, AB : Integer) : Integer');
 CL.AddDelphiFunction('Function DesignRectWidth( const ARect : TRect) : Integer');
 CL.AddDelphiFunction('Function DesignRectHeight( const ARect : TRect) : Integer');
 CL.AddDelphiFunction('Function DesignValidateRect( const ARect : TRect) : TRect');
 CL.AddDelphiFunction('Function DesignNameIsUnique( AOwner : TComponent; const AName : string) : Boolean');
 CL.AddDelphiFunction('Function DesignUniqueName( AOwner : TComponent; const AClassName : string) : string');
 CL.AddDelphiFunction('Procedure DesignPaintRubberbandRect( AContainer : TWinControl; ARect : TRect; APenStyle : TPenStyle)');
 CL.AddDelphiFunction('Procedure DesignPaintGrid( ACanvas : TCanvas; const ARect : TRect; ABackColor : TColor; AGridColor : TColor; ADivPixels : Integer)');
 CL.AddDelphiFunction('Procedure DesignPaintRules( ACanvas : TCanvas; const ARect : TRect; ADivPixels : Integer; ASubDivs : Boolean)');
 CL.AddDelphiFunction('Procedure DesignSaveComponentToStream( AComp : TComponent; AStream : TStream)');
 CL.AddDelphiFunction('Function DesignLoadComponentFromStream( AComp : TComponent; AStream : TStream; AOnError : TReaderError) : TComponent');
 CL.AddDelphiFunction('Procedure DesignSaveComponentToFile( AComp : TComponent; const AFileName : string)');
 CL.AddDelphiFunction('Procedure DesignLoadComponentFromFile( AComp : TComponent; const AFileName : string; AOnError : TReaderError)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDesignUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DesignClientToParent, 'DesignClientToParent', cdRegister);
 S.RegisterDelphiFunction(@DesignMin, 'DesignMin', cdRegister);
 S.RegisterDelphiFunction(@DesignMax, 'DesignMax', cdRegister);
 S.RegisterDelphiFunction(@DesignRectWidth, 'DesignRectWidth', cdRegister);
 S.RegisterDelphiFunction(@DesignRectHeight, 'DesignRectHeight', cdRegister);
 S.RegisterDelphiFunction(@DesignValidateRect, 'DesignValidateRect', cdRegister);
 S.RegisterDelphiFunction(@DesignNameIsUnique, 'DesignNameIsUnique', cdRegister);
 S.RegisterDelphiFunction(@DesignUniqueName, 'DesignUniqueName', cdRegister);
 S.RegisterDelphiFunction(@DesignPaintRubberbandRect, 'DesignPaintRubberbandRect', cdRegister);
 S.RegisterDelphiFunction(@DesignPaintGrid, 'DesignPaintGrid', cdRegister);
 S.RegisterDelphiFunction(@DesignPaintRules, 'DesignPaintRules', cdRegister);
 S.RegisterDelphiFunction(@DesignSaveComponentToStream, 'DesignSaveComponentToStream', cdRegister);
 S.RegisterDelphiFunction(@DesignLoadComponentFromStream, 'DesignLoadComponentFromStream', cdRegister);
 S.RegisterDelphiFunction(@DesignSaveComponentToFile, 'DesignSaveComponentToFile', cdRegister);
 S.RegisterDelphiFunction(@DesignLoadComponentFromFile, 'DesignLoadComponentFromFile', cdRegister);
end;

 
 
{ TPSImport_JvDesignUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDesignUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvDesignUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDesignUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvDesignUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
