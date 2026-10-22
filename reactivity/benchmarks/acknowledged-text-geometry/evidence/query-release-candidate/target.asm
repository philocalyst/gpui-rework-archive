
/tmp/gpui-acknowledged-text-evidence/query-release-candidate/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a7c590 <<gpui::runtime::query::Part>::target>:
  a7c590:	50                   	push   %rax
  a7c591:	89 f0                	mov    %esi,%eax
  a7c593:	48 8b 77 38          	mov    0x38(%rdi),%rsi
  a7c597:	48 39 c6             	cmp    %rax,%rsi
  a7c59a:	76 38                	jbe    a7c5d4 <<gpui::runtime::query::Part>::target+0x44>
  a7c59c:	48 8b 4f 30          	mov    0x30(%rdi),%rcx
  a7c5a0:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  a7c5a4:	48 c1 e0 04          	shl    $0x4,%rax
  a7c5a8:	48 8b 54 01 20       	mov    0x20(%rcx,%rax,1),%rdx
  a7c5ad:	48 85 d2             	test   %rdx,%rdx
  a7c5b0:	74 09                	je     a7c5bb <<gpui::runtime::query::Part>::target+0x2b>
  a7c5b2:	48 8b 47 28          	mov    0x28(%rdi),%rax
  a7c5b6:	48 8b 00             	mov    (%rax),%rax
  a7c5b9:	59                   	pop    %rcx
  a7c5ba:	c3                   	ret
  a7c5bb:	48 8d 3d be da 70 ff 	lea    -0x8f2542(%rip),%rdi        # 18a080 <anon.8b8e1a483624fd5dab70611b728235bd.57.llvm.1428813640133867424>
  a7c5c2:	48 8d 15 c7 5c a4 00 	lea    0xa45cc7(%rip),%rdx        # 14c2290 <anon.8b8e1a483624fd5dab70611b728235bd.58.llvm.1428813640133867424>
  a7c5c9:	be 20 00 00 00       	mov    $0x20,%esi
  a7c5ce:	ff 15 1c 2f ab 00    	call   *0xab2f1c(%rip)        # 152f4f0 <_DYNAMIC+0x378>
  a7c5d4:	48 8d 15 35 5c a4 00 	lea    0xa45c35(%rip),%rdx        # 14c2210 <anon.8b8e1a483624fd5dab70611b728235bd.24.llvm.1428813640133867424>
  a7c5db:	48 89 c7             	mov    %rax,%rdi
  a7c5de:	ff 15 44 2e ab 00    	call   *0xab2e44(%rip)        # 152f428 <_DYNAMIC+0x2b0>
