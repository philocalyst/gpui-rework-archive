
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000729ff0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at>:
  729ff0:	55                   	push   %rbp
  729ff1:	41 57                	push   %r15
  729ff3:	41 56                	push   %r14
  729ff5:	41 55                	push   %r13
  729ff7:	41 54                	push   %r12
  729ff9:	53                   	push   %rbx
  729ffa:	48 81 ec f8 01 00 00 	sub    $0x1f8,%rsp
  72a001:	4d 89 c5             	mov    %r8,%r13
  72a004:	89 cd                	mov    %ecx,%ebp
  72a006:	49 89 d7             	mov    %rdx,%r15
  72a009:	49 89 f6             	mov    %rsi,%r14
  72a00c:	48 89 fb             	mov    %rdi,%rbx
  72a00f:	45 0f b6 20          	movzbl (%r8),%r12d
  72a013:	41 80 fc ff          	cmp    $0xff,%r12b
  72a017:	74 1c                	je     72a035 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x45>
  72a019:	89 ef                	mov    %ebp,%edi
  72a01b:	4c 89 ee             	mov    %r13,%rsi
  72a01e:	ff 15 54 f6 3f 00    	call   *0x3ff654(%rip)        # b29678 <_DYNAMIC+0x508>
  72a024:	66 85 c0             	test   %ax,%ax
  72a027:	74 0c                	je     72a035 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x45>
  72a029:	48 89 c1             	mov    %rax,%rcx
  72a02c:	48 c1 e9 10          	shr    $0x10,%rcx
  72a030:	e9 28 06 00 00       	jmp    72a65d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x66d>
  72a035:	0f b7 c5             	movzwl %bp,%eax
  72a038:	48 8d 0d 69 19 3d 00 	lea    0x3d1969(%rip),%rcx        # afb9a8 <__frame_dummy_init_array_entry+0x10a0>
  72a03f:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  72a044:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  72a048:	74 78                	je     72a0c2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xd2>
  72a04a:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  72a051:	49 39 f7             	cmp    %rsi,%r15
  72a054:	0f 83 d7 0b 00 00    	jae    72ac31 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc41>
  72a05a:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  72a061:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  72a065:	4c 8b 3c c8          	mov    (%rax,%rcx,8),%r15
  72a069:	4d 8b a6 10 06 00 00 	mov    0x610(%r14),%r12
  72a070:	4d 85 e4             	test   %r12,%r12
  72a073:	0f 84 d4 00 00 00    	je     72a14d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x15d>
  72a079:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72a080:	00 
  72a081:	48 85 ff             	test   %rdi,%rdi
  72a084:	0f 84 22 05 00 00    	je     72a5ac <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x5bc>
  72a08a:	4c 89 fe             	mov    %r15,%rsi
  72a08d:	ff 15 a5 f6 3f 00    	call   *0x3ff6a5(%rip)        # b29738 <_DYNAMIC+0x5c8>
  72a093:	4d 8b a6 10 06 00 00 	mov    0x610(%r14),%r12
  72a09a:	66 0f 7e 84 24 e8 00 	movd   %xmm0,0xe8(%rsp)
  72a0a1:	00 00 
  72a0a3:	4d 85 e4             	test   %r12,%r12
  72a0a6:	0f 84 b0 00 00 00    	je     72a15c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x16c>
  72a0ac:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72a0b3:	00 
  72a0b4:	48 85 ff             	test   %rdi,%rdi
  72a0b7:	0f 85 81 05 00 00    	jne    72a63e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x64e>
  72a0bd:	e9 06 05 00 00       	jmp    72a5c8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x5d8>
  72a0c2:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  72a0c9:	49 39 f7             	cmp    %rsi,%r15
  72a0cc:	0f 83 6f 0b 00 00    	jae    72ac41 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc51>
  72a0d2:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  72a0d9:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  72a0dd:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  72a0e1:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  72a0e6:	49 8b 86 00 02 00 00 	mov    0x200(%r14),%rax
  72a0ed:	48 8d 0d b4 18 93 ff 	lea    -0x6ce74c(%rip),%rcx        # 5b9a8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x138>
  72a0f4:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  72a0f8:	48 01 c8             	add    %rcx,%rax
  72a0fb:	ff e0                	jmp    *%rax
  72a0fd:	0f 10 05 5c 1a 93 ff 	movups -0x6ce5a4(%rip),%xmm0        # 5bb60 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2f0>
  72a104:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  72a109:	0f 10 05 40 1a 93 ff 	movups -0x6ce5c0(%rip),%xmm0        # 5bb50 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e0>
  72a110:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  72a115:	0f 10 05 24 1a 93 ff 	movups -0x6ce5dc(%rip),%xmm0        # 5bb40 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2d0>
  72a11c:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  72a121:	0f 10 05 08 1a 93 ff 	movups -0x6ce5f8(%rip),%xmm0        # 5bb30 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c0>
  72a128:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  72a12d:	0f 10 05 ec 19 93 ff 	movups -0x6ce614(%rip),%xmm0        # 5bb20 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2b0>
  72a134:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  72a139:	48 b8 00 00 00 00 01 	movabs $0x3000100000000,%rax
  72a140:	00 03 00 
  72a143:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  72a148:	e9 81 01 00 00       	jmp    72a2ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x2de>
  72a14d:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  72a154:	00 00 00 00 
  72a158:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72a15c:	66 0f 7e 44 24 70    	movd   %xmm0,0x70(%rsp)
  72a162:	ff 15 68 f2 3f 00    	call   *0x3ff268(%rip)        # b293d0 <_DYNAMIC+0x260>
  72a168:	bf 08 01 00 00       	mov    $0x108,%edi
  72a16d:	be 08 00 00 00       	mov    $0x8,%esi
  72a172:	ff 15 38 f2 3f 00    	call   *0x3ff238(%rip)        # b293b0 <_DYNAMIC+0x240>
  72a178:	48 85 c0             	test   %rax,%rax
  72a17b:	0f 84 83 0a 00 00    	je     72ac04 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc14>
  72a181:	49 89 c4             	mov    %rax,%r12
  72a184:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72a188:	f3 0f 7f 80 d8 00 00 	movdqu %xmm0,0xd8(%rax)
  72a18f:	00 
  72a190:	f3 0f 7f 40 28       	movdqu %xmm0,0x28(%rax)
  72a195:	f3 0f 7f 40 40       	movdqu %xmm0,0x40(%rax)
  72a19a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  72a1a1:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  72a1a8:	00 
  72a1a9:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  72a1b0:	00 
  72a1b1:	48 c7 40 38 08 00 00 	movq   $0x8,0x38(%rax)
  72a1b8:	00 
  72a1b9:	48 c7 40 50 08 00 00 	movq   $0x8,0x50(%rax)
  72a1c0:	00 
  72a1c1:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  72a1c8:	00 
  72a1c9:	48 c7 40 60 ff ff ff 	movq   $0xffffffffffffffff,0x60(%rax)
  72a1d0:	ff 
  72a1d1:	48 c7 80 c0 00 00 00 	movq   $0x0,0xc0(%rax)
  72a1d8:	00 00 00 00 
  72a1dc:	48 c7 80 c8 00 00 00 	movq   $0x8,0xc8(%rax)
  72a1e3:	08 00 00 00 
  72a1e7:	48 c7 80 d0 00 00 00 	movq   $0x0,0xd0(%rax)
  72a1ee:	00 00 00 00 
  72a1f2:	48 c7 80 e8 00 00 00 	movq   $0x0,0xe8(%rax)
  72a1f9:	00 00 00 00 
  72a1fd:	f3 0f 7f 80 f8 00 00 	movdqu %xmm0,0xf8(%rax)
  72a204:	00 
  72a205:	49 89 86 10 06 00 00 	mov    %rax,0x610(%r14)
  72a20c:	66 0f 6e 44 24 70    	movd   0x70(%rsp),%xmm0
  72a212:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72a219:	00 
  72a21a:	48 85 ff             	test   %rdi,%rdi
  72a21d:	0f 85 1b 04 00 00    	jne    72a63e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x64e>
  72a223:	e9 a0 03 00 00       	jmp    72a5c8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x5d8>
  72a228:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  72a22f:	49 39 f7             	cmp    %rsi,%r15
  72a232:	0f 83 19 0a 00 00    	jae    72ac51 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc61>
  72a238:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  72a23f:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  72a246:	42 0f b6 3c 38       	movzbl (%rax,%r15,1),%edi
  72a24b:	48 39 fe             	cmp    %rdi,%rsi
  72a24e:	0f 86 1d 0a 00 00    	jbe    72ac71 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc81>
  72a254:	49 8b 86 08 02 00 00 	mov    0x208(%r14),%rax
  72a25b:	48 6b cf 58          	imul   $0x58,%rdi,%rcx
  72a25f:	eb 32                	jmp    72a293 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x2a3>
  72a261:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  72a268:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  72a26d:	4c 89 fa             	mov    %r15,%rdx
  72a270:	ff 15 32 f2 3f 00    	call   *0x3ff232(%rip)        # b294a8 <_DYNAMIC+0x338>
  72a276:	eb 56                	jmp    72a2ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x2de>
  72a278:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  72a27f:	49 39 f7             	cmp    %rsi,%r15
  72a282:	0f 83 d9 09 00 00    	jae    72ac61 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc71>
  72a288:	49 8b 86 10 02 00 00 	mov    0x210(%r14),%rax
  72a28f:	49 6b cf 58          	imul   $0x58,%r15,%rcx
  72a293:	48 8b 54 08 50       	mov    0x50(%rax,%rcx,1),%rdx
  72a298:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  72a29d:	0f 10 44 08 40       	movups 0x40(%rax,%rcx,1),%xmm0
  72a2a2:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  72a2a7:	0f 10 04 08          	movups (%rax,%rcx,1),%xmm0
  72a2ab:	0f 10 4c 08 10       	movups 0x10(%rax,%rcx,1),%xmm1
  72a2b0:	0f 10 54 08 20       	movups 0x20(%rax,%rcx,1),%xmm2
  72a2b5:	0f 10 5c 08 30       	movups 0x30(%rax,%rcx,1),%xmm3
  72a2ba:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
  72a2bf:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  72a2c4:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  72a2c9:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  72a2ce:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  72a2d5:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  72a2dc:	00 
  72a2dd:	4c 89 fa             	mov    %r15,%rdx
  72a2e0:	ff 15 b2 f5 3f 00    	call   *0x3ff5b2(%rip)        # b29898 <_DYNAMIC+0x728>
  72a2e6:	80 bc 24 40 01 00 00 	cmpb   $0x0,0x140(%rsp)
  72a2ed:	00 
  72a2ee:	74 1a                	je     72a30a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x31a>
  72a2f0:	48 8d 94 24 44 01 00 	lea    0x144(%rsp),%rdx
  72a2f7:	00 
  72a2f8:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  72a2ff:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  72a304:	ff 15 96 f5 3f 00    	call   *0x3ff596(%rip)        # b298a0 <_DYNAMIC+0x730>
  72a30a:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  72a311:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  72a316:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  72a31d:	00 
  72a31e:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
  72a323:	0f 29 84 24 80 01 00 	movaps %xmm0,0x180(%rsp)
  72a32a:	00 
  72a32b:	66 0f 6f 44 24 10    	movdqa 0x10(%rsp),%xmm0
  72a331:	66 0f 6f 4c 24 20    	movdqa 0x20(%rsp),%xmm1
  72a337:	0f 28 54 24 30       	movaps 0x30(%rsp),%xmm2
  72a33c:	0f 28 5c 24 40       	movaps 0x40(%rsp),%xmm3
  72a341:	0f 29 9c 24 70 01 00 	movaps %xmm3,0x170(%rsp)
  72a348:	00 
  72a349:	0f 29 94 24 60 01 00 	movaps %xmm2,0x160(%rsp)
  72a350:	00 
  72a351:	66 0f 7f 8c 24 50 01 	movdqa %xmm1,0x150(%rsp)
  72a358:	00 00 
  72a35a:	66 0f 7f 84 24 40 01 	movdqa %xmm0,0x140(%rsp)
  72a361:	00 00 
  72a363:	48 8d bc 24 a0 01 00 	lea    0x1a0(%rsp),%rdi
  72a36a:	00 
  72a36b:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  72a372:	00 
  72a373:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  72a378:	41 89 e8             	mov    %ebp,%r8d
  72a37b:	4d 89 e9             	mov    %r13,%r9
  72a37e:	e8 7d 4d 04 00       	call   76f100 <<gpui::property::Overrides>::set_value>
  72a383:	44 8b ac 24 a0 01 00 	mov    0x1a0(%rsp),%r13d
  72a38a:	00 
  72a38b:	41 83 fd 02          	cmp    $0x2,%r13d
  72a38f:	75 2b                	jne    72a3bc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x3cc>
  72a391:	0f b7 84 24 a8 01 00 	movzwl 0x1a8(%rsp),%eax
  72a398:	00 
  72a399:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  72a39e:	8b 8c 24 a4 01 00 00 	mov    0x1a4(%rsp),%ecx
  72a3a5:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  72a3a9:	66 89 43 0c          	mov    %ax,0xc(%rbx)
  72a3ad:	89 4b 08             	mov    %ecx,0x8(%rbx)
  72a3b0:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  72a3b7:	e9 36 08 00 00       	jmp    72abf2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc02>
  72a3bc:	45 31 c0             	xor    %r8d,%r8d
  72a3bf:	41 80 fc ff          	cmp    $0xff,%r12b
  72a3c3:	41 0f 95 c0          	setne  %r8b
  72a3c7:	0f b7 84 24 a8 01 00 	movzwl 0x1a8(%rsp),%eax
  72a3ce:	00 
  72a3cf:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  72a3d4:	8b 8c 24 a4 01 00 00 	mov    0x1a4(%rsp),%ecx
  72a3db:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  72a3df:	0f 10 84 24 aa 01 00 	movups 0x1aa(%rsp),%xmm0
  72a3e6:	00 
  72a3e7:	0f 11 84 24 f2 00 00 	movups %xmm0,0xf2(%rsp)
  72a3ee:	00 
  72a3ef:	0f 10 84 24 ba 01 00 	movups 0x1ba(%rsp),%xmm0
  72a3f6:	00 
  72a3f7:	0f 11 84 24 02 01 00 	movups %xmm0,0x102(%rsp)
  72a3fe:	00 
  72a3ff:	0f 10 84 24 ca 01 00 	movups 0x1ca(%rsp),%xmm0
  72a406:	00 
  72a407:	0f 11 84 24 12 01 00 	movups %xmm0,0x112(%rsp)
  72a40e:	00 
  72a40f:	0f 10 84 24 da 01 00 	movups 0x1da(%rsp),%xmm0
  72a416:	00 
  72a417:	0f 11 84 24 22 01 00 	movups %xmm0,0x122(%rsp)
  72a41e:	00 
  72a41f:	0f 10 84 24 e8 01 00 	movups 0x1e8(%rsp),%xmm0
  72a426:	00 
  72a427:	0f 11 84 24 30 01 00 	movups %xmm0,0x130(%rsp)
  72a42e:	00 
  72a42f:	44 89 ac 24 e8 00 00 	mov    %r13d,0xe8(%rsp)
  72a436:	00 
  72a437:	66 89 84 24 f0 00 00 	mov    %ax,0xf0(%rsp)
  72a43e:	00 
  72a43f:	89 8c 24 ec 00 00 00 	mov    %ecx,0xec(%rsp)
  72a446:	0f 10 84 24 28 01 00 	movups 0x128(%rsp),%xmm0
  72a44d:	00 
  72a44e:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  72a455:	00 
  72a456:	0f 10 84 24 18 01 00 	movups 0x118(%rsp),%xmm0
  72a45d:	00 
  72a45e:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  72a465:	00 
  72a466:	0f 10 84 24 08 01 00 	movups 0x108(%rsp),%xmm0
  72a46d:	00 
  72a46e:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  72a475:	00 
  72a476:	0f 10 84 24 f8 00 00 	movups 0xf8(%rsp),%xmm0
  72a47d:	00 
  72a47e:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  72a485:	00 
  72a486:	0f 10 84 24 e8 00 00 	movups 0xe8(%rsp),%xmm0
  72a48d:	00 
  72a48e:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  72a495:	00 
  72a496:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  72a49d:	00 
  72a49e:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  72a4a5:	00 
  72a4a6:	4d 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%r9
  72a4ad:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
  72a4b4:	00 
  72a4b5:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  72a4bc:	00 
  72a4bd:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  72a4c4:	00 
  72a4c5:	f3 0f 6f 84 24 f8 00 	movdqu 0xf8(%rsp),%xmm0
  72a4cc:	00 00 
  72a4ce:	f3 0f 6f 8c 24 08 01 	movdqu 0x108(%rsp),%xmm1
  72a4d5:	00 00 
  72a4d7:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  72a4de:	00 
  72a4df:	0f 10 9c 24 28 01 00 	movups 0x128(%rsp),%xmm3
  72a4e6:	00 
  72a4e7:	0f 29 9c 24 80 01 00 	movaps %xmm3,0x180(%rsp)
  72a4ee:	00 
  72a4ef:	0f 29 94 24 70 01 00 	movaps %xmm2,0x170(%rsp)
  72a4f6:	00 
  72a4f7:	66 0f 7f 8c 24 60 01 	movdqa %xmm1,0x160(%rsp)
  72a4fe:	00 00 
  72a500:	66 0f 7f 84 24 50 01 	movdqa %xmm0,0x150(%rsp)
  72a507:	00 00 
  72a509:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  72a510:	00 
  72a511:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  72a518:	4c 89 fe             	mov    %r15,%rsi
  72a51b:	89 ea                	mov    %ebp,%edx
  72a51d:	ff 15 85 f3 3f 00    	call   *0x3ff385(%rip)        # b298a8 <_DYNAMIC+0x738>
  72a523:	41 08 86 1f 08 00 00 	or     %al,0x81f(%r14)
  72a52a:	8b 6c 24 10          	mov    0x10(%rsp),%ebp
  72a52e:	44 0f b6 a4 24 90 00 	movzbl 0x90(%rsp),%r12d
  72a535:	00 00 
  72a537:	83 fd 01             	cmp    $0x1,%ebp
  72a53a:	75 25                	jne    72a561 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x571>
  72a53c:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  72a543:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  72a547:	39 c1                	cmp    %eax,%ecx
  72a549:	0f 94 c2             	sete   %dl
  72a54c:	41 84 d4             	test   %dl,%r12b
  72a54f:	75 26                	jne    72a577 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x587>
  72a551:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  72a558:	01 00 00 00 
  72a55c:	e9 78 03 00 00       	jmp    72a8d9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8e9>
  72a561:	41 f6 c4 01          	test   $0x1,%r12b
  72a565:	74 10                	je     72a577 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x587>
  72a567:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  72a56e:	01 00 00 00 
  72a572:	e9 76 04 00 00       	jmp    72a9ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a577:	8b 54 24 18          	mov    0x18(%rsp),%edx
  72a57b:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  72a582:	00 
  72a583:	83 fa 01             	cmp    $0x1,%edx
  72a586:	0f 85 27 02 00 00    	jne    72a7b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x7c3>
  72a58c:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  72a593:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  72a597:	0f 94 c0             	sete   %al
  72a59a:	be 01 00 00 00       	mov    $0x1,%esi
  72a59f:	84 c1                	test   %al,%cl
  72a5a1:	0f 85 1a 02 00 00    	jne    72a7c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x7d1>
  72a5a7:	e9 15 03 00 00       	jmp    72a8c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a5ac:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  72a5b3:	00 00 00 00 
  72a5b7:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72a5bb:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72a5c2:	00 
  72a5c3:	48 85 ff             	test   %rdi,%rdi
  72a5c6:	75 76                	jne    72a63e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x64e>
  72a5c8:	66 0f 7e 44 24 70    	movd   %xmm0,0x70(%rsp)
  72a5ce:	ff 15 fc ed 3f 00    	call   *0x3fedfc(%rip)        # b293d0 <_DYNAMIC+0x260>
  72a5d4:	bf 60 00 00 00       	mov    $0x60,%edi
  72a5d9:	be 08 00 00 00       	mov    $0x8,%esi
  72a5de:	ff 15 cc ed 3f 00    	call   *0x3fedcc(%rip)        # b293b0 <_DYNAMIC+0x240>
  72a5e4:	48 85 c0             	test   %rax,%rax
  72a5e7:	0f 84 27 06 00 00    	je     72ac14 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc24>
  72a5ed:	48 89 c7             	mov    %rax,%rdi
  72a5f0:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72a5f4:	f3 0f 7f 40 10       	movdqu %xmm0,0x10(%rax)
  72a5f9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  72a600:	48 c7 40 08 08 00 00 	movq   $0x8,0x8(%rax)
  72a607:	00 
  72a608:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  72a60f:	00 
  72a610:	48 c7 40 28 00 00 00 	movq   $0x0,0x28(%rax)
  72a617:	00 
  72a618:	48 c7 40 30 ff ff ff 	movq   $0xffffffffffffffff,0x30(%rax)
  72a61f:	ff 
  72a620:	48 c7 40 48 00 00 00 	movq   $0x0,0x48(%rax)
  72a627:	00 
  72a628:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  72a62f:	00 
  72a630:	49 89 84 24 00 01 00 	mov    %rax,0x100(%r12)
  72a637:	00 
  72a638:	66 0f 6e 44 24 70    	movd   0x70(%rsp),%xmm0
  72a63e:	48 83 c7 48          	add    $0x48,%rdi
  72a642:	4c 89 fe             	mov    %r15,%rsi
  72a645:	89 ea                	mov    %ebp,%edx
  72a647:	4c 89 e9             	mov    %r13,%rcx
  72a64a:	e8 31 42 04 00       	call   76e880 <<gpui::property::Overrides<gpui::property::GeometryStyle>>::set_value>
  72a64f:	48 89 c1             	mov    %rax,%rcx
  72a652:	48 c1 e9 20          	shr    $0x20,%rcx
  72a656:	a8 01                	test   $0x1,%al
  72a658:	74 16                	je     72a670 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x680>
  72a65a:	c1 e8 10             	shr    $0x10,%eax
  72a65d:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  72a664:	66 89 43 08          	mov    %ax,0x8(%rbx)
  72a668:	89 4b 0a             	mov    %ecx,0xa(%rbx)
  72a66b:	e9 82 05 00 00       	jmp    72abf2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc02>
  72a670:	66 0f 6e c1          	movd   %ecx,%xmm0
  72a674:	89 8c 24 40 01 00 00 	mov    %ecx,0x140(%rsp)
  72a67b:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72a682:	00 
  72a683:	4c 89 fe             	mov    %r15,%rsi
  72a686:	ff 15 24 f2 3f 00    	call   *0x3ff224(%rip)        # b298b0 <_DYNAMIC+0x740>
  72a68c:	49 8b 84 24 00 01 00 	mov    0x100(%r12),%rax
  72a693:	00 
  72a694:	48 83 78 10 00       	cmpq   $0x0,0x10(%rax)
  72a699:	75 3a                	jne    72a6d5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x6e5>
  72a69b:	48 83 78 58 00       	cmpq   $0x0,0x58(%rax)
  72a6a0:	75 33                	jne    72a6d5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x6e5>
  72a6a2:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  72a6a7:	75 2c                	jne    72a6d5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x6e5>
  72a6a9:	48 83 78 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rax)
  72a6ae:	75 25                	jne    72a6d5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x6e5>
  72a6b0:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72a6b7:	48 8b b8 00 01 00 00 	mov    0x100(%rax),%rdi
  72a6be:	e8 dd 9f fc ff       	call   6f46a0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::geometry::Geometry>>>>
  72a6c3:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72a6ca:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  72a6d1:	00 00 00 00 
  72a6d5:	48 8b 05 8c ee 3f 00 	mov    0x3fee8c(%rip),%rax        # b29568 <_DYNAMIC+0x3f8>
  72a6dc:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  72a6e3:	00 
  72a6e4:	48 8d b4 24 40 01 00 	lea    0x140(%rsp),%rsi
  72a6eb:	00 
  72a6ec:	ff 50 18             	call   *0x18(%rax)
  72a6ef:	34 01                	xor    $0x1,%al
  72a6f1:	0f b6 c0             	movzbl %al,%eax
  72a6f4:	49 89 86 08 07 00 00 	mov    %rax,0x708(%r14)
  72a6fb:	41 08 86 1f 08 00 00 	or     %al,0x81f(%r14)
  72a702:	4d 8b be 10 06 00 00 	mov    0x610(%r14),%r15
  72a709:	4d 85 ff             	test   %r15,%r15
  72a70c:	0f 84 d9 04 00 00    	je     72abeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a712:	49 83 bf d8 00 00 00 	cmpq   $0x0,0xd8(%r15)
  72a719:	00 
  72a71a:	0f 85 cb 04 00 00    	jne    72abeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a720:	49 83 bf e0 00 00 00 	cmpq   $0x0,0xe0(%r15)
  72a727:	00 
  72a728:	0f 85 bd 04 00 00    	jne    72abeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a72e:	49 83 bf 00 01 00 00 	cmpq   $0x0,0x100(%r15)
  72a735:	00 
  72a736:	0f 85 af 04 00 00    	jne    72abeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a73c:	49 83 bf d0 00 00 00 	cmpq   $0x0,0xd0(%r15)
  72a743:	00 
  72a744:	0f 85 a1 04 00 00    	jne    72abeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a74a:	49 83 bf f8 00 00 00 	cmpq   $0x0,0xf8(%r15)
  72a751:	00 
  72a752:	0f 85 93 04 00 00    	jne    72abeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a758:	49 8b 47 60          	mov    0x60(%r15),%rax
  72a75c:	83 f8 ff             	cmp    $0xffffffff,%eax
  72a75f:	0f 85 86 04 00 00    	jne    72abeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a765:	49 83 7f 28 00       	cmpq   $0x0,0x28(%r15)
  72a76a:	0f 85 7b 04 00 00    	jne    72abeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a770:	49 8b 07             	mov    (%r15),%rax
  72a773:	49 0b 47 40          	or     0x40(%r15),%rax
  72a777:	0f 85 6e 04 00 00    	jne    72abeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a77d:	49 83 7f 58 00       	cmpq   $0x0,0x58(%r15)
  72a782:	0f 85 63 04 00 00    	jne    72abeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a788:	4c 89 ff             	mov    %r15,%rdi
  72a78b:	e8 d0 eb fc ff       	call   6f9360 <core::ptr::drop_glue::<gpui::runtime::metadata::Metadata>>
  72a790:	be 08 01 00 00       	mov    $0x108,%esi
  72a795:	ba 08 00 00 00       	mov    $0x8,%edx
  72a79a:	4c 89 ff             	mov    %r15,%rdi
  72a79d:	ff 15 15 ec 3f 00    	call   *0x3fec15(%rip)        # b293b8 <_DYNAMIC+0x248>
  72a7a3:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  72a7aa:	00 00 00 00 
  72a7ae:	e9 38 04 00 00       	jmp    72abeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a7b3:	be 01 00 00 00       	mov    $0x1,%esi
  72a7b8:	f6 c1 01             	test   $0x1,%cl
  72a7bb:	0f 85 00 01 00 00    	jne    72a8c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a7c1:	8b 44 24 20          	mov    0x20(%rsp),%eax
  72a7c5:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  72a7cc:	0f 85 ef 00 00 00    	jne    72a8c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a7d2:	8b 44 24 24          	mov    0x24(%rsp),%eax
  72a7d6:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  72a7dd:	0f 85 de 00 00 00    	jne    72a8c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a7e3:	8b 44 24 28          	mov    0x28(%rsp),%eax
  72a7e7:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  72a7ee:	0f 85 cd 00 00 00    	jne    72a8c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a7f4:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  72a7f9:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  72a800:	0f 85 bb 00 00 00    	jne    72a8c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a806:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  72a80b:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  72a812:	0f 85 a9 00 00 00    	jne    72a8c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a818:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  72a81d:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  72a824:	0f 85 97 00 00 00    	jne    72a8c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a82a:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  72a82f:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  72a836:	0f 85 85 00 00 00    	jne    72a8c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a83c:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  72a840:	88 8c 24 80 00 00 00 	mov    %cl,0x80(%rsp)
  72a847:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  72a84c:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  72a853:	00 
  72a854:	e8 c7 16 00 00       	call   72bf20 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  72a859:	84 c0                	test   %al,%al
  72a85b:	74 53                	je     72a8b0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8c0>
  72a85d:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  72a863:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  72a86a:	00 00 
  72a86c:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72a870:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72a874:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72a879:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  72a880:	00 
  72a881:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  72a885:	be 01 00 00 00       	mov    $0x1,%esi
  72a88a:	75 35                	jne    72a8c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a88c:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  72a892:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  72a899:	00 00 
  72a89b:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72a89f:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72a8a3:	31 f6                	xor    %esi,%esi
  72a8a5:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72a8aa:	40 0f 95 c6          	setne  %sil
  72a8ae:	eb 11                	jmp    72a8c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a8b0:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  72a8b7:	00 
  72a8b8:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  72a8bc:	be 01 00 00 00       	mov    $0x1,%esi
  72a8c1:	49 89 b6 08 07 00 00 	mov    %rsi,0x708(%r14)
  72a8c8:	40 f6 c5 01          	test   $0x1,%bpl
  72a8cc:	74 2b                	je     72a8f9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x909>
  72a8ce:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  72a8d5:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  72a8d9:	39 c1                	cmp    %eax,%ecx
  72a8db:	0f 94 c0             	sete   %al
  72a8de:	41 20 c4             	and    %al,%r12b
  72a8e1:	41 80 fc 01          	cmp    $0x1,%r12b
  72a8e5:	0f 85 02 01 00 00    	jne    72a9ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a8eb:	8b 54 24 18          	mov    0x18(%rsp),%edx
  72a8ef:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  72a8f6:	00 
  72a8f7:	eb 0a                	jmp    72a903 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x913>
  72a8f9:	41 f6 c4 01          	test   $0x1,%r12b
  72a8fd:	0f 85 ea 00 00 00    	jne    72a9ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a903:	83 fa 01             	cmp    $0x1,%edx
  72a906:	75 17                	jne    72a91f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x92f>
  72a908:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  72a90f:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  72a913:	0f 94 c0             	sete   %al
  72a916:	84 c1                	test   %al,%cl
  72a918:	75 0e                	jne    72a928 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x938>
  72a91a:	e9 ce 00 00 00       	jmp    72a9ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a91f:	f6 c1 01             	test   $0x1,%cl
  72a922:	0f 85 c5 00 00 00    	jne    72a9ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a928:	8b 44 24 20          	mov    0x20(%rsp),%eax
  72a92c:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  72a933:	0f 85 b4 00 00 00    	jne    72a9ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a939:	8b 44 24 24          	mov    0x24(%rsp),%eax
  72a93d:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  72a944:	0f 85 a3 00 00 00    	jne    72a9ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a94a:	8b 44 24 28          	mov    0x28(%rsp),%eax
  72a94e:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  72a955:	0f 85 92 00 00 00    	jne    72a9ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a95b:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  72a960:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  72a967:	0f 85 80 00 00 00    	jne    72a9ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a96d:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  72a972:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  72a979:	75 72                	jne    72a9ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a97b:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  72a980:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  72a987:	75 64                	jne    72a9ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a989:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  72a98e:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  72a995:	75 56                	jne    72a9ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a997:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  72a99c:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  72a9a3:	00 
  72a9a4:	e8 77 15 00 00       	call   72bf20 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  72a9a9:	84 c0                	test   %al,%al
  72a9ab:	74 40                	je     72a9ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a9ad:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  72a9b3:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  72a9ba:	00 00 
  72a9bc:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72a9c0:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72a9c4:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72a9c9:	75 22                	jne    72a9ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a9cb:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  72a9d1:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  72a9d8:	00 00 
  72a9da:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72a9de:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72a9e2:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72a9e7:	0f 84 fe 01 00 00    	je     72abeb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a9ed:	45 89 e8             	mov    %r13d,%r8d
  72a9f0:	44 8b 64 24 18       	mov    0x18(%rsp),%r12d
  72a9f5:	0f b6 7c 24 64       	movzbl 0x64(%rsp),%edi
  72a9fa:	44 0f b6 6c 24 65    	movzbl 0x65(%rsp),%r13d
  72aa00:	0f b6 4c 24 66       	movzbl 0x66(%rsp),%ecx
  72aa05:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  72aa0a:	88 84 24 80 00 00 00 	mov    %al,0x80(%rsp)
  72aa11:	8b b4 24 f0 00 00 00 	mov    0xf0(%rsp),%esi
  72aa18:	0f 10 5c 24 1c       	movups 0x1c(%rsp),%xmm3
  72aa1d:	f3 0f 10 44 24 20    	movss  0x20(%rsp),%xmm0
  72aa23:	0f 10 a4 24 f4 00 00 	movups 0xf4(%rsp),%xmm4
  72aa2a:	00 
  72aa2b:	f3 0f 10 8c 24 f8 00 	movss  0xf8(%rsp),%xmm1
  72aa32:	00 00 
  72aa34:	44 0f b6 9c 24 3c 01 	movzbl 0x13c(%rsp),%r11d
  72aa3b:	00 00 
  72aa3d:	44 0f b6 8c 24 3d 01 	movzbl 0x13d(%rsp),%r9d
  72aa44:	00 00 
  72aa46:	0f b6 84 24 3e 01 00 	movzbl 0x13e(%rsp),%eax
  72aa4d:	00 
  72aa4e:	44 0f b6 94 24 3f 01 	movzbl 0x13f(%rsp),%r10d
  72aa55:	00 00 
  72aa57:	40 f6 c5 01          	test   $0x1,%bpl
  72aa5b:	74 22                	je     72aa7f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xa8f>
  72aa5d:	f3 0f 10 54 24 14    	movss  0x14(%rsp),%xmm2
  72aa63:	0f 2e 94 24 ec 00 00 	ucomiss 0xec(%rsp),%xmm2
  72aa6a:	00 
  72aa6b:	40 0f 9b c5          	setnp  %bpl
  72aa6f:	0f 94 c2             	sete   %dl
  72aa72:	40 20 ea             	and    %bpl,%dl
  72aa75:	41 84 d0             	test   %dl,%r8b
  72aa78:	75 0f                	jne    72aa89 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xa99>
  72aa7a:	e9 a4 00 00 00       	jmp    72ab23 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xb33>
  72aa7f:	41 f6 c0 01          	test   $0x1,%r8b
  72aa83:	0f 85 9a 00 00 00    	jne    72ab23 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xb33>
  72aa89:	41 83 fc 01          	cmp    $0x1,%r12d
  72aa8d:	75 3c                	jne    72aacb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xadb>
  72aa8f:	44 30 df             	xor    %r11b,%dil
  72aa92:	30 c1                	xor    %al,%cl
  72aa94:	0f b6 84 24 80 00 00 	movzbl 0x80(%rsp),%eax
  72aa9b:	00 
  72aa9c:	44 30 d0             	xor    %r10b,%al
  72aa9f:	45 38 cd             	cmp    %r9b,%r13b
  72aaa2:	0f 94 c2             	sete   %dl
  72aaa5:	0f 28 c3             	movaps %xmm3,%xmm0
  72aaa8:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  72aaac:	44 0f 50 c0          	movmskps %xmm0,%r8d
  72aab0:	41 80 f0 0f          	xor    $0xf,%r8b
  72aab4:	40 08 f9             	or     %dil,%cl
  72aab7:	44 08 c1             	or     %r8b,%cl
  72aaba:	08 c1                	or     %al,%cl
  72aabc:	0f 94 c0             	sete   %al
  72aabf:	40 20 f0             	and    %sil,%al
  72aac2:	84 d0                	test   %dl,%al
  72aac4:	74 5d                	je     72ab23 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xb33>
  72aac6:	e9 83 00 00 00       	jmp    72ab4e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xb5e>
  72aacb:	0f 2e c1             	ucomiss %xmm1,%xmm0
  72aace:	0f 9b c2             	setnp  %dl
  72aad1:	40 0f 94 c5          	sete   %bpl
  72aad5:	40 20 d5             	and    %dl,%bpl
  72aad8:	40 f6 d6             	not    %sil
  72aadb:	40 20 ee             	and    %bpl,%sil
  72aade:	0f 28 c3             	movaps %xmm3,%xmm0
  72aae1:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  72aae5:	0f 50 d0             	movmskps %xmm0,%edx
  72aae8:	89 d5                	mov    %edx,%ebp
  72aaea:	40 c0 ed 03          	shr    $0x3,%bpl
  72aaee:	c0 ea 02             	shr    $0x2,%dl
  72aaf1:	40 20 f2             	and    %sil,%dl
  72aaf4:	44 38 df             	cmp    %r11b,%dil
  72aaf7:	40 0f 94 c6          	sete   %sil
  72aafb:	40 20 ee             	and    %bpl,%sil
  72aafe:	40 20 d6             	and    %dl,%sil
  72ab01:	38 c1                	cmp    %al,%cl
  72ab03:	0f 94 c1             	sete   %cl
  72ab06:	44 38 94 24 80 00 00 	cmp    %r10b,0x80(%rsp)
  72ab0d:	00 
  72ab0e:	0f 94 c0             	sete   %al
  72ab11:	20 c8                	and    %cl,%al
  72ab13:	45 38 cd             	cmp    %r9b,%r13b
  72ab16:	0f 94 c1             	sete   %cl
  72ab19:	20 c1                	and    %al,%cl
  72ab1b:	40 20 f1             	and    %sil,%cl
  72ab1e:	80 f9 01             	cmp    $0x1,%cl
  72ab21:	74 2b                	je     72ab4e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xb5e>
  72ab23:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  72ab2a:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  72ab2f:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
  72ab34:	0f 29 a4 24 80 00 00 	movaps %xmm4,0x80(%rsp)
  72ab3b:	00 
  72ab3c:	e8 3f aa 01 00       	call   745580 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  72ab41:	0f 28 a4 24 80 00 00 	movaps 0x80(%rsp),%xmm4
  72ab48:	00 
  72ab49:	0f 28 5c 24 70       	movaps 0x70(%rsp),%xmm3
  72ab4e:	0f c2 dc 04          	cmpneqps %xmm4,%xmm3
  72ab52:	66 0f c5 c3 06       	pextrw $0x6,%xmm3,%eax
  72ab57:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  72ab5e:	a8 01                	test   $0x1,%al
  72ab60:	74 69                	je     72abcb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbdb>
  72ab62:	49 39 cf             	cmp    %rcx,%r15
  72ab65:	0f 83 13 01 00 00    	jae    72ac7e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc8e>
  72ab6b:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  72ab72:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  72ab76:	8b 7c d0 20          	mov    0x20(%rax,%rdx,8),%edi
  72ab7a:	89 f8                	mov    %edi,%eax
  72ab7c:	83 e0 07             	and    $0x7,%eax
  72ab7f:	83 f8 06             	cmp    $0x6,%eax
  72ab82:	74 47                	je     72abcb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbdb>
  72ab84:	c1 ef 03             	shr    $0x3,%edi
  72ab87:	74 42                	je     72abcb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbdb>
  72ab89:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  72ab90:	ff cf                	dec    %edi
  72ab92:	48 39 fe             	cmp    %rdi,%rsi
  72ab95:	0f 86 f6 00 00 00    	jbe    72ac91 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xca1>
  72ab9b:	4d 8b a6 b0 02 00 00 	mov    0x2b0(%r14),%r12
  72aba2:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  72aba6:	48 c1 e0 04          	shl    $0x4,%rax
  72abaa:	49 83 3c 04 fe       	cmpq   $0xfffffffffffffffe,(%r12,%rax,1)
  72abaf:	74 73                	je     72ac24 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc34>
  72abb1:	49 01 c4             	add    %rax,%r12
  72abb4:	4c 89 e7             	mov    %r12,%rdi
  72abb7:	e8 14 9e fc ff       	call   6f49d0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  72abbc:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  72abc3:	ff 
  72abc4:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  72abcb:	48 8d 94 24 e8 00 00 	lea    0xe8(%rsp),%rdx
  72abd2:	00 
  72abd3:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  72abda:	4c 89 fe             	mov    %r15,%rsi
  72abdd:	ff 15 c5 e9 3f 00    	call   *0x3fe9c5(%rip)        # b295a8 <_DYNAMIC+0x438>
  72abe3:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  72abea:	01 
  72abeb:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  72abf2:	48 81 c4 f8 01 00 00 	add    $0x1f8,%rsp
  72abf9:	5b                   	pop    %rbx
  72abfa:	41 5c                	pop    %r12
  72abfc:	41 5d                	pop    %r13
  72abfe:	41 5e                	pop    %r14
  72ac00:	41 5f                	pop    %r15
  72ac02:	5d                   	pop    %rbp
  72ac03:	c3                   	ret
  72ac04:	bf 08 00 00 00       	mov    $0x8,%edi
  72ac09:	be 08 01 00 00       	mov    $0x108,%esi
  72ac0e:	ff 15 cc e7 3f 00    	call   *0x3fe7cc(%rip)        # b293e0 <_DYNAMIC+0x270>
  72ac14:	bf 08 00 00 00       	mov    $0x8,%edi
  72ac19:	be 60 00 00 00       	mov    $0x60,%esi
  72ac1e:	ff 15 bc e7 3f 00    	call   *0x3fe7bc(%rip)        # b293e0 <_DYNAMIC+0x270>
  72ac24:	48 8d 3d 5d fe 3c 00 	lea    0x3cfe5d(%rip),%rdi        # afaa88 <__frame_dummy_init_array_entry+0x180>
  72ac2b:	ff 15 47 e8 3f 00    	call   *0x3fe847(%rip)        # b29478 <_DYNAMIC+0x308>
  72ac31:	48 8d 15 c0 03 3d 00 	lea    0x3d03c0(%rip),%rdx        # afaff8 <__frame_dummy_init_array_entry+0x6f0>
  72ac38:	4c 89 ff             	mov    %r15,%rdi
  72ac3b:	ff 15 87 e8 3f 00    	call   *0x3fe887(%rip)        # b294c8 <_DYNAMIC+0x358>
  72ac41:	48 8d 15 88 0a 3d 00 	lea    0x3d0a88(%rip),%rdx        # afb6d0 <__frame_dummy_init_array_entry+0xdc8>
  72ac48:	4c 89 ff             	mov    %r15,%rdi
  72ac4b:	ff 15 77 e8 3f 00    	call   *0x3fe877(%rip)        # b294c8 <_DYNAMIC+0x358>
  72ac51:	48 8d 15 b8 01 3d 00 	lea    0x3d01b8(%rip),%rdx        # afae10 <__frame_dummy_init_array_entry+0x508>
  72ac58:	4c 89 ff             	mov    %r15,%rdi
  72ac5b:	ff 15 67 e8 3f 00    	call   *0x3fe867(%rip)        # b294c8 <_DYNAMIC+0x358>
  72ac61:	48 8d 15 90 01 3d 00 	lea    0x3d0190(%rip),%rdx        # afadf8 <__frame_dummy_init_array_entry+0x4f0>
  72ac68:	4c 89 ff             	mov    %r15,%rdi
  72ac6b:	ff 15 57 e8 3f 00    	call   *0x3fe857(%rip)        # b294c8 <_DYNAMIC+0x358>
  72ac71:	48 8d 15 b0 01 3d 00 	lea    0x3d01b0(%rip),%rdx        # afae28 <__frame_dummy_init_array_entry+0x520>
  72ac78:	ff 15 4a e8 3f 00    	call   *0x3fe84a(%rip)        # b294c8 <_DYNAMIC+0x358>
  72ac7e:	48 8d 15 63 0a 3d 00 	lea    0x3d0a63(%rip),%rdx        # afb6e8 <__frame_dummy_init_array_entry+0xde0>
  72ac85:	4c 89 ff             	mov    %r15,%rdi
  72ac88:	48 89 ce             	mov    %rcx,%rsi
  72ac8b:	ff 15 37 e8 3f 00    	call   *0x3fe837(%rip)        # b294c8 <_DYNAMIC+0x358>
  72ac91:	48 8d 15 d8 fd 3c 00 	lea    0x3cfdd8(%rip),%rdx        # afaa70 <__frame_dummy_init_array_entry+0x168>
  72ac98:	ff 15 2a e8 3f 00    	call   *0x3fe82a(%rip)        # b294c8 <_DYNAMIC+0x358>
  72ac9e:	48 89 c3             	mov    %rax,%rbx
  72aca1:	be 08 01 00 00       	mov    $0x108,%esi
  72aca6:	ba 08 00 00 00       	mov    $0x8,%edx
  72acab:	4c 89 ff             	mov    %r15,%rdi
  72acae:	ff 15 04 e7 3f 00    	call   *0x3fe704(%rip)        # b293b8 <_DYNAMIC+0x248>
  72acb4:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  72acbb:	00 00 00 00 
  72acbf:	48 89 df             	mov    %rbx,%rdi
  72acc2:	e8 89 e8 3c 00       	call   af9550 <_Unwind_Resume@plt>
  72acc7:	48 89 c3             	mov    %rax,%rbx
  72acca:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72acd1:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  72acd8:	00 00 00 00 
  72acdc:	48 89 df             	mov    %rbx,%rdi
  72acdf:	e8 6c e8 3c 00       	call   af9550 <_Unwind_Resume@plt>
  72ace4:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  72aceb:	ff 
  72acec:	48 89 c7             	mov    %rax,%rdi
  72acef:	e8 5c e8 3c 00       	call   af9550 <_Unwind_Resume@plt>
