unit uPSI_PerlRegEx;
{
  EKON16     + EKON20 + function getMatchString(arex, atext: string): string;

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
  TPSImport_PerlRegEx = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TPerlRegExList(CL: TPSPascalCompiler);
procedure SIRegister_TPerlRegEx(CL: TPSPascalCompiler);
procedure SIRegister_PerlRegEx(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPerlRegExList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPerlRegEx(CL: TPSRuntimeClassImporter);
procedure RIRegister_PerlRegEx(CL: TPSRuntimeClassImporter);

function getMatchString(arex, atext: string): string;


procedure Register;

implementation


uses
   Windows
  ,Messages
  ,pcre
  ,PerlRegEx
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PerlRegEx]);
end;

function getMatchString(arex, atext: string): string;
 var
   RegEx: TPerlRegEx;
   WordCount: Integer;
 begin
   RegEx:= TPerlRegEx.Create; 
   try
     regEx.Subject:= atext;
     RegEx.regex:= arex;
     WordCount := 0;
     { Match function performs search and returns...}
     if RegEx.Match then
       { If there was a match, enter a loop to extract, count and write
        all matches and captured substrings. }
       repeat
         Inc(WordCount);
         //result:= RegEx.groups[1];
         { Write complete matched string. }
         result:= result+'match '+inttostr(WordCount)+ ' - '+ RegEx.MatchedText+
          { Write a matched substrings. }
          ' - last debug: '+ (RegEx.groups[1]+#13#10); //RegEx.SubStr(1),
          result:= result+RegEx.MatchedText;
       until NOT RegEx.matchagain;   //MatchNext < 0;
     //RegEx.CompileOptions:= RegEx.CompileOptions + [coNoAutoCapture];
     //RegEx.Options:= RegEx.Options - [preNoAutoCapture];
     RegEx.Options:= RegEx.Options- [preUnGreedy];
   finally
     RegEx.Free;
   end;
   //WriteLn('Done REX - Press Enter to exit');
   result:= result+('Done MatchString REX - Press Enter to exit');

 end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPerlRegExList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPerlRegExList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPerlRegExList') do begin
    RegisterMethod('Constructor Create');
   RegisterMethod('Procedure Free');
    RegisterMethod('Function Add( ARegEx : TPerlRegEx) : Integer');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Function IndexOf( ARegEx : TPerlRegEx) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; ARegEx : TPerlRegEx)');
    RegisterMethod('Function Match : Boolean');
    RegisterMethod('Function MatchAgain : Boolean');
    RegisterProperty('RegEx', 'TPerlRegEx Integer', iptrw);
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Subject', 'PCREString', iptrw);
    RegisterProperty('Start', 'Integer', iptrw);
    RegisterProperty('Stop', 'Integer', iptrw);
    RegisterProperty('MatchedRegEx', 'TPerlRegEx', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPerlRegEx(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPerlRegEx') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPerlRegEx') do begin
    RegisterMethod('Constructor Create');
   RegisterMethod('Procedure Free');
    RegisterMethod('Function EscapeRegExChars( const S : string) : string');
    RegisterMethod('Procedure Compile');
    RegisterMethod('Procedure Study');
    RegisterMethod('Function Match : Boolean');
    RegisterMethod('Function MatchAgain : Boolean');
    RegisterMethod('Function Replace : PCREString');
    RegisterMethod('Function ReplaceAll : Boolean');
    RegisterMethod('Function ComputeReplacement : PCREString');
    RegisterMethod('Procedure StoreGroups');
    RegisterMethod('Function NamedGroup( const Name : PCREString) : Integer');
    RegisterMethod('Procedure Split( Strings : TStrings; Limit : Integer)');
    RegisterMethod('Procedure SplitCapture( Strings : TStrings; Limit : Integer);');
    RegisterMethod('Procedure SplitCapture1( Strings : TStrings; Limit : Integer; Offset : Integer);');
    RegisterProperty('Compiled', 'Boolean', iptr);
    RegisterProperty('FoundMatch', 'Boolean', iptr);
    RegisterProperty('Studied', 'Boolean', iptr);
    RegisterProperty('MatchedText', 'PCREString', iptr);
    RegisterProperty('MatchedLength', 'Integer', iptr);
    RegisterProperty('MatchedOffset', 'Integer', iptr);
    RegisterProperty('Start', 'Integer', iptrw);
    RegisterProperty('Stop', 'Integer', iptrw);
    RegisterProperty('State', 'TPerlRegExState', iptrw);
    RegisterProperty('GroupCount', 'Integer', iptr);
    RegisterProperty('Groups', 'PCREString Integer', iptr);
    RegisterProperty('GroupLengths', 'Integer Integer', iptr);
    RegisterProperty('GroupOffsets', 'Integer Integer', iptr);
    RegisterProperty('Subject', 'PCREString', iptrw);
    RegisterProperty('SubjectLeft', 'PCREString', iptr);
    RegisterProperty('SubjectRight', 'PCREString', iptr);
    RegisterProperty('Options', 'TPerlRegExOptions', iptrw);
    RegisterProperty('RegEx', 'PCREString', iptrw);
    RegisterProperty('Replacement', 'PCREString', iptrw);
    RegisterProperty('OnMatch', 'TNotifyEvent', iptrw);
    RegisterProperty('OnReplace', 'TPerlRegExReplaceEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PerlRegEx(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TPerlRegExOption', '( preCaseLess, preMultiLine, preSing'
   +'leLine, preExtended, preAnchored, preUnGreedy, preNoAutoCapture )');
  CL.AddTypeS('TPerlRegExState', '( preNotBOL, preNotEOL, preNotEmpty )');
  CL.AddTypeS('TPerlRegExOptions', 'set of TPerlRegExOption');

 CL.AddConstantN('MAX_SUBEXPRESSIONS','LongInt').SetInt( 99);
  CL.AddTypeS('PCREString', 'UTF8String');
  CL.AddTypeS('PCREString', 'AnsiString');
  CL.AddTypeS('TPerlRegExReplaceEvent', 'Procedure ( Sender : TObject; var Repl'
   +'aceWith : PCREString)');
  SIRegister_TPerlRegEx(CL);
  SIRegister_TPerlRegExList(CL);

   CL.AddDelphiFunction('function getMatchString(arex, atext: string): string; ');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPerlRegExListMatchedRegEx_R(Self: TPerlRegExList; var T: TPerlRegEx);
begin T := Self.MatchedRegEx; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExListStop_W(Self: TPerlRegExList; const T: Integer);
begin Self.Stop := T; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExListStop_R(Self: TPerlRegExList; var T: Integer);
begin T := Self.Stop; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExListStart_W(Self: TPerlRegExList; const T: Integer);
begin Self.Start := T; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExListStart_R(Self: TPerlRegExList; var T: Integer);
begin T := Self.Start; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExListSubject_W(Self: TPerlRegExList; const T: PCREString);
begin Self.Subject := T; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExListSubject_R(Self: TPerlRegExList; var T: PCREString);
begin T := Self.Subject; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExListCount_R(Self: TPerlRegExList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExListRegEx_W(Self: TPerlRegExList; const T: TPerlRegEx; const t1: Integer);
begin Self.RegEx[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExListRegEx_R(Self: TPerlRegExList; var T: TPerlRegEx; const t1: Integer);
begin T := Self.RegEx[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExOnReplace_W(Self: TPerlRegEx; const T: TPerlRegExReplaceEvent);
begin Self.OnReplace := T; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExOnReplace_R(Self: TPerlRegEx; var T: TPerlRegExReplaceEvent);
begin T := Self.OnReplace; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExOnMatch_W(Self: TPerlRegEx; const T: TNotifyEvent);
begin Self.OnMatch := T; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExOnMatch_R(Self: TPerlRegEx; var T: TNotifyEvent);
begin T := Self.OnMatch; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExReplacement_W(Self: TPerlRegEx; const T: PCREString);
begin Self.Replacement := T; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExReplacement_R(Self: TPerlRegEx; var T: PCREString);
begin T := Self.Replacement; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExRegEx_W(Self: TPerlRegEx; const T: PCREString);
begin Self.RegEx := T; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExRegEx_R(Self: TPerlRegEx; var T: PCREString);
begin T := Self.RegEx; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExOptions_W(Self: TPerlRegEx; const T: TPerlRegExOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExOptions_R(Self: TPerlRegEx; var T: TPerlRegExOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExSubjectRight_R(Self: TPerlRegEx; var T: PCREString);
begin T := Self.SubjectRight; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExSubjectLeft_R(Self: TPerlRegEx; var T: PCREString);
begin T := Self.SubjectLeft; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExSubject_W(Self: TPerlRegEx; const T: PCREString);
begin Self.Subject := T; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExSubject_R(Self: TPerlRegEx; var T: PCREString);
begin T := Self.Subject; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExGroupOffsets_R(Self: TPerlRegEx; var T: Integer; const t1: Integer);
begin T := Self.GroupOffsets[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExGroupLengths_R(Self: TPerlRegEx; var T: Integer; const t1: Integer);
begin T := Self.GroupLengths[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExGroups_R(Self: TPerlRegEx; var T: PCREString; const t1: Integer);
begin T := Self.Groups[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExGroupCount_R(Self: TPerlRegEx; var T: Integer);
begin T := Self.GroupCount; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExState_W(Self: TPerlRegEx; const T: TPerlRegExState);
begin Self.State := T; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExState_R(Self: TPerlRegEx; var T: TPerlRegExState);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExStop_W(Self: TPerlRegEx; const T: Integer);
begin Self.Stop := T; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExStop_R(Self: TPerlRegEx; var T: Integer);
begin T := Self.Stop; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExStart_W(Self: TPerlRegEx; const T: Integer);
begin Self.Start := T; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExStart_R(Self: TPerlRegEx; var T: Integer);
begin T := Self.Start; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExMatchedOffset_R(Self: TPerlRegEx; var T: Integer);
begin T := Self.MatchedOffset; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExMatchedLength_R(Self: TPerlRegEx; var T: Integer);
begin T := Self.MatchedLength; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExMatchedText_R(Self: TPerlRegEx; var T: PCREString);
begin T := Self.MatchedText; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExStudied_R(Self: TPerlRegEx; var T: Boolean);
begin T := Self.Studied; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExFoundMatch_R(Self: TPerlRegEx; var T: Boolean);
begin T := Self.FoundMatch; end;

(*----------------------------------------------------------------------------*)
procedure TPerlRegExCompiled_R(Self: TPerlRegEx; var T: Boolean);
begin T := Self.Compiled; end;

(*----------------------------------------------------------------------------*)
Procedure TPerlRegExSplitCapture1_P(Self: TPerlRegEx;  Strings : TStrings; Limit : Integer; Offset : Integer);
Begin Self.SplitCapture(Strings, Limit, Offset); END;

(*----------------------------------------------------------------------------*)
Procedure TPerlRegExSplitCapture_P(Self: TPerlRegEx;  Strings : TStrings; Limit : Integer);
Begin Self.SplitCapture(Strings, Limit); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPerlRegExList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPerlRegExList) do
  begin
    RegisterConstructor(@TPerlRegExList.Create, 'Create');
   RegisterMethod(@TPerlRegExList.Destroy, 'Free');
    RegisterMethod(@TPerlRegExList.Add, 'Add');
    RegisterMethod(@TPerlRegExList.Clear, 'Clear');
    RegisterMethod(@TPerlRegExList.Delete, 'Delete');
    RegisterMethod(@TPerlRegExList.IndexOf, 'IndexOf');
    RegisterMethod(@TPerlRegExList.Insert, 'Insert');
    RegisterMethod(@TPerlRegExList.Match, 'Match');
    RegisterMethod(@TPerlRegExList.MatchAgain, 'MatchAgain');
    RegisterPropertyHelper(@TPerlRegExListRegEx_R,@TPerlRegExListRegEx_W,'RegEx');
    RegisterPropertyHelper(@TPerlRegExListCount_R,nil,'Count');
    RegisterPropertyHelper(@TPerlRegExListSubject_R,@TPerlRegExListSubject_W,'Subject');
    RegisterPropertyHelper(@TPerlRegExListStart_R,@TPerlRegExListStart_W,'Start');
    RegisterPropertyHelper(@TPerlRegExListStop_R,@TPerlRegExListStop_W,'Stop');
    RegisterPropertyHelper(@TPerlRegExListMatchedRegEx_R,nil,'MatchedRegEx');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPerlRegEx(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPerlRegEx) do begin
    RegisterConstructor(@TPerlRegEx.Create, 'Create');
    RegisterMethod(@TPerlRegEx.Destroy, 'Free');
    RegisterMethod(@TPerlRegEx.EscapeRegExChars, 'EscapeRegExChars');
    RegisterMethod(@TPerlRegEx.Compile, 'Compile');
    RegisterMethod(@TPerlRegEx.Study, 'Study');
    RegisterMethod(@TPerlRegEx.Match, 'Match');
    RegisterMethod(@TPerlRegEx.MatchAgain, 'MatchAgain');
    RegisterMethod(@TPerlRegEx.Replace, 'Replace');
    RegisterMethod(@TPerlRegEx.ReplaceAll, 'ReplaceAll');
    RegisterMethod(@TPerlRegEx.ComputeReplacement, 'ComputeReplacement');
    RegisterMethod(@TPerlRegEx.StoreGroups, 'StoreGroups');
    RegisterMethod(@TPerlRegEx.NamedGroup, 'NamedGroup');
    RegisterMethod(@TPerlRegEx.Split, 'Split');
    RegisterMethod(@TPerlRegExSplitCapture_P, 'SplitCapture');
    RegisterMethod(@TPerlRegExSplitCapture1_P, 'SplitCapture1');
    RegisterPropertyHelper(@TPerlRegExCompiled_R,nil,'Compiled');
    RegisterPropertyHelper(@TPerlRegExFoundMatch_R,nil,'FoundMatch');
    RegisterPropertyHelper(@TPerlRegExStudied_R,nil,'Studied');
    RegisterPropertyHelper(@TPerlRegExMatchedText_R,nil,'MatchedText');
    RegisterPropertyHelper(@TPerlRegExMatchedLength_R,nil,'MatchedLength');
    RegisterPropertyHelper(@TPerlRegExMatchedOffset_R,nil,'MatchedOffset');
    RegisterPropertyHelper(@TPerlRegExStart_R,@TPerlRegExStart_W,'Start');
    RegisterPropertyHelper(@TPerlRegExStop_R,@TPerlRegExStop_W,'Stop');
    RegisterPropertyHelper(@TPerlRegExState_R,@TPerlRegExState_W,'State');
    RegisterPropertyHelper(@TPerlRegExGroupCount_R,nil,'GroupCount');
    RegisterPropertyHelper(@TPerlRegExGroups_R,nil,'Groups');
    RegisterPropertyHelper(@TPerlRegExGroupLengths_R,nil,'GroupLengths');
    RegisterPropertyHelper(@TPerlRegExGroupOffsets_R,nil,'GroupOffsets');
    RegisterPropertyHelper(@TPerlRegExSubject_R,@TPerlRegExSubject_W,'Subject');
    RegisterPropertyHelper(@TPerlRegExSubjectLeft_R,nil,'SubjectLeft');
    RegisterPropertyHelper(@TPerlRegExSubjectRight_R,nil,'SubjectRight');
    RegisterPropertyHelper(@TPerlRegExOptions_R,@TPerlRegExOptions_W,'Options');
    RegisterPropertyHelper(@TPerlRegExRegEx_R,@TPerlRegExRegEx_W,'RegEx');
    RegisterPropertyHelper(@TPerlRegExReplacement_R,@TPerlRegExReplacement_W,'Replacement');
    RegisterPropertyHelper(@TPerlRegExOnMatch_R,@TPerlRegExOnMatch_W,'OnMatch');
    RegisterPropertyHelper(@TPerlRegExOnReplace_R,@TPerlRegExOnReplace_W,'OnReplace');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PerlRegEx(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPerlRegEx(CL);
  RIRegister_TPerlRegExList(CL);
end;

 
 
{ TPSImport_PerlRegEx }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PerlRegEx.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PerlRegEx(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PerlRegEx.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_PerlRegEx(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
