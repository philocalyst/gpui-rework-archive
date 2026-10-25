
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000071ee50 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at>:
  71ee50:	55                   	push   %rbp
  71ee51:	41 57                	push   %r15
  71ee53:	41 56                	push   %r14
  71ee55:	41 55                	push   %r13
  71ee57:	41 54                	push   %r12
  71ee59:	53                   	push   %rbx
  71ee5a:	48 81 ec f8 01 00 00 	sub    $0x1f8,%rsp
  71ee61:	4d 89 c5             	mov    %r8,%r13
  71ee64:	89 cd                	mov    %ecx,%ebp
  71ee66:	49 89 d7             	mov    %rdx,%r15
  71ee69:	49 89 f6             	mov    %rsi,%r14
  71ee6c:	48 89 fb             	mov    %rdi,%rbx
  71ee6f:	45 0f b6 20          	movzbl (%r8),%r12d
  71ee73:	41 80 fc ff          	cmp    $0xff,%r12b
  71ee77:	74 1c                	je     71ee95 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x45>
  71ee79:	89 ef                	mov    %ebp,%edi
  71ee7b:	4c 89 ee             	mov    %r13,%rsi
  71ee7e:	ff 15 b4 34 3e 00    	call   *0x3e34b4(%rip)        # b02338 <_DYNAMIC+0x520>
  71ee84:	66 85 c0             	test   %ax,%ax
  71ee87:	74 0c                	je     71ee95 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x45>
  71ee89:	48 89 c1             	mov    %rax,%rcx
  71ee8c:	48 c1 e9 10          	shr    $0x10,%rcx
  71ee90:	e9 28 06 00 00       	jmp    71f4bd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x66d>
  71ee95:	0f b7 c5             	movzwl %bp,%eax
  71ee98:	48 8d 0d 71 5b 3b 00 	lea    0x3b5b71(%rip),%rcx        # ad4a10 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1198>
  71ee9f:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  71eea4:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  71eea8:	74 78                	je     71ef22 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xd2>
  71eeaa:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  71eeb1:	49 39 f7             	cmp    %rsi,%r15
  71eeb4:	0f 83 d7 0b 00 00    	jae    71fa91 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc41>
  71eeba:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  71eec1:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  71eec5:	4c 8b 3c c8          	mov    (%rax,%rcx,8),%r15
  71eec9:	4d 8b a6 10 06 00 00 	mov    0x610(%r14),%r12
  71eed0:	4d 85 e4             	test   %r12,%r12
  71eed3:	0f 84 d4 00 00 00    	je     71efad <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x15d>
  71eed9:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  71eee0:	00 
  71eee1:	48 85 ff             	test   %rdi,%rdi
  71eee4:	0f 84 22 05 00 00    	je     71f40c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x5bc>
  71eeea:	4c 89 fe             	mov    %r15,%rsi
  71eeed:	ff 15 fd 34 3e 00    	call   *0x3e34fd(%rip)        # b023f0 <_DYNAMIC+0x5d8>
  71eef3:	4d 8b a6 10 06 00 00 	mov    0x610(%r14),%r12
  71eefa:	66 0f 7e 84 24 e8 00 	movd   %xmm0,0xe8(%rsp)
  71ef01:	00 00 
  71ef03:	4d 85 e4             	test   %r12,%r12
  71ef06:	0f 84 b0 00 00 00    	je     71efbc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x16c>
  71ef0c:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  71ef13:	00 
  71ef14:	48 85 ff             	test   %rdi,%rdi
  71ef17:	0f 85 81 05 00 00    	jne    71f49e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x64e>
  71ef1d:	e9 06 05 00 00       	jmp    71f428 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x5d8>
  71ef22:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  71ef29:	49 39 f7             	cmp    %rsi,%r15
  71ef2c:	0f 83 6f 0b 00 00    	jae    71faa1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc51>
  71ef32:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  71ef39:	4b 8d 0c bf          	lea    (%r15,%r15,4),%rcx
  71ef3d:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  71ef41:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  71ef46:	49 8b 86 00 02 00 00 	mov    0x200(%r14),%rax
  71ef4d:	48 8d 0d 68 79 94 ff 	lea    -0x6b8698(%rip),%rcx        # 668bc <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x9c>
  71ef54:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  71ef58:	48 01 c8             	add    %rcx,%rax
  71ef5b:	ff e0                	jmp    *%rax
  71ef5d:	0f 10 05 00 7b 94 ff 	movups -0x6b8500(%rip),%xmm0        # 66a64 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x244>
  71ef64:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  71ef69:	0f 10 05 e4 7a 94 ff 	movups -0x6b851c(%rip),%xmm0        # 66a54 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x234>
  71ef70:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  71ef75:	0f 10 05 c8 7a 94 ff 	movups -0x6b8538(%rip),%xmm0        # 66a44 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x224>
  71ef7c:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  71ef81:	0f 10 05 ac 7a 94 ff 	movups -0x6b8554(%rip),%xmm0        # 66a34 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x214>
  71ef88:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  71ef8d:	0f 10 05 90 7a 94 ff 	movups -0x6b8570(%rip),%xmm0        # 66a24 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x204>
  71ef94:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  71ef99:	48 b8 00 00 00 00 01 	movabs $0x3000100000000,%rax
  71efa0:	00 03 00 
  71efa3:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  71efa8:	e9 81 01 00 00       	jmp    71f12e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x2de>
  71efad:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  71efb4:	00 00 00 00 
  71efb8:	66 0f ef c0          	pxor   %xmm0,%xmm0
  71efbc:	66 0f 7e 44 24 70    	movd   %xmm0,0x70(%rsp)
  71efc2:	ff 15 b0 30 3e 00    	call   *0x3e30b0(%rip)        # b02078 <_DYNAMIC+0x260>
  71efc8:	bf 08 01 00 00       	mov    $0x108,%edi
  71efcd:	be 08 00 00 00       	mov    $0x8,%esi
  71efd2:	ff 15 80 30 3e 00    	call   *0x3e3080(%rip)        # b02058 <_DYNAMIC+0x240>
  71efd8:	48 85 c0             	test   %rax,%rax
  71efdb:	0f 84 83 0a 00 00    	je     71fa64 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc14>
  71efe1:	49 89 c4             	mov    %rax,%r12
  71efe4:	66 0f ef c0          	pxor   %xmm0,%xmm0
  71efe8:	f3 0f 7f 80 d8 00 00 	movdqu %xmm0,0xd8(%rax)
  71efef:	00 
  71eff0:	f3 0f 7f 40 28       	movdqu %xmm0,0x28(%rax)
  71eff5:	f3 0f 7f 40 40       	movdqu %xmm0,0x40(%rax)
  71effa:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  71f001:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  71f008:	00 
  71f009:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  71f010:	00 
  71f011:	48 c7 40 38 08 00 00 	movq   $0x8,0x38(%rax)
  71f018:	00 
  71f019:	48 c7 40 50 08 00 00 	movq   $0x8,0x50(%rax)
  71f020:	00 
  71f021:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  71f028:	00 
  71f029:	48 c7 40 60 ff ff ff 	movq   $0xffffffffffffffff,0x60(%rax)
  71f030:	ff 
  71f031:	48 c7 80 c0 00 00 00 	movq   $0x0,0xc0(%rax)
  71f038:	00 00 00 00 
  71f03c:	48 c7 80 c8 00 00 00 	movq   $0x8,0xc8(%rax)
  71f043:	08 00 00 00 
  71f047:	48 c7 80 d0 00 00 00 	movq   $0x0,0xd0(%rax)
  71f04e:	00 00 00 00 
  71f052:	48 c7 80 e8 00 00 00 	movq   $0x0,0xe8(%rax)
  71f059:	00 00 00 00 
  71f05d:	f3 0f 7f 80 f8 00 00 	movdqu %xmm0,0xf8(%rax)
  71f064:	00 
  71f065:	49 89 86 10 06 00 00 	mov    %rax,0x610(%r14)
  71f06c:	66 0f 6e 44 24 70    	movd   0x70(%rsp),%xmm0
  71f072:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  71f079:	00 
  71f07a:	48 85 ff             	test   %rdi,%rdi
  71f07d:	0f 85 1b 04 00 00    	jne    71f49e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x64e>
  71f083:	e9 a0 03 00 00       	jmp    71f428 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x5d8>
  71f088:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  71f08f:	49 39 f7             	cmp    %rsi,%r15
  71f092:	0f 83 19 0a 00 00    	jae    71fab1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc61>
  71f098:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  71f09f:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  71f0a6:	42 0f b6 3c 38       	movzbl (%rax,%r15,1),%edi
  71f0ab:	48 39 fe             	cmp    %rdi,%rsi
  71f0ae:	0f 86 1d 0a 00 00    	jbe    71fad1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc81>
  71f0b4:	49 8b 86 08 02 00 00 	mov    0x208(%r14),%rax
  71f0bb:	48 6b cf 58          	imul   $0x58,%rdi,%rcx
  71f0bf:	eb 32                	jmp    71f0f3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x2a3>
  71f0c1:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  71f0c8:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  71f0cd:	4c 89 fa             	mov    %r15,%rdx
  71f0d0:	ff 15 9a 30 3e 00    	call   *0x3e309a(%rip)        # b02170 <_DYNAMIC+0x358>
  71f0d6:	eb 56                	jmp    71f12e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x2de>
  71f0d8:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  71f0df:	49 39 f7             	cmp    %rsi,%r15
  71f0e2:	0f 83 d9 09 00 00    	jae    71fac1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc71>
  71f0e8:	49 8b 86 10 02 00 00 	mov    0x210(%r14),%rax
  71f0ef:	49 6b cf 58          	imul   $0x58,%r15,%rcx
  71f0f3:	48 8b 54 08 50       	mov    0x50(%rax,%rcx,1),%rdx
  71f0f8:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  71f0fd:	0f 10 44 08 40       	movups 0x40(%rax,%rcx,1),%xmm0
  71f102:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  71f107:	0f 10 04 08          	movups (%rax,%rcx,1),%xmm0
  71f10b:	0f 10 4c 08 10       	movups 0x10(%rax,%rcx,1),%xmm1
  71f110:	0f 10 54 08 20       	movups 0x20(%rax,%rcx,1),%xmm2
  71f115:	0f 10 5c 08 30       	movups 0x30(%rax,%rcx,1),%xmm3
  71f11a:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
  71f11f:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  71f124:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  71f129:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  71f12e:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  71f135:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  71f13c:	00 
  71f13d:	4c 89 fa             	mov    %r15,%rdx
  71f140:	ff 15 0a 34 3e 00    	call   *0x3e340a(%rip)        # b02550 <_DYNAMIC+0x738>
  71f146:	80 bc 24 40 01 00 00 	cmpb   $0x0,0x140(%rsp)
  71f14d:	00 
  71f14e:	74 1a                	je     71f16a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x31a>
  71f150:	48 8d 94 24 44 01 00 	lea    0x144(%rsp),%rdx
  71f157:	00 
  71f158:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  71f15f:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  71f164:	ff 15 ee 33 3e 00    	call   *0x3e33ee(%rip)        # b02558 <_DYNAMIC+0x740>
  71f16a:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  71f171:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  71f176:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  71f17d:	00 
  71f17e:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
  71f183:	0f 29 84 24 80 01 00 	movaps %xmm0,0x180(%rsp)
  71f18a:	00 
  71f18b:	66 0f 6f 44 24 10    	movdqa 0x10(%rsp),%xmm0
  71f191:	66 0f 6f 4c 24 20    	movdqa 0x20(%rsp),%xmm1
  71f197:	0f 28 54 24 30       	movaps 0x30(%rsp),%xmm2
  71f19c:	0f 28 5c 24 40       	movaps 0x40(%rsp),%xmm3
  71f1a1:	0f 29 9c 24 70 01 00 	movaps %xmm3,0x170(%rsp)
  71f1a8:	00 
  71f1a9:	0f 29 94 24 60 01 00 	movaps %xmm2,0x160(%rsp)
  71f1b0:	00 
  71f1b1:	66 0f 7f 8c 24 50 01 	movdqa %xmm1,0x150(%rsp)
  71f1b8:	00 00 
  71f1ba:	66 0f 7f 84 24 40 01 	movdqa %xmm0,0x140(%rsp)
  71f1c1:	00 00 
  71f1c3:	48 8d bc 24 a0 01 00 	lea    0x1a0(%rsp),%rdi
  71f1ca:	00 
  71f1cb:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  71f1d2:	00 
  71f1d3:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  71f1d8:	41 89 e8             	mov    %ebp,%r8d
  71f1db:	4d 89 e9             	mov    %r13,%r9
  71f1de:	e8 8d 27 01 00       	call   731970 <<gpui::property::Overrides>::set_value>
  71f1e3:	44 8b ac 24 a0 01 00 	mov    0x1a0(%rsp),%r13d
  71f1ea:	00 
  71f1eb:	41 83 fd 02          	cmp    $0x2,%r13d
  71f1ef:	75 2b                	jne    71f21c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x3cc>
  71f1f1:	0f b7 84 24 a8 01 00 	movzwl 0x1a8(%rsp),%eax
  71f1f8:	00 
  71f1f9:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  71f1fe:	8b 8c 24 a4 01 00 00 	mov    0x1a4(%rsp),%ecx
  71f205:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  71f209:	66 89 43 0c          	mov    %ax,0xc(%rbx)
  71f20d:	89 4b 08             	mov    %ecx,0x8(%rbx)
  71f210:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  71f217:	e9 36 08 00 00       	jmp    71fa52 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc02>
  71f21c:	45 31 c0             	xor    %r8d,%r8d
  71f21f:	41 80 fc ff          	cmp    $0xff,%r12b
  71f223:	41 0f 95 c0          	setne  %r8b
  71f227:	0f b7 84 24 a8 01 00 	movzwl 0x1a8(%rsp),%eax
  71f22e:	00 
  71f22f:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  71f234:	8b 8c 24 a4 01 00 00 	mov    0x1a4(%rsp),%ecx
  71f23b:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  71f23f:	0f 10 84 24 aa 01 00 	movups 0x1aa(%rsp),%xmm0
  71f246:	00 
  71f247:	0f 11 84 24 f2 00 00 	movups %xmm0,0xf2(%rsp)
  71f24e:	00 
  71f24f:	0f 10 84 24 ba 01 00 	movups 0x1ba(%rsp),%xmm0
  71f256:	00 
  71f257:	0f 11 84 24 02 01 00 	movups %xmm0,0x102(%rsp)
  71f25e:	00 
  71f25f:	0f 10 84 24 ca 01 00 	movups 0x1ca(%rsp),%xmm0
  71f266:	00 
  71f267:	0f 11 84 24 12 01 00 	movups %xmm0,0x112(%rsp)
  71f26e:	00 
  71f26f:	0f 10 84 24 da 01 00 	movups 0x1da(%rsp),%xmm0
  71f276:	00 
  71f277:	0f 11 84 24 22 01 00 	movups %xmm0,0x122(%rsp)
  71f27e:	00 
  71f27f:	0f 10 84 24 e8 01 00 	movups 0x1e8(%rsp),%xmm0
  71f286:	00 
  71f287:	0f 11 84 24 30 01 00 	movups %xmm0,0x130(%rsp)
  71f28e:	00 
  71f28f:	44 89 ac 24 e8 00 00 	mov    %r13d,0xe8(%rsp)
  71f296:	00 
  71f297:	66 89 84 24 f0 00 00 	mov    %ax,0xf0(%rsp)
  71f29e:	00 
  71f29f:	89 8c 24 ec 00 00 00 	mov    %ecx,0xec(%rsp)
  71f2a6:	0f 10 84 24 28 01 00 	movups 0x128(%rsp),%xmm0
  71f2ad:	00 
  71f2ae:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  71f2b5:	00 
  71f2b6:	0f 10 84 24 18 01 00 	movups 0x118(%rsp),%xmm0
  71f2bd:	00 
  71f2be:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  71f2c5:	00 
  71f2c6:	0f 10 84 24 08 01 00 	movups 0x108(%rsp),%xmm0
  71f2cd:	00 
  71f2ce:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  71f2d5:	00 
  71f2d6:	0f 10 84 24 f8 00 00 	movups 0xf8(%rsp),%xmm0
  71f2dd:	00 
  71f2de:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  71f2e5:	00 
  71f2e6:	0f 10 84 24 e8 00 00 	movups 0xe8(%rsp),%xmm0
  71f2ed:	00 
  71f2ee:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  71f2f5:	00 
  71f2f6:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  71f2fd:	00 
  71f2fe:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  71f305:	00 
  71f306:	4d 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%r9
  71f30d:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
  71f314:	00 
  71f315:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  71f31c:	00 
  71f31d:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  71f324:	00 
  71f325:	f3 0f 6f 84 24 f8 00 	movdqu 0xf8(%rsp),%xmm0
  71f32c:	00 00 
  71f32e:	f3 0f 6f 8c 24 08 01 	movdqu 0x108(%rsp),%xmm1
  71f335:	00 00 
  71f337:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  71f33e:	00 
  71f33f:	0f 10 9c 24 28 01 00 	movups 0x128(%rsp),%xmm3
  71f346:	00 
  71f347:	0f 29 9c 24 80 01 00 	movaps %xmm3,0x180(%rsp)
  71f34e:	00 
  71f34f:	0f 29 94 24 70 01 00 	movaps %xmm2,0x170(%rsp)
  71f356:	00 
  71f357:	66 0f 7f 8c 24 60 01 	movdqa %xmm1,0x160(%rsp)
  71f35e:	00 00 
  71f360:	66 0f 7f 84 24 50 01 	movdqa %xmm0,0x150(%rsp)
  71f367:	00 00 
  71f369:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  71f370:	00 
  71f371:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  71f378:	4c 89 fe             	mov    %r15,%rsi
  71f37b:	89 ea                	mov    %ebp,%edx
  71f37d:	ff 15 dd 31 3e 00    	call   *0x3e31dd(%rip)        # b02560 <_DYNAMIC+0x748>
  71f383:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  71f38a:	8b 6c 24 10          	mov    0x10(%rsp),%ebp
  71f38e:	44 0f b6 a4 24 90 00 	movzbl 0x90(%rsp),%r12d
  71f395:	00 00 
  71f397:	83 fd 01             	cmp    $0x1,%ebp
  71f39a:	75 25                	jne    71f3c1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x571>
  71f39c:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  71f3a3:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  71f3a7:	39 c1                	cmp    %eax,%ecx
  71f3a9:	0f 94 c2             	sete   %dl
  71f3ac:	41 84 d4             	test   %dl,%r12b
  71f3af:	75 26                	jne    71f3d7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x587>
  71f3b1:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  71f3b8:	01 00 00 00 
  71f3bc:	e9 78 03 00 00       	jmp    71f739 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8e9>
  71f3c1:	41 f6 c4 01          	test   $0x1,%r12b
  71f3c5:	74 10                	je     71f3d7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x587>
  71f3c7:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  71f3ce:	01 00 00 00 
  71f3d2:	e9 76 04 00 00       	jmp    71f84d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f3d7:	8b 54 24 18          	mov    0x18(%rsp),%edx
  71f3db:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  71f3e2:	00 
  71f3e3:	83 fa 01             	cmp    $0x1,%edx
  71f3e6:	0f 85 27 02 00 00    	jne    71f613 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x7c3>
  71f3ec:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  71f3f3:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  71f3f7:	0f 94 c0             	sete   %al
  71f3fa:	be 01 00 00 00       	mov    $0x1,%esi
  71f3ff:	84 c1                	test   %al,%cl
  71f401:	0f 85 1a 02 00 00    	jne    71f621 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x7d1>
  71f407:	e9 15 03 00 00       	jmp    71f721 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f40c:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  71f413:	00 00 00 00 
  71f417:	66 0f ef c0          	pxor   %xmm0,%xmm0
  71f41b:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  71f422:	00 
  71f423:	48 85 ff             	test   %rdi,%rdi
  71f426:	75 76                	jne    71f49e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x64e>
  71f428:	66 0f 7e 44 24 70    	movd   %xmm0,0x70(%rsp)
  71f42e:	ff 15 44 2c 3e 00    	call   *0x3e2c44(%rip)        # b02078 <_DYNAMIC+0x260>
  71f434:	bf 60 00 00 00       	mov    $0x60,%edi
  71f439:	be 08 00 00 00       	mov    $0x8,%esi
  71f43e:	ff 15 14 2c 3e 00    	call   *0x3e2c14(%rip)        # b02058 <_DYNAMIC+0x240>
  71f444:	48 85 c0             	test   %rax,%rax
  71f447:	0f 84 27 06 00 00    	je     71fa74 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc24>
  71f44d:	48 89 c7             	mov    %rax,%rdi
  71f450:	66 0f ef c0          	pxor   %xmm0,%xmm0
  71f454:	f3 0f 7f 40 10       	movdqu %xmm0,0x10(%rax)
  71f459:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  71f460:	48 c7 40 08 08 00 00 	movq   $0x8,0x8(%rax)
  71f467:	00 
  71f468:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  71f46f:	00 
  71f470:	48 c7 40 28 00 00 00 	movq   $0x0,0x28(%rax)
  71f477:	00 
  71f478:	48 c7 40 30 ff ff ff 	movq   $0xffffffffffffffff,0x30(%rax)
  71f47f:	ff 
  71f480:	48 c7 40 48 00 00 00 	movq   $0x0,0x48(%rax)
  71f487:	00 
  71f488:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  71f48f:	00 
  71f490:	49 89 84 24 00 01 00 	mov    %rax,0x100(%r12)
  71f497:	00 
  71f498:	66 0f 6e 44 24 70    	movd   0x70(%rsp),%xmm0
  71f49e:	48 83 c7 48          	add    $0x48,%rdi
  71f4a2:	4c 89 fe             	mov    %r15,%rsi
  71f4a5:	89 ea                	mov    %ebp,%edx
  71f4a7:	4c 89 e9             	mov    %r13,%rcx
  71f4aa:	e8 41 1c 01 00       	call   7310f0 <<gpui::property::Overrides<gpui::property::GeometryStyle>>::set_value>
  71f4af:	48 89 c1             	mov    %rax,%rcx
  71f4b2:	48 c1 e9 20          	shr    $0x20,%rcx
  71f4b6:	a8 01                	test   $0x1,%al
  71f4b8:	74 16                	je     71f4d0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x680>
  71f4ba:	c1 e8 10             	shr    $0x10,%eax
  71f4bd:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  71f4c4:	66 89 43 08          	mov    %ax,0x8(%rbx)
  71f4c8:	89 4b 0a             	mov    %ecx,0xa(%rbx)
  71f4cb:	e9 82 05 00 00       	jmp    71fa52 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc02>
  71f4d0:	66 0f 6e c1          	movd   %ecx,%xmm0
  71f4d4:	89 8c 24 40 01 00 00 	mov    %ecx,0x140(%rsp)
  71f4db:	49 8b bc 24 00 01 00 	mov    0x100(%r12),%rdi
  71f4e2:	00 
  71f4e3:	4c 89 fe             	mov    %r15,%rsi
  71f4e6:	ff 15 7c 30 3e 00    	call   *0x3e307c(%rip)        # b02568 <_DYNAMIC+0x750>
  71f4ec:	49 8b 84 24 00 01 00 	mov    0x100(%r12),%rax
  71f4f3:	00 
  71f4f4:	48 83 78 10 00       	cmpq   $0x0,0x10(%rax)
  71f4f9:	75 3a                	jne    71f535 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x6e5>
  71f4fb:	48 83 78 58 00       	cmpq   $0x0,0x58(%rax)
  71f500:	75 33                	jne    71f535 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x6e5>
  71f502:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  71f507:	75 2c                	jne    71f535 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x6e5>
  71f509:	48 83 78 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rax)
  71f50e:	75 25                	jne    71f535 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x6e5>
  71f510:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  71f517:	48 8b b8 00 01 00 00 	mov    0x100(%rax),%rdi
  71f51e:	e8 ad 20 fe ff       	call   7015d0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::geometry::Geometry>>>>
  71f523:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  71f52a:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  71f531:	00 00 00 00 
  71f535:	48 8b 05 f4 2c 3e 00 	mov    0x3e2cf4(%rip),%rax        # b02230 <_DYNAMIC+0x418>
  71f53c:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  71f543:	00 
  71f544:	48 8d b4 24 40 01 00 	lea    0x140(%rsp),%rsi
  71f54b:	00 
  71f54c:	ff 50 18             	call   *0x18(%rax)
  71f54f:	34 01                	xor    $0x1,%al
  71f551:	0f b6 c0             	movzbl %al,%eax
  71f554:	49 89 86 08 07 00 00 	mov    %rax,0x708(%r14)
  71f55b:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  71f562:	4d 8b be 10 06 00 00 	mov    0x610(%r14),%r15
  71f569:	4d 85 ff             	test   %r15,%r15
  71f56c:	0f 84 d9 04 00 00    	je     71fa4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f572:	49 83 bf d8 00 00 00 	cmpq   $0x0,0xd8(%r15)
  71f579:	00 
  71f57a:	0f 85 cb 04 00 00    	jne    71fa4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f580:	49 83 bf e0 00 00 00 	cmpq   $0x0,0xe0(%r15)
  71f587:	00 
  71f588:	0f 85 bd 04 00 00    	jne    71fa4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f58e:	49 83 bf 00 01 00 00 	cmpq   $0x0,0x100(%r15)
  71f595:	00 
  71f596:	0f 85 af 04 00 00    	jne    71fa4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f59c:	49 83 bf d0 00 00 00 	cmpq   $0x0,0xd0(%r15)
  71f5a3:	00 
  71f5a4:	0f 85 a1 04 00 00    	jne    71fa4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f5aa:	49 83 bf f8 00 00 00 	cmpq   $0x0,0xf8(%r15)
  71f5b1:	00 
  71f5b2:	0f 85 93 04 00 00    	jne    71fa4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f5b8:	49 8b 47 60          	mov    0x60(%r15),%rax
  71f5bc:	83 f8 ff             	cmp    $0xffffffff,%eax
  71f5bf:	0f 85 86 04 00 00    	jne    71fa4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f5c5:	49 83 7f 28 00       	cmpq   $0x0,0x28(%r15)
  71f5ca:	0f 85 7b 04 00 00    	jne    71fa4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f5d0:	49 8b 07             	mov    (%r15),%rax
  71f5d3:	49 0b 47 40          	or     0x40(%r15),%rax
  71f5d7:	0f 85 6e 04 00 00    	jne    71fa4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f5dd:	49 83 7f 58 00       	cmpq   $0x0,0x58(%r15)
  71f5e2:	0f 85 63 04 00 00    	jne    71fa4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f5e8:	4c 89 ff             	mov    %r15,%rdi
  71f5eb:	e8 60 65 fe ff       	call   705b50 <core::ptr::drop_glue::<gpui::runtime::metadata::Metadata>>
  71f5f0:	be 08 01 00 00       	mov    $0x108,%esi
  71f5f5:	ba 08 00 00 00       	mov    $0x8,%edx
  71f5fa:	4c 89 ff             	mov    %r15,%rdi
  71f5fd:	ff 15 5d 2a 3e 00    	call   *0x3e2a5d(%rip)        # b02060 <_DYNAMIC+0x248>
  71f603:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  71f60a:	00 00 00 00 
  71f60e:	e9 38 04 00 00       	jmp    71fa4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f613:	be 01 00 00 00       	mov    $0x1,%esi
  71f618:	f6 c1 01             	test   $0x1,%cl
  71f61b:	0f 85 00 01 00 00    	jne    71f721 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f621:	8b 44 24 20          	mov    0x20(%rsp),%eax
  71f625:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  71f62c:	0f 85 ef 00 00 00    	jne    71f721 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f632:	8b 44 24 24          	mov    0x24(%rsp),%eax
  71f636:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  71f63d:	0f 85 de 00 00 00    	jne    71f721 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f643:	8b 44 24 28          	mov    0x28(%rsp),%eax
  71f647:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  71f64e:	0f 85 cd 00 00 00    	jne    71f721 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f654:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  71f659:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  71f660:	0f 85 bb 00 00 00    	jne    71f721 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f666:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  71f66b:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  71f672:	0f 85 a9 00 00 00    	jne    71f721 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f678:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  71f67d:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  71f684:	0f 85 97 00 00 00    	jne    71f721 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f68a:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  71f68f:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  71f696:	0f 85 85 00 00 00    	jne    71f721 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f69c:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  71f6a0:	88 8c 24 80 00 00 00 	mov    %cl,0x80(%rsp)
  71f6a7:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  71f6ac:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  71f6b3:	00 
  71f6b4:	e8 17 08 00 00       	call   71fed0 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  71f6b9:	84 c0                	test   %al,%al
  71f6bb:	74 53                	je     71f710 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8c0>
  71f6bd:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  71f6c3:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  71f6ca:	00 00 
  71f6cc:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  71f6d0:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  71f6d4:	3d ff ff 00 00       	cmp    $0xffff,%eax
  71f6d9:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  71f6e0:	00 
  71f6e1:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  71f6e5:	be 01 00 00 00       	mov    $0x1,%esi
  71f6ea:	75 35                	jne    71f721 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f6ec:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  71f6f2:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  71f6f9:	00 00 
  71f6fb:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  71f6ff:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  71f703:	31 f6                	xor    %esi,%esi
  71f705:	3d ff ff 00 00       	cmp    $0xffff,%eax
  71f70a:	40 0f 95 c6          	setne  %sil
  71f70e:	eb 11                	jmp    71f721 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x8d1>
  71f710:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  71f717:	00 
  71f718:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  71f71c:	be 01 00 00 00       	mov    $0x1,%esi
  71f721:	49 89 b6 08 07 00 00 	mov    %rsi,0x708(%r14)
  71f728:	40 f6 c5 01          	test   $0x1,%bpl
  71f72c:	74 2b                	je     71f759 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x909>
  71f72e:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  71f735:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  71f739:	39 c1                	cmp    %eax,%ecx
  71f73b:	0f 94 c0             	sete   %al
  71f73e:	41 20 c4             	and    %al,%r12b
  71f741:	41 80 fc 01          	cmp    $0x1,%r12b
  71f745:	0f 85 02 01 00 00    	jne    71f84d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f74b:	8b 54 24 18          	mov    0x18(%rsp),%edx
  71f74f:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  71f756:	00 
  71f757:	eb 0a                	jmp    71f763 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x913>
  71f759:	41 f6 c4 01          	test   $0x1,%r12b
  71f75d:	0f 85 ea 00 00 00    	jne    71f84d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f763:	83 fa 01             	cmp    $0x1,%edx
  71f766:	75 17                	jne    71f77f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x92f>
  71f768:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  71f76f:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  71f773:	0f 94 c0             	sete   %al
  71f776:	84 c1                	test   %al,%cl
  71f778:	75 0e                	jne    71f788 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x938>
  71f77a:	e9 ce 00 00 00       	jmp    71f84d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f77f:	f6 c1 01             	test   $0x1,%cl
  71f782:	0f 85 c5 00 00 00    	jne    71f84d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f788:	8b 44 24 20          	mov    0x20(%rsp),%eax
  71f78c:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  71f793:	0f 85 b4 00 00 00    	jne    71f84d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f799:	8b 44 24 24          	mov    0x24(%rsp),%eax
  71f79d:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  71f7a4:	0f 85 a3 00 00 00    	jne    71f84d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f7aa:	8b 44 24 28          	mov    0x28(%rsp),%eax
  71f7ae:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  71f7b5:	0f 85 92 00 00 00    	jne    71f84d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f7bb:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  71f7c0:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  71f7c7:	0f 85 80 00 00 00    	jne    71f84d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f7cd:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  71f7d2:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  71f7d9:	75 72                	jne    71f84d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f7db:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  71f7e0:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  71f7e7:	75 64                	jne    71f84d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f7e9:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  71f7ee:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  71f7f5:	75 56                	jne    71f84d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f7f7:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  71f7fc:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  71f803:	00 
  71f804:	e8 c7 06 00 00       	call   71fed0 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  71f809:	84 c0                	test   %al,%al
  71f80b:	74 40                	je     71f84d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f80d:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  71f813:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  71f81a:	00 00 
  71f81c:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  71f820:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  71f824:	3d ff ff 00 00       	cmp    $0xffff,%eax
  71f829:	75 22                	jne    71f84d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0x9fd>
  71f82b:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  71f831:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  71f838:	00 00 
  71f83a:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  71f83e:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  71f842:	3d ff ff 00 00       	cmp    $0xffff,%eax
  71f847:	0f 84 fe 01 00 00    	je     71fa4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbfb>
  71f84d:	45 89 e8             	mov    %r13d,%r8d
  71f850:	44 8b 64 24 18       	mov    0x18(%rsp),%r12d
  71f855:	0f b6 7c 24 64       	movzbl 0x64(%rsp),%edi
  71f85a:	44 0f b6 6c 24 65    	movzbl 0x65(%rsp),%r13d
  71f860:	0f b6 4c 24 66       	movzbl 0x66(%rsp),%ecx
  71f865:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  71f86a:	88 84 24 80 00 00 00 	mov    %al,0x80(%rsp)
  71f871:	8b b4 24 f0 00 00 00 	mov    0xf0(%rsp),%esi
  71f878:	0f 10 5c 24 1c       	movups 0x1c(%rsp),%xmm3
  71f87d:	f3 0f 10 44 24 20    	movss  0x20(%rsp),%xmm0
  71f883:	0f 10 a4 24 f4 00 00 	movups 0xf4(%rsp),%xmm4
  71f88a:	00 
  71f88b:	f3 0f 10 8c 24 f8 00 	movss  0xf8(%rsp),%xmm1
  71f892:	00 00 
  71f894:	44 0f b6 9c 24 3c 01 	movzbl 0x13c(%rsp),%r11d
  71f89b:	00 00 
  71f89d:	44 0f b6 8c 24 3d 01 	movzbl 0x13d(%rsp),%r9d
  71f8a4:	00 00 
  71f8a6:	0f b6 84 24 3e 01 00 	movzbl 0x13e(%rsp),%eax
  71f8ad:	00 
  71f8ae:	44 0f b6 94 24 3f 01 	movzbl 0x13f(%rsp),%r10d
  71f8b5:	00 00 
  71f8b7:	40 f6 c5 01          	test   $0x1,%bpl
  71f8bb:	74 22                	je     71f8df <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xa8f>
  71f8bd:	f3 0f 10 54 24 14    	movss  0x14(%rsp),%xmm2
  71f8c3:	0f 2e 94 24 ec 00 00 	ucomiss 0xec(%rsp),%xmm2
  71f8ca:	00 
  71f8cb:	40 0f 9b c5          	setnp  %bpl
  71f8cf:	0f 94 c2             	sete   %dl
  71f8d2:	40 20 ea             	and    %bpl,%dl
  71f8d5:	41 84 d0             	test   %dl,%r8b
  71f8d8:	75 0f                	jne    71f8e9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xa99>
  71f8da:	e9 a4 00 00 00       	jmp    71f983 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xb33>
  71f8df:	41 f6 c0 01          	test   $0x1,%r8b
  71f8e3:	0f 85 9a 00 00 00    	jne    71f983 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xb33>
  71f8e9:	41 83 fc 01          	cmp    $0x1,%r12d
  71f8ed:	75 3c                	jne    71f92b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xadb>
  71f8ef:	44 30 df             	xor    %r11b,%dil
  71f8f2:	30 c1                	xor    %al,%cl
  71f8f4:	0f b6 84 24 80 00 00 	movzbl 0x80(%rsp),%eax
  71f8fb:	00 
  71f8fc:	44 30 d0             	xor    %r10b,%al
  71f8ff:	45 38 cd             	cmp    %r9b,%r13b
  71f902:	0f 94 c2             	sete   %dl
  71f905:	0f 28 c3             	movaps %xmm3,%xmm0
  71f908:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  71f90c:	44 0f 50 c0          	movmskps %xmm0,%r8d
  71f910:	41 80 f0 0f          	xor    $0xf,%r8b
  71f914:	40 08 f9             	or     %dil,%cl
  71f917:	44 08 c1             	or     %r8b,%cl
  71f91a:	08 c1                	or     %al,%cl
  71f91c:	0f 94 c0             	sete   %al
  71f91f:	40 20 f0             	and    %sil,%al
  71f922:	84 d0                	test   %dl,%al
  71f924:	74 5d                	je     71f983 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xb33>
  71f926:	e9 83 00 00 00       	jmp    71f9ae <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xb5e>
  71f92b:	0f 2e c1             	ucomiss %xmm1,%xmm0
  71f92e:	0f 9b c2             	setnp  %dl
  71f931:	40 0f 94 c5          	sete   %bpl
  71f935:	40 20 d5             	and    %dl,%bpl
  71f938:	40 f6 d6             	not    %sil
  71f93b:	40 20 ee             	and    %bpl,%sil
  71f93e:	0f 28 c3             	movaps %xmm3,%xmm0
  71f941:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  71f945:	0f 50 d0             	movmskps %xmm0,%edx
  71f948:	89 d5                	mov    %edx,%ebp
  71f94a:	40 c0 ed 03          	shr    $0x3,%bpl
  71f94e:	c0 ea 02             	shr    $0x2,%dl
  71f951:	40 20 f2             	and    %sil,%dl
  71f954:	44 38 df             	cmp    %r11b,%dil
  71f957:	40 0f 94 c6          	sete   %sil
  71f95b:	40 20 ee             	and    %bpl,%sil
  71f95e:	40 20 d6             	and    %dl,%sil
  71f961:	38 c1                	cmp    %al,%cl
  71f963:	0f 94 c1             	sete   %cl
  71f966:	44 38 94 24 80 00 00 	cmp    %r10b,0x80(%rsp)
  71f96d:	00 
  71f96e:	0f 94 c0             	sete   %al
  71f971:	20 c8                	and    %cl,%al
  71f973:	45 38 cd             	cmp    %r9b,%r13b
  71f976:	0f 94 c1             	sete   %cl
  71f979:	20 c1                	and    %al,%cl
  71f97b:	40 20 f1             	and    %sil,%cl
  71f97e:	80 f9 01             	cmp    $0x1,%cl
  71f981:	74 2b                	je     71f9ae <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xb5e>
  71f983:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  71f98a:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  71f98f:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
  71f994:	0f 29 a4 24 80 00 00 	movaps %xmm4,0x80(%rsp)
  71f99b:	00 
  71f99c:	e8 8f 20 00 00       	call   721a30 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  71f9a1:	0f 28 a4 24 80 00 00 	movaps 0x80(%rsp),%xmm4
  71f9a8:	00 
  71f9a9:	0f 28 5c 24 70       	movaps 0x70(%rsp),%xmm3
  71f9ae:	0f c2 dc 04          	cmpneqps %xmm4,%xmm3
  71f9b2:	66 0f c5 c3 06       	pextrw $0x6,%xmm3,%eax
  71f9b7:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  71f9be:	a8 01                	test   $0x1,%al
  71f9c0:	74 69                	je     71fa2b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbdb>
  71f9c2:	49 39 cf             	cmp    %rcx,%r15
  71f9c5:	0f 83 13 01 00 00    	jae    71fade <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc8e>
  71f9cb:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  71f9d2:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  71f9d6:	8b 7c d0 20          	mov    0x20(%rax,%rdx,8),%edi
  71f9da:	89 f8                	mov    %edi,%eax
  71f9dc:	83 e0 07             	and    $0x7,%eax
  71f9df:	83 f8 06             	cmp    $0x6,%eax
  71f9e2:	74 47                	je     71fa2b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbdb>
  71f9e4:	c1 ef 03             	shr    $0x3,%edi
  71f9e7:	74 42                	je     71fa2b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xbdb>
  71f9e9:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  71f9f0:	ff cf                	dec    %edi
  71f9f2:	48 39 fe             	cmp    %rdi,%rsi
  71f9f5:	0f 86 f6 00 00 00    	jbe    71faf1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xca1>
  71f9fb:	4d 8b a6 b0 02 00 00 	mov    0x2b0(%r14),%r12
  71fa02:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  71fa06:	48 c1 e0 04          	shl    $0x4,%rax
  71fa0a:	49 83 3c 04 fe       	cmpq   $0xfffffffffffffffe,(%r12,%rax,1)
  71fa0f:	74 73                	je     71fa84 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::apply_property_value_at+0xc34>
  71fa11:	49 01 c4             	add    %rax,%r12
  71fa14:	4c 89 e7             	mov    %r12,%rdi
  71fa17:	e8 e4 1e fe ff       	call   701900 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  71fa1c:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  71fa23:	ff 
  71fa24:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  71fa2b:	48 8d 94 24 e8 00 00 	lea    0xe8(%rsp),%rdx
  71fa32:	00 
  71fa33:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  71fa3a:	4c 89 fe             	mov    %r15,%rsi
  71fa3d:	ff 15 2d 28 3e 00    	call   *0x3e282d(%rip)        # b02270 <_DYNAMIC+0x458>
  71fa43:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  71fa4a:	01 
  71fa4b:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  71fa52:	48 81 c4 f8 01 00 00 	add    $0x1f8,%rsp
  71fa59:	5b                   	pop    %rbx
  71fa5a:	41 5c                	pop    %r12
  71fa5c:	41 5d                	pop    %r13
  71fa5e:	41 5e                	pop    %r14
  71fa60:	41 5f                	pop    %r15
  71fa62:	5d                   	pop    %rbp
  71fa63:	c3                   	ret
  71fa64:	bf 08 00 00 00       	mov    $0x8,%edi
  71fa69:	be 08 01 00 00       	mov    $0x108,%esi
  71fa6e:	ff 15 1c 26 3e 00    	call   *0x3e261c(%rip)        # b02090 <_DYNAMIC+0x278>
  71fa74:	bf 08 00 00 00       	mov    $0x8,%edi
  71fa79:	be 60 00 00 00       	mov    $0x60,%esi
  71fa7e:	ff 15 0c 26 3e 00    	call   *0x3e260c(%rip)        # b02090 <_DYNAMIC+0x278>
  71fa84:	48 8d 3d 8d 40 3b 00 	lea    0x3b408d(%rip),%rdi        # ad3b18 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x2a0>
  71fa8b:	ff 15 0f 26 3e 00    	call   *0x3e260f(%rip)        # b020a0 <_DYNAMIC+0x288>
  71fa91:	48 8d 15 f0 45 3b 00 	lea    0x3b45f0(%rip),%rdx        # ad4088 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x810>
  71fa98:	4c 89 ff             	mov    %r15,%rdi
  71fa9b:	ff 15 ef 26 3e 00    	call   *0x3e26ef(%rip)        # b02190 <_DYNAMIC+0x378>
  71faa1:	48 8d 15 90 4c 3b 00 	lea    0x3b4c90(%rip),%rdx        # ad4738 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xec0>
  71faa8:	4c 89 ff             	mov    %r15,%rdi
  71faab:	ff 15 df 26 3e 00    	call   *0x3e26df(%rip)        # b02190 <_DYNAMIC+0x378>
  71fab1:	48 8d 15 e8 43 3b 00 	lea    0x3b43e8(%rip),%rdx        # ad3ea0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x628>
  71fab8:	4c 89 ff             	mov    %r15,%rdi
  71fabb:	ff 15 cf 26 3e 00    	call   *0x3e26cf(%rip)        # b02190 <_DYNAMIC+0x378>
  71fac1:	48 8d 15 c0 43 3b 00 	lea    0x3b43c0(%rip),%rdx        # ad3e88 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x610>
  71fac8:	4c 89 ff             	mov    %r15,%rdi
  71facb:	ff 15 bf 26 3e 00    	call   *0x3e26bf(%rip)        # b02190 <_DYNAMIC+0x378>
  71fad1:	48 8d 15 e0 43 3b 00 	lea    0x3b43e0(%rip),%rdx        # ad3eb8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x640>
  71fad8:	ff 15 b2 26 3e 00    	call   *0x3e26b2(%rip)        # b02190 <_DYNAMIC+0x378>
  71fade:	48 8d 15 6b 4c 3b 00 	lea    0x3b4c6b(%rip),%rdx        # ad4750 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xed8>
  71fae5:	4c 89 ff             	mov    %r15,%rdi
  71fae8:	48 89 ce             	mov    %rcx,%rsi
  71faeb:	ff 15 9f 26 3e 00    	call   *0x3e269f(%rip)        # b02190 <_DYNAMIC+0x378>
  71faf1:	48 8d 15 08 40 3b 00 	lea    0x3b4008(%rip),%rdx        # ad3b00 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x288>
  71faf8:	ff 15 92 26 3e 00    	call   *0x3e2692(%rip)        # b02190 <_DYNAMIC+0x378>
  71fafe:	48 89 c3             	mov    %rax,%rbx
  71fb01:	be 08 01 00 00       	mov    $0x108,%esi
  71fb06:	ba 08 00 00 00       	mov    $0x8,%edx
  71fb0b:	4c 89 ff             	mov    %r15,%rdi
  71fb0e:	ff 15 4c 25 3e 00    	call   *0x3e254c(%rip)        # b02060 <_DYNAMIC+0x248>
  71fb14:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  71fb1b:	00 00 00 00 
  71fb1f:	48 89 df             	mov    %rbx,%rdi
  71fb22:	e8 19 29 3b 00       	call   ad2440 <_Unwind_Resume@plt>
  71fb27:	48 89 c3             	mov    %rax,%rbx
  71fb2a:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  71fb31:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  71fb38:	00 00 00 00 
  71fb3c:	48 89 df             	mov    %rbx,%rdi
  71fb3f:	e8 fc 28 3b 00       	call   ad2440 <_Unwind_Resume@plt>
  71fb44:	49 c7 04 24 ff ff ff 	movq   $0xffffffffffffffff,(%r12)
  71fb4b:	ff 
  71fb4c:	48 89 c7             	mov    %rax,%rdi
  71fb4f:	e8 ec 28 3b 00       	call   ad2440 <_Unwind_Resume@plt>
