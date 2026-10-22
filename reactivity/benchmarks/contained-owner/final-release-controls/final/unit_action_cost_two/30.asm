
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
  6fade1:	49 89 f6             	mov    %rsi,%r14
  6fade4:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  6fade9:	48 8b b6 a0 02 00 00 	mov    0x2a0(%rsi),%rsi
  6fadf0:	48 39 f1             	cmp    %rsi,%rcx
  6fadf3:	0f 83 a7 05 00 00    	jae    6fb3a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x5d0>
  6fadf9:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6fae00:	48 89 0c 24          	mov    %rcx,(%rsp)
  6fae04:	48 8d 1c 89          	lea    (%rcx,%rcx,4),%rbx
  6fae08:	48 8b 4c d8 08       	mov    0x8(%rax,%rbx,8),%rcx
  6fae0d:	4c 8b 64 d8 10       	mov    0x10(%rax,%rbx,8),%r12
  6fae12:	48 c7 44 d8 08 00 00 	movq   $0x0,0x8(%rax,%rbx,8)
  6fae19:	00 00 
  6fae1b:	48 85 c9             	test   %rcx,%rcx
  6fae1e:	0f 84 59 05 00 00    	je     6fb37d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x5ad>
  6fae24:	48 89 94 24 d8 00 00 	mov    %rdx,0xd8(%rsp)
  6fae2b:	00 
  6fae2c:	4c 89 84 24 e0 00 00 	mov    %r8,0xe0(%rsp)
  6fae33:	00 
  6fae34:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  6fae39:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
  6fae40:	00 
  6fae41:	4c 89 a4 24 f8 00 00 	mov    %r12,0xf8(%rsp)
  6fae48:	00 
  6fae49:	49 8b 86 60 06 00 00 	mov    0x660(%r14),%rax
  6fae50:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6fae57:	00 
  6fae58:	49 8d ae 10 07 00 00 	lea    0x710(%r14),%rbp
  6fae5f:	48 8d 0d 72 fa 3f 00 	lea    0x3ffa72(%rip),%rcx        # afa8d8 <__frame_dummy_init_array_entry+0x70>
  6fae66:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fae6b:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  6fae72:	00 
  6fae73:	48 89 ea             	mov    %rbp,%rdx
  6fae76:	4c 89 64 24 58       	mov    %r12,0x58(%rsp)
  6fae7b:	ff 15 7f e5 42 00    	call   *0x42e57f(%rip)        # b29400 <_DYNAMIC+0x378>
  6fae81:	44 0f b7 7c 24 20    	movzwl 0x20(%rsp),%r15d
  6fae87:	66 41 83 ff ff       	cmp    $0xffff,%r15w
  6fae8c:	0f 84 f6 00 00 00    	je     6faf88 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x1b8>
  6fae92:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6fae97:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  6fae9c:	8b 74 24 24          	mov    0x24(%rsp),%esi
  6faea0:	0f b6 7c 24 28       	movzbl 0x28(%rsp),%edi
  6faea5:	44 0f b6 4c 24 2f    	movzbl 0x2f(%rsp),%r9d
  6faeab:	44 0f b7 44 24 2d    	movzwl 0x2d(%rsp),%r8d
  6faeb1:	8b 4c 24 29          	mov    0x29(%rsp),%ecx
  6faeb5:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  6faeba:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  6faec1:	00 
  6faec2:	66 45 85 ff          	test   %r15w,%r15w
  6faec6:	0f 84 f3 00 00 00    	je     6fafbf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x1ef>
  6faecc:	41 c1 e1 10          	shl    $0x10,%r9d
  6faed0:	45 09 c8             	or     %r9d,%r8d
  6faed3:	49 c1 e0 20          	shl    $0x20,%r8
  6faed7:	4c 09 c1             	or     %r8,%rcx
  6faeda:	89 b4 24 04 01 00 00 	mov    %esi,0x104(%rsp)
  6faee1:	40 88 bc 24 08 01 00 	mov    %dil,0x108(%rsp)
  6faee8:	00 
  6faee9:	89 8c 24 09 01 00 00 	mov    %ecx,0x109(%rsp)
  6faef0:	48 89 ce             	mov    %rcx,%rsi
  6faef3:	48 c1 ee 30          	shr    $0x30,%rsi
  6faef7:	40 88 b4 24 0f 01 00 	mov    %sil,0x10f(%rsp)
  6faefe:	00 
  6faeff:	48 c1 e9 20          	shr    $0x20,%rcx
  6faf03:	66 89 8c 24 0d 01 00 	mov    %cx,0x10d(%rsp)
  6faf0a:	00 
  6faf0b:	0f 28 84 24 20 01 00 	movaps 0x120(%rsp),%xmm0
  6faf12:	00 
  6faf13:	0f 11 84 24 10 01 00 	movups %xmm0,0x110(%rsp)
  6faf1a:	00 
  6faf1b:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  6faf22:	49 ff c5             	inc    %r13
  6faf25:	0f 84 6b 04 00 00    	je     6fb396 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x5c6>
  6faf2b:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  6faf32:	0f 85 a1 00 00 00    	jne    6fafd9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x209>
  6faf38:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6faf3d:	4c 89 f6             	mov    %r14,%rsi
  6faf40:	e8 3b f4 01 00       	call   71a380 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  6faf45:	48 83 7c 24 10 fe    	cmpq   $0xfffffffffffffffe,0x10(%rsp)
  6faf4b:	0f 85 91 00 00 00    	jne    6fafe2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x212>
  6faf51:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  6faf56:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  6faf5b:	4c 8d 84 24 04 01 00 	lea    0x104(%rsp),%r8
  6faf62:	00 
  6faf63:	4c 89 f6             	mov    %r14,%rsi
  6faf66:	44 89 f9             	mov    %r15d,%ecx
  6faf69:	e8 82 ef 02 00       	call   729ef0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at>
  6faf6e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6faf73:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  6faf77:	0f 85 ac 00 00 00    	jne    6fb029 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x259>
  6faf7d:	49 89 cc             	mov    %rcx,%r12
  6faf80:	45 31 c0             	xor    %r8d,%r8d
  6faf83:	e9 c6 00 00 00       	jmp    6fb04e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x27e>
  6faf88:	44 0f b6 7c 24 28    	movzbl 0x28(%rsp),%r15d
  6faf8e:	0f b6 44 24 2f       	movzbl 0x2f(%rsp),%eax
  6faf93:	c1 e0 10             	shl    $0x10,%eax
  6faf96:	0f b7 4c 24 2d       	movzwl 0x2d(%rsp),%ecx
  6faf9b:	09 c1                	or     %eax,%ecx
  6faf9d:	48 c1 e1 20          	shl    $0x20,%rcx
  6fafa1:	8b 6c 24 29          	mov    0x29(%rsp),%ebp
  6fafa5:	48 09 cd             	or     %rcx,%rbp
  6fafa8:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  6fafad:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  6fafb4:	00 
  6fafb5:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fafba:	e9 26 01 00 00       	jmp    6fb0e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x315>
  6fafbf:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  6fafc6:	00 00 00 00 
  6fafca:	48 c7 c1 fe ff ff ff 	mov    $0xfffffffffffffffe,%rcx
  6fafd1:	45 31 ff             	xor    %r15d,%r15d
  6fafd4:	e9 11 01 00 00       	jmp    6fb0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x31a>
  6fafd9:	48 c7 44 24 10 11 00 	movq   $0x11,0x10(%rsp)
  6fafe0:	00 00 
  6fafe2:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fafe7:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  6fafee:	00 
  6fafef:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6faff4:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  6faff9:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  6faffe:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  6fb003:	0f 29 8c 24 80 00 00 	movaps %xmm1,0x80(%rsp)
  6fb00a:	00 
  6fb00b:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  6fb010:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6fb015:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  6fb01a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6fb01f:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  6fb023:	0f 84 54 ff ff ff    	je     6faf7d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x1ad>
  6fb029:	49 89 cc             	mov    %rcx,%r12
  6fb02c:	48 83 e9 0d          	sub    $0xd,%rcx
  6fb030:	b8 14 00 00 00       	mov    $0x14,%eax
  6fb035:	48 0f 4d c1          	cmovge %rcx,%rax
  6fb039:	4c 8d 44 24 60       	lea    0x60(%rsp),%r8
  6fb03e:	48 83 f8 17          	cmp    $0x17,%rax
  6fb042:	74 0a                	je     6fb04e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x27e>
  6fb044:	48 83 f8 04          	cmp    $0x4,%rax
  6fb048:	0f 85 9f 02 00 00    	jne    6fb2ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x51d>
  6fb04e:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  6fb055:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  6fb05c:	48 8d 0d 75 f8 3f 00 	lea    0x3ff875(%rip),%rcx        # afa8d8 <__frame_dummy_init_array_entry+0x70>
  6fb063:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  6fb06a:	00 
  6fb06b:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  6fb072:	00 
  6fb073:	48 89 ea             	mov    %rbp,%rdx
  6fb076:	ff 15 8c e3 42 00    	call   *0x42e38c(%rip)        # b29408 <_DYNAMIC+0x380>
  6fb07c:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  6fb081:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  6fb086:	4c 8b bc 24 30 01 00 	mov    0x130(%rsp),%r15
  6fb08d:	00 
  6fb08e:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  6fb092:	0f 84 0d 02 00 00    	je     6fb2a5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x4d5>
  6fb098:	4c 89 fd             	mov    %r15,%rbp
  6fb09b:	48 c1 ed 08          	shr    $0x8,%rbp
  6fb09f:	0f 10 84 24 38 01 00 	movups 0x138(%rsp),%xmm0
  6fb0a6:	00 
  6fb0a7:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fb0ac:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fb0b0:	74 33                	je     6fb0e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x315>
  6fb0b2:	49 83 ec 0d          	sub    $0xd,%r12
  6fb0b6:	ba 14 00 00 00       	mov    $0x14,%edx
  6fb0bb:	49 0f 4d d4          	cmovge %r12,%rdx
  6fb0bf:	48 83 fa 19          	cmp    $0x19,%rdx
  6fb0c3:	74 09                	je     6fb0ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x2fe>
  6fb0c5:	48 89 c8             	mov    %rcx,%rax
  6fb0c8:	48 83 fa 14          	cmp    $0x14,%rdx
  6fb0cc:	75 17                	jne    6fb0e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x315>
  6fb0ce:	48 8b 30             	mov    (%rax),%rsi
  6fb0d1:	48 85 f6             	test   %rsi,%rsi
  6fb0d4:	74 0f                	je     6fb0e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x315>
  6fb0d6:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fb0da:	ba 01 00 00 00       	mov    $0x1,%edx
  6fb0df:	ff 15 eb e1 42 00    	call   *0x42e1eb(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fb0e5:	b9 20 00 00 00       	mov    $0x20,%ecx
  6fb0ea:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fb0ee:	41 0f b6 c7          	movzbl %r15b,%eax
  6fb0f2:	48 c1 e5 08          	shl    $0x8,%rbp
  6fb0f6:	48 09 c5             	or     %rax,%rbp
  6fb0f9:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  6fb0fe:	0f 28 4c 24 20       	movaps 0x20(%rsp),%xmm1
  6fb103:	0f 11 84 24 b0 00 00 	movups %xmm0,0xb0(%rsp)
  6fb10a:	00 
  6fb10b:	0f 11 8c 24 c0 00 00 	movups %xmm1,0xc0(%rsp)
  6fb112:	00 
  6fb113:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fb118:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fb11f:	00 
  6fb120:	48 89 8c 24 a0 00 00 	mov    %rcx,0xa0(%rsp)
  6fb127:	00 
  6fb128:	48 89 ac 24 a8 00 00 	mov    %rbp,0xa8(%rsp)
  6fb12f:	00 
  6fb130:	48 89 0c 24          	mov    %rcx,(%rsp)
  6fb134:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fb13b:	48 39 f7             	cmp    %rsi,%rdi
  6fb13e:	0f 83 2d 03 00 00    	jae    6fb471 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6a1>
  6fb144:	4d 89 fc             	mov    %r15,%r12
  6fb147:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6fb14e:	4c 8d 2c d8          	lea    (%rax,%rbx,8),%r13
  6fb152:	4c 8b 7c d8 08       	mov    0x8(%rax,%rbx,8),%r15
  6fb157:	4d 85 ff             	test   %r15,%r15
  6fb15a:	74 28                	je     6fb184 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x3b4>
  6fb15c:	48 8b 5c d8 10       	mov    0x10(%rax,%rbx,8),%rbx
  6fb161:	48 8b 03             	mov    (%rbx),%rax
  6fb164:	48 85 c0             	test   %rax,%rax
  6fb167:	74 05                	je     6fb16e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x39e>
  6fb169:	4c 89 ff             	mov    %r15,%rdi
  6fb16c:	ff d0                	call   *%rax
  6fb16e:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fb172:	48 85 f6             	test   %rsi,%rsi
  6fb175:	74 0d                	je     6fb184 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x3b4>
  6fb177:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fb17b:	4c 89 ff             	mov    %r15,%rdi
  6fb17e:	ff 15 4c e1 42 00    	call   *0x42e14c(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fb184:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fb189:	49 89 45 08          	mov    %rax,0x8(%r13)
  6fb18d:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fb192:	49 89 45 10          	mov    %rax,0x10(%r13)
  6fb196:	48 8b 04 24          	mov    (%rsp),%rax
  6fb19a:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  6fb19e:	74 34                	je     6fb1d4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x404>
  6fb1a0:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fb1a4:	75 76                	jne    6fb21c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x44c>
  6fb1a6:	41 80 fc 01          	cmp    $0x1,%r12b
  6fb1aa:	0f 85 be 00 00 00    	jne    6fb26e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x49e>
  6fb1b0:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6fb1b5:	4c 89 f6             	mov    %r14,%rsi
  6fb1b8:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  6fb1bf:	00 
  6fb1c0:	31 c9                	xor    %ecx,%ecx
  6fb1c2:	4c 8b 84 24 e0 00 00 	mov    0xe0(%rsp),%r8
  6fb1c9:	00 
  6fb1ca:	e8 01 07 00 00       	call   6fb8d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing>
  6fb1cf:	e9 97 01 00 00       	jmp    6fb36b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x59b>
  6fb1d4:	4c 89 f7             	mov    %r14,%rdi
  6fb1d7:	e8 34 f8 01 00       	call   71aa10 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fb1dc:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fb1e1:	48 c7 00 0f 00 00 00 	movq   $0xf,(%rax)
  6fb1e8:	48 8b 9c 24 b0 00 00 	mov    0xb0(%rsp),%rbx
  6fb1ef:	00 
  6fb1f0:	48 8b 03             	mov    (%rbx),%rax
  6fb1f3:	48 85 c0             	test   %rax,%rax
  6fb1f6:	74 05                	je     6fb1fd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x42d>
  6fb1f8:	48 89 ef             	mov    %rbp,%rdi
  6fb1fb:	ff d0                	call   *%rax
  6fb1fd:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fb201:	48 85 f6             	test   %rsi,%rsi
  6fb204:	0f 84 61 01 00 00    	je     6fb36b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x59b>
  6fb20a:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fb20e:	48 89 ef             	mov    %rbp,%rdi
  6fb211:	ff 15 b9 e0 42 00    	call   *0x42e0b9(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fb217:	e9 4f 01 00 00       	jmp    6fb36b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x59b>
  6fb21c:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  6fb223:	00 
  6fb224:	49 39 86 60 06 00 00 	cmp    %rax,0x660(%r14)
  6fb22b:	74 08                	je     6fb235 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x465>
  6fb22d:	4c 89 f7             	mov    %r14,%rdi
  6fb230:	e8 db f7 01 00       	call   71aa10 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fb235:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  6fb23c:	00 
  6fb23d:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fb242:	48 89 41 30          	mov    %rax,0x30(%rcx)
  6fb246:	0f 10 84 24 a0 00 00 	movups 0xa0(%rsp),%xmm0
  6fb24d:	00 
  6fb24e:	0f 10 8c 24 b0 00 00 	movups 0xb0(%rsp),%xmm1
  6fb255:	00 
  6fb256:	0f 10 94 24 c0 00 00 	movups 0xc0(%rsp),%xmm2
  6fb25d:	00 
  6fb25e:	0f 11 51 20          	movups %xmm2,0x20(%rcx)
  6fb262:	0f 11 49 10          	movups %xmm1,0x10(%rcx)
  6fb266:	0f 11 01             	movups %xmm0,(%rcx)
  6fb269:	e9 fd 00 00 00       	jmp    6fb36b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x59b>
  6fb26e:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  6fb275:	00 
  6fb276:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  6fb27d:	00 
  6fb27e:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  6fb285:	00 
  6fb286:	74 16                	je     6fb29e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x4ce>
  6fb288:	84 c0                	test   %al,%al
  6fb28a:	0f 84 a9 00 00 00    	je     6fb339 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x569>
  6fb290:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  6fb297:	ff 
  6fb298:	0f 85 9b 00 00 00    	jne    6fb339 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x569>
  6fb29e:	31 c9                	xor    %ecx,%ecx
  6fb2a0:	e9 a0 00 00 00       	jmp    6fb345 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x575>
  6fb2a5:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fb2a9:	74 33                	je     6fb2de <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x50e>
  6fb2ab:	49 83 ec 0d          	sub    $0xd,%r12
  6fb2af:	ba 14 00 00 00       	mov    $0x14,%edx
  6fb2b4:	49 0f 4d d4          	cmovge %r12,%rdx
  6fb2b8:	48 83 fa 19          	cmp    $0x19,%rdx
  6fb2bc:	74 09                	je     6fb2c7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x4f7>
  6fb2be:	48 89 c8             	mov    %rcx,%rax
  6fb2c1:	48 83 fa 14          	cmp    $0x14,%rdx
  6fb2c5:	75 17                	jne    6fb2de <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x50e>
  6fb2c7:	48 8b 30             	mov    (%rax),%rsi
  6fb2ca:	48 85 f6             	test   %rsi,%rsi
  6fb2cd:	74 0f                	je     6fb2de <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x50e>
  6fb2cf:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fb2d3:	ba 01 00 00 00       	mov    $0x1,%edx
  6fb2d8:	ff 15 f2 df 42 00    	call   *0x42dff2(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fb2de:	48 c7 c1 fe ff ff ff 	mov    $0xfffffffffffffffe,%rcx
  6fb2e5:	41 b7 01             	mov    $0x1,%r15b
  6fb2e8:	e9 fd fd ff ff       	jmp    6fb0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x31a>
  6fb2ed:	44 0f b6 7c 24 68    	movzbl 0x68(%rsp),%r15d
  6fb2f3:	0f b6 44 24 6f       	movzbl 0x6f(%rsp),%eax
  6fb2f8:	c1 e0 10             	shl    $0x10,%eax
  6fb2fb:	0f b7 4c 24 6d       	movzwl 0x6d(%rsp),%ecx
  6fb300:	09 c1                	or     %eax,%ecx
  6fb302:	48 c1 e1 20          	shl    $0x20,%rcx
  6fb306:	8b 6c 24 69          	mov    0x69(%rsp),%ebp
  6fb30a:	48 09 cd             	or     %rcx,%rbp
  6fb30d:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  6fb312:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fb317:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  6fb31e:	00 
  6fb31f:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  6fb324:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  6fb32b:	00 
  6fb32c:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6fb331:	4c 89 e1             	mov    %r12,%rcx
  6fb334:	e9 b1 fd ff ff       	jmp    6fb0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x31a>
  6fb339:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  6fb340:	b9 01 00 00 00       	mov    $0x1,%ecx
  6fb345:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  6fb34c:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6fb351:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  6fb355:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  6fb359:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  6fb35d:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  6fb361:	88 47 30             	mov    %al,0x30(%rdi)
  6fb364:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  6fb36b:	48 81 c4 48 01 00 00 	add    $0x148,%rsp
  6fb372:	5b                   	pop    %rbx
  6fb373:	41 5c                	pop    %r12
  6fb375:	41 5d                	pop    %r13
  6fb377:	41 5e                	pop    %r14
  6fb379:	41 5f                	pop    %r15
  6fb37b:	5d                   	pop    %rbp
  6fb37c:	c3                   	ret
  6fb37d:	48 8d 3d 81 c8 96 ff 	lea    -0x69377f(%rip),%rdi        # 67c05 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x988>
  6fb384:	48 8d 15 55 f9 3f 00 	lea    0x3ff955(%rip),%rdx        # aface0 <__frame_dummy_init_array_entry+0x478>
  6fb38b:	be 0e 00 00 00       	mov    $0xe,%esi
  6fb390:	ff 15 3a e0 42 00    	call   *0x42e03a(%rip)        # b293d0 <_DYNAMIC+0x348>
  6fb396:	b9 1f 00 00 00       	mov    $0x1f,%ecx
  6fb39b:	e9 4a fd ff ff       	jmp    6fb0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x31a>
  6fb3a0:	48 8d 15 21 f9 3f 00 	lea    0x3ff921(%rip),%rdx        # afacc8 <__frame_dummy_init_array_entry+0x460>
  6fb3a7:	48 89 cf             	mov    %rcx,%rdi
  6fb3aa:	ff 15 30 e0 42 00    	call   *0x42e030(%rip)        # b293e0 <_DYNAMIC+0x358>
  6fb3b0:	49 89 c6             	mov    %rax,%r14
  6fb3b3:	e9 ee 00 00 00       	jmp    6fb4a6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6d6>
  6fb3b8:	49 89 c6             	mov    %rax,%r14
  6fb3bb:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fb3bf:	48 85 f6             	test   %rsi,%rsi
  6fb3c2:	0f 84 eb 00 00 00    	je     6fb4b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6e3>
  6fb3c8:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fb3cc:	48 89 ef             	mov    %rbp,%rdi
  6fb3cf:	ff 15 fb de 42 00    	call   *0x42defb(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fb3d5:	4c 89 f7             	mov    %r14,%rdi
  6fb3d8:	e8 d3 e0 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6fb3dd:	49 89 c7             	mov    %rax,%r15
  6fb3e0:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fb3e4:	74 41                	je     6fb427 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x657>
  6fb3e6:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  6fb3eb:	e8 00 cb ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fb3f0:	eb 35                	jmp    6fb427 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x657>
  6fb3f2:	49 89 c6             	mov    %rax,%r14
  6fb3f5:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fb3f9:	48 85 f6             	test   %rsi,%rsi
  6fb3fc:	74 0d                	je     6fb40b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x63b>
  6fb3fe:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fb402:	4c 89 ff             	mov    %r15,%rdi
  6fb405:	ff 15 c5 de 42 00    	call   *0x42dec5(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fb40b:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fb410:	49 89 45 08          	mov    %rax,0x8(%r13)
  6fb414:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fb419:	49 89 45 10          	mov    %rax,0x10(%r13)
  6fb41d:	eb 79                	jmp    6fb498 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6c8>
  6fb41f:	49 89 c6             	mov    %rax,%r14
  6fb422:	eb 74                	jmp    6fb498 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6c8>
  6fb424:	49 89 c7             	mov    %rax,%r15
  6fb427:	4c 89 ff             	mov    %r15,%rdi
  6fb42a:	ff 15 c0 df 42 00    	call   *0x42dfc0(%rip)        # b293f0 <_DYNAMIC+0x368>
  6fb430:	48 89 c5             	mov    %rax,%rbp
  6fb433:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  6fb43a:	00 
  6fb43b:	48 89 94 24 b0 00 00 	mov    %rdx,0xb0(%rsp)
  6fb442:	00 
  6fb443:	48 c7 84 24 a0 00 00 	movq   $0xfffffffffffffffd,0xa0(%rsp)
  6fb44a:	00 fd ff ff ff 
  6fb44f:	48 c7 c1 fd ff ff ff 	mov    $0xfffffffffffffffd,%rcx
  6fb456:	41 89 ef             	mov    %ebp,%r15d
  6fb459:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fb45d:	48 89 0c 24          	mov    %rcx,(%rsp)
  6fb461:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fb468:	48 39 f7             	cmp    %rsi,%rdi
  6fb46b:	0f 82 d3 fc ff ff    	jb     6fb144 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x374>
  6fb471:	48 8d 15 80 f8 3f 00 	lea    0x3ff880(%rip),%rdx        # afacf8 <__frame_dummy_init_array_entry+0x490>
  6fb478:	ff 15 62 df 42 00    	call   *0x42df62(%rip)        # b293e0 <_DYNAMIC+0x358>
  6fb47e:	0f 0b                	ud2
  6fb480:	ff 15 72 df 42 00    	call   *0x42df72(%rip)        # b293f8 <_DYNAMIC+0x370>
  6fb486:	49 89 c6             	mov    %rax,%r14
  6fb489:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  6fb48e:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  6fb493:	e8 d8 93 ff ff       	call   6f4870 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  6fb498:	48 83 3c 24 fd       	cmpq   $0xfffffffffffffffd,(%rsp)
  6fb49d:	74 1c                	je     6fb4bb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6eb>
  6fb49f:	48 83 3c 24 fe       	cmpq   $0xfffffffffffffffe,(%rsp)
  6fb4a4:	74 0d                	je     6fb4b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6e3>
  6fb4a6:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  6fb4ad:	00 
  6fb4ae:	e8 3d ca ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fb4b3:	4c 89 f7             	mov    %r14,%rdi
  6fb4b6:	e8 f5 df 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6fb4bb:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  6fb4c2:	00 
  6fb4c3:	e8 48 98 ff ff       	call   6f4d10 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb4c8:	eb e9                	jmp    6fb4b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6e3>
  6fb4ca:	ff 15 30 de 42 00    	call   *0x42de30(%rip)        # b29300 <_DYNAMIC+0x278>
