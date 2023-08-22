unit uPSI_rxAniFile;
{
   animat led icons for led chess

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
  TPSImport_rxAniFile = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAnimatedCursorImage(CL: TPSPascalCompiler);
procedure SIRegister_TIconFrame(CL: TPSPascalCompiler);
procedure SIRegister_rxAniFile(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAnimatedCursorImage(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIconFrame(CL: TPSRuntimeClassImporter);
procedure RIRegister_rxAniFile(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,rxAniFile
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_rxAniFile]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAnimatedCursorImage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TAnimatedCursorImage') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TAnimatedCursorImage') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
       RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromFile( const Filename : string)');
    RegisterMethod('Procedure AssignToBitmap( Bitmap : TBitmap; BackColor : TColor; DecreaseColors, Vertical : Boolean)');
    RegisterProperty('DefaultRate', 'Longint', iptr);
    RegisterProperty('IconCount', 'Integer', iptr);
    RegisterProperty('Icons', 'TIcon Integer', iptr);
    RegisterProperty('Frames', 'TIconFrame Integer', iptr);
    RegisterProperty('Title', 'string', iptr);
    RegisterProperty('Creator', 'string', iptr);
    RegisterProperty('OriginalColors', 'Word', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIconFrame(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TIconFrame') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TIconFrame') do begin
    RegisterMethod('Constructor Create( Index : Integer; Jiff : Longint)');
     RegisterMethod('Procedure Free');
       RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('JiffRate', 'Longint', iptr);
    RegisterProperty('Seq', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_rxAniFile(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PAniTag', '^TAniTag // will not work');
  CL.AddTypeS('TFourCC', 'array[0..3] of AnsiChar;');

 // type  TFourCC = array[0..3] of AnsiChar;
  CL.AddTypeS('TAniTag', 'record ckID : TFourCC; ckSize : Longint; end');
 CL.AddConstantN('AF_ICON','LongWord').SetUInt( $00000001);
 CL.AddConstantN('AF_SEQUENCE','LongWord').SetUInt( $00000002);
  SIRegister_TIconFrame(CL);
  SIRegister_TAnimatedCursorImage(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAnimatedCursorImageOriginalColors_R(Self: TAnimatedCursorImage; var T: Word);
begin T := Self.OriginalColors; end;

(*----------------------------------------------------------------------------*)
procedure TAnimatedCursorImageCreator_R(Self: TAnimatedCursorImage; var T: string);
begin T := Self.Creator; end;

(*----------------------------------------------------------------------------*)
procedure TAnimatedCursorImageTitle_R(Self: TAnimatedCursorImage; var T: string);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TAnimatedCursorImageFrames_R(Self: TAnimatedCursorImage; var T: TIconFrame; const t1: Integer);
begin T := Self.Frames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TAnimatedCursorImageIcons_R(Self: TAnimatedCursorImage; var T: TIcon; const t1: Integer);
begin T := Self.Icons[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TAnimatedCursorImageIconCount_R(Self: TAnimatedCursorImage; var T: Integer);
begin T := Self.IconCount; end;

(*----------------------------------------------------------------------------*)
procedure TAnimatedCursorImageDefaultRate_R(Self: TAnimatedCursorImage; var T: Longint);
begin T := Self.DefaultRate; end;

(*----------------------------------------------------------------------------*)
procedure TIconFrameSeq_R(Self: TIconFrame; var T: Integer);
begin T := Self.Seq; end;

(*----------------------------------------------------------------------------*)
procedure TIconFrameJiffRate_R(Self: TIconFrame; var T: Longint);
begin T := Self.JiffRate; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAnimatedCursorImage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAnimatedCursorImage) do
  begin
    RegisterConstructor(@TAnimatedCursorImage.Create, 'Create');
      RegisterMethod(@TAnimatedCursorImage.Destroy, 'Free');
     RegisterMethod(@TAnimatedCursorImage.Assign, 'Assign');
    RegisterMethod(@TAnimatedCursorImage.Clear, 'Clear');
    RegisterVirtualMethod(@TAnimatedCursorImage.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TAnimatedCursorImage.SaveToStream, 'SaveToStream');
    RegisterVirtualMethod(@TAnimatedCursorImage.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TAnimatedCursorImage.AssignToBitmap, 'AssignToBitmap');
    RegisterPropertyHelper(@TAnimatedCursorImageDefaultRate_R,nil,'DefaultRate');
    RegisterPropertyHelper(@TAnimatedCursorImageIconCount_R,nil,'IconCount');
    RegisterPropertyHelper(@TAnimatedCursorImageIcons_R,nil,'Icons');
    RegisterPropertyHelper(@TAnimatedCursorImageFrames_R,nil,'Frames');
    RegisterPropertyHelper(@TAnimatedCursorImageTitle_R,nil,'Title');
    RegisterPropertyHelper(@TAnimatedCursorImageCreator_R,nil,'Creator');
    RegisterPropertyHelper(@TAnimatedCursorImageOriginalColors_R,nil,'OriginalColors');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIconFrame(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIconFrame) do begin
    RegisterConstructor(@TIconFrame.Create, 'Create');
      RegisterMethod(@TIconFrame.Destroy, 'Free');
      RegisterMethod(@TIconFrame.Assign, 'Assign');
    RegisterPropertyHelper(@TIconFrameJiffRate_R,nil,'JiffRate');
    RegisterPropertyHelper(@TIconFrameSeq_R,nil,'Seq');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_rxAniFile(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIconFrame(CL);
  RIRegister_TAnimatedCursorImage(CL);
end;

 
 
{ TPSImport_rxAniFile }
(*----------------------------------------------------------------------------*)
procedure TPSImport_rxAniFile.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_rxAniFile(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_rxAniFile.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_rxAniFile(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
