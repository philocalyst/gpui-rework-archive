
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000007057a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer>:
  7057a0:	55                   	push   %rbp
  7057a1:	41 57                	push   %r15
  7057a3:	41 56                	push   %r14
  7057a5:	41 55                	push   %r13
  7057a7:	41 54                	push   %r12
  7057a9:	53                   	push   %rbx
  7057aa:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
  7057b1:	80 be 22 07 00 00 01 	cmpb   $0x1,0x722(%rsi)
  7057b8:	75 0c                	jne    7057c6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x26>
  7057ba:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  7057c1:	e9 37 02 00 00       	jmp    7059fd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  7057c6:	80 be 1e 07 00 00 01 	cmpb   $0x1,0x71e(%rsi)
  7057cd:	0f 85 23 02 00 00    	jne    7059f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  7057d3:	80 be 1f 07 00 00 00 	cmpb   $0x0,0x71f(%rsi)
  7057da:	0f 85 16 02 00 00    	jne    7059f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  7057e0:	80 be 20 07 00 00 00 	cmpb   $0x0,0x720(%rsi)
  7057e7:	0f 84 09 02 00 00    	je     7059f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  7057ed:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  7057f4:	ff 
  7057f5:	0f 85 fb 01 00 00    	jne    7059f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  7057fb:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  705802:	48 3b 86 68 06 00 00 	cmp    0x668(%rsi),%rax
  705809:	0f 85 e7 01 00 00    	jne    7059f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  70580f:	48 8b 86 78 06 00 00 	mov    0x678(%rsi),%rax
  705816:	48 3b 86 70 06 00 00 	cmp    0x670(%rsi),%rax
  70581d:	0f 85 d3 01 00 00    	jne    7059f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  705823:	f3 0f 10 96 14 07 00 	movss  0x714(%rsi),%xmm2
  70582a:	00 
  70582b:	0f 2e 96 18 07 00 00 	ucomiss 0x718(%rsi),%xmm2
  705832:	0f 85 be 01 00 00    	jne    7059f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  705838:	0f 8a b8 01 00 00    	jp     7059f6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x256>
  70583e:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  705844:	f3 0f 11 0c 24       	movss  %xmm1,(%rsp)
  705849:	48 89 fd             	mov    %rdi,%rbp
  70584c:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705851:	48 89 f3             	mov    %rsi,%rbx
  705854:	49 89 d7             	mov    %rdx,%r15
  705857:	49 89 ce             	mov    %rcx,%r14
  70585a:	e8 f1 cd ff ff       	call   702650 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::input_index>
  70585f:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  705864:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  705869:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70586d:	0f 85 9c 01 00 00    	jne    705a0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x26f>
  705873:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  70587a:	49 39 f4             	cmp    %rsi,%r12
  70587d:	0f 83 8b 04 00 00    	jae    705d0e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x56e>
  705883:	48 89 e8             	mov    %rbp,%rax
  705886:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  70588d:	4b 8d 34 a4          	lea    (%r12,%r12,4),%rsi
  705891:	48 8b 34 f1          	mov    (%rcx,%rsi,8),%rsi
  705895:	48 8b 8b 78 05 00 00 	mov    0x578(%rbx),%rcx
  70589c:	48 8b 93 80 05 00 00 	mov    0x580(%rbx),%rdx
  7058a3:	48 c1 e2 04          	shl    $0x4,%rdx
  7058a7:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  7058ab:	31 d2                	xor    %edx,%edx
  7058ad:	49 89 c8             	mov    %rcx,%r8
  7058b0:	48 39 d7             	cmp    %rdx,%rdi
  7058b3:	0f 84 7b 01 00 00    	je     705a34 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x294>
  7058b9:	48 83 c2 50          	add    $0x50,%rdx
  7058bd:	49 39 70 20          	cmp    %rsi,0x20(%r8)
  7058c1:	4d 8d 40 50          	lea    0x50(%r8),%r8
  7058c5:	75 e9                	jne    7058b0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x110>
  7058c7:	f3 0f 10 44 11 e0    	movss  -0x20(%rcx,%rdx,1),%xmm0
  7058cd:	0f 2e c0             	ucomiss %xmm0,%xmm0
  7058d0:	0f 8a 5e 01 00 00    	jp     705a34 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x294>
  7058d6:	f3 0f 10 4c 11 e4    	movss  -0x1c(%rcx,%rdx,1),%xmm1
  7058dc:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  7058e3:	00 00 
  7058e5:	0f 14 c1             	unpcklps %xmm1,%xmm0
  7058e8:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  7058eb:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  7058f2:	00 
  7058f3:	0f 5a 44 11 e8       	cvtps2pd -0x18(%rcx,%rdx,1),%xmm0
  7058f8:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  7058fd:	0f 5a 44 11 f0       	cvtps2pd -0x10(%rcx,%rdx,1),%xmm0
  705902:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  705909:	00 
  70590a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70590f:	e8 cc 26 ff ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  705914:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  70591b:	00 
  70591c:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  705921:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  705926:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  70592b:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
  705932:	00 
  705933:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  705938:	c6 44 24 40 00       	movb   $0x0,0x40(%rsp)
  70593d:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  705944:	00 
  705945:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  70594a:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
  705950:	f3 0f 10 0c 24       	movss  (%rsp),%xmm1
  705955:	ff 15 4d 3c 42 00    	call   *0x423c4d(%rip)        # b295a8 <_DYNAMIC+0x4a8>
  70595b:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  705962:	00 00 
  705964:	83 bc 24 90 00 00 00 	cmpl   $0x1,0x90(%rsp)
  70596b:	01 
  70596c:	0f 85 34 01 00 00    	jne    705aa6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x306>
  705972:	f3 0f 10 84 24 94 00 	movss  0x94(%rsp),%xmm0
  705979:	00 00 
  70597b:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  705980:	f3 0f 10 84 24 98 00 	movss  0x98(%rsp),%xmm0
  705987:	00 00 
  705989:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70598f:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705994:	e8 47 26 ff ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  705999:	48 8b b3 68 05 00 00 	mov    0x568(%rbx),%rsi
  7059a0:	49 39 f4             	cmp    %rsi,%r12
  7059a3:	0f 83 75 03 00 00    	jae    705d1e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x57e>
  7059a9:	48 8b 8b 60 05 00 00 	mov    0x560(%rbx),%rcx
  7059b0:	48 8d b3 c0 02 00 00 	lea    0x2c0(%rbx),%rsi
  7059b7:	4c 89 e0             	mov    %r12,%rax
  7059ba:	48 c1 e0 04          	shl    $0x4,%rax
  7059be:	0f 10 04 01          	movups (%rcx,%rax,1),%xmm0
  7059c2:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  7059c9:	00 
  7059ca:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7059cf:	48 8d 94 24 90 00 00 	lea    0x90(%rsp),%rdx
  7059d6:	00 
  7059d7:	ff 15 ab 3b 42 00    	call   *0x423bab(%rip)        # b29588 <_DYNAMIC+0x488>
  7059dd:	80 7c 24 10 00       	cmpb   $0x0,0x10(%rsp)
  7059e2:	74 59                	je     705a3d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x29d>
  7059e4:	0f b6 44 24 11       	movzbl 0x11(%rsp),%eax
  7059e9:	48 c7 45 00 22 00 00 	movq   $0x22,0x0(%rbp)
  7059f0:	00 
  7059f1:	88 45 08             	mov    %al,0x8(%rbp)
  7059f4:	eb 07                	jmp    7059fd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  7059f6:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  7059fd:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
  705a04:	5b                   	pop    %rbx
  705a05:	41 5c                	pop    %r12
  705a07:	41 5d                	pop    %r13
  705a09:	41 5e                	pop    %r14
  705a0b:	41 5f                	pop    %r15
  705a0d:	5d                   	pop    %rbp
  705a0e:	c3                   	ret
  705a0f:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  705a14:	48 89 4d 30          	mov    %rcx,0x30(%rbp)
  705a18:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  705a1d:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  705a22:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  705a26:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  705a2a:	48 89 45 00          	mov    %rax,0x0(%rbp)
  705a2e:	4c 89 65 08          	mov    %r12,0x8(%rbp)
  705a32:	eb c9                	jmp    7059fd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705a34:	48 c7 00 19 00 00 00 	movq   $0x19,(%rax)
  705a3b:	eb c0                	jmp    7059fd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705a3d:	f3 0f 10 44 24 34    	movss  0x34(%rsp),%xmm0
  705a43:	f3 0f 11 84 24 80 00 	movss  %xmm0,0x80(%rsp)
  705a4a:	00 00 
  705a4c:	f3 0f 10 44 24 3c    	movss  0x3c(%rsp),%xmm0
  705a52:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  705a58:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705a5d:	48 89 de             	mov    %rbx,%rsi
  705a60:	4c 89 e2             	mov    %r12,%rdx
  705a63:	e8 58 d7 ff ff       	call   7031c0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::interaction_layout>
  705a68:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  705a6d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  705a71:	75 40                	jne    705ab3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x313>
  705a73:	f3 0f 10 4c 24 08    	movss  0x8(%rsp),%xmm1
  705a79:	f3 0f 5c 4c 24 70    	subss  0x70(%rsp),%xmm1
  705a7f:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
  705a84:	f3 0f 5c 84 24 80 00 	subss  0x80(%rsp),%xmm0
  705a8b:	00 00 
  705a8d:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  705a92:	ff 15 18 3b 42 00    	call   *0x423b18(%rip)        # b295b0 <_DYNAMIC+0x4b0>
  705a98:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  705a9f:	00 00 
  705aa1:	80 fa 02             	cmp    $0x2,%dl
  705aa4:	75 3a                	jne    705ae0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x340>
  705aa6:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  705aad:	00 
  705aae:	e9 4a ff ff ff       	jmp    7059fd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705ab3:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  705ab8:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  705abd:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  705ac1:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  705ac6:	0f 11 45 20          	movups %xmm0,0x20(%rbp)
  705aca:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  705acf:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  705ad3:	48 89 45 00          	mov    %rax,0x0(%rbp)
  705ad7:	48 89 4d 08          	mov    %rcx,0x8(%rbp)
  705adb:	e9 1d ff ff ff       	jmp    7059fd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705ae0:	41 89 d5             	mov    %edx,%r13d
  705ae3:	41 89 c4             	mov    %eax,%r12d
  705ae6:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705aeb:	e8 f0 24 ff ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  705af0:	48 83 bb 60 06 00 00 	cmpq   $0xffffffffffffffff,0x660(%rbx)
  705af7:	ff 
  705af8:	0f 84 03 02 00 00    	je     705d01 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x561>
  705afe:	48 c7 44 24 10 1f 00 	movq   $0x1f,0x10(%rsp)
  705b05:	00 00 
  705b07:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705b0c:	e8 cf 24 ff ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  705b11:	48 89 de             	mov    %rbx,%rsi
  705b14:	48 8b 83 e8 05 00 00 	mov    0x5e8(%rbx),%rax
  705b1b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  705b20:	48 8b 83 f0 05 00 00 	mov    0x5f0(%rbx),%rax
  705b27:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  705b2e:	00 
  705b2f:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  705b36:	48 89 04 24          	mov    %rax,(%rsp)
  705b3a:	48 8b 83 88 06 00 00 	mov    0x688(%rbx),%rax
  705b41:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  705b46:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705b4b:	4c 89 fa             	mov    %r15,%rdx
  705b4e:	4c 89 f1             	mov    %r14,%rcx
  705b51:	e8 1a b7 ff ff       	call   701270 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::focus>
  705b56:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  705b5b:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  705b5f:	0f 85 fa 00 00 00    	jne    705c5f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x4bf>
  705b65:	41 80 e5 01          	and    $0x1,%r13b
  705b69:	44 89 a4 24 c0 00 00 	mov    %r12d,0xc0(%rsp)
  705b70:	00 
  705b71:	44 88 ac 24 c4 00 00 	mov    %r13b,0xc4(%rsp)
  705b78:	00 
  705b79:	44 89 a4 24 c8 00 00 	mov    %r12d,0xc8(%rsp)
  705b80:	00 
  705b81:	44 88 ac 24 cc 00 00 	mov    %r13b,0xcc(%rsp)
  705b88:	00 
  705b89:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  705b8e:	4c 8d 84 24 c0 00 00 	lea    0xc0(%rsp),%r8
  705b95:	00 
  705b96:	48 89 de             	mov    %rbx,%rsi
  705b99:	4c 89 fa             	mov    %r15,%rdx
  705b9c:	4c 89 f1             	mov    %r14,%rcx
  705b9f:	e8 fc f9 ff ff       	call   7055a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input>
  705ba4:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  705ba9:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  705bae:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  705bb5:	00 
  705bb6:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  705bbb:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  705bc2:	00 
  705bc3:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  705bc8:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  705bcf:	00 
  705bd0:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  705bd4:	0f 85 bf 00 00 00    	jne    705c99 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x4f9>
  705bda:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  705be1:	00 
  705be2:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  705be9:	00 
  705bea:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  705bf1:	00 
  705bf2:	0f 29 94 24 00 01 00 	movaps %xmm2,0x100(%rsp)
  705bf9:	00 
  705bfa:	0f 29 8c 24 f0 00 00 	movaps %xmm1,0xf0(%rsp)
  705c01:	00 
  705c02:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  705c09:	00 
  705c0a:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  705c11:	48 85 c0             	test   %rax,%rax
  705c14:	48 89 ef             	mov    %rbp,%rdi
  705c17:	0f 84 a9 00 00 00    	je     705cc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x526>
  705c1d:	48 8b 0c 24          	mov    (%rsp),%rcx
  705c21:	48 85 c9             	test   %rcx,%rcx
  705c24:	0f 84 a7 00 00 00    	je     705cd1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x531>
  705c2a:	48 39 c8             	cmp    %rcx,%rax
  705c2d:	0f 85 9e 00 00 00    	jne    705cd1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x531>
  705c33:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  705c38:	48 39 83 88 06 00 00 	cmp    %rax,0x688(%rbx)
  705c3f:	0f 85 8c 00 00 00    	jne    705cd1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x531>
  705c45:	48 89 de             	mov    %rbx,%rsi
  705c48:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  705c4d:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  705c54:	00 
  705c55:	e8 d6 00 00 00       	call   705d30 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::publish_focus_change>
  705c5a:	e9 9e fd ff ff       	jmp    7059fd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705c5f:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  705c64:	0f b6 54 24 40       	movzbl 0x40(%rsp),%edx
  705c69:	8b 74 24 44          	mov    0x44(%rsp),%esi
  705c6d:	89 75 34             	mov    %esi,0x34(%rbp)
  705c70:	8b 74 24 41          	mov    0x41(%rsp),%esi
  705c74:	89 75 31             	mov    %esi,0x31(%rbp)
  705c77:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  705c7c:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  705c81:	48 89 45 00          	mov    %rax,0x0(%rbp)
  705c85:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  705c89:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  705c8d:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  705c91:	88 55 30             	mov    %dl,0x30(%rbp)
  705c94:	e9 64 fd ff ff       	jmp    7059fd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705c99:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  705ca0:	00 
  705ca1:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  705ca8:	00 
  705ca9:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  705cb0:	00 
  705cb1:	0f 11 55 28          	movups %xmm2,0x28(%rbp)
  705cb5:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  705cb9:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  705cbd:	48 89 45 00          	mov    %rax,0x0(%rbp)
  705cc1:	e9 37 fd ff ff       	jmp    7059fd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705cc6:	48 83 3c 24 00       	cmpq   $0x0,(%rsp)
  705ccb:	0f 84 74 ff ff ff    	je     705c45 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x4a5>
  705cd1:	0f 28 84 24 e0 00 00 	movaps 0xe0(%rsp),%xmm0
  705cd8:	00 
  705cd9:	0f 28 8c 24 f0 00 00 	movaps 0xf0(%rsp),%xmm1
  705ce0:	00 
  705ce1:	0f 28 94 24 00 01 00 	movaps 0x100(%rsp),%xmm2
  705ce8:	00 
  705ce9:	0f 11 57 28          	movups %xmm2,0x28(%rdi)
  705ced:	0f 11 4f 18          	movups %xmm1,0x18(%rdi)
  705cf1:	0f 11 47 08          	movups %xmm0,0x8(%rdi)
  705cf5:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  705cfc:	e9 fc fc ff ff       	jmp    7059fd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705d01:	48 c7 45 00 1f 00 00 	movq   $0x1f,0x0(%rbp)
  705d08:	00 
  705d09:	e9 ef fc ff ff       	jmp    7059fd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer+0x25d>
  705d0e:	48 8d 15 d3 52 3f 00 	lea    0x3f52d3(%rip),%rdx        # afafe8 <__frame_dummy_init_array_entry+0x750>
  705d15:	4c 89 e7             	mov    %r12,%rdi
  705d18:	ff 15 3a 37 42 00    	call   *0x42373a(%rip)        # b29458 <_DYNAMIC+0x358>
  705d1e:	48 8d 15 db 52 3f 00 	lea    0x3f52db(%rip),%rdx        # afb000 <__frame_dummy_init_array_entry+0x768>
  705d25:	4c 89 e7             	mov    %r12,%rdi
  705d28:	ff 15 2a 37 42 00    	call   *0x42372a(%rip)        # b29458 <_DYNAMIC+0x358>
