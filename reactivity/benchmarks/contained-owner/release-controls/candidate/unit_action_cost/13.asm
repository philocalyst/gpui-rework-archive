
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

0000000000707dc0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing>:
  707dc0:	55                   	push   %rbp
  707dc1:	41 57                	push   %r15
  707dc3:	41 56                	push   %r14
  707dc5:	41 55                	push   %r13
  707dc7:	41 54                	push   %r12
  707dc9:	53                   	push   %rbx
  707dca:	48 83 ec 78          	sub    $0x78,%rsp
  707dce:	48 89 fb             	mov    %rdi,%rbx
  707dd1:	80 be 22 07 00 00 01 	cmpb   $0x1,0x722(%rsi)
  707dd8:	75 0c                	jne    707de6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x26>
  707dda:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  707de1:	e9 c4 00 00 00       	jmp    707eaa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  707de6:	48 3b 8e b0 05 00 00 	cmp    0x5b0(%rsi),%rcx
  707ded:	0f 85 90 00 00 00    	jne    707e83 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xc3>
  707df3:	4d 89 cc             	mov    %r9,%r12
  707df6:	49 89 d5             	mov    %rdx,%r13
  707df9:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  707dfe:	49 89 f6             	mov    %rsi,%r14
  707e01:	4c 89 c2             	mov    %r8,%rdx
  707e04:	e8 17 60 01 00       	call   71de20 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  707e09:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  707e0e:	4c 8b 7c 24 38       	mov    0x38(%rsp),%r15
  707e13:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  707e17:	75 6f                	jne    707e88 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xc8>
  707e19:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  707e20:	49 39 f7             	cmp    %rsi,%r15
  707e23:	0f 83 7d 02 00 00    	jae    7080a6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x2e6>
  707e29:	4c 89 f0             	mov    %r14,%rax
  707e2c:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  707e33:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  707e37:	8b 74 d1 20          	mov    0x20(%rcx,%rdx,8),%esi
  707e3b:	83 e6 07             	and    $0x7,%esi
  707e3e:	83 fe 02             	cmp    $0x2,%esi
  707e41:	75 76                	jne    707eb9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xf9>
  707e43:	48 c7 80 08 07 00 00 	movq   $0x0,0x708(%rax)
  707e4a:	00 00 00 00 
  707e4e:	0f 10 80 60 06 00 00 	movups 0x660(%rax),%xmm0
  707e55:	0f b6 88 20 07 00 00 	movzbl 0x720(%rax),%ecx
  707e5c:	48 83 b8 80 06 00 00 	cmpq   $0x0,0x680(%rax)
  707e63:	00 
  707e64:	74 16                	je     707e7c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xbc>
  707e66:	84 c9                	test   %cl,%cl
  707e68:	0f 84 06 01 00 00    	je     707f74 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x1b4>
  707e6e:	48 83 b8 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rax)
  707e75:	ff 
  707e76:	0f 85 f8 00 00 00    	jne    707f74 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x1b4>
  707e7c:	31 c0                	xor    %eax,%eax
  707e7e:	e9 fd 00 00 00       	jmp    707f80 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x1c0>
  707e83:	b8 11 00 00 00       	mov    $0x11,%eax
  707e88:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  707e8d:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  707e91:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  707e96:	0f 10 4c 24 50       	movups 0x50(%rsp),%xmm1
  707e9b:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  707e9f:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  707ea3:	48 89 03             	mov    %rax,(%rbx)
  707ea6:	4c 89 7b 08          	mov    %r15,0x8(%rbx)
  707eaa:	48 83 c4 78          	add    $0x78,%rsp
  707eae:	5b                   	pop    %rbx
  707eaf:	41 5c                	pop    %r12
  707eb1:	41 5d                	pop    %r13
  707eb3:	41 5e                	pop    %r14
  707eb5:	41 5f                	pop    %r15
  707eb7:	5d                   	pop    %rbp
  707eb8:	c3                   	ret
  707eb9:	48 8d 2c d1          	lea    (%rcx,%rdx,8),%rbp
  707ebd:	48 83 7d 08 00       	cmpq   $0x0,0x8(%rbp)
  707ec2:	0f 84 a0 00 00 00    	je     707f68 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x1a8>
  707ec8:	48 83 c5 08          	add    $0x8,%rbp
  707ecc:	48 8d 90 10 07 00 00 	lea    0x710(%rax),%rdx
  707ed3:	4c 8d 80 28 02 00 00 	lea    0x228(%rax),%r8
  707eda:	48 8d 0d 97 bb 3c 00 	lea    0x3cbb97(%rip),%rcx        # ad3a78 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1d0>
  707ee1:	4c 8d 0d b0 bb 3c 00 	lea    0x3cbbb0(%rip),%r9        # ad3a98 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1f0>
  707ee8:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  707eed:	48 89 ee             	mov    %rbp,%rsi
  707ef0:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
  707ef5:	ff 15 f5 a2 3f 00    	call   *0x3fa2f5(%rip)        # b021f0 <_DYNAMIC+0x3a8>
  707efb:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  707f00:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  707f05:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  707f0a:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  707f0f:	48 89 14 24          	mov    %rdx,(%rsp)
  707f13:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  707f18:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  707f1d:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  707f22:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  707f26:	0f 84 0a 02 00 00    	je     708136 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x376>
  707f2c:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  707f30:	75 71                	jne    707fa3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x1e3>
  707f32:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  707f37:	e8 94 9d ff ff       	call   701cd0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  707f3c:	48 8b 0c 24          	mov    (%rsp),%rcx
  707f40:	66 85 c9             	test   %cx,%cx
  707f43:	74 7f                	je     707fc4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x204>
  707f45:	0f b7 c1             	movzwl %cx,%eax
  707f48:	83 f8 01             	cmp    $0x1,%eax
  707f4b:	0f 85 17 01 00 00    	jne    708068 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x2a8>
  707f51:	48 c1 e9 10          	shr    $0x10,%rcx
  707f55:	48 89 df             	mov    %rbx,%rdi
  707f58:	4c 89 f6             	mov    %r14,%rsi
  707f5b:	4c 89 ea             	mov    %r13,%rdx
  707f5e:	e8 1d 65 00 00       	call   70e480 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action>
  707f63:	e9 42 ff ff ff       	jmp    707eaa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  707f68:	48 c7 03 16 00 00 00 	movq   $0x16,(%rbx)
  707f6f:	e9 36 ff ff ff       	jmp    707eaa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  707f74:	48 8b 90 90 06 00 00 	mov    0x690(%rax),%rdx
  707f7b:	b8 01 00 00 00       	mov    $0x1,%eax
  707f80:	48 89 43 08          	mov    %rax,0x8(%rbx)
  707f84:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  707f88:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  707f8c:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  707f93:	00 
  707f94:	88 4b 30             	mov    %cl,0x30(%rbx)
  707f97:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  707f9e:	e9 07 ff ff ff       	jmp    707eaa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  707fa3:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  707faa:	48 89 43 08          	mov    %rax,0x8(%rbx)
  707fae:	48 8b 04 24          	mov    (%rsp),%rax
  707fb2:	48 89 43 10          	mov    %rax,0x10(%rbx)
  707fb6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  707fbb:	48 89 43 18          	mov    %rax,0x18(%rbx)
  707fbf:	e9 e6 fe ff ff       	jmp    707eaa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  707fc4:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  707fcb:	49 ff c7             	inc    %r15
  707fce:	0f 84 c6 00 00 00    	je     70809a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x2da>
  707fd4:	48 c7 44 24 30 1f 00 	movq   $0x1f,0x30(%rsp)
  707fdb:	00 00 
  707fdd:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  707fe2:	e8 f9 c7 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  707fe7:	48 8d 0d 8a ba 3c 00 	lea    0x3cba8a(%rip),%rcx        # ad3a78 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1d0>
  707fee:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  707ff3:	48 89 ee             	mov    %rbp,%rsi
  707ff6:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  707ffb:	ff 15 f7 a1 3f 00    	call   *0x3fa1f7(%rip)        # b021f8 <_DYNAMIC+0x3b0>
  708001:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  708006:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  70800b:	0f 28 44 24 30       	movaps 0x30(%rsp),%xmm0
  708010:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  708015:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  70801a:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70801e:	0f 84 ae 00 00 00    	je     7080d2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x312>
  708024:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  708028:	75 57                	jne    708081 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x2c1>
  70802a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70802f:	e8 9c 9c ff ff       	call   701cd0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  708034:	4d 89 be 60 06 00 00 	mov    %r15,0x660(%r14)
  70803b:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  708042:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  708049:	00 00 00 00 
  70804d:	48 89 df             	mov    %rbx,%rdi
  708050:	4c 89 f6             	mov    %r14,%rsi
  708053:	4c 89 ea             	mov    %r13,%rdx
  708056:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  70805b:	4d 89 e0             	mov    %r12,%r8
  70805e:	e8 5d 01 00 00       	call   7081c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing>
  708063:	e9 42 fe ff ff       	jmp    707eaa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  708068:	48 89 df             	mov    %rbx,%rdi
  70806b:	4c 89 f6             	mov    %r14,%rsi
  70806e:	4c 89 ea             	mov    %r13,%rdx
  708071:	4c 89 f9             	mov    %r15,%rcx
  708074:	4d 89 e0             	mov    %r12,%r8
  708077:	e8 44 f6 ff ff       	call   7076c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property>
  70807c:	e9 29 fe ff ff       	jmp    707eaa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  708081:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  708086:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  70808a:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  708091:	48 89 43 08          	mov    %rax,0x8(%rbx)
  708095:	e9 10 fe ff ff       	jmp    707eaa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  70809a:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  7080a1:	e9 04 fe ff ff       	jmp    707eaa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  7080a6:	48 8d 15 c3 bd 3c 00 	lea    0x3cbdc3(%rip),%rdx        # ad3e70 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x5c8>
  7080ad:	4c 89 ff             	mov    %r15,%rdi
  7080b0:	ff 15 0a a1 3f 00    	call   *0x3fa10a(%rip)        # b021c0 <_DYNAMIC+0x378>
  7080b6:	48 89 c7             	mov    %rax,%rdi
  7080b9:	ff 15 11 a1 3f 00    	call   *0x3fa111(%rip)        # b021d0 <_DYNAMIC+0x388>
  7080bf:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  7080c4:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  7080c9:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  7080d0:	ff ff 
  7080d2:	4c 89 f7             	mov    %r14,%rdi
  7080d5:	e8 d6 63 01 00       	call   71e4b0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  7080da:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  7080e1:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7080e6:	e8 e5 9b ff ff       	call   701cd0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  7080eb:	e9 ba fd ff ff       	jmp    707eaa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  7080f0:	ff 15 e2 a0 3f 00    	call   *0x3fa0e2(%rip)        # b021d8 <_DYNAMIC+0x390>
  7080f6:	48 89 c3             	mov    %rax,%rbx
  7080f9:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7080fe:	e8 cd 9b ff ff       	call   701cd0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  708103:	e9 aa 00 00 00       	jmp    7081b2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x3f2>
  708108:	48 89 c7             	mov    %rax,%rdi
  70810b:	ff 15 bf a0 3f 00    	call   *0x3fa0bf(%rip)        # b021d0 <_DYNAMIC+0x388>
  708111:	48 89 04 24          	mov    %rax,(%rsp)
  708115:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70811a:	48 8b 04 24          	mov    (%rsp),%rax
  70811e:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  708123:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  708128:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  70812d:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  708134:	ff ff 
  708136:	4c 89 f7             	mov    %r14,%rdi
  708139:	e8 72 63 01 00       	call   71e4b0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  70813e:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  708143:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  70814a:	49 8b 06             	mov    (%r14),%rax
  70814d:	48 85 c0             	test   %rax,%rax
  708150:	74 06                	je     708158 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x398>
  708152:	48 8b 3c 24          	mov    (%rsp),%rdi
  708156:	ff d0                	call   *%rax
  708158:	49 8b 76 08          	mov    0x8(%r14),%rsi
  70815c:	48 85 f6             	test   %rsi,%rsi
  70815f:	0f 84 45 fd ff ff    	je     707eaa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  708165:	49 8b 56 10          	mov    0x10(%r14),%rdx
  708169:	48 8b 3c 24          	mov    (%rsp),%rdi
  70816d:	ff 15 1d 9f 3f 00    	call   *0x3f9f1d(%rip)        # b02090 <_DYNAMIC+0x248>
  708173:	e9 32 fd ff ff       	jmp    707eaa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  708178:	ff 15 5a a0 3f 00    	call   *0x3fa05a(%rip)        # b021d8 <_DYNAMIC+0x390>
  70817e:	48 89 c3             	mov    %rax,%rbx
  708181:	49 8b 76 08          	mov    0x8(%r14),%rsi
  708185:	48 85 f6             	test   %rsi,%rsi
  708188:	74 28                	je     7081b2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x3f2>
  70818a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70818f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  708193:	48 8b 3c 24          	mov    (%rsp),%rdi
  708197:	ff 15 f3 9e 3f 00    	call   *0x3f9ef3(%rip)        # b02090 <_DYNAMIC+0x248>
  70819d:	48 89 df             	mov    %rbx,%rdi
  7081a0:	e8 cb a2 3c 00       	call   ad2470 <_Unwind_Resume@plt>
  7081a5:	48 89 c3             	mov    %rax,%rbx
  7081a8:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  7081ad:	e8 1e 9b ff ff       	call   701cd0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  7081b2:	48 89 df             	mov    %rbx,%rdi
  7081b5:	e8 b6 a2 3c 00       	call   ad2470 <_Unwind_Resume@plt>
  7081ba:	ff 15 20 9f 3f 00    	call   *0x3f9f20(%rip)        # b020e0 <_DYNAMIC+0x298>
