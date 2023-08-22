unit IBConst;

interface

resourcestring
  srSamples = 'Samples';
  SNoEventsRegistered  = 'You must register events before queueing them';
  SInvalidDBConnection = 'Component is not connected to an open Database';
  SInvalidDatabase     = '''''%s'''' is not connected to an InterBase database';
  SInvalidCancellation = 'You cannot call CancelEvents from within an OnEventAlert handler';
  SInvalidEvent        = 'Invalid blank event added to EventAlerter events list';
  SInvalidQueueing     = 'You cannot call QueueEvents from within an OnEventAlert handler';
  SInvalidRegistration = 'You cannot Register or Unregister events from within an OnEventAlert handler';  SMaximumEvents       = 'You can only register 15 events per EventAlerter';

implementation

end.
  
