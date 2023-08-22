unit PSResources;

// typed for maXbox  https://github.com/fabriciocolombo/PascalScriptEx/tree/master/src
// https://lawrencebarsanti.wordpress.com/2009/11/28/introduction-to-pascal-script/

interface

uses Classes, SysUtils, uPSRunTime, uPSCompiler, uPSComponent, Variants, Types, TypInfo, uPSUtils;

resourcestring
  sBeginCompile = 'Compiling';
  sSuccessfullyCompiled = 'Succesfully compiled';
  sSuccessfullyExecuted = 'Succesfully executed';
  sRuntimeError = '[Runtime error] %s(%d:%d), bytecode(%d:%d): %s';
  sTextNotFound = 'Text not found';
  sUnnamed = 'Unnamed';
  sEditorTitle = 'Editor';
  sEditorTitleRunning = 'Editor - Running';
  sEditorTitlePaused = 'Editor - Paused';
  sEditorTitleStopped = 'Editor - Stopped';
  sInputBoxTiyle = 'Script';
  sFileNotSaved = 'File has not been saved, save now?';
  sEmptyProgram = 'Program myprogram;' + sLineBreak + sLineBreak +
                  'begin' + sLineBreak +
                  'end.';

const
  isRunningOrPaused = [isRunning, isPaused];

type
  TPSUtils = class
  private
    class function SetToString(APsScript: TPSScript; AType: TPSSetType; const Value: PIfRVariant): String;
  public
    class function GetValue(AValue: PIfRVariant): Variant;
    class function GetAsString(APsScript: TPSScript; AValue: PIfRVariant): String;

    class function GetPSTypeName(APsScript: TPSScript; APSType: TPSType): TbtString;
    class function GetMethodDeclaration(AMethodName: TbtString; APSParametersDecl: TPSParametersDecl): TbtString;
    class function GetMethodParametersDeclaration(APSParametersDecl: TPSParametersDecl): TbtString;

    class function GetEnumBounds(APsScript: TPSScript; AType: TPSType; out ALow, AHigh: TbtString) : Boolean;
  end;

  function list_functions: TStringlist;
  function list_functions2: TStringlist;
  function list_functions3: TStringlist;
  procedure InternalRaiseException(E: Exception);
  function ListFiles(ADirectory, AFilter: String; AList: TStrings) : Boolean;


implementation

uses StrUtils, fmain;

type PtrUInt = DWord;


function TFEditorBuildRegFuncList(Sender: TPSScript): TStringlist;
var i, j, typ: integer;
    SaveFunclist: TStringList;  FuncList, InsertList: TStringList;
    S: string;
begin
  FuncList := TStringList.Create;
  InsertList := TStringList.Create;
  FuncList.Clear;
  InsertList.Clear;
  for i := 0 to Sender.Comp.GetRegProcCount-1 do  begin
    //procedure Getdecl(decl : TPSParametersDecl; var T,v :string);
    s:= Sender.Comp.GetRegProc(i).OrgName;
    if (s <> '') and (s[1] <> '_') and (UpperCase(s) <> s) then begin
      if Sender.Comp.GetRegProc(i).Decl.Result <> nil then begin
        //s := 'function ' + s;
        typ := 0;
      end else begin
        //s := 'procedure ' + s;
        typ := 1;
      end;

      Insertlist.Add(s);

      s := s + '(';
      for j := 0 to Sender.Comp.GetRegProc(i).Decl.ParamCount - 1 do begin
        if j <> 0 then s := s + ' ';
        s := s + Sender.Comp.GetRegProc(i).Decl.Params[j].OrgName;
        if Sender.Comp.GetRegProc(i).Decl.Params[j].aType <> nil then begin
          s := s + ': ' + Sender.Comp.GetRegProc(i).Decl.Params[j].aType.OriginalName;
          if j <> Sender.Comp.GetRegProc(i).Decl.ParamCount - 1 then s := s + ';';
        end;
      end;
      if Sender.Comp.GetRegProc(i).Decl.Result <> nil then begin
        s := s + '): ' + Sender.Comp.GetRegProc(i).Decl.Result.OriginalName + ';';
      end else begin
        s := s + ');';
      end;
      Funclist.AddObject(S, TObject(typ));
     end;
  end;

  //Insertlist.Sort;
  //Funclist.Sort;

  for i := 0 to Funclist.Count -1 do begin
    if PtrUInt(Funclist.Objects[i]) = 1 then begin
      Funclist.Strings[i] := ' procedure ' + Funclist.Strings[i];
    end else begin
      Funclist.Strings[i] := ' function ' + Funclist.Strings[i];
    end;
  end;

  result:= Funclist;

  {SaveFunclist := TStringList.Create;
  try
    SaveFunclist.AddStrings(Funclist);
    SaveFunclist.SaveToFile('funclist47620.txt');
  finally
    SaveFunclist.Free;
  end; }
