; =====================================================
; Data definitions for a biodata program
; Field struc -- captures a field such as name
;                   storing the field prompt and value
;
; =====================================================

%include "main.inc"

%define MAX_FIELDS 20

global fields:data, fields_len, int_format, str_format
global Field, Field_size, Field.prompt, Field.value, Field.len

struc Field
    .prompt: resb 20
    .value: resb 25
    .len: resb 1
endstruc

segment .data

first_name:
    istruc Field
        at Field.prompt, db    "First Name", 0
        at Field.value,  db    ""
        at Field.len,    db    0d
    iend

last_name:
    istruc Field
        at Field.prompt, db    "Last Name", 0
        at Field.value,  db    20
        at Field.len,    db    0d
    iend

email:
    istruc Field
        at Field.prompt, db    "Email", 0
        at Field.value,  db    ""
        at Field.len,    db    0d
    iend

occupation:
    istruc Field
        at Field.prompt, db     "Occupation", 0
        at Field.value,  db     ""
        at Field.len,    db     0d
    iend

country:
    istruc Field
        at Field.prompt, db    "Country", 0
        at Field.value,  db    ""
        at Field.len,    db    0d
    iend

state:
    istruc Field
        at Field.prompt, db    "State", 0
        at Field.value,  db    ""
        at Field.len,    db    0d
    iend

dob:
    istruc Field
        at Field.prompt,   db     "DOB (dd/mm/yyyy)", 0
        at Field.value,    db     ""
        at Field.len,      db     0d
    iend


fields dd first_name, last_name, email, occupation, country, state, dob
fields_len EQU ($ - fields)/4
edit_prompt    db   0xA, "---   Select Field to edit   ---", 0xA, 0
edit_select_error   db "Invalid field. Entry out of range", 0xA, 0
display_title   db  0xA, "*****     Showing saved data     *****", 0xA, 0xA, 0
create_title    db  0xA, "*****     Enter your details     *****", 0xA, 0xA, 0
str_format db "%s", 0
int_format db "%d", 0
field_format db "%s: %s", 0xA, 0
edit_menu_format db "%d - %s", 0xA, 0
field_prompt_format db "%s: ", 0

NEWLINE db 0xA,0

segment .bss
edit_menu_select resb 1


segment .text

global create, edit, display, write_to_file
extern printf, scanf, dprintf



create:
    enter 0,0
    push ebx
    xor ecx, ecx

    push dword create_title
    call printf
    add esp, 4

.loop:
    push ecx
    mov ebx, dword [fields + ecx*4]
    push ebx
    push dword field_prompt_format
    call printf
    add esp, 8

    ; read input
    add ebx, Field.value
    push ebx
    push dword str_format
    call scanf
    add esp, 8

    pop ecx

    add ecx, 1
    cmp ecx, fields_len
    jl .loop

    push dword NEWLINE
    call printf
    add esp, 4
    
.return:
    pop ebx
    leave
    ret


edit:
    enter 0,0
    push ebx
    push dword edit_prompt
    call printf
    add esp, 4
    xor ecx, ecx
.loop:
    mov ebx, dword [fields + ecx * 4]
    push ebx
    push ecx
    push dword edit_menu_format
    call printf

    add esp, 4                      ; remove edit_menu_format
    pop ecx                         ; restore ecx
    add esp, 4                      ; remove ebx

    inc ecx
    cmp ecx, fields_len
    jl .loop

    push dword NEWLINE
    call printf
    add esp, 4

    push dword edit_menu_select
    push int_format
    call scanf
    add esp, 8

    mov eax, [edit_menu_select]
    cmp eax, 0                      ; Validate input
    jl .error
    cmp eax, fields_len
    jge .error

    mov ebx, dword [fields + eax * 4]   ; Edit selected field
    push ebx
    push dword field_prompt_format
    call printf
    add esp, 8

    ; read input
    add ebx, Field.value
    push ebx
    push dword str_format
    call scanf
    add esp, 8


.return:
    pop ebx
    leave
    ret

.error:
    push dword edit_select_error
    call printf
    add esp, 4
    jmp .return


display:
    enter 0,0
    push ebx
    xor ecx, ecx

    push dword display_title
    call printf
    add esp, 4

.loop:
    push ecx
    mov ebx, dword [fields + ecx*4]
    mov edx, ebx
    add edx, Field.value

    push edx
    push ebx
    push dword field_format
    call printf
    add esp, 12

    pop ecx

    add ecx, 1
    cmp ecx, fields_len
    jl .loop

    push dword NEWLINE
    call printf
    add esp, 4
    
.return:
    pop ebx
    leave
    ret


write_to_file:
    push ebp
    mov ebp, esp
    push ebx

    xor ecx, ecx
.loop:
    push ecx
    mov ebx, dword [fields + ecx * 4]       ; print prompt
    mov edx, ebx
    add edx, Field.value

    push edx
    push ebx
    push dword field_format
    push dword [ebp + 8]
    call dprintf
    add esp, 16

    pop ecx
    inc ecx
    cmp ecx, fields_len
    jl .loop

    xor eax, eax
    pop ebx
    pop ebp
    ret