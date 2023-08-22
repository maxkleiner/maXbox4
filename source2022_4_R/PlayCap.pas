// Aufnehmen von Videos und einschl. Audio komprimiert abspeichern
// Bruno Volkmer
// 5/2002
// für ToolBox
//
unit PlayCap;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  {DirectShow,} ExtCtrls, StdCtrls, ComCtrls, ComObj, ActiveX, Menus;



Type TPLAYSTATE  = (Stopped, Paused, Running, Init);

CONST  ONE_SECOND  : Int64 =          10000000;
CONST  ZehntelSekunde : Int64 = 1000000;
const  MAX_TIME = $7FFFFFFFFFFFFFFF;
Const  WM_GRAPHNOTIFY  = WM_APP+1 ;

Type TMenutitel = (Videogeraet, VideoCompression , Audiogeraet, AudioCompression);


type
  TfrmCap = class(TForm)
    Panel1: TPanel;
    pnlView: TPanel;
    btnVideoDevProps: TButton;
    btnCapture: TButton;
    btnPreview: TButton;
    btnExit: TButton;
    StatusBar1: TStatusBar;
    btnVideoComprProps: TButton;
    MainMenu1: TMainMenu;
    Datei1: TMenuItem;
    mnuDatei: TMenuItem;
    N1: TMenuItem;
    mnuExit: TMenuItem;
    mnuVDevice: TMenuItem;
    mnuVCompress: TMenuItem;
    mnuADevice: TMenuItem;
    mnuACompress: TMenuItem;
    btnAudioDevProps: TButton;
    btnAudioComprProps: TButton;
    chkVideoCompress: TCheckBox;
    chkAudioCompress: TCheckBox;
    Timer1: TTimer;
    ProgressBar1: TProgressBar;
    Panel2: TPanel;
    edStart: TEdit;
    edDauer: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    SaveDialog1: TSaveDialog;
    Memo1: TMemo;
    btnStopCapture: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
 
 
    procedure btnCaptureClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
  
    procedure btnVideoComprPropsClick(Sender: TObject);
    procedure mnuVDeviceClick(Sender: TObject);
    procedure mnuVCompressClick(Sender: TObject);
    procedure mnuADeviceClick(Sender: TObject);
    procedure mnuACompressClick(Sender: TObject);
    procedure btnAudioDevPropsClick(Sender: TObject);
    procedure btnAudioComprPropsClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure mnuDateiClick(Sender: TObject);
    procedure btnVideoDevPropsClick(Sender: TObject);
    procedure btnStopCaptureClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
      DeviceName : WideString;
      ComprName  : WideString;
      rtStart, rtStop : TREFERENCE_TIME;

      Function  GetInterfaces: HRESULT;
    
      Function  FindDevice(Category : TGUID; bstrName : WideString; VAR ppSrcFilter : IBaseFilter ) :  HRESULT ;

      Function  SetupVideoWindow: HRESULT;
   
      Function  HandleGraphEvent: HRESULT;

      Procedure Msg(szFormat : String; hr : HRESULT);
      Procedure CloseInterfaces;
      Procedure ResizeVideoWindow;
      Function  InititInterfacesAndFilter : HRESULT;
      Function Enumerate (category : TGUID; VAR item : TMenuItem):HRESULT;
      Function  FillListDevices:HRESULT;


      Function SupportsPropertyPage(pFilter :IBaseFilter ) : BOOL;
      Function  FindFilterFromName(szNameToFind : String )  : IBaseFilter;



      Procedure   WMGrafNotify(VAR msg :TMessage); message WM_GRAPHNOTIFY;
    

      Function DisplayECEvent(lEventCode : Integer) : String;

      Function ShowPins(pFilter : IBaseFilter):HRESULT;
      Procedure  ShowFilterProperties(mnuTitel : TMenuTitel; CONST categorie : TGUID);
      Function PreviewVideo (devname      : WideString):HRESULT;

       Function FindNeededFilter (comprName    : WideString;
                                  audioFilter  : WideString;
                                  audioCompr   : WideString):HRESULT;
       Procedure FilterLoop;
  end;

var
  frmCap: TfrmCap;

implementation

{$R *.DFM}


VAR
   g_dwGraphRegister : INTEGER = 0;
   pVideoWindow        : IVideoWindow    = nil;
   pMediaControl       : IMediaControl   = nil;
   pMediaEventEx       : IMediaEventEx   = nil;
   g_pGraphBuilder     : IGraphBuilder   = nil;
   g_pCapture          : ICaptureGraphBuilder2 = nil;
   g_pBaseFilter       : IBaseFilter;
   g_pDeviceFilter     : IBaseFilter;
   g_pDevEnum          : ICreateDevEnum;
   g_psCurrent         : TPLAYSTATE      = Stopped;
   G_VideoComprFilter  : IBaseFilter;
   G_AudioFilter       : IBaseFilter;
   G_AudioComprFilter  : IBaseFilter;
   G_MediaSeek         : IMediaSeeking;
   OutputFilename      : WideString;
   DefaultDateiName    : WideString;

   sFeld, s            : ARRAY[TMenutitel] OF String;



//------------------------------------------------------------------------------

procedure TfrmCap.FormCreate(Sender: TObject);
VAR hr : HRESULT;
begin
  DefaultDateiName := 'C:\CapTest2.avi';
  OutputFilename := DefaultdateiName;
  hr :=   InititInterfacesAndFilter ;

  IF failed (hr) then EXIT;

  hr :=   FillListDevices;    // suchen und listen
  btnCapture.Enabled := false;
  if FAILED (hr) then
  BEGIN
      CloseInterfaces;
      Close;
      Application.Terminate;
   END ;
end;