end;

procedure InternalRaiseException(E: Exception);
begin
  raise E;
end;

function ListFiles(ADirectory, AFilter: String; AList: TStrings) : Boolean;
var
  S: TSearchRec;
  vDir: String;
begin
  vDir := IncludeTrailingPathDelimiter(ADirectory);

  if not DirectoryExists(vDir) then
  begin
    raise Exception.CreateFmt('Directory "%s" does not exists.', [vDir]);
  end;

  try
    Result := FindFirst(vDir + AFilter, faAnyFile, S) = 0;
    repeat
      if (S.Name <> '.') and (S.Name <> '..') then begin
        AList.Add(vDir + S.name);
      end;
    until FindNext(S) <> 0;
  finally
    FindClose(S);
  end;
end;


function ExtendCompiler(Compiler: TPSPascalCompiler; const Name: AnsiString): Boolean;
var
    CustomClass: TPSCompileTimeClass;
begin
  try
    Compiler.AddDelphiFunction('function list_functions: TStringlist;');
    //SIRegisterTObject(Compiler); // Add compile-time definition for TObject
    //CustomClass := Compiler.AddClass(Compiler.FindClass('TObject'), TAccumulator);
    //Customclass.RegisterMethod('procedure Add(AValue: Integer)');
    //CustomClass.RegisterMethod('function GetTotal: Integer');
    Result := True;
  except
    Result := False; // will halt compilation
  end;
end;

var afunclist: TStringlist;

function ExtendCompiler2(Compiler: TPSPascalCompiler; const Name: AnsiString): Boolean;
var
    CustomClass: TPSCompileTimeClass;
begin
  try
    //compiler:= maxForm1.PSScript.Comp;
    //Compiler.AddDelphiFunction('function TFEditorBuildRegFuncList(Sender: TPSScript): TStringlist;');
    afunclist:= TFEditorBuildRegFuncList(maxForm1.PSScript);
    maxform1.memo2.Lines.Add('script comp on uses call back');
    //SIRegisterTObject(Compiler); // Add compile-time definition for TObject
    //CustomClass := Compiler.AddClass(Compiler.FindClass('TObject'), TAccumulator);
    //Customclass.RegisterMethod('procedure Add(AValue: Integer)');
    //CustomClass.RegisterMethod('function GetTotal: Integer');
    Result := True;
  except
    Result := False; // will halt compilation
  end;
end;

function ExtendCompiler3(Compiler: TPSPascalCompiler; const Name: AnsiString): Boolean;
var
    CustomClass: TPSCompileTimeClass;
