object ImageForm2: TImageForm2
  Left = 193
  Top = 107
  ActiveControl = FileEdit
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Image Viewer'
  ClientHeight = 349
  ClientWidth = 852
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 596
    Top = 5
    Width = 171
    Height = 121
  end
  object Bevel2: TBevel
    Left = 597
    Top = 132
    Width = 170
    Height = 177
  end
  object Label1: TLabel
    Left = 605
    Top = 11
    Width = 147
    Height = 13
    AutoSize = False
    Caption = 'Preview'
  end
  object Label2: TLabel
    Left = 604
    Top = 290
    Width = 95
    Height = 13
    Caption = 'Number of Glyphs - '
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 16
    Top = 12
    Width = 238
    Height = 260
    FileList = FileListBox1
    IntegralHeight = True
    ItemHeight = 16
    TabOrder = 1
  end
  object DriveComboBox1: TDriveComboBox
    Left = 17
    Top = 277
    Width = 238
    Height = 19
    DirList = DirectoryListBox1
    TabOrder = 3
  end
  object FileEdit: TEdit
    Left = 302
    Top = 13
    Width = 263
    Height = 21
    TabOrder = 0
    Text = '*.bmp;*.ico;*.wmf;*.emf'
    OnKeyPress = FileEditKeyPress
  end
  object UpDownGroup: TGroupBox
    Left = 603
    Top = 158
    Width = 154
    Height = 60
    Caption = 'Up / Down'
    TabOrder = 5
    object SpeedButton1: TSpeedButton
      Left = 116
      Top = 26
      Width = 25
      Height = 25
      AllowAllUp = True
      GroupIndex = 1
    end
    object BitBtn1: TBitBtn
      Left = 12
      Top = 18
      Width = 92
      Height = 33
      Caption = 'BitBtn1'
      TabOrder = 0
    end
  end
  object DisabledGrp: TGroupBox
    Left = 603
    Top = 220
    Width = 154
    Height = 60
    Caption = 'Disabled'
    TabOrder = 7
    object SpeedButton2: TSpeedButton
      Left = 116
      Top = 25
      Width = 25
      Height = 25
      Enabled = False
    end
    object BitBtn2: TBitBtn
      Left = 11
      Top = 18
      Width = 92
      Height = 33
      Caption = 'BitBtn2'
      Enabled = False
      TabOrder = 0
    end
  end
  object Panel1: TPanel
    Left = 604
    Top = 27
    Width = 153
    Height = 68
    BevelInner = bvLowered
    TabOrder = 8
    object Image1: TImage
      Left = 2
      Top = 2
      Width = 149
      Height = 64
      Align = alClient
    end
  end
  object FileListBox1: TFileListBox
    Left = 302
    Top = 41
    Width = 263
    Height = 227
    FileEdit = FileEdit
    ItemHeight = 13
    Mask = '*.bmp;*.ico;*.wmf;*.emf'
    TabOrder = 2
    OnClick = FileListBox1Click
  end
  object ViewBtn: TBitBtn
    Left = 605
    Top = 98
    Width = 63
    Height = 24
    Caption = '&Full View'
    TabOrder = 6
    OnClick = ViewBtnClick
  end
  object FilterComboBox1: TFilterComboBox
    Left = 302
    Top = 275
    Width = 264
    Height = 21
    FileList = FileListBox1
    Filter = 
      'Image Files (*.bmp, *.ico, *.wmf, *.emf)|*.bmp;*.ico;*.wmf;*.emf' +
      '|Bitmap Files (*.bmp)|*.bmp|Icons (*.ico)|*.ico|Metafiles (*.wmf' +
      ', *.emf)|*.wmf;*.emf|All files (*.*)|*.*'
    TabOrder = 4
  end
  object GlyphCheck: TCheckBox
    Left = 607
    Top = 137
    Width = 104
    Height = 17
    Caption = 'View as Glyph'
    TabOrder = 9
    OnClick = GlyphCheckClick
  end
  object StretchCheck: TCheckBox
    Left = 693
    Top = 96
    Width = 64
    Height = 17
    Caption = 'Stretch'
    TabOrder = 11
    OnClick = StretchCheckClick
  end
  object UpDownEdit: TEdit
    Left = 719
    Top = 286
    Width = 24
    Height = 21
    TabOrder = 10
    Text = '1'
    OnChange = UpDownEditChange
  end
  object UpDown1: TUpDown
    Left = 743
    Top = 286
    Width = 11
    Height = 21
    Associate = UpDownEdit
    Position = 1
    TabOrder = 12
  end
end