//------------------------------------------------------------------------------

Function TfrmCap.InititInterfacesAndFilter : HRESULT;
var   hr  : HRESULT ;

BEGIN
    // DirectShow Interfaces holen
    hr := GetInterfaces;      // initialisiert alle Objekte

    if  FAILED(hr) then
    BEGIN
        Msg('Fehler beim Suchen nach den  Video Interfaces!  hr:= $%x', hr);
        result :=  hr;
        exit;
     END;

    // Filtergraph dem Capture Graph  zufügen
    hr := g_pCapture.SetFiltergraph(g_pGraphBuilder);
    if FAILED(hr) then 
    BEGIN
        Msg('Capture Filter Graph kann nicht gesetzt werden!  hr:=%x', hr);
        result :=  hr;
        exit;
     END;


    result := hr;
end;
//------------------------------------------------------------------------------
//  benötigte Interface erzeugen
//------------------------------------------------------------------------------

Function TfrmCap.GetInterfaces:     HRESULT ;
VAR     hr : HRESULT ;

BEGIN
    // Filter Graph  erzeugen
    hr := CoCreateInstance ( CLSID_FilterGraph, nil, CLSCTX_INPROC,
                             IGraphBuilder, g_pGraphBuilder);           //IGraphBuilder
        if FAILED(hr) then
    begin
        result :=  hr;
        exit;
    end;

    // Capture GraphBuilder  erzeugen
    hr := CoCreateInstance ( CLSID_CaptureGraphBuilder2 , nil, CLSCTX_INPROC,
                             ICaptureGraphBuilder2, g_pCapture);
        if FAILED(hr) then   begin
        result :=  hr;
        exit;
    end;

 
    // Interface für Media Control holen, wird zur Vorschau benötigt
    hr := g_pGraphBuilder.QueryInterface(IMediaControl, pMediaControl);
    if FAILED(hr) then   begin
        result :=  hr;
        exit;
    end;

     // Interface für Videowindow holen, dort wird angezeigt weden
    hr := g_pGraphBuilder.QueryInterface(IVideoWindow, pVideoWindow);
    if FAILED(hr) then  begin
        result :=  hr;
        exit;
    end;

      // Interface für Benachrichtigungen holen
    hr := g_pGraphBuilder.QueryInterface(IID_IMediaEvent, pMediaEventEx);
    if FAILED(hr) then  begin
        result :=  hr;
           exit;
    end;
        // Fenster für Benachrichtigungen zuordnen
    hr := pMediaEventEx.SetNotifyWindow(OAHWND(Handle), WM_GRAPHNOTIFY, 0);

    result :=  hr;
 END;

//------------------------------------------------------------------------------
// PC nach Aufnahmegeräten absuchen und im Menü zur Auswahl anbieten
//------------------------------------------------------------------------------

Function TfrmCap.Enumerate (category : TGUID; VAR item : TMenuItem):HRESULT;
VAR  hr           : HRESULT;
     pMoniker     : IMoniker;
     cFetched     : ULONG ;
     pEnumMoniker : IEnumMoniker;
     pProp        : IPropertybag;
     varName      : Olevariant;
     mnuItem      : TmenuItem;
begin
     hr := g_pDevEnum.CreateClassEnumerator (category,  pEnumMoniker, 0);

     if FAILED(hr) then
     BEGIN
        Msg('Kann  keine Kompressions - Filter finden!  hr:= $%x', hr);
        result :=  hr;
        exit;
     END
     else

     while pEnumMoniker.Next(1, pMoniker, @cFetched) = S_OK  DO
     BEGIN
        hr :=  pMoniker.BindToStorage(nil, nil, IPropertyBag, pProp);
        hr := pProp.Read('FriendlyName', varName, nil);
        IF succeeded(hr) then Begin

          mnuItem := TmenuItem.Create(self);
          item.Add(mnuItem);
          mnuItem. AutoHotkeys := maManual;
          mnuItem.Caption      := varname;
          mnuItem.Onclick      := item.OnClick;
          mnuItem.tag          := item.Count   ;

        end;
     end;
   Result := hr;
end;

//------------------------------------------------------------------------------
// Menus erzeugen und ausfüllen
//------------------------------------------------------------------------------


Function TfrmCap.FillListDevices:HRESULT;
VAR
  hr          : HRESULT ;
BEGIN

    // Systemdevices : Interface für Aufzählung erzeugen
    hr := CoCreateInstance ( CLSID_SystemDeviceEnum, nil, CLSCTX_INPROC,
                             ICreateDevEnum, g_pDevEnum);

    if FAILED(hr) then
    BEGIN
        Msg('Kann  System Enumerator  nicht erzeugen!  hr:= $%x', hr);
        result :=  hr;
        exit;
     END;



   hr :=   Enumerate (CLSID_VideoCompressorCategory, mnuVCompress);
   IF failed(hr) then begin Result := hr ; exit; end;
   mnuVCompress.Items[0].Checked := true;

    hr :=   Enumerate (CLSID_AudioInputDeviceCategory, mnuADevice);
     IF failed(hr) then begin Result := hr ; exit; end;
     mnuADevice .Items[0].Checked := true;

    hr :=   Enumerate (CLSID_AudioCompressorCategory, mnuACompress);
     IF failed(hr) then begin Result := hr ; exit; end;
     mnuACompress .Items[0].Checked := true;

   hr :=   Enumerate (CLSID_VideoInputDeviceCategory, mnuVDevice);
     IF failed(hr) then begin Result := hr ; exit; end;
     mnuVDevice .Items[0].Checked := true;
    result := hr;
end;

//------------------------------------------------------------------------------
// Vorschau starten
//------------------------------------------------------------------------------

