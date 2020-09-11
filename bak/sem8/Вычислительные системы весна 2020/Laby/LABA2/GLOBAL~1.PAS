unit GlobalTypes;
{ Модуль объявляет общие типы TVertex(вершина), TGraf(граф) }

interface
uses
  Classes, Extctrls, Controls, Graphics;

const
  MaxVert = 30; { Максимальное кол-во вершин в графе }

type

{ Описание вершины }
TVertex = record
    Level : Byte;             { Ярус вершины в графе          }
    DecisionTime : Word;      { Время решения вершины         }
    ParentVertexQuant : Byte; { Кол-во вершин-предшественников}
    ParentVertexNumbs : array [1..MaxVert] of Byte;{ Номера вершин-предшественников }
    ChildVertexQuant : Byte;  { Кол-во вершин-последователей  }
    ChildVertexNumbs : array [1..MaxVert] of Byte;{ Номера вершин-последователей }
    PlaceStatus : ( inQuaue, inCPU ); { Местоположение }
    Status : ( NotReady, Ready, Completed ); { Состояние узла }
    CPUNumber  : Byte;   { Номер процессора, на котором обрабатывается данный узел     }
    OnCritWay  : Boolean;{ Показывает, принадлежит ли данная вершина критическому пути }
    NextVertex : Byte;   { Номер вершины, в которую ведет ветвь с нулевой нагрузкой    }
    Start, Finish : Word;
end;

{ Описание графа }
TGraf = class
   Prioritet : byte; 
   VertexQuant : Byte; { Кол-во вершин в графе }
   Vertex : array[1..MaxVert] of TVertex; { Описание графа как "массива вершин" }
   MaxLevel : Byte; { Максимальный ярус в графе }
   MinTime : Word; { Минимальное время, за которое задача может быть решена }
   MaxTime : Word; { Максимальное время, необходимое для решения задачи }

   procedure SetCritWay;
   { Определяет вершины, принадлежащие критическому пути }

   procedure DrawGraf ( var DrawBox : TPaintBox; ImList : TImageList );
   { Определяет внешний вид графа и рисует его на поверхности объекта
     DrawBox, используя изображения вершин, хранящиеся в объекте ImList }

end;




implementation


procedure TGraf.DrawGraf ( var DrawBox : TPaintBox; ImList : TImageList );
var
  VertexInLevel : Array [1..MaxVert] of Byte;// Кол-во вершин в уровне
  PosInLevel : Array [1..MaxVert] of Word;// Расстояние между вершинами
  X, Y : Array [1..MaxVert] of Word; //Координаты всех вершин
  XPos, YPos : Word;
  i, k : Byte;
  st : string[4];
  VertInterval : Word;

begin
  { Определяются координаты вершин }

  for i := 1 to MaxLevel do VertexInLevel[i] := 0;
  for i := 1 to VertexQuant do VertexInLevel[Vertex[i].Level] :=
                     VertexInLevel[Vertex[i].Level] + 1;
  for i := 1 to MaxLevel do PosInLevel[i] :=
               Round ( DrawBox.Width/( VertexInLevel[i] + 1 ));
  VertInterval := Round ( (DrawBox.Height) / MaxLevel );
  for k := 1 to MaxLevel do
    begin
      XPos := PosInLevel[k] +25;
      YPos := (k * VertInterval) - 50;
      for i := 1 to VertexQuant do
        begin
          if Vertex[i].Level = k then
            begin
              X[i] := XPos;
              Y[i] := Ypos;
              XPos := XPos + PosInLevel[k];
            end;
        end;
    end;

  { Изображаются линии связей }
  for i := 1 to VertexQuant do
    begin
      DrawBox.Canvas.MoveTo ( X[i], Y[i] );
      if Vertex[i].ChildVertexQuant > 0 then
        begin
          for k := 1 to Vertex[i].ChildVertexQuant do
            begin
              if (Vertex[i].OnCritWay) and
                 (Vertex[Vertex[i].ChildVertexNumbs[k]].OnCritWay)and
                 (Vertex[Vertex[i].ChildVertexNumbs[k]].Level=Vertex[i].Level+1)
                 then  DrawBox.Canvas.Pen.Color := clRed
              else DrawBox.Canvas.Pen.Color := clOlive;
              DrawBox.Canvas.Pen.Width := 2;
              DrawBox.Canvas.LineTo
                       ( X[Vertex[i].ChildVertexNumbs[k]],
                                      Y[Vertex[i].ChildVertexNumbs[k]] );
              DrawBox.Canvas.MoveTo ( X[i], Y[i] );
           end;
        end;
    end;

   { Изображаются вершины }
  for i := 1 to VertexQuant do
    begin
      ImList.Draw ( DrawBox.Canvas, X[i]-20, Y[i]-20, i-1, True );
      Str ( Vertex[i].DecisionTime, st );
      DrawBox.Canvas.Font.Color := clLime;
      DrawBox.Canvas.Font.Size := 10;
      DrawBox.Canvas.TextOut ( X[i] + 20, Y[i] - 10, st );
    end;
