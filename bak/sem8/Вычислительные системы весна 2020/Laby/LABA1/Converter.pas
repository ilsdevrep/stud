unit Converter;
{ Модуль объявляет функцию Convert, которая преобразует данные из .dat файла
  в переменную типа TGraf. }

interface

uses GlobalTypes, Classes, Extctrls, Controls, Graphics ;


function Convert ( AFileName : String ) : TGraf; { Функция конвертации
      .dat-файла в тип TGraf }

{procedure DrawFile ( FileName : string; var DrawBox : TPaintBox; ImList : TImageList ); }



implementation

function Convert ( AFileName : String ) : TGraf; export;{ Функция конвертации
.dat-файла в тип Graf }

var
  ADatFile : System.Text;{ Переменная типа "Текстовый файл" }
  AFileLine : String; { Переменная, содержащая текущую строку .dat файла }
  k, t, r, c, f, i, StLeng : Byte; { Различные счётчики }
  Code : Integer; { Код результата преобразования символов в числа }
  St : String;
  TempArray : Array [1..MaxVert, 1..MaxVert] of Byte; { Временный массив }



begin

  { Этап1: Считывание информации из .dat-файла }
  Assign (ADatFile, AFileName);
  Reset (ADatFile);
  Result := TGraf.Create;
  r := 0;

  while not Eof( ADatFile ) do
    begin
      ReadLn (ADatFile, AFileLine); // Считывание строки из .dat файла
      r := r + 1;
      StLeng := Length ( AFileLine ); // Определение длины строки

      { Определяется кол-во вершин графа }
      if r = 1 then
        begin
          Val (AFileLine, Result.VertexQuant, Code);
        end;

      { Создается временный массив }
      if (( r > 1 ) and ( r <= (Result.VertexQuant + 1))) then
        begin
          k := 1;
          for c := 1 to Result.VertexQuant do
            begin
              f := k;
              if (AFileLine[k+1] <> ' ') and ((k + 1) <= StLeng ) then
                begin
                  while (AFileLine[f] <> ' ') and (f <= StLeng) do
                    begin
                      f :=  f + 1;
                    end;
                  St := Copy (AFileLine, k, f-k);
                  k := f;
                end
              else
                begin
                  St := AFileLine[k];
                  k := k + 1;
                end;
              Val (St, TempArray[r-1, c], Code); //Преобразование сроки в число
              k := k + 1;
            end;
        end;

      { Определяются времена выполнения вершин }
      if r = (Result.VertexQuant + 2) then
        begin
          k := 1;
          for c := 1 to Result.VertexQuant do
            begin
              f := k;
              if (AFileLine[k+1] <> ' ') and ((k + 1) <= StLeng ) then
                begin
                  while (AFileLine[f] <> ' ') and (f <= StLeng) do
                    begin
                      f :=  f + 1;
                    end;
                  St := Copy (AFileLine, k, f-k);
                  k := f;
                end
              else
                begin
                  St := AFileLine[k];
                  k := k + 1;
                end;
              Val (St, Result.Vertex[c].DecisionTime, Code);
              k := k + 1;
            end;
        end;

    end;
  Close (ADatFile); // Окончание первого этапа ( Закрытие файла )


  { Этап2: Преобразование временного массива в значения полей переменной
     типа TGraf }

  { Определяются параметры вершин-последователей }

  for t := 1 to Result.VertexQuant do
    begin
      Result.Vertex[t].ChildVertexQuant := 0;
      i := 1;
      for c := 1 to Result.VertexQuant do
        begin
          if TempArray[t,c] > 0 then
            begin
              Result.Vertex[t].ChildVertexQuant :=
                                    Result.Vertex[t].ChildVertexQuant + 1;
              Result.Vertex[t].ChildVertexNumbs[i] := c;
              i := i + 1;
            end;
        end;
    end;


  { Определяются параметры вершин-предшественников }

  for c := 1 to Result.VertexQuant do
    begin
      Result.Vertex[c].ParentVertexQuant := 0;
      i := 1;
      for r := 1 to Result.VertexQuant do
        begin
          if TempArray[r,c] > 0 then
            begin
              Result.Vertex[c].ParentVertexQuant :=
                                    Result.Vertex[c].ParentVertexQuant + 1;
              Result.Vertex[c].ParentVertexNumbs[i] := r;
              i := i + 1;
            end;
        end;
    end; //  Окончание второго этапа
    
Result.Vertex[1].Level := 1;  // Определяются ярусы вершин
for k := 2 to Result.VertexQuant do
  begin
    for i := Result.VertexQuant downto 1 do
      begin
        if TempArray [i,k] > 0 then
          begin
            Result.Vertex[k].Level := Result.Vertex[i].Level + 1;
            Break;
          end;
      end;
    Continue;
  end;

for i := 1 to Result.VertexQuant do Result.Vertex[i].Status := notReady;
Result.Vertex[1].Status := Ready;
Result.MaxLevel := Result.Vertex[Result.VertexQuant].Level;

for i := 1 to Result.VertexQuant do // Устанавливаются значения различных свойств вершин
  begin
    with Result.Vertex[i] do
      begin
        OnCritWay := False;
        CPUNumber := 0;
        NextVertex := 0;
        PlaceStatus := inQuaue;
      end;  

  end;  
end; // Окончание реализации функции  Convert


{procedure DrawFile ( FileName : string; var DrawBox : TPaintBox; ImList : TImageList );
var
  Graf : TGraf;
begin
  Graf := Convert ( FileName );
  Graf.DrawGraf ( DrawBox, ImList );
  Graf.Destroy;
end; }


end.
