object Form1Boss: TForm1Boss
  Left = 356
  Top = 324
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'PascalPicturePuzzle'
  ClientHeight = 470
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object panImg1: TPanel
    Left = 8
    Top = 8
    Width = 452
    Height = 452
    BevelOuter = bvLowered
    TabOrder = 0
    object img1: TImage
      Left = 1
      Top = 1
      Width = 450
      Height = 450
    end
    object drG: TDrawGrid
      Left = 0
      Top = 0
      Width = 455
      Height = 455
      Cursor = crHandPoint
      ColCount = 4
      DefaultColWidth = 111
      DefaultRowHeight = 111
      FixedCols = 0
      RowCount = 4
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
      ScrollBars = ssNone
      TabOrder = 0
      Visible = False
      OnClick = drGClick
      OnDrawCell = drGDrawCell
    end
  end
  object Panel2: TPanel
    Left = 472
    Top = 8
    Width = 153
    Height = 449
    BevelOuter = bvLowered
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 12
      Width = 30
      Height = 13
      Caption = 'Status'
    end
    object Label2: TLabel
      Left = 8
      Top = 47
      Width = 59
      Height = 13
      Caption = 'Current Step'
    end
    object Label3: TLabel
      Left = 8
      Top = 76
      Width = 67
      Height = 13
      Caption = 'Situation Rate'
    end
    object btnNewPic: TButton
      Left = 16
      Top = 176
      Width = 121
      Height = 25
      Caption = 'New Picture'
      TabOrder = 0
      OnClick = btnNewPicClick
    end
    object btnClose: TButton
      Left = 16
      Top = 408
      Width = 121
      Height = 25
      Caption = 'Close'
      TabOrder = 1
      OnClick = btnCloseClick
    end
    object btnToggel: TButton
      Left = 16
      Top = 272
      Width = 97
      Height = 25
      Caption = 'to Picture'
      Enabled = False
      TabOrder = 2
      OnClick = btnToggelClick
    end
    object panStatus: TPanel
      Left = 48
      Top = 8
      Width = 97
      Height = 25
      BevelOuter = bvLowered
      Caption = 'Destination'
      Color = clTeal
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 3
    end
    object panZug: TPanel
      Left = 104
      Top = 40
      Width = 41
      Height = 25
      BevelOuter = bvLowered
      Caption = '0'
      Color = clTeal
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 4
    end
    object panSchritt: TPanel
      Left = 104
      Top = 72
      Width = 41
      Height = 25
      BevelOuter = bvLowered
      Caption = '0'
      Color = clTeal
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 5
    end
    object rgInit: TRadioGroup
      Left = 8
      Top = 112
      Width = 137
      Height = 41
      Caption = 'Initialise on'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Random'
        'Shuffle')
      TabOrder = 6
    end
    object btnNewGame: TButton
      Left = 16
      Top = 208
      Width = 121
      Height = 25
      Caption = 'New Game'
      Enabled = False
      TabOrder = 7
      OnClick = btnNewGameClick
    end
    object btnCancel: TButton
      Left = 16
      Top = 240
      Width = 121
      Height = 25
      Caption = 'Cancel'
      Enabled = False
      TabOrder = 8
      OnClick = btnCancelClick
    end
    object btnSG: TButton
      Left = 112
      Top = 272
      Width = 25
      Height = 25
      Caption = '...'
      TabOrder = 9
      OnClick = btnSGClick
    end
  end
  object sg: TStringGrid
    Left = 512
    Top = 320
    Width = 79
    Height = 79
    ColCount = 4
    DefaultColWidth = 18
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 4
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    ParentFont = False
    TabOrder = 2
  end
  object opDlg: TOpenPictureDialog
    Left = 424
    Top = 16
  end
end