end;
{ Окончание реализации функции TGraf.DrawGraf }






{ Реализация процедуры определения критического пути }

procedure TGraf.SetCritWay;
{ Определяет вершины, принадлежащие критическому пути }
type

  TTimeArr = Array [1..MaxVert] of Word; { Тип, описывающий результат работы
                                           процедур SetDownTime и SetUpTime }
var
  DownTime, UpTime : TTimeArr;
  



function WayQuant ( Graf : TGraf ) : Byte;
{ Функция, определяющая кол-во путей в графе }
var
  n : Byte;
begin
  Result := 1;
  for n := 1 to Graf.VertexQuant do
    begin
      if Graf.Vertex[n].ChildVertexQuant > 1 then
        begin
          Result := Result +  Graf.Vertex[n].ChildVertexQuant - 1;
        end
      else
        begin
          Continue;
        end;
    end;
end;




procedure SetDownTime;
{ Определяет времена окончания выполнения вершин при, движении сверху вниз }
var
  DT : TTimeArr;
  i, n : Byte;
begin
  for i := 1 to VertexQuant do DownTime[i] := 0;
  DownTime[1] := Vertex[1].DecisionTime;
  for n := 1 to (VertexQuant - 1) do
    begin
      for i := 1 to Vertex[n].ChildVertexQuant do
        begin
          DT[Vertex[n].ChildVertexNumbs[i]] := DownTime[n] +
            Vertex[Vertex[n].ChildVertexNumbs[i]].DecisionTime;
          if DT[Vertex[n].ChildVertexNumbs[i]] >
                                   DownTime[Vertex[n].ChildVertexNumbs[i]]
          then DownTime[Vertex[n].ChildVertexNumbs[i]] :=
                                       DT[Vertex[n].ChildVertexNumbs[i]];
        end;
    end;
end;



procedure SetUpTime;
{ Определяет времена окончания выполнения вершин при, движении снизу вверх }
var
  i, k : Byte;
begin
  for i := 1 to VertexQuant do UpTime[i] := DownTime[VertexQuant];
  for i := VertexQuant downto 2 do
    begin
      for k := 1 to Vertex[i].ParentVertexQuant do
        begin
          if UpTime[Vertex[i].ParentVertexNumbs[k]]  > (UpTime[i] -  Vertex[i].DecisionTime)
            then
             UpTime[Vertex[i].ParentVertexNumbs[k]] := (UpTime[i]  - Vertex[i].DecisionTime);
        end;
    end;
end;








procedure CompareTimes;
{ Сравнивает времена DownTime и UpTime для каждой вершины графа и присваивает
  значения свойству OnCritWay каждой вершины  }
var
  i : Byte;
begin
  for i := 1 to VertexQuant do Vertex[i].OnCritWay := False;
  for i := 1 to VertexQuant do
    begin
      if DownTime[i] = UpTime[i] then  Vertex[i].OnCritWay := True;
    end;
  MinTime := DownTime[VertexQuant];
  MaxTime := 0;
  for i := 1 to VertexQuant do MaxTime := MaxTime + Vertex[i].DecisionTime;
end;

begin
  SetDownTime;

  SetUpTime;
  CompareTimes;
end;

end.
