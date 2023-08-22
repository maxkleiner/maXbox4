object HexForm2: THexForm2
  Left = 207
  Top = 36
  Caption = 'mX Hex View:  No file selected'
  ClientHeight = 713
  ClientWidth = 895
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCanResize = FormCanResize
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  DesignSize = (
    895
    713)
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 224
    Top = 648
    Width = 66
    Height = 16
    Anchors = [akLeft, akBottom]
    Caption = 'Page 0 of 0'
  end
  object Memo1: TMemo
    Left = 24
    Top = 16
    Width = 848
    Height = 601
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    Lines.Strings = (
      ''
      '    Select a file to view contents.'
      ''
      '    Browse using PgUp, PgDn keys'
      ''
      '    Ctrl+PgUp = view 1st page'
      '    Ctrl+PgDn = view last page'
      '    Esc = Close file')
    ParentFont = False
    TabOrder = 0
    WordWrap = False
  end
  object OpenBtn: TButton
    Left = 40
    Top = 648
    Width = 137
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Select a file'
    TabOrder = 1
    OnClick = OpenBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 693
    Width = 895
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 
      'Copyright 2007, Gary Darby, Intellitech Systems Inc., www.Delphi' +
      'ForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 2
    OnClick = StaticText1Click
  end
  object Memo2: TMemo
    Left = 432
    Top = 600
    Width = 393
    Height = 57
    Lines.Strings = (
      '    Browse using PgUp, PgDn keys.  '
      '    Ctrl+PgUp = view 1st page;     Ctrl+PgDn = view last page'
      '    Esc= Close file'
      '')
    TabOrder = 3
  end
  object OpenDialog1: TOpenDialog
    Left = 784
    Top = 576
  end
end
