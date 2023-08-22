object Service1: TService1
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  DisplayName = 'MXToolbox Interface Service'
  OnContinue = ServiceContinue
  OnPause = ServicePause
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 150
  Width = 215
  object Server: TIdTCPServer
    Bindings = <>
    DefaultPort = 7802
    Left = 28
    Top = 20
  end
  object HTTPServer: TIdHTTPServer
    Bindings = <>
    DefaultPort = 7801
    AutoStartSession = True
    Left = 112
    Top = 24
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 64
    Top = 68
  end
end
