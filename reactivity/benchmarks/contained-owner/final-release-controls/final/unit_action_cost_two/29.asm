
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000705710 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer>:
  705710:	55                   	push   %rbp
  705711:	41 57                	push   %r15
  705713:	41 56                	push   %r14
  705715:	41 55                	push   %r13
  705717:	41 54                	push   %r12
  705719:	53                   	push   %rbx
  70571a:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
  705721:	80 be 22 07 00 00 01 	cmpb   $0x1,0x722(%rsi)
  705728:	75 0c                	jne    705736 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x26>
  70572a:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  705731:	e9 37 02 00 00       	jmp    70596d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705736:	80 be 1e 07 00 00 01 	cmpb   $0x1,0x71e(%rsi)
  70573d:	0f 85 23 02 00 00    	jne    705966 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  705743:	80 be 1f 07 00 00 00 	cmpb   $0x0,0x71f(%rsi)
  70574a:	0f 85 16 02 00 00    	jne    705966 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  705750:	80 be 20 07 00 00 00 	cmpb   $0x0,0x720(%rsi)
  705757:	0f 84 09 02 00 00    	je     705966 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  70575d:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  705764:	ff 
  705765:	0f 85 fb 01 00 00    	jne    705966 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  70576b:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  705772:	48 3b 86 68 06 00 00 	cmp    0x668(%rsi),%rax
  705779:	0f 85 e7 01 00 00    	jne    705966 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  70577f:	48 8b 86 78 06 00 00 	mov    0x678(%rsi),%rax
  705786:	48 3b 86 70 06 00 00 	cmp    0x670(%rsi),%rax
  70578d:	0f 85 d3 01 00 00    	jne    705966 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  705793:	f3 0f 10 96 14 07 00 	movss  0x714(%rsi),%xmm2
  70579a:	00 
  70579b:	0f 2e 96 18 07 00 00 	ucomiss 0x718(%rsi),%xmm2
  7057a2:	0f 85 be 01 00 00    	jne    705966 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  7057a8:	0f 8a b8 01 00 00    	jp     705966 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  7057ae:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  7057b4:	f3 0f 11 0c 24       	movss  %xmm1,(%rsp)
  7057b9:	48 89 fd             	mov    %rdi,%rbp
  7057bc:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7057c1:	48 89 f3             	mov    %rsi,%rbx
  7057c4:	49 89 d7             	mov    %rdx,%r15
  7057c7:	49 89 ce             	mov    %rcx,%r14
  7057ca:	e8 f1 cd ff ff       	call   7025c0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::input_index>
  7057cf:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7057d4:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  7057d9:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  7057dd:	0f 85 9c 01 00 00    	jne    70597f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x26f>
  7057e3:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  7057ea:	49 39 f4             	cmp    %rsi,%r12
  7057ed:	0f 83 8b 04 00 00    	jae    705c7e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x56e>
  7057f3:	48 89 e8             	mov    %rbp,%rax
  7057f6:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  7057fd:	4b 8d 34 a4          	lea    (%r12,%r12,4),%rsi
  705801:	48 8b 34 f1          	mov    (%rcx,%rsi,8),%rsi
  705805:	48 8b 8b 78 05 00 00 	mov    0x578(%rbx),%rcx
  70580c:	48 8b 93 80 05 00 00 	mov    0x580(%rbx),%rdx
  705813:	48 c1 e2 04          	shl    $0x4,%rdx
  705817:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  70581b:	31 d2                	xor    %edx,%edx
  70581d:	49 89 c8             	mov    %rcx,%r8
  705820:	48 39 d7             	cmp    %rdx,%rdi
  705823:	0f 84 7b 01 00 00    	je     7059a4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x294>
  705829:	48 83 c2 50          	add    $0x50,%rdx
  70582d:	49 39 70 20          	cmp    %rsi,0x20(%r8)
  705831:	4d 8d 40 50          	lea    0x50(%r8),%r8
  705835:	75 e9                	jne    705820 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x110>
  705837:	f3 0f 10 44 11 e0    	movss  -0x20(%rcx,%rdx,1),%xmm0
  70583d:	0f 2e c0             	ucomiss %xmm0,%xmm0
  705840:	0f 8a 5e 01 00 00    	jp     7059a4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x294>
  705846:	f3 0f 10 4c 11 e4    	movss  -0x1c(%rcx,%rdx,1),%xmm1
  70584c:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  705853:	00 00 
  705855:	0f 14 c1             	unpcklps %xmm1,%xmm0
  705858:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  70585b:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  705862:	00 
  705863:	0f 5a 44 11 e8       	cvtps2pd -0x18(%rcx,%rdx,1),%xmm0
  705868:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  70586d:	0f 5a 44 11 f0       	cvtps2pd -0x10(%rcx,%rdx,1),%xmm0
  705872:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  705879:	00 
  70587a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70587f:	e8 6c 26 ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  705884:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  70588b:	00 
  70588c:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  705891:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  705896:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  70589b:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
  7058a2:	00 
  7058a3:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  7058a8:	c6 44 24 40 00       	movb   $0x0,0x40(%rsp)
  7058ad:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  7058b4:	00 
  7058b5:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  7058ba:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
  7058c0:	f3 0f 10 0c 24       	movss  (%rsp),%xmm1
  7058c5:	ff 15 65 3c 42 00    	call   *0x423c65(%rip)        # b29530 <_DYNAMIC+0x4a8>
  7058cb:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  7058d2:	00 00 
  7058d4:	83 bc 24 90 00 00 00 	cmpl   $0x1,0x90(%rsp)
  7058db:	01 
  7058dc:	0f 85 34 01 00 00    	jne    705a16 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x306>
  7058e2:	f3 0f 10 84 24 94 00 	movss  0x94(%rsp),%xmm0
  7058e9:	00 00 
  7058eb:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  7058f0:	f3 0f 10 84 24 98 00 	movss  0x98(%rsp),%xmm0
  7058f7:	00 00 
  7058f9:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  7058ff:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705904:	e8 e7 25 ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  705909:	48 8b b3 68 05 00 00 	mov    0x568(%rbx),%rsi
  705910:	49 39 f4             	cmp    %rsi,%r12
  705913:	0f 83 75 03 00 00    	jae    705c8e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x57e>
  705919:	48 8b 8b 60 05 00 00 	mov    0x560(%rbx),%rcx
  705920:	48 8d b3 c0 02 00 00 	lea    0x2c0(%rbx),%rsi
  705927:	4c 89 e0             	mov    %r12,%rax
  70592a:	48 c1 e0 04          	shl    $0x4,%rax
  70592e:	0f 10 04 01          	movups (%rcx,%rax,1),%xmm0
  705932:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  705939:	00 
  70593a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70593f:	48 8d 94 24 90 00 00 	lea    0x90(%rsp),%rdx
  705946:	00 
  705947:	ff 15 c3 3b 42 00    	call   *0x423bc3(%rip)        # b29510 <_DYNAMIC+0x488>
  70594d:	80 7c 24 10 00       	cmpb   $0x0,0x10(%rsp)
  705952:	74 59                	je     7059ad <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x29d>
  705954:	0f b6 44 24 11       	movzbl 0x11(%rsp),%eax
  705959:	48 c7 45 00 22 00 00 	movq   $0x22,0x0(%rbp)
  705960:	00 
  705961:	88 45 08             	mov    %al,0x8(%rbp)
  705964:	eb 07                	jmp    70596d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705966:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  70596d:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
  705974:	5b                   	pop    %rbx
  705975:	41 5c                	pop    %r12
  705977:	41 5d                	pop    %r13
  705979:	41 5e                	pop    %r14
  70597b:	41 5f                	pop    %r15
  70597d:	5d                   	pop    %rbp
  70597e:	c3                   	ret
  70597f:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  705984:	48 89 4d 30          	mov    %rcx,0x30(%rbp)
  705988:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  70598d:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  705992:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  705996:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70599a:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70599e:	4c 89 65 08          	mov    %r12,0x8(%rbp)
  7059a2:	eb c9                	jmp    70596d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  7059a4:	48 c7 00 19 00 00 00 	movq   $0x19,(%rax)
  7059ab:	eb c0                	jmp    70596d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  7059ad:	f3 0f 10 44 24 34    	movss  0x34(%rsp),%xmm0
  7059b3:	f3 0f 11 84 24 80 00 	movss  %xmm0,0x80(%rsp)
  7059ba:	00 00 
  7059bc:	f3 0f 10 44 24 3c    	movss  0x3c(%rsp),%xmm0
  7059c2:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  7059c8:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7059cd:	48 89 de             	mov    %rbx,%rsi
  7059d0:	4c 89 e2             	mov    %r12,%rdx
  7059d3:	e8 58 d7 ff ff       	call   703130 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::interaction_layout>
  7059d8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7059dd:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  7059e1:	75 40                	jne    705a23 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x313>
  7059e3:	f3 0f 10 4c 24 08    	movss  0x8(%rsp),%xmm1
  7059e9:	f3 0f 5c 4c 24 70    	subss  0x70(%rsp),%xmm1
  7059ef:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
  7059f4:	f3 0f 5c 84 24 80 00 	subss  0x80(%rsp),%xmm0
  7059fb:	00 00 
  7059fd:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  705a02:	ff 15 30 3b 42 00    	call   *0x423b30(%rip)        # b29538 <_DYNAMIC+0x4b0>
  705a08:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  705a0f:	00 00 
  705a11:	80 fa 02             	cmp    $0x2,%dl
  705a14:	75 3a                	jne    705a50 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x340>
  705a16:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  705a1d:	00 
  705a1e:	e9 4a ff ff ff       	jmp    70596d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705a23:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  705a28:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  705a2d:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  705a31:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  705a36:	0f 11 45 20          	movups %xmm0,0x20(%rbp)
  705a3a:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  705a3f:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  705a43:	48 89 45 00          	mov    %rax,0x0(%rbp)
  705a47:	48 89 4d 08          	mov    %rcx,0x8(%rbp)
  705a4b:	e9 1d ff ff ff       	jmp    70596d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705a50:	41 89 d5             	mov    %edx,%r13d
  705a53:	41 89 c4             	mov    %eax,%r12d
  705a56:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705a5b:	e8 90 24 ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  705a60:	48 83 bb 60 06 00 00 	cmpq   $0xffffffffffffffff,0x660(%rbx)
  705a67:	ff 
  705a68:	0f 84 03 02 00 00    	je     705c71 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x561>
  705a6e:	48 c7 44 24 10 1f 00 	movq   $0x1f,0x10(%rsp)
  705a75:	00 00 
  705a77:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705a7c:	e8 6f 24 ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  705a81:	48 89 de             	mov    %rbx,%rsi
  705a84:	48 8b 83 e8 05 00 00 	mov    0x5e8(%rbx),%rax
  705a8b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  705a90:	48 8b 83 f0 05 00 00 	mov    0x5f0(%rbx),%rax
  705a97:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  705a9e:	00 
  705a9f:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  705aa6:	48 89 04 24          	mov    %rax,(%rsp)
  705aaa:	48 8b 83 88 06 00 00 	mov    0x688(%rbx),%rax
  705ab1:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  705ab6:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705abb:	4c 89 fa             	mov    %r15,%rdx
  705abe:	4c 89 f1             	mov    %r14,%rcx
  705ac1:	e8 1a b7 ff ff       	call   7011e0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::focus>
  705ac6:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  705acb:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  705acf:	0f 85 fa 00 00 00    	jne    705bcf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x4bf>
  705ad5:	41 80 e5 01          	and    $0x1,%r13b
  705ad9:	44 89 a4 24 c0 00 00 	mov    %r12d,0xc0(%rsp)
  705ae0:	00 
  705ae1:	44 88 ac 24 c4 00 00 	mov    %r13b,0xc4(%rsp)
  705ae8:	00 
  705ae9:	44 89 a4 24 c8 00 00 	mov    %r12d,0xc8(%rsp)
  705af0:	00 
  705af1:	44 88 ac 24 cc 00 00 	mov    %r13b,0xcc(%rsp)
  705af8:	00 
  705af9:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705afe:	4c 8d 84 24 c0 00 00 	lea    0xc0(%rsp),%r8
  705b05:	00 
  705b06:	48 89 de             	mov    %rbx,%rsi
  705b09:	4c 89 fa             	mov    %r15,%rdx
  705b0c:	4c 89 f1             	mov    %r14,%rcx
  705b0f:	e8 fc f9 ff ff       	call   705510 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input>
  705b14:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  705b19:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  705b1e:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  705b25:	00 
  705b26:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  705b2b:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  705b32:	00 
  705b33:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  705b38:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  705b3f:	00 
  705b40:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  705b44:	0f 85 bf 00 00 00    	jne    705c09 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x4f9>
  705b4a:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  705b51:	00 
  705b52:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  705b59:	00 
  705b5a:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  705b61:	00 
  705b62:	0f 29 94 24 00 01 00 	movaps %xmm2,0x100(%rsp)
  705b69:	00 
  705b6a:	0f 29 8c 24 f0 00 00 	movaps %xmm1,0xf0(%rsp)
  705b71:	00 
  705b72:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  705b79:	00 
  705b7a:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  705b81:	48 85 c0             	test   %rax,%rax
  705b84:	48 89 ef             	mov    %rbp,%rdi
  705b87:	0f 84 a9 00 00 00    	je     705c36 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x526>
  705b8d:	48 8b 0c 24          	mov    (%rsp),%rcx
  705b91:	48 85 c9             	test   %rcx,%rcx
  705b94:	0f 84 a7 00 00 00    	je     705c41 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x531>
  705b9a:	48 39 c8             	cmp    %rcx,%rax
  705b9d:	0f 85 9e 00 00 00    	jne    705c41 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x531>
  705ba3:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  705ba8:	48 39 83 88 06 00 00 	cmp    %rax,0x688(%rbx)
  705baf:	0f 85 8c 00 00 00    	jne    705c41 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x531>
  705bb5:	48 89 de             	mov    %rbx,%rsi
  705bb8:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  705bbd:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  705bc4:	00 
  705bc5:	e8 d6 00 00 00       	call   705ca0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change>
  705bca:	e9 9e fd ff ff       	jmp    70596d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705bcf:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  705bd4:	0f b6 54 24 40       	movzbl 0x40(%rsp),%edx
  705bd9:	8b 74 24 44          	mov    0x44(%rsp),%esi
  705bdd:	89 75 34             	mov    %esi,0x34(%rbp)
  705be0:	8b 74 24 41          	mov    0x41(%rsp),%esi
  705be4:	89 75 31             	mov    %esi,0x31(%rbp)
  705be7:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  705bec:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  705bf1:	48 89 45 00          	mov    %rax,0x0(%rbp)
  705bf5:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  705bf9:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  705bfd:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  705c01:	88 55 30             	mov    %dl,0x30(%rbp)
  705c04:	e9 64 fd ff ff       	jmp    70596d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705c09:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  705c10:	00 
  705c11:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  705c18:	00 
  705c19:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  705c20:	00 
  705c21:	0f 11 55 28          	movups %xmm2,0x28(%rbp)
  705c25:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  705c29:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  705c2d:	48 89 45 00          	mov    %rax,0x0(%rbp)
  705c31:	e9 37 fd ff ff       	jmp    70596d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705c36:	48 83 3c 24 00       	cmpq   $0x0,(%rsp)
  705c3b:	0f 84 74 ff ff ff    	je     705bb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x4a5>
  705c41:	0f 28 84 24 e0 00 00 	movaps 0xe0(%rsp),%xmm0
  705c48:	00 
  705c49:	0f 28 8c 24 f0 00 00 	movaps 0xf0(%rsp),%xmm1
  705c50:	00 
  705c51:	0f 28 94 24 00 01 00 	movaps 0x100(%rsp),%xmm2
  705c58:	00 
  705c59:	0f 11 57 28          	movups %xmm2,0x28(%rdi)
  705c5d:	0f 11 4f 18          	movups %xmm1,0x18(%rdi)
  705c61:	0f 11 47 08          	movups %xmm0,0x8(%rdi)
  705c65:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  705c6c:	e9 fc fc ff ff       	jmp    70596d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705c71:	48 c7 45 00 1f 00 00 	movq   $0x1f,0x0(%rbp)
  705c78:	00 
  705c79:	e9 ef fc ff ff       	jmp    70596d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705c7e:	48 8d 15 33 53 3f 00 	lea    0x3f5333(%rip),%rdx        # afafb8 <__frame_dummy_init_array_entry+0x750>
  705c85:	4c 89 e7             	mov    %r12,%rdi
  705c88:	ff 15 52 37 42 00    	call   *0x423752(%rip)        # b293e0 <_DYNAMIC+0x358>
  705c8e:	48 8d 15 3b 53 3f 00 	lea    0x3f533b(%rip),%rdx        # afafd0 <__frame_dummy_init_array_entry+0x768>
  705c95:	4c 89 e7             	mov    %r12,%rdi
  705c98:	ff 15 42 37 42 00    	call   *0x423742(%rip)        # b293e0 <_DYNAMIC+0x358>
