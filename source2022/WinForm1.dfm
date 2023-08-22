object winFormp: TwinFormp
  Left = 593
  Top = 399
  Width = 910
  Height = 767
  HorzScrollBar.Style = ssFlat
  AutoScroll = True
  BorderWidth = 1
  Caption = 'puzzle template form'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 0
    Top = 255
    Width = 890
    Height = 12
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 261
    ExplicitWidth = 774
  end
  object Panel1: TPanel
    Left = 0
    Top = 267
    Width = 890
    Height = 421
    Align = alClient
    TabOrder = 3
    ExplicitWidth = 900
    ExplicitHeight = 441
    object Label2: TLabel
      Left = 11
      Top = 250
      Width = 354
      Height = 55
      Caption = 'FullTextFinder3'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -48
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 10
      Top = 348
      Width = 242
      Height = 16
      Caption = 'Find File Mask: DblClick in Directory Box '
    end
    object Label3: TLabel
      Left = 11
      Top = 19
      Width = 194
      Height = 16
      Caption = 'DblClick 2 times in Directory Box '
    end
    object Label4: TLabel
      Left = 539
      Top = 348
      Width = 169
      Height = 16
      Caption = 'DblClick to change Directory'
    end
    object btnfinder: TButton
      Left = 360
      Top = 316
      Width = 160
      Height = 40
      Caption = '&Start Report'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnfinderClick
    end
    object chkrecursive: TCheckBox
      Left = 539
      Top = 247
      Width = 187
      Height = 38
      Caption = 'with Sub Directories'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 1
    end
    object chkbxfinder: TCheckBox
      Left = 539
      Top = 314
      Width = 187
      Height = 17
      Caption = 'Console Out (-speed)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object chkbxcounter: TCheckBox
      Left = 539
      Top = 277
      Width = 187
      Height = 35
      Caption = 'Directory Counter'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 3
    end
    object edtsearch: TEdit
      Left = 164
      Top = 375
      Width = 356
      Height = 24
      MaxLength = 255
      TabOrder = 4
      Text = 'SearchName'
    end
    object edtfilename: TEdit
      Left = 539
      Top = 375
      Width = 310
      Height = 24
      Hint = 'Change Directory'
      TabOrder = 5
      Text = 'Filename_savereport.txt'
      OnChange = edtfilenameChange
      OnDblClick = edtfilenameDblClick
    end
    object edtmask: TEdit
      Left = 10
      Top = 375
      Width = 140
      Height = 24
      TabOrder = 6
      Text = '*.txt'
      OnDblClick = DirectoryListBox1DblClick
    end
    object chkboxtoday: TCheckBox
      Left = 539
      Top = 217
      Width = 187
      Height = 38
      Caption = 'only Date Now'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = chkboxtodayClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 688
    Width = 890
    Height = 30
    Panels = <>
    SimplePanel = True
    ExplicitTop = 708
    ExplicitWidth = 900
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 10
    Top = 305
    Width = 273
    Height = 165
    ItemHeight = 16
    TabOrder = 0
    OnDblClick = DirectoryListBox1DblClick
  end
  object DriveComboBox1: TDriveComboBox
    Left = 10
    Top = 478
    Width = 273
    Height = 22
    DirList = DirectoryListBox1
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 890
    Height = 255
    Align = alTop
    TabOrder = 4
    ExplicitWidth = 900
  end
end
