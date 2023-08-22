unit uPSI_Textures;
{
  openGL
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
  TPSImport_Textures = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TVoidTextureRGBA(CL: TPSPascalCompiler);
procedure SIRegister_TTextureRGBA(CL: TPSPascalCompiler);
procedure SIRegister_TVoidTexture(CL: TPSPascalCompiler);
procedure SIRegister_TTexture(CL: TPSPascalCompiler);
procedure SIRegister_Textures(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TVoidTextureRGBA(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTextureRGBA(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVoidTexture(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTexture(CL: TPSRuntimeClassImporter);
procedure RIRegister_Textures(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Textures
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Textures]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TVoidTextureRGBA(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'tobject', 'TVoidTextureRGBA') do
  with CL.AddClassN(CL.FindClass('tobject'),'TVoidTextureRGBA') do
  begin
    RegisterProperty('ID', 'integer', iptrw);
    RegisterProperty('width', 'integer', iptrw);
    RegisterProperty('height', 'integer', iptrw);
    RegisterProperty('pixels', 'pRGBAlist', iptrw);
    RegisterMethod('Constructor create( tid, twidth, theight : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTextureRGBA(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTexture', 'TTextureRGBA') do
  with CL.AddClassN(CL.FindClass('TTexture'),'TTextureRGBA') do
  begin
    RegisterProperty('pixels', 'pRGBAlist', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TVoidTexture(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'tobject', 'TVoidTexture') do
  with CL.AddClassN(CL.FindClass('tobject'),'TVoidTexture') do
  begin
    RegisterProperty('ID', 'integer', iptrw);
    RegisterProperty('width', 'integer', iptrw);
    RegisterProperty('height', 'integer', iptrw);
    RegisterProperty('pixels', 'pRGBlist', iptrw);
    RegisterMethod('Constructor create( tid, twidth, theight : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTexture(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'tobject', 'TTexture') do
  with CL.AddClassN(CL.FindClass('tobject'),'TTexture') do
  begin
    RegisterProperty('ID', 'integer', iptrw);
    RegisterProperty('width', 'integer', iptrw);
    RegisterProperty('height', 'integer', iptrw);
    RegisterProperty('pixels', 'pRGBlist', iptrw);
    RegisterMethod('Constructor Load( tID : integer; filename : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Textures(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MYINT1','LongInt').SetInt( 2147483647);
 CL.AddConstantN('MYINT2','LongWord').SetUInt( 4294967295);
 CL.AddConstantN('MYLONGWORD','LongWord').SetUInt( 4294967295);
  CL.AddTypeS('TColorRGB', 'record r : byte; g : byte; b : BYTE; end');
  //CL.AddTypeS('PColorRGB', '^TColorRGB // will not work');
  //CL.AddTypeS('pRGBList', '^TRGBList // will not work');
  CL.AddTypeS('TColorRGBA', 'record r : byte; g : byte; b : byte; a : BYTE; end');
  //CL.AddTypeS('PColorRGBA', '^TColorRGBA // will not work');
  //CL.AddTypeS('PRGBAList', '^TRGBAList // will not work');
  SIRegister_TTexture(CL);
  SIRegister_TVoidTexture(CL);
  SIRegister_TTextureRGBA(CL);
  SIRegister_TVoidTextureRGBA(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TVoidTextureRGBApixels_W(Self: TVoidTextureRGBA; const T: pRGBAlist);
Begin Self.pixels := T; end;

(*----------------------------------------------------------------------------*)
procedure TVoidTextureRGBApixels_R(Self: TVoidTextureRGBA; var T: pRGBAlist);
Begin T := Self.pixels; end;

(*----------------------------------------------------------------------------*)
procedure TVoidTextureRGBAheight_W(Self: TVoidTextureRGBA; const T: integer);
Begin Self.height := T; end;

(*----------------------------------------------------------------------------*)
procedure TVoidTextureRGBAheight_R(Self: TVoidTextureRGBA; var T: integer);
Begin T := Self.height; end;

(*----------------------------------------------------------------------------*)
procedure TVoidTextureRGBAwidth_W(Self: TVoidTextureRGBA; const T: integer);
Begin Self.width := T; end;

(*----------------------------------------------------------------------------*)
procedure TVoidTextureRGBAwidth_R(Self: TVoidTextureRGBA; var T: integer);
Begin T := Self.width; end;

(*----------------------------------------------------------------------------*)
procedure TVoidTextureRGBAID_W(Self: TVoidTextureRGBA; const T: integer);
Begin Self.ID := T; end;

(*----------------------------------------------------------------------------*)
procedure TVoidTextureRGBAID_R(Self: TVoidTextureRGBA; var T: integer);
Begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure TTextureRGBApixels_W(Self: TTextureRGBA; const T: pRGBAlist);
Begin Self.pixels := T; end;

(*----------------------------------------------------------------------------*)
procedure TTextureRGBApixels_R(Self: TTextureRGBA; var T: pRGBAlist);
Begin T := Self.pixels; end;

(*----------------------------------------------------------------------------*)
procedure TVoidTexturepixels_W(Self: TVoidTexture; const T: pRGBlist);
Begin Self.pixels := T; end;

(*----------------------------------------------------------------------------*)
procedure TVoidTexturepixels_R(Self: TVoidTexture; var T: pRGBlist);
Begin T := Self.pixels; end;

(*----------------------------------------------------------------------------*)
procedure TVoidTextureheight_W(Self: TVoidTexture; const T: integer);
Begin Self.height := T; end;

(*----------------------------------------------------------------------------*)
procedure TVoidTextureheight_R(Self: TVoidTexture; var T: integer);
Begin T := Self.height; end;

(*----------------------------------------------------------------------------*)
procedure TVoidTexturewidth_W(Self: TVoidTexture; const T: integer);
Begin Self.width := T; end;

(*----------------------------------------------------------------------------*)
procedure TVoidTexturewidth_R(Self: TVoidTexture; var T: integer);
Begin T := Self.width; end;

(*----------------------------------------------------------------------------*)
procedure TVoidTextureID_W(Self: TVoidTexture; const T: integer);
Begin Self.ID := T; end;

(*----------------------------------------------------------------------------*)
procedure TVoidTextureID_R(Self: TVoidTexture; var T: integer);
Begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure TTexturepixels_W(Self: TTexture; const T: pRGBlist);
Begin Self.pixels := T; end;

(*----------------------------------------------------------------------------*)
procedure TTexturepixels_R(Self: TTexture; var T: pRGBlist);
Begin T := Self.pixels; end;

(*----------------------------------------------------------------------------*)
procedure TTextureheight_W(Self: TTexture; const T: integer);
Begin Self.height := T; end;

(*----------------------------------------------------------------------------*)
procedure TTextureheight_R(Self: TTexture; var T: integer);
Begin T := Self.height; end;

(*----------------------------------------------------------------------------*)
procedure TTexturewidth_W(Self: TTexture; const T: integer);
Begin Self.width := T; end;

(*----------------------------------------------------------------------------*)
procedure TTexturewidth_R(Self: TTexture; var T: integer);
Begin T := Self.width; end;

(*----------------------------------------------------------------------------*)
procedure TTextureID_W(Self: TTexture; const T: integer);
Begin Self.ID := T; end;

(*----------------------------------------------------------------------------*)
procedure TTextureID_R(Self: TTexture; var T: integer);
Begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVoidTextureRGBA(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVoidTextureRGBA) do
  begin
    RegisterPropertyHelper(@TVoidTextureRGBAID_R,@TVoidTextureRGBAID_W,'ID');
    RegisterPropertyHelper(@TVoidTextureRGBAwidth_R,@TVoidTextureRGBAwidth_W,'width');
    RegisterPropertyHelper(@TVoidTextureRGBAheight_R,@TVoidTextureRGBAheight_W,'height');
    RegisterPropertyHelper(@TVoidTextureRGBApixels_R,@TVoidTextureRGBApixels_W,'pixels');
    RegisterConstructor(@TVoidTextureRGBA.create, 'create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTextureRGBA(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTextureRGBA) do
  begin
    RegisterPropertyHelper(@TTextureRGBApixels_R,@TTextureRGBApixels_W,'pixels');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVoidTexture(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVoidTexture) do
  begin
    RegisterPropertyHelper(@TVoidTextureID_R,@TVoidTextureID_W,'ID');
    RegisterPropertyHelper(@TVoidTexturewidth_R,@TVoidTexturewidth_W,'width');
    RegisterPropertyHelper(@TVoidTextureheight_R,@TVoidTextureheight_W,'height');
    RegisterPropertyHelper(@TVoidTexturepixels_R,@TVoidTexturepixels_W,'pixels');
    RegisterConstructor(@TVoidTexture.create, 'create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTexture(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTexture) do
  begin
    RegisterPropertyHelper(@TTextureID_R,@TTextureID_W,'ID');
    RegisterPropertyHelper(@TTexturewidth_R,@TTexturewidth_W,'width');
    RegisterPropertyHelper(@TTextureheight_R,@TTextureheight_W,'height');
    RegisterPropertyHelper(@TTexturepixels_R,@TTexturepixels_W,'pixels');
    RegisterConstructor(@TTexture.Load, 'Load');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Textures(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TTexture(CL);
  RIRegister_TVoidTexture(CL);
  RIRegister_TTextureRGBA(CL);
  RIRegister_TVoidTextureRGBA(CL);
end;

 
 
{ TPSImport_Textures }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Textures.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Textures(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Textures.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Textures(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
