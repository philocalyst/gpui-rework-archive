
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fd910 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with>:
  6fd910:	55                   	push   %rbp
  6fd911:	41 57                	push   %r15
  6fd913:	41 56                	push   %r14
  6fd915:	41 54                	push   %r12
  6fd917:	53                   	push   %rbx
  6fd918:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  6fd91f:	89 cd                	mov    %ecx,%ebp
  6fd921:	49 89 d7             	mov    %rdx,%r15
  6fd924:	49 89 f6             	mov    %rsi,%r14
  6fd927:	48 89 fb             	mov    %rdi,%rbx
  6fd92a:	48 81 c6 28 02 00 00 	add    $0x228,%rsi
  6fd931:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6fd938:	48 8d 7c 24 78       	lea    0x78(%rsp),%rdi
  6fd93d:	e8 ae 7f 05 00       	call   7558f0 <<gpui::source::Sources<unit_action_cost_two::Model>>::validate>
  6fd942:	83 7c 24 78 ff       	cmpl   $0xffffffff,0x78(%rsp)
  6fd947:	74 1e                	je     6fd967 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x57>
  6fd949:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  6fd950:	00 
  6fd951:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fd956:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  6fd95b:	0f 11 44 24 48       	movups %xmm0,0x48(%rsp)
  6fd960:	b8 20 00 00 00       	mov    $0x20,%eax
  6fd965:	eb 1e                	jmp    6fd985 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x75>
  6fd967:	40 0f b6 d5          	movzbl %bpl,%edx
  6fd96b:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  6fd970:	4c 89 f6             	mov    %r14,%rsi
  6fd973:	4c 89 f9             	mov    %r15,%rcx
  6fd976:	e8 d5 34 02 00       	call   720e50 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::describe_inner>
  6fd97b:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fd980:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6fd985:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
  6fd98a:	4c 8b 64 24 50       	mov    0x50(%rsp),%r12
  6fd98f:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  6fd994:	0f 11 44 24 30       	movups %xmm0,0x30(%rsp)
  6fd999:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  6fd99e:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  6fd9a3:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fd9a8:	4c 89 7c 24 10       	mov    %r15,0x10(%rsp)
  6fd9ad:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fd9b2:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  6fd9b7:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  6fd9bc:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fd9c0:	74 3d                	je     6fd9ff <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0xef>
  6fd9c2:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  6fd9c6:	75 40                	jne    6fda08 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0xf8>
  6fd9c8:	4c 89 f7             	mov    %r14,%rdi
  6fd9cb:	e8 e0 b8 02 00       	call   7292b0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fd9d0:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fd9d7:	49 8b 04 24          	mov    (%r12),%rax
  6fd9db:	48 85 c0             	test   %rax,%rax
  6fd9de:	74 05                	je     6fd9e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0xd5>
  6fd9e0:	4c 89 ff             	mov    %r15,%rdi
  6fd9e3:	ff d0                	call   *%rax
  6fd9e5:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  6fd9ea:	48 85 f6             	test   %rsi,%rsi
  6fd9ed:	74 4f                	je     6fda3e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x12e>
  6fd9ef:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  6fd9f4:	4c 89 ff             	mov    %r15,%rdi
  6fd9f7:	ff 15 d3 b8 42 00    	call   *0x42b8d3(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fd9fd:	eb 3f                	jmp    6fda3e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x12e>
  6fd9ff:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fda06:	eb 36                	jmp    6fda3e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x12e>
  6fda08:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6fda0d:	48 89 43 30          	mov    %rax,0x30(%rbx)
  6fda11:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  6fda16:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  6fda1b:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  6fda20:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  6fda24:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  6fda28:	0f 11 03             	movups %xmm0,(%rbx)
  6fda2b:	41 c6 86 1e 07 00 00 	movb   $0x0,0x71e(%r14)
  6fda32:	00 
  6fda33:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  6fda3a:	00 00 00 00 
  6fda3e:	48 81 c4 90 00 00 00 	add    $0x90,%rsp
  6fda45:	5b                   	pop    %rbx
  6fda46:	41 5c                	pop    %r12
  6fda48:	41 5e                	pop    %r14
  6fda4a:	41 5f                	pop    %r15
  6fda4c:	5d                   	pop    %rbp
  6fda4d:	c3                   	ret
  6fda4e:	48 89 c3             	mov    %rax,%rbx
  6fda51:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  6fda56:	48 85 f6             	test   %rsi,%rsi
  6fda59:	74 23                	je     6fda7e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x16e>
  6fda5b:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  6fda60:	4c 89 ff             	mov    %r15,%rdi
  6fda63:	ff 15 67 b8 42 00    	call   *0x42b867(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fda69:	48 89 df             	mov    %rbx,%rdi
  6fda6c:	e8 3f ba 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6fda71:	48 89 c3             	mov    %rax,%rbx
  6fda74:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  6fda79:	e8 92 72 ff ff       	call   6f4d10 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fda7e:	48 89 df             	mov    %rbx,%rdi
  6fda81:	e8 2a ba 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6fda86:	ff 15 74 b8 42 00    	call   *0x42b874(%rip)        # b29300 <_DYNAMIC+0x278>
  6fda8c:	48 89 c7             	mov    %rax,%rdi
  6fda8f:	ff 15 5b b9 42 00    	call   *0x42b95b(%rip)        # b293f0 <_DYNAMIC+0x368>
  6fda95:	49 89 c7             	mov    %rax,%r15
  6fda98:	49 89 d4             	mov    %rdx,%r12
  6fda9b:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  6fdaa0:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fdaa5:	48 c7 44 24 08 fd ff 	movq   $0xfffffffffffffffd,0x8(%rsp)
  6fdaac:	ff ff 
  6fdaae:	e9 15 ff ff ff       	jmp    6fd9c8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0xb8>
  6fdab3:	ff 15 3f b9 42 00    	call   *0x42b93f(%rip)        # b293f8 <_DYNAMIC+0x370>
