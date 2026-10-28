
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000660570 <selection_queries::motion>:
  660570:	50                   	push   %rax
  660571:	ff 15 01 92 12 00    	call   *0x129201(%rip)        # 789778 <_DYNAMIC+0x310>
  660577:	80 fa 02             	cmp    $0x2,%dl
  66057a:	74 02                	je     66057e <selection_queries::motion+0xe>
  66057c:	59                   	pop    %rcx
  66057d:	c3                   	ret
  66057e:	48 8d 3d 1b e3 11 00 	lea    0x11e31b(%rip),%rdi        # 77e8a0 <__frame_dummy_init_array_entry+0xe0>
  660585:	ff 15 85 91 12 00    	call   *0x129185(%rip)        # 789710 <_DYNAMIC+0x2a8>
