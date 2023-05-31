.model .small
.stack 32
.data
    
    ; variables
    input_number dw 0
    input_number_lenght dw 0
    multiplyer dw 10
    
    number_to_print dw 123
    
    ; messages
    entrance_msg_1 dw "!!! All input should be in lower case !!!$"
    your_number_is_msg dw "Your number is $"
    decimal_msq dw "Decimal$"
    binary_msg dw "Binary$"
    octal_msq dw "Octal$"
    hexadecimal_msq dw "Hexadecimal$"
    
.code
main:
    mov ax, @data
    mov ds, ax
    mov ax, 00
    
    mov cx, 00
    
    call print_entrance
    jmp get_num

; ------- Getting input Jump -------   
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
    sub al, 30h
    
    cmp al, 30h         ; saving hexadecimals
    jna save_to_stack
    sub al, 31h
    add al, 0xah
    
   save_to_stack:
    push ax
    inc input_number_lenght
    jmp get_num
    
  
; ------- Number Type Jumps ------- ;       
                               
  is_decimal:
    ; prints "Your number is Decimal" in new line
    lea bx, decimal_msq
    call show_number_type
    ; saves Decimal number in input_number 
    jmp save_decimal
    
  is_binary:
    ; prints "Your number is Binary" in new line
    lea bx, binary_msg
    call show_number_type
    
    jmp save_binary
     
  is_hexadecimal:
    ; prints "Your number is Hexadecimal" in new line
    lea bx, hexadecimal_msq
    call show_number_type
    
    jmp save_hexadecimal
    
  is_octal:
    ; prints "Your number is Octal" in new line
    lea bx, octal_msq
    call show_number_type
    
    jmp save_octal   
  
; ------- Saving jumps ------- ;
                  
  save_decimal:
    ; saving number in input_number in Decimal
    mov dx, 00
    mov cx, 00
   save_d:
    cmp cx, input_number_lenght
    je decimal_calculator
    mov ax, multiplyer
    push cx
    call power
    pop cx
    mov dx, 00
    pop bx
    mul bx
    add ax, input_number
    mov input_number, ax
    inc cx 
    jmp save_d

  save_binary:
    ; saving number in input_number in Binary
    mov dx, 00
    mov cx, 00
   save_b:
    cmp cx, input_number_lenght
    je binary_calculator
    mov ax, 2
    push cx
    call power
    pop cx
    mov dx, 00
    pop bx
    mul bx
    add ax, input_number
    mov input_number, ax
    inc cx 
    jmp save_b
  
  save_hexadecimal:
    ; saving number in input_number in Hexadecimal
    mov dx, 00
    mov cx, 00
   save_h:
    cmp cx, input_number_lenght
    je hexadecimal_calculator
    mov ax, 16
    push cx
    call power
    pop cx
    mov dx, 00
    pop bx
    mul bx
    add ax, input_number
    mov input_number, ax
    inc cx 
    jmp save_h
    
  save_octal:
    ; saving number in input_number in Octal
    mov dx, 00
    mov cx, 00
   save_o:
    cmp cx, input_number_lenght
    je octal_calculator
    mov ax, 8
    push cx
    call power
    pop cx
    mov dx, 00
    pop bx
    mul bx
    add ax, input_number
    mov input_number, ax
    inc cx 
    jmp save_o  
  
                  
                  
; ------- Calculation Jumps ------- ;
  
  decimal_calculator:
    jmp resume
    
  binary_calculator:
    jmp resume
                         
  hexadecimal_calculator:
    jmp resume
    
  octal_calculator:
    jmp resume
  
; ------- Calculation Procedures ------- ;

  power proc
    ; powers up the number in ax to power of cx and saves it in the ax
    cmp cx, 0
    je return_1
    cmp cx, 1
    je return_ax
    mov bx, ax
    sub cx, 1
   calculate:
    mul bx
    loop calculate
    ret
   return_1:
    mov ax, 1 
    ret
   return_ax:
    ret
  power endp  

; ------- Printing Procedures ------- ;

  print_entrance proc
    lea dx, entrance_msg_1 
    call print_msq 
    mov dx, 0xdh
    call print_letter
    mov dx, 0xah
    call print_letter       
    
    ret
  print_entrance endp  
   
  print_number proc
    ; prints number inside number_to_print
    mov ax, number_to_print               
    mov cx, 00
   push_to_stack:
    ; stores digits in stack
    div multiplyer
    push dx
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
  
  show_number_type proc
    ; prints inputed number type
    mov dx, 0xdh
    call print_letter
    mov dx, 0xah
    call print_letter
    lea dx, your_number_is_msg
    call print_msq
    mov dx, bx
    call print_msq
    mov dx, 9h
    call print_letter
    
    ret
  show_number_type endp
  
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