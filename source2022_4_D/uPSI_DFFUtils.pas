unit uPSI_DFFUtils;

{
  after passing the syn test, add sveral routines regexscan
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
  TPSImport_DFFUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_DFFUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DFFUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Stdctrls
  ,Grids
  ,DFFUtils
  ,UGetParens, ShellAPI
  ,DB, Forms, Controls, FileUtils, gsUtils, SynRegExpr, JVStrings, Dialogs, fmain
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DFFUtils]);
end;


procedure searchAndOpenDoc(vfilenamepath: string);
var FileName: string;
begin
  if fileexists(vfilenamepath) then begin
    FileName:= vfilenamepath;
    ShellAPI.ShellExecute(HInstance, NIL, pchar(FileName), NIL, NIL, sw_ShowNormal);
  end else
    Showmessage('Sorry, filepath to '+vfilenamepath+' is missing')
    //MessageBox(0, pChar('Sorry, filepath to '+vfilenamepath+' is missing'),'maXbox Doc',MB_OKCANCEL);
end;


procedure WriteDataSetToCSV(DataSet: TDataSet; FileName: String);
var
  List: TStringList;
  S: String;
  I: Integer;
begin
  List := TStringList.Create;
  try
    DataSet.First;
    while not DataSet.Eof do begin
      S := '';
      for I := 0 to DataSet.FieldCount - 1 do begin
        if S > '' then
          S := S + ',';
        S := S + '"' + DataSet.Fields[I].AsString + '"';
      end;
      List.Add(S);
      DataSet.Next;
    end;
  finally
    List.SaveToFile(FileName);
    List.Free;
  end;
end;

Procedure regExPathfinder(Pathin, fileout, firstp, aregex, ext: string; asort: boolean);
//Find all directories above and including the current one
var
  dirList, rlist, linelst: TStringList;
  i, fhandle, cntr, ftot, offset, linecnt: integer;
  fstr: string;
begin
  screen.cursor:= CRhourglass;
  dirList:= TStringList.Create;
  ftot:= 0;
  offset:= 0;
   if not FileExists(fileout) then begin
      fhandle:= FileCreate(fileout);
      FileClose(fhandle)
   end;
  try
    //FindDirectories(dirList, ExePath);
    GetDirList(pathin,dirlist,true);
    rlist:= TStringlist.create;
    rlist.add('mX RegEx SONAR Code Pattern Search in '+pathin);
    rlist.add(S_RepeatChar(90,'*'));

  for i:= 0 to dirlist.count-1 do begin
   // for i:= 0 to 10 - 1 do begin
    //fstr:= loadFileasString(dirlist[i]);
