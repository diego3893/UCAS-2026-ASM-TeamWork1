.section .text
.global as_exit
    .type as_exit, @function

as_exit:
    movl $1, %eax       
    movl $0, %ebx 
    int $0x80