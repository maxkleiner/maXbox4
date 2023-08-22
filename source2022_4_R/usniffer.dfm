object sniffForm: TsniffForm
  Left = 254
  Top = 127
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'mX4 SimpleSniffer'
  ClientHeight = 578
  ClientWidth = 822
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 822
    Height = 578
    Align = alClient
    BorderStyle = bsNone
    Columns = <
      item
        Caption = 'Time'
        Width = 60
      end
      item
        Caption = 'Proto'
        Width = 70
      end
      item
        Caption = 'Source'
        Width = 100
      end
      item
        Caption = 'Dest'
        Width = 100
      end
      item
        Caption = 'iPort len'
        Width = 70
      end
      item
        Caption = 'TTL'
      end
      item
        Caption = 'XSum'
      end
      item
        Caption = 'TOS'
      end
      item
        Caption = 'Verlen'
      end
      item
        Caption = 'ID'
      end>
    ColumnClick = False
    GridLines = True
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = ListView1Change
    OnDblClick = ListView1DblClick
    ExplicitWidth = 726
    ExplicitHeight = 497
  end
end
