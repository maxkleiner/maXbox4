{$A8,B-,C-,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q+,R+,S-,T-,U-,V+,W-,X+,Y-,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
program maxbox3_9;

uses
  Forms, ShellAPI, 
  fMain in 'fMain.pas' {MaxForm1},
  uPSCompiler in 'uPSCompiler.pas',
  infobox1 in 'infobox1.pas' {AboutBox},
  ConfirmReplDlg in 'ConfirmReplDlg.pas' {ConfirmReplDialog},
  FindReplDlg in 'FindReplDlg.pas' {FindReplDialog},
  uPSI_MathMax in 'uPSI_MathMax.pas',
  ide_debugoutput in 'ide_debugoutput.pas' {debugoutput},
  uPSR_dateutils in 'uPSR_dateutils.pas',
  uPSC_dateutils in 'uPSC_dateutils.pas',
  WinForm1 in 'WinForm1.pas' {winFormp},
  IFSI_WinForm1puzzle in 'IFSI_WinForm1puzzle.pas',
  UCMainForm in 'usecase\UCMainForm.pas' {UCMainDlg},
  JimShape in 'usecase\JimShape.pas',
  CaptionEditForm in 'usecase\CaptionEditForm.pas' {CaptionEditDlg},
  IFSI_IdTCPClient in 'IFSI_IdTCPClient.pas',
  uPSI_StrUtils in 'uPSI_StrUtils.pas',
  IdHashCRC in 'IdHashCRC.pas',
  uPSI_IdHashCRC in 'uPSI_IdHashCRC.pas',
  IFSI_IdHTTP in 'IFSI_IdHTTP.pas',
  uPSI_IdHTTPHeaderInfo in 'uPSI_IdHTTPHeaderInfo.pas',
  uPSI_IdGlobal in 'uPSI_IdGlobal.pas',
  uPSI_IdSMTP in 'uPSI_IdSMTP.pas',
  uPSI_IdMessage in 'uPSI_IdMessage.pas',
  uPSI_PNGLoader in 'uPSI_PNGLoader.pas',
  uPSI_LinarBitmap in 'uPSI_LinarBitmap.pas',
  uPSC_graphics in 'uPSC_graphics.pas',
  uPSR_graphics in 'uPSR_graphics.pas',
  uPSC_DB in 'uPSC_DB.pas',
  uPSI_IniFiles in 'uPSI_IniFiles.pas',
  IFSI_SysUtils_max in 'IFSI_SysUtils_max.pas',
  uPSC_forms in 'uPSC_forms.pas',
  uPSR_forms in 'uPSR_forms.pas',
  uPSR_DB in 'uPSR_DB.pas',
  memorymax3 in 'memorymax3.pas' {winmemory},
  uPSRuntime in 'uPSRuntime.pas',
  uPSUtils in 'uPSUtils.pas',
  AESPassWordDlg in 'AESPassWordDlg.pas' {PasswordDlg};

{$R *.RES}

begin

  if ParamCount=10 then begin
  //for i := 1 to ParamCount do
    //ShellExecute(0, nil, PChar(ParamStr(0)), PChar('"'+ParamStr(i)+'"'),
    ShellExecute(0,NIL,PChar(ParamStr(0)), PChar('"'+ParamStr(1)+'"'), NIL, 1); //SW_SHOWDEFAULT
    Exit;
  end;
  (*if (ParamStr(1) <> '') then begin
     {act_Filename:= ParamStr(1);
     memo1.Lines.LoadFromFile(act_Filename);
     memo2.Lines.Add(Act_Filename + CLIFILELOAD);
     CB1SCList.Items.Add((Act_Filename));   //3.9 wb  bugfix 3.9.3.6
     CB1SCList.ItemIndex:= CB1SCList.Items.Count-1;
     Compile1Click(self);}
    ShellExecute(0,NIL,PChar(ParamStr(0)), PChar('"'+ParamStr(1)+'"'), NIL, 1); //SW_SHOWDEFAULT
      Exit;
     if (ParamStr(2) = 'm') then begin
       //Compile1Click(self);!
       Application.Minimize;
     end;
  end; *)


  Application.Initialize;
  Application.Title := 'Pascal_maXbox';
  Application.CreateForm(TMaxForm1, MaxForm1);
  if maxform1.STATMemoryReport = true then
    ReportMemoryLeaksOnShutdown:= true;
  //Application.CreateForm(TUCMainDlg, UCMainDlg);
  //Application.CreateForm(Tdebugoutput, debugoutput);
  Application.CreateForm(TConfirmReplDialog, ConfirmReplDialog);
  Application.CreateForm(TFindReplDialog, FindReplDialog);
  Application.Run;
end.
