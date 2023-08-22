unit uPSI_GR32_System;
{
  first GR32
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
  TPSImport_GR32_System = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPerfTimer(CL: TPSPascalCompiler);
procedure SIRegister_GR32_System(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_GR32_System_Routines(S: TPSExec);
procedure RIRegister_TPerfTimer(CL: TPSRuntimeClassImporter);
procedure RIRegister_GR32_System(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,GR32_System
  ,Dialogs
  ,Forms
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GR32_System]);
end;


function Null2Blank(aString:String):String;
 Const  arNull : array[0..2] of String = ('0','0.0','0.00');
 var i:Longint;
begin
 result:=aString;
 for i:=low(arNull) to high(arNull) do if aString = arNull[i] then Result:='';
end;

Function BoolToInt(aBool: Boolean): LongInt;
Begin
  If aBool Then
    Result := 1
  Else
    Result := 0;
End ;

Function IntToBool(aInt: LongInt): Boolean ;
Begin
  If aInt = 0 Then Result := False Else Result := True ;
End ;

function IntTo3Str(Value : Longint; separator: string) : string;
var s, s2 : string;
  rest : shortint;
begin
  s := IntToStr(Value);
  s2 := '';
  if s[1] = '-' then begin
    s2 := '-';
    s := copy(s, 2, length(s) - 1);
  end;
  if length(s) > 3 then begin
    rest := length(s) mod 3;
    if rest > 0 then begin
      s2 := copy(s, 1, rest) + separator;
      s := copy(s, 1 + rest , length(s) - rest);
    end;
    while length(s) > 3 do begin
      s2 := s2 + copy(s, 1, 3) + separator;
      s := copy(s, 4, length(s) - 3);
    end;
    s2 := s2 + s;
  end else begin
    s2 := s;
  end;
  result:= s2;
end;

function IsReadOnly(const Filename: string): boolean;
begin
  result:= boolean(FileGetAttr(Filename) and faReadOnly);
  if result then MessageDlg(Format('%s is readonly!',
     [ExtractFileName(Filename)]), mtWarning, [mbOK], 0);
end;

procedure BeepOk;
begin
  MessageBeep(MB_OK);
end;

 procedure BeepInformation;
begin
  MessageBeep(MB_ICONINFORMATION);
end;

procedure BeepExclamation;
begin
    MessageBeep(MB_ICONEXCLAMATION);
end;

procedure BeepAsterisk;
begin
    MessageBeep(MB_ICONASTERISK);
end;

procedure BeepQuestion;
begin
    MessageBeep(MB_ICONQUESTION);
end;

procedure BeepHand;
begin
    MessageBeep(MB_ICONHAND);       
end;

procedure CenterDlg(AForm: TForm; MForm: TForm);   { Zentriert Forms }
begin
     With AForm Do Begin
          Left := Abs(MForm.Left) + Round(Abs(MForm.Width - Width) / 2);
          Top := Abs(MForm.Top) + Round(Abs(MForm.Height - Height) / 2);
     End;
end;


function RemoveDF(aString:String):String;
begin
 result:=aString;
 while pos(ThousandSeparator,result) > 0 do
  result:=Copy(result,1,pos(ThousandSeparator,result)-1)+Copy(result,pos(ThousandSeparator,result)+1,length(result))
end;

 function RefStringListCopy(aRefArray:TStringlist):TStringList;
  var i,e:LongInt;
 begin
  result:=TStringList.Create;
  for i:=0 to aRefArray.Count-1 do begin
   Result.AddObject(aRefArray.Strings[i],TStringList.Create);
   for e:=0 to TStringList(aRefArray.Objects[i]).Count-1 do
    TStringList(Result.Objects[i]).AddObject(TStringList(aRefArray.Objects[i]).Strings[e],
     TStringList(aRefArray.Objects[i]).Objects[e]);
  end;
 end;





(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPerfTimer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPerfTimer') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPerfTimer') do begin
    RegisterMethod('Procedure Start');
    RegisterMethod('Function ReadNanoseconds : string');
    RegisterMethod('Function ReadMilliseconds : string');
    RegisterMethod('Function ReadSeconds : String');
    RegisterMethod('Function ReadValue : Int64');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GR32_System(CL: TPSPascalCompiler);
begin
  SIRegister_TPerfTimer(CL);
 CL.AddDelphiFunction('Function GetTickCount : Cardinal');
 CL.AddDelphiFunction('Function GetProcessorCount : Cardinal');
  CL.AddTypeS('TCPUInstructionSet', '( ciMMX, ciEMMX, ciSSE, ciSSE2, ci3DNow, ci3DNowExt )');
  CL.AddTypeS('TCPUInstructionSet', '( ciDummy )');
  //CL.AddTypeS('PCPUFeatures', '^TCPUFeatures // will not work');
  CL.AddTypeS('TCPUFeatures', 'set of TCPUInstructionSet');
 CL.AddDelphiFunction('Function HasInstructionSet( const InstructionSet : TCPUInstructionSet) : Boolean');
 CL.AddDelphiFunction('Function CPUFeatures : TCPUFeatures');
 //from CALWIN32 !
  CL.AddDelphiFunction('Function Null2Blank( aString : String) : String');
  CL.AddDelphiFunction('Function booltoint( aBool : Boolean) : LongInt');
 CL.AddDelphiFunction('Function inttobool( aInt : LongInt) : Boolean');
 CL.AddDelphiFunction('Function IntTo3Str( Value : Longint; separator: string) : string');
 CL.AddDelphiFunction('function IsReadOnly(const Filename: string): boolean;');
 CL.AddDelphiFunction('Procedure BeepOk');
 CL.AddDelphiFunction('Procedure BeepQuestion');
 CL.AddDelphiFunction('Procedure BeepHand');
 CL.AddDelphiFunction('Procedure BeepExclamation');
 CL.AddDelphiFunction('Procedure BeepAsterisk');
 CL.AddDelphiFunction('Procedure BeepInformation');
 CL.AddDelphiFunction('Procedure CenterDlg( AForm : TForm; MForm : TForm)');
 CL.AddDelphiFunction('Procedure CenterForm( AForm : TForm; MForm : TForm)');
 CL.AddDelphiFunction('Procedure CenterFrm( AForm : TForm; MForm : TForm)');
 CL.AddDelphiFunction('Function RemoveDF( aString : String) : String');
 CL.AddDelphiFunction('Function RefStringlistCopy( aRefArray : TStringList) : TStringList');


end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_GR32_System_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetTickCount, 'GetTickCount', cdRegister);
 S.RegisterDelphiFunction(@GetProcessorCount, 'GetProcessorCount', cdRegister);
 S.RegisterDelphiFunction(@HasInstructionSet, 'HasInstructionSet', cdRegister);
 S.RegisterDelphiFunction(@CPUFeatures, 'CPUFeatures', cdRegister);
 S.RegisterDelphiFunction(@Null2Blank, 'Null2Blank', cdRegister);
 S.RegisterDelphiFunction(@booltoint, 'booltoint', cdRegister);
 S.RegisterDelphiFunction(@inttobool, 'inttobool', cdRegister);
 S.RegisterDelphiFunction(@intto3str, 'intto3str', cdRegister);
 S.RegisterDelphiFunction(@IsReadOnly, 'IsReadOnly', cdRegister);
 S.RegisterDelphiFunction(@BeepOk, 'BeepOk', cdRegister);
 S.RegisterDelphiFunction(@BeepQuestion, 'BeepQuestion', cdRegister);
 S.RegisterDelphiFunction(@BeepHand, 'BeepHand', cdRegister);
 S.RegisterDelphiFunction(@BeepExclamation, 'BeepExclamation', cdRegister);
 S.RegisterDelphiFunction(@BeepAsterisk, 'BeepAsterisk', cdRegister);
 S.RegisterDelphiFunction(@BeepInformation, 'BeepInformation', cdRegister);
 S.RegisterDelphiFunction(@RemoveDF, 'RemoveDF', cdRegister);
 //S.RegisterDelphiFunction(@FormatNumber, 'FormatNumber', cdRegister);
 S.RegisterDelphiFunction(@CenterDlg, 'CenterDlg', cdRegister);
 S.RegisterDelphiFunction(@CenterDlg, 'CenterForm', cdRegister);
 S.RegisterDelphiFunction(@CenterDlg, 'CenterFrm', cdRegister);
 S.RegisterDelphiFunction(@RefStringlistCopy, 'RefStringlistCopy', cdRegister);



 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPerfTimer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPerfTimer) do begin
    RegisterMethod(@TPerfTimer.Start, 'Start');
    RegisterMethod(@TPerfTimer.ReadNanoseconds, 'ReadNanoseconds');
    RegisterMethod(@TPerfTimer.ReadMilliseconds, 'ReadMilliseconds');
    RegisterMethod(@TPerfTimer.ReadSeconds, 'ReadSeconds');
    RegisterMethod(@TPerfTimer.ReadValue, 'ReadValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GR32_System(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPerfTimer(CL);
end;



{ TPSImport_GR32_System }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_System.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GR32_System(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_System.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GR32_System(ri);
  RIRegister_GR32_System_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
