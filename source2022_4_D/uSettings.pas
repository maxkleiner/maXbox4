unit uSettings;

interface
  uses IniFiles,Graphics,forms;

  procedure SaveSettings;
  procedure GetSettings;

implementation

uses Windows, SysUtils, dialogs, U_Oscilloscope4,ufrmOscilloscope4;

const
  SETTINGS_FILE = 'osc.ini';

procedure SaveSettings;
var
  IniFile:TIniFile;
  Ts:integer;
  filename:string;
  attrs:integer;
begin

  filename:=ExtractFilePath(Application.ExeName)+ SETTINGS_FILE;

  if fileexists(filename)then  attrs:=filegetattr(filename)
  else attrs:=2;{dummy attributes just so next test will not fail}
  if (getdrivetype(Pchar(filename))=Drive_CDRom) or ((attrs and faReadOnly) =0) then
  begin  {not readonly, so we can create or update this file}
    IniFile := TIniFile.Create(filename);
    try
      IniFile.WriteBool('Mode','Dual',oscfrmMain.btnDual.Down);
      IniFile.WriteInteger('Channel1','Gain',oscfrmMain.upGainCh1.Position);
      IniFile.WriteInteger('Channel1','ofset',oscfrmMain.trOfsCh1.Position);
      IniFile.WriteBool('Channel1','Gnd',oscfrmMain.btnCH1Gnd.Down);
      IniFile.WriteBool('Channel1','On',oscfrmMain.OnCh1Box.checked);
      IniFile.WriteInteger('Channel2','Gain',oscfrmMain.upGainCh2.Position);
      IniFile.WriteInteger('Channel2','ofset',oscfrmMain.trOfsCh2.Position);
      IniFile.WriteBool('Channel2','Gnd',oscfrmMain.OnCh2Box.Checked);
      IniFile.WriteBool('Channel2','On',oscfrmMain.btnCh2Gnd.down);
      IniFile.WriteInteger('Trigger','Level',oscfrmMain.TrigLevelBar.Position);

      Ts:=0;
      if oscfrmMain.sp11025Sample.Down then
        Ts:=11
      else if oscfrmMain.sp22050Sample.Down then
        Ts:=22
      else if oscfrmMain.sp44100Sample.Down then
        Ts:=44;

      IniFile.WriteInteger('Time','Scale',Ts);
      IniFile.WriteInteger('Time','Gain',oscfrmMain.SweepUD.Position);

      IniFile.WriteInteger('Screen','Scale',oscfrmMain.UpScaleLight.Position);
      IniFile.WriteInteger('Screen','Beam',oscfrmMain.upBeamLight.Position);
      IniFile.WriteInteger('Screen','focus',oscfrmMain.upFocus.Position);
      IniFile.WriteString('Screen','color',  ColorToString(oscfrmMain.frmOscilloscope1.ScreenColor));

      IniFile.WriteBool('ScreenData','Time',oscfrmMain.menuData_Time.checked);
    except
    end;
    FreeAndNil(IniFile);
  end
  else showMessage('Oscilloscope is in a read Only folder and settings cannot be saved'
              +#13+'Move program to a writable file to allow settings to be saved '
              +#13+'for next run.');

end;

procedure GetSettings;
var
  IniFile:TIniFile;
  Ts:integer;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+ SETTINGS_FILE);
  try
    //frmMain.btnDual.Down := IniFile.ReadBool('Mode','Dual',False);
    oscfrmMain.upGainCh1.Position := IniFile.ReadInteger('Channel1','Gain',3);
    oscfrmMain.trOfsCh1.Position  := IniFile.ReadInteger('Channel1','ofset',0);
    oscfrmMain.btnCH1Gnd.Down     := IniFile.ReadBool('Channel1','Gnd',False);
    oscfrmMain.OnCh1Box.checked      := IniFile.ReadBool('Channel1','On',True);
    oscfrmMain.upGainCh2.Position := IniFile.ReadInteger('Channel2','Gain',3);
    oscfrmMain.trOfsCh2.Position  := IniFile.ReadInteger('Channel2','ofset',0);
    oscfrmMain.btnCH2Gnd.Down     := IniFile.ReadBool('Channel2','Gnd',False);
    oscfrmMain.OnCh2Box.checked      := IniFile.ReadBool('Channel2','On',True);
    oscfrmMain.TrigLevelBar.Position := IniFile.ReadInteger('Trigger','Level',0);
    Ts := IniFile.ReadInteger('Time','Scale',11);

    if Ts= 11 then
      oscfrmMain.sp11025Sample.Down := True
    else if Ts= 22 then
      oscfrmMain.sp22050Sample.Down := True
    else if Ts= 44 then
      oscfrmMain.sp44100Sample.Down := True;

    oscfrmMain.SweepUD.Position      := IniFile.ReadInteger('Time','Gain',1);
    oscfrmMain.UpScaleLight.Position := IniFile.ReadInteger('Screen','Scale',70);
    oscfrmMain.upBeamLight.Position  := IniFile.ReadInteger('Screen','Beam',1);
    oscfrmMain.upFocus.Position      := IniFile.ReadInteger('Screen','focus',1);

    oscfrmMain.frmOscilloscope1.ScreenColor :=
                StringToColor(IniFile.ReadString('Screen','color','clBlack'));

    oscfrmMain.menuData_Time.checked := IniFile.ReadBool('ScreenData','Time',True);

    oscfrmMain.SetOscState;
  finally
    FreeAndNil(IniFile);
  end;
end;

end.
