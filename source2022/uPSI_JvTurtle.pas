unit uPSI_JvTurtle;
{
   lang turtle
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
  TPSImport_JvTurtle = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvTurtle(CL: TPSPascalCompiler);
procedure SIRegister_JvTurtle(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvTurtle(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvTurtle(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  //,Messages
  ,Graphics
  ,Controls
  ,Math
  ,JvTurtle
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvTurtle]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvTurtle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TJvTurtle') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TJvTurtle') do begin
    RegisterProperty('Canvas', 'TCanvas', iptrw);
    RegisterProperty('Position', 'TPoint', iptrw);
    RegisterProperty('Mark', 'TPoint', iptrw);
    RegisterProperty('Area', 'TRect', iptrw);
    RegisterProperty('Heading', 'Real', iptrw);
    RegisterProperty('PenDown', 'Boolean', iptrw);
    RegisterProperty('PenWidth', 'Integer', iptrw);
    RegisterProperty('PenColor', 'TColor', iptrw);
    RegisterMethod('Function DoCom : string');
    RegisterMethod('procedure SetPos(x,y: integer);');
    RegisterMethod('Procedure Turn( AAngle : Real)');
    RegisterMethod('Procedure Right( AAngle : Real)');
    RegisterMethod('Procedure Left( AAngle : Real)');
    RegisterMethod('Procedure MoveForward( ADistance : Real)');
    RegisterMethod('Procedure MoveBackward( ADistance : Real)');
    RegisterMethod('Function Interpret( var ALine, ACol : Integer; const S : TStrings) : string');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free');
    RegisterProperty('OnRepaintRequest', 'TNotifyEvent', iptrw);
    RegisterProperty('OnRequestBackground', 'TRequestBackgroundEvent', iptrw);
    RegisterProperty('OnRequestFilter', 'TRequestFilterEvent', iptrw);
    RegisterProperty('OnRequestImageSize', 'TRequestImageSizeEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvTurtle(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TRequestBackgroundEvent', 'Procedure ( Sender : TObject; Background : string)');
  CL.AddTypeS('TRequestFilterEvent', 'Procedure ( Sender : TObject; Filter : string)');
  CL.AddTypeS('TRequestImageSizeEvent', 'Procedure ( Sender : TObject; var ARect : TRect)');
  SIRegister_TJvTurtle(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvTurtleOnRequestImageSize_W(Self: TJvTurtle; const T: TRequestImageSizeEvent);
begin Self.OnRequestImageSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtleOnRequestImageSize_R(Self: TJvTurtle; var T: TRequestImageSizeEvent);
begin T := Self.OnRequestImageSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtleOnRequestFilter_W(Self: TJvTurtle; const T: TRequestFilterEvent);
begin Self.OnRequestFilter := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtleOnRequestFilter_R(Self: TJvTurtle; var T: TRequestFilterEvent);
begin T := Self.OnRequestFilter; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtleOnRequestBackground_W(Self: TJvTurtle; const T: TRequestBackgroundEvent);
begin Self.OnRequestBackground := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtleOnRequestBackground_R(Self: TJvTurtle; var T: TRequestBackgroundEvent);
begin T := Self.OnRequestBackground; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtleOnRepaintRequest_W(Self: TJvTurtle; const T: TNotifyEvent);
begin Self.OnRepaintRequest := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtleOnRepaintRequest_R(Self: TJvTurtle; var T: TNotifyEvent);
begin T := Self.OnRepaintRequest; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtlePenWidth_W(Self: TJvTurtle; const T: Integer);
begin Self.PenWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtlePenWidth_R(Self: TJvTurtle; var T: Integer);
begin T := Self.PenWidth; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtlePenColor_W(Self: TJvTurtle; const T: TColor);
begin Self.canvas.Pen.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtlePenColor_R(Self: TJvTurtle; var T: TColor);
begin T := Self.canvas.Pen.Color; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtlePenDown_W(Self: TJvTurtle; const T: Boolean);
begin Self.PenDown := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtlePenDown_R(Self: TJvTurtle; var T: Boolean);
begin T := Self.PenDown; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtleHeading_W(Self: TJvTurtle; const T: Real);
begin Self.Heading := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtleHeading_R(Self: TJvTurtle; var T: Real);
begin T := Self.Heading; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtleArea_W(Self: TJvTurtle; const T: TRect);
begin Self.Area := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtleArea_R(Self: TJvTurtle; var T: TRect);
begin T := Self.Area; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtleMark_W(Self: TJvTurtle; const T: TPoint);
begin Self.Mark := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtleMark_R(Self: TJvTurtle; var T: TPoint);
begin T := Self.Mark; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtlePosition_W(Self: TJvTurtle; const T: TPoint);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtlePosition_R(Self: TJvTurtle; var T: TPoint);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtleCanvas_W(Self: TJvTurtle; const T: TCanvas);
begin Self.Canvas := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTurtleCanvas_R(Self: TJvTurtle; var T: TCanvas);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvTurtle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvTurtle) do begin
    RegisterPropertyHelper(@TJvTurtleCanvas_R,@TJvTurtleCanvas_W,'Canvas');
    RegisterPropertyHelper(@TJvTurtlePosition_R,@TJvTurtlePosition_W,'Position');
    RegisterPropertyHelper(@TJvTurtleMark_R,@TJvTurtleMark_W,'Mark');
    RegisterPropertyHelper(@TJvTurtleArea_R,@TJvTurtleArea_W,'Area');
    RegisterPropertyHelper(@TJvTurtleHeading_R,@TJvTurtleHeading_W,'Heading');
    RegisterPropertyHelper(@TJvTurtlePenDown_R,@TJvTurtlePenDown_W,'PenDown');
    RegisterPropertyHelper(@TJvTurtlePenWidth_R,@TJvTurtlePenWidth_W,'PenWidth');
    RegisterPropertyHelper(@TJvTurtlePenColor_R,@TJvTurtlePenColor_W,'PenColor');
    RegisterMethod(@TJvTurtle.DoCom, 'DoCom');
    RegisterMethod(@TJvTurtle.SetPos, 'SetPos');
    RegisterMethod(@TJvTurtle.Turn, 'Turn');
    RegisterMethod(@TJvTurtle.Right, 'Right');
    RegisterMethod(@TJvTurtle.Left, 'Left');
    RegisterMethod(@TJvTurtle.MoveForward, 'MoveForward');
    RegisterMethod(@TJvTurtle.MoveBackward, 'MoveBackward');
    RegisterMethod(@TJvTurtle.Interpret, 'Interpret');
    RegisterConstructor(@TJvTurtle.Create, 'Create');
    RegisterMethod(@TJvTurtle.Destroy, 'Free');
    RegisterPropertyHelper(@TJvTurtleOnRepaintRequest_R,@TJvTurtleOnRepaintRequest_W,'OnRepaintRequest');
    RegisterPropertyHelper(@TJvTurtleOnRequestBackground_R,@TJvTurtleOnRequestBackground_W,'OnRequestBackground');
    RegisterPropertyHelper(@TJvTurtleOnRequestFilter_R,@TJvTurtleOnRequestFilter_W,'OnRequestFilter');
    RegisterPropertyHelper(@TJvTurtleOnRequestImageSize_R,@TJvTurtleOnRequestImageSize_W,'OnRequestImageSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvTurtle(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvTurtle(CL);
end;

 
 
{ TPSImport_JvTurtle }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvTurtle.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvTurtle(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvTurtle.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvTurtle(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
