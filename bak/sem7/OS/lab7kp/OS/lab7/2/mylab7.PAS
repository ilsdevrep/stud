program mylab7;

uses windows,  sysutils,messages; {���������� � ��������� DLL}

{$R myres7.res} // ������������ ���� ��������

procedure chengetext(h:thandle);
var   i,j:integer;
      buftmp,war: string;
      buffer: array[0..2000] of char;
      buffer2:PChar;


begin
    SendMessage(GetDlgItem(h,4),wm_gettext,sizeof(buffer),integer(@buffer));
    if buffer[1999] <> #0 then
     begin
      if  MessageBox(0,'�� �������� 2000 �������! ��������� ������� ���� �����?','� ���� �� ������ �������� ������!', MB_YESNO) = IDYES then
       begin
         SendMessage(GetDlgItem(h,4),wm_settext,0,0);
       end;
       war:='�� �������, �� ��������!!!';
       SendMessage(GetDlgItem(h,5),wm_settext,0,longint(war));
     end

     else
       begin
         buffer2:=StrAlloc(2000);
         i:=0; StrCopy(buffer2,'');
         while buffer[i]<>#0 do
           begin
              case buffer[i] of
                    '�' : StrCat(buffer2,'io');'�' : StrCat(buffer2,'z'); '�' : StrCat(buffer2,'u');
                    '�' : StrCat(buffer2,'k');'�' : StrCat(buffer2,'e');  '�' : StrCat(buffer2,'n');
                    '�' : StrCat(buffer2,'g');'�' : StrCat(buffer2,'sh'); '�' : StrCat(buffer2,'sch');
                    '�' : StrCat(buffer2,'z');'�' : StrCat(buffer2,'h');  '�' : StrCat(buffer2,'f');
                    '�' : StrCat(buffer2,'bl');'�' : StrCat(buffer2,'v'); '�' : StrCat(buffer2,'a');
                    '�' : StrCat(buffer2,'p'); '�' : StrCat(buffer2,'r'); '�' : StrCat(buffer2,'o');
                    '�' : StrCat(buffer2,'l'); '�' : StrCat(buffer2,'d'); '�' : StrCat(buffer2,'j');
                    '�' : StrCat(buffer2,'e'); '�' : StrCat(buffer2,'ya');'�' : StrCat(buffer2,'ch');
                    '�' : StrCat(buffer2,'s'); '�' : StrCat(buffer2,'m'); '�' : StrCat(buffer2,'i');
                    '�' : StrCat(buffer2,'t'); '�' : StrCat(buffer2,'b'); '�' : StrCat(buffer2,'u');

                    '�' : StrCat(buffer2,'IO');'�' : StrCat(buffer2,'Z');'�' : StrCat(buffer2,'U');
                    '�' : StrCat(buffer2,'K'); '�' : StrCat(buffer2,'E');'�' : StrCat(buffer2,'N');
                    '�' : StrCat(buffer2,'G'); '�' : StrCat(buffer2,'SH');'�' : StrCat(buffer2,'SCH');
                    '�' : StrCat(buffer2,'Z'); '�' : StrCat(buffer2,'H'); '�' : StrCat(buffer2,'F');
                    '�' : StrCat(buffer2,'bl');'�' : StrCat(buffer2,'V'); '�' : StrCat(buffer2,'A');
                    '�' : StrCat(buffer2,'P'); '�' : StrCat(buffer2,'R'); '�' : StrCat(buffer2,'O');
                    '�' : StrCat(buffer2,'L'); '�' : StrCat(buffer2,'D'); '�' : StrCat(buffer2,'J');
                    '�' : StrCat(buffer2,'E'); '�' : StrCat(buffer2,'YA');'�' : StrCat(buffer2,'CH');
                    '�' : StrCat(buffer2,'S'); '�' : StrCat(buffer2,'M'); '�' : StrCat(buffer2,'I');
                    '�' : StrCat(buffer2,'T'); '�' : StrCat(buffer2,'B'); '�' : StrCat(buffer2,'U');

                 else
                      begin
                        buftmp:='';
                        buftmp:=buffer[i];
                        StrCat(buffer2,PChar(buftmp));
                      end;
            end;//case
          inc(i);
       end;//while
     SendMessage(GetDlgItem(h,5),wm_settext,0,longint(buffer2))
  end;// if 2000
end;


procedure static(a,b:integer); stdcall; external 'mylib7.dll' name 'static';
  //����������� �������� �������

var dyn:procedure(a,b:integer) stdcall; //���������� ��� ������������ ��������
    hLib7:hModule;


procedure DrawBitmap(hdc, hBitmap: THandle; xs,yS: integer;rect:TRect);
  var bm: TBitmap;
      hdcMem: THandle;
begin
  hdcMem:=CreateCompatibleDC(hdc);
  SelectObject(hdcMem, hBitmap);
  GetObject(hBitmap, sizeof(TBitmap),@bm);
  BitBlt(hdc, xs, ys, bm.bmWidth, bm.bmHeight, hdcMem,0,0,SRCCOPY);
  DeleteDC(hdcMem);
end;



