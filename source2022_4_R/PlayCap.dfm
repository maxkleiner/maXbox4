object frmCap: TfrmCap
  Left = 478
  Top = 252
  Caption = 'Capture '
  ClientHeight = 512
  ClientWidth = 834
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 834
    Height = 121
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 842
    object Label1: TLabel
      Left = 192
      Top = 48
      Width = 138
      Height = 13
      Caption = 'Start (nach Klick auf Caption)'
    end
    object Label2: TLabel
      Left = 192
      Top = 72
      Width = 75
      Height = 13
      Caption = 'Aufnahmedauer'
    end
    object btnVideoDevProps: TButton
      Left = 520
      Top = 8
      Width = 105
      Height = 25
      Caption = 'Video Dev Props'
      TabOrder = 0
      OnClick = btnVideoDevPropsClick
    end
    object btnCapture: TButton
      Left = 432
      Top = 40
      Width = 75
      Height = 25
      Caption = 'Capture'
      TabOrder = 1
      OnClick = btnCaptureClick
    end
    object btnPreview: TButton
      Left = 432
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Vorschau'
      TabOrder = 2
      OnClick = btnPreviewClick
    end
    object btnExit: TButton
      Left = 752
      Top = 32
      Width = 75
      Height = 25
      Caption = 'Beenden'
      TabOrder = 3
      OnClick = btnExitClick
    end
    object btnVideoComprProps: TButton
      Left = 520
      Top = 40
      Width = 107
      Height = 25
      Caption = 'VideoCompr. Props'
      TabOrder = 4
      OnClick = btnVideoComprPropsClick
    end
    object btnAudioDevProps: TButton
      Left = 632
      Top = 8
      Width = 105
      Height = 25
      Caption = 'AudioIn Props.'
      TabOrder = 5
      OnClick = btnAudioDevPropsClick
    end
    object btnAudioComprProps: TButton
      Left = 632
      Top = 40
      Width = 105
      Height = 25
      Caption = 'bAudioCompress Props.'
      TabOrder = 6
      OnClick = btnAudioComprPropsClick
    end
    object chkVideoCompress: TCheckBox
      Left = 512
      Top = 80
      Width = 113
      Height = 17
      Caption = 'Video komprimieren'
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
    object chkAudioCompress: TCheckBox
      Left = 640
      Top = 80
      Width = 113
      Height = 17
      Caption = 'Audio komprimieren'
      Checked = True
      State = cbChecked
      TabOrder = 8
    end
    object ProgressBar1: TProgressBar
      Left = 440
      Top = 96
      Width = 393
      Height = 19
      TabOrder = 9
    end
    object edStart: TEdit
      Left = 344
      Top = 40
      Width = 49
      Height = 21
      TabOrder = 10
      Text = '0'
    end
    object edDauer: TEdit
      Left = 344
      Top = 72
      Width = 49
      Height = 21
      TabOrder = 11
      Text = '10'
    end
    object btnStopCapture: TButton
      Left = 432
      Top = 72
      Width = 75
      Height = 25
      Caption = 'Stop Capture'
      TabOrder = 12
      OnClick = btnStopCaptureClick
    end
  end
  object pnlView: TPanel
    Left = 0
    Top = 121
    Width = 384
    Height = 372
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 392
    ExplicitHeight = 352
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 493
    Width = 834
    Height = 19
    Panels = <>
    SimplePanel = True
    SimpleText = '...'
    ExplicitTop = 473
    ExplicitWidth = 842
  end
  object Panel2: TPanel
    Left = 384
    Top = 121
    Width = 450
    Height = 372
    Align = alRight
    TabOrder = 3
    ExplicitLeft = 392
    ExplicitHeight = 352
    object Memo1: TMemo
      Left = 24
      Top = 24
      Width = 185
      Height = 129
      Lines.Strings = (
        'Hilfe:'
        'Zuerst: Videoger'#228't ausw'#228'hlen und '
        'Vorschau ansehen'
        'Dann : Videokompression,'
        'Audioger'#228't, Audiokompression in den '
        'Men'#252's ausw'#228'hlen, dann bei Bedarf '
        'Caption.'
        'Erneute Caption nur nach Neustart '
        'm'#246'glich.'
        '')
      TabOrder = 0
    end
  end
  object MainMenu1: TMainMenu
    AutoHotkeys = maManual
    Left = 72
    Top = 32
    object Datei1: TMenuItem
      Caption = 'Datei'
      object mnuDatei: TMenuItem
        Caption = 'Datei festlegen'
        OnClick = mnuDateiClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuExit: TMenuItem
        Caption = 'Beenden'
      end
    end
    object mnuVDevice: TMenuItem
      Caption = 'VideoGer'#228'te'
      OnClick = mnuVDeviceClick
    end
    object mnuVCompress: TMenuItem
      Caption = 'VideoCompress'
      OnClick = mnuVCompressClick
    end
    object mnuADevice: TMenuItem
      Caption = 'Audioger'#228'te'
      OnClick = mnuADeviceClick
    end
    object mnuACompress: TMenuItem
      Caption = 'AudioCompress'
      OnClick = mnuACompressClick
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 72
    Top = 72
  end
  object SaveDialog1: TSaveDialog
    Left = 16
    Top = 80
  end
end
