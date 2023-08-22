unit uPSI_hhAvComp;
{
  compass  leVel
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
  TPSImport_hhAvComp = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ThhAvComp(CL: TPSPascalCompiler);
procedure SIRegister_hhAvComp(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_hhAvComp_Routines(S: TPSExec);
procedure RIRegister_ThhAvComp(CL: TPSRuntimeClassImporter);
procedure RIRegister_hhAvComp(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,StdCtrls
  ,hhAvComp
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_hhAvComp]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ThhAvComp(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'ThhAvComp') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'ThhAvComp') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
      RegisterMethod('Procedure AddBearing( Value : Real)');
    RegisterMethod('Procedure AddCourse( Value : Real)');
    RegisterProperty('BackColor', 'TColor', iptrw);
    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('PointerColor', 'TColor', iptrw);
    RegisterProperty('CardinalColor', 'TColor', iptrw);
    RegisterProperty('CourseColor', 'TColor', iptrw);
    RegisterProperty('ScaleColor', 'TColor', iptrw);
    RegisterProperty('IsMagnetic', 'Boolean', iptrw);
    RegisterProperty('ShowMagnetic', 'Boolean', iptrw);
    RegisterProperty('ShowBearing', 'Boolean', iptrw);
    RegisterProperty('ShowCourse', 'Boolean', iptrw);
    RegisterProperty('FullBearing', 'Boolean', iptrw);
    RegisterProperty('Bearing', 'Real', iptrw);
    RegisterProperty('Course', 'Real', iptrw);
    RegisterProperty('CoursePointer', 'TpsCoursePointer', iptrw);
    RegisterProperty('MagVar', 'Real', iptrw);
    RegisterProperty('ToFrom', 'boolean', iptr);
    RegisterpublishedProperties;
    RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('CANVAS', 'TCanvas', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_hhAvComp(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TpsCoursePointer', '( psArrow, psDelta, psPlane, psPtrLine )');
  SIRegister_ThhAvComp(CL);
// CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure ThhAvCompToFrom_R(Self: ThhAvComp; var T: boolean);
begin T := Self.ToFrom; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompMagVar_W(Self: ThhAvComp; const T: Real);
begin Self.MagVar := T; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompMagVar_R(Self: ThhAvComp; var T: Real);
begin T := Self.MagVar; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompCoursePointer_W(Self: ThhAvComp; const T: TpsCoursePointer);
begin Self.CoursePointer := T; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompCoursePointer_R(Self: ThhAvComp; var T: TpsCoursePointer);
begin T := Self.CoursePointer; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompCourse_W(Self: ThhAvComp; const T: Real);
begin Self.Course := T; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompCourse_R(Self: ThhAvComp; var T: Real);
begin T := Self.Course; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompBearing_W(Self: ThhAvComp; const T: Real);
begin Self.Bearing := T; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompBearing_R(Self: ThhAvComp; var T: Real);
begin T := Self.Bearing; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompFullBearing_W(Self: ThhAvComp; const T: Boolean);
begin Self.FullBearing := T; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompFullBearing_R(Self: ThhAvComp; var T: Boolean);
begin T := Self.FullBearing; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompShowCourse_W(Self: ThhAvComp; const T: Boolean);
begin Self.ShowCourse := T; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompShowCourse_R(Self: ThhAvComp; var T: Boolean);
begin T := Self.ShowCourse; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompShowBearing_W(Self: ThhAvComp; const T: Boolean);
begin Self.ShowBearing := T; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompShowBearing_R(Self: ThhAvComp; var T: Boolean);
begin T := Self.ShowBearing; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompShowMagnetic_W(Self: ThhAvComp; const T: Boolean);
begin Self.ShowMagnetic := T; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompShowMagnetic_R(Self: ThhAvComp; var T: Boolean);
begin T := Self.ShowMagnetic; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompIsMagnetic_W(Self: ThhAvComp; const T: Boolean);
begin Self.IsMagnetic := T; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompIsMagnetic_R(Self: ThhAvComp; var T: Boolean);
begin T := Self.IsMagnetic; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompScaleColor_W(Self: ThhAvComp; const T: TColor);
begin Self.ScaleColor := T; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompScaleColor_R(Self: ThhAvComp; var T: TColor);
begin T := Self.ScaleColor; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompCourseColor_W(Self: ThhAvComp; const T: TColor);
begin Self.CourseColor := T; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompCourseColor_R(Self: ThhAvComp; var T: TColor);
begin T := Self.CourseColor; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompCardinalColor_W(Self: ThhAvComp; const T: TColor);
begin Self.CardinalColor := T; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompCardinalColor_R(Self: ThhAvComp; var T: TColor);
begin T := Self.CardinalColor; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompPointerColor_W(Self: ThhAvComp; const T: TColor);
begin Self.PointerColor := T; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompPointerColor_R(Self: ThhAvComp; var T: TColor);
begin T := Self.PointerColor; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompBorderStyle_W(Self: ThhAvComp; const T: TBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompBorderStyle_R(Self: ThhAvComp; var T: TBorderStyle);
begin T := Self.BorderStyle; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompBackColor_W(Self: ThhAvComp; const T: TColor);
begin Self.BackColor := T; end;

(*----------------------------------------------------------------------------*)
procedure ThhAvCompBackColor_R(Self: ThhAvComp; var T: TColor);
begin T := Self.BackColor; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_hhAvComp_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ThhAvComp(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ThhAvComp) do begin
    RegisterConstructor(@ThhAvComp.Create, 'Create');
    RegisterMethod(@ThhAvComp.Destroy, 'Free');
    RegisterMethod(@ThhAvComp.AddBearing, 'AddBearing');
    RegisterMethod(@ThhAvComp.AddCourse, 'AddCourse');
    RegisterPropertyHelper(@ThhAvCompBackColor_R,@ThhAvCompBackColor_W,'BackColor');
    RegisterPropertyHelper(@ThhAvCompBorderStyle_R,@ThhAvCompBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@ThhAvCompPointerColor_R,@ThhAvCompPointerColor_W,'PointerColor');
    RegisterPropertyHelper(@ThhAvCompCardinalColor_R,@ThhAvCompCardinalColor_W,'CardinalColor');
    RegisterPropertyHelper(@ThhAvCompCourseColor_R,@ThhAvCompCourseColor_W,'CourseColor');
    RegisterPropertyHelper(@ThhAvCompScaleColor_R,@ThhAvCompScaleColor_W,'ScaleColor');
    RegisterPropertyHelper(@ThhAvCompIsMagnetic_R,@ThhAvCompIsMagnetic_W,'IsMagnetic');
    RegisterPropertyHelper(@ThhAvCompShowMagnetic_R,@ThhAvCompShowMagnetic_W,'ShowMagnetic');
    RegisterPropertyHelper(@ThhAvCompShowBearing_R,@ThhAvCompShowBearing_W,'ShowBearing');
    RegisterPropertyHelper(@ThhAvCompShowCourse_R,@ThhAvCompShowCourse_W,'ShowCourse');
    RegisterPropertyHelper(@ThhAvCompFullBearing_R,@ThhAvCompFullBearing_W,'FullBearing');
    RegisterPropertyHelper(@ThhAvCompBearing_R,@ThhAvCompBearing_W,'Bearing');
    RegisterPropertyHelper(@ThhAvCompCourse_R,@ThhAvCompCourse_W,'Course');
    RegisterPropertyHelper(@ThhAvCompCoursePointer_R,@ThhAvCompCoursePointer_W,'CoursePointer');
    RegisterPropertyHelper(@ThhAvCompMagVar_R,@ThhAvCompMagVar_W,'MagVar');
    RegisterPropertyHelper(@ThhAvCompToFrom_R,nil,'ToFrom');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_hhAvComp(CL: TPSRuntimeClassImporter);
begin
  RIRegister_ThhAvComp(CL);
end;

 
 
{ TPSImport_hhAvComp }
(*----------------------------------------------------------------------------*)
procedure TPSImport_hhAvComp.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_hhAvComp(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_hhAvComp.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_hhAvComp(ri);
  //RIRegister_hhAvComp_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
