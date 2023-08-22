unit Prediction;

{ CyberUnits }

{ Object Pascal units for computational cybernetics }

{ Demo of a simple simulator for a linear 1st order feedback system }
{ Predictor }

{ Version 1.1.1 (Dendron) }

{ (c) Johannes W. Dietrich, 1994 - 2020 }
{ (c) Ludwig Maximilian University of Munich 1995 - 2002 }
{ (c) University of Ulm Hospitals 2002 - 2004 }
{ (c) Ruhr University of Bochum 2005 - 2020 }

{ Standard blocks for systems modelling and simulation }

{ Source code released under the BSD License }

{ See the file "license.txt", included in this distribution, }
{ for details about the copyright. }
{ Current versions and additional information are available from }
{ http://cyberunits.sf.net }

{ This program is distributed in the hope that it will be useful, }
{ but WITHOUT ANY WARRANTY; without even the implied warranty of }
{ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. }

//{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ValEdit; //, SimulationEngine;

type

  { TPredictionForm }

  TPredictionForm = class(TForm)
    PredictionList: TValueListEditor;
  private
    { private declarations }
  public
    { public declarations }
    procedure DisplayPrediction(theParameters: TPrediction);
  end;

var
  PredictionForm: TPredictionForm;

implementation

{$R *.lfm}

procedure TPredictionForm.DisplayPrediction(theParameters: TPrediction);
begin
  PredictionList.Cells[1, 1] := FloatToStrF(theParameters.x, ffFixed, 0, 4);
  PredictionList.Cells[1, 2] := FloatToStrF(theParameters.z, ffFixed, 0, 4);
  PredictionList.Cells[1, 3] := FloatToStrF(theParameters.y, ffFixed, 0, 4);
  PredictionList.Cells[1, 4] := FloatToStrF(theParameters.e, ffFixed, 0, 4);
  PredictionList.Cells[1, 5] := FloatToStrF(theParameters.ys, ffFixed, 0, 4);
  PredictionList.Cells[1, 6] := FloatToStrF(theParameters.yr, ffFixed, 0, 4);
end;

end.

