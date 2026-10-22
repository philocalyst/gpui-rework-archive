
/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000065f260 <selection_queries::hit>:
  65f260:	50                   	push   %rax
  65f261:	ff 15 e9 82 12 00    	call   *0x1282e9(%rip)        # 787550 <_DYNAMIC+0x2a0>
  65f267:	80 fa 02             	cmp    $0x2,%dl
  65f26a:	74 02                	je     65f26e <selection_queries::hit+0xe>
  65f26c:	59                   	pop    %rcx
  65f26d:	c3                   	ret
  65f26e:	48 8d 3d fb d3 11 00 	lea    0x11d3fb(%rip),%rdi        # 77c670 <__frame_dummy_init_array_entry+0x50>
  65f275:	ff 15 dd 82 12 00    	call   *0x1282dd(%rip)        # 787558 <_DYNAMIC+0x2a8>
