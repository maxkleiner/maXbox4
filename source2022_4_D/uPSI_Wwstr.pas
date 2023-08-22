unit uPSI_Wwstr;
{
   a last string thing oneS
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
  TPSImport_Wwstr = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_Wwstr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Wwstr_Routines(S: TPSExec);

procedure Register;

implementation


uses
   dialogs
  ,wwtypes
  ,Wwstr
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Wwstr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_Wwstr(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('strCharSet', 'set of char');
 CL.AddTypeS('TwwGetWordOption', '(wwgwSkipLeadingBlanks, wwgwQuotesAsWords, wwgwStripQuotes , wwgwSpacesInWords )');
  CL.AddTypeS('TwwGetWordOptions', 'set of TwwGetWordOption');

   // TwwGetWordOption = (wwgwSkipLeadingBlanks, wwgwQuotesAsWords, wwgwStripQuotes, wwgwSpacesInWords);
  //TwwWriteTextOption = (wtoAmpersandToUnderline, wtoEllipsis, wtoWordWrap,
    //                    wtoMergeCanvas, wtoTransparent, wtoCenterVert);
//                        ,
//                        wtoRightToLeft);

  //TwwWriteTextOptions = Set of TwwWriteTextOption;
  //TwwGetWordOptions = set of TwwGetWordOption;  {pwe}

 CL.AddDelphiFunction('Procedure strBreakApart( s : string; delimeter : string; parts : TStrings)');
 CL.AddDelphiFunction('Function strGetToken( s : string; delimeter : string; var APos : integer) : string');
 CL.AddDelphiFunction('Procedure strStripPreceding( var s : string; delimeter : strCharSet)');
 CL.AddDelphiFunction('Procedure strStripTrailing( var s : string; delimeter : strCharSet)');
 CL.AddDelphiFunction('Procedure strStripWhiteSpace( var s : string)');
 CL.AddDelphiFunction('Function strRemoveChar( str : string; removeChar : char) : string');
 CL.AddDelphiFunction('Function wwstrReplaceChar( str : string; removeChar, replaceChar : char) : string');
 CL.AddDelphiFunction('Function strReplaceCharWithStr( str : string; removeChar : char; replaceStr : string) : string');
 CL.AddDelphiFunction('Function wwEqualStr( s1, s2 : string) : boolean');
 CL.AddDelphiFunction('Function strCount( s : string; delimeter : char) : integer');
 CL.AddDelphiFunction('Function strWhiteSpace : strCharSet');
 CL.AddDelphiFunction('Function wwExtractFileNameOnly( const FileName : string) : string');
 CL.AddDelphiFunction('Function wwGetWord( s : string; var APos : integer; Options : TwwGetWordOptions; DelimSet : strCharSet) : string');
 CL.AddDelphiFunction('Function strTrailing( s : string; delimeter : char) : string');
 CL.AddDelphiFunction('Function strPreceding( s : string; delimeter : char) : string');
 CL.AddDelphiFunction('Function wwstrReplace( s, Find, Replace : string) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_Wwstr_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@strBreakApart, 'strBreakApart', cdRegister);
 S.RegisterDelphiFunction(@strGetToken, 'strGetToken', cdRegister);
 S.RegisterDelphiFunction(@strStripPreceding, 'strStripPreceding', cdRegister);
 S.RegisterDelphiFunction(@strStripTrailing, 'strStripTrailing', cdRegister);
 S.RegisterDelphiFunction(@strStripWhiteSpace, 'strStripWhiteSpace', cdRegister);
 S.RegisterDelphiFunction(@strRemoveChar, 'strRemoveChar', cdRegister);
 S.RegisterDelphiFunction(@strReplaceChar, 'wwstrReplaceChar', cdRegister);
 S.RegisterDelphiFunction(@strReplaceCharWithStr, 'strReplaceCharWithStr', cdRegister);
 S.RegisterDelphiFunction(@wwEqualStr, 'wwEqualStr', cdRegister);
 S.RegisterDelphiFunction(@strCount, 'strCount', cdRegister);
 S.RegisterDelphiFunction(@strWhiteSpace, 'strWhiteSpace', cdRegister);
 S.RegisterDelphiFunction(@wwExtractFileNameOnly, 'wwExtractFileNameOnly', cdRegister);
 S.RegisterDelphiFunction(@wwGetWord, 'wwGetWord', cdRegister);
 S.RegisterDelphiFunction(@strTrailing, 'strTrailing', cdRegister);
 S.RegisterDelphiFunction(@strPreceding, 'strPreceding', cdRegister);
 S.RegisterDelphiFunction(@strReplace, 'wwstrReplace', cdRegister);
end;

 
 
{ TPSImport_Wwstr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Wwstr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Wwstr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Wwstr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_Wwstr(ri);
  RIRegister_Wwstr_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
