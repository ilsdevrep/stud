unit Devices;
 { Содержит описание  процессоров (TCPU),
   а также описание самой вычислительной системы (TDecisionSystem) }

interface

uses
  Classes, GlobalTypes,PrioritetUnit, Converter;

const
       MaxDevices  = 20; { Максимальное кол-во устройств одного вида         }
       MaxTask   =   8;  { Максималное кол-во задач при многозадачном режиме }

type
   TStatus = ( Busy, Empty );// Возможные статусы устройства
   TStrategy = ( MinTime, MaxTime, MaxChild );// Стратегии

   TVertNum = record { Номер узла, находящегося на устройстве  }
      g : Byte; { Номер графа }
      v : Byte; { Номер вершины в графе }
   end;

   TStatArr = record { Массив статусов устройств }
      Vert : TVertNum;
      Stat : TStatus;
   end;



  { Описание процессора}
  TCPU = class
    public
      Status  : TStatus; { Статус устройства                       }
      FinishTime : Word; { Время окончания текущего процесса       }
      Buffer : TVertNum; { Номер узла, находящегося на устройстве  }
      StatArr : Array of TStatArr; { Массив состояний устройства во времени  }
      Koef : Real; { Коеффициент загрузки }
      constructor Create;
      procedure FindLoading; { Определяет коэффициент загрузки устройства }
  end;



   { Описание вычислительной системы }
  TDecisionSystem = class  ( TObject )

    public
      Mode : ( TimeTab, Modeling ); { Режим работы ( составление расписания или моделирование ) }
      SystemTime : Word; { Системное время        }
      CPUQuant : Byte;   { Кол-во процессоров     }
      CPU : Array[1..MaxDevices] of TCPU; { Набор процессоров }
      Strategy : TStrategy; { Стратегия выбора узлов }
      GrafQuant : Byte;     { Кол-во задач           }
      Graf : Array [1..MaxTask] of TGraf;{ Задачи    }
      FinalTime : Word;  { Общее время моделирования }
      CPUKoef : Real; { Средний коэффициент загруженности процессоров }


    protected
      function TryAssignVertex ( CPUNum : Byte ) : Boolean;
      { Производится попытка назначить на процессор следующий узел }
      procedure TryAssignReady;
      { Во время особого состояния проверяется каким вершинам из очереди
        можно присвоить статус Ready. Если все вершины-предшественники
        данного узла имеют статус Completed, то данному узлу
        присваивается статус Ready }
      procedure SetCPUFree ( CPUNum : Byte );
      { Освобождение процессора }
      function AllCompleted : Boolean;
      { Функция возвращает True, если все узлы всех задач обработаны }
      procedure MoveSystemTime;
      { Продвигает системное время до следующего ближайшего события }
      procedure ResetResult;
      { Обнуляет некоторые величины после составления расписания }
      procedure FindLoading;

    private

      function FindVertex ( CPUNum : Byte ) : TVertNum;
      { Находит следующий узел для решения на данном процессоре }

    public
      constructor Create( NCPU, Task : Byte; Strat : TStrategy; Strings : TStrings );
                                                     { Создает объект МВС }
      destructor Destroy; override; { Уничтожает объект МВС           }
      procedure MakeTimeTable;      { Создает расписание              }
      procedure Run;                { Запускает процесс моделирования }

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


procedure TCPU.FindLoading; { Определяет коэффициент загрузки устройства }
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
      { Находит следующий узел для решения на данном процессоре,
        учитывая стратегию назначения узлов и наличие/отсутствие приоритетов}
var
  i, k,j, Temp,MaxValuePrioritet : Byte;
  Find : Boolean;

begin
  Find := False;
  {поиск готового узла без приоритета}
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
  {поиск готового узла в зависимости от приоритета}
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
{ Назначает на процессор следующий узел, найденный функцией FindVertex }

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
      { Во время особого состояния проверяется каким вершинам можно
        присвоить статус Ready. Если все вершины-предшественники
        данного узла имеют статус Completed, то данному узлу
        присваивается статус Ready }
var
  i, k, c : Byte;
  Flag : Boolean;// Флаг равен True, если все вершины-предшественники решены
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
{ Освобождение процессора }
begin
  with CPU[CPUNum] do
    begin
      Graf[Buffer.g].Vertex[Buffer.v].Status := Completed;// Узел объявляется решенным
      Graf[Buffer.g].Vertex[Buffer.v].Finish := SystemTime;
      Buffer.g := 0; {    Буффер              }
      Buffer.v := 0; {           обнуляется   }
      Status := Empty;// Процессор объявляется свободным
      FinishTime := 0;
     end;
end;




function TDecisionSystem.AllCompleted : Boolean;
{ Функция возвращает True, если все узлы обработаны }
var
  i, k : Byte;
begin
  Result := True;
  for i := 1 to GrafQuant do
    for k := 1 to Graf[i].VertexQuant do
      if Graf[i].Vertex[k].Status <> Completed then Result := False;
end;






procedure TDecisionSystem.MoveSystemTime;
{ Продвигает системное время до следующего события }
var
  i : Byte;
  k, TempTime : Word;
begin
  TempTime := 65000;
  for i := 1 to CPUQuant do
    if (TempTime > CPU[i].FinishTime) and (CPU[i].FinishTime <> 0) then
       TempTime := CPU[i].FinishTime;

  { Добавляются значения в массив статусов }
  for i := 1 to CPUQuant do
    begin
      SetLength ( CPU[i].StatArr, TempTime + 1 );
      for k := (SystemTime + 1) to TempTime do
        begin
          CPU[i].StatArr[k].Stat := CPU[i].Status;
          CPU[i].StatArr[k].Vert := CPU[i].Buffer;
        end;
    end;

 SystemTime := TempTime; // Системное время продвигается до очередного события
end;



procedure TDecisionSystem.ResetResult;
      { Обнуляет некоторые величины после составления расписания }
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
{ Создает расписание }
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
{ Запускает процесс моделирования }
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
