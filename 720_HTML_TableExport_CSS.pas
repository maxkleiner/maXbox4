unit HTML_CSS_ExportUnit1;

//#sign:Max: MAXBOX10: 19/09/2016 20:53:26 
//#tech:5perf: 0:0:2.523 threads: 6 192.168.1.53 20:53:26 4.2.4.60

interface

//TODO: Translate on english
//DONE: check decimals separator . or , on Operating System
//TODO: test methode of rate calculation 

{uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, ExtActns; #locs:350
  you need: CSSFILE: xtable.css
 }
 
 Const BROWSER = 'firefox.exe' ;//'Iexplore.exe'; //firefox.exe';
       HTMLFILE = 'ZZinsen4.htm';
       CSSFILE = 'C:\maXbox\maxbox3\maxbox3\maXbox3\examples\xtable.css';
 
 var 
//type
  //TForm1 = class(TForm)
    edK0: TEdit;
    edZs: TEdit;
    edLz: TEdit;
    sg: TStringGrid;
    btnCalc: TButton;
    btnExport: TButton;
    btnClear: TButton;
    btnClose: TButton;

    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
       procedure TForm1_FormCreate(Sender: TObject);
       procedure TForm1_btnCalcClick(Sender: TObject);
       procedure TForm1_btnExportClick(Sender: TObject);
       procedure TForm1_btnClearClick(Sender: TObject);
       procedure TForm1_btnCloseClick(Sender: TObject);
  //private
    { Private declarations }
  //public
    { Public declarations }
  //end;

var
  Form1: TForm;  //1;

implementation

//{$R *.dfm}

procedure Berechnung;
//Ausführen der Berechnung
var
  k0, kn, zs, z, g: double;
  j, lz: integer;
begin
  with Form1 do begin
    //Übernahme der Eingabewerte
    k0:=StrToFloat(edK0.Text);
    zs:=StrToFloat(edZs.Text);
    lz:=StrToInt(edLz.Text);
    if lz<1 then lz:=1;
    if lz>30 then lz:=30;
    sg.RowCount:=lz+1;

    //Berechnung
    g:=k0;
    for j:=1 to lz do begin
      kn:=g; z:=g*zs/100; g:=kn+z;
      sg.Cells[0,j]:=IntToStr(j);
      sg.Cells[1,j]:=FormatFloat('0.00 €',kn);
      sg.Cells[2,j]:=FormatFloat('0.00 €',z);
      sg.Cells[3,j]:=FormatFloat('0.00 €',g);
    end;
  end;
end;

procedure HideGridCursor(g: TStringGrid);
//Cursor aus dem StringGrid verbannen
var gr: TGridRect;
begin
  with gr do begin
    Top:=-1; Left:=-1; Right:=-1; Bottom:=-1
  end;
  g.Selection:=gr;
end;

procedure TForm1_FormCreate(Sender: TObject);
//Starteinstellungen
begin
  //Beschriftung der Tabelle
  sg.Cells[0,0]:='Jahr'; sg.Cells[1,0]:='Ausgangskapital';
  sg.Cells[2,0]:='Zinsen'; sg.Cells[3,0]:='Guthaben';
  Berechnung;
  HideGridCursor(sg);
end;

procedure TForm1_btnCalcClick(Sender: TObject);
//Start der Berechnung
begin
  HideGridCursor(sg);
  Berechnung;
end;

procedure TForm1_btnExportClick(Sender: TObject);
//Ausführung des HTML-Exports
var
  t,p,s,s1,s2,n,b: string;
  i,j: integer;
  sl: TStrings;
  f: TFileRun;
begin
  sl:=TStringList.Create; sl.Clear();
  p:=Application.ExeName;
  p:=ExtractFilePath(p)+HTMLFILE;
  sl.Clear;

  //HTML-Header schreiben
  t:='<html>'; sl.Add(t);
  t:='  <head>'; sl.Add(t);
  t:='    <title>Zinseszinstabelle</title>'; sl.Add(t);
  t:='    <link rel="stylesheet" href="'+CSSFILE+'" type="text/css">'; sl.Add(t);
  t:='  </head>'; sl.Add(t);
  t:='  <body><basefont face="Courier"><center>'; sl.Add(t);

  //HTML-Daten schreiben
  s1:='class="td1"'; s2:='class="td2"';
  t:='    <table width="400" border=0" cellspacing="2" cellpadding="2">'; sl.Add(t);
  //  Überschrift und Eingabedaten
  t:='      <tr><td class="th1" colspan=4 align="center">Ermittlung von Zinseszinsen</td></tr>';
  sl.Add(t);
  s:='Ausgangskapital: '+edK0.Text+'€;&nbsp; Zinssatz: '+edZS.Text;
  s:=s+'%;&nbsp; Laufzeit: '+edLZ.Text+' Jahre<br><br>';
  t:='      <tr><td class="text" colspan=4 align="center">'+s+'</td></tr>';
  sl.Add(t);
  //  Spaltenüberschriften
  t:='      <tr>'; sl.Add(t);
  for j:=0 to sg.ColCount-1 do begin
    if i mod 2 = 0 then s:=s1 else s:=s2;
    t:='        <td class="th1">'+sg.Cells[j,0]+'</td>';
    sl.Add(t);
  end;
  t:='      </tr>'; sl.Add(t);
  //  Tabellendaten
  for i:=1 to sg.RowCount-1 do begin
    t:='      <tr>'; sl.Add(t);
    for j:=0 to sg.ColCount-1 do begin
      if i mod 2 = 0 then s:=s1 else s:=s2;
      t:='        <td '+ s +'>'+sg.Cells[j,i]+'</td>';
      sl.Add(t);
    end;
    t:='      </tr>'; sl.Add(t);
  end;
  t:='    </table>'; sl.Add(t);

  //HTML-Footer schreiben
  t:='  </body>'; sl.Add(t);
  t:='</html>'; sl.Add(t);

  sl.SaveToFile(p);

  //Webbrowser aufrufen
  p:=Application.ExeName;
  p:=(ExtractFilePath(p)+HTMLFILE);
  writeln(ansiquotedstr(strhtmlencode(p),'"'))
  f:=TFileRun.Create(Form1);
  f.FileName:= BROWSER; //'iexplore.exe';
  //writeln(p)
  f.parameters:=ansiquotedstr(p,'"');
  f.Execute;
  f.Free;

  sl.Free;
