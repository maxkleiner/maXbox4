object frmInputControl: TfrmInputControl
  Left = 0
  Top = 0
  Width = 798
  Height = 91
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clMaroon
  Font.Height = -17
  Font.Name = 'Verdana'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object pnlButtons: TPanel
    Left = 241
    Top = 0
    Width = 104
    Height = 91
    Align = alLeft
    BevelOuter = bvNone
    BorderWidth = 5
    ParentColor = True
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 241
    Height = 91
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Audio Recorder Control'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = []
    ParentColor = True
    ParentFont = False
    TabOrder = 1
    object lblStereo: TLabel
      Left = 126
      Top = 55
      Width = 96
      Height = 20
      Caption = 'Mono input'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -17
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
  end
  object Panel3: TPanel
    Left = 345
    Top = 0
    Width = 264
    Height = 91
    Align = alLeft
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '  Gain'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -17
    Font.Name = 'Verdana'
    Font.Style = []
    ParentColor = True
    ParentFont = False
    TabOrder = 2
    object trInpVoume: TTrackBar
      Left = 56
      Top = 35
      Width = 201
      Height = 25
      Max = 65535
      TabOrder = 0
      OnChange = trInpVoumeChange
    end
  end
end