begin
  try
    //compiler:= maxForm1.PSScript.Comp;
    //maxForm1.PSScript.Comp:= compiler;
    maxForm1.PSScript.LoadExec;
    //maxForm1.PSScript.Comp:= compiler;
    //CustomClass:= maxForm1.PSScript.RuntimeImporter;
    //maxForm1.PSScript.compile;
    //maxForm1.PSScript.RuntimeImporter;
    //Compiler.AddDelphiFunction('function TFEditorBuildRegFuncList(Sender: TPSScript): TStringlist;');
    afunclist:= TFEditorBuildRegFuncList(maxForm1.PSScript);
    //afunclist:= TFEditorBuildRegFuncList(compiler);
    maxform1.memo2.Lines.Add('script3 comp on uses call back');
    //SIRegisterTObject(Compiler); // Add compile-time definition for TObject
    //CustomClass := Compiler.AddClass(Compiler.FindClass('TObject'), TAccumulator);
    //Customclass.RegisterMethod('procedure Add(AValue: Integer)');
    //CustomClass.RegisterMethod('function GetTotal: Integer');
    Result := True;
  except
    Result := False; // will halt compilation
  end;
end;

function list_functions: TStringlist;
var Compiler: TPSPascalCompiler;
begin
  //maxForm1.PSScript.Comp.OnUses:= ExtendCompiler;
    //Compiler := TPSPascalCompiler.Create;
    //Compiler.OnUses := ExtendCompiler;
  result:= TFEditorBuildRegFuncList(maxForm1.PSScript);
end;

const Fdemo =
'program Delphi_in_a_Box_Demo_3;   '+#13#10+
'begin                             '+#13#10+
'  //... add more code here        '+#13#10+
'end.                              ';

function list_functions2: TStringlist;
var Compiler: TPSPascalCompiler;
    ret: boolean;
begin
  afunclist:= TStringlist.create;

  maxForm1.PSScript.Comp.OnUses:= ExtendCompiler2;
  //ret := maxForm1.PSScript.Comp.Compile(Fdemo);
   ret := maxForm1.PSScript.Comp.Compile(maxForm1.PSScript.script.text);
  if ret then maxform1.memo2.Lines.Add('script comp back');
  //maxForm1.PSScript.Comp.OnUses:= ExtendCompiler2;
  //maxForm1.PSScript.Execute;
  //funclist:= TFEditorBuildRegFuncList(maxForm1.PSScript);
  result:= afunclist;
  maxform1.memo2.Lines.Add('script count back '+inttostr(result.count));
  maxForm1.PSScript.Comp.OnUses:= Nil;
  //afunclist.Free;
    //Compiler := TPSPascalCompiler.Create;
    //Compiler.OnUses := ExtendCompiler;
  //result:= TFEditorBuildRegFuncList(maxForm1.PSScript);
end;

function list_functions3: TStringlist;
var Compiler: TPSPascalCompiler;
    ret: boolean;
begin
  afunclist:= TStringlist.create;
  //maxForm1.PSScript.compile;
  compiler:=   maxForm1.PSScript.Comp;
  maxForm1.PSScript.Comp.OnUses:= ExtendCompiler3;
  //ret := maxForm1.PSScript.Comp.Compile(Fdemo);
   ret := maxForm1.PSScript.Comp.Compile(maxForm1.PSScript.script.text);
 //   maxform1.memo2.Lines.Add(maxForm1.PSScript.script.text);
  if ret then maxform1.memo2.Lines.Add('script comp back3');
  //maxForm1.PSScript.Comp.OnUses:= ExtendCompiler3;
  //maxForm1.PSScript.Execute;
  //funclist:= TFEditorBuildRegFuncList(maxForm1.PSScript);
  result:= afunclist;
  maxform1.memo2.Lines.Add('script count back3 '+inttostr(result.count));
  maxForm1.PSScript.Comp.OnUses:= Nil;
  //afunclist.Free;
    //Compiler := TPSPascalCompiler.Create;
    //Compiler.OnUses := ExtendCompiler;
  //result:= TFEditorBuildRegFuncList(maxForm1.PSScript);
end;

{ TConstanstUtils }

