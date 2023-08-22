{ Invokable interface IVCLScanner }

{ ****************************************************************
  sourcefile:  	vclscannerintf.pas
  typ:  		    abstract-Unit
  author:   		borland, max kleiner, LoC 253
  description: 	declares wsdl
  classes:    	see ModelMaker ps#12
  specials: 	  wsdl* /admin enabled /new guid by hand
  revisions:    	20.07.04 build menu structure
			            19.08.06 enlarge register functions
                  20.08.06 enlarge the interface documentation
                  26.08.06 include wsdlpub.pas in own project
 **************************************************************** }

unit VCLScannerIntf;

interface

uses InvokeRegistry, Types, XSBuiltIns;

resourcestring
   SintfDocScan = 'Scans Clients for TechStates';
   SintfDocOrch = 'Sets the Sequence for Services';

type
  { Invokable interfaces must derive from IInvokable }
  IVCLScanner = interface(IInvokable)
  ['{8FFBAA56-B4C2-4A32-924D-B3D3DE2C4EFF}']

    function PostData(const UserData: WideString; const CheckSum: integer):
                                                              Boolean; stdcall;
    procedure PostUser(const Email, FirstName, LastName: WideString); stdcall;
    function GetTicketNr: longint; stdcall;
  end;

  //this intf is still in progress
  IVCLOrchestrator = interface(IInvokable)
  ['{8FFBAA56-B4C2-4A32-924D-B3D3DE2C4EFA}']
    function SetSequence(S, Localizar, Substituir: shortstring):
                                                   shortstring; stdcall;
    procedure lineToNumber(xmemo: String; met: boolean); stdcall;
  end;


implementation

initialization
  { Invokable interfaces must be registered }
  InvRegistry.RegisterInterface(TypeInfo(IVCLScanner),'','',SintfDocScan);
  InvRegistry.RegisterInterface(TypeInfo(IVCLOrchestrator),'','',SintfDocOrch);
 //InvRegistry.RegisterInterface(TypeInfo(IWSDLPublish), SBorlandTypeNamespace,
 //                          '', IWSDLPublishDoc);

end.
