{Demo program for h314task}

uses dos,rdelay, crt,graph,h314task;

{$S-}

var hThread1, hThread2:integer;

procedure Thread0;
  var i:word;
      j:longint;
begin
  randomize;
  while true do begin
    EnterCritical(1);
    putpixel(random(getmaxx), random(getmaxy-50),White);
    putpixel(random(getmaxx), random(getmaxy-50),Black);
    LeaveCritical(1);
  end;
  LoopBack;
end;

procedure Thread2;
  var i:word;
      k:real;
      x:integer;
      ch:char;
begin
  x:=0;

  repeat
      ch:=readkey;
      if ch=#27 then break;
      enterCritical(1);
      outTextXY(x,getmaxy-16,char(ch));
      x:=(x+8) mod getmaxx;
      leaveCritical(1);
  until false;
  {readln;}

  StopThread(hThread1);
  StopThread(hThread2);
  LoopBack;
end;

{$S+}
var       gd,gm:integer;

begin
  gd:=detect;
  initgraph(gd,gm,'');

  clearThreads;
  hThread1:=RegisterThread(@Thread0,8000); {Registered as Thread #0}
  hThread2:=RegisterThread(@Thread2,8000); {Registered as Thread #1}

  ExecuteRegisteredThreads(true);

  closegraph;
end.