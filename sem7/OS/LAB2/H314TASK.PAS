unit h314task;

interface

  const MaxThread=10;
        maxCritical=10;
  type TCriticalNum=0..maxCritical;

  function RegisterThread( ThreadAddr:pointer;
                          StackSize:word):integer;
  {Регистрация задачи - занесение в очередь. Возвращается хэндл задачи}

  procedure ExecuteRegisteredThreads(UseTimer:boolean);
  {Выполняет зарегистрированные задачи.
   Задачи  регистрируются активными, т.е. каждая способна получить
   управление. Выполнение прекращается, когда все задачи будут
   прекращены с помощью StopThread. UseTimer указывает, будут ли
   переключаться задачи по таймеру (вытесняющая многозадачность) или
   "добровольно", т.е. путем вызова SwitchThreads внутри себя}

  procedure StopThread(ThreadNumber:byte);{Запрещает передачу управления задаче}
  procedure RunThread(ThreadNumber:byte); {Разрешает передачу управления задаче}
  procedure SwitchThreads; {Досрочно отдать управление диспетчеру задач}

  procedure EnterCritical(num:TCriticalNum); {Войти в критическую секцию}
  procedure LeaveCritical(num:TCriticalNum); {Покинуть критическую секцию}

  procedure LoopBack; {Бесконечный цикл, используется в конце задачи
                       вместо команды RET}

  procedure ClearThreads;


implementation

  uses dos;

  type TThreadStateWord=record
       BP_reg, ES_reg, DS_reg, DI_reg, SI_reg, DX_reg,
       CX_reg, BX_reg, AX_reg, IP_reg, CS_reg, Flags:  word;
       Stack:pointer;
       Active:boolean;
     end;

  var TS:array [0..MaxThread-1] of TThreadStateWord;
      Stacks: array [0..MaxThread-1] of record
                sze:word; {размеры стеков}
                ptr:pointer; {указатель на блок, выделенный под стек}
              end;

  const ThreadsRegistered:byte=0;

  var oldvec8:procedure;

  const ParallelFinished:boolean=true;
        parallelStart:boolean=false;
        stepcount:longint=0;

        preemptiveSwitch:boolean=true; {Переключать потоки по таймеру}
        DisableHardwareEvents:boolean=false;
          {При взведенном флаге старый обработчик не вызывается}

  var curflags:word;

const
  criticalTable:array [TCriticalNum] of byte=(0,0,0,0,0,0,0,0,0,0,0);
  criticalTableWait:array [TCriticalNum] of byte=(0,0,0,0,0,0,0,0,0,0,0);

procedure EnterCritical(num:TCriticalNum); {Войти в критическую секцию}
begin
  asm cli end;
  if num<=maxCritical then begin
    if criticalTable[num]<>0 then begin
      inc(criticalTableWait[num]); {запрос на вход в КС}
      while criticalTable[num]>0 do begin {Пока КС занята кем-то}
        {отдать управление другому процессу и ждать освобождения КС}
        asm sti end;
        SwitchThreads;
        asm cli end;
      end;
      dec(criticalTableWait[num]);
    end;
    criticalTable[num]:=1;
  end;
  asm sti end;
end;

procedure LeaveCritical(num:TCriticalNum); {Покинуть критическую секцию}
begin
  asm cli end;
  if num<=maxCritical then
    criticalTable[num]:=0;
  asm sti end;

  if criticalTableWait[num]>0 then {Если кто-то ждет КС}
    switchThreads;
end;

procedure TimerHandler(flags,cs,ip,ax,bx,cx,dx,si,di,ds,es,bp:word); interrupt;
  {Следующие типизированные константы являются на самом деле
   статическими локальными переменными, которые размещаются в сегменте
   данных и сохраняют свои значения между вызовами процедуры}
  const ThreadNumber:byte=0;
  const NumPrev:byte=0;
  const tsoffset:word=0;
        mainSP:word=0;
        mainSS:word=0;
