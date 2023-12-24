; A program that collects users biodata and saves it to a file
; prints out the collected biodata in a nice form

%include "main.inc"

extern fields, fields_len, int_format
extern printf, scanf, fopen, fclose
extern create, edit, display, write_to_file

segment .data
NL db 0xa
SPACE db 0x20
COLON db 0x3A

var title, db "******   Student Biodata Program    ******", 0xA, 0xA, 0
menu    db  "----   Select action from the menu    ----", 0xA, 0xA
        db  "1 - Enter your details", 0xA
        db  "2 - Edit your biodata", 0xA
        db  "3 - Display biodata", 0xA
        db  "4 - Save Your Biodata", 0xA
        db  "0 - Exit program", 0xA, 0xA, 0

exit_msg    db  "Program ended.", 0xA, 0
actions     dd  exit, create, edit, display, save
actions_len EQU ($ - actions)/4
save_success    db  "Biodata saved to biodata.txt", 0xA, 0xA, 0
filename    db "biodata.txt", 0
open_perm   db "w+", 0



segment .bss
menu_select resb 1


segment .text

global start
start:
    enter 0,0
    push title
    call printf
    add esp, 4

.loop:
    call display_menu
    cmp eax, 0
    jl .loop
    je .end
    cmp eax, actions_len
    jg .loop

    call [actions + eax * 4]
    jmp .loop

.end:
    jmp exit

display_menu:
    enter 0,0

    push dword menu
    call printf
    add esp, 4

    push dword menu_select
    push dword int_format
    call scanf
    add esp, 8
    movzx eax, byte [menu_select]

    leave
    ret

save:
    push ebp
    mov ebp, esp

    mov eax,5
    mov ebx,filename
    mov ecx, 0102o
    mov edx,0666o
    int 80h

    push eax
    call write_to_file
    pop eax

    mov ebx, eax
    mov eax, 6
    int 80h

    push dword save_success
    call printf
    add esp, 4

    pop ebp
    ret


exit:
    push dword exit_msg
    call printf
    add esp, 4

    leave
    ret