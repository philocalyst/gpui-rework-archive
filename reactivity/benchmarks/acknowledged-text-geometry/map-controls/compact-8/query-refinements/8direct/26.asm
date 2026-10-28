
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006868d0 <<gpui_canvas::text::layout::CaretBuilder>::push>:
  6868d0:	55                   	push   %rbp
  6868d1:	41 57                	push   %r15
  6868d3:	41 56                	push   %r14
  6868d5:	41 55                	push   %r13
  6868d7:	41 54                	push   %r12
  6868d9:	53                   	push   %rbx
  6868da:	48 83 ec 48          	sub    $0x48,%rsp
  6868de:	49 89 d7             	mov    %rdx,%r15
  6868e1:	49 89 f5             	mov    %rsi,%r13
  6868e4:	48 89 fb             	mov    %rdi,%rbx
  6868e7:	4c 8d 77 08          	lea    0x8(%rdi),%r14
  6868eb:	83 3f 01             	cmpl   $0x1,(%rdi)
  6868ee:	75 6e                	jne    68695e <<gpui_canvas::text::layout::CaretBuilder>::push+0x8e>
  6868f0:	4c 8b 63 18          	mov    0x18(%rbx),%r12
  6868f4:	4c 3b 63 08          	cmp    0x8(%rbx),%r12
  6868f8:	75 09                	jne    686903 <<gpui_canvas::text::layout::CaretBuilder>::push+0x33>
  6868fa:	4c 89 f7             	mov    %r14,%rdi
  6868fd:	ff 15 75 2f 10 00    	call   *0x102f75(%rip)        # 789878 <_DYNAMIC+0x410>
  686903:	48 8b 43 10          	mov    0x10(%rbx),%rax
  686907:	4b 8d 0c 64          	lea    (%r12,%r12,2),%rcx
  68690b:	41 8b 55 08          	mov    0x8(%r13),%edx
  68690f:	89 54 88 08          	mov    %edx,0x8(%rax,%rcx,4)
  686913:	49 8b 55 00          	mov    0x0(%r13),%rdx
  686917:	48 89 14 88          	mov    %rdx,(%rax,%rcx,4)
  68691b:	49 ff c4             	inc    %r12
  68691e:	4c 89 63 18          	mov    %r12,0x18(%rbx)
  686922:	45 8b 2f             	mov    (%r15),%r13d
  686925:	48 8b 43 08          	mov    0x8(%rbx),%rax
  686929:	4c 29 e0             	sub    %r12,%rax
  68692c:	4c 39 e8             	cmp    %r13,%rax
  68692f:	0f 82 42 02 00 00    	jb     686b77 <<gpui_canvas::text::layout::CaretBuilder>::push+0x2a7>
  686935:	4d 85 ed             	test   %r13,%r13
  686938:	74 1b                	je     686955 <<gpui_canvas::text::layout::CaretBuilder>::push+0x85>
  68693a:	48 8b 43 10          	mov    0x10(%rbx),%rax
  68693e:	4b 8d 0c 64          	lea    (%r12,%r12,2),%rcx
  686942:	41 8b 57 0c          	mov    0xc(%r15),%edx
  686946:	89 54 88 08          	mov    %edx,0x8(%rax,%rcx,4)
  68694a:	49 8b 57 04          	mov    0x4(%r15),%rdx
  68694e:	48 89 14 88          	mov    %rdx,(%rax,%rcx,4)
  686952:	49 ff c4             	inc    %r12
  686955:	4c 89 63 18          	mov    %r12,0x18(%rbx)
  686959:	e9 0a 02 00 00       	jmp    686b68 <<gpui_canvas::text::layout::CaretBuilder>::push+0x298>
  68695e:	45 8b 27             	mov    (%r15),%r12d
  686961:	49 83 fc 01          	cmp    $0x1,%r12
  686965:	0f 85 9f 00 00 00    	jne    686a0a <<gpui_canvas::text::layout::CaretBuilder>::push+0x13a>
  68696b:	41 80 7f 0c 02       	cmpb   $0x2,0xc(%r15)
  686970:	0f 85 df 00 00 00    	jne    686a55 <<gpui_canvas::text::layout::CaretBuilder>::push+0x185>
  686976:	41 80 7d 08 01       	cmpb   $0x1,0x8(%r13)
  68697b:	0f 85 d4 00 00 00    	jne    686a55 <<gpui_canvas::text::layout::CaretBuilder>::push+0x185>
  686981:	41 8b 6f 04          	mov    0x4(%r15),%ebp
  686985:	41 39 6d 00          	cmp    %ebp,0x0(%r13)
  686989:	0f 85 c6 00 00 00    	jne    686a55 <<gpui_canvas::text::layout::CaretBuilder>::push+0x185>
  68698f:	f3 41 0f 10 45 04    	movss  0x4(%r13),%xmm0
  686995:	4c 8b 63 18          	mov    0x18(%rbx),%r12
  686999:	4c 3b 63 08          	cmp    0x8(%rbx),%r12
  68699d:	75 15                	jne    6869b4 <<gpui_canvas::text::layout::CaretBuilder>::push+0xe4>
  68699f:	4c 89 f7             	mov    %r14,%rdi
  6869a2:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  6869a8:	ff 15 ba 2e 10 00    	call   *0x102eba(%rip)        # 789868 <_DYNAMIC+0x400>
  6869ae:	f3 0f 10 44 24 04    	movss  0x4(%rsp),%xmm0
  6869b4:	48 8b 43 10          	mov    0x10(%rbx),%rax
  6869b8:	42 89 2c e0          	mov    %ebp,(%rax,%r12,8)
  6869bc:	f3 42 0f 11 44 e0 04 	movss  %xmm0,0x4(%rax,%r12,8)
  6869c3:	49 8d 44 24 01       	lea    0x1(%r12),%rax
  6869c8:	48 89 43 18          	mov    %rax,0x18(%rbx)
  6869cc:	f3 41 0f 10 47 08    	movss  0x8(%r15),%xmm0
  6869d2:	48 3b 43 08          	cmp    0x8(%rbx),%rax
  6869d6:	75 15                	jne    6869ed <<gpui_canvas::text::layout::CaretBuilder>::push+0x11d>
  6869d8:	4c 89 f7             	mov    %r14,%rdi
  6869db:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  6869e1:	ff 15 81 2e 10 00    	call   *0x102e81(%rip)        # 789868 <_DYNAMIC+0x400>
  6869e7:	f3 0f 10 44 24 04    	movss  0x4(%rsp),%xmm0
  6869ed:	48 8b 43 10          	mov    0x10(%rbx),%rax
  6869f1:	42 89 6c e0 08       	mov    %ebp,0x8(%rax,%r12,8)
  6869f6:	f3 42 0f 11 44 e0 0c 	movss  %xmm0,0xc(%rax,%r12,8)
  6869fd:	49 83 c4 02          	add    $0x2,%r12
  686a01:	4c 89 63 18          	mov    %r12,0x18(%rbx)
  686a05:	e9 5e 01 00 00       	jmp    686b68 <<gpui_canvas::text::layout::CaretBuilder>::push+0x298>
  686a0a:	41 80 7d 08 03       	cmpb   $0x3,0x8(%r13)
  686a0f:	75 44                	jne    686a55 <<gpui_canvas::text::layout::CaretBuilder>::push+0x185>
  686a11:	41 8b 6d 00          	mov    0x0(%r13),%ebp
  686a15:	f3 41 0f 10 45 04    	movss  0x4(%r13),%xmm0
  686a1b:	4c 8b 7b 18          	mov    0x18(%rbx),%r15
  686a1f:	4c 3b 7b 08          	cmp    0x8(%rbx),%r15
  686a23:	75 15                	jne    686a3a <<gpui_canvas::text::layout::CaretBuilder>::push+0x16a>
  686a25:	4c 89 f7             	mov    %r14,%rdi
  686a28:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  686a2e:	ff 15 34 2e 10 00    	call   *0x102e34(%rip)        # 789868 <_DYNAMIC+0x400>
  686a34:	f3 0f 10 44 24 04    	movss  0x4(%rsp),%xmm0
  686a3a:	48 8b 43 10          	mov    0x10(%rbx),%rax
  686a3e:	42 89 2c f8          	mov    %ebp,(%rax,%r15,8)
  686a42:	f3 42 0f 11 44 f8 04 	movss  %xmm0,0x4(%rax,%r15,8)
  686a49:	49 ff c7             	inc    %r15
  686a4c:	4c 89 7b 18          	mov    %r15,0x18(%rbx)
  686a50:	e9 13 01 00 00       	jmp    686b68 <<gpui_canvas::text::layout::CaretBuilder>::push+0x298>
  686a55:	48 8b 43 10          	mov    0x10(%rbx),%rax
  686a59:	48 8b 4b 18          	mov    0x18(%rbx),%rcx
  686a5d:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  686a64:	00 00 
  686a66:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
  686a6b:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  686a72:	00 00 
  686a74:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  686a79:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  686a7e:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  686a83:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
  686a88:	e8 83 33 ff ff       	call   679e10 <<alloc::vec::Vec<gpui_canvas::text::layout::Stop> as alloc::vec::spec_from_iter_nested::SpecFromIterNested<gpui_canvas::text::layout::Stop, core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>>::from_iter>
  686a8d:	48 8b 6c 24 18       	mov    0x18(%rsp),%rbp
  686a92:	48 3b 6c 24 08       	cmp    0x8(%rsp),%rbp
  686a97:	75 0b                	jne    686aa4 <<gpui_canvas::text::layout::CaretBuilder>::push+0x1d4>
  686a99:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  686a9e:	ff 15 d4 2d 10 00    	call   *0x102dd4(%rip)        # 789878 <_DYNAMIC+0x410>
  686aa4:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  686aa9:	48 8d 0c 6d 00 00 00 	lea    0x0(,%rbp,2),%rcx
  686ab0:	00 
  686ab1:	48 01 e9             	add    %rbp,%rcx
  686ab4:	41 8b 55 08          	mov    0x8(%r13),%edx
  686ab8:	89 54 88 08          	mov    %edx,0x8(%rax,%rcx,4)
  686abc:	49 8b 55 00          	mov    0x0(%r13),%rdx
  686ac0:	48 89 14 88          	mov    %rdx,(%rax,%rcx,4)
  686ac4:	48 ff c5             	inc    %rbp
  686ac7:	48 89 6c 24 18       	mov    %rbp,0x18(%rsp)
  686acc:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  686ad1:	48 29 e8             	sub    %rbp,%rax
  686ad4:	4c 39 e0             	cmp    %r12,%rax
  686ad7:	0f 82 c5 00 00 00    	jb     686ba2 <<gpui_canvas::text::layout::CaretBuilder>::push+0x2d2>
  686add:	45 84 e4             	test   %r12b,%r12b
  686ae0:	74 23                	je     686b05 <<gpui_canvas::text::layout::CaretBuilder>::push+0x235>
  686ae2:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  686ae7:	48 8d 0c 6d 00 00 00 	lea    0x0(,%rbp,2),%rcx
  686aee:	00 
  686aef:	48 01 e9             	add    %rbp,%rcx
  686af2:	41 8b 57 0c          	mov    0xc(%r15),%edx
  686af6:	89 54 88 08          	mov    %edx,0x8(%rax,%rcx,4)
  686afa:	49 8b 57 04          	mov    0x4(%r15),%rdx
  686afe:	48 89 14 88          	mov    %rdx,(%rax,%rcx,4)
  686b02:	48 ff c5             	inc    %rbp
  686b05:	48 89 6c 24 18       	mov    %rbp,0x18(%rsp)
  686b0a:	48 89 6c 24 30       	mov    %rbp,0x30(%rsp)
  686b0f:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  686b14:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  686b19:	80 3b 00             	cmpb   $0x0,(%rbx)
  686b1c:	74 16                	je     686b34 <<gpui_canvas::text::layout::CaretBuilder>::push+0x264>
  686b1e:	49 8b 06             	mov    (%r14),%rax
  686b21:	48 85 c0             	test   %rax,%rax
  686b24:	74 29                	je     686b4f <<gpui_canvas::text::layout::CaretBuilder>::push+0x27f>
  686b26:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
  686b2a:	48 c1 e0 02          	shl    $0x2,%rax
  686b2e:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  686b32:	eb 10                	jmp    686b44 <<gpui_canvas::text::layout::CaretBuilder>::push+0x274>
  686b34:	49 8b 36             	mov    (%r14),%rsi
  686b37:	48 85 f6             	test   %rsi,%rsi
  686b3a:	74 13                	je     686b4f <<gpui_canvas::text::layout::CaretBuilder>::push+0x27f>
  686b3c:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
  686b40:	48 c1 e6 03          	shl    $0x3,%rsi
  686b44:	ba 04 00 00 00       	mov    $0x4,%edx
  686b49:	ff 15 61 2b 10 00    	call   *0x102b61(%rip)        # 7896b0 <_DYNAMIC+0x248>
  686b4f:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  686b56:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  686b5b:	49 89 46 10          	mov    %rax,0x10(%r14)
  686b5f:	0f 28 44 24 20       	movaps 0x20(%rsp),%xmm0
  686b64:	41 0f 11 06          	movups %xmm0,(%r14)
  686b68:	48 83 c4 48          	add    $0x48,%rsp
  686b6c:	5b                   	pop    %rbx
  686b6d:	41 5c                	pop    %r12
  686b6f:	41 5d                	pop    %r13
  686b71:	41 5e                	pop    %r14
  686b73:	41 5f                	pop    %r15
  686b75:	5d                   	pop    %rbp
  686b76:	c3                   	ret
  686b77:	b9 04 00 00 00       	mov    $0x4,%ecx
  686b7c:	41 b8 0c 00 00 00    	mov    $0xc,%r8d
  686b82:	4c 89 f7             	mov    %r14,%rdi
  686b85:	4c 89 e6             	mov    %r12,%rsi
  686b88:	4c 89 ea             	mov    %r13,%rdx
  686b8b:	e8 10 b0 fd ff       	call   661ba0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  686b90:	4c 8b 63 18          	mov    0x18(%rbx),%r12
  686b94:	4d 85 ed             	test   %r13,%r13
  686b97:	0f 85 9d fd ff ff    	jne    68693a <<gpui_canvas::text::layout::CaretBuilder>::push+0x6a>
  686b9d:	e9 b3 fd ff ff       	jmp    686955 <<gpui_canvas::text::layout::CaretBuilder>::push+0x85>
  686ba2:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  686ba7:	b9 04 00 00 00       	mov    $0x4,%ecx
  686bac:	41 b8 0c 00 00 00    	mov    $0xc,%r8d
  686bb2:	48 89 ee             	mov    %rbp,%rsi
  686bb5:	4c 89 e2             	mov    %r12,%rdx
  686bb8:	e8 e3 af fd ff       	call   661ba0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
  686bbd:	48 8b 6c 24 18       	mov    0x18(%rsp),%rbp
  686bc2:	45 84 e4             	test   %r12b,%r12b
  686bc5:	0f 85 17 ff ff ff    	jne    686ae2 <<gpui_canvas::text::layout::CaretBuilder>::push+0x212>
  686bcb:	e9 35 ff ff ff       	jmp    686b05 <<gpui_canvas::text::layout::CaretBuilder>::push+0x235>
  686bd0:	48 89 c3             	mov    %rax,%rbx
  686bd3:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  686bd8:	48 85 c0             	test   %rax,%rax
  686bdb:	74 18                	je     686bf5 <<gpui_canvas::text::layout::CaretBuilder>::push+0x325>
  686bdd:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  686be2:	48 c1 e0 02          	shl    $0x2,%rax
  686be6:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  686bea:	ba 04 00 00 00       	mov    $0x4,%edx
  686bef:	ff 15 bb 2a 10 00    	call   *0x102abb(%rip)        # 7896b0 <_DYNAMIC+0x248>
  686bf5:	48 89 df             	mov    %rbx,%rdi
  686bf8:	e8 83 6b 0f 00       	call   77d780 <_Unwind_Resume@plt>
