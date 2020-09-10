;жк - 9600 бит-секунду исходная скорость 
;исх адрес 8000h 
;загрузка reset 
; 
; 

cseg at 8000h 
jmp start 
org 8040h 

start: 

call lcdini 
call datav 
aa: 
nop 
jmp aa 

datav: 
push acc 
push b 

mov a,#10000000b ; переносна 2ую строку 
call write_command 

mov a,#041h ; А 
call write_data 
mov a,#0B4h ;г 
call write_data 
mov a,#61h ; а 
call write_data 
mov a,#0BEh ; п 
call write_data 
mov a,#06Fh ; о 
call write_data 
mov a,#0B3h ; в 
call write_data 
mov a,#61h ; а 
call write_data 



mov a,#11000000b ; переносна 2ую строку 
call write_command 

mov a,#54h ; Т 
call write_data 
mov a,#70h ; р 
call write_data 
mov a,#6Fh ; о 
call write_data 
mov a,#0C7h ; я 
call write_data 
mov a,#0BDh ; н 
call write_data 





pop b 
pop acc 
ret 

lcdini: 
mov a,#00101000b ; 4 бита, 2 строки, 5х8 точек 
call write_command 
mov a,#00001101b ; отображение символов, курсор - мерцающее знакоместо 
call write_command 
mov a,#00000110b ; сдвигвправо 
call write_command 
mov a,#00000001b ; очисткаэкрана 
call write_command 

clr p1.1 
ret 

wait_bf: ; проверка бита занятости 
push acc 

wait_ll: 
mov p1,#11110100b ; C/D=0, R/W=1,E=0 
setb p1.0 ; E=1 
mov a,p1 ; чтение старшей тетрады регистра IR 
clr p1.0 ; E=0 
mov b,a ; временное хранение старшей тетрады 
setb p1.0 
mov a,p1 ; чтение младшей тетрады 
clr p1.0 
mov a,b 
jb acc.7,wait_ll ; проверка бита занятости BF 
pop acc 
ret 

write_command: 
push acc 
push b 

call wait_bf 

mov b,a ; сохраняем код команды в B 
anl a,#11110000b ; C/D=0,R/W=0,E=0 

mov p1,a ; вывод старшей тетрады 
setb p1.0 ; E=1 
nop 
clr p1.0 ; ?=0 

mov a,b ; исходная команда 
swap a ; меняем местами тетрады 
anl a,#11110000b ; C/D=0,R/W=0,E=0 

mov p1,a ; вывод младшей тетрады 
setb p1.0 ; E=1 
nop 
clr p1.0 ; E=0 

mov p1, #11110000b 

pop b 
pop acc 
ret 

write_data: 
push acc 
push b 

call wait_bf 

mov b,a ; сохраняем данные в B 
anl a,#11110000b ; C/D=0,R/W=0,E=0 
orl a,#00000010b ; C/D=1 

mov p1,a ; старшая тетрада данных 
setb p1.0 ; E=1 
nop 
clr p1.0 ; E=0 

mov a,b ; исходные данные 
swap a ; меняем местами тетрады 
anl a,#11110000b ; C/D=0,R/W=0,E=0 
orl a,#00000010b ; C/D=1 

mov p1,a ; выводмладшейтетрады 
setb p1.0 ; E=1 
nop 
clr p1.0 ; E=0 

mov p1, #11110000b ; высокий уровень 

pop b 
pop acc 
ret 
end