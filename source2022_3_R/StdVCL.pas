{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{*******************************************************}

{*******************************************************}
{       Standard VCL OLE Interfaces                     }
{*******************************************************}

unit StdVCL;

{ Borland standard VCL type library }
{ Version 1.0 }

{ Bring in definition of IDispatch which is used here }

(*$HPPEMIT '// The following was extracted from OAIDL.H and brought in here to avoid bringing'*)
(*$HPPEMIT '// in OAIDL.H itself. It was conveniently guarded in the said header, which makes'*)
(*$HPPEMIT '// it ideal to be plucked out and replicated.'*)
(*$HPPEMIT '// '*)
(*$HPPEMIT '#ifndef __IDispatch_INTERFACE_DEFINED__'*)
(*$HPPEMIT '#define __IDispatch_INTERFACE_DEFINED__'*)
(*$HPPEMIT ''*)
(*$HPPEMIT '// Forward ref. OLE structures'*)
(*$HPPEMIT 'struct    tagDISPPARAMS;'*)
(*$HPPEMIT 'struct    tagEXCEPINFO;'*)
(*$HPPEMIT ''*)
(*$HPPEMIT '// OAIDL.H would have declared DISPID as a typedef of a LONG but we don't '*)
(*$HPPEMIT '// assume it has been included. Hence, we use a macro'*)
(*$HPPEMIT '//'*)
(*$HPPEMIT '#define DISPID LONG'*)
(*$HPPEMIT ''*)
(*$HPPEMIT '/****************************************'*)
(*$HPPEMIT ' * Generated header for interface: IDispatch'*)
(*$HPPEMIT ' * at Sat Jul 13 21:56:52 1996'*)
(*$HPPEMIT ' * using MIDL 3.00.39'*)
(*$HPPEMIT ' ****************************************/'*)
(*$HPPEMIT '/* [unique][uuid][object] */ '*)
(*$HPPEMIT ''*)
(*$HPPEMIT ''*)
(*$HPPEMIT 'typedef /* [unique] */ IDispatch __RPC_FAR *LPDISPATCH;'*)
(*$HPPEMIT ''*)
(*$HPPEMIT '/* DISPID reserved to indicate an "unknown" name */'*)
(*$HPPEMIT '/* only reserved for data members (properties); reused as a method dispid below */'*)
(*$HPPEMIT '#define DISPID_UNKNOWN  ( -1 )'*)
(*$HPPEMIT ''*)
(*$HPPEMIT '/* DISPID reserved for the "value" property */'*)
(*$HPPEMIT '#define DISPID_VALUE  ( 0 )'*)
(*$HPPEMIT ''*)
(*$HPPEMIT '/* The following DISPID is reserved to indicate the param'*)
(*$HPPEMIT ' * that is the right-hand-side (or "put" value) of a PropertyPut'*)
(*$HPPEMIT ' */'*)
(*$HPPEMIT '#define DISPID_PROPERTYPUT  ( -3 )'*)
(*$HPPEMIT ''*)
(*$HPPEMIT '/* DISPID reserved for the standard "NewEnum" method */'*)
(*$HPPEMIT '#define DISPID_NEWENUM  ( -4 )'*)
(*$HPPEMIT ''*)
(*$HPPEMIT '/* DISPID reserved for the standard "Evaluate" method */'*)
(*$HPPEMIT '#define DISPID_EVALUATE ( -5 )'*)
(*$HPPEMIT ''*)
(*$HPPEMIT '#define DISPID_CONSTRUCTOR  ( -6 )'*)
(*$HPPEMIT ''*)
(*$HPPEMIT '#define DISPID_DESTRUCTOR ( -7 )'*)
(*$HPPEMIT ''*)
(*$HPPEMIT '#define DISPID_COLLECT  ( -8 )'*)
(*$HPPEMIT ''*)
(*$HPPEMIT '/* The range -500 through -999 is reserved for Controls */'*)
(*$HPPEMIT '/* The range 0x80010000 through 0x8001FFFF is reserved for Controls */'*)
(*$HPPEMIT '/* The range -5000 through -5499 is reserved for ActiveX Accessability */'*)
(*$HPPEMIT '/* The remainder of the negative DISPIDs are reserved for future use */'*)
(*$HPPEMIT ''*)
(*$HPPEMIT 'EXTERN_C const IID IID_IDispatch;'*)
(*$HPPEMIT ''*)
(*$HPPEMIT '    '*)
(*$HPPEMIT '    interface IDispatch : public IUnknown'*)
(*$HPPEMIT '    {'*)
(*$HPPEMIT '    public:'*)
(*$HPPEMIT '        virtual HRESULT STDMETHODCALLTYPE GetTypeInfoCount( '*)
(*$HPPEMIT '            /* [out] */ UINT __RPC_FAR *pctinfo) = 0;'*)
(*$HPPEMIT '        '*)
(*$HPPEMIT '        virtual HRESULT STDMETHODCALLTYPE GetTypeInfo( '*)
(*$HPPEMIT '            /* [in] */ UINT iTInfo,'*)
(*$HPPEMIT '            /* [in] */ LCID lcid,'*)
(*$HPPEMIT '            /* [out] */ ITypeInfo __RPC_FAR *__RPC_FAR *ppTInfo) = 0;'*)
(*$HPPEMIT '        '*)
(*$HPPEMIT '        virtual HRESULT STDMETHODCALLTYPE GetIDsOfNames( '*)
(*$HPPEMIT '            /* [in] */ REFIID riid,'*)
(*$HPPEMIT '            /* [size_is][in] */ LPOLESTR __RPC_FAR *rgszNames,'*)
(*$HPPEMIT '            /* [in] */ UINT cNames,'*)
(*$HPPEMIT '            /* [in] */ LCID lcid,'*)
(*$HPPEMIT '            /* [size_is][out] */ DISPID __RPC_FAR *rgDispId) = 0;'*)
(*$HPPEMIT '        '*)
(*$HPPEMIT '        virtual /* [local] */ HRESULT STDMETHODCALLTYPE Invoke( '*)
(*$HPPEMIT '            /* [in] */ DISPID dispIdMember,'*)
(*$HPPEMIT '            /* [in] */ REFIID riid,'*)
(*$HPPEMIT '            /* [in] */ LCID lcid,'*)
(*$HPPEMIT '            /* [in] */ WORD wFlags,'*)
(*$HPPEMIT '            /* [out][in] */ tagDISPPARAMS __RPC_FAR *pDispParams,'*)
(*$HPPEMIT '            /* [out] */ tagVARIANT __RPC_FAR *pVarResult,'*)
(*$HPPEMIT '            /* [out] */ tagEXCEPINFO __RPC_FAR *pExcepInfo,'*)
(*$HPPEMIT '            /* [out] */ UINT __RPC_FAR *puArgErr) = 0;'*)
(*$HPPEMIT '    };'*)
(*$HPPEMIT '    '*)
(*$HPPEMIT ''*)
(*$HPPEMIT 'HRESULT STDMETHODCALLTYPE IDispatch_GetTypeInfoCount_Proxy( '*)
(*$HPPEMIT '    IDispatch __RPC_FAR * This,'*)
(*$HPPEMIT '    /* [out] */ UINT __RPC_FAR *pctinfo);'*)
(*$HPPEMIT ''*)
(*$HPPEMIT 'void __RPC_STUB IDispatch_GetTypeInfoCount_Stub('*)
(*$HPPEMIT '    IRpcStubBuffer *This,'*)
(*$HPPEMIT '    IRpcChannelBuffer *_pRpcChannelBuffer,'*)
(*$HPPEMIT '    PRPC_MESSAGE _pRpcMessage,'*)
(*$HPPEMIT '    DWORD *_pdwStubPhase);'*)
(*$HPPEMIT ''*)
(*$HPPEMIT 'HRESULT STDMETHODCALLTYPE IDispatch_GetTypeInfo_Proxy( '*)
(*$HPPEMIT '    IDispatch __RPC_FAR * This,'*)
(*$HPPEMIT '    /* [in] */ UINT iTInfo,'*)
(*$HPPEMIT '    /* [in] */ LCID lcid,'*)
(*$HPPEMIT '    /* [out] */ ITypeInfo __RPC_FAR *__RPC_FAR *ppTInfo);'*)
(*$HPPEMIT ''*)
(*$HPPEMIT 'void __RPC_STUB IDispatch_GetTypeInfo_Stub('*)
(*$HPPEMIT '    IRpcStubBuffer *This,'*)
(*$HPPEMIT '    IRpcChannelBuffer *_pRpcChannelBuffer,'*)
(*$HPPEMIT '    PRPC_MESSAGE _pRpcMessage,'*)
(*$HPPEMIT '    DWORD *_pdwStubPhase);'*)
(*$HPPEMIT ''*)
(*$HPPEMIT 'HRESULT STDMETHODCALLTYPE IDispatch_GetIDsOfNames_Proxy( '*)
(*$HPPEMIT '    IDispatch __RPC_FAR * This,'*)
(*$HPPEMIT '    /* [in] */ REFIID riid,'*)
(*$HPPEMIT '    /* [size_is][in] */ LPOLESTR __RPC_FAR *rgszNames,'*)
(*$HPPEMIT '    /* [in] */ UINT cNames,'*)
(*$HPPEMIT '    /* [in] */ LCID lcid,'*)
(*$HPPEMIT '    /* [size_is][out] */ DISPID __RPC_FAR *rgDispId);'*)
(*$HPPEMIT ''*)
(*$HPPEMIT 'void __RPC_STUB IDispatch_GetIDsOfNames_Stub('*)
(*$HPPEMIT '    IRpcStubBuffer *This,'*)
(*$HPPEMIT '    IRpcChannelBuffer *_pRpcChannelBuffer,'*)
(*$HPPEMIT '    PRPC_MESSAGE _pRpcMessage,'*)
(*$HPPEMIT '    DWORD *_pdwStubPhase);'*)
(*$HPPEMIT ''*)
(*$HPPEMIT '/* [call_as] */ HRESULT STDMETHODCALLTYPE IDispatch_RemoteInvoke_Proxy( '*)
(*$HPPEMIT '    IDispatch __RPC_FAR * This,'*)
(*$HPPEMIT '    /* [in] */ DISPID dispIdMember,'*)
(*$HPPEMIT '    /* [in] */ REFIID riid,'*)
(*$HPPEMIT '    /* [in] */ LCID lcid,'*)
(*$HPPEMIT '    /* [in] */ DWORD dwFlags,'*)
(*$HPPEMIT '    /* [in] */ tagDISPPARAMS __RPC_FAR *pDispParams,'*)
(*$HPPEMIT '    /* [out] */ tagVARIANT __RPC_FAR *pVarResult,'*)
(*$HPPEMIT '    /* [out] */ tagEXCEPINFO __RPC_FAR *pExcepInfo,'*)
(*$HPPEMIT '    /* [out] */ UINT __RPC_FAR *pArgErr,'*)
(*$HPPEMIT '    /* [in] */ UINT cVarRef,'*)
(*$HPPEMIT '    /* [size_is][in] */ UINT __RPC_FAR *rgVarRefIdx,'*)
(*$HPPEMIT '    /* [size_is][out][in] */ tagVARIANT __RPC_FAR *rgVarRef);'*)
(*$HPPEMIT ''*)
(*$HPPEMIT ''*)
(*$HPPEMIT 'void __RPC_STUB IDispatch_RemoteInvoke_Stub('*)
(*$HPPEMIT '    IRpcStubBuffer *This,'*)
(*$HPPEMIT '    IRpcChannelBuffer *_pRpcChannelBuffer,'*)
(*$HPPEMIT '    PRPC_MESSAGE _pRpcMessage,'*)
(*$HPPEMIT '    DWORD *_pdwStubPhase);'*)
(*$HPPEMIT ''*)
(*$HPPEMIT '// Remove DISPID macro defined if OAIDL was not included'*)
(*$HPPEMIT '//'*)
(*$HPPEMIT '#if defined(DISPID)'*)
(*$HPPEMIT '#undef DISPID'*)
(*$HPPEMIT '#endif'*)
(*$HPPEMIT ''*)
(*$HPPEMIT '#endif  /* __IDispatch_INTERFACE_DEFINED__ */'*)
(*$HPPEMIT ''*)


interface

const
  LIBID_StdVCL: TGUID = '{EE05DFE0-5549-11D0-9EA9-0020AF3D82DA}';
  IID_IProvider: TGUID = '{6E644935-51F7-11D0-8D41-00A0248E4B9A}';
  IID_IStrings: TGUID = '{EE05DFE2-5549-11D0-9EA9-0020AF3D82DA}';
  IID_IDataBroker: TGUID = '{6539BF65-6FE7-11D0-9E8C-00A02457621F}';

type

{ Forward declarations }
{ Forward declarations: Interfaces }
  IProvider = interface;
  IProviderDisp = dispinterface;
  IStrings = interface;
  IStringsDisp = dispinterface;
  IDataBroker = interface;
  IDataBrokerDisp = dispinterface;

{ Provider interface for TClientDataSet }

  IProvider = interface(IDispatch)
    ['{6E644935-51F7-11D0-8D41-00A0248E4B9A}']
    function Get_Data: OleVariant; safecall;
    function ApplyUpdates(Delta: OleVariant; MaxErrors: Integer; out ErrorCount: Integer): OleVariant; safecall;
    function GetMetaData: OleVariant; safecall;
    function GetRecords(Count: Integer; out RecsOut: Integer): OleVariant; safecall;
    function DataRequest(Input: OleVariant): OleVariant; safecall;
    function Get_Constraints: WordBool; safecall;
    procedure Set_Constraints(Value: WordBool); safecall;
    procedure Reset(MetaData: WordBool); safecall;
    procedure SetParams(Values: OleVariant); safecall;
    property Data: OleVariant read Get_Data;
    property Constraints: WordBool read Get_Constraints write Set_Constraints;
  end;

{ DispInterface declaration for Dual Interface IProvider }

  IProviderDisp = dispinterface
    ['{6E644935-51F7-11D0-8D41-00A0248E4B9A}']
    property Data: OleVariant readonly dispid 1;
    function ApplyUpdates(Delta: OleVariant; MaxErrors: Integer; out ErrorCount: Integer): OleVariant; dispid 2;
    function GetMetaData: OleVariant; dispid 3;
    function GetRecords(Count: Integer; out RecsOut: Integer): OleVariant; dispid 4;
    function DataRequest(Input: OleVariant): OleVariant; dispid 5;
    property Constraints: WordBool dispid 6;
    procedure Reset(MetaData: WordBool); dispid 7;
    procedure SetParams(Values: OleVariant); dispid 8;
  end;

{ Collection Interface for TStrings }

  IStrings = interface(IDispatch)
    ['{EE05DFE2-5549-11D0-9EA9-0020AF3D82DA}']
    function Get_ControlDefault(Index: Integer): OleVariant; safecall;
    procedure Set_ControlDefault(Index: Integer; Value: OleVariant); safecall;
    function Count: Integer; safecall;
    function Get_Item(Index: Integer): OleVariant; safecall;
    procedure Set_Item(Index: Integer; Value: OleVariant); safecall;
    procedure Remove(Index: Integer); safecall;
    procedure Clear; safecall;
    function Add(Item: OleVariant): Integer; safecall;
    function _NewEnum: IUnknown; safecall;
    property ControlDefault[Index: Integer]: OleVariant read Get_ControlDefault write Set_ControlDefault; default;
    property Item[Index: Integer]: OleVariant read Get_Item write Set_Item;
  end;

{ DispInterface declaration for Dual Interface IStrings }

  IStringsDisp = dispinterface
    ['{EE05DFE2-5549-11D0-9EA9-0020AF3D82DA}']
    property ControlDefault[Index: Integer]: OleVariant dispid 0; default;
    function Count: Integer; dispid 1;
    property Item[Index: Integer]: OleVariant dispid 2;
    procedure Remove(Index: Integer); dispid 3;
    procedure Clear; dispid 4;
    function Add(Item: OleVariant): Integer; dispid 5;
    function _NewEnum: IUnknown; dispid -4;
  end;

{ Design-time interface for remote data modules }

  IDataBroker = interface(IDispatch)
    ['{6539BF65-6FE7-11D0-9E8C-00A02457621F}']
    function GetProviderNames: OleVariant; safecall;
  end;

{ DispInterface declaration for Dual Interface IDataBroker }

  IDataBrokerDisp = dispinterface
    ['{6539BF65-6FE7-11D0-9E8C-00A02457621F}']
    function GetProviderNames: OleVariant; dispid 22929905;
  end;

implementation


end.
