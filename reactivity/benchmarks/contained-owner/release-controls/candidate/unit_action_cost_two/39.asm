
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000072ae80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at>:
  72ae80:	55                   	push   %rbp
  72ae81:	41 57                	push   %r15
  72ae83:	41 56                	push   %r14
  72ae85:	41 55                	push   %r13
  72ae87:	41 54                	push   %r12
  72ae89:	53                   	push   %rbx
  72ae8a:	48 81 ec f8 01 00 00 	sub    $0x1f8,%rsp
  72ae91:	4d 89 c5             	mov    %r8,%r13
  72ae94:	89 cd                	mov    %ecx,%ebp
  72ae96:	49 89 d7             	mov    %rdx,%r15
  72ae99:	49 89 f6             	mov    %rsi,%r14
  72ae9c:	48 89 fb             	mov    %rdi,%rbx
  72ae9f:	45 0f b6 20          	movzbl (%r8),%r12d
  72aea3:	41 80 fc ff          	cmp    $0xff,%r12b
  72aea7:	74 1c                	je     72aec5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x45>
  72aea9:	89 ef                	mov    %ebp,%edi
  72aeab:	4c 89 ee             	mov    %r13,%rsi
  72aeae:	ff 15 c4 e7 3f 00    	call   *0x3fe7c4(%rip)        # b29678 <_DYNAMIC+0x508>
  72aeb4:	66 85 c0             	test   %ax,%ax
  72aeb7:	74 0c                	je     72aec5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x45>
  72aeb9:	48 89 c1             	mov    %rax,%rcx
  72aebc:	48 c1 e9 10          	shr    $0x10,%rcx
  72aec0:	e9 28 06 00 00       	jmp    72b4ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x66d>
  72aec5:	0f b7 c5             	movzwl %bp,%eax
  72aec8:	48 8d 0d d9 0a 3d 00 	lea    0x3d0ad9(%rip),%rcx        # afb9a8 <__frame_dummy_init_array_entry+0x10a0>
  72aecf:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  72aed4:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  72aed8:	74 78                	je     72af52 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xd2>
  72aeda:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  72aee1:	49 39 f7             	cmp    %rsi,%r15
  72aee4:	0f 83 d7 0b 00 00    	jae    72bac1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc41>
  72aeea:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  72aef1:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  72aef5:	4c 8b 3c c8          	mov    (%rax,%rcx,8),%r15
  72aef9:	4d 8b a6 10 06 00 00 	mov    0x610(%r14),%r12
  72af00:	4d 85 e4             	test   %r12,%r12
  72af03:	0f 84 d4 00 00 00    	je     72afdd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x15d>
  72af09:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72af10:	00 
  72af11:	48 85 ff             	test   %rdi,%rdi
  72af14:	0f 84 22 05 00 00    	je     72b43c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x5bc>
  72af1a:	4c 89 fe             	mov    %r15,%rsi
  72af1d:	ff 15 15 e8 3f 00    	call   *0x3fe815(%rip)        # b29738 <_DYNAMIC+0x5c8>
  72af23:	4d 8b a6 10 06 00 00 	mov    0x610(%r14),%r12
  72af2a:	66 0f 7e 84 24 e8 00 	movd   %xmm0,0xe8(%rsp)
  72af31:	00 00 
  72af33:	4d 85 e4             	test   %r12,%r12
  72af36:	0f 84 b0 00 00 00    	je     72afec <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x16c>
  72af3c:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72af43:	00 
  72af44:	48 85 ff             	test   %rdi,%rdi
  72af47:	0f 85 81 05 00 00    	jne    72b4ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x64e>
  72af4d:	e9 06 05 00 00       	jmp    72b458 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x5d8>
  72af52:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  72af59:	49 39 f7             	cmp    %rsi,%r15
  72af5c:	0f 83 6f 0b 00 00    	jae    72bad1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc51>
  72af62:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  72af69:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  72af6d:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  72af71:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  72af76:	49 8b 86 00 02 00 00 	mov    0x200(%r14),%rax
  72af7d:	48 8d 0d 34 0a 93 ff 	lea    -0x6cf5cc(%rip),%rcx        # 5b9b8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x148>
  72af84:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  72af88:	48 01 c8             	add    %rcx,%rax
  72af8b:	ff e0                	jmp    *%rax
  72af8d:	0f 10 05 cc 0b 93 ff 	movups -0x6cf434(%rip),%xmm0        # 5bb60 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2f0>
  72af94:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  72af99:	0f 10 05 b0 0b 93 ff 	movups -0x6cf450(%rip),%xmm0        # 5bb50 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e0>
  72afa0:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  72afa5:	0f 10 05 94 0b 93 ff 	movups -0x6cf46c(%rip),%xmm0        # 5bb40 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2d0>
  72afac:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  72afb1:	0f 10 05 78 0b 93 ff 	movups -0x6cf488(%rip),%xmm0        # 5bb30 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c0>
  72afb8:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  72afbd:	0f 10 05 5c 0b 93 ff 	movups -0x6cf4a4(%rip),%xmm0        # 5bb20 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2b0>
  72afc4:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  72afc9:	48 b8 00 00 00 00 01 	movabs $0x3000100000000,%rax
  72afd0:	00 03 00 
  72afd3:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  72afd8:	e9 81 01 00 00       	jmp    72b15e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x2de>
  72afdd:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  72afe4:	00 00 00 00 
  72afe8:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72afec:	66 0f 7e 44 24 70    	movd   %xmm0,0x70(%rsp)
  72aff2:	ff 15 d8 e3 3f 00    	call   *0x3fe3d8(%rip)        # b293d0 <_DYNAMIC+0x260>
  72aff8:	bf 08 01 00 00       	mov    $0x108,%edi
  72affd:	be 08 00 00 00       	mov    $0x8,%esi
  72b002:	ff 15 a8 e3 3f 00    	call   *0x3fe3a8(%rip)        # b293b0 <_DYNAMIC+0x240>
  72b008:	48 85 c0             	test   %rax,%rax
  72b00b:	0f 84 83 0a 00 00    	je     72ba94 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc14>
  72b011:	49 89 c4             	mov    %rax,%r12
  72b014:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72b018:	f3 0f 7f 80 d8 00 00 	movdqu %xmm0,0xd8(%rax)
  72b01f:	00 
  72b020:	f3 0f 7f 40 28       	movdqu %xmm0,0x28(%rax)
  72b025:	f3 0f 7f 40 40       	movdqu %xmm0,0x40(%rax)
  72b02a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  72b031:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  72b038:	00 
  72b039:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  72b040:	00 
  72b041:	48 c7 40 38 08 00 00 	movq   $0x8,0x38(%rax)
  72b048:	00 
  72b049:	48 c7 40 50 08 00 00 	movq   $0x8,0x50(%rax)
  72b050:	00 
  72b051:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  72b058:	00 
  72b059:	48 c7 40 60 ff ff ff 	movq   $0xffffffffffffffff,0x60(%rax)
  72b060:	ff 
  72b061:	48 c7 80 c0 00 00 00 	movq   $0x0,0xc0(%rax)
  72b068:	00 00 00 00 
  72b06c:	48 c7 80 c8 00 00 00 	movq   $0x8,0xc8(%rax)
  72b073:	08 00 00 00 
  72b077:	48 c7 80 d0 00 00 00 	movq   $0x0,0xd0(%rax)
  72b07e:	00 00 00 00 
  72b082:	48 c7 80 e8 00 00 00 	movq   $0x0,0xe8(%rax)
  72b089:	00 00 00 00 
  72b08d:	f3 0f 7f 80 f8 00 00 	movdqu %xmm0,0xf8(%rax)
  72b094:	00 
  72b095:	49 89 86 10 06 00 00 	mov    %rax,0x610(%r14)
  72b09c:	66 0f 6e 44 24 70    	movd   0x70(%rsp),%xmm0
  72b0a2:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72b0a9:	00 
  72b0aa:	48 85 ff             	test   %rdi,%rdi
  72b0ad:	0f 85 1b 04 00 00    	jne    72b4ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x64e>
  72b0b3:	e9 a0 03 00 00       	jmp    72b458 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x5d8>
  72b0b8:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  72b0bf:	49 39 f7             	cmp    %rsi,%r15
  72b0c2:	0f 83 19 0a 00 00    	jae    72bae1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc61>
  72b0c8:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  72b0cf:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  72b0d6:	42 0f b6 3c 38       	movzbl (%rax,%r15,1),%edi
  72b0db:	48 39 fe             	cmp    %rdi,%rsi
  72b0de:	0f 86 1d 0a 00 00    	jbe    72bb01 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc81>
  72b0e4:	49 8b 86 08 02 00 00 	mov    0x208(%r14),%rax
  72b0eb:	48 6b cf 58          	imul   $0x58,%rdi,%rcx
  72b0ef:	eb 32                	jmp    72b123 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x2a3>
  72b0f1:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  72b0f8:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  72b0fd:	4c 89 fa             	mov    %r15,%rdx
  72b100:	ff 15 a2 e3 3f 00    	call   *0x3fe3a2(%rip)        # b294a8 <_DYNAMIC+0x338>
  72b106:	eb 56                	jmp    72b15e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x2de>
  72b108:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  72b10f:	49 39 f7             	cmp    %rsi,%r15
  72b112:	0f 83 d9 09 00 00    	jae    72baf1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc71>
  72b118:	49 8b 86 10 02 00 00 	mov    0x210(%r14),%rax
  72b11f:	49 6b cf 58          	imul   $0x58,%r15,%rcx
  72b123:	48 8b 54 08 50       	mov    0x50(%rax,%rcx,1),%rdx
  72b128:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  72b12d:	0f 10 44 08 40       	movups 0x40(%rax,%rcx,1),%xmm0
  72b132:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  72b137:	0f 10 04 08          	movups (%rax,%rcx,1),%xmm0
  72b13b:	0f 10 4c 08 10       	movups 0x10(%rax,%rcx,1),%xmm1
  72b140:	0f 10 54 08 20       	movups 0x20(%rax,%rcx,1),%xmm2
  72b145:	0f 10 5c 08 30       	movups 0x30(%rax,%rcx,1),%xmm3
  72b14a:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
  72b14f:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  72b154:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  72b159:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  72b15e:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  72b165:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  72b16c:	00 
  72b16d:	4c 89 fa             	mov    %r15,%rdx
  72b170:	ff 15 22 e7 3f 00    	call   *0x3fe722(%rip)        # b29898 <_DYNAMIC+0x728>
  72b176:	80 bc 24 40 01 00 00 	cmpb   $0x0,0x140(%rsp)
  72b17d:	00 
  72b17e:	74 1a                	je     72b19a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x31a>
  72b180:	48 8d 94 24 44 01 00 	lea    0x144(%rsp),%rdx
  72b187:	00 
  72b188:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  72b18f:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  72b194:	ff 15 06 e7 3f 00    	call   *0x3fe706(%rip)        # b298a0 <_DYNAMIC+0x730>
  72b19a:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  72b1a1:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  72b1a6:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  72b1ad:	00 
  72b1ae:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
  72b1b3:	0f 29 84 24 80 01 00 	movaps %xmm0,0x180(%rsp)
  72b1ba:	00 
  72b1bb:	66 0f 6f 44 24 10    	movdqa 0x10(%rsp),%xmm0
  72b1c1:	66 0f 6f 4c 24 20    	movdqa 0x20(%rsp),%xmm1
  72b1c7:	0f 28 54 24 30       	movaps 0x30(%rsp),%xmm2
  72b1cc:	0f 28 5c 24 40       	movaps 0x40(%rsp),%xmm3
  72b1d1:	0f 29 9c 24 70 01 00 	movaps %xmm3,0x170(%rsp)
  72b1d8:	00 
  72b1d9:	0f 29 94 24 60 01 00 	movaps %xmm2,0x160(%rsp)
  72b1e0:	00 
  72b1e1:	66 0f 7f 8c 24 50 01 	movdqa %xmm1,0x150(%rsp)
  72b1e8:	00 00 
  72b1ea:	66 0f 7f 84 24 40 01 	movdqa %xmm0,0x140(%rsp)
  72b1f1:	00 00 
  72b1f3:	48 8d bc 24 a0 01 00 	lea    0x1a0(%rsp),%rdi
  72b1fa:	00 
  72b1fb:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  72b202:	00 
  72b203:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  72b208:	41 89 e8             	mov    %ebp,%r8d
  72b20b:	4d 89 e9             	mov    %r13,%r9
  72b20e:	e8 ed 3e 04 00       	call   76f100 <<gpui::property::Overrides>::set_value>
  72b213:	44 8b ac 24 a0 01 00 	mov    0x1a0(%rsp),%r13d
  72b21a:	00 
  72b21b:	41 83 fd 02          	cmp    $0x2,%r13d
  72b21f:	75 2b                	jne    72b24c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x3cc>
  72b221:	0f b7 84 24 a8 01 00 	movzwl 0x1a8(%rsp),%eax
  72b228:	00 
  72b229:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  72b22e:	8b 8c 24 a4 01 00 00 	mov    0x1a4(%rsp),%ecx
  72b235:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  72b239:	66 89 43 0c          	mov    %ax,0xc(%rbx)
  72b23d:	89 4b 08             	mov    %ecx,0x8(%rbx)
  72b240:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  72b247:	e9 36 08 00 00       	jmp    72ba82 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc02>
  72b24c:	45 31 c0             	xor    %r8d,%r8d
  72b24f:	41 80 fc ff          	cmp    $0xff,%r12b
  72b253:	41 0f 95 c0          	setne  %r8b
  72b257:	0f b7 84 24 a8 01 00 	movzwl 0x1a8(%rsp),%eax
  72b25e:	00 
  72b25f:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  72b264:	8b 8c 24 a4 01 00 00 	mov    0x1a4(%rsp),%ecx
  72b26b:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  72b26f:	0f 10 84 24 aa 01 00 	movups 0x1aa(%rsp),%xmm0
  72b276:	00 
  72b277:	0f 11 84 24 f2 00 00 	movups %xmm0,0xf2(%rsp)
  72b27e:	00 
  72b27f:	0f 10 84 24 ba 01 00 	movups 0x1ba(%rsp),%xmm0
  72b286:	00 
  72b287:	0f 11 84 24 02 01 00 	movups %xmm0,0x102(%rsp)
  72b28e:	00 
  72b28f:	0f 10 84 24 ca 01 00 	movups 0x1ca(%rsp),%xmm0
  72b296:	00 
  72b297:	0f 11 84 24 12 01 00 	movups %xmm0,0x112(%rsp)
  72b29e:	00 
  72b29f:	0f 10 84 24 da 01 00 	movups 0x1da(%rsp),%xmm0
  72b2a6:	00 
  72b2a7:	0f 11 84 24 22 01 00 	movups %xmm0,0x122(%rsp)
  72b2ae:	00 
  72b2af:	0f 10 84 24 e8 01 00 	movups 0x1e8(%rsp),%xmm0
  72b2b6:	00 
  72b2b7:	0f 11 84 24 30 01 00 	movups %xmm0,0x130(%rsp)
  72b2be:	00 
  72b2bf:	44 89 ac 24 e8 00 00 	mov    %r13d,0xe8(%rsp)
  72b2c6:	00 
  72b2c7:	66 89 84 24 f0 00 00 	mov    %ax,0xf0(%rsp)
  72b2ce:	00 
  72b2cf:	89 8c 24 ec 00 00 00 	mov    %ecx,0xec(%rsp)
  72b2d6:	0f 10 84 24 28 01 00 	movups 0x128(%rsp),%xmm0
  72b2dd:	00 
  72b2de:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  72b2e5:	00 
  72b2e6:	0f 10 84 24 18 01 00 	movups 0x118(%rsp),%xmm0
  72b2ed:	00 
  72b2ee:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  72b2f5:	00 
  72b2f6:	0f 10 84 24 08 01 00 	movups 0x108(%rsp),%xmm0
  72b2fd:	00 
  72b2fe:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  72b305:	00 
  72b306:	0f 10 84 24 f8 00 00 	movups 0xf8(%rsp),%xmm0
  72b30d:	00 
  72b30e:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  72b315:	00 
  72b316:	0f 10 84 24 e8 00 00 	movups 0xe8(%rsp),%xmm0
  72b31d:	00 
  72b31e:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  72b325:	00 
  72b326:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  72b32d:	00 
  72b32e:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  72b335:	00 
  72b336:	4d 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%r9
  72b33d:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
  72b344:	00 
  72b345:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  72b34c:	00 
  72b34d:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  72b354:	00 
  72b355:	f3 0f 6f 84 24 f8 00 	movdqu 0xf8(%rsp),%xmm0
  72b35c:	00 00 
  72b35e:	f3 0f 6f 8c 24 08 01 	movdqu 0x108(%rsp),%xmm1
  72b365:	00 00 
  72b367:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  72b36e:	00 
  72b36f:	0f 10 9c 24 28 01 00 	movups 0x128(%rsp),%xmm3
  72b376:	00 
  72b377:	0f 29 9c 24 80 01 00 	movaps %xmm3,0x180(%rsp)
  72b37e:	00 
  72b37f:	0f 29 94 24 70 01 00 	movaps %xmm2,0x170(%rsp)
  72b386:	00 
  72b387:	66 0f 7f 8c 24 60 01 	movdqa %xmm1,0x160(%rsp)
  72b38e:	00 00 
  72b390:	66 0f 7f 84 24 50 01 	movdqa %xmm0,0x150(%rsp)
  72b397:	00 00 
  72b399:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  72b3a0:	00 
  72b3a1:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  72b3a8:	4c 89 fe             	mov    %r15,%rsi
  72b3ab:	89 ea                	mov    %ebp,%edx
  72b3ad:	ff 15 f5 e4 3f 00    	call   *0x3fe4f5(%rip)        # b298a8 <_DYNAMIC+0x738>
  72b3b3:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  72b3ba:	8b 6c 24 10          	mov    0x10(%rsp),%ebp
  72b3be:	44 0f b6 a4 24 90 00 	movzbl 0x90(%rsp),%r12d
  72b3c5:	00 00 
  72b3c7:	83 fd 01             	cmp    $0x1,%ebp
  72b3ca:	75 25                	jne    72b3f1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x571>
  72b3cc:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  72b3d3:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  72b3d7:	39 c1                	cmp    %eax,%ecx
  72b3d9:	0f 94 c2             	sete   %dl
  72b3dc:	41 84 d4             	test   %dl,%r12b
  72b3df:	75 26                	jne    72b407 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x587>
  72b3e1:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  72b3e8:	01 00 00 00 
  72b3ec:	e9 78 03 00 00       	jmp    72b769 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8e9>
  72b3f1:	41 f6 c4 01          	test   $0x1,%r12b
  72b3f5:	74 10                	je     72b407 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x587>
  72b3f7:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  72b3fe:	01 00 00 00 
  72b402:	e9 76 04 00 00       	jmp    72b87d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b407:	8b 54 24 18          	mov    0x18(%rsp),%edx
  72b40b:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  72b412:	00 
  72b413:	83 fa 01             	cmp    $0x1,%edx
  72b416:	0f 85 27 02 00 00    	jne    72b643 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x7c3>
  72b41c:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  72b423:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  72b427:	0f 94 c0             	sete   %al
  72b42a:	be 01 00 00 00       	mov    $0x1,%esi
  72b42f:	84 c1                	test   %al,%cl
  72b431:	0f 85 1a 02 00 00    	jne    72b651 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x7d1>
  72b437:	e9 15 03 00 00       	jmp    72b751 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b43c:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  72b443:	00 00 00 00 
  72b447:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72b44b:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72b452:	00 
  72b453:	48 85 ff             	test   %rdi,%rdi
  72b456:	75 76                	jne    72b4ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x64e>
  72b458:	66 0f 7e 44 24 70    	movd   %xmm0,0x70(%rsp)
  72b45e:	ff 15 6c df 3f 00    	call   *0x3fdf6c(%rip)        # b293d0 <_DYNAMIC+0x260>
  72b464:	bf 60 00 00 00       	mov    $0x60,%edi
  72b469:	be 08 00 00 00       	mov    $0x8,%esi
  72b46e:	ff 15 3c df 3f 00    	call   *0x3fdf3c(%rip)        # b293b0 <_DYNAMIC+0x240>
  72b474:	48 85 c0             	test   %rax,%rax
  72b477:	0f 84 27 06 00 00    	je     72baa4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc24>
  72b47d:	48 89 c7             	mov    %rax,%rdi
  72b480:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72b484:	f3 0f 7f 40 10       	movdqu %xmm0,0x10(%rax)
  72b489:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  72b490:	48 c7 40 08 08 00 00 	movq   $0x8,0x8(%rax)
  72b497:	00 
  72b498:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  72b49f:	00 
  72b4a0:	48 c7 40 28 00 00 00 	movq   $0x0,0x28(%rax)
  72b4a7:	00 
  72b4a8:	48 c7 40 30 ff ff ff 	movq   $0xffffffffffffffff,0x30(%rax)
  72b4af:	ff 
  72b4b0:	48 c7 40 48 00 00 00 	movq   $0x0,0x48(%rax)
  72b4b7:	00 
  72b4b8:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  72b4bf:	00 
  72b4c0:	49 89 84 24 00 01 00 	mov    %rax,0x100(%r12)
  72b4c7:	00 
  72b4c8:	66 0f 6e 44 24 70    	movd   0x70(%rsp),%xmm0
  72b4ce:	48 83 c7 48          	add    $0x48,%rdi
  72b4d2:	4c 89 fe             	mov    %r15,%rsi
  72b4d5:	89 ea                	mov    %ebp,%edx
  72b4d7:	4c 89 e9             	mov    %r13,%rcx
  72b4da:	e8 a1 33 04 00       	call   76e880 <<gpui::property::Overrides<gpui::property::GeometryStyle>>::set_value>
  72b4df:	48 89 c1             	mov    %rax,%rcx
  72b4e2:	48 c1 e9 20          	shr    $0x20,%rcx
  72b4e6:	a8 01                	test   $0x1,%al
  72b4e8:	74 16                	je     72b500 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x680>
  72b4ea:	c1 e8 10             	shr    $0x10,%eax
  72b4ed:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  72b4f4:	66 89 43 08          	mov    %ax,0x8(%rbx)
  72b4f8:	89 4b 0a             	mov    %ecx,0xa(%rbx)
  72b4fb:	e9 82 05 00 00       	jmp    72ba82 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc02>
  72b500:	66 0f 6e c1          	movd   %ecx,%xmm0
  72b504:	89 8c 24 40 01 00 00 	mov    %ecx,0x140(%rsp)
  72b50b:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72b512:	00 
  72b513:	4c 89 fe             	mov    %r15,%rsi
  72b516:	ff 15 94 e3 3f 00    	call   *0x3fe394(%rip)        # b298b0 <_DYNAMIC+0x740>
  72b51c:	49 8b 84 24 00 01 00 	mov    0x100(%r12),%rax
  72b523:	00 
  72b524:	48 83 78 10 00       	cmpq   $0x0,0x10(%rax)
  72b529:	75 3a                	jne    72b565 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x6e5>
  72b52b:	48 83 78 58 00       	cmpq   $0x0,0x58(%rax)
  72b530:	75 33                	jne    72b565 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x6e5>
  72b532:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  72b537:	75 2c                	jne    72b565 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x6e5>
  72b539:	48 83 78 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rax)
  72b53e:	75 25                	jne    72b565 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x6e5>
  72b540:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72b547:	48 8b b8 00 01 00 00 	mov    0x100(%rax),%rdi
  72b54e:	e8 4d 91 fc ff       	call   6f46a0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::geometry::Geometry>>>>
  72b553:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72b55a:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  72b561:	00 00 00 00 
  72b565:	48 8b 05 fc df 3f 00 	mov    0x3fdffc(%rip),%rax        # b29568 <_DYNAMIC+0x3f8>
  72b56c:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  72b573:	00 
  72b574:	48 8d b4 24 40 01 00 	lea    0x140(%rsp),%rsi
  72b57b:	00 
  72b57c:	ff 50 18             	call   *0x18(%rax)
  72b57f:	34 01                	xor    $0x1,%al
  72b581:	0f b6 c0             	movzbl %al,%eax
  72b584:	49 89 86 08 07 00 00 	mov    %rax,0x708(%r14)
  72b58b:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  72b592:	4d 8b be 10 06 00 00 	mov    0x610(%r14),%r15
  72b599:	4d 85 ff             	test   %r15,%r15
  72b59c:	0f 84 d9 04 00 00    	je     72ba7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b5a2:	49 83 bf d8 00 00 00 	cmpq   $0x0,0xd8(%r15)
  72b5a9:	00 
  72b5aa:	0f 85 cb 04 00 00    	jne    72ba7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b5b0:	49 83 bf e0 00 00 00 	cmpq   $0x0,0xe0(%r15)
  72b5b7:	00 
  72b5b8:	0f 85 bd 04 00 00    	jne    72ba7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b5be:	49 83 bf 00 01 00 00 	cmpq   $0x0,0x100(%r15)
  72b5c5:	00 
  72b5c6:	0f 85 af 04 00 00    	jne    72ba7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b5cc:	49 83 bf d0 00 00 00 	cmpq   $0x0,0xd0(%r15)
  72b5d3:	00 
  72b5d4:	0f 85 a1 04 00 00    	jne    72ba7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b5da:	49 83 bf f8 00 00 00 	cmpq   $0x0,0xf8(%r15)
  72b5e1:	00 
  72b5e2:	0f 85 93 04 00 00    	jne    72ba7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b5e8:	49 8b 47 60          	mov    0x60(%r15),%rax
  72b5ec:	83 f8 ff             	cmp    $0xffffffff,%eax
  72b5ef:	0f 85 86 04 00 00    	jne    72ba7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b5f5:	49 83 7f 28 00       	cmpq   $0x0,0x28(%r15)
  72b5fa:	0f 85 7b 04 00 00    	jne    72ba7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b600:	49 8b 07             	mov    (%r15),%rax
  72b603:	49 0b 47 40          	or     0x40(%r15),%rax
  72b607:	0f 85 6e 04 00 00    	jne    72ba7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b60d:	49 83 7f 58 00       	cmpq   $0x0,0x58(%r15)
  72b612:	0f 85 63 04 00 00    	jne    72ba7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b618:	4c 89 ff             	mov    %r15,%rdi
  72b61b:	e8 40 dd fc ff       	call   6f9360 <core::ptr::drop_glue::<gpui::runtime::metadata::Metadata>>
  72b620:	be 08 01 00 00       	mov    $0x108,%esi
  72b625:	ba 08 00 00 00       	mov    $0x8,%edx
  72b62a:	4c 89 ff             	mov    %r15,%rdi
  72b62d:	ff 15 85 dd 3f 00    	call   *0x3fdd85(%rip)        # b293b8 <_DYNAMIC+0x248>
  72b633:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  72b63a:	00 00 00 00 
  72b63e:	e9 38 04 00 00       	jmp    72ba7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b643:	be 01 00 00 00       	mov    $0x1,%esi
  72b648:	f6 c1 01             	test   $0x1,%cl
  72b64b:	0f 85 00 01 00 00    	jne    72b751 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b651:	8b 44 24 20          	mov    0x20(%rsp),%eax
  72b655:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  72b65c:	0f 85 ef 00 00 00    	jne    72b751 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b662:	8b 44 24 24          	mov    0x24(%rsp),%eax
  72b666:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  72b66d:	0f 85 de 00 00 00    	jne    72b751 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b673:	8b 44 24 28          	mov    0x28(%rsp),%eax
  72b677:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  72b67e:	0f 85 cd 00 00 00    	jne    72b751 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b684:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  72b689:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  72b690:	0f 85 bb 00 00 00    	jne    72b751 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b696:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  72b69b:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  72b6a2:	0f 85 a9 00 00 00    	jne    72b751 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b6a8:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  72b6ad:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  72b6b4:	0f 85 97 00 00 00    	jne    72b751 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b6ba:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  72b6bf:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  72b6c6:	0f 85 85 00 00 00    	jne    72b751 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b6cc:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  72b6d0:	88 8c 24 80 00 00 00 	mov    %cl,0x80(%rsp)
  72b6d7:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  72b6dc:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  72b6e3:	00 
  72b6e4:	e8 37 08 00 00       	call   72bf20 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  72b6e9:	84 c0                	test   %al,%al
  72b6eb:	74 53                	je     72b740 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8c0>
  72b6ed:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  72b6f3:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  72b6fa:	00 00 
  72b6fc:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72b700:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72b704:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72b709:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  72b710:	00 
  72b711:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  72b715:	be 01 00 00 00       	mov    $0x1,%esi
  72b71a:	75 35                	jne    72b751 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b71c:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  72b722:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  72b729:	00 00 
  72b72b:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72b72f:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72b733:	31 f6                	xor    %esi,%esi
  72b735:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72b73a:	40 0f 95 c6          	setne  %sil
  72b73e:	eb 11                	jmp    72b751 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b740:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  72b747:	00 
  72b748:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  72b74c:	be 01 00 00 00       	mov    $0x1,%esi
  72b751:	49 89 b6 08 07 00 00 	mov    %rsi,0x708(%r14)
  72b758:	40 f6 c5 01          	test   $0x1,%bpl
  72b75c:	74 2b                	je     72b789 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x909>
  72b75e:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  72b765:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  72b769:	39 c1                	cmp    %eax,%ecx
  72b76b:	0f 94 c0             	sete   %al
  72b76e:	41 20 c4             	and    %al,%r12b
  72b771:	41 80 fc 01          	cmp    $0x1,%r12b
  72b775:	0f 85 02 01 00 00    	jne    72b87d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b77b:	8b 54 24 18          	mov    0x18(%rsp),%edx
  72b77f:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  72b786:	00 
  72b787:	eb 0a                	jmp    72b793 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x913>
  72b789:	41 f6 c4 01          	test   $0x1,%r12b
  72b78d:	0f 85 ea 00 00 00    	jne    72b87d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b793:	83 fa 01             	cmp    $0x1,%edx
  72b796:	75 17                	jne    72b7af <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x92f>
  72b798:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  72b79f:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  72b7a3:	0f 94 c0             	sete   %al
  72b7a6:	84 c1                	test   %al,%cl
  72b7a8:	75 0e                	jne    72b7b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x938>
  72b7aa:	e9 ce 00 00 00       	jmp    72b87d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b7af:	f6 c1 01             	test   $0x1,%cl
  72b7b2:	0f 85 c5 00 00 00    	jne    72b87d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b7b8:	8b 44 24 20          	mov    0x20(%rsp),%eax
  72b7bc:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  72b7c3:	0f 85 b4 00 00 00    	jne    72b87d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b7c9:	8b 44 24 24          	mov    0x24(%rsp),%eax
  72b7cd:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  72b7d4:	0f 85 a3 00 00 00    	jne    72b87d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b7da:	8b 44 24 28          	mov    0x28(%rsp),%eax
  72b7de:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  72b7e5:	0f 85 92 00 00 00    	jne    72b87d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b7eb:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  72b7f0:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  72b7f7:	0f 85 80 00 00 00    	jne    72b87d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b7fd:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  72b802:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  72b809:	75 72                	jne    72b87d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b80b:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  72b810:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  72b817:	75 64                	jne    72b87d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b819:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  72b81e:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  72b825:	75 56                	jne    72b87d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b827:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  72b82c:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  72b833:	00 
  72b834:	e8 e7 06 00 00       	call   72bf20 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  72b839:	84 c0                	test   %al,%al
  72b83b:	74 40                	je     72b87d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b83d:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  72b843:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  72b84a:	00 00 
  72b84c:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72b850:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72b854:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72b859:	75 22                	jne    72b87d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b85b:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  72b861:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  72b868:	00 00 
  72b86a:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72b86e:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72b872:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72b877:	0f 84 fe 01 00 00    	je     72ba7b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b87d:	45 89 e8             	mov    %r13d,%r8d
  72b880:	44 8b 64 24 18       	mov    0x18(%rsp),%r12d
  72b885:	0f b6 7c 24 64       	movzbl 0x64(%rsp),%edi
  72b88a:	44 0f b6 6c 24 65    	movzbl 0x65(%rsp),%r13d
  72b890:	0f b6 4c 24 66       	movzbl 0x66(%rsp),%ecx
  72b895:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  72b89a:	88 84 24 80 00 00 00 	mov    %al,0x80(%rsp)
  72b8a1:	8b b4 24 f0 00 00 00 	mov    0xf0(%rsp),%esi
  72b8a8:	0f 10 5c 24 1c       	movups 0x1c(%rsp),%xmm3
  72b8ad:	f3 0f 10 44 24 20    	movss  0x20(%rsp),%xmm0
  72b8b3:	0f 10 a4 24 f4 00 00 	movups 0xf4(%rsp),%xmm4
  72b8ba:	00 
  72b8bb:	f3 0f 10 8c 24 f8 00 	movss  0xf8(%rsp),%xmm1
  72b8c2:	00 00 
  72b8c4:	44 0f b6 9c 24 3c 01 	movzbl 0x13c(%rsp),%r11d
  72b8cb:	00 00 
  72b8cd:	44 0f b6 8c 24 3d 01 	movzbl 0x13d(%rsp),%r9d
  72b8d4:	00 00 
  72b8d6:	0f b6 84 24 3e 01 00 	movzbl 0x13e(%rsp),%eax
  72b8dd:	00 
  72b8de:	44 0f b6 94 24 3f 01 	movzbl 0x13f(%rsp),%r10d
  72b8e5:	00 00 
  72b8e7:	40 f6 c5 01          	test   $0x1,%bpl
  72b8eb:	74 22                	je     72b90f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xa8f>
  72b8ed:	f3 0f 10 54 24 14    	movss  0x14(%rsp),%xmm2
  72b8f3:	0f 2e 94 24 ec 00 00 	ucomiss 0xec(%rsp),%xmm2
  72b8fa:	00 
  72b8fb:	40 0f 9b c5          	setnp  %bpl
  72b8ff:	0f 94 c2             	sete   %dl
  72b902:	40 20 ea             	and    %bpl,%dl
  72b905:	41 84 d0             	test   %dl,%r8b
  72b908:	75 0f                	jne    72b919 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xa99>
  72b90a:	e9 a4 00 00 00       	jmp    72b9b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xb33>
  72b90f:	41 f6 c0 01          	test   $0x1,%r8b
  72b913:	0f 85 9a 00 00 00    	jne    72b9b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xb33>
  72b919:	41 83 fc 01          	cmp    $0x1,%r12d
  72b91d:	75 3c                	jne    72b95b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xadb>
  72b91f:	44 30 df             	xor    %r11b,%dil
  72b922:	30 c1                	xor    %al,%cl
  72b924:	0f b6 84 24 80 00 00 	movzbl 0x80(%rsp),%eax
  72b92b:	00 
  72b92c:	44 30 d0             	xor    %r10b,%al
  72b92f:	45 38 cd             	cmp    %r9b,%r13b
  72b932:	0f 94 c2             	sete   %dl
  72b935:	0f 28 c3             	movaps %xmm3,%xmm0
  72b938:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  72b93c:	44 0f 50 c0          	movmskps %xmm0,%r8d
  72b940:	41 80 f0 0f          	xor    $0xf,%r8b
  72b944:	40 08 f9             	or     %dil,%cl
  72b947:	44 08 c1             	or     %r8b,%cl
  72b94a:	08 c1                	or     %al,%cl
  72b94c:	0f 94 c0             	sete   %al
  72b94f:	40 20 f0             	and    %sil,%al
  72b952:	84 d0                	test   %dl,%al
  72b954:	74 5d                	je     72b9b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xb33>
  72b956:	e9 83 00 00 00       	jmp    72b9de <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xb5e>
  72b95b:	0f 2e c1             	ucomiss %xmm1,%xmm0
  72b95e:	0f 9b c2             	setnp  %dl
  72b961:	40 0f 94 c5          	sete   %bpl
  72b965:	40 20 d5             	and    %dl,%bpl
  72b968:	40 f6 d6             	not    %sil
  72b96b:	40 20 ee             	and    %bpl,%sil
  72b96e:	0f 28 c3             	movaps %xmm3,%xmm0
  72b971:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  72b975:	0f 50 d0             	movmskps %xmm0,%edx
  72b978:	89 d5                	mov    %edx,%ebp
  72b97a:	40 c0 ed 03          	shr    $0x3,%bpl
  72b97e:	c0 ea 02             	shr    $0x2,%dl
  72b981:	40 20 f2             	and    %sil,%dl
  72b984:	44 38 df             	cmp    %r11b,%dil
  72b987:	40 0f 94 c6          	sete   %sil
  72b98b:	40 20 ee             	and    %bpl,%sil
  72b98e:	40 20 d6             	and    %dl,%sil
  72b991:	38 c1                	cmp    %al,%cl
  72b993:	0f 94 c1             	sete   %cl
  72b996:	44 38 94 24 80 00 00 	cmp    %r10b,0x80(%rsp)
  72b99d:	00 
  72b99e:	0f 94 c0             	sete   %al
  72b9a1:	20 c8                	and    %cl,%al
  72b9a3:	45 38 cd             	cmp    %r9b,%r13b
  72b9a6:	0f 94 c1             	sete   %cl
  72b9a9:	20 c1                	and    %al,%cl
  72b9ab:	40 20 f1             	and    %sil,%cl
  72b9ae:	80 f9 01             	cmp    $0x1,%cl
  72b9b1:	74 2b                	je     72b9de <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xb5e>
  72b9b3:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  72b9ba:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  72b9bf:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
  72b9c4:	0f 29 a4 24 80 00 00 	movaps %xmm4,0x80(%rsp)
  72b9cb:	00 
  72b9cc:	e8 af 9b 01 00       	call   745580 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  72b9d1:	0f 28 a4 24 80 00 00 	movaps 0x80(%rsp),%xmm4
  72b9d8:	00 
  72b9d9:	0f 28 5c 24 70       	movaps 0x70(%rsp),%xmm3
  72b9de:	0f c2 dc 04          	cmpneqps %xmm4,%xmm3
  72b9e2:	66 0f c5 c3 06       	pextrw $0x6,%xmm3,%eax
  72b9e7:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  72b9ee:	a8 01                	test   $0x1,%al
  72b9f0:	74 69                	je     72ba5b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbdb>
  72b9f2:	49 39 cf             	cmp    %rcx,%r15
  72b9f5:	0f 83 13 01 00 00    	jae    72bb0e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc8e>
  72b9fb:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  72ba02:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  72ba06:	8b 7c d0 20          	mov    0x20(%rax,%rdx,8),%edi
  72ba0a:	89 f8                	mov    %edi,%eax
  72ba0c:	83 e0 07             	and    $0x7,%eax
  72ba0f:	83 f8 06             	cmp    $0x6,%eax
  72ba12:	74 47                	je     72ba5b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbdb>
  72ba14:	c1 ef 03             	shr    $0x3,%edi
  72ba17:	74 42                	je     72ba5b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbdb>
  72ba19:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  72ba20:	ff cf                	dec    %edi
  72ba22:	48 39 fe             	cmp    %rdi,%rsi
  72ba25:	0f 86 f6 00 00 00    	jbe    72bb21 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xca1>
  72ba2b:	4d 8b a6 b0 02 00 00 	mov    0x2b0(%r14),%r12
  72ba32:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  72ba36:	48 c1 e0 04          	shl    $0x4,%rax
  72ba3a:	49 83 3c 04 fe       	cmpq   $0xfffffffffffffffe,(%r12,%rax,1)
  72ba3f:	74 73                	je     72bab4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc34>
  72ba41:	49 01 c4             	add    %rax,%r12
  72ba44:	4c 89 e7             	mov    %r12,%rdi
  72ba47:	e8 84 8f fc ff       	call   6f49d0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  72ba4c:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  72ba53:	ff 
  72ba54:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  72ba5b:	48 8d 94 24 e8 00 00 	lea    0xe8(%rsp),%rdx
  72ba62:	00 
  72ba63:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  72ba6a:	4c 89 fe             	mov    %r15,%rsi
  72ba6d:	ff 15 35 db 3f 00    	call   *0x3fdb35(%rip)        # b295a8 <_DYNAMIC+0x438>
  72ba73:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  72ba7a:	01 
  72ba7b:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  72ba82:	48 81 c4 f8 01 00 00 	add    $0x1f8,%rsp
  72ba89:	5b                   	pop    %rbx
  72ba8a:	41 5c                	pop    %r12
  72ba8c:	41 5d                	pop    %r13
  72ba8e:	41 5e                	pop    %r14
  72ba90:	41 5f                	pop    %r15
  72ba92:	5d                   	pop    %rbp
  72ba93:	c3                   	ret
  72ba94:	bf 08 00 00 00       	mov    $0x8,%edi
  72ba99:	be 08 01 00 00       	mov    $0x108,%esi
  72ba9e:	ff 15 3c d9 3f 00    	call   *0x3fd93c(%rip)        # b293e0 <_DYNAMIC+0x270>
  72baa4:	bf 08 00 00 00       	mov    $0x8,%edi
  72baa9:	be 60 00 00 00       	mov    $0x60,%esi
  72baae:	ff 15 2c d9 3f 00    	call   *0x3fd92c(%rip)        # b293e0 <_DYNAMIC+0x270>
  72bab4:	48 8d 3d cd ef 3c 00 	lea    0x3cefcd(%rip),%rdi        # afaa88 <__frame_dummy_init_array_entry+0x180>
  72babb:	ff 15 b7 d9 3f 00    	call   *0x3fd9b7(%rip)        # b29478 <_DYNAMIC+0x308>
  72bac1:	48 8d 15 30 f5 3c 00 	lea    0x3cf530(%rip),%rdx        # afaff8 <__frame_dummy_init_array_entry+0x6f0>
  72bac8:	4c 89 ff             	mov    %r15,%rdi
  72bacb:	ff 15 f7 d9 3f 00    	call   *0x3fd9f7(%rip)        # b294c8 <_DYNAMIC+0x358>
  72bad1:	48 8d 15 f8 fb 3c 00 	lea    0x3cfbf8(%rip),%rdx        # afb6d0 <__frame_dummy_init_array_entry+0xdc8>
  72bad8:	4c 89 ff             	mov    %r15,%rdi
  72badb:	ff 15 e7 d9 3f 00    	call   *0x3fd9e7(%rip)        # b294c8 <_DYNAMIC+0x358>
  72bae1:	48 8d 15 28 f3 3c 00 	lea    0x3cf328(%rip),%rdx        # afae10 <__frame_dummy_init_array_entry+0x508>
  72bae8:	4c 89 ff             	mov    %r15,%rdi
  72baeb:	ff 15 d7 d9 3f 00    	call   *0x3fd9d7(%rip)        # b294c8 <_DYNAMIC+0x358>
  72baf1:	48 8d 15 00 f3 3c 00 	lea    0x3cf300(%rip),%rdx        # afadf8 <__frame_dummy_init_array_entry+0x4f0>
  72baf8:	4c 89 ff             	mov    %r15,%rdi
  72bafb:	ff 15 c7 d9 3f 00    	call   *0x3fd9c7(%rip)        # b294c8 <_DYNAMIC+0x358>
  72bb01:	48 8d 15 20 f3 3c 00 	lea    0x3cf320(%rip),%rdx        # afae28 <__frame_dummy_init_array_entry+0x520>
  72bb08:	ff 15 ba d9 3f 00    	call   *0x3fd9ba(%rip)        # b294c8 <_DYNAMIC+0x358>
  72bb0e:	48 8d 15 d3 fb 3c 00 	lea    0x3cfbd3(%rip),%rdx        # afb6e8 <__frame_dummy_init_array_entry+0xde0>
  72bb15:	4c 89 ff             	mov    %r15,%rdi
  72bb18:	48 89 ce             	mov    %rcx,%rsi
  72bb1b:	ff 15 a7 d9 3f 00    	call   *0x3fd9a7(%rip)        # b294c8 <_DYNAMIC+0x358>
  72bb21:	48 8d 15 48 ef 3c 00 	lea    0x3cef48(%rip),%rdx        # afaa70 <__frame_dummy_init_array_entry+0x168>
  72bb28:	ff 15 9a d9 3f 00    	call   *0x3fd99a(%rip)        # b294c8 <_DYNAMIC+0x358>
  72bb2e:	48 89 c3             	mov    %rax,%rbx
  72bb31:	be 08 01 00 00       	mov    $0x108,%esi
  72bb36:	ba 08 00 00 00       	mov    $0x8,%edx
  72bb3b:	4c 89 ff             	mov    %r15,%rdi
  72bb3e:	ff 15 74 d8 3f 00    	call   *0x3fd874(%rip)        # b293b8 <_DYNAMIC+0x248>
  72bb44:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  72bb4b:	00 00 00 00 
  72bb4f:	48 89 df             	mov    %rbx,%rdi
  72bb52:	e8 f9 d9 3c 00       	call   af9550 <_Unwind_Resume@plt>
  72bb57:	48 89 c3             	mov    %rax,%rbx
  72bb5a:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72bb61:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  72bb68:	00 00 00 00 
  72bb6c:	48 89 df             	mov    %rbx,%rdi
  72bb6f:	e8 dc d9 3c 00       	call   af9550 <_Unwind_Resume@plt>
  72bb74:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  72bb7b:	ff 
  72bb7c:	48 89 c7             	mov    %rax,%rdi
  72bb7f:	e8 cc d9 3c 00       	call   af9550 <_Unwind_Resume@plt>
