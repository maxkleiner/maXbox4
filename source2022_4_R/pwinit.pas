{*******************************************************************************

                                POWTILS 

********************************************************************************

*******************************************************************************}


unit pwinit; 

interface
// uses
//   pwSdsSess, pwDefaultCfg;

{ Put units like pwSdsSess and pwDefaultCfg in uses clause of this unit if you
  want that functionality in your web program. By default this unit uses no
  plugin units, meaning no config file or sessions are on. }

implementation
uses 
  pwmain;

initialization
  Init;
end.

{ Make different copies of this unit for different configurations. Put this file
  in local directory of your program if you modify it, or rename different
  copies to specific setups such as pwInitMySql if you have a custom setup }



{ ANOTHER EXAMPLE OF A CONFIGURATION IS BELOW:


unit pwInitAll;

interface
uses // sessions and config are on
   pwSdsSess, pwDefaultCfg;

implementation
uses 
  pwmain;

initialization
  Init;
end.
}

{ ANOTHER EXAMPLE OF A CONFIGURATION IS BELOW:


unit pwInitAll;

interface
uses // just sessions, no config
   pwSdsSess; 

implementation
uses 
  pwmain;

initialization
  Init;
end.
}

{ ANOTHER EXAMPLE OF A CONFIGURATION IS BELOW:


unit pwInitAll;

interface
uses // just config, no sessions
   pwDefaultCfg; 

implementation
uses 
  pwmain;

initialization
  Init;
end.
}
