{ Compiletime TObject, TPersistent and TComponent definitions }
unit uPSC_std;
{$I PascalScript.inc}
interface
uses
  uPSCompiler, uPSUtils;

{
  Will register files from:
    System
    Classes (Only TComponent and TPersistent)
    add ClassName & ClassType by max
    TRect has 2 type defs  , TObject as 3 class functions 3.9.3
    Tpersistent with Free  add TComponentEnumerator ,
    tobject classname shortstring!
    add componentstyle

}

procedure SIRegister_Std_TypesAndConsts(Cl: TPSPascalCompiler);
procedure SIRegisterTObject(CL: TPSPascalCompiler);
procedure SIRegisterTPersistent(Cl: TPSPascalCompiler);
procedure SIRegisterTComponent(Cl: TPSPascalCompiler);
procedure SIRegister_TComponentEnumerator(CL: TPSPascalCompiler);
procedure SIRegister_Std(Cl: TPSPascalCompiler);


implementation

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComponentEnumerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TComponentEnumerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TComponentEnumerator') do begin
    RegisterMethod('Constructor Create( AComponent : TComponent)');
    RegisterMethod('Function GetCurrent : TComponent');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'TComponent', iptr);
  end;
end;


procedure SIRegisterTObject(CL: TPSPascalCompiler);
begin
  with Cl.AddClassN(NIL, 'TObject') do begin
    RegisterMethod('constructor Create');
    RegisterMethod('procedure Free');
    RegisterMethod('procedure CleanupInstance');
    RegisterMethod('function GetInterface(const IID: TGUID; out Obj): Boolean;');
    //RegisterMethod('class function ClassName: ShortString');
    //RegisterMethod('class function ClassNameIs(const Name: string): Boolean');
    //RegisterMethod('class function InstanceSize: Longint');
    RegisterMethod('function ClassName: ShortString;');
    RegisterMethod('function ClassNameIs(const Name: string): Boolean;');
    RegisterMethod('function InstanceSize: Longint;');
  end;
end;

procedure SIRegisterTPersistent(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TObject'), 'TPersistent') do begin
    RegisterMethod('procedure Assign(Source: TPersistent)');
    RegisterMethod('function  GetNamePath: string; dynamic;');
    RegisterMethod('procedure Free');
  end;
end;

procedure SIRegisterTComponent(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TPersistent'), 'TComponent') do begin
    RegisterMethod('function FindComponent(AName: String): TComponent;');
    RegisterMethod('constructor Create(AOwner: TComponent); virtual;');
    RegisterMethod('procedure Free');
    RegisterMethod('procedure FreeOnRelease');
    RegisterMethod('procedure ExecuteAction(Action: TBasicAction): Boolean;');
    //RegisterMethod('function FindComponent(const AName: string): TComponent;');
    //RegisterMethod('procedure FreeNotification(AComponent: TComponent);');
    RegisterMethod('procedure RemoveFreeNotification(AComponent: TComponent);');
    RegisterMethod('function GetParentComponent: TComponent;');
    RegisterMethod('function GetNamePath: string;');
    RegisterMethod('function HasParent: Boolean;');
    RegisterMethod('function GetEnumerator: TComponentEnumerator;');

    //  function ExecuteAction(Action: TBasicAction): Boolean; dynamic;
    //function FindComponent(const AName: string): TComponent;
    //procedure FreeNotification(AComponent: TComponent);
   //procedure RemoveFreeNotification(AComponent: TComponent);
    //procedure FreeOnRelease;
    //function GetEnumerator: TComponentEnumerator;
    //function GetParentComponent: TComponent; dynamic;
    //function GetNamePath: string; override;
    //function HasParent: Boolean; dynamic;

    RegisterProperty('Owner', 'TComponent', iptRW);
    RegisterMethod('procedure DestroyComponents');
    RegisterMethod('procedure Destroying');
    RegisterMethod('procedure FreeNotification(AComponent:TComponent)');
    RegisterMethod('procedure InsertComponent(AComponent:TComponent)');
    RegisterMethod('procedure RemoveComponent(AComponent:TComponent)');
    RegisterProperty('Components', 'TComponent Integer', iptr);
    RegisterProperty('ComponentCount', 'Integer', iptr);
    RegisterProperty('ComponentIndex', 'Integer', iptrw);
    //RegisterProperty('ComponentState', 'Byte', iptr);
    RegisterProperty('ComponentState', 'TComponentState', iptr);

    RegisterProperty('ComponentStyle', 'TComponentStyle', iptr);

    //  property ComponentStyle: TComponentStyle read FComponentStyle;

    RegisterProperty('Designinfo', 'LongInt', iptrw);
    RegisterProperty('ComObject', 'IUnknown', iptr);
    // property ComObject: IUnknown read GetComObject;
    RegisterPublishedProperties;
    RegisterProperty('Name', 'String', iptrw);
    RegisterProperty('Tag', 'LongInt', iptrw);
    RegisterProperty('ClassName', 'String', iptr);   //3.1
    RegisterProperty('ClassType', 'TClass', iptr);   //3.1
  end;
end;




procedure SIRegister_Std_TypesAndConsts(Cl: TPSPascalCompiler);
begin
  Cl.AddTypeS('TComponentStateE', '(csLoading, csReading, csWriting, csDestroying, csDesigning, csAncestor, csUpdating, csFixups, csFreeNotification, csInline, csDesignInstance)');
  cl.AddTypeS('TComponentState', 'set of TComponentStateE');
   CL.AddTypeS('TComponentStyle', '( csInheritable, csCheckPropAvail, csSubComponent, csTransient )');

  Cl.AddTypeS('TRect', 'record Left, Top, Right, Bottom: Integer; end;');
  Cl.AddTypeS('TPoint', 'record X, Y: LongInt; end;'); //from upsc_controls !!

  {TPoint = packed record
    X: Longint;
    Y: Longint;
  end;}

//  Cl.AddTypeS('TRect2', 'record TopLeft, BottomRight: TPoint; end;');  in sysutils
end;

procedure SIRegister_Std(Cl: TPSPascalCompiler);
begin
  SIRegister_Std_TypesAndConsts(Cl);
  SIRegisterTObject(CL);
  SIRegisterTPersistent(Cl);
  SIRegisterTComponent(Cl);
  SIRegister_TComponentEnumerator(CL);
end;

// PS_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)


End.


