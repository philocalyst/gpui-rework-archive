
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000704ce0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer>:
  704ce0:	55                   	push   %rbp
  704ce1:	41 57                	push   %r15
  704ce3:	41 56                	push   %r14
  704ce5:	41 55                	push   %r13
  704ce7:	41 54                	push   %r12
  704ce9:	53                   	push   %rbx
  704cea:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
  704cf1:	80 be 22 08 00 00 01 	cmpb   $0x1,0x822(%rsi)
  704cf8:	75 0c                	jne    704d06 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x26>
  704cfa:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  704d01:	e9 37 02 00 00       	jmp    704f3d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  704d06:	80 be 1e 08 00 00 01 	cmpb   $0x1,0x81e(%rsi)
  704d0d:	0f 85 23 02 00 00    	jne    704f36 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704d13:	80 be 1f 08 00 00 00 	cmpb   $0x0,0x81f(%rsi)
  704d1a:	0f 85 16 02 00 00    	jne    704f36 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704d20:	80 be 20 08 00 00 00 	cmpb   $0x0,0x820(%rsi)
  704d27:	0f 84 09 02 00 00    	je     704f36 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704d2d:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  704d34:	ff 
  704d35:	0f 85 fb 01 00 00    	jne    704f36 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704d3b:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  704d42:	48 3b 86 68 06 00 00 	cmp    0x668(%rsi),%rax
  704d49:	0f 85 e7 01 00 00    	jne    704f36 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704d4f:	48 8b 86 78 06 00 00 	mov    0x678(%rsi),%rax
  704d56:	48 3b 86 70 06 00 00 	cmp    0x670(%rsi),%rax
  704d5d:	0f 85 d3 01 00 00    	jne    704f36 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704d63:	f3 0f 10 96 14 08 00 	movss  0x814(%rsi),%xmm2
  704d6a:	00 
  704d6b:	0f 2e 96 18 08 00 00 	ucomiss 0x818(%rsi),%xmm2
  704d72:	0f 85 be 01 00 00    	jne    704f36 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704d78:	0f 8a b8 01 00 00    	jp     704f36 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704d7e:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  704d84:	f3 0f 11 0c 24       	movss  %xmm1,(%rsp)
  704d89:	48 89 fd             	mov    %rdi,%rbp
  704d8c:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  704d91:	48 89 f3             	mov    %rsi,%rbx
  704d94:	49 89 d7             	mov    %rdx,%r15
  704d97:	49 89 ce             	mov    %rcx,%r14
  704d9a:	e8 91 c6 ff ff       	call   701430 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::input_index>
  704d9f:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  704da4:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  704da9:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  704dad:	0f 85 9c 01 00 00    	jne    704f4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x26f>
  704db3:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  704dba:	49 39 f4             	cmp    %rsi,%r12
  704dbd:	0f 83 8b 04 00 00    	jae    70524e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x56e>
  704dc3:	48 89 e8             	mov    %rbp,%rax
  704dc6:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  704dcd:	4b 8d 34 a4          	lea    (%r12,%r12,4),%rsi
  704dd1:	48 8b 34 f1          	mov    (%rcx,%rsi,8),%rsi
  704dd5:	48 8b 8b 78 05 00 00 	mov    0x578(%rbx),%rcx
  704ddc:	48 8b 93 80 05 00 00 	mov    0x580(%rbx),%rdx
  704de3:	48 c1 e2 04          	shl    $0x4,%rdx
  704de7:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  704deb:	31 d2                	xor    %edx,%edx
  704ded:	49 89 c8             	mov    %rcx,%r8
  704df0:	48 39 d7             	cmp    %rdx,%rdi
  704df3:	0f 84 7b 01 00 00    	je     704f74 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x294>
  704df9:	48 83 c2 50          	add    $0x50,%rdx
  704dfd:	49 39 70 20          	cmp    %rsi,0x20(%r8)
  704e01:	4d 8d 40 50          	lea    0x50(%r8),%r8
  704e05:	75 e9                	jne    704df0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x110>
  704e07:	f3 0f 10 44 11 e0    	movss  -0x20(%rcx,%rdx,1),%xmm0
  704e0d:	0f 2e c0             	ucomiss %xmm0,%xmm0
  704e10:	0f 8a 5e 01 00 00    	jp     704f74 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x294>
  704e16:	f3 0f 10 4c 11 e4    	movss  -0x1c(%rcx,%rdx,1),%xmm1
  704e1c:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  704e23:	00 00 
  704e25:	0f 14 c1             	unpcklps %xmm1,%xmm0
  704e28:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  704e2b:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  704e32:	00 
  704e33:	0f 5a 44 11 e8       	cvtps2pd -0x18(%rcx,%rdx,1),%xmm0
  704e38:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  704e3d:	0f 5a 44 11 f0       	cvtps2pd -0x10(%rcx,%rdx,1),%xmm0
  704e42:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  704e49:	00 
  704e4a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  704e4f:	e8 9c 30 ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  704e54:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  704e5b:	00 
  704e5c:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  704e61:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  704e66:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  704e6b:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
  704e72:	00 
  704e73:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  704e78:	c6 44 24 40 00       	movb   $0x0,0x40(%rsp)
  704e7d:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  704e84:	00 
  704e85:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  704e8a:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
  704e90:	f3 0f 10 0c 24       	movss  (%rsp),%xmm1
  704e95:	ff 15 95 46 42 00    	call   *0x424695(%rip)        # b29530 <_DYNAMIC+0x4a8>
  704e9b:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  704ea2:	00 00 
  704ea4:	83 bc 24 90 00 00 00 	cmpl   $0x1,0x90(%rsp)
  704eab:	01 
  704eac:	0f 85 34 01 00 00    	jne    704fe6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x306>
  704eb2:	f3 0f 10 84 24 94 00 	movss  0x94(%rsp),%xmm0
  704eb9:	00 00 
  704ebb:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  704ec0:	f3 0f 10 84 24 98 00 	movss  0x98(%rsp),%xmm0
  704ec7:	00 00 
  704ec9:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  704ecf:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  704ed4:	e8 17 30 ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  704ed9:	48 8b b3 68 05 00 00 	mov    0x568(%rbx),%rsi
  704ee0:	49 39 f4             	cmp    %rsi,%r12
  704ee3:	0f 83 75 03 00 00    	jae    70525e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x57e>
  704ee9:	48 8b 8b 60 05 00 00 	mov    0x560(%rbx),%rcx
  704ef0:	48 8d b3 c0 02 00 00 	lea    0x2c0(%rbx),%rsi
  704ef7:	4c 89 e0             	mov    %r12,%rax
  704efa:	48 c1 e0 04          	shl    $0x4,%rax
  704efe:	0f 10 04 01          	movups (%rcx,%rax,1),%xmm0
  704f02:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  704f09:	00 
  704f0a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  704f0f:	48 8d 94 24 90 00 00 	lea    0x90(%rsp),%rdx
  704f16:	00 
  704f17:	ff 15 f3 45 42 00    	call   *0x4245f3(%rip)        # b29510 <_DYNAMIC+0x488>
  704f1d:	80 7c 24 10 00       	cmpb   $0x0,0x10(%rsp)
  704f22:	74 59                	je     704f7d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x29d>
  704f24:	0f b6 44 24 11       	movzbl 0x11(%rsp),%eax
  704f29:	48 c7 45 00 22 00 00 	movq   $0x22,0x0(%rbp)
  704f30:	00 
  704f31:	88 45 08             	mov    %al,0x8(%rbp)
  704f34:	eb 07                	jmp    704f3d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  704f36:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  704f3d:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
  704f44:	5b                   	pop    %rbx
  704f45:	41 5c                	pop    %r12
  704f47:	41 5d                	pop    %r13
  704f49:	41 5e                	pop    %r14
  704f4b:	41 5f                	pop    %r15
  704f4d:	5d                   	pop    %rbp
  704f4e:	c3                   	ret
  704f4f:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  704f54:	48 89 4d 30          	mov    %rcx,0x30(%rbp)
  704f58:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  704f5d:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  704f62:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  704f66:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  704f6a:	48 89 45 00          	mov    %rax,0x0(%rbp)
  704f6e:	4c 89 65 08          	mov    %r12,0x8(%rbp)
  704f72:	eb c9                	jmp    704f3d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  704f74:	48 c7 00 19 00 00 00 	movq   $0x19,(%rax)
  704f7b:	eb c0                	jmp    704f3d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  704f7d:	f3 0f 10 44 24 34    	movss  0x34(%rsp),%xmm0
  704f83:	f3 0f 11 84 24 80 00 	movss  %xmm0,0x80(%rsp)
  704f8a:	00 00 
  704f8c:	f3 0f 10 44 24 3c    	movss  0x3c(%rsp),%xmm0
  704f92:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  704f98:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  704f9d:	48 89 de             	mov    %rbx,%rsi
  704fa0:	4c 89 e2             	mov    %r12,%rdx
  704fa3:	e8 f8 cf ff ff       	call   701fa0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::interaction_layout>
  704fa8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  704fad:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  704fb1:	75 40                	jne    704ff3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x313>
  704fb3:	f3 0f 10 4c 24 08    	movss  0x8(%rsp),%xmm1
  704fb9:	f3 0f 5c 4c 24 70    	subss  0x70(%rsp),%xmm1
  704fbf:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
  704fc4:	f3 0f 5c 84 24 80 00 	subss  0x80(%rsp),%xmm0
  704fcb:	00 00 
  704fcd:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  704fd2:	ff 15 60 45 42 00    	call   *0x424560(%rip)        # b29538 <_DYNAMIC+0x4b0>
  704fd8:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  704fdf:	00 00 
  704fe1:	80 fa 02             	cmp    $0x2,%dl
  704fe4:	75 3a                	jne    705020 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x340>
  704fe6:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  704fed:	00 
  704fee:	e9 4a ff ff ff       	jmp    704f3d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  704ff3:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  704ff8:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  704ffd:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  705001:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  705006:	0f 11 45 20          	movups %xmm0,0x20(%rbp)
  70500a:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  70500f:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  705013:	48 89 45 00          	mov    %rax,0x0(%rbp)
  705017:	48 89 4d 08          	mov    %rcx,0x8(%rbp)
  70501b:	e9 1d ff ff ff       	jmp    704f3d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  705020:	41 89 d5             	mov    %edx,%r13d
  705023:	41 89 c4             	mov    %eax,%r12d
  705026:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70502b:	e8 c0 2e ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  705030:	48 83 bb 60 06 00 00 	cmpq   $0xffffffffffffffff,0x660(%rbx)
  705037:	ff 
  705038:	0f 84 03 02 00 00    	je     705241 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x561>
  70503e:	48 c7 44 24 10 1f 00 	movq   $0x1f,0x10(%rsp)
  705045:	00 00 
  705047:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70504c:	e8 9f 2e ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  705051:	48 89 de             	mov    %rbx,%rsi
  705054:	48 8b 83 e8 05 00 00 	mov    0x5e8(%rbx),%rax
  70505b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  705060:	48 8b 83 f0 05 00 00 	mov    0x5f0(%rbx),%rax
  705067:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  70506e:	00 
  70506f:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  705076:	48 89 04 24          	mov    %rax,(%rsp)
  70507a:	48 8b 83 88 06 00 00 	mov    0x688(%rbx),%rax
  705081:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  705086:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70508b:	4c 89 fa             	mov    %r15,%rdx
  70508e:	4c 89 f1             	mov    %r14,%rcx
  705091:	e8 2a bf ff ff       	call   700fc0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::focus>
  705096:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70509b:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70509f:	0f 85 fa 00 00 00    	jne    70519f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x4bf>
  7050a5:	41 80 e5 01          	and    $0x1,%r13b
  7050a9:	44 89 a4 24 c0 00 00 	mov    %r12d,0xc0(%rsp)
  7050b0:	00 
  7050b1:	44 88 ac 24 c4 00 00 	mov    %r13b,0xc4(%rsp)
  7050b8:	00 
  7050b9:	44 89 a4 24 c8 00 00 	mov    %r12d,0xc8(%rsp)
  7050c0:	00 
  7050c1:	44 88 ac 24 cc 00 00 	mov    %r13b,0xcc(%rsp)
  7050c8:	00 
  7050c9:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7050ce:	4c 8d 84 24 c0 00 00 	lea    0xc0(%rsp),%r8
  7050d5:	00 
  7050d6:	48 89 de             	mov    %rbx,%rsi
  7050d9:	4c 89 fa             	mov    %r15,%rdx
  7050dc:	4c 89 f1             	mov    %r14,%rcx
  7050df:	e8 fc f9 ff ff       	call   704ae0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input>
  7050e4:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7050e9:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  7050ee:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  7050f5:	00 
  7050f6:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  7050fb:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  705102:	00 
  705103:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  705108:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  70510f:	00 
  705110:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  705114:	0f 85 bf 00 00 00    	jne    7051d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x4f9>
  70511a:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  705121:	00 
  705122:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  705129:	00 
  70512a:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  705131:	00 
  705132:	0f 29 94 24 00 01 00 	movaps %xmm2,0x100(%rsp)
  705139:	00 
  70513a:	0f 29 8c 24 f0 00 00 	movaps %xmm1,0xf0(%rsp)
  705141:	00 
  705142:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  705149:	00 
  70514a:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  705151:	48 85 c0             	test   %rax,%rax
  705154:	48 89 ef             	mov    %rbp,%rdi
  705157:	0f 84 a9 00 00 00    	je     705206 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x526>
  70515d:	48 8b 0c 24          	mov    (%rsp),%rcx
  705161:	48 85 c9             	test   %rcx,%rcx
  705164:	0f 84 a7 00 00 00    	je     705211 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x531>
  70516a:	48 39 c8             	cmp    %rcx,%rax
  70516d:	0f 85 9e 00 00 00    	jne    705211 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x531>
  705173:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  705178:	48 39 83 88 06 00 00 	cmp    %rax,0x688(%rbx)
  70517f:	0f 85 8c 00 00 00    	jne    705211 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x531>
  705185:	48 89 de             	mov    %rbx,%rsi
  705188:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  70518d:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  705194:	00 
  705195:	e8 d6 00 00 00       	call   705270 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change>
  70519a:	e9 9e fd ff ff       	jmp    704f3d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  70519f:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  7051a4:	0f b6 54 24 40       	movzbl 0x40(%rsp),%edx
  7051a9:	8b 74 24 44          	mov    0x44(%rsp),%esi
  7051ad:	89 75 34             	mov    %esi,0x34(%rbp)
  7051b0:	8b 74 24 41          	mov    0x41(%rsp),%esi
  7051b4:	89 75 31             	mov    %esi,0x31(%rbp)
  7051b7:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  7051bc:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  7051c1:	48 89 45 00          	mov    %rax,0x0(%rbp)
  7051c5:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  7051c9:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  7051cd:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  7051d1:	88 55 30             	mov    %dl,0x30(%rbp)
  7051d4:	e9 64 fd ff ff       	jmp    704f3d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  7051d9:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  7051e0:	00 
  7051e1:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  7051e8:	00 
  7051e9:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  7051f0:	00 
  7051f1:	0f 11 55 28          	movups %xmm2,0x28(%rbp)
  7051f5:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  7051f9:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  7051fd:	48 89 45 00          	mov    %rax,0x0(%rbp)
  705201:	e9 37 fd ff ff       	jmp    704f3d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  705206:	48 83 3c 24 00       	cmpq   $0x0,(%rsp)
  70520b:	0f 84 74 ff ff ff    	je     705185 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x4a5>
  705211:	0f 28 84 24 e0 00 00 	movaps 0xe0(%rsp),%xmm0
  705218:	00 
  705219:	0f 28 8c 24 f0 00 00 	movaps 0xf0(%rsp),%xmm1
  705220:	00 
  705221:	0f 28 94 24 00 01 00 	movaps 0x100(%rsp),%xmm2
  705228:	00 
  705229:	0f 11 57 28          	movups %xmm2,0x28(%rdi)
  70522d:	0f 11 4f 18          	movups %xmm1,0x18(%rdi)
  705231:	0f 11 47 08          	movups %xmm0,0x8(%rdi)
  705235:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  70523c:	e9 fc fc ff ff       	jmp    704f3d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  705241:	48 c7 45 00 1f 00 00 	movq   $0x1f,0x0(%rbp)
  705248:	00 
  705249:	e9 ef fc ff ff       	jmp    704f3d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  70524e:	48 8d 15 63 5d 3f 00 	lea    0x3f5d63(%rip),%rdx        # afafb8 <__frame_dummy_init_array_entry+0x750>
  705255:	4c 89 e7             	mov    %r12,%rdi
  705258:	ff 15 82 41 42 00    	call   *0x424182(%rip)        # b293e0 <_DYNAMIC+0x358>
  70525e:	48 8d 15 6b 5d 3f 00 	lea    0x3f5d6b(%rip),%rdx        # afafd0 <__frame_dummy_init_array_entry+0x768>
  705265:	4c 89 e7             	mov    %r12,%rdi
  705268:	ff 15 72 41 42 00    	call   *0x424172(%rip)        # b293e0 <_DYNAMIC+0x358>
