object ComTrmSetForm: TComTrmSetForm
  Left = 375
  Top = 187
  BorderStyle = bsDialog
  Caption = 'Setup'
  ClientHeight = 287
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 281
    Height = 113
    Caption = ' ASCII Settings '
    TabOrder = 0
    object CheckBox1: TCheckBox
      Left = 8
      Top = 24
      Width = 177
      Height = 17
      Caption = 'Echo typed charachters locally'
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 40
      Width = 193
      Height = 17
      Caption = 'Send line feeds with carriage return'
      TabOrder = 1
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 56
      Width = 217
      Height = 17
      Caption = 'Wrap lines that exceed terminal width'
      TabOrder = 2
    end
    object CheckBox4: TCheckBox
      Left = 8
      Top = 72
      Width = 193
      Height = 17
      Caption = 'Force incoming data to 7 bit ASCII'
      TabOrder = 3
    end
    object CheckBox5: TCheckBox
      Left = 8
      Top = 88
      Width = 241
      Height = 17
      Caption = 'Append line feeds to incoming carriage return'
      TabOrder = 4
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 128
    Width = 281
    Height = 121
    Caption = ' Terminal Settings '
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 25
      Height = 13
      Caption = 'Caret'
    end
    object Label3: TLabel
      Left = 8
      Top = 72
      Width = 40
      Height = 13
      Caption = 'Columns'
    end
    object Label4: TLabel
      Left = 144
      Top = 72
      Width = 27
      Height = 13
      Caption = 'Rows'
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 46
      Height = 13
      Caption = 'Emulation'
    end
    object Label5: TLabel
      Left = 8
      Top = 96
      Width = 55
      Height = 13
      Caption = 'Cursor keys'
    end
    object ComboBox1: TComboBox
      Left = 72
      Top = 16
      Width = 97
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      Items.Strings = (
        'Block'
        'Underline')
    end
    object ComboBox2: TComboBox
      Left = 72
      Top = 40
      Width = 97
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        'ANSI/VT100'
        'VT52'
        'None')
    end
    object ComboBox3: TComboBox
      Left = 72
      Top = 88
      Width = 161
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        'Act as terminal keys'
        'Act as windows keys')
    end
    object Edit1: TEdit
      Left = 72
      Top = 64
      Width = 49
      Height = 21
      TabOrder = 3
    end
    object Edit2: TEdit
      Left = 184
      Top = 64
      Width = 49
      Height = 21
      TabOrder = 4
    end
  end
  object Button1: TButton
    Left = 134
    Top = 256
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 214
    Top = 256
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