class function TPSUtils.GetAsString(APsScript: TPSScript; AValue: PIfRVariant): String;
begin
  case AValue.FType.BaseType of
    btChar: Result := String(tbtChar(AValue^.tchar));
    btString: Result := String(tbtstring(AValue^.tstring));
    btWideChar: Result := AValue^.twidechar;
    {$IFNDEF PS_NOWIDESTRING}
    btWideString: Result := tbtWideString(AValue^.twidestring);
    {$ENDIF}
    btUnicodeString: Result := tbtUnicodeString(AValue^.tunistring);
    btU8: Result := SysUtils.IntToStr(TbtU8(AValue^.tu8));
    btS8: Result := SysUtils.IntToStr(TbtS8(AValue^.tS8));
    btU16: Result := SysUtils.IntToStr(TbtU16(AValue^.tu16));
    btS16: Result := SysUtils.IntToStr(TbtS16(AValue^.ts16));
    btSet: begin
             //-'set of ' + String(TPSSetType(AValue^.FType).SetType.OriginalName);
             Result := SetToString(APsScript, TPSSetType(TPSSetType(AValue^.FType).SetType), AValue);
           end;
    btU32: Result := SysUtils.IntToStr(TbtU32(AValue^.tu32));
    btEnum: begin
             Result := Format('%s(%d)', [AValue^.FType.OriginalName, TbtU32(AValue^.tu32)]);
            end;
    btS32: Result := SysUtils.IntToStr(TbtS32(AValue^.ts32));
    btSingle: Result := SysUtils.FloatToStr(TbtSingle(AValue^.tsingle));
    btDouble: Result := SysUtils.FloatToStr(TbtDouble(AValue^.tdouble));
    btExtended: Result := SysUtils.FloatToStr(AValue^.textended);
    btCurrency: Result := SysUtils.CurrToStr(AValue^.tcurrency);
    {$IFNDEF PS_NOINT64}
      btS64: Result := SysUtils.IntToStr(AValue^.ts64);
    {$ENDIF}
  else
    Result := EmptyStr;
  end;
end;

class function TPSUtils.GetEnumBounds(APsScript: TPSScript; AType: TPSType; out ALow, AHigh: TbtString) : Boolean;
var
  i: Integer;
  vConst: TPSConstant;
begin
  ALow := EmptyStr;
  AHigh := EmptyStr;

  for i := 0 to APsScript.Comp.GetConstCount-1 do begin
    vConst := APsScript.Comp.GetConst(i);

    if (vConst.Value^.FType = AType) then  begin
      if ALow = EmptyStr then begin
        ALow := vConst.OrgName;
      end;
      AHigh := vConst.OrgName;
    end;
  end;

  Result := (AHigh <> '');
end;

class function TPSUtils.GetMethodDeclaration(AMethodName: TbtString; APSParametersDecl: TPSParametersDecl): TbtString;
var
  vDecl: TbtString;
begin
  vDecl := AMethodName + GetMethodParametersDeclaration(APSParametersDecl);

  if APSParametersDecl.Result <> nil then
  begin
    Result := 'function ' + vDecl;
  end
  else
  begin
    Result := 'procedure ' + vDecl;
  end;
end;

class function TPSUtils.GetMethodParametersDeclaration(APSParametersDecl: TPSParametersDecl): TbtString;
var
  i: Integer;
  vDecl: TbtString;
  vParam: TPSParameterDecl;
begin
  vDecl := EmptyStr;
  for i := 0 to APSParametersDecl.ParamCount-1 do begin
    vParam := APSParametersDecl.Params[i];

    case vParam.Mode of
      pmOut: vDecl := vDecl + 'out ';
      pmInOut: vDecl := vDecl + 'var ';
    end;

    vDecl := vDecl + vParam.OrgName;

    if vParam.aType <> nil then
    begin
      vDecl := vDecl + ': ' + vParam.aType.OriginalName;
    end;

    if (i < APSParametersDecl.ParamCount-1) then
    begin
      vDecl := vDecl + '; ';
    end;
  end;

  if (vDecl <> EmptyStr) then
  begin
    vDecl := '(' + vDecl + ')';
  end;

  Result := vDecl;

  if APSParametersDecl.Result <> nil then
  begin
    Result := Result + ':' + APSParametersDecl.Result.OriginalName;
  end;
end;