Function TfrmCap.PreviewVideo(devname      : WideString):HRESULT;

VAR
    hr           : HRESULT ;
    pSrcFilter   : IBaseFilter ;
    pComprFilter : IBaseFilter;
    ppsink       : IFileSinkFilter;
    pAudioFilter : IbaseFilter;
    pAudioComprFilter : IbaseFilter;
    pStreamConfig : IAMStreamConfig;
    pVih          : PVIDEOINFOHEADER ;
    pmt           :  PAM_MEDIA_TYPE;
BEGIN

    hr := FindDevice(CLSID_VideoInputDeviceCategory, DevName, pSrcFilter);  // Capture Device suchen, EnumCaps etc
    btnVideoDevProps.Enabled :=  SupportsPropertyPage(pSrcFilter);

    g_pDeviceFilter :=  pSrcFilter;               // die Capture Device merken

    if FAILED(hr) then
    BEGIN
         result :=  hr;
         exit;
     END;
   
    //  Capture Device - Filter zu Graph hinzufügen.
    hr := g_pGraphBuilder.AddFilter(pSrcFilter, 'Video Capture');
    if FAILED(hr) then
    BEGIN
        Msg('Kann Capture Filter dem Graph nicht hinzufügen!  hr:=$%x', hr);
        pSrcFilter:= nil;
        result :=  hr;
        exit;
     END;

     // die restlichen Filter werden hier schon erzeugt, aber nioch nicht dem Graphbuilder zugefügt


      hr := g_pCapture.RenderStream ( @PIN_CATEGORY_PREVIEW,
                                      @MEDIATYPE_Video,
                                      pSrcFilter,
                                      nil,
                                      nil);

   if FAILED(hr) then
    BEGIN
        Msg('Kann den  Capture Stream zur Vorschau nicht rendern  '  +
            'Möglicherweise ist das Gerät schon in Gebrauch ($%x)', hr);
        pSrcFilter   := nil;
        result       :=  hr;
        exit;
     END;



    pSrcFilter:= nil;

    // Windowstil  und Position  setzen
    hr := SetupVideoWindow;
    if FAILED(hr) then 
    BEGIN
        Msg('Kann das  Video Window nicht initialisieren!  hr:=0x%x', hr);
        result :=  hr;
        exit;
     END;




     hr := g_pCapture.FindInterface( @PIN_CATEGORY_CAPTURE,
                                     @MEDIATYPE_Interleaved,
                                     g_pDeviceFilter,
                                     IAMStreamConfig,
                                     pStreamConfig);

    if  hr <>  NOERROR then  begin
        hr := g_pCapture.FindInterface(@PIN_CATEGORY_CAPTURE,
            @MEDIATYPE_Video, g_pDeviceFilter,
            IAMStreamConfig, pStreamConfig);

        if hr <>  NOERROR   then
           Begin
            ShowMessage(Format('Keine StreamConfig - Möglichkeit %x',[hr]));
            exit;
           end;
          hr :=   pStreamConfig.getFormat(pmt);
          pVih  := PVIDEOINFOHEADER(pmt^.pbFormat);
          pVih^.AvgTimePerFrame := 400000;
          pVih^.bmiHeader.biWidth  :=  352;
          pVih^.bmiHeader.biHeight :=  288;
          hr := pStreamConfig.SetFormat(pmt^);
          IF succeeded (hr) then begin
             pnlView.Width :=  pVih^.bmiHeader.biWidth;
             pnlView.Height := pVih^.bmiHeader.biHeight ;
          end;
    end;
     // los gehts
   // Status merken


   hr := pMediaControl.Run;
    if FAILED(hr) then
    BEGIN
        Msg('Kann Graph nicht starten  hr:= $%x', hr);
        result :=  hr;
        exit;
     END;
    g_psCurrent := Running;
    result :=  S_OK;
 END;

 //------------------------------------------------------------------------------
//  Gerät anhand des Namens aus dem Menü suchen
//------------------------------------------------------------------------------

Function TfrmCap.FindDevice(Category : TGUID; bstrName : WideString; VAR ppSrcFilter : IBaseFilter ) :  HRESULT ;
VAR
  hr           : HRESULT ;
  pSrc         : IBaseFilter ;
  pMoniker     : IMoniker;
  cFetched     : ULONG ;
  pClassEnum   : IEnumMoniker;
  pProp        : IPropertyBag;
  varName      : Olevariant;


BEGIN


    hr := g_pDevEnum.CreateClassEnumerator (category, pClassEnum, 0);
    if FAILED(hr) then 
    BEGIN
        Msg('Kann  Class Enumerator nicht erzeugen!  hr:=$%x', hr);
        result :=  hr;
        exit;
     END;


    if (pClassEnum = nil)  then
    BEGIN
        MessageBox(Handle,'Es wurde kein entsprechendes Gerät gefunden' +
                   'Dieses beispiel benötigt ein derariges gerät, wie z.B eine USB WebCam,' +
                   'die sauber arbeitet.  Das Beispiel wird nun beendet.',
                   'Keine Video Capture Hardware', MB_OK  OR  MB_ICONINFORMATION);
        result :=  E_FAIL;
        exit;
     END;




  hr := E_FAIL;
  while (pClassEnum.Next(1, pMoniker, @cFetched) = S_OK)  DO
    BEGIN

       hr := pMoniker.BindToStorage(nil, nil, IPropertyBag, pProp);
       IF succeeded(hr) then begin

       hr := pProp.Read('FriendlyName', varName, nil);
       IF Succeeded(hr) then begin

       if (SUCCEEDED(hr)) and (bstrName = varName)  then
        begin
            hr := pMoniker.BindToObject(nil, nil, IBaseFilter, pSrc);
            break;
        end;
       end;

      end;

    end;

    ppSrcFilter := pSrc;

    result :=  hr;
 END;

