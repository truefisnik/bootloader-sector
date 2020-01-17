bits 16 ; 16-bit Real Mode
org 0x7c00 ; BIOS boot origin 

jmp main ;Jump to start main() entry-point 

;;;;;;;;;;;;;;
; Variables 
;;;;;;;;;;;;;;

message db "Bootloader Sector 1.0", 0x0
copyright db "Copyright (c) 2020 Fisnik. All rights reserved.", 0x0
awaiting_anykey_message  db "Press any key to reboot...", 0x0

;Print characters to the screen 
PrintCharacters:
    lodsb ;Load string 
    or al, al
    jz complete
    mov ah, 0x0e 	
    int 0x10 ;BIOS Interrupt 0x10 - Used to print characters on the screen via Video Memory 
    jmp PrintCharacters ;Loop
complete:
    call Println

;Prints empty new lines like '\n' in C/C++ 	
Println: 
    mov al, 0	; null terminator '\0'
    stosb       ; Store string 

    ;Adds a newline break '\n'
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10
    mov al, 0x0A 
    int 0x10
	ret

;Reboot the Machine 
Reboot: 
    mov si, awaiting_anykey_message
    call PrintCharacters
    call GetPressedKey 

    ;Sends us to the end of the memory
    ;causing reboot 
    db 0x0ea 
    dw 0x0000 
    dw 0xffff 

;Gets the pressed key 
GetPressedKey:
    mov ah, 0
    int 0x16  ;BIOS Keyboard Service 
    ret 

;Bootloader entry-code 
main:
   cli ;Clear interrupts 
   ;Setup stack segments 
   mov ax,cs              
   mov ds,ax   
   mov es,ax               
   mov ss,ax                
   sti ;Enable interrupts

   mov si, message
   call PrintCharacters

   mov si, copyright
   call PrintCharacters

   call Println
   call Println

   call Reboot 

   times 510 - ($-$$) db 0 ;Fill the rest of the bootloader with zeros
   dw 0xAA55 ;Boot signature