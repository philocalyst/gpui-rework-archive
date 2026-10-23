
/tmp/gpui-caret-transaction-bin/62e-codegen:     file format elf64-x86-64


Disassembly of section .text:

000000000001ce60 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>>:
   1ce60:	55                   	push   %rbp
   1ce61:	41 57                	push   %r15
   1ce63:	41 56                	push   %r14
   1ce65:	41 55                	push   %r13
   1ce67:	41 54                	push   %r12
   1ce69:	53                   	push   %rbx
   1ce6a:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
   1ce71:	66 0f 7e 04 24       	movd   %xmm0,(%rsp)
   1ce76:	48 8b 0e             	mov    (%rsi),%rcx
   1ce79:	48 8b 46 08          	mov    0x8(%rsi),%rax
   1ce7d:	4c 8b 6e 18          	mov    0x18(%rsi),%r13
   1ce81:	48 8b 2a             	mov    (%rdx),%rbp
   1ce84:	0f b6 56 20          	movzbl 0x20(%rsi),%edx
   1ce88:	4c 8b 66 10          	mov    0x10(%rsi),%r12
   1ce8c:	48 c7 06 02 00 00 00 	movq   $0x2,(%rsi)
   1ce93:	48 85 c9             	test   %rcx,%rcx
   1ce96:	0f 84 37 02 00 00    	je     1d0d3 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x273>
   1ce9c:	48 89 f3             	mov    %rsi,%rbx
   1ce9f:	49 89 fe             	mov    %rdi,%r14
   1cea2:	48 83 f9 02          	cmp    $0x2,%rcx
   1cea6:	75 29                	jne    1ced1 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x71>
   1cea8:	4d 39 ec             	cmp    %r13,%r12
   1ceab:	0f 97 c0             	seta   %al
   1ceae:	08 c2                	or     %al,%dl
   1ceb0:	f6 c2 01             	test   $0x1,%dl
   1ceb3:	0f 85 1a 02 00 00    	jne    1d0d3 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x273>
   1ceb9:	4d 39 ec             	cmp    %r13,%r12
   1cebc:	73 1f                	jae    1cedd <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x7d>
   1cebe:	4d 8d 7c 24 01       	lea    0x1(%r12),%r15
   1cec3:	4c 89 7b 10          	mov    %r15,0x10(%rbx)
   1cec7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%rsp)
   1cece:	00 
   1cecf:	eb 19                	jmp    1ceea <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x8a>
   1ced1:	89 54 24 04          	mov    %edx,0x4(%rsp)
   1ced5:	4d 89 e7             	mov    %r12,%r15
   1ced8:	49 89 c4             	mov    %rax,%r12
   1cedb:	eb 0d                	jmp    1ceea <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x8a>
   1cedd:	c6 43 20 01          	movb   $0x1,0x20(%rbx)
   1cee1:	b0 01                	mov    $0x1,%al
   1cee3:	89 44 24 04          	mov    %eax,0x4(%rsp)
   1cee7:	4d 89 e7             	mov    %r12,%r15
   1ceea:	4c 89 f7             	mov    %r14,%rdi
   1ceed:	4c 89 e6             	mov    %r12,%rsi
   1cef0:	ba 01 00 00 00       	mov    $0x1,%edx
   1cef5:	e8 a6 dd ff ff       	call   1aca0 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
   1cefa:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
   1ceff:	80 e2 01             	and    $0x1,%dl
   1cf02:	88 54 24 10          	mov    %dl,0x10(%rsp)
   1cf06:	4c 39 e0             	cmp    %r12,%rax
   1cf09:	0f 85 95 00 00 00    	jne    1cfa4 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x144>
   1cf0f:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
   1cf14:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   1cf19:	4c 89 f2             	mov    %r14,%rdx
   1cf1c:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
   1cf21:	e8 3a de ff ff       	call   1ad60 <<parley::editing::cursor::Cursor>::geometry::<()>>
   1cf26:	4c 89 f7             	mov    %r14,%rdi
   1cf29:	4c 89 e6             	mov    %r12,%rsi
   1cf2c:	31 d2                	xor    %edx,%edx
   1cf2e:	e8 6d dd ff ff       	call   1aca0 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
   1cf33:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   1cf38:	80 e2 01             	and    $0x1,%dl
   1cf3b:	88 54 24 20          	mov    %dl,0x20(%rsp)
   1cf3f:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
   1cf44:	48 8d 74 24 18       	lea    0x18(%rsp),%rsi
   1cf49:	4c 89 f2             	mov    %r14,%rdx
   1cf4c:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
   1cf51:	e8 0a de ff ff       	call   1ad60 <<parley::editing::cursor::Cursor>::geometry::<()>>
   1cf56:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
   1cf5b:	0f 10 4c 24 78       	movups 0x78(%rsp),%xmm1
   1cf60:	48 8d 44 24 48       	lea    0x48(%rsp),%rax
   1cf65:	0f 11 48 10          	movups %xmm1,0x10(%rax)
   1cf69:	0f 11 00             	movups %xmm0,(%rax)
   1cf6c:	f3 0f 6f 44 24 28    	movdqu 0x28(%rsp),%xmm0
   1cf72:	f3 0f 6f 4c 24 38    	movdqu 0x38(%rsp),%xmm1
   1cf78:	f3 0f 6f 54 24 48    	movdqu 0x48(%rsp),%xmm2
   1cf7e:	66 0f ef d0          	pxor   %xmm0,%xmm2
   1cf82:	f3 0f 6f 44 24 58    	movdqu 0x58(%rsp),%xmm0
   1cf88:	66 0f ef c1          	pxor   %xmm1,%xmm0
   1cf8c:	66 0f ef c2          	pxor   %xmm2,%xmm0
   1cf90:	66 0f 70 c8 ee       	pshufd $0xee,%xmm0,%xmm1
   1cf95:	66 0f ef c8          	pxor   %xmm0,%xmm1
   1cf99:	66 48 0f 7e c8       	movq   %xmm1,%rax
   1cf9e:	48 33 45 00          	xor    0x0(%rbp),%rax
   1cfa2:	eb 04                	jmp    1cfa8 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x148>
   1cfa4:	48 8b 45 00          	mov    0x0(%rbp),%rax
   1cfa8:	4c 31 e0             	xor    %r12,%rax
   1cfab:	48 89 45 00          	mov    %rax,0x0(%rbp)
   1cfaf:	48 c7 03 02 00 00 00 	movq   $0x2,(%rbx)
   1cfb6:	4d 39 ef             	cmp    %r13,%r15
   1cfb9:	0f 97 c0             	seta   %al
   1cfbc:	8b 4c 24 04          	mov    0x4(%rsp),%ecx
   1cfc0:	08 c1                	or     %al,%cl
   1cfc2:	f6 c1 01             	test   $0x1,%cl
   1cfc5:	0f 85 08 01 00 00    	jne    1d0d3 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x273>
   1cfcb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   1cfd0:	4d 39 ef             	cmp    %r13,%r15
   1cfd3:	72 0b                	jb     1cfe0 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x180>
   1cfd5:	c6 43 20 01          	movb   $0x1,0x20(%rbx)
   1cfd9:	4d 89 fc             	mov    %r15,%r12
   1cfdc:	eb 0a                	jmp    1cfe8 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x188>
   1cfde:	66 90                	xchg   %ax,%ax
   1cfe0:	4d 8d 67 01          	lea    0x1(%r15),%r12
   1cfe4:	4c 89 63 10          	mov    %r12,0x10(%rbx)
   1cfe8:	4c 89 f7             	mov    %r14,%rdi
   1cfeb:	4c 89 fe             	mov    %r15,%rsi
   1cfee:	ba 01 00 00 00       	mov    $0x1,%edx
   1cff3:	e8 a8 dc ff ff       	call   1aca0 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
   1cff8:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
   1cffd:	80 e2 01             	and    $0x1,%dl
   1d000:	88 54 24 10          	mov    %dl,0x10(%rsp)
   1d004:	4c 39 f8             	cmp    %r15,%rax
   1d007:	0f 85 a3 00 00 00    	jne    1d0b0 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x250>
   1d00d:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
   1d012:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   1d017:	4c 89 f2             	mov    %r14,%rdx
   1d01a:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
   1d01f:	e8 3c dd ff ff       	call   1ad60 <<parley::editing::cursor::Cursor>::geometry::<()>>
   1d024:	4c 89 f7             	mov    %r14,%rdi
   1d027:	4c 89 fe             	mov    %r15,%rsi
   1d02a:	31 d2                	xor    %edx,%edx
   1d02c:	e8 6f dc ff ff       	call   1aca0 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
   1d031:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   1d036:	80 e2 01             	and    $0x1,%dl
   1d039:	88 54 24 20          	mov    %dl,0x20(%rsp)
   1d03d:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
   1d042:	48 8d 74 24 18       	lea    0x18(%rsp),%rsi
   1d047:	4c 89 f2             	mov    %r14,%rdx
   1d04a:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
   1d04f:	e8 0c dd ff ff       	call   1ad60 <<parley::editing::cursor::Cursor>::geometry::<()>>
   1d054:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
   1d059:	0f 10 4c 24 78       	movups 0x78(%rsp),%xmm1
   1d05e:	48 8d 44 24 48       	lea    0x48(%rsp),%rax
   1d063:	0f 11 48 10          	movups %xmm1,0x10(%rax)
   1d067:	0f 11 00             	movups %xmm0,(%rax)
   1d06a:	f3 0f 6f 44 24 28    	movdqu 0x28(%rsp),%xmm0
   1d070:	f3 0f 6f 4c 24 38    	movdqu 0x38(%rsp),%xmm1
   1d076:	f3 0f 6f 54 24 48    	movdqu 0x48(%rsp),%xmm2
   1d07c:	66 0f ef d0          	pxor   %xmm0,%xmm2
   1d080:	f3 0f 6f 44 24 58    	movdqu 0x58(%rsp),%xmm0
   1d086:	66 0f ef c1          	pxor   %xmm1,%xmm0
   1d08a:	66 0f ef c2          	pxor   %xmm2,%xmm0
   1d08e:	66 0f 70 c8 ee       	pshufd $0xee,%xmm0,%xmm1
   1d093:	66 0f ef c8          	pxor   %xmm0,%xmm1
   1d097:	66 48 0f 7e c8       	movq   %xmm1,%rax
   1d09c:	48 33 45 00          	xor    0x0(%rbp),%rax
   1d0a0:	eb 12                	jmp    1d0b4 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x254>
   1d0a2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   1d0a9:	1f 84 00 00 00 00 00 
   1d0b0:	48 8b 45 00          	mov    0x0(%rbp),%rax
   1d0b4:	4c 31 f8             	xor    %r15,%rax
   1d0b7:	48 89 45 00          	mov    %rax,0x0(%rbp)
   1d0bb:	48 c7 03 02 00 00 00 	movq   $0x2,(%rbx)
   1d0c2:	4d 39 ef             	cmp    %r13,%r15
   1d0c5:	73 0c                	jae    1d0d3 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x273>
   1d0c7:	4d 89 e7             	mov    %r12,%r15
   1d0ca:	4d 39 ec             	cmp    %r13,%r12
   1d0cd:	0f 86 fd fe ff ff    	jbe    1cfd0 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x170>
   1d0d3:	31 c0                	xor    %eax,%eax
   1d0d5:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
   1d0dc:	5b                   	pop    %rbx
   1d0dd:	41 5c                	pop    %r12
   1d0df:	41 5d                	pop    %r13
   1d0e1:	41 5e                	pop    %r14
   1d0e3:	41 5f                	pop    %r15
   1d0e5:	5d                   	pop    %rbp
   1d0e6:	c3                   	ret
