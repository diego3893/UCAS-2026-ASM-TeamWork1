.section .rodata
    msg_word: .string "出现次数最多的单词有:\n"
    msg_word_len = . - msg_word
    msg_cnt: .string "出现次数: "
    msg_cnt_len = . - msg_cnt
    msg_nl: .string "\n"
    msg_nl_len = . - msg_nl

.section .bss
    .extern dictionary
    .extern max_index
    .extern dict_size
    .lcomm itoa_buf, 16 # itoa的缓冲区

.section .text
.global output
    .type output, @function

output:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %esi
    pushl %edi

    movl max_index, %eax
    imull $104, %eax
    movl dictionary+100(%eax), %edi # edi=max_cnt

    movl $4, %eax
    movl $1, %ebx
    movl $msg_word, %ecx
    movl $msg_word_len, %edx
    int $0x80

    movl $0, %esi # esi=i=0

.loop_dict:
    cmpl dict_size, %esi
    jge .print_count_info

    movl %esi, %eax
    imull $104, %eax
    movl dictionary+100(%eax), %edx # edx=dictionary[i].count

    cmpl %edi, %edx
    jne .next_iter # 不是max_cnt不打印

    leal dictionary(%eax), %ecx
    movl %ecx, %ebx
    movl $0, %edx # edx=strlen(s)，初始化为0

.calc_len: # strlen
    cmpb $0, (%ebx) # ebx是备份的字符串地址，找字符串末尾的'\0'
    je .do_print_word
    incl %ebx
    incl %edx
    jmp .calc_len

.do_print_word:
    movl $4, %eax
    movl $1, %ebx
    int $0x80
    movl $4, %eax
    movl $1, %ebx
    movl $msg_nl, %ecx
    movl $msg_nl_len, %edx
    int $0x80

.next_iter:
    incl %esi
    jmp .loop_dict

.print_count_info:
    movl $4, %eax
    movl $1, %ebx
    movl $msg_cnt, %ecx
    movl $msg_cnt_len, %edx
    int $0x80

    # itoa
    movl %edi, %eax # eax=max_count，转换成字符串
    movl $itoa_buf+15, %ecx # ecx指向缓冲区末尾，倒序写入
    movb $0, (%ecx) # 补一个'\0'
    movl $10, %ebx # 每次除以10，消去末位

.itoa_loop:
    decl %ecx # 指针前移
    xorl %edx, %edx # 清空edx
    divl %ebx # eax/=10，edx=eax%10
    addb $'0', %dl
    movb %dl, (%ecx) # 当前字符存到缓冲区
    testl %eax, %eax # 检查商是否为0
    jnz .itoa_loop

    # 打印
    movl $itoa_buf+15, %edx
    subl %ecx, %edx # 缓冲区尾地址-当前头部指针=字符串实际长度
    movl $4, %eax
    movl $1, %ebx
    int $0x80

    movl $4, %eax
    movl $1, %ebx
    movl $msg_nl, %ecx
    movl $msg_nl_len, %edx
    int $0x80

    popl %edi
    popl %esi
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret