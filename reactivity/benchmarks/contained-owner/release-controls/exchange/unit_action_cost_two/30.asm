
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fadd0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property>:
  6fadd0:	55                   	push   %rbp
  6fadd1:	41 57                	push   %r15
  6fadd3:	41 56                	push   %r14
  6fadd5:	41 55                	push   %r13
  6fadd7:	41 54                	push   %r12
  6fadd9:	53                   	push   %rbx
  6fadda:	48 81 ec 48 01 00 00 	sub    $0x148,%rsp
  6fade1:	49 89 cc             	mov    %rcx,%r12
  6fade4:	49 89 f6             	mov    %rsi,%r14
  6fade7:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  6fadec:	48 8b b6 a0 02 00 00 	mov    0x2a0(%rsi),%rsi
  6fadf3:	48 39 f1             	cmp    %rsi,%rcx
  6fadf6:	0f 83 97 05 00 00    	jae    6fb393 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x5c3>
  6fadfc:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6fae03:	4b 8d 1c a4          	lea    (%r12,%r12,4),%rbx
  6fae07:	48 8b 74 d8 08       	mov    0x8(%rax,%rbx,8),%rsi
  6fae0c:	48 8b 4c d8 10       	mov    0x10(%rax,%rbx,8),%rcx
  6fae11:	48 c7 44 d8 08 00 00 	movq   $0x0,0x8(%rax,%rbx,8)
  6fae18:	00 00 
  6fae1a:	48 85 f6             	test   %rsi,%rsi
  6fae1d:	0f 84 49 05 00 00    	je     6fb36c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x59c>
  6fae23:	48 89 94 24 d8 00 00 	mov    %rdx,0xd8(%rsp)
  6fae2a:	00 
  6fae2b:	4c 89 84 24 e0 00 00 	mov    %r8,0xe0(%rsp)
  6fae32:	00 
  6fae33:	48 89 74 24 48       	mov    %rsi,0x48(%rsp)
  6fae38:	48 89 b4 24 f0 00 00 	mov    %rsi,0xf0(%rsp)
  6fae3f:	00 
  6fae40:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  6fae45:	48 89 8c 24 f8 00 00 	mov    %rcx,0xf8(%rsp)
  6fae4c:	00 
  6fae4d:	49 8b 86 60 06 00 00 	mov    0x660(%r14),%rax
  6fae54:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6fae5b:	00 
  6fae5c:	49 8d ae 10 07 00 00 	lea    0x710(%r14),%rbp
  6fae63:	48 8d 0d 6e fa 3f 00 	lea    0x3ffa6e(%rip),%rcx        # afa8d8 <__frame_dummy_init_array_entry+0x70>
  6fae6a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fae6f:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  6fae76:	00 
  6fae77:	48 89 ea             	mov    %rbp,%rdx
  6fae7a:	ff 15 80 e5 42 00    	call   *0x42e580(%rip)        # b29400 <_DYNAMIC+0x378>
  6fae80:	44 0f b7 7c 24 20    	movzwl 0x20(%rsp),%r15d
  6fae86:	66 41 83 ff ff       	cmp    $0xffff,%r15w
  6fae8b:	0f 84 f6 00 00 00    	je     6faf87 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x1b7>
  6fae91:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6fae96:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  6fae9b:	8b 74 24 24          	mov    0x24(%rsp),%esi
  6fae9f:	0f b6 7c 24 28       	movzbl 0x28(%rsp),%edi
  6faea4:	44 0f b6 4c 24 2f    	movzbl 0x2f(%rsp),%r9d
  6faeaa:	44 0f b7 44 24 2d    	movzwl 0x2d(%rsp),%r8d
  6faeb0:	8b 4c 24 29          	mov    0x29(%rsp),%ecx
  6faeb4:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  6faeb9:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  6faec0:	00 
  6faec1:	66 45 85 ff          	test   %r15w,%r15w
  6faec5:	0f 84 f8 00 00 00    	je     6fafc3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x1f3>
  6faecb:	41 c1 e1 10          	shl    $0x10,%r9d
  6faecf:	45 09 c8             	or     %r9d,%r8d
  6faed2:	49 c1 e0 20          	shl    $0x20,%r8
  6faed6:	4c 09 c1             	or     %r8,%rcx
  6faed9:	89 b4 24 04 01 00 00 	mov    %esi,0x104(%rsp)
  6faee0:	40 88 bc 24 08 01 00 	mov    %dil,0x108(%rsp)
  6faee7:	00 
  6faee8:	89 8c 24 09 01 00 00 	mov    %ecx,0x109(%rsp)
  6faeef:	48 89 ce             	mov    %rcx,%rsi
  6faef2:	48 c1 ee 30          	shr    $0x30,%rsi
  6faef6:	40 88 b4 24 0f 01 00 	mov    %sil,0x10f(%rsp)
  6faefd:	00 
  6faefe:	48 c1 e9 20          	shr    $0x20,%rcx
  6faf02:	66 89 8c 24 0d 01 00 	mov    %cx,0x10d(%rsp)
  6faf09:	00 
  6faf0a:	0f 28 84 24 20 01 00 	movaps 0x120(%rsp),%xmm0
  6faf11:	00 
  6faf12:	0f 11 84 24 10 01 00 	movups %xmm0,0x110(%rsp)
  6faf19:	00 
  6faf1a:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  6faf21:	49 ff c5             	inc    %r13
  6faf24:	0f 84 5b 04 00 00    	je     6fb385 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x5b5>
  6faf2a:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  6faf31:	0f 85 93 00 00 00    	jne    6fafca <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x1fa>
  6faf37:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6faf3c:	4c 89 f6             	mov    %r14,%rsi
  6faf3f:	e8 3c f4 01 00       	call   71a380 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  6faf44:	48 83 7c 24 10 fe    	cmpq   $0xfffffffffffffffe,0x10(%rsp)
  6faf4a:	0f 85 83 00 00 00    	jne    6fafd3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x203>
  6faf50:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  6faf55:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  6faf5a:	4c 8d 84 24 04 01 00 	lea    0x104(%rsp),%r8
  6faf61:	00 
  6faf62:	4c 89 f6             	mov    %r14,%rsi
  6faf65:	44 89 f9             	mov    %r15d,%ecx
  6faf68:	e8 83 ef 02 00       	call   729ef0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at>
  6faf6d:	4d 89 e7             	mov    %r12,%r15
  6faf70:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  6faf75:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6faf79:	0f 85 9e 00 00 00    	jne    6fb01d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x24d>
  6faf7f:	45 31 c0             	xor    %r8d,%r8d
  6faf82:	e9 bb 00 00 00       	jmp    6fb042 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x272>
  6faf87:	0f b6 74 24 28       	movzbl 0x28(%rsp),%esi
  6faf8c:	0f b6 44 24 2f       	movzbl 0x2f(%rsp),%eax
  6faf91:	c1 e0 10             	shl    $0x10,%eax
  6faf94:	0f b7 4c 24 2d       	movzwl 0x2d(%rsp),%ecx
  6faf99:	09 c1                	or     %eax,%ecx
  6faf9b:	48 c1 e1 20          	shl    $0x20,%rcx
  6faf9f:	8b 6c 24 29          	mov    0x29(%rsp),%ebp
  6fafa3:	48 09 cd             	or     %rcx,%rbp
  6fafa6:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  6fafab:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  6fafb2:	00 
  6fafb3:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fafb8:	41 bd 20 00 00 00    	mov    $0x20,%r13d
  6fafbe:	e9 bf 01 00 00       	jmp    6fb182 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x3b2>
  6fafc3:	31 f6                	xor    %esi,%esi
  6fafc5:	e9 66 01 00 00       	jmp    6fb130 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x360>
  6fafca:	48 c7 44 24 10 11 00 	movq   $0x11,0x10(%rsp)
  6fafd1:	00 00 
  6fafd3:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fafd8:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  6fafdf:	00 
  6fafe0:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6fafe5:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  6fafea:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  6fafef:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  6faff4:	0f 29 8c 24 80 00 00 	movaps %xmm1,0x80(%rsp)
  6faffb:	00 
  6faffc:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  6fb001:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6fb006:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  6fb00b:	4d 89 e7             	mov    %r12,%r15
  6fb00e:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  6fb013:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fb017:	0f 84 62 ff ff ff    	je     6faf7f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x1af>
  6fb01d:	4c 89 e1             	mov    %r12,%rcx
  6fb020:	48 83 e9 0d          	sub    $0xd,%rcx
  6fb024:	b8 14 00 00 00       	mov    $0x14,%eax
  6fb029:	48 0f 4d c1          	cmovge %rcx,%rax
  6fb02d:	4c 8d 44 24 60       	lea    0x60(%rsp),%r8
  6fb032:	48 83 f8 17          	cmp    $0x17,%rax
  6fb036:	74 0a                	je     6fb042 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x272>
  6fb038:	48 83 f8 04          	cmp    $0x4,%rax
  6fb03c:	0f 85 f7 00 00 00    	jne    6fb139 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x369>
  6fb042:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  6fb049:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  6fb050:	48 8d 0d 81 f8 3f 00 	lea    0x3ff881(%rip),%rcx        # afa8d8 <__frame_dummy_init_array_entry+0x70>
  6fb057:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  6fb05e:	00 
  6fb05f:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  6fb066:	00 
  6fb067:	48 89 ea             	mov    %rbp,%rdx
  6fb06a:	ff 15 98 e3 42 00    	call   *0x42e398(%rip)        # b29408 <_DYNAMIC+0x380>
  6fb070:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  6fb075:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  6fb07a:	48 8b b4 24 30 01 00 	mov    0x130(%rsp),%rsi
  6fb081:	00 
  6fb082:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  6fb086:	74 69                	je     6fb0f1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x321>
  6fb088:	48 89 f5             	mov    %rsi,%rbp
  6fb08b:	48 c1 ed 08          	shr    $0x8,%rbp
  6fb08f:	0f 10 84 24 38 01 00 	movups 0x138(%rsp),%xmm0
  6fb096:	00 
  6fb097:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fb09c:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fb0a0:	74 44                	je     6fb0e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x316>
  6fb0a2:	49 83 ec 0d          	sub    $0xd,%r12
  6fb0a6:	ba 14 00 00 00       	mov    $0x14,%edx
  6fb0ab:	49 0f 4d d4          	cmovge %r12,%rdx
  6fb0af:	48 83 fa 19          	cmp    $0x19,%rdx
  6fb0b3:	74 09                	je     6fb0be <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x2ee>
  6fb0b5:	48 89 c8             	mov    %rcx,%rax
  6fb0b8:	48 83 fa 14          	cmp    $0x14,%rdx
  6fb0bc:	75 28                	jne    6fb0e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x316>
  6fb0be:	49 89 f5             	mov    %rsi,%r13
  6fb0c1:	48 8b 30             	mov    (%rax),%rsi
  6fb0c4:	48 85 f6             	test   %rsi,%rsi
  6fb0c7:	74 0f                	je     6fb0d8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x308>
  6fb0c9:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fb0cd:	ba 01 00 00 00       	mov    $0x1,%edx
  6fb0d2:	ff 15 f8 e1 42 00    	call   *0x42e1f8(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fb0d8:	41 bc 20 00 00 00    	mov    $0x20,%r12d
  6fb0de:	4c 89 ee             	mov    %r13,%rsi
  6fb0e1:	e9 96 00 00 00       	jmp    6fb17c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x3ac>
  6fb0e6:	41 bc 20 00 00 00    	mov    $0x20,%r12d
  6fb0ec:	e9 8b 00 00 00       	jmp    6fb17c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x3ac>
  6fb0f1:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fb0f5:	74 33                	je     6fb12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x35a>
  6fb0f7:	49 83 ec 0d          	sub    $0xd,%r12
  6fb0fb:	ba 14 00 00 00       	mov    $0x14,%edx
  6fb100:	49 0f 4d d4          	cmovge %r12,%rdx
  6fb104:	48 83 fa 19          	cmp    $0x19,%rdx
  6fb108:	74 09                	je     6fb113 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x343>
  6fb10a:	48 89 c8             	mov    %rcx,%rax
  6fb10d:	48 83 fa 14          	cmp    $0x14,%rdx
  6fb111:	75 17                	jne    6fb12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x35a>
  6fb113:	48 8b 30             	mov    (%rax),%rsi
  6fb116:	48 85 f6             	test   %rsi,%rsi
  6fb119:	74 0f                	je     6fb12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x35a>
  6fb11b:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fb11f:	ba 01 00 00 00       	mov    $0x1,%edx
  6fb124:	ff 15 a6 e1 42 00    	call   *0x42e1a6(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fb12a:	40 b6 01             	mov    $0x1,%sil
  6fb12d:	4d 89 fc             	mov    %r15,%r12
  6fb130:	49 c7 c5 fe ff ff ff 	mov    $0xfffffffffffffffe,%r13
  6fb137:	eb 49                	jmp    6fb182 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x3b2>
  6fb139:	0f b6 74 24 68       	movzbl 0x68(%rsp),%esi
  6fb13e:	0f b6 44 24 6f       	movzbl 0x6f(%rsp),%eax
  6fb143:	c1 e0 10             	shl    $0x10,%eax
  6fb146:	0f b7 4c 24 6d       	movzwl 0x6d(%rsp),%ecx
  6fb14b:	09 c1                	or     %eax,%ecx
  6fb14d:	48 c1 e1 20          	shl    $0x20,%rcx
  6fb151:	8b 6c 24 69          	mov    0x69(%rsp),%ebp
  6fb155:	48 09 cd             	or     %rcx,%rbp
  6fb158:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  6fb15d:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fb162:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  6fb169:	00 
  6fb16a:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  6fb16f:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  6fb176:	00 
  6fb177:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6fb17c:	4d 89 e5             	mov    %r12,%r13
  6fb17f:	4d 89 fc             	mov    %r15,%r12
  6fb182:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
  6fb187:	40 0f b6 c6          	movzbl %sil,%eax
  6fb18b:	48 c1 e5 08          	shl    $0x8,%rbp
  6fb18f:	48 09 c5             	or     %rax,%rbp
  6fb192:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  6fb197:	0f 28 4c 24 20       	movaps 0x20(%rsp),%xmm1
  6fb19c:	0f 11 84 24 b0 00 00 	movups %xmm0,0xb0(%rsp)
  6fb1a3:	00 
  6fb1a4:	0f 11 8c 24 c0 00 00 	movups %xmm1,0xc0(%rsp)
  6fb1ab:	00 
  6fb1ac:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fb1b1:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fb1b8:	00 
  6fb1b9:	4c 89 ac 24 a0 00 00 	mov    %r13,0xa0(%rsp)
  6fb1c0:	00 
  6fb1c1:	48 89 ac 24 a8 00 00 	mov    %rbp,0xa8(%rsp)
  6fb1c8:	00 
  6fb1c9:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fb1d0:	49 39 f4             	cmp    %rsi,%r12
  6fb1d3:	0f 83 8d 02 00 00    	jae    6fb466 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x696>
  6fb1d9:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6fb1e0:	4c 8d 24 d8          	lea    (%rax,%rbx,8),%r12
  6fb1e4:	4c 8b 7c d8 08       	mov    0x8(%rax,%rbx,8),%r15
  6fb1e9:	4d 85 ff             	test   %r15,%r15
  6fb1ec:	74 28                	je     6fb216 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x446>
  6fb1ee:	48 8b 5c d8 10       	mov    0x10(%rax,%rbx,8),%rbx
  6fb1f3:	48 8b 03             	mov    (%rbx),%rax
  6fb1f6:	48 85 c0             	test   %rax,%rax
  6fb1f9:	74 05                	je     6fb200 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x430>
  6fb1fb:	4c 89 ff             	mov    %r15,%rdi
  6fb1fe:	ff d0                	call   *%rax
  6fb200:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fb204:	48 85 f6             	test   %rsi,%rsi
  6fb207:	74 0d                	je     6fb216 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x446>
  6fb209:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fb20d:	4c 89 ff             	mov    %r15,%rdi
  6fb210:	ff 15 ba e0 42 00    	call   *0x42e0ba(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fb216:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6fb21b:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  6fb220:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fb225:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  6fb22a:	49 83 fd fd          	cmp    $0xfffffffffffffffd,%r13
  6fb22e:	74 35                	je     6fb265 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x495>
  6fb230:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  6fb234:	75 77                	jne    6fb2ad <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x4dd>
  6fb236:	80 7c 24 58 01       	cmpb   $0x1,0x58(%rsp)
  6fb23b:	0f 85 bb 00 00 00    	jne    6fb2fc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x52c>
  6fb241:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6fb246:	4c 89 f6             	mov    %r14,%rsi
  6fb249:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  6fb250:	00 
  6fb251:	31 c9                	xor    %ecx,%ecx
  6fb253:	4c 8b 84 24 e0 00 00 	mov    0xe0(%rsp),%r8
  6fb25a:	00 
  6fb25b:	e8 70 06 00 00       	call   6fb8d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing>
  6fb260:	e9 f5 00 00 00       	jmp    6fb35a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x58a>
  6fb265:	4c 89 f7             	mov    %r14,%rdi
  6fb268:	e8 a3 f7 01 00       	call   71aa10 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fb26d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fb272:	48 c7 00 0f 00 00 00 	movq   $0xf,(%rax)
  6fb279:	48 8b 9c 24 b0 00 00 	mov    0xb0(%rsp),%rbx
  6fb280:	00 
  6fb281:	48 8b 03             	mov    (%rbx),%rax
  6fb284:	48 85 c0             	test   %rax,%rax
  6fb287:	74 05                	je     6fb28e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x4be>
  6fb289:	48 89 ef             	mov    %rbp,%rdi
  6fb28c:	ff d0                	call   *%rax
  6fb28e:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fb292:	48 85 f6             	test   %rsi,%rsi
  6fb295:	0f 84 bf 00 00 00    	je     6fb35a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x58a>
  6fb29b:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fb29f:	48 89 ef             	mov    %rbp,%rdi
  6fb2a2:	ff 15 28 e0 42 00    	call   *0x42e028(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fb2a8:	e9 ad 00 00 00       	jmp    6fb35a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x58a>
  6fb2ad:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  6fb2b4:	00 
  6fb2b5:	49 39 86 60 06 00 00 	cmp    %rax,0x660(%r14)
  6fb2bc:	74 08                	je     6fb2c6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x4f6>
  6fb2be:	4c 89 f7             	mov    %r14,%rdi
  6fb2c1:	e8 4a f7 01 00       	call   71aa10 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fb2c6:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  6fb2cd:	00 
  6fb2ce:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fb2d3:	48 89 41 30          	mov    %rax,0x30(%rcx)
  6fb2d7:	0f 10 84 24 a0 00 00 	movups 0xa0(%rsp),%xmm0
  6fb2de:	00 
  6fb2df:	0f 10 8c 24 b0 00 00 	movups 0xb0(%rsp),%xmm1
  6fb2e6:	00 
  6fb2e7:	0f 10 94 24 c0 00 00 	movups 0xc0(%rsp),%xmm2
  6fb2ee:	00 
  6fb2ef:	0f 11 51 20          	movups %xmm2,0x20(%rcx)
  6fb2f3:	0f 11 49 10          	movups %xmm1,0x10(%rcx)
  6fb2f7:	0f 11 01             	movups %xmm0,(%rcx)
  6fb2fa:	eb 5e                	jmp    6fb35a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x58a>
  6fb2fc:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  6fb303:	00 
  6fb304:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  6fb30b:	00 
  6fb30c:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  6fb313:	00 
  6fb314:	74 0e                	je     6fb324 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x554>
  6fb316:	84 c0                	test   %al,%al
  6fb318:	74 0e                	je     6fb328 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x558>
  6fb31a:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  6fb321:	ff 
  6fb322:	75 04                	jne    6fb328 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x558>
  6fb324:	31 c9                	xor    %ecx,%ecx
  6fb326:	eb 0c                	jmp    6fb334 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x564>
  6fb328:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  6fb32f:	b9 01 00 00 00       	mov    $0x1,%ecx
  6fb334:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  6fb33b:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6fb340:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  6fb344:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  6fb348:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  6fb34c:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  6fb350:	88 47 30             	mov    %al,0x30(%rdi)
  6fb353:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  6fb35a:	48 81 c4 48 01 00 00 	add    $0x148,%rsp
  6fb361:	5b                   	pop    %rbx
  6fb362:	41 5c                	pop    %r12
  6fb364:	41 5d                	pop    %r13
  6fb366:	41 5e                	pop    %r14
  6fb368:	41 5f                	pop    %r15
  6fb36a:	5d                   	pop    %rbp
  6fb36b:	c3                   	ret
  6fb36c:	48 8d 3d 92 c8 96 ff 	lea    -0x69376e(%rip),%rdi        # 67c05 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x988>
  6fb373:	48 8d 15 66 f9 3f 00 	lea    0x3ff966(%rip),%rdx        # aface0 <__frame_dummy_init_array_entry+0x478>
  6fb37a:	be 0e 00 00 00       	mov    $0xe,%esi
  6fb37f:	ff 15 4b e0 42 00    	call   *0x42e04b(%rip)        # b293d0 <_DYNAMIC+0x348>
  6fb385:	4d 89 e7             	mov    %r12,%r15
  6fb388:	41 bc 1f 00 00 00    	mov    $0x1f,%r12d
  6fb38e:	e9 e9 fd ff ff       	jmp    6fb17c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x3ac>
  6fb393:	48 8d 15 2e f9 3f 00 	lea    0x3ff92e(%rip),%rdx        # afacc8 <__frame_dummy_init_array_entry+0x460>
  6fb39a:	4c 89 e7             	mov    %r12,%rdi
  6fb39d:	ff 15 3d e0 42 00    	call   *0x42e03d(%rip)        # b293e0 <_DYNAMIC+0x358>
  6fb3a3:	49 89 c6             	mov    %rax,%r14
  6fb3a6:	e9 f1 00 00 00       	jmp    6fb49c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6cc>
  6fb3ab:	49 89 c6             	mov    %rax,%r14
  6fb3ae:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fb3b2:	48 85 f6             	test   %rsi,%rsi
  6fb3b5:	0f 84 ee 00 00 00    	je     6fb4a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6d9>
  6fb3bb:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fb3bf:	48 89 ef             	mov    %rbp,%rdi
  6fb3c2:	ff 15 08 df 42 00    	call   *0x42df08(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fb3c8:	4c 89 f7             	mov    %r14,%rdi
  6fb3cb:	e8 e0 e0 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6fb3d0:	49 89 c5             	mov    %rax,%r13
  6fb3d3:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fb3d7:	74 46                	je     6fb41f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x64f>
  6fb3d9:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  6fb3de:	e8 0d cb ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fb3e3:	eb 3a                	jmp    6fb41f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x64f>
  6fb3e5:	49 89 c6             	mov    %rax,%r14
  6fb3e8:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fb3ec:	48 85 f6             	test   %rsi,%rsi
  6fb3ef:	74 0d                	je     6fb3fe <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x62e>
  6fb3f1:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fb3f5:	4c 89 ff             	mov    %r15,%rdi
  6fb3f8:	ff 15 d2 de 42 00    	call   *0x42ded2(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fb3fe:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6fb403:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  6fb408:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fb40d:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  6fb412:	eb 7c                	jmp    6fb490 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6c0>
  6fb414:	49 89 c6             	mov    %rax,%r14
  6fb417:	eb 77                	jmp    6fb490 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6c0>
  6fb419:	4d 89 e7             	mov    %r12,%r15
  6fb41c:	49 89 c5             	mov    %rax,%r13
  6fb41f:	4c 89 ef             	mov    %r13,%rdi
  6fb422:	ff 15 c8 df 42 00    	call   *0x42dfc8(%rip)        # b293f0 <_DYNAMIC+0x368>
  6fb428:	48 89 c5             	mov    %rax,%rbp
  6fb42b:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  6fb432:	00 
  6fb433:	48 89 94 24 b0 00 00 	mov    %rdx,0xb0(%rsp)
  6fb43a:	00 
  6fb43b:	48 c7 84 24 a0 00 00 	movq   $0xfffffffffffffffd,0xa0(%rsp)
  6fb442:	00 fd ff ff ff 
  6fb447:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fb44c:	4d 89 fc             	mov    %r15,%r12
  6fb44f:	49 c7 c5 fd ff ff ff 	mov    $0xfffffffffffffffd,%r13
  6fb456:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fb45d:	49 39 f4             	cmp    %rsi,%r12
  6fb460:	0f 82 73 fd ff ff    	jb     6fb1d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x409>
  6fb466:	48 8d 15 8b f8 3f 00 	lea    0x3ff88b(%rip),%rdx        # afacf8 <__frame_dummy_init_array_entry+0x490>
  6fb46d:	4c 89 e7             	mov    %r12,%rdi
  6fb470:	ff 15 6a df 42 00    	call   *0x42df6a(%rip)        # b293e0 <_DYNAMIC+0x358>
  6fb476:	0f 0b                	ud2
  6fb478:	ff 15 7a df 42 00    	call   *0x42df7a(%rip)        # b293f8 <_DYNAMIC+0x370>
  6fb47e:	49 89 c6             	mov    %rax,%r14
  6fb481:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  6fb486:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6fb48b:	e8 e0 93 ff ff       	call   6f4870 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  6fb490:	49 83 fd fd          	cmp    $0xfffffffffffffffd,%r13
  6fb494:	74 1b                	je     6fb4b1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6e1>
  6fb496:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  6fb49a:	74 0d                	je     6fb4a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6d9>
  6fb49c:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  6fb4a3:	00 
  6fb4a4:	e8 47 ca ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fb4a9:	4c 89 f7             	mov    %r14,%rdi
  6fb4ac:	e8 ff df 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6fb4b1:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  6fb4b8:	00 
  6fb4b9:	e8 52 98 ff ff       	call   6f4d10 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb4be:	eb e9                	jmp    6fb4a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6d9>
  6fb4c0:	ff 15 3a de 42 00    	call   *0x42de3a(%rip)        # b29300 <_DYNAMIC+0x278>
