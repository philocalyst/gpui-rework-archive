
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000065ff80 <selection_queries::motion>:
  65ff80:	50                   	push   %rax
  65ff81:	ff 15 a9 76 12 00    	call   *0x1276a9(%rip)        # 787630 <_DYNAMIC+0x310>
  65ff87:	80 fa 02             	cmp    $0x2,%dl
  65ff8a:	74 02                	je     65ff8e <selection_queries::motion+0xe>
  65ff8c:	59                   	pop    %rcx
  65ff8d:	c3                   	ret
  65ff8e:	48 8d 3d ab c7 11 00 	lea    0x11c7ab(%rip),%rdi        # 77c740 <__frame_dummy_init_array_entry+0xe0>
  65ff95:	ff 15 2d 76 12 00    	call   *0x12762d(%rip)        # 7875c8 <_DYNAMIC+0x2a8>
