
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006faed0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property>:
  6faed0:	55                   	push   %rbp
  6faed1:	41 57                	push   %r15
  6faed3:	41 56                	push   %r14
  6faed5:	41 55                	push   %r13
  6faed7:	41 54                	push   %r12
  6faed9:	53                   	push   %rbx
  6faeda:	48 81 ec 48 01 00 00 	sub    $0x148,%rsp
  6faee1:	49 89 cc             	mov    %rcx,%r12
  6faee4:	49 89 f6             	mov    %rsi,%r14
  6faee7:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  6faeec:	48 8b b6 a0 02 00 00 	mov    0x2a0(%rsi),%rsi
  6faef3:	48 39 f1             	cmp    %rsi,%rcx
  6faef6:	0f 83 97 05 00 00    	jae    6fb493 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x5c3>
  6faefc:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6faf03:	4b 8d 1c a4          	lea    (%r12,%r12,4),%rbx
  6faf07:	48 8b 74 d8 08       	mov    0x8(%rax,%rbx,8),%rsi
  6faf0c:	48 8b 4c d8 10       	mov    0x10(%rax,%rbx,8),%rcx
  6faf11:	48 c7 44 d8 08 00 00 	movq   $0x0,0x8(%rax,%rbx,8)
  6faf18:	00 00 
  6faf1a:	48 85 f6             	test   %rsi,%rsi
  6faf1d:	0f 84 49 05 00 00    	je     6fb46c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x59c>
  6faf23:	48 89 94 24 d8 00 00 	mov    %rdx,0xd8(%rsp)
  6faf2a:	00 
  6faf2b:	4c 89 84 24 e0 00 00 	mov    %r8,0xe0(%rsp)
  6faf32:	00 
  6faf33:	48 89 74 24 48       	mov    %rsi,0x48(%rsp)
  6faf38:	48 89 b4 24 f0 00 00 	mov    %rsi,0xf0(%rsp)
  6faf3f:	00 
  6faf40:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  6faf45:	48 89 8c 24 f8 00 00 	mov    %rcx,0xf8(%rsp)
  6faf4c:	00 
  6faf4d:	49 8b 86 60 06 00 00 	mov    0x660(%r14),%rax
  6faf54:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6faf5b:	00 
  6faf5c:	49 8d ae 10 07 00 00 	lea    0x710(%r14),%rbp
  6faf63:	48 8d 0d 0e fa 3f 00 	lea    0x3ffa0e(%rip),%rcx        # afa978 <__frame_dummy_init_array_entry+0x70>
  6faf6a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6faf6f:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  6faf76:	00 
  6faf77:	48 89 ea             	mov    %rbp,%rdx
  6faf7a:	ff 15 68 e5 42 00    	call   *0x42e568(%rip)        # b294e8 <_DYNAMIC+0x378>
  6faf80:	44 0f b7 7c 24 20    	movzwl 0x20(%rsp),%r15d
  6faf86:	66 41 83 ff ff       	cmp    $0xffff,%r15w
  6faf8b:	0f 84 f6 00 00 00    	je     6fb087 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x1b7>
  6faf91:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6faf96:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  6faf9b:	8b 74 24 24          	mov    0x24(%rsp),%esi
  6faf9f:	0f b6 7c 24 28       	movzbl 0x28(%rsp),%edi
  6fafa4:	44 0f b6 4c 24 2f    	movzbl 0x2f(%rsp),%r9d
  6fafaa:	44 0f b7 44 24 2d    	movzwl 0x2d(%rsp),%r8d
  6fafb0:	8b 4c 24 29          	mov    0x29(%rsp),%ecx
  6fafb4:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  6fafb9:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  6fafc0:	00 
  6fafc1:	66 45 85 ff          	test   %r15w,%r15w
  6fafc5:	0f 84 f8 00 00 00    	je     6fb0c3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x1f3>
  6fafcb:	41 c1 e1 10          	shl    $0x10,%r9d
  6fafcf:	45 09 c8             	or     %r9d,%r8d
  6fafd2:	49 c1 e0 20          	shl    $0x20,%r8
  6fafd6:	4c 09 c1             	or     %r8,%rcx
  6fafd9:	89 b4 24 04 01 00 00 	mov    %esi,0x104(%rsp)
  6fafe0:	40 88 bc 24 08 01 00 	mov    %dil,0x108(%rsp)
  6fafe7:	00 
  6fafe8:	89 8c 24 09 01 00 00 	mov    %ecx,0x109(%rsp)
  6fafef:	48 89 ce             	mov    %rcx,%rsi
  6faff2:	48 c1 ee 30          	shr    $0x30,%rsi
  6faff6:	40 88 b4 24 0f 01 00 	mov    %sil,0x10f(%rsp)
  6faffd:	00 
  6faffe:	48 c1 e9 20          	shr    $0x20,%rcx
  6fb002:	66 89 8c 24 0d 01 00 	mov    %cx,0x10d(%rsp)
  6fb009:	00 
  6fb00a:	0f 28 84 24 20 01 00 	movaps 0x120(%rsp),%xmm0
  6fb011:	00 
  6fb012:	0f 11 84 24 10 01 00 	movups %xmm0,0x110(%rsp)
  6fb019:	00 
  6fb01a:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  6fb021:	49 ff c5             	inc    %r13
  6fb024:	0f 84 5b 04 00 00    	je     6fb485 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x5b5>
  6fb02a:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  6fb031:	0f 85 93 00 00 00    	jne    6fb0ca <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x1fa>
  6fb037:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fb03c:	4c 89 f6             	mov    %r14,%rsi
  6fb03f:	e8 3c f4 01 00       	call   71a480 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  6fb044:	48 83 7c 24 10 fe    	cmpq   $0xfffffffffffffffe,0x10(%rsp)
  6fb04a:	0f 85 83 00 00 00    	jne    6fb0d3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x203>
  6fb050:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  6fb055:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  6fb05a:	4c 8d 84 24 04 01 00 	lea    0x104(%rsp),%r8
  6fb061:	00 
  6fb062:	4c 89 f6             	mov    %r14,%rsi
  6fb065:	44 89 f9             	mov    %r15d,%ecx
  6fb068:	e8 83 ef 02 00       	call   729ff0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at>
  6fb06d:	4d 89 e7             	mov    %r12,%r15
  6fb070:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  6fb075:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fb079:	0f 85 9e 00 00 00    	jne    6fb11d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x24d>
  6fb07f:	45 31 c0             	xor    %r8d,%r8d
  6fb082:	e9 bb 00 00 00       	jmp    6fb142 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x272>
  6fb087:	0f b6 74 24 28       	movzbl 0x28(%rsp),%esi
  6fb08c:	0f b6 44 24 2f       	movzbl 0x2f(%rsp),%eax
  6fb091:	c1 e0 10             	shl    $0x10,%eax
  6fb094:	0f b7 4c 24 2d       	movzwl 0x2d(%rsp),%ecx
  6fb099:	09 c1                	or     %eax,%ecx
  6fb09b:	48 c1 e1 20          	shl    $0x20,%rcx
  6fb09f:	8b 6c 24 29          	mov    0x29(%rsp),%ebp
  6fb0a3:	48 09 cd             	or     %rcx,%rbp
  6fb0a6:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  6fb0ab:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  6fb0b2:	00 
  6fb0b3:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fb0b8:	41 bd 20 00 00 00    	mov    $0x20,%r13d
  6fb0be:	e9 bf 01 00 00       	jmp    6fb282 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x3b2>
  6fb0c3:	31 f6                	xor    %esi,%esi
  6fb0c5:	e9 66 01 00 00       	jmp    6fb230 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x360>
  6fb0ca:	48 c7 44 24 10 11 00 	movq   $0x11,0x10(%rsp)
  6fb0d1:	00 00 
  6fb0d3:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fb0d8:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  6fb0df:	00 
  6fb0e0:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6fb0e5:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  6fb0ea:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  6fb0ef:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  6fb0f4:	0f 29 8c 24 80 00 00 	movaps %xmm1,0x80(%rsp)
  6fb0fb:	00 
  6fb0fc:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  6fb101:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6fb106:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  6fb10b:	4d 89 e7             	mov    %r12,%r15
  6fb10e:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  6fb113:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fb117:	0f 84 62 ff ff ff    	je     6fb07f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x1af>
  6fb11d:	4c 89 e1             	mov    %r12,%rcx
  6fb120:	48 83 e9 0d          	sub    $0xd,%rcx
  6fb124:	b8 14 00 00 00       	mov    $0x14,%eax
  6fb129:	48 0f 4d c1          	cmovge %rcx,%rax
  6fb12d:	4c 8d 44 24 60       	lea    0x60(%rsp),%r8
  6fb132:	48 83 f8 17          	cmp    $0x17,%rax
  6fb136:	74 0a                	je     6fb142 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x272>
  6fb138:	48 83 f8 04          	cmp    $0x4,%rax
  6fb13c:	0f 85 f7 00 00 00    	jne    6fb239 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x369>
  6fb142:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  6fb149:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  6fb150:	48 8d 0d 21 f8 3f 00 	lea    0x3ff821(%rip),%rcx        # afa978 <__frame_dummy_init_array_entry+0x70>
  6fb157:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  6fb15e:	00 
  6fb15f:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  6fb166:	00 
  6fb167:	48 89 ea             	mov    %rbp,%rdx
  6fb16a:	ff 15 80 e3 42 00    	call   *0x42e380(%rip)        # b294f0 <_DYNAMIC+0x380>
  6fb170:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  6fb175:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  6fb17a:	48 8b b4 24 30 01 00 	mov    0x130(%rsp),%rsi
  6fb181:	00 
  6fb182:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  6fb186:	74 69                	je     6fb1f1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x321>
  6fb188:	48 89 f5             	mov    %rsi,%rbp
  6fb18b:	48 c1 ed 08          	shr    $0x8,%rbp
  6fb18f:	0f 10 84 24 38 01 00 	movups 0x138(%rsp),%xmm0
  6fb196:	00 
  6fb197:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fb19c:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fb1a0:	74 44                	je     6fb1e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x316>
  6fb1a2:	49 83 ec 0d          	sub    $0xd,%r12
  6fb1a6:	ba 14 00 00 00       	mov    $0x14,%edx
  6fb1ab:	49 0f 4d d4          	cmovge %r12,%rdx
  6fb1af:	48 83 fa 19          	cmp    $0x19,%rdx
  6fb1b3:	74 09                	je     6fb1be <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x2ee>
  6fb1b5:	48 89 c8             	mov    %rcx,%rax
  6fb1b8:	48 83 fa 14          	cmp    $0x14,%rdx
  6fb1bc:	75 28                	jne    6fb1e6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x316>
  6fb1be:	49 89 f5             	mov    %rsi,%r13
  6fb1c1:	48 8b 30             	mov    (%rax),%rsi
  6fb1c4:	48 85 f6             	test   %rsi,%rsi
  6fb1c7:	74 0f                	je     6fb1d8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x308>
  6fb1c9:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fb1cd:	ba 01 00 00 00       	mov    $0x1,%edx
  6fb1d2:	ff 15 e0 e1 42 00    	call   *0x42e1e0(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fb1d8:	41 bc 20 00 00 00    	mov    $0x20,%r12d
  6fb1de:	4c 89 ee             	mov    %r13,%rsi
  6fb1e1:	e9 96 00 00 00       	jmp    6fb27c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x3ac>
  6fb1e6:	41 bc 20 00 00 00    	mov    $0x20,%r12d
  6fb1ec:	e9 8b 00 00 00       	jmp    6fb27c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x3ac>
  6fb1f1:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fb1f5:	74 33                	je     6fb22a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x35a>
  6fb1f7:	49 83 ec 0d          	sub    $0xd,%r12
  6fb1fb:	ba 14 00 00 00       	mov    $0x14,%edx
  6fb200:	49 0f 4d d4          	cmovge %r12,%rdx
  6fb204:	48 83 fa 19          	cmp    $0x19,%rdx
  6fb208:	74 09                	je     6fb213 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x343>
  6fb20a:	48 89 c8             	mov    %rcx,%rax
  6fb20d:	48 83 fa 14          	cmp    $0x14,%rdx
  6fb211:	75 17                	jne    6fb22a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x35a>
  6fb213:	48 8b 30             	mov    (%rax),%rsi
  6fb216:	48 85 f6             	test   %rsi,%rsi
  6fb219:	74 0f                	je     6fb22a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x35a>
  6fb21b:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fb21f:	ba 01 00 00 00       	mov    $0x1,%edx
  6fb224:	ff 15 8e e1 42 00    	call   *0x42e18e(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fb22a:	40 b6 01             	mov    $0x1,%sil
  6fb22d:	4d 89 fc             	mov    %r15,%r12
  6fb230:	49 c7 c5 fe ff ff ff 	mov    $0xfffffffffffffffe,%r13
  6fb237:	eb 49                	jmp    6fb282 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x3b2>
  6fb239:	0f b6 74 24 68       	movzbl 0x68(%rsp),%esi
  6fb23e:	0f b6 44 24 6f       	movzbl 0x6f(%rsp),%eax
  6fb243:	c1 e0 10             	shl    $0x10,%eax
  6fb246:	0f b7 4c 24 6d       	movzwl 0x6d(%rsp),%ecx
  6fb24b:	09 c1                	or     %eax,%ecx
  6fb24d:	48 c1 e1 20          	shl    $0x20,%rcx
  6fb251:	8b 6c 24 69          	mov    0x69(%rsp),%ebp
  6fb255:	48 09 cd             	or     %rcx,%rbp
  6fb258:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  6fb25d:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fb262:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  6fb269:	00 
  6fb26a:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  6fb26f:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  6fb276:	00 
  6fb277:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6fb27c:	4d 89 e5             	mov    %r12,%r13
  6fb27f:	4d 89 fc             	mov    %r15,%r12
  6fb282:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
  6fb287:	40 0f b6 c6          	movzbl %sil,%eax
  6fb28b:	48 c1 e5 08          	shl    $0x8,%rbp
  6fb28f:	48 09 c5             	or     %rax,%rbp
  6fb292:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  6fb297:	0f 28 4c 24 20       	movaps 0x20(%rsp),%xmm1
  6fb29c:	0f 11 84 24 b0 00 00 	movups %xmm0,0xb0(%rsp)
  6fb2a3:	00 
  6fb2a4:	0f 11 8c 24 c0 00 00 	movups %xmm1,0xc0(%rsp)
  6fb2ab:	00 
  6fb2ac:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fb2b1:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fb2b8:	00 
  6fb2b9:	4c 89 ac 24 a0 00 00 	mov    %r13,0xa0(%rsp)
  6fb2c0:	00 
  6fb2c1:	48 89 ac 24 a8 00 00 	mov    %rbp,0xa8(%rsp)
  6fb2c8:	00 
  6fb2c9:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fb2d0:	49 39 f4             	cmp    %rsi,%r12
  6fb2d3:	0f 83 8d 02 00 00    	jae    6fb566 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x696>
  6fb2d9:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6fb2e0:	4c 8d 24 d8          	lea    (%rax,%rbx,8),%r12
  6fb2e4:	4c 8b 7c d8 08       	mov    0x8(%rax,%rbx,8),%r15
  6fb2e9:	4d 85 ff             	test   %r15,%r15
  6fb2ec:	74 28                	je     6fb316 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x446>
  6fb2ee:	48 8b 5c d8 10       	mov    0x10(%rax,%rbx,8),%rbx
  6fb2f3:	48 8b 03             	mov    (%rbx),%rax
  6fb2f6:	48 85 c0             	test   %rax,%rax
  6fb2f9:	74 05                	je     6fb300 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x430>
  6fb2fb:	4c 89 ff             	mov    %r15,%rdi
  6fb2fe:	ff d0                	call   *%rax
  6fb300:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fb304:	48 85 f6             	test   %rsi,%rsi
  6fb307:	74 0d                	je     6fb316 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x446>
  6fb309:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fb30d:	4c 89 ff             	mov    %r15,%rdi
  6fb310:	ff 15 a2 e0 42 00    	call   *0x42e0a2(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fb316:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6fb31b:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  6fb320:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fb325:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  6fb32a:	49 83 fd fd          	cmp    $0xfffffffffffffffd,%r13
  6fb32e:	74 35                	je     6fb365 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x495>
  6fb330:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  6fb334:	75 77                	jne    6fb3ad <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x4dd>
  6fb336:	80 7c 24 58 01       	cmpb   $0x1,0x58(%rsp)
  6fb33b:	0f 85 bb 00 00 00    	jne    6fb3fc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x52c>
  6fb341:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6fb346:	4c 89 f6             	mov    %r14,%rsi
  6fb349:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  6fb350:	00 
  6fb351:	31 c9                	xor    %ecx,%ecx
  6fb353:	4c 8b 84 24 e0 00 00 	mov    0xe0(%rsp),%r8
  6fb35a:	00 
  6fb35b:	e8 70 06 00 00       	call   6fb9d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing>
  6fb360:	e9 f5 00 00 00       	jmp    6fb45a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x58a>
  6fb365:	4c 89 f7             	mov    %r14,%rdi
  6fb368:	e8 a3 f7 01 00       	call   71ab10 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fb36d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fb372:	48 c7 00 0f 00 00 00 	movq   $0xf,(%rax)
  6fb379:	48 8b 9c 24 b0 00 00 	mov    0xb0(%rsp),%rbx
  6fb380:	00 
  6fb381:	48 8b 03             	mov    (%rbx),%rax
  6fb384:	48 85 c0             	test   %rax,%rax
  6fb387:	74 05                	je     6fb38e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x4be>
  6fb389:	48 89 ef             	mov    %rbp,%rdi
  6fb38c:	ff d0                	call   *%rax
  6fb38e:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fb392:	48 85 f6             	test   %rsi,%rsi
  6fb395:	0f 84 bf 00 00 00    	je     6fb45a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x58a>
  6fb39b:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fb39f:	48 89 ef             	mov    %rbp,%rdi
  6fb3a2:	ff 15 10 e0 42 00    	call   *0x42e010(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fb3a8:	e9 ad 00 00 00       	jmp    6fb45a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x58a>
  6fb3ad:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  6fb3b4:	00 
  6fb3b5:	49 39 86 60 06 00 00 	cmp    %rax,0x660(%r14)
  6fb3bc:	74 08                	je     6fb3c6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x4f6>
  6fb3be:	4c 89 f7             	mov    %r14,%rdi
  6fb3c1:	e8 4a f7 01 00       	call   71ab10 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fb3c6:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  6fb3cd:	00 
  6fb3ce:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fb3d3:	48 89 41 30          	mov    %rax,0x30(%rcx)
  6fb3d7:	0f 10 84 24 a0 00 00 	movups 0xa0(%rsp),%xmm0
  6fb3de:	00 
  6fb3df:	0f 10 8c 24 b0 00 00 	movups 0xb0(%rsp),%xmm1
  6fb3e6:	00 
  6fb3e7:	0f 10 94 24 c0 00 00 	movups 0xc0(%rsp),%xmm2
  6fb3ee:	00 
  6fb3ef:	0f 11 51 20          	movups %xmm2,0x20(%rcx)
  6fb3f3:	0f 11 49 10          	movups %xmm1,0x10(%rcx)
  6fb3f7:	0f 11 01             	movups %xmm0,(%rcx)
  6fb3fa:	eb 5e                	jmp    6fb45a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x58a>
  6fb3fc:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  6fb403:	00 
  6fb404:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  6fb40b:	00 
  6fb40c:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  6fb413:	00 
  6fb414:	74 0e                	je     6fb424 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x554>
  6fb416:	84 c0                	test   %al,%al
  6fb418:	74 0e                	je     6fb428 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x558>
  6fb41a:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  6fb421:	ff 
  6fb422:	75 04                	jne    6fb428 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x558>
  6fb424:	31 c9                	xor    %ecx,%ecx
  6fb426:	eb 0c                	jmp    6fb434 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x564>
  6fb428:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  6fb42f:	b9 01 00 00 00       	mov    $0x1,%ecx
  6fb434:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  6fb43b:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6fb440:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  6fb444:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  6fb448:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  6fb44c:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  6fb450:	88 47 30             	mov    %al,0x30(%rdi)
  6fb453:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  6fb45a:	48 81 c4 48 01 00 00 	add    $0x148,%rsp
  6fb461:	5b                   	pop    %rbx
  6fb462:	41 5c                	pop    %r12
  6fb464:	41 5d                	pop    %r13
  6fb466:	41 5e                	pop    %r14
  6fb468:	41 5f                	pop    %r15
  6fb46a:	5d                   	pop    %rbp
  6fb46b:	c3                   	ret
  6fb46c:	48 8d 3d 02 c8 96 ff 	lea    -0x6937fe(%rip),%rdi        # 67c75 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x988>
  6fb473:	48 8d 15 06 f9 3f 00 	lea    0x3ff906(%rip),%rdx        # afad80 <__frame_dummy_init_array_entry+0x478>
  6fb47a:	be 0e 00 00 00       	mov    $0xe,%esi
  6fb47f:	ff 15 33 e0 42 00    	call   *0x42e033(%rip)        # b294b8 <_DYNAMIC+0x348>
  6fb485:	4d 89 e7             	mov    %r12,%r15
  6fb488:	41 bc 1f 00 00 00    	mov    $0x1f,%r12d
  6fb48e:	e9 e9 fd ff ff       	jmp    6fb27c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x3ac>
  6fb493:	48 8d 15 ce f8 3f 00 	lea    0x3ff8ce(%rip),%rdx        # afad68 <__frame_dummy_init_array_entry+0x460>
  6fb49a:	4c 89 e7             	mov    %r12,%rdi
  6fb49d:	ff 15 25 e0 42 00    	call   *0x42e025(%rip)        # b294c8 <_DYNAMIC+0x358>
  6fb4a3:	49 89 c6             	mov    %rax,%r14
  6fb4a6:	e9 f1 00 00 00       	jmp    6fb59c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6cc>
  6fb4ab:	49 89 c6             	mov    %rax,%r14
  6fb4ae:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fb4b2:	48 85 f6             	test   %rsi,%rsi
  6fb4b5:	0f 84 ee 00 00 00    	je     6fb5a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6d9>
  6fb4bb:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fb4bf:	48 89 ef             	mov    %rbp,%rdi
  6fb4c2:	ff 15 f0 de 42 00    	call   *0x42def0(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fb4c8:	4c 89 f7             	mov    %r14,%rdi
  6fb4cb:	e8 80 e0 3f 00       	call   af9550 <_Unwind_Resume@plt>
  6fb4d0:	49 89 c5             	mov    %rax,%r13
  6fb4d3:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fb4d7:	74 46                	je     6fb51f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x64f>
  6fb4d9:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  6fb4de:	e8 0d cb ff ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fb4e3:	eb 3a                	jmp    6fb51f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x64f>
  6fb4e5:	49 89 c6             	mov    %rax,%r14
  6fb4e8:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fb4ec:	48 85 f6             	test   %rsi,%rsi
  6fb4ef:	74 0d                	je     6fb4fe <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x62e>
  6fb4f1:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fb4f5:	4c 89 ff             	mov    %r15,%rdi
  6fb4f8:	ff 15 ba de 42 00    	call   *0x42deba(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fb4fe:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6fb503:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  6fb508:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fb50d:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  6fb512:	eb 7c                	jmp    6fb590 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6c0>
  6fb514:	49 89 c6             	mov    %rax,%r14
  6fb517:	eb 77                	jmp    6fb590 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6c0>
  6fb519:	4d 89 e7             	mov    %r12,%r15
  6fb51c:	49 89 c5             	mov    %rax,%r13
  6fb51f:	4c 89 ef             	mov    %r13,%rdi
  6fb522:	ff 15 b0 df 42 00    	call   *0x42dfb0(%rip)        # b294d8 <_DYNAMIC+0x368>
  6fb528:	48 89 c5             	mov    %rax,%rbp
  6fb52b:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  6fb532:	00 
  6fb533:	48 89 94 24 b0 00 00 	mov    %rdx,0xb0(%rsp)
  6fb53a:	00 
  6fb53b:	48 c7 84 24 a0 00 00 	movq   $0xfffffffffffffffd,0xa0(%rsp)
  6fb542:	00 fd ff ff ff 
  6fb547:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fb54c:	4d 89 fc             	mov    %r15,%r12
  6fb54f:	49 c7 c5 fd ff ff ff 	mov    $0xfffffffffffffffd,%r13
  6fb556:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fb55d:	49 39 f4             	cmp    %rsi,%r12
  6fb560:	0f 82 73 fd ff ff    	jb     6fb2d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x409>
  6fb566:	48 8d 15 2b f8 3f 00 	lea    0x3ff82b(%rip),%rdx        # afad98 <__frame_dummy_init_array_entry+0x490>
  6fb56d:	4c 89 e7             	mov    %r12,%rdi
  6fb570:	ff 15 52 df 42 00    	call   *0x42df52(%rip)        # b294c8 <_DYNAMIC+0x358>
  6fb576:	0f 0b                	ud2
  6fb578:	ff 15 62 df 42 00    	call   *0x42df62(%rip)        # b294e0 <_DYNAMIC+0x370>
  6fb57e:	49 89 c6             	mov    %rax,%r14
  6fb581:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  6fb586:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6fb58b:	e8 e0 93 ff ff       	call   6f4970 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  6fb590:	49 83 fd fd          	cmp    $0xfffffffffffffffd,%r13
  6fb594:	74 1b                	je     6fb5b1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6e1>
  6fb596:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  6fb59a:	74 0d                	je     6fb5a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6d9>
  6fb59c:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  6fb5a3:	00 
  6fb5a4:	e8 47 ca ff ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fb5a9:	4c 89 f7             	mov    %r14,%rdi
  6fb5ac:	e8 9f df 3f 00       	call   af9550 <_Unwind_Resume@plt>
  6fb5b1:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  6fb5b8:	00 
  6fb5b9:	e8 52 98 ff ff       	call   6f4e10 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb5be:	eb e9                	jmp    6fb5a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6d9>
  6fb5c0:	ff 15 22 de 42 00    	call   *0x42de22(%rip)        # b293e8 <_DYNAMIC+0x278>