//------------------------------------------------------------------------------
// Interface beenden
//------------------------------------------------------------------------------

Procedure TfrmCap.CloseInterfaces;
BEGIN

    if assigned (pMediaControl)   then  begin
        pMediaControl.StopWhenReady;
        pMediaControl := nil;
    end;

    g_psCurrent := Stopped;


    if  assigned (pMediaEventEx)  then  begin
        pMediaEventEx.SetNotifyWindow(0, WM_GRAPHNOTIFY, 0);
        pMediaEventEx := nil;
    end;

    if assigned(pVideoWindow)  then
    BEGIN
        pVideoWindow.put_Visible(FALSE);
        pVideoWindow.put_Owner(0);        // muß aufgelöst werden
     END;

    g_pGraphBuilder    := nil;
     g_pCapture         := nil;

     g_pBaseFilter       := nil;
     g_pDeviceFilter     := nil;
     g_pDevEnum          := NIL;

     G_VideoComprFilter  := nil;
     G_AudioFilter       := nil;
     G_AudioComprFilter  := nil;
     G_MediaSeek         := nil;

END;

//------------------------------------------------------------------------------
// Videofenster setzten
//------------------------------------------------------------------------------


Function TfrmCap.SetupVideoWindow : HRESULT;
VAR
   hr :  HRESULT ;
BEGIN
    hr := pVideoWindow.put_Owner(OAHWND(pnlView.handle));
    if FAILED(hr) then begin
        result :=  hr;
        exit;
    end;

    hr := pVideoWindow.put_WindowStyle(WS_CHILD  OR  WS_CLIPCHILDREN);
    if FAILED(hr) then begin
        result :=  hr;
        exit;
    end;


    ResizeVideoWindow;

    hr := pVideoWindow.put_Visible(TRUE);
    if FAILED(hr) then begin
        result :=  hr;
        EXIT;
    end;

    result :=  hr;
 END;

 //------------------------------------------------------------------------------
// Fenstergröße an ändern, Achtung, bei Videokarte ohne Overlay wird das nichts
//------------------------------------------------------------------------------

Procedure Tfrmcap.ResizeVideoWindow;
VAR rc : TREct;
BEGIN
    rc :=  PnlView.ClientRect;
    if  assigned (pVideoWindow)  then
        pVideoWindow.SetWindowPosition(0, 0, rc.right, rc.bottom);
 END;


//------------------------------------------------------------------------------
// Hilfeprozedur , Fehlerausgabe
//------------------------------------------------------------------------------



Procedure TfrmCap.Msg(szFormat : String; hr : HRESULT);
VAR s : String;
BEGIN
    s := Format ('%s %x',[ szFormat, hr]);
    MessageBox(0, PCHAR(s) ,'PlayCap Message', MB_OK  OR  MB_ICONERROR);
 END;

//------------------------------------------------------------------------------
// Eventhandler
//------------------------------------------------------------------------------

Function  TfrmCap.HandleGraphEvent: HRESULT;
VAR  evCode, evParam1, evParam2  : LONGINT;
     hr                          :HRESULT ;
BEGIN
    hr := s_ok;
    IF NOT assigned(pMediaEventEx) then BEGIN
       Result := hr;
       EXIT;
    end;


    while SUCCEEDED(pMediaEventEx.GetEvent(evCode, evParam1, evParam2, 0))   do
    BEGIN

        Statusbar1.SimpleText := Format( 'Status %s, %s',[DisplayECEvent(evCode), DisplayECEvent( evParam2)] );


        IF evCode = EC_STREAM_CONTROL_STARTED THEN
           Caption := 'Capture gestartet'

        else IF evCode =  EC_STREAM_CONTROL_STOPPED
        then begin
           Caption := 'Capture beendet' ;

           
        end;
         hr := pMediaEventEx.FreeEventParams(evCode, evParam1, evParam2);
     END;

    result :=  hr;
 END;

//------------------------------------------------------------------------------
// alles schließen
//------------------------------------------------------------------------------


procedure TfrmCap.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    CloseInterfaces;

end;

procedure TfrmCap.FormResize(Sender: TObject);
begin
   ResizeVideoWindow;
end;

Procedure   TFrmCap.WMGrafNotify(VAR msg :TMessage);
BEGIN
  HandleGraphEvent;

end;

//------------------------------------------------------------------------------
// nachsehen, ob Property Page unterstützt wird.
//------------------------------------------------------------------------------


Function TfrmCap.SupportsPropertyPage(pFilter :IBaseFilter ) : BOOL;
VAR
   hr       : HRESULT ;
   pSpecify : ISpecifyPropertyPages ;
begin

    IF not assigned(pFilter) then begin Result := false;  exit;   end;
    hr := pFilter.QueryInterface(ISpecifyPropertyPages, pSpecify);
    Result := Succeeded(hr);
end;  //SupportsPropertyPage

//------------------------------------------------------------------------------
// Filter aus dem Namen ermitteln
// die Namen existieren schon im Menü durch gleiche Durchläufe
// diesmal wird der Name verglichen und bei Übereinstimmung das Objekt mit BindToObject
// gebunden
//------------------------------------------------------------------------------


Function  TfrmCap.FindFilterFromName(szNameToFind : String )  : IBaseFilter;
VAR

   hr          :HRESULT;
   pEnum       :IEnumFilters ;
   pFilter     :IBaseFilter ;
   cFetched    :ULONG ;
   bFound      :BOOL ;
   FilterInfo  :TFILTERINFO ;
   szName      : String;
