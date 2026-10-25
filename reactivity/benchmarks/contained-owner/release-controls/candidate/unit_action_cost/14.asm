
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070fdc0 <<gpui::runtime::Win<unit_action_cost::Model>>::click>:
  70fdc0:	55                   	push   %rbp
  70fdc1:	41 57                	push   %r15
  70fdc3:	41 56                	push   %r14
  70fdc5:	41 55                	push   %r13
  70fdc7:	41 54                	push   %r12
  70fdc9:	53                   	push   %rbx
  70fdca:	48 81 ec b8 00 00 00 	sub    $0xb8,%rsp
  70fdd1:	48 8b 1e             	mov    (%rsi),%rbx
  70fdd4:	48 85 db             	test   %rbx,%rbx
  70fdd7:	74 15                	je     70fdee <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x2e>
  70fdd9:	80 bb 22 07 00 00 01 	cmpb   $0x1,0x722(%rbx)
  70fde0:	75 20                	jne    70fe02 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x42>
  70fde2:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70fde9:	e9 03 03 00 00       	jmp    7100f1 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x331>
  70fdee:	48 c7 07 0d 00 00 00 	movq   $0xd,(%rdi)
  70fdf5:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  70fdfc:	00 
  70fdfd:	e9 ef 02 00 00       	jmp    7100f1 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x331>
  70fe02:	48 3b 93 b0 05 00 00 	cmp    0x5b0(%rbx),%rdx
  70fe09:	0f 85 7e 02 00 00    	jne    71008d <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x2cd>
  70fe0f:	49 89 f4             	mov    %rsi,%r12
  70fe12:	49 89 d6             	mov    %rdx,%r14
  70fe15:	48 89 fd             	mov    %rdi,%rbp
  70fe18:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70fe1d:	48 89 de             	mov    %rbx,%rsi
  70fe20:	49 89 cf             	mov    %rcx,%r15
  70fe23:	48 89 ca             	mov    %rcx,%rdx
  70fe26:	e8 f5 df 00 00       	call   71de20 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  70fe2b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70fe30:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70fe34:	0f 85 5a 02 00 00    	jne    710094 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x2d4>
  70fe3a:	80 bb 1e 07 00 00 01 	cmpb   $0x1,0x71e(%rbx)
  70fe41:	48 89 ef             	mov    %rbp,%rdi
  70fe44:	0f 85 a0 02 00 00    	jne    7100ea <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fe4a:	80 bb 1f 07 00 00 00 	cmpb   $0x0,0x71f(%rbx)
  70fe51:	0f 85 93 02 00 00    	jne    7100ea <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fe57:	80 bb 20 07 00 00 00 	cmpb   $0x0,0x720(%rbx)
  70fe5e:	0f 84 86 02 00 00    	je     7100ea <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fe64:	48 83 bb 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rbx)
  70fe6b:	ff 
  70fe6c:	0f 85 78 02 00 00    	jne    7100ea <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fe72:	48 8b 83 60 06 00 00 	mov    0x660(%rbx),%rax
  70fe79:	48 3b 83 68 06 00 00 	cmp    0x668(%rbx),%rax
  70fe80:	0f 85 64 02 00 00    	jne    7100ea <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fe86:	48 8b 83 78 06 00 00 	mov    0x678(%rbx),%rax
  70fe8d:	48 3b 83 70 06 00 00 	cmp    0x670(%rbx),%rax
  70fe94:	0f 85 50 02 00 00    	jne    7100ea <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fe9a:	f3 0f 10 83 14 07 00 	movss  0x714(%rbx),%xmm0
  70fea1:	00 
  70fea2:	0f 2e 83 18 07 00 00 	ucomiss 0x718(%rbx),%xmm0
  70fea9:	0f 85 3b 02 00 00    	jne    7100ea <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70feaf:	0f 8a 35 02 00 00    	jp     7100ea <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70feb5:	4c 89 e0             	mov    %r12,%rax
  70feb8:	48 83 c0 08          	add    $0x8,%rax
  70febc:	4c 8b ab 78 05 00 00 	mov    0x578(%rbx),%r13
  70fec3:	48 8b 8b 80 05 00 00 	mov    0x580(%rbx),%rcx
  70feca:	48 c1 e1 04          	shl    $0x4,%rcx
  70fece:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  70fed2:	45 31 e4             	xor    %r12d,%r12d
  70fed5:	4c 89 ee             	mov    %r13,%rsi
  70fed8:	4c 89 fa             	mov    %r15,%rdx
  70fedb:	4c 39 e1             	cmp    %r12,%rcx
  70fede:	0f 84 22 02 00 00    	je     710106 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x346>
  70fee4:	49 83 c4 50          	add    $0x50,%r12
  70fee8:	48 39 56 20          	cmp    %rdx,0x20(%rsi)
  70feec:	48 8d 76 50          	lea    0x50(%rsi),%rsi
  70fef0:	75 e9                	jne    70fedb <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x11b>
  70fef2:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  70fef7:	48 c7 44 24 08 11 00 	movq   $0x11,0x8(%rsp)
  70fefe:	00 00 
  70ff00:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70ff05:	e8 d6 48 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70ff0a:	f3 43 0f 10 44 25 e0 	movss  -0x20(%r13,%r12,1),%xmm0
  70ff11:	0f 2e c0             	ucomiss %xmm0,%xmm0
  70ff14:	7a 62                	jp     70ff78 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1b8>
  70ff16:	43 8b 44 25 f4       	mov    -0xc(%r13,%r12,1),%eax
  70ff1b:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  70ff1f:	43 0f 10 4c 25 e4    	movups -0x1c(%r13,%r12,1),%xmm1
  70ff25:	0f 11 4c 24 0c       	movups %xmm1,0xc(%rsp)
  70ff2a:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70ff30:	f3 43 0f 10 44 25 b8 	movss  -0x48(%r13,%r12,1),%xmm0
  70ff37:	f3 43 0f 10 4c 25 bc 	movss  -0x44(%r13,%r12,1),%xmm1
  70ff3e:	48 8d 7c 24 64       	lea    0x64(%rsp),%rdi
  70ff43:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
  70ff48:	e8 a3 6b ff ff       	call   706af0 <<gpui::runtime::Win<unit_action_cost::Model>>::click::{closure#1}>
  70ff4d:	83 7c 24 64 01       	cmpl   $0x1,0x64(%rsp)
  70ff52:	75 24                	jne    70ff78 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1b8>
  70ff54:	f2 0f 10 44 24 68    	movsd  0x68(%rsp),%xmm0
  70ff5a:	0f 28 c8             	movaps %xmm0,%xmm1
  70ff5d:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70ff61:	4b 8d 3c 2c          	lea    (%r12,%r13,1),%rdi
  70ff65:	48 83 c7 c0          	add    $0xffffffffffffffc0,%rdi
  70ff69:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  70ff6e:	ff 15 24 24 3f 00    	call   *0x3f2424(%rip)        # b02398 <_DYNAMIC+0x550>
  70ff74:	84 c0                	test   %al,%al
  70ff76:	75 40                	jne    70ffb8 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1f8>
  70ff78:	f3 43 0f 10 44 25 c8 	movss  -0x38(%r13,%r12,1),%xmm0
  70ff7f:	0f 57 d2             	xorps  %xmm2,%xmm2
  70ff82:	0f 2e c2             	ucomiss %xmm2,%xmm0
  70ff85:	75 06                	jne    70ff8d <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1cd>
  70ff87:	0f 8b 82 01 00 00    	jnp    71010f <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x34f>
  70ff8d:	f3 43 0f 10 4c 25 cc 	movss  -0x34(%r13,%r12,1),%xmm1
  70ff94:	0f 2e ca             	ucomiss %xmm2,%xmm1
  70ff97:	75 06                	jne    70ff9f <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1df>
  70ff99:	0f 8b 70 01 00 00    	jnp    71010f <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x34f>
  70ff9f:	0f 14 c1             	unpcklps %xmm1,%xmm0
  70ffa2:	0f 59 05 07 60 95 ff 	mulps  -0x6a9ff9(%rip),%xmm0        # 65fb0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1110>
  70ffa9:	f2 43 0f 10 4c 25 c0 	movsd  -0x40(%r13,%r12,1),%xmm1
  70ffb0:	0f 58 c8             	addps  %xmm0,%xmm1
  70ffb3:	0f 29 4c 24 40       	movaps %xmm1,0x40(%rsp)
  70ffb8:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70ffbf:	00 00 
  70ffc1:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70ffc6:	e8 15 48 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70ffcb:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70ffd0:	0f 28 c8             	movaps %xmm0,%xmm1
  70ffd3:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70ffd7:	48 89 df             	mov    %rbx,%rdi
  70ffda:	0f 29 8c 24 a0 00 00 	movaps %xmm1,0xa0(%rsp)
  70ffe1:	00 
  70ffe2:	e8 f9 e0 00 00       	call   71e0e0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::hit>
  70ffe7:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70ffee:	00 00 
  70fff0:	a8 01                	test   $0x1,%al
  70fff2:	0f 84 17 01 00 00    	je     71010f <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x34f>
  70fff8:	49 89 d5             	mov    %rdx,%r13
  70fffb:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  710000:	e8 db 47 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  710005:	4d 39 fd             	cmp    %r15,%r13
  710008:	0f 85 01 01 00 00    	jne    71010f <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x34f>
  71000e:	4c 3b b3 b0 05 00 00 	cmp    0x5b0(%rbx),%r14
  710015:	0f 85 01 01 00 00    	jne    71011c <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x35c>
  71001b:	4c 89 fa             	mov    %r15,%rdx
  71001e:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  710023:	48 89 de             	mov    %rbx,%rsi
  710026:	e8 f5 dd 00 00       	call   71de20 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  71002b:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  710030:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  710035:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  710039:	0f 85 e2 00 00 00    	jne    710121 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x361>
  71003f:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  710046:	48 39 f0             	cmp    %rsi,%rax
  710049:	0f 83 88 01 00 00    	jae    7101d7 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x417>
  71004f:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  710056:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  71005a:	8b 44 c1 20          	mov    0x20(%rcx,%rax,8),%eax
  71005e:	83 e0 07             	and    $0x7,%eax
  710061:	83 f8 02             	cmp    $0x2,%eax
  710064:	0f 85 df 00 00 00    	jne    710149 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x389>
  71006a:	48 89 ef             	mov    %rbp,%rdi
  71006d:	48 89 de             	mov    %rbx,%rsi
  710070:	4c 89 f2             	mov    %r14,%rdx
  710073:	4c 89 f9             	mov    %r15,%rcx
  710076:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  71007b:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  710082:	00 
  710083:	e8 68 c4 ff ff       	call   70c4f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer>
  710088:	e9 05 01 00 00       	jmp    710192 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x3d2>
  71008d:	b8 11 00 00 00       	mov    $0x11,%eax
  710092:	eb 2c                	jmp    7100c0 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x300>
  710094:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  710099:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  71009e:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  7100a3:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  7100a8:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  7100af:	00 
  7100b0:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  7100b5:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  7100bc:	00 
  7100bd:	48 89 ef             	mov    %rbp,%rdi
  7100c0:	48 89 07             	mov    %rax,(%rdi)
  7100c3:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  7100c7:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  7100cc:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
  7100d3:	00 
  7100d4:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  7100d8:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  7100dc:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  7100e3:	00 
  7100e4:	48 89 47 30          	mov    %rax,0x30(%rdi)
  7100e8:	eb 07                	jmp    7100f1 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x331>
  7100ea:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  7100f1:	48 89 f8             	mov    %rdi,%rax
  7100f4:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
  7100fb:	5b                   	pop    %rbx
  7100fc:	41 5c                	pop    %r12
  7100fe:	41 5d                	pop    %r13
  710100:	41 5e                	pop    %r14
  710102:	41 5f                	pop    %r15
  710104:	5d                   	pop    %rbp
  710105:	c3                   	ret
  710106:	48 c7 07 11 00 00 00 	movq   $0x11,(%rdi)
  71010d:	eb e2                	jmp    7100f1 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x331>
  71010f:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  710116:	00 
  710117:	48 89 e8             	mov    %rbp,%rax
  71011a:	eb d8                	jmp    7100f4 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x334>
  71011c:	b9 11 00 00 00       	mov    $0x11,%ecx
  710121:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  710126:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  71012a:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  71012f:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  710134:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  710138:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  71013c:	48 89 4d 00          	mov    %rcx,0x0(%rbp)
  710140:	48 89 45 08          	mov    %rax,0x8(%rbp)
  710144:	48 89 e8             	mov    %rbp,%rax
  710147:	eb ab                	jmp    7100f4 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x334>
  710149:	4c 8b ab e8 05 00 00 	mov    0x5e8(%rbx),%r13
  710150:	4c 8b a3 f0 05 00 00 	mov    0x5f0(%rbx),%r12
  710157:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  71015c:	48 89 de             	mov    %rbx,%rsi
  71015f:	4c 89 f2             	mov    %r14,%rdx
  710162:	4c 89 f9             	mov    %r15,%rcx
  710165:	e8 56 a4 ff ff       	call   70a5c0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::focus>
  71016a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  71016f:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  710173:	75 25                	jne    71019a <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x3da>
  710175:	4c 89 24 24          	mov    %r12,(%rsp)
  710179:	48 89 ef             	mov    %rbp,%rdi
  71017c:	48 89 de             	mov    %rbx,%rsi
  71017f:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  710184:	4c 89 f1             	mov    %r14,%rcx
  710187:	4d 89 f8             	mov    %r15,%r8
  71018a:	4d 89 e9             	mov    %r13,%r9
  71018d:	e8 1e 72 ff ff       	call   7073b0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused>
  710192:	48 89 e8             	mov    %rbp,%rax
  710195:	e9 5a ff ff ff       	jmp    7100f4 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x334>
  71019a:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  71019f:	0f b6 54 24 38       	movzbl 0x38(%rsp),%edx
  7101a4:	8b 74 24 3c          	mov    0x3c(%rsp),%esi
  7101a8:	89 75 34             	mov    %esi,0x34(%rbp)
  7101ab:	8b 74 24 39          	mov    0x39(%rsp),%esi
  7101af:	89 75 31             	mov    %esi,0x31(%rbp)
  7101b2:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  7101b7:	0f 10 4c 24 20       	movups 0x20(%rsp),%xmm1
  7101bc:	48 89 45 00          	mov    %rax,0x0(%rbp)
  7101c0:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  7101c4:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  7101c8:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  7101cc:	88 55 30             	mov    %dl,0x30(%rbp)
  7101cf:	48 89 e8             	mov    %rbp,%rax
  7101d2:	e9 1d ff ff ff       	jmp    7100f4 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x334>
  7101d7:	48 8d 15 32 41 3c 00 	lea    0x3c4132(%rip),%rdx        # ad4310 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xa68>
  7101de:	48 89 c7             	mov    %rax,%rdi
  7101e1:	ff 15 d9 1f 3f 00    	call   *0x3f1fd9(%rip)        # b021c0 <_DYNAMIC+0x378>
