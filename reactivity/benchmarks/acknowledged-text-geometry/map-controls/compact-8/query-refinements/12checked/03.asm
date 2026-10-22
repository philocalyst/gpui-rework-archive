
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000065ff50 <selection_queries::motion>:
  65ff50:	50                   	push   %rax
  65ff51:	ff 15 d9 74 12 00    	call   *0x1274d9(%rip)        # 787430 <_DYNAMIC+0x310>
  65ff57:	80 fa 02             	cmp    $0x2,%dl
  65ff5a:	74 02                	je     65ff5e <selection_queries::motion+0xe>
  65ff5c:	59                   	pop    %rcx
  65ff5d:	c3                   	ret
  65ff5e:	48 8d 3d 0b c6 11 00 	lea    0x11c60b(%rip),%rdi        # 77c570 <__frame_dummy_init_array_entry+0xe0>
  65ff65:	ff 15 5d 74 12 00    	call   *0x12745d(%rip)        # 7873c8 <_DYNAMIC+0x2a8>
