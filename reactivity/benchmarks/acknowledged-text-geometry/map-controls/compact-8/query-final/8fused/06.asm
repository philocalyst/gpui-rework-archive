
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000660550 <selection_queries::motion>:
  660550:	50                   	push   %rax
  660551:	ff 15 e1 92 12 00    	call   *0x1292e1(%rip)        # 789838 <_DYNAMIC+0x310>
  660557:	80 fa 02             	cmp    $0x2,%dl
  66055a:	74 02                	je     66055e <selection_queries::motion+0xe>
  66055c:	59                   	pop    %rcx
  66055d:	c3                   	ret
  66055e:	48 8d 3d cb e3 11 00 	lea    0x11e3cb(%rip),%rdi        # 77e930 <__frame_dummy_init_array_entry+0xe0>
  660565:	ff 15 65 92 12 00    	call   *0x129265(%rip)        # 7897d0 <_DYNAMIC+0x2a8>
