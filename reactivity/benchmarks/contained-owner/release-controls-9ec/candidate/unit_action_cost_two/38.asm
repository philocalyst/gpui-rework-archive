
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000729f80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at>:
  729f80:	55                   	push   %rbp
  729f81:	41 57                	push   %r15
  729f83:	41 56                	push   %r14
  729f85:	41 55                	push   %r13
  729f87:	41 54                	push   %r12
  729f89:	53                   	push   %rbx
  729f8a:	48 81 ec f8 01 00 00 	sub    $0x1f8,%rsp
  729f91:	4d 89 c5             	mov    %r8,%r13
  729f94:	89 cd                	mov    %ecx,%ebp
  729f96:	49 89 d7             	mov    %rdx,%r15
  729f99:	49 89 f6             	mov    %rsi,%r14
  729f9c:	48 89 fb             	mov    %rdi,%rbx
  729f9f:	45 0f b6 20          	movzbl (%r8),%r12d
  729fa3:	41 80 fc ff          	cmp    $0xff,%r12b
  729fa7:	74 1c                	je     729fc5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x45>
  729fa9:	89 ef                	mov    %ebp,%edi
  729fab:	4c 89 ee             	mov    %r13,%rsi
  729fae:	ff 15 54 f6 3f 00    	call   *0x3ff654(%rip)        # b29608 <_DYNAMIC+0x508>
  729fb4:	66 85 c0             	test   %ax,%ax
  729fb7:	74 0c                	je     729fc5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x45>
  729fb9:	48 89 c1             	mov    %rax,%rcx
  729fbc:	48 c1 e9 10          	shr    $0x10,%rcx
  729fc0:	e9 28 06 00 00       	jmp    72a5ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x66d>
  729fc5:	0f b7 c5             	movzwl %bp,%eax
  729fc8:	48 8d 0d 69 19 3d 00 	lea    0x3d1969(%rip),%rcx        # afb938 <__frame_dummy_init_array_entry+0x10a0>
  729fcf:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  729fd4:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  729fd8:	74 78                	je     72a052 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xd2>
  729fda:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  729fe1:	49 39 f7             	cmp    %rsi,%r15
  729fe4:	0f 83 d7 0b 00 00    	jae    72abc1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc41>
  729fea:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  729ff1:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  729ff5:	4c 8b 3c c8          	mov    (%rax,%rcx,8),%r15
  729ff9:	4d 8b a6 10 06 00 00 	mov    0x610(%r14),%r12
  72a000:	4d 85 e4             	test   %r12,%r12
  72a003:	0f 84 d4 00 00 00    	je     72a0dd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x15d>
  72a009:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72a010:	00 
  72a011:	48 85 ff             	test   %rdi,%rdi
  72a014:	0f 84 22 05 00 00    	je     72a53c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x5bc>
  72a01a:	4c 89 fe             	mov    %r15,%rsi
  72a01d:	ff 15 a5 f6 3f 00    	call   *0x3ff6a5(%rip)        # b296c8 <_DYNAMIC+0x5c8>
  72a023:	4d 8b a6 10 06 00 00 	mov    0x610(%r14),%r12
  72a02a:	66 0f 7e 84 24 e8 00 	movd   %xmm0,0xe8(%rsp)
  72a031:	00 00 
  72a033:	4d 85 e4             	test   %r12,%r12
  72a036:	0f 84 b0 00 00 00    	je     72a0ec <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x16c>
  72a03c:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72a043:	00 
  72a044:	48 85 ff             	test   %rdi,%rdi
  72a047:	0f 85 81 05 00 00    	jne    72a5ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x64e>
  72a04d:	e9 06 05 00 00       	jmp    72a558 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x5d8>
  72a052:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  72a059:	49 39 f7             	cmp    %rsi,%r15
  72a05c:	0f 83 6f 0b 00 00    	jae    72abd1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc51>
  72a062:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  72a069:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  72a06d:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  72a071:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  72a076:	49 8b 86 00 02 00 00 	mov    0x200(%r14),%rax
  72a07d:	48 8d 0d 14 19 93 ff 	lea    -0x6ce6ec(%rip),%rcx        # 5b998 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x138>
  72a084:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  72a088:	48 01 c8             	add    %rcx,%rax
  72a08b:	ff e0                	jmp    *%rax
  72a08d:	0f 10 05 bc 1a 93 ff 	movups -0x6ce544(%rip),%xmm0        # 5bb50 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2f0>
  72a094:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  72a099:	0f 10 05 a0 1a 93 ff 	movups -0x6ce560(%rip),%xmm0        # 5bb40 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e0>
  72a0a0:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  72a0a5:	0f 10 05 84 1a 93 ff 	movups -0x6ce57c(%rip),%xmm0        # 5bb30 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2d0>
  72a0ac:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  72a0b1:	0f 10 05 68 1a 93 ff 	movups -0x6ce598(%rip),%xmm0        # 5bb20 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c0>
  72a0b8:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  72a0bd:	0f 10 05 4c 1a 93 ff 	movups -0x6ce5b4(%rip),%xmm0        # 5bb10 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2b0>
  72a0c4:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  72a0c9:	48 b8 00 00 00 00 01 	movabs $0x3000100000000,%rax
  72a0d0:	00 03 00 
  72a0d3:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  72a0d8:	e9 81 01 00 00       	jmp    72a25e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x2de>
  72a0dd:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  72a0e4:	00 00 00 00 
  72a0e8:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72a0ec:	66 0f 7e 44 24 70    	movd   %xmm0,0x70(%rsp)
  72a0f2:	ff 15 68 f2 3f 00    	call   *0x3ff268(%rip)        # b29360 <_DYNAMIC+0x260>
  72a0f8:	bf 08 01 00 00       	mov    $0x108,%edi
  72a0fd:	be 08 00 00 00       	mov    $0x8,%esi
  72a102:	ff 15 38 f2 3f 00    	call   *0x3ff238(%rip)        # b29340 <_DYNAMIC+0x240>
  72a108:	48 85 c0             	test   %rax,%rax
  72a10b:	0f 84 83 0a 00 00    	je     72ab94 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc14>
  72a111:	49 89 c4             	mov    %rax,%r12
  72a114:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72a118:	f3 0f 7f 80 d8 00 00 	movdqu %xmm0,0xd8(%rax)
  72a11f:	00 
  72a120:	f3 0f 7f 40 28       	movdqu %xmm0,0x28(%rax)
  72a125:	f3 0f 7f 40 40       	movdqu %xmm0,0x40(%rax)
  72a12a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  72a131:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  72a138:	00 
  72a139:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  72a140:	00 
  72a141:	48 c7 40 38 08 00 00 	movq   $0x8,0x38(%rax)
  72a148:	00 
  72a149:	48 c7 40 50 08 00 00 	movq   $0x8,0x50(%rax)
  72a150:	00 
  72a151:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  72a158:	00 
  72a159:	48 c7 40 60 ff ff ff 	movq   $0xffffffffffffffff,0x60(%rax)
  72a160:	ff 
  72a161:	48 c7 80 c0 00 00 00 	movq   $0x0,0xc0(%rax)
  72a168:	00 00 00 00 
  72a16c:	48 c7 80 c8 00 00 00 	movq   $0x8,0xc8(%rax)
  72a173:	08 00 00 00 
  72a177:	48 c7 80 d0 00 00 00 	movq   $0x0,0xd0(%rax)
  72a17e:	00 00 00 00 
  72a182:	48 c7 80 e8 00 00 00 	movq   $0x0,0xe8(%rax)
  72a189:	00 00 00 00 
  72a18d:	f3 0f 7f 80 f8 00 00 	movdqu %xmm0,0xf8(%rax)
  72a194:	00 
  72a195:	49 89 86 10 06 00 00 	mov    %rax,0x610(%r14)
  72a19c:	66 0f 6e 44 24 70    	movd   0x70(%rsp),%xmm0
  72a1a2:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72a1a9:	00 
  72a1aa:	48 85 ff             	test   %rdi,%rdi
  72a1ad:	0f 85 1b 04 00 00    	jne    72a5ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x64e>
  72a1b3:	e9 a0 03 00 00       	jmp    72a558 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x5d8>
  72a1b8:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  72a1bf:	49 39 f7             	cmp    %rsi,%r15
  72a1c2:	0f 83 19 0a 00 00    	jae    72abe1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc61>
  72a1c8:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  72a1cf:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  72a1d6:	42 0f b6 3c 38       	movzbl (%rax,%r15,1),%edi
  72a1db:	48 39 fe             	cmp    %rdi,%rsi
  72a1de:	0f 86 1d 0a 00 00    	jbe    72ac01 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc81>
  72a1e4:	49 8b 86 08 02 00 00 	mov    0x208(%r14),%rax
  72a1eb:	48 6b cf 58          	imul   $0x58,%rdi,%rcx
  72a1ef:	eb 32                	jmp    72a223 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x2a3>
  72a1f1:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  72a1f8:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  72a1fd:	4c 89 fa             	mov    %r15,%rdx
  72a200:	ff 15 32 f2 3f 00    	call   *0x3ff232(%rip)        # b29438 <_DYNAMIC+0x338>
  72a206:	eb 56                	jmp    72a25e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x2de>
  72a208:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  72a20f:	49 39 f7             	cmp    %rsi,%r15
  72a212:	0f 83 d9 09 00 00    	jae    72abf1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc71>
  72a218:	49 8b 86 10 02 00 00 	mov    0x210(%r14),%rax
  72a21f:	49 6b cf 58          	imul   $0x58,%r15,%rcx
  72a223:	48 8b 54 08 50       	mov    0x50(%rax,%rcx,1),%rdx
  72a228:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  72a22d:	0f 10 44 08 40       	movups 0x40(%rax,%rcx,1),%xmm0
  72a232:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  72a237:	0f 10 04 08          	movups (%rax,%rcx,1),%xmm0
  72a23b:	0f 10 4c 08 10       	movups 0x10(%rax,%rcx,1),%xmm1
  72a240:	0f 10 54 08 20       	movups 0x20(%rax,%rcx,1),%xmm2
  72a245:	0f 10 5c 08 30       	movups 0x30(%rax,%rcx,1),%xmm3
  72a24a:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
  72a24f:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  72a254:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  72a259:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  72a25e:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  72a265:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  72a26c:	00 
  72a26d:	4c 89 fa             	mov    %r15,%rdx
  72a270:	ff 15 b2 f5 3f 00    	call   *0x3ff5b2(%rip)        # b29828 <_DYNAMIC+0x728>
  72a276:	80 bc 24 40 01 00 00 	cmpb   $0x0,0x140(%rsp)
  72a27d:	00 
  72a27e:	74 1a                	je     72a29a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x31a>
  72a280:	48 8d 94 24 44 01 00 	lea    0x144(%rsp),%rdx
  72a287:	00 
  72a288:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  72a28f:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  72a294:	ff 15 96 f5 3f 00    	call   *0x3ff596(%rip)        # b29830 <_DYNAMIC+0x730>
  72a29a:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  72a2a1:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  72a2a6:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  72a2ad:	00 
  72a2ae:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
  72a2b3:	0f 29 84 24 80 01 00 	movaps %xmm0,0x180(%rsp)
  72a2ba:	00 
  72a2bb:	66 0f 6f 44 24 10    	movdqa 0x10(%rsp),%xmm0
  72a2c1:	66 0f 6f 4c 24 20    	movdqa 0x20(%rsp),%xmm1
  72a2c7:	0f 28 54 24 30       	movaps 0x30(%rsp),%xmm2
  72a2cc:	0f 28 5c 24 40       	movaps 0x40(%rsp),%xmm3
  72a2d1:	0f 29 9c 24 70 01 00 	movaps %xmm3,0x170(%rsp)
  72a2d8:	00 
  72a2d9:	0f 29 94 24 60 01 00 	movaps %xmm2,0x160(%rsp)
  72a2e0:	00 
  72a2e1:	66 0f 7f 8c 24 50 01 	movdqa %xmm1,0x150(%rsp)
  72a2e8:	00 00 
  72a2ea:	66 0f 7f 84 24 40 01 	movdqa %xmm0,0x140(%rsp)
  72a2f1:	00 00 
  72a2f3:	48 8d bc 24 a0 01 00 	lea    0x1a0(%rsp),%rdi
  72a2fa:	00 
  72a2fb:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  72a302:	00 
  72a303:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  72a308:	41 89 e8             	mov    %ebp,%r8d
  72a30b:	4d 89 e9             	mov    %r13,%r9
  72a30e:	e8 7d 4d 04 00       	call   76f090 <<gpui::property::Overrides>::set_value>
  72a313:	44 8b ac 24 a0 01 00 	mov    0x1a0(%rsp),%r13d
  72a31a:	00 
  72a31b:	41 83 fd 02          	cmp    $0x2,%r13d
  72a31f:	75 2b                	jne    72a34c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x3cc>
  72a321:	0f b7 84 24 a8 01 00 	movzwl 0x1a8(%rsp),%eax
  72a328:	00 
  72a329:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  72a32e:	8b 8c 24 a4 01 00 00 	mov    0x1a4(%rsp),%ecx
  72a335:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  72a339:	66 89 43 0c          	mov    %ax,0xc(%rbx)
  72a33d:	89 4b 08             	mov    %ecx,0x8(%rbx)
  72a340:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  72a347:	e9 36 08 00 00       	jmp    72ab82 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc02>
  72a34c:	45 31 c0             	xor    %r8d,%r8d
  72a34f:	41 80 fc ff          	cmp    $0xff,%r12b
  72a353:	41 0f 95 c0          	setne  %r8b
  72a357:	0f b7 84 24 a8 01 00 	movzwl 0x1a8(%rsp),%eax
  72a35e:	00 
  72a35f:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  72a364:	8b 8c 24 a4 01 00 00 	mov    0x1a4(%rsp),%ecx
  72a36b:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  72a36f:	0f 10 84 24 aa 01 00 	movups 0x1aa(%rsp),%xmm0
  72a376:	00 
  72a377:	0f 11 84 24 f2 00 00 	movups %xmm0,0xf2(%rsp)
  72a37e:	00 
  72a37f:	0f 10 84 24 ba 01 00 	movups 0x1ba(%rsp),%xmm0
  72a386:	00 
  72a387:	0f 11 84 24 02 01 00 	movups %xmm0,0x102(%rsp)
  72a38e:	00 
  72a38f:	0f 10 84 24 ca 01 00 	movups 0x1ca(%rsp),%xmm0
  72a396:	00 
  72a397:	0f 11 84 24 12 01 00 	movups %xmm0,0x112(%rsp)
  72a39e:	00 
  72a39f:	0f 10 84 24 da 01 00 	movups 0x1da(%rsp),%xmm0
  72a3a6:	00 
  72a3a7:	0f 11 84 24 22 01 00 	movups %xmm0,0x122(%rsp)
  72a3ae:	00 
  72a3af:	0f 10 84 24 e8 01 00 	movups 0x1e8(%rsp),%xmm0
  72a3b6:	00 
  72a3b7:	0f 11 84 24 30 01 00 	movups %xmm0,0x130(%rsp)
  72a3be:	00 
  72a3bf:	44 89 ac 24 e8 00 00 	mov    %r13d,0xe8(%rsp)
  72a3c6:	00 
  72a3c7:	66 89 84 24 f0 00 00 	mov    %ax,0xf0(%rsp)
  72a3ce:	00 
  72a3cf:	89 8c 24 ec 00 00 00 	mov    %ecx,0xec(%rsp)
  72a3d6:	0f 10 84 24 28 01 00 	movups 0x128(%rsp),%xmm0
  72a3dd:	00 
  72a3de:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  72a3e5:	00 
  72a3e6:	0f 10 84 24 18 01 00 	movups 0x118(%rsp),%xmm0
  72a3ed:	00 
  72a3ee:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  72a3f5:	00 
  72a3f6:	0f 10 84 24 08 01 00 	movups 0x108(%rsp),%xmm0
  72a3fd:	00 
  72a3fe:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  72a405:	00 
  72a406:	0f 10 84 24 f8 00 00 	movups 0xf8(%rsp),%xmm0
  72a40d:	00 
  72a40e:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  72a415:	00 
  72a416:	0f 10 84 24 e8 00 00 	movups 0xe8(%rsp),%xmm0
  72a41d:	00 
  72a41e:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  72a425:	00 
  72a426:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  72a42d:	00 
  72a42e:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  72a435:	00 
  72a436:	4d 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%r9
  72a43d:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
  72a444:	00 
  72a445:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  72a44c:	00 
  72a44d:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  72a454:	00 
  72a455:	f3 0f 6f 84 24 f8 00 	movdqu 0xf8(%rsp),%xmm0
  72a45c:	00 00 
  72a45e:	f3 0f 6f 8c 24 08 01 	movdqu 0x108(%rsp),%xmm1
  72a465:	00 00 
  72a467:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  72a46e:	00 
  72a46f:	0f 10 9c 24 28 01 00 	movups 0x128(%rsp),%xmm3
  72a476:	00 
  72a477:	0f 29 9c 24 80 01 00 	movaps %xmm3,0x180(%rsp)
  72a47e:	00 
  72a47f:	0f 29 94 24 70 01 00 	movaps %xmm2,0x170(%rsp)
  72a486:	00 
  72a487:	66 0f 7f 8c 24 60 01 	movdqa %xmm1,0x160(%rsp)
  72a48e:	00 00 
  72a490:	66 0f 7f 84 24 50 01 	movdqa %xmm0,0x150(%rsp)
  72a497:	00 00 
  72a499:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  72a4a0:	00 
  72a4a1:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  72a4a8:	4c 89 fe             	mov    %r15,%rsi
  72a4ab:	89 ea                	mov    %ebp,%edx
  72a4ad:	ff 15 85 f3 3f 00    	call   *0x3ff385(%rip)        # b29838 <_DYNAMIC+0x738>
  72a4b3:	41 08 86 1f 08 00 00 	or     %al,0x81f(%r14)
  72a4ba:	8b 6c 24 10          	mov    0x10(%rsp),%ebp
  72a4be:	44 0f b6 a4 24 90 00 	movzbl 0x90(%rsp),%r12d
  72a4c5:	00 00 
  72a4c7:	83 fd 01             	cmp    $0x1,%ebp
  72a4ca:	75 25                	jne    72a4f1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x571>
  72a4cc:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  72a4d3:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  72a4d7:	39 c1                	cmp    %eax,%ecx
  72a4d9:	0f 94 c2             	sete   %dl
  72a4dc:	41 84 d4             	test   %dl,%r12b
  72a4df:	75 26                	jne    72a507 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x587>
  72a4e1:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  72a4e8:	01 00 00 00 
  72a4ec:	e9 78 03 00 00       	jmp    72a869 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8e9>
  72a4f1:	41 f6 c4 01          	test   $0x1,%r12b
  72a4f5:	74 10                	je     72a507 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x587>
  72a4f7:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  72a4fe:	01 00 00 00 
  72a502:	e9 76 04 00 00       	jmp    72a97d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a507:	8b 54 24 18          	mov    0x18(%rsp),%edx
  72a50b:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  72a512:	00 
  72a513:	83 fa 01             	cmp    $0x1,%edx
  72a516:	0f 85 27 02 00 00    	jne    72a743 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x7c3>
  72a51c:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  72a523:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  72a527:	0f 94 c0             	sete   %al
  72a52a:	be 01 00 00 00       	mov    $0x1,%esi
  72a52f:	84 c1                	test   %al,%cl
  72a531:	0f 85 1a 02 00 00    	jne    72a751 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x7d1>
  72a537:	e9 15 03 00 00       	jmp    72a851 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a53c:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  72a543:	00 00 00 00 
  72a547:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72a54b:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72a552:	00 
  72a553:	48 85 ff             	test   %rdi,%rdi
  72a556:	75 76                	jne    72a5ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x64e>
  72a558:	66 0f 7e 44 24 70    	movd   %xmm0,0x70(%rsp)
  72a55e:	ff 15 fc ed 3f 00    	call   *0x3fedfc(%rip)        # b29360 <_DYNAMIC+0x260>
  72a564:	bf 60 00 00 00       	mov    $0x60,%edi
  72a569:	be 08 00 00 00       	mov    $0x8,%esi
  72a56e:	ff 15 cc ed 3f 00    	call   *0x3fedcc(%rip)        # b29340 <_DYNAMIC+0x240>
  72a574:	48 85 c0             	test   %rax,%rax
  72a577:	0f 84 27 06 00 00    	je     72aba4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc24>
  72a57d:	48 89 c7             	mov    %rax,%rdi
  72a580:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72a584:	f3 0f 7f 40 10       	movdqu %xmm0,0x10(%rax)
  72a589:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  72a590:	48 c7 40 08 08 00 00 	movq   $0x8,0x8(%rax)
  72a597:	00 
  72a598:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  72a59f:	00 
  72a5a0:	48 c7 40 28 00 00 00 	movq   $0x0,0x28(%rax)
  72a5a7:	00 
  72a5a8:	48 c7 40 30 ff ff ff 	movq   $0xffffffffffffffff,0x30(%rax)
  72a5af:	ff 
  72a5b0:	48 c7 40 48 00 00 00 	movq   $0x0,0x48(%rax)
  72a5b7:	00 
  72a5b8:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  72a5bf:	00 
  72a5c0:	49 89 84 24 00 01 00 	mov    %rax,0x100(%r12)
  72a5c7:	00 
  72a5c8:	66 0f 6e 44 24 70    	movd   0x70(%rsp),%xmm0
  72a5ce:	48 83 c7 48          	add    $0x48,%rdi
  72a5d2:	4c 89 fe             	mov    %r15,%rsi
  72a5d5:	89 ea                	mov    %ebp,%edx
  72a5d7:	4c 89 e9             	mov    %r13,%rcx
  72a5da:	e8 31 42 04 00       	call   76e810 <<gpui::property::Overrides<gpui::property::GeometryStyle>>::set_value>
  72a5df:	48 89 c1             	mov    %rax,%rcx
  72a5e2:	48 c1 e9 20          	shr    $0x20,%rcx
  72a5e6:	a8 01                	test   $0x1,%al
  72a5e8:	74 16                	je     72a600 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x680>
  72a5ea:	c1 e8 10             	shr    $0x10,%eax
  72a5ed:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  72a5f4:	66 89 43 08          	mov    %ax,0x8(%rbx)
  72a5f8:	89 4b 0a             	mov    %ecx,0xa(%rbx)
  72a5fb:	e9 82 05 00 00       	jmp    72ab82 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc02>
  72a600:	66 0f 6e c1          	movd   %ecx,%xmm0
  72a604:	89 8c 24 40 01 00 00 	mov    %ecx,0x140(%rsp)
  72a60b:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72a612:	00 
  72a613:	4c 89 fe             	mov    %r15,%rsi
  72a616:	ff 15 24 f2 3f 00    	call   *0x3ff224(%rip)        # b29840 <_DYNAMIC+0x740>
  72a61c:	49 8b 84 24 00 01 00 	mov    0x100(%r12),%rax
  72a623:	00 
  72a624:	48 83 78 10 00       	cmpq   $0x0,0x10(%rax)
  72a629:	75 3a                	jne    72a665 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x6e5>
  72a62b:	48 83 78 58 00       	cmpq   $0x0,0x58(%rax)
  72a630:	75 33                	jne    72a665 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x6e5>
  72a632:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  72a637:	75 2c                	jne    72a665 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x6e5>
  72a639:	48 83 78 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rax)
  72a63e:	75 25                	jne    72a665 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x6e5>
  72a640:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72a647:	48 8b b8 00 01 00 00 	mov    0x100(%rax),%rdi
  72a64e:	e8 3d a0 fc ff       	call   6f4690 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::geometry::Geometry>>>>
  72a653:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72a65a:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  72a661:	00 00 00 00 
  72a665:	48 8b 05 8c ee 3f 00 	mov    0x3fee8c(%rip),%rax        # b294f8 <_DYNAMIC+0x3f8>
  72a66c:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  72a673:	00 
  72a674:	48 8d b4 24 40 01 00 	lea    0x140(%rsp),%rsi
  72a67b:	00 
  72a67c:	ff 50 18             	call   *0x18(%rax)
  72a67f:	34 01                	xor    $0x1,%al
  72a681:	0f b6 c0             	movzbl %al,%eax
  72a684:	49 89 86 08 07 00 00 	mov    %rax,0x708(%r14)
  72a68b:	41 08 86 1f 08 00 00 	or     %al,0x81f(%r14)
  72a692:	4d 8b be 10 06 00 00 	mov    0x610(%r14),%r15
  72a699:	4d 85 ff             	test   %r15,%r15
  72a69c:	0f 84 d9 04 00 00    	je     72ab7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a6a2:	49 83 bf d8 00 00 00 	cmpq   $0x0,0xd8(%r15)
  72a6a9:	00 
  72a6aa:	0f 85 cb 04 00 00    	jne    72ab7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a6b0:	49 83 bf e0 00 00 00 	cmpq   $0x0,0xe0(%r15)
  72a6b7:	00 
  72a6b8:	0f 85 bd 04 00 00    	jne    72ab7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a6be:	49 83 bf 00 01 00 00 	cmpq   $0x0,0x100(%r15)
  72a6c5:	00 
  72a6c6:	0f 85 af 04 00 00    	jne    72ab7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a6cc:	49 83 bf d0 00 00 00 	cmpq   $0x0,0xd0(%r15)
  72a6d3:	00 
  72a6d4:	0f 85 a1 04 00 00    	jne    72ab7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a6da:	49 83 bf f8 00 00 00 	cmpq   $0x0,0xf8(%r15)
  72a6e1:	00 
  72a6e2:	0f 85 93 04 00 00    	jne    72ab7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a6e8:	49 8b 47 60          	mov    0x60(%r15),%rax
  72a6ec:	83 f8 ff             	cmp    $0xffffffff,%eax
  72a6ef:	0f 85 86 04 00 00    	jne    72ab7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a6f5:	49 83 7f 28 00       	cmpq   $0x0,0x28(%r15)
  72a6fa:	0f 85 7b 04 00 00    	jne    72ab7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a700:	49 8b 07             	mov    (%r15),%rax
  72a703:	49 0b 47 40          	or     0x40(%r15),%rax
  72a707:	0f 85 6e 04 00 00    	jne    72ab7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a70d:	49 83 7f 58 00       	cmpq   $0x0,0x58(%r15)
  72a712:	0f 85 63 04 00 00    	jne    72ab7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a718:	4c 89 ff             	mov    %r15,%rdi
  72a71b:	e8 30 ec fc ff       	call   6f9350 <core::ptr::drop_glue::<gpui::runtime::metadata::Metadata>>
  72a720:	be 08 01 00 00       	mov    $0x108,%esi
  72a725:	ba 08 00 00 00       	mov    $0x8,%edx
  72a72a:	4c 89 ff             	mov    %r15,%rdi
  72a72d:	ff 15 15 ec 3f 00    	call   *0x3fec15(%rip)        # b29348 <_DYNAMIC+0x248>
  72a733:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  72a73a:	00 00 00 00 
  72a73e:	e9 38 04 00 00       	jmp    72ab7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a743:	be 01 00 00 00       	mov    $0x1,%esi
  72a748:	f6 c1 01             	test   $0x1,%cl
  72a74b:	0f 85 00 01 00 00    	jne    72a851 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a751:	8b 44 24 20          	mov    0x20(%rsp),%eax
  72a755:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  72a75c:	0f 85 ef 00 00 00    	jne    72a851 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a762:	8b 44 24 24          	mov    0x24(%rsp),%eax
  72a766:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  72a76d:	0f 85 de 00 00 00    	jne    72a851 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a773:	8b 44 24 28          	mov    0x28(%rsp),%eax
  72a777:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  72a77e:	0f 85 cd 00 00 00    	jne    72a851 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a784:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  72a789:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  72a790:	0f 85 bb 00 00 00    	jne    72a851 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a796:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  72a79b:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  72a7a2:	0f 85 a9 00 00 00    	jne    72a851 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a7a8:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  72a7ad:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  72a7b4:	0f 85 97 00 00 00    	jne    72a851 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a7ba:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  72a7bf:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  72a7c6:	0f 85 85 00 00 00    	jne    72a851 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a7cc:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  72a7d0:	88 8c 24 80 00 00 00 	mov    %cl,0x80(%rsp)
  72a7d7:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  72a7dc:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  72a7e3:	00 
  72a7e4:	e8 c7 16 00 00       	call   72beb0 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  72a7e9:	84 c0                	test   %al,%al
  72a7eb:	74 53                	je     72a840 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8c0>
  72a7ed:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  72a7f3:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  72a7fa:	00 00 
  72a7fc:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72a800:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72a804:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72a809:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  72a810:	00 
  72a811:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  72a815:	be 01 00 00 00       	mov    $0x1,%esi
  72a81a:	75 35                	jne    72a851 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a81c:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  72a822:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  72a829:	00 00 
  72a82b:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72a82f:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72a833:	31 f6                	xor    %esi,%esi
  72a835:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72a83a:	40 0f 95 c6          	setne  %sil
  72a83e:	eb 11                	jmp    72a851 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x8d1>
  72a840:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  72a847:	00 
  72a848:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  72a84c:	be 01 00 00 00       	mov    $0x1,%esi
  72a851:	49 89 b6 08 07 00 00 	mov    %rsi,0x708(%r14)
  72a858:	40 f6 c5 01          	test   $0x1,%bpl
  72a85c:	74 2b                	je     72a889 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x909>
  72a85e:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  72a865:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  72a869:	39 c1                	cmp    %eax,%ecx
  72a86b:	0f 94 c0             	sete   %al
  72a86e:	41 20 c4             	and    %al,%r12b
  72a871:	41 80 fc 01          	cmp    $0x1,%r12b
  72a875:	0f 85 02 01 00 00    	jne    72a97d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a87b:	8b 54 24 18          	mov    0x18(%rsp),%edx
  72a87f:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  72a886:	00 
  72a887:	eb 0a                	jmp    72a893 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x913>
  72a889:	41 f6 c4 01          	test   $0x1,%r12b
  72a88d:	0f 85 ea 00 00 00    	jne    72a97d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a893:	83 fa 01             	cmp    $0x1,%edx
  72a896:	75 17                	jne    72a8af <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x92f>
  72a898:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  72a89f:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  72a8a3:	0f 94 c0             	sete   %al
  72a8a6:	84 c1                	test   %al,%cl
  72a8a8:	75 0e                	jne    72a8b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x938>
  72a8aa:	e9 ce 00 00 00       	jmp    72a97d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a8af:	f6 c1 01             	test   $0x1,%cl
  72a8b2:	0f 85 c5 00 00 00    	jne    72a97d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a8b8:	8b 44 24 20          	mov    0x20(%rsp),%eax
  72a8bc:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  72a8c3:	0f 85 b4 00 00 00    	jne    72a97d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a8c9:	8b 44 24 24          	mov    0x24(%rsp),%eax
  72a8cd:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  72a8d4:	0f 85 a3 00 00 00    	jne    72a97d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a8da:	8b 44 24 28          	mov    0x28(%rsp),%eax
  72a8de:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  72a8e5:	0f 85 92 00 00 00    	jne    72a97d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a8eb:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  72a8f0:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  72a8f7:	0f 85 80 00 00 00    	jne    72a97d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a8fd:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  72a902:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  72a909:	75 72                	jne    72a97d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a90b:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  72a910:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  72a917:	75 64                	jne    72a97d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a919:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  72a91e:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  72a925:	75 56                	jne    72a97d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a927:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  72a92c:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  72a933:	00 
  72a934:	e8 77 15 00 00       	call   72beb0 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  72a939:	84 c0                	test   %al,%al
  72a93b:	74 40                	je     72a97d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a93d:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  72a943:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  72a94a:	00 00 
  72a94c:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72a950:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72a954:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72a959:	75 22                	jne    72a97d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0x9fd>
  72a95b:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  72a961:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  72a968:	00 00 
  72a96a:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72a96e:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72a972:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72a977:	0f 84 fe 01 00 00    	je     72ab7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbfb>
  72a97d:	45 89 e8             	mov    %r13d,%r8d
  72a980:	44 8b 64 24 18       	mov    0x18(%rsp),%r12d
  72a985:	0f b6 7c 24 64       	movzbl 0x64(%rsp),%edi
  72a98a:	44 0f b6 6c 24 65    	movzbl 0x65(%rsp),%r13d
  72a990:	0f b6 4c 24 66       	movzbl 0x66(%rsp),%ecx
  72a995:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  72a99a:	88 84 24 80 00 00 00 	mov    %al,0x80(%rsp)
  72a9a1:	8b b4 24 f0 00 00 00 	mov    0xf0(%rsp),%esi
  72a9a8:	0f 10 5c 24 1c       	movups 0x1c(%rsp),%xmm3
  72a9ad:	f3 0f 10 44 24 20    	movss  0x20(%rsp),%xmm0
  72a9b3:	0f 10 a4 24 f4 00 00 	movups 0xf4(%rsp),%xmm4
  72a9ba:	00 
  72a9bb:	f3 0f 10 8c 24 f8 00 	movss  0xf8(%rsp),%xmm1
  72a9c2:	00 00 
  72a9c4:	44 0f b6 9c 24 3c 01 	movzbl 0x13c(%rsp),%r11d
  72a9cb:	00 00 
  72a9cd:	44 0f b6 8c 24 3d 01 	movzbl 0x13d(%rsp),%r9d
  72a9d4:	00 00 
  72a9d6:	0f b6 84 24 3e 01 00 	movzbl 0x13e(%rsp),%eax
  72a9dd:	00 
  72a9de:	44 0f b6 94 24 3f 01 	movzbl 0x13f(%rsp),%r10d
  72a9e5:	00 00 
  72a9e7:	40 f6 c5 01          	test   $0x1,%bpl
  72a9eb:	74 22                	je     72aa0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xa8f>
  72a9ed:	f3 0f 10 54 24 14    	movss  0x14(%rsp),%xmm2
  72a9f3:	0f 2e 94 24 ec 00 00 	ucomiss 0xec(%rsp),%xmm2
  72a9fa:	00 
  72a9fb:	40 0f 9b c5          	setnp  %bpl
  72a9ff:	0f 94 c2             	sete   %dl
  72aa02:	40 20 ea             	and    %bpl,%dl
  72aa05:	41 84 d0             	test   %dl,%r8b
  72aa08:	75 0f                	jne    72aa19 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xa99>
  72aa0a:	e9 a4 00 00 00       	jmp    72aab3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xb33>
  72aa0f:	41 f6 c0 01          	test   $0x1,%r8b
  72aa13:	0f 85 9a 00 00 00    	jne    72aab3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xb33>
  72aa19:	41 83 fc 01          	cmp    $0x1,%r12d
  72aa1d:	75 3c                	jne    72aa5b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xadb>
  72aa1f:	44 30 df             	xor    %r11b,%dil
  72aa22:	30 c1                	xor    %al,%cl
  72aa24:	0f b6 84 24 80 00 00 	movzbl 0x80(%rsp),%eax
  72aa2b:	00 
  72aa2c:	44 30 d0             	xor    %r10b,%al
  72aa2f:	45 38 cd             	cmp    %r9b,%r13b
  72aa32:	0f 94 c2             	sete   %dl
  72aa35:	0f 28 c3             	movaps %xmm3,%xmm0
  72aa38:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  72aa3c:	44 0f 50 c0          	movmskps %xmm0,%r8d
  72aa40:	41 80 f0 0f          	xor    $0xf,%r8b
  72aa44:	40 08 f9             	or     %dil,%cl
  72aa47:	44 08 c1             	or     %r8b,%cl
  72aa4a:	08 c1                	or     %al,%cl
  72aa4c:	0f 94 c0             	sete   %al
  72aa4f:	40 20 f0             	and    %sil,%al
  72aa52:	84 d0                	test   %dl,%al
  72aa54:	74 5d                	je     72aab3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xb33>
  72aa56:	e9 83 00 00 00       	jmp    72aade <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xb5e>
  72aa5b:	0f 2e c1             	ucomiss %xmm1,%xmm0
  72aa5e:	0f 9b c2             	setnp  %dl
  72aa61:	40 0f 94 c5          	sete   %bpl
  72aa65:	40 20 d5             	and    %dl,%bpl
  72aa68:	40 f6 d6             	not    %sil
  72aa6b:	40 20 ee             	and    %bpl,%sil
  72aa6e:	0f 28 c3             	movaps %xmm3,%xmm0
  72aa71:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  72aa75:	0f 50 d0             	movmskps %xmm0,%edx
  72aa78:	89 d5                	mov    %edx,%ebp
  72aa7a:	40 c0 ed 03          	shr    $0x3,%bpl
  72aa7e:	c0 ea 02             	shr    $0x2,%dl
  72aa81:	40 20 f2             	and    %sil,%dl
  72aa84:	44 38 df             	cmp    %r11b,%dil
  72aa87:	40 0f 94 c6          	sete   %sil
  72aa8b:	40 20 ee             	and    %bpl,%sil
  72aa8e:	40 20 d6             	and    %dl,%sil
  72aa91:	38 c1                	cmp    %al,%cl
  72aa93:	0f 94 c1             	sete   %cl
  72aa96:	44 38 94 24 80 00 00 	cmp    %r10b,0x80(%rsp)
  72aa9d:	00 
  72aa9e:	0f 94 c0             	sete   %al
  72aaa1:	20 c8                	and    %cl,%al
  72aaa3:	45 38 cd             	cmp    %r9b,%r13b
  72aaa6:	0f 94 c1             	sete   %cl
  72aaa9:	20 c1                	and    %al,%cl
  72aaab:	40 20 f1             	and    %sil,%cl
  72aaae:	80 f9 01             	cmp    $0x1,%cl
  72aab1:	74 2b                	je     72aade <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xb5e>
  72aab3:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  72aaba:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  72aabf:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
  72aac4:	0f 29 a4 24 80 00 00 	movaps %xmm4,0x80(%rsp)
  72aacb:	00 
  72aacc:	e8 3f aa 01 00       	call   745510 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  72aad1:	0f 28 a4 24 80 00 00 	movaps 0x80(%rsp),%xmm4
  72aad8:	00 
  72aad9:	0f 28 5c 24 70       	movaps 0x70(%rsp),%xmm3
  72aade:	0f c2 dc 04          	cmpneqps %xmm4,%xmm3
  72aae2:	66 0f c5 c3 06       	pextrw $0x6,%xmm3,%eax
  72aae7:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  72aaee:	a8 01                	test   $0x1,%al
  72aaf0:	74 69                	je     72ab5b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbdb>
  72aaf2:	49 39 cf             	cmp    %rcx,%r15
  72aaf5:	0f 83 13 01 00 00    	jae    72ac0e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc8e>
  72aafb:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  72ab02:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  72ab06:	8b 7c d0 20          	mov    0x20(%rax,%rdx,8),%edi
  72ab0a:	89 f8                	mov    %edi,%eax
  72ab0c:	83 e0 07             	and    $0x7,%eax
  72ab0f:	83 f8 06             	cmp    $0x6,%eax
  72ab12:	74 47                	je     72ab5b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbdb>
  72ab14:	c1 ef 03             	shr    $0x3,%edi
  72ab17:	74 42                	je     72ab5b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xbdb>
  72ab19:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  72ab20:	ff cf                	dec    %edi
  72ab22:	48 39 fe             	cmp    %rdi,%rsi
  72ab25:	0f 86 f6 00 00 00    	jbe    72ac21 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xca1>
  72ab2b:	4d 8b a6 b0 02 00 00 	mov    0x2b0(%r14),%r12
  72ab32:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  72ab36:	48 c1 e0 04          	shl    $0x4,%rax
  72ab3a:	49 83 3c 04 fe       	cmpq   $0xfffffffffffffffe,(%r12,%rax,1)
  72ab3f:	74 73                	je     72abb4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::apply_property_value_at+0xc34>
  72ab41:	49 01 c4             	add    %rax,%r12
  72ab44:	4c 89 e7             	mov    %r12,%rdi
  72ab47:	e8 74 9e fc ff       	call   6f49c0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  72ab4c:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  72ab53:	ff 
  72ab54:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  72ab5b:	48 8d 94 24 e8 00 00 	lea    0xe8(%rsp),%rdx
  72ab62:	00 
  72ab63:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  72ab6a:	4c 89 fe             	mov    %r15,%rsi
  72ab6d:	ff 15 c5 e9 3f 00    	call   *0x3fe9c5(%rip)        # b29538 <_DYNAMIC+0x438>
  72ab73:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  72ab7a:	01 
  72ab7b:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  72ab82:	48 81 c4 f8 01 00 00 	add    $0x1f8,%rsp
  72ab89:	5b                   	pop    %rbx
  72ab8a:	41 5c                	pop    %r12
  72ab8c:	41 5d                	pop    %r13
  72ab8e:	41 5e                	pop    %r14
  72ab90:	41 5f                	pop    %r15
  72ab92:	5d                   	pop    %rbp
  72ab93:	c3                   	ret
  72ab94:	bf 08 00 00 00       	mov    $0x8,%edi
  72ab99:	be 08 01 00 00       	mov    $0x108,%esi
  72ab9e:	ff 15 cc e7 3f 00    	call   *0x3fe7cc(%rip)        # b29370 <_DYNAMIC+0x270>
  72aba4:	bf 08 00 00 00       	mov    $0x8,%edi
  72aba9:	be 60 00 00 00       	mov    $0x60,%esi
  72abae:	ff 15 bc e7 3f 00    	call   *0x3fe7bc(%rip)        # b29370 <_DYNAMIC+0x270>
  72abb4:	48 8d 3d 5d fe 3c 00 	lea    0x3cfe5d(%rip),%rdi        # afaa18 <__frame_dummy_init_array_entry+0x180>
  72abbb:	ff 15 47 e8 3f 00    	call   *0x3fe847(%rip)        # b29408 <_DYNAMIC+0x308>
  72abc1:	48 8d 15 c0 03 3d 00 	lea    0x3d03c0(%rip),%rdx        # afaf88 <__frame_dummy_init_array_entry+0x6f0>
  72abc8:	4c 89 ff             	mov    %r15,%rdi
  72abcb:	ff 15 87 e8 3f 00    	call   *0x3fe887(%rip)        # b29458 <_DYNAMIC+0x358>
  72abd1:	48 8d 15 88 0a 3d 00 	lea    0x3d0a88(%rip),%rdx        # afb660 <__frame_dummy_init_array_entry+0xdc8>
  72abd8:	4c 89 ff             	mov    %r15,%rdi
  72abdb:	ff 15 77 e8 3f 00    	call   *0x3fe877(%rip)        # b29458 <_DYNAMIC+0x358>
  72abe1:	48 8d 15 b8 01 3d 00 	lea    0x3d01b8(%rip),%rdx        # afada0 <__frame_dummy_init_array_entry+0x508>
  72abe8:	4c 89 ff             	mov    %r15,%rdi
  72abeb:	ff 15 67 e8 3f 00    	call   *0x3fe867(%rip)        # b29458 <_DYNAMIC+0x358>
  72abf1:	48 8d 15 90 01 3d 00 	lea    0x3d0190(%rip),%rdx        # afad88 <__frame_dummy_init_array_entry+0x4f0>
  72abf8:	4c 89 ff             	mov    %r15,%rdi
  72abfb:	ff 15 57 e8 3f 00    	call   *0x3fe857(%rip)        # b29458 <_DYNAMIC+0x358>
  72ac01:	48 8d 15 b0 01 3d 00 	lea    0x3d01b0(%rip),%rdx        # afadb8 <__frame_dummy_init_array_entry+0x520>
  72ac08:	ff 15 4a e8 3f 00    	call   *0x3fe84a(%rip)        # b29458 <_DYNAMIC+0x358>
  72ac0e:	48 8d 15 63 0a 3d 00 	lea    0x3d0a63(%rip),%rdx        # afb678 <__frame_dummy_init_array_entry+0xde0>
  72ac15:	4c 89 ff             	mov    %r15,%rdi
  72ac18:	48 89 ce             	mov    %rcx,%rsi
  72ac1b:	ff 15 37 e8 3f 00    	call   *0x3fe837(%rip)        # b29458 <_DYNAMIC+0x358>
  72ac21:	48 8d 15 d8 fd 3c 00 	lea    0x3cfdd8(%rip),%rdx        # afaa00 <__frame_dummy_init_array_entry+0x168>
  72ac28:	ff 15 2a e8 3f 00    	call   *0x3fe82a(%rip)        # b29458 <_DYNAMIC+0x358>
  72ac2e:	48 89 c3             	mov    %rax,%rbx
  72ac31:	be 08 01 00 00       	mov    $0x108,%esi
  72ac36:	ba 08 00 00 00       	mov    $0x8,%edx
  72ac3b:	4c 89 ff             	mov    %r15,%rdi
  72ac3e:	ff 15 04 e7 3f 00    	call   *0x3fe704(%rip)        # b29348 <_DYNAMIC+0x248>
  72ac44:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  72ac4b:	00 00 00 00 
  72ac4f:	48 89 df             	mov    %rbx,%rdi
  72ac52:	e8 89 e8 3c 00       	call   af94e0 <_Unwind_Resume@plt>
  72ac57:	48 89 c3             	mov    %rax,%rbx
  72ac5a:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72ac61:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  72ac68:	00 00 00 00 
  72ac6c:	48 89 df             	mov    %rbx,%rdi
  72ac6f:	e8 6c e8 3c 00       	call   af94e0 <_Unwind_Resume@plt>
  72ac74:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  72ac7b:	ff 
  72ac7c:	48 89 c7             	mov    %rax,%rdi
  72ac7f:	e8 5c e8 3c 00       	call   af94e0 <_Unwind_Resume@plt>
