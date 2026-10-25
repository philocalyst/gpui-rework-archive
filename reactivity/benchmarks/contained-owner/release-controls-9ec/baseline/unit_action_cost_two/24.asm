
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000703a10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer>:
  703a10:	55                   	push   %rbp
  703a11:	41 57                	push   %r15
  703a13:	41 56                	push   %r14
  703a15:	41 55                	push   %r13
  703a17:	41 54                	push   %r12
  703a19:	53                   	push   %rbx
  703a1a:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
  703a21:	80 be 22 08 00 00 01 	cmpb   $0x1,0x822(%rsi)
  703a28:	75 0c                	jne    703a36 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x26>
  703a2a:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  703a31:	e9 37 02 00 00       	jmp    703c6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  703a36:	80 be 1e 08 00 00 01 	cmpb   $0x1,0x81e(%rsi)
  703a3d:	0f 85 23 02 00 00    	jne    703c66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  703a43:	80 be 1f 08 00 00 00 	cmpb   $0x0,0x81f(%rsi)
  703a4a:	0f 85 16 02 00 00    	jne    703c66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  703a50:	80 be 20 08 00 00 00 	cmpb   $0x0,0x820(%rsi)
  703a57:	0f 84 09 02 00 00    	je     703c66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  703a5d:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  703a64:	ff 
  703a65:	0f 85 fb 01 00 00    	jne    703c66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  703a6b:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  703a72:	48 3b 86 68 06 00 00 	cmp    0x668(%rsi),%rax
  703a79:	0f 85 e7 01 00 00    	jne    703c66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  703a7f:	48 8b 86 78 06 00 00 	mov    0x678(%rsi),%rax
  703a86:	48 3b 86 70 06 00 00 	cmp    0x670(%rsi),%rax
  703a8d:	0f 85 d3 01 00 00    	jne    703c66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  703a93:	f3 0f 10 96 14 08 00 	movss  0x814(%rsi),%xmm2
  703a9a:	00 
  703a9b:	0f 2e 96 18 08 00 00 	ucomiss 0x818(%rsi),%xmm2
  703aa2:	0f 85 be 01 00 00    	jne    703c66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  703aa8:	0f 8a b8 01 00 00    	jp     703c66 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  703aae:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  703ab4:	f3 0f 11 0c 24       	movss  %xmm1,(%rsp)
  703ab9:	48 89 fd             	mov    %rdi,%rbp
  703abc:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  703ac1:	48 89 f3             	mov    %rsi,%rbx
  703ac4:	49 89 d7             	mov    %rdx,%r15
  703ac7:	49 89 ce             	mov    %rcx,%r14
  703aca:	e8 91 c6 ff ff       	call   700160 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::input_index>
  703acf:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  703ad4:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  703ad9:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  703add:	0f 85 9c 01 00 00    	jne    703c7f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x26f>
  703ae3:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  703aea:	49 39 f4             	cmp    %rsi,%r12
  703aed:	0f 83 8b 04 00 00    	jae    703f7e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x56e>
  703af3:	48 89 e8             	mov    %rbp,%rax
  703af6:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  703afd:	4b 8d 34 a4          	lea    (%r12,%r12,4),%rsi
  703b01:	48 8b 34 f1          	mov    (%rcx,%rsi,8),%rsi
  703b05:	48 8b 8b 78 05 00 00 	mov    0x578(%rbx),%rcx
  703b0c:	48 8b 93 80 05 00 00 	mov    0x580(%rbx),%rdx
  703b13:	48 c1 e2 04          	shl    $0x4,%rdx
  703b17:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  703b1b:	31 d2                	xor    %edx,%edx
  703b1d:	49 89 c8             	mov    %rcx,%r8
  703b20:	48 39 d7             	cmp    %rdx,%rdi
  703b23:	0f 84 7b 01 00 00    	je     703ca4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x294>
  703b29:	48 83 c2 50          	add    $0x50,%rdx
  703b2d:	49 39 70 20          	cmp    %rsi,0x20(%r8)
  703b31:	4d 8d 40 50          	lea    0x50(%r8),%r8
  703b35:	75 e9                	jne    703b20 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x110>
  703b37:	f3 0f 10 44 11 e0    	movss  -0x20(%rcx,%rdx,1),%xmm0
  703b3d:	0f 2e c0             	ucomiss %xmm0,%xmm0
  703b40:	0f 8a 5e 01 00 00    	jp     703ca4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x294>
  703b46:	f3 0f 10 4c 11 e4    	movss  -0x1c(%rcx,%rdx,1),%xmm1
  703b4c:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  703b53:	00 00 
  703b55:	0f 14 c1             	unpcklps %xmm1,%xmm0
  703b58:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  703b5b:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  703b62:	00 
  703b63:	0f 5a 44 11 e8       	cvtps2pd -0x18(%rcx,%rdx,1),%xmm0
  703b68:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  703b6d:	0f 5a 44 11 f0       	cvtps2pd -0x10(%rcx,%rdx,1),%xmm0
  703b72:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  703b79:	00 
  703b7a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  703b7f:	e8 fc 3e ff ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  703b84:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  703b8b:	00 
  703b8c:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  703b91:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  703b96:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  703b9b:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
  703ba2:	00 
  703ba3:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  703ba8:	c6 44 24 40 00       	movb   $0x0,0x40(%rsp)
  703bad:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  703bb4:	00 
  703bb5:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  703bba:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
  703bc0:	f3 0f 10 0c 24       	movss  (%rsp),%xmm1
  703bc5:	ff 15 85 45 42 00    	call   *0x424585(%rip)        # b28150 <_DYNAMIC+0x498>
  703bcb:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  703bd2:	00 00 
  703bd4:	83 bc 24 90 00 00 00 	cmpl   $0x1,0x90(%rsp)
  703bdb:	01 
  703bdc:	0f 85 34 01 00 00    	jne    703d16 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x306>
  703be2:	f3 0f 10 84 24 94 00 	movss  0x94(%rsp),%xmm0
  703be9:	00 00 
  703beb:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  703bf0:	f3 0f 10 84 24 98 00 	movss  0x98(%rsp),%xmm0
  703bf7:	00 00 
  703bf9:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  703bff:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  703c04:	e8 77 3e ff ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  703c09:	48 8b b3 68 05 00 00 	mov    0x568(%rbx),%rsi
  703c10:	49 39 f4             	cmp    %rsi,%r12
  703c13:	0f 83 75 03 00 00    	jae    703f8e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x57e>
  703c19:	48 8b 8b 60 05 00 00 	mov    0x560(%rbx),%rcx
  703c20:	48 8d b3 c0 02 00 00 	lea    0x2c0(%rbx),%rsi
  703c27:	4c 89 e0             	mov    %r12,%rax
  703c2a:	48 c1 e0 04          	shl    $0x4,%rax
  703c2e:	0f 10 04 01          	movups (%rcx,%rax,1),%xmm0
  703c32:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  703c39:	00 
  703c3a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  703c3f:	48 8d 94 24 90 00 00 	lea    0x90(%rsp),%rdx
  703c46:	00 
  703c47:	ff 15 e3 44 42 00    	call   *0x4244e3(%rip)        # b28130 <_DYNAMIC+0x478>
  703c4d:	80 7c 24 10 00       	cmpb   $0x0,0x10(%rsp)
  703c52:	74 59                	je     703cad <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x29d>
  703c54:	0f b6 44 24 11       	movzbl 0x11(%rsp),%eax
  703c59:	48 c7 45 00 22 00 00 	movq   $0x22,0x0(%rbp)
  703c60:	00 
  703c61:	88 45 08             	mov    %al,0x8(%rbp)
  703c64:	eb 07                	jmp    703c6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  703c66:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  703c6d:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
  703c74:	5b                   	pop    %rbx
  703c75:	41 5c                	pop    %r12
  703c77:	41 5d                	pop    %r13
  703c79:	41 5e                	pop    %r14
  703c7b:	41 5f                	pop    %r15
  703c7d:	5d                   	pop    %rbp
  703c7e:	c3                   	ret
  703c7f:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  703c84:	48 89 4d 30          	mov    %rcx,0x30(%rbp)
  703c88:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  703c8d:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  703c92:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  703c96:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  703c9a:	48 89 45 00          	mov    %rax,0x0(%rbp)
  703c9e:	4c 89 65 08          	mov    %r12,0x8(%rbp)
  703ca2:	eb c9                	jmp    703c6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  703ca4:	48 c7 00 19 00 00 00 	movq   $0x19,(%rax)
  703cab:	eb c0                	jmp    703c6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  703cad:	f3 0f 10 44 24 34    	movss  0x34(%rsp),%xmm0
  703cb3:	f3 0f 11 84 24 80 00 	movss  %xmm0,0x80(%rsp)
  703cba:	00 00 
  703cbc:	f3 0f 10 44 24 3c    	movss  0x3c(%rsp),%xmm0
  703cc2:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  703cc8:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  703ccd:	48 89 de             	mov    %rbx,%rsi
  703cd0:	4c 89 e2             	mov    %r12,%rdx
  703cd3:	e8 f8 cf ff ff       	call   700cd0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::interaction_layout>
  703cd8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  703cdd:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  703ce1:	75 40                	jne    703d23 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x313>
  703ce3:	f3 0f 10 4c 24 08    	movss  0x8(%rsp),%xmm1
  703ce9:	f3 0f 5c 4c 24 70    	subss  0x70(%rsp),%xmm1
  703cef:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
  703cf4:	f3 0f 5c 84 24 80 00 	subss  0x80(%rsp),%xmm0
  703cfb:	00 00 
  703cfd:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  703d02:	ff 15 50 44 42 00    	call   *0x424450(%rip)        # b28158 <_DYNAMIC+0x4a0>
  703d08:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  703d0f:	00 00 
  703d11:	80 fa 02             	cmp    $0x2,%dl
  703d14:	75 3a                	jne    703d50 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x340>
  703d16:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  703d1d:	00 
  703d1e:	e9 4a ff ff ff       	jmp    703c6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  703d23:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  703d28:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  703d2d:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  703d31:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  703d36:	0f 11 45 20          	movups %xmm0,0x20(%rbp)
  703d3a:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  703d3f:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  703d43:	48 89 45 00          	mov    %rax,0x0(%rbp)
  703d47:	48 89 4d 08          	mov    %rcx,0x8(%rbp)
  703d4b:	e9 1d ff ff ff       	jmp    703c6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  703d50:	41 89 d5             	mov    %edx,%r13d
  703d53:	41 89 c4             	mov    %eax,%r12d
  703d56:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  703d5b:	e8 20 3d ff ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  703d60:	48 83 bb 60 06 00 00 	cmpq   $0xffffffffffffffff,0x660(%rbx)
  703d67:	ff 
  703d68:	0f 84 03 02 00 00    	je     703f71 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x561>
  703d6e:	48 c7 44 24 10 1f 00 	movq   $0x1f,0x10(%rsp)
  703d75:	00 00 
  703d77:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  703d7c:	e8 ff 3c ff ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  703d81:	48 89 de             	mov    %rbx,%rsi
  703d84:	48 8b 83 e8 05 00 00 	mov    0x5e8(%rbx),%rax
  703d8b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  703d90:	48 8b 83 f0 05 00 00 	mov    0x5f0(%rbx),%rax
  703d97:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  703d9e:	00 
  703d9f:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  703da6:	48 89 04 24          	mov    %rax,(%rsp)
  703daa:	48 8b 83 88 06 00 00 	mov    0x688(%rbx),%rax
  703db1:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  703db6:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  703dbb:	4c 89 fa             	mov    %r15,%rdx
  703dbe:	4c 89 f1             	mov    %r14,%rcx
  703dc1:	e8 2a bf ff ff       	call   6ffcf0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::focus>
  703dc6:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  703dcb:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  703dcf:	0f 85 fa 00 00 00    	jne    703ecf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x4bf>
  703dd5:	41 80 e5 01          	and    $0x1,%r13b
  703dd9:	44 89 a4 24 c0 00 00 	mov    %r12d,0xc0(%rsp)
  703de0:	00 
  703de1:	44 88 ac 24 c4 00 00 	mov    %r13b,0xc4(%rsp)
  703de8:	00 
  703de9:	44 89 a4 24 c8 00 00 	mov    %r12d,0xc8(%rsp)
  703df0:	00 
  703df1:	44 88 ac 24 cc 00 00 	mov    %r13b,0xcc(%rsp)
  703df8:	00 
  703df9:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  703dfe:	4c 8d 84 24 c0 00 00 	lea    0xc0(%rsp),%r8
  703e05:	00 
  703e06:	48 89 de             	mov    %rbx,%rsi
  703e09:	4c 89 fa             	mov    %r15,%rdx
  703e0c:	4c 89 f1             	mov    %r14,%rcx
  703e0f:	e8 fc f9 ff ff       	call   703810 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input>
  703e14:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  703e19:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  703e1e:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  703e25:	00 
  703e26:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  703e2b:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  703e32:	00 
  703e33:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  703e38:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  703e3f:	00 
  703e40:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  703e44:	0f 85 bf 00 00 00    	jne    703f09 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x4f9>
  703e4a:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  703e51:	00 
  703e52:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  703e59:	00 
  703e5a:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  703e61:	00 
  703e62:	0f 29 94 24 00 01 00 	movaps %xmm2,0x100(%rsp)
  703e69:	00 
  703e6a:	0f 29 8c 24 f0 00 00 	movaps %xmm1,0xf0(%rsp)
  703e71:	00 
  703e72:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  703e79:	00 
  703e7a:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  703e81:	48 85 c0             	test   %rax,%rax
  703e84:	48 89 ef             	mov    %rbp,%rdi
  703e87:	0f 84 a9 00 00 00    	je     703f36 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x526>
  703e8d:	48 8b 0c 24          	mov    (%rsp),%rcx
  703e91:	48 85 c9             	test   %rcx,%rcx
  703e94:	0f 84 a7 00 00 00    	je     703f41 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x531>
  703e9a:	48 39 c8             	cmp    %rcx,%rax
  703e9d:	0f 85 9e 00 00 00    	jne    703f41 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x531>
  703ea3:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  703ea8:	48 39 83 88 06 00 00 	cmp    %rax,0x688(%rbx)
  703eaf:	0f 85 8c 00 00 00    	jne    703f41 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x531>
  703eb5:	48 89 de             	mov    %rbx,%rsi
  703eb8:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  703ebd:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  703ec4:	00 
  703ec5:	e8 d6 00 00 00       	call   703fa0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change>
  703eca:	e9 9e fd ff ff       	jmp    703c6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  703ecf:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  703ed4:	0f b6 54 24 40       	movzbl 0x40(%rsp),%edx
  703ed9:	8b 74 24 44          	mov    0x44(%rsp),%esi
  703edd:	89 75 34             	mov    %esi,0x34(%rbp)
  703ee0:	8b 74 24 41          	mov    0x41(%rsp),%esi
  703ee4:	89 75 31             	mov    %esi,0x31(%rbp)
  703ee7:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  703eec:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  703ef1:	48 89 45 00          	mov    %rax,0x0(%rbp)
  703ef5:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  703ef9:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  703efd:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  703f01:	88 55 30             	mov    %dl,0x30(%rbp)
  703f04:	e9 64 fd ff ff       	jmp    703c6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  703f09:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  703f10:	00 
  703f11:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  703f18:	00 
  703f19:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  703f20:	00 
  703f21:	0f 11 55 28          	movups %xmm2,0x28(%rbp)
  703f25:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  703f29:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  703f2d:	48 89 45 00          	mov    %rax,0x0(%rbp)
  703f31:	e9 37 fd ff ff       	jmp    703c6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  703f36:	48 83 3c 24 00       	cmpq   $0x0,(%rsp)
  703f3b:	0f 84 74 ff ff ff    	je     703eb5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x4a5>
  703f41:	0f 28 84 24 e0 00 00 	movaps 0xe0(%rsp),%xmm0
  703f48:	00 
  703f49:	0f 28 8c 24 f0 00 00 	movaps 0xf0(%rsp),%xmm1
  703f50:	00 
  703f51:	0f 28 94 24 00 01 00 	movaps 0x100(%rsp),%xmm2
  703f58:	00 
  703f59:	0f 11 57 28          	movups %xmm2,0x28(%rdi)
  703f5d:	0f 11 4f 18          	movups %xmm1,0x18(%rdi)
  703f61:	0f 11 47 08          	movups %xmm0,0x8(%rdi)
  703f65:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  703f6c:	e9 fc fc ff ff       	jmp    703c6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  703f71:	48 c7 45 00 1f 00 00 	movq   $0x1f,0x0(%rbp)
  703f78:	00 
  703f79:	e9 ef fc ff ff       	jmp    703c6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  703f7e:	48 8d 15 ab 5c 3f 00 	lea    0x3f5cab(%rip),%rdx        # af9c30 <__frame_dummy_init_array_entry+0x708>
  703f85:	4c 89 e7             	mov    %r12,%rdi
  703f88:	ff 15 82 40 42 00    	call   *0x424082(%rip)        # b28010 <_DYNAMIC+0x358>
  703f8e:	48 8d 15 b3 5c 3f 00 	lea    0x3f5cb3(%rip),%rdx        # af9c48 <__frame_dummy_init_array_entry+0x720>
  703f95:	4c 89 e7             	mov    %r12,%rdi
  703f98:	ff 15 72 40 42 00    	call   *0x424072(%rip)        # b28010 <_DYNAMIC+0x358>