BEGIN

    hr := g_pGraphBuilder.EnumFilters(pEnum);
    if FAILED(hr) then
    Begin
        result := nil;
        exit;
    end;
    bFound  := FALSE;


    while(pEnum.Next(1, pFilter, @cFetched) = S_OK) and ( not bFound) do
    begin
        hr := pFilter.QueryFilterInfo(FilterInfo);
        if FAILED(hr) then
        begin
            pFilter := nil;
            pEnum   := nil;
            result  := nil;
            exit;
        end;


        szName   := WideCharToString(FilterInfo.achName);

        if  szName = szNameToFind then
            bFound := TRUE;


        FilterInfo.pGraph := nil;


       if NOT bFound then
            pFilter := nil
        else
            break;

    end;

    pEnum:= nil;
    IF bFound then Result := pFilter else Result := nil;

end;  //FindFilterFromName

//------------------------------------------------------------------------------
// schon aufgelistete Filternamen mit gesuchtem vergleichen
// und dazugehörende CLSID abholen
//------------------------------------------------------------------------------


Function TfrmCap.FindNeededFilter (  //devname     : WideString;
                                  comprName    : WideString;
                                  audioFilter  : WideString;
                                  audioCompr   : WideString):HRESULT;
VAR hr           : HRESULT;
    ppsink       : IFileSinkFilter;
BEGIN

     hr := FindDevice ( CLSID_VideoCompressorCategory, ComprName,  g_VideoComprFilter);
     btnVideoComprProps.Enabled :=  SupportsPropertyPage(g_VideoComprFilter);

     if FAILED(hr) then
      BEGIN
        Msg('Fehler beim Suchen nach dem Compressionsfilter - Interface!  hr:= $%x', hr);
        g_VideoComprFilter:= nil;
        result :=  hr;
        exit;
     END;



      hr := FindDevice(CLSID_AudioInputDeviceCategory, audioFilter,  g_AudioFilter );
      btnAudioDevProps.Enabled :=  SupportsPropertyPage(g_AudioFilter);


      if FAILED(hr) then
      BEGIN
        Msg('Kann Audio capture Filter dem Graph nicht erzeugen!  hr:= $%x', hr);
        g_AudioFilter:= nil;
        result :=  hr;
        exit;
     END;

     hr := FindDevice(CLSID_AudioCompressorCategory, audioCompr,  g_AudioComprFilter );
     btnAudioComprProps.Enabled :=  SupportsPropertyPage(g_AudioComprFilter);

      if FAILED(hr) then
      BEGIN
        Msg('Kann Audio Capture Filter dem Graph nicht erzeugen!  hr:= $%x', hr);
        g_AudioComprFilter:= nil;
        result :=  hr;
        exit;
     END;


     ppsink := nil;
     Result := hr;
End;

//------------------------------------------------------------------------------
//  die 3 Menus VCompr, Audio und ACompr durchlaufen
//------------------------------------------------------------------------------


Procedure TFrmCap.FilterLoop;
VAR i,j: Integer;
  mi : TmenuItem;
begin

  For i := 2 TO Mainmenu1.Items.Count-1 DO        // den 0ren nicht, da "Datei"
     BEGIN
     mi := Mainmenu1.Items[i];                    // Menutitel

     For j := 0 TO mi.Count-1 DO                  // Einträge dazu
      IF mi.Items[j].Checked then begin
        sFeld[TMenutitel(i-1)] := mi.Items[j].Caption; ;     // gecheckten Tiltel eintragen
        break;
      end;

     END;                                            // mit allen 4 Filternamen ans Preview geben
    FindNeededFilter( sfeld[VideoCompression], sfeld[Audiogeraet], sfeld[Audiocompression]);
end;



//------------------------------------------------------------------------------
// Aufnahme starten
// DEBUGGEN HIERIN BLOCKERT DEN PC !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// Ausstieg in XP nur über Taskmanager und Abmelden!!!
//------------------------------------------------------------------------------

procedure TfrmCap.btnCaptureClick(Sender: TObject);
VAR hr            : HRESULT;
    ppsink        : IFileSinkFilter;
    start, dauer  : TReference_Time;
    pStreamConfig : IAMStreamConfig;
    pVih          : PVIDEOINFOHEADER ;
    pmt           : PAM_MEDIA_TYPE;
    i,j           : INTEGER;
    mi            : TmenuItem;
