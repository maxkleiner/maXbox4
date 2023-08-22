object SoapForm: TSoapForm
  Left = 162
  Top = 97
  Caption = 'mX SOAP Post Tool'
  ClientHeight = 616
  ClientWidth = 898
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 115
    Width = 898
    Height = 5
    Cursor = crVSplit
    Align = alTop
    ExplicitWidth = 792
  end
  object Panel1: TPanel
    Left = 0
    Top = 120
    Width = 898
    Height = 496
    Align = alClient
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 896
      Height = 494
      ActivePage = tsRequest
      Align = alClient
      TabOrder = 0
      object tsRequest: TTabSheet
        Caption = '&Request'
        object Request: TMemo
          Left = 0
          Top = 0
          Width = 888
          Height = 466
          Align = alClient
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object tsResponse: TTabSheet
        Caption = 'Respon&se'
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Response: TMemo
          Left = 0
          Top = 0
          Width = 782
          Height = 404
          Align = alClient
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object tsTransactionLog: TTabSheet
        Caption = '&Transaction Log'
        ImageIndex = 2
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object TransactionLog: TMemo
          Left = 0
          Top = 0
          Width = 782
          Height = 404
          Align = alClient
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
  end
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 898
    Height = 115
    Align = alTop
    TabOrder = 1
    DesignSize = (
      898
      115)
    object Label1: TLabel
      Left = 10
      Top = 74
      Width = 26
      Height = 13
      Caption = 'Pro&xy'
      FocusControl = Proxy
    end
    object Label4: TLabel
      Left = 10
      Top = 47
      Width = 65
      Height = 13
      Caption = 'SOAP &Action:'
      FocusControl = SOAPAction
    end
    object Label3: TLabel
      Left = 10
      Top = 20
      Width = 25
      Height = 13
      Caption = '&URL:'
      FocusControl = URL
    end
    object Proxy: TEdit
      Left = 89
      Top = 70
      Width = 690
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object SOAPAction: TEdit
      Left = 89
      Top = 41
      Width = 690
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object URL: TEdit
      Left = 89
      Top = 12
      Width = 690
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
    end
    object Post: TButton
      Left = 809
      Top = 15
      Width = 75
      Height = 26
      Anchors = [akTop, akRight]
      Caption = '&Post'
      TabOrder = 3
      OnClick = PostClick
    end
  end
  object HTTPReqResp1: THTTPReqResp
    Agent = 'Borland SOAP 1.1'
    UseUTF8InHeader = True
    InvokeOptions = []
    Left = 696
    Top = 72
  end
  object MainMenu1: TMainMenu
    Left = 664
    Top = 72
    object File1: TMenuItem
      Caption = '&File'
      object FileNew: TMenuItem
        Caption = '&New'
        ShortCut = 16462
        OnClick = FileNewClick
      end
      object FileOpen: TMenuItem
        Caption = '&Open'
        ShortCut = 16463
        OnClick = FileOpenClick
      end
      object FileSave: TMenuItem
        Caption = '&Save'
        ShortCut = 16467
        OnClick = FileSaveClick
      end
      object FileExit: TMenuItem
        Caption = '&Exit'
        ShortCut = 16472
        OnClick = FileExitClick
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 728
    Top = 72
  end
  object OpenDialog1: TOpenDialog
    Left = 760
    Top = 72
  end
end
