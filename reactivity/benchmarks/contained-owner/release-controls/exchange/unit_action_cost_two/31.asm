
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fddd0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property>:
  6fddd0:	55                   	push   %rbp
  6fddd1:	41 57                	push   %r15
  6fddd3:	41 56                	push   %r14
  6fddd5:	41 55                	push   %r13
  6fddd7:	41 54                	push   %r12
  6fddd9:	53                   	push   %rbx
  6fddda:	48 81 ec 48 01 00 00 	sub    $0x148,%rsp
  6fdde1:	49 89 cc             	mov    %rcx,%r12
  6fdde4:	49 89 f6             	mov    %rsi,%r14
  6fdde7:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  6fddec:	48 8b b6 a0 02 00 00 	mov    0x2a0(%rsi),%rsi
  6fddf3:	48 39 f1             	cmp    %rsi,%rcx
  6fddf6:	0f 83 97 05 00 00    	jae    6fe393 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x5c3>
  6fddfc:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6fde03:	4b 8d 1c a4          	lea    (%r12,%r12,4),%rbx
  6fde07:	48 8b 74 d8 08       	mov    0x8(%rax,%rbx,8),%rsi
  6fde0c:	48 8b 4c d8 10       	mov    0x10(%rax,%rbx,8),%rcx
  6fde11:	48 c7 44 d8 08 00 00 	movq   $0x0,0x8(%rax,%rbx,8)
  6fde18:	00 00 
  6fde1a:	48 85 f6             	test   %rsi,%rsi
  6fde1d:	0f 84 49 05 00 00    	je     6fe36c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x59c>
  6fde23:	48 89 94 24 d8 00 00 	mov    %rdx,0xd8(%rsp)
  6fde2a:	00 
  6fde2b:	4c 89 84 24 e0 00 00 	mov    %r8,0xe0(%rsp)
  6fde32:	00 
  6fde33:	48 89 74 24 48       	mov    %rsi,0x48(%rsp)
  6fde38:	48 89 b4 24 f0 00 00 	mov    %rsi,0xf0(%rsp)
  6fde3f:	00 
  6fde40:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  6fde45:	48 89 8c 24 f8 00 00 	mov    %rcx,0xf8(%rsp)
  6fde4c:	00 
  6fde4d:	49 8b 86 60 06 00 00 	mov    0x660(%r14),%rax
  6fde54:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6fde5b:	00 
  6fde5c:	49 8d ae 10 07 00 00 	lea    0x710(%r14),%rbp
  6fde63:	48 8d 0d ae ca 3f 00 	lea    0x3fcaae(%rip),%rcx        # afa918 <__frame_dummy_init_array_entry+0xb0>
  6fde6a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fde6f:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  6fde76:	00 
  6fde77:	48 89 ea             	mov    %rbp,%rdx
  6fde7a:	ff 15 80 b5 42 00    	call   *0x42b580(%rip)        # b29400 <_DYNAMIC+0x378>
  6fde80:	44 0f b7 7c 24 20    	movzwl 0x20(%rsp),%r15d
  6fde86:	66 41 83 ff ff       	cmp    $0xffff,%r15w
  6fde8b:	0f 84 f6 00 00 00    	je     6fdf87 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x1b7>
  6fde91:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6fde96:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  6fde9b:	8b 74 24 24          	mov    0x24(%rsp),%esi
  6fde9f:	0f b6 7c 24 28       	movzbl 0x28(%rsp),%edi
  6fdea4:	44 0f b6 4c 24 2f    	movzbl 0x2f(%rsp),%r9d
  6fdeaa:	44 0f b7 44 24 2d    	movzwl 0x2d(%rsp),%r8d
  6fdeb0:	8b 4c 24 29          	mov    0x29(%rsp),%ecx
  6fdeb4:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  6fdeb9:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  6fdec0:	00 
  6fdec1:	66 45 85 ff          	test   %r15w,%r15w
  6fdec5:	0f 84 f8 00 00 00    	je     6fdfc3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x1f3>
  6fdecb:	41 c1 e1 10          	shl    $0x10,%r9d
  6fdecf:	45 09 c8             	or     %r9d,%r8d
  6fded2:	49 c1 e0 20          	shl    $0x20,%r8
  6fded6:	4c 09 c1             	or     %r8,%rcx
  6fded9:	89 b4 24 04 01 00 00 	mov    %esi,0x104(%rsp)
  6fdee0:	40 88 bc 24 08 01 00 	mov    %dil,0x108(%rsp)
  6fdee7:	00 
  6fdee8:	89 8c 24 09 01 00 00 	mov    %ecx,0x109(%rsp)
  6fdeef:	48 89 ce             	mov    %rcx,%rsi
  6fdef2:	48 c1 ee 30          	shr    $0x30,%rsi
  6fdef6:	40 88 b4 24 0f 01 00 	mov    %sil,0x10f(%rsp)
  6fdefd:	00 
  6fdefe:	48 c1 e9 20          	shr    $0x20,%rcx
  6fdf02:	66 89 8c 24 0d 01 00 	mov    %cx,0x10d(%rsp)
  6fdf09:	00 
  6fdf0a:	0f 28 84 24 20 01 00 	movaps 0x120(%rsp),%xmm0
  6fdf11:	00 
  6fdf12:	0f 11 84 24 10 01 00 	movups %xmm0,0x110(%rsp)
  6fdf19:	00 
  6fdf1a:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  6fdf21:	49 ff c5             	inc    %r13
  6fdf24:	0f 84 5b 04 00 00    	je     6fe385 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x5b5>
  6fdf2a:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  6fdf31:	0f 85 93 00 00 00    	jne    6fdfca <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x1fa>
  6fdf37:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fdf3c:	4c 89 f6             	mov    %r14,%rsi
  6fdf3f:	e8 dc ac 02 00       	call   728c20 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  6fdf44:	48 83 7c 24 10 fe    	cmpq   $0xfffffffffffffffe,0x10(%rsp)
  6fdf4a:	0f 85 83 00 00 00    	jne    6fdfd3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x203>
  6fdf50:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  6fdf55:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  6fdf5a:	4c 8d 84 24 04 01 00 	lea    0x104(%rsp),%r8
  6fdf61:	00 
  6fdf62:	4c 89 f6             	mov    %r14,%rsi
  6fdf65:	44 89 f9             	mov    %r15d,%ecx
  6fdf68:	e8 13 ce 02 00       	call   72ad80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at>
  6fdf6d:	4d 89 e7             	mov    %r12,%r15
  6fdf70:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  6fdf75:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fdf79:	0f 85 9e 00 00 00    	jne    6fe01d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x24d>
  6fdf7f:	45 31 c0             	xor    %r8d,%r8d
  6fdf82:	e9 bb 00 00 00       	jmp    6fe042 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x272>
  6fdf87:	0f b6 74 24 28       	movzbl 0x28(%rsp),%esi
  6fdf8c:	0f b6 44 24 2f       	movzbl 0x2f(%rsp),%eax
  6fdf91:	c1 e0 10             	shl    $0x10,%eax
  6fdf94:	0f b7 4c 24 2d       	movzwl 0x2d(%rsp),%ecx
  6fdf99:	09 c1                	or     %eax,%ecx
  6fdf9b:	48 c1 e1 20          	shl    $0x20,%rcx
  6fdf9f:	8b 6c 24 29          	mov    0x29(%rsp),%ebp
  6fdfa3:	48 09 cd             	or     %rcx,%rbp
  6fdfa6:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  6fdfab:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  6fdfb2:	00 
  6fdfb3:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fdfb8:	41 bd 20 00 00 00    	mov    $0x20,%r13d
  6fdfbe:	e9 bf 01 00 00       	jmp    6fe182 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x3b2>
  6fdfc3:	31 f6                	xor    %esi,%esi
  6fdfc5:	e9 66 01 00 00       	jmp    6fe130 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x360>
  6fdfca:	48 c7 44 24 10 11 00 	movq   $0x11,0x10(%rsp)
  6fdfd1:	00 00 
  6fdfd3:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fdfd8:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  6fdfdf:	00 
  6fdfe0:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6fdfe5:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  6fdfea:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  6fdfef:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  6fdff4:	0f 29 8c 24 80 00 00 	movaps %xmm1,0x80(%rsp)
  6fdffb:	00 
  6fdffc:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  6fe001:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6fe006:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  6fe00b:	4d 89 e7             	mov    %r12,%r15
  6fe00e:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  6fe013:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fe017:	0f 84 62 ff ff ff    	je     6fdf7f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x1af>
  6fe01d:	4c 89 e1             	mov    %r12,%rcx
  6fe020:	48 83 e9 0d          	sub    $0xd,%rcx
  6fe024:	b8 14 00 00 00       	mov    $0x14,%eax
  6fe029:	48 0f 4d c1          	cmovge %rcx,%rax
  6fe02d:	4c 8d 44 24 60       	lea    0x60(%rsp),%r8
  6fe032:	48 83 f8 17          	cmp    $0x17,%rax
  6fe036:	74 0a                	je     6fe042 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x272>
  6fe038:	48 83 f8 04          	cmp    $0x4,%rax
  6fe03c:	0f 85 f7 00 00 00    	jne    6fe139 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x369>
  6fe042:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  6fe049:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  6fe050:	48 8d 0d c1 c8 3f 00 	lea    0x3fc8c1(%rip),%rcx        # afa918 <__frame_dummy_init_array_entry+0xb0>
  6fe057:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  6fe05e:	00 
  6fe05f:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  6fe066:	00 
  6fe067:	48 89 ea             	mov    %rbp,%rdx
  6fe06a:	ff 15 98 b3 42 00    	call   *0x42b398(%rip)        # b29408 <_DYNAMIC+0x380>
  6fe070:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  6fe075:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  6fe07a:	48 8b b4 24 30 01 00 	mov    0x130(%rsp),%rsi
  6fe081:	00 
  6fe082:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  6fe086:	74 69                	je     6fe0f1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x321>
  6fe088:	48 89 f5             	mov    %rsi,%rbp
  6fe08b:	48 c1 ed 08          	shr    $0x8,%rbp
  6fe08f:	0f 10 84 24 38 01 00 	movups 0x138(%rsp),%xmm0
  6fe096:	00 
  6fe097:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fe09c:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fe0a0:	74 44                	je     6fe0e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x316>
  6fe0a2:	49 83 ec 0d          	sub    $0xd,%r12
  6fe0a6:	ba 14 00 00 00       	mov    $0x14,%edx
  6fe0ab:	49 0f 4d d4          	cmovge %r12,%rdx
  6fe0af:	48 83 fa 19          	cmp    $0x19,%rdx
  6fe0b3:	74 09                	je     6fe0be <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x2ee>
  6fe0b5:	48 89 c8             	mov    %rcx,%rax
  6fe0b8:	48 83 fa 14          	cmp    $0x14,%rdx
  6fe0bc:	75 28                	jne    6fe0e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x316>
  6fe0be:	49 89 f5             	mov    %rsi,%r13
  6fe0c1:	48 8b 30             	mov    (%rax),%rsi
  6fe0c4:	48 85 f6             	test   %rsi,%rsi
  6fe0c7:	74 0f                	je     6fe0d8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x308>
  6fe0c9:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fe0cd:	ba 01 00 00 00       	mov    $0x1,%edx
  6fe0d2:	ff 15 f8 b1 42 00    	call   *0x42b1f8(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fe0d8:	41 bc 20 00 00 00    	mov    $0x20,%r12d
  6fe0de:	4c 89 ee             	mov    %r13,%rsi
  6fe0e1:	e9 96 00 00 00       	jmp    6fe17c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x3ac>
  6fe0e6:	41 bc 20 00 00 00    	mov    $0x20,%r12d
  6fe0ec:	e9 8b 00 00 00       	jmp    6fe17c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x3ac>
  6fe0f1:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fe0f5:	74 33                	je     6fe12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x35a>
  6fe0f7:	49 83 ec 0d          	sub    $0xd,%r12
  6fe0fb:	ba 14 00 00 00       	mov    $0x14,%edx
  6fe100:	49 0f 4d d4          	cmovge %r12,%rdx
  6fe104:	48 83 fa 19          	cmp    $0x19,%rdx
  6fe108:	74 09                	je     6fe113 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x343>
  6fe10a:	48 89 c8             	mov    %rcx,%rax
  6fe10d:	48 83 fa 14          	cmp    $0x14,%rdx
  6fe111:	75 17                	jne    6fe12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x35a>
  6fe113:	48 8b 30             	mov    (%rax),%rsi
  6fe116:	48 85 f6             	test   %rsi,%rsi
  6fe119:	74 0f                	je     6fe12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x35a>
  6fe11b:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fe11f:	ba 01 00 00 00       	mov    $0x1,%edx
  6fe124:	ff 15 a6 b1 42 00    	call   *0x42b1a6(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fe12a:	40 b6 01             	mov    $0x1,%sil
  6fe12d:	4d 89 fc             	mov    %r15,%r12
  6fe130:	49 c7 c5 fe ff ff ff 	mov    $0xfffffffffffffffe,%r13
  6fe137:	eb 49                	jmp    6fe182 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x3b2>
  6fe139:	0f b6 74 24 68       	movzbl 0x68(%rsp),%esi
  6fe13e:	0f b6 44 24 6f       	movzbl 0x6f(%rsp),%eax
  6fe143:	c1 e0 10             	shl    $0x10,%eax
  6fe146:	0f b7 4c 24 6d       	movzwl 0x6d(%rsp),%ecx
  6fe14b:	09 c1                	or     %eax,%ecx
  6fe14d:	48 c1 e1 20          	shl    $0x20,%rcx
  6fe151:	8b 6c 24 69          	mov    0x69(%rsp),%ebp
  6fe155:	48 09 cd             	or     %rcx,%rbp
  6fe158:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  6fe15d:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fe162:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  6fe169:	00 
  6fe16a:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  6fe16f:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  6fe176:	00 
  6fe177:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6fe17c:	4d 89 e5             	mov    %r12,%r13
  6fe17f:	4d 89 fc             	mov    %r15,%r12
  6fe182:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
  6fe187:	40 0f b6 c6          	movzbl %sil,%eax
  6fe18b:	48 c1 e5 08          	shl    $0x8,%rbp
  6fe18f:	48 09 c5             	or     %rax,%rbp
  6fe192:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  6fe197:	0f 28 4c 24 20       	movaps 0x20(%rsp),%xmm1
  6fe19c:	0f 11 84 24 b0 00 00 	movups %xmm0,0xb0(%rsp)
  6fe1a3:	00 
  6fe1a4:	0f 11 8c 24 c0 00 00 	movups %xmm1,0xc0(%rsp)
  6fe1ab:	00 
  6fe1ac:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fe1b1:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fe1b8:	00 
  6fe1b9:	4c 89 ac 24 a0 00 00 	mov    %r13,0xa0(%rsp)
  6fe1c0:	00 
  6fe1c1:	48 89 ac 24 a8 00 00 	mov    %rbp,0xa8(%rsp)
  6fe1c8:	00 
  6fe1c9:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fe1d0:	49 39 f4             	cmp    %rsi,%r12
  6fe1d3:	0f 83 8d 02 00 00    	jae    6fe466 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x696>
  6fe1d9:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6fe1e0:	4c 8d 24 d8          	lea    (%rax,%rbx,8),%r12
  6fe1e4:	4c 8b 7c d8 08       	mov    0x8(%rax,%rbx,8),%r15
  6fe1e9:	4d 85 ff             	test   %r15,%r15
  6fe1ec:	74 28                	je     6fe216 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x446>
  6fe1ee:	48 8b 5c d8 10       	mov    0x10(%rax,%rbx,8),%rbx
  6fe1f3:	48 8b 03             	mov    (%rbx),%rax
  6fe1f6:	48 85 c0             	test   %rax,%rax
  6fe1f9:	74 05                	je     6fe200 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x430>
  6fe1fb:	4c 89 ff             	mov    %r15,%rdi
  6fe1fe:	ff d0                	call   *%rax
  6fe200:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fe204:	48 85 f6             	test   %rsi,%rsi
  6fe207:	74 0d                	je     6fe216 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x446>
  6fe209:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fe20d:	4c 89 ff             	mov    %r15,%rdi
  6fe210:	ff 15 ba b0 42 00    	call   *0x42b0ba(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fe216:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6fe21b:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  6fe220:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fe225:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  6fe22a:	49 83 fd fd          	cmp    $0xfffffffffffffffd,%r13
  6fe22e:	74 35                	je     6fe265 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x495>
  6fe230:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  6fe234:	75 77                	jne    6fe2ad <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x4dd>
  6fe236:	80 7c 24 58 01       	cmpb   $0x1,0x58(%rsp)
  6fe23b:	0f 85 bb 00 00 00    	jne    6fe2fc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x52c>
  6fe241:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6fe246:	4c 89 f6             	mov    %r14,%rsi
  6fe249:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  6fe250:	00 
  6fe251:	31 c9                	xor    %ecx,%ecx
  6fe253:	4c 8b 84 24 e0 00 00 	mov    0xe0(%rsp),%r8
  6fe25a:	00 
  6fe25b:	e8 70 06 00 00       	call   6fe8d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing>
  6fe260:	e9 f5 00 00 00       	jmp    6fe35a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x58a>
  6fe265:	4c 89 f7             	mov    %r14,%rdi
  6fe268:	e8 43 b0 02 00       	call   7292b0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fe26d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fe272:	48 c7 00 0f 00 00 00 	movq   $0xf,(%rax)
  6fe279:	48 8b 9c 24 b0 00 00 	mov    0xb0(%rsp),%rbx
  6fe280:	00 
  6fe281:	48 8b 03             	mov    (%rbx),%rax
  6fe284:	48 85 c0             	test   %rax,%rax
  6fe287:	74 05                	je     6fe28e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x4be>
  6fe289:	48 89 ef             	mov    %rbp,%rdi
  6fe28c:	ff d0                	call   *%rax
  6fe28e:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fe292:	48 85 f6             	test   %rsi,%rsi
  6fe295:	0f 84 bf 00 00 00    	je     6fe35a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x58a>
  6fe29b:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fe29f:	48 89 ef             	mov    %rbp,%rdi
  6fe2a2:	ff 15 28 b0 42 00    	call   *0x42b028(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fe2a8:	e9 ad 00 00 00       	jmp    6fe35a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x58a>
  6fe2ad:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  6fe2b4:	00 
  6fe2b5:	49 39 86 60 06 00 00 	cmp    %rax,0x660(%r14)
  6fe2bc:	74 08                	je     6fe2c6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x4f6>
  6fe2be:	4c 89 f7             	mov    %r14,%rdi
  6fe2c1:	e8 ea af 02 00       	call   7292b0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fe2c6:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  6fe2cd:	00 
  6fe2ce:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fe2d3:	48 89 41 30          	mov    %rax,0x30(%rcx)
  6fe2d7:	0f 10 84 24 a0 00 00 	movups 0xa0(%rsp),%xmm0
  6fe2de:	00 
  6fe2df:	0f 10 8c 24 b0 00 00 	movups 0xb0(%rsp),%xmm1
  6fe2e6:	00 
  6fe2e7:	0f 10 94 24 c0 00 00 	movups 0xc0(%rsp),%xmm2
  6fe2ee:	00 
  6fe2ef:	0f 11 51 20          	movups %xmm2,0x20(%rcx)
  6fe2f3:	0f 11 49 10          	movups %xmm1,0x10(%rcx)
  6fe2f7:	0f 11 01             	movups %xmm0,(%rcx)
  6fe2fa:	eb 5e                	jmp    6fe35a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x58a>
  6fe2fc:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  6fe303:	00 
  6fe304:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  6fe30b:	00 
  6fe30c:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  6fe313:	00 
  6fe314:	74 0e                	je     6fe324 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x554>
  6fe316:	84 c0                	test   %al,%al
  6fe318:	74 0e                	je     6fe328 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x558>
  6fe31a:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  6fe321:	ff 
  6fe322:	75 04                	jne    6fe328 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x558>
  6fe324:	31 c9                	xor    %ecx,%ecx
  6fe326:	eb 0c                	jmp    6fe334 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x564>
  6fe328:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  6fe32f:	b9 01 00 00 00       	mov    $0x1,%ecx
  6fe334:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  6fe33b:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6fe340:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  6fe344:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  6fe348:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  6fe34c:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  6fe350:	88 47 30             	mov    %al,0x30(%rdi)
  6fe353:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  6fe35a:	48 81 c4 48 01 00 00 	add    $0x148,%rsp
  6fe361:	5b                   	pop    %rbx
  6fe362:	41 5c                	pop    %r12
  6fe364:	41 5d                	pop    %r13
  6fe366:	41 5e                	pop    %r14
  6fe368:	41 5f                	pop    %r15
  6fe36a:	5d                   	pop    %rbp
  6fe36b:	c3                   	ret
  6fe36c:	48 8d 3d 92 98 96 ff 	lea    -0x69676e(%rip),%rdi        # 67c05 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x988>
  6fe373:	48 8d 15 66 c9 3f 00 	lea    0x3fc966(%rip),%rdx        # aface0 <__frame_dummy_init_array_entry+0x478>
  6fe37a:	be 0e 00 00 00       	mov    $0xe,%esi
  6fe37f:	ff 15 4b b0 42 00    	call   *0x42b04b(%rip)        # b293d0 <_DYNAMIC+0x348>
  6fe385:	4d 89 e7             	mov    %r12,%r15
  6fe388:	41 bc 1f 00 00 00    	mov    $0x1f,%r12d
  6fe38e:	e9 e9 fd ff ff       	jmp    6fe17c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x3ac>
  6fe393:	48 8d 15 2e c9 3f 00 	lea    0x3fc92e(%rip),%rdx        # afacc8 <__frame_dummy_init_array_entry+0x460>
  6fe39a:	4c 89 e7             	mov    %r12,%rdi
  6fe39d:	ff 15 3d b0 42 00    	call   *0x42b03d(%rip)        # b293e0 <_DYNAMIC+0x358>
  6fe3a3:	49 89 c6             	mov    %rax,%r14
  6fe3a6:	e9 f1 00 00 00       	jmp    6fe49c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6cc>
  6fe3ab:	49 89 c6             	mov    %rax,%r14
  6fe3ae:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fe3b2:	48 85 f6             	test   %rsi,%rsi
  6fe3b5:	0f 84 ee 00 00 00    	je     6fe4a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6d9>
  6fe3bb:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fe3bf:	48 89 ef             	mov    %rbp,%rdi
  6fe3c2:	ff 15 08 af 42 00    	call   *0x42af08(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fe3c8:	4c 89 f7             	mov    %r14,%rdi
  6fe3cb:	e8 e0 b0 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6fe3d0:	49 89 c5             	mov    %rax,%r13
  6fe3d3:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fe3d7:	74 46                	je     6fe41f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x64f>
  6fe3d9:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  6fe3de:	e8 0d 9b ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fe3e3:	eb 3a                	jmp    6fe41f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x64f>
  6fe3e5:	49 89 c6             	mov    %rax,%r14
  6fe3e8:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fe3ec:	48 85 f6             	test   %rsi,%rsi
  6fe3ef:	74 0d                	je     6fe3fe <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x62e>
  6fe3f1:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fe3f5:	4c 89 ff             	mov    %r15,%rdi
  6fe3f8:	ff 15 d2 ae 42 00    	call   *0x42aed2(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fe3fe:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6fe403:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  6fe408:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fe40d:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  6fe412:	eb 7c                	jmp    6fe490 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6c0>
  6fe414:	49 89 c6             	mov    %rax,%r14
  6fe417:	eb 77                	jmp    6fe490 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6c0>
  6fe419:	4d 89 e7             	mov    %r12,%r15
  6fe41c:	49 89 c5             	mov    %rax,%r13
  6fe41f:	4c 89 ef             	mov    %r13,%rdi
  6fe422:	ff 15 c8 af 42 00    	call   *0x42afc8(%rip)        # b293f0 <_DYNAMIC+0x368>
  6fe428:	48 89 c5             	mov    %rax,%rbp
  6fe42b:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  6fe432:	00 
  6fe433:	48 89 94 24 b0 00 00 	mov    %rdx,0xb0(%rsp)
  6fe43a:	00 
  6fe43b:	48 c7 84 24 a0 00 00 	movq   $0xfffffffffffffffd,0xa0(%rsp)
  6fe442:	00 fd ff ff ff 
  6fe447:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fe44c:	4d 89 fc             	mov    %r15,%r12
  6fe44f:	49 c7 c5 fd ff ff ff 	mov    $0xfffffffffffffffd,%r13
  6fe456:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fe45d:	49 39 f4             	cmp    %rsi,%r12
  6fe460:	0f 82 73 fd ff ff    	jb     6fe1d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x409>
  6fe466:	48 8d 15 8b c8 3f 00 	lea    0x3fc88b(%rip),%rdx        # afacf8 <__frame_dummy_init_array_entry+0x490>
  6fe46d:	4c 89 e7             	mov    %r12,%rdi
  6fe470:	ff 15 6a af 42 00    	call   *0x42af6a(%rip)        # b293e0 <_DYNAMIC+0x358>
  6fe476:	0f 0b                	ud2
  6fe478:	ff 15 7a af 42 00    	call   *0x42af7a(%rip)        # b293f8 <_DYNAMIC+0x370>
  6fe47e:	49 89 c6             	mov    %rax,%r14
  6fe481:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  6fe486:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6fe48b:	e8 e0 63 ff ff       	call   6f4870 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  6fe490:	49 83 fd fd          	cmp    $0xfffffffffffffffd,%r13
  6fe494:	74 1b                	je     6fe4b1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6e1>
  6fe496:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  6fe49a:	74 0d                	je     6fe4a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6d9>
  6fe49c:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  6fe4a3:	00 
  6fe4a4:	e8 47 9a ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fe4a9:	4c 89 f7             	mov    %r14,%rdi
  6fe4ac:	e8 ff af 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6fe4b1:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  6fe4b8:	00 
  6fe4b9:	e8 52 68 ff ff       	call   6f4d10 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe4be:	eb e9                	jmp    6fe4a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6d9>
  6fe4c0:	ff 15 3a ae 42 00    	call   *0x42ae3a(%rip)        # b29300 <_DYNAMIC+0x278>