//fstr:= loadFileasString('C:\maXbook\maxbox3\mX3999\maxbox3\source\JCL\source\JclGraphics_test.pas');
    //{extback:= PathFindExtension(dirlist[i]);
      //S_ShellExecute(exepath+'maxbox3.exe',dirlist[i],seCMDOpen);
   if ExtractFileExt(dirlist[i]) = ext then
     with TRegExpr.Create do try
      fstr:= loadFileasString(dirlist[i]);
      linelst:= TStringlist.create;
      linelst.loadfromfile(dirlist[i]);
      linecnt:= linelst.count-1;
      linelst.Free;
      //firstp; //'extends';  //public
      //gstr2:= ' Category, CheckId, Status, Created' 'implements';
      modifierS:= false; //!non greedy  code around clock
      modifierI:= true;  //case insens
      //Expression:= gstr+'.*([\d]+,[\d]).*?'; //array
      //Expression:= '.*([\d]+).*?';     //all numb
      //Expression:= '.*([\d],).*?';     //all numbs and signs
      //Expression:= '.*[a-zA-Z_]\(\w[\d]+\)*?';     //numbers in name (X1)
      //Expression:= '.*\([\d]\).*?';     //magic numbs just one parameter!
      //Expression:= '.*\([\d]+\)*?';     //magic numbs after (
      //Expression:= '.*\([\d]+,[\d]\)*?';     //numbs more than one in para
      //Expression:= '.*[a-zA-Z_]\([\w][\d]+\)*?';   //magic numbs with X1)
      //Expression:= gstr+'.*[a-zA-Z_]\([*,\d]+\)'+gstr2+'*?';  //mnumbs allwith N(d(d))
      Expression:= firstp+aregex;  //mnumbs allwith N(d(d))
      cntr:= 0;
      if asort then
        rlist.Sorted:= true;   //before dup!
        rlist.duplicates:= dupAccept;//true; //false is dupIgnore; ?
      //rlist.Add(Format(inttoStr(i)+' Fileto: %s ',[dirlist[i]]));
      //TODO: count the files which has regex found! change savestring

      if Exec(fstr) then
       try //save console out count categories
           rlist.Add(Format(inttoStr(i+offset)+' filein: %s ',[dirlist[i]]));
            savestring(extractfilepath(fileout)+inttostr(i+offset)+'_'
                     +extractfilename(dirlist[i])+'.txt',fstr);
         Repeat
           rlist.add(Match[0]);
           inc(cntr);
         Until Not ExecNext;
           inc(ftot);
           rlist.Add(Format('distSortMetrics: %d found %d of tot %d',
                                              [cntr,ftot, rlist.count-2]));
       except
         showmessage('''Exception in regex Review svnnavi'')');
       end;
    finally
      //writeln(inttostr(cntr)+ ' search total: '+gstr+' '+gstr2);
      Free;
      //rlist.Free;
    end; //with try
    //S_ShellExecute(exepath+'maxbox3.exe',dirlist[i],seCMDOpen);
    //writeln('*************** open '+dirlist[i]);
      //writeln(inttostr(cntr)+ ' search total of '+gstr+' '+gstr2);
     maxForm1.memo2.lines.add(Format('Search Metrics: %d of lines %d from %s to %s of %s',
                   [cntr, linecnt, firstp,aregex , extractfilename(dirlist[i])]))
     //memo2.lines.savetofile(AWORKPATH2+extractfilename(dirlist[i])+'.txt');
  end; //for dirlist loop
    rlist.SavetoFile(fileout);
    //writeln('File Saved at: '+fileout+' of total '+inttostr(i)+' files');
    maxForm1.memo2.lines.Add('File Saved at: '+fileout+' of total '+inttostr(i)+' files');
  finally
    dirList.Free;
    rlist.Free;
    screen.cursor:= CRdefault;
    SearchandOpenDoc(fileout);
  end;//for
end;


Procedure regExPathfinder2(Pathin, fileout, firstp, aregex,
                                    ext: string; asort, acopy: boolean);
//Find all directories above and including the current one
var
  dirList, rlist, linelst: TStringList;
  i, fhandle, cntr, ftot, offset, linecnt: integer;
  fstr: string;
begin
  screen.cursor:= CRhourglass;
  dirList:= TStringList.Create;
  ftot:= 0;
  offset:= 0;
   if not FileExists(fileout) then begin
      fhandle:= FileCreate(fileout);
      FileClose(fhandle)
   end;
   if not DirectoryExists(fileout) then begin
      CreateDir(extractfilepath(fileout))
      //FileClose(fhandle)
   end;
  try
    //FindDirectories(dirList, ExePath);
    GetDirList(pathin,dirlist,true);
    rlist:= TStringlist.create;
    rlist.add('mX RegEx SONAR Code Pattern Search2 in '+pathin);
    rlist.add(S_RepeatChar(90,'*'));
    rlist.add('dir list '+inttostr(dirlist.count));

  for i:= 0 to dirlist.count-1 do begin     //dir list 25873
  //for i:= 0 to 100-1 do begin     //dir list 25873
   // for i:= 0 to 10 - 1 do begin
   //fstr:= loadFileasString(dirlist[i]);
//fstr:= loadFileasString('C:\maXbook\maxbox3\mX3999\maxbox3\source\JCL\source\JclGraphics_test.pas');
    //{extback:= PathFindExtension(dirlist[i]);
      //S_ShellExecute(exepath+'maxbox3.exe',dirlist[i],seCMDOpen);
   linecnt:= 0;
   cntr:= 0;
   if AnsiUppercase(ExtractFileExt(dirlist[i])) = (ansiuppercase(ext)) then
   //if ExtractFileExt(dirlist[i]) = ext then

     with TRegExpr.Create do try
      try
        fstr:= loadFileasString(dirlist[i]);
        linelst:= TStringlist.create;
        linelst.loadfromfile(dirlist[i]);
        linecnt:= linelst.count-1;
        linelst.Free;
      except
        showmessage('ERROR: The filename or extension is too long.');
      end;  
      //gstr2:= ' CheckId, Status, Created' 'implements'; 
      modifierS:= false; //!non greedy  code around clock
      modifierI:= true;  //case insens
      //Expression:= gstr+'.*([\d]+,[\d]).*?'; //array
      //Expression:= '.*([\d]+).*?';     //all numb
      //Expression:= '.*([\d],).*?';     //all numbs and signs
      //Expression:= '.*[a-zA-Z_]\(\w[\d]+\)*?';  //numbs in name (X1)
      //Expression:= '.*\([\d]\).*?';     //numbs just one parameter!
      //Expression:= '.*\([\d]+\)*?';     //magic numbs after (
      //Expression:= '.*\([\d]+,[\d]\)*?';     //more than one in para
      //Expression:= '.*[a-zA-Z_]\([\w][\d]+\)*?';   //magic numbs with X1)
      //Expression:= gstr+'.*[a-zA-Z_]\([*,\d]+\)'+gstr2+'*?';//mn allwith N(d(d))
      Expression:= firstp+aregex;  //mnumbs allwith N(d(d))
      //cntr:= 0;
      if asort then
        rlist.Sorted:= true;   //before dup!
        rlist.duplicates:= dupAccept; //true; //false is dupIgnore; ?
      //rlist.Add(Format(inttoStr(i)+' Fileto: %s ',[dirlist[i]]));
      //TODO: count files which has regex found! change savestring
       
      if Exec(fstr) then 
       try //save console out count categories
           rlist.Add(Format(inttoStr(i+offset)+' filein: %s ',[dirlist[i]]));
         if acopy then
            savestring(extractfilepath(fileout)+inttostr(i+offset)+'_'
                     +extractfilename(dirlist[i])+'.txt',fstr);
         Repeat 
           rlist.add(Match[0]); 
           inc(cntr);
         Until Not ExecNext; 
           inc(ftot);
           rlist.Add(Format('SortMetrics: %d found %d of tot %d',
                                            [cntr,ftot, rlist.count-2]));
       except
         showmessage('''Exception in regex Review svnnavi'')');
         //writeln('''Exception in regex Review svnnavi'')');

       end;    
    finally 
      Free;
    end; //with try
    //S_ShellExecute(exepath+'maxbox3.exe',dirlist[i],seCMDOpen);
      //writeln(inttostr(cntr)+ ' search total of '+gstr+' '+gstr2);
     maxForm1.memo2.lines.add(Format('SearchMetrics: %d of lines %d from %s to %s of %s',
                   [cntr, linecnt, firstp,aregex , extractfilename(dirlist[i])]));
  end; //for dirlist loop
    rlist.add(maxForm1.memo2.text);
    rlist.SavetoFile(fileout);
   // writeln('File Saved at: '+fileout+' of total '+inttostr(i)+' files');
    maxForm1.memo2.lines.Add('File Saved at: '+fileout+' of total '+inttostr(i)+' files');
  finally
    dirList.Free;
    rlist.Free;
    screen.cursor:= CRdefault;
    SearchandOpenDoc(fileout);
  end;//for