end;

procedure TForm1_btnClearClick(Sender: TObject);
//Löschen der Formulareinstellungen
var z,s,lz: integer;
begin
  lz:=StrToInt(edLz.Text);
  for z:=1 to lz do
    for s:=0 to 3 do
      sg.Cells[s,z]:='';
  sg.RowCount:=2;
  //edK0.Text:=''; edZs.Text:=''; edLZ.Text:='';
  HideGridCursor(sg);
  edK0.SetFocus;
end;

procedure InitFormObjects;
begin
Form1:= TForm.create(self);
with Form1 do begin
  Left := 368
  Top := 258
  BorderIcons := [biSystemMenu, biMinimize]
  BorderStyle := bsSingle
  Caption := 'maXbox4 Zinseszinsen mit HTML-Export and CSS'
  ClientHeight := 350
  ClientWidth := 396
  Color := clBtnFace
  Font.Charset := DEFAULT_CHARSET
  Font.Color := clWindowText
  Font.Height := -11
  Font.Name := 'MS Sans Serif'
  Font.Style := []
  OldCreateOrder := False
  Position := poDesktopCenter
  OnCreate := @TForm1_FormCreate
  PixelsPerInch := 96
  //TextHeight := 13
  Show;
 end; 
  Panel1:= TPanel.create(form1)
  with panel1 do begin
    parent:= form1;
    Left := 8
    Top := 8
    Width := 249
    Height := 109
    BevelOuter := bvLowered
    TabOrder := 0
   end; 
    Label1:= TLabel.create(form1)
    with label1 do begin
      parent:= panel1;
      Left := 16
      Top := 16
      Width := 74
      Height := 13
      Caption := 'Grundkapital/'#8364':'
    end;
    Label2:= TLabel.create(form1)
    with label2 do begin
      parent:= panel1;
      Left := 16
      Top := 48
      Width := 55
      Height := 13
      Caption := 'Zinssatz/%:'
    end;
    Label3:= TLabel.create(form1)
    with label3 do begin
      parent:= panel1;
      Left := 16
      Top := 80
      Width := 71
      Height := 13
      Caption := 'Laufzeit/Jahre:'
    end;
    edK0:= TEdit.create(form1)
    with edk0 do begin
      parent:= panel1;
      Left := 120
      Top := 12
      Width := 113
      Height := 21
      TabOrder := 0
      Text := '10000'
    end;
    edZs:= TEdit.create(form1)
    with edzs do begin
      parent:= panel1;
      SetBounds(120,44,113,21)
     TabOrder := 1
      if getDecimalSeparator = ',' then
        Text := '2,5'
        else Text:= '2.5';
    end;
    edLz:= TEdit.create(form1)
    with edlz do begin
      parent:= panel1;
      SetBounds(120,76,113,21)
      TabOrder := 2
      Text := '10'
    end;
  //end panel1
  sg:= TStringGrid.create(form1)
  with sg do begin
    parent:= form1;
    Left := 8
    Top := 128
    Width := 377
    Height := 210
    ColCount := 4
    DefaultColWidth := 88
    DefaultRowHeight := 18
    FixedCols := 0
    RowCount := 11
    Options := [goFixedVertLine, goFixedHorzLine, goVertLine, 
                   goHorzLine, goRangeSelect, goThumbTracking]
    //TabOrder := 1
  end;
  btnCalc:= TButton.create(form1)
  with btncalc do begin
    parent:= form1;
    SetBounds(272,8,113,25)
    Caption := 'Berechnen'
    TabOrder := 2
    OnClick := @Tform1_btnCalcClick
  end;
  {object} btnClose:= TButton.create(form1)
  with btnclose do begin
    parent:= form1;
    SetBounds(272,88,113,25)
    Caption := 'Beenden'
    TabOrder := 4
    OnClick := @TForm1_btnCloseClick
  end;
  btnExport:= TButton.create(form1)
  with btnexport do begin
    parent:= form1;
    SetBounds(272,32,113,25)
    Caption := 'HTML-Export'
    TabOrder := 5
    OnClick := @TForm1_btnExportClick
  end;
  {object} btnClear:= TButton.create(form1)
  with btnClear do begin
    parent:= form1;
    Left := 272
    Top := 56
    Width := 113
    Height := 25
    Caption := 'L'#246'schen'
    TabOrder := 3
    OnClick := @Tform1_btnClearClick
  end;
end;


procedure TForm1_btnCloseClick(Sender: TObject);
//Programmende
begin
  form1.Close;
  writeln('app form closed at: '+datetimetostr(now))
end;

Begin

 InitFormObjects;  
 TForm1_FormCreate(Self);
 writeln('decimal check: '+getDecimalSeparator)
 
End.
