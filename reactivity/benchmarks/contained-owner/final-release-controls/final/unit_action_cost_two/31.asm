
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
  6fdde1:	49 89 f6             	mov    %rsi,%r14
  6fdde4:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  6fdde9:	48 8b b6 a0 02 00 00 	mov    0x2a0(%rsi),%rsi
  6fddf0:	48 39 f1             	cmp    %rsi,%rcx
  6fddf3:	0f 83 a7 05 00 00    	jae    6fe3a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x5d0>
  6fddf9:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6fde00:	48 89 0c 24          	mov    %rcx,(%rsp)
  6fde04:	48 8d 1c 89          	lea    (%rcx,%rcx,4),%rbx
  6fde08:	48 8b 4c d8 08       	mov    0x8(%rax,%rbx,8),%rcx
  6fde0d:	4c 8b 64 d8 10       	mov    0x10(%rax,%rbx,8),%r12
  6fde12:	48 c7 44 d8 08 00 00 	movq   $0x0,0x8(%rax,%rbx,8)
  6fde19:	00 00 
  6fde1b:	48 85 c9             	test   %rcx,%rcx
  6fde1e:	0f 84 59 05 00 00    	je     6fe37d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x5ad>
  6fde24:	48 89 94 24 d8 00 00 	mov    %rdx,0xd8(%rsp)
  6fde2b:	00 
  6fde2c:	4c 89 84 24 e0 00 00 	mov    %r8,0xe0(%rsp)
  6fde33:	00 
  6fde34:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  6fde39:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
  6fde40:	00 
  6fde41:	4c 89 a4 24 f8 00 00 	mov    %r12,0xf8(%rsp)
  6fde48:	00 
  6fde49:	49 8b 86 60 06 00 00 	mov    0x660(%r14),%rax
  6fde50:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  6fde57:	00 
  6fde58:	49 8d ae 10 07 00 00 	lea    0x710(%r14),%rbp
  6fde5f:	48 8d 0d b2 ca 3f 00 	lea    0x3fcab2(%rip),%rcx        # afa918 <__frame_dummy_init_array_entry+0xb0>
  6fde66:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fde6b:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  6fde72:	00 
  6fde73:	48 89 ea             	mov    %rbp,%rdx
  6fde76:	4c 89 64 24 58       	mov    %r12,0x58(%rsp)
  6fde7b:	ff 15 7f b5 42 00    	call   *0x42b57f(%rip)        # b29400 <_DYNAMIC+0x378>
  6fde81:	44 0f b7 7c 24 20    	movzwl 0x20(%rsp),%r15d
  6fde87:	66 41 83 ff ff       	cmp    $0xffff,%r15w
  6fde8c:	0f 84 f6 00 00 00    	je     6fdf88 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x1b8>
  6fde92:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6fde97:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  6fde9c:	8b 74 24 24          	mov    0x24(%rsp),%esi
  6fdea0:	0f b6 7c 24 28       	movzbl 0x28(%rsp),%edi
  6fdea5:	44 0f b6 4c 24 2f    	movzbl 0x2f(%rsp),%r9d
  6fdeab:	44 0f b7 44 24 2d    	movzwl 0x2d(%rsp),%r8d
  6fdeb1:	8b 4c 24 29          	mov    0x29(%rsp),%ecx
  6fdeb5:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  6fdeba:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  6fdec1:	00 
  6fdec2:	66 45 85 ff          	test   %r15w,%r15w
  6fdec6:	0f 84 f3 00 00 00    	je     6fdfbf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x1ef>
  6fdecc:	41 c1 e1 10          	shl    $0x10,%r9d
  6fded0:	45 09 c8             	or     %r9d,%r8d
  6fded3:	49 c1 e0 20          	shl    $0x20,%r8
  6fded7:	4c 09 c1             	or     %r8,%rcx
  6fdeda:	89 b4 24 04 01 00 00 	mov    %esi,0x104(%rsp)
  6fdee1:	40 88 bc 24 08 01 00 	mov    %dil,0x108(%rsp)
  6fdee8:	00 
  6fdee9:	89 8c 24 09 01 00 00 	mov    %ecx,0x109(%rsp)
  6fdef0:	48 89 ce             	mov    %rcx,%rsi
  6fdef3:	48 c1 ee 30          	shr    $0x30,%rsi
  6fdef7:	40 88 b4 24 0f 01 00 	mov    %sil,0x10f(%rsp)
  6fdefe:	00 
  6fdeff:	48 c1 e9 20          	shr    $0x20,%rcx
  6fdf03:	66 89 8c 24 0d 01 00 	mov    %cx,0x10d(%rsp)
  6fdf0a:	00 
  6fdf0b:	0f 28 84 24 20 01 00 	movaps 0x120(%rsp),%xmm0
  6fdf12:	00 
  6fdf13:	0f 11 84 24 10 01 00 	movups %xmm0,0x110(%rsp)
  6fdf1a:	00 
  6fdf1b:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  6fdf22:	49 ff c5             	inc    %r13
  6fdf25:	0f 84 6b 04 00 00    	je     6fe396 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x5c6>
  6fdf2b:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  6fdf32:	0f 85 a1 00 00 00    	jne    6fdfd9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x209>
  6fdf38:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fdf3d:	4c 89 f6             	mov    %r14,%rsi
  6fdf40:	e8 db ac 02 00       	call   728c20 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  6fdf45:	48 83 7c 24 10 fe    	cmpq   $0xfffffffffffffffe,0x10(%rsp)
  6fdf4b:	0f 85 91 00 00 00    	jne    6fdfe2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x212>
  6fdf51:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  6fdf56:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  6fdf5b:	4c 8d 84 24 04 01 00 	lea    0x104(%rsp),%r8
  6fdf62:	00 
  6fdf63:	4c 89 f6             	mov    %r14,%rsi
  6fdf66:	44 89 f9             	mov    %r15d,%ecx
  6fdf69:	e8 12 ce 02 00       	call   72ad80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at>
  6fdf6e:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6fdf73:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  6fdf77:	0f 85 ac 00 00 00    	jne    6fe029 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x259>
  6fdf7d:	49 89 cc             	mov    %rcx,%r12
  6fdf80:	45 31 c0             	xor    %r8d,%r8d
  6fdf83:	e9 c6 00 00 00       	jmp    6fe04e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x27e>
  6fdf88:	44 0f b6 7c 24 28    	movzbl 0x28(%rsp),%r15d
  6fdf8e:	0f b6 44 24 2f       	movzbl 0x2f(%rsp),%eax
  6fdf93:	c1 e0 10             	shl    $0x10,%eax
  6fdf96:	0f b7 4c 24 2d       	movzwl 0x2d(%rsp),%ecx
  6fdf9b:	09 c1                	or     %eax,%ecx
  6fdf9d:	48 c1 e1 20          	shl    $0x20,%rcx
  6fdfa1:	8b 6c 24 29          	mov    0x29(%rsp),%ebp
  6fdfa5:	48 09 cd             	or     %rcx,%rbp
  6fdfa8:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  6fdfad:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  6fdfb4:	00 
  6fdfb5:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fdfba:	e9 26 01 00 00       	jmp    6fe0e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x315>
  6fdfbf:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  6fdfc6:	00 00 00 00 
  6fdfca:	48 c7 c1 fe ff ff ff 	mov    $0xfffffffffffffffe,%rcx
  6fdfd1:	45 31 ff             	xor    %r15d,%r15d
  6fdfd4:	e9 11 01 00 00       	jmp    6fe0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x31a>
  6fdfd9:	48 c7 44 24 10 11 00 	movq   $0x11,0x10(%rsp)
  6fdfe0:	00 00 
  6fdfe2:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fdfe7:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  6fdfee:	00 
  6fdfef:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6fdff4:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  6fdff9:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  6fdffe:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  6fe003:	0f 29 8c 24 80 00 00 	movaps %xmm1,0x80(%rsp)
  6fe00a:	00 
  6fe00b:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  6fe010:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6fe015:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  6fe01a:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6fe01f:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  6fe023:	0f 84 54 ff ff ff    	je     6fdf7d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x1ad>
  6fe029:	49 89 cc             	mov    %rcx,%r12
  6fe02c:	48 83 e9 0d          	sub    $0xd,%rcx
  6fe030:	b8 14 00 00 00       	mov    $0x14,%eax
  6fe035:	48 0f 4d c1          	cmovge %rcx,%rax
  6fe039:	4c 8d 44 24 60       	lea    0x60(%rsp),%r8
  6fe03e:	48 83 f8 17          	cmp    $0x17,%rax
  6fe042:	74 0a                	je     6fe04e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x27e>
  6fe044:	48 83 f8 04          	cmp    $0x4,%rax
  6fe048:	0f 85 9f 02 00 00    	jne    6fe2ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x51d>
  6fe04e:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  6fe055:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  6fe05c:	48 8d 0d b5 c8 3f 00 	lea    0x3fc8b5(%rip),%rcx        # afa918 <__frame_dummy_init_array_entry+0xb0>
  6fe063:	48 8d bc 24 30 01 00 	lea    0x130(%rsp),%rdi
  6fe06a:	00 
  6fe06b:	48 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%rsi
  6fe072:	00 
  6fe073:	48 89 ea             	mov    %rbp,%rdx
  6fe076:	ff 15 8c b3 42 00    	call   *0x42b38c(%rip)        # b29408 <_DYNAMIC+0x380>
  6fe07c:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  6fe081:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  6fe086:	4c 8b bc 24 30 01 00 	mov    0x130(%rsp),%r15
  6fe08d:	00 
  6fe08e:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  6fe092:	0f 84 0d 02 00 00    	je     6fe2a5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x4d5>
  6fe098:	4c 89 fd             	mov    %r15,%rbp
  6fe09b:	48 c1 ed 08          	shr    $0x8,%rbp
  6fe09f:	0f 10 84 24 38 01 00 	movups 0x138(%rsp),%xmm0
  6fe0a6:	00 
  6fe0a7:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fe0ac:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fe0b0:	74 33                	je     6fe0e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x315>
  6fe0b2:	49 83 ec 0d          	sub    $0xd,%r12
  6fe0b6:	ba 14 00 00 00       	mov    $0x14,%edx
  6fe0bb:	49 0f 4d d4          	cmovge %r12,%rdx
  6fe0bf:	48 83 fa 19          	cmp    $0x19,%rdx
  6fe0c3:	74 09                	je     6fe0ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x2fe>
  6fe0c5:	48 89 c8             	mov    %rcx,%rax
  6fe0c8:	48 83 fa 14          	cmp    $0x14,%rdx
  6fe0cc:	75 17                	jne    6fe0e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x315>
  6fe0ce:	48 8b 30             	mov    (%rax),%rsi
  6fe0d1:	48 85 f6             	test   %rsi,%rsi
  6fe0d4:	74 0f                	je     6fe0e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x315>
  6fe0d6:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fe0da:	ba 01 00 00 00       	mov    $0x1,%edx
  6fe0df:	ff 15 eb b1 42 00    	call   *0x42b1eb(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fe0e5:	b9 20 00 00 00       	mov    $0x20,%ecx
  6fe0ea:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fe0ee:	41 0f b6 c7          	movzbl %r15b,%eax
  6fe0f2:	48 c1 e5 08          	shl    $0x8,%rbp
  6fe0f6:	48 09 c5             	or     %rax,%rbp
  6fe0f9:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  6fe0fe:	0f 28 4c 24 20       	movaps 0x20(%rsp),%xmm1
  6fe103:	0f 11 84 24 b0 00 00 	movups %xmm0,0xb0(%rsp)
  6fe10a:	00 
  6fe10b:	0f 11 8c 24 c0 00 00 	movups %xmm1,0xc0(%rsp)
  6fe112:	00 
  6fe113:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fe118:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  6fe11f:	00 
  6fe120:	48 89 8c 24 a0 00 00 	mov    %rcx,0xa0(%rsp)
  6fe127:	00 
  6fe128:	48 89 ac 24 a8 00 00 	mov    %rbp,0xa8(%rsp)
  6fe12f:	00 
  6fe130:	48 89 0c 24          	mov    %rcx,(%rsp)
  6fe134:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fe13b:	48 39 f7             	cmp    %rsi,%rdi
  6fe13e:	0f 83 2d 03 00 00    	jae    6fe471 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6a1>
  6fe144:	4d 89 fc             	mov    %r15,%r12
  6fe147:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6fe14e:	4c 8d 2c d8          	lea    (%rax,%rbx,8),%r13
  6fe152:	4c 8b 7c d8 08       	mov    0x8(%rax,%rbx,8),%r15
  6fe157:	4d 85 ff             	test   %r15,%r15
  6fe15a:	74 28                	je     6fe184 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x3b4>
  6fe15c:	48 8b 5c d8 10       	mov    0x10(%rax,%rbx,8),%rbx
  6fe161:	48 8b 03             	mov    (%rbx),%rax
  6fe164:	48 85 c0             	test   %rax,%rax
  6fe167:	74 05                	je     6fe16e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x39e>
  6fe169:	4c 89 ff             	mov    %r15,%rdi
  6fe16c:	ff d0                	call   *%rax
  6fe16e:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fe172:	48 85 f6             	test   %rsi,%rsi
  6fe175:	74 0d                	je     6fe184 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x3b4>
  6fe177:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fe17b:	4c 89 ff             	mov    %r15,%rdi
  6fe17e:	ff 15 4c b1 42 00    	call   *0x42b14c(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fe184:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fe189:	49 89 45 08          	mov    %rax,0x8(%r13)
  6fe18d:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fe192:	49 89 45 10          	mov    %rax,0x10(%r13)
  6fe196:	48 8b 04 24          	mov    (%rsp),%rax
  6fe19a:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  6fe19e:	74 34                	je     6fe1d4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x404>
  6fe1a0:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fe1a4:	75 76                	jne    6fe21c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x44c>
  6fe1a6:	41 80 fc 01          	cmp    $0x1,%r12b
  6fe1aa:	0f 85 be 00 00 00    	jne    6fe26e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x49e>
  6fe1b0:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6fe1b5:	4c 89 f6             	mov    %r14,%rsi
  6fe1b8:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  6fe1bf:	00 
  6fe1c0:	31 c9                	xor    %ecx,%ecx
  6fe1c2:	4c 8b 84 24 e0 00 00 	mov    0xe0(%rsp),%r8
  6fe1c9:	00 
  6fe1ca:	e8 01 07 00 00       	call   6fe8d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::after_source_with_editing>
  6fe1cf:	e9 97 01 00 00       	jmp    6fe36b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x59b>
  6fe1d4:	4c 89 f7             	mov    %r14,%rdi
  6fe1d7:	e8 d4 b0 02 00       	call   7292b0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fe1dc:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fe1e1:	48 c7 00 0f 00 00 00 	movq   $0xf,(%rax)
  6fe1e8:	48 8b 9c 24 b0 00 00 	mov    0xb0(%rsp),%rbx
  6fe1ef:	00 
  6fe1f0:	48 8b 03             	mov    (%rbx),%rax
  6fe1f3:	48 85 c0             	test   %rax,%rax
  6fe1f6:	74 05                	je     6fe1fd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x42d>
  6fe1f8:	48 89 ef             	mov    %rbp,%rdi
  6fe1fb:	ff d0                	call   *%rax
  6fe1fd:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fe201:	48 85 f6             	test   %rsi,%rsi
  6fe204:	0f 84 61 01 00 00    	je     6fe36b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x59b>
  6fe20a:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fe20e:	48 89 ef             	mov    %rbp,%rdi
  6fe211:	ff 15 b9 b0 42 00    	call   *0x42b0b9(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fe217:	e9 4f 01 00 00       	jmp    6fe36b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x59b>
  6fe21c:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  6fe223:	00 
  6fe224:	49 39 86 60 06 00 00 	cmp    %rax,0x660(%r14)
  6fe22b:	74 08                	je     6fe235 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x465>
  6fe22d:	4c 89 f7             	mov    %r14,%rdi
  6fe230:	e8 7b b0 02 00       	call   7292b0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fe235:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  6fe23c:	00 
  6fe23d:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fe242:	48 89 41 30          	mov    %rax,0x30(%rcx)
  6fe246:	0f 10 84 24 a0 00 00 	movups 0xa0(%rsp),%xmm0
  6fe24d:	00 
  6fe24e:	0f 10 8c 24 b0 00 00 	movups 0xb0(%rsp),%xmm1
  6fe255:	00 
  6fe256:	0f 10 94 24 c0 00 00 	movups 0xc0(%rsp),%xmm2
  6fe25d:	00 
  6fe25e:	0f 11 51 20          	movups %xmm2,0x20(%rcx)
  6fe262:	0f 11 49 10          	movups %xmm1,0x10(%rcx)
  6fe266:	0f 11 01             	movups %xmm0,(%rcx)
  6fe269:	e9 fd 00 00 00       	jmp    6fe36b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x59b>
  6fe26e:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  6fe275:	00 
  6fe276:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  6fe27d:	00 
  6fe27e:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  6fe285:	00 
  6fe286:	74 16                	je     6fe29e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x4ce>
  6fe288:	84 c0                	test   %al,%al
  6fe28a:	0f 84 a9 00 00 00    	je     6fe339 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x569>
  6fe290:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  6fe297:	ff 
  6fe298:	0f 85 9b 00 00 00    	jne    6fe339 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x569>
  6fe29e:	31 c9                	xor    %ecx,%ecx
  6fe2a0:	e9 a0 00 00 00       	jmp    6fe345 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x575>
  6fe2a5:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fe2a9:	74 33                	je     6fe2de <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x50e>
  6fe2ab:	49 83 ec 0d          	sub    $0xd,%r12
  6fe2af:	ba 14 00 00 00       	mov    $0x14,%edx
  6fe2b4:	49 0f 4d d4          	cmovge %r12,%rdx
  6fe2b8:	48 83 fa 19          	cmp    $0x19,%rdx
  6fe2bc:	74 09                	je     6fe2c7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x4f7>
  6fe2be:	48 89 c8             	mov    %rcx,%rax
  6fe2c1:	48 83 fa 14          	cmp    $0x14,%rdx
  6fe2c5:	75 17                	jne    6fe2de <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x50e>
  6fe2c7:	48 8b 30             	mov    (%rax),%rsi
  6fe2ca:	48 85 f6             	test   %rsi,%rsi
  6fe2cd:	74 0f                	je     6fe2de <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x50e>
  6fe2cf:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fe2d3:	ba 01 00 00 00       	mov    $0x1,%edx
  6fe2d8:	ff 15 f2 af 42 00    	call   *0x42aff2(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fe2de:	48 c7 c1 fe ff ff ff 	mov    $0xfffffffffffffffe,%rcx
  6fe2e5:	41 b7 01             	mov    $0x1,%r15b
  6fe2e8:	e9 fd fd ff ff       	jmp    6fe0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x31a>
  6fe2ed:	44 0f b6 7c 24 68    	movzbl 0x68(%rsp),%r15d
  6fe2f3:	0f b6 44 24 6f       	movzbl 0x6f(%rsp),%eax
  6fe2f8:	c1 e0 10             	shl    $0x10,%eax
  6fe2fb:	0f b7 4c 24 6d       	movzwl 0x6d(%rsp),%ecx
  6fe300:	09 c1                	or     %eax,%ecx
  6fe302:	48 c1 e1 20          	shl    $0x20,%rcx
  6fe306:	8b 6c 24 69          	mov    0x69(%rsp),%ebp
  6fe30a:	48 09 cd             	or     %rcx,%rbp
  6fe30d:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  6fe312:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fe317:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  6fe31e:	00 
  6fe31f:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  6fe324:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  6fe32b:	00 
  6fe32c:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6fe331:	4c 89 e1             	mov    %r12,%rcx
  6fe334:	e9 b1 fd ff ff       	jmp    6fe0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x31a>
  6fe339:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  6fe340:	b9 01 00 00 00       	mov    $0x1,%ecx
  6fe345:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  6fe34c:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6fe351:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  6fe355:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  6fe359:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  6fe35d:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  6fe361:	88 47 30             	mov    %al,0x30(%rdi)
  6fe364:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  6fe36b:	48 81 c4 48 01 00 00 	add    $0x148,%rsp
  6fe372:	5b                   	pop    %rbx
  6fe373:	41 5c                	pop    %r12
  6fe375:	41 5d                	pop    %r13
  6fe377:	41 5e                	pop    %r14
  6fe379:	41 5f                	pop    %r15
  6fe37b:	5d                   	pop    %rbp
  6fe37c:	c3                   	ret
  6fe37d:	48 8d 3d 81 98 96 ff 	lea    -0x69677f(%rip),%rdi        # 67c05 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x988>
  6fe384:	48 8d 15 55 c9 3f 00 	lea    0x3fc955(%rip),%rdx        # aface0 <__frame_dummy_init_array_entry+0x478>
  6fe38b:	be 0e 00 00 00       	mov    $0xe,%esi
  6fe390:	ff 15 3a b0 42 00    	call   *0x42b03a(%rip)        # b293d0 <_DYNAMIC+0x348>
  6fe396:	b9 1f 00 00 00       	mov    $0x1f,%ecx
  6fe39b:	e9 4a fd ff ff       	jmp    6fe0ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x31a>
  6fe3a0:	48 8d 15 21 c9 3f 00 	lea    0x3fc921(%rip),%rdx        # afacc8 <__frame_dummy_init_array_entry+0x460>
  6fe3a7:	48 89 cf             	mov    %rcx,%rdi
  6fe3aa:	ff 15 30 b0 42 00    	call   *0x42b030(%rip)        # b293e0 <_DYNAMIC+0x358>
  6fe3b0:	49 89 c6             	mov    %rax,%r14
  6fe3b3:	e9 ee 00 00 00       	jmp    6fe4a6 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6d6>
  6fe3b8:	49 89 c6             	mov    %rax,%r14
  6fe3bb:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fe3bf:	48 85 f6             	test   %rsi,%rsi
  6fe3c2:	0f 84 eb 00 00 00    	je     6fe4b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6e3>
  6fe3c8:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fe3cc:	48 89 ef             	mov    %rbp,%rdi
  6fe3cf:	ff 15 fb ae 42 00    	call   *0x42aefb(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fe3d5:	4c 89 f7             	mov    %r14,%rdi
  6fe3d8:	e8 d3 b0 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6fe3dd:	49 89 c7             	mov    %rax,%r15
  6fe3e0:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fe3e4:	74 41                	je     6fe427 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x657>
  6fe3e6:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  6fe3eb:	e8 00 9b ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fe3f0:	eb 35                	jmp    6fe427 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x657>
  6fe3f2:	49 89 c6             	mov    %rax,%r14
  6fe3f5:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fe3f9:	48 85 f6             	test   %rsi,%rsi
  6fe3fc:	74 0d                	je     6fe40b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x63b>
  6fe3fe:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fe402:	4c 89 ff             	mov    %r15,%rdi
  6fe405:	ff 15 c5 ae 42 00    	call   *0x42aec5(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fe40b:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fe410:	49 89 45 08          	mov    %rax,0x8(%r13)
  6fe414:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  6fe419:	49 89 45 10          	mov    %rax,0x10(%r13)
  6fe41d:	eb 79                	jmp    6fe498 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6c8>
  6fe41f:	49 89 c6             	mov    %rax,%r14
  6fe422:	eb 74                	jmp    6fe498 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6c8>
  6fe424:	49 89 c7             	mov    %rax,%r15
  6fe427:	4c 89 ff             	mov    %r15,%rdi
  6fe42a:	ff 15 c0 af 42 00    	call   *0x42afc0(%rip)        # b293f0 <_DYNAMIC+0x368>
  6fe430:	48 89 c5             	mov    %rax,%rbp
  6fe433:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  6fe43a:	00 
  6fe43b:	48 89 94 24 b0 00 00 	mov    %rdx,0xb0(%rsp)
  6fe442:	00 
  6fe443:	48 c7 84 24 a0 00 00 	movq   $0xfffffffffffffffd,0xa0(%rsp)
  6fe44a:	00 fd ff ff ff 
  6fe44f:	48 c7 c1 fd ff ff ff 	mov    $0xfffffffffffffffd,%rcx
  6fe456:	41 89 ef             	mov    %ebp,%r15d
  6fe459:	48 8b 3c 24          	mov    (%rsp),%rdi
  6fe45d:	48 89 0c 24          	mov    %rcx,(%rsp)
  6fe461:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fe468:	48 39 f7             	cmp    %rsi,%rdi
  6fe46b:	0f 82 d3 fc ff ff    	jb     6fe144 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x374>
  6fe471:	48 8d 15 80 c8 3f 00 	lea    0x3fc880(%rip),%rdx        # afacf8 <__frame_dummy_init_array_entry+0x490>
  6fe478:	ff 15 62 af 42 00    	call   *0x42af62(%rip)        # b293e0 <_DYNAMIC+0x358>
  6fe47e:	0f 0b                	ud2
  6fe480:	ff 15 72 af 42 00    	call   *0x42af72(%rip)        # b293f8 <_DYNAMIC+0x370>
  6fe486:	49 89 c6             	mov    %rax,%r14
  6fe489:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  6fe48e:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  6fe493:	e8 d8 63 ff ff       	call   6f4870 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  6fe498:	48 83 3c 24 fd       	cmpq   $0xfffffffffffffffd,(%rsp)
  6fe49d:	74 1c                	je     6fe4bb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6eb>
  6fe49f:	48 83 3c 24 fe       	cmpq   $0xfffffffffffffffe,(%rsp)
  6fe4a4:	74 0d                	je     6fe4b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6e3>
  6fe4a6:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  6fe4ad:	00 
  6fe4ae:	e8 3d 9a ff ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fe4b3:	4c 89 f7             	mov    %r14,%rdi
  6fe4b6:	e8 f5 af 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6fe4bb:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  6fe4c2:	00 
  6fe4c3:	e8 48 68 ff ff       	call   6f4d10 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fe4c8:	eb e9                	jmp    6fe4b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_property+0x6e3>
  6fe4ca:	ff 15 30 ae 42 00    	call   *0x42ae30(%rip)        # b29300 <_DYNAMIC+0x278>
