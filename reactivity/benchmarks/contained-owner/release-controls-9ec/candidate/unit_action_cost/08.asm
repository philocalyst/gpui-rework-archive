
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

0000000000707200 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with>:
  707200:	55                   	push   %rbp
  707201:	41 57                	push   %r15
  707203:	41 56                	push   %r14
  707205:	41 54                	push   %r12
  707207:	53                   	push   %rbx
  707208:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  70720f:	89 cd                	mov    %ecx,%ebp
  707211:	49 89 d7             	mov    %rdx,%r15
  707214:	49 89 f6             	mov    %rsi,%r14
  707217:	48 89 fb             	mov    %rdi,%rbx
  70721a:	48 81 c6 28 02 00 00 	add    $0x228,%rsi
  707221:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  707228:	48 8d 7c 24 78       	lea    0x78(%rsp),%rdi
  70722d:	e8 1e be 03 00       	call   743050 <<gpui::source::Sources<unit_action_cost::Model>>::validate>
  707232:	83 7c 24 78 ff       	cmpl   $0xffffffff,0x78(%rsp)
  707237:	74 1e                	je     707257 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0x57>
  707239:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  707240:	00 
  707241:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  707246:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  70724b:	0f 11 44 24 48       	movups %xmm0,0x48(%rsp)
  707250:	b8 20 00 00 00       	mov    $0x20,%eax
  707255:	eb 1e                	jmp    707275 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0x75>
  707257:	40 0f b6 d5          	movzbl %bpl,%edx
  70725b:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  707260:	4c 89 f6             	mov    %r14,%rsi
  707263:	4c 89 f9             	mov    %r15,%rcx
  707266:	e8 b5 ed 00 00       	call   716020 <<gpui::runtime::Runtime<unit_action_cost::Model>>::describe_inner>
  70726b:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  707270:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  707275:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
  70727a:	4c 8b 64 24 50       	mov    0x50(%rsp),%r12
  70727f:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  707284:	0f 11 44 24 30       	movups %xmm0,0x30(%rsp)
  707289:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  70728e:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  707293:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  707298:	4c 89 7c 24 10       	mov    %r15,0x10(%rsp)
  70729d:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  7072a2:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  7072a7:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  7072ac:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  7072b0:	74 3d                	je     7072ef <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0xef>
  7072b2:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  7072b6:	75 40                	jne    7072f8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0xf8>
  7072b8:	4c 89 f7             	mov    %r14,%rdi
  7072bb:	e8 c0 71 01 00       	call   71e480 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  7072c0:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  7072c7:	49 8b 04 24          	mov    (%r12),%rax
  7072cb:	48 85 c0             	test   %rax,%rax
  7072ce:	74 05                	je     7072d5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0xd5>
  7072d0:	4c 89 ff             	mov    %r15,%rdi
  7072d3:	ff d0                	call   *%rax
  7072d5:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  7072da:	48 85 f6             	test   %rsi,%rsi
  7072dd:	74 4f                	je     70732e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0x12e>
  7072df:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  7072e4:	4c 89 ff             	mov    %r15,%rdi
  7072e7:	ff 15 73 ad 3f 00    	call   *0x3fad73(%rip)        # b02060 <_DYNAMIC+0x248>
  7072ed:	eb 3f                	jmp    70732e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0x12e>
  7072ef:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  7072f6:	eb 36                	jmp    70732e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0x12e>
  7072f8:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  7072fd:	48 89 43 30          	mov    %rax,0x30(%rbx)
  707301:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  707306:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  70730b:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  707310:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  707314:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  707318:	0f 11 03             	movups %xmm0,(%rbx)
  70731b:	41 c6 86 1e 07 00 00 	movb   $0x0,0x71e(%r14)
  707322:	00 
  707323:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  70732a:	00 00 00 00 
  70732e:	48 81 c4 90 00 00 00 	add    $0x90,%rsp
  707335:	5b                   	pop    %rbx
  707336:	41 5c                	pop    %r12
  707338:	41 5e                	pop    %r14
  70733a:	41 5f                	pop    %r15
  70733c:	5d                   	pop    %rbp
  70733d:	c3                   	ret
  70733e:	48 89 c3             	mov    %rax,%rbx
  707341:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  707346:	48 85 f6             	test   %rsi,%rsi
  707349:	74 23                	je     70736e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0x16e>
  70734b:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  707350:	4c 89 ff             	mov    %r15,%rdi
  707353:	ff 15 07 ad 3f 00    	call   *0x3fad07(%rip)        # b02060 <_DYNAMIC+0x248>
  707359:	48 89 df             	mov    %rbx,%rdi
  70735c:	e8 df b0 3c 00       	call   ad2440 <_Unwind_Resume@plt>
  707361:	48 89 c3             	mov    %rax,%rbx
  707364:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  707369:	e8 d2 a9 ff ff       	call   701d40 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  70736e:	48 89 df             	mov    %rbx,%rdi
  707371:	e8 ca b0 3c 00       	call   ad2440 <_Unwind_Resume@plt>
  707376:	ff 15 34 ad 3f 00    	call   *0x3fad34(%rip)        # b020b0 <_DYNAMIC+0x298>
  70737c:	48 89 c7             	mov    %rax,%rdi
  70737f:	ff 15 1b ae 3f 00    	call   *0x3fae1b(%rip)        # b021a0 <_DYNAMIC+0x388>
  707385:	49 89 c7             	mov    %rax,%r15
  707388:	49 89 d4             	mov    %rdx,%r12
  70738b:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  707390:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  707395:	48 c7 44 24 08 fd ff 	movq   $0xfffffffffffffffd,0x8(%rsp)
  70739c:	ff ff 
  70739e:	e9 15 ff ff ff       	jmp    7072b8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0xb8>
  7073a3:	ff 15 ff ad 3f 00    	call   *0x3fadff(%rip)        # b021a8 <_DYNAMIC+0x390>
