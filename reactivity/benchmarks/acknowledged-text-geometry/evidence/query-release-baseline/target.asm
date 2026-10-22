
/tmp/gpui-acknowledged-text-evidence/query-release-baseline/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a5bbc0 <<gpui::runtime::query::Part>::target>:
  a5bbc0:	48 8b 57 20          	mov    0x20(%rdi),%rdx
  a5bbc4:	48 85 d2             	test   %rdx,%rdx
  a5bbc7:	74 08                	je     a5bbd1 <<gpui::runtime::query::Part>::target+0x11>
  a5bbc9:	48 8b 46 28          	mov    0x28(%rsi),%rax
  a5bbcd:	48 8b 00             	mov    (%rax),%rax
  a5bbd0:	c3                   	ret
  a5bbd1:	50                   	push   %rax
  a5bbd2:	48 8d 3d 87 da 72 ff 	lea    -0x8d2579(%rip),%rdi        # 189660 <anon.f6ff16f7f4c35f4266a75630a34fc967.11.llvm.14217339180126818166>
  a5bbd9:	48 8d 15 f8 f2 a5 00 	lea    0xa5f2f8(%rip),%rdx        # 14baed8 <anon.f6ff16f7f4c35f4266a75630a34fc967.12.llvm.14217339180126818166>
  a5bbe0:	be 20 00 00 00       	mov    $0x20,%esi
  a5bbe5:	ff 15 9d c2 ac 00    	call   *0xacc29d(%rip)        # 1527e88 <_DYNAMIC+0x370>
