
/tmp/gpui-text-map-query-final/24trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000065f160 <selection_queries::hit>:
  65f160:	50                   	push   %rax
  65f161:	ff 15 c1 81 12 00    	call   *0x1281c1(%rip)        # 787328 <_DYNAMIC+0x2a0>
  65f167:	80 fa 02             	cmp    $0x2,%dl
  65f16a:	74 02                	je     65f16e <selection_queries::hit+0xe>
  65f16c:	59                   	pop    %rcx
  65f16d:	c3                   	ret
  65f16e:	48 8d 3d eb d2 11 00 	lea    0x11d2eb(%rip),%rdi        # 77c460 <__frame_dummy_init_array_entry+0x50>
  65f175:	ff 15 b5 81 12 00    	call   *0x1281b5(%rip)        # 787330 <_DYNAMIC+0x2a8>
