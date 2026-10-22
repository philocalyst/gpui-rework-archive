
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fa960 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing>:
  6fa960:	55                   	push   %rbp
  6fa961:	41 57                	push   %r15
  6fa963:	41 56                	push   %r14
  6fa965:	41 55                	push   %r13
  6fa967:	41 54                	push   %r12
  6fa969:	53                   	push   %rbx
  6fa96a:	48 83 ec 78          	sub    $0x78,%rsp
  6fa96e:	48 89 fb             	mov    %rdi,%rbx
  6fa971:	80 be 22 08 00 00 01 	cmpb   $0x1,0x822(%rsi)
  6fa978:	75 0c                	jne    6fa986 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x26>
  6fa97a:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  6fa981:	e9 c4 00 00 00       	jmp    6faa4a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fa986:	48 3b 8e b0 05 00 00 	cmp    0x5b0(%rsi),%rcx
  6fa98d:	0f 85 90 00 00 00    	jne    6faa23 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xc3>
  6fa993:	4d 89 cd             	mov    %r9,%r13
  6fa996:	49 89 d4             	mov    %rdx,%r12
  6fa999:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fa99e:	49 89 f6             	mov    %rsi,%r14
  6fa9a1:	4c 89 c2             	mov    %r8,%rdx
  6fa9a4:	e8 07 e7 01 00       	call   7190b0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  6fa9a9:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fa9ae:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
  6fa9b3:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fa9b7:	75 6f                	jne    6faa28 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xc8>
  6fa9b9:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  6fa9c0:	48 39 f7             	cmp    %rsi,%rdi
  6fa9c3:	0f 83 4f 02 00 00    	jae    6fac18 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x2b8>
  6fa9c9:	4c 89 f0             	mov    %r14,%rax
  6fa9cc:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  6fa9d3:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  6fa9d7:	8b 74 d1 20          	mov    0x20(%rcx,%rdx,8),%esi
  6fa9db:	83 e6 07             	and    $0x7,%esi
  6fa9de:	83 fe 02             	cmp    $0x2,%esi
  6fa9e1:	75 76                	jne    6faa59 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xf9>
  6fa9e3:	48 c7 80 08 07 00 00 	movq   $0x0,0x708(%rax)
  6fa9ea:	00 00 00 00 
  6fa9ee:	0f 10 80 60 06 00 00 	movups 0x660(%rax),%xmm0
  6fa9f5:	0f b6 88 20 08 00 00 	movzbl 0x820(%rax),%ecx
  6fa9fc:	48 83 b8 80 06 00 00 	cmpq   $0x0,0x680(%rax)
  6faa03:	00 
  6faa04:	74 16                	je     6faa1c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xbc>
  6faa06:	84 c9                	test   %cl,%cl
  6faa08:	0f 84 f5 00 00 00    	je     6fab03 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1a3>
  6faa0e:	48 83 b8 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rax)
  6faa15:	ff 
  6faa16:	0f 85 e7 00 00 00    	jne    6fab03 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1a3>
  6faa1c:	31 c0                	xor    %eax,%eax
  6faa1e:	e9 ec 00 00 00       	jmp    6fab0f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1af>
  6faa23:	b8 11 00 00 00       	mov    $0x11,%eax
  6faa28:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6faa2d:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  6faa31:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  6faa36:	0f 10 4c 24 50       	movups 0x50(%rsp),%xmm1
  6faa3b:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  6faa3f:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  6faa43:	48 89 03             	mov    %rax,(%rbx)
  6faa46:	48 89 7b 08          	mov    %rdi,0x8(%rbx)
  6faa4a:	48 83 c4 78          	add    $0x78,%rsp
  6faa4e:	5b                   	pop    %rbx
  6faa4f:	41 5c                	pop    %r12
  6faa51:	41 5d                	pop    %r13
  6faa53:	41 5e                	pop    %r14
  6faa55:	41 5f                	pop    %r15
  6faa57:	5d                   	pop    %rbp
  6faa58:	c3                   	ret
  6faa59:	4c 8d 3c d1          	lea    (%rcx,%rdx,8),%r15
  6faa5d:	49 83 7f 08 00       	cmpq   $0x0,0x8(%r15)
  6faa62:	0f 84 8f 00 00 00    	je     6faaf7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x197>
  6faa68:	49 83 c7 08          	add    $0x8,%r15
  6faa6c:	48 8d 90 10 07 00 00 	lea    0x710(%rax),%rdx
  6faa73:	4c 8d 80 28 02 00 00 	lea    0x228(%rax),%r8
  6faa7a:	48 8d 0d 17 eb 3f 00 	lea    0x3feb17(%rip),%rcx        # af9598 <__frame_dummy_init_array_entry+0x70>
  6faa81:	4c 8d 0d 30 eb 3f 00 	lea    0x3feb30(%rip),%r9        # af95b8 <__frame_dummy_init_array_entry+0x90>
  6faa88:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6faa8d:	4c 89 fe             	mov    %r15,%rsi
  6faa90:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
  6faa95:	ff 15 95 d5 42 00    	call   *0x42d595(%rip)        # b28030 <_DYNAMIC+0x378>
  6faa9b:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6faaa0:	48 8b 6c 24 38       	mov    0x38(%rsp),%rbp
  6faaa5:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6faaaa:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  6faaaf:	48 89 6c 24 18       	mov    %rbp,0x18(%rsp)
  6faab4:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  6faab9:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  6faabe:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6faac2:	0f 84 d8 01 00 00    	je     6faca0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x340>
  6faac8:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6faacc:	75 64                	jne    6fab32 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1d2>
  6faace:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6faad3:	e8 58 9d ff ff       	call   6f4830 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6faad8:	40 f6 c5 01          	test   $0x1,%bpl
  6faadc:	74 71                	je     6fab4f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x1ef>
  6faade:	48 c1 ed 10          	shr    $0x10,%rbp
  6faae2:	48 89 df             	mov    %rbx,%rdi
  6faae5:	4c 89 f6             	mov    %r14,%rsi
  6faae8:	4c 89 e2             	mov    %r12,%rdx
  6faaeb:	89 e9                	mov    %ebp,%ecx
  6faaed:	e8 1e cf 00 00       	call   707a10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::window_action>
  6faaf2:	e9 53 ff ff ff       	jmp    6faa4a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6faaf7:	48 c7 03 16 00 00 00 	movq   $0x16,(%rbx)
  6faafe:	e9 47 ff ff ff       	jmp    6faa4a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fab03:	48 8b 90 90 06 00 00 	mov    0x690(%rax),%rdx
  6fab0a:	b8 01 00 00 00       	mov    $0x1,%eax
  6fab0f:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fab13:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  6fab17:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  6fab1b:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  6fab22:	00 
  6fab23:	88 4b 30             	mov    %cl,0x30(%rbx)
  6fab26:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fab2d:	e9 18 ff ff ff       	jmp    6faa4a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fab32:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fab39:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fab3d:	48 89 6b 10          	mov    %rbp,0x10(%rbx)
  6fab41:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fab46:	48 89 43 18          	mov    %rax,0x18(%rbx)
  6fab4a:	e9 fb fe ff ff       	jmp    6faa4a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fab4f:	49 8b ae 60 06 00 00 	mov    0x660(%r14),%rbp
  6fab56:	48 ff c5             	inc    %rbp
  6fab59:	0f 84 ad 00 00 00    	je     6fac0c <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x2ac>
  6fab5f:	48 c7 44 24 30 1f 00 	movq   $0x1f,0x30(%rsp)
  6fab66:	00 00 
  6fab68:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fab6d:	e8 0e cf ff ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  6fab72:	48 8d 0d 1f ea 3f 00 	lea    0x3fea1f(%rip),%rcx        # af9598 <__frame_dummy_init_array_entry+0x70>
  6fab79:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  6fab7e:	4c 89 fe             	mov    %r15,%rsi
  6fab81:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  6fab86:	ff 15 ac d4 42 00    	call   *0x42d4ac(%rip)        # b28038 <_DYNAMIC+0x380>
  6fab8c:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  6fab91:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  6fab96:	0f 28 44 24 30       	movaps 0x30(%rsp),%xmm0
  6fab9b:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  6faba0:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  6faba5:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6faba9:	0f 84 92 00 00 00    	je     6fac41 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x2e1>
  6fabaf:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  6fabb3:	75 3e                	jne    6fabf3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x293>
  6fabb5:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fabba:	e8 71 9c ff ff       	call   6f4830 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fabbf:	49 89 ae 60 06 00 00 	mov    %rbp,0x660(%r14)
  6fabc6:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  6fabcd:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  6fabd4:	00 00 00 00 
  6fabd8:	48 89 df             	mov    %rbx,%rdi
  6fabdb:	4c 89 f6             	mov    %r14,%rsi
  6fabde:	4c 89 e2             	mov    %r12,%rdx
  6fabe1:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  6fabe6:	4d 89 e8             	mov    %r13,%r8
  6fabe9:	e8 42 01 00 00       	call   6fad30 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::after_source_with_editing>
  6fabee:	e9 57 fe ff ff       	jmp    6faa4a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fabf3:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  6fabf8:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  6fabfc:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  6fac03:	48 89 43 08          	mov    %rax,0x8(%rbx)
  6fac07:	e9 3e fe ff ff       	jmp    6faa4a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fac0c:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  6fac13:	e9 32 fe ff ff       	jmp    6faa4a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fac18:	48 8d 15 69 ed 3f 00 	lea    0x3fed69(%rip),%rdx        # af9988 <__frame_dummy_init_array_entry+0x460>
  6fac1f:	ff 15 eb d3 42 00    	call   *0x42d3eb(%rip)        # b28010 <_DYNAMIC+0x358>
  6fac25:	48 89 c7             	mov    %rax,%rdi
  6fac28:	ff 15 f2 d3 42 00    	call   *0x42d3f2(%rip)        # b28020 <_DYNAMIC+0x368>
  6fac2e:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fac33:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  6fac38:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  6fac3f:	ff ff 
  6fac41:	4c 89 f7             	mov    %r14,%rdi
  6fac44:	e8 f7 ea 01 00       	call   719740 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fac49:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fac50:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fac55:	e8 d6 9b ff ff       	call   6f4830 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fac5a:	e9 eb fd ff ff       	jmp    6faa4a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6fac5f:	ff 15 c3 d3 42 00    	call   *0x42d3c3(%rip)        # b28028 <_DYNAMIC+0x370>
  6fac65:	48 89 c3             	mov    %rax,%rbx
  6fac68:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fac6d:	e8 be 9b ff ff       	call   6f4830 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fac72:	e9 a2 00 00 00       	jmp    6fad19 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x3b9>
  6fac77:	48 89 c7             	mov    %rax,%rdi
  6fac7a:	ff 15 a0 d3 42 00    	call   *0x42d3a0(%rip)        # b28020 <_DYNAMIC+0x368>
  6fac80:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  6fac85:	48 89 c5             	mov    %rax,%rbp
  6fac88:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  6fac8d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6fac92:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  6fac97:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  6fac9e:	ff ff 
  6faca0:	4c 89 f7             	mov    %r14,%rdi
  6faca3:	e8 98 ea 01 00       	call   719740 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6faca8:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  6facad:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6facb4:	49 8b 06             	mov    (%r14),%rax
  6facb7:	48 85 c0             	test   %rax,%rax
  6facba:	74 05                	je     6facc1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x361>
  6facbc:	48 89 ef             	mov    %rbp,%rdi
  6facbf:	ff d0                	call   *%rax
  6facc1:	49 8b 76 08          	mov    0x8(%r14),%rsi
  6facc5:	48 85 f6             	test   %rsi,%rsi
  6facc8:	0f 84 7c fd ff ff    	je     6faa4a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6facce:	49 8b 56 10          	mov    0x10(%r14),%rdx
  6facd2:	48 89 ef             	mov    %rbp,%rdi
  6facd5:	ff 15 25 d2 42 00    	call   *0x42d225(%rip)        # b27f00 <_DYNAMIC+0x248>
  6facdb:	e9 6a fd ff ff       	jmp    6faa4a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0xea>
  6face0:	ff 15 42 d3 42 00    	call   *0x42d342(%rip)        # b28028 <_DYNAMIC+0x370>
  6face6:	48 89 c3             	mov    %rax,%rbx
  6face9:	49 8b 76 08          	mov    0x8(%r14),%rsi
  6faced:	48 85 f6             	test   %rsi,%rsi
  6facf0:	74 27                	je     6fad19 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_with_editing+0x3b9>
  6facf2:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  6facf7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  6facfb:	48 89 ef             	mov    %rbp,%rdi
  6facfe:	ff 15 fc d1 42 00    	call   *0x42d1fc(%rip)        # b27f00 <_DYNAMIC+0x248>
  6fad04:	48 89 df             	mov    %rbx,%rdi
  6fad07:	e8 64 d4 3f 00       	call   af8170 <_Unwind_Resume@plt>
  6fad0c:	48 89 c3             	mov    %rax,%rbx
  6fad0f:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  6fad14:	e8 17 9b ff ff       	call   6f4830 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fad19:	48 89 df             	mov    %rbx,%rdi
  6fad1c:	e8 4f d4 3f 00       	call   af8170 <_Unwind_Resume@plt>
  6fad21:	ff 15 09 d2 42 00    	call   *0x42d209(%rip)        # b27f30 <_DYNAMIC+0x278>
