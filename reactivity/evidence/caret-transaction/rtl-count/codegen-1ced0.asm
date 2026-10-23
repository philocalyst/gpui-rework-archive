
/tmp/gpui-caret-transaction-bin/d54-codegen:     file format elf64-x86-64


Disassembly of section .text:

000000000001ced0 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>>:
   1ced0:	55                   	push   %rbp
   1ced1:	41 57                	push   %r15
   1ced3:	41 56                	push   %r14
   1ced5:	41 55                	push   %r13
   1ced7:	41 54                	push   %r12
   1ced9:	53                   	push   %rbx
   1ceda:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
   1cee1:	66 0f 7e 04 24       	movd   %xmm0,(%rsp)
   1cee6:	48 8b 0e             	mov    (%rsi),%rcx
   1cee9:	48 8b 46 08          	mov    0x8(%rsi),%rax
   1ceed:	4c 8b 6e 18          	mov    0x18(%rsi),%r13
   1cef1:	48 8b 2a             	mov    (%rdx),%rbp
   1cef4:	0f b6 56 20          	movzbl 0x20(%rsi),%edx
   1cef8:	4c 8b 66 10          	mov    0x10(%rsi),%r12
   1cefc:	48 c7 06 02 00 00 00 	movq   $0x2,(%rsi)
   1cf03:	48 85 c9             	test   %rcx,%rcx
   1cf06:	0f 84 37 02 00 00    	je     1d143 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x273>
   1cf0c:	48 89 f3             	mov    %rsi,%rbx
   1cf0f:	49 89 fe             	mov    %rdi,%r14
   1cf12:	48 83 f9 02          	cmp    $0x2,%rcx
   1cf16:	75 29                	jne    1cf41 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x71>
   1cf18:	4d 39 ec             	cmp    %r13,%r12
   1cf1b:	0f 97 c0             	seta   %al
   1cf1e:	08 c2                	or     %al,%dl
   1cf20:	f6 c2 01             	test   $0x1,%dl
   1cf23:	0f 85 1a 02 00 00    	jne    1d143 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x273>
   1cf29:	4d 39 ec             	cmp    %r13,%r12
   1cf2c:	73 1f                	jae    1cf4d <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x7d>
   1cf2e:	4d 8d 7c 24 01       	lea    0x1(%r12),%r15
   1cf33:	4c 89 7b 10          	mov    %r15,0x10(%rbx)
   1cf37:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%rsp)
   1cf3e:	00 
   1cf3f:	eb 19                	jmp    1cf5a <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x8a>
   1cf41:	89 54 24 04          	mov    %edx,0x4(%rsp)
   1cf45:	4d 89 e7             	mov    %r12,%r15
   1cf48:	49 89 c4             	mov    %rax,%r12
   1cf4b:	eb 0d                	jmp    1cf5a <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x8a>
   1cf4d:	c6 43 20 01          	movb   $0x1,0x20(%rbx)
   1cf51:	b0 01                	mov    $0x1,%al
   1cf53:	89 44 24 04          	mov    %eax,0x4(%rsp)
   1cf57:	4d 89 e7             	mov    %r12,%r15
   1cf5a:	4c 89 f7             	mov    %r14,%rdi
   1cf5d:	4c 89 e6             	mov    %r12,%rsi
   1cf60:	ba 01 00 00 00       	mov    $0x1,%edx
   1cf65:	e8 96 dd ff ff       	call   1ad00 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
   1cf6a:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
   1cf6f:	80 e2 01             	and    $0x1,%dl
   1cf72:	88 54 24 10          	mov    %dl,0x10(%rsp)
   1cf76:	4c 39 e0             	cmp    %r12,%rax
   1cf79:	0f 85 95 00 00 00    	jne    1d014 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x144>
   1cf7f:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
   1cf84:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   1cf89:	4c 89 f2             	mov    %r14,%rdx
   1cf8c:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
   1cf91:	e8 2a de ff ff       	call   1adc0 <<parley::editing::cursor::Cursor>::geometry::<()>>
   1cf96:	4c 89 f7             	mov    %r14,%rdi
   1cf99:	4c 89 e6             	mov    %r12,%rsi
   1cf9c:	31 d2                	xor    %edx,%edx
   1cf9e:	e8 5d dd ff ff       	call   1ad00 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
   1cfa3:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   1cfa8:	80 e2 01             	and    $0x1,%dl
   1cfab:	88 54 24 20          	mov    %dl,0x20(%rsp)
   1cfaf:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
   1cfb4:	48 8d 74 24 18       	lea    0x18(%rsp),%rsi
   1cfb9:	4c 89 f2             	mov    %r14,%rdx
   1cfbc:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
   1cfc1:	e8 fa dd ff ff       	call   1adc0 <<parley::editing::cursor::Cursor>::geometry::<()>>
   1cfc6:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
   1cfcb:	0f 10 4c 24 78       	movups 0x78(%rsp),%xmm1
   1cfd0:	48 8d 44 24 48       	lea    0x48(%rsp),%rax
   1cfd5:	0f 11 48 10          	movups %xmm1,0x10(%rax)
   1cfd9:	0f 11 00             	movups %xmm0,(%rax)
   1cfdc:	f3 0f 6f 44 24 28    	movdqu 0x28(%rsp),%xmm0
   1cfe2:	f3 0f 6f 4c 24 38    	movdqu 0x38(%rsp),%xmm1
   1cfe8:	f3 0f 6f 54 24 48    	movdqu 0x48(%rsp),%xmm2
   1cfee:	66 0f ef d0          	pxor   %xmm0,%xmm2
   1cff2:	f3 0f 6f 44 24 58    	movdqu 0x58(%rsp),%xmm0
   1cff8:	66 0f ef c1          	pxor   %xmm1,%xmm0
   1cffc:	66 0f ef c2          	pxor   %xmm2,%xmm0
   1d000:	66 0f 70 c8 ee       	pshufd $0xee,%xmm0,%xmm1
   1d005:	66 0f ef c8          	pxor   %xmm0,%xmm1
   1d009:	66 48 0f 7e c8       	movq   %xmm1,%rax
   1d00e:	48 33 45 00          	xor    0x0(%rbp),%rax
   1d012:	eb 04                	jmp    1d018 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x148>
   1d014:	48 8b 45 00          	mov    0x0(%rbp),%rax
   1d018:	4c 31 e0             	xor    %r12,%rax
   1d01b:	48 89 45 00          	mov    %rax,0x0(%rbp)
   1d01f:	48 c7 03 02 00 00 00 	movq   $0x2,(%rbx)
   1d026:	4d 39 ef             	cmp    %r13,%r15
   1d029:	0f 97 c0             	seta   %al
   1d02c:	8b 4c 24 04          	mov    0x4(%rsp),%ecx
   1d030:	08 c1                	or     %al,%cl
   1d032:	f6 c1 01             	test   $0x1,%cl
   1d035:	0f 85 08 01 00 00    	jne    1d143 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x273>
   1d03b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   1d040:	4d 39 ef             	cmp    %r13,%r15
   1d043:	72 0b                	jb     1d050 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x180>
   1d045:	c6 43 20 01          	movb   $0x1,0x20(%rbx)
   1d049:	4d 89 fc             	mov    %r15,%r12
   1d04c:	eb 0a                	jmp    1d058 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x188>
   1d04e:	66 90                	xchg   %ax,%ax
   1d050:	4d 8d 67 01          	lea    0x1(%r15),%r12
   1d054:	4c 89 63 10          	mov    %r12,0x10(%rbx)
   1d058:	4c 89 f7             	mov    %r14,%rdi
   1d05b:	4c 89 fe             	mov    %r15,%rsi
   1d05e:	ba 01 00 00 00       	mov    $0x1,%edx
   1d063:	e8 98 dc ff ff       	call   1ad00 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
   1d068:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
   1d06d:	80 e2 01             	and    $0x1,%dl
   1d070:	88 54 24 10          	mov    %dl,0x10(%rsp)
   1d074:	4c 39 f8             	cmp    %r15,%rax
   1d077:	0f 85 a3 00 00 00    	jne    1d120 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x250>
   1d07d:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
   1d082:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
   1d087:	4c 89 f2             	mov    %r14,%rdx
   1d08a:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
   1d08f:	e8 2c dd ff ff       	call   1adc0 <<parley::editing::cursor::Cursor>::geometry::<()>>
   1d094:	4c 89 f7             	mov    %r14,%rdi
   1d097:	4c 89 fe             	mov    %r15,%rsi
   1d09a:	31 d2                	xor    %edx,%edx
   1d09c:	e8 5f dc ff ff       	call   1ad00 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
   1d0a1:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   1d0a6:	80 e2 01             	and    $0x1,%dl
   1d0a9:	88 54 24 20          	mov    %dl,0x20(%rsp)
   1d0ad:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
   1d0b2:	48 8d 74 24 18       	lea    0x18(%rsp),%rsi
   1d0b7:	4c 89 f2             	mov    %r14,%rdx
   1d0ba:	f3 0f 10 04 24       	movss  (%rsp),%xmm0
   1d0bf:	e8 fc dc ff ff       	call   1adc0 <<parley::editing::cursor::Cursor>::geometry::<()>>
   1d0c4:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
   1d0c9:	0f 10 4c 24 78       	movups 0x78(%rsp),%xmm1
   1d0ce:	48 8d 44 24 48       	lea    0x48(%rsp),%rax
   1d0d3:	0f 11 48 10          	movups %xmm1,0x10(%rax)
   1d0d7:	0f 11 00             	movups %xmm0,(%rax)
   1d0da:	f3 0f 6f 44 24 28    	movdqu 0x28(%rsp),%xmm0
   1d0e0:	f3 0f 6f 4c 24 38    	movdqu 0x38(%rsp),%xmm1
   1d0e6:	f3 0f 6f 54 24 48    	movdqu 0x48(%rsp),%xmm2
   1d0ec:	66 0f ef d0          	pxor   %xmm0,%xmm2
   1d0f0:	f3 0f 6f 44 24 58    	movdqu 0x58(%rsp),%xmm0
   1d0f6:	66 0f ef c1          	pxor   %xmm1,%xmm0
   1d0fa:	66 0f ef c2          	pxor   %xmm2,%xmm0
   1d0fe:	66 0f 70 c8 ee       	pshufd $0xee,%xmm0,%xmm1
   1d103:	66 0f ef c8          	pxor   %xmm0,%xmm1
   1d107:	66 48 0f 7e c8       	movq   %xmm1,%rax
   1d10c:	48 33 45 00          	xor    0x0(%rbp),%rax
   1d110:	eb 12                	jmp    1d124 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x254>
   1d112:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   1d119:	1f 84 00 00 00 00 00 
   1d120:	48 8b 45 00          	mov    0x0(%rbp),%rax
   1d124:	4c 31 f8             	xor    %r15,%rax
   1d127:	48 89 45 00          	mov    %rax,0x0(%rbp)
   1d12b:	48 c7 03 02 00 00 00 	movq   $0x2,(%rbx)
   1d132:	4d 39 ef             	cmp    %r13,%r15
   1d135:	73 0c                	jae    1d143 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x273>
   1d137:	4d 89 e7             	mov    %r12,%r15
   1d13a:	4d 39 ec             	cmp    %r13,%r12
   1d13d:	0f 86 fd fe ff ff    	jbe    1d040 <parley::editing::geometry::visit_direct::<(), (), &mut core::iter::adapters::peekable::Peekable<core::ops::range::RangeInclusive<usize>>, transaction_codegen::atomic::{closure#0}>+0x170>
   1d143:	31 c0                	xor    %eax,%eax
   1d145:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
   1d14c:	5b                   	pop    %rbx
   1d14d:	41 5c                	pop    %r12
   1d14f:	41 5d                	pop    %r13
   1d151:	41 5e                	pop    %r14
   1d153:	41 5f                	pop    %r15
   1d155:	5d                   	pop    %rbp
   1d156:	c3                   	ret
