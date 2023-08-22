
unit uPSR_classes;

//Register STD first   add delimiter & quotechar by max

   //3.6.8.4 , tbasicaction in 3.9.3 , custommemorystream.memory
   //fix mem stream  add interfacelist   second resstream constructor  CL.AddTypeS('RT_BITMAP','PChar(2)')
   // add TList one    resstream savetofile 4.7.6

{$I PascalScript.inc}
interface
uses
  uPSRuntime, uPSUtils;


procedure RIRegisterTStrings(cl: TPSRuntimeClassImporter; Streams: Boolean);
procedure RIRegisterTStringList(cl: TPSRuntimeClassImporter);
procedure RIRegister_TStringStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStreamAdapter(CL: TPSRuntimeClassImporter);
//procedure RIRegister_TClassFinder(CL: TPSRuntimeClassImporter);
procedure RIRegister_TThreadList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBasicAction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDataModule(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFiler(CL: TPSRuntimeClassImporter);
//procedure RIRegister_TTextReader(CL: TPSRuntimeClassImporter);

 procedure RIRegister_TStringsEnumerator(CL: TPSRuntimeClassImporter);
//procedure RIRegister_IVarStreamable(CL: TPSRuntimeClassImporter);
//procedure SIRegister_TFiler(CL: TPSPascalCompiler);
//procedure RIRegister_IInterfaceComponentReference(CL: TPSRuntimeClassImporter);
//procedure RIRegister_IVCLComObject(CL: TPSRuntimeClassImporter);
//procedure RIRegister_IStringsAdapter(CL: TPSRuntimeClassImporter);

//procedure RIRegister_TCollection(CL: TPSRuntimeClassImporter);

procedure RIRegister_TList(CL: TPSRuntimeClassImporter);

 procedure RIRegister_TCollectionEnumerator(CL: TPSRuntimeClassImporter);
//procedure SIRegister_TCollectionItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRecall(CL: TPSRuntimeClassImporter);
procedure RIRegister_TInterfacedPersistent(CL: TPSRuntimeClassImporter);
//procedure SIRegister_TPersistent(CL: TPSPascalCompiler);
procedure RIRegister_TInterfaceList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TInterfaceListEnumerator(CL: TPSRuntimeClassImporter);
//procedure SIRegister_IInterfaceList(CL: TPSPascalCompiler);
procedure RIRegister_TComponentEnumerator(CL: TPSRuntimeClassImporter);
 procedure RIRegister_EFileStreamError(CL: TPSRuntimeClassImporter);


{$IFNDEF PS_MINIVCL}
procedure RIRegisterTBITS(Cl: TPSRuntimeClassImporter);
{$ENDIF}
procedure RIRegisterTSTREAM(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTHANDLESTREAM(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTFILESTREAM(Cl: TPSRuntimeClassImporter);
{$IFNDEF PS_MINIVCL}
procedure RIRegisterTCUSTOMMEMORYSTREAM(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTMEMORYSTREAM(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTRESOURCESTREAM(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTPARSER(Cl: TPSRuntimeClassImporter);
{$IFDEF DELPHI3UP}
procedure RIRegisterTOWNEDCOLLECTION(Cl: TPSRuntimeClassImporter);
{$ENDIF}
procedure RIRegisterTCOLLECTION(Cl: TPSRuntimeClassImporter);
procedure RIRegisterTCOLLECTIONITEM(Cl: TPSRuntimeClassImporter);
{$ENDIF}

procedure RIRegister_Classes(Cl: TPSRuntimeClassImporter; Streams: Boolean{$IFDEF D4PLUS}=True{$ENDIF});

implementation
uses
  Classes, Sysutils;

procedure TStringsCountR(Self: TStrings; var T: Longint); begin T := Self.Count; end;

procedure TStringsTextR(Self: TStrings; var T: string); begin T := Self.Text; end;
procedure TStringsTextW(Self: TStrings; T: string); begin Self.Text:= T; end;

procedure TStringsCommaTextR(Self: TStrings; var T: string); begin T := Self.CommaText; end;
procedure TStringsCommaTextW(Self: TStrings; T: string); begin Self.CommaText:= T; end;

procedure TStringsDelimR(Self: TStrings; var T: char); begin T := Self.Delimiter; end;
procedure TStringsDelimW(Self: TStrings; T: char); begin Self.Delimiter:= T; end;

procedure TStringsQuoteR(Self: TStrings; var T: char); begin T := Self.QuoteChar; end;
procedure TStringsQuoteW(Self: TStrings; T: char); begin Self.QuoteChar:= T; end;


//procedure TStringsLineR(Self: TStrings; var T: string); begin T := Self.LineBreak; end;
//procedure TStringsLineW(Self: TStrings; T: string); begin Self.QuoteChar:= T; end;
procedure TStringsLineBreakR(Self: TStrings; var T: string); begin T := Self.LineBreak; end;
procedure TStringsLineBreakW(Self: TStrings; T: string); begin Self.LineBreak:= T; end;
procedure TStringsDelimtextR(Self: TStrings; var T: string); begin T := Self.DelimitedText; end;
procedure TStringsDelimtextW(Self: TStrings; T: string); begin Self.DelimitedText:= T; end;
procedure TStringsCapacityR(Self: TStrings; var T: integer); begin T := Self.Capacity; end;
procedure TStringsCapacityW(Self: TStrings; T: integer); begin Self.Capacity:= T; end;
procedure TStringsSDelimiterR(Self: TStrings; var T: boolean); begin T := Self.StrictDelimiter; end;
procedure TStringsSDelimiterW(Self: TStrings; T: boolean); begin Self.StrictDelimiter:= T; end;



procedure TStringsObjectsR(Self: TStrings; var T: TObject; I: Longint);
begin
T := Self.Objects[I];
end;
procedure TStringsObjectsW(Self: TStrings; const T: TObject; I: Longint);
begin
  Self.Objects[I]:= T;
end;

procedure TStringsStringsR(Self: TStrings; var T: string; I: Longint);
begin
T := Self.Strings[I];
end;
procedure TStringsStringsW(Self: TStrings; const T: string; I: Longint);
begin
  Self.Strings[I]:= T;
end;


(*----------------------------------------------------------------------------*)
procedure TStringStreamDataString_R(Self: TStringStream; var T: string);
begin T := Self.DataString; end;



procedure TStringsNamesR(Self: TStrings; var T: string; I: Longint);
begin
T := Self.Names[I];
end;

procedure TStringsNameR(Self: TStrings; var T: string);
begin
 //T:= Self.name;
end;

procedure TStringsValuesR(Self: TStrings; var T: string; const I: string);
begin
T := Self.Values[I];
end;
procedure TStringsValuesW(Self: TStrings; Const T, I: String);
begin
  Self.Values[I]:= T;
end;

(*----------------------------------------------------------------------------*)
procedure TStringsNameValueSeparator_W(Self: TStrings; const T: Char);
begin Self.NameValueSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringsNameValueSeparator_R(Self: TStrings; var T: Char);
begin T := Self.NameValueSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TStringsValueFromIndex_W(Self: TStrings; const T: string; const t1: Integer);
begin Self.ValueFromIndex[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringsValueFromIndex_R(Self: TStrings; var T: string; const t1: Integer);
begin T := Self.ValueFromIndex[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStringsStringsAdapter_W(Self: TStrings; const T: IStringsAdapter);
begin Self.StringsAdapter := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringsStringsAdapter_R(Self: TStrings; var T: IStringsAdapter);
begin T := Self.StringsAdapter; end;

(*----------------------------------------------------------------------------*)
procedure TStringsEnumeratorCurrent_R(Self: TStringsEnumerator; var T: string);
begin T := Self.Current; end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TStringsEnumerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStringsEnumerator) do
  begin
    RegisterConstructor(@TStringsEnumerator.Create, 'Create');
    RegisterMethod(@TStringsEnumerator.GetCurrent, 'GetCurrent');
    RegisterMethod(@TStringsEnumerator.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TStringsEnumeratorCurrent_R,nil,'Current');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure TComponentEnumeratorCurrent_R(Self: TComponentEnumerator; var T: TComponent);
begin T := Self.Current; end;


procedure RIRegister_TComponentEnumerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComponentEnumerator) do
  begin
    RegisterConstructor(@TComponentEnumerator.Create, 'Create');
    RegisterMethod(@TComponentEnumerator.GetCurrent, 'GetCurrent');
    RegisterMethod(@TComponentEnumerator.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TComponentEnumeratorCurrent_R,nil,'Current');
  end;
end;

procedure RIRegister_EFileStreamError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EFileStreamError) do
  begin
    RegisterConstructor(@EFileStreamError.Create, 'Create');
  end;
end;


 {
procedure TCollectionItems_W(Self: TCollection; const T: TCollectionItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCollectionItems_R(Self: TCollection; var T: TCollectionItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCollectionItemClass_R(Self: TCollection; var T: TCollectionItemClass);
begin T := Self.ItemClass; end;

(*----------------------------------------------------------------------------*)
procedure TCollectionCount_R(Self: TCollection; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TCollectionCapacity_W(Self: TCollection; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TCollectionCapacity_R(Self: TCollection; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
procedure TCollectionEnumeratorCurrent_R(Self: TCollectionEnumerator; var T: TCollectionItem);
begin T := Self.Current; end;

(*----------------------------------------------------------------------------*)
procedure TCollectionItemDisplayName_W(Self: TCollectionItem; const T: string);
begin Self.DisplayName := T; end;

(*----------------------------------------------------------------------------*)
procedure TCollectionItemDisplayName_R(Self: TCollectionItem; var T: string);
begin T := Self.DisplayName; end;

(*----------------------------------------------------------------------------*)
procedure TCollectionItemIndex_W(Self: TCollectionItem; const T: Integer);
begin Self.Index := T; end;

(*----------------------------------------------------------------------------*)
procedure TCollectionItemIndex_R(Self: TCollectionItem; var T: Integer);
begin T := Self.Index; end;

(*----------------------------------------------------------------------------*)
procedure TCollectionItemID_R(Self: TCollectionItem; var T: Integer);
begin T := Self.ID; end;

(*----------------------------------------------------------------------------*)
procedure TCollectionItemCollection_W(Self: TCollectionItem; const T: TCollection);
begin Self.Collection := T; end;

(*----------------------------------------------------------------------------*)
procedure TCollectionItemCollection_R(Self: TCollectionItem; var T: TCollection);
begin T := Self.Collection; end;

}

(*----------------------------------------------------------------------------*)
procedure TRecallReference_R(Self: TRecall; var T: TPersistent);
begin T := Self.Reference; end;


{
procedure RIRegister_TCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCollection) do
  begin
    RegisterConstructor(@TCollection.Create, 'Create');
    RegisterMethod(@TCollection.Owner, 'Owner');
    RegisterMethod(@TCollection.Add, 'Add');
    RegisterVirtualMethod(@TCollection.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TCollection.Clear, 'Clear');
    RegisterMethod(@TCollection.Delete, 'Delete');
    RegisterVirtualMethod(@TCollection.EndUpdate, 'EndUpdate');
    RegisterMethod(@TCollection.FindItemID, 'FindItemID');
    RegisterMethod(@TCollection.GetEnumerator, 'GetEnumerator');
    RegisterMethod(@TCollection.Insert, 'Insert');
    RegisterPropertyHelper(@TCollectionCapacity_R,@TCollectionCapacity_W,'Capacity');
    RegisterPropertyHelper(@TCollectionCount_R,nil,'Count');
    RegisterPropertyHelper(@TCollectionItemClass_R,nil,'ItemClass');
    RegisterPropertyHelper(@TCollectionItems_R,@TCollectionItems_W,'Items');
  end;
end;   }

(*----------------------------------------------------------------------------*)
procedure TCollectionEnumeratorCurrent_R(Self: TCollectionEnumerator; var T: TCollectionItem);
begin T := Self.Current; end;



procedure RIRegister_TCollectionEnumerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCollectionEnumerator) do
  begin
    RegisterConstructor(@TCollectionEnumerator.Create, 'Create');
    RegisterMethod(@TCollectionEnumerator.GetCurrent, 'GetCurrent');
    RegisterMethod(@TCollectionEnumerator.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TCollectionEnumeratorCurrent_R,nil,'Current');
  end;
end;

(*----------------------------------------------------------------------------*)
{procedure RIRegister_TCollectionItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCollectionItem) do
  begin
    RegisterVirtualConstructor(@TCollectionItem.Create, 'Create');
    RegisterPropertyHelper(@TCollectionItemCollection_R,@TCollectionItemCollection_W,'Collection');
    RegisterPropertyHelper(@TCollectionItemID_R,nil,'ID');
    RegisterPropertyHelper(@TCollectionItemIndex_R,@TCollectionItemIndex_W,'Index');
    RegisterPropertyHelper(@TCollectionItemDisplayName_R,@TCollectionItemDisplayName_W,'DisplayName');
  end;
end;       }

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRecall(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRecall) do begin
    RegisterConstructor(@TRecall.Create, 'Create');
      RegisterMethod(@TRecall.Destroy, 'Free');
      RegisterMethod(@TRecall.Store, 'Store');
    RegisterMethod(@TRecall.Forget, 'Forget');
    RegisterPropertyHelper(@TRecallReference_R,nil,'Reference');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TInterfacedPersistent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInterfacedPersistent) do
  begin
    RegisterVirtualMethod(@TInterfacedPersistent.QueryInterface, 'QueryInterface');
  end;
end;


(*----------------------------------------------------------------------------*)
procedure TInterfaceListItems_W(Self: TInterfaceList; const T: IInterface; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TInterfaceListItems_R(Self: TInterfaceList; var T: IInterface; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TInterfaceListCount_W(Self: TInterfaceList; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TInterfaceListCount_R(Self: TInterfaceList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TInterfaceListCapacity_W(Self: TInterfaceList; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TInterfaceListCapacity_R(Self: TInterfaceList; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
procedure TInterfaceListEnumeratorCurrent_R(Self: TInterfaceListEnumerator; var T: IInterface);
begin T := Self.Current; end;



 procedure RIRegister_TInterfaceList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInterfaceList) do begin
    RegisterConstructor(@TInterfaceList.Create, 'Create');
    RegisterMethod(@TInterfaceList.Clear, 'Clear');
    RegisterMethod(@TInterfaceList.Destroy, 'Free');
    RegisterMethod(@TInterfaceList.Delete, 'Delete');
    RegisterMethod(@TInterfaceList.Exchange, 'Exchange');
    RegisterMethod(@TInterfaceList.Expand, 'Expand');
    RegisterMethod(@TInterfaceList.First, 'First');
    RegisterMethod(@TInterfaceList.GetEnumerator, 'GetEnumerator');
    RegisterMethod(@TInterfaceList.IndexOf, 'IndexOf');
    RegisterMethod(@TInterfaceList.Add, 'Add');
    RegisterMethod(@TInterfaceList.Insert, 'Insert');
    RegisterMethod(@TInterfaceList.Last, 'Last');
    RegisterMethod(@TInterfaceList.Remove, 'Remove');
    RegisterMethod(@TInterfaceList.Lock, 'Lock');
    RegisterMethod(@TInterfaceList.Unlock, 'Unlock');
    RegisterPropertyHelper(@TInterfaceListCapacity_R,@TInterfaceListCapacity_W,'Capacity');
    RegisterPropertyHelper(@TInterfaceListCount_R,@TInterfaceListCount_W,'Count');
    RegisterPropertyHelper(@TInterfaceListItems_R,@TInterfaceListItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TInterfaceListEnumerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInterfaceListEnumerator) do
  begin
    RegisterConstructor(@TInterfaceListEnumerator.Create, 'Create');
    RegisterMethod(@TInterfaceListEnumerator.GetCurrent, 'GetCurrent');
    RegisterMethod(@TInterfaceListEnumerator.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TInterfaceListEnumeratorCurrent_R,nil,'Current');
  end;
end;


procedure RIRegisterTStrings(cl: TPSRuntimeClassImporter; Streams: Boolean); // requires TPersistent
begin
  with Cl.Add(TStrings) do begin
    RegisterVirtualMethod(@TStrings.Add, 'ADD');
    RegisterMethod(@TStrings.Destroy, 'Free');
    RegisterMethod(@TStrings.Assign, 'Assign');
    RegisterMethod(@TStrings.Append, 'APPEND');
    RegisterMethod(@TStrings.InstanceSize, 'InstanceSize');
    RegisterVirtualMethod(@TStrings.AddStrings, 'ADDSTRINGS');
    RegisterVirtualAbstractMethod(TStringList, @TStringList.Clear, 'CLEAR');
    RegisterVirtualAbstractMethod(TStringList, @TStringList.Delete, 'DELETE');
    RegisterVirtualMethod(@TStrings.IndexOf, 'INDEXOF');
    RegisterVirtualAbstractMethod(TStringList, @TStringList.Insert, 'INSERT');
    RegisterPropertyHelper(@TStringsCountR, nil, 'COUNT');
    RegisterPropertyHelper(@TStringsTextR, @TStringsTextW, 'TEXT');
    RegisterPropertyHelper(@TStringsDelimR, @TStringsDelimW, 'DELIMITER');
    RegisterPropertyHelper(@TStringsQUOTER, @TStringsQuoteW, 'QUOTECHAR');
    RegisterPropertyHelper(@TStringslineBreakR, @TStringsLineBreakW, 'LINEBREAK');
    RegisterPropertyHelper(@TStringsDelimtextR, @TStringsDelimtextW, 'DELIMITEDTEXT');
    RegisterPropertyHelper(@TStringsCapacityR, @TStringsCapacityW, 'CAPACITY');
    RegisterPropertyHelper(@TStringsSDelimiterR, @TStringsSDelimiterW, 'StrictDelimiter');
    RegisterPropertyHelper(@TStringsValueFromIndex_R,@TStringsValueFromIndex_W,'ValueFromIndex');
    RegisterPropertyHelper(@TStringsNameValueSeparator_R,@TStringsNameValueSeparator_W,'NameValueSeparator');
    RegisterPropertyHelper(@TStringsStringsAdapter_R,@TStringsStringsAdapter_W,'StringsAdapter');

      //RegisterPropertyHelper(@TStringsSDelimiterR, @TStringsSDelimiterW, 'CAPACITY');
      // RegisterProperty('StrictDelimiter','boolean',iptrw);

    RegisterPropertyHelper(@TStringsCommaTextR, @TStringsCommatextW, 'COMMATEXT');
    if Streams then begin
      RegisterVirtualMethod(@TStrings.LoadFromFile, 'LOADFROMFILE');
      RegisterVirtualMethod(@TStrings.SaveToFile, 'SAVETOFILE');
    end;
    RegisterPropertyHelper(@TStringsStringsR, @TStringsStringsW, 'STRINGS');
    RegisterPropertyHelper(@TStringsObjectsR, @TStringsObjectsW, 'OBJECTS');

    {$IFNDEF PS_MINIVCL}
    RegisterMethod(@TStrings.BeginUpdate, 'BEGINUPDATE');
    RegisterMethod(@TStrings.EndUpdate, 'ENDUPDATE');
    RegisterMethod(@TStrings.Equals,  'EQUALS');
    RegisterVirtualMethod(@TStrings.Exchange, 'EXCHANGE');
    RegisterMethod(@TStrings.IndexOfName, 'INDEXOFNAME');
    if Streams then
      RegisterVirtualMethod(@TStrings.LoadFromStream, 'LOADFROMSTREAM');
    RegisterVirtualMethod(@TStrings.Move, 'MOVE');
    if Streams then
      RegisterVirtualMethod(@TStrings.SaveToStream, 'SAVETOSTREAM');
    RegisterVirtualMethod(@TStrings.SetText, 'SETTEXT');
    RegisterPropertyHelper(@TStringsNamesR, nil, 'NAMES');
    RegisterPropertyHelper(@TStringsNameR, nil, 'NAME');    //not working

    RegisterPropertyHelper(@TStringsValuesR, @TStringsValuesW, 'VALUES');
    RegisterVirtualMethod(@TSTRINGS.ADDOBJECT, 'ADDOBJECT');
    RegisterVirtualMethod(@TSTRINGS.GETTEXT, 'GETTEXT');
    RegisterMethod(@TSTRINGS.INDEXOFOBJECT, 'INDEXOFOBJECT');
    RegisterMethod(@TSTRINGS.INSERTOBJECT, 'INSERTOBJECT');
    RegisterMethod(@TStrings.GetEnumerator, 'GetEnumerator');

    {$ENDIF}
  end;
end;


(*----------------------------------------------------------------------------*)
procedure TStreamAdapterStream_R(Self: TStreamAdapter; var T: TStream);
begin T := Self.Stream; end;

(*----------------------------------------------------------------------------*)
procedure TStreamAdapterStreamOwnership_W(Self: TStreamAdapter; const T: TStreamOwnership);
begin Self.StreamOwnership := T; end;


(*----------------------------------------------------------------------------*)
procedure TStreamAdapterStreamOwnership_R(Self: TStreamAdapter; var T: TStreamOwnership);
begin T := Self.StreamOwnership; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStreamAdapter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStreamAdapter) do begin
    RegisterConstructor(@TStreamAdapter.Create, 'Create');
    RegisterVirtualMethod(@TStreamAdapter.Read, 'Read');
    RegisterVirtualMethod(@TStreamAdapter.Write, 'Write');
    RegisterVirtualMethod(@TStreamAdapter.Seek, 'Seek');
    RegisterVirtualMethod(@TStreamAdapter.SetSize, 'SetSize');
    RegisterVirtualMethod(@TStreamAdapter.CopyTo, 'CopyTo');
    RegisterVirtualMethod(@TStreamAdapter.Commit, 'Commit');
    RegisterVirtualMethod(@TStreamAdapter.Revert, 'Revert');
    RegisterVirtualMethod(@TStreamAdapter.LockRegion, 'LockRegion');
    RegisterVirtualMethod(@TStreamAdapter.UnlockRegion, 'UnlockRegion');
    RegisterVirtualMethod(@TStreamAdapter.Stat, 'Stat');
    RegisterVirtualMethod(@TStreamAdapter.Clone, 'Clone');
    RegisterPropertyHelper(@TStreamAdapterStream_R,nil,'Stream');
    RegisterPropertyHelper(@TStreamAdapterStreamOwnership_R,@TStreamAdapterStreamOwnership_W,'StreamOwnership');
  end;
end;


(*----------------------------------------------------------------------------*)
procedure TBasicActionOnUpdate_W(Self: TBasicAction; const T: TNotifyEvent);
begin Self.OnUpdate := T; end;

(*----------------------------------------------------------------------------*)
procedure TBasicActionOnUpdate_R(Self: TBasicAction; var T: TNotifyEvent);
begin T := Self.OnUpdate; end;

(*----------------------------------------------------------------------------*)
procedure TBasicActionOnExecute_W(Self: TBasicAction; const T: TNotifyEvent);
begin Self.OnExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TBasicActionOnExecute_R(Self: TBasicAction; var T: TNotifyEvent);
begin T := Self.OnExecute; end;

(*----------------------------------------------------------------------------*)
procedure TBasicActionActionComponent_W(Self: TBasicAction; const T: TComponent);
begin Self.ActionComponent := T; end;

(*----------------------------------------------------------------------------*)
procedure TBasicActionActionComponent_R(Self: TBasicAction; var T: TComponent);
begin T := Self.ActionComponent; end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TBasicAction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBasicAction) do begin
    RegisterConstructor(@TBasicAction.Create, 'Create');
    RegisterVirtualMethod(@TBasicAction.HandlesTarget, 'HandlesTarget');
    RegisterVirtualMethod(@TBasicAction.UpdateTarget, 'UpdateTarget');
    RegisterVirtualMethod(@TBasicAction.ExecuteTarget, 'ExecuteTarget');
    RegisterVirtualMethod(@TBasicAction.Execute, 'Execute');
    RegisterMethod(@TBasicAction.RegisterChanges, 'RegisterChanges');
    RegisterMethod(@TBasicAction.UnRegisterChanges, 'UnRegisterChanges');
    RegisterVirtualMethod(@TBasicAction.Update, 'Update');
    RegisterPropertyHelper(@TBasicActionActionComponent_R,@TBasicActionActionComponent_W,'ActionComponent');
    RegisterPropertyHelper(@TBasicActionOnExecute_R,@TBasicActionOnExecute_W,'OnExecute');
    RegisterPropertyHelper(@TBasicActionOnUpdate_R,@TBasicActionOnUpdate_W,'OnUpdate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure TDataModuleOnDestroy_W(Self: TDataModule; const T: TNotifyEvent);
begin Self.OnDestroy := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataModuleOnDestroy_R(Self: TDataModule; var T: TNotifyEvent);
begin T := Self.OnDestroy; end;

(*----------------------------------------------------------------------------*)
procedure TDataModuleOnCreate_W(Self: TDataModule; const T: TNotifyEvent);
begin Self.OnCreate := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataModuleOnCreate_R(Self: TDataModule; var T: TNotifyEvent);
begin T := Self.OnCreate; end;

(*----------------------------------------------------------------------------*)
procedure TDataModuleOldCreateOrder_W(Self: TDataModule; const T: Boolean);
begin Self.OldCreateOrder := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataModuleOldCreateOrder_R(Self: TDataModule; var T: Boolean);
begin T := Self.OldCreateOrder; end;

(*----------------------------------------------------------------------------*)
//procedure TDataModuleDesignSize_W(Self: TDataModule; const T: TPoint);
//begin Self.DesignSize := T; end;

(*----------------------------------------------------------------------------*)
//procedure TDataModuleDesignSize_R(Self: TDataModule; var T: TPoint);
//begin T := Self.DesignSize; end;

(*----------------------------------------------------------------------------*)
//procedure TDataModuleDesignOffset_W(Self: TDataModule; const T: TPoint);
//begin Self.DesignOffset := T; end;

(*----------------------------------------------------------------------------*)
//procedure TDataModuleDesignOffset_R(Self: TDataModule; var T: TPoint);
//begin T := Self.DesignOffset; end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_TDataModule(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDataModule) do begin
    RegisterConstructor(@TDataModule.Create, 'Create');
    RegisterVirtualConstructor(@TDataModule.CreateNew, 'CreateNew');
    RegisterMethod(@TDataModule.AfterConstruction, 'AfterConstruction');
    RegisterMethod(@TDataModule.BeforeDestruction, 'BeforeDestruction');
    //RegisterPropertyHelper(@TDataModuleDesignOffset_R,@TDataModuleDesignOffset_W,'DesignOffset');
    //RegisterPropertyHelper(@TDataModuleDesignSize_R,@TDataModuleDesignSize_W,'DesignSize');
    RegisterPropertyHelper(@TDataModuleOldCreateOrder_R,@TDataModuleOldCreateOrder_W,'OldCreateOrder');
    RegisterPropertyHelper(@TDataModuleOnCreate_R,@TDataModuleOnCreate_W,'OnCreate');
    RegisterPropertyHelper(@TDataModuleOnDestroy_R,@TDataModuleOnDestroy_W,'OnDestroy');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure TFilerIgnoreChildren_W(Self: TFiler; const T: Boolean);
begin Self.IgnoreChildren := T; end;

(*----------------------------------------------------------------------------*)
procedure TFilerIgnoreChildren_R(Self: TFiler; var T: Boolean);
begin T := Self.IgnoreChildren; end;

(*----------------------------------------------------------------------------*)
procedure TFilerAncestor_W(Self: TFiler; const T: TPersistent);
begin Self.Ancestor := T; end;

(*----------------------------------------------------------------------------*)
procedure TFilerAncestor_R(Self: TFiler; var T: TPersistent);
begin T := Self.Ancestor; end;

(*----------------------------------------------------------------------------*)
procedure TFilerLookupRoot_R(Self: TFiler; var T: TComponent);
begin T := Self.LookupRoot; end;

(*----------------------------------------------------------------------------*)
procedure TFilerRoot_W(Self: TFiler; const T: TComponent);
begin Self.Root := T; end;

(*----------------------------------------------------------------------------*)
procedure TFilerRoot_R(Self: TFiler; var T: TComponent);
begin T := Self.Root; end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_TFiler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFiler) do begin
    RegisterConstructor(@TFiler.Create, 'Create');
    RegisterMethod(@TFiler.Destroy, 'Free');
    //RegisterVirtualAbstractMethod(@TFiler, @!.DefineProperty, 'DefineProperty');
    //RegisterVirtualAbstractMethod(@TFiler, @!.DefineBinaryProperty, 'DefineBinaryProperty');
    //RegisterVirtualAbstractMethod(@TFiler, @!.FlushBuffer, 'FlushBuffer');
    RegisterPropertyHelper(@TFilerRoot_R,@TFilerRoot_W,'Root');
    RegisterPropertyHelper(@TFilerLookupRoot_R,nil,'LookupRoot');
    RegisterPropertyHelper(@TFilerAncestor_R,@TFilerAncestor_W,'Ancestor');
    RegisterPropertyHelper(@TFilerIgnoreChildren_R,@TFilerIgnoreChildren_W,'IgnoreChildren');
  end;
end;



(*----------------------------------------------------------------------------*)
procedure TThreadOnTerminate_W(Self: TThread; const T: TNotifyEvent);
begin Self.OnTerminate := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadOnTerminate_R(Self: TThread; var T: TNotifyEvent);
begin T := Self.OnTerminate; end;

(*----------------------------------------------------------------------------*)
procedure TThreadThreadID_R(Self: TThread; var T: Cardinal);
begin T := Self.ThreadID; end;

(*----------------------------------------------------------------------------*)
procedure TThreadThreadID_R1(Self: TThread; var T: THandle);
begin T := Self.ThreadID; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSuspended_W(Self: TThread; const T: Boolean);
begin Self.Suspended := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadSuspended_R(Self: TThread; var T: Boolean);
begin T := Self.Suspended; end;

(*----------------------------------------------------------------------------*)
procedure TThreadPolicy_W(Self: TThread; const T: Integer);
begin //Self.Policy := T;
 end;

(*----------------------------------------------------------------------------*)
procedure TThreadPolicy_R(Self: TThread; var T: Integer);
begin //T := //Self.Policy;
 end;

(*----------------------------------------------------------------------------*)
procedure TThreadPriority_W(Self: TThread; const T: Integer);
begin //Self.Priority:= T;
 end;

(*----------------------------------------------------------------------------*)
procedure TThreadPriority_R(Self: TThread; var T: Integer);
begin //T := Self.Priority;
 end;

(*----------------------------------------------------------------------------*)
procedure TThreadPriority_W1(Self: TThread; const T: TThreadPriority);
begin Self.Priority := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadPriority_R1(Self: TThread; var T: TThreadPriority);
begin T := Self.Priority; end;

(*----------------------------------------------------------------------------*)
procedure TThreadHandle_R(Self: TThread; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TThreadFreeOnTerminate_W(Self: TThread; const T: Boolean);
begin Self.FreeOnTerminate := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadFreeOnTerminate_R(Self: TThread; var T: Boolean);
begin T := Self.FreeOnTerminate; end;

(*----------------------------------------------------------------------------*)
procedure TThreadFatalException_R(Self: TThread; var T: TObject);
begin T := Self.FatalException; end;

(*----------------------------------------------------------------------------*)
Procedure TThreadSynchronize_P(Self: TThread;  AThread : TThread; AMethod : TThreadMethod);
Begin Self.Synchronize(AThread, AMethod); END;

(*----------------------------------------------------------------------------*)
Procedure TThreadSynchronize_P1(Self: TThread;  AMethod : TThreadMethod);
Begin //Self.Synchronize(AMethod);
 END;

(*----------------------------------------------------------------------------*)
Procedure TThreadSynchronize_P2(Self: TThread;  ASyncRec : PSynchronizeRecord; QueueEvent : Boolean);
Begin //Self.Synchronize(ASyncRec, QueueEvent);
 END;


(*----------------------------------------------------------------------------*)
Procedure TThreadQueue_P(Self: TThread;  AThread : TThread; AMethod : TThreadMethod);
Begin Self.Queue(AThread, AMethod); END;

(*----------------------------------------------------------------------------*)
Procedure TThreadQueue_P1(Self: TThread;  AMethod : TThreadMethod);
Begin //Self.Queue(AMethod);
 END;

(*----------------------------------------------------------------------------*)
Procedure TThreadCheckThreadError_P(Self: TThread;  Success : Boolean);
Begin //Self.CheckThreadError(Success);
 END;

(*----------------------------------------------------------------------------*)
Procedure TThreadCheckThreadError_P1(Self: TThread;  ErrCode : Integer);
Begin //Self.CheckThreadError(ErrCode);
 END;



(*----------------------------------------------------------------------------*)
procedure RIRegister_TThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TThread) do begin
    RegisterConstructor(@TThread.Create, 'Create');
    RegisterMethod(@TThread.Resume, 'Resume');
    RegisterMethod(@TThread.Suspend, 'Suspend');
    RegisterMethod(@TThread.Terminate, 'Terminate');
    RegisterMethod(@TThread.WaitFor, 'WaitFor');
    RegisterMethod(@TThreadQueue_P, 'Queue');
    RegisterMethod(@TThread.RemoveQueuedEvents, 'RemoveQueuedEvents');
    RegisterMethod(@TThread.StaticQueue, 'StaticQueue');
    RegisterMethod(@TThreadSynchronize_P, 'Synchronize');
    //add 2 synchronize
    RegisterMethod(@TThread.StaticSynchronize, 'StaticSynchronize');
    RegisterPropertyHelper(@TThreadFatalException_R,nil,'FatalException');
    RegisterPropertyHelper(@TThreadFreeOnTerminate_R,@TThreadFreeOnTerminate_W,'FreeOnTerminate');
    RegisterPropertyHelper(@TThreadHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TThreadPriority_R,@TThreadPriority_W,'Priority');
    RegisterPropertyHelper(@TThreadPriority_R1,@TThreadPriority_W1,'Priority1');
    RegisterPropertyHelper(@TThreadPolicy_R,@TThreadPolicy_W,'Policy');
    RegisterPropertyHelper(@TThreadSuspended_R,@TThreadSuspended_W,'Suspended');
    RegisterPropertyHelper(@TThreadThreadID_R,nil,'ThreadID');
    RegisterPropertyHelper(@TThreadThreadID_R1,nil,'ThreadID1');
    RegisterPropertyHelper(@TThreadOnTerminate_R,@TThreadOnTerminate_W,'OnTerminate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure TThreadListDuplicates_W(Self: TThreadList; const T: TDuplicates);
begin Self.Duplicates := T; end;

(*----------------------------------------------------------------------------*)
procedure TThreadListDuplicates_R(Self: TThreadList; var T: TDuplicates);
begin T := Self.Duplicates; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TThreadList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TThreadList) do begin
    RegisterConstructor(@TThreadList.Create, 'Create');
    RegisterMethod(@TThreadlist.Destroy, 'Free');
    RegisterMethod(@TThreadList.Add, 'Add');
    RegisterMethod(@TThreadList.Clear, 'Clear');
    RegisterMethod(@TThreadList.LockList, 'LockList');
    RegisterMethod(@TThreadList.Remove, 'Remove');
    RegisterMethod(@TThreadList.UnlockList, 'UnlockList');
    RegisterPropertyHelper(@TThreadListDuplicates_R,@TThreadListDuplicates_W,'Duplicates');
  end;
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TListList_R(Self: TList; var T: PPointerList);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure TListItems_W(Self: TList; const T: Pointer; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TListItems_R(Self: TList; var T: Pointer; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TListCount_W(Self: TList; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TListCount_R(Self: TList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TListCapacity_W(Self: TList; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TListCapacity_R(Self: TList; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
Procedure TListError3_P(Self: TList;  Msg : PResStringRec; Data : Integer);
Begin Self.Error(Msg, Data); END;

(*----------------------------------------------------------------------------*)
Procedure TListError2_P(Self: TList;  const Msg : string; Data : Integer);
Begin Self.Error(Msg, Data); END;



(*----------------------------------------------------------------------------*)
procedure RIRegister_TList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TList) do
  begin
    RegisterMethod(@TList.Add, 'Add');
    RegisterVirtualMethod(@TList.Clear, 'Clear');
     RegisterMethod(@TList.Destroy, 'Free');
    RegisterMethod(@TList.Delete, 'Delete');
    RegisterVirtualMethod(@TListError2_P, 'Error');
    RegisterMethod(@TListError3_P, 'Error2');
    RegisterMethod(@TList.Exchange, 'Exchange');
    RegisterMethod(@TList.Expand, 'Expand');
    RegisterMethod(@TList.Extract, 'Extract');
    RegisterMethod(@TList.First, 'First');
    RegisterMethod(@TList.GetEnumerator, 'GetEnumerator');
    RegisterMethod(@TList.IndexOf, 'IndexOf');
    RegisterMethod(@TList.Insert, 'Insert');
    RegisterMethod(@TList.Last, 'Last');
    RegisterMethod(@TList.Move, 'Move');
    RegisterMethod(@TList.Remove, 'Remove');
    RegisterMethod(@TList.Pack, 'Pack');
    RegisterMethod(@TList.Sort, 'Sort');
    RegisterMethod(@TList.Assign, 'Assign');
    RegisterPropertyHelper(@TListCapacity_R,@TListCapacity_W,'Capacity');
    RegisterPropertyHelper(@TListCount_R,@TListCount_W,'Count');
    RegisterPropertyHelper(@TListItems_R,@TListItems_W,'Items');
    RegisterPropertyHelper(@TListList_R,nil,'List');
  end;
end;


(*----------------------------------------------------------------------------*)
procedure TStringListCaseSensitive_W(Self: TStringList; const T: Boolean);
begin Self.CaseSensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringListCaseSensitive_R(Self: TStringList; var T: Boolean);
begin T := Self.CaseSensitive; end;

procedure TSTRINGLISTDUPLICATES_R(Self: TSTRINGLIST; var T: TDUPLICATES); begin T := Self.DUPLICATES; end;

procedure TSTRINGLISTName_R(Self: TSTRINGLIST; var T: string);
 begin //T:= Self.name;
 end;

procedure TSTRINGLISTDUPLICATES_W(Self: TSTRINGLIST; const T: TDUPLICATES); begin Self.DUPLICATES := T; end;
procedure TSTRINGLISTSORTED_R(Self: TSTRINGLIST; var T: BOOLEAN); begin T := Self.SORTED; end;
procedure TSTRINGLISTSORTED_W(Self: TSTRINGLIST; const T: BOOLEAN); begin Self.SORTED := T; end;
procedure TSTRINGLISTONCHANGE_R(Self: TSTRINGLIST; var T: TNOTIFYEVENT);
begin
T := Self.ONCHANGE; end;
procedure TSTRINGLISTONCHANGE_W(Self: TSTRINGLIST; const T: TNOTIFYEVENT);
begin
Self.ONCHANGE := T; end;
procedure TSTRINGLISTONCHANGING_R(Self: TSTRINGLIST; var T: TNOTIFYEVENT); begin T := Self.ONCHANGING; end;
procedure TSTRINGLISTONCHANGING_W(Self: TSTRINGLIST; const T: TNOTIFYEVENT); begin Self.ONCHANGING := T; end;
procedure RIRegisterTSTRINGLIST(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TSTRINGLIST) do begin
    RegisterVirtualMethod(@TSTRINGLIST.FIND, 'FIND');
    RegisterMethod(@TStringList.Destroy, 'Free');
    RegisterMethod(@TStringList.Destroy, 'Destroy');
    RegisterVirtualMethod(@TSTRINGLIST.SORT, 'SORT');
    RegisterVirtualMethod(@TSTRINGLIST.CLEAR, 'CLEAR');
    RegisterVirtualMethod(@TStringList.CustomSort, 'CustomSort');
    RegisterVirtualMethod(@TStringList.Exchange, 'Exchange');
    RegisterMethod(@TStringList.Delete,'Delete');
    RegisterMethod(@TStringList.IndexOf,'IndexOf');
    RegisterMethod(@TStringList.Add,'Add');
    RegisterMethod(@TStringList.AddObject,'AddObject');
    RegisterMethod(@TStringList.Insert,'Insert');
    RegisterMethod(@TStringList.InsertObject,'InsertObject');
    RegisterPropertyHelper(@TSTRINGLISTDUPLICATES_R, @TSTRINGLISTDUPLICATES_W, 'DUPLICATES');
    RegisterPropertyHelper(@TSTRINGLISTSORTED_R, @TSTRINGLISTSORTED_W, 'SORTED');
     RegisterPropertyHelper(@TStringListCaseSensitive_R,@TStringListCaseSensitive_W,'CaseSensitive');
    RegisterEventPropertyHelper(@TSTRINGLISTONCHANGE_R, @TSTRINGLISTONCHANGE_W, 'ONCHANGE');
    RegisterEventPropertyHelper(@TSTRINGLISTONCHANGING_R, @TSTRINGLISTONCHANGING_W, 'ONCHANGING');
  end;
end;

{$IFNDEF PS_MINIVCL}
procedure TBITSBITS_W(Self: TBITS; T: BOOLEAN; t1: INTEGER); begin Self.BITS[t1] := T; end;
procedure TBITSBITS_R(Self: TBITS; var T: BOOLEAN; t1: INTEGER); begin T := Self.Bits[t1]; end;
procedure TBITSSIZE_R(Self: TBITS; T: INTEGER); begin Self.SIZE := T; end;
procedure TBITSSIZE_W(Self: TBITS; var T: INTEGER); begin T := Self.SIZE; end;

procedure RIRegisterTBITS(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TBITS) do begin
    RegisterMethod(@TBits.Destroy, 'Free');
    RegisterMethod(@TBITS.OPENBIT, 'OPENBIT');
    RegisterMethod(@TBits.InstanceSize, 'InstanceSize');
    RegisterPropertyHelper(@TBITSBITS_R, @TBITSBITS_W, 'BITS');
    RegisterPropertyHelper(@TBITSSIZE_R, @TBITSSIZE_W, 'SIZE');
  end;
end;
{$ENDIF}

procedure TSTREAMPOSITION_R(Self: TSTREAM; var T: LONGINT); begin t := Self.POSITION; end;
procedure TSTREAMPOSITION_W(Self: TSTREAM; T: LONGINT); begin Self.POSITION := t; end;
procedure TSTREAMSIZE_R(Self: TSTREAM; var T: LONGINT); begin t := Self.SIZE; end;
{$IFDEF DELPHI3UP}
procedure TSTREAMSIZE_W(Self: TSTREAM; T: LONGINT); begin Self.SIZE := t; end;
{$ENDIF}

procedure TCUSTOMMEMORYSTREAMMemory_R(Self: TCustomMemorySTREAM; var T: TObject);
 begin
   t:= Self.Memory;
  end;

//TCUSTOMMEMORYSTREAMMemory


{procedure ReadBufferAB(var Buffer; Count: Longint);
begin
  if (Count <> 0) and (Read(Buffer, Count) <> Count) then
    raise EReadError.CreateRes(@SReadError);
end;

procedure WriteBufferAB(const Buffer; Count: Longint);
begin
  if (Count <> 0) and (Write(Buffer, Count) <> Count) then
    raise EWriteError.CreateRes(@SWriteError);
end;}


procedure ReadBufferChar(Self: TStream; var Buffer: char; Count: Longint);
begin
  //if (Count <> 0) and (Read(Buffer, Count) <> Count) then
    //raise EWriteError.CreateRes(@SReadError);
    //TSTREAM.READBUFFER(buffer, count)
    self.READbuffer(buffer, count)

 end;



procedure ReadBufferString(Self: TStream; var Buffer: string; Count: Longint);
begin
  //if (Count <> 0) and (Read(Buffer, Count) <> Count) then
    //raise EWriteError.CreateRes(@SReadError);
    //TSTREAM.READBUFFER(buffer, count)
    self.READbuffer(buffer, count)

 end;

procedure ReadBufferInt(Self: TStream; var Buffer: integer; Count: Longint);
begin
  //if (Count <> 0) and (Read(Buffer, Count) <> Count) then
    //raise EWriteError.CreateRes(@SReadError);
    //TSTREAM.READBUFFER(buffer, count)
    self.READBUFFER(buffer, count)

 end;

procedure ReadBufferByte(Self: TStream; var Buffer: integer; Count: Longint);
begin
  //if (Count <> 0) and (Read(Buffer, Count) <> Count) then
    //raise EWriteError.CreateRes(@SReadError);
    //TSTREAM.READBUFFER(buffer, count)
    self.READBUFFER(buffer, count)

 end;

 procedure ReadByteArray2(Self: TStream; var Buffer: array of byte; Count: Longint);
begin
  //if (Count <> 0) and (Read(Buffer, Count) <> Count) then
    //raise EWriteError.CreateRes(@SReadError);
    //TSTREAM.READBUFFER(buffer, count)
    self.READBUFFER(buffer, count)

 end;

  procedure WriteByteArray2(Self: TStream; const Buffer: array of byte; Count: Longint);
begin
  //if (Count <> 0) and (Read(Buffer, Count) <> Count) then
    //raise EWriteError.CreateRes(@SReadError);
    //TSTREAM.READBUFFER(buffer, count)
    self.WriteBUFFER(buffer, count)

 end;

procedure ReadBufferByte2(Self: TStream; var Buffer: byte; Count: Longint);
begin
  //if (Count <> 0) and (Read(Buffer, Count) <> Count) then
    //raise EWriteError.CreateRes(@SReadError);
    //TSTREAM.READBUFFER(buffer, count)
    self.READBUFFER(buffer, count)

 end;

procedure WriteBufferByte2(Self: TStream; const Buffer: byte; Count: Longint);
begin
  //if (Count <> 0) and (Read(Buffer, Count) <> Count) then
    //raise EWriteError.CreateRes(@SReadError);
    //TSTREAM.READBUFFER(buffer, count)
    self.writeBUFFER(buffer, count)

 end;

 procedure ReadStr(Self: TStream; var Buffer: string; Count: Longint);
begin
  //if (Count <> 0) and (Read(Buffer, Count) <> Count) then
    //raise EWriteError.CreateRes(@SReadError);
    //TSTREAM.READBUFFER(buffer, count)
    self.READBUFFER(buffer, count)

 end;

procedure WriteStr(Self: TStream; const Buffer: string; Count: Longint);
begin
  //if (Count <> 0) and (Read(Buffer, Count) <> Count) then
    //raise EWriteError.CreateRes(@SReadError);
    //TSTREAM.READBUFFER(buffer, count)
    self.writeBUFFER(buffer, count)

 end;

procedure RIRegisterTSTREAM(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TSTREAM) do begin
    RegisterVirtualAbstractMethod(TMemoryStream, @TMemoryStream.READ, 'READ');
    RegisterVirtualAbstractMethod(TMemoryStream, @TMemoryStream.WRITE, 'WRITE');
    RegisterVirtualAbstractMethod(TMemoryStream, @TMemoryStream.SEEK, 'SEEK');
    RegisterMethod(@TSTREAM.READBUFFER , 'READBUFFER');

    RegisterMethod(@READBUFFERChar, 'READChar');

    RegisterMethod(@READBUFFERChar, 'READBUFFERChar');
      RegisterMethod(@READBUFFERString, 'READBUFFERSTRING');
    RegisterMethod(@TSTREAM.WRITEBUFFER, 'WRITEBUFFER');
    RegisterMethod(@TSTREAM.READBUFFER , 'READBUFFERAB');
    RegisterMethod(@TSTREAM.WRITEBUFFER, 'WRITEBUFFERAB');
    RegisterMethod(@TSTREAM.READBUFFER , 'READBUFFERABD');
    RegisterMethod(@TSTREAM.WRITEBUFFER, 'WRITEBUFFERABD');
    RegisterMethod(@TSTREAM.READBUFFER , 'READBUFFERP');
    RegisterMethod(@TSTREAM.WRITEBUFFER, 'WRITEBUFFERP');
    RegisterMethod(@TSTREAM.READBUFFER , 'READBUFFERAC');
    RegisterMethod(@TSTREAM.WRITEBUFFER, 'WRITEBUFFERAC');
    RegisterMethod(@TSTREAM.READBUFFER , 'READBUFFERACD');
    RegisterMethod(@TSTREAM.WRITEBUFFER, 'WRITEBUFFERACD');
    RegisterMethod(@TSTREAM.READBUFFER , 'READBUFFERAW');
    RegisterMethod(@TSTREAM.WRITEBUFFER, 'WRITEBUFFERAW');
    RegisterMethod(@TSTREAM.READBUFFER , 'READBUFFERAWD');
    RegisterMethod(@TSTREAM.WRITEBUFFER, 'WRITEBUFFERAWD');
    RegisterMethod(@TSTREAM.READBUFFER , 'READBUFFERO');
    RegisterMethod(@TSTREAM.WRITEBUFFER, 'WRITEBUFFERO');

    RegisterMethod(@READBUFFERInt , 'READBUFFERINT');
    RegisterMethod(@TSTREAM.WRITEBUFFER, 'WRITEBUFFERINT');
    //RegisterMethod(@TSTREAM.READBUFFER , 'READBUFFERINT');
    //RegisterMethod(@TSTREAM.WRITEBUFFER, 'WRITEBUFFERINT');

    RegisterMethod(@TSTREAM.READBUFFER , 'READBUFFERFloat');
    RegisterMethod(@TSTREAM.WRITEBUFFER, 'WRITEBUFFERFloat');

 //     RegisterMethod('procedure ReadBufferO(Buffer: TObject;Count:LongInt)');
 //   RegisterMethod('procedure WriteBufferO(Buffer: TObject;Count:LongInt)');

     RegisterMethod(@TSTREAM.READ , 'READAB');
    RegisterMethod(@TSTREAM.WRITE, 'WRITEAB');
    RegisterMethod(@TSTREAM.READ , 'READABD');
    RegisterMethod(@TSTREAM.WRITE, 'WRITEABD');
    RegisterMethod(@TSTREAM.READ , 'READAC');
    RegisterMethod(@TSTREAM.WRITE, 'WRITEAC');
    RegisterMethod(@TSTREAM.READ , 'READACD');
    RegisterMethod(@TSTREAM.WRITE, 'WRITEACD');
    RegisterMethod(@TSTREAM.READ , 'READInt');
    RegisterMethod(@TSTREAM.WRITE, 'WRITEInt');
    RegisterMethod(@READBufferByte , 'READByte');
     RegisterMethod(@TSTREAM.WRITE, 'WRITEByte');
    RegisterMethod(@READBufferByte2 , 'READByte2');
   RegisterMethod(@WriteBufferByte2 , 'WriteByte2');

    RegisterMethod(@READStr , 'READStr');
   RegisterMethod(@WriteStr , 'WriteStr');

    RegisterMethod(@TSTREAM.READ, 'READBYTEArray');
    RegisterMethod(@TSTREAM.WRITE, 'WRITEByteArray');
    RegisterMethod(@ReadByteArray2, 'READBYTEArray2');
    RegisterMethod(@WriteByteArray2, 'WriteBYTEArray2');

    //RegisterMethod('procedure ReadBufferAB(Buffer: array of byte;Count:LongInt)');
    //RegisterMethod('procedure WriteBufferAB(Buffer: array of byte;Count:LongInt)');

    RegisterMethod(@TSTREAM.COPYFROM, 'COPYFROM');
    RegisterMethod(@TStream.InstanceSize, 'InstanceSize');
    RegisterMethod(@TStream.FixupResourceHeader, 'FixupResourceHeader');
    RegisterMethod(@TStream.ReadResHeader, 'ReadResHeader');
    RegisterMethod(@TStream.ReadComponent, 'ReadComponent');
    RegisterMethod(@TStream.ReadComponentRes, 'ReadComponentRes');
    RegisterMethod(@TStream.WriteComponent, 'WriteComponent');
    RegisterMethod(@TStream.WriteComponentRes, 'WriteComponentRes');

    RegisterPropertyHelper(@TSTREAMPOSITION_R, @TSTREAMPOSITION_W, 'POSITION');
    RegisterPropertyHelper(@TSTREAMSIZE_R, {$IFDEF DELPHI3UP}@TSTREAMSIZE_W, {$ELSE}nil, {$ENDIF}'SIZE');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStringStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStringStream) do begin
    RegisterConstructor(@TStringStream.Create, 'Create');
    RegisterMethod(@TStringStream.ReadString, 'ReadString');
    RegisterMethod(@TStringStream.WriteString, 'WriteString');
    RegisterMethod(@TStringStream.Read, 'Read');
    RegisterMethod(@TStringStream.Write, 'Write');
    RegisterMethod(@TStringStream.Seek, 'Seek');
    RegisterPropertyHelper(@TStringStreamDataString_R,nil,'DataString');
  end;
end;


  //RegisterMethod('function ReadInt(Buffer:Integer;Count:LongInt):LongInt');
    //RegisterMethod('function WriteInt(Buffer:Integer;Count:LongInt):LongInt');

//function THANDLESTREAMWriteInt(Buffer:Integer;Count:LongInt):LongInt;
//begin
  //THandleStream.Write(buffer, count);
//end;

//Procedure THANDLESTREAMWriteInt(Self: THandleStream; const aBuffer: integer; Count:LongInt; var T: Longint);
Function THANDLESTREAMWriteInt(Self: THandleStream; const aBuffer: integer; Count: integer): integer;
Begin
 result:= Self.Write(aBuffer, count);
// T:= Self.Write(aBuffer, count);
//  T:= SysUtils.FileWrite(Self.Handle, Buffer, Count);
  //if Result = -1 then Result := 0;

END;

function THANDLESTREAMReadInt(Self: THandleStream; var Buffer: integer; Count:LongInt): Longint;
Begin
  result:= Self.Read(Buffer, count);
  //buffer:= buffer;
END;


procedure THANDLESTREAMHANDLE_R(Self: THANDLESTREAM; var T: INTEGER); begin T := Self.HANDLE; end;

procedure RIRegisterTHANDLESTREAM(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(THANDLESTREAM) do begin
    RegisterConstructor(@THANDLESTREAM.CREATE, 'CREATE');
    RegisterPropertyHelper(@THANDLESTREAMHANDLE_R, nil, 'HANDLE');
       RegisterMethod(@THandleStream.Read, 'Read');
    RegisterMethod(@THandleStream.Write, 'Write');
    RegisterMethod(@THandleStream.Seek, 'Seek');
       RegisterMethod(@THandleStreamReadInt, 'ReadInt');
    RegisterMethod(@THandleStreamWriteInt, 'WriteInt');
       RegisterMethod(@THandleStream.Read, 'ReadString');
    RegisterMethod(@THandleStream.Write, 'WriteString');
    //   RegisterMethod(@THandleStream.Read, 'ReadByteArray');
    //RegisterMethod(@THandleStream.Write, 'WriteByteArray');
    RegisterPropertyHelper(@THANDLESTREAMHANDLE_R, nil, 'HANDLE');

    {RegisterMethod('function ReadByteArray(Buffer:TByteArray;Count:LongInt):LongInt');
    RegisterMethod('function WriteByteArray(Buffer:TByteArray;Count:LongInt):LongInt');}

   end;
end;

{$IFDEF FPC}
// mh: because FPC doesn't handle pointers to overloaded functions
function TFileStreamCreate(filename: string; mode: word): TFileStream;
begin
  result := TFilestream.Create(filename, mode);
end;
{$ENDIF}


Procedure TFILESTREAMCREATE_P(Self: TFileStream;  FileName:String;Mode:Word;Rights: Cardinal);
Begin
   Self.Create(Filename, mode, rights);
 END;


procedure TFileStreamfilename_R(Self: TFileSTREAM; var T: string);
 begin
   t:= Self.FileName;
  end;

Procedure TFileSTREAMWriteInt(Self: TFileStream; const Buffer: integer; Count:integer; var T: integer);
//Procedure TFileSTREAMWriteInt(const Buffer: integer; Count:integer);
Begin
  T:= Self.Write(Buffer, count);
END;

Procedure TFileSTREAMReadInt(Self: TFileStream; var Buffer: integer; Count:LongInt; var T: Longint);
Begin T:= Self.Read(integer(Buffer), count); END;


function TFileSTREAMWriteBA(Self: TFileStream; const Buffer: TByteArray; Count:integer): integer;
//Procedure TFileSTREAMWriteInt(const Buffer: integer; Count:integer);
Begin
  result:= Self.Write(Buffer, count);
END;

function TFileSTREAMReadBA(Self: TFileStream; var Buffer: TByteArray; Count:integer): integer;
Begin
  result:= Self.Read(Buffer, count);
END;

//Procedure TFileSTREAMTestInt(Self: TFileStream; aint: integer; T: integer);
function TFileSTREAMTestInt(Self: TFileStream; aint: integer): integer;
Begin
  //T:= Self.Handle;
  result:= aint;
END;


function TMemSTREAMReadString(Self: TMemoryStream; var Buffer: string; Count:longint): longint;
Begin
  result:= Self.Read(Buffer, count);
END;


procedure RIRegisterTFILESTREAM(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TFILESTREAM) do begin
    {$IFDEF FPC}
    RegisterConstructor(@TFileStream.Create, 'CREATE');
    {$ELSE}
    RegisterConstructor(@TFILESTREAM.CREATE, 'CREATE');
    RegisterConstructor(@TFILESTREAMCREATE_P, 'CREATE1');
    RegisterMethod(@TFileStream.Destroy, 'Free');
    RegisterPropertyHelper(@TFileStreamfilename_R, nil, 'FileName');
    //RegisterMethod(@TFileStreamReadInt, 'ReadInt');
    //RegisterMethod(@TFileStreamWriteInt, 'WriteInt');
    RegisterMethod(@TFileStreamReadBA, 'ReadByteArray');
    RegisterMethod(@TFileStreamWriteBA, 'WriteByteArray');
    RegisterMethod(@TFileStreamTestInt, 'TestInt');

 // RegisterProperty('FileName', 'string', iptr);

    {$ENDIF}
  end;
end;

{$IFNDEF PS_MINIVCL}
procedure RIRegisterTCUSTOMMEMORYSTREAM(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TCUSTOMMEMORYSTREAM) do begin
    RegisterMethod(@TCUSTOMMEMORYSTREAM.SAVETOSTREAM, 'SAVETOSTREAM');
    RegisterMethod(@TCUSTOMMEMORYSTREAM.SAVETOFILE, 'SAVETOFILE');
    RegisterMethod(@TCUSTOMMEMORYSTREAM.Read, 'Read');
    RegisterMethod(@TMemSTREAMReadString, 'ReadString');
    RegisterMethod(@TCUSTOMMEMORYSTREAM.Read, 'ReadByteArray');
    RegisterMethod(@TCUSTOMMEMORYSTREAM.Seek, 'Seek');
    RegisterPropertyHelper(@TCUSTOMMEMORYSTREAMMemory_R, nil, 'Memory');
  end;
end;



procedure RIRegisterTMEMORYSTREAM(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TMEMORYSTREAM) do begin
    RegisterMethod(@TMEMORYSTREAM.CLEAR, 'CLEAR');
    RegisterMethod(@TMemoryStream.Destroy, 'Free');
    RegisterMethod(@TMEMORYSTREAM.LOADFROMSTREAM, 'LOADFROMSTREAM');
    RegisterMethod(@TMEMORYSTREAM.LOADFROMFILE, 'LOADFROMFILE');
    RegisterMethod(@TMEMORYSTREAM.SETSIZE, 'SETSIZE');
    RegisterMethod(@TMemoryStream.InstanceSize, 'InstanceSize');
    RegisterMethod(@TMemoryStream.Write, 'Write');
    RegisterMethod(@TMemoryStream.Write, 'WriteByteArray');

    //RegisterMethod(@TMEMORYSTREAM.READBUFFER, 'READBUFFERAB');
    //RegisterMethod(@TMEMORYSTREAM.WRITEBUFFER, 'WRITEBUFFERAB');
  end;
end;

const
  RT_RCDATA       = PChar(10);

  RT_BITMAP       = PChar(2);


Procedure TRESOURCESTREAM_P(Self: TRESOURCESTREAM;  aInstance: THandle; ResName:String);
Begin
   Self.Create(aInstance, resname, pansichar(RT_RCDATA));
 END;

Procedure TRESOURCESTREAM_P2(Self: TRESOURCESTREAM;  aInstance: THandle; ResName:String);
Begin
   Self.Create(aInstance, resname, pansichar(RT_BITMAP));
 END;

procedure RIRegisterTRESOURCESTREAM(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TRESOURCESTREAM) do begin
    RegisterConstructor(@TRESOURCESTREAM.CREATE, 'CREATE');
    RegisterConstructor(@TRESOURCESTREAM_P, 'CREATE1');
    RegisterConstructor(@TRESOURCESTREAM_P2, 'CREATE2');
    RegisterMethod(@TResourceStream.Destroy, 'Free');
    RegisterMethod(@TResourceStream.Write, 'Write');
    RegisterConstructor(@TRESOURCESTREAM.CREATEFROMID, 'CREATEFROMID');
     RegisterMethod(@TRESOURCESTREAM.SAVETOSTREAM, 'SAVETOSTREAM');
    RegisterMethod(@TRESOURCESTREAM.SAVETOFILE, 'SAVETOFILE');
  end;
end;

procedure TPARSERSOURCELINE_R(Self: TPARSER; var T: INTEGER); begin T := Self.SOURCELINE; end;
procedure TPARSERTOKEN_R(Self: TPARSER; var T: CHAR); begin T := Self.TOKEN; end;

(*----------------------------------------------------------------------------*)
procedure TParserLinePos_R(Self: TParser; var T: Integer);
begin T := Self.LinePos; end;

(*----------------------------------------------------------------------------*)
procedure TParserFloatType_R(Self: TParser; var T: Char);
begin T := Self.FloatType; end;


procedure TParserOnError_W(Self: TParser; const T: TParserErrorEvent);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TParserOnError_R(Self: TParser; var T: TParserErrorEvent);
begin T := Self.OnError; end;


procedure RIRegisterTPARSER(Cl: TPSRuntimeClassImporter);
begin
  with Cl.Add(TPARSER) do begin
    RegisterConstructor(@TPARSER.CREATE, 'CREATE');
    RegisterMethod(@TParser.Destroy, 'Free');
    RegisterMethod(@TPARSER.CHECKTOKEN, 'CHECKTOKEN');
    RegisterMethod(@TPARSER.CHECKTOKENSYMBOL, 'CHECKTOKENSYMBOL');
    RegisterMethod(@TPARSER.ERROR, 'ERROR');
    RegisterMethod(@TPARSER.ERRORSTR, 'ERRORSTR');
    RegisterMethod(@TPARSER.ErrorFmt, 'ErrorFmt');

    RegisterMethod(@TPARSER.HEXTOBINARY, 'HEXTOBINARY');
    RegisterMethod(@TPARSER.NEXTTOKEN, 'NEXTTOKEN');
    RegisterMethod(@TPARSER.SOURCEPOS, 'SOURCEPOS');
    RegisterMethod(@TPARSER.TOKENCOMPONENTIDENT, 'TOKENCOMPONENTIDENT');
    RegisterMethod(@TPARSER.TOKENFLOAT, 'TOKENFLOAT');
    RegisterMethod(@TPARSER.TOKENINT, 'TOKENINT');
    RegisterMethod(@TPARSER.TOKENSTRING, 'TOKENSTRING');
    RegisterMethod(@TPARSER.TOKENSYMBOLIS, 'TOKENSYMBOLIS');
    RegisterMethod(@TPARSER.TokenWideString, 'TokenWideString');

    //   RegisterMethod('Function TokenWideString : WideString');

    RegisterPropertyHelper(@TPARSERSOURCELINE_R, nil, 'SOURCELINE');
    RegisterPropertyHelper(@TPARSERTOKEN_R, nil, 'TOKEN');
    RegisterPropertyHelper(@TParserFloatType_R,nil,'FloatType');
     RegisterPropertyHelper(@TParserOnError_R,@TParserOnError_W,'OnError');


    //RegisterPropertyHelper(@TParserSourceLine_R,nil,'SourceLine');
    RegisterPropertyHelper(@TParserLinePos_R,nil,'LinePos');
  end;
end;

procedure TCOLLECTIONITEMS_W(Self: TCOLLECTION; const T: TCOLLECTIONITEM; const t1: INTEGER);
begin Self.ITEMS[t1] := T; end;

procedure TCOLLECTIONITEMS_R(Self: TCOLLECTION; var T: TCOLLECTIONITEM; const t1: INTEGER);
begin T := Self.ITEMS[t1]; end;

{$IFDEF DELPHI3UP}
procedure TCOLLECTIONITEMCLASS_R(Self: TCOLLECTION; var T: TCOLLECTIONITEMCLASS);
begin T := Self.ITEMCLASS; end;
{$ENDIF}

procedure TCOLLECTIONCOUNT_R(Self: TCOLLECTION; var T: INTEGER);
begin T := Self.COUNT; end;

{$IFDEF DELPHI3UP}
procedure TCOLLECTIONITEMDISPLAYNAME_W(Self: TCOLLECTIONITEM; const T: STRING);
begin Self.DISPLAYNAME := T; end;
{$ENDIF}

{$IFDEF DELPHI3UP}
procedure TCOLLECTIONITEMDISPLAYNAME_R(Self: TCOLLECTIONITEM; var T: STRING);
begin T := Self.DISPLAYNAME; end;
{$ENDIF}

procedure TCOLLECTIONITEMINDEX_W(Self: TCOLLECTIONITEM; const T: INTEGER);
begin Self.INDEX := T; end;

procedure TCOLLECTIONITEMINDEX_R(Self: TCOLLECTIONITEM; var T: INTEGER);
begin T := Self.INDEX; end;

{$IFDEF DELPHI3UP}
procedure TCOLLECTIONITEMID_R(Self: TCOLLECTIONITEM; var T: INTEGER);
begin T := Self.ID; end;
{$ENDIF}

procedure TCOLLECTIONITEMCOLLECTION_W(Self: TCOLLECTIONITEM; const T: TCOLLECTION);
begin Self.COLLECTION := T; end;

procedure TCOLLECTIONITEMCOLLECTION_R(Self: TCOLLECTIONITEM; var T: TCOLLECTION);
begin T := Self.COLLECTION; end;

{$IFDEF DELPHI3UP}
procedure RIRegisterTOWNEDCOLLECTION(Cl: TPSRuntimeClassImporter);
Begin
with Cl.Add(TOWNEDCOLLECTION) do
  begin
  RegisterConstructor(@TOWNEDCOLLECTION.CREATE, 'CREATE');
  end;
end;
{$ENDIF}

procedure RIRegisterTCOLLECTION(Cl: TPSRuntimeClassImporter);
Begin
with Cl.Add(TCOLLECTION) do begin
  RegisterConstructor(@TCOLLECTION.CREATE, 'CREATE');
  RegisterMethod(@TCOLLECTION.Destroy, 'Free');
  RegisterMethod(@TCOLLECTION.Assign, 'Assign');
{$IFDEF DELPHI6UP}  {$IFNDEF FPC} RegisterMethod(@TCOLLECTION.OWNER, 'OWNER'); {$ENDIF} {$ENDIF} // no owner in FPC
  RegisterMethod(@TCOLLECTION.ADD, 'ADD');
  RegisterVirtualMethod(@TCOLLECTION.BEGINUPDATE, 'BEGINUPDATE');
  RegisterMethod(@TCOLLECTION.CLEAR, 'CLEAR');
{$IFDEF DELPHI5UP}  RegisterMethod(@TCOLLECTION.DELETE, 'DELETE'); {$ENDIF}
  RegisterVirtualMethod(@TCOLLECTION.ENDUPDATE, 'ENDUPDATE');
{$IFDEF DELPHI3UP}  RegisterMethod(@TCOLLECTION.FINDITEMID, 'FINDITEMID'); {$ENDIF}
{$IFDEF DELPHI3UP}  RegisterMethod(@TCOLLECTION.INSERT, 'INSERT'); {$ENDIF}
  RegisterPropertyHelper(@TCOLLECTIONCOUNT_R,nil,'COUNT');
{$IFDEF DELPHI3UP}  RegisterPropertyHelper(@TCOLLECTIONITEMCLASS_R,nil,'ITEMCLASS'); {$ENDIF}
  RegisterPropertyHelper(@TCOLLECTIONITEMS_R,@TCOLLECTIONITEMS_W,'ITEMS');
  end;
end;

procedure RIRegisterTCOLLECTIONITEM(Cl: TPSRuntimeClassImporter);
Begin
with Cl.Add(TCOLLECTIONITEM) do begin
  RegisterMethod(@TCOLLECTIONITEM.Destroy, 'Free');
  RegisterMethod(@TCOLLECTIONITEM.GetNamePath, 'GetNamePath');
  RegisterVirtualConstructor(@TCOLLECTIONITEM.CREATE, 'CREATE');
  RegisterPropertyHelper(@TCOLLECTIONITEMCOLLECTION_R,@TCOLLECTIONITEMCOLLECTION_W,'COLLECTION');
{$IFDEF DELPHI3UP}  RegisterPropertyHelper(@TCOLLECTIONITEMID_R,nil,'ID'); {$ENDIF}
  RegisterPropertyHelper(@TCOLLECTIONITEMINDEX_R,@TCOLLECTIONITEMINDEX_W,'INDEX');
{$IFDEF DELPHI3UP}  RegisterPropertyHelper(@TCOLLECTIONITEMDISPLAYNAME_R,@TCOLLECTIONITEMDISPLAYNAME_W,'DISPLAYNAME'); {$ENDIF}
  end;
end;
{$ENDIF}

{procedure RIRegister_TTextReader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTextReader) do begin
    RegisterVirtualAbstractMethod(@TTextReader, @Close, 'Close');
    RegisterVirtualAbstractMethod(@TTextReader, @Peek, 'Peek');
    RegisterVirtualAbstractMethod(@TTextReader, @Read, 'Read');
    RegisterVirtualAbstractMethod(@TTextReader, @Read, 'Read');
    RegisterVirtualAbstractMethod(@TTextReader, @ReadBlock, 'ReadBlock');
    RegisterVirtualAbstractMethod(@TTextReader, @ReadLine, 'ReadLine');
    RegisterVirtualAbstractMethod(@TTextReader, @ReadToEnd, 'ReadToEnd');
  end;
end;}


procedure RIRegister_Classes(Cl: TPSRuntimeClassImporter; Streams: Boolean);
begin

  with CL.Add(EFCreateError) do
  with CL.Add(EFOpenError) do
  with CL.Add(EFilerError) do
  with CL.Add(EReadError) do
  with CL.Add(EWriteError) do
  with CL.Add(EClassNotFound) do
  with CL.Add(EMethodNotFound) do
  with CL.Add(EInvalidImage) do
  with CL.Add(EResNotFound) do
  with CL.Add(EListError) do
  with CL.Add(EBitsError) do
  with CL.Add(EStringListError) do
  with CL.Add(EComponentError) do
  with CL.Add(EParserError) do
  with CL.Add(EOutOfResources) do
  with CL.Add(EInvalidOperation) do
  with CL.Add(TStream) do
  with CL.Add(TFiler) do
  with CL.Add(TReader) do
  with CL.Add(TWriter) do
  with CL.Add(TComponent) do

  if Streams then
    RIRegisterTSTREAM(Cl);
  RIRegisterTStrings(cl, Streams);
  RIRegisterTStringList(cl);
  RIRegister_TStringStream(CL);
   with CL.Add(EThread) do
  RIRegister_TThread(CL);
  RIRegister_TThreadList(CL);
  RIRegister_TStreamAdapter(CL);
  RIRegister_TBasicAction(CL);
  RIRegister_TDataModule(CL);
  RIRegister_TFiler(CL);
  RIRegister_TStringsEnumerator(CL);

  RIRegister_TList(CL);

  with CL.Add(TInterfaceList) do
  RIRegister_TInterfaceListEnumerator(CL);
  RIRegister_TInterfaceList(CL);
  //RIRegister_TBits(CL);
  //RIRegister_TPersistent(CL);
  RIRegister_TInterfacedPersistent(CL);
  RIRegister_TRecall(CL);
  RIRegister_TCollectionEnumerator(CL);
  RIRegister_TComponentEnumerator(CL);

   with CL.Add(EStreamError) do
  RIRegister_EFileStreamError(CL);


 {$IFNDEF PS_MINIVCL}
  RIRegisterTBITS(cl);
  {$ENDIF}
  if Streams then begin

   RIRegisterTHANDLESTREAM(Cl);
    RIRegisterTFILESTREAM(Cl);
    {$IFNDEF PS_MINIVCL}
    RIRegisterTCUSTOMMEMORYSTREAM(Cl);
    RIRegisterTMEMORYSTREAM(Cl);
    RIRegisterTRESOURCESTREAM(Cl);
    {$ENDIF}
  end;
  {$IFNDEF PS_MINIVCL}
  RIRegisterTPARSER(Cl);
  RIRegisterTCOLLECTIONITEM(Cl);
  RIRegisterTCOLLECTION(Cl);
  {$IFDEF DELPHI3UP}
  RIRegisterTOWNEDCOLLECTION(Cl);
  {$ENDIF}
  {$ENDIF}
end;

// PS_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)

end.
