
/tmp/gpui-ack-query-comparison/usize/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a61760 <<gpui::identity::Sites>::target>:
  a61760:	48 85 f6             	test   %rsi,%rsi
  a61763:	74 07                	je     a6176c <<gpui::identity::Sites>::target+0xc>
  a61765:	48 8b 07             	mov    (%rdi),%rax
  a61768:	48 89 f2             	mov    %rsi,%rdx
  a6176b:	c3                   	ret
  a6176c:	50                   	push   %rax
  a6176d:	48 8d 3d 6c 8d 72 ff 	lea    -0x8d7294(%rip),%rdi        # 18a4e0 <anon.3619ef3883629585de0d6acaf5c725d7.55.llvm.10332671355869831320>
  a61774:	48 8d 15 cd ff a5 00 	lea    0xa5ffcd(%rip),%rdx        # 14c1748 <anon.3619ef3883629585de0d6acaf5c725d7.56.llvm.10332671355869831320>
  a6177b:	be 20 00 00 00       	mov    $0x20,%esi
  a61780:	ff 15 12 e3 ac 00    	call   *0xace312(%rip)        # 152fa98 <_DYNAMIC+0x378>
