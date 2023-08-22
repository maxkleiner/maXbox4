unit uPSI_JvIni;
{
   another inin with functions
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
  TPSImport_JvIni = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvIniFile(CL: TPSPascalCompiler);
procedure SIRegister_JvIni(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvIni_Routines(S: TPSExec);
procedure RIRegister_TJvIniFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvIni(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  //,WinTypes
  //,WinProcs
  ,IniFiles
  ,Graphics
  ,JvIni
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvIni]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvIniFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIniFile', 'TJvIniFile') do
  with CL.AddClassN(CL.FindClass('TIniFile'),'TJvIniFile') do begin
    RegisterMethod('Constructor Create( const FileName : string)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Flush');
    RegisterMethod('Procedure DeleteKey( const Section, Ident : string)');
    RegisterMethod('Function ReadClearList( const Section : string; List : TStrings) : TStrings');
    RegisterMethod('Function ReadList( const Section : string; List : TStrings) : TStrings');
    RegisterMethod('Procedure WriteList( const Section : string; List : TStrings)');
    RegisterMethod('Function ReadColor( const Section, Ident : string; Default : TColor) : TColor');
    RegisterMethod('Procedure WriteColor( const Section, Ident : string; Value : TColor)');
    RegisterMethod('Function ReadFont( const Section, Ident : string; Font : TFont) : TFont');
    RegisterMethod('Procedure WriteFont( const Section, Ident : string; Font : TFont)');
    RegisterMethod('Function ReadRect( const Section, Ident : string; const Default : TRect) : TRect');
    RegisterMethod('Procedure WriteRect( const Section, Ident : string; const Value : TRect)');
    RegisterMethod('Function ReadPoint( const Section, Ident : string; const Default : TPoint) : TPoint');
    RegisterMethod('Procedure WritePoint( const Section, Ident : string; const Value : TPoint)');
    RegisterProperty('ListItemName', 'string', iptrw);
    RegisterProperty('OnReadObject', 'TReadObjectEvent', iptrw);
    RegisterProperty('OnWriteObject', 'TWriteObjectEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvIni(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TReadObjectEvent', 'Function ( Sender : TObject; const Section, Item, Value : string) : TObject');
  CL.AddTypeS('TWriteObjectEvent', 'Procedure ( Sender : TObject; const Section, Item: string; Obj: TObject)');
  SIRegister_TJvIniFile(CL);
 CL.AddDelphiFunction('Function StringToFontStyles( const Styles : string) : TFontStyles');
 CL.AddDelphiFunction('Function FontStylesToString( Styles : TFontStyles) : string');
 CL.AddDelphiFunction('Function FontToString( Font : TFont) : string');
 CL.AddDelphiFunction('Procedure StringToFont( const Str : string; Font : TFont)');
 CL.AddDelphiFunction('Function RectToStr( Rect : TRect) : string');
 CL.AddDelphiFunction('Function StrToRect( const Str : string; const Def : TRect) : TRect');
 CL.AddDelphiFunction('Function JPointToStr( P : TPoint) : string');
 CL.AddDelphiFunction('Function JStrToPoint( const Str : string; const Def : TPoint) : TPoint');
 CL.AddDelphiFunction('Function DefProfileName : string');
 CL.AddDelphiFunction('Function DefLocalProfileName : string');
 CL.AddConstantN('idnListItem','String').SetString( 'Item');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvIniFileOnWriteObject_W(Self: TJvIniFile; const T: TWriteObjectEvent);
begin Self.OnWriteObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIniFileOnWriteObject_R(Self: TJvIniFile; var T: TWriteObjectEvent);
begin T := Self.OnWriteObject; end;

(*----------------------------------------------------------------------------*)
procedure TJvIniFileOnReadObject_W(Self: TJvIniFile; const T: TReadObjectEvent);
begin Self.OnReadObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIniFileOnReadObject_R(Self: TJvIniFile; var T: TReadObjectEvent);
begin T := Self.OnReadObject; end;

(*----------------------------------------------------------------------------*)
procedure TJvIniFileListItemName_W(Self: TJvIniFile; const T: string);
begin Self.ListItemName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIniFileListItemName_R(Self: TJvIniFile; var T: string);
begin T := Self.ListItemName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvIni_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@StringToFontStyles, 'StringToFontStyles', cdRegister);
 S.RegisterDelphiFunction(@FontStylesToString, 'FontStylesToString', cdRegister);
 S.RegisterDelphiFunction(@FontToString, 'FontToString', cdRegister);
 S.RegisterDelphiFunction(@StringToFont, 'StringToFont', cdRegister);
 S.RegisterDelphiFunction(@RectToStr, 'RectToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToRect, 'StrToRect', cdRegister);
 S.RegisterDelphiFunction(@PointToStr, 'JPointToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToPoint, 'JStrToPoint', cdRegister);
 S.RegisterDelphiFunction(@DefProfileName, 'DefProfileName', cdRegister);
 S.RegisterDelphiFunction(@DefLocalProfileName, 'DefLocalProfileName', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvIniFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvIniFile) do begin
    RegisterConstructor(@TJvIniFile.Create, 'Create');
     RegisterMethod(@TJvIniFile.Destroy, 'Free');
     RegisterMethod(@TJvIniFile.Flush, 'Flush');
    RegisterMethod(@TJvIniFile.DeleteKey, 'DeleteKey');
    RegisterMethod(@TJvIniFile.ReadClearList, 'ReadClearList');
    RegisterMethod(@TJvIniFile.ReadList, 'ReadList');
    RegisterMethod(@TJvIniFile.WriteList, 'WriteList');
    RegisterMethod(@TJvIniFile.ReadColor, 'ReadColor');
    RegisterMethod(@TJvIniFile.WriteColor, 'WriteColor');
    RegisterMethod(@TJvIniFile.ReadFont, 'ReadFont');
    RegisterMethod(@TJvIniFile.WriteFont, 'WriteFont');
    RegisterMethod(@TJvIniFile.ReadRect, 'ReadRect');
    RegisterMethod(@TJvIniFile.WriteRect, 'WriteRect');
    RegisterMethod(@TJvIniFile.ReadPoint, 'ReadPoint');
    RegisterMethod(@TJvIniFile.WritePoint, 'WritePoint');
    RegisterPropertyHelper(@TJvIniFileListItemName_R,@TJvIniFileListItemName_W,'ListItemName');
    RegisterPropertyHelper(@TJvIniFileOnReadObject_R,@TJvIniFileOnReadObject_W,'OnReadObject');
    RegisterPropertyHelper(@TJvIniFileOnWriteObject_R,@TJvIniFileOnWriteObject_W,'OnWriteObject');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvIni(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvIniFile(CL);
end;

 
 
{ TPSImport_JvIni }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvIni.CompileImport1(CompExec: TPSScript);
begin
  //SIRegister_JvIni(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvIni.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvIni(ri);
  RIRegister_JvIni_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
