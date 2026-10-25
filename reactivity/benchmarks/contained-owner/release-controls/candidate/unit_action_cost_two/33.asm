
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fded0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property>:
  6fded0:	55                   	push   %rbp
  6fded1:	41 57                	push   %r15
  6fded3:	41 56                	push   %r14
  6fded5:	41 55                	push   %r13
  6fded7:	41 54                	push   %r12
  6fded9:	53                   	push   %rbx
  6fdeda:	48 81 ec 48 01 00 00 	sub    $0x148,%rsp
  6fdee1:	49 89 cc             	mov    %rcx,%r12
  6fdee4:	49 89 f6             	mov    %rsi,%r14
  6fdee7:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  6fdeec:	48 8b b6 a0 02 00 00 	mov    0x2a0(%rsi),%rsi
  6fdef3:	48 39 f1             	cmp    %rsi,%rcx
  6fdef6:	0f 83 97 05 00 00    	jae    6fe493 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x5c3>
  6fdefc:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6fdf03:	4b 8d 1c a4          	lea    (%r12,%r12,4),%rbx
  6fdf07:	48 8b 74 d8 08       	mov    0x8(%rax,%rbx,8),%rsi
  6fdf0c:	48 8b 4c d8 10       	mov    0x10(%rax,%rbx,8),%rcx
  6fdf11:	48 c7 44 d8 08 00 00 	movq   $0x0,0x8(%rax,%rbx,8)
  6fdf18:	00 00 
  6fdf1a:	48 85 f6             	test   %rsi,%rsi
  6fdf1d:	0f 84 49 05 00 00    	je     6fe46c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x59c>
  6fdf23:	48 89 94 24 d8 00 00 	mov    %rdx,0xd8(%rsp)
  6fdf2a:	00 
  6fdf2b:	4c 89 84 24 e0 00 00 	mov    %r8,0xe0(%rsp)
  6fdf32:	00 
  6fdf33:	48 89 74 24 48       	mov    %rsi,0x48(%rsp)
  6fdf38:	48 89 b4 24 f0 00 00 	mov    %rsi,0xf0(%rsp)
  6fdf3f:	00 
  6fdf40:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  6fdf45:	48 89 8c 24 f8 00 00 	mov    %rcx,0xf8(%rsp)
  6fdf4c:	00 
  6fdf4d:	49 8b 86 60 06 00 00 	mov    0x660(%r14),%rax
  6fdf54:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6fdf5b:	00 
  6fdf5c:	49 8d ae 10 07 00 00 	lea    0x710(%r14),%rbp
  6fdf63:	48 8d 0d 4e ca 3f 00 	lea    0x3fca4e(%rip),%rcx        # afa9b8 <__frame_dummy_init_array_entry+0xb0>
  6fdf6a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fdf6f:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  6fdf76:	00 
  6fdf77:	48 89 ea             	mov    %rbp,%rdx
  6fdf7a:	ff 15 68 b5 42 00    	call   *0x42b568(%rip)        # b294e8 <_DYNAMIC+0x378>
  6fdf80:	44 0f b7 7c 24 20    	movzwl 0x20(%rsp),%r15d
  6fdf86:	66 41 83 ff ff       	cmp    $0xffff,%r15w
  6fdf8b:	0f 84 f6 00 00 00    	je     6fe087 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x1b7>
  6fdf91:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6fdf96:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  6fdf9b:	8b 74 24 24          	mov    0x24(%rsp),%esi
  6fdf9f:	0f b6 7c 24 28       	movzbl 0x28(%rsp),%edi
  6fdfa4:	44 0f b6 4c 24 2f    	movzbl 0x2f(%rsp),%r9d
  6fdfaa:	44 0f b7 44 24 2d    	movzwl 0x2d(%rsp),%r8d
  6fdfb0:	8b 4c 24 29          	mov    0x29(%rsp),%ecx
  6fdfb4:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  6fdfb9:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  6fdfc0:	00 
  6fdfc1:	66 45 85 ff          	test   %r15w,%r15w
  6fdfc5:	0f 84 f8 00 00 00    	je     6fe0c3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x1f3>
  6fdfcb:	41 c1 e1 10          	shl    $0x10,%r9d
  6fdfcf:	45 09 c8             	or     %r9d,%r8d
  6fdfd2:	49 c1 e0 20          	shl    $0x20,%r8
  6fdfd6:	4c 09 c1             	or     %r8,%rcx
  6fdfd9:	89 b4 24 04 01 00 00 	mov    %esi,0x104(%rsp)
  6fdfe0:	40 88 bc 24 08 01 00 	mov    %dil,0x108(%rsp)
  6fdfe7:	00 
  6fdfe8:	89 8c 24 09 01 00 00 	mov    %ecx,0x109(%rsp)
  6fdfef:	48 89 ce             	mov    %rcx,%rsi
  6fdff2:	48 c1 ee 30          	shr    $0x30,%rsi
  6fdff6:	40 88 b4 24 0f 01 00 	mov    %sil,0x10f(%rsp)
  6fdffd:	00 
  6fdffe:	48 c1 e9 20          	shr    $0x20,%rcx
  6fe002:	66 89 8c 24 0d 01 00 	mov    %cx,0x10d(%rsp)
  6fe009:	00 
  6fe00a:	0f 28 84 24 20 01 00 	movaps 0x120(%rsp),%xmm0
  6fe011:	00 
  6fe012:	0f 11 84 24 10 01 00 	movups %xmm0,0x110(%rsp)
  6fe019:	00 
  6fe01a:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  6fe021:	49 ff c5             	inc    %r13
  6fe024:	0f 84 5b 04 00 00    	je     6fe485 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x5b5>
  6fe02a:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  6fe031:	0f 85 93 00 00 00    	jne    6fe0ca <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x1fa>
  6fe037:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fe03c:	4c 89 f6             	mov    %r14,%rsi
  6fe03f:	e8 dc ac 02 00       	call   728d20 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  6fe044:	48 83 7c 24 10 fe    	cmpq   $0xfffffffffffffffe,0x10(%rsp)
  6fe04a:	0f 85 83 00 00 00    	jne    6fe0d3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x203>
  6fe050:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  6fe055:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  6fe05a:	4c 8d 84 24 04 01 00 	lea    0x104(%rsp),%r8
  6fe061:	00 
  6fe062:	4c 89 f6             	mov    %r14,%rsi
  6fe065:	44 89 f9             	mov    %r15d,%ecx
  6fe068:	e8 13 ce 02 00       	call   72ae80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at>
  6fe06d:	4d 89 e7             	mov    %r12,%r15
  6fe070:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  6fe075:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fe079:	0f 85 9e 00 00 00    	jne    6fe11d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x24d>
  6fe07f:	45 31 c0             	xor    %r8d,%r8d
  6fe082:	e9 bb 00 00 00       	jmp    6fe142 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x272>
  6fe087:	0f b6 74 24 28       	movzbl 0x28(%rsp),%esi
  6fe08c:	0f b6 44 24 2f       	movzbl 0x2f(%rsp),%eax
  6fe091:	c1 e0 10             	shl    $0x10,%eax
  6fe094:	0f b7 4c 24 2d       	movzwl 0x2d(%rsp),%ecx
  6fe099:	09 c1                	or     %eax,%ecx
  6fe09b:	48 c1 e1 20          	shl    $0x20,%rcx
  6fe09f:	8b 6c 24 29          	mov    0x29(%rsp),%ebp
  6fe0a3:	48 09 cd             	or     %rcx,%rbp
  6fe0a6:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  6fe0ab:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  6fe0b2:	00 
  6fe0b3:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fe0b8:	41 bd 20 00 00 00    	mov    $0x20,%r13d
  6fe0be:	e9 bf 01 00 00       	jmp    6fe282 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x3b2>
  6fe0c3:	31 f6                	xor    %esi,%esi
  6fe0c5:	e9 66 01 00 00       	jmp    6fe230 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x360>
  6fe0ca:	48 c7 44 24 10 11 00 	movq   $0x11,0x10(%rsp)
  6fe0d1:	00 00 
  6fe0d3:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fe0d8:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  6fe0df:	00 
  6fe0e0:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6fe0e5:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  6fe0ea:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  6fe0ef:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  6fe0f4:	0f 29 8c 24 80 00 00 	movaps %xmm1,0x80(%rsp)
  6fe0fb:	00 
  6fe0fc:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  6fe101:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6fe106:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  6fe10b:	4d 89 e7             	mov    %r12,%r15
  6fe10e:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  6fe113:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fe117:	0f 84 62 ff ff ff    	je     6fe07f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x1af>
  6fe11d:	4c 89 e1             	mov    %r12,%rcx
  6fe120:	48 83 e9 0d          	sub    $0xd,%rcx
  6fe124:	b8 14 00 00 00       	mov    $0x14,%eax
  6fe129:	48 0f 4d c1          	cmovge %rcx,%rax
  6fe12d:	4c 8d 44 24 60       	lea    0x60(%rsp),%r8
  6fe132:	48 83 f8 17          	cmp    $0x17,%rax
  6fe136:	74 0a                	je     6fe142 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x272>
  6fe138:	48 83 f8 04          	cmp    $0x4,%rax
  6fe13c:	0f 85 f7 00 00 00    	jne    6fe239 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x369>
  6fe142:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  6fe149:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  6fe150:	48 8d 0d 61 c8 3f 00 	lea    0x3fc861(%rip),%rcx        # afa9b8 <__frame_dummy_init_array_entry+0xb0>
  6fe157:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  6fe15e:	00 
  6fe15f:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  6fe166:	00 
  6fe167:	48 89 ea             	mov    %rbp,%rdx
  6fe16a:	ff 15 80 b3 42 00    	call   *0x42b380(%rip)        # b294f0 <_DYNAMIC+0x380>
  6fe170:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  6fe175:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  6fe17a:	48 8b b4 24 30 01 00 	mov    0x130(%rsp),%rsi
  6fe181:	00 
  6fe182:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  6fe186:	74 69                	je     6fe1f1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x321>
  6fe188:	48 89 f5             	mov    %rsi,%rbp
  6fe18b:	48 c1 ed 08          	shr    $0x8,%rbp
  6fe18f:	0f 10 84 24 38 01 00 	movups 0x138(%rsp),%xmm0
  6fe196:	00 
  6fe197:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fe19c:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fe1a0:	74 44                	je     6fe1e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x316>
  6fe1a2:	49 83 ec 0d          	sub    $0xd,%r12
  6fe1a6:	ba 14 00 00 00       	mov    $0x14,%edx
  6fe1ab:	49 0f 4d d4          	cmovge %r12,%rdx
  6fe1af:	48 83 fa 19          	cmp    $0x19,%rdx
  6fe1b3:	74 09                	je     6fe1be <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x2ee>
  6fe1b5:	48 89 c8             	mov    %rcx,%rax
  6fe1b8:	48 83 fa 14          	cmp    $0x14,%rdx
  6fe1bc:	75 28                	jne    6fe1e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x316>
  6fe1be:	49 89 f5             	mov    %rsi,%r13
  6fe1c1:	48 8b 30             	mov    (%rax),%rsi
  6fe1c4:	48 85 f6             	test   %rsi,%rsi
  6fe1c7:	74 0f                	je     6fe1d8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x308>
  6fe1c9:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fe1cd:	ba 01 00 00 00       	mov    $0x1,%edx
  6fe1d2:	ff 15 e0 b1 42 00    	call   *0x42b1e0(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fe1d8:	41 bc 20 00 00 00    	mov    $0x20,%r12d
  6fe1de:	4c 89 ee             	mov    %r13,%rsi
  6fe1e1:	e9 96 00 00 00       	jmp    6fe27c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x3ac>
  6fe1e6:	41 bc 20 00 00 00    	mov    $0x20,%r12d
  6fe1ec:	e9 8b 00 00 00       	jmp    6fe27c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x3ac>
  6fe1f1:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fe1f5:	74 33                	je     6fe22a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x35a>
  6fe1f7:	49 83 ec 0d          	sub    $0xd,%r12
  6fe1fb:	ba 14 00 00 00       	mov    $0x14,%edx
  6fe200:	49 0f 4d d4          	cmovge %r12,%rdx
  6fe204:	48 83 fa 19          	cmp    $0x19,%rdx
  6fe208:	74 09                	je     6fe213 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x343>
  6fe20a:	48 89 c8             	mov    %rcx,%rax
  6fe20d:	48 83 fa 14          	cmp    $0x14,%rdx
  6fe211:	75 17                	jne    6fe22a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x35a>
  6fe213:	48 8b 30             	mov    (%rax),%rsi
  6fe216:	48 85 f6             	test   %rsi,%rsi
  6fe219:	74 0f                	je     6fe22a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x35a>
  6fe21b:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fe21f:	ba 01 00 00 00       	mov    $0x1,%edx
  6fe224:	ff 15 8e b1 42 00    	call   *0x42b18e(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fe22a:	40 b6 01             	mov    $0x1,%sil
  6fe22d:	4d 89 fc             	mov    %r15,%r12
  6fe230:	49 c7 c5 fe ff ff ff 	mov    $0xfffffffffffffffe,%r13
  6fe237:	eb 49                	jmp    6fe282 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x3b2>
  6fe239:	0f b6 74 24 68       	movzbl 0x68(%rsp),%esi
  6fe23e:	0f b6 44 24 6f       	movzbl 0x6f(%rsp),%eax
  6fe243:	c1 e0 10             	shl    $0x10,%eax
  6fe246:	0f b7 4c 24 6d       	movzwl 0x6d(%rsp),%ecx
  6fe24b:	09 c1                	or     %eax,%ecx
  6fe24d:	48 c1 e1 20          	shl    $0x20,%rcx
  6fe251:	8b 6c 24 69          	mov    0x69(%rsp),%ebp
  6fe255:	48 09 cd             	or     %rcx,%rbp
  6fe258:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  6fe25d:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fe262:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  6fe269:	00 
  6fe26a:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  6fe26f:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  6fe276:	00 
  6fe277:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6fe27c:	4d 89 e5             	mov    %r12,%r13
  6fe27f:	4d 89 fc             	mov    %r15,%r12
  6fe282:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
  6fe287:	40 0f b6 c6          	movzbl %sil,%eax
  6fe28b:	48 c1 e5 08          	shl    $0x8,%rbp
  6fe28f:	48 09 c5             	or     %rax,%rbp
  6fe292:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  6fe297:	0f 28 4c 24 20       	movaps 0x20(%rsp),%xmm1
  6fe29c:	0f 11 84 24 b0 00 00 	movups %xmm0,0xb0(%rsp)
  6fe2a3:	00 
  6fe2a4:	0f 11 8c 24 c0 00 00 	movups %xmm1,0xc0(%rsp)
  6fe2ab:	00 
  6fe2ac:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fe2b1:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fe2b8:	00 
  6fe2b9:	4c 89 ac 24 a0 00 00 	mov    %r13,0xa0(%rsp)
  6fe2c0:	00 
  6fe2c1:	48 89 ac 24 a8 00 00 	mov    %rbp,0xa8(%rsp)
  6fe2c8:	00 
  6fe2c9:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fe2d0:	49 39 f4             	cmp    %rsi,%r12
  6fe2d3:	0f 83 8d 02 00 00    	jae    6fe566 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x696>
  6fe2d9:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6fe2e0:	4c 8d 24 d8          	lea    (%rax,%rbx,8),%r12
  6fe2e4:	4c 8b 7c d8 08       	mov    0x8(%rax,%rbx,8),%r15
  6fe2e9:	4d 85 ff             	test   %r15,%r15
  6fe2ec:	74 28                	je     6fe316 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x446>
  6fe2ee:	48 8b 5c d8 10       	mov    0x10(%rax,%rbx,8),%rbx
  6fe2f3:	48 8b 03             	mov    (%rbx),%rax
  6fe2f6:	48 85 c0             	test   %rax,%rax
  6fe2f9:	74 05                	je     6fe300 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x430>
  6fe2fb:	4c 89 ff             	mov    %r15,%rdi
  6fe2fe:	ff d0                	call   *%rax
  6fe300:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fe304:	48 85 f6             	test   %rsi,%rsi
  6fe307:	74 0d                	je     6fe316 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x446>
  6fe309:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fe30d:	4c 89 ff             	mov    %r15,%rdi
  6fe310:	ff 15 a2 b0 42 00    	call   *0x42b0a2(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fe316:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6fe31b:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  6fe320:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fe325:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  6fe32a:	49 83 fd fd          	cmp    $0xfffffffffffffffd,%r13
  6fe32e:	74 35                	je     6fe365 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x495>
  6fe330:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  6fe334:	75 77                	jne    6fe3ad <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x4dd>
  6fe336:	80 7c 24 58 01       	cmpb   $0x1,0x58(%rsp)
  6fe33b:	0f 85 bb 00 00 00    	jne    6fe3fc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x52c>
  6fe341:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6fe346:	4c 89 f6             	mov    %r14,%rsi
  6fe349:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  6fe350:	00 
  6fe351:	31 c9                	xor    %ecx,%ecx
  6fe353:	4c 8b 84 24 e0 00 00 	mov    0xe0(%rsp),%r8
  6fe35a:	00 
  6fe35b:	e8 70 06 00 00       	call   6fe9d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing>
  6fe360:	e9 f5 00 00 00       	jmp    6fe45a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x58a>
  6fe365:	4c 89 f7             	mov    %r14,%rdi
  6fe368:	e8 43 b0 02 00       	call   7293b0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fe36d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fe372:	48 c7 00 0f 00 00 00 	movq   $0xf,(%rax)
  6fe379:	48 8b 9c 24 b0 00 00 	mov    0xb0(%rsp),%rbx
  6fe380:	00 
  6fe381:	48 8b 03             	mov    (%rbx),%rax
  6fe384:	48 85 c0             	test   %rax,%rax
  6fe387:	74 05                	je     6fe38e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x4be>
  6fe389:	48 89 ef             	mov    %rbp,%rdi
  6fe38c:	ff d0                	call   *%rax
  6fe38e:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fe392:	48 85 f6             	test   %rsi,%rsi
  6fe395:	0f 84 bf 00 00 00    	je     6fe45a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x58a>
  6fe39b:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fe39f:	48 89 ef             	mov    %rbp,%rdi
  6fe3a2:	ff 15 10 b0 42 00    	call   *0x42b010(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fe3a8:	e9 ad 00 00 00       	jmp    6fe45a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x58a>
  6fe3ad:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  6fe3b4:	00 
  6fe3b5:	49 39 86 60 06 00 00 	cmp    %rax,0x660(%r14)
  6fe3bc:	74 08                	je     6fe3c6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x4f6>
  6fe3be:	4c 89 f7             	mov    %r14,%rdi
  6fe3c1:	e8 ea af 02 00       	call   7293b0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fe3c6:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  6fe3cd:	00 
  6fe3ce:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fe3d3:	48 89 41 30          	mov    %rax,0x30(%rcx)
  6fe3d7:	0f 10 84 24 a0 00 00 	movups 0xa0(%rsp),%xmm0
  6fe3de:	00 
  6fe3df:	0f 10 8c 24 b0 00 00 	movups 0xb0(%rsp),%xmm1
  6fe3e6:	00 
  6fe3e7:	0f 10 94 24 c0 00 00 	movups 0xc0(%rsp),%xmm2
  6fe3ee:	00 
  6fe3ef:	0f 11 51 20          	movups %xmm2,0x20(%rcx)
  6fe3f3:	0f 11 49 10          	movups %xmm1,0x10(%rcx)
  6fe3f7:	0f 11 01             	movups %xmm0,(%rcx)
  6fe3fa:	eb 5e                	jmp    6fe45a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x58a>
  6fe3fc:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  6fe403:	00 
  6fe404:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  6fe40b:	00 
  6fe40c:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  6fe413:	00 
  6fe414:	74 0e                	je     6fe424 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x554>
  6fe416:	84 c0                	test   %al,%al
  6fe418:	74 0e                	je     6fe428 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x558>
  6fe41a:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  6fe421:	ff 
  6fe422:	75 04                	jne    6fe428 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x558>
  6fe424:	31 c9                	xor    %ecx,%ecx
  6fe426:	eb 0c                	jmp    6fe434 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x564>
  6fe428:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  6fe42f:	b9 01 00 00 00       	mov    $0x1,%ecx
  6fe434:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  6fe43b:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6fe440:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  6fe444:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  6fe448:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  6fe44c:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  6fe450:	88 47 30             	mov    %al,0x30(%rdi)
  6fe453:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  6fe45a:	48 81 c4 48 01 00 00 	add    $0x148,%rsp
  6fe461:	5b                   	pop    %rbx
  6fe462:	41 5c                	pop    %r12
  6fe464:	41 5d                	pop    %r13
  6fe466:	41 5e                	pop    %r14
  6fe468:	41 5f                	pop    %r15
  6fe46a:	5d                   	pop    %rbp
  6fe46b:	c3                   	ret
  6fe46c:	48 8d 3d 02 98 96 ff 	lea    -0x6967fe(%rip),%rdi        # 67c75 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x988>
  6fe473:	48 8d 15 06 c9 3f 00 	lea    0x3fc906(%rip),%rdx        # afad80 <__frame_dummy_init_array_entry+0x478>
  6fe47a:	be 0e 00 00 00       	mov    $0xe,%esi
  6fe47f:	ff 15 33 b0 42 00    	call   *0x42b033(%rip)        # b294b8 <_DYNAMIC+0x348>
  6fe485:	4d 89 e7             	mov    %r12,%r15
  6fe488:	41 bc 1f 00 00 00    	mov    $0x1f,%r12d
  6fe48e:	e9 e9 fd ff ff       	jmp    6fe27c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x3ac>
  6fe493:	48 8d 15 ce c8 3f 00 	lea    0x3fc8ce(%rip),%rdx        # afad68 <__frame_dummy_init_array_entry+0x460>
  6fe49a:	4c 89 e7             	mov    %r12,%rdi
  6fe49d:	ff 15 25 b0 42 00    	call   *0x42b025(%rip)        # b294c8 <_DYNAMIC+0x358>
  6fe4a3:	49 89 c6             	mov    %rax,%r14
  6fe4a6:	e9 f1 00 00 00       	jmp    6fe59c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6cc>
  6fe4ab:	49 89 c6             	mov    %rax,%r14
  6fe4ae:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fe4b2:	48 85 f6             	test   %rsi,%rsi
  6fe4b5:	0f 84 ee 00 00 00    	je     6fe5a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6d9>
  6fe4bb:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fe4bf:	48 89 ef             	mov    %rbp,%rdi
  6fe4c2:	ff 15 f0 ae 42 00    	call   *0x42aef0(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fe4c8:	4c 89 f7             	mov    %r14,%rdi
  6fe4cb:	e8 80 b0 3f 00       	call   af9550 <_Unwind_Resume@plt>
  6fe4d0:	49 89 c5             	mov    %rax,%r13
  6fe4d3:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fe4d7:	74 46                	je     6fe51f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x64f>
  6fe4d9:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  6fe4de:	e8 0d 9b ff ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fe4e3:	eb 3a                	jmp    6fe51f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x64f>
  6fe4e5:	49 89 c6             	mov    %rax,%r14
  6fe4e8:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fe4ec:	48 85 f6             	test   %rsi,%rsi
  6fe4ef:	74 0d                	je     6fe4fe <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x62e>
  6fe4f1:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fe4f5:	4c 89 ff             	mov    %r15,%rdi
  6fe4f8:	ff 15 ba ae 42 00    	call   *0x42aeba(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fe4fe:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6fe503:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  6fe508:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fe50d:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  6fe512:	eb 7c                	jmp    6fe590 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6c0>
  6fe514:	49 89 c6             	mov    %rax,%r14
  6fe517:	eb 77                	jmp    6fe590 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6c0>
  6fe519:	4d 89 e7             	mov    %r12,%r15
  6fe51c:	49 89 c5             	mov    %rax,%r13
  6fe51f:	4c 89 ef             	mov    %r13,%rdi
  6fe522:	ff 15 b0 af 42 00    	call   *0x42afb0(%rip)        # b294d8 <_DYNAMIC+0x368>
  6fe528:	48 89 c5             	mov    %rax,%rbp
  6fe52b:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  6fe532:	00 
  6fe533:	48 89 94 24 b0 00 00 	mov    %rdx,0xb0(%rsp)
  6fe53a:	00 
  6fe53b:	48 c7 84 24 a0 00 00 	movq   $0xfffffffffffffffd,0xa0(%rsp)
  6fe542:	00 fd ff ff ff 
  6fe547:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fe54c:	4d 89 fc             	mov    %r15,%r12
  6fe54f:	49 c7 c5 fd ff ff ff 	mov    $0xfffffffffffffffd,%r13
  6fe556:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fe55d:	49 39 f4             	cmp    %rsi,%r12
  6fe560:	0f 82 73 fd ff ff    	jb     6fe2d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x409>
  6fe566:	48 8d 15 2b c8 3f 00 	lea    0x3fc82b(%rip),%rdx        # afad98 <__frame_dummy_init_array_entry+0x490>
  6fe56d:	4c 89 e7             	mov    %r12,%rdi
  6fe570:	ff 15 52 af 42 00    	call   *0x42af52(%rip)        # b294c8 <_DYNAMIC+0x358>
  6fe576:	0f 0b                	ud2
  6fe578:	ff 15 62 af 42 00    	call   *0x42af62(%rip)        # b294e0 <_DYNAMIC+0x370>
  6fe57e:	49 89 c6             	mov    %rax,%r14
  6fe581:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  6fe586:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6fe58b:	e8 e0 63 ff ff       	call   6f4970 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  6fe590:	49 83 fd fd          	cmp    $0xfffffffffffffffd,%r13
  6fe594:	74 1b                	je     6fe5b1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6e1>
  6fe596:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  6fe59a:	74 0d                	je     6fe5a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6d9>
  6fe59c:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  6fe5a3:	00 
  6fe5a4:	e8 47 9a ff ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fe5a9:	4c 89 f7             	mov    %r14,%rdi
  6fe5ac:	e8 9f af 3f 00       	call   af9550 <_Unwind_Resume@plt>
  6fe5b1:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  6fe5b8:	00 
  6fe5b9:	e8 52 68 ff ff       	call   6f4e10 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe5be:	eb e9                	jmp    6fe5a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6d9>
  6fe5c0:	ff 15 22 ae 42 00    	call   *0x42ae22(%rip)        # b293e8 <_DYNAMIC+0x278>