begin

    ppsink := nil;
    Filterloop;      // die Filter für VCompr, Audio, ACompr holen
    
    hr := pMediaControl.Stop;



    hr := g_pCapture.SetOutputFileName(MEDIASUBTYPE_AVI, PWideChar(OutputFilename), g_pBaseFilter, ppsink);
        IF Failed(hr) then     ShowMessage(Format('Fehler in "SetOutputFileName" %x',[hr]));

    hr :=  g_pBaseFilter.QueryInterface(IMediaSeeking, G_MediaSeek);
      IF Failed(hr) then     ShowMessage(Format('Fehler in "Query MediaSeek" %x',[hr]));

    hr := g_pGraphBuilder.AddFilter(G_AudioFilter,'Audio capture');
    IF Failed(hr) then      ShowMessage(Format('Fehler in "AddFilter Audio " %x',[hr]));




  IF chkVideoCompress.checked then begin
    hr := g_pGraphBuilder.AddFilter(G_VideoComprFilter, 'Video Compression');

   IF Failed(hr) then      ShowMessage(Format('Fehler in "AddFilter Video Compression" %x',[hr]));

   hr := g_pCapture.RenderStream ( @PIN_CATEGORY_CAPTURE,
                                    @MEDIATYPE_Video,
                                    g_pDeviceFilter,
                                    g_VideoComprFilter,
                                    g_pBaseFilter )
   end
   else
    hr := g_pCapture.RenderStream ( @PIN_CATEGORY_CAPTURE,
                                    @MEDIATYPE_Video,
                                    g_pDeviceFilter,
                                    NIL,
                                    g_pBaseFilter
                                    );


   IF Failed(hr) then         ShowMessage(Format('Fehler in "PIN_CATEGORY_Capture Video" %x',[hr]));


     IF chkAudioCompress.checked then  begin
      hr := G_pGraphBuilder.AddFilter(G_AudioComprFilter, 'Audio Compression');
     IF Failed(hr) then      ShowMessage(Format('Fehler in "AddFilter Audio Compression " %x',[hr]));


     hr := g_pCapture.RenderStream(  @PIN_CATEGORY_CAPTURE,  // Pin category
                                     @MEDIATYPE_Audio,       // Media type
                                     g_AudioFilter,          // Capture filter
                                     G_AudioComprFilter,     // mit Kompressionsfilter
                                     g_pBaseFilter
                                   )
   end
   else
      hr := g_pCapture.RenderStream(  @PIN_CATEGORY_CAPTURE,  // Pin category
                                      @MEDIATYPE_Audio,       // Media type
                                      g_AudioFilter,          // Capture filter
                                      NIL,                    // keine Kompression
                                      g_pBaseFilter
                                   );

   IF Failed(hr) then     ShowMessage(Format('Fehler in "PIN_CATEGORY_Capture Audio " %x',[hr]));
 
    start := StrToInt(edStart.Text);
    dauer := StrToInt(eddauer.Text);

    rtStart := start * ONE_SECOND;
    rtStop :=  (start + dauer) * ONE_SECOND;
    hr := g_pCapture.ControlStream( @PIN_CATEGORY_CAPTURE,
                                    @MediaType_Video,
                                    nil,

                                    @rtStart,
                                    @rtStop,
                                    0,0);
    Progressbar1.Min := start * 10;
    ProgressBar1.max := dauer * 10;
    Timer1.Enabled := TRUE;
    g_psCurrent  := running;
    hr := pMediaControl.Run;

end;

//------------------------------------------------------------------------------
// gecheckte Menueinträge suchen und im Feld sfeld festhalten
//------------------------------------------------------------------------------


procedure TfrmCap.btnPreviewClick(Sender: TObject);

VAR i,j : Integer;
    mi  : TmenuItem;

begin
    i := 1;
    mi := Mainmenu1.Items[i];                    // Menutitel

    For j := 0 TO mi.Count-1 DO                  // Einträge dazu
      IF mi.Items[j].Checked then begin
        sFeld[TMenutitel(i-1)] := mi.Items[j].Caption; ;     // gecheckten Tiltel einrragen
        break;
      end;
                                         // mit allen 4 Filternamen ans Preview geben
  PreviewVideo(sfeld[Videogeraet]);//, sfeld[VideoCompression], sfeld[Audiogeraet], sfeld[Audiocompression]);

 btnCapture.Enabled := TRUE
end;



procedure TfrmCap.btnExitClick(Sender: TObject);
begin
Close
end;



//------------------------------------------------------------------------------
// Meldungen verbal ausgeben
//------------------------------------------------------------------------------


Function TFrmcap.DisplayECEvent(lEventCode : Integer) : String;
VAR   szMsg : String;

      Procedure HANDLE_EC(s : String);
      Begin                 szMsg := Format('%s',[s]);        end ;

Begin
    Case lEventCode of

    EC_ACTIVATE              :    HANDLE_EC('EC_ACTIVATE ');
    EC_BUFFERING_DATA        :    HANDLE_EC('EC_BUFFERING_DATA');
    EC_CLOCK_CHANGED         :    HANDLE_EC('EC_CLOCK_CHANGED');
    EC_COMPLETE              :    HANDLE_EC('EC_COMPLETE') ;
    EC_DEVICE_LOST           :    HANDLE_EC('EC_DEVICE_LOST');
    EC_DISPLAY_CHANGED       :    HANDLE_EC('EC_DISPLAY_CHANGED');
    EC_END_OF_SEGMENT        :    HANDLE_EC('EC_END_OF_SEGMENT');
    EC_ERROR_STILLPLAYING    :    HANDLE_EC('EC_ERROR_STILLPLAYING');
    EC_ERRORABORT            :    HANDLE_EC('EC_ERRORABORT');
    EC_EXTDEVICE_MODE_CHANGE :    HANDLE_EC('EC_EXTDEVICE_MODE_CHANGE');
    EC_FULLSCREEN_LOST       :    HANDLE_EC('EC_FULLSCREEN_LOST');
    EC_GRAPH_CHANGED         :    HANDLE_EC('EC_GRAPH_CHANGED');
    EC_LENGTH_CHANGED        :    HANDLE_EC('EC_LENGTH_CHANGED');
    EC_NEED_RESTART          :    HANDLE_EC('EC_NEED_RESTART');
    EC_NOTIFY_WINDOW         :    HANDLE_EC('EC_NOTIFY_WINDOW');
    EC_OLE_EVENT             :    HANDLE_EC('EC_OLE_EVENT');
    EC_OPENING_FILE          :    HANDLE_EC('EC_OPENING_FILE');
    EC_PALETTE_CHANGED       :    HANDLE_EC('EC_PALETTE_CHANGED');
    EC_PAUSED                :    HANDLE_EC('EC_PAUSED ');
    EC_QUALITY_CHANGE        :    HANDLE_EC('EC_QUALITY_CHANGE');
    EC_REPAINT               :    HANDLE_EC('EC_REPAINT') ;
    EC_SEGMENT_STARTED       :    HANDLE_EC('EC_SEGMENT_STARTED');
    EC_SHUTTING_DOWN         :    HANDLE_EC('EC_SHUTTING_DOWN');
    EC_SNDDEV_IN_ERROR       :    HANDLE_EC('EC_SNDDEV_IN_ERROR');
    EC_SNDDEV_OUT_ERROR      :    HANDLE_EC('EC_SNDDEV_OUT_ERROR');
    EC_STARVATION            :    HANDLE_EC('EC_STARVATION');
    EC_STEP_COMPLETE         :    HANDLE_EC('EC_STEP_COMPLETE');
    EC_STREAM_CONTROL_STARTED :    HANDLE_EC('EC_STREAM_CONTROL_STARTED');
    EC_STREAM_CONTROL_STOPPED :    HANDLE_EC('EC_STREAM_CONTROL_STOPPED');
    EC_STREAM_ERROR_STILLPLAYING :    HANDLE_EC('EC_STREAM_ERROR_STILLPLAYING');
    EC_STREAM_ERROR_STOPPED      :    HANDLE_EC('EC_STREAM_ERROR_STOPPED');
    EC_TIMECODE_AVAILABLE        :    HANDLE_EC('EC_TIMECODE_AVAILABLE');
    EC_USERABORT                 :    HANDLE_EC('EC_USERABORT');
    EC_VIDEO_SIZE_CHANGED        :    HANDLE_EC('EC_VIDEO_SIZE_CHANGED');
    EC_WINDOW_DESTROYED          :    HANDLE_EC('EC_WINDOW_DESTROYED');

    else
        szMsg := Format('Unbekannt ($%x)', [lEventCode]);
    end;
    Result := szMsg;

