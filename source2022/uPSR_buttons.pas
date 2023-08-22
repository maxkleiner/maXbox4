
unit uPSR_buttons;
{$I PascalScript.inc}
interface
uses
  uPSRuntime, uPSUtils;


procedure RIRegisterTSPEEDBUTTON(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTBITBTN(Cl: TPSRuntimeClassImporter);
procedure RIRegister_TBitBtnActionLink(CL: TPSRuntimeClassImporter);

procedure RIRegister_Buttons(Cl: TPSRuntimeClassImporter);
procedure RIRegister_Buttons_Routines(S: TPSExec);


implementation
uses
  Classes{$IFDEF CLX}, QControls, QButtons{$ELSE}, Controls, Buttons{$ENDIF};

(*----------------------------------------------------------------------------*)
procedure TSpeedButtonTransparent_W(Self: TSpeedButton; const T: Boolean);
begin Self.Transparent := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpeedButtonTransparent_R(Self: TSpeedButton; var T: Boolean);
begin T := Self.Transparent; end;


procedure RIRegisterTSPEEDBUTTON(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TSPEEDBUTTON) do begin
    RegisterConstructor(@TSPEEDBUTTON.Create, 'Create');
    RegisterMethod(@TSPEEDBUTTON.Free, 'Free');
    RegisterMethod(@TSPEEDBUTTON.Click, 'Click');
    //RegisterProperty('Transparent', 'Boolean', iptrw);
    RegisterPropertyHelper(@TSpeedButtonTransparent_R,@TSpeedButtonTransparent_W,'Transparent');
  end;
end;


procedure RIRegisterTBITBTN(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TBITBTN) do begin
    RegisterConstructor(@TBITBTN.Create, 'Create');
    RegisterMethod(@TBITBTN.Free, 'Free');
    RegisterMethod(@TBITBTN.Click, 'Click');
  end;

end;

procedure RIRegister_TBitBtnActionLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBitBtnActionLink) do begin
    RegisterMethod(@TBitBtnActionLink.Free, 'Free');
  end;
end;


procedure RIRegister_Buttons(Cl: TPSRuntimeClassImporter);
begin
  RIRegisterTSPEEDBUTTON(cl);
   with CL.Add(TBitBtn) do
  RIRegister_TBitBtnActionLink(CL);
   RIRegisterTBITBTN(cl);
end;

procedure RIRegister_Buttons_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DrawButtonFace, 'DrawButtonFace', cdRegister);
end;


// PS_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)


end.
