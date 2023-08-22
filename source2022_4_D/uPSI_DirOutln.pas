unit uPSI_DirOutln;
{
   of samples
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
  TPSImport_DirOutln = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDirectoryOutline(CL: TPSPascalCompiler);
procedure SIRegister_DirOutln(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DirOutln_Routines(S: TPSExec);
procedure RIRegister_TDirectoryOutline(CL: TPSRuntimeClassImporter);
procedure RIRegister_DirOutln(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Forms
  ,Controls
  ,Outline
  ,Graphics
  ,Grids
  ,StdCtrls
  ,Menus
  ,DirOutln
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DirOutln]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDirectoryOutline(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomOutline', 'TDirectoryOutline') do
  with CL.AddClassN(CL.FindClass('TCustomOutline'),'TDirectoryOutline') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
         RegisterMethod('Procedure Free');
        RegisterMethod('procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);');
      RegisterMethod('Function ForceCase( const AString : string) : string');
    RegisterProperty('Drive', 'Char', iptrw);
    RegisterProperty('Directory', 'TFileName', iptrw);
    RegisterProperty('TextCase', 'TTextCase', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('Lines', 'TStrings', iptrw);
      RegisterPublishedProperties;
   RegisterProperty('FONT', 'TFont', iptrw);
   RegisterProperty('Color', 'TColor', iptrw);
      RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('Enabled', 'Boolean', iptrw);
      RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('CANVAS', 'TCanvas', iptrw);
     RegisterProperty('ItemHeight', 'Integer', iptrw);
     RegisterProperty('ScrollBars', 'boolean', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
  //  RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
  //  RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
  //  RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DirOutln(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TTTextCase', '( tcLowerCase, tcUpperCase, tcAsIs )');
  SIRegister_TDirectoryOutline(CL);
 CL.AddDelphiFunction('Function SameLetter( Letter1, Letter2 : Char) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDirectoryOutlineOnChange_W(Self: TDirectoryOutline; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TDirectoryOutlineOnChange_R(Self: TDirectoryOutline; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TDirectoryOutlineTextCase_W(Self: TDirectoryOutline; const T: TTextCase);
begin Self.TextCase := T; end;

(*----------------------------------------------------------------------------*)
procedure TDirectoryOutlineTextCase_R(Self: TDirectoryOutline; var T: TTextCase);
begin T := Self.TextCase; end;

(*----------------------------------------------------------------------------*)
procedure TDirectoryOutlineDirectory_W(Self: TDirectoryOutline; const T: TFileName);
begin Self.Directory := T; end;

(*----------------------------------------------------------------------------*)
procedure TDirectoryOutlineDirectory_R(Self: TDirectoryOutline; var T: TFileName);
begin T := Self.Directory; end;

(*----------------------------------------------------------------------------*)
procedure TDirectoryOutlineDrive_W(Self: TDirectoryOutline; const T: Char);
begin Self.Drive := T; end;

(*----------------------------------------------------------------------------*)
procedure TDirectoryOutlineDrive_R(Self: TDirectoryOutline; var T: Char);
begin T := Self.Drive; end;

procedure TDirectoryOutlineLines_W(Self: TDirectoryOutline; const T: TStrings);
begin Self.Lines:= T; end;

(*----------------------------------------------------------------------------*)
procedure TDirectoryOutlineLines_R(Self: TDirectoryOutline; var T: TStrings);
begin T := Self.Lines; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DirOutln_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SameLetter, 'SameLetter', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDirectoryOutline(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDirectoryOutline) do begin
    RegisterConstructor(@TDirectoryOutline.Create, 'Create');
     RegisterMethod(@TDirectoryOutline.Destroy, 'Free');
       RegisterMethod(@TDirectoryOutline.ForceCase, 'ForceCase');
         RegisterMethod(@TDirectoryOutline.SetBounds, 'SetBounds');
    RegisterPropertyHelper(@TDirectoryOutlineDrive_R,@TDirectoryOutlineDrive_W,'Drive');
    RegisterPropertyHelper(@TDirectoryOutlineDirectory_R,@TDirectoryOutlineDirectory_W,'Directory');
    RegisterPropertyHelper(@TDirectoryOutlineTextCase_R,@TDirectoryOutlineTextCase_W,'TextCase');
    RegisterPropertyHelper(@TDirectoryOutlineOnChange_R,@TDirectoryOutlineOnChange_W,'OnChange');
    RegisterPropertyHelper(@TDirectoryOutlineLines_R,@TDirectoryOutlineLines_W,'Lines');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DirOutln(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDirectoryOutline(CL);
end;

 
 
{ TPSImport_DirOutln }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DirOutln.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DirOutln(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DirOutln.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DirOutln(ri);
  RIRegister_DirOutln_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
