
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000065f810 <selection_queries::hit>:
  65f810:	50                   	push   %rax
  65f811:	ff 15 b1 9f 12 00    	call   *0x129fb1(%rip)        # 7897c8 <_DYNAMIC+0x2a0>
  65f817:	80 fa 02             	cmp    $0x2,%dl
  65f81a:	74 02                	je     65f81e <selection_queries::hit+0xe>
  65f81c:	59                   	pop    %rcx
  65f81d:	c3                   	ret
  65f81e:	48 8d 3d 7b f0 11 00 	lea    0x11f07b(%rip),%rdi        # 77e8a0 <__frame_dummy_init_array_entry+0x50>
  65f825:	ff 15 a5 9f 12 00    	call   *0x129fa5(%rip)        # 7897d0 <_DYNAMIC+0x2a8>
