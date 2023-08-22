object SocketForm: TSocketForm
  Left = 282
  Top = 179
  BorderIcons = [biSystemMenu]
  Caption = 'mX Borland Socket Server'
  ClientHeight = 432
  ClientWidth = 497
  Color = clBtnFace
  Constraints.MinHeight = 478
  Constraints.MinWidth = 437
  ParentFont = True
  Menu = MainMenu1
  OldCreateOrder = True
  PopupMode = pmAuto
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Pages: TPageControl
    Left = 89
    Top = 0
    Width = 408
    Height = 432
    ActivePage = PropPage
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 340
    object PropPage: TTabSheet
      Caption = 'Properties'
      ExplicitWidth = 332
      DesignSize = (
        400
        404)
      object PortGroup: TGroupBox
        Left = 8
        Top = 8
        Width = 389
        Height = 97
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Port'
        TabOrder = 0
        ExplicitWidth = 321
        DesignSize = (
          389
          97)
        object Label1: TLabel
          Left = 38
          Top = 20
          Width = 70
          Height = 13
          Alignment = taRightJustify
          Caption = '&Listen on Port:'
          FocusControl = PortNo
        end
        object PortDesc: TLabel
          Left = 8
          Top = 40
          Width = 372
          Height = 49
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Many values of Port are associated by convention with a particul' +
            'ar service such as ftp or http. Port is the ID of the connection' +
            ' on which the server listens for client requests. '
          WordWrap = True
          ExplicitWidth = 304
        end
        object PortNo: TEdit
          Left = 120
          Top = 16
          Width = 73
          Height = 21
          TabOrder = 0
          Text = '1'
          OnExit = IntegerExit
        end
        object PortUpDown: TUpDown
          Left = 193
          Top = 16
          Width = 12
          Height = 21
          Associate = PortNo
          Min = 1
          Max = 32767
          Position = 1
          TabOrder = 1
          Thousands = False
          OnClick = UpDownClick
        end
      end
      object ThreadGroup: TGroupBox
        Left = 8
        Top = 112
        Width = 389
        Height = 81
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Thread Caching'
        TabOrder = 1
        ExplicitWidth = 321
        DesignSize = (
          389
          81)
        object Label4: TLabel
          Left = 17
          Top = 16
          Width = 93
          Height = 13
          Alignment = taRightJustify
          Caption = '&Thread Cache Size:'
          FocusControl = ThreadSize
        end
        object ThreadDesc: TLabel
          Left = 8
          Top = 40
          Width = 373
          Height = 33
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Thread Cache Size is the maximum number of threads that can be r' +
            'eused for new client connections.'
          WordWrap = True
          ExplicitWidth = 305
        end
        object ThreadSize: TEdit
          Left = 120
          Top = 12
          Width = 73
          Height = 21
          TabOrder = 0
          Text = '0'
          OnExit = IntegerExit
        end
        object ThreadUpDown: TUpDown
          Left = 193
          Top = 12
          Width = 12
          Height = 21
          Associate = ThreadSize
          Max = 1000
          TabOrder = 1
          Thousands = False
          OnClick = UpDownClick
        end
      end
      object InterceptGroup: TGroupBox
        Left = 8
        Top = 288
        Width = 389
        Height = 81
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Intercept GUID'
        TabOrder = 3
        ExplicitWidth = 321
        DesignSize = (
          389
          81)
        object Label5: TLabel
          Left = 16
          Top = 20
          Width = 29
          Height = 13
          Caption = '&GUID:'
        end
        object GUIDDesc: TLabel
          Left = 16
          Top = 40
          Width = 365
          Height = 33
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Intercept GUID is the GUID for a data interceptor COM object.  S' +
            'ee help for the TSocketConnection for details.'
          WordWrap = True
          ExplicitWidth = 297
        end
        object InterceptGUID: TEdit
          Left = 56
          Top = 16
          Width = 257
          Height = 21
          TabOrder = 0
        end
      end
      object TimeoutGroup: TGroupBox
        Left = 8
        Top = 200
        Width = 389
        Height = 81
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Timeout'
        TabOrder = 2
        ExplicitWidth = 321
        DesignSize = (
          389
          81)
        object Label7: TLabel
          Left = 22
          Top = 16
          Width = 84
          Height = 13
          Alignment = taRightJustify
          Caption = '&Inactive Timeout:'
          FocusControl = Timeout
        end
        object TimeoutDesc: TLabel
          Left = 16
          Top = 36
          Width = 365
          Height = 37
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Inactive Timeout specifes the number of minutes a client can be ' +
            'inactive before being disconnected. (0 indicates infinite)'
          WordWrap = True
          ExplicitWidth = 297
        end
        object Timeout: TEdit
          Left = 120
          Top = 12
          Width = 73
          Height = 21
          TabOrder = 0
          Text = '0'
          OnExit = IntegerExit
        end
        object TimeoutUpDown: TUpDown
          Left = 193
          Top = 12
          Width = 12
          Height = 21
          Associate = Timeout
          Max = 32767
          Increment = 30
          TabOrder = 1
          OnClick = UpDownClick
        end
      end
      object ApplyButton: TButton
        Tag = -1
        Left = 8
        Top = 375
        Width = 75
        Height = 25
        Action = ApplyAction
        Anchors = [akLeft, akBottom]
        TabOrder = 4
      end
    end
    object StatPage: TTabSheet
      Caption = 'Users'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ConnectionList: TListView
        Left = 0
        Top = 0
        Width = 332
        Height = 385
        Align = alClient
        Columns = <
          item
            Caption = 'Port'
          end
          item
            AutoSize = True
            Caption = 'IP Address'
          end
          item
            AutoSize = True
            Caption = 'Host'
          end
          item
            AutoSize = True
            Caption = 'Last Activity'
          end>
        HideSelection = False
        MultiSelect = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = ConnectionListColumnClick
        OnCompare = ConnectionListCompare
      end
      object UserStatus: TStatusBar
        Left = 0
        Top = 385
        Width = 332
        Height = 19
        Panels = <>
        SimplePanel = True
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 89
    Height = 432
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object PortList: TListBox
      Left = 0
      Top = 17
      Width = 89
      Height = 415
      Align = alClient
      BorderStyle = bsNone
      ItemHeight = 13
      TabOrder = 0
      OnClick = PortListClick
    end
    object HeaderControl1: THeaderControl
      Left = 0
      Top = 0
      Width = 89
      Height = 17
      Sections = <
        item
          AllowClick = False
          AutoSize = True
          ImageIndex = -1
          Text = 'Port'
          Width = 89
        end>
    end
  end
  object PopupMenu: TPopupMenu
    Left = 8
    Top = 72
    object miClose: TMenuItem
      Caption = '&Close'
      OnClick = miCloseClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miProperties: TMenuItem
      Caption = '&Properties'
      Default = True
      OnClick = miPropertiesClick
    end
  end
  object UpdateTimer: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = UpdateTimerTimer
    Left = 8
    Top = 104
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 136
    object miPorts: TMenuItem
      Caption = '&Ports'
      object miAdd: TMenuItem
        Caption = '&Add'
        OnClick = miAddClick
      end
      object miRemove: TMenuItem
        Action = RemovePortAction
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object miExit: TMenuItem
        Caption = '&Exit'
        OnClick = miExitClick
      end
    end
    object Connections1: TMenuItem
      Caption = '&Connections'
      object miShowHostName: TMenuItem
        Action = ShowHostAction
      end
      object ExportedObjectOnly1: TMenuItem
        Action = RegisteredAction
      end
      object XMLPacket1: TMenuItem
        Action = AllowXML
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object miDisconnect: TMenuItem
        Action = DisconnectAction
      end
    end
  end
  object ActionList1: TActionList
    Left = 8
    Top = 168
    object ApplyAction: TAction
      Caption = '&Apply'
      OnExecute = ApplyActionExecute
      OnUpdate = ApplyActionUpdate
    end
    object DisconnectAction: TAction
      Caption = '&Disconnect'
      OnExecute = miDisconnectClick
      OnUpdate = DisconnectActionUpdate
    end
    object ShowHostAction: TAction
      Caption = '&Show Host Name'
      Checked = True
      OnExecute = ShowHostActionExecute
    end
    object RemovePortAction: TAction
      Caption = '&Remove'
      OnExecute = RemovePortActionExecute
      OnUpdate = RemovePortActionUpdate
    end
    object RegisteredAction: TAction
      Caption = '&Registered Objects Only'
      Checked = True
      OnExecute = RegisteredActionExecute
    end
    object AllowXML: TAction
      Caption = '&Allow XML Packets'
      Checked = True
      OnExecute = AllowXMLExecute
    end
  end
end
