unit Devices;
 { �������� ��������  ����������� (TCPU),
   � ����� �������� ����� �������������� ������� (TDecisionSystem) }

interface

uses
  Classes, GlobalTypes,PrioritetUnit, Converter;

const
       MaxDevices  = 20; { ������������ ���-�� ��������� ������ ����         }
       MaxTask   =   8;  { ����������� ���-�� ����� ��� ������������� ������ }

type
   TStatus = ( Busy, Empty );// ��������� ������� ����������
   TStrategy = ( MinTime, MaxTime, MaxChild );// ���������

   TVertNum = record { ����� ����, ������������ �� ����������  }
      g : Byte; { ����� ����� }
      v : Byte; { ����� ������� � ����� }
   end;

   TStatArr = record { ������ �������� ��������� }
      Vert : TVertNum;
      Stat : TStatus;
   end;



  { �������� ����������}
  TCPU = class
    public
      Status  : TStatus; { ������ ����������                       }
      FinishTime : Word; { ����� ��������� �������� ��������       }
      Buffer : TVertNum; { ����� ����, ������������ �� ����������  }
      StatArr : Array of TStatArr; { ������ ��������� ���������� �� �������  }
      Koef : Real; { ����������� �������� }
      constructor Create;
      procedure FindLoading; { ���������� ����������� �������� ���������� }
  end;



   { �������� �������������� ������� }
  TDecisionSystem = class  ( TObject )

    public
      Mode : ( TimeTab, Modeling ); { ����� ������ ( ����������� ���������� ��� ������������� ) }
      SystemTime : Word; { ��������� �����        }
      CPUQuant : Byte;   { ���-�� �����������     }
      CPU : Array[1..MaxDevices] of TCPU; { ����� ����������� }
      Strategy : TStrategy; { ��������� ������ ����� }
      GrafQuant : Byte;     { ���-�� �����           }
      Graf : Array [1..MaxTask] of TGraf;{ ������    }
      FinalTime : Word;  { ����� ����� ������������� }
      CPUKoef : Real; { ������� ����������� ������������� ����������� }


    protected
      function TryAssignVertex ( CPUNum : Byte ) : Boolean;
      { ������������ ������� ��������� �� ��������� ��������� ���� }
      procedure TryAssignReady;
      { �� ����� ������� ��������� ����������� ����� �������� �� �������
        ����� ��������� ������ Ready. ���� ��� �������-���������������
        ������� ���� ����� ������ Completed, �� ������� ����
        ������������� ������ Ready }
      procedure SetCPUFree ( CPUNum : Byte );
      { ������������ ���������� }
      function AllCompleted : Boolean;
      { ������� ���������� True, ���� ��� ���� ���� ����� ���������� }
      procedure MoveSystemTime;
      { ���������� ��������� ����� �� ���������� ���������� ������� }
      procedure ResetResult;
      { �������� ��������� �������� ����� ����������� ���������� }
      procedure FindLoading;

    private

      function FindVertex ( CPUNum : Byte ) : TVertNum;
      { ������� ��������� ���� ��� ������� �� ������ ���������� }

    public
      constructor Create( NCPU, Task : Byte; Strat : TStrategy; Strings : TStrings );
                                                     { ������� ������ ��� }
      destructor Destroy; override; { ���������� ������ ���           }
      procedure MakeTimeTable;      { ������� ����������              }
      procedure Run;                { ��������� ������� ������������� }

  end;


var
  DecisionSystem : TDecisionSystem;


implementation

constructor TCPU.Create;
begin
  inherited Create;
  SetLength ( StatArr, 1 );
  FinishTime := 0;
  Status := Empty;
  Buffer.g := 0;
  Buffer.v := 0;
end;


procedure TCPU.FindLoading; { ���������� ����������� �������� ���������� }
var
  i, f : Word;
begin
  i := 0;
  for f := 1 to High ( StatArr ) do if StatArr[f].Stat = Busy then i := i + 1;
  Koef := i / High ( StatArr ) * 100;
end;



procedure TDecisionSystem.FindLoading;
var
  i : Byte;
  LCPUKoef: Real;
