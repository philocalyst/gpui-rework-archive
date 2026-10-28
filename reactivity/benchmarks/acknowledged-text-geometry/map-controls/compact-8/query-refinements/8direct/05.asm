
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000065f830 <selection_queries::hit>:
  65f830:	50                   	push   %rax
  65f831:	ff 15 d1 9e 12 00    	call   *0x129ed1(%rip)        # 789708 <_DYNAMIC+0x2a0>
  65f837:	80 fa 02             	cmp    $0x2,%dl
  65f83a:	74 02                	je     65f83e <selection_queries::hit+0xe>
  65f83c:	59                   	pop    %rcx
  65f83d:	c3                   	ret
  65f83e:	48 8d 3d cb ef 11 00 	lea    0x11efcb(%rip),%rdi        # 77e810 <__frame_dummy_init_array_entry+0x50>
  65f845:	ff 15 c5 9e 12 00    	call   *0x129ec5(%rip)        # 789710 <_DYNAMIC+0x2a8>
