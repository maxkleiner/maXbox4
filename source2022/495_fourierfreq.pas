{ ******************************************************************
  Fast Fourier Transform (modified from Pascal program by Don Cross)
  ******************************************************************
  This program compares the FFT with the direct computation of the
  frequencies, on a set of random data.

  Results are stored in the output file freq.txt
  ****************************************************************** }
  //#TODO: save data string as file and vice versa

program ffreq;

//uses
  //dmath;

const
  NumSamples = 512;             { Buffer size (power of 2) }
  MaxIndex   = NumSamples - 1;  { Max. array index }

var
  InArray, OutArray : TCompVector;
  OutFile           : Text;
  I                 : Integer;
  Z                 : Complex;

begin
  DimCompVector(InArray, MaxIndex);
  DimCompVector(OutArray, MaxIndex);

  { Fill input buffers with random data }
  for I := 0 to MaxIndex do begin
      InArray[I].X := Random(10000);
      InArray[I].Y := Random(10000);
    end;

  //AssignFile(OutFile, 'freq.txt');
  //Rewrite(OutFile);

  //WriteLn(OutFile);
  WriteLn('*** Testing procedure CalcFrequency ***');
  //WriteLn(OutFile);

  FFT(NumSamples, InArray, OutArray);

  for I := 0 to MaxIndex do begin
      CalcFrequency(NumSamples, I, InArray, Z);
      //WriteLn(OutFile, I:4,
        //      OutArray[I].X:15:6, Z.X:15:6,
          //    OutArray[I].Y:20:6, Z.Y:15:6);
      PrintF('freq X: %-18.6f ZX: %-12f ',[OutArray[I].X, Z.X])    
      PrintF('freq Y: %-18.6f ZY: %-12f ',[OutArray[I].Y, Z.Y])    
      end;

  //CloseFile(OutFile);
end.