begin
  LCPUKoef := 0;
  for i := 1 to CPUQuant do LCPUKoef := LCPUKoef + CPU[i].Koef;
  CPUKoef := LCPUKoef / CPUQuant;

end;


constructor TDecisionSystem.Create ( NCPU, Task : Byte; Strat : TStrategy;
                                                        Strings : TStrings );
var
   i, k : Byte;
begin
  inherited Create;
  CPUQuant := NCPU;
  for i := 1 to CPUQuant do CPU[i] := TCPU.Create;
  Strategy := Strat;
  GrafQuant := Task;
  for i := 1 to GrafQuant do
    begin
      Graf[i] := Convert ( Strings[i-1] );
      Graf[i].Prioritet:=Prior[i];
      Graf[i].SetCritWay;
    end;
  SystemTime := 0;
  for i := 1 to GrafQuant do
    for k := 1 to Graf[i].VertexQuant do Graf[i].Vertex[k].PlaceStatus := inQuaue;
end;




destructor TDecisionSystem.Destroy;
var
   i : Byte;
begin
  for i := 1 to CPUQuant do CPU[i].Free;
  for i := 1 to GrafQuant do Graf[i].Free;
  GrafQuant := 0;
  inherited Destroy;
end;





function TDecisionSystem.FindVertex ( CPUNum : Byte ) : TVertNum;
      { ������� ��������� ���� ��� ������� �� ������ ����������,
        �������� ��������� ���������� ����� � �������/���������� �����������}
var
  i, k,j, Temp,MaxValuePrioritet : Byte;
  Find : Boolean;

begin
  Find := False;
  {����� �������� ���� ��� ����������}
  if PrioritetUnit.PrioritetFlag=False then
   begin
    case Strategy of

    MaxTime:
      begin
        Temp := 0;
        for i := GrafQuant downto 1 do
          for k := Graf[i].VertexQuant downto 1 do
            if ( Graf[i].Vertex[k].DecisionTime >= Temp ) and
               ( Graf[i].Vertex[k].Status = Ready ) and
               ( Graf[i].Vertex[k].PlaceStatus = InQuaue ) and
               ( (Graf[i].Vertex[k].CPUNumber = CPUNum) or (Graf[i].Vertex[k].CPUNumber = 0) ) then
                 begin
                   Temp := Graf[i].Vertex[k].DecisionTime;
                   Result.g := i;
                   Result.v := k;
                   Find := True;
                 end;
      end;

    MinTime:
       begin
        Temp := 255;
        for i :=GrafQuant downto 1 do
          for k := Graf[i].VertexQuant downto 1 do
            if ( Graf[i].Vertex[k].DecisionTime <= Temp ) and
               ( Graf[i].Vertex[k].Status = Ready ) and
               ( Graf[i].Vertex[k].PlaceStatus = InQuaue ) and
               ( (Graf[i].Vertex[k].CPUNumber = CPUNum) or (Graf[i].Vertex[k].CPUNumber = 0) ) then
                 begin
                   Temp := Graf[i].Vertex[k].DecisionTime;
                   Result.g := i;
                   Result.v := k;
                   Find := True;
                 end;
      end;

    MaxChild:
      begin
        Temp := 0;
        for i :=GrafQuant downto  1 do
          for k :=Graf[i].VertexQuant downto 1 do
            if ( Graf[i].Vertex[k].ChildVertexQuant >= Temp ) and
               ( Graf[i].Vertex[k].Status = Ready ) and
               ( Graf[i].Vertex[k].PlaceStatus = InQuaue ) and
               ( (Graf[i].Vertex[k].CPUNumber = CPUNum) or (Graf[i].Vertex[k].CPUNumber = 0) ) then
                 begin
                   Temp := Graf[i].Vertex[k].ChildVertexQuant;
                   Result.g := i;
                   Result.v := k;
                   Find := True;
                 end;
      end;

    end;
  end;
  {����� �������� ���� � ����������� �� ����������}
  if PrioritetUnit.PrioritetFlag=True then
   begin
    MaxValuePrioritet:=Graf[1].Prioritet;
    for i:=2 to GrafQuant do
    if MaxValuePrioritet < Graf[i].Prioritet then MaxValuePrioritet:=Graf[i].Prioritet;

     case Strategy of

     MaxTime:
       begin
        j:=MaxValuePrioritet;
        repeat
         Temp := 0;
         for i :=GrafQuant downto 1 do
           if( Graf[i].Prioritet=j)then
            for k := 1 to Graf[i].VertexQuant do
             if ( Graf[i].Vertex[k].DecisionTime >= Temp ) and
                ( Graf[i].Vertex[k].Status = Ready ) and
                ( Graf[i].Vertex[k].PlaceStatus = InQuaue ) and
                ( (Graf[i].Vertex[k].CPUNumber = CPUNum) or (Graf[i].Vertex[k].CPUNumber = 0) ) then
                 begin
                   Temp := Graf[i].Vertex[k].DecisionTime;
                   Result.g := i;
                   Result.v := k;
                   Find := True;
                 end;
         j:=j-1;
        until j<1;
       end;

     MinTime:
       begin
        j:= MaxValuePrioritet;
        repeat
         Temp := 255;
         for i := GrafQuant downto 1 do
          if ( Graf[i].Prioritet=j) then
           for k :=  Graf[i].VertexQuant  downto 1 do
             if( Graf[i].Vertex[k].DecisionTime <= Temp ) and
               ( Graf[i].Vertex[k].Status = Ready ) and
               ( Graf[i].Vertex[k].PlaceStatus = InQuaue ) and
               ( (Graf[i].Vertex[k].CPUNumber = CPUNum) or (Graf[i].Vertex[k].CPUNumber = 0) ) then
                 begin
                   Temp := Graf[i].Vertex[k].DecisionTime;
                   Result.g := i;
                   Result.v := k;
                   Find := True;
                 end;
         j:=j-1;
        until j<1;
      end;

     MaxChild:
      begin
       j:= MaxValuePrioritet;
        repeat
         Temp := 0;
         for i := GrafQuant downto 1  do
          if ( Graf[i].Prioritet=j) then
           for k :=  Graf[i].VertexQuant  downto 1 do
            if ( Graf[i].Vertex[k].ChildVertexQuant >= Temp ) and
               ( Graf[i].Vertex[k].Status = Ready ) and
               ( Graf[i].Vertex[k].PlaceStatus = InQuaue ) and
               ( (Graf[i].Vertex[k].CPUNumber = CPUNum) or (Graf[i].Vertex[k].CPUNumber = 0) ) then
                 begin
                   Temp := Graf[i].Vertex[k].ChildVertexQuant;
                   Result.g := i;
                   Result.v := k;
                   Find := True;
                 end;

         j:=j-1;
        until j<1;
       end;
     end;


  end;
  if not Find then
    begin
      Result.g := 0;
      Result.v := 0;
    end;
