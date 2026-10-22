
/tmp/gpui-style-startup-base-target/release/examples/literal_startup:     file format elf64-x86-64


Disassembly of section .text:

00000000004ede30 <literal_startup::single_width_probe>:
  4ede30:	53                   	push   %rbx
  4ede31:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  4ede38:	c6 84 24 c8 00 00 00 	movb   $0x0,0xc8(%rsp)
  4ede3f:	00 
  4ede40:	48 c7 44 24 38 ff ff 	movq   $0xffffffffffffffff,0x38(%rsp)
  4ede47:	ff ff 
  4ede49:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  4ede50:	00 00 
  4ede52:	48 c7 44 24 28 08 00 	movq   $0x8,0x28(%rsp)
  4ede59:	00 00 
  4ede5b:	48 c7 44 24 30 00 00 	movq   $0x0,0x30(%rsp)
  4ede62:	00 00 
  4ede64:	0f 10 05 59 a2 b5 ff 	movups -0x4a5da7(%rip),%xmm0        # 480c4 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.3697923927314719398>
  4ede6b:	0f 11 44 24 50       	movups %xmm0,0x50(%rsp)
  4ede70:	0f 10 05 5d a2 b5 ff 	movups -0x4a5da3(%rip),%xmm0        # 480d4 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.3697923927314719398+0x10>
  4ede77:	0f 11 44 24 60       	movups %xmm0,0x60(%rsp)
  4ede7c:	0f 10 05 61 a2 b5 ff 	movups -0x4a5d9f(%rip),%xmm0        # 480e4 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.3697923927314719398+0x20>
  4ede83:	0f 11 44 24 70       	movups %xmm0,0x70(%rsp)
  4ede88:	0f 10 05 65 a2 b5 ff 	movups -0x4a5d9b(%rip),%xmm0        # 480f4 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.3697923927314719398+0x30>
  4ede8f:	0f 11 84 24 80 00 00 	movups %xmm0,0x80(%rsp)
  4ede96:	00 
  4ede97:	0f 10 05 66 a2 b5 ff 	movups -0x4a5d9a(%rip),%xmm0        # 48104 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.3697923927314719398+0x40>
  4ede9e:	0f 11 84 24 90 00 00 	movups %xmm0,0x90(%rsp)
  4edea5:	00 
  4edea6:	48 b8 00 00 00 00 01 	movabs $0x3000100000000,%rax
  4edead:	00 03 00 
  4edeb0:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  4edeb7:	00 
  4edeb8:	48 c7 84 24 a8 00 00 	movq   $0x0,0xa8(%rsp)
  4edebf:	00 00 00 00 00 
  4edec4:	0f 57 c0             	xorps  %xmm0,%xmm0
  4edec7:	0f 11 84 24 b8 00 00 	movups %xmm0,0xb8(%rsp)
  4edece:	00 
  4edecf:	48 8d 05 02 ac b5 ff 	lea    -0x4a53fe(%rip),%rax        # 48ad8 <anon.6ba7146c6aa0f0ae89a42e7891a41f44.7.llvm.11103893389065245635>
  4eded6:	48 89 04 24          	mov    %rax,(%rsp)
  4ededa:	89 f0                	mov    %esi,%eax
  4ededc:	0f 57 c0             	xorps  %xmm0,%xmm0
  4ededf:	f2 48 0f 2a c0       	cvtsi2sd %rax,%xmm0
  4edee4:	48 c7 44 24 08 05 00 	movq   $0x5,0x8(%rsp)
  4edeeb:	00 00 
  4edeed:	66 48 0f 7e c1       	movq   %xmm0,%rcx
  4edef2:	48 ba 00 00 00 00 00 	movabs $0xfff0000000000000,%rdx
  4edef9:	00 f0 ff 
  4edefc:	48 01 ca             	add    %rcx,%rdx
  4edeff:	48 c1 ea 35          	shr    $0x35,%rdx
  4edf03:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  4edf09:	0f 92 c2             	setb   %dl
  4edf0c:	48 85 c9             	test   %rcx,%rcx
  4edf0f:	0f 94 c1             	sete   %cl
  4edf12:	40 0f 99 c6          	setns  %sil
  4edf16:	40 20 d6             	and    %dl,%sil
  4edf19:	40 08 ce             	or     %cl,%sil
  4edf1c:	74 35                	je     4edf53 <literal_startup::single_width_probe+0x123>
  4edf1e:	48 89 fb             	mov    %rdi,%rbx
  4edf21:	0f 57 c0             	xorps  %xmm0,%xmm0
  4edf24:	f3 48 0f 2a c0       	cvtsi2ss %rax,%xmm0
  4edf29:	c7 44 24 50 01 00 00 	movl   $0x1,0x50(%rsp)
  4edf30:	00 
  4edf31:	f3 0f 11 44 24 54    	movss  %xmm0,0x54(%rsp)
  4edf37:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
  4edf3c:	ba b0 00 00 00       	mov    $0xb0,%edx
  4edf41:	ff 15 c1 86 2d 00    	call   *0x2d86c1(%rip)        # 7c6608 <memcpy@GLIBC_2.14>
  4edf47:	48 89 d8             	mov    %rbx,%rax
  4edf4a:	48 81 c4 d0 00 00 00 	add    $0xd0,%rsp
  4edf51:	5b                   	pop    %rbx
  4edf52:	c3                   	ret
  4edf53:	48 89 e0             	mov    %rsp,%rax
  4edf56:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  4edf5b:	48 8d 05 ee f1 00 00 	lea    0xf1ee(%rip),%rax        # 4fd150 <<&str as core::fmt::Display>::fmt>
  4edf62:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  4edf67:	48 8d 3d 0d 0e b5 ff 	lea    -0x4af1f3(%rip),%rdi        # 3ed7b <anon.92dd3145bac80cf215b9d7fafbb74c84.0.llvm.12650873719306534212>
  4edf6e:	48 8d 15 93 77 2b 00 	lea    0x2b7793(%rip),%rdx        # 7a5708 <anon.92dd3145bac80cf215b9d7fafbb74c84.2.llvm.12650873719306534212>
  4edf75:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  4edf7a:	ff 15 b8 86 2d 00    	call   *0x2d86b8(%rip)        # 7c6638 <_DYNAMIC+0x2a0>
  4edf80:	0f 0b                	ud2
  4edf82:	48 89 c3             	mov    %rax,%rbx
  4edf85:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  4edf8a:	e8 91 1f 01 00       	call   4fff20 <core::ptr::drop_glue::<gpui::element::El>>
  4edf8f:	48 89 df             	mov    %rbx,%rdi
  4edf92:	e8 d9 54 2b 00       	call   7a3470 <_Unwind_Resume@plt>
  4edf97:	ff 15 93 86 2d 00    	call   *0x2d8693(%rip)        # 7c6630 <_DYNAMIC+0x298>
