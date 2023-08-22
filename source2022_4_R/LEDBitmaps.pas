unit LEDBitmaps;

interface

uses
  Windows;

type
  TLEDColor = (ledcGreen, ledcRed, ledcGray);

function GetLEDBitmapHandle(Color: TLEDColor; State: Boolean): THandle;

implementation

//{$R LEDBitmaps.res}

function GetLEDBitmapHandle(Color: TLEDColor; State: Boolean): THandle;
var
  BitmapName: string;
begin
  { Namen der Bitmap ermitteln }
  case Color of
    ledcGreen: if State then
                 BitmapName := 'LED_GREEN_ON'
               else
                 BitmapName := 'LED_GREEN_OFF';
    ledcRed: if State then
               BitmapName := 'LED_RED_ON'
             else
               BitmapName := 'LED_RED_OFF';
    ledcGray: BitmapName := 'LED_GRAY';
  end;

  { Bitmap laden }
  Result := LoadBitmap(hInstance, PChar(BitmapName));
end;

end.
