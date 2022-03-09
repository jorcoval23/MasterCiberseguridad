PROGRAM sorting
  VAR_IN_OUT
    Grafcet : INT;
  END_VAR
  VAR
    AtScaleEntry AT %IX100.0 : BOOL;
    AtScale AT %IX100.1 : BOOL;
    AtScaleExit AT %IX100.2 : BOOL;
    AtLeftEntry AT %IX100.3 : BOOL;
    AtExitLeft AT %IX100.4 : BOOL;
    AtForwardEntry AT %IX100.5 : BOOL;
    AtExitFront AT %IX100.6 : BOOL;
    AtRightEntry AT %IX100.7 : BOOL;
    AtExitRight AT %IX100.8 : BOOL;
    Start AT %IX100.9 : BOOL;
    Reset AT %IX100.10 : BOOL;
    Stop AT %IX100.11 : BOOL;
    WeightSensor AT %IW100 : WORD;
    EntryConveyor AT %QX100.0 : BOOL;
    LoadScale AT %QX100.1 : BOOL;
    SendLeft AT %QX100.2 : BOOL;
    LeftConveyor AT %QX100.3 : BOOL;
    SendRight AT %QX100.4 : BOOL;
    RightConveyor AT %QX100.5 : BOOL;
    SendForward AT %QX100.6 : BOOL;
    FrontConveyor AT %QX100.7 : BOOL;
    StartLight AT %QX100.8 : BOOL;
    ResetLight AT %QX100.9 : BOOL;
    StopLight AT %QX100.10 : BOOL;
  END_VAR
  VAR
    RisingScaleEntry : R_TRIG;
    FallingScaleEntry : F_TRIG;
    RisingScaleExit : R_TRIG;
    FallingScaleExit : F_TRIG;
    RisingLeftEntry : R_TRIG;
    RisingFrontEntry : R_TRIG;
    RisingRightEntry : R_TRIG;
    RisingLeftExit : R_TRIG;
    RisingFrontExit : R_TRIG;
    RisingRightExit : R_TRIG;
    RisingScale : R_TRIG;
  END_VAR
  VAR
    Weight AT %QW300 : WORD;
  END_VAR
  VAR_IN_OUT
    pesar : BOOL;
  END_VAR
  VAR
    StopHMI AT %QX100.12 : BOOL;
    StartHMI AT %QX100.11 : BOOL;
    CajasGrandes AT %QW302 : INT;
    CajasPequenas AT %QW304 : INT;
    CajasMedianas AT %QW306 : INT;
  END_VAR
  VAR
    TempPesaje : TON;
  END_VAR
  VAR
    ResetContadores AT %QX100.13 : BOOL;
  END_VAR

  (* Rising and Falling Edges *)
  RisingScaleEntry(
       CLK := AtScaleEntry);
       
  FallingScaleEntry(
       CLK := AtScaleEntry);
       
  RisingScaleExit(
       CLK := AtScaleExit);
       
  FallingScaleExit(
       CLK := AtScaleExit);
       
  RisingLeftEntry(
       CLK := AtLeftEntry);
       
  RisingFrontEntry(
       CLK := AtForwardEntry);
       
  RisingRightEntry(
       CLK := AtRightEntry);
       
  RisingLeftExit(
       CLK := AtExitLeft);
       
  RisingFrontExit(
       CLK := AtExitFront);
       
  RisingRightExit(
       CLK := AtExitRight);
       
  RisingScale(
       CLK := AtScale);



  (*                          *)


  (* ESTADOS DEL PROCESO      *)
  IF Grafcet=0 AND (Start OR StartHMI) THEN
    Grafcet:=1;
  END_IF;

  IF Grafcet=1 AND RisingScaleEntry.Q THEN
    Grafcet:=2;
  END_IF;

  IF Grafcet=2 AND RisingScale.Q THEN
    Grafcet:=3;
  END_IF;

  IF Grafcet=3 AND TempPesaje.Q THEN
    Grafcet:=4;
  END_IF;

  IF Grafcet=4 AND (RisingLeftEntry.Q OR RisingRightEntry.Q OR RisingFrontEntry.Q) THEN
    Grafcet:=1;
  END_IF;

  IF Stop=0 OR StopHMI=1 THEN
    Grafcet:=0;
  END_IF;
  (*                          *)

  (* SALIDAS DE PROCESO       *)
  TempPesaje(
       IN := pesar,
       PT := T#1s);

  IF Grafcet=0 THEN
    StopLight:=true;
    StartLight:=false;
    
    SendLeft:=false;
    SendForward:=false;
    SendRight:=false;
  ELSE
    StopLight:=false;
    StartLight:=true;
  END_IF;

  IF Grafcet=1 THEN
    EntryConveyor:=true;
  ELSE
    EntryConveyor:=false;
  END_IF;
    
  IF Grafcet=1 OR Grafcet=2 OR Grafcet=4 THEN
    LoadScale:=true;
  ELSE 
    LoadScale:=false;
  END_IF;

  IF Grafcet=1 THEN
    Weight:=0;
  END_IF;

  IF Grafcet=3 THEN
    pesar:=true;
    Weight:=WeightSensor;
  ELSE
    pesar:=false;
  END_IF;


  IF grafcet<>0 THEN
    IF Weight>50 AND Weight<=400 THEN
      SendLeft:=true;
      SendForward:=true;
      SendRight:=false;
    ELSIF Weight>400 AND Weight<600 THEN
      SendLeft:=false;
      SendForward:=true;
      SendRight:=false;
    ELSIF Weight>=600 THEN
      SendLeft:=false;
      SendForward:=true;
      SendRight:=true;
    END_IF;
  END_IF;



  IF RisingLeftEntry.Q THEN
    SendLeft:=false;
  END_IF;

  IF RisingFrontEntry.Q THEN
    SendForward:=false;
  END_IF;

  IF RisingRightEntry.Q THEN
    SendRight:=false;
  END_IF;

  IF Grafcet=0 THEN
    LeftConveyor:=false;
    FrontConveyor:=false;
    RightConveyor:=false;
  ELSE
    LeftConveyor:=true;
    FrontConveyor:=true;
    RightConveyor:=true;
  END_IF;

    
  (*                          *)
  IF RisingLeftExit.Q THEN
    CajasPequenas:=CajasPequenas+1;
  END_IF;

  IF RisingFrontExit.Q THEN
    CajasMedianas:=CajasMedianas+1;
  END_IF;

  IF RisingRightExit.Q THEN
    CajasGrandes:=CajasGrandes+1;
  END_IF;


  IF ResetContadores=true THEN
    CajasGrandes:=0;
    CajasPequenas:=0;
    CajasMedianas:=0;
    ResetContadores:=false;
  END_IF;

END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : sorting;
  END_RESOURCE
END_CONFIGURATION
