
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000728aa0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at>:
  728aa0:	55                   	push   %rbp
  728aa1:	41 57                	push   %r15
  728aa3:	41 56                	push   %r14
  728aa5:	41 55                	push   %r13
  728aa7:	41 54                	push   %r12
  728aa9:	53                   	push   %rbx
  728aaa:	48 81 ec 08 02 00 00 	sub    $0x208,%rsp
  728ab1:	45 89 cf             	mov    %r9d,%r15d
  728ab4:	4c 89 84 24 a8 01 00 	mov    %r8,0x1a8(%rsp)
  728abb:	00 
  728abc:	49 89 cd             	mov    %rcx,%r13
  728abf:	48 89 94 24 a0 01 00 	mov    %rdx,0x1a0(%rsp)
  728ac6:	00 
  728ac7:	49 89 f6             	mov    %rsi,%r14
  728aca:	48 89 fb             	mov    %rdi,%rbx
  728acd:	4c 8b a4 24 40 02 00 	mov    0x240(%rsp),%r12
  728ad4:	00 
  728ad5:	41 0f b6 2c 24       	movzbl (%r12),%ebp
  728ada:	40 80 fd ff          	cmp    $0xff,%bpl
  728ade:	74 1d                	je     728afd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x5d>
  728ae0:	44 89 ff             	mov    %r15d,%edi
  728ae3:	4c 89 e6             	mov    %r12,%rsi
  728ae6:	ff 15 c4 f6 3f 00    	call   *0x3ff6c4(%rip)        # b281b0 <_DYNAMIC+0x4f8>
  728aec:	66 85 c0             	test   %ax,%ax
  728aef:	74 0c                	je     728afd <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x5d>
  728af1:	48 89 c1             	mov    %rax,%rcx
  728af4:	48 c1 e9 10          	shr    $0x10,%rcx
  728af8:	e9 24 06 00 00       	jmp    729121 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x681>
  728afd:	41 0f b7 c7          	movzwl %r15w,%eax
  728b01:	48 8d 0d 78 1a 3d 00 	lea    0x3d1a78(%rip),%rcx        # afa580 <__frame_dummy_init_array_entry+0x1058>
  728b08:	48 89 84 24 98 01 00 	mov    %rax,0x198(%rsp)
  728b0f:	00 
  728b10:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  728b15:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  728b19:	74 6d                	je     728b88 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xe8>
  728b1b:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  728b22:	49 39 f5             	cmp    %rsi,%r13
  728b25:	0f 83 04 0d 00 00    	jae    72982f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xd8f>
  728b2b:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  728b32:	4a 8d 0c ad 00 00 00 	lea    0x0(,%r13,4),%rcx
  728b39:	00 
  728b3a:	4c 01 e9             	add    %r13,%rcx
  728b3d:	4c 8b 2c c8          	mov    (%rax,%rcx,8),%r13
  728b41:	49 8b ae 10 06 00 00 	mov    0x610(%r14),%rbp
  728b48:	48 85 ed             	test   %rbp,%rbp
  728b4b:	0f 84 c9 00 00 00    	je     728c1a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x17a>
  728b51:	48 8b bd 00 01 00 00 	mov    0x100(%rbp),%rdi
  728b58:	48 85 ff             	test   %rdi,%rdi
  728b5b:	0f 84 82 05 00 00    	je     7290e3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x643>
  728b61:	4c 89 ee             	mov    %r13,%rsi
  728b64:	ff 15 06 f7 3f 00    	call   *0x3ff706(%rip)        # b28270 <_DYNAMIC+0x5b8>
  728b6a:	49 8b ae 10 06 00 00 	mov    0x610(%r14),%rbp
  728b71:	f3 0f 11 84 24 e8 00 	movss  %xmm0,0xe8(%rsp)
  728b78:	00 00 
  728b7a:	48 85 ed             	test   %rbp,%rbp
  728b7d:	0f 85 56 01 00 00    	jne    728cd9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x239>
  728b83:	e9 a0 00 00 00       	jmp    728c28 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x188>
  728b88:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  728b8f:	49 39 f5             	cmp    %rsi,%r13
  728b92:	0f 83 a7 0c 00 00    	jae    72983f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xd9f>
  728b98:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  728b9f:	4a 8d 0c ad 00 00 00 	lea    0x0(,%r13,4),%rcx
  728ba6:	00 
  728ba7:	4c 01 e9             	add    %r13,%rcx
  728baa:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  728bae:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  728bb3:	49 8b 86 00 02 00 00 	mov    0x200(%r14),%rax
  728bba:	48 8d 0d e7 2b 93 ff 	lea    -0x6cd419(%rip),%rcx        # 5b7a8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x138>
  728bc1:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  728bc5:	48 01 c8             	add    %rcx,%rax
  728bc8:	ff e0                	jmp    *%rax
  728bca:	0f 10 05 8f 2d 93 ff 	movups -0x6cd271(%rip),%xmm0        # 5b960 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2f0>
  728bd1:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  728bd6:	0f 10 05 73 2d 93 ff 	movups -0x6cd28d(%rip),%xmm0        # 5b950 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e0>
  728bdd:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  728be2:	0f 10 05 57 2d 93 ff 	movups -0x6cd2a9(%rip),%xmm0        # 5b940 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2d0>
  728be9:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  728bee:	0f 10 05 3b 2d 93 ff 	movups -0x6cd2c5(%rip),%xmm0        # 5b930 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c0>
  728bf5:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  728bfa:	0f 10 05 1f 2d 93 ff 	movups -0x6cd2e1(%rip),%xmm0        # 5b920 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2b0>
  728c01:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  728c06:	48 b8 00 00 00 00 01 	movabs $0x3000100000000,%rax
  728c0d:	00 03 00 
  728c10:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  728c15:	e9 ed 01 00 00       	jmp    728e07 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x367>
  728c1a:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  728c21:	00 00 00 00 
  728c25:	0f 57 c0             	xorps  %xmm0,%xmm0
  728c28:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  728c2e:	ff 15 e4 f2 3f 00    	call   *0x3ff2e4(%rip)        # b27f18 <_DYNAMIC+0x260>
  728c34:	bf 08 01 00 00       	mov    $0x108,%edi
  728c39:	be 08 00 00 00       	mov    $0x8,%esi
  728c3e:	ff 15 b4 f2 3f 00    	call   *0x3ff2b4(%rip)        # b27ef8 <_DYNAMIC+0x240>
  728c44:	48 85 c0             	test   %rax,%rax
  728c47:	0f 84 b5 0b 00 00    	je     729802 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xd62>
  728c4d:	48 89 c5             	mov    %rax,%rbp
  728c50:	0f 57 c0             	xorps  %xmm0,%xmm0
  728c53:	0f 11 80 d8 00 00 00 	movups %xmm0,0xd8(%rax)
  728c5a:	0f 11 40 28          	movups %xmm0,0x28(%rax)
  728c5e:	0f 11 40 40          	movups %xmm0,0x40(%rax)
  728c62:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  728c69:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  728c70:	00 
  728c71:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  728c78:	00 
  728c79:	48 c7 40 38 08 00 00 	movq   $0x8,0x38(%rax)
  728c80:	00 
  728c81:	48 c7 40 50 08 00 00 	movq   $0x8,0x50(%rax)
  728c88:	00 
  728c89:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  728c90:	00 
  728c91:	48 c7 40 60 ff ff ff 	movq   $0xffffffffffffffff,0x60(%rax)
  728c98:	ff 
  728c99:	48 c7 80 c0 00 00 00 	movq   $0x0,0xc0(%rax)
  728ca0:	00 00 00 00 
  728ca4:	48 c7 80 c8 00 00 00 	movq   $0x8,0xc8(%rax)
  728cab:	08 00 00 00 
  728caf:	48 c7 80 d0 00 00 00 	movq   $0x0,0xd0(%rax)
  728cb6:	00 00 00 00 
  728cba:	48 c7 80 e8 00 00 00 	movq   $0x0,0xe8(%rax)
  728cc1:	00 00 00 00 
  728cc5:	0f 11 80 f8 00 00 00 	movups %xmm0,0xf8(%rax)
  728ccc:	49 89 86 10 06 00 00 	mov    %rax,0x610(%r14)
  728cd3:	f3 0f 10 44 24 70    	movss  0x70(%rsp),%xmm0
  728cd9:	48 8b bd 00 01 00 00 	mov    0x100(%rbp),%rdi
  728ce0:	48 85 ff             	test   %rdi,%rdi
  728ce3:	0f 85 18 04 00 00    	jne    729101 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x661>
  728ce9:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  728cef:	ff 15 23 f2 3f 00    	call   *0x3ff223(%rip)        # b27f18 <_DYNAMIC+0x260>
  728cf5:	bf 60 00 00 00       	mov    $0x60,%edi
  728cfa:	be 08 00 00 00       	mov    $0x8,%esi
  728cff:	ff 15 f3 f1 3f 00    	call   *0x3ff1f3(%rip)        # b27ef8 <_DYNAMIC+0x240>
  728d05:	48 85 c0             	test   %rax,%rax
  728d08:	0f 84 04 0b 00 00    	je     729812 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xd72>
  728d0e:	48 89 c7             	mov    %rax,%rdi
  728d11:	0f 57 c0             	xorps  %xmm0,%xmm0
  728d14:	0f 11 40 10          	movups %xmm0,0x10(%rax)
  728d18:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  728d1f:	48 c7 40 08 08 00 00 	movq   $0x8,0x8(%rax)
  728d26:	00 
  728d27:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  728d2e:	00 
  728d2f:	48 c7 40 28 00 00 00 	movq   $0x0,0x28(%rax)
  728d36:	00 
  728d37:	48 c7 40 30 ff ff ff 	movq   $0xffffffffffffffff,0x30(%rax)
  728d3e:	ff 
  728d3f:	48 c7 40 48 00 00 00 	movq   $0x0,0x48(%rax)
  728d46:	00 
  728d47:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  728d4e:	00 
  728d4f:	48 89 85 00 01 00 00 	mov    %rax,0x100(%rbp)
  728d56:	f3 0f 10 44 24 70    	movss  0x70(%rsp),%xmm0
  728d5c:	e9 a0 03 00 00       	jmp    729101 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x661>
  728d61:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  728d68:	49 39 f5             	cmp    %rsi,%r13
  728d6b:	0f 83 de 0a 00 00    	jae    72984f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xdaf>
  728d71:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  728d78:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  728d7f:	42 0f b6 3c 28       	movzbl (%rax,%r13,1),%edi
  728d84:	48 39 fe             	cmp    %rdi,%rsi
  728d87:	0f 86 e2 0a 00 00    	jbe    72986f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xdcf>
  728d8d:	49 8b 86 08 02 00 00 	mov    0x208(%r14),%rax
  728d94:	48 6b cf 58          	imul   $0x58,%rdi,%rcx
  728d98:	eb 32                	jmp    728dcc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x32c>
  728d9a:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  728da1:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  728da6:	4c 89 ea             	mov    %r13,%rdx
  728da9:	ff 15 41 f2 3f 00    	call   *0x3ff241(%rip)        # b27ff0 <_DYNAMIC+0x338>
  728daf:	eb 56                	jmp    728e07 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x367>
  728db1:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  728db8:	49 39 f5             	cmp    %rsi,%r13
  728dbb:	0f 83 9e 0a 00 00    	jae    72985f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xdbf>
  728dc1:	49 8b 86 10 02 00 00 	mov    0x210(%r14),%rax
  728dc8:	49 6b cd 58          	imul   $0x58,%r13,%rcx
  728dcc:	48 8b 54 08 50       	mov    0x50(%rax,%rcx,1),%rdx
  728dd1:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  728dd6:	0f 10 44 08 40       	movups 0x40(%rax,%rcx,1),%xmm0
  728ddb:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  728de0:	0f 10 04 08          	movups (%rax,%rcx,1),%xmm0
  728de4:	0f 10 4c 08 10       	movups 0x10(%rax,%rcx,1),%xmm1
  728de9:	0f 10 54 08 20       	movups 0x20(%rax,%rcx,1),%xmm2
  728dee:	0f 10 5c 08 30       	movups 0x30(%rax,%rcx,1),%xmm3
  728df3:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
  728df8:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  728dfd:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  728e02:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  728e07:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  728e0e:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  728e15:	00 
  728e16:	4c 89 ea             	mov    %r13,%rdx
  728e19:	ff 15 b1 f5 3f 00    	call   *0x3ff5b1(%rip)        # b283d0 <_DYNAMIC+0x718>
  728e1f:	80 bc 24 40 01 00 00 	cmpb   $0x0,0x140(%rsp)
  728e26:	00 
  728e27:	74 1a                	je     728e43 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x3a3>
  728e29:	48 8d 94 24 44 01 00 	lea    0x144(%rsp),%rdx
  728e30:	00 
  728e31:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  728e38:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  728e3d:	ff 15 95 f5 3f 00    	call   *0x3ff595(%rip)        # b283d8 <_DYNAMIC+0x720>
  728e43:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  728e4a:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  728e4f:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  728e56:	00 
  728e57:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
  728e5c:	0f 29 84 24 80 01 00 	movaps %xmm0,0x180(%rsp)
  728e63:	00 
  728e64:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  728e69:	0f 28 4c 24 20       	movaps 0x20(%rsp),%xmm1
  728e6e:	0f 28 54 24 30       	movaps 0x30(%rsp),%xmm2
  728e73:	0f 28 5c 24 40       	movaps 0x40(%rsp),%xmm3
  728e78:	0f 29 9c 24 70 01 00 	movaps %xmm3,0x170(%rsp)
  728e7f:	00 
  728e80:	0f 29 94 24 60 01 00 	movaps %xmm2,0x160(%rsp)
  728e87:	00 
  728e88:	0f 29 8c 24 50 01 00 	movaps %xmm1,0x150(%rsp)
  728e8f:	00 
  728e90:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
  728e97:	00 
  728e98:	48 8d bc 24 b0 01 00 	lea    0x1b0(%rsp),%rdi
  728e9f:	00 
  728ea0:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  728ea7:	00 
  728ea8:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  728ead:	45 89 f8             	mov    %r15d,%r8d
  728eb0:	4d 89 e1             	mov    %r12,%r9
  728eb3:	e8 d8 de 02 00       	call   756d90 <<gpui::property::Overrides>::set_value>
  728eb8:	44 8b a4 24 b0 01 00 	mov    0x1b0(%rsp),%r12d
  728ebf:	00 
  728ec0:	41 83 fc 02          	cmp    $0x2,%r12d
  728ec4:	75 2b                	jne    728ef1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x451>
  728ec6:	0f b7 84 24 b8 01 00 	movzwl 0x1b8(%rsp),%eax
  728ecd:	00 
  728ece:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  728ed3:	8b 8c 24 b4 01 00 00 	mov    0x1b4(%rsp),%ecx
  728eda:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  728ede:	66 89 43 0c          	mov    %ax,0xc(%rbx)
  728ee2:	89 4b 08             	mov    %ecx,0x8(%rbx)
  728ee5:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  728eec:	e9 ff 07 00 00       	jmp    7296f0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc50>
  728ef1:	45 31 c0             	xor    %r8d,%r8d
  728ef4:	40 80 fd ff          	cmp    $0xff,%bpl
  728ef8:	41 0f 95 c0          	setne  %r8b
  728efc:	0f b7 84 24 b8 01 00 	movzwl 0x1b8(%rsp),%eax
  728f03:	00 
  728f04:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  728f09:	8b 8c 24 b4 01 00 00 	mov    0x1b4(%rsp),%ecx
  728f10:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  728f14:	0f 10 84 24 ba 01 00 	movups 0x1ba(%rsp),%xmm0
  728f1b:	00 
  728f1c:	0f 11 84 24 f2 00 00 	movups %xmm0,0xf2(%rsp)
  728f23:	00 
  728f24:	0f 10 84 24 ca 01 00 	movups 0x1ca(%rsp),%xmm0
  728f2b:	00 
  728f2c:	0f 11 84 24 02 01 00 	movups %xmm0,0x102(%rsp)
  728f33:	00 
  728f34:	0f 10 84 24 da 01 00 	movups 0x1da(%rsp),%xmm0
  728f3b:	00 
  728f3c:	0f 11 84 24 12 01 00 	movups %xmm0,0x112(%rsp)
  728f43:	00 
  728f44:	0f 10 84 24 ea 01 00 	movups 0x1ea(%rsp),%xmm0
  728f4b:	00 
  728f4c:	0f 11 84 24 22 01 00 	movups %xmm0,0x122(%rsp)
  728f53:	00 
  728f54:	0f 10 84 24 f8 01 00 	movups 0x1f8(%rsp),%xmm0
  728f5b:	00 
  728f5c:	0f 11 84 24 30 01 00 	movups %xmm0,0x130(%rsp)
  728f63:	00 
  728f64:	44 89 a4 24 e8 00 00 	mov    %r12d,0xe8(%rsp)
  728f6b:	00 
  728f6c:	66 89 84 24 f0 00 00 	mov    %ax,0xf0(%rsp)
  728f73:	00 
  728f74:	89 8c 24 ec 00 00 00 	mov    %ecx,0xec(%rsp)
  728f7b:	0f 10 84 24 28 01 00 	movups 0x128(%rsp),%xmm0
  728f82:	00 
  728f83:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  728f8a:	00 
  728f8b:	0f 10 84 24 18 01 00 	movups 0x118(%rsp),%xmm0
  728f92:	00 
  728f93:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  728f9a:	00 
  728f9b:	0f 10 84 24 08 01 00 	movups 0x108(%rsp),%xmm0
  728fa2:	00 
  728fa3:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  728faa:	00 
  728fab:	0f 10 84 24 f8 00 00 	movups 0xf8(%rsp),%xmm0
  728fb2:	00 
  728fb3:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  728fba:	00 
  728fbb:	0f 10 84 24 e8 00 00 	movups 0xe8(%rsp),%xmm0
  728fc2:	00 
  728fc3:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  728fca:	00 
  728fcb:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  728fd2:	00 
  728fd3:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  728fda:	00 
  728fdb:	4d 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%r9
  728fe2:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
  728fe9:	00 
  728fea:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  728ff1:	00 
  728ff2:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  728ff9:	00 
  728ffa:	f3 0f 6f 84 24 f8 00 	movdqu 0xf8(%rsp),%xmm0
  729001:	00 00 
  729003:	f3 0f 6f 8c 24 08 01 	movdqu 0x108(%rsp),%xmm1
  72900a:	00 00 
  72900c:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  729013:	00 
  729014:	0f 10 9c 24 28 01 00 	movups 0x128(%rsp),%xmm3
  72901b:	00 
  72901c:	0f 29 9c 24 80 01 00 	movaps %xmm3,0x180(%rsp)
  729023:	00 
  729024:	0f 29 94 24 70 01 00 	movaps %xmm2,0x170(%rsp)
  72902b:	00 
  72902c:	66 0f 7f 8c 24 60 01 	movdqa %xmm1,0x160(%rsp)
  729033:	00 00 
  729035:	66 0f 7f 84 24 50 01 	movdqa %xmm0,0x150(%rsp)
  72903c:	00 00 
  72903e:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  729045:	00 
  729046:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  72904d:	4c 89 ee             	mov    %r13,%rsi
  729050:	44 89 fa             	mov    %r15d,%edx
  729053:	ff 15 87 f3 3f 00    	call   *0x3ff387(%rip)        # b283e0 <_DYNAMIC+0x728>
  729059:	41 08 86 1f 08 00 00 	or     %al,0x81f(%r14)
  729060:	44 8b 7c 24 10       	mov    0x10(%rsp),%r15d
  729065:	0f b6 ac 24 90 00 00 	movzbl 0x90(%rsp),%ebp
  72906c:	00 
  72906d:	41 83 ff 01          	cmp    $0x1,%r15d
  729071:	75 25                	jne    729098 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x5f8>
  729073:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  72907a:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  72907e:	39 c1                	cmp    %eax,%ecx
  729080:	0f 94 c2             	sete   %dl
  729083:	40 84 d5             	test   %dl,%bpl
  729086:	75 26                	jne    7290ae <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x60e>
  729088:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  72908f:	01 00 00 00 
  729093:	e9 03 03 00 00       	jmp    72939b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x8fb>
  729098:	40 f6 c5 01          	test   $0x1,%bpl
  72909c:	74 10                	je     7290ae <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x60e>
  72909e:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  7290a5:	01 00 00 00 
  7290a9:	e9 01 04 00 00       	jmp    7294af <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xa0f>
  7290ae:	8b 54 24 18          	mov    0x18(%rsp),%edx
  7290b2:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  7290b9:	00 
  7290ba:	83 fa 01             	cmp    $0x1,%edx
  7290bd:	0f 85 b2 01 00 00    	jne    729275 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x7d5>
  7290c3:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  7290ca:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  7290ce:	0f 94 c0             	sete   %al
  7290d1:	be 01 00 00 00       	mov    $0x1,%esi
  7290d6:	84 c1                	test   %al,%cl
  7290d8:	0f 85 a5 01 00 00    	jne    729283 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x7e3>
  7290de:	e9 a0 02 00 00       	jmp    729383 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x8e3>
  7290e3:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  7290ea:	00 00 00 00 
  7290ee:	0f 57 c0             	xorps  %xmm0,%xmm0
  7290f1:	48 8b bd 00 01 00 00 	mov    0x100(%rbp),%rdi
  7290f8:	48 85 ff             	test   %rdi,%rdi
  7290fb:	0f 84 e8 fb ff ff    	je     728ce9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x249>
  729101:	48 83 c7 48          	add    $0x48,%rdi
  729105:	4c 89 ee             	mov    %r13,%rsi
  729108:	44 89 fa             	mov    %r15d,%edx
  72910b:	4c 89 e1             	mov    %r12,%rcx
  72910e:	e8 fd d3 02 00       	call   756510 <<gpui::property::Overrides<gpui::property::GeometryStyle>>::set_value>
  729113:	48 89 c1             	mov    %rax,%rcx
  729116:	48 c1 e9 20          	shr    $0x20,%rcx
  72911a:	a8 01                	test   $0x1,%al
  72911c:	74 16                	je     729134 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x694>
  72911e:	c1 e8 10             	shr    $0x10,%eax
  729121:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  729128:	66 89 43 08          	mov    %ax,0x8(%rbx)
  72912c:	89 4b 0a             	mov    %ecx,0xa(%rbx)
  72912f:	e9 bc 05 00 00       	jmp    7296f0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc50>
  729134:	66 0f 6e c1          	movd   %ecx,%xmm0
  729138:	89 8c 24 40 01 00 00 	mov    %ecx,0x140(%rsp)
  72913f:	48 8b bd 00 01 00 00 	mov    0x100(%rbp),%rdi
  729146:	4c 89 ee             	mov    %r13,%rsi
  729149:	ff 15 99 f2 3f 00    	call   *0x3ff299(%rip)        # b283e8 <_DYNAMIC+0x730>
  72914f:	48 8b 85 00 01 00 00 	mov    0x100(%rbp),%rax
  729156:	48 83 78 10 00       	cmpq   $0x0,0x10(%rax)
  72915b:	75 3a                	jne    729197 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x6f7>
  72915d:	48 83 78 58 00       	cmpq   $0x0,0x58(%rax)
  729162:	75 33                	jne    729197 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x6f7>
  729164:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  729169:	75 2c                	jne    729197 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x6f7>
  72916b:	48 83 78 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rax)
  729170:	75 25                	jne    729197 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x6f7>
  729172:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  729179:	48 8b b8 00 01 00 00 	mov    0x100(%rax),%rdi
  729180:	e8 ab af fc ff       	call   6f4130 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::geometry::Geometry>>>>
  729185:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  72918c:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  729193:	00 00 00 00 
  729197:	48 8b 05 02 ef 3f 00 	mov    0x3fef02(%rip),%rax        # b280a0 <_DYNAMIC+0x3e8>
  72919e:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  7291a5:	00 
  7291a6:	48 8d b4 24 40 01 00 	lea    0x140(%rsp),%rsi
  7291ad:	00 
  7291ae:	ff 50 18             	call   *0x18(%rax)
  7291b1:	34 01                	xor    $0x1,%al
  7291b3:	0f b6 c0             	movzbl %al,%eax
  7291b6:	49 89 86 08 07 00 00 	mov    %rax,0x708(%r14)
  7291bd:	41 08 86 1f 08 00 00 	or     %al,0x81f(%r14)
  7291c4:	4d 8b be 10 06 00 00 	mov    0x610(%r14),%r15
  7291cb:	4d 85 ff             	test   %r15,%r15
  7291ce:	0f 84 e1 04 00 00    	je     7296b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc15>
  7291d4:	49 83 bf d8 00 00 00 	cmpq   $0x0,0xd8(%r15)
  7291db:	00 
  7291dc:	0f 85 d3 04 00 00    	jne    7296b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc15>
  7291e2:	49 83 bf e0 00 00 00 	cmpq   $0x0,0xe0(%r15)
  7291e9:	00 
  7291ea:	0f 85 c5 04 00 00    	jne    7296b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc15>
  7291f0:	49 83 bf 00 01 00 00 	cmpq   $0x0,0x100(%r15)
  7291f7:	00 
  7291f8:	0f 85 b7 04 00 00    	jne    7296b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc15>
  7291fe:	49 83 bf d0 00 00 00 	cmpq   $0x0,0xd0(%r15)
  729205:	00 
  729206:	0f 85 a9 04 00 00    	jne    7296b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc15>
  72920c:	49 83 bf f8 00 00 00 	cmpq   $0x0,0xf8(%r15)
  729213:	00 
  729214:	0f 85 9b 04 00 00    	jne    7296b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc15>
  72921a:	49 8b 47 60          	mov    0x60(%r15),%rax
  72921e:	83 f8 ff             	cmp    $0xffffffff,%eax
  729221:	0f 85 8e 04 00 00    	jne    7296b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc15>
  729227:	49 83 7f 28 00       	cmpq   $0x0,0x28(%r15)
  72922c:	0f 85 83 04 00 00    	jne    7296b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc15>
  729232:	49 8b 07             	mov    (%r15),%rax
  729235:	49 0b 47 40          	or     0x40(%r15),%rax
  729239:	0f 85 76 04 00 00    	jne    7296b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc15>
  72923f:	49 83 7f 58 00       	cmpq   $0x0,0x58(%r15)
  729244:	0f 85 6b 04 00 00    	jne    7296b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc15>
  72924a:	4c 89 ff             	mov    %r15,%rdi
  72924d:	e8 9e fb fc ff       	call   6f8df0 <core::ptr::drop_glue::<gpui::runtime::metadata::Metadata>>
  729252:	be 08 01 00 00       	mov    $0x108,%esi
  729257:	ba 08 00 00 00       	mov    $0x8,%edx
  72925c:	4c 89 ff             	mov    %r15,%rdi
  72925f:	ff 15 9b ec 3f 00    	call   *0x3fec9b(%rip)        # b27f00 <_DYNAMIC+0x248>
  729265:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  72926c:	00 00 00 00 
  729270:	e9 40 04 00 00       	jmp    7296b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc15>
  729275:	be 01 00 00 00       	mov    $0x1,%esi
  72927a:	f6 c1 01             	test   $0x1,%cl
  72927d:	0f 85 00 01 00 00    	jne    729383 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x8e3>
  729283:	8b 44 24 20          	mov    0x20(%rsp),%eax
  729287:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  72928e:	0f 85 ef 00 00 00    	jne    729383 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x8e3>
  729294:	8b 44 24 24          	mov    0x24(%rsp),%eax
  729298:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  72929f:	0f 85 de 00 00 00    	jne    729383 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x8e3>
  7292a5:	8b 44 24 28          	mov    0x28(%rsp),%eax
  7292a9:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  7292b0:	0f 85 cd 00 00 00    	jne    729383 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x8e3>
  7292b6:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  7292bb:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  7292c2:	0f 85 bb 00 00 00    	jne    729383 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x8e3>
  7292c8:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  7292cd:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  7292d4:	0f 85 a9 00 00 00    	jne    729383 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x8e3>
  7292da:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  7292df:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  7292e6:	0f 85 97 00 00 00    	jne    729383 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x8e3>
  7292ec:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  7292f1:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  7292f8:	0f 85 85 00 00 00    	jne    729383 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x8e3>
  7292fe:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  729302:	88 8c 24 80 00 00 00 	mov    %cl,0x80(%rsp)
  729309:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  72930e:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  729315:	00 
  729316:	e8 d5 17 00 00       	call   72aaf0 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  72931b:	84 c0                	test   %al,%al
  72931d:	74 53                	je     729372 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x8d2>
  72931f:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  729325:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  72932c:	00 00 
  72932e:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  729332:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  729336:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72933b:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  729342:	00 
  729343:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  729347:	be 01 00 00 00       	mov    $0x1,%esi
  72934c:	75 35                	jne    729383 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x8e3>
  72934e:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  729354:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  72935b:	00 00 
  72935d:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  729361:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  729365:	31 f6                	xor    %esi,%esi
  729367:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72936c:	40 0f 95 c6          	setne  %sil
  729370:	eb 11                	jmp    729383 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x8e3>
  729372:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  729379:	00 
  72937a:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  72937e:	be 01 00 00 00       	mov    $0x1,%esi
  729383:	49 89 b6 08 07 00 00 	mov    %rsi,0x708(%r14)
  72938a:	41 f6 c7 01          	test   $0x1,%r15b
  72938e:	74 2b                	je     7293bb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x91b>
  729390:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  729397:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  72939b:	39 c1                	cmp    %eax,%ecx
  72939d:	0f 94 c0             	sete   %al
  7293a0:	40 20 c5             	and    %al,%bpl
  7293a3:	40 80 fd 01          	cmp    $0x1,%bpl
  7293a7:	0f 85 02 01 00 00    	jne    7294af <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xa0f>
  7293ad:	8b 54 24 18          	mov    0x18(%rsp),%edx
  7293b1:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  7293b8:	00 
  7293b9:	eb 0a                	jmp    7293c5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x925>
  7293bb:	40 f6 c5 01          	test   $0x1,%bpl
  7293bf:	0f 85 ea 00 00 00    	jne    7294af <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xa0f>
  7293c5:	83 fa 01             	cmp    $0x1,%edx
  7293c8:	75 17                	jne    7293e1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x941>
  7293ca:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  7293d1:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  7293d5:	0f 94 c0             	sete   %al
  7293d8:	84 c1                	test   %al,%cl
  7293da:	75 0e                	jne    7293ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0x94a>
  7293dc:	e9 ce 00 00 00       	jmp    7294af <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xa0f>
  7293e1:	f6 c1 01             	test   $0x1,%cl
  7293e4:	0f 85 c5 00 00 00    	jne    7294af <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xa0f>
  7293ea:	8b 44 24 20          	mov    0x20(%rsp),%eax
  7293ee:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  7293f5:	0f 85 b4 00 00 00    	jne    7294af <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xa0f>
  7293fb:	8b 44 24 24          	mov    0x24(%rsp),%eax
  7293ff:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  729406:	0f 85 a3 00 00 00    	jne    7294af <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xa0f>
  72940c:	8b 44 24 28          	mov    0x28(%rsp),%eax
  729410:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  729417:	0f 85 92 00 00 00    	jne    7294af <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xa0f>
  72941d:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  729422:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  729429:	0f 85 80 00 00 00    	jne    7294af <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xa0f>
  72942f:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  729434:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  72943b:	75 72                	jne    7294af <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xa0f>
  72943d:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  729442:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  729449:	75 64                	jne    7294af <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xa0f>
  72944b:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  729450:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  729457:	75 56                	jne    7294af <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xa0f>
  729459:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  72945e:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  729465:	00 
  729466:	e8 85 16 00 00       	call   72aaf0 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  72946b:	84 c0                	test   %al,%al
  72946d:	74 40                	je     7294af <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xa0f>
  72946f:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  729475:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  72947c:	00 00 
  72947e:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  729482:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  729486:	3d ff ff 00 00       	cmp    $0xffff,%eax
  72948b:	75 22                	jne    7294af <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xa0f>
  72948d:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  729493:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  72949a:	00 00 
  72949c:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  7294a0:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  7294a4:	3d ff ff 00 00       	cmp    $0xffff,%eax
  7294a9:	0f 84 06 02 00 00    	je     7296b5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc15>
  7294af:	45 89 e0             	mov    %r12d,%r8d
  7294b2:	8b 6c 24 18          	mov    0x18(%rsp),%ebp
  7294b6:	0f b6 7c 24 64       	movzbl 0x64(%rsp),%edi
  7294bb:	44 0f b6 64 24 65    	movzbl 0x65(%rsp),%r12d
  7294c1:	0f b6 4c 24 66       	movzbl 0x66(%rsp),%ecx
  7294c6:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  7294cb:	88 84 24 80 00 00 00 	mov    %al,0x80(%rsp)
  7294d2:	8b b4 24 f0 00 00 00 	mov    0xf0(%rsp),%esi
  7294d9:	0f 10 5c 24 1c       	movups 0x1c(%rsp),%xmm3
  7294de:	f3 0f 10 44 24 20    	movss  0x20(%rsp),%xmm0
  7294e4:	0f 10 a4 24 f4 00 00 	movups 0xf4(%rsp),%xmm4
  7294eb:	00 
  7294ec:	f3 0f 10 8c 24 f8 00 	movss  0xf8(%rsp),%xmm1
  7294f3:	00 00 
  7294f5:	44 0f b6 9c 24 3c 01 	movzbl 0x13c(%rsp),%r11d
  7294fc:	00 00 
  7294fe:	44 0f b6 8c 24 3d 01 	movzbl 0x13d(%rsp),%r9d
  729505:	00 00 
  729507:	0f b6 84 24 3e 01 00 	movzbl 0x13e(%rsp),%eax
  72950e:	00 
  72950f:	44 0f b6 94 24 3f 01 	movzbl 0x13f(%rsp),%r10d
  729516:	00 00 
  729518:	41 f6 c7 01          	test   $0x1,%r15b
  72951c:	74 22                	je     729540 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xaa0>
  72951e:	f3 0f 10 54 24 14    	movss  0x14(%rsp),%xmm2
  729524:	0f 2e 94 24 ec 00 00 	ucomiss 0xec(%rsp),%xmm2
  72952b:	00 
  72952c:	41 0f 9b c7          	setnp  %r15b
  729530:	0f 94 c2             	sete   %dl
  729533:	44 20 fa             	and    %r15b,%dl
  729536:	41 84 d0             	test   %dl,%r8b
  729539:	75 0f                	jne    72954a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xaaa>
  72953b:	e9 a3 00 00 00       	jmp    7295e3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xb43>
  729540:	41 f6 c0 01          	test   $0x1,%r8b
  729544:	0f 85 99 00 00 00    	jne    7295e3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xb43>
  72954a:	83 fd 01             	cmp    $0x1,%ebp
  72954d:	75 3c                	jne    72958b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xaeb>
  72954f:	44 30 df             	xor    %r11b,%dil
  729552:	30 c1                	xor    %al,%cl
  729554:	0f b6 84 24 80 00 00 	movzbl 0x80(%rsp),%eax
  72955b:	00 
  72955c:	44 30 d0             	xor    %r10b,%al
  72955f:	45 38 cc             	cmp    %r9b,%r12b
  729562:	0f 94 c2             	sete   %dl
  729565:	0f 28 c3             	movaps %xmm3,%xmm0
  729568:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  72956c:	44 0f 50 c0          	movmskps %xmm0,%r8d
  729570:	41 80 f0 0f          	xor    $0xf,%r8b
  729574:	40 08 f9             	or     %dil,%cl
  729577:	44 08 c1             	or     %r8b,%cl
  72957a:	08 c1                	or     %al,%cl
  72957c:	0f 94 c0             	sete   %al
  72957f:	40 20 f0             	and    %sil,%al
  729582:	84 d0                	test   %dl,%al
  729584:	74 5d                	je     7295e3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xb43>
  729586:	e9 83 00 00 00       	jmp    72960e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xb6e>
  72958b:	0f 2e c1             	ucomiss %xmm1,%xmm0
  72958e:	0f 9b c2             	setnp  %dl
  729591:	40 0f 94 c5          	sete   %bpl
  729595:	40 20 d5             	and    %dl,%bpl
  729598:	40 f6 d6             	not    %sil
  72959b:	40 20 ee             	and    %bpl,%sil
  72959e:	0f 28 c3             	movaps %xmm3,%xmm0
  7295a1:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  7295a5:	0f 50 d0             	movmskps %xmm0,%edx
  7295a8:	89 d5                	mov    %edx,%ebp
  7295aa:	40 c0 ed 03          	shr    $0x3,%bpl
  7295ae:	c0 ea 02             	shr    $0x2,%dl
  7295b1:	40 20 f2             	and    %sil,%dl
  7295b4:	44 38 df             	cmp    %r11b,%dil
  7295b7:	40 0f 94 c6          	sete   %sil
  7295bb:	40 20 ee             	and    %bpl,%sil
  7295be:	40 20 d6             	and    %dl,%sil
  7295c1:	38 c1                	cmp    %al,%cl
  7295c3:	0f 94 c1             	sete   %cl
  7295c6:	44 38 94 24 80 00 00 	cmp    %r10b,0x80(%rsp)
  7295cd:	00 
  7295ce:	0f 94 c0             	sete   %al
  7295d1:	20 c8                	and    %cl,%al
  7295d3:	45 38 cc             	cmp    %r9b,%r12b
  7295d6:	0f 94 c1             	sete   %cl
  7295d9:	20 c1                	and    %al,%cl
  7295db:	40 20 f1             	and    %sil,%cl
  7295de:	80 f9 01             	cmp    $0x1,%cl
  7295e1:	74 2b                	je     72960e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xb6e>
  7295e3:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  7295ea:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  7295ef:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
  7295f4:	0f 29 a4 24 80 00 00 	movaps %xmm4,0x80(%rsp)
  7295fb:	00 
  7295fc:	e8 cf a9 01 00       	call   743fd0 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  729601:	0f 28 a4 24 80 00 00 	movaps 0x80(%rsp),%xmm4
  729608:	00 
  729609:	0f 28 5c 24 70       	movaps 0x70(%rsp),%xmm3
  72960e:	0f c2 dc 04          	cmpneqps %xmm4,%xmm3
  729612:	66 0f c5 c3 06       	pextrw $0x6,%xmm3,%eax
  729617:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  72961e:	a8 01                	test   $0x1,%al
  729620:	74 73                	je     729695 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xbf5>
  729622:	49 39 cd             	cmp    %rcx,%r13
  729625:	0f 83 51 02 00 00    	jae    72987c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xddc>
  72962b:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  729632:	4a 8d 14 ad 00 00 00 	lea    0x0(,%r13,4),%rdx
  729639:	00 
  72963a:	4c 01 ea             	add    %r13,%rdx
  72963d:	8b 7c d0 20          	mov    0x20(%rax,%rdx,8),%edi
  729641:	89 f8                	mov    %edi,%eax
  729643:	83 e0 07             	and    $0x7,%eax
  729646:	83 f8 06             	cmp    $0x6,%eax
  729649:	74 4a                	je     729695 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xbf5>
  72964b:	c1 ef 03             	shr    $0x3,%edi
  72964e:	74 45                	je     729695 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xbf5>
  729650:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  729657:	ff cf                	dec    %edi
  729659:	48 39 fe             	cmp    %rdi,%rsi
  72965c:	0f 86 2d 02 00 00    	jbe    72988f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xdef>
  729662:	4d 8b be b0 02 00 00 	mov    0x2b0(%r14),%r15
  729669:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  72966d:	48 c1 e0 04          	shl    $0x4,%rax
  729671:	49 83 3c 07 fe       	cmpq   $0xfffffffffffffffe,(%r15,%rax,1)
  729676:	0f 84 a6 01 00 00    	je     729822 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xd82>
  72967c:	49 01 c7             	add    %rax,%r15
  72967f:	4c 89 ff             	mov    %r15,%rdi
  729682:	e8 d9 ad fc ff       	call   6f4460 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  729687:	49 c7 07 ff ff ff ff 	movq   $0xffffffffffffffff,(%r15)
  72968e:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  729695:	48 8d 94 24 e8 00 00 	lea    0xe8(%rsp),%rdx
  72969c:	00 
  72969d:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  7296a4:	4c 89 ee             	mov    %r13,%rsi
  7296a7:	ff 15 33 ea 3f 00    	call   *0x3fea33(%rip)        # b280e0 <_DYNAMIC+0x428>
  7296ad:	41 c6 86 1f 08 00 00 	movb   $0x1,0x81f(%r14)
  7296b4:	01 
  7296b5:	48 8b 84 24 a8 01 00 	mov    0x1a8(%rsp),%rax
  7296bc:	00 
  7296bd:	49 89 86 60 06 00 00 	mov    %rax,0x660(%r14)
  7296c4:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  7296cb:	48 8b 84 24 98 01 00 	mov    0x198(%rsp),%rax
  7296d2:	00 
  7296d3:	48 8d 0d a6 0e 3d 00 	lea    0x3d0ea6(%rip),%rcx        # afa580 <__frame_dummy_init_array_entry+0x1058>
  7296da:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  7296df:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  7296e3:	74 1d                	je     729702 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc62>
  7296e5:	48 89 df             	mov    %rbx,%rdi
  7296e8:	4c 89 f6             	mov    %r14,%rsi
  7296eb:	e8 30 02 ff ff       	call   719920 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  7296f0:	48 81 c4 08 02 00 00 	add    $0x208,%rsp
  7296f7:	5b                   	pop    %rbx
  7296f8:	41 5c                	pop    %r12
  7296fa:	41 5d                	pop    %r13
  7296fc:	41 5e                	pop    %r14
  7296fe:	41 5f                	pop    %r15
  729700:	5d                   	pop    %rbp
  729701:	c3                   	ret
  729702:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  729709:	48 85 c0             	test   %rax,%rax
  72970c:	74 d7                	je     7296e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc45>
  72970e:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  729715:	48 85 c9             	test   %rcx,%rcx
  729718:	74 74                	je     72978e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xcee>
  72971a:	48 89 ca             	mov    %rcx,%rdx
  72971d:	48 83 e2 07          	and    $0x7,%rdx
  729721:	74 24                	je     729747 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xca7>
  729723:	31 f6                	xor    %esi,%esi
  729725:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  72972c:	00 00 00 00 
  729730:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729737:	48 ff c6             	inc    %rsi
  72973a:	48 39 f2             	cmp    %rsi,%rdx
  72973d:	75 f1                	jne    729730 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc90>
  72973f:	48 89 ca             	mov    %rcx,%rdx
  729742:	48 29 f2             	sub    %rsi,%rdx
  729745:	eb 03                	jmp    72974a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xcaa>
  729747:	48 89 ca             	mov    %rcx,%rdx
  72974a:	48 83 f9 08          	cmp    $0x8,%rcx
  72974e:	72 3e                	jb     72978e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xcee>
  729750:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729757:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72975e:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729765:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72976c:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729773:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  72977a:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729781:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  729788:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  72978c:	75 c2                	jne    729750 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xcb0>
  72978e:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  729795:	00 
  729796:	0f 84 49 ff ff ff    	je     7296e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc45>
  72979c:	48 83 38 00          	cmpq   $0x0,(%rax)
  7297a0:	0f 85 3f ff ff ff    	jne    7296e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc45>
  7297a6:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  7297ad:	00 
  7297ae:	4c 89 f6             	mov    %r14,%rsi
  7297b1:	48 8b 94 24 a0 01 00 	mov    0x1a0(%rsp),%rdx
  7297b8:	00 
  7297b9:	31 c9                	xor    %ecx,%ecx
  7297bb:	e8 e0 0c fd ff       	call   6fa4a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with>
  7297c0:	83 bc 24 40 01 00 00 	cmpl   $0xfffffffe,0x140(%rsp)
  7297c7:	fe 
  7297c8:	0f 84 17 ff ff ff    	je     7296e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc45>
  7297ce:	48 8b 84 24 70 01 00 	mov    0x170(%rsp),%rax
  7297d5:	00 
  7297d6:	48 89 43 30          	mov    %rax,0x30(%rbx)
  7297da:	0f 10 84 24 40 01 00 	movups 0x140(%rsp),%xmm0
  7297e1:	00 
  7297e2:	0f 10 8c 24 50 01 00 	movups 0x150(%rsp),%xmm1
  7297e9:	00 
  7297ea:	0f 10 94 24 60 01 00 	movups 0x160(%rsp),%xmm2
  7297f1:	00 
  7297f2:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  7297f6:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  7297fa:	0f 11 03             	movups %xmm0,(%rbx)
  7297fd:	e9 ee fe ff ff       	jmp    7296f0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::set_property_value_at+0xc50>
  729802:	bf 08 00 00 00       	mov    $0x8,%edi
  729807:	be 08 01 00 00       	mov    $0x108,%esi
  72980c:	ff 15 16 e7 3f 00    	call   *0x3fe716(%rip)        # b27f28 <_DYNAMIC+0x270>
  729812:	bf 08 00 00 00       	mov    $0x8,%edi
  729817:	be 60 00 00 00       	mov    $0x60,%esi
  72981c:	ff 15 06 e7 3f 00    	call   *0x3fe706(%rip)        # b27f28 <_DYNAMIC+0x270>
  729822:	48 8d 3d 7f fe 3c 00 	lea    0x3cfe7f(%rip),%rdi        # af96a8 <__frame_dummy_init_array_entry+0x180>
  729829:	ff 15 91 e7 3f 00    	call   *0x3fe791(%rip)        # b27fc0 <_DYNAMIC+0x308>
  72982f:	48 8d 15 9a 03 3d 00 	lea    0x3d039a(%rip),%rdx        # af9bd0 <__frame_dummy_init_array_entry+0x6a8>
  729836:	4c 89 ef             	mov    %r13,%rdi
  729839:	ff 15 d1 e7 3f 00    	call   *0x3fe7d1(%rip)        # b28010 <_DYNAMIC+0x358>
  72983f:	48 8d 15 62 0a 3d 00 	lea    0x3d0a62(%rip),%rdx        # afa2a8 <__frame_dummy_init_array_entry+0xd80>
  729846:	4c 89 ef             	mov    %r13,%rdi
  729849:	ff 15 c1 e7 3f 00    	call   *0x3fe7c1(%rip)        # b28010 <_DYNAMIC+0x358>
  72984f:	48 8d 15 92 01 3d 00 	lea    0x3d0192(%rip),%rdx        # af99e8 <__frame_dummy_init_array_entry+0x4c0>
  729856:	4c 89 ef             	mov    %r13,%rdi
  729859:	ff 15 b1 e7 3f 00    	call   *0x3fe7b1(%rip)        # b28010 <_DYNAMIC+0x358>
  72985f:	48 8d 15 6a 01 3d 00 	lea    0x3d016a(%rip),%rdx        # af99d0 <__frame_dummy_init_array_entry+0x4a8>
  729866:	4c 89 ef             	mov    %r13,%rdi
  729869:	ff 15 a1 e7 3f 00    	call   *0x3fe7a1(%rip)        # b28010 <_DYNAMIC+0x358>
  72986f:	48 8d 15 8a 01 3d 00 	lea    0x3d018a(%rip),%rdx        # af9a00 <__frame_dummy_init_array_entry+0x4d8>
  729876:	ff 15 94 e7 3f 00    	call   *0x3fe794(%rip)        # b28010 <_DYNAMIC+0x358>
  72987c:	48 8d 15 3d 0a 3d 00 	lea    0x3d0a3d(%rip),%rdx        # afa2c0 <__frame_dummy_init_array_entry+0xd98>
  729883:	4c 89 ef             	mov    %r13,%rdi
  729886:	48 89 ce             	mov    %rcx,%rsi
  729889:	ff 15 81 e7 3f 00    	call   *0x3fe781(%rip)        # b28010 <_DYNAMIC+0x358>
  72988f:	48 8d 15 fa fd 3c 00 	lea    0x3cfdfa(%rip),%rdx        # af9690 <__frame_dummy_init_array_entry+0x168>
  729896:	ff 15 74 e7 3f 00    	call   *0x3fe774(%rip)        # b28010 <_DYNAMIC+0x358>
  72989c:	48 89 c3             	mov    %rax,%rbx
  72989f:	be 08 01 00 00       	mov    $0x108,%esi
  7298a4:	ba 08 00 00 00       	mov    $0x8,%edx
  7298a9:	4c 89 ff             	mov    %r15,%rdi
  7298ac:	ff 15 4e e6 3f 00    	call   *0x3fe64e(%rip)        # b27f00 <_DYNAMIC+0x248>
  7298b2:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  7298b9:	00 00 00 00 
  7298bd:	48 89 df             	mov    %rbx,%rdi
  7298c0:	e8 ab e8 3c 00       	call   af8170 <_Unwind_Resume@plt>
  7298c5:	48 89 c3             	mov    %rax,%rbx
  7298c8:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  7298cf:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  7298d6:	00 00 00 00 
  7298da:	48 89 df             	mov    %rbx,%rdi
  7298dd:	e8 8e e8 3c 00       	call   af8170 <_Unwind_Resume@plt>
  7298e2:	49 c7 07 ff ff ff ff 	movq   $0xffffffffffffffff,(%r15)
  7298e9:	48 89 c7             	mov    %rax,%rdi
  7298ec:	e8 7f e8 3c 00       	call   af8170 <_Unwind_Resume@plt>