end;






function TDecisionSystem.TryAssignVertex ( CPUNum : Byte ) : Boolean;
{ ��������� �� ��������� ��������� ����, ��������� �������� FindVertex }

begin
  with CPU[CPUNum] do
    begin
      if (FindVertex ( CPUNum ).g <> 0) and (FindVertex ( CPUNum ).v <> 0) then
        begin
          Buffer := FindVertex ( CPUNum );
          Graf[Buffer.g].Vertex[Buffer.v].PlaceStatus := inCPU;
          if Graf[Buffer.g].Vertex[Buffer.v].CPUNumber = 0 then Graf[Buffer.g].Vertex[Buffer.v].CPUNumber := CPUNum;
          if Graf[Buffer.g].Vertex[Buffer.v].NextVertex <> 0 then
                Graf[Buffer.g].Vertex[Graf[Buffer.g].Vertex[Buffer.v].NextVertex].CPUNUmber := CPUNum;

       FinishTime := SystemTime + Graf[Buffer.g ].Vertex[Buffer.v ].DecisionTime;
       Status := Busy;
       Result := True;
        end
      else
        begin
          Status := Empty;
          Result := False;
        end;
    end;
end;





procedure TDecisionSystem.TryAssignReady;
      { �� ����� ������� ��������� ����������� ����� �������� �����
        ��������� ������ Ready. ���� ��� �������-���������������
        ������� ���� ����� ������ Completed, �� ������� ����
        ������������� ������ Ready }