end;  





(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_DFFUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure reformatMemo( const m : TCustomMemo)');
 CL.AddDelphiFunction('Procedure SetMemoMargins( m : TCustomMemo; const L, T, R, B : integer)');
 CL.AddDelphiFunction('Procedure MoveToTop( memo : TMemo)');
 CL.AddDelphiFunction('Procedure ScrollToTop( memo : TMemo)');
 CL.AddDelphiFunction('Function LineNumberClicked( memo : TMemo) : integer');
 CL.AddDelphiFunction('Function MemoClickedLine( memo : TMemo) : integer');
 CL.AddDelphiFunction('Function ClickedMemoLine( memo : TMemo) : integer');
 CL.AddDelphiFunction('Function MemoLineClicked( memo : TMemo) : integer');
 CL.AddDelphiFunction('Function LinePositionClicked( Memo : TMemo) : integer');
 CL.AddDelphiFunction('Function ClickedMemoPosition( memo : TMemo) : integer');
 CL.AddDelphiFunction('Function MemoPositionClicked( memo : TMemo) : integer');
 CL.AddDelphiFunction('Procedure AdjustGridSize( grid : TDrawGrid)');
 CL.AddDelphiFunction('Procedure DeleteGridRow( Grid : TStringGrid; const ARow : integer)');
 CL.AddDelphiFunction('Procedure InsertgridRow( Grid : TStringGrid; const ARow : integer)');
 CL.AddDelphiFunction('Procedure Sortgrid( Grid : TStringGrid; const SortCol : integer);');
 CL.AddDelphiFunction('Procedure Sortgrid1( Grid : TStringGrid; const SortCol : integer; sortascending : boolean);');
 CL.AddDelphiFunction('Procedure sortstrDown( var s : string)');
 CL.AddDelphiFunction('Procedure sortstrUp( var s : string)');
 CL.AddDelphiFunction('Procedure rotatestrleft( var s : string)');
 CL.AddDelphiFunction('Function dffstrtofloatdef( s : string; default : extended) : extended');
 CL.AddDelphiFunction('Function deblank( s : string) : string');
 CL.AddDelphiFunction('Function IntToBinaryString( const n : integer; MinLength : integer) : string');
 CL.AddDelphiFunction('Procedure FreeAndClearListBox( C : TListBox);');
 CL.AddDelphiFunction('Procedure FreeAndClearMemo( C : TMemo);');
 CL.AddDelphiFunction('Procedure FreeAndClearStringList( C : TStringList);');
 CL.AddDelphiFunction('Function dffgetfilesize( f : TSearchrec) : int64');
 CL.AddDelphiFunction('Procedure GetParens( Variables : string; OpChar : char; var list : TStringlist)');
 CL.AddDelphiFunction('procedure WriteDataSetToCSV(DataSet: TDataSet; FileName: String)');
 CL.AddDelphiFunction('Procedure regExPathfinder(Pathin, fileout, firstp, aregex, ext: string; asort: boolean)');
 CL.AddDelphiFunction('Procedure regExPathfinder2(Pathin, fileout, firstp, aregex, ext: string; asort, acopy: boolean)');





end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure FreeAndClear2_P( C : TStringList);
Begin DFFUtils.FreeAndClear(C); END;

(*----------------------------------------------------------------------------*)
Procedure FreeAndClear1_P( C : TMemo);
Begin DFFUtils.FreeAndClear(C); END;

(*----------------------------------------------------------------------------*)
Procedure FreeAndClear_P( C : TListBox);
Begin DFFUtils.FreeAndClear(C); END;

(*----------------------------------------------------------------------------*)
Procedure Sortgrid1_P( Grid : TStringGrid; const SortCol : integer; sortascending : boolean);
Begin DFFUtils.Sortgrid(Grid, SortCol, sortascending); END;

(*----------------------------------------------------------------------------*)
Procedure Sortgrid_P( Grid : TStringGrid; const SortCol : integer);
Begin DFFUtils.Sortgrid(Grid, SortCol); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DFFUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@reformatMemo, 'reformatMemo', cdRegister);
 S.RegisterDelphiFunction(@SetMemoMargins, 'SetMemoMargins', cdRegister);
 S.RegisterDelphiFunction(@MoveToTop, 'MoveToTop', cdRegister);
 S.RegisterDelphiFunction(@ScrollToTop, 'ScrollToTop', cdRegister);
 S.RegisterDelphiFunction(@LineNumberClicked, 'LineNumberClicked', cdRegister);
 S.RegisterDelphiFunction(@MemoClickedLine, 'MemoClickedLine', cdRegister);
 S.RegisterDelphiFunction(@ClickedMemoLine, 'ClickedMemoLine', cdRegister);
 S.RegisterDelphiFunction(@MemoLineClicked, 'MemoLineClicked', cdRegister);
 S.RegisterDelphiFunction(@LinePositionClicked, 'LinePositionClicked', cdRegister);
 S.RegisterDelphiFunction(@ClickedMemoPosition, 'ClickedMemoPosition', cdRegister);
 S.RegisterDelphiFunction(@MemoPositionClicked, 'MemoPositionClicked', cdRegister);
 S.RegisterDelphiFunction(@AdjustGridSize, 'AdjustGridSize', cdRegister);
 S.RegisterDelphiFunction(@DeleteGridRow, 'DeleteGridRow', cdRegister);
 S.RegisterDelphiFunction(@InsertgridRow, 'InsertgridRow', cdRegister);
 S.RegisterDelphiFunction(@Sortgrid, 'Sortgrid', cdRegister);
 S.RegisterDelphiFunction(@Sortgrid1_P, 'Sortgrid1', cdRegister);
 S.RegisterDelphiFunction(@sortstrDown, 'sortstrDown', cdRegister);
 S.RegisterDelphiFunction(@sortstrUp, 'sortstrUp', cdRegister);
 S.RegisterDelphiFunction(@rotatestrleft, 'rotatestrleft', cdRegister);
 S.RegisterDelphiFunction(@strtofloatdef, 'dffstrtofloatdef', cdRegister);
 S.RegisterDelphiFunction(@deblank, 'deblank', cdRegister);
 S.RegisterDelphiFunction(@IntToBinaryString, 'IntToBinaryString', cdRegister);
 S.RegisterDelphiFunction(@FreeAndClear, 'FreeAndClearListbox', cdRegister);
 S.RegisterDelphiFunction(@FreeAndClear1_P, 'FreeAndClearMemo', cdRegister);
 S.RegisterDelphiFunction(@FreeAndClear2_P, 'FreeAndClearStringlist', cdRegister);
 S.RegisterDelphiFunction(@getfilesize, 'dffgetfilesize', cdRegister);
 S.RegisterDelphiFunction(@GetParens, 'GetParens', cdRegister);
 S.RegisterDelphiFunction(@WriteDataSetToCSV, 'WriteDataSetToCSV', cdRegister);
 S.RegisterDelphiFunction(@regExPathfinder, 'regExPathfinder', cdRegister);
 S.RegisterDelphiFunction(@regExPathfinder2, 'regExPathfinder2', cdRegister);



end;



{ TPSImport_DFFUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DFFUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DFFUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DFFUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_DFFUtils(ri);
  RIRegister_DFFUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
