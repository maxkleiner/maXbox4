unit uPSI_o32ledlabel;
{
  led box
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
  TPSImport_o32ledlabel = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TO32LEDLabel(CL: TPSPascalCompiler);
procedure SIRegister_TO32CustomLEDLabel(CL: TPSPascalCompiler);
procedure SIRegister_o32ledlabel(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TO32LEDLabel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TO32CustomLEDLabel(CL: TPSRuntimeClassImporter);
procedure RIRegister_o32ledlabel(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,Graphics
  ,Messages
  ,OvcBase
  ,O32SR
  ,o32ledlabel
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_o32ledlabel]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TO32LEDLabel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TO32CustomLEDLabel', 'TO32LEDLabel') do
  with CL.AddClassN(CL.FindClass('TO32CustomLEDLabel'),'TO32LEDLabel') do  begin
   REgisterPublishedProperties;
   RegisterProperty('Caption', 'string', iptrW);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('ALIGNMENT', 'TAlignment', iptrw);
     //RegisterProperty('Options', 'TAfComOptions', iptrw);
      //RegisterProperty('TermColorMode', 'TAfTRMColorMode', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
     RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('READONLY', 'Boolean', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TO32CustomLEDLabel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TO32CustomLEDLabel') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TO32CustomLEDLabel') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free)');
      RegisterProperty('About', 'string', iptrw);
    RegisterProperty('Columns', 'Integer', iptrw);
    RegisterProperty('Rows', 'Integer', iptrw);
    RegisterProperty('BgColor', 'TColor', iptrw);
    RegisterProperty('OffColor', 'TColor', iptrw);
    RegisterProperty('OnColor', 'TColor', iptrw);
    RegisterProperty('Size', 'TSegmentSize', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_o32ledlabel(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TSegmentSize', 'Integer');
  SIRegister_TO32CustomLEDLabel(CL);
  SIRegister_TO32LEDLabel(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TO32CustomLEDLabelSize_W(Self: TO32CustomLEDLabel; const T: TSegmentSize);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TO32CustomLEDLabelSize_R(Self: TO32CustomLEDLabel; var T: TSegmentSize);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TO32CustomLEDLabelOnColor_W(Self: TO32CustomLEDLabel; const T: TColor);
begin Self.OnColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TO32CustomLEDLabelOnColor_R(Self: TO32CustomLEDLabel; var T: TColor);
begin T := Self.OnColor; end;

(*----------------------------------------------------------------------------*)
procedure TO32CustomLEDLabelOffColor_W(Self: TO32CustomLEDLabel; const T: TColor);
begin Self.OffColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TO32CustomLEDLabelOffColor_R(Self: TO32CustomLEDLabel; var T: TColor);
begin T := Self.OffColor; end;

(*----------------------------------------------------------------------------*)
procedure TO32CustomLEDLabelBgColor_W(Self: TO32CustomLEDLabel; const T: TColor);
begin Self.BgColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TO32CustomLEDLabelBgColor_R(Self: TO32CustomLEDLabel; var T: TColor);
begin T := Self.BgColor; end;

(*----------------------------------------------------------------------------*)
procedure TO32CustomLEDLabelRows_W(Self: TO32CustomLEDLabel; const T: Integer);
begin Self.Rows := T; end;

(*----------------------------------------------------------------------------*)
procedure TO32CustomLEDLabelRows_R(Self: TO32CustomLEDLabel; var T: Integer);
begin T := Self.Rows; end;

(*----------------------------------------------------------------------------*)
procedure TO32CustomLEDLabelColumns_W(Self: TO32CustomLEDLabel; const T: Integer);
begin Self.Columns := T; end;

(*----------------------------------------------------------------------------*)
procedure TO32CustomLEDLabelColumns_R(Self: TO32CustomLEDLabel; var T: Integer);
begin T := Self.Columns; end;

(*----------------------------------------------------------------------------*)
procedure TO32CustomLEDLabelAbout_W(Self: TO32CustomLEDLabel; const T: string);
begin Self.About := T; end;

(*----------------------------------------------------------------------------*)
procedure TO32CustomLEDLabelAbout_R(Self: TO32CustomLEDLabel; var T: string);
begin T := Self.About; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TO32LEDLabel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TO32LEDLabel) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TO32CustomLEDLabel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TO32CustomLEDLabel) do begin
    RegisterConstructor(@TO32CustomLEDLabel.Create, 'Create');
    RegisterMethod(@TO32CustomLEDLabel.Free, 'Free');
     RegisterPropertyHelper(@TO32CustomLEDLabelAbout_R,@TO32CustomLEDLabelAbout_W,'About');
    RegisterPropertyHelper(@TO32CustomLEDLabelColumns_R,@TO32CustomLEDLabelColumns_W,'Columns');
    RegisterPropertyHelper(@TO32CustomLEDLabelRows_R,@TO32CustomLEDLabelRows_W,'Rows');
    RegisterPropertyHelper(@TO32CustomLEDLabelBgColor_R,@TO32CustomLEDLabelBgColor_W,'BgColor');
    RegisterPropertyHelper(@TO32CustomLEDLabelOffColor_R,@TO32CustomLEDLabelOffColor_W,'OffColor');
    RegisterPropertyHelper(@TO32CustomLEDLabelOnColor_R,@TO32CustomLEDLabelOnColor_W,'OnColor');
    RegisterPropertyHelper(@TO32CustomLEDLabelSize_R,@TO32CustomLEDLabelSize_W,'Size');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_o32ledlabel(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TO32CustomLEDLabel(CL);
  RIRegister_TO32LEDLabel(CL);
end;

 
 
{ TPSImport_o32ledlabel }
(*----------------------------------------------------------------------------*)
procedure TPSImport_o32ledlabel.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_o32ledlabel(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_o32ledlabel.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_o32ledlabel(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
