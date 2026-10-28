
/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000065ffa0 <selection_queries::motion>:
  65ffa0:	50                   	push   %rax
  65ffa1:	ff 15 19 76 12 00    	call   *0x127619(%rip)        # 7875c0 <_DYNAMIC+0x310>
  65ffa7:	80 fa 02             	cmp    $0x2,%dl
  65ffaa:	74 02                	je     65ffae <selection_queries::motion+0xe>
  65ffac:	59                   	pop    %rcx
  65ffad:	c3                   	ret
  65ffae:	48 8d 3d 4b c7 11 00 	lea    0x11c74b(%rip),%rdi        # 77c700 <__frame_dummy_init_array_entry+0xe0>
  65ffb5:	ff 15 9d 75 12 00    	call   *0x12759d(%rip)        # 787558 <_DYNAMIC+0x2a8>
