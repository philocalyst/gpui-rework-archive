
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070fcb0 <<gpui::runtime::Win<unit_action_cost::Model>>::click>:
  70fcb0:	55                   	push   %rbp
  70fcb1:	41 57                	push   %r15
  70fcb3:	41 56                	push   %r14
  70fcb5:	41 55                	push   %r13
  70fcb7:	41 54                	push   %r12
  70fcb9:	53                   	push   %rbx
  70fcba:	48 81 ec b8 00 00 00 	sub    $0xb8,%rsp
  70fcc1:	48 8b 1e             	mov    (%rsi),%rbx
  70fcc4:	48 85 db             	test   %rbx,%rbx
  70fcc7:	74 15                	je     70fcde <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x2e>
  70fcc9:	80 bb 22 07 00 00 01 	cmpb   $0x1,0x722(%rbx)
  70fcd0:	75 20                	jne    70fcf2 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x42>
  70fcd2:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70fcd9:	e9 03 03 00 00       	jmp    70ffe1 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x331>
  70fcde:	48 c7 07 0d 00 00 00 	movq   $0xd,(%rdi)
  70fce5:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  70fcec:	00 
  70fced:	e9 ef 02 00 00       	jmp    70ffe1 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x331>
  70fcf2:	48 3b 93 b0 05 00 00 	cmp    0x5b0(%rbx),%rdx
  70fcf9:	0f 85 7e 02 00 00    	jne    70ff7d <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x2cd>
  70fcff:	49 89 f4             	mov    %rsi,%r12
  70fd02:	49 89 d6             	mov    %rdx,%r14
  70fd05:	48 89 fd             	mov    %rdi,%rbp
  70fd08:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70fd0d:	48 89 de             	mov    %rbx,%rsi
  70fd10:	49 89 cf             	mov    %rcx,%r15
  70fd13:	48 89 ca             	mov    %rcx,%rdx
  70fd16:	e8 f5 df 00 00       	call   71dd10 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  70fd1b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70fd20:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70fd24:	0f 85 5a 02 00 00    	jne    70ff84 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x2d4>
  70fd2a:	80 bb 1e 07 00 00 01 	cmpb   $0x1,0x71e(%rbx)
  70fd31:	48 89 ef             	mov    %rbp,%rdi
  70fd34:	0f 85 a0 02 00 00    	jne    70ffda <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fd3a:	80 bb 1f 07 00 00 00 	cmpb   $0x0,0x71f(%rbx)
  70fd41:	0f 85 93 02 00 00    	jne    70ffda <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fd47:	80 bb 20 07 00 00 00 	cmpb   $0x0,0x720(%rbx)
  70fd4e:	0f 84 86 02 00 00    	je     70ffda <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fd54:	48 83 bb 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rbx)
  70fd5b:	ff 
  70fd5c:	0f 85 78 02 00 00    	jne    70ffda <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fd62:	48 8b 83 60 06 00 00 	mov    0x660(%rbx),%rax
  70fd69:	48 3b 83 68 06 00 00 	cmp    0x668(%rbx),%rax
  70fd70:	0f 85 64 02 00 00    	jne    70ffda <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fd76:	48 8b 83 78 06 00 00 	mov    0x678(%rbx),%rax
  70fd7d:	48 3b 83 70 06 00 00 	cmp    0x670(%rbx),%rax
  70fd84:	0f 85 50 02 00 00    	jne    70ffda <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fd8a:	f3 0f 10 83 14 07 00 	movss  0x714(%rbx),%xmm0
  70fd91:	00 
  70fd92:	0f 2e 83 18 07 00 00 	ucomiss 0x718(%rbx),%xmm0
  70fd99:	0f 85 3b 02 00 00    	jne    70ffda <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fd9f:	0f 8a 35 02 00 00    	jp     70ffda <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fda5:	4c 89 e0             	mov    %r12,%rax
  70fda8:	48 83 c0 08          	add    $0x8,%rax
  70fdac:	4c 8b ab 78 05 00 00 	mov    0x578(%rbx),%r13
  70fdb3:	48 8b 8b 80 05 00 00 	mov    0x580(%rbx),%rcx
  70fdba:	48 c1 e1 04          	shl    $0x4,%rcx
  70fdbe:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  70fdc2:	45 31 e4             	xor    %r12d,%r12d
  70fdc5:	4c 89 ee             	mov    %r13,%rsi
  70fdc8:	4c 89 fa             	mov    %r15,%rdx
  70fdcb:	4c 39 e1             	cmp    %r12,%rcx
  70fdce:	0f 84 22 02 00 00    	je     70fff6 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x346>
  70fdd4:	49 83 c4 50          	add    $0x50,%r12
  70fdd8:	48 39 56 20          	cmp    %rdx,0x20(%rsi)
  70fddc:	48 8d 76 50          	lea    0x50(%rsi),%rsi
  70fde0:	75 e9                	jne    70fdcb <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x11b>
  70fde2:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  70fde7:	48 c7 44 24 08 11 00 	movq   $0x11,0x8(%rsp)
  70fdee:	00 00 
  70fdf0:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70fdf5:	e8 d6 48 ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70fdfa:	f3 43 0f 10 44 25 e0 	movss  -0x20(%r13,%r12,1),%xmm0
  70fe01:	0f 2e c0             	ucomiss %xmm0,%xmm0
  70fe04:	7a 62                	jp     70fe68 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1b8>
  70fe06:	43 8b 44 25 f4       	mov    -0xc(%r13,%r12,1),%eax
  70fe0b:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  70fe0f:	43 0f 10 4c 25 e4    	movups -0x1c(%r13,%r12,1),%xmm1
  70fe15:	0f 11 4c 24 0c       	movups %xmm1,0xc(%rsp)
  70fe1a:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70fe20:	f3 43 0f 10 44 25 b8 	movss  -0x48(%r13,%r12,1),%xmm0
  70fe27:	f3 43 0f 10 4c 25 bc 	movss  -0x44(%r13,%r12,1),%xmm1
  70fe2e:	48 8d 7c 24 64       	lea    0x64(%rsp),%rdi
  70fe33:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
  70fe38:	e8 a3 6b ff ff       	call   7069e0 <<gpui::runtime::Win<unit_action_cost::Model>>::click::{closure#1}>
  70fe3d:	83 7c 24 64 01       	cmpl   $0x1,0x64(%rsp)
  70fe42:	75 24                	jne    70fe68 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1b8>
  70fe44:	f2 0f 10 44 24 68    	movsd  0x68(%rsp),%xmm0
  70fe4a:	0f 28 c8             	movaps %xmm0,%xmm1
  70fe4d:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70fe51:	4b 8d 3c 2c          	lea    (%r12,%r13,1),%rdi
  70fe55:	48 83 c7 c0          	add    $0xffffffffffffffc0,%rdi
  70fe59:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  70fe5e:	ff 15 34 24 3f 00    	call   *0x3f2434(%rip)        # b02298 <_DYNAMIC+0x550>
  70fe64:	84 c0                	test   %al,%al
  70fe66:	75 40                	jne    70fea8 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1f8>
  70fe68:	f3 43 0f 10 44 25 c8 	movss  -0x38(%r13,%r12,1),%xmm0
  70fe6f:	0f 57 d2             	xorps  %xmm2,%xmm2
  70fe72:	0f 2e c2             	ucomiss %xmm2,%xmm0
  70fe75:	75 06                	jne    70fe7d <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1cd>
  70fe77:	0f 8b 82 01 00 00    	jnp    70ffff <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x34f>
  70fe7d:	f3 43 0f 10 4c 25 cc 	movss  -0x34(%r13,%r12,1),%xmm1
  70fe84:	0f 2e ca             	ucomiss %xmm2,%xmm1
  70fe87:	75 06                	jne    70fe8f <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1df>
  70fe89:	0f 8b 70 01 00 00    	jnp    70ffff <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x34f>
  70fe8f:	0f 14 c1             	unpcklps %xmm1,%xmm0
  70fe92:	0f 59 05 b7 60 95 ff 	mulps  -0x6a9f49(%rip),%xmm0        # 65f50 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1110>
  70fe99:	f2 43 0f 10 4c 25 c0 	movsd  -0x40(%r13,%r12,1),%xmm1
  70fea0:	0f 58 c8             	addps  %xmm0,%xmm1
  70fea3:	0f 29 4c 24 40       	movaps %xmm1,0x40(%rsp)
  70fea8:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70feaf:	00 00 
  70feb1:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70feb6:	e8 15 48 ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70febb:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70fec0:	0f 28 c8             	movaps %xmm0,%xmm1
  70fec3:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70fec7:	48 89 df             	mov    %rbx,%rdi
  70feca:	0f 29 8c 24 a0 00 00 	movaps %xmm1,0xa0(%rsp)
  70fed1:	00 
  70fed2:	e8 f9 e0 00 00       	call   71dfd0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::hit>
  70fed7:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70fede:	00 00 
  70fee0:	a8 01                	test   $0x1,%al
  70fee2:	0f 84 17 01 00 00    	je     70ffff <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x34f>
  70fee8:	49 89 d5             	mov    %rdx,%r13
  70feeb:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70fef0:	e8 db 47 ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70fef5:	4d 39 fd             	cmp    %r15,%r13
  70fef8:	0f 85 01 01 00 00    	jne    70ffff <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x34f>
  70fefe:	4c 3b b3 b0 05 00 00 	cmp    0x5b0(%rbx),%r14
  70ff05:	0f 85 01 01 00 00    	jne    71000c <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x35c>
  70ff0b:	4c 89 fa             	mov    %r15,%rdx
  70ff0e:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70ff13:	48 89 de             	mov    %rbx,%rsi
  70ff16:	e8 f5 dd 00 00       	call   71dd10 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  70ff1b:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  70ff20:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70ff25:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  70ff29:	0f 85 e2 00 00 00    	jne    710011 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x361>
  70ff2f:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  70ff36:	48 39 f0             	cmp    %rsi,%rax
  70ff39:	0f 83 88 01 00 00    	jae    7100c7 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x417>
  70ff3f:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  70ff46:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  70ff4a:	8b 44 c1 20          	mov    0x20(%rcx,%rax,8),%eax
  70ff4e:	83 e0 07             	and    $0x7,%eax
  70ff51:	83 f8 02             	cmp    $0x2,%eax
  70ff54:	0f 85 df 00 00 00    	jne    710039 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x389>
  70ff5a:	48 89 ef             	mov    %rbp,%rdi
  70ff5d:	48 89 de             	mov    %rbx,%rsi
  70ff60:	4c 89 f2             	mov    %r14,%rdx
  70ff63:	4c 89 f9             	mov    %r15,%rcx
  70ff66:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70ff6b:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  70ff72:	00 
  70ff73:	e8 68 c4 ff ff       	call   70c3e0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer>
  70ff78:	e9 05 01 00 00       	jmp    710082 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x3d2>
  70ff7d:	b8 11 00 00 00       	mov    $0x11,%eax
  70ff82:	eb 2c                	jmp    70ffb0 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x300>
  70ff84:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  70ff89:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70ff8e:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  70ff93:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70ff98:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  70ff9f:	00 
  70ffa0:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70ffa5:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  70ffac:	00 
  70ffad:	48 89 ef             	mov    %rbp,%rdi
  70ffb0:	48 89 07             	mov    %rax,(%rdi)
  70ffb3:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  70ffb7:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  70ffbc:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
  70ffc3:	00 
  70ffc4:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  70ffc8:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  70ffcc:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  70ffd3:	00 
  70ffd4:	48 89 47 30          	mov    %rax,0x30(%rdi)
  70ffd8:	eb 07                	jmp    70ffe1 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x331>
  70ffda:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  70ffe1:	48 89 f8             	mov    %rdi,%rax
  70ffe4:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
  70ffeb:	5b                   	pop    %rbx
  70ffec:	41 5c                	pop    %r12
  70ffee:	41 5d                	pop    %r13
  70fff0:	41 5e                	pop    %r14
  70fff2:	41 5f                	pop    %r15
  70fff4:	5d                   	pop    %rbp
  70fff5:	c3                   	ret
  70fff6:	48 c7 07 11 00 00 00 	movq   $0x11,(%rdi)
  70fffd:	eb e2                	jmp    70ffe1 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x331>
  70ffff:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  710006:	00 
  710007:	48 89 e8             	mov    %rbp,%rax
  71000a:	eb d8                	jmp    70ffe4 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x334>
  71000c:	b9 11 00 00 00       	mov    $0x11,%ecx
  710011:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  710016:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  71001a:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  71001f:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  710024:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  710028:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  71002c:	48 89 4d 00          	mov    %rcx,0x0(%rbp)
  710030:	48 89 45 08          	mov    %rax,0x8(%rbp)
  710034:	48 89 e8             	mov    %rbp,%rax
  710037:	eb ab                	jmp    70ffe4 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x334>
  710039:	4c 8b ab e8 05 00 00 	mov    0x5e8(%rbx),%r13
  710040:	4c 8b a3 f0 05 00 00 	mov    0x5f0(%rbx),%r12
  710047:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  71004c:	48 89 de             	mov    %rbx,%rsi
  71004f:	4c 89 f2             	mov    %r14,%rdx
  710052:	4c 89 f9             	mov    %r15,%rcx
  710055:	e8 56 a4 ff ff       	call   70a4b0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::focus>
  71005a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  71005f:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  710063:	75 25                	jne    71008a <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x3da>
  710065:	4c 89 24 24          	mov    %r12,(%rsp)
  710069:	48 89 ef             	mov    %rbp,%rdi
  71006c:	48 89 de             	mov    %rbx,%rsi
  71006f:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  710074:	4c 89 f1             	mov    %r14,%rcx
  710077:	4d 89 f8             	mov    %r15,%r8
  71007a:	4d 89 e9             	mov    %r13,%r9
  71007d:	e8 1e 72 ff ff       	call   7072a0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused>
  710082:	48 89 e8             	mov    %rbp,%rax
  710085:	e9 5a ff ff ff       	jmp    70ffe4 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x334>
  71008a:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  71008f:	0f b6 54 24 38       	movzbl 0x38(%rsp),%edx
  710094:	8b 74 24 3c          	mov    0x3c(%rsp),%esi
  710098:	89 75 34             	mov    %esi,0x34(%rbp)
  71009b:	8b 74 24 39          	mov    0x39(%rsp),%esi
  71009f:	89 75 31             	mov    %esi,0x31(%rbp)
  7100a2:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  7100a7:	0f 10 4c 24 20       	movups 0x20(%rsp),%xmm1
  7100ac:	48 89 45 00          	mov    %rax,0x0(%rbp)
  7100b0:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  7100b4:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  7100b8:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  7100bc:	88 55 30             	mov    %dl,0x30(%rbp)
  7100bf:	48 89 e8             	mov    %rbp,%rax
  7100c2:	e9 1d ff ff ff       	jmp    70ffe4 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x334>
  7100c7:	48 8d 15 82 41 3c 00 	lea    0x3c4182(%rip),%rdx        # ad4250 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xa68>
  7100ce:	48 89 c7             	mov    %rax,%rdi
  7100d1:	ff 15 e9 1f 3f 00    	call   *0x3f1fe9(%rip)        # b020c0 <_DYNAMIC+0x378>
