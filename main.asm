.model .small
.stack 32
.data
    
    number dw 0
    multiplyer dw 10
    
    your_number_is_msg dw "Your number is $"
    decimal_msq dw "Decimal$"
    binary_msg dw "Binary$"
    octal_msq dw "Octal$"
    hexadecimal_msq dw "Hexadecimal$"
    
    number_to_print dw 123
.code
main:
    mov ax, @data
    mov ds, ax
    mov ax, 00
    
    mov cx, 00
    
  get_num:
    
    mov ah, 01          ; gets input    (All inputs are lowercase)
    int 21h
    
    cmp al, 0xdh        ; checks if input is enter or not (entered number is Decimal)
    je is_decimal
    cmp al, 62h         ; checks if input is Binary
    je is_binary        
    cmp al, 64h         ; checks if input is Decimal
    je is_decimal
    cmp al, 68h         ; checks if input is Hexadecimal
    je is_hexadecimal
    cmp al, 6fh         ; checks if input is Octal
    je is_octal
     
   
    mov ah, 00
    sub al, 48          ; ASCII to DECIMAL 
    
    mov bx, number      ; multiplying number by 10 and adding inputed number to it
    mov cl, al
    mov ax, multiplyer
    mul bx
    add ax, cx
    mov number, ax
        
    jmp get_num    
  
; --------------- ;       
                               
  is_decimal:
    ; prints "Your number is Decimal" in new line
    mov dx, 0xdh
    call print_letter
    mov dx, 0xah
    call print_letter
    lea dx, your_number_is_msg
    call print_msq
    lea dx, decimal_msq
    call print_msq
    mov dx, 9h
    call print_letter
     
    jmp decimal_calculator
    
  is_binary:
    ; prints "Your number is Binary" in new line
    mov dx, 0xdh
    call print_letter
    mov dx, 0xah
    call print_letter
    lea dx, your_number_is_msg
    call print_msq
    lea dx, binary_msg
    call print_msq
    mov dx, 9h
    call print_letter
    
    jmp binary_calculator
     
  is_hexadecimal:
    ; prints "Your number is Hexadecimal" in new line
    mov dx, 0xdh
    call print_letter
    mov dx, 0xah
    call print_letter
    lea dx, your_number_is_msg
    call print_msq
    lea dx, hexadecimal_msq
    call print_msq
    mov dx, 9h
    call print_letter
    
    jmp hexadecimal_calculator
    
  is_octal:
    ; prints "Your number is Octal" in new line
    mov dx, 0xdh
    call print_letter          
    mov dx, 0xah
    call print_letter
    lea dx, your_number_is_msg
    call print_msq
    lea dx, octal_msq
    call print_msq
    mov dx, 9h
    call print_letter
    
    jmp octal_calculator   
  
; --------------- ;
  
  decimal_calculator:
    jmp resume
    
  binary_calculator:
    jmp resume
  
  octal_calculator:
    jmp resume
    
  hexadecimal_calculator:
    jmp resume
  
; --------------- ;
   
  print_number proc
    ; prints number inside number_to_print
    mov ax, number_to_print               
    mov cx, 00
   push_to_stack:
    ; stores digits in stack
    div multiplyer
    push dl
    inc cx
    mov dx, 00          
    cmp al, 00
    jne push_to_stack
   print:
    ; prints each digit
    pop dx
    add dx, 30h
    call print_letter
    loop print  
    ret
  print_number endp
  
  print_msq proc
    mov ah, 9h
    int 21h    
    ret 
  print_msq endp
  
  print_letter proc
    mov ah, 2h
    int 21h    
    ret 
  print_letter endp
  
; --------------- ;
    
  resume:
    end  