end;  //DisplayECEvent

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------


Function TFrmcap.ShowPins(pFilter : IBaseFilter):HRESULT;
VAR pEnum              : IEnumPins;
    pPin               : IPin;
    pCompress          : IAMVideoCompression;
    lCap, lKeyFrame, lPFrame : INTEGER;
    Quality                  : Double;
    lKeyFrameDef, lPFrameDef : Integer;
    QualityDef               : Double;
    hr                       : HRESULT;
    cbVersion, cbDesc        : Integer;
    szversion, szDesc        : Array[0..99] OF WideChar;

BEGIN
  REsult := S_OK;
  IF pFilter = NIL then Exit;
   hr :=  pFilter.EnumPins( pEnum);
   While pEnum.Next(1, pPin, NIL) = S_OK DO
   BEGIN
     hr := pPin.QueryInterface(IAMVideoCompression,pCompress);
     IF succeeded(hr) then break;
   END;
   
   IF succeeded(hr) then begin
 //  cbDesc := 100; cbversion := 100;
    hr := pCompress.getInfo(NIL, cbversion, NIL, cbDesc  , lKeyFrameDef, lPFrameDef, QualityDef,lcap);

    hr := pCompress.getInfo(szVersion, cbversion, szDesc, cbDesc  , lKeyFrameDef, lPFrameDef, QualityDef,lcap);
    Statusbar1.SimpletExt := szDesc;
     IF succeeded(hr) then begin
         hr :=   pCompress.put_KeyFrameRate(25);
       IF lCap and CompressionCaps_CanKeyFrame <> 0 then begin
          hr := pCompress.Get_KeyFrameRate(lKeyFrame);

          IF failed(hr) OR (lKeyFrame < 0) then lKeyFrame := lKeyFrameDef;
          
       end;

       
       IF lCap and CompressionCaps_CanBFrame <> 0 then begin
          hr := pCompress.Get_PFramesPerKeyFrame(lPFrame);
          IF failed(hr) OR (lPFrame < 0) then lPFrame := lPFrameDef;
       end;

       
       IF lCap and CompressionCaps_CanQuality <> 0 then begin
          hr := pCompress.Get_Quality(Quality);
          IF failed(hr) OR (Quality  < 0) then Quality := QualityDef;
       end;

     END;
   end;
END;

//------------------------------------------------------------------------------
// Properties ansehen
//------------------------------------------------------------------------------



procedure TfrmCap.btnVideoComprPropsClick(Sender: TObject);
Begin
   ShowFilterProperties(videoCompression, CLSID_VideoCompressorCategory);
end;

//------------------------------------------------------------------------------
// Menus anklicken
//------------------------------------------------------------------------------

procedure TfrmCap.mnuVDeviceClick(Sender: TObject);
VAR
    mm, i : Integer;
    hr    : HRESULT;
    pSrcFilter : IbaseFilter;
begin
 mm := (Sender as TmenuItem).tag ;           // welcher Eintrag wars denn
 IF mm = 0 then Exit;
 For i := 1 TO mnuVDevice.Count   DO
         mnuVDevice.Items[i-1].checked := i = mm;   // nur den gewählten checken

 s[Videogeraet] := (Sender as TmenuItem).Caption;   // Eintrag übernehmen

 hr := FindDevice(CLSID_VideoInputDeviceCategory, s[Videogeraet], pSrcFilter);  // Capture Device suchen, EnumCaps etc

 btnVideoDevProps.Enabled :=  SupportsPropertyPage(pSrcFilter);
end;

//------------------------------------------------------------------------------


procedure TfrmCap.mnuVCompressClick(Sender: TObject);
VAR i, mm : integer;
    hr : HRESULT;
    pSrcFilter : IbaseFilter;
begin
   mm := (Sender as TmenuItem).tag ;
   IF mm = 0 then Exit;
   For i := 1 TO mnuVCompress.Count   DO mnuVCompress.Items[i-1].checked := mm = i;

   s[VideoCompression] := (Sender as TmenuItem).Caption;
   hr := FindDevice(CLSID_VideoCompressorCategory, s[VideoCompression], pSrcFilter);  // Capture Device suchen, EnumCaps etc
   btnVideoComprProps.Enabled :=  SupportsPropertyPage(pSrcFilter);
   ShowPins(pSrcFilter);

