# Bootloader
*Bootloader* is a small program that is executed under boot up in 16-bit **Real Mode**. It is very small, in fact, it is only 512 bytes and it resides on the very first sector of a boot device, **sector 0**. The bootloader is used to load more complex programs like an OS Kernel. The 512-byte bootloader code is stored with the *Master Boot Record (MBR)* and is loaded by the *Basic Input/Output System (BIOS)* via Interrupt (INT) 0x19 at **0x0000:0x7c00h**. This is a standard sequence in booting for almost all x86 PCs, except that in some PCs it can be loaded to 0x7c00:0x0000h.

## Build
`nasm -f bin bootloader.asm -o bootloader.img`

## Result
<img src="bootloader_running.png" />