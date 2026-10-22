
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

00000000007070f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with>:
  7070f0:	55                   	push   %rbp
  7070f1:	41 57                	push   %r15
  7070f3:	41 56                	push   %r14
  7070f5:	41 54                	push   %r12
  7070f7:	53                   	push   %rbx
  7070f8:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  7070ff:	89 cd                	mov    %ecx,%ebp
  707101:	49 89 d7             	mov    %rdx,%r15
  707104:	49 89 f6             	mov    %rsi,%r14
  707107:	48 89 fb             	mov    %rdi,%rbx
  70710a:	48 81 c6 28 02 00 00 	add    $0x228,%rsi
  707111:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  707118:	48 8d 7c 24 78       	lea    0x78(%rsp),%rdi
  70711d:	e8 2e be 03 00       	call   742f50 <<gpui::source::Sources<unit_action_cost::Model>>::validate>
  707122:	83 7c 24 78 ff       	cmpl   $0xffffffff,0x78(%rsp)
  707127:	74 1e                	je     707147 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0x57>
  707129:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  707130:	00 
  707131:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  707136:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  70713b:	0f 11 44 24 48       	movups %xmm0,0x48(%rsp)
  707140:	b8 20 00 00 00       	mov    $0x20,%eax
  707145:	eb 1e                	jmp    707165 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0x75>
  707147:	40 0f b6 d5          	movzbl %bpl,%edx
  70714b:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  707150:	4c 89 f6             	mov    %r14,%rsi
  707153:	4c 89 f9             	mov    %r15,%rcx
  707156:	e8 e5 ed 00 00       	call   715f40 <<gpui::runtime::Runtime<unit_action_cost::Model>>::describe_inner>
  70715b:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  707160:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  707165:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
  70716a:	4c 8b 64 24 50       	mov    0x50(%rsp),%r12
  70716f:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  707174:	0f 11 44 24 30       	movups %xmm0,0x30(%rsp)
  707179:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  70717e:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  707183:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  707188:	4c 89 7c 24 10       	mov    %r15,0x10(%rsp)
  70718d:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  707192:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  707197:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  70719c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  7071a0:	74 3d                	je     7071df <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0xef>
  7071a2:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  7071a6:	75 40                	jne    7071e8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0xf8>
  7071a8:	4c 89 f7             	mov    %r14,%rdi
  7071ab:	e8 f0 71 01 00       	call   71e3a0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  7071b0:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  7071b7:	49 8b 04 24          	mov    (%r12),%rax
  7071bb:	48 85 c0             	test   %rax,%rax
  7071be:	74 05                	je     7071c5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0xd5>
  7071c0:	4c 89 ff             	mov    %r15,%rdi
  7071c3:	ff d0                	call   *%rax
  7071c5:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  7071ca:	48 85 f6             	test   %rsi,%rsi
  7071cd:	74 4f                	je     70721e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0x12e>
  7071cf:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  7071d4:	4c 89 ff             	mov    %r15,%rdi
  7071d7:	ff 15 b3 ad 3f 00    	call   *0x3fadb3(%rip)        # b01f90 <_DYNAMIC+0x248>
  7071dd:	eb 3f                	jmp    70721e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0x12e>
  7071df:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  7071e6:	eb 36                	jmp    70721e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0x12e>
  7071e8:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  7071ed:	48 89 43 30          	mov    %rax,0x30(%rbx)
  7071f1:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  7071f6:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  7071fb:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  707200:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  707204:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  707208:	0f 11 03             	movups %xmm0,(%rbx)
  70720b:	41 c6 86 1e 07 00 00 	movb   $0x0,0x71e(%r14)
  707212:	00 
  707213:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  70721a:	00 00 00 00 
  70721e:	48 81 c4 90 00 00 00 	add    $0x90,%rsp
  707225:	5b                   	pop    %rbx
  707226:	41 5c                	pop    %r12
  707228:	41 5e                	pop    %r14
  70722a:	41 5f                	pop    %r15
  70722c:	5d                   	pop    %rbp
  70722d:	c3                   	ret
  70722e:	48 89 c3             	mov    %rax,%rbx
  707231:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  707236:	48 85 f6             	test   %rsi,%rsi
  707239:	74 23                	je     70725e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0x16e>
  70723b:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  707240:	4c 89 ff             	mov    %r15,%rdi
  707243:	ff 15 47 ad 3f 00    	call   *0x3fad47(%rip)        # b01f90 <_DYNAMIC+0x248>
  707249:	48 89 df             	mov    %rbx,%rdi
  70724c:	e8 5f b1 3c 00       	call   ad23b0 <_Unwind_Resume@plt>
  707251:	48 89 c3             	mov    %rax,%rbx
  707254:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  707259:	e8 d2 a9 ff ff       	call   701c30 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  70725e:	48 89 df             	mov    %rbx,%rdi
  707261:	e8 4a b1 3c 00       	call   ad23b0 <_Unwind_Resume@plt>
  707266:	ff 15 74 ad 3f 00    	call   *0x3fad74(%rip)        # b01fe0 <_DYNAMIC+0x298>
  70726c:	48 89 c7             	mov    %rax,%rdi
  70726f:	ff 15 5b ae 3f 00    	call   *0x3fae5b(%rip)        # b020d0 <_DYNAMIC+0x388>
  707275:	49 89 c7             	mov    %rax,%r15
  707278:	49 89 d4             	mov    %rdx,%r12
  70727b:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  707280:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  707285:	48 c7 44 24 08 fd ff 	movq   $0xfffffffffffffffd,0x8(%rsp)
  70728c:	ff ff 
  70728e:	e9 15 ff ff ff       	jmp    7071a8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0xb8>
  707293:	ff 15 3f ae 3f 00    	call   *0x3fae3f(%rip)        # b020d8 <_DYNAMIC+0x390>
