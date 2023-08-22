{ ****************************************************************
  Sourcefile :  	infobox1.pas
  Typ :  		Boundary-Unit
  Autor :  		max kleiner, LoCs=115
  Beschreibung :  	enables about box with hyperlinks
  Klassen :	  	1, siehe ModelMaker
  Besonderes : 	        service DLL in one function
  Revisionen :  	07.11.03 site and email
                  22.06.04 rechange GIFImage to jpeg
                  11.11.07 no buttons & sysutils
                  19.10.08 second hyperlink
                  13.03.11 more parameter
                  21.04.12 add a 3D ball for future mXb
 **************************************************************** }

unit infobox1;

interface

uses Classes, Forms, StdCtrls,
  hyperLabel, Controls, jpeg, Graphics, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    lblSoft: TLabel;
    lblVersion: TLabel;
    Image1: TImage;
    Label1: TLabel;
    lblhash: TLabel;
    Image2: TImage;
    Image3: TImage;
    //procedure Label1Click(Sender: TObject); test
  private
    procedure hyperLinkCreate;
    //procedure startBrowserInfo;
    { Private declarations }
  public
    { Public declarations }
  end;

 procedure ShowInfoBox(boxCaption: shortstring; apptopic: shortstring;
                        versionCaption: shortstring; logo: boolean); export;

var
  AboutBox: TAboutBox;

implementation

  {$R *.DFM}

//uses shellAPI;
  uses IFSI_WinForm1puzzle;

resourcestring
   rsKLink='http://max.kleiner.com';
   //rsKEmail='mailto:max@kleiner.com?subject=maXbox';
   rsKEmail='http://sourceforge.net/projects/maxbox';
   rsMBLink='http://www.softwareschule.ch/maxbox.htm';


procedure ShowInfoBox(boxCaption: shortstring; apptopic: shortstring;
                          versionCaption: shortstring; logo: boolean);
begin
  AboutBox:= TAboutBox.Create(Application);
  try
    with aboutBox do begin
     hyperLinkCreate;
     if (length(caption) > 5) then begin // not yet
       Caption:= boxCaption;
       lblVersion.caption:= versionCaption;
       lblSoft.Caption:= apptopic;
       if not logo then begin
         image1.Visible:= false;
         panel1.top:= 10;
         lblVersion.Top:= 213;
         lblVersion.Left:= 380;
         lblVersion.Color:= clRed; //White;     //former clred
         //lblVersion.Color:= clBlue;
         panel1.Color:= clBlue;
        lblhash.Caption:= 'SHA1: '+SHA1(Application.ExeName);
       end else
         image1.Visible:= true;
     end;
     lblhash.Caption:= 'SHA1: '+SHA1(Application.ExeName);
     lblhash.Font.Color:= clwhite; //clRed;
     FormStyle:= fsstayontop;
     panel1.Color:= clNavy;
     ShowModal;

    end;
  finally
    AboutBox.Free
  end;
end;

procedure TAboutBox.hyperLinkCreate;
 var myhyperLabel, myhyperLabel2, myHyperlabel3: THyperlabel;
 begin
    myhyperlabel:= THyperlabel.create(self);
    myhyperLabel2:= THyperlabel.create(self);
    myhyperLabel3:= THyperlabel.create(self);
    with myhyperlabel do begin
      //font.Size:= 12;
      parent:= Panel1;
      left:= 12;
      top:= 65;
      caption:= rsKLink;
      //font.color:= clRed;
      hyperlinkcolor:= clRed;
      font.color:= clskyblue;
     //onClick:= startBrowserInfo;
    end;
    with myhyperlabel2 do begin
      parent:= Panel1;
      left:= 12;
      top:= 80;
      color:= clRed;
      hyperlinkcolor:= clRed;
      font.color:= clskyblue;
      caption:= rsKEmail;
    end;
    with myhyperlabel3 do begin
      parent:= Panel1;
      font.Size:= 18;
      left:= 12;
      top:= 08;
      color:= clRed;
      hyperlinkcolor:= clRed;
      font.color:= clskyblue;
      caption:= rsMBLink;
    end;
 end;

procedure startBrowserInfo;
begin
  //showmessage('startet nun den browser...');
end;
  // test direkt ohne unit hyperlabel
{procedure TAboutBox.Label1Click(Sender: TObject);
  var URLBuf: array[0..255] of char;
  begin
    strPCopy(URLBuf, label1.Caption);
    ShellExecute(Application.handle, NIL, URLBuf,
                 NIL, NIL, sw_ShowNormal);
    messagebeep(0)
end;}

end.
