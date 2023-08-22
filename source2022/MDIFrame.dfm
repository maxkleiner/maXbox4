object FrameForm: TFrameForm
  Left = 219
  Top = 138
  Caption = 'Text editor'
  ClientHeight = 586
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poDefault
  WindowMenu = Window1
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 8
    Top = 248
    object File1: TMenuItem
      Caption = '&File'
      object New1: TMenuItem
        Caption = '&New'
        OnClick = New1Click
      end
      object Open1: TMenuItem
        Caption = '&Open...'
        OnClick = Open1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        GroupIndex = 9
        OnClick = Exit1Click
      end
    end
    object Window1: TMenuItem
      Caption = '&Window'
      GroupIndex = 9
      object Tile1: TMenuItem
        Caption = '&Tile'
        OnClick = Tile1Click
      end
      object Cascade1: TMenuItem
        Caption = '&Cascade'
        OnClick = Cascade1Click
      end
      object Arrangeicons1: TMenuItem
        Caption = '&Arrange icons'
        OnClick = Arrangeicons1Click
      end
    end
  end
  object OpenFileDialog: TOpenDialog
    Filter = 
      'Rich text files (*.rtf)|*.rtf|Plain text files (*.txt)|*.txt|All' +
      ' files|*.*'
    Left = 16
    Top = 24
  end
end