end;

//------------------------------------------------------------------------------

procedure TfrmCap.mnuADeviceClick(Sender: TObject);
VAR i, mm: Integer;
     hr : HRESULT;
    pSrcFilter : IbaseFilter;
begin
  mm := (Sender as TmenuItem).tag ;
  IF mm = 0 then Exit;
  For i := 1 TO mnuADevice.Count   DO mnuADevice.Items[i-1].checked := mm = i;
  s[AudioGeraet] := (Sender as TmenuItem).Caption;
  hr := FindDevice(CLSID_AudioInputDeviceCategory, s[AudioGeraet], pSrcFilter);  // Capture Device suchen, EnumCaps etc
  btnAudioDevProps.Enabled :=  SupportsPropertyPage(pSrcFilter);
end;

//------------------------------------------------------------------------------

procedure TfrmCap.mnuACompressClick(Sender: TObject);
VAR i,mm : Integer;
     hr : HRESULT;
    pSrcFilter : IbaseFilter;
begin
  mm := (Sender as TmenuItem).tag ;
  IF mm = 0 then Exit;
  For i := 1 TO mnuACompress.Count   DO mnuACompress.Items[i-1].checked := mm = i;
   s[AudioCompression] := (Sender as TmenuItem).Caption;
  hr := FindDevice(CLSID_AudioCompressorCategory, s[AudioCompression], pSrcFilter);  // Capture Device suchen, EnumCaps etc
   btnAudioComprProps.Enabled :=  SupportsPropertyPage(pSrcFilter);
end;

//------------------------------------------------------------------------------

Procedure  TfrmCap.ShowFilterProperties(mnuTitel : TMenuTitel; CONST categorie : TGUID);
VAR
 hr        :HRESULT ;
 pFilter   :IBaseFilter ;
 szNameToFind :  String;
 pSpecify     : ISpecifyPropertyPages ;
 FilterInfo   : TFILTERINFO ;
 caGUID       : TCAGUID;
 i : Integer;
begin
    szNameToFind := s[mnuTitel];
    hr := FindDevice(categorie,szNameToFind, pFilter);
    IF pFilter = NIL then EXIT;


    hr := pFilter.QueryInterface(ISpecifyPropertyPages, pSpecify);
    if SUCCEEDED(hr)   then
    begin
            hr := pFilter.QueryFilterInfo(FilterInfo);
            if FAILED(hr) then exit;
            
            hr := pSpecify.GetPages(caGUID);
            if  FAILED(hr) then  exit;


            pSpecify := nil;


           hr :=     OleCreatePropertyFrame(
                handle,                 // Parent window
                0,                      // x (Reserved)
                0,                      // y (Reserved)
                FilterInfo.achName,     // Caption for the dialog box
                1,                      // Number of filters
                @pFilter,               // Pointer to the filter
                caGUID.cElems,          // Number of property pages
                caGUID.pElems,          // Pointer to property page CLSIDs
                0,                      // Locale identifier
                0,                      // Reserved
                Nil                     // Reserved
            );


          IF failed(hr) then
              ShowMessage(Format('Fehler in "File Properties" %x',[hr]));
    end;
end;
//------------------------------------------------------------------------------

procedure TfrmCap.btnAudioDevPropsClick(Sender: TObject);
Begin
 ShowFilterProperties(audiogeraet, CLSID_AudioInputDeviceCategory);
end;
//------------------------------------------------------------------------------


procedure TfrmCap.btnAudioComprPropsClick(Sender: TObject);
Begin
 ShowFilterProperties(audioCompression, CLSID_AudioCompressorCategory);
end;
//------------------------------------------------------------------------------

procedure TfrmCap.Timer1Timer(Sender: TObject);
VAR rtNow : TREFERENCE_TIME;
    hr : HRESULT;
begin
    IF assigned( G_MediaSeek) then begin
    hr := G_MediaSeek.GetCurrentPosition(rtNow);
    IF succeeded(hr) then
     // Statusbar1.SimpleText := Format('%d', [rtNow DIV 10000000]);
     Progressbar1.Position := rtNow DIV ZehntelSekunde;//10000000;
    end;
end;

//------------------------------------------------------------------------------

procedure TfrmCap.FormActivate(Sender: TObject);
begin
mainmenu1.AutoHotkeys := maManual;         // & für Hotkey nicht mit einfügen!!!!!
end;
//------------------------------------------------------------------------------

procedure TfrmCap.mnuDateiClick(Sender: TObject);
begin
  IF SaveDialog1.Execute then begin
   OutputFileName := SaveDialog1.FileName
  end
  else
    OutputFilename := Defaultdateiname;
end;
//------------------------------------------------------------------------------

procedure TfrmCap.btnVideoDevPropsClick(Sender: TObject);

begin

    ShowFilterProperties(videogeraet, CLSID_VideoInputDeviceCategory);
end;

procedure TfrmCap.btnStopCaptureClick(Sender: TObject);
VAR     hr : HRESULT;
       start, stop : TReference_Time;
begin
IF assigned(pMediaControl) then begin
   IF g_psCurrent  = running then begin
       Start := MAX_TIME;
       Stop := 0;

    hr := g_pCapture.ControlStream(@PIN_CATEGORY_CAPTURE,
                                    nil,// @MediaType_Video,
                                    nil,
                                    @Start,
                                    @Stop,
                                    0,EC_USERABORT);

  //   pMediaControl.run;

   end;
END;
end;

end.

//-----------------------------------------------------------------------------


