
/tmp/gpui-acknowledged-text-evidence/query-release-candidate/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a4be60 <query_visit_control>:
  a4be60:	53                   	push   %rbx
  a4be61:	48 81 ec 80 00 00 00 	sub    $0x80,%rsp
  a4be68:	48 89 fe             	mov    %rdi,%rsi
  a4be6b:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  a4be72:	00 00 
  a4be74:	48 8d 7c 24 48       	lea    0x48(%rsp),%rdi
  a4be79:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  a4be7e:	e8 ad 64 f6 ff       	call   9b2330 <<gpui::runtime::Win<ack_query_control::Page>>::visit::<ack_query_control::query_visit_control::{closure#0}>>
  a4be83:	83 7c 24 48 fe       	cmpl   $0xfffffffe,0x48(%rsp)
  a4be88:	75 1d                	jne    a4bea7 <query_visit_control+0x47>
  a4be8a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  a4be8f:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  a4be94:	48 8d 44 24 10       	lea    0x10(%rsp),%rax
  a4be99:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  a4be9e:	48 81 c4 80 00 00 00 	add    $0x80,%rsp
  a4bea5:	5b                   	pop    %rbx
  a4bea6:	c3                   	ret
  a4bea7:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  a4beac:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  a4beb1:	0f 10 44 24 48       	movups 0x48(%rsp),%xmm0
  a4beb6:	0f 10 4c 24 58       	movups 0x58(%rsp),%xmm1
  a4bebb:	0f 10 54 24 68       	movups 0x68(%rsp),%xmm2
  a4bec0:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  a4bec5:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  a4beca:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  a4becf:	48 8d 3d c0 fe 74 ff 	lea    -0x8b0140(%rip),%rdi        # 19bd96 <anon.68a54e84e457eea401d24dc6a9d93b0a.6.llvm.2319709713416821753+0x24>
  a4bed6:	48 8d 0d 43 45 a7 00 	lea    0xa74543(%rip),%rcx        # 14c0420 <anon.68a54e84e457eea401d24dc6a9d93b0a.19.llvm.2319709713416821753+0xd8>
  a4bedd:	4c 8d 05 0c 49 a7 00 	lea    0xa7490c(%rip),%r8        # 14c07f0 <anon.68a54e84e457eea401d24dc6a9d93b0a.122.llvm.2319709713416821753+0xf8>
  a4bee4:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  a4bee9:	be 2b 00 00 00       	mov    $0x2b,%esi
  a4beee:	ff 15 04 36 ae 00    	call   *0xae3604(%rip)        # 152f4f8 <_DYNAMIC+0x380>
  a4bef4:	0f 0b                	ud2
  a4bef6:	48 89 c3             	mov    %rax,%rbx
  a4bef9:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  a4befe:	e8 dd 9a ff ff       	call   a459e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  a4bf03:	48 89 df             	mov    %rbx,%rdi
  a4bf06:	e8 e5 dc a6 00       	call   14b9bf0 <_Unwind_Resume@plt>

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .plt:
