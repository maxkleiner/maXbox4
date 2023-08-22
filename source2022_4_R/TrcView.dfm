object TraceForm: TTraceForm
  Left = 35
  Top = 107
  Width = 757
  Height = 338
  Caption = 'Debug Trace Information'
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  PixelsPerInch = 96
  TextHeight = 13
  object TraceData: TListBox
    Left = 0
    Top = 0
    Width = 749
    Height = 311
    Align = alClient
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Fixedsys'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    TabOrder = 0
    OnKeyPress = TraceDataKeyPress
  end
end
