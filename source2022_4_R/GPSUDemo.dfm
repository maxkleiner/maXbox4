object FDemo: TFDemo
  Left = 382
  Top = 247
  BorderStyle = bsDialog
  Caption = 'mXDemo3 GPS'
  ClientHeight = 446
  ClientWidth = 483
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object LBL_Latitude: TLabel
    Left = 8
    Top = 68
    Width = 43
    Height = 13
    Caption = 'Latitude:'
  end
  object LBL_Longitude: TLabel
    Left = 8
    Top = 88
    Width = 51
    Height = 13
    Caption = 'Longitude:'
  end
  object LBL_Altitude: TLabel
    Left = 8
    Top = 108
    Width = 41
    Height = 13
    Caption = 'Altitude:'
  end
  object LBL_NbSats: TLabel
    Left = 8
    Top = 176
    Width = 99
    Height = 13
    Caption = 'Number of satellites:'
  end
  object LBL_NbSatsUsed: TLabel
    Left = 8
    Top = 196
    Width = 125
    Height = 13
    Caption = 'Number of satellites used:'
  end
  object SHP_Connected: TShape
    Left = 140
    Top = 8
    Width = 21
    Height = 21
    Brush.Color = clGray
    Shape = stCircle
  end
  object LBL_COMPort: TLabel
    Left = 8
    Top = 44
    Width = 72
    Height = 13
    Caption = 'GPS COM &Port:'
    FocusControl = CMB_COMPort
  end
  object LBL_Speed: TLabel
    Left = 8
    Top = 128
    Width = 34
    Height = 13
    Caption = 'Speed:'
  end
  object LBL_Time: TLabel
    Left = 8
    Top = 220
    Width = 49
    Height = 13
    Caption = 'UTC Time:'
  end
  object LBL_GPSSpeed: TGPSSpeed
    Left = 48
    Top = 124
    Width = 61
    Height = 21
    GPS = GPS1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
  end
  object LBL_Course: TLabel
    Left = 8
    Top = 148
    Width = 38
    Height = 13
    Caption = 'Course:'
  end
  object GPSSpeed1: TGPSSpeed
    Left = 112
    Top = 124
    Width = 61
    Height = 21
    GPS = GPS1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    SpeedUnit = suMile
  end
  object GPSSpeed2: TGPSSpeed
    Left = 176
    Top = 124
    Width = 61
    Height = 21
    GPS = GPS1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    SpeedUnit = suNauticalMile
  end
  object GPSSatellitesPosition1: TGPSSatellitesPosition
    Left = 272
    Top = 4
    Width = 193
    Height = 201
    GPS = GPS1
    CardFont.Charset = DEFAULT_CHARSET
    CardFont.Color = 13408614
    CardFont.Height = -12
    CardFont.Name = 'Tahoma'
    CardFont.Style = [fsBold]
    SatFont.Charset = DEFAULT_CHARSET
    SatFont.Color = clBlue
    SatFont.Height = -11
    SatFont.Name = 'Tahoma'
    SatFont.Style = []
    Pen.Color = 13408614
    Pen.Width = 2
  end
  object GPSCompass1: TGPSCompass
    Left = 236
    Top = 4
    Width = 29
    Height = 29
    GPS = GPS1
    CardFont.Charset = DEFAULT_CHARSET
    CardFont.Color = clRed
    CardFont.Height = -12
    CardFont.Name = 'Arial'
    CardFont.Style = [fsBold]
    Pen.Color = 13408614
    Pen.Width = 2
    Brush.Color = 16764057
  end
  object GPSSatellitesReception1: TGPSSatellitesReception
    Left = 292
    Top = 232
    Width = 157
    Height = 185
    GPS = GPS1
  end
  object BTN_Start: TButton
    Left = 4
    Top = 4
    Width = 125
    Height = 29
    Caption = 'Start'
    Default = True
    TabOrder = 0
    OnClick = BTN_StartClick
  end
  object CMB_COMPort: TComComboBox
    Left = 88
    Top = 40
    Width = 133
    Height = 21
    ComProperty = cpPort
    Text = 'COM1'
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 1
    OnChange = CMB_COMPortChange
  end
  object CHK_Valid: TCheckBox
    Left = 8
    Top = 240
    Width = 209
    Height = 17
    Caption = 'Valide position'
    TabOrder = 2
    OnClick = CHK_ValidClick
  end
  object GPS1: TGPS
    BaudRate = br9600
    DataBits = dbEight
    StopBits = sbOneStopBit
    Parity.Bits = prNone
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    OnGPSDatasChange = GPS1GPSDatasChange
    OnAfterOpen = GPS1AfterOpen
    OnAfterClose = GPS1AfterClose
    Left = 112
    Top = 80
  end
  object GPStoGPX1: TGPStoGPX
    Active = False
    GPS = GPS1
    FileName = 'TestGPX.gpx'
    Left = 168
    Top = 84
  end
end