function dlgProc(hdlg: THandle; Msg: integer; wParam: longint; lParam: longint): LRESULT; stdcall;
begin
  result:=1;
  case Msg of

     wm_command:  // ��������� ������ �� ���� ������� ����������
      if SendMessage(1, BM_GETCHECK,0,0)=1 then
       begin
         if hiword(wParam)= EN_CHANGE then
            begin
              //SendMessage(GetDlgItem(hwnd1,edit),wm_gettext,sizeof(buffer),integer(@buffer));
              //SendDlgItemMessage(hwnd1,edit2,wm_settext,sizeof(buffer),integer(@buffer));
              chengetext(hdlg);
            end;
       end

     else
      if hiword(wParam)= BN_Clicked then
        begin
           if loword(wParam)=3 then
              begin
                chengetext(hdlg);
              end;//if
        end; //if



    wm_close:
      begin
        EndDialog(hdlg,idCancel);
      end;
    else
      result:=0;
      // ������� DefDlgProc!
  end;
end;

function abProc(habdlg: THandle; Msg: integer; wParam: longint; lParam: longint): longint; stdcall;
var ps:TPaintStruct;
      hend,hdc:THandle;
      rect:TRect;
begin
  result:=0;
  case Msg of
   wm_paint:
      begin
        SetWindowRgn(habdlg,CreateRoundRectRgn(3,23,161,240,80,80),true);
        hdc:=BeginPaint(habdlg,ps);
         GetClientRect(habdlg,rect);
         hend:=loadbitmap(hInstance,'im1');
         DrawBitmap(hdc,hend,0,0,rect );
        endPaint(habdlg,ps);
      end;

    wm_lbuttondown :
      EndDialog(habdlg,idCancel);

    wm_close:
      EndDialog(habdlg,idCancel);
    else
      result:=0;
  end;
end;

function wndProc(hWnd: THandle; Msg: integer; wParam: longint; lParam: longint): longint; stdcall;
begin
  result:=0;
  case Msg of
    wm_create:
      begin
        //� ������ -- �������� �������. �� ����� ���� ��� DLL ��� ���������,
        // ������� ��� ��� �� �����������, ������������� ���� ������� ������ �� ���
        hLib7:=loadLibrary('mylib7.dll');
        // ��������� ���������� ������������ ���� �� ������ 100 � DLL
        @dyn:=GetProcAddress(hLib7,pointer(100));
      end;
    wm_command: // ��������� ������ �� ���� ������� ����������
      if hiword(wparam)=0 then begin //� ���������� ���� ������� ��� �����������
        case loword(wparam) of
          101: static(101,1);
          102: dyn(102,1);
          103:DialogBox(hlib7,'mydlg',0,@dlgproc);
          // ������ �� ������� ������� ������ -- hLib7 !

          104: sendmessage(hwnd,wm_close,0,0);
          105: DialogBox(hInstance,'ab',hwnd,@abproc);
          106:MessageBox(0,'��� ������ ���! ��� �������!','Team#17', MB_OK or MB_ICONINFORMATION);
        end;
      end;
    wm_close:
      begin // ������ ���������� ������������ �������������
        FreeLibrary(hLib7);
        PostQuitMessage(0);
      end;
    else
      result:=DefWindowProc(hwnd,msg,wparam,lparam);
  end;
end;

procedure WinMain; {�������� ���� ��������� ���������}
  const szClassName='Controls demo';
  var   wndClass:TWndClassEx;
        msg:TMsg;
        hwnd1,hwnd2:THandle;
        sbuf:array[byte] of char;
begin
  loadString(hInstance,1,@sbuf,256);

  wndClass.cbSize:=sizeof(wndClass);
  wndClass.style:=0;
  wndClass.lpfnWndProc:=@WndProc;
  wndClass.cbClsExtra:=0;
  wndClass.cbWndExtra:=0;
  wndClass.hInstance:=hInstance;
  wndClass.hIcon:=loadIcon(hInstance, 'tox');
  wndClass.hCursor:=loadCursor(hInstance, 'cur');
  wndClass.hbrBackground:=GetStockObject(gray_Brush);
  wndClass.lpszMenuName:='lab7menu';
  wndClass.lpszClassName:=szClassName;
  wndClass.hIconSm:=wndClass.hIcon;

  RegisterClassEx(wndClass);

  hwnd1:=CreateWindowEx(0,
         szClassName, {��� ������ ����}
         @sbuf,    {��������� ����}
         ws_overlappedwindow,       {����� ����}
         100,           {Left}
         100,           {Top}
         500,                     {Width}
         300,                     {Height}
         0,                       {����� ������������� ����}
         0,                       {����� �������� ����}
         hInstance,               {����� ���������� ����������}
         nil);                    {��������� �������� ����}

  ShowWindow(hwnd1,sw_show);

  while GetMessage(msg,0,0,0) do begin {�������� ��������� ���������}
      TranslateMessage(msg);   {Windows ����������� ��������� �� ����������}
      DispatchMessage(msg);    {Windows ������� ������� ���������}
  end; {����� �� wm_quit, �� ������� GetMessage ������ FALSE}
end;


begin
  WinMain;
end.
