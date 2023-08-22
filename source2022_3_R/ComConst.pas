{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{*******************************************************}

unit ComConst;

interface

resourcestring
    SCreateRegKeyError = 'Fehler beim Erstellen eines Eintrages in der Systemregistrierung';
    SOleError = 'OLE-Fehler %.8x';
    SObjectFactoryMissing = 'Der Objektgenerator für die Klasse %s fehlt';
    STypeInfoMissing = 'Für die Klasse %s fehlt die Typinformation';
    SBadTypeInfo = 'Falsche Typinformation für Klasse %s';
    SDispIntfMissing = 'Dispatch-Interface der Klasse %s fehlt';
    SNoMethod = 'Die Methode '#39'%s'#39' wird vom Automatisierungsobjekt nicht unterstützt';
    SVarNotObject = 'Variante referenziert kein Automatisierungsobjekt';
    STooManyParams = 'Dispatch-Methoden unterstützen maximal 64 Parameter.';
    SDCOMNotInstalled = 'DCOM ist nicht installiert';
    SDAXError = 'DAX-Fehler';

    SAutomationWarning = 'Warnung des COM-Servers';
    SNoCloseActiveServer1 = 'Diese Anwendung enthält noch aktive COM-Objekte.Mindestens ein Client verweist noch auf diese Objekte,so dass manuelles Schließen ';
    SNoCloseActiveServer2 = 'dieser Anwendung dazu führen könnte, dass die Client-Anwendungen nicht korrekt funktionieren.'#13''#10''#13''#10'Sind Sie sicher, dass Sie diese Anwendung schließen möchten?';

implementation

end.
