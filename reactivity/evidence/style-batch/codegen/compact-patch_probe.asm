
/tmp/gpui-style-compact-release-target/release/deps/gpui-559efaa5b4b411d5:     file format elf64-x86-64


Disassembly of section .text:

00000000008e8ca0 <gpui::runtime::style_ledger::batch_phase::patch_probe>:
  8e8ca0:	41 56                	push   %r14
  8e8ca2:	53                   	push   %rbx
  8e8ca3:	48 83 ec 78          	sub    $0x78,%rsp
  8e8ca7:	48 89 f0             	mov    %rsi,%rax
  8e8caa:	48 8b 37             	mov    (%rdi),%rsi
  8e8cad:	48 85 f6             	test   %rsi,%rsi
  8e8cb0:	0f 84 d3 00 00 00    	je     8e8d89 <gpui::runtime::style_ledger::batch_phase::patch_probe+0xe9>
  8e8cb6:	8b 8e a0 07 00 00    	mov    0x7a0(%rsi),%ecx
  8e8cbc:	83 f9 ff             	cmp    $0xffffffff,%ecx
  8e8cbf:	74 47                	je     8e8d08 <gpui::runtime::style_ledger::batch_phase::patch_probe+0x68>
  8e8cc1:	ff c1                	inc    %ecx
  8e8cc3:	89 8e a0 07 00 00    	mov    %ecx,0x7a0(%rsi)
  8e8cc9:	0f 10 00             	movups (%rax),%xmm0
  8e8ccc:	0f 11 86 90 07 00 00 	movups %xmm0,0x790(%rsi)
  8e8cd3:	48 c7 86 58 09 00 00 	movq   $0x0,0x958(%rsi)
  8e8cda:	00 00 00 00 
  8e8cde:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  8e8ce3:	48 ba 01 00 00 00 01 	movabs $0x100000001,%rdx
  8e8cea:	00 00 00 
  8e8ced:	e8 4e 12 d2 ff       	call   609f40 <<gpui::runtime::Runtime<gpui::runtime::style_ledger::batch_phase::Theme>>::patch>
  8e8cf2:	83 7c 24 40 fe       	cmpl   $0xfffffffe,0x40(%rsp)
  8e8cf7:	75 28                	jne    8e8d21 <gpui::runtime::style_ledger::batch_phase::patch_probe+0x81>
  8e8cf9:	80 7c 24 48 00       	cmpb   $0x0,0x48(%rsp)
  8e8cfe:	75 70                	jne    8e8d70 <gpui::runtime::style_ledger::batch_phase::patch_probe+0xd0>
  8e8d00:	48 83 c4 78          	add    $0x78,%rsp
  8e8d04:	5b                   	pop    %rbx
  8e8d05:	41 5e                	pop    %r14
  8e8d07:	c3                   	ret
  8e8d08:	48 8d 3d c0 26 7a ff 	lea    -0x85d940(%rip),%rdi        # 8b3cf <anon.0bc4f2871a7f66bd197ac5014c0b6730.220.llvm.13088362880924847524>
  8e8d0f:	48 8d 15 8a 7a 37 00 	lea    0x377a8a(%rip),%rdx        # c607a0 <anon.0bc4f2871a7f66bd197ac5014c0b6730.222.llvm.13088362880924847524>
  8e8d16:	be 19 00 00 00       	mov    $0x19,%esi
  8e8d1b:	ff 15 97 92 3a 00    	call   *0x3a9297(%rip)        # c91fb8 <_DYNAMIC+0x298>
  8e8d21:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8e8d26:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8e8d2b:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  8e8d30:	0f 10 4c 24 50       	movups 0x50(%rsp),%xmm1
  8e8d35:	0f 10 54 24 60       	movups 0x60(%rsp),%xmm2
  8e8d3a:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
  8e8d3f:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  8e8d44:	0f 29 04 24          	movaps %xmm0,(%rsp)
  8e8d48:	48 8d 3d 29 3e 7a ff 	lea    -0x85c1d7(%rip),%rdi        # 8cb78 <anon.8e7f7beb62b89ca650cc5690a13cb3a4.80.llvm.11208107661761841984>
  8e8d4f:	48 8d 0d da a3 37 00 	lea    0x37a3da(%rip),%rcx        # c63130 <anon.8e7f7beb62b89ca650cc5690a13cb3a4.79.llvm.11208107661761841984>
  8e8d56:	4c 8d 05 cb a8 37 00 	lea    0x37a8cb(%rip),%r8        # c63628 <anon.8e7f7beb62b89ca650cc5690a13cb3a4.148.llvm.11208107661761841984+0x190>
  8e8d5d:	48 89 e3             	mov    %rsp,%rbx
  8e8d60:	be 2b 00 00 00       	mov    $0x2b,%esi
  8e8d65:	48 89 da             	mov    %rbx,%rdx
  8e8d68:	ff 15 f2 92 3a 00    	call   *0x3a92f2(%rip)        # c92060 <_DYNAMIC+0x340>
  8e8d6e:	eb 50                	jmp    8e8dc0 <gpui::runtime::style_ledger::batch_phase::patch_probe+0x120>
  8e8d70:	48 8d 3d 67 40 7a ff 	lea    -0x85bf99(%rip),%rdi        # 8cdde <anon.8e7f7beb62b89ca650cc5690a13cb3a4.106.llvm.11208107661761841984+0x1ab>
  8e8d77:	48 8d 15 c2 a8 37 00 	lea    0x37a8c2(%rip),%rdx        # c63640 <anon.8e7f7beb62b89ca650cc5690a13cb3a4.148.llvm.11208107661761841984+0x1a8>
  8e8d7e:	be 3a 00 00 00       	mov    $0x3a,%esi
  8e8d83:	ff 15 f7 93 3a 00    	call   *0x3a93f7(%rip)        # c92180 <_DYNAMIC+0x460>
  8e8d89:	48 c7 04 24 0d 00 00 	movq   $0xd,(%rsp)
  8e8d90:	00 
  8e8d91:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  8e8d98:	00 00 
  8e8d9a:	48 8d 3d d7 3d 7a ff 	lea    -0x85c229(%rip),%rdi        # 8cb78 <anon.8e7f7beb62b89ca650cc5690a13cb3a4.80.llvm.11208107661761841984>
  8e8da1:	48 8d 0d 88 a3 37 00 	lea    0x37a388(%rip),%rcx        # c63130 <anon.8e7f7beb62b89ca650cc5690a13cb3a4.79.llvm.11208107661761841984>
  8e8da8:	4c 8d 05 61 a8 37 00 	lea    0x37a861(%rip),%r8        # c63610 <anon.8e7f7beb62b89ca650cc5690a13cb3a4.148.llvm.11208107661761841984+0x178>
  8e8daf:	48 89 e3             	mov    %rsp,%rbx
  8e8db2:	be 2b 00 00 00       	mov    $0x2b,%esi
  8e8db7:	48 89 da             	mov    %rbx,%rdx
  8e8dba:	ff 15 a0 92 3a 00    	call   *0x3a92a0(%rip)        # c92060 <_DYNAMIC+0x340>
  8e8dc0:	0f 0b                	ud2
  8e8dc2:	eb 00                	jmp    8e8dc4 <gpui::runtime::style_ledger::batch_phase::patch_probe+0x124>
  8e8dc4:	49 89 c6             	mov    %rax,%r14
  8e8dc7:	48 89 df             	mov    %rbx,%rdi
  8e8dca:	e8 c1 80 ff ff       	call   8e0e90 <core::ptr::drop_glue::<gpui::runtime::Error>>
  8e8dcf:	4c 89 f7             	mov    %r14,%rdi
  8e8dd2:	e8 59 2d 37 00       	call   c5bb30 <_Unwind_Resume@plt>
