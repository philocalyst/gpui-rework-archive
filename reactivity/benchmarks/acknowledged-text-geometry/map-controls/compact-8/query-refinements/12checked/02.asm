
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000065f210 <selection_queries::hit>:
  65f210:	50                   	push   %rax
  65f211:	ff 15 a9 81 12 00    	call   *0x1281a9(%rip)        # 7873c0 <_DYNAMIC+0x2a0>
  65f217:	80 fa 02             	cmp    $0x2,%dl
  65f21a:	74 02                	je     65f21e <selection_queries::hit+0xe>
  65f21c:	59                   	pop    %rcx
  65f21d:	c3                   	ret
  65f21e:	48 8d 3d bb d2 11 00 	lea    0x11d2bb(%rip),%rdi        # 77c4e0 <__frame_dummy_init_array_entry+0x50>
  65f225:	ff 15 9d 81 12 00    	call   *0x12819d(%rip)        # 7873c8 <_DYNAMIC+0x2a8>
