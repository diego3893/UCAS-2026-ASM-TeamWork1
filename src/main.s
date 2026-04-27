.section .text

.global _start
_start:
    call file_input
    call split
    call max_cnt
    call output

    call as_exit