
/tmp/gpui-text-map-query-controls/24trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000065fea0 <selection_queries::motion>:
  65fea0:	50                   	push   %rax
  65fea1:	ff 15 f1 74 12 00    	call   *0x1274f1(%rip)        # 787398 <_DYNAMIC+0x310>
  65fea7:	80 fa 02             	cmp    $0x2,%dl
  65feaa:	74 02                	je     65feae <selection_queries::motion+0xe>
  65feac:	59                   	pop    %rcx
  65fead:	c3                   	ret
  65feae:	48 8d 3d 3b c6 11 00 	lea    0x11c63b(%rip),%rdi        # 77c4f0 <__frame_dummy_init_array_entry+0xe0>
  65feb5:	ff 15 75 74 12 00    	call   *0x127475(%rip)        # 787330 <_DYNAMIC+0x2a8>
