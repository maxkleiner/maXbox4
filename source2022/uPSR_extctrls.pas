
unit uPSR_extctrls;

// add custom radio methods

{$I PascalScript.inc}
interface
uses
  uPSRuntime, uPSUtils;


procedure RIRegister_ExtCtrls(cl: TPSRuntimeClassImporter);

procedure RIRegisterTSHAPE(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTIMAGE(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTPAINTBOX(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTBEVEL(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTTIMER(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTCUSTOMPANEL(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTPANEL(Cl: TPSRuntimeClassImporter);
{$IFNDEF CLX}
procedure RIRegisterTPAGE(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTNOTEBOOK(Cl: TPSRuntimeClassImporter);
{$IFNDEF FPC}procedure RIRegisterTHEADER(Cl: TPSRuntimeClassImporter);{$ENDIF}
{$ENDIF}
procedure RIRegisterTCUSTOMRADIOGROUP(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTRADIOGROUP(Cl: TPSRuntimeClassImporter);

implementation

uses
  {$IFDEF CLX}
  QExtCtrls, QGraphics;
  {$ELSE}
  ExtCtrls, Graphics, Controls, StdCtrls;
  {$ENDIF}

{procedure TITEMONCLICK_W(Self: TShape; const T: TNOTIFYEVENT);
begin //Self.ONCLICK := T;
 end;
procedure TITEMONCLICK_R(Self: TShape; var T: TNOTIFYEVENT);
begin //T := //Self.ONCLICK;
 end;}
procedure TITEMONMouse_W(Self: TShape; const T: TMouseEvent);
begin Self.ONMouseDown:= T; end;
procedure TITEMONMouse_R(Self: TShape; var T: TMouseEvent);
begin T := Self.OnMouseDown; end;
procedure TITEMONMouse1_W(Self: TImage; const T: TMouseEvent);
begin Self.ONMouseDown:= T; end;
procedure TITEMONMouse1_R(Self: TImage; var T: TMouseEvent);
begin T := Self.OnMouseDown; end;
procedure TITEMONMouse2_W(Self: TPaintBox; const T: TMouseEvent);
begin Self.ONMouseDown:= T; end;
procedure TITEMONMouse2_R(Self: TPaintBox; var T: TMouseEvent);
begin T := Self.OnMouseDown; end;


procedure RIRegisterTSHAPE(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TSHAPE) do begin
    {$IFNDEF PS_MINIVCL}
    RegisterMethod(@TSHAPE.STYLECHANGED, 'STYLECHANGED');
    //RegisterMethod(@TSHAPE.SCALEBY, 'SCALEBY');
      RegisterConstructor(@TSHAPE.Create, 'Create');
   RegisterMethod(@TSHAPE.Free, 'Free');
 		//RegisterEventPropertyHelper(@TITEMONCLICK_R,@TITEMONCLICK_W,'ONCLICK');
		RegisterEventPropertyHelper(@TITEMONMouse_R,@TITEMONMouse_W,'ONMouseDown');

    {$ENDIF}
  end;
end;

procedure TIMAGECANVAS_R(Self: TIMAGE; var T: TCANVAS); begin T := Self.CANVAS; end;

procedure RIRegisterTIMAGE(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TIMAGE) do begin
    RegisterConstructor(@TImage.Create, 'Create');
    RegisterMethod(@TImage.Destroy, 'Free');
    RegisterPropertyHelper(@TIMAGECANVAS_R, nil, 'CANVAS');
 		RegisterEventPropertyHelper(@TITEMONMouse1_R,@TITEMONMouse1_W,'ONMouseDown');
  end;
end;

procedure TPAINTBOXCANVAS_R(Self: TPAINTBOX; var T: TCanvas); begin T := Self.CANVAS; end;

procedure RIRegisterTPAINTBOX(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TPAINTBOX) do begin
    RegisterConstructor(@TPAINTBOX.Create, 'Create');
     RegisterPropertyHelper(@TPAINTBOXCANVAS_R, nil, 'CANVAS');
		RegisterEventPropertyHelper(@TITEMONMouse2_R,@TITEMONMouse2_W,'ONMouseDown');
  end;
end;

procedure RIRegisterTBEVEL(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TBEVEL) do begin
     RegisterConstructor(@TBEVEL.Create, 'Create');
   end;
end;

procedure RIRegisterTTIMER(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TTIMER) do begin
   RegisterConstructor(@TTIMER.Create, 'Create');
  RegisterMethod(@TTIMER.Free, 'Free');
 end;
end;        

procedure RIRegisterTCUSTOMPANEL(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TCUSTOMPANEL) do begin
  RegisterConstructor(@TCUSTOMPANEL.Create, 'Create');
  //RegisterMethod(@TCUSTOMMEMO.Free, 'Free');
  RegisterMethod(@TCUSTOMPANEL.GetControlsAlignment, 'GetControlsAlignment');
 end;
end;

procedure RIRegisterTPANEL(Cl: TPSRuntimeClassImporter);
begin
  Cl.Add(TPANEL);
end;
{$IFNDEF CLX}
procedure RIRegisterTPAGE(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TPAGE) do
    RegisterConstructor(@TPAGE.Create, 'Create');
end;

procedure RIRegisterTNOTEBOOK(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TNOTEBOOK) do begin
     RegisterConstructor(@TNOTEBOOK.Create, 'Create');
     RegisterMethod(@TNOTEBOOK.Free, 'Free');
   end;
end;

{$IFNDEF FPC}
procedure THEADERSECTIONWIDTH_R(Self: THEADER; var T: INTEGER; t1: INTEGER); begin T := Self.SECTIONWIDTH[t1]; end;
procedure THEADERSECTIONWIDTH_W(Self: THEADER; T: INTEGER; t1: INTEGER); begin Self.SECTIONWIDTH[t1] := T; end;

procedure RIRegisterTHEADER(Cl: TPSRuntimeClassImporter);
begin
	with Cl.Add(THEADER) do begin
     RegisterConstructor(@THEADER.Create, 'Create');
     RegisterMethod(@THEADER.Free, 'Free');
  	RegisterPropertyHelper(@THEADERSECTIONWIDTH_R, @THEADERSECTIONWIDTH_W, 'SECTIONWIDTH');
	end;
end;
{$ENDIF}
{$ENDIF}


(*----------------------------------------------------------------------------*)
procedure TCustomRadioGroupButtons_R(Self: TCustomRadioGroup; var T: TRadioButton; const t1: Integer);
begin T := Self.Buttons[t1]; end;


procedure RIRegisterTCUSTOMRADIOGROUP(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TCUSTOMRADIOGROUP) do  //CL.Add(TCustomRadioGroup)
  begin
    RegisterConstructor(@TCustomRadioGroup.Create, 'Create');
     RegisterMethod(@TCustomRadioGroup.Free, 'Free');
    RegisterMethod(@TCustomRadioGroup.FlipChildren, 'FlipChildren');
    RegisterPropertyHelper(@TCustomRadioGroupButtons_R,nil,'Buttons');
  end;
end;

procedure RIRegisterTRADIOGROUP(Cl: TPSRuntimeClassImporter);
begin
  Cl.Add(TRADIOGROUP);
end;

procedure RIRegister_ExtCtrls(cl: TPSRuntimeClassImporter);
begin
  {$IFNDEF PS_MINIVCL}
  RIRegisterTSHAPE(Cl);
  RIRegisterTIMAGE(Cl);
  RIRegisterTPAINTBOX(Cl);
  {$ENDIF}
  RIRegisterTBEVEL(Cl);
  {$IFNDEF PS_MINIVCL}
  RIRegisterTTIMER(Cl);
  {$ENDIF}
  RIRegisterTCUSTOMPANEL(Cl);
{$IFNDEF CLX}
  RIRegisterTPANEL(Cl);
{$ENDIF}
  {$IFNDEF PS_MINIVCL}
{$IFNDEF CLX}
  RIRegisterTPAGE(Cl);
	RIRegisterTNOTEBOOK(Cl);
 {$IFNDEF FPC}
	RIRegisterTHEADER(Cl);
 {$ENDIF}{FPC}
{$ENDIF}
  RIRegisterTCUSTOMRADIOGROUP(Cl);
  RIRegisterTRADIOGROUP(Cl);
  {$ENDIF}
end;

end.


