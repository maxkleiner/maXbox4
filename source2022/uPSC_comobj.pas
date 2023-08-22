{ compiletime ComObj support }
unit uPSC_comobj;

{$I PascalScript.inc}
interface
uses
  uPSCompiler, uPSUtils;

{
 
Will register:
 
function CreateOleObject(const ClassName: String): IDispatch;
function GetActiveOleObject(const ClassName: String): IDispatch;
   add the ole 

}

procedure SIRegister_ComObj(cl: TPSPascalCompiler);

implementation

procedure SIRegister_ComObj(cl: TPSPascalCompiler);
begin
  cl.AddDelphiFunction('function CreateOleObject(const ClassName: String): IDispatch;');
  cl.AddDelphiFunction('function GetActiveOleObject(const ClassName: String): IDispatch;');
  cl.AddDelphiFunction('function ProgIDToClassID(const ProgID: string): TGUID;');
  cl.AddDelphiFunction('function ClassIDToProgID(const ClassID: TGUID): string;');
  cl.AddDelphiFunction('function CreateClassID: string;');
  cl.AddDelphiFunction('function CreateGUIDString: string;');
  cl.AddDelphiFunction('function CreateGUIDID: string;');
  cl.AddDelphiFunction('procedure OleError(ErrorCode: longint)');
  cl.AddDelphiFunction('procedure OleCheck(Result: HResult);');
  cl.AddDelphiFunction('function CoCreateInstance(cid: TGUID; aobj: TObject; ctx: DWord; id: TGUID; un: TObject): HResult);');
  cl.AddDelphiFunction('function CoCreateInstance2(cid: TGUID; unkOuter: IUnknown; ctx: longint; iid: TGUID; un: TObject): HResult);');
  cl.AddDelphiFunction('function CoCreateGuid(var guid: TGUID): HResult;');

  //function CoCreateInstance(const clsid: TCLSID; unkOuter: IUnknown;dwClsContext: Longint; const iid: TIID; var pv): HResult; stdcall;

  end;
end.

 //OleCheck(CoCreateInstance(ClassID, nil, CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER, IID_IUnknown, Unknown));

