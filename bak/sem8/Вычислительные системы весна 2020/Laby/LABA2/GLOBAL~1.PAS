unit GlobalTypes;
{ ������ ��������� ����� ���� TVertex(�������), TGraf(����) }

interface
uses
  Classes, Extctrls, Controls, Graphics;

const
  MaxVert = 30; { ������������ ���-�� ������ � ����� }

type

{ �������� ������� }
TVertex = record
    Level : Byte;             { ���� ������� � �����          }
    DecisionTime : Word;      { ����� ������� �������         }
    ParentVertexQuant : Byte; { ���-�� ������-����������������}
    ParentVertexNumbs : array [1..MaxVert] of Byte;{ ������ ������-���������������� }
    ChildVertexQuant : Byte;  { ���-�� ������-��������������  }
    ChildVertexNumbs : array [1..MaxVert] of Byte;{ ������ ������-�������������� }
    PlaceStatus : ( inQuaue, inCPU ); { �������������� }
    Status : ( NotReady, Ready, Completed ); { ��������� ���� }
    CPUNumber  : Byte;   { ����� ����������, �� ������� �������������� ������ ����     }
    OnCritWay  : Boolean;{ ����������, ����������� �� ������ ������� ������������ ���� }
    NextVertex : Byte;   { ����� �������, � ������� ����� ����� � ������� ���������    }
    Start, Finish : Word;
end;

{ �������� ����� }
TGraf = class
   Prioritet : byte; 
   VertexQuant : Byte; { ���-�� ������ � ����� }
   Vertex : array[1..MaxVert] of TVertex; { �������� ����� ��� "������� ������" }
   MaxLevel : Byte; { ������������ ���� � ����� }
   MinTime : Word; { ����������� �����, �� ������� ������ ����� ���� ������ }
   MaxTime : Word; { ������������ �����, ����������� ��� ������� ������ }

   procedure SetCritWay;
   { ���������� �������, ������������� ������������ ���� }

   procedure DrawGraf ( var DrawBox : TPaintBox; ImList : TImageList );
   { ���������� ������� ��� ����� � ������ ��� �� ����������� �������
     DrawBox, ��������� ����������� ������, ���������� � ������� ImList }

end;




implementation


procedure TGraf.DrawGraf ( var DrawBox : TPaintBox; ImList : TImageList );
var
  VertexInLevel : Array [1..MaxVert] of Byte;// ���-�� ������ � ������
  PosInLevel : Array [1..MaxVert] of Word;// ���������� ����� ���������
  X, Y : Array [1..MaxVert] of Word; //���������� ���� ������
  XPos, YPos : Word;
  i, k : Byte;
  st : string[4];
  VertInterval : Word;

begin
  { ������������ ���������� ������ }

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

  { ������������ ����� ������ }
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

   { ������������ ������� }
  for i := 1 to VertexQuant do
    begin
      ImList.Draw ( DrawBox.Canvas, X[i]-20, Y[i]-20, i-1, True );
      Str ( Vertex[i].DecisionTime, st );
      DrawBox.Canvas.Font.Color := clLime;
      DrawBox.Canvas.Font.Size := 10;
      DrawBox.Canvas.TextOut ( X[i] + 20, Y[i] - 10, st );
    end;
end;
{ ��������� ���������� ������� TGraf.DrawGraf }






{ ���������� ��������� ����������� ������������ ���� }

procedure TGraf.SetCritWay;
{ ���������� �������, ������������� ������������ ���� }
type

  TTimeArr = Array [1..MaxVert] of Word; { ���, ����������� ��������� ������
                                           �������� SetDownTime � SetUpTime }
var
  DownTime, UpTime : TTimeArr;
  



function WayQuant ( Graf : TGraf ) : Byte;
{ �������, ������������ ���-�� ����� � ����� }
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
{ ���������� ������� ��������� ���������� ������ ���, �������� ������ ���� }
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
{ ���������� ������� ��������� ���������� ������ ���, �������� ����� ����� }
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
{ ���������� ������� DownTime � UpTime ��� ������ ������� ����� � �����������
  �������� �������� OnCritWay ������ �������  }
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
