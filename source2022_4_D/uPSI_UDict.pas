unit uPSI_UDict;
{
   dict for turing
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
  TPSImport_UDict = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TDic(CL: TPSPascalCompiler);
procedure SIRegister_TDicForm(CL: TPSPascalCompiler);
procedure SIRegister_UDict(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDic(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDicForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_UDict(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,UDict
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UDict]);
end;

procedure Create1(newpath:string; precheckedflag:boolean);
begin
   TDic.Create(newpath, precheckedflag);
end;

(*----------------------------------------------------------------------------*)
//procedure TDicCreate1_P(Self: TDic;  newpath:string; precheckedflag:boolean);
//Begin Self.Create(newpath, precheckedflag); END;

(*----------------------------------------------------------------------------*)
Function TDicCreate1_P(Self: TClass; CreateNewInstance: Boolean;  Newpath : string; Precheckedflag : boolean):TObject;
Begin Result := TDic.Create(Newpath, Precheckedflag); END;

(*----------------------------------------------------------------------------*)
Function TDicCreate0_P(Self: TClass; CreateNewInstance: Boolean;  Precheckedflag : boolean):TObject;
Begin Result := TDic.Create(Precheckedflag); END;



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDic(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TDic') do
  with CL.AddClassN(CL.FindClass('TObject'),'TDic') do begin
    RegisterProperty('IniPathName', 'string', iptrw);
    RegisterProperty('Maxwordlength', 'integer', iptrw);
    RegisterProperty('DicLoaded', 'boolean', iptrw);
    RegisterProperty('Dicname', 'string', iptrw);
    RegisterProperty('DefaultDic', 'String', iptrw);
    RegisterProperty('SmallDic', 'String', iptrw);
    RegisterProperty('MediumDic', 'String', iptrw);
    RegisterProperty('LargeDic', 'String', iptrw);
    RegisterMethod('Constructor Create( Precheckedflag : boolean)');
    RegisterMethod('Constructor Create1( Newpath : string; Precheckedflag : boolean)');
    RegisterMethod('Procedure LoadDicFromFile( filename : string)');
    RegisterMethod('Procedure LoadDefaultDic');
    RegisterMethod('Procedure LoadSmallDic');
    RegisterMethod('Procedure LoadMediumDic');
    RegisterMethod('Procedure LoadLargeDic');
    RegisterMethod('Procedure SaveDicToFile( filename : string)');
    RegisterMethod('Procedure SaveDicToTextFile( filename : string)');
    RegisterMethod('Procedure Setrange( const letter1 : char; length1 : byte; const letter2 : char; length2 : byte)');
    RegisterMethod('Procedure saverange');
    RegisterMethod('Procedure restorerange');
    RegisterMethod('Function Lookup( s : string; var abbrev, foreign, caps : boolean) : boolean;');
    RegisterMethod('Function Lookup1( s : string) : boolean;');
    RegisterMethod('Function GetnextWord( var word : string; var abbrev, foreign, caps : boolean) : boolean;');
    RegisterMethod('Function GetnextWord1( var word : string; var wordnbr : integer; var abbrev, foreign, caps : boolean) : boolean;');
    RegisterMethod('Function GetWordByNumber( n : integer; var word : string) : boolean');
    RegisterMethod('Function IsValidword( const ss : string) : boolean');
    RegisterMethod('Function AddWord( s : String; abbrev, foreign, caps : boolean) : boolean');
    RegisterMethod('Function RemoveWord( s : String) : boolean');
    RegisterMethod('Procedure Rebuildindex');
    RegisterMethod('Procedure reSortrange');
    RegisterMethod('Function GetwordCount : integer');
    RegisterMethod('Function checksave : integer');
    RegisterMethod('Function getDicSize : integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDicForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TDicForm') do
  with CL.AddClassN(CL.FindClass('TForm'),'TDicForm') do
  begin
    RegisterProperty('OpenDialog1', 'TOpenDialog', iptrw);
    RegisterMethod('Procedure FormCloseQuery( Sender : TObject; var CanClose : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_UDict(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('dichighletter','String').SetString( 'z');
  SIRegister_TDicForm(CL);
  SIRegister_TDic(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TDicGetnextWord3_P(Self: TDic;  var word : string; var wordnbr : integer; var abbrev, foreign, caps : boolean) : boolean;
Begin Result := Self.GetnextWord(word, wordnbr, abbrev, foreign, caps); END;

(*----------------------------------------------------------------------------*)
Function TDicGetnextWord2_P(Self: TDic;  var word : string; var abbrev, foreign, caps : boolean) : boolean;
Begin Result := Self.GetnextWord(word, abbrev, foreign, caps); END;

(*----------------------------------------------------------------------------*)
Function TDicLookup1_P(Self: TDic;  s : string) : boolean;
Begin Result := Self.Lookup(s); END;

(*----------------------------------------------------------------------------*)
Function TDicLookup0_P(Self: TDic;  s : string; var abbrev, foreign, caps : boolean) : boolean;
Begin Result := Self.Lookup(s, abbrev, foreign, caps); END;

(*----------------------------------------------------------------------------*)
procedure TDicLargeDic_W(Self: TDic; const T: String);
Begin Self.LargeDic := T; end;

(*----------------------------------------------------------------------------*)
procedure TDicLargeDic_R(Self: TDic; var T: String);
Begin T := Self.LargeDic; end;

(*----------------------------------------------------------------------------*)
procedure TDicMediumDic_W(Self: TDic; const T: String);
Begin Self.MediumDic := T; end;

(*----------------------------------------------------------------------------*)
procedure TDicMediumDic_R(Self: TDic; var T: String);
Begin T := Self.MediumDic; end;

(*----------------------------------------------------------------------------*)
procedure TDicSmallDic_W(Self: TDic; const T: String);
Begin Self.SmallDic := T; end;

(*----------------------------------------------------------------------------*)
procedure TDicSmallDic_R(Self: TDic; var T: String);
Begin T := Self.SmallDic; end;

(*----------------------------------------------------------------------------*)
procedure TDicDefaultDic_W(Self: TDic; const T: String);
Begin Self.DefaultDic := T; end;

(*----------------------------------------------------------------------------*)
procedure TDicDefaultDic_R(Self: TDic; var T: String);
Begin T := Self.DefaultDic; end;

(*----------------------------------------------------------------------------*)
procedure TDicDicname_W(Self: TDic; const T: string);
Begin Self.Dicname := T; end;

(*----------------------------------------------------------------------------*)
procedure TDicDicname_R(Self: TDic; var T: string);
Begin T := Self.Dicname; end;

(*----------------------------------------------------------------------------*)
procedure TDicDicLoaded_W(Self: TDic; const T: boolean);
Begin Self.DicLoaded := T; end;

(*----------------------------------------------------------------------------*)
procedure TDicDicLoaded_R(Self: TDic; var T: boolean);
Begin T := Self.DicLoaded; end;

(*----------------------------------------------------------------------------*)
procedure TDicMaxwordlength_W(Self: TDic; const T: integer);
Begin Self.Maxwordlength := T; end;

(*----------------------------------------------------------------------------*)
procedure TDicMaxwordlength_R(Self: TDic; var T: integer);
Begin T := Self.Maxwordlength; end;

(*----------------------------------------------------------------------------*)
procedure TDicIniPathName_W(Self: TDic; const T: string);
Begin Self.IniPathName := T; end;

(*----------------------------------------------------------------------------*)
procedure TDicIniPathName_R(Self: TDic; var T: string);
Begin T := Self.IniPathName; end;

(*----------------------------------------------------------------------------*)
procedure TDicFormOpenDialog1_W(Self: TDicForm; const T: TOpenDialog);
Begin Self.OpenDialog1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TDicFormOpenDialog1_R(Self: TDicForm; var T: TOpenDialog);
Begin T := Self.OpenDialog1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDic(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDic) do begin
    RegisterPropertyHelper(@TDicIniPathName_R,@TDicIniPathName_W,'IniPathName');
    RegisterPropertyHelper(@TDicMaxwordlength_R,@TDicMaxwordlength_W,'Maxwordlength');
    RegisterPropertyHelper(@TDicDicLoaded_R,@TDicDicLoaded_W,'DicLoaded');
    RegisterPropertyHelper(@TDicDicname_R,@TDicDicname_W,'Dicname');
    RegisterPropertyHelper(@TDicDefaultDic_R,@TDicDefaultDic_W,'DefaultDic');
    RegisterPropertyHelper(@TDicSmallDic_R,@TDicSmallDic_W,'SmallDic');
    RegisterPropertyHelper(@TDicMediumDic_R,@TDicMediumDic_W,'MediumDic');
    RegisterPropertyHelper(@TDicLargeDic_R,@TDicLargeDic_W,'LargeDic');
    RegisterConstructor(@TDicCreate0_P, 'Create');
    RegisterConstructor(@TDicCreate1_P, 'Create1');
    RegisterMethod(@TDic.LoadDicFromFile, 'LoadDicFromFile');
    RegisterMethod(@TDic.LoadDefaultDic, 'LoadDefaultDic');
    RegisterMethod(@TDic.LoadSmallDic, 'LoadSmallDic');
    RegisterMethod(@TDic.LoadMediumDic, 'LoadMediumDic');
    RegisterMethod(@TDic.LoadLargeDic, 'LoadLargeDic');
    RegisterMethod(@TDic.SaveDicToFile, 'SaveDicToFile');
    RegisterMethod(@TDic.SaveDicToTextFile, 'SaveDicToTextFile');
    RegisterMethod(@TDic.Setrange, 'Setrange');
    RegisterMethod(@TDic.saverange, 'saverange');
    RegisterMethod(@TDic.restorerange, 'restorerange');
    RegisterMethod(@TDicLookup0_P, 'Lookup');
    RegisterMethod(@TDicLookup1_P, 'Lookup1');
    RegisterMethod(@TDicGetnextWord2_P, 'GetnextWord');
    RegisterMethod(@TDicGetnextWord3_P, 'GetnextWord1');
    RegisterMethod(@TDic.GetWordByNumber, 'GetWordByNumber');
    RegisterMethod(@TDic.IsValidword, 'IsValidword');
    RegisterMethod(@TDic.AddWord, 'AddWord');
    RegisterMethod(@TDic.RemoveWord, 'RemoveWord');
    RegisterMethod(@TDic.Rebuildindex, 'Rebuildindex');
    RegisterMethod(@TDic.reSortrange, 'reSortrange');
    RegisterMethod(@TDic.GetwordCount, 'GetwordCount');
    RegisterMethod(@TDic.checksave, 'checksave');
    RegisterMethod(@TDic.getDicSize, 'getDicSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDicForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDicForm) do
  begin
    RegisterPropertyHelper(@TDicFormOpenDialog1_R,@TDicFormOpenDialog1_W,'OpenDialog1');
    RegisterMethod(@TDicForm.FormCloseQuery, 'FormCloseQuery');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_UDict(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDicForm(CL);
  RIRegister_TDic(CL);
end;

 
 
{ TPSImport_UDict }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UDict.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UDict(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UDict.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_UDict(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
