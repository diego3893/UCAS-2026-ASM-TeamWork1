.section .bss
    .global max_index
    .extern dictionary
    .extern dict_size
    .lcomm max_index, 4

.section .text
.global max_cnt
.type max_cnt, @function

max_cnt:
    pushl %ebp
    movl %esp, %ebp

    movl $0, max_index 
    cmpl $1, dict_size
    jle .end_max # 没有词或只有1个词，不用比较

    movl $1, %ecx # ecx=i=1
.max_loop:
    cmpl dict_size, %ecx
    jge .end_max

    movl %ecx, %eax
    imull $104, %eax
    movl dictionary+100(%eax), %esi # esi=dictionary[i].count

    movl max_index, %eax
    imull $104, %eax
    movl dictionary+100(%eax), %edx # edx=dictionary[max_index].count

    cmpl %edx, %esi
    jle .next_max
    movl %ecx, max_index # 更新max_index

.next_max:
    incl %ecx
    jmp .max_loop

.end_max:
    movl %ebp, %esp
    popl %ebp
    ret