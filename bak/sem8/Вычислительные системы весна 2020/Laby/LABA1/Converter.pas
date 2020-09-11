unit Converter;
{ ������ ��������� ������� Convert, ������� ����������� ������ �� .dat �����
  � ���������� ���� TGraf. }

interface

uses GlobalTypes, Classes, Extctrls, Controls, Graphics ;


function Convert ( AFileName : String ) : TGraf; { ������� �����������
      .dat-����� � ��� TGraf }

{procedure DrawFile ( FileName : string; var DrawBox : TPaintBox; ImList : TImageList ); }



implementation

function Convert ( AFileName : String ) : TGraf; export;{ ������� �����������
.dat-����� � ��� Graf }

var
  ADatFile : System.Text;{ ���������� ���� "��������� ����" }
  AFileLine : String; { ����������, ���������� ������� ������ .dat ����� }
  k, t, r, c, f, i, StLeng : Byte; { ��������� �������� }
  Code : Integer; { ��� ���������� �������������� �������� � ����� }
  St : String;
  TempArray : Array [1..MaxVert, 1..MaxVert] of Byte; { ��������� ������ }



begin

  { ����1: ���������� ���������� �� .dat-����� }
  Assign (ADatFile, AFileName);
  Reset (ADatFile);
  Result := TGraf.Create;
  r := 0;

  while not Eof( ADatFile ) do
    begin
      ReadLn (ADatFile, AFileLine); // ���������� ������ �� .dat �����
      r := r + 1;
      StLeng := Length ( AFileLine ); // ����������� ����� ������

      { ������������ ���-�� ������ ����� }
      if r = 1 then
        begin
          Val (AFileLine, Result.VertexQuant, Code);
        end;

      { ��������� ��������� ������ }
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
              Val (St, TempArray[r-1, c], Code); //�������������� ����� � �����
              k := k + 1;
            end;
        end;

      { ������������ ������� ���������� ������ }
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
  Close (ADatFile); // ��������� ������� ����� ( �������� ����� )


  { ����2: �������������� ���������� ������� � �������� ����� ����������
     ���� TGraf }

  { ������������ ��������� ������-�������������� }

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


  { ������������ ��������� ������-���������������� }

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
    end; //  ��������� ������� �����
    
Result.Vertex[1].Level := 1;  // ������������ ����� ������
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

for i := 1 to Result.VertexQuant do // ��������������� �������� ��������� ������� ������
  begin
    with Result.Vertex[i] do
      begin
        OnCritWay := False;
        CPUNumber := 0;
        NextVertex := 0;
        PlaceStatus := inQuaue;
      end;  

  end;  
end; // ��������� ���������� �������  Convert


{procedure DrawFile ( FileName : string; var DrawBox : TPaintBox; ImList : TImageList );
var
  Graf : TGraf;
begin
  Graf := Convert ( FileName );
  Graf.DrawGraf ( DrawBox, ImList );
  Graf.Destroy;
end; }


end.