class function TPSUtils.GetPSTypeName(APsScript: TPSScript; APSType: TPSType): TbtString;
var
  vLow, vHigh: TbtString;
begin
  case APSType.BaseType of
    btProcPtr: Result := GetMethodDeclaration(APSType.OriginalName, TPSProceduralType(APSType).ProcDef);
//    BtTypeCopy: Result := TPSTypeLink.Create;
    btRecord: Result := 'record';
    btArray: Result := 'array of ' + GetPSTypeName(APsScript, TPSArrayType(APSType).ArrayTypeNo);
//    btStaticArray: Result := 'array of ' + GetPSTypeName(TPSStaticArrayType(APSType).ArrayTypeNo);
    btEnum: begin
              if GetEnumBounds(APsScript, APSType, vLow, vHigh) then
              begin
                Result := vLow + '..' + vHigh;
              end
              else
              begin
                Result := '0..' + IntToStr(TPSEnumType(APSType).HighValue);
              end;
            end;
    btClass: begin
               Result := 'class';

               with TPSClassType(APSType).Cl do
               begin
                 if Assigned(ClassInheritsFrom) then
                 begin
                   Result := Result + '(' + ClassInheritsFrom.aType.OriginalName + ')';
                 end;
               end;
             end;
    btExtClass: REsult := TPSUndefinedClassType(APSType).ExtClass.SelfType.OriginalName;
    btNotificationVariant, btVariant: Result := TPSVariantType(APSType).OriginalName;
    {$IFNDEF PS_NOINTERFACES}
    btInterface: begin
                   Result := 'interface';

                   with TPSInterfaceType(APSType).Intf do
                   begin
                     if Assigned(InheritedFrom) then
                     begin
                       Result := Result + '(' + InheritedFrom.aType.OriginalName + ')';
                     end;
                   end;
                 end;
    {$ENDIF}
  else
    Result := APSType.OriginalName;
  end;
end;

class function TPSUtils.GetValue(AValue: PIfRVariant): Variant;
begin
  case AValue.FType.BaseType of
    btChar: Result := tbtWidestring(AValue^.tchar);
    btString: Result := tbtWidestring(tbtstring(AValue^.tstring));
    btWideChar: Result := AValue^.twidechar;
    {$IFNDEF PS_NOWIDESTRING}
    btWideString: Result := tbtWideString(AValue^.twidestring);
    {$ENDIF}
    btUnicodeString: result := tbtUnicodeString(AValue^.tunistring);
    btU8: Result := TbtU8(AValue^.tu8);
    btS8: Result := TbtS8(AValue^.tS8);
    btU16: Result := TbtU16(AValue^.tu16);
    btS16: Result := TbtS16(AValue^.ts16);
    btU32, btEnum: Result := TbtU32(AValue^.tu32);
    btS32: Result := TbtS32(AValue^.ts32);
    btSingle: Result := TbtSingle(AValue^.tsingle);
    btDouble: Result := TbtDouble(AValue^.tdouble);
    btExtended: Result := TbtExtended(AValue^.textended);
    btCurrency: Result := TbtCurrency(AValue^.tcurrency);
    {$IFNDEF PS_NOINT64}
      btS64: Result := TbtS64(AValue^.ts64);
    {$ENDIF}
  else
    Result := varUnknown;
  end;
end;

class function TPSUtils.SetToString(APsScript: TPSScript; AType: TPSSetType; const Value: PIfRVariant): String;
var
  i: Integer;
  vConst: TPSConstant;
  vIntegerSet: TIntegerSet;
begin
  Result := EmptyStr;

  vIntegerSet := TIntegerSet(Value^.tstring^);

  for i := 0 to APsScript.Comp.GetConstCount-1 do begin
    vConst := APsScript.Comp.GetConst(i);

    if (vConst.Value^.FType = AType) then begin
      if vConst.Value^.ts32 in vIntegerSet  then begin
        Result := Result + vConst.OrgName + ',';
      end;
    end;
  end;

  Result := '[' + LeftStr(Result, Length(Result)-1) + ']';
end;

end.