var
  i, k, c : Byte;
  Flag : Boolean;// ���� ����� True, ���� ��� �������-��������������� ������
begin
  for i :=  1 to  GrafQuant do
    for k :=2 to Graf[i].VertexQuant   do
      begin
        Flag := True;
        for c := 1 to Graf[i].Vertex[k].ParentVertexQuant do
          if Graf[i].Vertex[Graf[i].Vertex[k].ParentVertexNumbs[c]].Status <>
               Completed then Flag := False;
        if (Flag) and (Graf[i].Vertex[k].Status <> Completed) then Graf[i].Vertex[k].Status := Ready;
      end;
end;






procedure TDecisionSystem.SetCPUFree ( CPUNum : Byte );
{ ������������ ���������� }
begin
  with CPU[CPUNum] do
    begin
      Graf[Buffer.g].Vertex[Buffer.v].Status := Completed;// ���� ����������� ��������
      Graf[Buffer.g].Vertex[Buffer.v].Finish := SystemTime;
      Buffer.g := 0; {    ������              }
      Buffer.v := 0; {           ����������   }
      Status := Empty;// ��������� ����������� ���������
      FinishTime := 0;
     end;
end;




function TDecisionSystem.AllCompleted : Boolean;
{ ������� ���������� True, ���� ��� ���� ���������� }
var
  i, k : Byte;
begin
  Result := True;
  for i := 1 to GrafQuant do
    for k := 1 to Graf[i].VertexQuant do
      if Graf[i].Vertex[k].Status <> Completed then Result := False;
end;






procedure TDecisionSystem.MoveSystemTime;
{ ���������� ��������� ����� �� ���������� ������� }
var
  i : Byte;
  k, TempTime : Word;
begin
  TempTime := 65000;
  for i := 1 to CPUQuant do
    if (TempTime > CPU[i].FinishTime) and (CPU[i].FinishTime <> 0) then
       TempTime := CPU[i].FinishTime;

  { ����������� �������� � ������ �������� }
  for i := 1 to CPUQuant do
    begin
      SetLength ( CPU[i].StatArr, TempTime + 1 );
      for k := (SystemTime + 1) to TempTime do
        begin
          CPU[i].StatArr[k].Stat := CPU[i].Status;
          CPU[i].StatArr[k].Vert := CPU[i].Buffer;
        end;
    end;

 SystemTime := TempTime; // ��������� ����� ������������ �� ���������� �������
end;



procedure TDecisionSystem.ResetResult;
      { �������� ��������� �������� ����� ����������� ���������� }
var
  i, k : Byte;
begin
  SystemTime := 0;
  for i := 1 to CPUQuant do
    with CPU[i] do
      begin
     
        Status := Empty;
        FinishTime := 0;
        SetLength ( StatArr, 1 );
        Buffer.g := 0;
        Buffer.v := 0;
      end;

  for i := 1 to GrafQuant do
    for k := 1 to Graf[i].VertexQuant do
      with Graf[i].Vertex[k] do
        begin
          if k = 1 then  Status := Ready
          else Status := notReady;
          PlaceStatus := inQuaue;
        end;
end;




procedure TDecisionSystem.MakeTimeTable;
{ ������� ���������� }
var
  i : Byte;
begin
  Mode := TimeTab;
  while not (AllCompleted) do
    begin
      for i := 1 to CPUQuant do
        if CPU[i].Status = Empty then TryAssignVertex(i);
      MoveSystemTime;
      for i := 1 to CPUQuant do
        if CPU[i].FinishTime = SystemTime then SetCPUFree ( i );
      TryAssignReady;
    end;
end;


procedure TDecisionSystem.Run;
{ ��������� ������� ������������� }
var
  i : Byte;
begin
  ResetResult;
  Mode := Modeling;
  while not (AllCompleted) do
    begin
      for i := 1 to CPUQuant do
        if CPU[i].Status = Empty then TryAssignVertex(i);

      MoveSystemTime;
      for i := 1 to CPUQuant do
      if CPU[i].FinishTime = SystemTime then SetCPUFree ( i );
      TryAssignReady;
    end;
  FinalTime := SystemTime;
  for i := 1 to CPUQuant do CPU[i].FindLoading;
  FindLoading;
end;





end.
