
/tmp/gpui-style-counted-release-target/release/deps/gpui-559efaa5b4b411d5:     file format elf64-x86-64


Disassembly of section .text:

000000000086ec70 <gpui::runtime::style_ledger::batch_phase::patch_probe>:
  86ec70:	41 56                	push   %r14
  86ec72:	53                   	push   %rbx
  86ec73:	48 83 ec 78          	sub    $0x78,%rsp
  86ec77:	48 89 f0             	mov    %rsi,%rax
  86ec7a:	48 8b 37             	mov    (%rdi),%rsi
  86ec7d:	48 85 f6             	test   %rsi,%rsi
  86ec80:	0f 84 d3 00 00 00    	je     86ed59 <gpui::runtime::style_ledger::batch_phase::patch_probe+0xe9>
  86ec86:	8b 8e a0 07 00 00    	mov    0x7a0(%rsi),%ecx
  86ec8c:	83 f9 ff             	cmp    $0xffffffff,%ecx
  86ec8f:	74 47                	je     86ecd8 <gpui::runtime::style_ledger::batch_phase::patch_probe+0x68>
  86ec91:	ff c1                	inc    %ecx
  86ec93:	89 8e a0 07 00 00    	mov    %ecx,0x7a0(%rsi)
  86ec99:	0f 10 00             	movups (%rax),%xmm0
  86ec9c:	0f 11 86 90 07 00 00 	movups %xmm0,0x790(%rsi)
  86eca3:	48 c7 86 58 09 00 00 	movq   $0x0,0x958(%rsi)
  86ecaa:	00 00 00 00 
  86ecae:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  86ecb3:	48 ba 01 00 00 00 01 	movabs $0x100000001,%rdx
  86ecba:	00 00 00 
  86ecbd:	e8 2e b8 d9 ff       	call   60a4f0 <<gpui::runtime::Runtime<gpui::runtime::style_ledger::batch_phase::Theme>>::patch>
  86ecc2:	83 7c 24 40 fe       	cmpl   $0xfffffffe,0x40(%rsp)
  86ecc7:	75 28                	jne    86ecf1 <gpui::runtime::style_ledger::batch_phase::patch_probe+0x81>
  86ecc9:	80 7c 24 48 00       	cmpb   $0x0,0x48(%rsp)
  86ecce:	75 70                	jne    86ed40 <gpui::runtime::style_ledger::batch_phase::patch_probe+0xd0>
  86ecd0:	48 83 c4 78          	add    $0x78,%rsp
  86ecd4:	5b                   	pop    %rbx
  86ecd5:	41 5e                	pop    %r14
  86ecd7:	c3                   	ret
  86ecd8:	48 8d 3d 41 c1 81 ff 	lea    -0x7e3ebf(%rip),%rdi        # 8ae20 <anon.15ca61b227bffbed5cbf57f2a9eb0129.78.llvm.8755791432489617226>
  86ecdf:	48 8d 15 42 37 3f 00 	lea    0x3f3742(%rip),%rdx        # c62428 <anon.15ca61b227bffbed5cbf57f2a9eb0129.80.llvm.8755791432489617226>
  86ece6:	be 19 00 00 00       	mov    $0x19,%esi
  86eceb:	ff 15 3f 66 42 00    	call   *0x42663f(%rip)        # c95330 <_DYNAMIC+0x290>
  86ecf1:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  86ecf6:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  86ecfb:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  86ed00:	0f 10 4c 24 50       	movups 0x50(%rsp),%xmm1
  86ed05:	0f 10 54 24 60       	movups 0x60(%rsp),%xmm2
  86ed0a:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
  86ed0f:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  86ed14:	0f 29 04 24          	movaps %xmm0,(%rsp)
  86ed18:	48 8d 3d f1 c7 81 ff 	lea    -0x7e380f(%rip),%rdi        # 8b510 <anon.0ccdd01f9eda8572f8ac6f637216e6b0.79.llvm.13523452353338582590>
  86ed1f:	48 8d 0d 6a 45 3f 00 	lea    0x3f456a(%rip),%rcx        # c63290 <anon.0ccdd01f9eda8572f8ac6f637216e6b0.80.llvm.13523452353338582590>
  86ed26:	4c 8d 05 8b 4d 3f 00 	lea    0x3f4d8b(%rip),%r8        # c63ab8 <anon.0ccdd01f9eda8572f8ac6f637216e6b0.149.llvm.13523452353338582590+0x4d0>
  86ed2d:	48 89 e3             	mov    %rsp,%rbx
  86ed30:	be 2b 00 00 00       	mov    $0x2b,%esi
  86ed35:	48 89 da             	mov    %rbx,%rdx
  86ed38:	ff 15 a2 66 42 00    	call   *0x4266a2(%rip)        # c953e0 <_DYNAMIC+0x340>
  86ed3e:	eb 50                	jmp    86ed90 <gpui::runtime::style_ledger::batch_phase::patch_probe+0x120>
  86ed40:	48 8d 3d 84 cc 81 ff 	lea    -0x7e337c(%rip),%rdi        # 8b9cb <anon.0ccdd01f9eda8572f8ac6f637216e6b0.104.llvm.13523452353338582590+0x418>
  86ed47:	48 8d 15 82 4d 3f 00 	lea    0x3f4d82(%rip),%rdx        # c63ad0 <anon.0ccdd01f9eda8572f8ac6f637216e6b0.149.llvm.13523452353338582590+0x4e8>
  86ed4e:	be 3a 00 00 00       	mov    $0x3a,%esi
  86ed53:	ff 15 a7 67 42 00    	call   *0x4267a7(%rip)        # c95500 <_DYNAMIC+0x460>
  86ed59:	48 c7 04 24 0d 00 00 	movq   $0xd,(%rsp)
  86ed60:	00 
  86ed61:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  86ed68:	00 00 
  86ed6a:	48 8d 3d 9f c7 81 ff 	lea    -0x7e3861(%rip),%rdi        # 8b510 <anon.0ccdd01f9eda8572f8ac6f637216e6b0.79.llvm.13523452353338582590>
  86ed71:	48 8d 0d 18 45 3f 00 	lea    0x3f4518(%rip),%rcx        # c63290 <anon.0ccdd01f9eda8572f8ac6f637216e6b0.80.llvm.13523452353338582590>
  86ed78:	4c 8d 05 21 4d 3f 00 	lea    0x3f4d21(%rip),%r8        # c63aa0 <anon.0ccdd01f9eda8572f8ac6f637216e6b0.149.llvm.13523452353338582590+0x4b8>
  86ed7f:	48 89 e3             	mov    %rsp,%rbx
  86ed82:	be 2b 00 00 00       	mov    $0x2b,%esi
  86ed87:	48 89 da             	mov    %rbx,%rdx
  86ed8a:	ff 15 50 66 42 00    	call   *0x426650(%rip)        # c953e0 <_DYNAMIC+0x340>
  86ed90:	0f 0b                	ud2
  86ed92:	eb 00                	jmp    86ed94 <gpui::runtime::style_ledger::batch_phase::patch_probe+0x124>
  86ed94:	49 89 c6             	mov    %rax,%r14
  86ed97:	48 89 df             	mov    %rbx,%rdi
  86ed9a:	e8 71 64 ff ff       	call   865210 <core::ptr::drop_glue::<gpui::runtime::Error>>
  86ed9f:	4c 89 f7             	mov    %r14,%rdi
  86eda2:	e8 d9 fc 3e 00       	call   c5ea80 <_Unwind_Resume@plt>
