
unit uPSR_std;
{$I PascalScript.inc}
interface
uses
  uPSRuntime, uPSUtils;

  //add  RIRegister_TComponentEnumerator
  //add classname        componentstyle


procedure RIRegisterTObject(CL: TPSRuntimeClassImporter);
procedure RIRegisterTPersistent(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTComponent(Cl: TPSRuntimeClassImporter);
procedure RIRegister_Std(Cl: TPSRuntimeClassImporter);
procedure RIRegister_TComponentEnumerator(CL: TPSRuntimeClassImporter);


implementation
uses
  Classes;


(*----------------------------------------------------------------------------*)
procedure TComponentEnumeratorCurrent_R(Self: TComponentEnumerator; var T: TComponent);
begin T := Self.Current; end;
  

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComponentEnumerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComponentEnumerator) do begin
    RegisterConstructor(@TComponentEnumerator.Create, 'Create');
    RegisterMethod(@TComponentEnumerator.GetCurrent, 'GetCurrent');
    RegisterMethod(@TComponentEnumerator.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TComponentEnumeratorCurrent_R,nil,'Current');
  end;
end;


procedure RIRegisterTObject(CL: TPSRuntimeClassImporter); 
begin
  with cl.Add(TObject) do begin
    RegisterConstructor(@TObject.Create, 'CREATE');
    RegisterMethod(@TObject.Free, 'FREE');
    RegisterMethod(@TObject.cleanupInstance, 'CleanUpInstance');
    RegisterMethod(@TObject.GetInterface, 'GetInterface');
     //RegisterVirtualAbstractMethod(TObject,@TObject.ClassName, 'ClassName');
    RegisterMethod(@TObject.ClassName, 'ClassName');
    RegisterMethod(@TObject.ClassNameIs, 'ClassNameIs');
    RegisterMethod(@TObject.InstanceSize, 'InstanceSize');
  end;
end;

procedure RIRegisterTPersistent(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TPersistent) do begin
    RegisterVirtualMethod(@TPersistent.Assign, 'ASSIGN');
    RegisterMethod(@TPersistent.GetNamePath,'GETNamePath');
    RegisterMethod(@TPersistent.Free, 'FREE');
  end;
end;

procedure TComponentOwnerR(Self: TComponent; var T: TComponent); begin T := Self.Owner; end;


procedure TCOMPONENTCOMPONENTS_R(Self: TCOMPONENT; var T: TCOMPONENT; t1: INTEGER); begin T := Self.COMPONENTS[t1]; end;
procedure TCOMPONENTCOMPONENTCOUNT_R(Self: TCOMPONENT; var T: INTEGER); begin t := Self.COMPONENTCOUNT; end;
procedure TCOMPONENTCOMPONENTINDEX_R(Self: TCOMPONENT; var T: INTEGER); begin t := Self.COMPONENTINDEX; end;
procedure TCOMPONENTCOMPONENTINDEX_W(Self: TCOMPONENT; T: INTEGER); begin Self.COMPONENTINDEX := t; end;
procedure TCOMPONENTCOMPONENTSTATE_R(Self: TCOMPONENT; var T: TCOMPONENTSTATE); begin t := Self.COMPONENTSTATE; end;
procedure TCOMPONENTCOMPONENTSTYLE_R(Self: TCOMPONENT; var T: TCOMPONENTSTYLE); begin t := Self.COMPONENTSTYLE; end;

procedure TCOMPONENTDESIGNINFO_R(Self: TCOMPONENT; var T: LONGINT); begin t := Self.DESIGNINFO; end;
procedure TCOMPONENTDESIGNINFO_W(Self: TCOMPONENT; T: LONGINT); begin Self.DESIGNINFO := t; end;
procedure TCOMPONENTCLASSNAME_R(Self: TCOMPONENT; var T: String); begin t:= Self.ClassName; end;
procedure TCOMPONENTCLASSTYPE_R(Self: TCOMPONENT; var T: TCLASS); begin t:= Self.ClassType; end;
procedure TCOMPONENTCLASSComObj_R(Self: TCOMPONENT; var T: IUnknown); begin t:= Self.ComObject; end;


procedure RIRegisterTComponent(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TComponent) do begin
    RegisterMethod(@TComponent.FindComponent, 'FINDCOMPONENT');
    RegisterVirtualConstructor(@TComponent.Create, 'CREATE');
    RegisterPropertyHelper(@TComponentOwnerR, nil, 'OWNER');

    RegisterMethod(@TCOMPONENT.Free, 'FREE');
    RegisterMethod(@TCOMPONENT.FreeOnRelease, 'FREEonRelease');
   RegisterMethod(@TCOMPONENT.ExecuteAction, 'ExecuteAction');
   RegisterMethod(@TCOMPONENT.FreeNotification, 'FreeNotification');
   RegisterMethod(@TCOMPONENT.RemoveFreeNotification, 'RemoveFreeNotification');
   RegisterMethod(@TCOMPONENT.GetParentComponent, 'GetParentComponent');
   RegisterMethod(@TCOMPONENT.GetNamePath, 'GetNamePath');
   RegisterMethod(@TCOMPONENT.HasParent, 'HasParent');
   RegisterMethod(@TCOMPONENT.GetEnumerator, 'GetEnumerator');
   RegisterMethod(@TCOMPONENT.Destroying, 'Destroying');
   RegisterMethod(@TCOMPONENT.InsertComponent, 'InsertComponent');
   RegisterMethod(@TCOMPONENT.RemoveComponent, 'RemoveComponent');

    RegisterMethod(@TCOMPONENT.DESTROYCOMPONENTS, 'DESTROYCOMPONENTS');
    RegisterPropertyHelper(@TCOMPONENTCOMPONENTS_R, nil, 'COMPONENTS');
    RegisterPropertyHelper(@TCOMPONENTCOMPONENTCOUNT_R, nil, 'COMPONENTCOUNT');
    RegisterPropertyHelper(@TCOMPONENTCOMPONENTINDEX_R, @TCOMPONENTCOMPONENTINDEX_W, 'COMPONENTINDEX');
    RegisterPropertyHelper(@TCOMPONENTCOMPONENTSTATE_R, nil, 'COMPONENTSTATE');
    RegisterPropertyHelper(@TCOMPONENTCOMPONENTSTYLE_R, nil, 'COMPONENTSTYLE');

    RegisterPropertyHelper(@TCOMPONENTCLASSNAME_R, nil, 'CLASSNAME');
    RegisterPropertyHelper(@TCOMPONENTCLASSTYPE_R, nil, 'CLASSTYPE');
    RegisterPropertyHelper(@TCOMPONENTCLASSComObj_R, nil, 'ComObject');
    // RegisterProperty('ComObject', 'IUnknown', iptr);

    RegisterPropertyHelper(@TCOMPONENTDESIGNINFO_R, @TCOMPONENTDESIGNINFO_W, 'DESIGNINFO');
  end;
end;


procedure RIRegister_Std(Cl: TPSRuntimeClassImporter);
begin
  RIRegisterTObject(CL);
  RIRegisterTPersistent(Cl);
  RIRegisterTComponent(Cl);
  RIRegister_TComponentEnumerator(CL);
end;
// PS_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)

end.





