
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000071ee80 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at>:
  71ee80:	55                   	push   %rbp
  71ee81:	41 57                	push   %r15
  71ee83:	41 56                	push   %r14
  71ee85:	41 55                	push   %r13
  71ee87:	41 54                	push   %r12
  71ee89:	53                   	push   %rbx
  71ee8a:	48 81 ec f8 01 00 00 	sub    $0x1f8,%rsp
  71ee91:	4d 89 c5             	mov    %r8,%r13
  71ee94:	89 cd                	mov    %ecx,%ebp
  71ee96:	49 89 d7             	mov    %rdx,%r15
  71ee99:	49 89 f6             	mov    %rsi,%r14
  71ee9c:	48 89 fb             	mov    %rdi,%rbx
  71ee9f:	45 0f b6 20          	movzbl (%r8),%r12d
  71eea3:	41 80 fc ff          	cmp    $0xff,%r12b
  71eea7:	74 1c                	je     71eec5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x45>
  71eea9:	89 ef                	mov    %ebp,%edi
  71eeab:	4c 89 ee             	mov    %r13,%rsi
  71eeae:	ff 15 b4 34 3e 00    	call   *0x3e34b4(%rip)        # b02368 <_DYNAMIC+0x520>
  71eeb4:	66 85 c0             	test   %ax,%ax
  71eeb7:	74 0c                	je     71eec5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x45>
  71eeb9:	48 89 c1             	mov    %rax,%rcx
  71eebc:	48 c1 e9 10          	shr    $0x10,%rcx
  71eec0:	e9 28 06 00 00       	jmp    71f4ed <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x66d>
  71eec5:	0f b7 c5             	movzwl %bp,%eax
  71eec8:	48 8d 0d 71 5b 3b 00 	lea    0x3b5b71(%rip),%rcx        # ad4a40 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1198>
  71eecf:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  71eed4:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  71eed8:	74 78                	je     71ef52 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xd2>
  71eeda:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  71eee1:	49 39 f7             	cmp    %rsi,%r15
  71eee4:	0f 83 d7 0b 00 00    	jae    71fac1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc41>
  71eeea:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  71eef1:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  71eef5:	4c 8b 3c c8          	mov    (%rax,%rcx,8),%r15
  71eef9:	4d 8b a6 10 06 00 00 	mov    0x610(%r14),%r12
  71ef00:	4d 85 e4             	test   %r12,%r12
  71ef03:	0f 84 d4 00 00 00    	je     71efdd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x15d>
  71ef09:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  71ef10:	00 
  71ef11:	48 85 ff             	test   %rdi,%rdi
  71ef14:	0f 84 22 05 00 00    	je     71f43c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x5bc>
  71ef1a:	4c 89 fe             	mov    %r15,%rsi
  71ef1d:	ff 15 fd 34 3e 00    	call   *0x3e34fd(%rip)        # b02420 <_DYNAMIC+0x5d8>
  71ef23:	4d 8b a6 10 06 00 00 	mov    0x610(%r14),%r12
  71ef2a:	66 0f 7e 84 24 e8 00 	movd   %xmm0,0xe8(%rsp)
  71ef31:	00 00 
  71ef33:	4d 85 e4             	test   %r12,%r12
  71ef36:	0f 84 b0 00 00 00    	je     71efec <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x16c>
  71ef3c:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  71ef43:	00 
  71ef44:	48 85 ff             	test   %rdi,%rdi
  71ef47:	0f 85 81 05 00 00    	jne    71f4ce <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x64e>
  71ef4d:	e9 06 05 00 00       	jmp    71f458 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x5d8>
  71ef52:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  71ef59:	49 39 f7             	cmp    %rsi,%r15
  71ef5c:	0f 83 6f 0b 00 00    	jae    71fad1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc51>
  71ef62:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  71ef69:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  71ef6d:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  71ef71:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  71ef76:	49 8b 86 00 02 00 00 	mov    0x200(%r14),%rax
  71ef7d:	48 8d 0d 38 79 94 ff 	lea    -0x6b86c8(%rip),%rcx        # 668bc <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x9c>
  71ef84:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  71ef88:	48 01 c8             	add    %rcx,%rax
  71ef8b:	ff e0                	jmp    *%rax
  71ef8d:	0f 10 05 d0 7a 94 ff 	movups -0x6b8530(%rip),%xmm0        # 66a64 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x244>
  71ef94:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  71ef99:	0f 10 05 b4 7a 94 ff 	movups -0x6b854c(%rip),%xmm0        # 66a54 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x234>
  71efa0:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  71efa5:	0f 10 05 98 7a 94 ff 	movups -0x6b8568(%rip),%xmm0        # 66a44 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x224>
  71efac:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  71efb1:	0f 10 05 7c 7a 94 ff 	movups -0x6b8584(%rip),%xmm0        # 66a34 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x214>
  71efb8:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  71efbd:	0f 10 05 60 7a 94 ff 	movups -0x6b85a0(%rip),%xmm0        # 66a24 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x204>
  71efc4:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  71efc9:	48 b8 00 00 00 00 01 	movabs $0x3000100000000,%rax
  71efd0:	00 03 00 
  71efd3:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  71efd8:	e9 81 01 00 00       	jmp    71f15e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x2de>
  71efdd:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  71efe4:	00 00 00 00 
  71efe8:	66 0f ef c0          	pxor   %xmm0,%xmm0
  71efec:	66 0f 7e 44 24 70    	movd   %xmm0,0x70(%rsp)
  71eff2:	ff 15 b0 30 3e 00    	call   *0x3e30b0(%rip)        # b020a8 <_DYNAMIC+0x260>
  71eff8:	bf 08 01 00 00       	mov    $0x108,%edi
  71effd:	be 08 00 00 00       	mov    $0x8,%esi
  71f002:	ff 15 80 30 3e 00    	call   *0x3e3080(%rip)        # b02088 <_DYNAMIC+0x240>
  71f008:	48 85 c0             	test   %rax,%rax
  71f00b:	0f 84 83 0a 00 00    	je     71fa94 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc14>
  71f011:	49 89 c4             	mov    %rax,%r12
  71f014:	66 0f ef c0          	pxor   %xmm0,%xmm0
  71f018:	f3 0f 7f 80 d8 00 00 	movdqu %xmm0,0xd8(%rax)
  71f01f:	00 
  71f020:	f3 0f 7f 40 28       	movdqu %xmm0,0x28(%rax)
  71f025:	f3 0f 7f 40 40       	movdqu %xmm0,0x40(%rax)
  71f02a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  71f031:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  71f038:	00 
  71f039:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  71f040:	00 
  71f041:	48 c7 40 38 08 00 00 	movq   $0x8,0x38(%rax)
  71f048:	00 
  71f049:	48 c7 40 50 08 00 00 	movq   $0x8,0x50(%rax)
  71f050:	00 
  71f051:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  71f058:	00 
  71f059:	48 c7 40 60 ff ff ff 	movq   $0xffffffffffffffff,0x60(%rax)
  71f060:	ff 
  71f061:	48 c7 80 c0 00 00 00 	movq   $0x0,0xc0(%rax)
  71f068:	00 00 00 00 
  71f06c:	48 c7 80 c8 00 00 00 	movq   $0x8,0xc8(%rax)
  71f073:	08 00 00 00 
  71f077:	48 c7 80 d0 00 00 00 	movq   $0x0,0xd0(%rax)
  71f07e:	00 00 00 00 
  71f082:	48 c7 80 e8 00 00 00 	movq   $0x0,0xe8(%rax)
  71f089:	00 00 00 00 
  71f08d:	f3 0f 7f 80 f8 00 00 	movdqu %xmm0,0xf8(%rax)
  71f094:	00 
  71f095:	49 89 86 10 06 00 00 	mov    %rax,0x610(%r14)
  71f09c:	66 0f 6e 44 24 70    	movd   0x70(%rsp),%xmm0
  71f0a2:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  71f0a9:	00 
  71f0aa:	48 85 ff             	test   %rdi,%rdi
  71f0ad:	0f 85 1b 04 00 00    	jne    71f4ce <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x64e>
  71f0b3:	e9 a0 03 00 00       	jmp    71f458 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x5d8>
  71f0b8:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  71f0bf:	49 39 f7             	cmp    %rsi,%r15
  71f0c2:	0f 83 19 0a 00 00    	jae    71fae1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc61>
  71f0c8:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  71f0cf:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  71f0d6:	42 0f b6 3c 38       	movzbl (%rax,%r15,1),%edi
  71f0db:	48 39 fe             	cmp    %rdi,%rsi
  71f0de:	0f 86 1d 0a 00 00    	jbe    71fb01 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc81>
  71f0e4:	49 8b 86 08 02 00 00 	mov    0x208(%r14),%rax
  71f0eb:	48 6b cf 58          	imul   $0x58,%rdi,%rcx
  71f0ef:	eb 32                	jmp    71f123 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x2a3>
  71f0f1:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  71f0f8:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  71f0fd:	4c 89 fa             	mov    %r15,%rdx
  71f100:	ff 15 9a 30 3e 00    	call   *0x3e309a(%rip)        # b021a0 <_DYNAMIC+0x358>
  71f106:	eb 56                	jmp    71f15e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x2de>
  71f108:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  71f10f:	49 39 f7             	cmp    %rsi,%r15
  71f112:	0f 83 d9 09 00 00    	jae    71faf1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc71>
  71f118:	49 8b 86 10 02 00 00 	mov    0x210(%r14),%rax
  71f11f:	49 6b cf 58          	imul   $0x58,%r15,%rcx
  71f123:	48 8b 54 08 50       	mov    0x50(%rax,%rcx,1),%rdx
  71f128:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  71f12d:	0f 10 44 08 40       	movups 0x40(%rax,%rcx,1),%xmm0
  71f132:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  71f137:	0f 10 04 08          	movups (%rax,%rcx,1),%xmm0
  71f13b:	0f 10 4c 08 10       	movups 0x10(%rax,%rcx,1),%xmm1
  71f140:	0f 10 54 08 20       	movups 0x20(%rax,%rcx,1),%xmm2
  71f145:	0f 10 5c 08 30       	movups 0x30(%rax,%rcx,1),%xmm3
  71f14a:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
  71f14f:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  71f154:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  71f159:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  71f15e:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  71f165:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  71f16c:	00 
  71f16d:	4c 89 fa             	mov    %r15,%rdx
  71f170:	ff 15 0a 34 3e 00    	call   *0x3e340a(%rip)        # b02580 <_DYNAMIC+0x738>
  71f176:	80 bc 24 40 01 00 00 	cmpb   $0x0,0x140(%rsp)
  71f17d:	00 
  71f17e:	74 1a                	je     71f19a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x31a>
  71f180:	48 8d 94 24 44 01 00 	lea    0x144(%rsp),%rdx
  71f187:	00 
  71f188:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  71f18f:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  71f194:	ff 15 ee 33 3e 00    	call   *0x3e33ee(%rip)        # b02588 <_DYNAMIC+0x740>
  71f19a:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  71f1a1:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  71f1a6:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  71f1ad:	00 
  71f1ae:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
  71f1b3:	0f 29 84 24 80 01 00 	movaps %xmm0,0x180(%rsp)
  71f1ba:	00 
  71f1bb:	66 0f 6f 44 24 10    	movdqa 0x10(%rsp),%xmm0
  71f1c1:	66 0f 6f 4c 24 20    	movdqa 0x20(%rsp),%xmm1
  71f1c7:	0f 28 54 24 30       	movaps 0x30(%rsp),%xmm2
  71f1cc:	0f 28 5c 24 40       	movaps 0x40(%rsp),%xmm3
  71f1d1:	0f 29 9c 24 70 01 00 	movaps %xmm3,0x170(%rsp)
  71f1d8:	00 
  71f1d9:	0f 29 94 24 60 01 00 	movaps %xmm2,0x160(%rsp)
  71f1e0:	00 
  71f1e1:	66 0f 7f 8c 24 50 01 	movdqa %xmm1,0x150(%rsp)
  71f1e8:	00 00 
  71f1ea:	66 0f 7f 84 24 40 01 	movdqa %xmm0,0x140(%rsp)
  71f1f1:	00 00 
  71f1f3:	48 8d bc 24 a0 01 00 	lea    0x1a0(%rsp),%rdi
  71f1fa:	00 
  71f1fb:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  71f202:	00 
  71f203:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  71f208:	41 89 e8             	mov    %ebp,%r8d
  71f20b:	4d 89 e9             	mov    %r13,%r9
  71f20e:	e8 8d 27 01 00       	call   7319a0 <<gpui::property::Overrides>::set_value>
  71f213:	44 8b ac 24 a0 01 00 	mov    0x1a0(%rsp),%r13d
  71f21a:	00 
  71f21b:	41 83 fd 02          	cmp    $0x2,%r13d
  71f21f:	75 2b                	jne    71f24c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x3cc>
  71f221:	0f b7 84 24 a8 01 00 	movzwl 0x1a8(%rsp),%eax
  71f228:	00 
  71f229:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  71f22e:	8b 8c 24 a4 01 00 00 	mov    0x1a4(%rsp),%ecx
  71f235:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  71f239:	66 89 43 0c          	mov    %ax,0xc(%rbx)
  71f23d:	89 4b 08             	mov    %ecx,0x8(%rbx)
  71f240:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  71f247:	e9 36 08 00 00       	jmp    71fa82 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc02>
  71f24c:	45 31 c0             	xor    %r8d,%r8d
  71f24f:	41 80 fc ff          	cmp    $0xff,%r12b
  71f253:	41 0f 95 c0          	setne  %r8b
  71f257:	0f b7 84 24 a8 01 00 	movzwl 0x1a8(%rsp),%eax
  71f25e:	00 
  71f25f:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  71f264:	8b 8c 24 a4 01 00 00 	mov    0x1a4(%rsp),%ecx
  71f26b:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  71f26f:	0f 10 84 24 aa 01 00 	movups 0x1aa(%rsp),%xmm0
  71f276:	00 
  71f277:	0f 11 84 24 f2 00 00 	movups %xmm0,0xf2(%rsp)
  71f27e:	00 
  71f27f:	0f 10 84 24 ba 01 00 	movups 0x1ba(%rsp),%xmm0
  71f286:	00 
  71f287:	0f 11 84 24 02 01 00 	movups %xmm0,0x102(%rsp)
  71f28e:	00 
  71f28f:	0f 10 84 24 ca 01 00 	movups 0x1ca(%rsp),%xmm0
  71f296:	00 
  71f297:	0f 11 84 24 12 01 00 	movups %xmm0,0x112(%rsp)
  71f29e:	00 
  71f29f:	0f 10 84 24 da 01 00 	movups 0x1da(%rsp),%xmm0
  71f2a6:	00 
  71f2a7:	0f 11 84 24 22 01 00 	movups %xmm0,0x122(%rsp)
  71f2ae:	00 
  71f2af:	0f 10 84 24 e8 01 00 	movups 0x1e8(%rsp),%xmm0
  71f2b6:	00 
  71f2b7:	0f 11 84 24 30 01 00 	movups %xmm0,0x130(%rsp)
  71f2be:	00 
  71f2bf:	44 89 ac 24 e8 00 00 	mov    %r13d,0xe8(%rsp)
  71f2c6:	00 
  71f2c7:	66 89 84 24 f0 00 00 	mov    %ax,0xf0(%rsp)
  71f2ce:	00 
  71f2cf:	89 8c 24 ec 00 00 00 	mov    %ecx,0xec(%rsp)
  71f2d6:	0f 10 84 24 28 01 00 	movups 0x128(%rsp),%xmm0
  71f2dd:	00 
  71f2de:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  71f2e5:	00 
  71f2e6:	0f 10 84 24 18 01 00 	movups 0x118(%rsp),%xmm0
  71f2ed:	00 
  71f2ee:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  71f2f5:	00 
  71f2f6:	0f 10 84 24 08 01 00 	movups 0x108(%rsp),%xmm0
  71f2fd:	00 
  71f2fe:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  71f305:	00 
  71f306:	0f 10 84 24 f8 00 00 	movups 0xf8(%rsp),%xmm0
  71f30d:	00 
  71f30e:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  71f315:	00 
  71f316:	0f 10 84 24 e8 00 00 	movups 0xe8(%rsp),%xmm0
  71f31d:	00 
  71f31e:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  71f325:	00 
  71f326:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  71f32d:	00 
  71f32e:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  71f335:	00 
  71f336:	4d 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%r9
  71f33d:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
  71f344:	00 
  71f345:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  71f34c:	00 
  71f34d:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  71f354:	00 
  71f355:	f3 0f 6f 84 24 f8 00 	movdqu 0xf8(%rsp),%xmm0
  71f35c:	00 00 
  71f35e:	f3 0f 6f 8c 24 08 01 	movdqu 0x108(%rsp),%xmm1
  71f365:	00 00 
  71f367:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  71f36e:	00 
  71f36f:	0f 10 9c 24 28 01 00 	movups 0x128(%rsp),%xmm3
  71f376:	00 
  71f377:	0f 29 9c 24 80 01 00 	movaps %xmm3,0x180(%rsp)
  71f37e:	00 
  71f37f:	0f 29 94 24 70 01 00 	movaps %xmm2,0x170(%rsp)
  71f386:	00 
  71f387:	66 0f 7f 8c 24 60 01 	movdqa %xmm1,0x160(%rsp)
  71f38e:	00 00 
  71f390:	66 0f 7f 84 24 50 01 	movdqa %xmm0,0x150(%rsp)
  71f397:	00 00 
  71f399:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  71f3a0:	00 
  71f3a1:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  71f3a8:	4c 89 fe             	mov    %r15,%rsi
  71f3ab:	89 ea                	mov    %ebp,%edx
  71f3ad:	ff 15 dd 31 3e 00    	call   *0x3e31dd(%rip)        # b02590 <_DYNAMIC+0x748>
  71f3b3:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  71f3ba:	8b 6c 24 10          	mov    0x10(%rsp),%ebp
  71f3be:	44 0f b6 a4 24 90 00 	movzbl 0x90(%rsp),%r12d
  71f3c5:	00 00 
  71f3c7:	83 fd 01             	cmp    $0x1,%ebp
  71f3ca:	75 25                	jne    71f3f1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x571>
  71f3cc:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  71f3d3:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  71f3d7:	39 c1                	cmp    %eax,%ecx
  71f3d9:	0f 94 c2             	sete   %dl
  71f3dc:	41 84 d4             	test   %dl,%r12b
  71f3df:	75 26                	jne    71f407 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x587>
  71f3e1:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  71f3e8:	01 00 00 00 
  71f3ec:	e9 78 03 00 00       	jmp    71f769 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8e9>
  71f3f1:	41 f6 c4 01          	test   $0x1,%r12b
  71f3f5:	74 10                	je     71f407 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x587>
  71f3f7:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  71f3fe:	01 00 00 00 
  71f402:	e9 76 04 00 00       	jmp    71f87d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f407:	8b 54 24 18          	mov    0x18(%rsp),%edx
  71f40b:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  71f412:	00 
  71f413:	83 fa 01             	cmp    $0x1,%edx
  71f416:	0f 85 27 02 00 00    	jne    71f643 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x7c3>
  71f41c:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  71f423:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  71f427:	0f 94 c0             	sete   %al
  71f42a:	be 01 00 00 00       	mov    $0x1,%esi
  71f42f:	84 c1                	test   %al,%cl
  71f431:	0f 85 1a 02 00 00    	jne    71f651 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x7d1>
  71f437:	e9 15 03 00 00       	jmp    71f751 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f43c:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  71f443:	00 00 00 00 
  71f447:	66 0f ef c0          	pxor   %xmm0,%xmm0
  71f44b:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  71f452:	00 
  71f453:	48 85 ff             	test   %rdi,%rdi
  71f456:	75 76                	jne    71f4ce <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x64e>
  71f458:	66 0f 7e 44 24 70    	movd   %xmm0,0x70(%rsp)
  71f45e:	ff 15 44 2c 3e 00    	call   *0x3e2c44(%rip)        # b020a8 <_DYNAMIC+0x260>
  71f464:	bf 60 00 00 00       	mov    $0x60,%edi
  71f469:	be 08 00 00 00       	mov    $0x8,%esi
  71f46e:	ff 15 14 2c 3e 00    	call   *0x3e2c14(%rip)        # b02088 <_DYNAMIC+0x240>
  71f474:	48 85 c0             	test   %rax,%rax
  71f477:	0f 84 27 06 00 00    	je     71faa4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc24>
  71f47d:	48 89 c7             	mov    %rax,%rdi
  71f480:	66 0f ef c0          	pxor   %xmm0,%xmm0
  71f484:	f3 0f 7f 40 10       	movdqu %xmm0,0x10(%rax)
  71f489:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  71f490:	48 c7 40 08 08 00 00 	movq   $0x8,0x8(%rax)
  71f497:	00 
  71f498:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  71f49f:	00 
  71f4a0:	48 c7 40 28 00 00 00 	movq   $0x0,0x28(%rax)
  71f4a7:	00 
  71f4a8:	48 c7 40 30 ff ff ff 	movq   $0xffffffffffffffff,0x30(%rax)
  71f4af:	ff 
  71f4b0:	48 c7 40 48 00 00 00 	movq   $0x0,0x48(%rax)
  71f4b7:	00 
  71f4b8:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  71f4bf:	00 
  71f4c0:	49 89 84 24 00 01 00 	mov    %rax,0x100(%r12)
  71f4c7:	00 
  71f4c8:	66 0f 6e 44 24 70    	movd   0x70(%rsp),%xmm0
  71f4ce:	48 83 c7 48          	add    $0x48,%rdi
  71f4d2:	4c 89 fe             	mov    %r15,%rsi
  71f4d5:	89 ea                	mov    %ebp,%edx
  71f4d7:	4c 89 e9             	mov    %r13,%rcx
  71f4da:	e8 41 1c 01 00       	call   731120 <<gpui::property::Overrides<gpui::property::GeometryStyle>>::set_value>
  71f4df:	48 89 c1             	mov    %rax,%rcx
  71f4e2:	48 c1 e9 20          	shr    $0x20,%rcx
  71f4e6:	a8 01                	test   $0x1,%al
  71f4e8:	74 16                	je     71f500 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x680>
  71f4ea:	c1 e8 10             	shr    $0x10,%eax
  71f4ed:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  71f4f4:	66 89 43 08          	mov    %ax,0x8(%rbx)
  71f4f8:	89 4b 0a             	mov    %ecx,0xa(%rbx)
  71f4fb:	e9 82 05 00 00       	jmp    71fa82 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc02>
  71f500:	66 0f 6e c1          	movd   %ecx,%xmm0
  71f504:	89 8c 24 40 01 00 00 	mov    %ecx,0x140(%rsp)
  71f50b:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  71f512:	00 
  71f513:	4c 89 fe             	mov    %r15,%rsi
  71f516:	ff 15 7c 30 3e 00    	call   *0x3e307c(%rip)        # b02598 <_DYNAMIC+0x750>
  71f51c:	49 8b 84 24 00 01 00 	mov    0x100(%r12),%rax
  71f523:	00 
  71f524:	48 83 78 10 00       	cmpq   $0x0,0x10(%rax)
  71f529:	75 3a                	jne    71f565 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x6e5>
  71f52b:	48 83 78 58 00       	cmpq   $0x0,0x58(%rax)
  71f530:	75 33                	jne    71f565 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x6e5>
  71f532:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  71f537:	75 2c                	jne    71f565 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x6e5>
  71f539:	48 83 78 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rax)
  71f53e:	75 25                	jne    71f565 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x6e5>
  71f540:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  71f547:	48 8b b8 00 01 00 00 	mov    0x100(%rax),%rdi
  71f54e:	e8 7d 20 fe ff       	call   7015d0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::geometry::Geometry>>>>
  71f553:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  71f55a:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  71f561:	00 00 00 00 
  71f565:	48 8b 05 f4 2c 3e 00 	mov    0x3e2cf4(%rip),%rax        # b02260 <_DYNAMIC+0x418>
  71f56c:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  71f573:	00 
  71f574:	48 8d b4 24 40 01 00 	lea    0x140(%rsp),%rsi
  71f57b:	00 
  71f57c:	ff 50 18             	call   *0x18(%rax)
  71f57f:	34 01                	xor    $0x1,%al
  71f581:	0f b6 c0             	movzbl %al,%eax
  71f584:	49 89 86 08 07 00 00 	mov    %rax,0x708(%r14)
  71f58b:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  71f592:	4d 8b be 10 06 00 00 	mov    0x610(%r14),%r15
  71f599:	4d 85 ff             	test   %r15,%r15
  71f59c:	0f 84 d9 04 00 00    	je     71fa7b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f5a2:	49 83 bf d8 00 00 00 	cmpq   $0x0,0xd8(%r15)
  71f5a9:	00 
  71f5aa:	0f 85 cb 04 00 00    	jne    71fa7b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f5b0:	49 83 bf e0 00 00 00 	cmpq   $0x0,0xe0(%r15)
  71f5b7:	00 
  71f5b8:	0f 85 bd 04 00 00    	jne    71fa7b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f5be:	49 83 bf 00 01 00 00 	cmpq   $0x0,0x100(%r15)
  71f5c5:	00 
  71f5c6:	0f 85 af 04 00 00    	jne    71fa7b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f5cc:	49 83 bf d0 00 00 00 	cmpq   $0x0,0xd0(%r15)
  71f5d3:	00 
  71f5d4:	0f 85 a1 04 00 00    	jne    71fa7b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f5da:	49 83 bf f8 00 00 00 	cmpq   $0x0,0xf8(%r15)
  71f5e1:	00 
  71f5e2:	0f 85 93 04 00 00    	jne    71fa7b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f5e8:	49 8b 47 60          	mov    0x60(%r15),%rax
  71f5ec:	83 f8 ff             	cmp    $0xffffffff,%eax
  71f5ef:	0f 85 86 04 00 00    	jne    71fa7b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f5f5:	49 83 7f 28 00       	cmpq   $0x0,0x28(%r15)
  71f5fa:	0f 85 7b 04 00 00    	jne    71fa7b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f600:	49 8b 07             	mov    (%r15),%rax
  71f603:	49 0b 47 40          	or     0x40(%r15),%rax
  71f607:	0f 85 6e 04 00 00    	jne    71fa7b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f60d:	49 83 7f 58 00       	cmpq   $0x0,0x58(%r15)
  71f612:	0f 85 63 04 00 00    	jne    71fa7b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f618:	4c 89 ff             	mov    %r15,%rdi
  71f61b:	e8 30 65 fe ff       	call   705b50 <core::ptr::drop_glue::<gpui::runtime::metadata::Metadata>>
  71f620:	be 08 01 00 00       	mov    $0x108,%esi
  71f625:	ba 08 00 00 00       	mov    $0x8,%edx
  71f62a:	4c 89 ff             	mov    %r15,%rdi
  71f62d:	ff 15 5d 2a 3e 00    	call   *0x3e2a5d(%rip)        # b02090 <_DYNAMIC+0x248>
  71f633:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  71f63a:	00 00 00 00 
  71f63e:	e9 38 04 00 00       	jmp    71fa7b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f643:	be 01 00 00 00       	mov    $0x1,%esi
  71f648:	f6 c1 01             	test   $0x1,%cl
  71f64b:	0f 85 00 01 00 00    	jne    71f751 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f651:	8b 44 24 20          	mov    0x20(%rsp),%eax
  71f655:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  71f65c:	0f 85 ef 00 00 00    	jne    71f751 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f662:	8b 44 24 24          	mov    0x24(%rsp),%eax
  71f666:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  71f66d:	0f 85 de 00 00 00    	jne    71f751 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f673:	8b 44 24 28          	mov    0x28(%rsp),%eax
  71f677:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  71f67e:	0f 85 cd 00 00 00    	jne    71f751 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f684:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  71f689:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  71f690:	0f 85 bb 00 00 00    	jne    71f751 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f696:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  71f69b:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  71f6a2:	0f 85 a9 00 00 00    	jne    71f751 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f6a8:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  71f6ad:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  71f6b4:	0f 85 97 00 00 00    	jne    71f751 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f6ba:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  71f6bf:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  71f6c6:	0f 85 85 00 00 00    	jne    71f751 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f6cc:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  71f6d0:	88 8c 24 80 00 00 00 	mov    %cl,0x80(%rsp)
  71f6d7:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  71f6dc:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  71f6e3:	00 
  71f6e4:	e8 17 08 00 00       	call   71ff00 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  71f6e9:	84 c0                	test   %al,%al
  71f6eb:	74 53                	je     71f740 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8c0>
  71f6ed:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  71f6f3:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  71f6fa:	00 00 
  71f6fc:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  71f700:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  71f704:	3d ff ff 00 00       	cmp    $0xffff,%eax
  71f709:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  71f710:	00 
  71f711:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  71f715:	be 01 00 00 00       	mov    $0x1,%esi
  71f71a:	75 35                	jne    71f751 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f71c:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  71f722:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  71f729:	00 00 
  71f72b:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  71f72f:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  71f733:	31 f6                	xor    %esi,%esi
  71f735:	3d ff ff 00 00       	cmp    $0xffff,%eax
  71f73a:	40 0f 95 c6          	setne  %sil
  71f73e:	eb 11                	jmp    71f751 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f740:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  71f747:	00 
  71f748:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  71f74c:	be 01 00 00 00       	mov    $0x1,%esi
  71f751:	49 89 b6 08 07 00 00 	mov    %rsi,0x708(%r14)
  71f758:	40 f6 c5 01          	test   $0x1,%bpl
  71f75c:	74 2b                	je     71f789 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x909>
  71f75e:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  71f765:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  71f769:	39 c1                	cmp    %eax,%ecx
  71f76b:	0f 94 c0             	sete   %al
  71f76e:	41 20 c4             	and    %al,%r12b
  71f771:	41 80 fc 01          	cmp    $0x1,%r12b
  71f775:	0f 85 02 01 00 00    	jne    71f87d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f77b:	8b 54 24 18          	mov    0x18(%rsp),%edx
  71f77f:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  71f786:	00 
  71f787:	eb 0a                	jmp    71f793 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x913>
  71f789:	41 f6 c4 01          	test   $0x1,%r12b
  71f78d:	0f 85 ea 00 00 00    	jne    71f87d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f793:	83 fa 01             	cmp    $0x1,%edx
  71f796:	75 17                	jne    71f7af <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x92f>
  71f798:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  71f79f:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  71f7a3:	0f 94 c0             	sete   %al
  71f7a6:	84 c1                	test   %al,%cl
  71f7a8:	75 0e                	jne    71f7b8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x938>
  71f7aa:	e9 ce 00 00 00       	jmp    71f87d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f7af:	f6 c1 01             	test   $0x1,%cl
  71f7b2:	0f 85 c5 00 00 00    	jne    71f87d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f7b8:	8b 44 24 20          	mov    0x20(%rsp),%eax
  71f7bc:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  71f7c3:	0f 85 b4 00 00 00    	jne    71f87d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f7c9:	8b 44 24 24          	mov    0x24(%rsp),%eax
  71f7cd:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  71f7d4:	0f 85 a3 00 00 00    	jne    71f87d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f7da:	8b 44 24 28          	mov    0x28(%rsp),%eax
  71f7de:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  71f7e5:	0f 85 92 00 00 00    	jne    71f87d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f7eb:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  71f7f0:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  71f7f7:	0f 85 80 00 00 00    	jne    71f87d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f7fd:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  71f802:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  71f809:	75 72                	jne    71f87d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f80b:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  71f810:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  71f817:	75 64                	jne    71f87d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f819:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  71f81e:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  71f825:	75 56                	jne    71f87d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f827:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  71f82c:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  71f833:	00 
  71f834:	e8 c7 06 00 00       	call   71ff00 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  71f839:	84 c0                	test   %al,%al
  71f83b:	74 40                	je     71f87d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f83d:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  71f843:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  71f84a:	00 00 
  71f84c:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  71f850:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  71f854:	3d ff ff 00 00       	cmp    $0xffff,%eax
  71f859:	75 22                	jne    71f87d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f85b:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  71f861:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  71f868:	00 00 
  71f86a:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  71f86e:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  71f872:	3d ff ff 00 00       	cmp    $0xffff,%eax
  71f877:	0f 84 fe 01 00 00    	je     71fa7b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f87d:	45 89 e8             	mov    %r13d,%r8d
  71f880:	44 8b 64 24 18       	mov    0x18(%rsp),%r12d
  71f885:	0f b6 7c 24 64       	movzbl 0x64(%rsp),%edi
  71f88a:	44 0f b6 6c 24 65    	movzbl 0x65(%rsp),%r13d
  71f890:	0f b6 4c 24 66       	movzbl 0x66(%rsp),%ecx
  71f895:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  71f89a:	88 84 24 80 00 00 00 	mov    %al,0x80(%rsp)
  71f8a1:	8b b4 24 f0 00 00 00 	mov    0xf0(%rsp),%esi
  71f8a8:	0f 10 5c 24 1c       	movups 0x1c(%rsp),%xmm3
  71f8ad:	f3 0f 10 44 24 20    	movss  0x20(%rsp),%xmm0
  71f8b3:	0f 10 a4 24 f4 00 00 	movups 0xf4(%rsp),%xmm4
  71f8ba:	00 
  71f8bb:	f3 0f 10 8c 24 f8 00 	movss  0xf8(%rsp),%xmm1
  71f8c2:	00 00 
  71f8c4:	44 0f b6 9c 24 3c 01 	movzbl 0x13c(%rsp),%r11d
  71f8cb:	00 00 
  71f8cd:	44 0f b6 8c 24 3d 01 	movzbl 0x13d(%rsp),%r9d
  71f8d4:	00 00 
  71f8d6:	0f b6 84 24 3e 01 00 	movzbl 0x13e(%rsp),%eax
  71f8dd:	00 
  71f8de:	44 0f b6 94 24 3f 01 	movzbl 0x13f(%rsp),%r10d
  71f8e5:	00 00 
  71f8e7:	40 f6 c5 01          	test   $0x1,%bpl
  71f8eb:	74 22                	je     71f90f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xa8f>
  71f8ed:	f3 0f 10 54 24 14    	movss  0x14(%rsp),%xmm2
  71f8f3:	0f 2e 94 24 ec 00 00 	ucomiss 0xec(%rsp),%xmm2
  71f8fa:	00 
  71f8fb:	40 0f 9b c5          	setnp  %bpl
  71f8ff:	0f 94 c2             	sete   %dl
  71f902:	40 20 ea             	and    %bpl,%dl
  71f905:	41 84 d0             	test   %dl,%r8b
  71f908:	75 0f                	jne    71f919 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xa99>
  71f90a:	e9 a4 00 00 00       	jmp    71f9b3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xb33>
  71f90f:	41 f6 c0 01          	test   $0x1,%r8b
  71f913:	0f 85 9a 00 00 00    	jne    71f9b3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xb33>
  71f919:	41 83 fc 01          	cmp    $0x1,%r12d
  71f91d:	75 3c                	jne    71f95b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xadb>
  71f91f:	44 30 df             	xor    %r11b,%dil
  71f922:	30 c1                	xor    %al,%cl
  71f924:	0f b6 84 24 80 00 00 	movzbl 0x80(%rsp),%eax
  71f92b:	00 
  71f92c:	44 30 d0             	xor    %r10b,%al
  71f92f:	45 38 cd             	cmp    %r9b,%r13b
  71f932:	0f 94 c2             	sete   %dl
  71f935:	0f 28 c3             	movaps %xmm3,%xmm0
  71f938:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  71f93c:	44 0f 50 c0          	movmskps %xmm0,%r8d
  71f940:	41 80 f0 0f          	xor    $0xf,%r8b
  71f944:	40 08 f9             	or     %dil,%cl
  71f947:	44 08 c1             	or     %r8b,%cl
  71f94a:	08 c1                	or     %al,%cl
  71f94c:	0f 94 c0             	sete   %al
  71f94f:	40 20 f0             	and    %sil,%al
  71f952:	84 d0                	test   %dl,%al
  71f954:	74 5d                	je     71f9b3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xb33>
  71f956:	e9 83 00 00 00       	jmp    71f9de <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xb5e>
  71f95b:	0f 2e c1             	ucomiss %xmm1,%xmm0
  71f95e:	0f 9b c2             	setnp  %dl
  71f961:	40 0f 94 c5          	sete   %bpl
  71f965:	40 20 d5             	and    %dl,%bpl
  71f968:	40 f6 d6             	not    %sil
  71f96b:	40 20 ee             	and    %bpl,%sil
  71f96e:	0f 28 c3             	movaps %xmm3,%xmm0
  71f971:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  71f975:	0f 50 d0             	movmskps %xmm0,%edx
  71f978:	89 d5                	mov    %edx,%ebp
  71f97a:	40 c0 ed 03          	shr    $0x3,%bpl
  71f97e:	c0 ea 02             	shr    $0x2,%dl
  71f981:	40 20 f2             	and    %sil,%dl
  71f984:	44 38 df             	cmp    %r11b,%dil
  71f987:	40 0f 94 c6          	sete   %sil
  71f98b:	40 20 ee             	and    %bpl,%sil
  71f98e:	40 20 d6             	and    %dl,%sil
  71f991:	38 c1                	cmp    %al,%cl
  71f993:	0f 94 c1             	sete   %cl
  71f996:	44 38 94 24 80 00 00 	cmp    %r10b,0x80(%rsp)
  71f99d:	00 
  71f99e:	0f 94 c0             	sete   %al
  71f9a1:	20 c8                	and    %cl,%al
  71f9a3:	45 38 cd             	cmp    %r9b,%r13b
  71f9a6:	0f 94 c1             	sete   %cl
  71f9a9:	20 c1                	and    %al,%cl
  71f9ab:	40 20 f1             	and    %sil,%cl
  71f9ae:	80 f9 01             	cmp    $0x1,%cl
  71f9b1:	74 2b                	je     71f9de <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xb5e>
  71f9b3:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  71f9ba:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  71f9bf:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
  71f9c4:	0f 29 a4 24 80 00 00 	movaps %xmm4,0x80(%rsp)
  71f9cb:	00 
  71f9cc:	e8 8f 20 00 00       	call   721a60 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  71f9d1:	0f 28 a4 24 80 00 00 	movaps 0x80(%rsp),%xmm4
  71f9d8:	00 
  71f9d9:	0f 28 5c 24 70       	movaps 0x70(%rsp),%xmm3
  71f9de:	0f c2 dc 04          	cmpneqps %xmm4,%xmm3
  71f9e2:	66 0f c5 c3 06       	pextrw $0x6,%xmm3,%eax
  71f9e7:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  71f9ee:	a8 01                	test   $0x1,%al
  71f9f0:	74 69                	je     71fa5b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbdb>
  71f9f2:	49 39 cf             	cmp    %rcx,%r15
  71f9f5:	0f 83 13 01 00 00    	jae    71fb0e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc8e>
  71f9fb:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  71fa02:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  71fa06:	8b 7c d0 20          	mov    0x20(%rax,%rdx,8),%edi
  71fa0a:	89 f8                	mov    %edi,%eax
  71fa0c:	83 e0 07             	and    $0x7,%eax
  71fa0f:	83 f8 06             	cmp    $0x6,%eax
  71fa12:	74 47                	je     71fa5b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbdb>
  71fa14:	c1 ef 03             	shr    $0x3,%edi
  71fa17:	74 42                	je     71fa5b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbdb>
  71fa19:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  71fa20:	ff cf                	dec    %edi
  71fa22:	48 39 fe             	cmp    %rdi,%rsi
  71fa25:	0f 86 f6 00 00 00    	jbe    71fb21 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xca1>
  71fa2b:	4d 8b a6 b0 02 00 00 	mov    0x2b0(%r14),%r12
  71fa32:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  71fa36:	48 c1 e0 04          	shl    $0x4,%rax
  71fa3a:	49 83 3c 04 fe       	cmpq   $0xfffffffffffffffe,(%r12,%rax,1)
  71fa3f:	74 73                	je     71fab4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc34>
  71fa41:	49 01 c4             	add    %rax,%r12
  71fa44:	4c 89 e7             	mov    %r12,%rdi
  71fa47:	e8 b4 1e fe ff       	call   701900 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  71fa4c:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  71fa53:	ff 
  71fa54:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  71fa5b:	48 8d 94 24 e8 00 00 	lea    0xe8(%rsp),%rdx
  71fa62:	00 
  71fa63:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  71fa6a:	4c 89 fe             	mov    %r15,%rsi
  71fa6d:	ff 15 2d 28 3e 00    	call   *0x3e282d(%rip)        # b022a0 <_DYNAMIC+0x458>
  71fa73:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  71fa7a:	01 
  71fa7b:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  71fa82:	48 81 c4 f8 01 00 00 	add    $0x1f8,%rsp
  71fa89:	5b                   	pop    %rbx
  71fa8a:	41 5c                	pop    %r12
  71fa8c:	41 5d                	pop    %r13
  71fa8e:	41 5e                	pop    %r14
  71fa90:	41 5f                	pop    %r15
  71fa92:	5d                   	pop    %rbp
  71fa93:	c3                   	ret
  71fa94:	bf 08 00 00 00       	mov    $0x8,%edi
  71fa99:	be 08 01 00 00       	mov    $0x108,%esi
  71fa9e:	ff 15 1c 26 3e 00    	call   *0x3e261c(%rip)        # b020c0 <_DYNAMIC+0x278>
  71faa4:	bf 08 00 00 00       	mov    $0x8,%edi
  71faa9:	be 60 00 00 00       	mov    $0x60,%esi
  71faae:	ff 15 0c 26 3e 00    	call   *0x3e260c(%rip)        # b020c0 <_DYNAMIC+0x278>
  71fab4:	48 8d 3d 8d 40 3b 00 	lea    0x3b408d(%rip),%rdi        # ad3b48 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x2a0>
  71fabb:	ff 15 0f 26 3e 00    	call   *0x3e260f(%rip)        # b020d0 <_DYNAMIC+0x288>
  71fac1:	48 8d 15 f0 45 3b 00 	lea    0x3b45f0(%rip),%rdx        # ad40b8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x810>
  71fac8:	4c 89 ff             	mov    %r15,%rdi
  71facb:	ff 15 ef 26 3e 00    	call   *0x3e26ef(%rip)        # b021c0 <_DYNAMIC+0x378>
  71fad1:	48 8d 15 90 4c 3b 00 	lea    0x3b4c90(%rip),%rdx        # ad4768 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xec0>
  71fad8:	4c 89 ff             	mov    %r15,%rdi
  71fadb:	ff 15 df 26 3e 00    	call   *0x3e26df(%rip)        # b021c0 <_DYNAMIC+0x378>
  71fae1:	48 8d 15 e8 43 3b 00 	lea    0x3b43e8(%rip),%rdx        # ad3ed0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x628>
  71fae8:	4c 89 ff             	mov    %r15,%rdi
  71faeb:	ff 15 cf 26 3e 00    	call   *0x3e26cf(%rip)        # b021c0 <_DYNAMIC+0x378>
  71faf1:	48 8d 15 c0 43 3b 00 	lea    0x3b43c0(%rip),%rdx        # ad3eb8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x610>
  71faf8:	4c 89 ff             	mov    %r15,%rdi
  71fafb:	ff 15 bf 26 3e 00    	call   *0x3e26bf(%rip)        # b021c0 <_DYNAMIC+0x378>
  71fb01:	48 8d 15 e0 43 3b 00 	lea    0x3b43e0(%rip),%rdx        # ad3ee8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x640>
  71fb08:	ff 15 b2 26 3e 00    	call   *0x3e26b2(%rip)        # b021c0 <_DYNAMIC+0x378>
  71fb0e:	48 8d 15 6b 4c 3b 00 	lea    0x3b4c6b(%rip),%rdx        # ad4780 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xed8>
  71fb15:	4c 89 ff             	mov    %r15,%rdi
  71fb18:	48 89 ce             	mov    %rcx,%rsi
  71fb1b:	ff 15 9f 26 3e 00    	call   *0x3e269f(%rip)        # b021c0 <_DYNAMIC+0x378>
  71fb21:	48 8d 15 08 40 3b 00 	lea    0x3b4008(%rip),%rdx        # ad3b30 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x288>
  71fb28:	ff 15 92 26 3e 00    	call   *0x3e2692(%rip)        # b021c0 <_DYNAMIC+0x378>
  71fb2e:	48 89 c3             	mov    %rax,%rbx
  71fb31:	be 08 01 00 00       	mov    $0x108,%esi
  71fb36:	ba 08 00 00 00       	mov    $0x8,%edx
  71fb3b:	4c 89 ff             	mov    %r15,%rdi
  71fb3e:	ff 15 4c 25 3e 00    	call   *0x3e254c(%rip)        # b02090 <_DYNAMIC+0x248>
  71fb44:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  71fb4b:	00 00 00 00 
  71fb4f:	48 89 df             	mov    %rbx,%rdi
  71fb52:	e8 19 29 3b 00       	call   ad2470 <_Unwind_Resume@plt>
  71fb57:	48 89 c3             	mov    %rax,%rbx
  71fb5a:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  71fb61:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  71fb68:	00 00 00 00 
  71fb6c:	48 89 df             	mov    %rbx,%rdi
  71fb6f:	e8 fc 28 3b 00       	call   ad2470 <_Unwind_Resume@plt>
  71fb74:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  71fb7b:	ff 
  71fb7c:	48 89 c7             	mov    %rax,%rdi
  71fb7f:	e8 ec 28 3b 00       	call   ad2470 <_Unwind_Resume@plt>
