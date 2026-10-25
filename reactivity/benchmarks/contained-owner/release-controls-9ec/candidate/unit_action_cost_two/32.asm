
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006faec0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property>:
  6faec0:	55                   	push   %rbp
  6faec1:	41 57                	push   %r15
  6faec3:	41 56                	push   %r14
  6faec5:	41 55                	push   %r13
  6faec7:	41 54                	push   %r12
  6faec9:	53                   	push   %rbx
  6faeca:	48 81 ec 38 01 00 00 	sub    $0x138,%rsp
  6faed1:	49 89 cc             	mov    %rcx,%r12
  6faed4:	49 89 f6             	mov    %rsi,%r14
  6faed7:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  6faedc:	48 8b b6 a0 02 00 00 	mov    0x2a0(%rsi),%rsi
  6faee3:	48 39 f1             	cmp    %rsi,%rcx
  6faee6:	0f 83 6f 05 00 00    	jae    6fb45b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x59b>
  6faeec:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6faef3:	4b 8d 1c a4          	lea    (%r12,%r12,4),%rbx
  6faef7:	48 8b 74 d8 08       	mov    0x8(%rax,%rbx,8),%rsi
  6faefc:	48 8b 4c d8 10       	mov    0x10(%rax,%rbx,8),%rcx
  6faf01:	48 c7 44 d8 08 00 00 	movq   $0x0,0x8(%rax,%rbx,8)
  6faf08:	00 00 
  6faf0a:	48 85 f6             	test   %rsi,%rsi
  6faf0d:	0f 84 21 05 00 00    	je     6fb434 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x574>
  6faf13:	48 89 94 24 d0 00 00 	mov    %rdx,0xd0(%rsp)
  6faf1a:	00 
  6faf1b:	4c 89 84 24 d8 00 00 	mov    %r8,0xd8(%rsp)
  6faf22:	00 
  6faf23:	48 89 74 24 48       	mov    %rsi,0x48(%rsp)
  6faf28:	48 89 b4 24 e0 00 00 	mov    %rsi,0xe0(%rsp)
  6faf2f:	00 
  6faf30:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  6faf35:	48 89 8c 24 e8 00 00 	mov    %rcx,0xe8(%rsp)
  6faf3c:	00 
  6faf3d:	49 8d ae 10 07 00 00 	lea    0x710(%r14),%rbp
  6faf44:	48 8d 0d bd f9 3f 00 	lea    0x3ff9bd(%rip),%rcx        # afa908 <__frame_dummy_init_array_entry+0x70>
  6faf4b:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6faf50:	48 8d b4 24 e0 00 00 	lea    0xe0(%rsp),%rsi
  6faf57:	00 
  6faf58:	48 89 ea             	mov    %rbp,%rdx
  6faf5b:	ff 15 17 e5 42 00    	call   *0x42e517(%rip)        # b29478 <_DYNAMIC+0x378>
  6faf61:	44 0f b7 7c 24 20    	movzwl 0x20(%rsp),%r15d
  6faf67:	66 41 83 ff ff       	cmp    $0xffff,%r15w
  6faf6c:	0f 84 f6 00 00 00    	je     6fb068 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x1a8>
  6faf72:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6faf77:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  6faf7c:	8b 74 24 24          	mov    0x24(%rsp),%esi
  6faf80:	0f b6 7c 24 28       	movzbl 0x28(%rsp),%edi
  6faf85:	44 0f b6 4c 24 2f    	movzbl 0x2f(%rsp),%r9d
  6faf8b:	44 0f b7 44 24 2d    	movzwl 0x2d(%rsp),%r8d
  6faf91:	8b 4c 24 29          	mov    0x29(%rsp),%ecx
  6faf95:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  6faf9a:	0f 29 84 24 10 01 00 	movaps %xmm0,0x110(%rsp)
  6fafa1:	00 
  6fafa2:	66 45 85 ff          	test   %r15w,%r15w
  6fafa6:	0f 84 f8 00 00 00    	je     6fb0a4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x1e4>
  6fafac:	41 c1 e1 10          	shl    $0x10,%r9d
  6fafb0:	45 09 c8             	or     %r9d,%r8d
  6fafb3:	49 c1 e0 20          	shl    $0x20,%r8
  6fafb7:	4c 09 c1             	or     %r8,%rcx
  6fafba:	89 b4 24 f4 00 00 00 	mov    %esi,0xf4(%rsp)
  6fafc1:	40 88 bc 24 f8 00 00 	mov    %dil,0xf8(%rsp)
  6fafc8:	00 
  6fafc9:	89 8c 24 f9 00 00 00 	mov    %ecx,0xf9(%rsp)
  6fafd0:	48 89 ce             	mov    %rcx,%rsi
  6fafd3:	48 c1 ee 30          	shr    $0x30,%rsi
  6fafd7:	40 88 b4 24 ff 00 00 	mov    %sil,0xff(%rsp)
  6fafde:	00 
  6fafdf:	48 c1 e9 20          	shr    $0x20,%rcx
  6fafe3:	66 89 8c 24 fd 00 00 	mov    %cx,0xfd(%rsp)
  6fafea:	00 
  6fafeb:	0f 28 84 24 10 01 00 	movaps 0x110(%rsp),%xmm0
  6faff2:	00 
  6faff3:	0f 11 84 24 00 01 00 	movups %xmm0,0x100(%rsp)
  6faffa:	00 
  6faffb:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  6fb002:	49 ff c5             	inc    %r13
  6fb005:	0f 84 42 04 00 00    	je     6fb44d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x58d>
  6fb00b:	49 3b 86 b0 05 00 00 	cmp    0x5b0(%r14),%rax
  6fb012:	0f 85 93 00 00 00    	jne    6fb0ab <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x1eb>
  6fb018:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fb01d:	4c 89 f6             	mov    %r14,%rsi
  6fb020:	e8 eb f3 01 00       	call   71a410 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  6fb025:	48 83 7c 24 10 fe    	cmpq   $0xfffffffffffffffe,0x10(%rsp)
  6fb02b:	0f 85 83 00 00 00    	jne    6fb0b4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x1f4>
  6fb031:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  6fb036:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  6fb03b:	4c 8d 84 24 f4 00 00 	lea    0xf4(%rsp),%r8
  6fb042:	00 
  6fb043:	4c 89 f6             	mov    %r14,%rsi
  6fb046:	44 89 f9             	mov    %r15d,%ecx
  6fb049:	e8 32 ef 02 00       	call   729f80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at>
  6fb04e:	4d 89 e7             	mov    %r12,%r15
  6fb051:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  6fb056:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fb05a:	0f 85 9e 00 00 00    	jne    6fb0fe <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x23e>
  6fb060:	45 31 c0             	xor    %r8d,%r8d
  6fb063:	e9 bb 00 00 00       	jmp    6fb123 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x263>
  6fb068:	0f b6 74 24 28       	movzbl 0x28(%rsp),%esi
  6fb06d:	0f b6 44 24 2f       	movzbl 0x2f(%rsp),%eax
  6fb072:	c1 e0 10             	shl    $0x10,%eax
  6fb075:	0f b7 4c 24 2d       	movzwl 0x2d(%rsp),%ecx
  6fb07a:	09 c1                	or     %eax,%ecx
  6fb07c:	48 c1 e1 20          	shl    $0x20,%rcx
  6fb080:	8b 6c 24 29          	mov    0x29(%rsp),%ebp
  6fb084:	48 09 cd             	or     %rcx,%rbp
  6fb087:	0f 10 44 24 30       	movups 0x30(%rsp),%xmm0
  6fb08c:	0f 29 84 24 10 01 00 	movaps %xmm0,0x110(%rsp)
  6fb093:	00 
  6fb094:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fb099:	41 bd 20 00 00 00    	mov    $0x20,%r13d
  6fb09f:	e9 bf 01 00 00       	jmp    6fb263 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x3a3>
  6fb0a4:	31 f6                	xor    %esi,%esi
  6fb0a6:	e9 66 01 00 00       	jmp    6fb211 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x351>
  6fb0ab:	48 c7 44 24 10 11 00 	movq   $0x11,0x10(%rsp)
  6fb0b2:	00 00 
  6fb0b4:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fb0b9:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  6fb0c0:	00 
  6fb0c1:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  6fb0c6:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  6fb0cb:	0f 10 44 24 20       	movups 0x20(%rsp),%xmm0
  6fb0d0:	0f 10 4c 24 30       	movups 0x30(%rsp),%xmm1
  6fb0d5:	0f 29 8c 24 80 00 00 	movaps %xmm1,0x80(%rsp)
  6fb0dc:	00 
  6fb0dd:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  6fb0e2:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  6fb0e7:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  6fb0ec:	4d 89 e7             	mov    %r12,%r15
  6fb0ef:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  6fb0f4:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fb0f8:	0f 84 62 ff ff ff    	je     6fb060 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x1a0>
  6fb0fe:	4c 89 e1             	mov    %r12,%rcx
  6fb101:	48 83 e9 0d          	sub    $0xd,%rcx
  6fb105:	b8 14 00 00 00       	mov    $0x14,%eax
  6fb10a:	48 0f 4d c1          	cmovge %rcx,%rax
  6fb10e:	4c 8d 44 24 60       	lea    0x60(%rsp),%r8
  6fb113:	48 83 f8 17          	cmp    $0x17,%rax
  6fb117:	74 0a                	je     6fb123 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x263>
  6fb119:	48 83 f8 04          	cmp    $0x4,%rax
  6fb11d:	0f 85 f7 00 00 00    	jne    6fb21a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x35a>
  6fb123:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  6fb12a:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  6fb131:	48 8d 0d d0 f7 3f 00 	lea    0x3ff7d0(%rip),%rcx        # afa908 <__frame_dummy_init_array_entry+0x70>
  6fb138:	48 8d bc 24 20 01 00 	lea    0x120(%rsp),%rdi
  6fb13f:	00 
  6fb140:	48 8d b4 24 e0 00 00 	lea    0xe0(%rsp),%rsi
  6fb147:	00 
  6fb148:	48 89 ea             	mov    %rbp,%rdx
  6fb14b:	ff 15 2f e3 42 00    	call   *0x42e32f(%rip)        # b29480 <_DYNAMIC+0x380>
  6fb151:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  6fb156:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  6fb15b:	48 8b b4 24 20 01 00 	mov    0x120(%rsp),%rsi
  6fb162:	00 
  6fb163:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  6fb167:	74 69                	je     6fb1d2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x312>
  6fb169:	48 89 f5             	mov    %rsi,%rbp
  6fb16c:	48 c1 ed 08          	shr    $0x8,%rbp
  6fb170:	0f 10 84 24 28 01 00 	movups 0x128(%rsp),%xmm0
  6fb177:	00 
  6fb178:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fb17d:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fb181:	74 44                	je     6fb1c7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x307>
  6fb183:	49 83 ec 0d          	sub    $0xd,%r12
  6fb187:	ba 14 00 00 00       	mov    $0x14,%edx
  6fb18c:	49 0f 4d d4          	cmovge %r12,%rdx
  6fb190:	48 83 fa 19          	cmp    $0x19,%rdx
  6fb194:	74 09                	je     6fb19f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x2df>
  6fb196:	48 89 c8             	mov    %rcx,%rax
  6fb199:	48 83 fa 14          	cmp    $0x14,%rdx
  6fb19d:	75 28                	jne    6fb1c7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x307>
  6fb19f:	49 89 f5             	mov    %rsi,%r13
  6fb1a2:	48 8b 30             	mov    (%rax),%rsi
  6fb1a5:	48 85 f6             	test   %rsi,%rsi
  6fb1a8:	74 0f                	je     6fb1b9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x2f9>
  6fb1aa:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fb1ae:	ba 01 00 00 00       	mov    $0x1,%edx
  6fb1b3:	ff 15 8f e1 42 00    	call   *0x42e18f(%rip)        # b29348 <_DYNAMIC+0x248>
  6fb1b9:	41 bc 20 00 00 00    	mov    $0x20,%r12d
  6fb1bf:	4c 89 ee             	mov    %r13,%rsi
  6fb1c2:	e9 96 00 00 00       	jmp    6fb25d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x39d>
  6fb1c7:	41 bc 20 00 00 00    	mov    $0x20,%r12d
  6fb1cd:	e9 8b 00 00 00       	jmp    6fb25d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x39d>
  6fb1d2:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fb1d6:	74 33                	je     6fb20b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x34b>
  6fb1d8:	49 83 ec 0d          	sub    $0xd,%r12
  6fb1dc:	ba 14 00 00 00       	mov    $0x14,%edx
  6fb1e1:	49 0f 4d d4          	cmovge %r12,%rdx
  6fb1e5:	48 83 fa 19          	cmp    $0x19,%rdx
  6fb1e9:	74 09                	je     6fb1f4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x334>
  6fb1eb:	48 89 c8             	mov    %rcx,%rax
  6fb1ee:	48 83 fa 14          	cmp    $0x14,%rdx
  6fb1f2:	75 17                	jne    6fb20b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x34b>
  6fb1f4:	48 8b 30             	mov    (%rax),%rsi
  6fb1f7:	48 85 f6             	test   %rsi,%rsi
  6fb1fa:	74 0f                	je     6fb20b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x34b>
  6fb1fc:	48 8b 78 08          	mov    0x8(%rax),%rdi
  6fb200:	ba 01 00 00 00       	mov    $0x1,%edx
  6fb205:	ff 15 3d e1 42 00    	call   *0x42e13d(%rip)        # b29348 <_DYNAMIC+0x248>
  6fb20b:	40 b6 01             	mov    $0x1,%sil
  6fb20e:	4d 89 fc             	mov    %r15,%r12
  6fb211:	49 c7 c5 fe ff ff ff 	mov    $0xfffffffffffffffe,%r13
  6fb218:	eb 49                	jmp    6fb263 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x3a3>
  6fb21a:	0f b6 74 24 68       	movzbl 0x68(%rsp),%esi
  6fb21f:	0f b6 44 24 6f       	movzbl 0x6f(%rsp),%eax
  6fb224:	c1 e0 10             	shl    $0x10,%eax
  6fb227:	0f b7 4c 24 6d       	movzwl 0x6d(%rsp),%ecx
  6fb22c:	09 c1                	or     %eax,%ecx
  6fb22e:	48 c1 e1 20          	shl    $0x20,%rcx
  6fb232:	8b 6c 24 69          	mov    0x69(%rsp),%ebp
  6fb236:	48 09 cd             	or     %rcx,%rbp
  6fb239:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  6fb23e:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6fb243:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
  6fb24a:	00 
  6fb24b:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  6fb250:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  6fb257:	00 
  6fb258:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  6fb25d:	4d 89 e5             	mov    %r12,%r13
  6fb260:	4d 89 fc             	mov    %r15,%r12
  6fb263:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
  6fb268:	40 0f b6 c6          	movzbl %sil,%eax
  6fb26c:	48 c1 e5 08          	shl    $0x8,%rbp
  6fb270:	48 09 c5             	or     %rax,%rbp
  6fb273:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  6fb278:	0f 28 4c 24 20       	movaps 0x20(%rsp),%xmm1
  6fb27d:	0f 11 84 24 a8 00 00 	movups %xmm0,0xa8(%rsp)
  6fb284:	00 
  6fb285:	0f 11 8c 24 b8 00 00 	movups %xmm1,0xb8(%rsp)
  6fb28c:	00 
  6fb28d:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fb292:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  6fb299:	00 
  6fb29a:	4c 89 ac 24 98 00 00 	mov    %r13,0x98(%rsp)
  6fb2a1:	00 
  6fb2a2:	48 89 ac 24 a0 00 00 	mov    %rbp,0xa0(%rsp)
  6fb2a9:	00 
  6fb2aa:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fb2b1:	49 39 f4             	cmp    %rsi,%r12
  6fb2b4:	0f 83 68 02 00 00    	jae    6fb522 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x662>
  6fb2ba:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  6fb2c1:	4c 8d 24 d8          	lea    (%rax,%rbx,8),%r12
  6fb2c5:	4c 8b 7c d8 08       	mov    0x8(%rax,%rbx,8),%r15
  6fb2ca:	4d 85 ff             	test   %r15,%r15
  6fb2cd:	74 28                	je     6fb2f7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x437>
  6fb2cf:	48 8b 5c d8 10       	mov    0x10(%rax,%rbx,8),%rbx
  6fb2d4:	48 8b 03             	mov    (%rbx),%rax
  6fb2d7:	48 85 c0             	test   %rax,%rax
  6fb2da:	74 05                	je     6fb2e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x421>
  6fb2dc:	4c 89 ff             	mov    %r15,%rdi
  6fb2df:	ff d0                	call   *%rax
  6fb2e1:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fb2e5:	48 85 f6             	test   %rsi,%rsi
  6fb2e8:	74 0d                	je     6fb2f7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x437>
  6fb2ea:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fb2ee:	4c 89 ff             	mov    %r15,%rdi
  6fb2f1:	ff 15 51 e0 42 00    	call   *0x42e051(%rip)        # b29348 <_DYNAMIC+0x248>
  6fb2f7:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6fb2fc:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  6fb301:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fb306:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  6fb30b:	49 83 fd fd          	cmp    $0xfffffffffffffffd,%r13
  6fb30f:	74 35                	je     6fb346 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x486>
  6fb311:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  6fb315:	75 77                	jne    6fb38e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x4ce>
  6fb317:	80 7c 24 58 01       	cmpb   $0x1,0x58(%rsp)
  6fb31c:	0f 85 a2 00 00 00    	jne    6fb3c4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x504>
  6fb322:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6fb327:	4c 89 f6             	mov    %r14,%rsi
  6fb32a:	48 8b 94 24 d0 00 00 	mov    0xd0(%rsp),%rdx
  6fb331:	00 
  6fb332:	31 c9                	xor    %ecx,%ecx
  6fb334:	4c 8b 84 24 d8 00 00 	mov    0xd8(%rsp),%r8
  6fb33b:	00 
  6fb33c:	e8 4f 06 00 00       	call   6fb990 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing>
  6fb341:	e9 dc 00 00 00       	jmp    6fb422 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x562>
  6fb346:	4c 89 f7             	mov    %r14,%rdi
  6fb349:	e8 52 f7 01 00       	call   71aaa0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fb34e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fb353:	48 c7 00 0f 00 00 00 	movq   $0xf,(%rax)
  6fb35a:	48 8b 9c 24 a8 00 00 	mov    0xa8(%rsp),%rbx
  6fb361:	00 
  6fb362:	48 8b 03             	mov    (%rbx),%rax
  6fb365:	48 85 c0             	test   %rax,%rax
  6fb368:	74 05                	je     6fb36f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x4af>
  6fb36a:	48 89 ef             	mov    %rbp,%rdi
  6fb36d:	ff d0                	call   *%rax
  6fb36f:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fb373:	48 85 f6             	test   %rsi,%rsi
  6fb376:	0f 84 a6 00 00 00    	je     6fb422 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x562>
  6fb37c:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fb380:	48 89 ef             	mov    %rbp,%rdi
  6fb383:	ff 15 bf df 42 00    	call   *0x42dfbf(%rip)        # b29348 <_DYNAMIC+0x248>
  6fb389:	e9 94 00 00 00       	jmp    6fb422 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x562>
  6fb38e:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  6fb395:	00 
  6fb396:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fb39b:	48 89 41 30          	mov    %rax,0x30(%rcx)
  6fb39f:	0f 10 84 24 98 00 00 	movups 0x98(%rsp),%xmm0
  6fb3a6:	00 
  6fb3a7:	0f 10 8c 24 a8 00 00 	movups 0xa8(%rsp),%xmm1
  6fb3ae:	00 
  6fb3af:	0f 10 94 24 b8 00 00 	movups 0xb8(%rsp),%xmm2
  6fb3b6:	00 
  6fb3b7:	0f 11 51 20          	movups %xmm2,0x20(%rcx)
  6fb3bb:	0f 11 49 10          	movups %xmm1,0x10(%rcx)
  6fb3bf:	0f 11 01             	movups %xmm0,(%rcx)
  6fb3c2:	eb 5e                	jmp    6fb422 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x562>
  6fb3c4:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  6fb3cb:	00 
  6fb3cc:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  6fb3d3:	00 
  6fb3d4:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  6fb3db:	00 
  6fb3dc:	74 0e                	je     6fb3ec <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x52c>
  6fb3de:	84 c0                	test   %al,%al
  6fb3e0:	74 0e                	je     6fb3f0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x530>
  6fb3e2:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  6fb3e9:	ff 
  6fb3ea:	75 04                	jne    6fb3f0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x530>
  6fb3ec:	31 c9                	xor    %ecx,%ecx
  6fb3ee:	eb 0c                	jmp    6fb3fc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x53c>
  6fb3f0:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  6fb3f7:	b9 01 00 00 00       	mov    $0x1,%ecx
  6fb3fc:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  6fb403:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  6fb408:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  6fb40c:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  6fb410:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  6fb414:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  6fb418:	88 47 30             	mov    %al,0x30(%rdi)
  6fb41b:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  6fb422:	48 81 c4 38 01 00 00 	add    $0x138,%rsp
  6fb429:	5b                   	pop    %rbx
  6fb42a:	41 5c                	pop    %r12
  6fb42c:	41 5d                	pop    %r13
  6fb42e:	41 5e                	pop    %r14
  6fb430:	41 5f                	pop    %r15
  6fb432:	5d                   	pop    %rbp
  6fb433:	c3                   	ret
  6fb434:	48 8d 3d 2a c8 96 ff 	lea    -0x6937d6(%rip),%rdi        # 67c65 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x988>
  6fb43b:	48 8d 15 ce f8 3f 00 	lea    0x3ff8ce(%rip),%rdx        # afad10 <__frame_dummy_init_array_entry+0x478>
  6fb442:	be 0e 00 00 00       	mov    $0xe,%esi
  6fb447:	ff 15 fb df 42 00    	call   *0x42dffb(%rip)        # b29448 <_DYNAMIC+0x348>
  6fb44d:	4d 89 e7             	mov    %r12,%r15
  6fb450:	41 bc 1f 00 00 00    	mov    $0x1f,%r12d
  6fb456:	e9 02 fe ff ff       	jmp    6fb25d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x39d>
  6fb45b:	48 8d 15 96 f8 3f 00 	lea    0x3ff896(%rip),%rdx        # afacf8 <__frame_dummy_init_array_entry+0x460>
  6fb462:	4c 89 e7             	mov    %r12,%rdi
  6fb465:	ff 15 ed df 42 00    	call   *0x42dfed(%rip)        # b29458 <_DYNAMIC+0x358>
  6fb46b:	49 89 c6             	mov    %rax,%r14
  6fb46e:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fb472:	48 85 f6             	test   %rsi,%rsi
  6fb475:	74 0d                	je     6fb484 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x5c4>
  6fb477:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fb47b:	48 89 ef             	mov    %rbp,%rdi
  6fb47e:	ff 15 c4 de 42 00    	call   *0x42dec4(%rip)        # b29348 <_DYNAMIC+0x248>
  6fb484:	4c 89 f7             	mov    %r14,%rdi
  6fb487:	e8 54 e0 3f 00       	call   af94e0 <_Unwind_Resume@plt>
  6fb48c:	49 89 c5             	mov    %rax,%r13
  6fb48f:	49 83 fc fe          	cmp    $0xfffffffffffffffe,%r12
  6fb493:	74 46                	je     6fb4db <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x61b>
  6fb495:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  6fb49a:	e8 41 cb ff ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fb49f:	eb 3a                	jmp    6fb4db <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x61b>
  6fb4a1:	49 89 c6             	mov    %rax,%r14
  6fb4a4:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  6fb4a8:	48 85 f6             	test   %rsi,%rsi
  6fb4ab:	74 0d                	je     6fb4ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x5fa>
  6fb4ad:	48 8b 53 10          	mov    0x10(%rbx),%rdx
  6fb4b1:	4c 89 ff             	mov    %r15,%rdi
  6fb4b4:	ff 15 8e de 42 00    	call   *0x42de8e(%rip)        # b29348 <_DYNAMIC+0x248>
  6fb4ba:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6fb4bf:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  6fb4c4:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  6fb4c9:	49 89 44 24 10       	mov    %rax,0x10(%r12)
  6fb4ce:	eb 7c                	jmp    6fb54c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x68c>
  6fb4d0:	49 89 c6             	mov    %rax,%r14
  6fb4d3:	eb 77                	jmp    6fb54c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x68c>
  6fb4d5:	4d 89 e7             	mov    %r12,%r15
  6fb4d8:	49 89 c5             	mov    %rax,%r13
  6fb4db:	4c 89 ef             	mov    %r13,%rdi
  6fb4de:	ff 15 84 df 42 00    	call   *0x42df84(%rip)        # b29468 <_DYNAMIC+0x368>
  6fb4e4:	48 89 c5             	mov    %rax,%rbp
  6fb4e7:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  6fb4ee:	00 
  6fb4ef:	48 89 94 24 a8 00 00 	mov    %rdx,0xa8(%rsp)
  6fb4f6:	00 
  6fb4f7:	48 c7 84 24 98 00 00 	movq   $0xfffffffffffffffd,0x98(%rsp)
  6fb4fe:	00 fd ff ff ff 
  6fb503:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fb508:	4d 89 fc             	mov    %r15,%r12
  6fb50b:	49 c7 c5 fd ff ff ff 	mov    $0xfffffffffffffffd,%r13
  6fb512:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fb519:	49 39 f4             	cmp    %rsi,%r12
  6fb51c:	0f 82 98 fd ff ff    	jb     6fb2ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x3fa>
  6fb522:	48 8d 15 ff f7 3f 00 	lea    0x3ff7ff(%rip),%rdx        # afad28 <__frame_dummy_init_array_entry+0x490>
  6fb529:	4c 89 e7             	mov    %r12,%rdi
  6fb52c:	ff 15 26 df 42 00    	call   *0x42df26(%rip)        # b29458 <_DYNAMIC+0x358>
  6fb532:	0f 0b                	ud2
  6fb534:	ff 15 36 df 42 00    	call   *0x42df36(%rip)        # b29470 <_DYNAMIC+0x370>
  6fb53a:	49 89 c6             	mov    %rax,%r14
  6fb53d:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  6fb542:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  6fb547:	e8 14 94 ff ff       	call   6f4960 <core::ptr::drop_glue::<core::option::Option<gpui::element::Handler>>>
  6fb54c:	49 83 fd fd          	cmp    $0xfffffffffffffffd,%r13
  6fb550:	74 1f                	je     6fb571 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x6b1>
  6fb552:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  6fb556:	0f 84 28 ff ff ff    	je     6fb484 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x5c4>
  6fb55c:	48 8d bc 24 98 00 00 	lea    0x98(%rsp),%rdi
  6fb563:	00 
  6fb564:	e8 77 ca ff ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fb569:	4c 89 f7             	mov    %r14,%rdi
  6fb56c:	e8 6f df 3f 00       	call   af94e0 <_Unwind_Resume@plt>
  6fb571:	48 8d bc 24 98 00 00 	lea    0x98(%rsp),%rdi
  6fb578:	00 
  6fb579:	e8 82 98 ff ff       	call   6f4e00 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fb57e:	e9 01 ff ff ff       	jmp    6fb484 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_property+0x5c4>
  6fb583:	ff 15 ef dd 42 00    	call   *0x42ddef(%rip)        # b29378 <_DYNAMIC+0x278>
