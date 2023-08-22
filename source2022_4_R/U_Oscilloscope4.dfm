object OscfrmMain: TOscfrmMain
  Left = 603
  Top = 169
  Caption = 'mX Dual Trace Oscilloscope Ver 4.2.3'
  ClientHeight = 624
  ClientWidth = 1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -9
  Font.Name = 'Verdana'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object statustext: TPanel
    Left = 0
    Top = 0
    Width = 1080
    Height = 33
    Align = alTop
    BevelInner = bvLowered
    BevelWidth = 2
    Caption = 'Oscilloscope'
    Color = clMaroon
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object Panel5: TPanel
    Left = 0
    Top = 33
    Width = 1080
    Height = 428
    Align = alTop
    Caption = 'Panel5'
    TabOrder = 1
    object Panel6: TPanel
      Left = 674
      Top = 1
      Width = 180
      Height = 426
      Align = alLeft
      BevelInner = bvLowered
      BevelWidth = 2
      TabOrder = 0
      object btnRun: TSpeedButton
        Left = 8
        Top = 8
        Width = 41
        Height = 25
        Hint = 'Run'
        AllowAllUp = True
        GroupIndex = 1
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FF000000000000000000000000000000000000000000FF
          00FFFF00FFFF00FFFF00FF000000000000000000000000000000000000000000
          000000000000000000000000000000000000FF00FFFF00FFFF00FF0000000000
          00000000000000000000000000000000000000000000000000000000000000FF
          00FFFF00FFFF00FFFF00FF000000000000000000000000000000000000000000
          000000FF00FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FF000000000000000000000000000000000000FF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000000000
          000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FF000000000000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        ParentShowHint = False
        ShowHint = True
        OnClick = btnRunClick
      end
      object btnDual: TSpeedButton
        Left = 9
        Top = 72
        Width = 96
        Height = 25
        Hint = 'Dual input'
        AllowAllUp = True
        GroupIndex = 2
        Caption = 'Dual inp.'
        ParentShowHint = False
        ShowHint = True
        OnClick = btnDualClick
      end
      object BtnOneFrame: TSpeedButton
        Left = 50
        Top = 8
        Width = 39
        Height = 25
        Hint = 'Single frame'
        AllowAllUp = True
        GroupIndex = 1
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000
          00000000FF00FFFF00FF000000000000000000000000FF00FF00000000000000
          0000000000000000000000000000000000000000000000FF00FF000000000000
          000000000000FF00FF0000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000FF00FF00000000000000
          0000000000000000000000000000000000000000000000FF00FFFF00FF000000
          000000000000FF00FF000000000000000000FF00FFFF00FFFF00FFFF00FF0000
          00000000FF00FFFF00FFFF00FF000000000000000000FF00FF00000000000000
          0000FF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FF000000
          000000000000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF00000000000000000000000000000000000000
          0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          000000000000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        ParentShowHint = False
        ShowHint = True
        OnClick = BtnOneFrameClick
      end
      object Panel3: TPanel
        Left = 91
        Top = 8
        Width = 13
        Height = 15
        Hint = 'Blinks when running'
        BevelInner = bvLowered
        Color = clMaroon
        TabOrder = 0
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 185
        Width = 148
        Height = 232
        Caption = 'Trigger'
        TabOrder = 1
        object btnTriggCh1: TSpeedButton
          Left = 8
          Top = 52
          Width = 33
          Height = 22
          Hint = 'Trigger on Channel 1'
          GroupIndex = 3
          Down = True
          Caption = 'Ch1'
        end
        object btnTriggCh2: TSpeedButton
          Left = 8
          Top = 75
          Width = 33
          Height = 22
          Hint = 'Trigger on Channel2'
          GroupIndex = 3
          Caption = 'Ch2'
        end
        object btnTrigPositiv: TSpeedButton
          Left = 8
          Top = 99
          Width = 33
          Height = 22
          Hint = 'Trigger on + rising level '
          GroupIndex = 4
          Caption = '+'
          OnClick = btnTrigerOnClick
        end
        object btnTrigNegativ: TSpeedButton
          Left = 8
          Top = 123
          Width = 33
          Height = 22
          Hint = 'Trigger on - falling level'
          GroupIndex = 4
          Caption = '-'
          OnClick = trOfsCh1Change
        end
        object Label4: TLabel
          Left = 75
          Top = 12
          Width = 7
          Height = 12
          Caption = '0'
        end
        object Label3: TLabel
          Left = 8
          Top = 215
          Width = 139
          Height = 14
          Caption = 'Level (-128 to +128): '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
        end
        object btnTrigerOn: TSpeedButton
          Left = 8
          Top = 31
          Width = 33
          Height = 22
          AllowAllUp = True
          GroupIndex = 5
          Caption = 'On'
          OnClick = btnTrigerOnClick
        end
        object TrigLevelBar: TTrackBar
          Left = 56
          Top = 24
          Width = 41
          Height = 185
          Hint = 'Trigger level'
          Max = 128
          Min = -128
          Orientation = trVertical
          Frequency = 128
          TabOrder = 0
          TickMarks = tmBoth
          OnChange = TrigLevelBarChange
        end
      end
      object SpectrumBtn: TBitBtn
        Left = 8
        Top = 40
        Width = 41
        Height = 25
        Hint = 'Spectrum'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = SpectrumBtnClick
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF00000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000FF00FF000000
          FF00FFFF00FF000000FF00FF000000FF00FF000000FF00FF000000FF00FF0000
          00FF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FF000000FF00FF000000FF
          00FF000000FF00FF000000FF00FF000000FF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FF000000FF00FF000000FF00FF000000FF00FF000000FF00FF0000
          00FF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FF000000FF00FF000000FF
          00FF000000FF00FF000000FF00FF000000FF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FF000000FF00FF000000FF00FF000000FF00FF000000FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FF000000FF
          00FF000000FF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FFFF00FFFF00FF000000FF00FF000000FF00FF000000FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      end
      object CalibrateBtn: TBitBtn
        Left = 48
        Top = 40
        Width = 57
        Height = 25
        Hint = 'Set zero level'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = CalibrateBtnClick
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000000000000000000000
          00FF00FFFF00FFFF00FFFF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF
          00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FF000000FF00FFFF00FF0000000000000000000000000000000000
          00000000FF00FFFF00FFFF00FF000000FF00FFFF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF
          00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000000000000000000000
          00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FF}
      end
    end
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 142
      Height = 426
      Align = alLeft
      BevelInner = bvLowered
      BevelWidth = 2
      TabOrder = 1
      object GrpChannel1: TGroupBox
        Left = 8
        Top = 8
        Width = 126
        Height = 201
        Caption = 'Channel 1'
        TabOrder = 0
        object Label5: TLabel
          Left = 78
          Top = 16
          Width = 38
          Height = 14
          Caption = 'Offset'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
        end
        object Label6: TLabel
          Left = 8
          Top = 60
          Width = 37
          Height = 18
          Caption = 'Gain'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
        end
        object btnCH1Gnd: TSpeedButton
          Left = 8
          Top = 169
          Width = 33
          Height = 22
          AllowAllUp = True
          GroupIndex = 7
          Caption = 'Gnd'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          OnClick = btnCH1GndClick
        end
        object trOfsCh1: TTrackBar
          Left = 78
          Top = 32
          Width = 24
          Height = 161
          Max = 160
          Min = -160
          Orientation = trVertical
          Frequency = 20
          TabOrder = 0
          OnChange = trOfsCh1Change
        end
        object upGainCh1: TUpDown
          Left = 38
          Top = 84
          Width = 19
          Height = 26
          Associate = edtGainCh1
          Max = 6
          Position = 3
          TabOrder = 1
        end
        object edtGainCh1: TEdit
          Left = 7
          Top = 84
          Width = 31
          Height = 26
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Text = '3'
          OnChange = edtGainCh1Change
        end
        object OnCh1Box: TCheckBox
          Left = 7
          Top = 22
          Width = 53
          Height = 16
          Caption = 'On'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = btnCh1OnClick
        end
      end
      object grpChannel2: TGroupBox
        Left = 7
        Top = 216
        Width = 127
        Height = 201
        Caption = 'Channel 2'
        TabOrder = 1
        object Label7: TLabel
          Left = 78
          Top = 16
          Width = 38
          Height = 14
          Caption = 'Offset'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
        end
        object Label8: TLabel
          Left = 8
          Top = 67
          Width = 37
          Height = 18
          Caption = 'Gain'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
        end
        object btnCH2Gnd: TSpeedButton
          Left = 8
          Top = 162
          Width = 64
          Height = 22
          AllowAllUp = True
          GroupIndex = 7
          Caption = 'Gnd'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          OnClick = btnCH2GndClick
        end
        object trOfsCh2: TTrackBar
          Left = 78
          Top = 40
          Width = 24
          Height = 160
          Max = 160
          Min = -160
          Orientation = trVertical
          Frequency = 20
          TabOrder = 0
          OnChange = trOfsCh2Change
        end
        object upGainCh2: TUpDown
          Left = 33
          Top = 91
          Width = 20
          Height = 26
          Associate = edtGainCh2
          Max = 6
          Position = 3
          TabOrder = 1
        end
        object edtGainCh2: TEdit
          Left = 7
          Top = 91
          Width = 26
          Height = 26
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Text = '3'
          OnChange = edtGainCh2Change
        end
        object OnCh2Box: TCheckBox
          Left = 7
          Top = 30
          Width = 53
          Height = 15
          Caption = 'On'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = btnCh2OnClick
        end
      end
    end
    object Panel4: TPanel
      Left = 854
      Top = 1
      Width = 136
      Height = 426
      Align = alLeft
      BevelInner = bvLowered
      BevelWidth = 2
      TabOrder = 2
      object GroupBox2: TGroupBox
        Left = 4
        Top = 4
        Width = 121
        Height = 322
        Caption = 'Time'
        TabOrder = 0
        object Label2: TLabel
          Left = 8
          Top = 120
          Width = 89
          Height = 13
          AutoSize = False
          Caption = 'Horizontal gain'
          WordWrap = True
        end
        object ScaleLbl: TLabel
          Left = 14
          Top = 20
          Width = 32
          Height = 12
          Caption = 'Scale:'
        end
        object sp11025Sample: TSpeedButton
          Left = 8
          Top = 40
          Width = 49
          Height = 22
          GroupIndex = 6
          Down = True
          Caption = '11,025'
          OnClick = sp11025SampleClick
        end
        object sp22050Sample: TSpeedButton
          Left = 8
          Top = 64
          Width = 49
          Height = 22
          GroupIndex = 6
          Caption = '22,050'
          OnClick = sp22050SampleClick
        end
        object sp44100Sample: TSpeedButton
          Left = 8
          Top = 88
          Width = 49
          Height = 22
          GroupIndex = 6
          Caption = '44,100'
          OnClick = sp44100SampleClick
        end
        object SweepEdt: TEdit
          Left = 8
          Top = 139
          Width = 29
          Height = 20
          TabOrder = 0
          Text = '1'
          OnChange = SweepEdtChange
        end
        object SweepUD: TUpDown
          Left = 37
          Top = 139
          Width = 16
          Height = 20
          Associate = SweepEdt
          Min = 1
          Max = 10
          Position = 1
          TabOrder = 1
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 176
        Width = 121
        Height = 150
        Caption = 'Capture frame'
        TabOrder = 1
        object btnExpand1: TSpeedButton
          Left = 8
          Top = 31
          Width = 23
          Height = 22
          GroupIndex = 8
          Down = True
          Caption = 'X1'
          OnClick = btnExpand1Click
        end
        object btnExpand2: TSpeedButton
          Left = 32
          Top = 30
          Width = 23
          Height = 22
          GroupIndex = 8
          Caption = 'X2'
          OnClick = btnExpand2Click
        end
        object btnExpand4: TSpeedButton
          Left = 56
          Top = 30
          Width = 23
          Height = 22
          GroupIndex = 8
          Caption = 'X4'
          OnClick = btnExpand4Click
        end
        object btnExpand8: TSpeedButton
          Left = 80
          Top = 30
          Width = 23
          Height = 22
          GroupIndex = 8
          Caption = 'X8'
          OnClick = btnExpand8Click
        end
        object Label11: TLabel
          Left = 8
          Top = 16
          Width = 41
          Height = 12
          Caption = 'Expand:'
        end
        object Label13: TLabel
          Left = 8
          Top = 56
          Width = 27
          Height = 12
          Caption = 'Gain:'
        end
        object btnGain0: TSpeedButton
          Left = 8
          Top = 72
          Width = 33
          Height = 22
          GroupIndex = 9
          Caption = '/2'
          OnClick = btnGain0Click
        end
        object btnGain1: TSpeedButton
          Left = 40
          Top = 72
          Width = 33
          Height = 22
          GroupIndex = 9
          Down = True
          Caption = 'X1'
          OnClick = btnGain1Click
        end
        object btnGain2: TSpeedButton
          Left = 72
          Top = 72
          Width = 33
          Height = 22
          GroupIndex = 9
          Caption = 'X2'
          OnClick = btnGain2Click
        end
        object Label12: TLabel
          Left = 37
          Top = 102
          Width = 47
          Height = 12
          Caption = '<-- X -->'
          OnDblClick = Label12DblClick
        end
        object trStartPos: TTrackBar
          Left = 4
          Top = 113
          Width = 113
          Height = 33
          Max = 400
          Min = -400
          Frequency = 40
          TabOrder = 0
          OnChange = trStartPosChange
        end
      end
      object GroupBox4: TGroupBox
        Left = 4
        Top = 332
        Width = 128
        Height = 90
        Align = alBottom
        Caption = 'Intensities'
        TabOrder = 2
        object Label9: TLabel
          Left = 8
          Top = 28
          Width = 28
          Height = 12
          Caption = 'Scale'
        end
        object Label1: TLabel
          Left = 50
          Top = 28
          Width = 28
          Height = 12
          Caption = 'Beam'
        end
        object Label10: TLabel
          Left = 86
          Top = 28
          Width = 27
          Height = 12
          Caption = 'focus'
        end
        object UpScaleLight: TUpDown
          Left = 16
          Top = 47
          Width = 17
          Height = 25
          Min = 25
          Max = 200
          Increment = 10
          Position = 70
          TabOrder = 0
          OnChanging = UpScaleLightChanging
        end
        object upBeamLight: TUpDown
          Left = 56
          Top = 47
          Width = 17
          Height = 25
          Min = -180
          Max = 150
          Increment = 15
          Position = 1
          TabOrder = 1
          OnClick = upBeamLightClick
        end
        object upFocus: TUpDown
          Left = 96
          Top = 47
          Width = 17
          Height = 25
          Min = 1
          Max = 6
          Position = 1
          TabOrder = 2
          OnClick = upFocusClick
        end
      end
    end
    object PageControl1: TPageControl
      Left = 143
      Top = 1
      Width = 531
      Height = 426
      ActivePage = Runsheet
      Align = alLeft
      TabOrder = 3
      object IntroSheet: TTabSheet
        Caption = 'Introduction'
        ImageIndex = 1
        object Memo1: TMemo
          Left = 0
          Top = 0
          Width = 523
          Height = 399
          Align = alClient
          Color = 15400959
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = []
          Lines.Strings = (
            
              'This simple oscilloscope uses the Windows Wavein API to capture ' +
              'data '
            
              'from a sound card and display it in the screen area above.   Use' +
              ' the '
            
              'Windows "Volume Controls - Options - Properties"  dialog and sel' +
              'ect '
            
              '"Recording Controls" to select input source(s) to be displayed. ' +
              '   After the '
            
              'Start button is clicked, any messages describing capture problem' +
              's will be '
            'displayed here.'
            ''
            
              'Version  2: A "Trigger" capability has been added.  Each scan is' +
              ' triggered'
            
              'when the signal rises above (+) or below (-) the preset trigger ' +
              'level.  To'
            
              'improve the image capture of transient events, there is now a "C' +
              'apture'
            
              'Single Frame" button.  Use he "Trigger" feature to control when ' +
              'the frame'
            'will be captured.'
            ''
            
              'Version 3  Spectrum analysis of Captured frames.  User selectabl' +
              'e Sample'
            'rates.  Time scale ref.lines on display.'
            ''
            
              'Version 4:  Dual trace function added.  Improved visual layout. ' +
              '  Improved'
            
              'controls.  Input signal selectable via buttons.    Settings save' +
              'd from run to'
            
              'run.  Many thanks to "Krille", a very sharp Delphi programmer fr' +
              'om '
            'Sweden.  ()March 28, 2014: Version 4.2.3 cleans up a number of '
            
              'formatting errors and adds some control hints.  Still a work in ' +
              'progress so '
            'bug reports are welcome.)')
          ParentFont = False
          TabOrder = 0
        end
      end
      object Runsheet: TTabSheet
        Caption = 'Oscilloscope'
        inline frmOscilloscope1: TfrmOscilloscope
          Left = 0
          Top = 0
          Width = 523
          Height = 399
          Align = alClient
          AutoSize = True
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          ExplicitWidth = 523
          ExplicitHeight = 399
          inherited Image1: TImage
            Width = 523
            Height = 399
            Stretch = True
            ExplicitWidth = 523
            ExplicitHeight = 400
          end
          inherited Image2: TImage
            Left = 40
            Top = 39
            Width = 446
            Height = 320
            ExplicitLeft = 40
            ExplicitTop = 39
            ExplicitWidth = 446
            ExplicitHeight = 320
          end
          inherited ImgScreen: TImage
            Left = 273
            Top = 155
            Width = 97
            Height = 97
            ExplicitLeft = 273
            ExplicitTop = 155
            ExplicitWidth = 97
            ExplicitHeight = 97
          end
        end
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 604
    Width = 1080
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'maXbox http://www.delphiforfun.org/'
    Color = clSkyBlue
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = [fsUnderline]
    ParentColor = False
    ParentFont = False
    TabOrder = 2
    OnClick = StaticText1Click
  end
  inline frmInputControl1: TfrmInputControl
    Left = 0
    Top = 461
    Width = 1080
    Height = 84
    HorzScrollBar.Visible = False
    VertScrollBar.Visible = False
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    ExplicitTop = 461
    ExplicitWidth = 1080
    ExplicitHeight = 84
    inherited pnlButtons: TPanel
      Left = 222
      Width = 96
      Height = 84
      ExplicitLeft = 222
      ExplicitWidth = 96
      ExplicitHeight = 84
    end
    inherited Panel2: TPanel
      Width = 222
      Height = 84
      Font.Height = -16
      ExplicitWidth = 222
      ExplicitHeight = 84
      inherited lblStereo: TLabel
        Left = 116
        Top = 51
        Width = 91
        Height = 18
        Font.Height = -16
        ExplicitLeft = 116
        ExplicitTop = 51
        ExplicitWidth = 91
        ExplicitHeight = 18
      end
    end
    inherited Panel3: TPanel
      Left = 318
      Width = 244
      Height = 84
      Font.Height = -16
      ExplicitLeft = 318
      ExplicitWidth = 244
      ExplicitHeight = 84
      inherited trInpVoume: TTrackBar
        Left = 52
        Top = 32
        Width = 185
        Height = 23
        ExplicitLeft = 52
        ExplicitTop = 32
        ExplicitWidth = 185
        ExplicitHeight = 23
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 776
    Top = 648
    object File1: TMenuItem
      Caption = 'File'
      object menuSaveImage1: TMenuItem
        Caption = 'Save Image'
        OnClick = menuSaveImage1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object menuExit: TMenuItem
        Caption = 'Exit'
        OnClick = menuExitClick
      end
    end
    object Screen1: TMenuItem
      Caption = 'Screen'
      object Color1: TMenuItem
        Caption = 'Color'
        object menuBlack: TMenuItem
          Caption = 'Black'
          OnClick = menuBlackClick
        end
        object MenuGreen: TMenuItem
          Caption = 'Green'
          OnClick = MenuGreenClick
        end
      end
      object Data1: TMenuItem
        Caption = 'Data'
        object MenuData_Time: TMenuItem
          Caption = 'Time'
          OnClick = MenuData_TimeClick
        end
      end
    end
  end
end
