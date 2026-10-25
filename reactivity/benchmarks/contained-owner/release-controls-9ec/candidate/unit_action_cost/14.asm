
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070fd90 <<gpui::runtime::Win<unit_action_cost::Model>>::click>:
  70fd90:	55                   	push   %rbp
  70fd91:	41 57                	push   %r15
  70fd93:	41 56                	push   %r14
  70fd95:	41 55                	push   %r13
  70fd97:	41 54                	push   %r12
  70fd99:	53                   	push   %rbx
  70fd9a:	48 81 ec b8 00 00 00 	sub    $0xb8,%rsp
  70fda1:	48 8b 1e             	mov    (%rsi),%rbx
  70fda4:	48 85 db             	test   %rbx,%rbx
  70fda7:	74 15                	je     70fdbe <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x2e>
  70fda9:	80 bb 22 07 00 00 01 	cmpb   $0x1,0x722(%rbx)
  70fdb0:	75 20                	jne    70fdd2 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x42>
  70fdb2:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70fdb9:	e9 03 03 00 00       	jmp    7100c1 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x331>
  70fdbe:	48 c7 07 0d 00 00 00 	movq   $0xd,(%rdi)
  70fdc5:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  70fdcc:	00 
  70fdcd:	e9 ef 02 00 00       	jmp    7100c1 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x331>
  70fdd2:	48 3b 93 b0 05 00 00 	cmp    0x5b0(%rbx),%rdx
  70fdd9:	0f 85 7e 02 00 00    	jne    71005d <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x2cd>
  70fddf:	49 89 f4             	mov    %rsi,%r12
  70fde2:	49 89 d6             	mov    %rdx,%r14
  70fde5:	48 89 fd             	mov    %rdi,%rbp
  70fde8:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70fded:	48 89 de             	mov    %rbx,%rsi
  70fdf0:	49 89 cf             	mov    %rcx,%r15
  70fdf3:	48 89 ca             	mov    %rcx,%rdx
  70fdf6:	e8 f5 df 00 00       	call   71ddf0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  70fdfb:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70fe00:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70fe04:	0f 85 5a 02 00 00    	jne    710064 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x2d4>
  70fe0a:	80 bb 1e 07 00 00 01 	cmpb   $0x1,0x71e(%rbx)
  70fe11:	48 89 ef             	mov    %rbp,%rdi
  70fe14:	0f 85 a0 02 00 00    	jne    7100ba <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fe1a:	80 bb 1f 07 00 00 00 	cmpb   $0x0,0x71f(%rbx)
  70fe21:	0f 85 93 02 00 00    	jne    7100ba <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fe27:	80 bb 20 07 00 00 00 	cmpb   $0x0,0x720(%rbx)
  70fe2e:	0f 84 86 02 00 00    	je     7100ba <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fe34:	48 83 bb 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rbx)
  70fe3b:	ff 
  70fe3c:	0f 85 78 02 00 00    	jne    7100ba <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fe42:	48 8b 83 60 06 00 00 	mov    0x660(%rbx),%rax
  70fe49:	48 3b 83 68 06 00 00 	cmp    0x668(%rbx),%rax
  70fe50:	0f 85 64 02 00 00    	jne    7100ba <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fe56:	48 8b 83 78 06 00 00 	mov    0x678(%rbx),%rax
  70fe5d:	48 3b 83 70 06 00 00 	cmp    0x670(%rbx),%rax
  70fe64:	0f 85 50 02 00 00    	jne    7100ba <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fe6a:	f3 0f 10 83 14 07 00 	movss  0x714(%rbx),%xmm0
  70fe71:	00 
  70fe72:	0f 2e 83 18 07 00 00 	ucomiss 0x718(%rbx),%xmm0
  70fe79:	0f 85 3b 02 00 00    	jne    7100ba <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fe7f:	0f 8a 35 02 00 00    	jp     7100ba <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70fe85:	4c 89 e0             	mov    %r12,%rax
  70fe88:	48 83 c0 08          	add    $0x8,%rax
  70fe8c:	4c 8b ab 78 05 00 00 	mov    0x578(%rbx),%r13
  70fe93:	48 8b 8b 80 05 00 00 	mov    0x580(%rbx),%rcx
  70fe9a:	48 c1 e1 04          	shl    $0x4,%rcx
  70fe9e:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  70fea2:	45 31 e4             	xor    %r12d,%r12d
  70fea5:	4c 89 ee             	mov    %r13,%rsi
  70fea8:	4c 89 fa             	mov    %r15,%rdx
  70feab:	4c 39 e1             	cmp    %r12,%rcx
  70feae:	0f 84 22 02 00 00    	je     7100d6 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x346>
  70feb4:	49 83 c4 50          	add    $0x50,%r12
  70feb8:	48 39 56 20          	cmp    %rdx,0x20(%rsi)
  70febc:	48 8d 76 50          	lea    0x50(%rsi),%rsi
  70fec0:	75 e9                	jne    70feab <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x11b>
  70fec2:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  70fec7:	48 c7 44 24 08 11 00 	movq   $0x11,0x8(%rsp)
  70fece:	00 00 
  70fed0:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70fed5:	e8 06 49 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70feda:	f3 43 0f 10 44 25 e0 	movss  -0x20(%r13,%r12,1),%xmm0
  70fee1:	0f 2e c0             	ucomiss %xmm0,%xmm0
  70fee4:	7a 62                	jp     70ff48 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1b8>
  70fee6:	43 8b 44 25 f4       	mov    -0xc(%r13,%r12,1),%eax
  70feeb:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  70feef:	43 0f 10 4c 25 e4    	movups -0x1c(%r13,%r12,1),%xmm1
  70fef5:	0f 11 4c 24 0c       	movups %xmm1,0xc(%rsp)
  70fefa:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70ff00:	f3 43 0f 10 44 25 b8 	movss  -0x48(%r13,%r12,1),%xmm0
  70ff07:	f3 43 0f 10 4c 25 bc 	movss  -0x44(%r13,%r12,1),%xmm1
  70ff0e:	48 8d 7c 24 64       	lea    0x64(%rsp),%rdi
  70ff13:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
  70ff18:	e8 d3 6b ff ff       	call   706af0 <<gpui::runtime::Win<unit_action_cost::Model>>::click::{closure#1}>
  70ff1d:	83 7c 24 64 01       	cmpl   $0x1,0x64(%rsp)
  70ff22:	75 24                	jne    70ff48 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1b8>
  70ff24:	f2 0f 10 44 24 68    	movsd  0x68(%rsp),%xmm0
  70ff2a:	0f 28 c8             	movaps %xmm0,%xmm1
  70ff2d:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70ff31:	4b 8d 3c 2c          	lea    (%r12,%r13,1),%rdi
  70ff35:	48 83 c7 c0          	add    $0xffffffffffffffc0,%rdi
  70ff39:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  70ff3e:	ff 15 24 24 3f 00    	call   *0x3f2424(%rip)        # b02368 <_DYNAMIC+0x550>
  70ff44:	84 c0                	test   %al,%al
  70ff46:	75 40                	jne    70ff88 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1f8>
  70ff48:	f3 43 0f 10 44 25 c8 	movss  -0x38(%r13,%r12,1),%xmm0
  70ff4f:	0f 57 d2             	xorps  %xmm2,%xmm2
  70ff52:	0f 2e c2             	ucomiss %xmm2,%xmm0
  70ff55:	75 06                	jne    70ff5d <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1cd>
  70ff57:	0f 8b 82 01 00 00    	jnp    7100df <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x34f>
  70ff5d:	f3 43 0f 10 4c 25 cc 	movss  -0x34(%r13,%r12,1),%xmm1
  70ff64:	0f 2e ca             	ucomiss %xmm2,%xmm1
  70ff67:	75 06                	jne    70ff6f <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1df>
  70ff69:	0f 8b 70 01 00 00    	jnp    7100df <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x34f>
  70ff6f:	0f 14 c1             	unpcklps %xmm1,%xmm0
  70ff72:	0f 59 05 37 60 95 ff 	mulps  -0x6a9fc9(%rip),%xmm0        # 65fb0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1110>
  70ff79:	f2 43 0f 10 4c 25 c0 	movsd  -0x40(%r13,%r12,1),%xmm1
  70ff80:	0f 58 c8             	addps  %xmm0,%xmm1
  70ff83:	0f 29 4c 24 40       	movaps %xmm1,0x40(%rsp)
  70ff88:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70ff8f:	00 00 
  70ff91:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70ff96:	e8 45 48 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70ff9b:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70ffa0:	0f 28 c8             	movaps %xmm0,%xmm1
  70ffa3:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70ffa7:	48 89 df             	mov    %rbx,%rdi
  70ffaa:	0f 29 8c 24 a0 00 00 	movaps %xmm1,0xa0(%rsp)
  70ffb1:	00 
  70ffb2:	e8 f9 e0 00 00       	call   71e0b0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::hit>
  70ffb7:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70ffbe:	00 00 
  70ffc0:	a8 01                	test   $0x1,%al
  70ffc2:	0f 84 17 01 00 00    	je     7100df <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x34f>
  70ffc8:	49 89 d5             	mov    %rdx,%r13
  70ffcb:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70ffd0:	e8 0b 48 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70ffd5:	4d 39 fd             	cmp    %r15,%r13
  70ffd8:	0f 85 01 01 00 00    	jne    7100df <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x34f>
  70ffde:	4c 3b b3 b0 05 00 00 	cmp    0x5b0(%rbx),%r14
  70ffe5:	0f 85 01 01 00 00    	jne    7100ec <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x35c>
  70ffeb:	4c 89 fa             	mov    %r15,%rdx
  70ffee:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70fff3:	48 89 de             	mov    %rbx,%rsi
  70fff6:	e8 f5 dd 00 00       	call   71ddf0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  70fffb:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  710000:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  710005:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  710009:	0f 85 e2 00 00 00    	jne    7100f1 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x361>
  71000f:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  710016:	48 39 f0             	cmp    %rsi,%rax
  710019:	0f 83 88 01 00 00    	jae    7101a7 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x417>
  71001f:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  710026:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  71002a:	8b 44 c1 20          	mov    0x20(%rcx,%rax,8),%eax
  71002e:	83 e0 07             	and    $0x7,%eax
  710031:	83 f8 02             	cmp    $0x2,%eax
  710034:	0f 85 df 00 00 00    	jne    710119 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x389>
  71003a:	48 89 ef             	mov    %rbp,%rdi
  71003d:	48 89 de             	mov    %rbx,%rsi
  710040:	4c 89 f2             	mov    %r14,%rdx
  710043:	4c 89 f9             	mov    %r15,%rcx
  710046:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  71004b:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  710052:	00 
  710053:	e8 68 c4 ff ff       	call   70c4c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer>
  710058:	e9 05 01 00 00       	jmp    710162 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x3d2>
  71005d:	b8 11 00 00 00       	mov    $0x11,%eax
  710062:	eb 2c                	jmp    710090 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x300>
  710064:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  710069:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  71006e:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  710073:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  710078:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  71007f:	00 
  710080:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  710085:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  71008c:	00 
  71008d:	48 89 ef             	mov    %rbp,%rdi
  710090:	48 89 07             	mov    %rax,(%rdi)
  710093:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  710097:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  71009c:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
  7100a3:	00 
  7100a4:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  7100a8:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  7100ac:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  7100b3:	00 
  7100b4:	48 89 47 30          	mov    %rax,0x30(%rdi)
  7100b8:	eb 07                	jmp    7100c1 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x331>
  7100ba:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  7100c1:	48 89 f8             	mov    %rdi,%rax
  7100c4:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
  7100cb:	5b                   	pop    %rbx
  7100cc:	41 5c                	pop    %r12
  7100ce:	41 5d                	pop    %r13
  7100d0:	41 5e                	pop    %r14
  7100d2:	41 5f                	pop    %r15
  7100d4:	5d                   	pop    %rbp
  7100d5:	c3                   	ret
  7100d6:	48 c7 07 11 00 00 00 	movq   $0x11,(%rdi)
  7100dd:	eb e2                	jmp    7100c1 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x331>
  7100df:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  7100e6:	00 
  7100e7:	48 89 e8             	mov    %rbp,%rax
  7100ea:	eb d8                	jmp    7100c4 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x334>
  7100ec:	b9 11 00 00 00       	mov    $0x11,%ecx
  7100f1:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  7100f6:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  7100fa:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  7100ff:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  710104:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  710108:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  71010c:	48 89 4d 00          	mov    %rcx,0x0(%rbp)
  710110:	48 89 45 08          	mov    %rax,0x8(%rbp)
  710114:	48 89 e8             	mov    %rbp,%rax
  710117:	eb ab                	jmp    7100c4 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x334>
  710119:	4c 8b ab e8 05 00 00 	mov    0x5e8(%rbx),%r13
  710120:	4c 8b a3 f0 05 00 00 	mov    0x5f0(%rbx),%r12
  710127:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  71012c:	48 89 de             	mov    %rbx,%rsi
  71012f:	4c 89 f2             	mov    %r14,%rdx
  710132:	4c 89 f9             	mov    %r15,%rcx
  710135:	e8 56 a4 ff ff       	call   70a590 <<gpui::runtime::Runtime<unit_action_cost::Model>>::focus>
  71013a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  71013f:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  710143:	75 25                	jne    71016a <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x3da>
  710145:	4c 89 24 24          	mov    %r12,(%rsp)
  710149:	48 89 ef             	mov    %rbp,%rdi
  71014c:	48 89 de             	mov    %rbx,%rsi
  71014f:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  710154:	4c 89 f1             	mov    %r14,%rcx
  710157:	4d 89 f8             	mov    %r15,%r8
  71015a:	4d 89 e9             	mov    %r13,%r9
  71015d:	e8 4e 72 ff ff       	call   7073b0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused>
  710162:	48 89 e8             	mov    %rbp,%rax
  710165:	e9 5a ff ff ff       	jmp    7100c4 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x334>
  71016a:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  71016f:	0f b6 54 24 38       	movzbl 0x38(%rsp),%edx
  710174:	8b 74 24 3c          	mov    0x3c(%rsp),%esi
  710178:	89 75 34             	mov    %esi,0x34(%rbp)
  71017b:	8b 74 24 39          	mov    0x39(%rsp),%esi
  71017f:	89 75 31             	mov    %esi,0x31(%rbp)
  710182:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  710187:	0f 10 4c 24 20       	movups 0x20(%rsp),%xmm1
  71018c:	48 89 45 00          	mov    %rax,0x0(%rbp)
  710190:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  710194:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  710198:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  71019c:	88 55 30             	mov    %dl,0x30(%rbp)
  71019f:	48 89 e8             	mov    %rbp,%rax
  7101a2:	e9 1d ff ff ff       	jmp    7100c4 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x334>
  7101a7:	48 8d 15 32 41 3c 00 	lea    0x3c4132(%rip),%rdx        # ad42e0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xa68>
  7101ae:	48 89 c7             	mov    %rax,%rdi
  7101b1:	ff 15 d9 1f 3f 00    	call   *0x3f1fd9(%rip)        # b02190 <_DYNAMIC+0x378>
