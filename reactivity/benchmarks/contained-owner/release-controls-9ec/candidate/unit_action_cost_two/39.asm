
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000072ae10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at>:
  72ae10:	55                   	push   %rbp
  72ae11:	41 57                	push   %r15
  72ae13:	41 56                	push   %r14
  72ae15:	41 55                	push   %r13
  72ae17:	41 54                	push   %r12
  72ae19:	53                   	push   %rbx
  72ae1a:	48 81 ec f8 01 00 00 	sub    $0x1f8,%rsp
  72ae21:	4d 89 c5             	mov    %r8,%r13
  72ae24:	89 cd                	mov    %ecx,%ebp
  72ae26:	49 89 d7             	mov    %rdx,%r15
  72ae29:	49 89 f6             	mov    %rsi,%r14
  72ae2c:	48 89 fb             	mov    %rdi,%rbx
  72ae2f:	45 0f b6 20          	movzbl (%r8),%r12d
  72ae33:	41 80 fc ff          	cmp    $0xff,%r12b
  72ae37:	74 1c                	je     72ae55 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x45>
  72ae39:	89 ef                	mov    %ebp,%edi
  72ae3b:	4c 89 ee             	mov    %r13,%rsi
  72ae3e:	ff 15 c4 e7 3f 00    	call   *0x3fe7c4(%rip)        # b29608 <_DYNAMIC+0x508>
  72ae44:	66 85 c0             	test   %ax,%ax
  72ae47:	74 0c                	je     72ae55 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x45>
  72ae49:	48 89 c1             	mov    %rax,%rcx
  72ae4c:	48 c1 e9 10          	shr    $0x10,%rcx
  72ae50:	e9 28 06 00 00       	jmp    72b47d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x66d>
  72ae55:	0f b7 c5             	movzwl %bp,%eax
  72ae58:	48 8d 0d d9 0a 3d 00 	lea    0x3d0ad9(%rip),%rcx        # afb938 <__frame_dummy_init_array_entry+0x10a0>
  72ae5f:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  72ae64:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  72ae68:	74 78                	je     72aee2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xd2>
  72ae6a:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  72ae71:	49 39 f7             	cmp    %rsi,%r15
  72ae74:	0f 83 d7 0b 00 00    	jae    72ba51 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc41>
  72ae7a:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  72ae81:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  72ae85:	4c 8b 3c c8          	mov    (%rax,%rcx,8),%r15
  72ae89:	4d 8b a6 10 06 00 00 	mov    0x610(%r14),%r12
  72ae90:	4d 85 e4             	test   %r12,%r12
  72ae93:	0f 84 d4 00 00 00    	je     72af6d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x15d>
  72ae99:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72aea0:	00 
  72aea1:	48 85 ff             	test   %rdi,%rdi
  72aea4:	0f 84 22 05 00 00    	je     72b3cc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x5bc>
  72aeaa:	4c 89 fe             	mov    %r15,%rsi
  72aead:	ff 15 15 e8 3f 00    	call   *0x3fe815(%rip)        # b296c8 <_DYNAMIC+0x5c8>
  72aeb3:	4d 8b a6 10 06 00 00 	mov    0x610(%r14),%r12
  72aeba:	66 0f 7e 84 24 e8 00 	movd   %xmm0,0xe8(%rsp)
  72aec1:	00 00 
  72aec3:	4d 85 e4             	test   %r12,%r12
  72aec6:	0f 84 b0 00 00 00    	je     72af7c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x16c>
  72aecc:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72aed3:	00 
  72aed4:	48 85 ff             	test   %rdi,%rdi
  72aed7:	0f 85 81 05 00 00    	jne    72b45e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x64e>
  72aedd:	e9 06 05 00 00       	jmp    72b3e8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x5d8>
  72aee2:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  72aee9:	49 39 f7             	cmp    %rsi,%r15
  72aeec:	0f 83 6f 0b 00 00    	jae    72ba61 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc51>
  72aef2:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  72aef9:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  72aefd:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  72af01:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  72af06:	49 8b 86 00 02 00 00 	mov    0x200(%r14),%rax
  72af0d:	48 8d 0d 94 0a 93 ff 	lea    -0x6cf56c(%rip),%rcx        # 5b9a8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x148>
  72af14:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  72af18:	48 01 c8             	add    %rcx,%rax
  72af1b:	ff e0                	jmp    *%rax
  72af1d:	0f 10 05 2c 0c 93 ff 	movups -0x6cf3d4(%rip),%xmm0        # 5bb50 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2f0>
  72af24:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  72af29:	0f 10 05 10 0c 93 ff 	movups -0x6cf3f0(%rip),%xmm0        # 5bb40 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e0>
  72af30:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  72af35:	0f 10 05 f4 0b 93 ff 	movups -0x6cf40c(%rip),%xmm0        # 5bb30 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2d0>
  72af3c:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  72af41:	0f 10 05 d8 0b 93 ff 	movups -0x6cf428(%rip),%xmm0        # 5bb20 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c0>
  72af48:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  72af4d:	0f 10 05 bc 0b 93 ff 	movups -0x6cf444(%rip),%xmm0        # 5bb10 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2b0>
  72af54:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  72af59:	48 b8 00 00 00 00 01 	movabs $0x3000100000000,%rax
  72af60:	00 03 00 
  72af63:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  72af68:	e9 81 01 00 00       	jmp    72b0ee <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x2de>
  72af6d:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  72af74:	00 00 00 00 
  72af78:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72af7c:	66 0f 7e 44 24 70    	movd   %xmm0,0x70(%rsp)
  72af82:	ff 15 d8 e3 3f 00    	call   *0x3fe3d8(%rip)        # b29360 <_DYNAMIC+0x260>
  72af88:	bf 08 01 00 00       	mov    $0x108,%edi
  72af8d:	be 08 00 00 00       	mov    $0x8,%esi
  72af92:	ff 15 a8 e3 3f 00    	call   *0x3fe3a8(%rip)        # b29340 <_DYNAMIC+0x240>
  72af98:	48 85 c0             	test   %rax,%rax
  72af9b:	0f 84 83 0a 00 00    	je     72ba24 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc14>
  72afa1:	49 89 c4             	mov    %rax,%r12
  72afa4:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72afa8:	f3 0f 7f 80 d8 00 00 	movdqu %xmm0,0xd8(%rax)
  72afaf:	00 
  72afb0:	f3 0f 7f 40 28       	movdqu %xmm0,0x28(%rax)
  72afb5:	f3 0f 7f 40 40       	movdqu %xmm0,0x40(%rax)
  72afba:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  72afc1:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  72afc8:	00 
  72afc9:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  72afd0:	00 
  72afd1:	48 c7 40 38 08 00 00 	movq   $0x8,0x38(%rax)
  72afd8:	00 
  72afd9:	48 c7 40 50 08 00 00 	movq   $0x8,0x50(%rax)
  72afe0:	00 
  72afe1:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  72afe8:	00 
  72afe9:	48 c7 40 60 ff ff ff 	movq   $0xffffffffffffffff,0x60(%rax)
  72aff0:	ff 
  72aff1:	48 c7 80 c0 00 00 00 	movq   $0x0,0xc0(%rax)
  72aff8:	00 00 00 00 
  72affc:	48 c7 80 c8 00 00 00 	movq   $0x8,0xc8(%rax)
  72b003:	08 00 00 00 
  72b007:	48 c7 80 d0 00 00 00 	movq   $0x0,0xd0(%rax)
  72b00e:	00 00 00 00 
  72b012:	48 c7 80 e8 00 00 00 	movq   $0x0,0xe8(%rax)
  72b019:	00 00 00 00 
  72b01d:	f3 0f 7f 80 f8 00 00 	movdqu %xmm0,0xf8(%rax)
  72b024:	00 
  72b025:	49 89 86 10 06 00 00 	mov    %rax,0x610(%r14)
  72b02c:	66 0f 6e 44 24 70    	movd   0x70(%rsp),%xmm0
  72b032:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72b039:	00 
  72b03a:	48 85 ff             	test   %rdi,%rdi
  72b03d:	0f 85 1b 04 00 00    	jne    72b45e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x64e>
  72b043:	e9 a0 03 00 00       	jmp    72b3e8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x5d8>
  72b048:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  72b04f:	49 39 f7             	cmp    %rsi,%r15
  72b052:	0f 83 19 0a 00 00    	jae    72ba71 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc61>
  72b058:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  72b05f:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  72b066:	42 0f b6 3c 38       	movzbl (%rax,%r15,1),%edi
  72b06b:	48 39 fe             	cmp    %rdi,%rsi
  72b06e:	0f 86 1d 0a 00 00    	jbe    72ba91 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc81>
  72b074:	49 8b 86 08 02 00 00 	mov    0x208(%r14),%rax
  72b07b:	48 6b cf 58          	imul   $0x58,%rdi,%rcx
  72b07f:	eb 32                	jmp    72b0b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x2a3>
  72b081:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  72b088:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  72b08d:	4c 89 fa             	mov    %r15,%rdx
  72b090:	ff 15 a2 e3 3f 00    	call   *0x3fe3a2(%rip)        # b29438 <_DYNAMIC+0x338>
  72b096:	eb 56                	jmp    72b0ee <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x2de>
  72b098:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  72b09f:	49 39 f7             	cmp    %rsi,%r15
  72b0a2:	0f 83 d9 09 00 00    	jae    72ba81 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc71>
  72b0a8:	49 8b 86 10 02 00 00 	mov    0x210(%r14),%rax
  72b0af:	49 6b cf 58          	imul   $0x58,%r15,%rcx
  72b0b3:	48 8b 54 08 50       	mov    0x50(%rax,%rcx,1),%rdx
  72b0b8:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  72b0bd:	0f 10 44 08 40       	movups 0x40(%rax,%rcx,1),%xmm0
  72b0c2:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  72b0c7:	0f 10 04 08          	movups (%rax,%rcx,1),%xmm0
  72b0cb:	0f 10 4c 08 10       	movups 0x10(%rax,%rcx,1),%xmm1
  72b0d0:	0f 10 54 08 20       	movups 0x20(%rax,%rcx,1),%xmm2
  72b0d5:	0f 10 5c 08 30       	movups 0x30(%rax,%rcx,1),%xmm3
  72b0da:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
  72b0df:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  72b0e4:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  72b0e9:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  72b0ee:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  72b0f5:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  72b0fc:	00 
  72b0fd:	4c 89 fa             	mov    %r15,%rdx
  72b100:	ff 15 22 e7 3f 00    	call   *0x3fe722(%rip)        # b29828 <_DYNAMIC+0x728>
  72b106:	80 bc 24 40 01 00 00 	cmpb   $0x0,0x140(%rsp)
  72b10d:	00 
  72b10e:	74 1a                	je     72b12a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x31a>
  72b110:	48 8d 94 24 44 01 00 	lea    0x144(%rsp),%rdx
  72b117:	00 
  72b118:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  72b11f:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  72b124:	ff 15 06 e7 3f 00    	call   *0x3fe706(%rip)        # b29830 <_DYNAMIC+0x730>
  72b12a:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  72b131:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  72b136:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  72b13d:	00 
  72b13e:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
  72b143:	0f 29 84 24 80 01 00 	movaps %xmm0,0x180(%rsp)
  72b14a:	00 
  72b14b:	66 0f 6f 44 24 10    	movdqa 0x10(%rsp),%xmm0
  72b151:	66 0f 6f 4c 24 20    	movdqa 0x20(%rsp),%xmm1
  72b157:	0f 28 54 24 30       	movaps 0x30(%rsp),%xmm2
  72b15c:	0f 28 5c 24 40       	movaps 0x40(%rsp),%xmm3
  72b161:	0f 29 9c 24 70 01 00 	movaps %xmm3,0x170(%rsp)
  72b168:	00 
  72b169:	0f 29 94 24 60 01 00 	movaps %xmm2,0x160(%rsp)
  72b170:	00 
  72b171:	66 0f 7f 8c 24 50 01 	movdqa %xmm1,0x150(%rsp)
  72b178:	00 00 
  72b17a:	66 0f 7f 84 24 40 01 	movdqa %xmm0,0x140(%rsp)
  72b181:	00 00 
  72b183:	48 8d bc 24 a0 01 00 	lea    0x1a0(%rsp),%rdi
  72b18a:	00 
  72b18b:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  72b192:	00 
  72b193:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  72b198:	41 89 e8             	mov    %ebp,%r8d
  72b19b:	4d 89 e9             	mov    %r13,%r9
  72b19e:	e8 ed 3e 04 00       	call   76f090 <<gpui::property::Overrides>::set_value>
  72b1a3:	44 8b ac 24 a0 01 00 	mov    0x1a0(%rsp),%r13d
  72b1aa:	00 
  72b1ab:	41 83 fd 02          	cmp    $0x2,%r13d
  72b1af:	75 2b                	jne    72b1dc <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x3cc>
  72b1b1:	0f b7 84 24 a8 01 00 	movzwl 0x1a8(%rsp),%eax
  72b1b8:	00 
  72b1b9:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  72b1be:	8b 8c 24 a4 01 00 00 	mov    0x1a4(%rsp),%ecx
  72b1c5:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  72b1c9:	66 89 43 0c          	mov    %ax,0xc(%rbx)
  72b1cd:	89 4b 08             	mov    %ecx,0x8(%rbx)
  72b1d0:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  72b1d7:	e9 36 08 00 00       	jmp    72ba12 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc02>
  72b1dc:	45 31 c0             	xor    %r8d,%r8d
  72b1df:	41 80 fc ff          	cmp    $0xff,%r12b
  72b1e3:	41 0f 95 c0          	setne  %r8b
  72b1e7:	0f b7 84 24 a8 01 00 	movzwl 0x1a8(%rsp),%eax
  72b1ee:	00 
  72b1ef:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  72b1f4:	8b 8c 24 a4 01 00 00 	mov    0x1a4(%rsp),%ecx
  72b1fb:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  72b1ff:	0f 10 84 24 aa 01 00 	movups 0x1aa(%rsp),%xmm0
  72b206:	00 
  72b207:	0f 11 84 24 f2 00 00 	movups %xmm0,0xf2(%rsp)
  72b20e:	00 
  72b20f:	0f 10 84 24 ba 01 00 	movups 0x1ba(%rsp),%xmm0
  72b216:	00 
  72b217:	0f 11 84 24 02 01 00 	movups %xmm0,0x102(%rsp)
  72b21e:	00 
  72b21f:	0f 10 84 24 ca 01 00 	movups 0x1ca(%rsp),%xmm0
  72b226:	00 
  72b227:	0f 11 84 24 12 01 00 	movups %xmm0,0x112(%rsp)
  72b22e:	00 
  72b22f:	0f 10 84 24 da 01 00 	movups 0x1da(%rsp),%xmm0
  72b236:	00 
  72b237:	0f 11 84 24 22 01 00 	movups %xmm0,0x122(%rsp)
  72b23e:	00 
  72b23f:	0f 10 84 24 e8 01 00 	movups 0x1e8(%rsp),%xmm0
  72b246:	00 
  72b247:	0f 11 84 24 30 01 00 	movups %xmm0,0x130(%rsp)
  72b24e:	00 
  72b24f:	44 89 ac 24 e8 00 00 	mov    %r13d,0xe8(%rsp)
  72b256:	00 
  72b257:	66 89 84 24 f0 00 00 	mov    %ax,0xf0(%rsp)
  72b25e:	00 
  72b25f:	89 8c 24 ec 00 00 00 	mov    %ecx,0xec(%rsp)
  72b266:	0f 10 84 24 28 01 00 	movups 0x128(%rsp),%xmm0
  72b26d:	00 
  72b26e:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  72b275:	00 
  72b276:	0f 10 84 24 18 01 00 	movups 0x118(%rsp),%xmm0
  72b27d:	00 
  72b27e:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  72b285:	00 
  72b286:	0f 10 84 24 08 01 00 	movups 0x108(%rsp),%xmm0
  72b28d:	00 
  72b28e:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  72b295:	00 
  72b296:	0f 10 84 24 f8 00 00 	movups 0xf8(%rsp),%xmm0
  72b29d:	00 
  72b29e:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  72b2a5:	00 
  72b2a6:	0f 10 84 24 e8 00 00 	movups 0xe8(%rsp),%xmm0
  72b2ad:	00 
  72b2ae:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  72b2b5:	00 
  72b2b6:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  72b2bd:	00 
  72b2be:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  72b2c5:	00 
  72b2c6:	4d 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%r9
  72b2cd:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
  72b2d4:	00 
  72b2d5:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  72b2dc:	00 
  72b2dd:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  72b2e4:	00 
  72b2e5:	f3 0f 6f 84 24 f8 00 	movdqu 0xf8(%rsp),%xmm0
  72b2ec:	00 00 
  72b2ee:	f3 0f 6f 8c 24 08 01 	movdqu 0x108(%rsp),%xmm1
  72b2f5:	00 00 
  72b2f7:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  72b2fe:	00 
  72b2ff:	0f 10 9c 24 28 01 00 	movups 0x128(%rsp),%xmm3
  72b306:	00 
  72b307:	0f 29 9c 24 80 01 00 	movaps %xmm3,0x180(%rsp)
  72b30e:	00 
  72b30f:	0f 29 94 24 70 01 00 	movaps %xmm2,0x170(%rsp)
  72b316:	00 
  72b317:	66 0f 7f 8c 24 60 01 	movdqa %xmm1,0x160(%rsp)
  72b31e:	00 00 
  72b320:	66 0f 7f 84 24 50 01 	movdqa %xmm0,0x150(%rsp)
  72b327:	00 00 
  72b329:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  72b330:	00 
  72b331:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  72b338:	4c 89 fe             	mov    %r15,%rsi
  72b33b:	89 ea                	mov    %ebp,%edx
  72b33d:	ff 15 f5 e4 3f 00    	call   *0x3fe4f5(%rip)        # b29838 <_DYNAMIC+0x738>
  72b343:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  72b34a:	8b 6c 24 10          	mov    0x10(%rsp),%ebp
  72b34e:	44 0f b6 a4 24 90 00 	movzbl 0x90(%rsp),%r12d
  72b355:	00 00 
  72b357:	83 fd 01             	cmp    $0x1,%ebp
  72b35a:	75 25                	jne    72b381 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x571>
  72b35c:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  72b363:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  72b367:	39 c1                	cmp    %eax,%ecx
  72b369:	0f 94 c2             	sete   %dl
  72b36c:	41 84 d4             	test   %dl,%r12b
  72b36f:	75 26                	jne    72b397 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x587>
  72b371:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  72b378:	01 00 00 00 
  72b37c:	e9 78 03 00 00       	jmp    72b6f9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8e9>
  72b381:	41 f6 c4 01          	test   $0x1,%r12b
  72b385:	74 10                	je     72b397 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x587>
  72b387:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  72b38e:	01 00 00 00 
  72b392:	e9 76 04 00 00       	jmp    72b80d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b397:	8b 54 24 18          	mov    0x18(%rsp),%edx
  72b39b:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  72b3a2:	00 
  72b3a3:	83 fa 01             	cmp    $0x1,%edx
  72b3a6:	0f 85 27 02 00 00    	jne    72b5d3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x7c3>
  72b3ac:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  72b3b3:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  72b3b7:	0f 94 c0             	sete   %al
  72b3ba:	be 01 00 00 00       	mov    $0x1,%esi
  72b3bf:	84 c1                	test   %al,%cl
  72b3c1:	0f 85 1a 02 00 00    	jne    72b5e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x7d1>
  72b3c7:	e9 15 03 00 00       	jmp    72b6e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b3cc:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  72b3d3:	00 00 00 00 
  72b3d7:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72b3db:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72b3e2:	00 
  72b3e3:	48 85 ff             	test   %rdi,%rdi
  72b3e6:	75 76                	jne    72b45e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x64e>
  72b3e8:	66 0f 7e 44 24 70    	movd   %xmm0,0x70(%rsp)
  72b3ee:	ff 15 6c df 3f 00    	call   *0x3fdf6c(%rip)        # b29360 <_DYNAMIC+0x260>
  72b3f4:	bf 60 00 00 00       	mov    $0x60,%edi
  72b3f9:	be 08 00 00 00       	mov    $0x8,%esi
  72b3fe:	ff 15 3c df 3f 00    	call   *0x3fdf3c(%rip)        # b29340 <_DYNAMIC+0x240>
  72b404:	48 85 c0             	test   %rax,%rax
  72b407:	0f 84 27 06 00 00    	je     72ba34 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc24>
  72b40d:	48 89 c7             	mov    %rax,%rdi
  72b410:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72b414:	f3 0f 7f 40 10       	movdqu %xmm0,0x10(%rax)
  72b419:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  72b420:	48 c7 40 08 08 00 00 	movq   $0x8,0x8(%rax)
  72b427:	00 
  72b428:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  72b42f:	00 
  72b430:	48 c7 40 28 00 00 00 	movq   $0x0,0x28(%rax)
  72b437:	00 
  72b438:	48 c7 40 30 ff ff ff 	movq   $0xffffffffffffffff,0x30(%rax)
  72b43f:	ff 
  72b440:	48 c7 40 48 00 00 00 	movq   $0x0,0x48(%rax)
  72b447:	00 
  72b448:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  72b44f:	00 
  72b450:	49 89 84 24 00 01 00 	mov    %rax,0x100(%r12)
  72b457:	00 
  72b458:	66 0f 6e 44 24 70    	movd   0x70(%rsp),%xmm0
  72b45e:	48 83 c7 48          	add    $0x48,%rdi
  72b462:	4c 89 fe             	mov    %r15,%rsi
  72b465:	89 ea                	mov    %ebp,%edx
  72b467:	4c 89 e9             	mov    %r13,%rcx
  72b46a:	e8 a1 33 04 00       	call   76e810 <<gpui::property::Overrides<gpui::property::GeometryStyle>>::set_value>
  72b46f:	48 89 c1             	mov    %rax,%rcx
  72b472:	48 c1 e9 20          	shr    $0x20,%rcx
  72b476:	a8 01                	test   $0x1,%al
  72b478:	74 16                	je     72b490 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x680>
  72b47a:	c1 e8 10             	shr    $0x10,%eax
  72b47d:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  72b484:	66 89 43 08          	mov    %ax,0x8(%rbx)
  72b488:	89 4b 0a             	mov    %ecx,0xa(%rbx)
  72b48b:	e9 82 05 00 00       	jmp    72ba12 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc02>
  72b490:	66 0f 6e c1          	movd   %ecx,%xmm0
  72b494:	89 8c 24 40 01 00 00 	mov    %ecx,0x140(%rsp)
  72b49b:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72b4a2:	00 
  72b4a3:	4c 89 fe             	mov    %r15,%rsi
  72b4a6:	ff 15 94 e3 3f 00    	call   *0x3fe394(%rip)        # b29840 <_DYNAMIC+0x740>
  72b4ac:	49 8b 84 24 00 01 00 	mov    0x100(%r12),%rax
  72b4b3:	00 
  72b4b4:	48 83 78 10 00       	cmpq   $0x0,0x10(%rax)
  72b4b9:	75 3a                	jne    72b4f5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x6e5>
  72b4bb:	48 83 78 58 00       	cmpq   $0x0,0x58(%rax)
  72b4c0:	75 33                	jne    72b4f5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x6e5>
  72b4c2:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  72b4c7:	75 2c                	jne    72b4f5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x6e5>
  72b4c9:	48 83 78 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rax)
  72b4ce:	75 25                	jne    72b4f5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x6e5>
  72b4d0:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72b4d7:	48 8b b8 00 01 00 00 	mov    0x100(%rax),%rdi
  72b4de:	e8 ad 91 fc ff       	call   6f4690 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::geometry::Geometry>>>>
  72b4e3:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72b4ea:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  72b4f1:	00 00 00 00 
  72b4f5:	48 8b 05 fc df 3f 00 	mov    0x3fdffc(%rip),%rax        # b294f8 <_DYNAMIC+0x3f8>
  72b4fc:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  72b503:	00 
  72b504:	48 8d b4 24 40 01 00 	lea    0x140(%rsp),%rsi
  72b50b:	00 
  72b50c:	ff 50 18             	call   *0x18(%rax)
  72b50f:	34 01                	xor    $0x1,%al
  72b511:	0f b6 c0             	movzbl %al,%eax
  72b514:	49 89 86 08 07 00 00 	mov    %rax,0x708(%r14)
  72b51b:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  72b522:	4d 8b be 10 06 00 00 	mov    0x610(%r14),%r15
  72b529:	4d 85 ff             	test   %r15,%r15
  72b52c:	0f 84 d9 04 00 00    	je     72ba0b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b532:	49 83 bf d8 00 00 00 	cmpq   $0x0,0xd8(%r15)
  72b539:	00 
  72b53a:	0f 85 cb 04 00 00    	jne    72ba0b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b540:	49 83 bf e0 00 00 00 	cmpq   $0x0,0xe0(%r15)
  72b547:	00 
  72b548:	0f 85 bd 04 00 00    	jne    72ba0b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b54e:	49 83 bf 00 01 00 00 	cmpq   $0x0,0x100(%r15)
  72b555:	00 
  72b556:	0f 85 af 04 00 00    	jne    72ba0b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b55c:	49 83 bf d0 00 00 00 	cmpq   $0x0,0xd0(%r15)
  72b563:	00 
  72b564:	0f 85 a1 04 00 00    	jne    72ba0b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b56a:	49 83 bf f8 00 00 00 	cmpq   $0x0,0xf8(%r15)
  72b571:	00 
  72b572:	0f 85 93 04 00 00    	jne    72ba0b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b578:	49 8b 47 60          	mov    0x60(%r15),%rax
  72b57c:	83 f8 ff             	cmp    $0xffffffff,%eax
  72b57f:	0f 85 86 04 00 00    	jne    72ba0b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b585:	49 83 7f 28 00       	cmpq   $0x0,0x28(%r15)
  72b58a:	0f 85 7b 04 00 00    	jne    72ba0b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b590:	49 8b 07             	mov    (%r15),%rax
  72b593:	49 0b 47 40          	or     0x40(%r15),%rax
  72b597:	0f 85 6e 04 00 00    	jne    72ba0b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b59d:	49 83 7f 58 00       	cmpq   $0x0,0x58(%r15)
  72b5a2:	0f 85 63 04 00 00    	jne    72ba0b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b5a8:	4c 89 ff             	mov    %r15,%rdi
  72b5ab:	e8 a0 dd fc ff       	call   6f9350 <core::ptr::drop_glue::<gpui::runtime::metadata::Metadata>>
  72b5b0:	be 08 01 00 00       	mov    $0x108,%esi
  72b5b5:	ba 08 00 00 00       	mov    $0x8,%edx
  72b5ba:	4c 89 ff             	mov    %r15,%rdi
  72b5bd:	ff 15 85 dd 3f 00    	call   *0x3fdd85(%rip)        # b29348 <_DYNAMIC+0x248>
  72b5c3:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  72b5ca:	00 00 00 00 
  72b5ce:	e9 38 04 00 00       	jmp    72ba0b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b5d3:	be 01 00 00 00       	mov    $0x1,%esi
  72b5d8:	f6 c1 01             	test   $0x1,%cl
  72b5db:	0f 85 00 01 00 00    	jne    72b6e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b5e1:	8b 44 24 20          	mov    0x20(%rsp),%eax
  72b5e5:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  72b5ec:	0f 85 ef 00 00 00    	jne    72b6e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b5f2:	8b 44 24 24          	mov    0x24(%rsp),%eax
  72b5f6:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  72b5fd:	0f 85 de 00 00 00    	jne    72b6e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b603:	8b 44 24 28          	mov    0x28(%rsp),%eax
  72b607:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  72b60e:	0f 85 cd 00 00 00    	jne    72b6e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b614:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  72b619:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  72b620:	0f 85 bb 00 00 00    	jne    72b6e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b626:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  72b62b:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  72b632:	0f 85 a9 00 00 00    	jne    72b6e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b638:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  72b63d:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  72b644:	0f 85 97 00 00 00    	jne    72b6e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b64a:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  72b64f:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  72b656:	0f 85 85 00 00 00    	jne    72b6e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b65c:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  72b660:	88 8c 24 80 00 00 00 	mov    %cl,0x80(%rsp)
  72b667:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  72b66c:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  72b673:	00 
  72b674:	e8 37 08 00 00       	call   72beb0 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  72b679:	84 c0                	test   %al,%al
  72b67b:	74 53                	je     72b6d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8c0>
  72b67d:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  72b683:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  72b68a:	00 00 
  72b68c:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72b690:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72b694:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72b699:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  72b6a0:	00 
  72b6a1:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  72b6a5:	be 01 00 00 00       	mov    $0x1,%esi
  72b6aa:	75 35                	jne    72b6e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b6ac:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  72b6b2:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  72b6b9:	00 00 
  72b6bb:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72b6bf:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72b6c3:	31 f6                	xor    %esi,%esi
  72b6c5:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72b6ca:	40 0f 95 c6          	setne  %sil
  72b6ce:	eb 11                	jmp    72b6e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b6d0:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  72b6d7:	00 
  72b6d8:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  72b6dc:	be 01 00 00 00       	mov    $0x1,%esi
  72b6e1:	49 89 b6 08 07 00 00 	mov    %rsi,0x708(%r14)
  72b6e8:	40 f6 c5 01          	test   $0x1,%bpl
  72b6ec:	74 2b                	je     72b719 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x909>
  72b6ee:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  72b6f5:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  72b6f9:	39 c1                	cmp    %eax,%ecx
  72b6fb:	0f 94 c0             	sete   %al
  72b6fe:	41 20 c4             	and    %al,%r12b
  72b701:	41 80 fc 01          	cmp    $0x1,%r12b
  72b705:	0f 85 02 01 00 00    	jne    72b80d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b70b:	8b 54 24 18          	mov    0x18(%rsp),%edx
  72b70f:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  72b716:	00 
  72b717:	eb 0a                	jmp    72b723 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x913>
  72b719:	41 f6 c4 01          	test   $0x1,%r12b
  72b71d:	0f 85 ea 00 00 00    	jne    72b80d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b723:	83 fa 01             	cmp    $0x1,%edx
  72b726:	75 17                	jne    72b73f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x92f>
  72b728:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  72b72f:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  72b733:	0f 94 c0             	sete   %al
  72b736:	84 c1                	test   %al,%cl
  72b738:	75 0e                	jne    72b748 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x938>
  72b73a:	e9 ce 00 00 00       	jmp    72b80d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b73f:	f6 c1 01             	test   $0x1,%cl
  72b742:	0f 85 c5 00 00 00    	jne    72b80d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b748:	8b 44 24 20          	mov    0x20(%rsp),%eax
  72b74c:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  72b753:	0f 85 b4 00 00 00    	jne    72b80d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b759:	8b 44 24 24          	mov    0x24(%rsp),%eax
  72b75d:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  72b764:	0f 85 a3 00 00 00    	jne    72b80d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b76a:	8b 44 24 28          	mov    0x28(%rsp),%eax
  72b76e:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  72b775:	0f 85 92 00 00 00    	jne    72b80d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b77b:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  72b780:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  72b787:	0f 85 80 00 00 00    	jne    72b80d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b78d:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  72b792:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  72b799:	75 72                	jne    72b80d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b79b:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  72b7a0:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  72b7a7:	75 64                	jne    72b80d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b7a9:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  72b7ae:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  72b7b5:	75 56                	jne    72b80d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b7b7:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  72b7bc:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  72b7c3:	00 
  72b7c4:	e8 e7 06 00 00       	call   72beb0 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  72b7c9:	84 c0                	test   %al,%al
  72b7cb:	74 40                	je     72b80d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b7cd:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  72b7d3:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  72b7da:	00 00 
  72b7dc:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72b7e0:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72b7e4:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72b7e9:	75 22                	jne    72b80d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b7eb:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  72b7f1:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  72b7f8:	00 00 
  72b7fa:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72b7fe:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72b802:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72b807:	0f 84 fe 01 00 00    	je     72ba0b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b80d:	45 89 e8             	mov    %r13d,%r8d
  72b810:	44 8b 64 24 18       	mov    0x18(%rsp),%r12d
  72b815:	0f b6 7c 24 64       	movzbl 0x64(%rsp),%edi
  72b81a:	44 0f b6 6c 24 65    	movzbl 0x65(%rsp),%r13d
  72b820:	0f b6 4c 24 66       	movzbl 0x66(%rsp),%ecx
  72b825:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  72b82a:	88 84 24 80 00 00 00 	mov    %al,0x80(%rsp)
  72b831:	8b b4 24 f0 00 00 00 	mov    0xf0(%rsp),%esi
  72b838:	0f 10 5c 24 1c       	movups 0x1c(%rsp),%xmm3
  72b83d:	f3 0f 10 44 24 20    	movss  0x20(%rsp),%xmm0
  72b843:	0f 10 a4 24 f4 00 00 	movups 0xf4(%rsp),%xmm4
  72b84a:	00 
  72b84b:	f3 0f 10 8c 24 f8 00 	movss  0xf8(%rsp),%xmm1
  72b852:	00 00 
  72b854:	44 0f b6 9c 24 3c 01 	movzbl 0x13c(%rsp),%r11d
  72b85b:	00 00 
  72b85d:	44 0f b6 8c 24 3d 01 	movzbl 0x13d(%rsp),%r9d
  72b864:	00 00 
  72b866:	0f b6 84 24 3e 01 00 	movzbl 0x13e(%rsp),%eax
  72b86d:	00 
  72b86e:	44 0f b6 94 24 3f 01 	movzbl 0x13f(%rsp),%r10d
  72b875:	00 00 
  72b877:	40 f6 c5 01          	test   $0x1,%bpl
  72b87b:	74 22                	je     72b89f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xa8f>
  72b87d:	f3 0f 10 54 24 14    	movss  0x14(%rsp),%xmm2
  72b883:	0f 2e 94 24 ec 00 00 	ucomiss 0xec(%rsp),%xmm2
  72b88a:	00 
  72b88b:	40 0f 9b c5          	setnp  %bpl
  72b88f:	0f 94 c2             	sete   %dl
  72b892:	40 20 ea             	and    %bpl,%dl
  72b895:	41 84 d0             	test   %dl,%r8b
  72b898:	75 0f                	jne    72b8a9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xa99>
  72b89a:	e9 a4 00 00 00       	jmp    72b943 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xb33>
  72b89f:	41 f6 c0 01          	test   $0x1,%r8b
  72b8a3:	0f 85 9a 00 00 00    	jne    72b943 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xb33>
  72b8a9:	41 83 fc 01          	cmp    $0x1,%r12d
  72b8ad:	75 3c                	jne    72b8eb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xadb>
  72b8af:	44 30 df             	xor    %r11b,%dil
  72b8b2:	30 c1                	xor    %al,%cl
  72b8b4:	0f b6 84 24 80 00 00 	movzbl 0x80(%rsp),%eax
  72b8bb:	00 
  72b8bc:	44 30 d0             	xor    %r10b,%al
  72b8bf:	45 38 cd             	cmp    %r9b,%r13b
  72b8c2:	0f 94 c2             	sete   %dl
  72b8c5:	0f 28 c3             	movaps %xmm3,%xmm0
  72b8c8:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  72b8cc:	44 0f 50 c0          	movmskps %xmm0,%r8d
  72b8d0:	41 80 f0 0f          	xor    $0xf,%r8b
  72b8d4:	40 08 f9             	or     %dil,%cl
  72b8d7:	44 08 c1             	or     %r8b,%cl
  72b8da:	08 c1                	or     %al,%cl
  72b8dc:	0f 94 c0             	sete   %al
  72b8df:	40 20 f0             	and    %sil,%al
  72b8e2:	84 d0                	test   %dl,%al
  72b8e4:	74 5d                	je     72b943 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xb33>
  72b8e6:	e9 83 00 00 00       	jmp    72b96e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xb5e>
  72b8eb:	0f 2e c1             	ucomiss %xmm1,%xmm0
  72b8ee:	0f 9b c2             	setnp  %dl
  72b8f1:	40 0f 94 c5          	sete   %bpl
  72b8f5:	40 20 d5             	and    %dl,%bpl
  72b8f8:	40 f6 d6             	not    %sil
  72b8fb:	40 20 ee             	and    %bpl,%sil
  72b8fe:	0f 28 c3             	movaps %xmm3,%xmm0
  72b901:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  72b905:	0f 50 d0             	movmskps %xmm0,%edx
  72b908:	89 d5                	mov    %edx,%ebp
  72b90a:	40 c0 ed 03          	shr    $0x3,%bpl
  72b90e:	c0 ea 02             	shr    $0x2,%dl
  72b911:	40 20 f2             	and    %sil,%dl
  72b914:	44 38 df             	cmp    %r11b,%dil
  72b917:	40 0f 94 c6          	sete   %sil
  72b91b:	40 20 ee             	and    %bpl,%sil
  72b91e:	40 20 d6             	and    %dl,%sil
  72b921:	38 c1                	cmp    %al,%cl
  72b923:	0f 94 c1             	sete   %cl
  72b926:	44 38 94 24 80 00 00 	cmp    %r10b,0x80(%rsp)
  72b92d:	00 
  72b92e:	0f 94 c0             	sete   %al
  72b931:	20 c8                	and    %cl,%al
  72b933:	45 38 cd             	cmp    %r9b,%r13b
  72b936:	0f 94 c1             	sete   %cl
  72b939:	20 c1                	and    %al,%cl
  72b93b:	40 20 f1             	and    %sil,%cl
  72b93e:	80 f9 01             	cmp    $0x1,%cl
  72b941:	74 2b                	je     72b96e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xb5e>
  72b943:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  72b94a:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  72b94f:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
  72b954:	0f 29 a4 24 80 00 00 	movaps %xmm4,0x80(%rsp)
  72b95b:	00 
  72b95c:	e8 af 9b 01 00       	call   745510 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  72b961:	0f 28 a4 24 80 00 00 	movaps 0x80(%rsp),%xmm4
  72b968:	00 
  72b969:	0f 28 5c 24 70       	movaps 0x70(%rsp),%xmm3
  72b96e:	0f c2 dc 04          	cmpneqps %xmm4,%xmm3
  72b972:	66 0f c5 c3 06       	pextrw $0x6,%xmm3,%eax
  72b977:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  72b97e:	a8 01                	test   $0x1,%al
  72b980:	74 69                	je     72b9eb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbdb>
  72b982:	49 39 cf             	cmp    %rcx,%r15
  72b985:	0f 83 13 01 00 00    	jae    72ba9e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc8e>
  72b98b:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  72b992:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  72b996:	8b 7c d0 20          	mov    0x20(%rax,%rdx,8),%edi
  72b99a:	89 f8                	mov    %edi,%eax
  72b99c:	83 e0 07             	and    $0x7,%eax
  72b99f:	83 f8 06             	cmp    $0x6,%eax
  72b9a2:	74 47                	je     72b9eb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbdb>
  72b9a4:	c1 ef 03             	shr    $0x3,%edi
  72b9a7:	74 42                	je     72b9eb <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbdb>
  72b9a9:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  72b9b0:	ff cf                	dec    %edi
  72b9b2:	48 39 fe             	cmp    %rdi,%rsi
  72b9b5:	0f 86 f6 00 00 00    	jbe    72bab1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xca1>
  72b9bb:	4d 8b a6 b0 02 00 00 	mov    0x2b0(%r14),%r12
  72b9c2:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  72b9c6:	48 c1 e0 04          	shl    $0x4,%rax
  72b9ca:	49 83 3c 04 fe       	cmpq   $0xfffffffffffffffe,(%r12,%rax,1)
  72b9cf:	74 73                	je     72ba44 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc34>
  72b9d1:	49 01 c4             	add    %rax,%r12
  72b9d4:	4c 89 e7             	mov    %r12,%rdi
  72b9d7:	e8 e4 8f fc ff       	call   6f49c0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  72b9dc:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  72b9e3:	ff 
  72b9e4:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  72b9eb:	48 8d 94 24 e8 00 00 	lea    0xe8(%rsp),%rdx
  72b9f2:	00 
  72b9f3:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  72b9fa:	4c 89 fe             	mov    %r15,%rsi
  72b9fd:	ff 15 35 db 3f 00    	call   *0x3fdb35(%rip)        # b29538 <_DYNAMIC+0x438>
  72ba03:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  72ba0a:	01 
  72ba0b:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  72ba12:	48 81 c4 f8 01 00 00 	add    $0x1f8,%rsp
  72ba19:	5b                   	pop    %rbx
  72ba1a:	41 5c                	pop    %r12
  72ba1c:	41 5d                	pop    %r13
  72ba1e:	41 5e                	pop    %r14
  72ba20:	41 5f                	pop    %r15
  72ba22:	5d                   	pop    %rbp
  72ba23:	c3                   	ret
  72ba24:	bf 08 00 00 00       	mov    $0x8,%edi
  72ba29:	be 08 01 00 00       	mov    $0x108,%esi
  72ba2e:	ff 15 3c d9 3f 00    	call   *0x3fd93c(%rip)        # b29370 <_DYNAMIC+0x270>
  72ba34:	bf 08 00 00 00       	mov    $0x8,%edi
  72ba39:	be 60 00 00 00       	mov    $0x60,%esi
  72ba3e:	ff 15 2c d9 3f 00    	call   *0x3fd92c(%rip)        # b29370 <_DYNAMIC+0x270>
  72ba44:	48 8d 3d cd ef 3c 00 	lea    0x3cefcd(%rip),%rdi        # afaa18 <__frame_dummy_init_array_entry+0x180>
  72ba4b:	ff 15 b7 d9 3f 00    	call   *0x3fd9b7(%rip)        # b29408 <_DYNAMIC+0x308>
  72ba51:	48 8d 15 30 f5 3c 00 	lea    0x3cf530(%rip),%rdx        # afaf88 <__frame_dummy_init_array_entry+0x6f0>
  72ba58:	4c 89 ff             	mov    %r15,%rdi
  72ba5b:	ff 15 f7 d9 3f 00    	call   *0x3fd9f7(%rip)        # b29458 <_DYNAMIC+0x358>
  72ba61:	48 8d 15 f8 fb 3c 00 	lea    0x3cfbf8(%rip),%rdx        # afb660 <__frame_dummy_init_array_entry+0xdc8>
  72ba68:	4c 89 ff             	mov    %r15,%rdi
  72ba6b:	ff 15 e7 d9 3f 00    	call   *0x3fd9e7(%rip)        # b29458 <_DYNAMIC+0x358>
  72ba71:	48 8d 15 28 f3 3c 00 	lea    0x3cf328(%rip),%rdx        # afada0 <__frame_dummy_init_array_entry+0x508>
  72ba78:	4c 89 ff             	mov    %r15,%rdi
  72ba7b:	ff 15 d7 d9 3f 00    	call   *0x3fd9d7(%rip)        # b29458 <_DYNAMIC+0x358>
  72ba81:	48 8d 15 00 f3 3c 00 	lea    0x3cf300(%rip),%rdx        # afad88 <__frame_dummy_init_array_entry+0x4f0>
  72ba88:	4c 89 ff             	mov    %r15,%rdi
  72ba8b:	ff 15 c7 d9 3f 00    	call   *0x3fd9c7(%rip)        # b29458 <_DYNAMIC+0x358>
  72ba91:	48 8d 15 20 f3 3c 00 	lea    0x3cf320(%rip),%rdx        # afadb8 <__frame_dummy_init_array_entry+0x520>
  72ba98:	ff 15 ba d9 3f 00    	call   *0x3fd9ba(%rip)        # b29458 <_DYNAMIC+0x358>
  72ba9e:	48 8d 15 d3 fb 3c 00 	lea    0x3cfbd3(%rip),%rdx        # afb678 <__frame_dummy_init_array_entry+0xde0>
  72baa5:	4c 89 ff             	mov    %r15,%rdi
  72baa8:	48 89 ce             	mov    %rcx,%rsi
  72baab:	ff 15 a7 d9 3f 00    	call   *0x3fd9a7(%rip)        # b29458 <_DYNAMIC+0x358>
  72bab1:	48 8d 15 48 ef 3c 00 	lea    0x3cef48(%rip),%rdx        # afaa00 <__frame_dummy_init_array_entry+0x168>
  72bab8:	ff 15 9a d9 3f 00    	call   *0x3fd99a(%rip)        # b29458 <_DYNAMIC+0x358>
  72babe:	48 89 c3             	mov    %rax,%rbx
  72bac1:	be 08 01 00 00       	mov    $0x108,%esi
  72bac6:	ba 08 00 00 00       	mov    $0x8,%edx
  72bacb:	4c 89 ff             	mov    %r15,%rdi
  72bace:	ff 15 74 d8 3f 00    	call   *0x3fd874(%rip)        # b29348 <_DYNAMIC+0x248>
  72bad4:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  72badb:	00 00 00 00 
  72badf:	48 89 df             	mov    %rbx,%rdi
  72bae2:	e8 f9 d9 3c 00       	call   af94e0 <_Unwind_Resume@plt>
  72bae7:	48 89 c3             	mov    %rax,%rbx
  72baea:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72baf1:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  72baf8:	00 00 00 00 
  72bafc:	48 89 df             	mov    %rbx,%rdi
  72baff:	e8 dc d9 3c 00       	call   af94e0 <_Unwind_Resume@plt>
  72bb04:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  72bb0b:	ff 
  72bb0c:	48 89 c7             	mov    %rax,%rdi
  72bb0f:	e8 cc d9 3c 00       	call   af94e0 <_Unwind_Resume@plt>
