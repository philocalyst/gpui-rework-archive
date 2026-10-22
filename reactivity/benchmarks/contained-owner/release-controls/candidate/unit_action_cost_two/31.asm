
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000705810 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer>:
  705810:	55                   	push   %rbp
  705811:	41 57                	push   %r15
  705813:	41 56                	push   %r14
  705815:	41 55                	push   %r13
  705817:	41 54                	push   %r12
  705819:	53                   	push   %rbx
  70581a:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
  705821:	80 be 22 07 00 00 01 	cmpb   $0x1,0x722(%rsi)
  705828:	75 0c                	jne    705836 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x26>
  70582a:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  705831:	e9 37 02 00 00       	jmp    705a6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705836:	80 be 1e 07 00 00 01 	cmpb   $0x1,0x71e(%rsi)
  70583d:	0f 85 23 02 00 00    	jne    705a66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  705843:	80 be 1f 07 00 00 00 	cmpb   $0x0,0x71f(%rsi)
  70584a:	0f 85 16 02 00 00    	jne    705a66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  705850:	80 be 20 07 00 00 00 	cmpb   $0x0,0x720(%rsi)
  705857:	0f 84 09 02 00 00    	je     705a66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  70585d:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  705864:	ff 
  705865:	0f 85 fb 01 00 00    	jne    705a66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  70586b:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  705872:	48 3b 86 68 06 00 00 	cmp    0x668(%rsi),%rax
  705879:	0f 85 e7 01 00 00    	jne    705a66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  70587f:	48 8b 86 78 06 00 00 	mov    0x678(%rsi),%rax
  705886:	48 3b 86 70 06 00 00 	cmp    0x670(%rsi),%rax
  70588d:	0f 85 d3 01 00 00    	jne    705a66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  705893:	f3 0f 10 96 14 07 00 	movss  0x714(%rsi),%xmm2
  70589a:	00 
  70589b:	0f 2e 96 18 07 00 00 	ucomiss 0x718(%rsi),%xmm2
  7058a2:	0f 85 be 01 00 00    	jne    705a66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  7058a8:	0f 8a b8 01 00 00    	jp     705a66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  7058ae:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  7058b4:	f3 0f 11 0c 24       	movss  %xmm1,(%rsp)
  7058b9:	48 89 fd             	mov    %rdi,%rbp
  7058bc:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7058c1:	48 89 f3             	mov    %rsi,%rbx
  7058c4:	49 89 d7             	mov    %rdx,%r15
  7058c7:	49 89 ce             	mov    %rcx,%r14
  7058ca:	e8 f1 cd ff ff       	call   7026c0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::input_index>
  7058cf:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7058d4:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  7058d9:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  7058dd:	0f 85 9c 01 00 00    	jne    705a7f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x26f>
  7058e3:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  7058ea:	49 39 f4             	cmp    %rsi,%r12
  7058ed:	0f 83 8b 04 00 00    	jae    705d7e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x56e>
  7058f3:	48 89 e8             	mov    %rbp,%rax
  7058f6:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  7058fd:	4b 8d 34 a4          	lea    (%r12,%r12,4),%rsi
  705901:	48 8b 34 f1          	mov    (%rcx,%rsi,8),%rsi
  705905:	48 8b 8b 78 05 00 00 	mov    0x578(%rbx),%rcx
  70590c:	48 8b 93 80 05 00 00 	mov    0x580(%rbx),%rdx
  705913:	48 c1 e2 04          	shl    $0x4,%rdx
  705917:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  70591b:	31 d2                	xor    %edx,%edx
  70591d:	49 89 c8             	mov    %rcx,%r8
  705920:	48 39 d7             	cmp    %rdx,%rdi
  705923:	0f 84 7b 01 00 00    	je     705aa4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x294>
  705929:	48 83 c2 50          	add    $0x50,%rdx
  70592d:	49 39 70 20          	cmp    %rsi,0x20(%r8)
  705931:	4d 8d 40 50          	lea    0x50(%r8),%r8
  705935:	75 e9                	jne    705920 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x110>
  705937:	f3 0f 10 44 11 e0    	movss  -0x20(%rcx,%rdx,1),%xmm0
  70593d:	0f 2e c0             	ucomiss %xmm0,%xmm0
  705940:	0f 8a 5e 01 00 00    	jp     705aa4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x294>
  705946:	f3 0f 10 4c 11 e4    	movss  -0x1c(%rcx,%rdx,1),%xmm1
  70594c:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  705953:	00 00 
  705955:	0f 14 c1             	unpcklps %xmm1,%xmm0
  705958:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  70595b:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  705962:	00 
  705963:	0f 5a 44 11 e8       	cvtps2pd -0x18(%rcx,%rdx,1),%xmm0
  705968:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  70596d:	0f 5a 44 11 f0       	cvtps2pd -0x10(%rcx,%rdx,1),%xmm0
  705972:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  705979:	00 
  70597a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70597f:	e8 6c 26 ff ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  705984:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  70598b:	00 
  70598c:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  705991:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  705996:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  70599b:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
  7059a2:	00 
  7059a3:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  7059a8:	c6 44 24 40 00       	movb   $0x0,0x40(%rsp)
  7059ad:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  7059b4:	00 
  7059b5:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  7059ba:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
  7059c0:	f3 0f 10 0c 24       	movss  (%rsp),%xmm1
  7059c5:	ff 15 4d 3c 42 00    	call   *0x423c4d(%rip)        # b29618 <_DYNAMIC+0x4a8>
  7059cb:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  7059d2:	00 00 
  7059d4:	83 bc 24 90 00 00 00 	cmpl   $0x1,0x90(%rsp)
  7059db:	01 
  7059dc:	0f 85 34 01 00 00    	jne    705b16 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x306>
  7059e2:	f3 0f 10 84 24 94 00 	movss  0x94(%rsp),%xmm0
  7059e9:	00 00 
  7059eb:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  7059f0:	f3 0f 10 84 24 98 00 	movss  0x98(%rsp),%xmm0
  7059f7:	00 00 
  7059f9:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  7059ff:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705a04:	e8 e7 25 ff ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  705a09:	48 8b b3 68 05 00 00 	mov    0x568(%rbx),%rsi
  705a10:	49 39 f4             	cmp    %rsi,%r12
  705a13:	0f 83 75 03 00 00    	jae    705d8e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x57e>
  705a19:	48 8b 8b 60 05 00 00 	mov    0x560(%rbx),%rcx
  705a20:	48 8d b3 c0 02 00 00 	lea    0x2c0(%rbx),%rsi
  705a27:	4c 89 e0             	mov    %r12,%rax
  705a2a:	48 c1 e0 04          	shl    $0x4,%rax
  705a2e:	0f 10 04 01          	movups (%rcx,%rax,1),%xmm0
  705a32:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  705a39:	00 
  705a3a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705a3f:	48 8d 94 24 90 00 00 	lea    0x90(%rsp),%rdx
  705a46:	00 
  705a47:	ff 15 ab 3b 42 00    	call   *0x423bab(%rip)        # b295f8 <_DYNAMIC+0x488>
  705a4d:	80 7c 24 10 00       	cmpb   $0x0,0x10(%rsp)
  705a52:	74 59                	je     705aad <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x29d>
  705a54:	0f b6 44 24 11       	movzbl 0x11(%rsp),%eax
  705a59:	48 c7 45 00 22 00 00 	movq   $0x22,0x0(%rbp)
  705a60:	00 
  705a61:	88 45 08             	mov    %al,0x8(%rbp)
  705a64:	eb 07                	jmp    705a6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705a66:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  705a6d:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
  705a74:	5b                   	pop    %rbx
  705a75:	41 5c                	pop    %r12
  705a77:	41 5d                	pop    %r13
  705a79:	41 5e                	pop    %r14
  705a7b:	41 5f                	pop    %r15
  705a7d:	5d                   	pop    %rbp
  705a7e:	c3                   	ret
  705a7f:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  705a84:	48 89 4d 30          	mov    %rcx,0x30(%rbp)
  705a88:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  705a8d:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  705a92:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  705a96:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  705a9a:	48 89 45 00          	mov    %rax,0x0(%rbp)
  705a9e:	4c 89 65 08          	mov    %r12,0x8(%rbp)
  705aa2:	eb c9                	jmp    705a6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705aa4:	48 c7 00 19 00 00 00 	movq   $0x19,(%rax)
  705aab:	eb c0                	jmp    705a6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705aad:	f3 0f 10 44 24 34    	movss  0x34(%rsp),%xmm0
  705ab3:	f3 0f 11 84 24 80 00 	movss  %xmm0,0x80(%rsp)
  705aba:	00 00 
  705abc:	f3 0f 10 44 24 3c    	movss  0x3c(%rsp),%xmm0
  705ac2:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  705ac8:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705acd:	48 89 de             	mov    %rbx,%rsi
  705ad0:	4c 89 e2             	mov    %r12,%rdx
  705ad3:	e8 58 d7 ff ff       	call   703230 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::interaction_layout>
  705ad8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  705add:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  705ae1:	75 40                	jne    705b23 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x313>
  705ae3:	f3 0f 10 4c 24 08    	movss  0x8(%rsp),%xmm1
  705ae9:	f3 0f 5c 4c 24 70    	subss  0x70(%rsp),%xmm1
  705aef:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
  705af4:	f3 0f 5c 84 24 80 00 	subss  0x80(%rsp),%xmm0
  705afb:	00 00 
  705afd:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  705b02:	ff 15 18 3b 42 00    	call   *0x423b18(%rip)        # b29620 <_DYNAMIC+0x4b0>
  705b08:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  705b0f:	00 00 
  705b11:	80 fa 02             	cmp    $0x2,%dl
  705b14:	75 3a                	jne    705b50 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x340>
  705b16:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  705b1d:	00 
  705b1e:	e9 4a ff ff ff       	jmp    705a6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705b23:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  705b28:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  705b2d:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  705b31:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  705b36:	0f 11 45 20          	movups %xmm0,0x20(%rbp)
  705b3a:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  705b3f:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  705b43:	48 89 45 00          	mov    %rax,0x0(%rbp)
  705b47:	48 89 4d 08          	mov    %rcx,0x8(%rbp)
  705b4b:	e9 1d ff ff ff       	jmp    705a6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705b50:	41 89 d5             	mov    %edx,%r13d
  705b53:	41 89 c4             	mov    %eax,%r12d
  705b56:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705b5b:	e8 90 24 ff ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  705b60:	48 83 bb 60 06 00 00 	cmpq   $0xffffffffffffffff,0x660(%rbx)
  705b67:	ff 
  705b68:	0f 84 03 02 00 00    	je     705d71 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x561>
  705b6e:	48 c7 44 24 10 1f 00 	movq   $0x1f,0x10(%rsp)
  705b75:	00 00 
  705b77:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705b7c:	e8 6f 24 ff ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  705b81:	48 89 de             	mov    %rbx,%rsi
  705b84:	48 8b 83 e8 05 00 00 	mov    0x5e8(%rbx),%rax
  705b8b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  705b90:	48 8b 83 f0 05 00 00 	mov    0x5f0(%rbx),%rax
  705b97:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  705b9e:	00 
  705b9f:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  705ba6:	48 89 04 24          	mov    %rax,(%rsp)
  705baa:	48 8b 83 88 06 00 00 	mov    0x688(%rbx),%rax
  705bb1:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  705bb6:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705bbb:	4c 89 fa             	mov    %r15,%rdx
  705bbe:	4c 89 f1             	mov    %r14,%rcx
  705bc1:	e8 1a b7 ff ff       	call   7012e0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::focus>
  705bc6:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  705bcb:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  705bcf:	0f 85 fa 00 00 00    	jne    705ccf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x4bf>
  705bd5:	41 80 e5 01          	and    $0x1,%r13b
  705bd9:	44 89 a4 24 c0 00 00 	mov    %r12d,0xc0(%rsp)
  705be0:	00 
  705be1:	44 88 ac 24 c4 00 00 	mov    %r13b,0xc4(%rsp)
  705be8:	00 
  705be9:	44 89 a4 24 c8 00 00 	mov    %r12d,0xc8(%rsp)
  705bf0:	00 
  705bf1:	44 88 ac 24 cc 00 00 	mov    %r13b,0xcc(%rsp)
  705bf8:	00 
  705bf9:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705bfe:	4c 8d 84 24 c0 00 00 	lea    0xc0(%rsp),%r8
  705c05:	00 
  705c06:	48 89 de             	mov    %rbx,%rsi
  705c09:	4c 89 fa             	mov    %r15,%rdx
  705c0c:	4c 89 f1             	mov    %r14,%rcx
  705c0f:	e8 fc f9 ff ff       	call   705610 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input>
  705c14:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  705c19:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  705c1e:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  705c25:	00 
  705c26:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  705c2b:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  705c32:	00 
  705c33:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  705c38:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  705c3f:	00 
  705c40:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  705c44:	0f 85 bf 00 00 00    	jne    705d09 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x4f9>
  705c4a:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  705c51:	00 
  705c52:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  705c59:	00 
  705c5a:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  705c61:	00 
  705c62:	0f 29 94 24 00 01 00 	movaps %xmm2,0x100(%rsp)
  705c69:	00 
  705c6a:	0f 29 8c 24 f0 00 00 	movaps %xmm1,0xf0(%rsp)
  705c71:	00 
  705c72:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  705c79:	00 
  705c7a:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  705c81:	48 85 c0             	test   %rax,%rax
  705c84:	48 89 ef             	mov    %rbp,%rdi
  705c87:	0f 84 a9 00 00 00    	je     705d36 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x526>
  705c8d:	48 8b 0c 24          	mov    (%rsp),%rcx
  705c91:	48 85 c9             	test   %rcx,%rcx
  705c94:	0f 84 a7 00 00 00    	je     705d41 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x531>
  705c9a:	48 39 c8             	cmp    %rcx,%rax
  705c9d:	0f 85 9e 00 00 00    	jne    705d41 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x531>
  705ca3:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  705ca8:	48 39 83 88 06 00 00 	cmp    %rax,0x688(%rbx)
  705caf:	0f 85 8c 00 00 00    	jne    705d41 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x531>
  705cb5:	48 89 de             	mov    %rbx,%rsi
  705cb8:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  705cbd:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  705cc4:	00 
  705cc5:	e8 d6 00 00 00       	call   705da0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change>
  705cca:	e9 9e fd ff ff       	jmp    705a6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705ccf:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  705cd4:	0f b6 54 24 40       	movzbl 0x40(%rsp),%edx
  705cd9:	8b 74 24 44          	mov    0x44(%rsp),%esi
  705cdd:	89 75 34             	mov    %esi,0x34(%rbp)
  705ce0:	8b 74 24 41          	mov    0x41(%rsp),%esi
  705ce4:	89 75 31             	mov    %esi,0x31(%rbp)
  705ce7:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  705cec:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  705cf1:	48 89 45 00          	mov    %rax,0x0(%rbp)
  705cf5:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  705cf9:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  705cfd:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  705d01:	88 55 30             	mov    %dl,0x30(%rbp)
  705d04:	e9 64 fd ff ff       	jmp    705a6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705d09:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  705d10:	00 
  705d11:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  705d18:	00 
  705d19:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  705d20:	00 
  705d21:	0f 11 55 28          	movups %xmm2,0x28(%rbp)
  705d25:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  705d29:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  705d2d:	48 89 45 00          	mov    %rax,0x0(%rbp)
  705d31:	e9 37 fd ff ff       	jmp    705a6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705d36:	48 83 3c 24 00       	cmpq   $0x0,(%rsp)
  705d3b:	0f 84 74 ff ff ff    	je     705cb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x4a5>
  705d41:	0f 28 84 24 e0 00 00 	movaps 0xe0(%rsp),%xmm0
  705d48:	00 
  705d49:	0f 28 8c 24 f0 00 00 	movaps 0xf0(%rsp),%xmm1
  705d50:	00 
  705d51:	0f 28 94 24 00 01 00 	movaps 0x100(%rsp),%xmm2
  705d58:	00 
  705d59:	0f 11 57 28          	movups %xmm2,0x28(%rdi)
  705d5d:	0f 11 4f 18          	movups %xmm1,0x18(%rdi)
  705d61:	0f 11 47 08          	movups %xmm0,0x8(%rdi)
  705d65:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  705d6c:	e9 fc fc ff ff       	jmp    705a6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705d71:	48 c7 45 00 1f 00 00 	movq   $0x1f,0x0(%rbp)
  705d78:	00 
  705d79:	e9 ef fc ff ff       	jmp    705a6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705d7e:	48 8d 15 d3 52 3f 00 	lea    0x3f52d3(%rip),%rdx        # afb058 <__frame_dummy_init_array_entry+0x750>
  705d85:	4c 89 e7             	mov    %r12,%rdi
  705d88:	ff 15 3a 37 42 00    	call   *0x42373a(%rip)        # b294c8 <_DYNAMIC+0x358>
  705d8e:	48 8d 15 db 52 3f 00 	lea    0x3f52db(%rip),%rdx        # afb070 <__frame_dummy_init_array_entry+0x768>
  705d95:	4c 89 e7             	mov    %r12,%rdi
  705d98:	ff 15 2a 37 42 00    	call   *0x42372a(%rip)        # b294c8 <_DYNAMIC+0x358>