begin
  if not DisableHardwareEvents then begin
    asm pushf end;
    oldvec8;
    {Вызван старый обработчик прерывания от таймера. Он сбросил
     контроллер прерываний.}
  end;

  if preemptiveSwitch or DisableHardwareEvents then
    if (ThreadsRegistered>1) or (parallelStart) then begin
      {Зарегистрировано более одной задачи}
      asm cli end;

      if ParallelStart then begin
        {Если идет запуск процесса параллельных вычислений}
        StepCount:=0;
        asm
          mov       ParallelFinished,false {Сброс флага завершения}
          mov       mainsp,bp {Стек главного потока для возврата по окончании}
          mov       mainss,ss {исполнения параллельных потоков}
        end;
      end;

      inc(StepCount);

      if {ts[ThreadNumber].active and} not ParallelStart then begin
        {Сохранение состояния текущего (прерванного) потока.
        Не производится при взведенном флаге ParallelStart, т.к.
        предполагается, что в этом случае была прервана основная программа}

        {Смещение текущнго потока в таблице зарегистрированных потоков}
        tsoffset:=ThreadNumber*sizeof(TThreadStateWord);
        asm
          push      ds
             {нет гарантий, что при прерывании DS указывает
              на сегмент данных программы!}
          mov       ax,seg ts
          mov       es,ax
          mov       di,offset ts
          add       di,tsoffset

          mov       ax,ss
          mov       ds,ax
          mov       si,bp {ds:si указывает на регистры, сохраненные в стеке}

          cld
          mov       cx,12
      rep movsw     {сохранение состояния прерванного потока (кроме стека)}
          pop       ds

          {es:di продвинулось на 24 байта вперед и указывает на место
          для сохранения состояния стека}
          mov       ax,bp  {BP содержит состояние стека после 12 сохранений регистров}
          add       ax,12*2
          stosw  {SP задачи}
          mov       ax,ss
          stosw  {SS задачи}
        end;
      end;

      {Поиск следующей активной задачи}
      NumPrev:=ThreadNumber;
      repeat
        ThreadNumber:=(ThreadNumber+1) mod ThreadsRegistered;
      until (ThreadNumber=NumPrev) or TS[ThreadNumber].active;

      if ts[ThreadNumber].active and ((ThreadNumber<>NumPrev) or parallelStart)
      then begin
        {Восстановление новой задачи, если она отлична от прежней.
        Производится при взведенном флаге ParallelStart, даже если
        задача совпадает с якобы прежней, т.к. может
        оказаться, что единственной активной задачей в очереди является
        задача номер 0}
        tsOffset:=(ThreadNumber+1)*sizeof(TThreadStateWord) - 3;
        asm
          mov       dx,ds

          mov       ax,seg TS
          mov       ds,ax
          mov       si,offset TS
          add       si,tsOffset  {ds:si указывает на состояние активизируемого потока}
          std

          lodsw
          mov       ss,ax
          lodsw
          mov       sp,ax
          mov       bp,ax    {Переключение на стек нового потока}
          sub       bp,12*2

          {Подмена регистров в стеке на сосотояние нового потока. После
           возврата из процедуры будет исполняться код с той точки,
           где он был прерван при деактивации активизируемого сейчас
           потока}
          mov       cx,12
      @m1:
          lodsw
          push      ax
          loop      @m1
          cld

          mov       ds,dx
        end;
      end
      else if (not ts[Threadnumber].active) and (Threadnumber=NumPrev) then begin
        {Все задачи завершены}
        setintvec($8,@oldvec8);
        asm
          mov   parallelfinished,true
          mov   ax,mainss
          mov   ss,ax
          mov   bp,mainsp
          mov   sp,bp
        end;
      end;
      parallelstart:=false;
    end;

  DisableHardwareEvents:=false;
end;

procedure SwitchThreads;
begin
  if not parallelFinished then
    asm
      cli
      mov DisableHardwareEvents,1
      int 08h
      sti
    end;
end;

procedure ExecuteRegisteredThreads(useTimer:boolean);
begin
  parallelfinished:=false;
  parallelstart:=true;
  fillchar(criticalTable,sizeof(criticaltable),0);
  fillchar(criticalTableWait,sizeof(criticaltable),0);
  PreemptiveSwitch:=useTimer;
  getintvec($08,@oldvec8);
  setintvec($08,@TimerHandler);
  if not useTimer then SwitchThreads;
  repeat until parallelFinished;
  setintvec($08,@oldvec8);
end;

procedure StopThread(ThreadNumber:byte);
begin
  ts[ThreadNumber].active:=false;
  SwitchThreads;
end;

procedure RunThread(ThreadNumber:byte);
begin
  ts[ThreadNumber].active:=true;
end;

procedure LoopBack;
begin
  repeat
    SwitchThreads; {Отдать управление другому}
  until false;
end;

function RegisterThread(ThreadAddr:pointer; StackSize:word):integer;
begin
  asm
    sti
    pushf
    cli
    pop  ax  {разрешить прерывания в запоминаемом состоянии флагов}
    mov  curflags,ax
  end;
  ts[ThreadsRegistered].ip_reg:=word(ThreadAddr);
  ts[ThreadsRegistered].cs_reg:=word(longint(ThreadAddr) shr 16);
  ts[ThreadsRegistered].ds_reg:=dseg;
  ts[ThreadsRegistered].flags:=curflags;

  getmem(ts[ThreadsRegistered].stack,StackSize);    {Стек задачи}
  stacks[ThreadsRegistered].sze:=StackSize;
  stacks[ThreadsRegistered].ptr:=ts[ThreadsRegistered].stack;
  inc(word(ts[ThreadsRegistered].stack),StackSize and $FFFE-2);
  {Стек нарастает "вниз", адресуется словами!}

  ts[ThreadsRegistered].active:=true;
  registerThread:=ThreadsRegistered;
  inc(ThreadsRegistered);
  if Threadsregistered>maxThread then runerror(0);
  asm
    sti
  end;
end;

procedure ClearThreads;
  var i:integer;
begin
  for i:=0 to threadsregistered-1 do
    freemem(stacks[i].ptr,stacks[i].sze);
  ThreadsRegistered:=0;
  fillchar(ts,sizeof(ts),0);
end;

begin
  ClearThreads;
end.