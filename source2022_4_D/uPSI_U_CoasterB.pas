unit uPSI_U_CoasterB;
{
coaster simulator with splines  - tcoasterRealPoint
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
  TPSImport_U_CoasterB = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCoaster(CL: TPSPascalCompiler);
procedure SIRegister_TcoasterCircle(CL: TPSPascalCompiler);
procedure SIRegister_TcoasterLine(CL: TPSPascalCompiler);
procedure SIRegister_U_CoasterB(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCoaster(CL: TPSRuntimeClassImporter);
procedure RIRegister_TcoasterCircle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TcoasterLine(CL: TPSRuntimeClassImporter);
procedure RIRegister_U_CoasterB(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Forms
  ,windows
  ,controls
  ,graphics
  ,extctrls
  ,stdctrls
  ,mmsystem
  ,menus
  ,contnrs
  ,U_splines
  ,U_CoasterB
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_U_CoasterB]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCoaster(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPaintbox', 'TCoaster') do
  with CL.AddClassN(CL.FindClass('TPaintbox'),'TCoaster') do
  begin
    RegisterProperty('bspline', 'TBSpline', iptrw);
    RegisterProperty('cxmin', 'single', iptrw);
    RegisterProperty('cxmax', 'single', iptrw);
    RegisterProperty('cymin', 'single', iptrw);
    RegisterProperty('cymax', 'single', iptrw);
    RegisterProperty('rpoints', 'TTrackPointArray', iptrw);
    RegisterProperty('nbrpoints', 'integer', iptrw);
    RegisterProperty('chainto', 'single', iptrw);
    RegisterProperty('brakefrom', 'single', iptrw);
    RegisterProperty('chainpoint', 'integer', iptrw);
    RegisterProperty('scale', 'single', iptrw);
    RegisterProperty('time', 'single', iptrw);
    RegisterProperty('designmode', 'boolean', iptrw);
    RegisterProperty('modified', 'boolean', iptrw);
    RegisterProperty('cartready', 'boolean', iptrw);
    RegisterProperty('mass', 'single', iptrw);
    RegisterProperty('friction', 'single', iptrw);
    RegisterProperty('theta', 'single', iptrw);
    RegisterProperty('vx', 'single', iptrw);
    RegisterProperty('vy', 'single', iptrw);
    RegisterProperty('an', 'single', iptrw);
    RegisterProperty('timescale', 'single', iptrw);
    RegisterProperty('timestep', 'single', iptrw);
    RegisterProperty('Savebg', 'TBitmap', iptrw);
    RegisterProperty('imagecopy', 'TBitmap', iptrw);
    RegisterProperty('saverect', 'TRect', iptrw);
    RegisterProperty('moverect', 'TRect', iptrw);
    RegisterProperty('rec', 'TTrackrec', iptrw);
    RegisterProperty('msdelay', 'integer', iptrw);
    RegisterProperty('offtrack', 'boolean', iptrw);
    RegisterProperty('constrained', 'boolean', iptrw);
    RegisterProperty('flyheight', 'single', iptrw);
    RegisterProperty('onchain', 'boolean', iptrw);
    RegisterProperty('brakepoint', 'single', iptrw);
    RegisterProperty('maxfly', 'integer', iptrw);
    RegisterProperty('g', 'single', iptrw);
    RegisterProperty('fward', 'boolean', iptrw);
    RegisterProperty('ouchresources', 'ARRsoundstr', iptrw);
    RegisterProperty('nbrOuchfiles', 'integer', iptrw);
    RegisterProperty('playRunsounds', 'boolean', iptrw);
    RegisterProperty('PlayFallSounds', 'boolean', iptrw);
    RegisterProperty('carts', 'TCartLocRecArray', iptrw);
    RegisterProperty('Poslbl', 'TLabel', iptrw);
    RegisterMethod('Function GetXVal : single');
    RegisterMethod('Procedure SetXVal( Value : single)');
    RegisterMethod('Function GetYVal : single');
    RegisterMethod('Procedure SetYVal( Value : single)');
    RegisterMethod('Function GetV : single');
    RegisterMethod('Procedure SetV( Value : single)');
    RegisterMethod('Function GetDistance : single');
    RegisterMethod('Procedure SetDistance( Value : single)');
    RegisterMethod('Function GetA : single');
    RegisterMethod('Procedure SetA( Value : single)');
    RegisterMethod('Function GetCartx : single');
    RegisterMethod('Procedure SetCartX( value : single)');
    RegisterMethod('Function GetCarty : single');
    RegisterMethod('Procedure SetCarty( value : single)');
    RegisterMethod('Procedure SetNbrCarts( value : integer)');
    RegisterMethod('Function GetVZero : single');
    RegisterMethod('Procedure SetVZero( value : single)');
    RegisterMethod('Function GetGravity : single');
    RegisterMethod('Procedure SetGravity( value : single)');
    RegisterMethod('Procedure SetSkyline( value : integer)');
    RegisterMethod('Procedure settimestep( timeinc : single)');
    RegisterMethod('Procedure setTimeScale( newtimescale : single)');
    RegisterMethod('Procedure setfriction( newfriction : single)');
    RegisterMethod('Procedure setMass( newMass : single)');
    RegisterMethod('Procedure setConstrained( newConstrained : boolean)');
    RegisterMethod('Procedure SetXMax( value : single)');
    RegisterMethod('Procedure SetXMin( value : single)');
    RegisterMethod('Procedure SetYMax( value : single)');
    RegisterMethod('Procedure SetYMin( value : single)');
    RegisterProperty('xval', 'single', iptrw);
    RegisterProperty('yval', 'single', iptrw);
    RegisterProperty('Cartx', 'single', iptrw);
    RegisterProperty('Carty', 'single', iptrw);
    RegisterProperty('NbrCarts', 'integer', iptrw);
    RegisterProperty('VZero', 'single', iptrw);
    RegisterProperty('Gravity', 'single', iptrw);
    RegisterProperty('V', 'single', iptrw);
    RegisterProperty('Distance', 'single', iptrw);
    RegisterProperty('A', 'single', iptrw);
    RegisterProperty('Yskyline', 'integer', iptrw);
    RegisterProperty('xmin', 'single', iptrw);
    RegisterProperty('ymin', 'single', iptrw);
    RegisterProperty('xmax', 'single', iptrw);
    RegisterProperty('ymax', 'single', iptrw);
    RegisterMethod('Constructor create( newImage : TPaintbox)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure paintAll( sender : TObject)');
    RegisterMethod('Procedure Addpoint( newx, newy : integer)');
    RegisterMethod('Procedure finalize');
    RegisterMethod('Function getNextPosition( var rec : TTrackRec; dist : single) : boolean');
    RegisterMethod('Procedure SaveToStream( st : TStream)');
    RegisterMethod('Procedure LoadFromStream( st : TStream)');
    RegisterMethod('Procedure init( newmaxfly : integer)');
    RegisterMethod('Function steptime : boolean');
    RegisterMethod('Function PixelToVirtual( x, y : single) : tcoasterRealPoint');
    RegisterMethod('Function VirtualToPixel( x, y : single) : tcoasterRealPoint');
    RegisterMethod('Procedure Drawpoints( nbrsegs : integer)');
    RegisterMethod('Procedure drawfield');
    RegisterMethod('Procedure drawcart');
    RegisterMethod('Procedure rescale( newcxmin, newcxmax, newcymin, newcymax, newxmin, newxmax, newymin, newymax : single)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TcoasterCircle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TcoasterCircle') do
  with CL.AddClassN(CL.FindClass('TObject'),'TcoasterCircle') do
  begin
    RegisterProperty('Center', 'TPoint', iptrw);
    RegisterProperty('Radius', 'integer', iptrw);
    RegisterProperty('NewRadius', 'integer', iptrw);
    RegisterProperty('Newcenter', 'TPoint', iptrw);
    RegisterProperty('pbox', 'TPaintBox', iptrw);
    RegisterMethod('Constructor create( newPBox : TPaintBox)');
    RegisterMethod('Procedure draw');
    RegisterMethod('Procedure savetostream( st : Tstream)');
    RegisterMethod('Procedure loadfromstream( st : Tstream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TcoasterLine(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TcoasterLine') do
  with CL.AddClassN(CL.FindClass('TObject'),'TcoasterLine') do
  begin
    RegisterProperty('L1', 'TPoint', iptrw);
    RegisterProperty('L2', 'TPoint', iptrw);
    RegisterProperty('NewL2', 'TPoint', iptrw);
    RegisterProperty('pbox', 'TPaintBox', iptrw);
    RegisterMethod('Constructor create( newPBox : TPaintBox)');
    RegisterMethod('Procedure draw');
    RegisterMethod('Procedure savetostream( st : Tstream)');
    RegisterMethod('Procedure loadfromstream( st : Tstream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_U_CoasterB(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('float', 'single');
  CL.AddTypeS('tcoasterRealPoint', 'record x : single; y : single; end');
  CL.AddTypeS('TTrackPoint', 'record x : single; y : single; angleright : single; '
   +'sinangleright : single; cosangleright : single; quadrantright : integer; len'
   +'gthright : single; radiusright : single; end');
   CL.AddTypeS('TTrackPointArray', 'array of TTrackPoint');
    //carts', 'array of TCartLocRec'
   CL.AddTypeS('TTrackRec', 'record x : single; y : single; index : integer; distT'
   +'oend : single; quadrant : integer; radius : single; angle : single; sinangle '
   +': single; cosangle : single; end');
  CL.AddTypeS('TCartLocRec', 'record p1 : tpoint; p2 : tpoint; p3 : tpoint; p4 '
   +': tpoint; wr : integer; end');
    CL.AddTypeS('TCartLocRecArray', 'array of TCartLocRec');
  CL.AddTypeS('TLoopType', '( Insideloop, Outsideloop, none )');
  CL.AddTypeS('TTemplateMode', '( normal, makeline1, makeline2, makecircle1, ma'
   +'kecircle2, movecircle )');
  CL.AddTypeS('ARRsoundstr', 'array [0..5] of string');
   //type ARRstr = array [0..5] of string;
  SIRegister_TcoasterLine(CL);
  SIRegister_TcoasterCircle(CL);
  SIRegister_TCoaster(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCoasterymax_W(Self: TCoaster; const T: single);
begin Self.ymax := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterymax_R(Self: TCoaster; var T: single);
begin T := Self.ymax; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterxmax_W(Self: TCoaster; const T: single);
begin Self.xmax := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterxmax_R(Self: TCoaster; var T: single);
begin T := Self.xmax; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterymin_W(Self: TCoaster; const T: single);
begin Self.ymin := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterymin_R(Self: TCoaster; var T: single);
begin T := Self.ymin; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterxmin_W(Self: TCoaster; const T: single);
begin Self.xmin := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterxmin_R(Self: TCoaster; var T: single);
begin T := Self.xmin; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterYskyline_W(Self: TCoaster; const T: integer);
begin Self.Yskyline := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterYskyline_R(Self: TCoaster; var T: integer);
begin T := Self.Yskyline; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterA_W(Self: TCoaster; const T: single);
begin Self.A := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterA_R(Self: TCoaster; var T: single);
begin T := Self.A; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterDistance_W(Self: TCoaster; const T: single);
begin Self.Distance := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterDistance_R(Self: TCoaster; var T: single);
begin T := Self.Distance; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterV_W(Self: TCoaster; const T: single);
begin Self.V := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterV_R(Self: TCoaster; var T: single);
begin T := Self.V; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterGravity_W(Self: TCoaster; const T: single);
begin Self.Gravity := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterGravity_R(Self: TCoaster; var T: single);
begin T := Self.Gravity; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterVZero_W(Self: TCoaster; const T: single);
begin Self.VZero := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterVZero_R(Self: TCoaster; var T: single);
begin T := Self.VZero; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterNbrCarts_W(Self: TCoaster; const T: integer);
begin Self.NbrCarts := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterNbrCarts_R(Self: TCoaster; var T: integer);
begin T := Self.NbrCarts; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterCarty_W(Self: TCoaster; const T: single);
begin Self.Carty := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterCarty_R(Self: TCoaster; var T: single);
begin T := Self.Carty; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterCartx_W(Self: TCoaster; const T: single);
begin Self.Cartx := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterCartx_R(Self: TCoaster; var T: single);
begin T := Self.Cartx; end;

(*----------------------------------------------------------------------------*)
procedure TCoasteryval_W(Self: TCoaster; const T: single);
begin Self.yval := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasteryval_R(Self: TCoaster; var T: single);
begin T := Self.yval; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterxval_W(Self: TCoaster; const T: single);
begin Self.xval := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterxval_R(Self: TCoaster; var T: single);
begin T := Self.xval; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterPoslbl_W(Self: TCoaster; const T: TLabel);
Begin Self.Poslbl := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterPoslbl_R(Self: TCoaster; var T: TLabel);
Begin T := Self.Poslbl; end;

(*----------------------------------------------------------------------------*)
procedure TCoastercarts_W(Self: TCoaster; const T: array of TCartLocRec);
Begin //Self.carts := T;
end;

(*----------------------------------------------------------------------------*)
procedure TCoastercarts_R(Self: TCoaster; var T: array of TCartLocRec);
Begin //T := Self.carts;
end;

(*----------------------------------------------------------------------------*)
procedure TCoasterPlayFallSounds_W(Self: TCoaster; const T: boolean);
Begin Self.PlayFallSounds := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterPlayFallSounds_R(Self: TCoaster; var T: boolean);
Begin T := Self.PlayFallSounds; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterplayRunsounds_W(Self: TCoaster; const T: boolean);
Begin Self.playRunsounds := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterplayRunsounds_R(Self: TCoaster; var T: boolean);
Begin T := Self.playRunsounds; end;

(*----------------------------------------------------------------------------*)
procedure TCoasternbrOuchfiles_W(Self: TCoaster; const T: integer);
Begin Self.nbrOuchfiles := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasternbrOuchfiles_R(Self: TCoaster; var T: integer);
Begin T := Self.nbrOuchfiles; end;

//type arrstr = array [0..5] of string;

(*----------------------------------------------------------------------------*)
procedure TCoasterouchresources_W(Self: TCoaster; const T: ARRsoundstr );
Begin Self.ouchresources := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterouchresources_R(Self: TCoaster; var T: ARRsoundstr);
Begin T := Self.ouchresources; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterfward_W(Self: TCoaster; const T: boolean);
Begin Self.fward := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterfward_R(Self: TCoaster; var T: boolean);
Begin T := Self.fward; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterg_W(Self: TCoaster; const T: single);
Begin Self.g := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterg_R(Self: TCoaster; var T: single);
Begin T := Self.g; end;

(*----------------------------------------------------------------------------*)
procedure TCoastermaxfly_W(Self: TCoaster; const T: integer);
Begin Self.maxfly := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoastermaxfly_R(Self: TCoaster; var T: integer);
Begin T := Self.maxfly; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterbrakepoint_W(Self: TCoaster; const T: single);
Begin Self.brakepoint := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterbrakepoint_R(Self: TCoaster; var T: single);
Begin T := Self.brakepoint; end;

(*----------------------------------------------------------------------------*)
procedure TCoasteronchain_W(Self: TCoaster; const T: boolean);
Begin Self.onchain := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasteronchain_R(Self: TCoaster; var T: boolean);
Begin T := Self.onchain; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterflyheight_W(Self: TCoaster; const T: single);
Begin Self.flyheight := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterflyheight_R(Self: TCoaster; var T: single);
Begin T := Self.flyheight; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterconstrained_W(Self: TCoaster; const T: boolean);
Begin Self.constrained := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterconstrained_R(Self: TCoaster; var T: boolean);
Begin T := Self.constrained; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterofftrack_W(Self: TCoaster; const T: boolean);
Begin Self.offtrack := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterofftrack_R(Self: TCoaster; var T: boolean);
Begin T := Self.offtrack; end;

(*----------------------------------------------------------------------------*)
procedure TCoastermsdelay_W(Self: TCoaster; const T: integer);
Begin Self.msdelay := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoastermsdelay_R(Self: TCoaster; var T: integer);
Begin T := Self.msdelay; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterrec_W(Self: TCoaster; const T: TTrackrec);
Begin Self.rec := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterrec_R(Self: TCoaster; var T: TTrackrec);
Begin T := Self.rec; end;

(*----------------------------------------------------------------------------*)
procedure TCoastermoverect_W(Self: TCoaster; const T: TRect);
Begin Self.moverect := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoastermoverect_R(Self: TCoaster; var T: TRect);
Begin T := Self.moverect; end;

(*----------------------------------------------------------------------------*)
procedure TCoastersaverect_W(Self: TCoaster; const T: TRect);
Begin Self.saverect := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoastersaverect_R(Self: TCoaster; var T: TRect);
Begin T := Self.saverect; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterimagecopy_W(Self: TCoaster; const T: TBitmap);
Begin Self.imagecopy := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterimagecopy_R(Self: TCoaster; var T: TBitmap);
Begin T := Self.imagecopy; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterSavebg_W(Self: TCoaster; const T: TBitmap);
Begin Self.Savebg := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterSavebg_R(Self: TCoaster; var T: TBitmap);
Begin T := Self.Savebg; end;

(*----------------------------------------------------------------------------*)
procedure TCoastertimestep_W(Self: TCoaster; const T: single);
Begin Self.timestep := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoastertimestep_R(Self: TCoaster; var T: single);
Begin T := Self.timestep; end;

(*----------------------------------------------------------------------------*)
procedure TCoastertimescale_W(Self: TCoaster; const T: single);
Begin Self.timescale := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoastertimescale_R(Self: TCoaster; var T: single);
Begin T := Self.timescale; end;

(*----------------------------------------------------------------------------*)
procedure TCoasteran_W(Self: TCoaster; const T: single);
Begin Self.an := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasteran_R(Self: TCoaster; var T: single);
Begin T := Self.an; end;

(*----------------------------------------------------------------------------*)
procedure TCoastervy_W(Self: TCoaster; const T: single);
Begin Self.vy := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoastervy_R(Self: TCoaster; var T: single);
Begin T := Self.vy; end;

(*----------------------------------------------------------------------------*)
procedure TCoastervx_W(Self: TCoaster; const T: single);
Begin Self.vx := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoastervx_R(Self: TCoaster; var T: single);
Begin T := Self.vx; end;

(*----------------------------------------------------------------------------*)
procedure TCoastertheta_W(Self: TCoaster; const T: single);
Begin Self.theta := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoastertheta_R(Self: TCoaster; var T: single);
Begin T := Self.theta; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterfriction_W(Self: TCoaster; const T: single);
Begin Self.friction := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterfriction_R(Self: TCoaster; var T: single);
Begin T := Self.friction; end;

(*----------------------------------------------------------------------------*)
procedure TCoastermass_W(Self: TCoaster; const T: single);
Begin Self.mass := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoastermass_R(Self: TCoaster; var T: single);
Begin T := Self.mass; end;

(*----------------------------------------------------------------------------*)
procedure TCoastercartready_W(Self: TCoaster; const T: boolean);
Begin Self.cartready := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoastercartready_R(Self: TCoaster; var T: boolean);
Begin T := Self.cartready; end;

(*----------------------------------------------------------------------------*)
procedure TCoastermodified_W(Self: TCoaster; const T: boolean);
Begin Self.modified := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoastermodified_R(Self: TCoaster; var T: boolean);
Begin T := Self.modified; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterdesignmode_W(Self: TCoaster; const T: boolean);
Begin Self.designmode := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterdesignmode_R(Self: TCoaster; var T: boolean);
Begin T := Self.designmode; end;

(*----------------------------------------------------------------------------*)
procedure TCoastertime_W(Self: TCoaster; const T: single);
Begin Self.time := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoastertime_R(Self: TCoaster; var T: single);
Begin T := Self.time; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterscale_W(Self: TCoaster; const T: single);
Begin Self.scale := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterscale_R(Self: TCoaster; var T: single);
Begin T := Self.scale; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterchainpoint_W(Self: TCoaster; const T: integer);
Begin Self.chainpoint := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterchainpoint_R(Self: TCoaster; var T: integer);
Begin T := Self.chainpoint; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterbrakefrom_W(Self: TCoaster; const T: single);
Begin Self.brakefrom := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterbrakefrom_R(Self: TCoaster; var T: single);
Begin T := Self.brakefrom; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterchainto_W(Self: TCoaster; const T: single);
Begin Self.chainto := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterchainto_R(Self: TCoaster; var T: single);
Begin T := Self.chainto; end;

(*----------------------------------------------------------------------------*)
procedure TCoasternbrpoints_W(Self: TCoaster; const T: integer);
Begin Self.nbrpoints := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasternbrpoints_R(Self: TCoaster; var T: integer);
Begin T := Self.nbrpoints; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterrpoints_W(Self: TCoaster; const T: array of TTrackPoint);
Begin //Self.rpoints := T;
end;

(*----------------------------------------------------------------------------*)
procedure TCoasterrpoints_R(Self: TCoaster; var T: array of TTrackPoint);
Begin //T := Self.rpoints;
end;

(*----------------------------------------------------------------------------*)
procedure TCoastercymax_W(Self: TCoaster; const T: single);
Begin Self.cymax := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoastercymax_R(Self: TCoaster; var T: single);
Begin T := Self.cymax; end;

(*----------------------------------------------------------------------------*)
procedure TCoastercymin_W(Self: TCoaster; const T: single);
Begin Self.cymin := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoastercymin_R(Self: TCoaster; var T: single);
Begin T := Self.cymin; end;

(*----------------------------------------------------------------------------*)
procedure TCoastercxmax_W(Self: TCoaster; const T: single);
Begin Self.cxmax := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoastercxmax_R(Self: TCoaster; var T: single);
Begin T := Self.cxmax; end;

(*----------------------------------------------------------------------------*)
procedure TCoastercxmin_W(Self: TCoaster; const T: single);
Begin Self.cxmin := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoastercxmin_R(Self: TCoaster; var T: single );
Begin T := Self.cxmin; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterbspline_W(Self: TCoaster; const T: TBSpline);
Begin Self.bspline := T; end;

(*----------------------------------------------------------------------------*)
procedure TCoasterbspline_R(Self: TCoaster; var T: TBSpline);
Begin T := Self.bspline; end;

(*----------------------------------------------------------------------------*)
Procedure TCoastermakelbl1_P(Self: TCoaster;  c : TObject);
Begin //Self.makelbl(c);
END;

(*----------------------------------------------------------------------------*)
Procedure TCoastermakelbl_P(Self: TCoaster;  x, y : integer);
Begin //Self.makelbl(x, y);
END;

(*----------------------------------------------------------------------------*)
procedure TcoasterCirclepbox_W(Self: TcoasterCircle; const T: TPaintBox);
Begin Self.pbox := T; end;

(*----------------------------------------------------------------------------*)
procedure TcoasterCirclepbox_R(Self: TcoasterCircle; var T: TPaintBox);
Begin T := Self.pbox; end;

(*----------------------------------------------------------------------------*)
procedure TcoasterCircleNewcenter_W(Self: TcoasterCircle; const T: TPoint);
Begin Self.Newcenter := T; end;

(*----------------------------------------------------------------------------*)
procedure TcoasterCircleNewcenter_R(Self: TcoasterCircle; var T: TPoint);
Begin T := Self.Newcenter; end;

(*----------------------------------------------------------------------------*)
procedure TcoasterCircleNewRadius_W(Self: TcoasterCircle; const T: integer);
Begin Self.NewRadius := T; end;

(*----------------------------------------------------------------------------*)
procedure TcoasterCircleNewRadius_R(Self: TcoasterCircle; var T: integer);
Begin T := Self.NewRadius; end;

(*----------------------------------------------------------------------------*)
procedure TcoasterCircleRadius_W(Self: TcoasterCircle; const T: integer);
Begin Self.Radius := T; end;

(*----------------------------------------------------------------------------*)
procedure TcoasterCircleRadius_R(Self: TcoasterCircle; var T: integer);
Begin T := Self.Radius; end;

(*----------------------------------------------------------------------------*)
procedure TcoasterCircleCenter_W(Self: TcoasterCircle; const T: TPoint);
Begin Self.Center := T; end;

(*----------------------------------------------------------------------------*)
procedure TcoasterCircleCenter_R(Self: TcoasterCircle; var T: TPoint);
Begin T := Self.Center; end;

(*----------------------------------------------------------------------------*)
procedure TcoasterLinepbox_W(Self: TcoasterLine; const T: TPaintBox);
Begin Self.pbox := T; end;

(*----------------------------------------------------------------------------*)
procedure TcoasterLinepbox_R(Self: TcoasterLine; var T: TPaintBox);
Begin T := Self.pbox; end;

(*----------------------------------------------------------------------------*)
procedure TcoasterLineNewL2_W(Self: TcoasterLine; const T: TPoint);
Begin Self.NewL2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TcoasterLineNewL2_R(Self: TcoasterLine; var T: TPoint);
Begin T := Self.NewL2; end;

(*----------------------------------------------------------------------------*)
procedure TcoasterLineL2_W(Self: TcoasterLine; const T: TPoint);
Begin Self.L2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TcoasterLineL2_R(Self: TcoasterLine; var T: TPoint);
Begin T := Self.L2; end;

(*----------------------------------------------------------------------------*)
procedure TcoasterLineL1_W(Self: TcoasterLine; const T: TPoint);
Begin Self.L1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TcoasterLineL1_R(Self: TcoasterLine; var T: TPoint);
Begin T := Self.L1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCoaster(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCoaster) do
  begin
    RegisterPropertyHelper(@TCoasterbspline_R,@TCoasterbspline_W,'bspline');
    RegisterPropertyHelper(@TCoastercxmin_R,@TCoastercxmin_W,'cxmin');
    RegisterPropertyHelper(@TCoastercxmax_R,@TCoastercxmax_W,'cxmax');
    RegisterPropertyHelper(@TCoastercymin_R,@TCoastercymin_W,'cymin');
    RegisterPropertyHelper(@TCoastercymax_R,@TCoastercymax_W,'cymax');
    RegisterPropertyHelper(@TCoasterrpoints_R,@TCoasterrpoints_W,'rpoints');
    RegisterPropertyHelper(@TCoasternbrpoints_R,@TCoasternbrpoints_W,'nbrpoints');
    RegisterPropertyHelper(@TCoasterchainto_R,@TCoasterchainto_W,'chainto');
    RegisterPropertyHelper(@TCoasterbrakefrom_R,@TCoasterbrakefrom_W,'brakefrom');
    RegisterPropertyHelper(@TCoasterchainpoint_R,@TCoasterchainpoint_W,'chainpoint');
    RegisterPropertyHelper(@TCoasterscale_R,@TCoasterscale_W,'scale');
    RegisterPropertyHelper(@TCoastertime_R,@TCoastertime_W,'time');
    RegisterPropertyHelper(@TCoasterdesignmode_R,@TCoasterdesignmode_W,'designmode');
    RegisterPropertyHelper(@TCoastermodified_R,@TCoastermodified_W,'modified');
    RegisterPropertyHelper(@TCoastercartready_R,@TCoastercartready_W,'cartready');
    RegisterPropertyHelper(@TCoastermass_R,@TCoastermass_W,'mass');
    RegisterPropertyHelper(@TCoasterfriction_R,@TCoasterfriction_W,'friction');
    RegisterPropertyHelper(@TCoastertheta_R,@TCoastertheta_W,'theta');
    RegisterPropertyHelper(@TCoastervx_R,@TCoastervx_W,'vx');
    RegisterPropertyHelper(@TCoastervy_R,@TCoastervy_W,'vy');
    RegisterPropertyHelper(@TCoasteran_R,@TCoasteran_W,'an');
    RegisterPropertyHelper(@TCoastertimescale_R,@TCoastertimescale_W,'timescale');
    RegisterPropertyHelper(@TCoastertimestep_R,@TCoastertimestep_W,'timestep');
    RegisterPropertyHelper(@TCoasterSavebg_R,@TCoasterSavebg_W,'Savebg');
    RegisterPropertyHelper(@TCoasterimagecopy_R,@TCoasterimagecopy_W,'imagecopy');
    RegisterPropertyHelper(@TCoastersaverect_R,@TCoastersaverect_W,'saverect');
    RegisterPropertyHelper(@TCoastermoverect_R,@TCoastermoverect_W,'moverect');
    RegisterPropertyHelper(@TCoasterrec_R,@TCoasterrec_W,'rec');
    RegisterPropertyHelper(@TCoastermsdelay_R,@TCoastermsdelay_W,'msdelay');
    RegisterPropertyHelper(@TCoasterofftrack_R,@TCoasterofftrack_W,'offtrack');
    RegisterPropertyHelper(@TCoasterconstrained_R,@TCoasterconstrained_W,'constrained');
    RegisterPropertyHelper(@TCoasterflyheight_R,@TCoasterflyheight_W,'flyheight');
    RegisterPropertyHelper(@TCoasteronchain_R,@TCoasteronchain_W,'onchain');
    RegisterPropertyHelper(@TCoasterbrakepoint_R,@TCoasterbrakepoint_W,'brakepoint');
    RegisterPropertyHelper(@TCoastermaxfly_R,@TCoastermaxfly_W,'maxfly');
    RegisterPropertyHelper(@TCoasterg_R,@TCoasterg_W,'g');
    RegisterPropertyHelper(@TCoasterfward_R,@TCoasterfward_W,'fward');
    RegisterPropertyHelper(@TCoasterouchresources_R,@TCoasterouchresources_W,'ouchresources');
    RegisterPropertyHelper(@TCoasternbrOuchfiles_R,@TCoasternbrOuchfiles_W,'nbrOuchfiles');
    RegisterPropertyHelper(@TCoasterplayRunsounds_R,@TCoasterplayRunsounds_W,'playRunsounds');
    RegisterPropertyHelper(@TCoasterPlayFallSounds_R,@TCoasterPlayFallSounds_W,'PlayFallSounds');
    RegisterPropertyHelper(@TCoastercarts_R,@TCoastercarts_W,'carts');
    RegisterPropertyHelper(@TCoasterPoslbl_R,@TCoasterPoslbl_W,'Poslbl');
    RegisterMethod(@TCoaster.GetXVal, 'GetXVal');
    RegisterMethod(@TCoaster.SetXVal, 'SetXVal');
    RegisterMethod(@TCoaster.GetYVal, 'GetYVal');
    RegisterMethod(@TCoaster.SetYVal, 'SetYVal');
    RegisterMethod(@TCoaster.GetV, 'GetV');
    RegisterMethod(@TCoaster.SetV, 'SetV');
    RegisterMethod(@TCoaster.GetDistance, 'GetDistance');
    RegisterMethod(@TCoaster.SetDistance, 'SetDistance');
    RegisterMethod(@TCoaster.GetA, 'GetA');
    RegisterMethod(@TCoaster.SetA, 'SetA');
    RegisterMethod(@TCoaster.GetCartx, 'GetCartx');
    RegisterMethod(@TCoaster.SetCartX, 'SetCartX');
    RegisterMethod(@TCoaster.GetCarty, 'GetCarty');
    RegisterMethod(@TCoaster.SetCarty, 'SetCarty');
    RegisterMethod(@TCoaster.SetNbrCarts, 'SetNbrCarts');
    RegisterMethod(@TCoaster.GetVZero, 'GetVZero');
    RegisterMethod(@TCoaster.SetVZero, 'SetVZero');
    RegisterMethod(@TCoaster.GetGravity, 'GetGravity');
    RegisterMethod(@TCoaster.SetGravity, 'SetGravity');
    RegisterMethod(@TCoaster.SetSkyline, 'SetSkyline');
    RegisterMethod(@TCoaster.settimestep, 'settimestep');
    RegisterMethod(@TCoaster.setTimeScale, 'setTimeScale');
    RegisterMethod(@TCoaster.setfriction, 'setfriction');
    RegisterMethod(@TCoaster.setMass, 'setMass');
    RegisterMethod(@TCoaster.setConstrained, 'setConstrained');
    RegisterMethod(@TCoaster.SetXMax, 'SetXMax');
    RegisterMethod(@TCoaster.SetXMin, 'SetXMin');
    RegisterMethod(@TCoaster.SetYMax, 'SetYMax');
    RegisterMethod(@TCoaster.SetYMin, 'SetYMin');
    RegisterPropertyHelper(@TCoasterxval_R,@TCoasterxval_W,'xval');
    RegisterPropertyHelper(@TCoasteryval_R,@TCoasteryval_W,'yval');
    RegisterPropertyHelper(@TCoasterCartx_R,@TCoasterCartx_W,'Cartx');
    RegisterPropertyHelper(@TCoasterCarty_R,@TCoasterCarty_W,'Carty');
    RegisterPropertyHelper(@TCoasterNbrCarts_R,@TCoasterNbrCarts_W,'NbrCarts');
    RegisterPropertyHelper(@TCoasterVZero_R,@TCoasterVZero_W,'VZero');
    RegisterPropertyHelper(@TCoasterGravity_R,@TCoasterGravity_W,'Gravity');
    RegisterPropertyHelper(@TCoasterV_R,@TCoasterV_W,'V');
    RegisterPropertyHelper(@TCoasterDistance_R,@TCoasterDistance_W,'Distance');
    RegisterPropertyHelper(@TCoasterA_R,@TCoasterA_W,'A');
    RegisterPropertyHelper(@TCoasterYskyline_R,@TCoasterYskyline_W,'Yskyline');
    RegisterPropertyHelper(@TCoasterxmin_R,@TCoasterxmin_W,'xmin');
    RegisterPropertyHelper(@TCoasterymin_R,@TCoasterymin_W,'ymin');
    RegisterPropertyHelper(@TCoasterxmax_R,@TCoasterxmax_W,'xmax');
    RegisterPropertyHelper(@TCoasterymax_R,@TCoasterymax_W,'ymax');
    RegisterConstructor(@TCoaster.create, 'create');
    RegisterMethod(@TCoaster.Destroy, 'Free');
    RegisterMethod(@TCoaster.paintAll, 'paintAll');
    RegisterMethod(@TCoaster.Addpoint, 'Addpoint');
    RegisterMethod(@TCoaster.finalize, 'finalize');
    RegisterMethod(@TCoaster.getNextPosition, 'getNextPosition');
    RegisterMethod(@TCoaster.SaveToStream, 'SaveToStream');
    RegisterMethod(@TCoaster.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TCoaster.init, 'init');
    RegisterMethod(@TCoaster.steptime, 'steptime');
    RegisterMethod(@TCoaster.PixelToVirtual, 'PixelToVirtual');
    RegisterMethod(@TCoaster.VirtualToPixel, 'VirtualToPixel');
    RegisterMethod(@TCoaster.Drawpoints, 'Drawpoints');
    RegisterMethod(@TCoaster.drawfield, 'drawfield');
    RegisterMethod(@TCoaster.drawcart, 'drawcart');
    RegisterMethod(@TCoaster.rescale, 'rescale');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcoasterCircle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcoasterCircle) do
  begin
    RegisterPropertyHelper(@TcoasterCircleCenter_R,@TcoasterCircleCenter_W,'Center');
    RegisterPropertyHelper(@TcoasterCircleRadius_R,@TcoasterCircleRadius_W,'Radius');
    RegisterPropertyHelper(@TcoasterCircleNewRadius_R,@TcoasterCircleNewRadius_W,'NewRadius');
    RegisterPropertyHelper(@TcoasterCircleNewcenter_R,@TcoasterCircleNewcenter_W,'Newcenter');
    RegisterPropertyHelper(@TcoasterCirclepbox_R,@TcoasterCirclepbox_W,'pbox');
    RegisterConstructor(@TcoasterCircle.create, 'create');
    RegisterMethod(@TcoasterCircle.draw, 'draw');
    RegisterMethod(@TcoasterCircle.savetostream, 'savetostream');
    RegisterMethod(@TcoasterCircle.loadfromstream, 'loadfromstream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcoasterLine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcoasterLine) do
  begin
    RegisterPropertyHelper(@TcoasterLineL1_R,@TcoasterLineL1_W,'L1');
    RegisterPropertyHelper(@TcoasterLineL2_R,@TcoasterLineL2_W,'L2');
    RegisterPropertyHelper(@TcoasterLineNewL2_R,@TcoasterLineNewL2_W,'NewL2');
    RegisterPropertyHelper(@TcoasterLinepbox_R,@TcoasterLinepbox_W,'pbox');
    RegisterConstructor(@TcoasterLine.create, 'create');
    RegisterMethod(@TcoasterLine.draw, 'draw');
    RegisterMethod(@TcoasterLine.savetostream, 'savetostream');
    RegisterMethod(@TcoasterLine.loadfromstream, 'loadfromstream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_U_CoasterB(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TcoasterLine(CL);
  RIRegister_TcoasterCircle(CL);
  RIRegister_TCoaster(CL);
end;

 
 
{ TPSImport_U_CoasterB }
(*----------------------------------------------------------------------------*)
procedure TPSImport_U_CoasterB.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_U_CoasterB(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_U_CoasterB.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_U_CoasterB(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
