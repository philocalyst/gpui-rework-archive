
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000072ad80 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at>:
  72ad80:	55                   	push   %rbp
  72ad81:	41 57                	push   %r15
  72ad83:	41 56                	push   %r14
  72ad85:	41 55                	push   %r13
  72ad87:	41 54                	push   %r12
  72ad89:	53                   	push   %rbx
  72ad8a:	48 81 ec f8 01 00 00 	sub    $0x1f8,%rsp
  72ad91:	4d 89 c5             	mov    %r8,%r13
  72ad94:	89 cd                	mov    %ecx,%ebp
  72ad96:	49 89 d7             	mov    %rdx,%r15
  72ad99:	49 89 f6             	mov    %rsi,%r14
  72ad9c:	48 89 fb             	mov    %rdi,%rbx
  72ad9f:	45 0f b6 20          	movzbl (%r8),%r12d
  72ada3:	41 80 fc ff          	cmp    $0xff,%r12b
  72ada7:	74 1c                	je     72adc5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x45>
  72ada9:	89 ef                	mov    %ebp,%edi
  72adab:	4c 89 ee             	mov    %r13,%rsi
  72adae:	ff 15 dc e7 3f 00    	call   *0x3fe7dc(%rip)        # b29590 <_DYNAMIC+0x508>
  72adb4:	66 85 c0             	test   %ax,%ax
  72adb7:	74 0c                	je     72adc5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x45>
  72adb9:	48 89 c1             	mov    %rax,%rcx
  72adbc:	48 c1 e9 10          	shr    $0x10,%rcx
  72adc0:	e9 28 06 00 00       	jmp    72b3ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x66d>
  72adc5:	0f b7 c5             	movzwl %bp,%eax
  72adc8:	48 8d 0d 39 0b 3d 00 	lea    0x3d0b39(%rip),%rcx        # afb908 <__frame_dummy_init_array_entry+0x10a0>
  72adcf:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  72add4:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  72add8:	74 78                	je     72ae52 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xd2>
  72adda:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  72ade1:	49 39 f7             	cmp    %rsi,%r15
  72ade4:	0f 83 d7 0b 00 00    	jae    72b9c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc41>
  72adea:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  72adf1:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  72adf5:	4c 8b 3c c8          	mov    (%rax,%rcx,8),%r15
  72adf9:	4d 8b a6 10 06 00 00 	mov    0x610(%r14),%r12
  72ae00:	4d 85 e4             	test   %r12,%r12
  72ae03:	0f 84 d4 00 00 00    	je     72aedd <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x15d>
  72ae09:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72ae10:	00 
  72ae11:	48 85 ff             	test   %rdi,%rdi
  72ae14:	0f 84 22 05 00 00    	je     72b33c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x5bc>
  72ae1a:	4c 89 fe             	mov    %r15,%rsi
  72ae1d:	ff 15 2d e8 3f 00    	call   *0x3fe82d(%rip)        # b29650 <_DYNAMIC+0x5c8>
  72ae23:	4d 8b a6 10 06 00 00 	mov    0x610(%r14),%r12
  72ae2a:	66 0f 7e 84 24 e8 00 	movd   %xmm0,0xe8(%rsp)
  72ae31:	00 00 
  72ae33:	4d 85 e4             	test   %r12,%r12
  72ae36:	0f 84 b0 00 00 00    	je     72aeec <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x16c>
  72ae3c:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72ae43:	00 
  72ae44:	48 85 ff             	test   %rdi,%rdi
  72ae47:	0f 85 81 05 00 00    	jne    72b3ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x64e>
  72ae4d:	e9 06 05 00 00       	jmp    72b358 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x5d8>
  72ae52:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  72ae59:	49 39 f7             	cmp    %rsi,%r15
  72ae5c:	0f 83 6f 0b 00 00    	jae    72b9d1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc51>
  72ae62:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  72ae69:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  72ae6d:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  72ae71:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  72ae76:	49 8b 86 00 02 00 00 	mov    0x200(%r14),%rax
  72ae7d:	48 8d 0d c4 0a 93 ff 	lea    -0x6cf53c(%rip),%rcx        # 5b948 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x148>
  72ae84:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  72ae88:	48 01 c8             	add    %rcx,%rax
  72ae8b:	ff e0                	jmp    *%rax
  72ae8d:	0f 10 05 5c 0c 93 ff 	movups -0x6cf3a4(%rip),%xmm0        # 5baf0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2f0>
  72ae94:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  72ae99:	0f 10 05 40 0c 93 ff 	movups -0x6cf3c0(%rip),%xmm0        # 5bae0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e0>
  72aea0:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  72aea5:	0f 10 05 24 0c 93 ff 	movups -0x6cf3dc(%rip),%xmm0        # 5bad0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2d0>
  72aeac:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  72aeb1:	0f 10 05 08 0c 93 ff 	movups -0x6cf3f8(%rip),%xmm0        # 5bac0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c0>
  72aeb8:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  72aebd:	0f 10 05 ec 0b 93 ff 	movups -0x6cf414(%rip),%xmm0        # 5bab0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2b0>
  72aec4:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  72aec9:	48 b8 00 00 00 00 01 	movabs $0x3000100000000,%rax
  72aed0:	00 03 00 
  72aed3:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  72aed8:	e9 81 01 00 00       	jmp    72b05e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x2de>
  72aedd:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  72aee4:	00 00 00 00 
  72aee8:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72aeec:	66 0f 7e 44 24 70    	movd   %xmm0,0x70(%rsp)
  72aef2:	ff 15 f0 e3 3f 00    	call   *0x3fe3f0(%rip)        # b292e8 <_DYNAMIC+0x260>
  72aef8:	bf 08 01 00 00       	mov    $0x108,%edi
  72aefd:	be 08 00 00 00       	mov    $0x8,%esi
  72af02:	ff 15 c0 e3 3f 00    	call   *0x3fe3c0(%rip)        # b292c8 <_DYNAMIC+0x240>
  72af08:	48 85 c0             	test   %rax,%rax
  72af0b:	0f 84 83 0a 00 00    	je     72b994 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc14>
  72af11:	49 89 c4             	mov    %rax,%r12
  72af14:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72af18:	f3 0f 7f 80 d8 00 00 	movdqu %xmm0,0xd8(%rax)
  72af1f:	00 
  72af20:	f3 0f 7f 40 28       	movdqu %xmm0,0x28(%rax)
  72af25:	f3 0f 7f 40 40       	movdqu %xmm0,0x40(%rax)
  72af2a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  72af31:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  72af38:	00 
  72af39:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  72af40:	00 
  72af41:	48 c7 40 38 08 00 00 	movq   $0x8,0x38(%rax)
  72af48:	00 
  72af49:	48 c7 40 50 08 00 00 	movq   $0x8,0x50(%rax)
  72af50:	00 
  72af51:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  72af58:	00 
  72af59:	48 c7 40 60 ff ff ff 	movq   $0xffffffffffffffff,0x60(%rax)
  72af60:	ff 
  72af61:	48 c7 80 c0 00 00 00 	movq   $0x0,0xc0(%rax)
  72af68:	00 00 00 00 
  72af6c:	48 c7 80 c8 00 00 00 	movq   $0x8,0xc8(%rax)
  72af73:	08 00 00 00 
  72af77:	48 c7 80 d0 00 00 00 	movq   $0x0,0xd0(%rax)
  72af7e:	00 00 00 00 
  72af82:	48 c7 80 e8 00 00 00 	movq   $0x0,0xe8(%rax)
  72af89:	00 00 00 00 
  72af8d:	f3 0f 7f 80 f8 00 00 	movdqu %xmm0,0xf8(%rax)
  72af94:	00 
  72af95:	49 89 86 10 06 00 00 	mov    %rax,0x610(%r14)
  72af9c:	66 0f 6e 44 24 70    	movd   0x70(%rsp),%xmm0
  72afa2:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72afa9:	00 
  72afaa:	48 85 ff             	test   %rdi,%rdi
  72afad:	0f 85 1b 04 00 00    	jne    72b3ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x64e>
  72afb3:	e9 a0 03 00 00       	jmp    72b358 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x5d8>
  72afb8:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  72afbf:	49 39 f7             	cmp    %rsi,%r15
  72afc2:	0f 83 19 0a 00 00    	jae    72b9e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc61>
  72afc8:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  72afcf:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  72afd6:	42 0f b6 3c 38       	movzbl (%rax,%r15,1),%edi
  72afdb:	48 39 fe             	cmp    %rdi,%rsi
  72afde:	0f 86 1d 0a 00 00    	jbe    72ba01 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc81>
  72afe4:	49 8b 86 08 02 00 00 	mov    0x208(%r14),%rax
  72afeb:	48 6b cf 58          	imul   $0x58,%rdi,%rcx
  72afef:	eb 32                	jmp    72b023 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x2a3>
  72aff1:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  72aff8:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  72affd:	4c 89 fa             	mov    %r15,%rdx
  72b000:	ff 15 ba e3 3f 00    	call   *0x3fe3ba(%rip)        # b293c0 <_DYNAMIC+0x338>
  72b006:	eb 56                	jmp    72b05e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x2de>
  72b008:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  72b00f:	49 39 f7             	cmp    %rsi,%r15
  72b012:	0f 83 d9 09 00 00    	jae    72b9f1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc71>
  72b018:	49 8b 86 10 02 00 00 	mov    0x210(%r14),%rax
  72b01f:	49 6b cf 58          	imul   $0x58,%r15,%rcx
  72b023:	48 8b 54 08 50       	mov    0x50(%rax,%rcx,1),%rdx
  72b028:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  72b02d:	0f 10 44 08 40       	movups 0x40(%rax,%rcx,1),%xmm0
  72b032:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  72b037:	0f 10 04 08          	movups (%rax,%rcx,1),%xmm0
  72b03b:	0f 10 4c 08 10       	movups 0x10(%rax,%rcx,1),%xmm1
  72b040:	0f 10 54 08 20       	movups 0x20(%rax,%rcx,1),%xmm2
  72b045:	0f 10 5c 08 30       	movups 0x30(%rax,%rcx,1),%xmm3
  72b04a:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
  72b04f:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  72b054:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  72b059:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  72b05e:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  72b065:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  72b06c:	00 
  72b06d:	4c 89 fa             	mov    %r15,%rdx
  72b070:	ff 15 3a e7 3f 00    	call   *0x3fe73a(%rip)        # b297b0 <_DYNAMIC+0x728>
  72b076:	80 bc 24 40 01 00 00 	cmpb   $0x0,0x140(%rsp)
  72b07d:	00 
  72b07e:	74 1a                	je     72b09a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x31a>
  72b080:	48 8d 94 24 44 01 00 	lea    0x144(%rsp),%rdx
  72b087:	00 
  72b088:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  72b08f:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  72b094:	ff 15 1e e7 3f 00    	call   *0x3fe71e(%rip)        # b297b8 <_DYNAMIC+0x730>
  72b09a:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  72b0a1:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  72b0a6:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  72b0ad:	00 
  72b0ae:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
  72b0b3:	0f 29 84 24 80 01 00 	movaps %xmm0,0x180(%rsp)
  72b0ba:	00 
  72b0bb:	66 0f 6f 44 24 10    	movdqa 0x10(%rsp),%xmm0
  72b0c1:	66 0f 6f 4c 24 20    	movdqa 0x20(%rsp),%xmm1
  72b0c7:	0f 28 54 24 30       	movaps 0x30(%rsp),%xmm2
  72b0cc:	0f 28 5c 24 40       	movaps 0x40(%rsp),%xmm3
  72b0d1:	0f 29 9c 24 70 01 00 	movaps %xmm3,0x170(%rsp)
  72b0d8:	00 
  72b0d9:	0f 29 94 24 60 01 00 	movaps %xmm2,0x160(%rsp)
  72b0e0:	00 
  72b0e1:	66 0f 7f 8c 24 50 01 	movdqa %xmm1,0x150(%rsp)
  72b0e8:	00 00 
  72b0ea:	66 0f 7f 84 24 40 01 	movdqa %xmm0,0x140(%rsp)
  72b0f1:	00 00 
  72b0f3:	48 8d bc 24 a0 01 00 	lea    0x1a0(%rsp),%rdi
  72b0fa:	00 
  72b0fb:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  72b102:	00 
  72b103:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  72b108:	41 89 e8             	mov    %ebp,%r8d
  72b10b:	4d 89 e9             	mov    %r13,%r9
  72b10e:	e8 ed 3e 04 00       	call   76f000 <<gpui::property::Overrides>::set_value>
  72b113:	44 8b ac 24 a0 01 00 	mov    0x1a0(%rsp),%r13d
  72b11a:	00 
  72b11b:	41 83 fd 02          	cmp    $0x2,%r13d
  72b11f:	75 2b                	jne    72b14c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x3cc>
  72b121:	0f b7 84 24 a8 01 00 	movzwl 0x1a8(%rsp),%eax
  72b128:	00 
  72b129:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  72b12e:	8b 8c 24 a4 01 00 00 	mov    0x1a4(%rsp),%ecx
  72b135:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  72b139:	66 89 43 0c          	mov    %ax,0xc(%rbx)
  72b13d:	89 4b 08             	mov    %ecx,0x8(%rbx)
  72b140:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  72b147:	e9 36 08 00 00       	jmp    72b982 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc02>
  72b14c:	45 31 c0             	xor    %r8d,%r8d
  72b14f:	41 80 fc ff          	cmp    $0xff,%r12b
  72b153:	41 0f 95 c0          	setne  %r8b
  72b157:	0f b7 84 24 a8 01 00 	movzwl 0x1a8(%rsp),%eax
  72b15e:	00 
  72b15f:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  72b164:	8b 8c 24 a4 01 00 00 	mov    0x1a4(%rsp),%ecx
  72b16b:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  72b16f:	0f 10 84 24 aa 01 00 	movups 0x1aa(%rsp),%xmm0
  72b176:	00 
  72b177:	0f 11 84 24 f2 00 00 	movups %xmm0,0xf2(%rsp)
  72b17e:	00 
  72b17f:	0f 10 84 24 ba 01 00 	movups 0x1ba(%rsp),%xmm0
  72b186:	00 
  72b187:	0f 11 84 24 02 01 00 	movups %xmm0,0x102(%rsp)
  72b18e:	00 
  72b18f:	0f 10 84 24 ca 01 00 	movups 0x1ca(%rsp),%xmm0
  72b196:	00 
  72b197:	0f 11 84 24 12 01 00 	movups %xmm0,0x112(%rsp)
  72b19e:	00 
  72b19f:	0f 10 84 24 da 01 00 	movups 0x1da(%rsp),%xmm0
  72b1a6:	00 
  72b1a7:	0f 11 84 24 22 01 00 	movups %xmm0,0x122(%rsp)
  72b1ae:	00 
  72b1af:	0f 10 84 24 e8 01 00 	movups 0x1e8(%rsp),%xmm0
  72b1b6:	00 
  72b1b7:	0f 11 84 24 30 01 00 	movups %xmm0,0x130(%rsp)
  72b1be:	00 
  72b1bf:	44 89 ac 24 e8 00 00 	mov    %r13d,0xe8(%rsp)
  72b1c6:	00 
  72b1c7:	66 89 84 24 f0 00 00 	mov    %ax,0xf0(%rsp)
  72b1ce:	00 
  72b1cf:	89 8c 24 ec 00 00 00 	mov    %ecx,0xec(%rsp)
  72b1d6:	0f 10 84 24 28 01 00 	movups 0x128(%rsp),%xmm0
  72b1dd:	00 
  72b1de:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  72b1e5:	00 
  72b1e6:	0f 10 84 24 18 01 00 	movups 0x118(%rsp),%xmm0
  72b1ed:	00 
  72b1ee:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  72b1f5:	00 
  72b1f6:	0f 10 84 24 08 01 00 	movups 0x108(%rsp),%xmm0
  72b1fd:	00 
  72b1fe:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  72b205:	00 
  72b206:	0f 10 84 24 f8 00 00 	movups 0xf8(%rsp),%xmm0
  72b20d:	00 
  72b20e:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  72b215:	00 
  72b216:	0f 10 84 24 e8 00 00 	movups 0xe8(%rsp),%xmm0
  72b21d:	00 
  72b21e:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  72b225:	00 
  72b226:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  72b22d:	00 
  72b22e:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  72b235:	00 
  72b236:	4d 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%r9
  72b23d:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
  72b244:	00 
  72b245:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  72b24c:	00 
  72b24d:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  72b254:	00 
  72b255:	f3 0f 6f 84 24 f8 00 	movdqu 0xf8(%rsp),%xmm0
  72b25c:	00 00 
  72b25e:	f3 0f 6f 8c 24 08 01 	movdqu 0x108(%rsp),%xmm1
  72b265:	00 00 
  72b267:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  72b26e:	00 
  72b26f:	0f 10 9c 24 28 01 00 	movups 0x128(%rsp),%xmm3
  72b276:	00 
  72b277:	0f 29 9c 24 80 01 00 	movaps %xmm3,0x180(%rsp)
  72b27e:	00 
  72b27f:	0f 29 94 24 70 01 00 	movaps %xmm2,0x170(%rsp)
  72b286:	00 
  72b287:	66 0f 7f 8c 24 60 01 	movdqa %xmm1,0x160(%rsp)
  72b28e:	00 00 
  72b290:	66 0f 7f 84 24 50 01 	movdqa %xmm0,0x150(%rsp)
  72b297:	00 00 
  72b299:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  72b2a0:	00 
  72b2a1:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  72b2a8:	4c 89 fe             	mov    %r15,%rsi
  72b2ab:	89 ea                	mov    %ebp,%edx
  72b2ad:	ff 15 0d e5 3f 00    	call   *0x3fe50d(%rip)        # b297c0 <_DYNAMIC+0x738>
  72b2b3:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  72b2ba:	8b 6c 24 10          	mov    0x10(%rsp),%ebp
  72b2be:	44 0f b6 a4 24 90 00 	movzbl 0x90(%rsp),%r12d
  72b2c5:	00 00 
  72b2c7:	83 fd 01             	cmp    $0x1,%ebp
  72b2ca:	75 25                	jne    72b2f1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x571>
  72b2cc:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  72b2d3:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  72b2d7:	39 c1                	cmp    %eax,%ecx
  72b2d9:	0f 94 c2             	sete   %dl
  72b2dc:	41 84 d4             	test   %dl,%r12b
  72b2df:	75 26                	jne    72b307 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x587>
  72b2e1:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  72b2e8:	01 00 00 00 
  72b2ec:	e9 78 03 00 00       	jmp    72b669 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8e9>
  72b2f1:	41 f6 c4 01          	test   $0x1,%r12b
  72b2f5:	74 10                	je     72b307 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x587>
  72b2f7:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  72b2fe:	01 00 00 00 
  72b302:	e9 76 04 00 00       	jmp    72b77d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b307:	8b 54 24 18          	mov    0x18(%rsp),%edx
  72b30b:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  72b312:	00 
  72b313:	83 fa 01             	cmp    $0x1,%edx
  72b316:	0f 85 27 02 00 00    	jne    72b543 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x7c3>
  72b31c:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  72b323:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  72b327:	0f 94 c0             	sete   %al
  72b32a:	be 01 00 00 00       	mov    $0x1,%esi
  72b32f:	84 c1                	test   %al,%cl
  72b331:	0f 85 1a 02 00 00    	jne    72b551 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x7d1>
  72b337:	e9 15 03 00 00       	jmp    72b651 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b33c:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  72b343:	00 00 00 00 
  72b347:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72b34b:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72b352:	00 
  72b353:	48 85 ff             	test   %rdi,%rdi
  72b356:	75 76                	jne    72b3ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x64e>
  72b358:	66 0f 7e 44 24 70    	movd   %xmm0,0x70(%rsp)
  72b35e:	ff 15 84 df 3f 00    	call   *0x3fdf84(%rip)        # b292e8 <_DYNAMIC+0x260>
  72b364:	bf 60 00 00 00       	mov    $0x60,%edi
  72b369:	be 08 00 00 00       	mov    $0x8,%esi
  72b36e:	ff 15 54 df 3f 00    	call   *0x3fdf54(%rip)        # b292c8 <_DYNAMIC+0x240>
  72b374:	48 85 c0             	test   %rax,%rax
  72b377:	0f 84 27 06 00 00    	je     72b9a4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc24>
  72b37d:	48 89 c7             	mov    %rax,%rdi
  72b380:	66 0f ef c0          	pxor   %xmm0,%xmm0
  72b384:	f3 0f 7f 40 10       	movdqu %xmm0,0x10(%rax)
  72b389:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  72b390:	48 c7 40 08 08 00 00 	movq   $0x8,0x8(%rax)
  72b397:	00 
  72b398:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  72b39f:	00 
  72b3a0:	48 c7 40 28 00 00 00 	movq   $0x0,0x28(%rax)
  72b3a7:	00 
  72b3a8:	48 c7 40 30 ff ff ff 	movq   $0xffffffffffffffff,0x30(%rax)
  72b3af:	ff 
  72b3b0:	48 c7 40 48 00 00 00 	movq   $0x0,0x48(%rax)
  72b3b7:	00 
  72b3b8:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  72b3bf:	00 
  72b3c0:	49 89 84 24 00 01 00 	mov    %rax,0x100(%r12)
  72b3c7:	00 
  72b3c8:	66 0f 6e 44 24 70    	movd   0x70(%rsp),%xmm0
  72b3ce:	48 83 c7 48          	add    $0x48,%rdi
  72b3d2:	4c 89 fe             	mov    %r15,%rsi
  72b3d5:	89 ea                	mov    %ebp,%edx
  72b3d7:	4c 89 e9             	mov    %r13,%rcx
  72b3da:	e8 a1 33 04 00       	call   76e780 <<gpui::property::Overrides<gpui::property::GeometryStyle>>::set_value>
  72b3df:	48 89 c1             	mov    %rax,%rcx
  72b3e2:	48 c1 e9 20          	shr    $0x20,%rcx
  72b3e6:	a8 01                	test   $0x1,%al
  72b3e8:	74 16                	je     72b400 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x680>
  72b3ea:	c1 e8 10             	shr    $0x10,%eax
  72b3ed:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  72b3f4:	66 89 43 08          	mov    %ax,0x8(%rbx)
  72b3f8:	89 4b 0a             	mov    %ecx,0xa(%rbx)
  72b3fb:	e9 82 05 00 00       	jmp    72b982 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc02>
  72b400:	66 0f 6e c1          	movd   %ecx,%xmm0
  72b404:	89 8c 24 40 01 00 00 	mov    %ecx,0x140(%rsp)
  72b40b:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  72b412:	00 
  72b413:	4c 89 fe             	mov    %r15,%rsi
  72b416:	ff 15 ac e3 3f 00    	call   *0x3fe3ac(%rip)        # b297c8 <_DYNAMIC+0x740>
  72b41c:	49 8b 84 24 00 01 00 	mov    0x100(%r12),%rax
  72b423:	00 
  72b424:	48 83 78 10 00       	cmpq   $0x0,0x10(%rax)
  72b429:	75 3a                	jne    72b465 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x6e5>
  72b42b:	48 83 78 58 00       	cmpq   $0x0,0x58(%rax)
  72b430:	75 33                	jne    72b465 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x6e5>
  72b432:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  72b437:	75 2c                	jne    72b465 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x6e5>
  72b439:	48 83 78 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rax)
  72b43e:	75 25                	jne    72b465 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x6e5>
  72b440:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72b447:	48 8b b8 00 01 00 00 	mov    0x100(%rax),%rdi
  72b44e:	e8 4d 91 fc ff       	call   6f45a0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::geometry::Geometry>>>>
  72b453:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72b45a:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  72b461:	00 00 00 00 
  72b465:	48 8b 05 14 e0 3f 00 	mov    0x3fe014(%rip),%rax        # b29480 <_DYNAMIC+0x3f8>
  72b46c:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  72b473:	00 
  72b474:	48 8d b4 24 40 01 00 	lea    0x140(%rsp),%rsi
  72b47b:	00 
  72b47c:	ff 50 18             	call   *0x18(%rax)
  72b47f:	34 01                	xor    $0x1,%al
  72b481:	0f b6 c0             	movzbl %al,%eax
  72b484:	49 89 86 08 07 00 00 	mov    %rax,0x708(%r14)
  72b48b:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  72b492:	4d 8b be 10 06 00 00 	mov    0x610(%r14),%r15
  72b499:	4d 85 ff             	test   %r15,%r15
  72b49c:	0f 84 d9 04 00 00    	je     72b97b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b4a2:	49 83 bf d8 00 00 00 	cmpq   $0x0,0xd8(%r15)
  72b4a9:	00 
  72b4aa:	0f 85 cb 04 00 00    	jne    72b97b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b4b0:	49 83 bf e0 00 00 00 	cmpq   $0x0,0xe0(%r15)
  72b4b7:	00 
  72b4b8:	0f 85 bd 04 00 00    	jne    72b97b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b4be:	49 83 bf 00 01 00 00 	cmpq   $0x0,0x100(%r15)
  72b4c5:	00 
  72b4c6:	0f 85 af 04 00 00    	jne    72b97b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b4cc:	49 83 bf d0 00 00 00 	cmpq   $0x0,0xd0(%r15)
  72b4d3:	00 
  72b4d4:	0f 85 a1 04 00 00    	jne    72b97b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b4da:	49 83 bf f8 00 00 00 	cmpq   $0x0,0xf8(%r15)
  72b4e1:	00 
  72b4e2:	0f 85 93 04 00 00    	jne    72b97b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b4e8:	49 8b 47 60          	mov    0x60(%r15),%rax
  72b4ec:	83 f8 ff             	cmp    $0xffffffff,%eax
  72b4ef:	0f 85 86 04 00 00    	jne    72b97b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b4f5:	49 83 7f 28 00       	cmpq   $0x0,0x28(%r15)
  72b4fa:	0f 85 7b 04 00 00    	jne    72b97b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b500:	49 8b 07             	mov    (%r15),%rax
  72b503:	49 0b 47 40          	or     0x40(%r15),%rax
  72b507:	0f 85 6e 04 00 00    	jne    72b97b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b50d:	49 83 7f 58 00       	cmpq   $0x0,0x58(%r15)
  72b512:	0f 85 63 04 00 00    	jne    72b97b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b518:	4c 89 ff             	mov    %r15,%rdi
  72b51b:	e8 40 dd fc ff       	call   6f9260 <core::ptr::drop_glue::<gpui::runtime::metadata::Metadata>>
  72b520:	be 08 01 00 00       	mov    $0x108,%esi
  72b525:	ba 08 00 00 00       	mov    $0x8,%edx
  72b52a:	4c 89 ff             	mov    %r15,%rdi
  72b52d:	ff 15 9d dd 3f 00    	call   *0x3fdd9d(%rip)        # b292d0 <_DYNAMIC+0x248>
  72b533:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  72b53a:	00 00 00 00 
  72b53e:	e9 38 04 00 00       	jmp    72b97b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b543:	be 01 00 00 00       	mov    $0x1,%esi
  72b548:	f6 c1 01             	test   $0x1,%cl
  72b54b:	0f 85 00 01 00 00    	jne    72b651 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b551:	8b 44 24 20          	mov    0x20(%rsp),%eax
  72b555:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  72b55c:	0f 85 ef 00 00 00    	jne    72b651 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b562:	8b 44 24 24          	mov    0x24(%rsp),%eax
  72b566:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  72b56d:	0f 85 de 00 00 00    	jne    72b651 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b573:	8b 44 24 28          	mov    0x28(%rsp),%eax
  72b577:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  72b57e:	0f 85 cd 00 00 00    	jne    72b651 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b584:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  72b589:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  72b590:	0f 85 bb 00 00 00    	jne    72b651 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b596:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  72b59b:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  72b5a2:	0f 85 a9 00 00 00    	jne    72b651 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b5a8:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  72b5ad:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  72b5b4:	0f 85 97 00 00 00    	jne    72b651 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b5ba:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  72b5bf:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  72b5c6:	0f 85 85 00 00 00    	jne    72b651 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b5cc:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  72b5d0:	88 8c 24 80 00 00 00 	mov    %cl,0x80(%rsp)
  72b5d7:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  72b5dc:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  72b5e3:	00 
  72b5e4:	e8 37 08 00 00       	call   72be20 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  72b5e9:	84 c0                	test   %al,%al
  72b5eb:	74 53                	je     72b640 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8c0>
  72b5ed:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  72b5f3:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  72b5fa:	00 00 
  72b5fc:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72b600:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72b604:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72b609:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  72b610:	00 
  72b611:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  72b615:	be 01 00 00 00       	mov    $0x1,%esi
  72b61a:	75 35                	jne    72b651 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b61c:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  72b622:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  72b629:	00 00 
  72b62b:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72b62f:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72b633:	31 f6                	xor    %esi,%esi
  72b635:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72b63a:	40 0f 95 c6          	setne  %sil
  72b63e:	eb 11                	jmp    72b651 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x8d1>
  72b640:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  72b647:	00 
  72b648:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  72b64c:	be 01 00 00 00       	mov    $0x1,%esi
  72b651:	49 89 b6 08 07 00 00 	mov    %rsi,0x708(%r14)
  72b658:	40 f6 c5 01          	test   $0x1,%bpl
  72b65c:	74 2b                	je     72b689 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x909>
  72b65e:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  72b665:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  72b669:	39 c1                	cmp    %eax,%ecx
  72b66b:	0f 94 c0             	sete   %al
  72b66e:	41 20 c4             	and    %al,%r12b
  72b671:	41 80 fc 01          	cmp    $0x1,%r12b
  72b675:	0f 85 02 01 00 00    	jne    72b77d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b67b:	8b 54 24 18          	mov    0x18(%rsp),%edx
  72b67f:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  72b686:	00 
  72b687:	eb 0a                	jmp    72b693 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x913>
  72b689:	41 f6 c4 01          	test   $0x1,%r12b
  72b68d:	0f 85 ea 00 00 00    	jne    72b77d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b693:	83 fa 01             	cmp    $0x1,%edx
  72b696:	75 17                	jne    72b6af <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x92f>
  72b698:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  72b69f:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  72b6a3:	0f 94 c0             	sete   %al
  72b6a6:	84 c1                	test   %al,%cl
  72b6a8:	75 0e                	jne    72b6b8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x938>
  72b6aa:	e9 ce 00 00 00       	jmp    72b77d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b6af:	f6 c1 01             	test   $0x1,%cl
  72b6b2:	0f 85 c5 00 00 00    	jne    72b77d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b6b8:	8b 44 24 20          	mov    0x20(%rsp),%eax
  72b6bc:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  72b6c3:	0f 85 b4 00 00 00    	jne    72b77d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b6c9:	8b 44 24 24          	mov    0x24(%rsp),%eax
  72b6cd:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  72b6d4:	0f 85 a3 00 00 00    	jne    72b77d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b6da:	8b 44 24 28          	mov    0x28(%rsp),%eax
  72b6de:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  72b6e5:	0f 85 92 00 00 00    	jne    72b77d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b6eb:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  72b6f0:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  72b6f7:	0f 85 80 00 00 00    	jne    72b77d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b6fd:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  72b702:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  72b709:	75 72                	jne    72b77d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b70b:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  72b710:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  72b717:	75 64                	jne    72b77d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b719:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  72b71e:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  72b725:	75 56                	jne    72b77d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b727:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  72b72c:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  72b733:	00 
  72b734:	e8 e7 06 00 00       	call   72be20 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  72b739:	84 c0                	test   %al,%al
  72b73b:	74 40                	je     72b77d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b73d:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  72b743:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  72b74a:	00 00 
  72b74c:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72b750:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72b754:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72b759:	75 22                	jne    72b77d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0x9fd>
  72b75b:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  72b761:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  72b768:	00 00 
  72b76a:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  72b76e:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  72b772:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72b777:	0f 84 fe 01 00 00    	je     72b97b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbfb>
  72b77d:	45 89 e8             	mov    %r13d,%r8d
  72b780:	44 8b 64 24 18       	mov    0x18(%rsp),%r12d
  72b785:	0f b6 7c 24 64       	movzbl 0x64(%rsp),%edi
  72b78a:	44 0f b6 6c 24 65    	movzbl 0x65(%rsp),%r13d
  72b790:	0f b6 4c 24 66       	movzbl 0x66(%rsp),%ecx
  72b795:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  72b79a:	88 84 24 80 00 00 00 	mov    %al,0x80(%rsp)
  72b7a1:	8b b4 24 f0 00 00 00 	mov    0xf0(%rsp),%esi
  72b7a8:	0f 10 5c 24 1c       	movups 0x1c(%rsp),%xmm3
  72b7ad:	f3 0f 10 44 24 20    	movss  0x20(%rsp),%xmm0
  72b7b3:	0f 10 a4 24 f4 00 00 	movups 0xf4(%rsp),%xmm4
  72b7ba:	00 
  72b7bb:	f3 0f 10 8c 24 f8 00 	movss  0xf8(%rsp),%xmm1
  72b7c2:	00 00 
  72b7c4:	44 0f b6 9c 24 3c 01 	movzbl 0x13c(%rsp),%r11d
  72b7cb:	00 00 
  72b7cd:	44 0f b6 8c 24 3d 01 	movzbl 0x13d(%rsp),%r9d
  72b7d4:	00 00 
  72b7d6:	0f b6 84 24 3e 01 00 	movzbl 0x13e(%rsp),%eax
  72b7dd:	00 
  72b7de:	44 0f b6 94 24 3f 01 	movzbl 0x13f(%rsp),%r10d
  72b7e5:	00 00 
  72b7e7:	40 f6 c5 01          	test   $0x1,%bpl
  72b7eb:	74 22                	je     72b80f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xa8f>
  72b7ed:	f3 0f 10 54 24 14    	movss  0x14(%rsp),%xmm2
  72b7f3:	0f 2e 94 24 ec 00 00 	ucomiss 0xec(%rsp),%xmm2
  72b7fa:	00 
  72b7fb:	40 0f 9b c5          	setnp  %bpl
  72b7ff:	0f 94 c2             	sete   %dl
  72b802:	40 20 ea             	and    %bpl,%dl
  72b805:	41 84 d0             	test   %dl,%r8b
  72b808:	75 0f                	jne    72b819 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xa99>
  72b80a:	e9 a4 00 00 00       	jmp    72b8b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xb33>
  72b80f:	41 f6 c0 01          	test   $0x1,%r8b
  72b813:	0f 85 9a 00 00 00    	jne    72b8b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xb33>
  72b819:	41 83 fc 01          	cmp    $0x1,%r12d
  72b81d:	75 3c                	jne    72b85b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xadb>
  72b81f:	44 30 df             	xor    %r11b,%dil
  72b822:	30 c1                	xor    %al,%cl
  72b824:	0f b6 84 24 80 00 00 	movzbl 0x80(%rsp),%eax
  72b82b:	00 
  72b82c:	44 30 d0             	xor    %r10b,%al
  72b82f:	45 38 cd             	cmp    %r9b,%r13b
  72b832:	0f 94 c2             	sete   %dl
  72b835:	0f 28 c3             	movaps %xmm3,%xmm0
  72b838:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  72b83c:	44 0f 50 c0          	movmskps %xmm0,%r8d
  72b840:	41 80 f0 0f          	xor    $0xf,%r8b
  72b844:	40 08 f9             	or     %dil,%cl
  72b847:	44 08 c1             	or     %r8b,%cl
  72b84a:	08 c1                	or     %al,%cl
  72b84c:	0f 94 c0             	sete   %al
  72b84f:	40 20 f0             	and    %sil,%al
  72b852:	84 d0                	test   %dl,%al
  72b854:	74 5d                	je     72b8b3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xb33>
  72b856:	e9 83 00 00 00       	jmp    72b8de <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xb5e>
  72b85b:	0f 2e c1             	ucomiss %xmm1,%xmm0
  72b85e:	0f 9b c2             	setnp  %dl
  72b861:	40 0f 94 c5          	sete   %bpl
  72b865:	40 20 d5             	and    %dl,%bpl
  72b868:	40 f6 d6             	not    %sil
  72b86b:	40 20 ee             	and    %bpl,%sil
  72b86e:	0f 28 c3             	movaps %xmm3,%xmm0
  72b871:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  72b875:	0f 50 d0             	movmskps %xmm0,%edx
  72b878:	89 d5                	mov    %edx,%ebp
  72b87a:	40 c0 ed 03          	shr    $0x3,%bpl
  72b87e:	c0 ea 02             	shr    $0x2,%dl
  72b881:	40 20 f2             	and    %sil,%dl
  72b884:	44 38 df             	cmp    %r11b,%dil
  72b887:	40 0f 94 c6          	sete   %sil
  72b88b:	40 20 ee             	and    %bpl,%sil
  72b88e:	40 20 d6             	and    %dl,%sil
  72b891:	38 c1                	cmp    %al,%cl
  72b893:	0f 94 c1             	sete   %cl
  72b896:	44 38 94 24 80 00 00 	cmp    %r10b,0x80(%rsp)
  72b89d:	00 
  72b89e:	0f 94 c0             	sete   %al
  72b8a1:	20 c8                	and    %cl,%al
  72b8a3:	45 38 cd             	cmp    %r9b,%r13b
  72b8a6:	0f 94 c1             	sete   %cl
  72b8a9:	20 c1                	and    %al,%cl
  72b8ab:	40 20 f1             	and    %sil,%cl
  72b8ae:	80 f9 01             	cmp    $0x1,%cl
  72b8b1:	74 2b                	je     72b8de <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xb5e>
  72b8b3:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  72b8ba:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  72b8bf:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
  72b8c4:	0f 29 a4 24 80 00 00 	movaps %xmm4,0x80(%rsp)
  72b8cb:	00 
  72b8cc:	e8 af 9b 01 00       	call   745480 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  72b8d1:	0f 28 a4 24 80 00 00 	movaps 0x80(%rsp),%xmm4
  72b8d8:	00 
  72b8d9:	0f 28 5c 24 70       	movaps 0x70(%rsp),%xmm3
  72b8de:	0f c2 dc 04          	cmpneqps %xmm4,%xmm3
  72b8e2:	66 0f c5 c3 06       	pextrw $0x6,%xmm3,%eax
  72b8e7:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  72b8ee:	a8 01                	test   $0x1,%al
  72b8f0:	74 69                	je     72b95b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbdb>
  72b8f2:	49 39 cf             	cmp    %rcx,%r15
  72b8f5:	0f 83 13 01 00 00    	jae    72ba0e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc8e>
  72b8fb:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  72b902:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  72b906:	8b 7c d0 20          	mov    0x20(%rax,%rdx,8),%edi
  72b90a:	89 f8                	mov    %edi,%eax
  72b90c:	83 e0 07             	and    $0x7,%eax
  72b90f:	83 f8 06             	cmp    $0x6,%eax
  72b912:	74 47                	je     72b95b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbdb>
  72b914:	c1 ef 03             	shr    $0x3,%edi
  72b917:	74 42                	je     72b95b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xbdb>
  72b919:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  72b920:	ff cf                	dec    %edi
  72b922:	48 39 fe             	cmp    %rdi,%rsi
  72b925:	0f 86 f6 00 00 00    	jbe    72ba21 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xca1>
  72b92b:	4d 8b a6 b0 02 00 00 	mov    0x2b0(%r14),%r12
  72b932:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  72b936:	48 c1 e0 04          	shl    $0x4,%rax
  72b93a:	49 83 3c 04 fe       	cmpq   $0xfffffffffffffffe,(%r12,%rax,1)
  72b93f:	74 73                	je     72b9b4 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::apply_property_value_at+0xc34>
  72b941:	49 01 c4             	add    %rax,%r12
  72b944:	4c 89 e7             	mov    %r12,%rdi
  72b947:	e8 84 8f fc ff       	call   6f48d0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  72b94c:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  72b953:	ff 
  72b954:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  72b95b:	48 8d 94 24 e8 00 00 	lea    0xe8(%rsp),%rdx
  72b962:	00 
  72b963:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  72b96a:	4c 89 fe             	mov    %r15,%rsi
  72b96d:	ff 15 4d db 3f 00    	call   *0x3fdb4d(%rip)        # b294c0 <_DYNAMIC+0x438>
  72b973:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  72b97a:	01 
  72b97b:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  72b982:	48 81 c4 f8 01 00 00 	add    $0x1f8,%rsp
  72b989:	5b                   	pop    %rbx
  72b98a:	41 5c                	pop    %r12
  72b98c:	41 5d                	pop    %r13
  72b98e:	41 5e                	pop    %r14
  72b990:	41 5f                	pop    %r15
  72b992:	5d                   	pop    %rbp
  72b993:	c3                   	ret
  72b994:	bf 08 00 00 00       	mov    $0x8,%edi
  72b999:	be 08 01 00 00       	mov    $0x108,%esi
  72b99e:	ff 15 54 d9 3f 00    	call   *0x3fd954(%rip)        # b292f8 <_DYNAMIC+0x270>
  72b9a4:	bf 08 00 00 00       	mov    $0x8,%edi
  72b9a9:	be 60 00 00 00       	mov    $0x60,%esi
  72b9ae:	ff 15 44 d9 3f 00    	call   *0x3fd944(%rip)        # b292f8 <_DYNAMIC+0x270>
  72b9b4:	48 8d 3d 2d f0 3c 00 	lea    0x3cf02d(%rip),%rdi        # afa9e8 <__frame_dummy_init_array_entry+0x180>
  72b9bb:	ff 15 cf d9 3f 00    	call   *0x3fd9cf(%rip)        # b29390 <_DYNAMIC+0x308>
  72b9c1:	48 8d 15 90 f5 3c 00 	lea    0x3cf590(%rip),%rdx        # afaf58 <__frame_dummy_init_array_entry+0x6f0>
  72b9c8:	4c 89 ff             	mov    %r15,%rdi
  72b9cb:	ff 15 0f da 3f 00    	call   *0x3fda0f(%rip)        # b293e0 <_DYNAMIC+0x358>
  72b9d1:	48 8d 15 58 fc 3c 00 	lea    0x3cfc58(%rip),%rdx        # afb630 <__frame_dummy_init_array_entry+0xdc8>
  72b9d8:	4c 89 ff             	mov    %r15,%rdi
  72b9db:	ff 15 ff d9 3f 00    	call   *0x3fd9ff(%rip)        # b293e0 <_DYNAMIC+0x358>
  72b9e1:	48 8d 15 88 f3 3c 00 	lea    0x3cf388(%rip),%rdx        # afad70 <__frame_dummy_init_array_entry+0x508>
  72b9e8:	4c 89 ff             	mov    %r15,%rdi
  72b9eb:	ff 15 ef d9 3f 00    	call   *0x3fd9ef(%rip)        # b293e0 <_DYNAMIC+0x358>
  72b9f1:	48 8d 15 60 f3 3c 00 	lea    0x3cf360(%rip),%rdx        # afad58 <__frame_dummy_init_array_entry+0x4f0>
  72b9f8:	4c 89 ff             	mov    %r15,%rdi
  72b9fb:	ff 15 df d9 3f 00    	call   *0x3fd9df(%rip)        # b293e0 <_DYNAMIC+0x358>
  72ba01:	48 8d 15 80 f3 3c 00 	lea    0x3cf380(%rip),%rdx        # afad88 <__frame_dummy_init_array_entry+0x520>
  72ba08:	ff 15 d2 d9 3f 00    	call   *0x3fd9d2(%rip)        # b293e0 <_DYNAMIC+0x358>
  72ba0e:	48 8d 15 33 fc 3c 00 	lea    0x3cfc33(%rip),%rdx        # afb648 <__frame_dummy_init_array_entry+0xde0>
  72ba15:	4c 89 ff             	mov    %r15,%rdi
  72ba18:	48 89 ce             	mov    %rcx,%rsi
  72ba1b:	ff 15 bf d9 3f 00    	call   *0x3fd9bf(%rip)        # b293e0 <_DYNAMIC+0x358>
  72ba21:	48 8d 15 a8 ef 3c 00 	lea    0x3cefa8(%rip),%rdx        # afa9d0 <__frame_dummy_init_array_entry+0x168>
  72ba28:	ff 15 b2 d9 3f 00    	call   *0x3fd9b2(%rip)        # b293e0 <_DYNAMIC+0x358>
  72ba2e:	48 89 c3             	mov    %rax,%rbx
  72ba31:	be 08 01 00 00       	mov    $0x108,%esi
  72ba36:	ba 08 00 00 00       	mov    $0x8,%edx
  72ba3b:	4c 89 ff             	mov    %r15,%rdi
  72ba3e:	ff 15 8c d8 3f 00    	call   *0x3fd88c(%rip)        # b292d0 <_DYNAMIC+0x248>
  72ba44:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  72ba4b:	00 00 00 00 
  72ba4f:	48 89 df             	mov    %rbx,%rdi
  72ba52:	e8 59 da 3c 00       	call   af94b0 <_Unwind_Resume@plt>
  72ba57:	48 89 c3             	mov    %rax,%rbx
  72ba5a:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72ba61:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  72ba68:	00 00 00 00 
  72ba6c:	48 89 df             	mov    %rbx,%rdi
  72ba6f:	e8 3c da 3c 00       	call   af94b0 <_Unwind_Resume@plt>
  72ba74:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  72ba7b:	ff 
  72ba7c:	48 89 c7             	mov    %rax,%rdi
  72ba7f:	e8 2c da 3c 00       	call   af94b0 <_Unwind_Resume@plt>
