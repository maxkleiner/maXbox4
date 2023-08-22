unit uPSI_JvPlaylist;
{
   mplayer2
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
  TPSImport_JvPlaylist = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvPlaylist(CL: TPSPascalCompiler);
procedure SIRegister_JvPlaylist(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvPlaylist(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvPlaylist(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Messages
  ,Controls
  ,StdCtrls
  ,JvCtrls
  ,JvPlaylist
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvPlaylist]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvPlaylist(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvListBox', 'TJvPlaylist') do
  with CL.AddClassN(CL.FindClass('TJvListBox'),'TJvPlaylist') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure AddItem( Item : string; AObject : TObject)');
    RegisterMethod('Procedure AddItems( Value : TStrings)');
    RegisterMethod('Function GetItem( Index : Integer) : string');
    RegisterMethod('Procedure DeleteDeadFiles');
    RegisterMethod('Procedure SortBySongName');
    RegisterMethod('Procedure SortByPath');
    RegisterMethod('Procedure SortByPathInverted');
    RegisterMethod('Procedure SortBySongNameInverted');
    RegisterMethod('Procedure ReverseOrder');
    RegisterMethod('Procedure RandomOrder');
    RegisterMethod('Procedure MoveSelectedUp');
    RegisterMethod('Procedure MoveSelectedDown');
    RegisterMethod('Procedure SavePlaylist( FileName : string)');
    RegisterMethod('Procedure LoadPlaylist( FileName : string)');
    RegisterProperty('ShowDrive', 'Boolean', iptrw);
    RegisterProperty('ShowNumbers', 'Boolean', iptrw);
    RegisterProperty('ShowExtension', 'Boolean', iptrw);
    RegisterProperty('Items', 'TStrings', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvPlaylist(CL: TPSPascalCompiler);
begin
  SIRegister_TJvPlaylist(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvPlaylistItems_W(Self: TJvPlaylist; const T: TStringList);
begin Self.Items := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPlaylistItems_R(Self: TJvPlaylist; var T: TStrings);
begin T := Self.Items; end;

(*----------------------------------------------------------------------------*)
procedure TJvPlaylistShowExtension_W(Self: TJvPlaylist; const T: Boolean);
begin Self.ShowExtension := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPlaylistShowExtension_R(Self: TJvPlaylist; var T: Boolean);
begin T := Self.ShowExtension; end;

(*----------------------------------------------------------------------------*)
procedure TJvPlaylistShowNumbers_W(Self: TJvPlaylist; const T: Boolean);
begin Self.ShowNumbers := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPlaylistShowNumbers_R(Self: TJvPlaylist; var T: Boolean);
begin T := Self.ShowNumbers; end;

(*----------------------------------------------------------------------------*)
procedure TJvPlaylistShowDrive_W(Self: TJvPlaylist; const T: Boolean);
begin Self.ShowDrive:= T; end;

(*----------------------------------------------------------------------------*)
procedure TJvPlaylistShowDrive_R(Self: TJvPlaylist; var T: Boolean);
begin T := Self.ShowDrive; end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvPlaylist(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvPlaylist) do begin
    RegisterConstructor(@TJvPlaylist.Create, 'Create');
    RegisterMethod(@TJvPlaylist.Destroy, 'Free');
    RegisterMethod(@TJvPlaylist.AddItem, 'AddItem');
    RegisterMethod(@TJvPlaylist.AddItems, 'AddItems');
    RegisterMethod(@TJvPlaylist.GetItem, 'GetItem');
    RegisterMethod(@TJvPlaylist.DeleteDeadFiles, 'DeleteDeadFiles');
    RegisterMethod(@TJvPlaylist.SortBySongName, 'SortBySongName');
    RegisterMethod(@TJvPlaylist.SortByPath, 'SortByPath');
    RegisterMethod(@TJvPlaylist.SortByPathInverted, 'SortByPathInverted');
    RegisterMethod(@TJvPlaylist.SortBySongNameInverted, 'SortBySongNameInverted');
    RegisterMethod(@TJvPlaylist.ReverseOrder, 'ReverseOrder');
    RegisterMethod(@TJvPlaylist.RandomOrder, 'RandomOrder');
    RegisterMethod(@TJvPlaylist.MoveSelectedUp, 'MoveSelectedUp');
    RegisterMethod(@TJvPlaylist.MoveSelectedDown, 'MoveSelectedDown');
    RegisterMethod(@TJvPlaylist.SavePlaylist, 'SavePlaylist');
    RegisterMethod(@TJvPlaylist.LoadPlaylist, 'LoadPlaylist');
    RegisterPropertyHelper(@TJvPlaylistShowNumbers_R,@TJvPlaylistShowNumbers_W,'ShowNumbers');
    RegisterPropertyHelper(@TJvPlaylistShowDrive_R,@TJvPlaylistShowDrive_W,'ShowDrive');

    RegisterPropertyHelper(@TJvPlaylistShowExtension_R,@TJvPlaylistShowExtension_W,'ShowExtension');
    RegisterPropertyHelper(@TJvPlaylistItems_R,@TJvPlaylistItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvPlaylist(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvPlaylist(CL);
end;

 
 
{ TPSImport_JvPlaylist }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvPlaylist.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvPlaylist(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvPlaylist.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvPlaylist(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
