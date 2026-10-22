
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000704de0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer>:
  704de0:	55                   	push   %rbp
  704de1:	41 57                	push   %r15
  704de3:	41 56                	push   %r14
  704de5:	41 55                	push   %r13
  704de7:	41 54                	push   %r12
  704de9:	53                   	push   %rbx
  704dea:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
  704df1:	80 be 22 08 00 00 01 	cmpb   $0x1,0x822(%rsi)
  704df8:	75 0c                	jne    704e06 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x26>
  704dfa:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  704e01:	e9 37 02 00 00       	jmp    70503d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  704e06:	80 be 1e 08 00 00 01 	cmpb   $0x1,0x81e(%rsi)
  704e0d:	0f 85 23 02 00 00    	jne    705036 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704e13:	80 be 1f 08 00 00 00 	cmpb   $0x0,0x81f(%rsi)
  704e1a:	0f 85 16 02 00 00    	jne    705036 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704e20:	80 be 20 08 00 00 00 	cmpb   $0x0,0x820(%rsi)
  704e27:	0f 84 09 02 00 00    	je     705036 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704e2d:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  704e34:	ff 
  704e35:	0f 85 fb 01 00 00    	jne    705036 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704e3b:	48 8b 86 60 06 00 00 	mov    0x660(%rsi),%rax
  704e42:	48 3b 86 68 06 00 00 	cmp    0x668(%rsi),%rax
  704e49:	0f 85 e7 01 00 00    	jne    705036 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704e4f:	48 8b 86 78 06 00 00 	mov    0x678(%rsi),%rax
  704e56:	48 3b 86 70 06 00 00 	cmp    0x670(%rsi),%rax
  704e5d:	0f 85 d3 01 00 00    	jne    705036 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704e63:	f3 0f 10 96 14 08 00 	movss  0x814(%rsi),%xmm2
  704e6a:	00 
  704e6b:	0f 2e 96 18 08 00 00 	ucomiss 0x818(%rsi),%xmm2
  704e72:	0f 85 be 01 00 00    	jne    705036 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704e78:	0f 8a b8 01 00 00    	jp     705036 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x256>
  704e7e:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  704e84:	f3 0f 11 0c 24       	movss  %xmm1,(%rsp)
  704e89:	48 89 fd             	mov    %rdi,%rbp
  704e8c:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  704e91:	48 89 f3             	mov    %rsi,%rbx
  704e94:	49 89 d7             	mov    %rdx,%r15
  704e97:	49 89 ce             	mov    %rcx,%r14
  704e9a:	e8 91 c6 ff ff       	call   701530 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::input_index>
  704e9f:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  704ea4:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  704ea9:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  704ead:	0f 85 9c 01 00 00    	jne    70504f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x26f>
  704eb3:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  704eba:	49 39 f4             	cmp    %rsi,%r12
  704ebd:	0f 83 8b 04 00 00    	jae    70534e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x56e>
  704ec3:	48 89 e8             	mov    %rbp,%rax
  704ec6:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  704ecd:	4b 8d 34 a4          	lea    (%r12,%r12,4),%rsi
  704ed1:	48 8b 34 f1          	mov    (%rcx,%rsi,8),%rsi
  704ed5:	48 8b 8b 78 05 00 00 	mov    0x578(%rbx),%rcx
  704edc:	48 8b 93 80 05 00 00 	mov    0x580(%rbx),%rdx
  704ee3:	48 c1 e2 04          	shl    $0x4,%rdx
  704ee7:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  704eeb:	31 d2                	xor    %edx,%edx
  704eed:	49 89 c8             	mov    %rcx,%r8
  704ef0:	48 39 d7             	cmp    %rdx,%rdi
  704ef3:	0f 84 7b 01 00 00    	je     705074 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x294>
  704ef9:	48 83 c2 50          	add    $0x50,%rdx
  704efd:	49 39 70 20          	cmp    %rsi,0x20(%r8)
  704f01:	4d 8d 40 50          	lea    0x50(%r8),%r8
  704f05:	75 e9                	jne    704ef0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x110>
  704f07:	f3 0f 10 44 11 e0    	movss  -0x20(%rcx,%rdx,1),%xmm0
  704f0d:	0f 2e c0             	ucomiss %xmm0,%xmm0
  704f10:	0f 8a 5e 01 00 00    	jp     705074 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x294>
  704f16:	f3 0f 10 4c 11 e4    	movss  -0x1c(%rcx,%rdx,1),%xmm1
  704f1c:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  704f23:	00 00 
  704f25:	0f 14 c1             	unpcklps %xmm1,%xmm0
  704f28:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  704f2b:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  704f32:	00 
  704f33:	0f 5a 44 11 e8       	cvtps2pd -0x18(%rcx,%rdx,1),%xmm0
  704f38:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  704f3d:	0f 5a 44 11 f0       	cvtps2pd -0x10(%rcx,%rdx,1),%xmm0
  704f42:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  704f49:	00 
  704f4a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  704f4f:	e8 9c 30 ff ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  704f54:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  704f5b:	00 
  704f5c:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  704f61:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  704f66:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  704f6b:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
  704f72:	00 
  704f73:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  704f78:	c6 44 24 40 00       	movb   $0x0,0x40(%rsp)
  704f7d:	48 8d bc 24 90 00 00 	lea    0x90(%rsp),%rdi
  704f84:	00 
  704f85:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  704f8a:	f3 0f 10 44 24 08    	movss  0x8(%rsp),%xmm0
  704f90:	f3 0f 10 0c 24       	movss  (%rsp),%xmm1
  704f95:	ff 15 7d 46 42 00    	call   *0x42467d(%rip)        # b29618 <_DYNAMIC+0x4a8>
  704f9b:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  704fa2:	00 00 
  704fa4:	83 bc 24 90 00 00 00 	cmpl   $0x1,0x90(%rsp)
  704fab:	01 
  704fac:	0f 85 34 01 00 00    	jne    7050e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x306>
  704fb2:	f3 0f 10 84 24 94 00 	movss  0x94(%rsp),%xmm0
  704fb9:	00 00 
  704fbb:	f3 0f 11 04 24       	movss  %xmm0,(%rsp)
  704fc0:	f3 0f 10 84 24 98 00 	movss  0x98(%rsp),%xmm0
  704fc7:	00 00 
  704fc9:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  704fcf:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  704fd4:	e8 17 30 ff ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  704fd9:	48 8b b3 68 05 00 00 	mov    0x568(%rbx),%rsi
  704fe0:	49 39 f4             	cmp    %rsi,%r12
  704fe3:	0f 83 75 03 00 00    	jae    70535e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x57e>
  704fe9:	48 8b 8b 60 05 00 00 	mov    0x560(%rbx),%rcx
  704ff0:	48 8d b3 c0 02 00 00 	lea    0x2c0(%rbx),%rsi
  704ff7:	4c 89 e0             	mov    %r12,%rax
  704ffa:	48 c1 e0 04          	shl    $0x4,%rax
  704ffe:	0f 10 04 01          	movups (%rcx,%rax,1),%xmm0
  705002:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  705009:	00 
  70500a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70500f:	48 8d 94 24 90 00 00 	lea    0x90(%rsp),%rdx
  705016:	00 
  705017:	ff 15 db 45 42 00    	call   *0x4245db(%rip)        # b295f8 <_DYNAMIC+0x488>
  70501d:	80 7c 24 10 00       	cmpb   $0x0,0x10(%rsp)
  705022:	74 59                	je     70507d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x29d>
  705024:	0f b6 44 24 11       	movzbl 0x11(%rsp),%eax
  705029:	48 c7 45 00 22 00 00 	movq   $0x22,0x0(%rbp)
  705030:	00 
  705031:	88 45 08             	mov    %al,0x8(%rbp)
  705034:	eb 07                	jmp    70503d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  705036:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  70503d:	48 81 c4 18 01 00 00 	add    $0x118,%rsp
  705044:	5b                   	pop    %rbx
  705045:	41 5c                	pop    %r12
  705047:	41 5d                	pop    %r13
  705049:	41 5e                	pop    %r14
  70504b:	41 5f                	pop    %r15
  70504d:	5d                   	pop    %rbp
  70504e:	c3                   	ret
  70504f:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  705054:	48 89 4d 30          	mov    %rcx,0x30(%rbp)
  705058:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  70505d:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  705062:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  705066:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70506a:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70506e:	4c 89 65 08          	mov    %r12,0x8(%rbp)
  705072:	eb c9                	jmp    70503d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  705074:	48 c7 00 19 00 00 00 	movq   $0x19,(%rax)
  70507b:	eb c0                	jmp    70503d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  70507d:	f3 0f 10 44 24 34    	movss  0x34(%rsp),%xmm0
  705083:	f3 0f 11 84 24 80 00 	movss  %xmm0,0x80(%rsp)
  70508a:	00 00 
  70508c:	f3 0f 10 44 24 3c    	movss  0x3c(%rsp),%xmm0
  705092:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  705098:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70509d:	48 89 de             	mov    %rbx,%rsi
  7050a0:	4c 89 e2             	mov    %r12,%rdx
  7050a3:	e8 f8 cf ff ff       	call   7020a0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::interaction_layout>
  7050a8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7050ad:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  7050b1:	75 40                	jne    7050f3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x313>
  7050b3:	f3 0f 10 4c 24 08    	movss  0x8(%rsp),%xmm1
  7050b9:	f3 0f 5c 4c 24 70    	subss  0x70(%rsp),%xmm1
  7050bf:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
  7050c4:	f3 0f 5c 84 24 80 00 	subss  0x80(%rsp),%xmm0
  7050cb:	00 00 
  7050cd:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  7050d2:	ff 15 48 45 42 00    	call   *0x424548(%rip)        # b29620 <_DYNAMIC+0x4b0>
  7050d8:	48 c7 44 24 10 19 00 	movq   $0x19,0x10(%rsp)
  7050df:	00 00 
  7050e1:	80 fa 02             	cmp    $0x2,%dl
  7050e4:	75 3a                	jne    705120 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x340>
  7050e6:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  7050ed:	00 
  7050ee:	e9 4a ff ff ff       	jmp    70503d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  7050f3:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  7050f8:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  7050fd:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  705101:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  705106:	0f 11 45 20          	movups %xmm0,0x20(%rbp)
  70510a:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  70510f:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  705113:	48 89 45 00          	mov    %rax,0x0(%rbp)
  705117:	48 89 4d 08          	mov    %rcx,0x8(%rbp)
  70511b:	e9 1d ff ff ff       	jmp    70503d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  705120:	41 89 d5             	mov    %edx,%r13d
  705123:	41 89 c4             	mov    %eax,%r12d
  705126:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70512b:	e8 c0 2e ff ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  705130:	48 83 bb 60 06 00 00 	cmpq   $0xffffffffffffffff,0x660(%rbx)
  705137:	ff 
  705138:	0f 84 03 02 00 00    	je     705341 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x561>
  70513e:	48 c7 44 24 10 1f 00 	movq   $0x1f,0x10(%rsp)
  705145:	00 00 
  705147:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70514c:	e8 9f 2e ff ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  705151:	48 89 de             	mov    %rbx,%rsi
  705154:	48 8b 83 e8 05 00 00 	mov    0x5e8(%rbx),%rax
  70515b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  705160:	48 8b 83 f0 05 00 00 	mov    0x5f0(%rbx),%rax
  705167:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  70516e:	00 
  70516f:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  705176:	48 89 04 24          	mov    %rax,(%rsp)
  70517a:	48 8b 83 88 06 00 00 	mov    0x688(%rbx),%rax
  705181:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  705186:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70518b:	4c 89 fa             	mov    %r15,%rdx
  70518e:	4c 89 f1             	mov    %r14,%rcx
  705191:	e8 2a bf ff ff       	call   7010c0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::focus>
  705196:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70519b:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70519f:	0f 85 fa 00 00 00    	jne    70529f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x4bf>
  7051a5:	41 80 e5 01          	and    $0x1,%r13b
  7051a9:	44 89 a4 24 c0 00 00 	mov    %r12d,0xc0(%rsp)
  7051b0:	00 
  7051b1:	44 88 ac 24 c4 00 00 	mov    %r13b,0xc4(%rsp)
  7051b8:	00 
  7051b9:	44 89 a4 24 c8 00 00 	mov    %r12d,0xc8(%rsp)
  7051c0:	00 
  7051c1:	44 88 ac 24 cc 00 00 	mov    %r13b,0xcc(%rsp)
  7051c8:	00 
  7051c9:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7051ce:	4c 8d 84 24 c0 00 00 	lea    0xc0(%rsp),%r8
  7051d5:	00 
  7051d6:	48 89 de             	mov    %rbx,%rsi
  7051d9:	4c 89 fa             	mov    %r15,%rdx
  7051dc:	4c 89 f1             	mov    %r14,%rcx
  7051df:	e8 fc f9 ff ff       	call   704be0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input>
  7051e4:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  7051e9:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  7051ee:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  7051f5:	00 
  7051f6:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  7051fb:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  705202:	00 
  705203:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  705208:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  70520f:	00 
  705210:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  705214:	0f 85 bf 00 00 00    	jne    7052d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x4f9>
  70521a:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  705221:	00 
  705222:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  705229:	00 
  70522a:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  705231:	00 
  705232:	0f 29 94 24 00 01 00 	movaps %xmm2,0x100(%rsp)
  705239:	00 
  70523a:	0f 29 8c 24 f0 00 00 	movaps %xmm1,0xf0(%rsp)
  705241:	00 
  705242:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  705249:	00 
  70524a:	48 8b 83 80 06 00 00 	mov    0x680(%rbx),%rax
  705251:	48 85 c0             	test   %rax,%rax
  705254:	48 89 ef             	mov    %rbp,%rdi
  705257:	0f 84 a9 00 00 00    	je     705306 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x526>
  70525d:	48 8b 0c 24          	mov    (%rsp),%rcx
  705261:	48 85 c9             	test   %rcx,%rcx
  705264:	0f 84 a7 00 00 00    	je     705311 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x531>
  70526a:	48 39 c8             	cmp    %rcx,%rax
  70526d:	0f 85 9e 00 00 00    	jne    705311 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x531>
  705273:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  705278:	48 39 83 88 06 00 00 	cmp    %rax,0x688(%rbx)
  70527f:	0f 85 8c 00 00 00    	jne    705311 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x531>
  705285:	48 89 de             	mov    %rbx,%rsi
  705288:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  70528d:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  705294:	00 
  705295:	e8 d6 00 00 00       	call   705370 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::publish_focus_change>
  70529a:	e9 9e fd ff ff       	jmp    70503d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  70529f:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  7052a4:	0f b6 54 24 40       	movzbl 0x40(%rsp),%edx
  7052a9:	8b 74 24 44          	mov    0x44(%rsp),%esi
  7052ad:	89 75 34             	mov    %esi,0x34(%rbp)
  7052b0:	8b 74 24 41          	mov    0x41(%rsp),%esi
  7052b4:	89 75 31             	mov    %esi,0x31(%rbp)
  7052b7:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  7052bc:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  7052c1:	48 89 45 00          	mov    %rax,0x0(%rbp)
  7052c5:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  7052c9:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  7052cd:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  7052d1:	88 55 30             	mov    %dl,0x30(%rbp)
  7052d4:	e9 64 fd ff ff       	jmp    70503d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  7052d9:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  7052e0:	00 
  7052e1:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  7052e8:	00 
  7052e9:	0f 28 94 24 b0 00 00 	movaps 0xb0(%rsp),%xmm2
  7052f0:	00 
  7052f1:	0f 11 55 28          	movups %xmm2,0x28(%rbp)
  7052f5:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  7052f9:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  7052fd:	48 89 45 00          	mov    %rax,0x0(%rbp)
  705301:	e9 37 fd ff ff       	jmp    70503d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  705306:	48 83 3c 24 00       	cmpq   $0x0,(%rsp)
  70530b:	0f 84 74 ff ff ff    	je     705285 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x4a5>
  705311:	0f 28 84 24 e0 00 00 	movaps 0xe0(%rsp),%xmm0
  705318:	00 
  705319:	0f 28 8c 24 f0 00 00 	movaps 0xf0(%rsp),%xmm1
  705320:	00 
  705321:	0f 28 94 24 00 01 00 	movaps 0x100(%rsp),%xmm2
  705328:	00 
  705329:	0f 11 57 28          	movups %xmm2,0x28(%rdi)
  70532d:	0f 11 4f 18          	movups %xmm1,0x18(%rdi)
  705331:	0f 11 47 08          	movups %xmm0,0x8(%rdi)
  705335:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  70533c:	e9 fc fc ff ff       	jmp    70503d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  705341:	48 c7 45 00 1f 00 00 	movq   $0x1f,0x0(%rbp)
  705348:	00 
  705349:	e9 ef fc ff ff       	jmp    70503d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer+0x25d>
  70534e:	48 8d 15 03 5d 3f 00 	lea    0x3f5d03(%rip),%rdx        # afb058 <__frame_dummy_init_array_entry+0x750>
  705355:	4c 89 e7             	mov    %r12,%rdi
  705358:	ff 15 6a 41 42 00    	call   *0x42416a(%rip)        # b294c8 <_DYNAMIC+0x358>
  70535e:	48 8d 15 0b 5d 3f 00 	lea    0x3f5d0b(%rip),%rdx        # afb070 <__frame_dummy_init_array_entry+0x768>
  705365:	4c 89 e7             	mov    %r12,%rdi
  705368:	ff 15 5a 41 42 00    	call   *0x42415a(%rip)        # b294c8 <_DYNAMIC+0x358>
