{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvFormLog.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is Sébastien Buysse [sbuysse@buypin.com]
Portions created by Sébastien Buysse are Copyright (C) 2001 Sébastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck@bigfoot.com].

Last Modified: 2000-02-28

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

unit JvFormLog;

interface

uses
  SysUtils, Classes, Controls, Forms, Dialogs,
  ComCtrls, ActnList, ImgList, JvListview, JvComponent, ToolWin, JVPrint;

type
  TFoLog = class(TForm)
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ImageList1: TImageList;
    ActionList1: TActionList;
    Save: TAction;
    Print: TAction;
    SaveDialog1: TSaveDialog;
    //Print1: TPrint;
    procedure SaveExecute(Sender: TObject);
    procedure PrintExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
     ListView1: TJvListView;     //TJvlistview
     Print1: TJVPrint;
  end;

implementation

{$R *.DFM}

procedure TFoLog.SaveExecute(Sender: TObject);
begin
  if not SaveDialog1.Execute then
    Exit;
  if SaveDialog1.FilterIndex = 1 then
    ListView1.SaveToCSV(SaveDialog1.FileName)
  else
    ListView1.SaveToFile(SaveDialog1.FileName)
end;

procedure TFoLog.FormCreate(Sender: TObject);
begin
 Print1:= TJvPrint.create(self);
 ListView1:= TJvListView.create(self);
 with ListView1 do begin
    parent:= self;
    Left:= 0;
    Top:= 24;
    Width:= 413;
    Height:= 321;
    Align:= alClient;
    Columns.Add;
    Columns.Items[0].Caption:= 'Time';
    Columns.Items[0].Width:= 115;
    Columns.Add;
    Columns.Items[1].Caption:= 'Title';
    Columns.Items[1].Width:= 120;
    Columns.Add;
    Columns.Items[2].Caption:= 'Description';
    Columns.Items[2].Width:= 150;
    FlatScrollBars:= True;
    GridLines:= True;
    HotTrack:= True;
    ReadOnly:= True;
    RowSelect:= True;
    TabOrder:= 1;
    ViewStyle:= vsReport;
    SortOnClick:= False;
  end

end;

procedure TFoLog.PrintExecute(Sender: TObject);
var
 I: Integer;
 Ts: TStringList;
begin
  Ts := TStringList.Create;
  with Ts do
    try
      for I := 0 to ListView1.Items.Count-1 do
        with ListView1.Items[I] do
         Add('[' + Caption + ']' + SubItems[0] + ' > ' + SubItems[1]);
      //Print1.Print(Ts);
    finally
      Free;
    end;
end;

end.
