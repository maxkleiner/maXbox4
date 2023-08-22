unit RegisterTreeViewEx;

{ Registration of TTreeViewEx
  Version 0.8  Jun-14-1997  (C) 1997 Christoph R. Kirchner
}
{ Users of this unit must accept this disclaimer of warranty:
    "This unit is supplied as is. The author disclaims all warranties, expressed
    or implied, including, without limitation, the warranties of merchantability
    and of fitness for any purpose.
    The author assumes no liability for damages, direct or consequential, which
    may result from the use of this unit."

  This unit is donated to the public as public domain.

  This unit can be freely used and distributed in commercial and private
  environments provided this notice is not modified in any way.

  If you do find this unit handy and you feel guilty for using such a great
  product without paying someone - sorry :-)

  Please forward any comments or suggestions to Christoph Kirchner at:
  ckirchner@geocities.com
}

interface

uses
  SysUtils, DsgnIntf, Windows, Messages, Classes, Controls,
  CommCtrl, Forms, TreeVwEx;


procedure Register;

implementation


const
  RegisterOnPage = 'Samples';


{ Register -------------------------------------------------------------------}

procedure Register;
begin
  RegisterComponents(RegisterOnPage, [TTreeViewEx]);
end;

end.
