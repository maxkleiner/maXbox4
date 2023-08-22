unit xrtl_util_ResourceStrings;

{$INCLUDE xrtl.inc}

interface

resourcestring
  SXRTLNotImplemented    = 'Not implemented';
  SXRTLInvalidOperation1 = 'Invalid operation %s';
  SXRTLInvalidOperation2 = '.%s';
  SXRTLInvalidOperation3 = ': %s';

  SXRTLArrayInvalidPosition         = 'Array index %d is invalid on %s';
  SXRTLArrayInvalidDuplicate        = 'Duplicates are not allowed';
  SXRTLQueueEmpty                   = 'Queue is empty in %s';
  SXRTLForwardOnlyIteratorException = 'Only forward iteration is possible';
  SXRTLAlreadyAtBeginException      = 'Already at begin';
  SXRTLAlreadyAtEndException        = 'Already at end';

implementation

end.
