object JvDirectoryListDialog: TJvDirectoryListDialog
  Left = 206
  Top = 99
  ActiveControl = AddBtn
  BorderIcons = [biSystemMenu]
  Caption = 'Directory mX list'
  ClientHeight = 194
  ClientWidth = 350
  Color = clBtnFace
  Constraints.MinHeight = 221
  Constraints.MinWidth = 358
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100001001000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    00000000000000000BBBB0000000000BB000BB000000000BB0000B000000000B
    BB000BB00000000BBB000BB00000000000000BB00000000000000BB000000000
    00000BB00000000000000BB00000000000000BB00000000000000BB000000000
    00000BB0000000000000BBBB00000000000BBBBBB0000000000000000000FFFF
    0000F87F0000E73F0000E7BF0000E39F0000E39F0000FF9F0000FF9F0000FF9F
    0000FF9F0000FF9F0000FF9F0000FF9F0000FF0F0000FE070000FFFF0000}
  OldCreateOrder = True
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    350
    194)
  PixelsPerInch = 96
  TextHeight = 13
  object AddBtn: TButton
    Left = 264
    Top = 12
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Add...'
    TabOrder = 0
    OnClick = AddBtnClick
  end
  object RemoveBtn: TButton
    Left = 264
    Top = 76
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Remove'
    TabOrder = 2
    OnClick = RemoveBtnClick
  end
  object ModifyBtn: TButton
    Left = 264
    Top = 44
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Modify'
    TabOrder = 1
    OnClick = ModifyBtnClick
  end
  object OKBtn: TButton
    Left = 264
    Top = 120
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object CancelBtn: TButton
    Left = 264
    Top = 152
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object directorylist: TListBox
    Left = 24
    Top = 12
    Width = 193
    Height = 165
    ItemHeight = 13
    TabOrder = 5
  end
end
