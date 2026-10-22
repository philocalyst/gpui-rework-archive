
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000704d70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer>:
  704d70:	55                   	push   %rbp
  704d71:	41 57                	push   %r15
  704d73:	41 56                	push   %r14
  704d75:	41 55                	push   %r13
  704d77:	41 54                	push   %r12
  704d79:	53                   	push   %rbx
  704d7a:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
  704d81:	80 be 22 08 00 00 01 	cmpb   $0x1,0x822(%rsi)
  704d88:	75 0c                	jne    704d96 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x26>
  704d8a:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  704d91:	e9 37 02 00 00       	jmp    704fcd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  704d96:	80 be 1e 08 00 00 01 	cmpb   $0x1,0x81e(%rsi)
  704d9d:	0f 85 23 02 00 00    	jne    704fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704da3:	80 be 1f 08 00 00 00 	cmpb   $0x0,0x81f(%rsi)
  704daa:	0f 85 16 02 00 00    	jne    704fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704db0:	80 be 20 08 00 00 00 	cmpb   $0x0,0x820(%rsi)
  704db7:	0f 84 09 02 00 00    	je     704fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704dbd:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  704dc4:	ff 
  704dc5:	0f 85 fb 01 00 00    	jne    704fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704dcb:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  704dd2:	48 3b 86 68 06 00 00 	cmp    0x668(%rsi),%rax
  704dd9:	0f 85 e7 01 00 00    	jne    704fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704ddf:	48 8b 86 78 06 00 00 	mov    0x678(%rsi),%rax
  704de6:	48 3b 86 70 06 00 00 	cmp    0x670(%rsi),%rax
  704ded:	0f 85 d3 01 00 00    	jne    704fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704df3:	f3 0f 10 96 14 08 00 	movss  0x814(%rsi),%xmm2
  704dfa:	00 
  704dfb:	0f 2e 96 18 08 00 00 	ucomiss 0x818(%rsi),%xmm2
  704e02:	0f 85 be 01 00 00    	jne    704fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704e08:	0f 8a b8 01 00 00    	jp     704fc6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704e0e:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  704e14:	f3 0f 11 0c 24       	movss  %xmm1,(%rsp)
  704e19:	48 89 fd             	mov    %rdi,%rbp
  704e1c:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  704e21:	48 89 f3             	mov    %rsi,%rbx
  704e24:	49 89 d7             	mov    %rdx,%r15
  704e27:	49 89 ce             	mov    %rcx,%r14
  704e2a:	e8 91 c6 ff ff       	call   7014c0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::input_index>
  704e2f:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  704e34:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  704e39:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  704e3d:	0f 85 9c 01 00 00    	jne    704fdf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x26f>
  704e43:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  704e4a:	49 39 f4             	cmp    %rsi,%r12
  704e4d:	0f 83 8b 04 00 00    	jae    7052de <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x56e>
  704e53:	48 89 e8             	mov    %rbp,%rax
  704e56:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  704e5d:	4b 8d 34 a4          	lea    (%r12,%r12,4),%rsi
  704e61:	48 8b 34 f1          	mov    (%rcx,%rsi,8),%rsi
  704e65:	48 8b 8b 78 05 00 00 	mov    0x578(%rbx),%rcx
  704e6c:	48 8b 93 80 05 00 00 	mov    0x580(%rbx),%rdx
  704e73:	48 c1 e2 04          	shl    $0x4,%rdx
  704e77:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  704e7b:	31 d2                	xor    %edx,%edx
  704e7d:	49 89 c8             	mov    %rcx,%r8
  704e80:	48 39 d7             	cmp    %rdx,%rdi
  704e83:	0f 84 7b 01 00 00    	je     705004 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x294>
  704e89:	48 83 c2 50          	add    $0x50,%rdx
  704e8d:	49 39 70 20          	cmp    %rsi,0x20(%r8)
  704e91:	4d 8d 40 50          	lea    0x50(%r8),%r8
  704e95:	75 e9                	jne    704e80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x110>
  704e97:	f3 0f 10 44 11 e0    	movss  -0x20(%rcx,%rdx,1),%xmm0
  704e9d:	0f 2e c0             	ucomiss %xmm0,%xmm0
  704ea0:	0f 8a 5e 01 00 00    	jp     705004 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x294>
  704ea6:	f3 0f 10 4c 11 e4    	movss  -0x1c(%rcx,%rdx,1),%xmm1
  704eac:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  704eb3:	00 00 
  704eb5:	0f 14 c1             	unpcklps %xmm1,%xmm0
  704eb8:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  704ebb:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  704ec2:	00 
  704ec3:	0f 5a 44 11 e8       	cvtps2pd -0x18(%rcx,%rdx,1),%xmm0
  704ec8:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  704ecd:	0f 5a 44 11 f0       	cvtps2pd -0x10(%rcx,%rdx,1),%xmm0
  704ed2:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  704ed9:	00 
  704eda:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  704edf:	e8 fc 30 ff ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  704ee4:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  704eeb:	00 
  704eec:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  704ef1:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  704ef6:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  704efb:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
  704f02:	00 
  704f03:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  704f08:	c6 44 24 40 00       	movb   $0x0,0x40(%rsp)
  704f0d:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  704f14:	00 
  704f15:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  704f1a:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
  704f20:	f3 0f 10 0c 24       	movss  (%rsp),%xmm1
  704f25:	ff 15 7d 46 42 00    	call   *0x42467d(%rip)        # b295a8 <_DYNAMIC+0x4a8>
  704f2b:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  704f32:	00 00 
  704f34:	83 bc 24 90 00 00 00 	cmpl   $0x1,0x90(%rsp)
  704f3b:	01 
  704f3c:	0f 85 34 01 00 00    	jne    705076 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x306>
  704f42:	f3 0f 10 84 24 94 00 	movss  0x94(%rsp),%xmm0
  704f49:	00 00 
  704f4b:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  704f50:	f3 0f 10 84 24 98 00 	movss  0x98(%rsp),%xmm0
  704f57:	00 00 
  704f59:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  704f5f:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  704f64:	e8 77 30 ff ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  704f69:	48 8b b3 68 05 00 00 	mov    0x568(%rbx),%rsi
  704f70:	49 39 f4             	cmp    %rsi,%r12
  704f73:	0f 83 75 03 00 00    	jae    7052ee <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x57e>
  704f79:	48 8b 8b 60 05 00 00 	mov    0x560(%rbx),%rcx
  704f80:	48 8d b3 c0 02 00 00 	lea    0x2c0(%rbx),%rsi
  704f87:	4c 89 e0             	mov    %r12,%rax
  704f8a:	48 c1 e0 04          	shl    $0x4,%rax
  704f8e:	0f 10 04 01          	movups (%rcx,%rax,1),%xmm0
  704f92:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  704f99:	00 
  704f9a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  704f9f:	48 8d 94 24 90 00 00 	lea    0x90(%rsp),%rdx
  704fa6:	00 
  704fa7:	ff 15 db 45 42 00    	call   *0x4245db(%rip)        # b29588 <_DYNAMIC+0x488>
  704fad:	80 7c 24 10 00       	cmpb   $0x0,0x10(%rsp)
  704fb2:	74 59                	je     70500d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x29d>
  704fb4:	0f b6 44 24 11       	movzbl 0x11(%rsp),%eax
  704fb9:	48 c7 45 00 22 00 00 	movq   $0x22,0x0(%rbp)
  704fc0:	00 
  704fc1:	88 45 08             	mov    %al,0x8(%rbp)
  704fc4:	eb 07                	jmp    704fcd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  704fc6:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  704fcd:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
  704fd4:	5b                   	pop    %rbx
  704fd5:	41 5c                	pop    %r12
  704fd7:	41 5d                	pop    %r13
  704fd9:	41 5e                	pop    %r14
  704fdb:	41 5f                	pop    %r15
  704fdd:	5d                   	pop    %rbp
  704fde:	c3                   	ret
  704fdf:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  704fe4:	48 89 4d 30          	mov    %rcx,0x30(%rbp)
  704fe8:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  704fed:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  704ff2:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  704ff6:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  704ffa:	48 89 45 00          	mov    %rax,0x0(%rbp)
  704ffe:	4c 89 65 08          	mov    %r12,0x8(%rbp)
  705002:	eb c9                	jmp    704fcd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  705004:	48 c7 00 19 00 00 00 	movq   $0x19,(%rax)
  70500b:	eb c0                	jmp    704fcd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  70500d:	f3 0f 10 44 24 34    	movss  0x34(%rsp),%xmm0
  705013:	f3 0f 11 84 24 80 00 	movss  %xmm0,0x80(%rsp)
  70501a:	00 00 
  70501c:	f3 0f 10 44 24 3c    	movss  0x3c(%rsp),%xmm0
  705022:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  705028:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70502d:	48 89 de             	mov    %rbx,%rsi
  705030:	4c 89 e2             	mov    %r12,%rdx
  705033:	e8 f8 cf ff ff       	call   702030 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::interaction_layout>
  705038:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70503d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  705041:	75 40                	jne    705083 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x313>
  705043:	f3 0f 10 4c 24 08    	movss  0x8(%rsp),%xmm1
  705049:	f3 0f 5c 4c 24 70    	subss  0x70(%rsp),%xmm1
  70504f:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
  705054:	f3 0f 5c 84 24 80 00 	subss  0x80(%rsp),%xmm0
  70505b:	00 00 
  70505d:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  705062:	ff 15 48 45 42 00    	call   *0x424548(%rip)        # b295b0 <_DYNAMIC+0x4b0>
  705068:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  70506f:	00 00 
  705071:	80 fa 02             	cmp    $0x2,%dl
  705074:	75 3a                	jne    7050b0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x340>
  705076:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  70507d:	00 
  70507e:	e9 4a ff ff ff       	jmp    704fcd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  705083:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  705088:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  70508d:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  705091:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  705096:	0f 11 45 20          	movups %xmm0,0x20(%rbp)
  70509a:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  70509f:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  7050a3:	48 89 45 00          	mov    %rax,0x0(%rbp)
  7050a7:	48 89 4d 08          	mov    %rcx,0x8(%rbp)
  7050ab:	e9 1d ff ff ff       	jmp    704fcd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  7050b0:	41 89 d5             	mov    %edx,%r13d
  7050b3:	41 89 c4             	mov    %eax,%r12d
  7050b6:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7050bb:	e8 20 2f ff ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  7050c0:	48 83 bb 60 06 00 00 	cmpq   $0xffffffffffffffff,0x660(%rbx)
  7050c7:	ff 
  7050c8:	0f 84 03 02 00 00    	je     7052d1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x561>
  7050ce:	48 c7 44 24 10 1f 00 	movq   $0x1f,0x10(%rsp)
  7050d5:	00 00 
  7050d7:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7050dc:	e8 ff 2e ff ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  7050e1:	48 89 de             	mov    %rbx,%rsi
  7050e4:	48 8b 83 e8 05 00 00 	mov    0x5e8(%rbx),%rax
  7050eb:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  7050f0:	48 8b 83 f0 05 00 00 	mov    0x5f0(%rbx),%rax
  7050f7:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  7050fe:	00 
  7050ff:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  705106:	48 89 04 24          	mov    %rax,(%rsp)
  70510a:	48 8b 83 88 06 00 00 	mov    0x688(%rbx),%rax
  705111:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  705116:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70511b:	4c 89 fa             	mov    %r15,%rdx
  70511e:	4c 89 f1             	mov    %r14,%rcx
  705121:	e8 2a bf ff ff       	call   701050 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::focus>
  705126:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70512b:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70512f:	0f 85 fa 00 00 00    	jne    70522f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x4bf>
  705135:	41 80 e5 01          	and    $0x1,%r13b
  705139:	44 89 a4 24 c0 00 00 	mov    %r12d,0xc0(%rsp)
  705140:	00 
  705141:	44 88 ac 24 c4 00 00 	mov    %r13b,0xc4(%rsp)
  705148:	00 
  705149:	44 89 a4 24 c8 00 00 	mov    %r12d,0xc8(%rsp)
  705150:	00 
  705151:	44 88 ac 24 cc 00 00 	mov    %r13b,0xcc(%rsp)
  705158:	00 
  705159:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70515e:	4c 8d 84 24 c0 00 00 	lea    0xc0(%rsp),%r8
  705165:	00 
  705166:	48 89 de             	mov    %rbx,%rsi
  705169:	4c 89 fa             	mov    %r15,%rdx
  70516c:	4c 89 f1             	mov    %r14,%rcx
  70516f:	e8 fc f9 ff ff       	call   704b70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input>
  705174:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  705179:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70517e:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  705185:	00 
  705186:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70518b:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  705192:	00 
  705193:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  705198:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  70519f:	00 
  7051a0:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  7051a4:	0f 85 bf 00 00 00    	jne    705269 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x4f9>
  7051aa:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  7051b1:	00 
  7051b2:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  7051b9:	00 
  7051ba:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  7051c1:	00 
  7051c2:	0f 29 94 24 00 01 00 	movaps %xmm2,0x100(%rsp)
  7051c9:	00 
  7051ca:	0f 29 8c 24 f0 00 00 	movaps %xmm1,0xf0(%rsp)
  7051d1:	00 
  7051d2:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  7051d9:	00 
  7051da:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  7051e1:	48 85 c0             	test   %rax,%rax
  7051e4:	48 89 ef             	mov    %rbp,%rdi
  7051e7:	0f 84 a9 00 00 00    	je     705296 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x526>
  7051ed:	48 8b 0c 24          	mov    (%rsp),%rcx
  7051f1:	48 85 c9             	test   %rcx,%rcx
  7051f4:	0f 84 a7 00 00 00    	je     7052a1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x531>
  7051fa:	48 39 c8             	cmp    %rcx,%rax
  7051fd:	0f 85 9e 00 00 00    	jne    7052a1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x531>
  705203:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  705208:	48 39 83 88 06 00 00 	cmp    %rax,0x688(%rbx)
  70520f:	0f 85 8c 00 00 00    	jne    7052a1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x531>
  705215:	48 89 de             	mov    %rbx,%rsi
  705218:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  70521d:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  705224:	00 
  705225:	e8 d6 00 00 00       	call   705300 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change>
  70522a:	e9 9e fd ff ff       	jmp    704fcd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  70522f:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  705234:	0f b6 54 24 40       	movzbl 0x40(%rsp),%edx
  705239:	8b 74 24 44          	mov    0x44(%rsp),%esi
  70523d:	89 75 34             	mov    %esi,0x34(%rbp)
  705240:	8b 74 24 41          	mov    0x41(%rsp),%esi
  705244:	89 75 31             	mov    %esi,0x31(%rbp)
  705247:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70524c:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  705251:	48 89 45 00          	mov    %rax,0x0(%rbp)
  705255:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  705259:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70525d:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  705261:	88 55 30             	mov    %dl,0x30(%rbp)
  705264:	e9 64 fd ff ff       	jmp    704fcd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  705269:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  705270:	00 
  705271:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  705278:	00 
  705279:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  705280:	00 
  705281:	0f 11 55 28          	movups %xmm2,0x28(%rbp)
  705285:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  705289:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70528d:	48 89 45 00          	mov    %rax,0x0(%rbp)
  705291:	e9 37 fd ff ff       	jmp    704fcd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  705296:	48 83 3c 24 00       	cmpq   $0x0,(%rsp)
  70529b:	0f 84 74 ff ff ff    	je     705215 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x4a5>
  7052a1:	0f 28 84 24 e0 00 00 	movaps 0xe0(%rsp),%xmm0
  7052a8:	00 
  7052a9:	0f 28 8c 24 f0 00 00 	movaps 0xf0(%rsp),%xmm1
  7052b0:	00 
  7052b1:	0f 28 94 24 00 01 00 	movaps 0x100(%rsp),%xmm2
  7052b8:	00 
  7052b9:	0f 11 57 28          	movups %xmm2,0x28(%rdi)
  7052bd:	0f 11 4f 18          	movups %xmm1,0x18(%rdi)
  7052c1:	0f 11 47 08          	movups %xmm0,0x8(%rdi)
  7052c5:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  7052cc:	e9 fc fc ff ff       	jmp    704fcd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  7052d1:	48 c7 45 00 1f 00 00 	movq   $0x1f,0x0(%rbp)
  7052d8:	00 
  7052d9:	e9 ef fc ff ff       	jmp    704fcd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  7052de:	48 8d 15 03 5d 3f 00 	lea    0x3f5d03(%rip),%rdx        # afafe8 <__frame_dummy_init_array_entry+0x750>
  7052e5:	4c 89 e7             	mov    %r12,%rdi
  7052e8:	ff 15 6a 41 42 00    	call   *0x42416a(%rip)        # b29458 <_DYNAMIC+0x358>
  7052ee:	48 8d 15 0b 5d 3f 00 	lea    0x3f5d0b(%rip),%rdx        # afb000 <__frame_dummy_init_array_entry+0x768>
  7052f5:	4c 89 e7             	mov    %r12,%rdi
  7052f8:	ff 15 5a 41 42 00    	call   *0x42415a(%rip)        # b29458 <_DYNAMIC+0x358>
