; I/O routines for all programes

; MACROS for string operations
%idefine TWORD_size 10
%idefine QWORD_size 8
%idefine DWORD_size 4
%idefine WORD_size 2
%idefine BYTE_size 1
%imacro VAR 2+
    %{1}: %{2}
    %{1}_size EQU ($-%{1})
%endmacro

%define sizeof(_x_) _x_%+_size

; Print String
%macro print_string 1
    pusha
    mov ecx, %1
    mov edx, sizeof(%1)
    mov eax, 04h
    int 80h
    popa
%endmacro

; Print String with given length
%macro lprint 2
    pusha
    mov ecx, %1
    mov edx, %2
    mov eax, 04h
    int 80h
    popa
%endmacro

%macro print_char 1
    pusha
    mov ecx, %1
    mov edx, 1
    mov eax, 04h
    int 80h
    popa
%endmacro

%macro print_int 1
    pusha
    mov eax, 04h
    mov ebx, 0
    mov ecx, %1
    add [ecx], byte '0'
    mov edx, 1
    int 80h
    popa
%endmacro

%macro read_string 1-2 81
    pusha
    mov eax, 03h
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 80h
    popa
%endmacro

