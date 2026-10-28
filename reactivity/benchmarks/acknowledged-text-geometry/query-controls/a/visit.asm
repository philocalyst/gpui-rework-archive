
/tmp/gpui-ack-query-comparison/a/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a2f350 <query_visit_control>:
  a2f350:	53                   	push   %rbx
  a2f351:	48 81 ec 80 00 00 00 	sub    $0x80,%rsp
  a2f358:	48 89 fe             	mov    %rdi,%rsi
  a2f35b:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  a2f362:	00 00 
  a2f364:	48 8d 7c 24 48       	lea    0x48(%rsp),%rdi
  a2f369:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  a2f36e:	e8 4d 30 f8 ff       	call   9b23c0 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>>
  a2f373:	83 7c 24 48 fe       	cmpl   $0xfffffffe,0x48(%rsp)
  a2f378:	75 1d                	jne    a2f397 <query_visit_control+0x47>
  a2f37a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  a2f37f:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  a2f384:	48 8d 44 24 10       	lea    0x10(%rsp),%rax
  a2f389:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  a2f38e:	48 81 c4 80 00 00 00 	add    $0x80,%rsp
  a2f395:	5b                   	pop    %rbx
  a2f396:	c3                   	ret
  a2f397:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  a2f39c:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  a2f3a1:	0f 10 44 24 48       	movups 0x48(%rsp),%xmm0
  a2f3a6:	0f 10 4c 24 58       	movups 0x58(%rsp),%xmm1
  a2f3ab:	0f 10 54 24 68       	movups 0x68(%rsp),%xmm2
  a2f3b0:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  a2f3b5:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  a2f3ba:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  a2f3bf:	48 8d 3d 58 bf 76 ff 	lea    -0x8940a8(%rip),%rdi        # 19b31e <anon.8928f3dadf8cdc15980c8230354e99cc.17.llvm.3692146773738777312+0xf>
  a2f3c6:	48 8d 0d cb 03 a9 00 	lea    0xa903cb(%rip),%rcx        # 14bf798 <anon.8928f3dadf8cdc15980c8230354e99cc.19.llvm.3692146773738777312+0xd8>
  a2f3cd:	4c 8d 05 74 07 a9 00 	lea    0xa90774(%rip),%r8        # 14bfb48 <anon.8928f3dadf8cdc15980c8230354e99cc.119.llvm.3692146773738777312+0xf8>
  a2f3d4:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  a2f3d9:	be 2b 00 00 00       	mov    $0x2b,%esi
  a2f3de:	ff 15 3c 0b b0 00    	call   *0xb00b3c(%rip)        # 152ff20 <_DYNAMIC+0x380>
  a2f3e4:	0f 0b                	ud2
  a2f3e6:	48 89 c3             	mov    %rax,%rbx
  a2f3e9:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  a2f3ee:	e8 2d 90 ff ff       	call   a28420 <core::ptr::drop_glue::<gpui::runtime::Error>>
  a2f3f3:	48 89 df             	mov    %rbx,%rdi
  a2f3f6:	e8 75 b2 a8 00       	call   14ba670 <_Unwind_Resume@plt>
