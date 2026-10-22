
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000065f240 <selection_queries::hit>:
  65f240:	50                   	push   %rax
  65f241:	ff 15 79 83 12 00    	call   *0x128379(%rip)        # 7875c0 <_DYNAMIC+0x2a0>
  65f247:	80 fa 02             	cmp    $0x2,%dl
  65f24a:	74 02                	je     65f24e <selection_queries::hit+0xe>
  65f24c:	59                   	pop    %rcx
  65f24d:	c3                   	ret
  65f24e:	48 8d 3d 5b d4 11 00 	lea    0x11d45b(%rip),%rdi        # 77c6b0 <__frame_dummy_init_array_entry+0x50>
  65f255:	ff 15 6d 83 12 00    	call   *0x12836d(%rip)        # 7875c8 <_DYNAMIC+0x2a8>
