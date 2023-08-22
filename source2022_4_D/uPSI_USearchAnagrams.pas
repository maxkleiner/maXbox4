unit uPSI_USearchAnagrams;
{
for sentiment analysis   plus string hashunit

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
  TPSImport_USearchAnagrams = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSearchAnagrams(CL: TPSPascalCompiler);
procedure SIRegister_USearchAnagrams(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSearchAnagrams(CL: TPSRuntimeClassImporter);
procedure RIRegister_USearchAnagrams(CL: TPSRuntimeClassImporter);

{ compile-time registration functions }
procedure SIRegister_THashStr(CL: TPSPascalCompiler);
procedure SIRegister_THashObject(CL: TPSPascalCompiler);
procedure SIRegister_HashUnit(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_THashStr(CL: TPSRuntimeClassImporter);
procedure RIRegister_THashObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_HashUnit(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   controls
  ,forms
  ,UDict
  ,USearchAnagrams, HashUnit;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_USearchAnagrams]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSearchAnagrams(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'tcontrol', 'TSearchAnagrams') do
  with CL.AddClassN(CL.FindClass('tcontrol'),'TSearchAnagrams') do begin
    RegisterProperty('useabbrevs', 'boolean', iptrw);
    RegisterProperty('useforeign', 'boolean', iptrw);
    RegisterProperty('usecaps', 'boolean', iptrw);
    RegisterProperty('tag', 'integer', iptrw);
    RegisterMethod('Procedure Init(newletters :string; NewMinLen,NewMaxLen: word; newa,newf,newc:boolean; apubDic:TDic)');
    RegisterMethod('Function FindMissingLetter( const s : string) : TTestWords');
    RegisterMethod('Procedure Findallwords( const s : string; list : Tstrings)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_USearchAnagrams(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('char', 'ANSIChar');
  //CL.AddTypeS('CharSet', 'set of Char');
  CL.AddTypeS('TTestWords', 'array [97..122] of string;');
  CL.AddTypeS('tagTEXTMETRICA', 'record tmHeight : Longint; tmAscent : Longint;'
   +' tmDescent : Longint; tmInternalLeading : Longint; tmExternalLeading : Lon'
   +'gint; tmAveCharWidth : Longint; tmMaxCharWidth : Longint; tmWeight : Longi'
   +'nt; tmOverhang : Longint; tmDigitizedAspectX : Longint; tmDigitizedAspectY'
   +' : Longint; tmFirstChar : AnsiChar; tmLastChar : AnsiChar; tmDefaultChar :'
   +' AnsiChar; tmBreakChar : AnsiChar; tmItalic : Byte; tmUnderlined : Byte; t'
   +'mStruckOut : Byte; tmPitchAndFamily : Byte; tmCharSet : Byte; end');
  CL.AddTypeS('TEXTMETRICA', 'tagTEXTMETRICA');
   CL.AddTypeS('TEXTMETRIC', 'TEXTMETRICA');
 CL.AddConstantN('NTM_REGULAR','LongWord').SetUInt( $40);
 CL.AddConstantN('NTM_BOLD','LongWord').SetUInt( $20);
 CL.AddConstantN('NTM_ITALIC','LongInt').SetInt( 1);
  //TTestWords= array ['a'..'z'] of string;
  SIRegister_TSearchAnagrams(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSearchAnagramstag_W(Self: TSearchAnagrams; const T: integer);
Begin Self.tag := T; end;

(*----------------------------------------------------------------------------*)
procedure TSearchAnagramstag_R(Self: TSearchAnagrams; var T: integer);
Begin T := Self.tag; end;

(*----------------------------------------------------------------------------*)
procedure TSearchAnagramsusecaps_W(Self: TSearchAnagrams; const T: boolean);
Begin Self.usecaps := T; end;

(*----------------------------------------------------------------------------*)
procedure TSearchAnagramsusecaps_R(Self: TSearchAnagrams; var T: boolean);
Begin T := Self.usecaps; end;

(*----------------------------------------------------------------------------*)
procedure TSearchAnagramsuseforeign_W(Self: TSearchAnagrams; const T: boolean);
Begin Self.useforeign := T; end;

(*----------------------------------------------------------------------------*)
procedure TSearchAnagramsuseforeign_R(Self: TSearchAnagrams; var T: boolean);
Begin T := Self.useforeign; end;

(*----------------------------------------------------------------------------*)
procedure TSearchAnagramsuseabbrevs_W(Self: TSearchAnagrams; const T: boolean);
Begin Self.useabbrevs := T; end;

(*----------------------------------------------------------------------------*)
procedure TSearchAnagramsuseabbrevs_R(Self: TSearchAnagrams; var T: boolean);
Begin T := Self.useabbrevs; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSearchAnagrams(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSearchAnagrams) do
  begin
    RegisterPropertyHelper(@TSearchAnagramsuseabbrevs_R,@TSearchAnagramsuseabbrevs_W,'useabbrevs');
    RegisterPropertyHelper(@TSearchAnagramsuseforeign_R,@TSearchAnagramsuseforeign_W,'useforeign');
    RegisterPropertyHelper(@TSearchAnagramsusecaps_R,@TSearchAnagramsusecaps_W,'usecaps');
    RegisterPropertyHelper(@TSearchAnagramstag_R,@TSearchAnagramstag_W,'tag');
    RegisterMethod(@TSearchAnagrams.Init, 'Init');
    RegisterMethod(@TSearchAnagrams.FindMissingLetter, 'FindMissingLetter');
    RegisterMethod(@TSearchAnagrams.Findallwords, 'Findallwords');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_USearchAnagrams(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSearchAnagrams(CL);
end;

 
 
{ TPSImport_USearchAnagrams }
(*----------------------------------------------------------------------------*)
procedure TPSImport_USearchAnagrams.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_USearchAnagrams(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_USearchAnagrams.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_USearchAnagrams(ri);
end;
(*----------------------------------------------------------------------------*)


//type THashObjectArray = array of THashObject;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_THashStr(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('THashObjectArray', 'array of THashObject');
  //with RegClassS(CL,'TObject', 'THashStr') do
  with CL.AddClassN(CL.FindClass('TObject'),'THashStr') do begin
    RegisterProperty('test', 'THashObjectArray', iptrw);
    RegisterProperty('maxhash', 'integer', iptrw);
    RegisterProperty('maxloadfactor', 'single', iptrw);
    RegisterProperty('maxused', 'integer', iptrw);
    RegisterProperty('used', 'integer', iptrw);
    RegisterProperty('nbrcollisions', 'integer', iptrw);
    RegisterProperty('maxcollisions', 'integer', iptrw);
    RegisterMethod('Constructor create( newmaxhash : integer; newmaxloading : single)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function exists( s : string; var T : TObject) : boolean');
    RegisterMethod('Function AddIfNotDup( s : string; t : Tobject) : boolean');
    RegisterMethod('Procedure resethash');
    RegisterMethod('Procedure rehash');
    RegisterMethod('Function hash( s : string) : integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THashObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'THashObject') do
  with CL.AddClassN(CL.FindClass('TObject'),'THashObject') do
  begin
    RegisterProperty('s', 'string', iptrw);
    RegisterProperty('t', 'TObject', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_HashUnit(CL: TPSPascalCompiler);
begin
  SIRegister_THashObject(CL);
  SIRegister_THashStr(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure THashStrmaxcollisions_W(Self: THashStr; const T: integer);
Begin Self.maxcollisions := T; end;

(*----------------------------------------------------------------------------*)
procedure THashStrmaxcollisions_R(Self: THashStr; var T: integer);
Begin T := Self.maxcollisions; end;

(*----------------------------------------------------------------------------*)
procedure THashStrnbrcollisions_W(Self: THashStr; const T: integer);
Begin Self.nbrcollisions := T; end;

(*----------------------------------------------------------------------------*)
procedure THashStrnbrcollisions_R(Self: THashStr; var T: integer);
Begin T := Self.nbrcollisions; end;

(*----------------------------------------------------------------------------*)
procedure THashStrused_W(Self: THashStr; const T: integer);
Begin Self.used := T; end;

(*----------------------------------------------------------------------------*)
procedure THashStrused_R(Self: THashStr; var T: integer);
Begin T := Self.used; end;

(*----------------------------------------------------------------------------*)
procedure THashStrmaxused_W(Self: THashStr; const T: integer);
Begin Self.maxused := T; end;

(*----------------------------------------------------------------------------*)
procedure THashStrmaxused_R(Self: THashStr; var T: integer);
Begin T := Self.maxused; end;

(*----------------------------------------------------------------------------*)
procedure THashStrmaxloadfactor_W(Self: THashStr; const T: single);
Begin Self.maxloadfactor := T; end;

(*----------------------------------------------------------------------------*)
procedure THashStrmaxloadfactor_R(Self: THashStr; var T: single);
Begin T := Self.maxloadfactor; end;

(*----------------------------------------------------------------------------*)
procedure THashStrmaxhash_W(Self: THashStr; const T: integer);
Begin Self.maxhash := T; end;

(*----------------------------------------------------------------------------*)
procedure THashStrmaxhash_R(Self: THashStr; var T: integer);
Begin T := Self.maxhash; end;

(*----------------------------------------------------------------------------*)
procedure THashStrtest_W(Self: THashStr; const T: THashObjectArray);
Begin Self.test := T;
end;

(*----------------------------------------------------------------------------*)
procedure THashStrtest_R(Self: THashStr; var T: THashObjectArray);
Begin T := Self.test;
end;

(*----------------------------------------------------------------------------*)
procedure THashObjectt_W(Self: THashObject; const T: TObject);
Begin Self.t := T; end;

(*----------------------------------------------------------------------------*)
procedure THashObjectt_R(Self: THashObject; var T: TObject);
Begin T := Self.t; end;

(*----------------------------------------------------------------------------*)
procedure THashObjects_W(Self: THashObject; const T: string);
Begin Self.s := T; end;

(*----------------------------------------------------------------------------*)
procedure THashObjects_R(Self: THashObject; var T: string);
Begin T := Self.s; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THashStr(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THashStr) do begin
    RegisterPropertyHelper(@THashStrtest_R,@THashStrtest_W,'test');
    RegisterPropertyHelper(@THashStrmaxhash_R,@THashStrmaxhash_W,'maxhash');
    RegisterPropertyHelper(@THashStrmaxloadfactor_R,@THashStrmaxloadfactor_W,'maxloadfactor');
    RegisterPropertyHelper(@THashStrmaxused_R,@THashStrmaxused_W,'maxused');
    RegisterPropertyHelper(@THashStrused_R,@THashStrused_W,'used');
    RegisterPropertyHelper(@THashStrnbrcollisions_R,@THashStrnbrcollisions_W,'nbrcollisions');
    RegisterPropertyHelper(@THashStrmaxcollisions_R,@THashStrmaxcollisions_W,'maxcollisions');
    RegisterConstructor(@THashStr.create, 'create');
    RegisterMethod(@THashStr.exists, 'exists');
    RegisterMethod(@THashStr.AddIfNotDup, 'AddIfNotDup');
    RegisterMethod(@THashStr.resethash, 'resethash');
    RegisterMethod(@THashStr.rehash, 'rehash');
    RegisterMethod(@THashStr.hash, 'hash');
    RegisterMethod(@THashStr.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THashObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THashObject) do
  begin
    RegisterPropertyHelper(@THashObjects_R,@THashObjects_W,'s');
    RegisterPropertyHelper(@THashObjectt_R,@THashObjectt_W,'t');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_HashUnit(CL: TPSRuntimeClassImporter);
begin
  RIRegister_THashObject(CL);
  RIRegister_THashStr(CL);
end;

 
 

end.
