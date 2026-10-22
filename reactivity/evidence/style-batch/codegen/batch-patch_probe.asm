
/tmp/gpui-style-batch-release-target/release/deps/gpui-559efaa5b4b411d5:     file format elf64-x86-64


Disassembly of section .text:

000000000090e7c0 <gpui::runtime::style_ledger::batch_phase::patch_probe>:
  90e7c0:	41 56                	push   %r14
  90e7c2:	53                   	push   %rbx
  90e7c3:	48 83 ec 78          	sub    $0x78,%rsp
  90e7c7:	48 89 f0             	mov    %rsi,%rax
  90e7ca:	48 8b 37             	mov    (%rdi),%rsi
  90e7cd:	48 85 f6             	test   %rsi,%rsi
  90e7d0:	0f 84 d3 00 00 00    	je     90e8a9 <gpui::runtime::style_ledger::batch_phase::patch_probe+0xe9>
  90e7d6:	8b 8e a0 07 00 00    	mov    0x7a0(%rsi),%ecx
  90e7dc:	83 f9 ff             	cmp    $0xffffffff,%ecx
  90e7df:	74 47                	je     90e828 <gpui::runtime::style_ledger::batch_phase::patch_probe+0x68>
  90e7e1:	ff c1                	inc    %ecx
  90e7e3:	89 8e a0 07 00 00    	mov    %ecx,0x7a0(%rsi)
  90e7e9:	0f 10 00             	movups (%rax),%xmm0
  90e7ec:	0f 11 86 90 07 00 00 	movups %xmm0,0x790(%rsi)
  90e7f3:	48 c7 86 58 09 00 00 	movq   $0x0,0x958(%rsi)
  90e7fa:	00 00 00 00 
  90e7fe:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  90e803:	48 ba 01 00 00 00 01 	movabs $0x100000001,%rdx
  90e80a:	00 00 00 
  90e80d:	e8 8e e5 cf ff       	call   60cda0 <<gpui::runtime::Runtime<gpui::runtime::style_ledger::batch_phase::Theme>>::patch>
  90e812:	83 7c 24 40 fe       	cmpl   $0xfffffffe,0x40(%rsp)
  90e817:	75 28                	jne    90e841 <gpui::runtime::style_ledger::batch_phase::patch_probe+0x81>
  90e819:	80 7c 24 48 00       	cmpb   $0x0,0x48(%rsp)
  90e81e:	75 70                	jne    90e890 <gpui::runtime::style_ledger::batch_phase::patch_probe+0xd0>
  90e820:	48 83 c4 78          	add    $0x78,%rsp
  90e824:	5b                   	pop    %rbx
  90e825:	41 5e                	pop    %r14
  90e827:	c3                   	ret
  90e828:	48 8d 3d 75 ce 77 ff 	lea    -0x88318b(%rip),%rdi        # 8b6a4 <anon.1f5e156c2d71b9adadf1e4004d4673e2.82.llvm.7631762764491337279>
  90e82f:	48 8d 15 7a aa 35 00 	lea    0x35aa7a(%rip),%rdx        # c692b0 <anon.1f5e156c2d71b9adadf1e4004d4673e2.84.llvm.7631762764491337279>
  90e836:	be 19 00 00 00       	mov    $0x19,%esi
  90e83b:	ff 15 c7 df 38 00    	call   *0x38dfc7(%rip)        # c9c808 <_DYNAMIC+0x290>
  90e841:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  90e846:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  90e84b:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  90e850:	0f 10 4c 24 50       	movups 0x50(%rsp),%xmm1
  90e855:	0f 10 54 24 60       	movups 0x60(%rsp),%xmm2
  90e85a:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
  90e85f:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  90e864:	0f 29 04 24          	movaps %xmm0,(%rsp)
  90e868:	48 8d 3d d3 28 78 ff 	lea    -0x87d72d(%rip),%rdi        # 91142 <anon.1b72a5b8b5110b04d021962373711302.333.llvm.10952795245580062517>
  90e86f:	48 8d 0d 9a 51 36 00 	lea    0x36519a(%rip),%rcx        # c73a10 <anon.1b72a5b8b5110b04d021962373711302.334.llvm.10952795245580062517>
  90e876:	4c 8d 05 8b 5c 36 00 	lea    0x365c8b(%rip),%r8        # c74508 <anon.1b72a5b8b5110b04d021962373711302.458.llvm.10952795245580062517+0x500>
  90e87d:	48 89 e3             	mov    %rsp,%rbx
  90e880:	be 2b 00 00 00       	mov    $0x2b,%esi
  90e885:	48 89 da             	mov    %rbx,%rdx
  90e888:	ff 15 2a e0 38 00    	call   *0x38e02a(%rip)        # c9c8b8 <_DYNAMIC+0x340>
  90e88e:	eb 50                	jmp    90e8e0 <gpui::runtime::style_ledger::batch_phase::patch_probe+0x120>
  90e890:	48 8d 3d 05 2f 78 ff 	lea    -0x87d0fb(%rip),%rdi        # 9179c <anon.1b72a5b8b5110b04d021962373711302.411.llvm.10952795245580062517+0x502>
  90e897:	48 8d 15 82 5c 36 00 	lea    0x365c82(%rip),%rdx        # c74520 <anon.1b72a5b8b5110b04d021962373711302.458.llvm.10952795245580062517+0x518>
  90e89e:	be 3a 00 00 00       	mov    $0x3a,%esi
  90e8a3:	ff 15 2f e1 38 00    	call   *0x38e12f(%rip)        # c9c9d8 <_DYNAMIC+0x460>
  90e8a9:	48 c7 04 24 0d 00 00 	movq   $0xd,(%rsp)
  90e8b0:	00 
  90e8b1:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  90e8b8:	00 00 
  90e8ba:	48 8d 3d 81 28 78 ff 	lea    -0x87d77f(%rip),%rdi        # 91142 <anon.1b72a5b8b5110b04d021962373711302.333.llvm.10952795245580062517>
  90e8c1:	48 8d 0d 48 51 36 00 	lea    0x365148(%rip),%rcx        # c73a10 <anon.1b72a5b8b5110b04d021962373711302.334.llvm.10952795245580062517>
  90e8c8:	4c 8d 05 21 5c 36 00 	lea    0x365c21(%rip),%r8        # c744f0 <anon.1b72a5b8b5110b04d021962373711302.458.llvm.10952795245580062517+0x4e8>
  90e8cf:	48 89 e3             	mov    %rsp,%rbx
  90e8d2:	be 2b 00 00 00       	mov    $0x2b,%esi
  90e8d7:	48 89 da             	mov    %rbx,%rdx
  90e8da:	ff 15 d8 df 38 00    	call   *0x38dfd8(%rip)        # c9c8b8 <_DYNAMIC+0x340>
  90e8e0:	0f 0b                	ud2
  90e8e2:	eb 00                	jmp    90e8e4 <gpui::runtime::style_ledger::batch_phase::patch_probe+0x124>
  90e8e4:	49 89 c6             	mov    %rax,%r14
  90e8e7:	48 89 df             	mov    %rbx,%rdi
  90e8ea:	e8 01 bc ff ff       	call   90a4f0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  90e8ef:	4c 89 f7             	mov    %r14,%rdi
  90e8f2:	e8 79 6f 35 00       	call   c65870 <_Unwind_Resume@plt>
