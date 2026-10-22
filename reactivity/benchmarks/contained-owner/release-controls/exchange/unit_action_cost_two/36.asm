
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000729ef0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at>:
  729ef0:	55                   	push   %rbp
  729ef1:	41 57                	push   %r15
  729ef3:	41 56                	push   %r14
  729ef5:	41 55                	push   %r13
  729ef7:	41 54                	push   %r12
  729ef9:	53                   	push   %rbx
  729efa:	48 81 ec f8 01 00 00 	sub    $0x1f8,%rsp
  729f01:	4d 89 c5             	mov    %r8,%r13
  729f04:	89 cd                	mov    %ecx,%ebp
  729f06:	49 89 d7             	mov    %rdx,%r15
  729f09:	49 89 f6             	mov    %rsi,%r14
  729f0c:	48 89 fb             	mov    %rdi,%rbx
  729f0f:	45 0f b6 20          	movzbl (%r8),%r12d
  729f13:	41 80 fc ff          	cmp    $0xff,%r12b
  729f17:	74 1c                	je     729f35 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x45>
  729f19:	89 ef                	mov    %ebp,%edi
  729f1b:	4c 89 ee             	mov    %r13,%rsi
  729f1e:	ff 15 6c f6 3f 00    	call   *0x3ff66c(%rip)        # b29590 <_DYNAMIC+0x508>
  729f24:	66 85 c0             	test   %ax,%ax
  729f27:	74 0c                	je     729f35 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x45>
  729f29:	48 89 c1             	mov    %rax,%rcx
  729f2c:	48 c1 e9 10          	shr    $0x10,%rcx
  729f30:	e9 28 06 00 00       	jmp    72a55d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x66d>
  729f35:	0f b7 c5             	movzwl %bp,%eax
  729f38:	48 8d 0d c9 19 3d 00 	lea    0x3d19c9(%rip),%rcx        # afb908 <__frame_dummy_init_array_entry+0x10a0>
  729f3f:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  729f44:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  729f48:	74 78                	je     729fc2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xd2>
  729f4a:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  729f51:	49 39 f7             	cmp    %rsi,%r15
  729f54:	0f 83 d7 0b 00 00    	jae    72ab31 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc41>
  729f5a:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  729f61:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  729f65:	4c 8b 3c c8          	mov    (%rax,%rcx,8),%r15
  729f69:	4d 8b a6 10 06 00 00 	mov    0x610(%r14),%r12
  729f70:	4d 85 e4             	test   %r12,%r12
  729f73:	0f 84 d4 00 00 00    	je     72a04d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x15d>
  729f79:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  729f80:	00 
  729f81:	48 85 ff             	test   %rdi,%rdi
  729f84:	0f 84 22 05 00 00    	je     72a4ac <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x5bc>
  729f8a:	4c 89 fe             	mov    %r15,%rsi
  729f8d:	ff 15 bd f6 3f 00    	call   *0x3ff6bd(%rip)        # b29650 <_DYNAMIC+0x5c8>
  729f93:	4d 8b a6 10 06 00 00 	mov    0x610(%r14),%r12
  729f9a:	66 0f 7e 84 24 e8 00 	movd   %xmm0,0xe8(%rsp)
  729fa1:	00 00 
  729fa3:	4d 85 e4             	test   %r12,%r12
  729fa6:	0f 84 b0 00 00 00    	je     72a05c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x16c>
  729fac:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  729fb3:	00 
  729fb4:	48 85 ff             	test   %rdi,%rdi
  729fb7:	0f 85 81 05 00 00    	jne    72a53e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x64e>
  729fbd:	e9 06 05 00 00       	jmp    72a4c8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x5d8>
  729fc2:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  729fc9:	49 39 f7             	cmp    %rsi,%r15
  729fcc:	0f 83 6f 0b 00 00    	jae    72ab41 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc51>
  729fd2:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  729fd9:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  729fdd:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  729fe1:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  729fe6:	49 8b 86 00 02 00 00 	mov    0x200(%r14),%rax
  729fed:	48 8d 0d 44 19 93 ff 	lea    -0x6ce6bc(%rip),%rcx        # 5b938 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x138>
  729ff4:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  729ff8:	48 01 c8             	add    %rcx,%rax
  729ffb:	ff e0                	jmp    *%rax
  729ffd:	0f 10 05 ec 1a 93 ff 	movups -0x6ce514(%rip),%xmm0        # 5baf0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2f0>
  72a004:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  72a009:	0f 10 05 d0 1a 93 ff 	movups -0x6ce530(%rip),%xmm0        # 5bae0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e0>
  72a010:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  72a015:	0f 10 05 b4 1a 93 ff 	movups -0x6ce54c(%rip),%xmm0        # 5bad0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2d0>
  72a01c:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  72a021:	0f 10 05 98 1a 93 ff 	movups -0x6ce568(%rip),%xmm0        # 5bac0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c0>
  72a028:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  72a02d:	0f 10 05 7c 1a 93 ff 	movups -0x6ce584(%rip),%xmm0        # 5bab0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2b0>
  72a034:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  72a039:	48 b8 00 00 00 00 01 	movabs $0x3000100000000,%rax
  72a040:	00 03 00 
  72a043:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  72a048:	e9 81 01 00 00       	jmp    72a1ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x2de>
  72a04d:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  72a054:	00 00 00 00 
  72a058:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72a05c:	66 0f 7e 44 24 70    	movd   %xmm0,0x70(%rsp)
  72a062:	ff 15 80 f2 3f 00    	call   *0x3ff280(%rip)        # b292e8 <_DYNAMIC+0x260>
  72a068:	bf 08 01 00 00       	mov    $0x108,%edi
  72a06d:	be 08 00 00 00       	mov    $0x8,%esi
  72a072:	ff 15 50 f2 3f 00    	call   *0x3ff250(%rip)        # b292c8 <_DYNAMIC+0x240>
  72a078:	48 85 c0             	test   %rax,%rax
  72a07b:	0f 84 83 0a 00 00    	je     72ab04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc14>
  72a081:	49 89 c4             	mov    %rax,%r12
  72a084:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72a088:	f3 0f 7f 80 d8 00 00 	movdqu %xmm0,0xd8(%rax)
  72a08f:	00 
  72a090:	f3 0f 7f 40 28       	movdqu %xmm0,0x28(%rax)
  72a095:	f3 0f 7f 40 40       	movdqu %xmm0,0x40(%rax)
  72a09a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  72a0a1:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  72a0a8:	00 
  72a0a9:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  72a0b0:	00 
  72a0b1:	48 c7 40 38 08 00 00 	movq   $0x8,0x38(%rax)
  72a0b8:	00 
  72a0b9:	48 c7 40 50 08 00 00 	movq   $0x8,0x50(%rax)
  72a0c0:	00 
  72a0c1:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  72a0c8:	00 
  72a0c9:	48 c7 40 60 ff ff ff 	movq   $0xffffffffffffffff,0x60(%rax)
  72a0d0:	ff 
  72a0d1:	48 c7 80 c0 00 00 00 	movq   $0x0,0xc0(%rax)
  72a0d8:	00 00 00 00 
  72a0dc:	48 c7 80 c8 00 00 00 	movq   $0x8,0xc8(%rax)
  72a0e3:	08 00 00 00 
  72a0e7:	48 c7 80 d0 00 00 00 	movq   $0x0,0xd0(%rax)
  72a0ee:	00 00 00 00 
  72a0f2:	48 c7 80 e8 00 00 00 	movq   $0x0,0xe8(%rax)
  72a0f9:	00 00 00 00 
  72a0fd:	f3 0f 7f 80 f8 00 00 	movdqu %xmm0,0xf8(%rax)
  72a104:	00 
  72a105:	49 89 86 10 06 00 00 	mov    %rax,0x610(%r14)
  72a10c:	66 0f 6e 44 24 70    	movd   0x70(%rsp),%xmm0
  72a112:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72a119:	00 
  72a11a:	48 85 ff             	test   %rdi,%rdi
  72a11d:	0f 85 1b 04 00 00    	jne    72a53e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x64e>
  72a123:	e9 a0 03 00 00       	jmp    72a4c8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x5d8>
  72a128:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  72a12f:	49 39 f7             	cmp    %rsi,%r15
  72a132:	0f 83 19 0a 00 00    	jae    72ab51 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc61>
  72a138:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  72a13f:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  72a146:	42 0f b6 3c 38       	movzbl (%rax,%r15,1),%edi
  72a14b:	48 39 fe             	cmp    %rdi,%rsi
  72a14e:	0f 86 1d 0a 00 00    	jbe    72ab71 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc81>
  72a154:	49 8b 86 08 02 00 00 	mov    0x208(%r14),%rax
  72a15b:	48 6b cf 58          	imul   $0x58,%rdi,%rcx
  72a15f:	eb 32                	jmp    72a193 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x2a3>
  72a161:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  72a168:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  72a16d:	4c 89 fa             	mov    %r15,%rdx
  72a170:	ff 15 4a f2 3f 00    	call   *0x3ff24a(%rip)        # b293c0 <_DYNAMIC+0x338>
  72a176:	eb 56                	jmp    72a1ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x2de>
  72a178:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  72a17f:	49 39 f7             	cmp    %rsi,%r15
  72a182:	0f 83 d9 09 00 00    	jae    72ab61 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc71>
  72a188:	49 8b 86 10 02 00 00 	mov    0x210(%r14),%rax
  72a18f:	49 6b cf 58          	imul   $0x58,%r15,%rcx
  72a193:	48 8b 54 08 50       	mov    0x50(%rax,%rcx,1),%rdx
  72a198:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  72a19d:	0f 10 44 08 40       	movups 0x40(%rax,%rcx,1),%xmm0
  72a1a2:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  72a1a7:	0f 10 04 08          	movups (%rax,%rcx,1),%xmm0
  72a1ab:	0f 10 4c 08 10       	movups 0x10(%rax,%rcx,1),%xmm1
  72a1b0:	0f 10 54 08 20       	movups 0x20(%rax,%rcx,1),%xmm2
  72a1b5:	0f 10 5c 08 30       	movups 0x30(%rax,%rcx,1),%xmm3
  72a1ba:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
  72a1bf:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  72a1c4:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  72a1c9:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  72a1ce:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  72a1d5:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  72a1dc:	00 
  72a1dd:	4c 89 fa             	mov    %r15,%rdx
  72a1e0:	ff 15 ca f5 3f 00    	call   *0x3ff5ca(%rip)        # b297b0 <_DYNAMIC+0x728>
  72a1e6:	80 bc 24 40 01 00 00 	cmpb   $0x0,0x140(%rsp)
  72a1ed:	00 
  72a1ee:	74 1a                	je     72a20a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x31a>
  72a1f0:	48 8d 94 24 44 01 00 	lea    0x144(%rsp),%rdx
  72a1f7:	00 
  72a1f8:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  72a1ff:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  72a204:	ff 15 ae f5 3f 00    	call   *0x3ff5ae(%rip)        # b297b8 <_DYNAMIC+0x730>
  72a20a:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  72a211:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  72a216:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  72a21d:	00 
  72a21e:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
  72a223:	0f 29 84 24 80 01 00 	movaps %xmm0,0x180(%rsp)
  72a22a:	00 
  72a22b:	66 0f 6f 44 24 10    	movdqa 0x10(%rsp),%xmm0
  72a231:	66 0f 6f 4c 24 20    	movdqa 0x20(%rsp),%xmm1
  72a237:	0f 28 54 24 30       	movaps 0x30(%rsp),%xmm2
  72a23c:	0f 28 5c 24 40       	movaps 0x40(%rsp),%xmm3
  72a241:	0f 29 9c 24 70 01 00 	movaps %xmm3,0x170(%rsp)
  72a248:	00 
  72a249:	0f 29 94 24 60 01 00 	movaps %xmm2,0x160(%rsp)
  72a250:	00 
  72a251:	66 0f 7f 8c 24 50 01 	movdqa %xmm1,0x150(%rsp)
  72a258:	00 00 
  72a25a:	66 0f 7f 84 24 40 01 	movdqa %xmm0,0x140(%rsp)
  72a261:	00 00 
  72a263:	48 8d bc 24 a0 01 00 	lea    0x1a0(%rsp),%rdi
  72a26a:	00 
  72a26b:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  72a272:	00 
  72a273:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  72a278:	41 89 e8             	mov    %ebp,%r8d
  72a27b:	4d 89 e9             	mov    %r13,%r9
  72a27e:	e8 7d 4d 04 00       	call   76f000 <<gpui::property::Overrides>::set_value>
  72a283:	44 8b ac 24 a0 01 00 	mov    0x1a0(%rsp),%r13d
  72a28a:	00 
  72a28b:	41 83 fd 02          	cmp    $0x2,%r13d
  72a28f:	75 2b                	jne    72a2bc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x3cc>
  72a291:	0f b7 84 24 a8 01 00 	movzwl 0x1a8(%rsp),%eax
  72a298:	00 
  72a299:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  72a29e:	8b 8c 24 a4 01 00 00 	mov    0x1a4(%rsp),%ecx
  72a2a5:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  72a2a9:	66 89 43 0c          	mov    %ax,0xc(%rbx)
  72a2ad:	89 4b 08             	mov    %ecx,0x8(%rbx)
  72a2b0:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  72a2b7:	e9 36 08 00 00       	jmp    72aaf2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc02>
  72a2bc:	45 31 c0             	xor    %r8d,%r8d
  72a2bf:	41 80 fc ff          	cmp    $0xff,%r12b
  72a2c3:	41 0f 95 c0          	setne  %r8b
  72a2c7:	0f b7 84 24 a8 01 00 	movzwl 0x1a8(%rsp),%eax
  72a2ce:	00 
  72a2cf:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  72a2d4:	8b 8c 24 a4 01 00 00 	mov    0x1a4(%rsp),%ecx
  72a2db:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  72a2df:	0f 10 84 24 aa 01 00 	movups 0x1aa(%rsp),%xmm0
  72a2e6:	00 
  72a2e7:	0f 11 84 24 f2 00 00 	movups %xmm0,0xf2(%rsp)
  72a2ee:	00 
  72a2ef:	0f 10 84 24 ba 01 00 	movups 0x1ba(%rsp),%xmm0
  72a2f6:	00 
  72a2f7:	0f 11 84 24 02 01 00 	movups %xmm0,0x102(%rsp)
  72a2fe:	00 
  72a2ff:	0f 10 84 24 ca 01 00 	movups 0x1ca(%rsp),%xmm0
  72a306:	00 
  72a307:	0f 11 84 24 12 01 00 	movups %xmm0,0x112(%rsp)
  72a30e:	00 
  72a30f:	0f 10 84 24 da 01 00 	movups 0x1da(%rsp),%xmm0
  72a316:	00 
  72a317:	0f 11 84 24 22 01 00 	movups %xmm0,0x122(%rsp)
  72a31e:	00 
  72a31f:	0f 10 84 24 e8 01 00 	movups 0x1e8(%rsp),%xmm0
  72a326:	00 
  72a327:	0f 11 84 24 30 01 00 	movups %xmm0,0x130(%rsp)
  72a32e:	00 
  72a32f:	44 89 ac 24 e8 00 00 	mov    %r13d,0xe8(%rsp)
  72a336:	00 
  72a337:	66 89 84 24 f0 00 00 	mov    %ax,0xf0(%rsp)
  72a33e:	00 
  72a33f:	89 8c 24 ec 00 00 00 	mov    %ecx,0xec(%rsp)
  72a346:	0f 10 84 24 28 01 00 	movups 0x128(%rsp),%xmm0
  72a34d:	00 
  72a34e:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  72a355:	00 
  72a356:	0f 10 84 24 18 01 00 	movups 0x118(%rsp),%xmm0
  72a35d:	00 
  72a35e:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  72a365:	00 
  72a366:	0f 10 84 24 08 01 00 	movups 0x108(%rsp),%xmm0
  72a36d:	00 
  72a36e:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  72a375:	00 
  72a376:	0f 10 84 24 f8 00 00 	movups 0xf8(%rsp),%xmm0
  72a37d:	00 
  72a37e:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  72a385:	00 
  72a386:	0f 10 84 24 e8 00 00 	movups 0xe8(%rsp),%xmm0
  72a38d:	00 
  72a38e:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  72a395:	00 
  72a396:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  72a39d:	00 
  72a39e:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  72a3a5:	00 
  72a3a6:	4d 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%r9
  72a3ad:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
  72a3b4:	00 
  72a3b5:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  72a3bc:	00 
  72a3bd:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  72a3c4:	00 
  72a3c5:	f3 0f 6f 84 24 f8 00 	movdqu 0xf8(%rsp),%xmm0
  72a3cc:	00 00 
  72a3ce:	f3 0f 6f 8c 24 08 01 	movdqu 0x108(%rsp),%xmm1
  72a3d5:	00 00 
  72a3d7:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  72a3de:	00 
  72a3df:	0f 10 9c 24 28 01 00 	movups 0x128(%rsp),%xmm3
  72a3e6:	00 
  72a3e7:	0f 29 9c 24 80 01 00 	movaps %xmm3,0x180(%rsp)
  72a3ee:	00 
  72a3ef:	0f 29 94 24 70 01 00 	movaps %xmm2,0x170(%rsp)
  72a3f6:	00 
  72a3f7:	66 0f 7f 8c 24 60 01 	movdqa %xmm1,0x160(%rsp)
  72a3fe:	00 00 
  72a400:	66 0f 7f 84 24 50 01 	movdqa %xmm0,0x150(%rsp)
  72a407:	00 00 
  72a409:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  72a410:	00 
  72a411:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  72a418:	4c 89 fe             	mov    %r15,%rsi
  72a41b:	89 ea                	mov    %ebp,%edx
  72a41d:	ff 15 9d f3 3f 00    	call   *0x3ff39d(%rip)        # b297c0 <_DYNAMIC+0x738>
  72a423:	41 08 86 1f 08 00 00 	or     %al,0x81f(%r14)
  72a42a:	8b 6c 24 10          	mov    0x10(%rsp),%ebp
  72a42e:	44 0f b6 a4 24 90 00 	movzbl 0x90(%rsp),%r12d
  72a435:	00 00 
  72a437:	83 fd 01             	cmp    $0x1,%ebp
  72a43a:	75 25                	jne    72a461 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x571>
  72a43c:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  72a443:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  72a447:	39 c1                	cmp    %eax,%ecx
  72a449:	0f 94 c2             	sete   %dl
  72a44c:	41 84 d4             	test   %dl,%r12b
  72a44f:	75 26                	jne    72a477 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x587>
  72a451:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  72a458:	01 00 00 00 
  72a45c:	e9 78 03 00 00       	jmp    72a7d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8e9>
  72a461:	41 f6 c4 01          	test   $0x1,%r12b
  72a465:	74 10                	je     72a477 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x587>
  72a467:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  72a46e:	01 00 00 00 
  72a472:	e9 76 04 00 00       	jmp    72a8ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a477:	8b 54 24 18          	mov    0x18(%rsp),%edx
  72a47b:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  72a482:	00 
  72a483:	83 fa 01             	cmp    $0x1,%edx
  72a486:	0f 85 27 02 00 00    	jne    72a6b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x7c3>
  72a48c:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  72a493:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  72a497:	0f 94 c0             	sete   %al
  72a49a:	be 01 00 00 00       	mov    $0x1,%esi
  72a49f:	84 c1                	test   %al,%cl
  72a4a1:	0f 85 1a 02 00 00    	jne    72a6c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x7d1>
  72a4a7:	e9 15 03 00 00       	jmp    72a7c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a4ac:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  72a4b3:	00 00 00 00 
  72a4b7:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72a4bb:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72a4c2:	00 
  72a4c3:	48 85 ff             	test   %rdi,%rdi
  72a4c6:	75 76                	jne    72a53e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x64e>
  72a4c8:	66 0f 7e 44 24 70    	movd   %xmm0,0x70(%rsp)
  72a4ce:	ff 15 14 ee 3f 00    	call   *0x3fee14(%rip)        # b292e8 <_DYNAMIC+0x260>
  72a4d4:	bf 60 00 00 00       	mov    $0x60,%edi
  72a4d9:	be 08 00 00 00       	mov    $0x8,%esi
  72a4de:	ff 15 e4 ed 3f 00    	call   *0x3fede4(%rip)        # b292c8 <_DYNAMIC+0x240>
  72a4e4:	48 85 c0             	test   %rax,%rax
  72a4e7:	0f 84 27 06 00 00    	je     72ab14 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc24>
  72a4ed:	48 89 c7             	mov    %rax,%rdi
  72a4f0:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72a4f4:	f3 0f 7f 40 10       	movdqu %xmm0,0x10(%rax)
  72a4f9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  72a500:	48 c7 40 08 08 00 00 	movq   $0x8,0x8(%rax)
  72a507:	00 
  72a508:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  72a50f:	00 
  72a510:	48 c7 40 28 00 00 00 	movq   $0x0,0x28(%rax)
  72a517:	00 
  72a518:	48 c7 40 30 ff ff ff 	movq   $0xffffffffffffffff,0x30(%rax)
  72a51f:	ff 
  72a520:	48 c7 40 48 00 00 00 	movq   $0x0,0x48(%rax)
  72a527:	00 
  72a528:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  72a52f:	00 
  72a530:	49 89 84 24 00 01 00 	mov    %rax,0x100(%r12)
  72a537:	00 
  72a538:	66 0f 6e 44 24 70    	movd   0x70(%rsp),%xmm0
  72a53e:	48 83 c7 48          	add    $0x48,%rdi
  72a542:	4c 89 fe             	mov    %r15,%rsi
  72a545:	89 ea                	mov    %ebp,%edx
  72a547:	4c 89 e9             	mov    %r13,%rcx
  72a54a:	e8 31 42 04 00       	call   76e780 <<gpui::property::Overrides<gpui::property::GeometryStyle>>::set_value>
  72a54f:	48 89 c1             	mov    %rax,%rcx
  72a552:	48 c1 e9 20          	shr    $0x20,%rcx
  72a556:	a8 01                	test   $0x1,%al
  72a558:	74 16                	je     72a570 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x680>
  72a55a:	c1 e8 10             	shr    $0x10,%eax
  72a55d:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  72a564:	66 89 43 08          	mov    %ax,0x8(%rbx)
  72a568:	89 4b 0a             	mov    %ecx,0xa(%rbx)
  72a56b:	e9 82 05 00 00       	jmp    72aaf2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc02>
  72a570:	66 0f 6e c1          	movd   %ecx,%xmm0
  72a574:	89 8c 24 40 01 00 00 	mov    %ecx,0x140(%rsp)
  72a57b:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72a582:	00 
  72a583:	4c 89 fe             	mov    %r15,%rsi
  72a586:	ff 15 3c f2 3f 00    	call   *0x3ff23c(%rip)        # b297c8 <_DYNAMIC+0x740>
  72a58c:	49 8b 84 24 00 01 00 	mov    0x100(%r12),%rax
  72a593:	00 
  72a594:	48 83 78 10 00       	cmpq   $0x0,0x10(%rax)
  72a599:	75 3a                	jne    72a5d5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x6e5>
  72a59b:	48 83 78 58 00       	cmpq   $0x0,0x58(%rax)
  72a5a0:	75 33                	jne    72a5d5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x6e5>
  72a5a2:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  72a5a7:	75 2c                	jne    72a5d5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x6e5>
  72a5a9:	48 83 78 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rax)
  72a5ae:	75 25                	jne    72a5d5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x6e5>
  72a5b0:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72a5b7:	48 8b b8 00 01 00 00 	mov    0x100(%rax),%rdi
  72a5be:	e8 dd 9f fc ff       	call   6f45a0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::geometry::Geometry>>>>
  72a5c3:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72a5ca:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  72a5d1:	00 00 00 00 
  72a5d5:	48 8b 05 a4 ee 3f 00 	mov    0x3feea4(%rip),%rax        # b29480 <_DYNAMIC+0x3f8>
  72a5dc:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  72a5e3:	00 
  72a5e4:	48 8d b4 24 40 01 00 	lea    0x140(%rsp),%rsi
  72a5eb:	00 
  72a5ec:	ff 50 18             	call   *0x18(%rax)
  72a5ef:	34 01                	xor    $0x1,%al
  72a5f1:	0f b6 c0             	movzbl %al,%eax
  72a5f4:	49 89 86 08 07 00 00 	mov    %rax,0x708(%r14)
  72a5fb:	41 08 86 1f 08 00 00 	or     %al,0x81f(%r14)
  72a602:	4d 8b be 10 06 00 00 	mov    0x610(%r14),%r15
  72a609:	4d 85 ff             	test   %r15,%r15
  72a60c:	0f 84 d9 04 00 00    	je     72aaeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a612:	49 83 bf d8 00 00 00 	cmpq   $0x0,0xd8(%r15)
  72a619:	00 
  72a61a:	0f 85 cb 04 00 00    	jne    72aaeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a620:	49 83 bf e0 00 00 00 	cmpq   $0x0,0xe0(%r15)
  72a627:	00 
  72a628:	0f 85 bd 04 00 00    	jne    72aaeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a62e:	49 83 bf 00 01 00 00 	cmpq   $0x0,0x100(%r15)
  72a635:	00 
  72a636:	0f 85 af 04 00 00    	jne    72aaeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a63c:	49 83 bf d0 00 00 00 	cmpq   $0x0,0xd0(%r15)
  72a643:	00 
  72a644:	0f 85 a1 04 00 00    	jne    72aaeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a64a:	49 83 bf f8 00 00 00 	cmpq   $0x0,0xf8(%r15)
  72a651:	00 
  72a652:	0f 85 93 04 00 00    	jne    72aaeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a658:	49 8b 47 60          	mov    0x60(%r15),%rax
  72a65c:	83 f8 ff             	cmp    $0xffffffff,%eax
  72a65f:	0f 85 86 04 00 00    	jne    72aaeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a665:	49 83 7f 28 00       	cmpq   $0x0,0x28(%r15)
  72a66a:	0f 85 7b 04 00 00    	jne    72aaeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a670:	49 8b 07             	mov    (%r15),%rax
  72a673:	49 0b 47 40          	or     0x40(%r15),%rax
  72a677:	0f 85 6e 04 00 00    	jne    72aaeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a67d:	49 83 7f 58 00       	cmpq   $0x0,0x58(%r15)
  72a682:	0f 85 63 04 00 00    	jne    72aaeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a688:	4c 89 ff             	mov    %r15,%rdi
  72a68b:	e8 d0 eb fc ff       	call   6f9260 <core::ptr::drop_glue::<gpui::runtime::metadata::Metadata>>
  72a690:	be 08 01 00 00       	mov    $0x108,%esi
  72a695:	ba 08 00 00 00       	mov    $0x8,%edx
  72a69a:	4c 89 ff             	mov    %r15,%rdi
  72a69d:	ff 15 2d ec 3f 00    	call   *0x3fec2d(%rip)        # b292d0 <_DYNAMIC+0x248>
  72a6a3:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  72a6aa:	00 00 00 00 
  72a6ae:	e9 38 04 00 00       	jmp    72aaeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a6b3:	be 01 00 00 00       	mov    $0x1,%esi
  72a6b8:	f6 c1 01             	test   $0x1,%cl
  72a6bb:	0f 85 00 01 00 00    	jne    72a7c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a6c1:	8b 44 24 20          	mov    0x20(%rsp),%eax
  72a6c5:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  72a6cc:	0f 85 ef 00 00 00    	jne    72a7c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a6d2:	8b 44 24 24          	mov    0x24(%rsp),%eax
  72a6d6:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  72a6dd:	0f 85 de 00 00 00    	jne    72a7c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a6e3:	8b 44 24 28          	mov    0x28(%rsp),%eax
  72a6e7:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  72a6ee:	0f 85 cd 00 00 00    	jne    72a7c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a6f4:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  72a6f9:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  72a700:	0f 85 bb 00 00 00    	jne    72a7c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a706:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  72a70b:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  72a712:	0f 85 a9 00 00 00    	jne    72a7c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a718:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  72a71d:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  72a724:	0f 85 97 00 00 00    	jne    72a7c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a72a:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  72a72f:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  72a736:	0f 85 85 00 00 00    	jne    72a7c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a73c:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  72a740:	88 8c 24 80 00 00 00 	mov    %cl,0x80(%rsp)
  72a747:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  72a74c:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  72a753:	00 
  72a754:	e8 c7 16 00 00       	call   72be20 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  72a759:	84 c0                	test   %al,%al
  72a75b:	74 53                	je     72a7b0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8c0>
  72a75d:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  72a763:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  72a76a:	00 00 
  72a76c:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72a770:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72a774:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72a779:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  72a780:	00 
  72a781:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  72a785:	be 01 00 00 00       	mov    $0x1,%esi
  72a78a:	75 35                	jne    72a7c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a78c:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  72a792:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  72a799:	00 00 
  72a79b:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72a79f:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72a7a3:	31 f6                	xor    %esi,%esi
  72a7a5:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72a7aa:	40 0f 95 c6          	setne  %sil
  72a7ae:	eb 11                	jmp    72a7c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a7b0:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  72a7b7:	00 
  72a7b8:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  72a7bc:	be 01 00 00 00       	mov    $0x1,%esi
  72a7c1:	49 89 b6 08 07 00 00 	mov    %rsi,0x708(%r14)
  72a7c8:	40 f6 c5 01          	test   $0x1,%bpl
  72a7cc:	74 2b                	je     72a7f9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x909>
  72a7ce:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  72a7d5:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  72a7d9:	39 c1                	cmp    %eax,%ecx
  72a7db:	0f 94 c0             	sete   %al
  72a7de:	41 20 c4             	and    %al,%r12b
  72a7e1:	41 80 fc 01          	cmp    $0x1,%r12b
  72a7e5:	0f 85 02 01 00 00    	jne    72a8ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a7eb:	8b 54 24 18          	mov    0x18(%rsp),%edx
  72a7ef:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  72a7f6:	00 
  72a7f7:	eb 0a                	jmp    72a803 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x913>
  72a7f9:	41 f6 c4 01          	test   $0x1,%r12b
  72a7fd:	0f 85 ea 00 00 00    	jne    72a8ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a803:	83 fa 01             	cmp    $0x1,%edx
  72a806:	75 17                	jne    72a81f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x92f>
  72a808:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  72a80f:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  72a813:	0f 94 c0             	sete   %al
  72a816:	84 c1                	test   %al,%cl
  72a818:	75 0e                	jne    72a828 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x938>
  72a81a:	e9 ce 00 00 00       	jmp    72a8ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a81f:	f6 c1 01             	test   $0x1,%cl
  72a822:	0f 85 c5 00 00 00    	jne    72a8ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a828:	8b 44 24 20          	mov    0x20(%rsp),%eax
  72a82c:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  72a833:	0f 85 b4 00 00 00    	jne    72a8ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a839:	8b 44 24 24          	mov    0x24(%rsp),%eax
  72a83d:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  72a844:	0f 85 a3 00 00 00    	jne    72a8ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a84a:	8b 44 24 28          	mov    0x28(%rsp),%eax
  72a84e:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  72a855:	0f 85 92 00 00 00    	jne    72a8ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a85b:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  72a860:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  72a867:	0f 85 80 00 00 00    	jne    72a8ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a86d:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  72a872:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  72a879:	75 72                	jne    72a8ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a87b:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  72a880:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  72a887:	75 64                	jne    72a8ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a889:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  72a88e:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  72a895:	75 56                	jne    72a8ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a897:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  72a89c:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  72a8a3:	00 
  72a8a4:	e8 77 15 00 00       	call   72be20 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  72a8a9:	84 c0                	test   %al,%al
  72a8ab:	74 40                	je     72a8ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a8ad:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  72a8b3:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  72a8ba:	00 00 
  72a8bc:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72a8c0:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72a8c4:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72a8c9:	75 22                	jne    72a8ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a8cb:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  72a8d1:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  72a8d8:	00 00 
  72a8da:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72a8de:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72a8e2:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72a8e7:	0f 84 fe 01 00 00    	je     72aaeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a8ed:	45 89 e8             	mov    %r13d,%r8d
  72a8f0:	44 8b 64 24 18       	mov    0x18(%rsp),%r12d
  72a8f5:	0f b6 7c 24 64       	movzbl 0x64(%rsp),%edi
  72a8fa:	44 0f b6 6c 24 65    	movzbl 0x65(%rsp),%r13d
  72a900:	0f b6 4c 24 66       	movzbl 0x66(%rsp),%ecx
  72a905:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  72a90a:	88 84 24 80 00 00 00 	mov    %al,0x80(%rsp)
  72a911:	8b b4 24 f0 00 00 00 	mov    0xf0(%rsp),%esi
  72a918:	0f 10 5c 24 1c       	movups 0x1c(%rsp),%xmm3
  72a91d:	f3 0f 10 44 24 20    	movss  0x20(%rsp),%xmm0
  72a923:	0f 10 a4 24 f4 00 00 	movups 0xf4(%rsp),%xmm4
  72a92a:	00 
  72a92b:	f3 0f 10 8c 24 f8 00 	movss  0xf8(%rsp),%xmm1
  72a932:	00 00 
  72a934:	44 0f b6 9c 24 3c 01 	movzbl 0x13c(%rsp),%r11d
  72a93b:	00 00 
  72a93d:	44 0f b6 8c 24 3d 01 	movzbl 0x13d(%rsp),%r9d
  72a944:	00 00 
  72a946:	0f b6 84 24 3e 01 00 	movzbl 0x13e(%rsp),%eax
  72a94d:	00 
  72a94e:	44 0f b6 94 24 3f 01 	movzbl 0x13f(%rsp),%r10d
  72a955:	00 00 
  72a957:	40 f6 c5 01          	test   $0x1,%bpl
  72a95b:	74 22                	je     72a97f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xa8f>
  72a95d:	f3 0f 10 54 24 14    	movss  0x14(%rsp),%xmm2
  72a963:	0f 2e 94 24 ec 00 00 	ucomiss 0xec(%rsp),%xmm2
  72a96a:	00 
  72a96b:	40 0f 9b c5          	setnp  %bpl
  72a96f:	0f 94 c2             	sete   %dl
  72a972:	40 20 ea             	and    %bpl,%dl
  72a975:	41 84 d0             	test   %dl,%r8b
  72a978:	75 0f                	jne    72a989 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xa99>
  72a97a:	e9 a4 00 00 00       	jmp    72aa23 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xb33>
  72a97f:	41 f6 c0 01          	test   $0x1,%r8b
  72a983:	0f 85 9a 00 00 00    	jne    72aa23 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xb33>
  72a989:	41 83 fc 01          	cmp    $0x1,%r12d
  72a98d:	75 3c                	jne    72a9cb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xadb>
  72a98f:	44 30 df             	xor    %r11b,%dil
  72a992:	30 c1                	xor    %al,%cl
  72a994:	0f b6 84 24 80 00 00 	movzbl 0x80(%rsp),%eax
  72a99b:	00 
  72a99c:	44 30 d0             	xor    %r10b,%al
  72a99f:	45 38 cd             	cmp    %r9b,%r13b
  72a9a2:	0f 94 c2             	sete   %dl
  72a9a5:	0f 28 c3             	movaps %xmm3,%xmm0
  72a9a8:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  72a9ac:	44 0f 50 c0          	movmskps %xmm0,%r8d
  72a9b0:	41 80 f0 0f          	xor    $0xf,%r8b
  72a9b4:	40 08 f9             	or     %dil,%cl
  72a9b7:	44 08 c1             	or     %r8b,%cl
  72a9ba:	08 c1                	or     %al,%cl
  72a9bc:	0f 94 c0             	sete   %al
  72a9bf:	40 20 f0             	and    %sil,%al
  72a9c2:	84 d0                	test   %dl,%al
  72a9c4:	74 5d                	je     72aa23 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xb33>
  72a9c6:	e9 83 00 00 00       	jmp    72aa4e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xb5e>
  72a9cb:	0f 2e c1             	ucomiss %xmm1,%xmm0
  72a9ce:	0f 9b c2             	setnp  %dl
  72a9d1:	40 0f 94 c5          	sete   %bpl
  72a9d5:	40 20 d5             	and    %dl,%bpl
  72a9d8:	40 f6 d6             	not    %sil
  72a9db:	40 20 ee             	and    %bpl,%sil
  72a9de:	0f 28 c3             	movaps %xmm3,%xmm0
  72a9e1:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  72a9e5:	0f 50 d0             	movmskps %xmm0,%edx
  72a9e8:	89 d5                	mov    %edx,%ebp
  72a9ea:	40 c0 ed 03          	shr    $0x3,%bpl
  72a9ee:	c0 ea 02             	shr    $0x2,%dl
  72a9f1:	40 20 f2             	and    %sil,%dl
  72a9f4:	44 38 df             	cmp    %r11b,%dil
  72a9f7:	40 0f 94 c6          	sete   %sil
  72a9fb:	40 20 ee             	and    %bpl,%sil
  72a9fe:	40 20 d6             	and    %dl,%sil
  72aa01:	38 c1                	cmp    %al,%cl
  72aa03:	0f 94 c1             	sete   %cl
  72aa06:	44 38 94 24 80 00 00 	cmp    %r10b,0x80(%rsp)
  72aa0d:	00 
  72aa0e:	0f 94 c0             	sete   %al
  72aa11:	20 c8                	and    %cl,%al
  72aa13:	45 38 cd             	cmp    %r9b,%r13b
  72aa16:	0f 94 c1             	sete   %cl
  72aa19:	20 c1                	and    %al,%cl
  72aa1b:	40 20 f1             	and    %sil,%cl
  72aa1e:	80 f9 01             	cmp    $0x1,%cl
  72aa21:	74 2b                	je     72aa4e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xb5e>
  72aa23:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  72aa2a:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  72aa2f:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
  72aa34:	0f 29 a4 24 80 00 00 	movaps %xmm4,0x80(%rsp)
  72aa3b:	00 
  72aa3c:	e8 3f aa 01 00       	call   745480 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  72aa41:	0f 28 a4 24 80 00 00 	movaps 0x80(%rsp),%xmm4
  72aa48:	00 
  72aa49:	0f 28 5c 24 70       	movaps 0x70(%rsp),%xmm3
  72aa4e:	0f c2 dc 04          	cmpneqps %xmm4,%xmm3
  72aa52:	66 0f c5 c3 06       	pextrw $0x6,%xmm3,%eax
  72aa57:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  72aa5e:	a8 01                	test   $0x1,%al
  72aa60:	74 69                	je     72aacb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbdb>
  72aa62:	49 39 cf             	cmp    %rcx,%r15
  72aa65:	0f 83 13 01 00 00    	jae    72ab7e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc8e>
  72aa6b:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  72aa72:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  72aa76:	8b 7c d0 20          	mov    0x20(%rax,%rdx,8),%edi
  72aa7a:	89 f8                	mov    %edi,%eax
  72aa7c:	83 e0 07             	and    $0x7,%eax
  72aa7f:	83 f8 06             	cmp    $0x6,%eax
  72aa82:	74 47                	je     72aacb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbdb>
  72aa84:	c1 ef 03             	shr    $0x3,%edi
  72aa87:	74 42                	je     72aacb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbdb>
  72aa89:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  72aa90:	ff cf                	dec    %edi
  72aa92:	48 39 fe             	cmp    %rdi,%rsi
  72aa95:	0f 86 f6 00 00 00    	jbe    72ab91 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xca1>
  72aa9b:	4d 8b a6 b0 02 00 00 	mov    0x2b0(%r14),%r12
  72aaa2:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  72aaa6:	48 c1 e0 04          	shl    $0x4,%rax
  72aaaa:	49 83 3c 04 fe       	cmpq   $0xfffffffffffffffe,(%r12,%rax,1)
  72aaaf:	74 73                	je     72ab24 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc34>
  72aab1:	49 01 c4             	add    %rax,%r12
  72aab4:	4c 89 e7             	mov    %r12,%rdi
  72aab7:	e8 14 9e fc ff       	call   6f48d0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  72aabc:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  72aac3:	ff 
  72aac4:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  72aacb:	48 8d 94 24 e8 00 00 	lea    0xe8(%rsp),%rdx
  72aad2:	00 
  72aad3:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  72aada:	4c 89 fe             	mov    %r15,%rsi
  72aadd:	ff 15 dd e9 3f 00    	call   *0x3fe9dd(%rip)        # b294c0 <_DYNAMIC+0x438>
  72aae3:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  72aaea:	01 
  72aaeb:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  72aaf2:	48 81 c4 f8 01 00 00 	add    $0x1f8,%rsp
  72aaf9:	5b                   	pop    %rbx
  72aafa:	41 5c                	pop    %r12
  72aafc:	41 5d                	pop    %r13
  72aafe:	41 5e                	pop    %r14
  72ab00:	41 5f                	pop    %r15
  72ab02:	5d                   	pop    %rbp
  72ab03:	c3                   	ret
  72ab04:	bf 08 00 00 00       	mov    $0x8,%edi
  72ab09:	be 08 01 00 00       	mov    $0x108,%esi
  72ab0e:	ff 15 e4 e7 3f 00    	call   *0x3fe7e4(%rip)        # b292f8 <_DYNAMIC+0x270>
  72ab14:	bf 08 00 00 00       	mov    $0x8,%edi
  72ab19:	be 60 00 00 00       	mov    $0x60,%esi
  72ab1e:	ff 15 d4 e7 3f 00    	call   *0x3fe7d4(%rip)        # b292f8 <_DYNAMIC+0x270>
  72ab24:	48 8d 3d bd fe 3c 00 	lea    0x3cfebd(%rip),%rdi        # afa9e8 <__frame_dummy_init_array_entry+0x180>
  72ab2b:	ff 15 5f e8 3f 00    	call   *0x3fe85f(%rip)        # b29390 <_DYNAMIC+0x308>
  72ab31:	48 8d 15 20 04 3d 00 	lea    0x3d0420(%rip),%rdx        # afaf58 <__frame_dummy_init_array_entry+0x6f0>
  72ab38:	4c 89 ff             	mov    %r15,%rdi
  72ab3b:	ff 15 9f e8 3f 00    	call   *0x3fe89f(%rip)        # b293e0 <_DYNAMIC+0x358>
  72ab41:	48 8d 15 e8 0a 3d 00 	lea    0x3d0ae8(%rip),%rdx        # afb630 <__frame_dummy_init_array_entry+0xdc8>
  72ab48:	4c 89 ff             	mov    %r15,%rdi
  72ab4b:	ff 15 8f e8 3f 00    	call   *0x3fe88f(%rip)        # b293e0 <_DYNAMIC+0x358>
  72ab51:	48 8d 15 18 02 3d 00 	lea    0x3d0218(%rip),%rdx        # afad70 <__frame_dummy_init_array_entry+0x508>
  72ab58:	4c 89 ff             	mov    %r15,%rdi
  72ab5b:	ff 15 7f e8 3f 00    	call   *0x3fe87f(%rip)        # b293e0 <_DYNAMIC+0x358>
  72ab61:	48 8d 15 f0 01 3d 00 	lea    0x3d01f0(%rip),%rdx        # afad58 <__frame_dummy_init_array_entry+0x4f0>
  72ab68:	4c 89 ff             	mov    %r15,%rdi
  72ab6b:	ff 15 6f e8 3f 00    	call   *0x3fe86f(%rip)        # b293e0 <_DYNAMIC+0x358>
  72ab71:	48 8d 15 10 02 3d 00 	lea    0x3d0210(%rip),%rdx        # afad88 <__frame_dummy_init_array_entry+0x520>
  72ab78:	ff 15 62 e8 3f 00    	call   *0x3fe862(%rip)        # b293e0 <_DYNAMIC+0x358>
  72ab7e:	48 8d 15 c3 0a 3d 00 	lea    0x3d0ac3(%rip),%rdx        # afb648 <__frame_dummy_init_array_entry+0xde0>
  72ab85:	4c 89 ff             	mov    %r15,%rdi
  72ab88:	48 89 ce             	mov    %rcx,%rsi
  72ab8b:	ff 15 4f e8 3f 00    	call   *0x3fe84f(%rip)        # b293e0 <_DYNAMIC+0x358>
  72ab91:	48 8d 15 38 fe 3c 00 	lea    0x3cfe38(%rip),%rdx        # afa9d0 <__frame_dummy_init_array_entry+0x168>
  72ab98:	ff 15 42 e8 3f 00    	call   *0x3fe842(%rip)        # b293e0 <_DYNAMIC+0x358>
  72ab9e:	48 89 c3             	mov    %rax,%rbx
  72aba1:	be 08 01 00 00       	mov    $0x108,%esi
  72aba6:	ba 08 00 00 00       	mov    $0x8,%edx
  72abab:	4c 89 ff             	mov    %r15,%rdi
  72abae:	ff 15 1c e7 3f 00    	call   *0x3fe71c(%rip)        # b292d0 <_DYNAMIC+0x248>
  72abb4:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  72abbb:	00 00 00 00 
  72abbf:	48 89 df             	mov    %rbx,%rdi
  72abc2:	e8 e9 e8 3c 00       	call   af94b0 <_Unwind_Resume@plt>
  72abc7:	48 89 c3             	mov    %rax,%rbx
  72abca:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72abd1:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  72abd8:	00 00 00 00 
  72abdc:	48 89 df             	mov    %rbx,%rdi
  72abdf:	e8 cc e8 3c 00       	call   af94b0 <_Unwind_Resume@plt>
  72abe4:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  72abeb:	ff 
  72abec:	48 89 c7             	mov    %rax,%rdi
  72abef:	e8 bc e8 3c 00       	call   af94b0 <_Unwind_Resume@plt>
