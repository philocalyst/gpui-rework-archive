
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000071ed70 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at>:
  71ed70:	55                   	push   %rbp
  71ed71:	41 57                	push   %r15
  71ed73:	41 56                	push   %r14
  71ed75:	41 55                	push   %r13
  71ed77:	41 54                	push   %r12
  71ed79:	53                   	push   %rbx
  71ed7a:	48 81 ec f8 01 00 00 	sub    $0x1f8,%rsp
  71ed81:	4d 89 c5             	mov    %r8,%r13
  71ed84:	89 cd                	mov    %ecx,%ebp
  71ed86:	49 89 d7             	mov    %rdx,%r15
  71ed89:	49 89 f6             	mov    %rsi,%r14
  71ed8c:	48 89 fb             	mov    %rdi,%rbx
  71ed8f:	45 0f b6 20          	movzbl (%r8),%r12d
  71ed93:	41 80 fc ff          	cmp    $0xff,%r12b
  71ed97:	74 1c                	je     71edb5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x45>
  71ed99:	89 ef                	mov    %ebp,%edi
  71ed9b:	4c 89 ee             	mov    %r13,%rsi
  71ed9e:	ff 15 c4 34 3e 00    	call   *0x3e34c4(%rip)        # b02268 <_DYNAMIC+0x520>
  71eda4:	66 85 c0             	test   %ax,%ax
  71eda7:	74 0c                	je     71edb5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x45>
  71eda9:	48 89 c1             	mov    %rax,%rcx
  71edac:	48 c1 e9 10          	shr    $0x10,%rcx
  71edb0:	e9 28 06 00 00       	jmp    71f3dd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x66d>
  71edb5:	0f b7 c5             	movzwl %bp,%eax
  71edb8:	48 8d 0d c1 5b 3b 00 	lea    0x3b5bc1(%rip),%rcx        # ad4980 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1198>
  71edbf:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  71edc4:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  71edc8:	74 78                	je     71ee42 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xd2>
  71edca:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  71edd1:	49 39 f7             	cmp    %rsi,%r15
  71edd4:	0f 83 d7 0b 00 00    	jae    71f9b1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc41>
  71edda:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  71ede1:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  71ede5:	4c 8b 3c c8          	mov    (%rax,%rcx,8),%r15
  71ede9:	4d 8b a6 10 06 00 00 	mov    0x610(%r14),%r12
  71edf0:	4d 85 e4             	test   %r12,%r12
  71edf3:	0f 84 d4 00 00 00    	je     71eecd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x15d>
  71edf9:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  71ee00:	00 
  71ee01:	48 85 ff             	test   %rdi,%rdi
  71ee04:	0f 84 22 05 00 00    	je     71f32c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x5bc>
  71ee0a:	4c 89 fe             	mov    %r15,%rsi
  71ee0d:	ff 15 0d 35 3e 00    	call   *0x3e350d(%rip)        # b02320 <_DYNAMIC+0x5d8>
  71ee13:	4d 8b a6 10 06 00 00 	mov    0x610(%r14),%r12
  71ee1a:	66 0f 7e 84 24 e8 00 	movd   %xmm0,0xe8(%rsp)
  71ee21:	00 00 
  71ee23:	4d 85 e4             	test   %r12,%r12
  71ee26:	0f 84 b0 00 00 00    	je     71eedc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x16c>
  71ee2c:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  71ee33:	00 
  71ee34:	48 85 ff             	test   %rdi,%rdi
  71ee37:	0f 85 81 05 00 00    	jne    71f3be <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x64e>
  71ee3d:	e9 06 05 00 00       	jmp    71f348 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x5d8>
  71ee42:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  71ee49:	49 39 f7             	cmp    %rsi,%r15
  71ee4c:	0f 83 6f 0b 00 00    	jae    71f9c1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc51>
  71ee52:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  71ee59:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  71ee5d:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  71ee61:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  71ee66:	49 8b 86 00 02 00 00 	mov    0x200(%r14),%rax
  71ee6d:	48 8d 0d e8 79 94 ff 	lea    -0x6b8618(%rip),%rcx        # 6685c <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x9c>
  71ee74:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  71ee78:	48 01 c8             	add    %rcx,%rax
  71ee7b:	ff e0                	jmp    *%rax
  71ee7d:	0f 10 05 80 7b 94 ff 	movups -0x6b8480(%rip),%xmm0        # 66a04 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x244>
  71ee84:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  71ee89:	0f 10 05 64 7b 94 ff 	movups -0x6b849c(%rip),%xmm0        # 669f4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x234>
  71ee90:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  71ee95:	0f 10 05 48 7b 94 ff 	movups -0x6b84b8(%rip),%xmm0        # 669e4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x224>
  71ee9c:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  71eea1:	0f 10 05 2c 7b 94 ff 	movups -0x6b84d4(%rip),%xmm0        # 669d4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x214>
  71eea8:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  71eead:	0f 10 05 10 7b 94 ff 	movups -0x6b84f0(%rip),%xmm0        # 669c4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x204>
  71eeb4:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  71eeb9:	48 b8 00 00 00 00 01 	movabs $0x3000100000000,%rax
  71eec0:	00 03 00 
  71eec3:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  71eec8:	e9 81 01 00 00       	jmp    71f04e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x2de>
  71eecd:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  71eed4:	00 00 00 00 
  71eed8:	66 0f ef c0          	pxor   %xmm0,%xmm0
  71eedc:	66 0f 7e 44 24 70    	movd   %xmm0,0x70(%rsp)
  71eee2:	ff 15 c0 30 3e 00    	call   *0x3e30c0(%rip)        # b01fa8 <_DYNAMIC+0x260>
  71eee8:	bf 08 01 00 00       	mov    $0x108,%edi
  71eeed:	be 08 00 00 00       	mov    $0x8,%esi
  71eef2:	ff 15 90 30 3e 00    	call   *0x3e3090(%rip)        # b01f88 <_DYNAMIC+0x240>
  71eef8:	48 85 c0             	test   %rax,%rax
  71eefb:	0f 84 83 0a 00 00    	je     71f984 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc14>
  71ef01:	49 89 c4             	mov    %rax,%r12
  71ef04:	66 0f ef c0          	pxor   %xmm0,%xmm0
  71ef08:	f3 0f 7f 80 d8 00 00 	movdqu %xmm0,0xd8(%rax)
  71ef0f:	00 
  71ef10:	f3 0f 7f 40 28       	movdqu %xmm0,0x28(%rax)
  71ef15:	f3 0f 7f 40 40       	movdqu %xmm0,0x40(%rax)
  71ef1a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  71ef21:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  71ef28:	00 
  71ef29:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  71ef30:	00 
  71ef31:	48 c7 40 38 08 00 00 	movq   $0x8,0x38(%rax)
  71ef38:	00 
  71ef39:	48 c7 40 50 08 00 00 	movq   $0x8,0x50(%rax)
  71ef40:	00 
  71ef41:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  71ef48:	00 
  71ef49:	48 c7 40 60 ff ff ff 	movq   $0xffffffffffffffff,0x60(%rax)
  71ef50:	ff 
  71ef51:	48 c7 80 c0 00 00 00 	movq   $0x0,0xc0(%rax)
  71ef58:	00 00 00 00 
  71ef5c:	48 c7 80 c8 00 00 00 	movq   $0x8,0xc8(%rax)
  71ef63:	08 00 00 00 
  71ef67:	48 c7 80 d0 00 00 00 	movq   $0x0,0xd0(%rax)
  71ef6e:	00 00 00 00 
  71ef72:	48 c7 80 e8 00 00 00 	movq   $0x0,0xe8(%rax)
  71ef79:	00 00 00 00 
  71ef7d:	f3 0f 7f 80 f8 00 00 	movdqu %xmm0,0xf8(%rax)
  71ef84:	00 
  71ef85:	49 89 86 10 06 00 00 	mov    %rax,0x610(%r14)
  71ef8c:	66 0f 6e 44 24 70    	movd   0x70(%rsp),%xmm0
  71ef92:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  71ef99:	00 
  71ef9a:	48 85 ff             	test   %rdi,%rdi
  71ef9d:	0f 85 1b 04 00 00    	jne    71f3be <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x64e>
  71efa3:	e9 a0 03 00 00       	jmp    71f348 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x5d8>
  71efa8:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  71efaf:	49 39 f7             	cmp    %rsi,%r15
  71efb2:	0f 83 19 0a 00 00    	jae    71f9d1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc61>
  71efb8:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  71efbf:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  71efc6:	42 0f b6 3c 38       	movzbl (%rax,%r15,1),%edi
  71efcb:	48 39 fe             	cmp    %rdi,%rsi
  71efce:	0f 86 1d 0a 00 00    	jbe    71f9f1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc81>
  71efd4:	49 8b 86 08 02 00 00 	mov    0x208(%r14),%rax
  71efdb:	48 6b cf 58          	imul   $0x58,%rdi,%rcx
  71efdf:	eb 32                	jmp    71f013 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x2a3>
  71efe1:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  71efe8:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  71efed:	4c 89 fa             	mov    %r15,%rdx
  71eff0:	ff 15 aa 30 3e 00    	call   *0x3e30aa(%rip)        # b020a0 <_DYNAMIC+0x358>
  71eff6:	eb 56                	jmp    71f04e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x2de>
  71eff8:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  71efff:	49 39 f7             	cmp    %rsi,%r15
  71f002:	0f 83 d9 09 00 00    	jae    71f9e1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc71>
  71f008:	49 8b 86 10 02 00 00 	mov    0x210(%r14),%rax
  71f00f:	49 6b cf 58          	imul   $0x58,%r15,%rcx
  71f013:	48 8b 54 08 50       	mov    0x50(%rax,%rcx,1),%rdx
  71f018:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  71f01d:	0f 10 44 08 40       	movups 0x40(%rax,%rcx,1),%xmm0
  71f022:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  71f027:	0f 10 04 08          	movups (%rax,%rcx,1),%xmm0
  71f02b:	0f 10 4c 08 10       	movups 0x10(%rax,%rcx,1),%xmm1
  71f030:	0f 10 54 08 20       	movups 0x20(%rax,%rcx,1),%xmm2
  71f035:	0f 10 5c 08 30       	movups 0x30(%rax,%rcx,1),%xmm3
  71f03a:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
  71f03f:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  71f044:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  71f049:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  71f04e:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  71f055:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  71f05c:	00 
  71f05d:	4c 89 fa             	mov    %r15,%rdx
  71f060:	ff 15 1a 34 3e 00    	call   *0x3e341a(%rip)        # b02480 <_DYNAMIC+0x738>
  71f066:	80 bc 24 40 01 00 00 	cmpb   $0x0,0x140(%rsp)
  71f06d:	00 
  71f06e:	74 1a                	je     71f08a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x31a>
  71f070:	48 8d 94 24 44 01 00 	lea    0x144(%rsp),%rdx
  71f077:	00 
  71f078:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  71f07f:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  71f084:	ff 15 fe 33 3e 00    	call   *0x3e33fe(%rip)        # b02488 <_DYNAMIC+0x740>
  71f08a:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  71f091:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  71f096:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  71f09d:	00 
  71f09e:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
  71f0a3:	0f 29 84 24 80 01 00 	movaps %xmm0,0x180(%rsp)
  71f0aa:	00 
  71f0ab:	66 0f 6f 44 24 10    	movdqa 0x10(%rsp),%xmm0
  71f0b1:	66 0f 6f 4c 24 20    	movdqa 0x20(%rsp),%xmm1
  71f0b7:	0f 28 54 24 30       	movaps 0x30(%rsp),%xmm2
  71f0bc:	0f 28 5c 24 40       	movaps 0x40(%rsp),%xmm3
  71f0c1:	0f 29 9c 24 70 01 00 	movaps %xmm3,0x170(%rsp)
  71f0c8:	00 
  71f0c9:	0f 29 94 24 60 01 00 	movaps %xmm2,0x160(%rsp)
  71f0d0:	00 
  71f0d1:	66 0f 7f 8c 24 50 01 	movdqa %xmm1,0x150(%rsp)
  71f0d8:	00 00 
  71f0da:	66 0f 7f 84 24 40 01 	movdqa %xmm0,0x140(%rsp)
  71f0e1:	00 00 
  71f0e3:	48 8d bc 24 a0 01 00 	lea    0x1a0(%rsp),%rdi
  71f0ea:	00 
  71f0eb:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  71f0f2:	00 
  71f0f3:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  71f0f8:	41 89 e8             	mov    %ebp,%r8d
  71f0fb:	4d 89 e9             	mov    %r13,%r9
  71f0fe:	e8 6d 27 01 00       	call   731870 <<gpui::property::Overrides>::set_value>
  71f103:	44 8b ac 24 a0 01 00 	mov    0x1a0(%rsp),%r13d
  71f10a:	00 
  71f10b:	41 83 fd 02          	cmp    $0x2,%r13d
  71f10f:	75 2b                	jne    71f13c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x3cc>
  71f111:	0f b7 84 24 a8 01 00 	movzwl 0x1a8(%rsp),%eax
  71f118:	00 
  71f119:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  71f11e:	8b 8c 24 a4 01 00 00 	mov    0x1a4(%rsp),%ecx
  71f125:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  71f129:	66 89 43 0c          	mov    %ax,0xc(%rbx)
  71f12d:	89 4b 08             	mov    %ecx,0x8(%rbx)
  71f130:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  71f137:	e9 36 08 00 00       	jmp    71f972 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc02>
  71f13c:	45 31 c0             	xor    %r8d,%r8d
  71f13f:	41 80 fc ff          	cmp    $0xff,%r12b
  71f143:	41 0f 95 c0          	setne  %r8b
  71f147:	0f b7 84 24 a8 01 00 	movzwl 0x1a8(%rsp),%eax
  71f14e:	00 
  71f14f:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  71f154:	8b 8c 24 a4 01 00 00 	mov    0x1a4(%rsp),%ecx
  71f15b:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  71f15f:	0f 10 84 24 aa 01 00 	movups 0x1aa(%rsp),%xmm0
  71f166:	00 
  71f167:	0f 11 84 24 f2 00 00 	movups %xmm0,0xf2(%rsp)
  71f16e:	00 
  71f16f:	0f 10 84 24 ba 01 00 	movups 0x1ba(%rsp),%xmm0
  71f176:	00 
  71f177:	0f 11 84 24 02 01 00 	movups %xmm0,0x102(%rsp)
  71f17e:	00 
  71f17f:	0f 10 84 24 ca 01 00 	movups 0x1ca(%rsp),%xmm0
  71f186:	00 
  71f187:	0f 11 84 24 12 01 00 	movups %xmm0,0x112(%rsp)
  71f18e:	00 
  71f18f:	0f 10 84 24 da 01 00 	movups 0x1da(%rsp),%xmm0
  71f196:	00 
  71f197:	0f 11 84 24 22 01 00 	movups %xmm0,0x122(%rsp)
  71f19e:	00 
  71f19f:	0f 10 84 24 e8 01 00 	movups 0x1e8(%rsp),%xmm0
  71f1a6:	00 
  71f1a7:	0f 11 84 24 30 01 00 	movups %xmm0,0x130(%rsp)
  71f1ae:	00 
  71f1af:	44 89 ac 24 e8 00 00 	mov    %r13d,0xe8(%rsp)
  71f1b6:	00 
  71f1b7:	66 89 84 24 f0 00 00 	mov    %ax,0xf0(%rsp)
  71f1be:	00 
  71f1bf:	89 8c 24 ec 00 00 00 	mov    %ecx,0xec(%rsp)
  71f1c6:	0f 10 84 24 28 01 00 	movups 0x128(%rsp),%xmm0
  71f1cd:	00 
  71f1ce:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  71f1d5:	00 
  71f1d6:	0f 10 84 24 18 01 00 	movups 0x118(%rsp),%xmm0
  71f1dd:	00 
  71f1de:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  71f1e5:	00 
  71f1e6:	0f 10 84 24 08 01 00 	movups 0x108(%rsp),%xmm0
  71f1ed:	00 
  71f1ee:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  71f1f5:	00 
  71f1f6:	0f 10 84 24 f8 00 00 	movups 0xf8(%rsp),%xmm0
  71f1fd:	00 
  71f1fe:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  71f205:	00 
  71f206:	0f 10 84 24 e8 00 00 	movups 0xe8(%rsp),%xmm0
  71f20d:	00 
  71f20e:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  71f215:	00 
  71f216:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  71f21d:	00 
  71f21e:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  71f225:	00 
  71f226:	4d 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%r9
  71f22d:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
  71f234:	00 
  71f235:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  71f23c:	00 
  71f23d:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  71f244:	00 
  71f245:	f3 0f 6f 84 24 f8 00 	movdqu 0xf8(%rsp),%xmm0
  71f24c:	00 00 
  71f24e:	f3 0f 6f 8c 24 08 01 	movdqu 0x108(%rsp),%xmm1
  71f255:	00 00 
  71f257:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  71f25e:	00 
  71f25f:	0f 10 9c 24 28 01 00 	movups 0x128(%rsp),%xmm3
  71f266:	00 
  71f267:	0f 29 9c 24 80 01 00 	movaps %xmm3,0x180(%rsp)
  71f26e:	00 
  71f26f:	0f 29 94 24 70 01 00 	movaps %xmm2,0x170(%rsp)
  71f276:	00 
  71f277:	66 0f 7f 8c 24 60 01 	movdqa %xmm1,0x160(%rsp)
  71f27e:	00 00 
  71f280:	66 0f 7f 84 24 50 01 	movdqa %xmm0,0x150(%rsp)
  71f287:	00 00 
  71f289:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  71f290:	00 
  71f291:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  71f298:	4c 89 fe             	mov    %r15,%rsi
  71f29b:	89 ea                	mov    %ebp,%edx
  71f29d:	ff 15 ed 31 3e 00    	call   *0x3e31ed(%rip)        # b02490 <_DYNAMIC+0x748>
  71f2a3:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  71f2aa:	8b 6c 24 10          	mov    0x10(%rsp),%ebp
  71f2ae:	44 0f b6 a4 24 90 00 	movzbl 0x90(%rsp),%r12d
  71f2b5:	00 00 
  71f2b7:	83 fd 01             	cmp    $0x1,%ebp
  71f2ba:	75 25                	jne    71f2e1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x571>
  71f2bc:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  71f2c3:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  71f2c7:	39 c1                	cmp    %eax,%ecx
  71f2c9:	0f 94 c2             	sete   %dl
  71f2cc:	41 84 d4             	test   %dl,%r12b
  71f2cf:	75 26                	jne    71f2f7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x587>
  71f2d1:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  71f2d8:	01 00 00 00 
  71f2dc:	e9 78 03 00 00       	jmp    71f659 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8e9>
  71f2e1:	41 f6 c4 01          	test   $0x1,%r12b
  71f2e5:	74 10                	je     71f2f7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x587>
  71f2e7:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  71f2ee:	01 00 00 00 
  71f2f2:	e9 76 04 00 00       	jmp    71f76d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f2f7:	8b 54 24 18          	mov    0x18(%rsp),%edx
  71f2fb:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  71f302:	00 
  71f303:	83 fa 01             	cmp    $0x1,%edx
  71f306:	0f 85 27 02 00 00    	jne    71f533 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x7c3>
  71f30c:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  71f313:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  71f317:	0f 94 c0             	sete   %al
  71f31a:	be 01 00 00 00       	mov    $0x1,%esi
  71f31f:	84 c1                	test   %al,%cl
  71f321:	0f 85 1a 02 00 00    	jne    71f541 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x7d1>
  71f327:	e9 15 03 00 00       	jmp    71f641 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f32c:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  71f333:	00 00 00 00 
  71f337:	66 0f ef c0          	pxor   %xmm0,%xmm0
  71f33b:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  71f342:	00 
  71f343:	48 85 ff             	test   %rdi,%rdi
  71f346:	75 76                	jne    71f3be <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x64e>
  71f348:	66 0f 7e 44 24 70    	movd   %xmm0,0x70(%rsp)
  71f34e:	ff 15 54 2c 3e 00    	call   *0x3e2c54(%rip)        # b01fa8 <_DYNAMIC+0x260>
  71f354:	bf 60 00 00 00       	mov    $0x60,%edi
  71f359:	be 08 00 00 00       	mov    $0x8,%esi
  71f35e:	ff 15 24 2c 3e 00    	call   *0x3e2c24(%rip)        # b01f88 <_DYNAMIC+0x240>
  71f364:	48 85 c0             	test   %rax,%rax
  71f367:	0f 84 27 06 00 00    	je     71f994 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc24>
  71f36d:	48 89 c7             	mov    %rax,%rdi
  71f370:	66 0f ef c0          	pxor   %xmm0,%xmm0
  71f374:	f3 0f 7f 40 10       	movdqu %xmm0,0x10(%rax)
  71f379:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  71f380:	48 c7 40 08 08 00 00 	movq   $0x8,0x8(%rax)
  71f387:	00 
  71f388:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  71f38f:	00 
  71f390:	48 c7 40 28 00 00 00 	movq   $0x0,0x28(%rax)
  71f397:	00 
  71f398:	48 c7 40 30 ff ff ff 	movq   $0xffffffffffffffff,0x30(%rax)
  71f39f:	ff 
  71f3a0:	48 c7 40 48 00 00 00 	movq   $0x0,0x48(%rax)
  71f3a7:	00 
  71f3a8:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  71f3af:	00 
  71f3b0:	49 89 84 24 00 01 00 	mov    %rax,0x100(%r12)
  71f3b7:	00 
  71f3b8:	66 0f 6e 44 24 70    	movd   0x70(%rsp),%xmm0
  71f3be:	48 83 c7 48          	add    $0x48,%rdi
  71f3c2:	4c 89 fe             	mov    %r15,%rsi
  71f3c5:	89 ea                	mov    %ebp,%edx
  71f3c7:	4c 89 e9             	mov    %r13,%rcx
  71f3ca:	e8 21 1c 01 00       	call   730ff0 <<gpui::property::Overrides<gpui::property::GeometryStyle>>::set_value>
  71f3cf:	48 89 c1             	mov    %rax,%rcx
  71f3d2:	48 c1 e9 20          	shr    $0x20,%rcx
  71f3d6:	a8 01                	test   $0x1,%al
  71f3d8:	74 16                	je     71f3f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x680>
  71f3da:	c1 e8 10             	shr    $0x10,%eax
  71f3dd:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  71f3e4:	66 89 43 08          	mov    %ax,0x8(%rbx)
  71f3e8:	89 4b 0a             	mov    %ecx,0xa(%rbx)
  71f3eb:	e9 82 05 00 00       	jmp    71f972 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc02>
  71f3f0:	66 0f 6e c1          	movd   %ecx,%xmm0
  71f3f4:	89 8c 24 40 01 00 00 	mov    %ecx,0x140(%rsp)
  71f3fb:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  71f402:	00 
  71f403:	4c 89 fe             	mov    %r15,%rsi
  71f406:	ff 15 8c 30 3e 00    	call   *0x3e308c(%rip)        # b02498 <_DYNAMIC+0x750>
  71f40c:	49 8b 84 24 00 01 00 	mov    0x100(%r12),%rax
  71f413:	00 
  71f414:	48 83 78 10 00       	cmpq   $0x0,0x10(%rax)
  71f419:	75 3a                	jne    71f455 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x6e5>
  71f41b:	48 83 78 58 00       	cmpq   $0x0,0x58(%rax)
  71f420:	75 33                	jne    71f455 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x6e5>
  71f422:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  71f427:	75 2c                	jne    71f455 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x6e5>
  71f429:	48 83 78 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rax)
  71f42e:	75 25                	jne    71f455 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x6e5>
  71f430:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  71f437:	48 8b b8 00 01 00 00 	mov    0x100(%rax),%rdi
  71f43e:	e8 7d 20 fe ff       	call   7014c0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::geometry::Geometry>>>>
  71f443:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  71f44a:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  71f451:	00 00 00 00 
  71f455:	48 8b 05 04 2d 3e 00 	mov    0x3e2d04(%rip),%rax        # b02160 <_DYNAMIC+0x418>
  71f45c:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  71f463:	00 
  71f464:	48 8d b4 24 40 01 00 	lea    0x140(%rsp),%rsi
  71f46b:	00 
  71f46c:	ff 50 18             	call   *0x18(%rax)
  71f46f:	34 01                	xor    $0x1,%al
  71f471:	0f b6 c0             	movzbl %al,%eax
  71f474:	49 89 86 08 07 00 00 	mov    %rax,0x708(%r14)
  71f47b:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  71f482:	4d 8b be 10 06 00 00 	mov    0x610(%r14),%r15
  71f489:	4d 85 ff             	test   %r15,%r15
  71f48c:	0f 84 d9 04 00 00    	je     71f96b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f492:	49 83 bf d8 00 00 00 	cmpq   $0x0,0xd8(%r15)
  71f499:	00 
  71f49a:	0f 85 cb 04 00 00    	jne    71f96b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f4a0:	49 83 bf e0 00 00 00 	cmpq   $0x0,0xe0(%r15)
  71f4a7:	00 
  71f4a8:	0f 85 bd 04 00 00    	jne    71f96b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f4ae:	49 83 bf 00 01 00 00 	cmpq   $0x0,0x100(%r15)
  71f4b5:	00 
  71f4b6:	0f 85 af 04 00 00    	jne    71f96b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f4bc:	49 83 bf d0 00 00 00 	cmpq   $0x0,0xd0(%r15)
  71f4c3:	00 
  71f4c4:	0f 85 a1 04 00 00    	jne    71f96b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f4ca:	49 83 bf f8 00 00 00 	cmpq   $0x0,0xf8(%r15)
  71f4d1:	00 
  71f4d2:	0f 85 93 04 00 00    	jne    71f96b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f4d8:	49 8b 47 60          	mov    0x60(%r15),%rax
  71f4dc:	83 f8 ff             	cmp    $0xffffffff,%eax
  71f4df:	0f 85 86 04 00 00    	jne    71f96b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f4e5:	49 83 7f 28 00       	cmpq   $0x0,0x28(%r15)
  71f4ea:	0f 85 7b 04 00 00    	jne    71f96b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f4f0:	49 8b 07             	mov    (%r15),%rax
  71f4f3:	49 0b 47 40          	or     0x40(%r15),%rax
  71f4f7:	0f 85 6e 04 00 00    	jne    71f96b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f4fd:	49 83 7f 58 00       	cmpq   $0x0,0x58(%r15)
  71f502:	0f 85 63 04 00 00    	jne    71f96b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f508:	4c 89 ff             	mov    %r15,%rdi
  71f50b:	e8 30 65 fe ff       	call   705a40 <core::ptr::drop_glue::<gpui::runtime::metadata::Metadata>>
  71f510:	be 08 01 00 00       	mov    $0x108,%esi
  71f515:	ba 08 00 00 00       	mov    $0x8,%edx
  71f51a:	4c 89 ff             	mov    %r15,%rdi
  71f51d:	ff 15 6d 2a 3e 00    	call   *0x3e2a6d(%rip)        # b01f90 <_DYNAMIC+0x248>
  71f523:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  71f52a:	00 00 00 00 
  71f52e:	e9 38 04 00 00       	jmp    71f96b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f533:	be 01 00 00 00       	mov    $0x1,%esi
  71f538:	f6 c1 01             	test   $0x1,%cl
  71f53b:	0f 85 00 01 00 00    	jne    71f641 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f541:	8b 44 24 20          	mov    0x20(%rsp),%eax
  71f545:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  71f54c:	0f 85 ef 00 00 00    	jne    71f641 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f552:	8b 44 24 24          	mov    0x24(%rsp),%eax
  71f556:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  71f55d:	0f 85 de 00 00 00    	jne    71f641 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f563:	8b 44 24 28          	mov    0x28(%rsp),%eax
  71f567:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  71f56e:	0f 85 cd 00 00 00    	jne    71f641 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f574:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  71f579:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  71f580:	0f 85 bb 00 00 00    	jne    71f641 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f586:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  71f58b:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  71f592:	0f 85 a9 00 00 00    	jne    71f641 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f598:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  71f59d:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  71f5a4:	0f 85 97 00 00 00    	jne    71f641 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f5aa:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  71f5af:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  71f5b6:	0f 85 85 00 00 00    	jne    71f641 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f5bc:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  71f5c0:	88 8c 24 80 00 00 00 	mov    %cl,0x80(%rsp)
  71f5c7:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  71f5cc:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  71f5d3:	00 
  71f5d4:	e8 17 08 00 00       	call   71fdf0 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  71f5d9:	84 c0                	test   %al,%al
  71f5db:	74 53                	je     71f630 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8c0>
  71f5dd:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  71f5e3:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  71f5ea:	00 00 
  71f5ec:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  71f5f0:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  71f5f4:	3d ff ff 00 00       	cmp    $0xffff,%eax
  71f5f9:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  71f600:	00 
  71f601:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  71f605:	be 01 00 00 00       	mov    $0x1,%esi
  71f60a:	75 35                	jne    71f641 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f60c:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  71f612:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  71f619:	00 00 
  71f61b:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  71f61f:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  71f623:	31 f6                	xor    %esi,%esi
  71f625:	3d ff ff 00 00       	cmp    $0xffff,%eax
  71f62a:	40 0f 95 c6          	setne  %sil
  71f62e:	eb 11                	jmp    71f641 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f630:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  71f637:	00 
  71f638:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  71f63c:	be 01 00 00 00       	mov    $0x1,%esi
  71f641:	49 89 b6 08 07 00 00 	mov    %rsi,0x708(%r14)
  71f648:	40 f6 c5 01          	test   $0x1,%bpl
  71f64c:	74 2b                	je     71f679 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x909>
  71f64e:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  71f655:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  71f659:	39 c1                	cmp    %eax,%ecx
  71f65b:	0f 94 c0             	sete   %al
  71f65e:	41 20 c4             	and    %al,%r12b
  71f661:	41 80 fc 01          	cmp    $0x1,%r12b
  71f665:	0f 85 02 01 00 00    	jne    71f76d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f66b:	8b 54 24 18          	mov    0x18(%rsp),%edx
  71f66f:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  71f676:	00 
  71f677:	eb 0a                	jmp    71f683 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x913>
  71f679:	41 f6 c4 01          	test   $0x1,%r12b
  71f67d:	0f 85 ea 00 00 00    	jne    71f76d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f683:	83 fa 01             	cmp    $0x1,%edx
  71f686:	75 17                	jne    71f69f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x92f>
  71f688:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  71f68f:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  71f693:	0f 94 c0             	sete   %al
  71f696:	84 c1                	test   %al,%cl
  71f698:	75 0e                	jne    71f6a8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x938>
  71f69a:	e9 ce 00 00 00       	jmp    71f76d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f69f:	f6 c1 01             	test   $0x1,%cl
  71f6a2:	0f 85 c5 00 00 00    	jne    71f76d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f6a8:	8b 44 24 20          	mov    0x20(%rsp),%eax
  71f6ac:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  71f6b3:	0f 85 b4 00 00 00    	jne    71f76d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f6b9:	8b 44 24 24          	mov    0x24(%rsp),%eax
  71f6bd:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  71f6c4:	0f 85 a3 00 00 00    	jne    71f76d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f6ca:	8b 44 24 28          	mov    0x28(%rsp),%eax
  71f6ce:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  71f6d5:	0f 85 92 00 00 00    	jne    71f76d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f6db:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  71f6e0:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  71f6e7:	0f 85 80 00 00 00    	jne    71f76d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f6ed:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  71f6f2:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  71f6f9:	75 72                	jne    71f76d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f6fb:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  71f700:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  71f707:	75 64                	jne    71f76d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f709:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  71f70e:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  71f715:	75 56                	jne    71f76d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f717:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  71f71c:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  71f723:	00 
  71f724:	e8 c7 06 00 00       	call   71fdf0 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  71f729:	84 c0                	test   %al,%al
  71f72b:	74 40                	je     71f76d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f72d:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  71f733:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  71f73a:	00 00 
  71f73c:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  71f740:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  71f744:	3d ff ff 00 00       	cmp    $0xffff,%eax
  71f749:	75 22                	jne    71f76d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f74b:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  71f751:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  71f758:	00 00 
  71f75a:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  71f75e:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  71f762:	3d ff ff 00 00       	cmp    $0xffff,%eax
  71f767:	0f 84 fe 01 00 00    	je     71f96b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f76d:	45 89 e8             	mov    %r13d,%r8d
  71f770:	44 8b 64 24 18       	mov    0x18(%rsp),%r12d
  71f775:	0f b6 7c 24 64       	movzbl 0x64(%rsp),%edi
  71f77a:	44 0f b6 6c 24 65    	movzbl 0x65(%rsp),%r13d
  71f780:	0f b6 4c 24 66       	movzbl 0x66(%rsp),%ecx
  71f785:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  71f78a:	88 84 24 80 00 00 00 	mov    %al,0x80(%rsp)
  71f791:	8b b4 24 f0 00 00 00 	mov    0xf0(%rsp),%esi
  71f798:	0f 10 5c 24 1c       	movups 0x1c(%rsp),%xmm3
  71f79d:	f3 0f 10 44 24 20    	movss  0x20(%rsp),%xmm0
  71f7a3:	0f 10 a4 24 f4 00 00 	movups 0xf4(%rsp),%xmm4
  71f7aa:	00 
  71f7ab:	f3 0f 10 8c 24 f8 00 	movss  0xf8(%rsp),%xmm1
  71f7b2:	00 00 
  71f7b4:	44 0f b6 9c 24 3c 01 	movzbl 0x13c(%rsp),%r11d
  71f7bb:	00 00 
  71f7bd:	44 0f b6 8c 24 3d 01 	movzbl 0x13d(%rsp),%r9d
  71f7c4:	00 00 
  71f7c6:	0f b6 84 24 3e 01 00 	movzbl 0x13e(%rsp),%eax
  71f7cd:	00 
  71f7ce:	44 0f b6 94 24 3f 01 	movzbl 0x13f(%rsp),%r10d
  71f7d5:	00 00 
  71f7d7:	40 f6 c5 01          	test   $0x1,%bpl
  71f7db:	74 22                	je     71f7ff <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xa8f>
  71f7dd:	f3 0f 10 54 24 14    	movss  0x14(%rsp),%xmm2
  71f7e3:	0f 2e 94 24 ec 00 00 	ucomiss 0xec(%rsp),%xmm2
  71f7ea:	00 
  71f7eb:	40 0f 9b c5          	setnp  %bpl
  71f7ef:	0f 94 c2             	sete   %dl
  71f7f2:	40 20 ea             	and    %bpl,%dl
  71f7f5:	41 84 d0             	test   %dl,%r8b
  71f7f8:	75 0f                	jne    71f809 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xa99>
  71f7fa:	e9 a4 00 00 00       	jmp    71f8a3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xb33>
  71f7ff:	41 f6 c0 01          	test   $0x1,%r8b
  71f803:	0f 85 9a 00 00 00    	jne    71f8a3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xb33>
  71f809:	41 83 fc 01          	cmp    $0x1,%r12d
  71f80d:	75 3c                	jne    71f84b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xadb>
  71f80f:	44 30 df             	xor    %r11b,%dil
  71f812:	30 c1                	xor    %al,%cl
  71f814:	0f b6 84 24 80 00 00 	movzbl 0x80(%rsp),%eax
  71f81b:	00 
  71f81c:	44 30 d0             	xor    %r10b,%al
  71f81f:	45 38 cd             	cmp    %r9b,%r13b
  71f822:	0f 94 c2             	sete   %dl
  71f825:	0f 28 c3             	movaps %xmm3,%xmm0
  71f828:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  71f82c:	44 0f 50 c0          	movmskps %xmm0,%r8d
  71f830:	41 80 f0 0f          	xor    $0xf,%r8b
  71f834:	40 08 f9             	or     %dil,%cl
  71f837:	44 08 c1             	or     %r8b,%cl
  71f83a:	08 c1                	or     %al,%cl
  71f83c:	0f 94 c0             	sete   %al
  71f83f:	40 20 f0             	and    %sil,%al
  71f842:	84 d0                	test   %dl,%al
  71f844:	74 5d                	je     71f8a3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xb33>
  71f846:	e9 83 00 00 00       	jmp    71f8ce <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xb5e>
  71f84b:	0f 2e c1             	ucomiss %xmm1,%xmm0
  71f84e:	0f 9b c2             	setnp  %dl
  71f851:	40 0f 94 c5          	sete   %bpl
  71f855:	40 20 d5             	and    %dl,%bpl
  71f858:	40 f6 d6             	not    %sil
  71f85b:	40 20 ee             	and    %bpl,%sil
  71f85e:	0f 28 c3             	movaps %xmm3,%xmm0
  71f861:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  71f865:	0f 50 d0             	movmskps %xmm0,%edx
  71f868:	89 d5                	mov    %edx,%ebp
  71f86a:	40 c0 ed 03          	shr    $0x3,%bpl
  71f86e:	c0 ea 02             	shr    $0x2,%dl
  71f871:	40 20 f2             	and    %sil,%dl
  71f874:	44 38 df             	cmp    %r11b,%dil
  71f877:	40 0f 94 c6          	sete   %sil
  71f87b:	40 20 ee             	and    %bpl,%sil
  71f87e:	40 20 d6             	and    %dl,%sil
  71f881:	38 c1                	cmp    %al,%cl
  71f883:	0f 94 c1             	sete   %cl
  71f886:	44 38 94 24 80 00 00 	cmp    %r10b,0x80(%rsp)
  71f88d:	00 
  71f88e:	0f 94 c0             	sete   %al
  71f891:	20 c8                	and    %cl,%al
  71f893:	45 38 cd             	cmp    %r9b,%r13b
  71f896:	0f 94 c1             	sete   %cl
  71f899:	20 c1                	and    %al,%cl
  71f89b:	40 20 f1             	and    %sil,%cl
  71f89e:	80 f9 01             	cmp    $0x1,%cl
  71f8a1:	74 2b                	je     71f8ce <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xb5e>
  71f8a3:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  71f8aa:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  71f8af:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
  71f8b4:	0f 29 a4 24 80 00 00 	movaps %xmm4,0x80(%rsp)
  71f8bb:	00 
  71f8bc:	e8 8f 20 00 00       	call   721950 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  71f8c1:	0f 28 a4 24 80 00 00 	movaps 0x80(%rsp),%xmm4
  71f8c8:	00 
  71f8c9:	0f 28 5c 24 70       	movaps 0x70(%rsp),%xmm3
  71f8ce:	0f c2 dc 04          	cmpneqps %xmm4,%xmm3
  71f8d2:	66 0f c5 c3 06       	pextrw $0x6,%xmm3,%eax
  71f8d7:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  71f8de:	a8 01                	test   $0x1,%al
  71f8e0:	74 69                	je     71f94b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbdb>
  71f8e2:	49 39 cf             	cmp    %rcx,%r15
  71f8e5:	0f 83 13 01 00 00    	jae    71f9fe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc8e>
  71f8eb:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  71f8f2:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  71f8f6:	8b 7c d0 20          	mov    0x20(%rax,%rdx,8),%edi
  71f8fa:	89 f8                	mov    %edi,%eax
  71f8fc:	83 e0 07             	and    $0x7,%eax
  71f8ff:	83 f8 06             	cmp    $0x6,%eax
  71f902:	74 47                	je     71f94b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbdb>
  71f904:	c1 ef 03             	shr    $0x3,%edi
  71f907:	74 42                	je     71f94b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbdb>
  71f909:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  71f910:	ff cf                	dec    %edi
  71f912:	48 39 fe             	cmp    %rdi,%rsi
  71f915:	0f 86 f6 00 00 00    	jbe    71fa11 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xca1>
  71f91b:	4d 8b a6 b0 02 00 00 	mov    0x2b0(%r14),%r12
  71f922:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  71f926:	48 c1 e0 04          	shl    $0x4,%rax
  71f92a:	49 83 3c 04 fe       	cmpq   $0xfffffffffffffffe,(%r12,%rax,1)
  71f92f:	74 73                	je     71f9a4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc34>
  71f931:	49 01 c4             	add    %rax,%r12
  71f934:	4c 89 e7             	mov    %r12,%rdi
  71f937:	e8 b4 1e fe ff       	call   7017f0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  71f93c:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  71f943:	ff 
  71f944:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  71f94b:	48 8d 94 24 e8 00 00 	lea    0xe8(%rsp),%rdx
  71f952:	00 
  71f953:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  71f95a:	4c 89 fe             	mov    %r15,%rsi
  71f95d:	ff 15 3d 28 3e 00    	call   *0x3e283d(%rip)        # b021a0 <_DYNAMIC+0x458>
  71f963:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  71f96a:	01 
  71f96b:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  71f972:	48 81 c4 f8 01 00 00 	add    $0x1f8,%rsp
  71f979:	5b                   	pop    %rbx
  71f97a:	41 5c                	pop    %r12
  71f97c:	41 5d                	pop    %r13
  71f97e:	41 5e                	pop    %r14
  71f980:	41 5f                	pop    %r15
  71f982:	5d                   	pop    %rbp
  71f983:	c3                   	ret
  71f984:	bf 08 00 00 00       	mov    $0x8,%edi
  71f989:	be 08 01 00 00       	mov    $0x108,%esi
  71f98e:	ff 15 2c 26 3e 00    	call   *0x3e262c(%rip)        # b01fc0 <_DYNAMIC+0x278>
  71f994:	bf 08 00 00 00       	mov    $0x8,%edi
  71f999:	be 60 00 00 00       	mov    $0x60,%esi
  71f99e:	ff 15 1c 26 3e 00    	call   *0x3e261c(%rip)        # b01fc0 <_DYNAMIC+0x278>
  71f9a4:	48 8d 3d dd 40 3b 00 	lea    0x3b40dd(%rip),%rdi        # ad3a88 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x2a0>
  71f9ab:	ff 15 1f 26 3e 00    	call   *0x3e261f(%rip)        # b01fd0 <_DYNAMIC+0x288>
  71f9b1:	48 8d 15 40 46 3b 00 	lea    0x3b4640(%rip),%rdx        # ad3ff8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x810>
  71f9b8:	4c 89 ff             	mov    %r15,%rdi
  71f9bb:	ff 15 ff 26 3e 00    	call   *0x3e26ff(%rip)        # b020c0 <_DYNAMIC+0x378>
  71f9c1:	48 8d 15 e0 4c 3b 00 	lea    0x3b4ce0(%rip),%rdx        # ad46a8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xec0>
  71f9c8:	4c 89 ff             	mov    %r15,%rdi
  71f9cb:	ff 15 ef 26 3e 00    	call   *0x3e26ef(%rip)        # b020c0 <_DYNAMIC+0x378>
  71f9d1:	48 8d 15 38 44 3b 00 	lea    0x3b4438(%rip),%rdx        # ad3e10 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x628>
  71f9d8:	4c 89 ff             	mov    %r15,%rdi
  71f9db:	ff 15 df 26 3e 00    	call   *0x3e26df(%rip)        # b020c0 <_DYNAMIC+0x378>
  71f9e1:	48 8d 15 10 44 3b 00 	lea    0x3b4410(%rip),%rdx        # ad3df8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x610>
  71f9e8:	4c 89 ff             	mov    %r15,%rdi
  71f9eb:	ff 15 cf 26 3e 00    	call   *0x3e26cf(%rip)        # b020c0 <_DYNAMIC+0x378>
  71f9f1:	48 8d 15 30 44 3b 00 	lea    0x3b4430(%rip),%rdx        # ad3e28 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x640>
  71f9f8:	ff 15 c2 26 3e 00    	call   *0x3e26c2(%rip)        # b020c0 <_DYNAMIC+0x378>
  71f9fe:	48 8d 15 bb 4c 3b 00 	lea    0x3b4cbb(%rip),%rdx        # ad46c0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xed8>
  71fa05:	4c 89 ff             	mov    %r15,%rdi
  71fa08:	48 89 ce             	mov    %rcx,%rsi
  71fa0b:	ff 15 af 26 3e 00    	call   *0x3e26af(%rip)        # b020c0 <_DYNAMIC+0x378>
  71fa11:	48 8d 15 58 40 3b 00 	lea    0x3b4058(%rip),%rdx        # ad3a70 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x288>
  71fa18:	ff 15 a2 26 3e 00    	call   *0x3e26a2(%rip)        # b020c0 <_DYNAMIC+0x378>
  71fa1e:	48 89 c3             	mov    %rax,%rbx
  71fa21:	be 08 01 00 00       	mov    $0x108,%esi
  71fa26:	ba 08 00 00 00       	mov    $0x8,%edx
  71fa2b:	4c 89 ff             	mov    %r15,%rdi
  71fa2e:	ff 15 5c 25 3e 00    	call   *0x3e255c(%rip)        # b01f90 <_DYNAMIC+0x248>
  71fa34:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  71fa3b:	00 00 00 00 
  71fa3f:	48 89 df             	mov    %rbx,%rdi
  71fa42:	e8 69 29 3b 00       	call   ad23b0 <_Unwind_Resume@plt>
  71fa47:	48 89 c3             	mov    %rax,%rbx
  71fa4a:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  71fa51:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  71fa58:	00 00 00 00 
  71fa5c:	48 89 df             	mov    %rbx,%rdi
  71fa5f:	e8 4c 29 3b 00       	call   ad23b0 <_Unwind_Resume@plt>
  71fa64:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  71fa6b:	ff 
  71fa6c:	48 89 c7             	mov    %rax,%rdi
  71fa6f:	e8 3c 29 3b 00       	call   ad23b0 <_Unwind_Resume@plt>
