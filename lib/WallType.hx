package lib;

enum WallType {
  None;
  Solid;
  Invisible;
  Trigger(f:Entity->Void);
  Tunnel;
}
