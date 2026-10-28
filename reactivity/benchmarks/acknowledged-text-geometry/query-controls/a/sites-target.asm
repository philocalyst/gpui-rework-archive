
/tmp/gpui-ack-query-comparison/a/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a7d9f0 <<gpui::identity::Sites>::target>:
  a7d9f0:	48 85 f6             	test   %rsi,%rsi
  a7d9f3:	74 07                	je     a7d9fc <<gpui::identity::Sites>::target+0xc>
  a7d9f5:	48 8b 07             	mov    (%rdi),%rax
  a7d9f8:	48 89 f2             	mov    %rsi,%rdx
  a7d9fb:	c3                   	ret
  a7d9fc:	50                   	push   %rax
  a7d9fd:	48 8d 3d dc cb 70 ff 	lea    -0x8f3424(%rip),%rdi        # 18a5e0 <anon.f29bd53783d54abf9c05f2e13d9a3fb7.57.llvm.11816638417077940530>
  a7da04:	48 8d 15 85 54 a4 00 	lea    0xa45485(%rip),%rdx        # 14c2e90 <anon.f29bd53783d54abf9c05f2e13d9a3fb7.58.llvm.11816638417077940530>
  a7da0b:	be 20 00 00 00       	mov    $0x20,%esi
  a7da10:	ff 15 02 25 ab 00    	call   *0xab2502(%rip)        # 152ff18 <_DYNAMIC+0x378>
