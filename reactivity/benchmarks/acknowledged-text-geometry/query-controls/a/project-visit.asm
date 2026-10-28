
/tmp/gpui-ack-query-comparison/a/client:     file format elf64-x86-64


Disassembly of section .text:

0000000000a7cef0 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>>:
  a7cef0:	55                   	push   %rbp
  a7cef1:	41 57                	push   %r15
  a7cef3:	41 56                	push   %r14
  a7cef5:	41 55                	push   %r13
  a7cef7:	41 54                	push   %r12
  a7cef9:	53                   	push   %rbx
  a7cefa:	48 81 ec 58 01 00 00 	sub    $0x158,%rsp
  a7cf01:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  a7cf06:	48 8b 5f 38          	mov    0x38(%rdi),%rbx
  a7cf0a:	48 85 db             	test   %rbx,%rbx
  a7cf0d:	0f 84 7f 03 00 00    	je     a7d292 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x3a2>
  a7cf13:	4c 8b 3e             	mov    (%rsi),%r15
  a7cf16:	48 8b 46 08          	mov    0x8(%rsi),%rax
  a7cf1a:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  a7cf1f:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  a7cf24:	48 8b 68 28          	mov    0x28(%rax),%rbp
  a7cf28:	4c 8b 68 30          	mov    0x30(%rax),%r13
  a7cf2c:	4c 8b 66 10          	mov    0x10(%rsi),%r12
  a7cf30:	48 8b 48 50          	mov    0x50(%rax),%rcx
  a7cf34:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  a7cf39:	48 8b 40 58          	mov    0x58(%rax),%rax
  a7cf3d:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  a7cf42:	48 8b 46 18          	mov    0x18(%rsi),%rax
  a7cf46:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  a7cf4b:	45 31 c0             	xor    %r8d,%r8d
  a7cf4e:	48 89 6c 24 20       	mov    %rbp,0x20(%rsp)
  a7cf53:	4c 89 24 24          	mov    %r12,(%rsp)
  a7cf57:	eb 48                	jmp    a7cfa1 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0xb1>
  a7cf59:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  a7cf60:	4c 89 f0             	mov    %r14,%rax
  a7cf63:	48 c1 e0 07          	shl    $0x7,%rax
  a7cf67:	4a 8d 3c f0          	lea    (%rax,%r14,8),%rdi
  a7cf6b:	49 03 7c 24 08       	add    0x8(%r12),%rdi
  a7cf70:	ba 88 00 00 00       	mov    $0x88,%edx
  a7cf75:	48 8d b4 24 d0 00 00 	lea    0xd0(%rsp),%rsi
  a7cf7c:	00 
  a7cf7d:	ff 15 7d 2e ab 00    	call   *0xab2e7d(%rip)        # 152fe00 <memcpy@GLIBC_2.14>
  a7cf83:	49 ff c6             	inc    %r14
  a7cf86:	4d 89 74 24 10       	mov    %r14,0x10(%r12)
  a7cf8b:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  a7cf90:	49 ff c0             	inc    %r8
  a7cf93:	49 39 d8             	cmp    %rbx,%r8
  a7cf96:	48 8b 6c 24 20       	mov    0x20(%rsp),%rbp
  a7cf9b:	0f 84 f1 02 00 00    	je     a7d292 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x3a2>
  a7cfa1:	49 8b 4f 10          	mov    0x10(%r15),%rcx
  a7cfa5:	44 89 c7             	mov    %r8d,%edi
  a7cfa8:	4c 8d 24 bf          	lea    (%rdi,%rdi,4),%r12
  a7cfac:	49 c1 e4 04          	shl    $0x4,%r12
  a7cfb0:	4d 01 ec             	add    %r13,%r12
  a7cfb3:	eb 12                	jmp    a7cfc7 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0xd7>
  a7cfb5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  a7cfbc:	00 00 00 00 
  a7cfc0:	48 ff c9             	dec    %rcx
  a7cfc3:	49 89 4f 10          	mov    %rcx,0x10(%r15)
  a7cfc7:	48 85 c9             	test   %rcx,%rcx
  a7cfca:	74 54                	je     a7d020 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x130>
  a7cfcc:	41 8b 44 24 48       	mov    0x48(%r12),%eax
  a7cfd1:	25 ff ff 01 00       	and    $0x1ffff,%eax
  a7cfd6:	48 3d ff ff 01 00    	cmp    $0x1ffff,%rax
  a7cfdc:	74 e2                	je     a7cfc0 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0xd0>
  a7cfde:	48 39 c3             	cmp    %rax,%rbx
  a7cfe1:	0f 86 f1 02 00 00    	jbe    a7d2d8 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x3e8>
  a7cfe7:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  a7cfeb:	c1 e0 04             	shl    $0x4,%eax
  a7cfee:	49 8b 74 05 20       	mov    0x20(%r13,%rax,1),%rsi
  a7cff3:	48 85 f6             	test   %rsi,%rsi
  a7cff6:	0f 84 a8 02 00 00    	je     a7d2a4 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x3b4>
  a7cffc:	49 8b 47 08          	mov    0x8(%r15),%rax
  a7d000:	48 8d 14 49          	lea    (%rcx,%rcx,2),%rdx
  a7d004:	48 39 74 d0 f0       	cmp    %rsi,-0x10(%rax,%rdx,8)
  a7d009:	75 b5                	jne    a7cfc0 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0xd0>
  a7d00b:	48 8b 75 00          	mov    0x0(%rbp),%rsi
  a7d00f:	48 39 74 d0 e8       	cmp    %rsi,-0x18(%rax,%rdx,8)
  a7d014:	75 aa                	jne    a7cfc0 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0xd0>
  a7d016:	eb 68                	jmp    a7d080 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x190>
  a7d018:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  a7d01f:	00 
  a7d020:	41 8b 44 24 48       	mov    0x48(%r12),%eax
  a7d025:	25 ff ff 01 00       	and    $0x1ffff,%eax
  a7d02a:	48 3d ff ff 01 00    	cmp    $0x1ffff,%rax
  a7d030:	74 2e                	je     a7d060 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x170>
  a7d032:	48 39 c3             	cmp    %rax,%rbx
  a7d035:	0f 86 9d 02 00 00    	jbe    a7d2d8 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x3e8>
  a7d03b:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  a7d03f:	c1 e0 04             	shl    $0x4,%eax
  a7d042:	49 83 7c 05 20 00    	cmpq   $0x0,0x20(%r13,%rax,1)
  a7d048:	b9 00 00 00 00       	mov    $0x0,%ecx
  a7d04d:	0f 85 74 ff ff ff    	jne    a7cfc7 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0xd7>
  a7d053:	e9 4c 02 00 00       	jmp    a7d2a4 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x3b4>
  a7d058:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  a7d05f:	00 
  a7d060:	31 c0                	xor    %eax,%eax
  a7d062:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
  a7d067:	48 39 fb             	cmp    %rdi,%rbx
  a7d06a:	77 2a                	ja     a7d096 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x1a6>
  a7d06c:	e9 8a 02 00 00       	jmp    a7d2fb <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x40b>
  a7d071:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a7d078:	0f 1f 84 00 00 00 00 
  a7d07f:	00 
  a7d080:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
  a7d084:	48 8b 40 f8          	mov    -0x8(%rax),%rax
  a7d088:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
  a7d08d:	48 39 fb             	cmp    %rdi,%rbx
  a7d090:	0f 86 65 02 00 00    	jbe    a7d2fb <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x40b>
  a7d096:	4d 8b 74 24 20       	mov    0x20(%r12),%r14
  a7d09b:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  a7d0a0:	48 8b 51 10          	mov    0x10(%rcx),%rdx
  a7d0a4:	48 85 d2             	test   %rdx,%rdx
  a7d0a7:	74 67                	je     a7d110 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x220>
  a7d0a9:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  a7d0ae:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  a7d0b2:	48 83 fa 01          	cmp    $0x1,%rdx
  a7d0b6:	75 08                	jne    a7d0c0 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x1d0>
  a7d0b8:	4c 39 71 08          	cmp    %r14,0x8(%rcx)
  a7d0bc:	74 42                	je     a7d100 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x210>
  a7d0be:	eb 50                	jmp    a7d110 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x220>
  a7d0c0:	31 f6                	xor    %esi,%esi
  a7d0c2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  a7d0c9:	1f 84 00 00 00 00 00 
  a7d0d0:	48 89 f7             	mov    %rsi,%rdi
  a7d0d3:	49 89 d0             	mov    %rdx,%r8
  a7d0d6:	49 d1 e8             	shr    $1,%r8
  a7d0d9:	4c 01 c6             	add    %r8,%rsi
  a7d0dc:	4c 6b ce 38          	imul   $0x38,%rsi,%r9
  a7d0e0:	4e 39 74 09 08       	cmp    %r14,0x8(%rcx,%r9,1)
  a7d0e5:	48 0f 47 f7          	cmova  %rdi,%rsi
  a7d0e9:	4c 29 c2             	sub    %r8,%rdx
  a7d0ec:	48 83 fa 01          	cmp    $0x1,%rdx
  a7d0f0:	77 de                	ja     a7d0d0 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x1e0>
  a7d0f2:	48 6b d6 38          	imul   $0x38,%rsi,%rdx
  a7d0f6:	4c 39 74 11 08       	cmp    %r14,0x8(%rcx,%rdx,1)
  a7d0fb:	75 13                	jne    a7d110 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x220>
  a7d0fd:	48 01 d1             	add    %rdx,%rcx
  a7d100:	48 8b 49 20          	mov    0x20(%rcx),%rcx
  a7d104:	4d 01 f6             	add    %r14,%r14
  a7d107:	48 85 c9             	test   %rcx,%rcx
  a7d10a:	4c 0f 45 f1          	cmovne %rcx,%r14
  a7d10e:	eb 03                	jmp    a7d113 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x223>
  a7d110:	4d 01 f6             	add    %r14,%r14
  a7d113:	48 8b 0c 24          	mov    (%rsp),%rcx
  a7d117:	48 8b 71 10          	mov    0x10(%rcx),%rsi
  a7d11b:	48 39 f0             	cmp    %rsi,%rax
  a7d11e:	0f 83 c7 01 00 00    	jae    a7d2eb <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x3fb>
  a7d124:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  a7d128:	48 89 c2             	mov    %rax,%rdx
  a7d12b:	48 c1 e2 07          	shl    $0x7,%rdx
  a7d12f:	48 8d 04 c2          	lea    (%rdx,%rax,8),%rax
  a7d133:	48 8d 3c 01          	lea    (%rcx,%rax,1),%rdi
  a7d137:	48 83 c7 08          	add    $0x8,%rdi
  a7d13b:	31 f6                	xor    %esi,%esi
  a7d13d:	4c 89 f2             	mov    %r14,%rdx
  a7d140:	ff 15 0a 41 ab 00    	call   *0xab410a(%rip)        # 1531250 <_DYNAMIC+0x16b0>
  a7d146:	49 8b 44 24 20       	mov    0x20(%r12),%rax
  a7d14b:	48 85 c0             	test   %rax,%rax
  a7d14e:	0f 84 50 01 00 00    	je     a7d2a4 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x3b4>
  a7d154:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  a7d159:	48 3b 4d 00          	cmp    0x0(%rbp),%rcx
  a7d15d:	75 0f                	jne    a7d16e <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x27e>
  a7d15f:	48 39 44 24 30       	cmp    %rax,0x30(%rsp)
  a7d164:	75 08                	jne    a7d16e <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x27e>
  a7d166:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  a7d16b:	4c 89 30             	mov    %r14,(%rax)
  a7d16e:	48 8d 7c 24 50       	lea    0x50(%rsp),%rdi
  a7d173:	48 8b 6c 24 18       	mov    0x18(%rsp),%rbp
  a7d178:	48 89 ee             	mov    %rbp,%rsi
  a7d17b:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  a7d180:	e8 bb 27 fe ff       	call   a5f940 <gpui::native::accessibility::projected_node>
  a7d185:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  a7d18a:	48 89 ee             	mov    %rbp,%rsi
  a7d18d:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  a7d192:	48 8d 4c 24 50       	lea    0x50(%rsp),%rcx
  a7d197:	4c 8b 04 24          	mov    (%rsp),%r8
  a7d19b:	45 31 c9             	xor    %r9d,%r9d
  a7d19e:	e8 ad c5 fe ff       	call   a69750 <<gpui::native::accessibility::text::Cohort>::append>
  a7d1a3:	4d 8b 64 24 20       	mov    0x20(%r12),%r12
  a7d1a8:	4d 85 e4             	test   %r12,%r12
  a7d1ab:	0f 84 0c 01 00 00    	je     a7d2bd <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x3cd>
  a7d1b1:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  a7d1b6:	48 8b 00             	mov    (%rax),%rax
  a7d1b9:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  a7d1be:	48 8b 04 24          	mov    (%rsp),%rax
  a7d1c2:	48 8b 40 10          	mov    0x10(%rax),%rax
  a7d1c6:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  a7d1cb:	49 8b 6f 10          	mov    0x10(%r15),%rbp
  a7d1cf:	49 3b 2f             	cmp    (%r15),%rbp
  a7d1d2:	75 09                	jne    a7d1dd <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x2ed>
  a7d1d4:	4c 89 ff             	mov    %r15,%rdi
  a7d1d7:	ff 15 03 42 ab 00    	call   *0xab4203(%rip)        # 15313e0 <_DYNAMIC+0x1840>
  a7d1dd:	49 8b 47 08          	mov    0x8(%r15),%rax
  a7d1e1:	48 8d 0c 6d 00 00 00 	lea    0x0(,%rbp,2),%rcx
  a7d1e8:	00 
  a7d1e9:	48 01 e9             	add    %rbp,%rcx
  a7d1ec:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  a7d1f1:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
  a7d1f5:	4c 89 64 c8 08       	mov    %r12,0x8(%rax,%rcx,8)
  a7d1fa:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  a7d1ff:	48 89 54 c8 10       	mov    %rdx,0x10(%rax,%rcx,8)
  a7d204:	48 ff c5             	inc    %rbp
  a7d207:	49 89 6f 10          	mov    %rbp,0x10(%r15)
  a7d20b:	0f 10 84 24 c0 00 00 	movups 0xc0(%rsp),%xmm0
  a7d212:	00 
  a7d213:	48 8d 84 24 d8 00 00 	lea    0xd8(%rsp),%rax
  a7d21a:	00 
  a7d21b:	0f 11 40 70          	movups %xmm0,0x70(%rax)
  a7d21f:	0f 10 84 24 b0 00 00 	movups 0xb0(%rsp),%xmm0
  a7d226:	00 
  a7d227:	0f 11 40 60          	movups %xmm0,0x60(%rax)
  a7d22b:	0f 10 84 24 a0 00 00 	movups 0xa0(%rsp),%xmm0
  a7d232:	00 
  a7d233:	0f 11 40 50          	movups %xmm0,0x50(%rax)
  a7d237:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  a7d23e:	00 
  a7d23f:	0f 11 40 40          	movups %xmm0,0x40(%rax)
  a7d243:	0f 10 44 24 50       	movups 0x50(%rsp),%xmm0
  a7d248:	0f 10 4c 24 60       	movups 0x60(%rsp),%xmm1
  a7d24d:	0f 10 54 24 70       	movups 0x70(%rsp),%xmm2
  a7d252:	0f 10 9c 24 80 00 00 	movups 0x80(%rsp),%xmm3
  a7d259:	00 
  a7d25a:	0f 11 58 30          	movups %xmm3,0x30(%rax)
  a7d25e:	0f 11 50 20          	movups %xmm2,0x20(%rax)
  a7d262:	0f 11 48 10          	movups %xmm1,0x10(%rax)
  a7d266:	0f 11 00             	movups %xmm0,(%rax)
  a7d269:	4c 89 b4 24 d0 00 00 	mov    %r14,0xd0(%rsp)
  a7d270:	00 
  a7d271:	4c 8b 24 24          	mov    (%rsp),%r12
  a7d275:	4d 8b 74 24 10       	mov    0x10(%r12),%r14
  a7d27a:	4d 3b 34 24          	cmp    (%r12),%r14
  a7d27e:	0f 85 dc fc ff ff    	jne    a7cf60 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x70>
  a7d284:	4c 89 e7             	mov    %r12,%rdi
  a7d287:	ff 15 cb 3f ab 00    	call   *0xab3fcb(%rip)        # 1531258 <_DYNAMIC+0x16b8>
  a7d28d:	e9 ce fc ff ff       	jmp    a7cf60 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x70>
  a7d292:	48 81 c4 58 01 00 00 	add    $0x158,%rsp
  a7d299:	5b                   	pop    %rbx
  a7d29a:	41 5c                	pop    %r12
  a7d29c:	41 5d                	pop    %r13
  a7d29e:	41 5e                	pop    %r14
  a7d2a0:	41 5f                	pop    %r15
  a7d2a2:	5d                   	pop    %rbp
  a7d2a3:	c3                   	ret
  a7d2a4:	48 8d 3d 35 d3 70 ff 	lea    -0x8f2ccb(%rip),%rdi        # 18a5e0 <anon.f29bd53783d54abf9c05f2e13d9a3fb7.57.llvm.11816638417077940530>
  a7d2ab:	48 8d 15 de 5b a4 00 	lea    0xa45bde(%rip),%rdx        # 14c2e90 <anon.f29bd53783d54abf9c05f2e13d9a3fb7.58.llvm.11816638417077940530>
  a7d2b2:	be 20 00 00 00       	mov    $0x20,%esi
  a7d2b7:	ff 15 5b 2c ab 00    	call   *0xab2c5b(%rip)        # 152ff18 <_DYNAMIC+0x378>
  a7d2bd:	48 8d 3d 1c d3 70 ff 	lea    -0x8f2ce4(%rip),%rdi        # 18a5e0 <anon.f29bd53783d54abf9c05f2e13d9a3fb7.57.llvm.11816638417077940530>
  a7d2c4:	48 8d 15 c5 5b a4 00 	lea    0xa45bc5(%rip),%rdx        # 14c2e90 <anon.f29bd53783d54abf9c05f2e13d9a3fb7.58.llvm.11816638417077940530>
  a7d2cb:	be 20 00 00 00       	mov    $0x20,%esi
  a7d2d0:	ff 15 42 2c ab 00    	call   *0xab2c42(%rip)        # 152ff18 <_DYNAMIC+0x378>
  a7d2d6:	0f 0b                	ud2
  a7d2d8:	48 8d 15 c9 5b a4 00 	lea    0xa45bc9(%rip),%rdx        # 14c2ea8 <anon.f29bd53783d54abf9c05f2e13d9a3fb7.58.llvm.11816638417077940530+0x18>
  a7d2df:	48 89 c7             	mov    %rax,%rdi
  a7d2e2:	48 89 de             	mov    %rbx,%rsi
  a7d2e5:	ff 15 65 2b ab 00    	call   *0xab2b65(%rip)        # 152fe50 <_DYNAMIC+0x2b0>
  a7d2eb:	48 8d 15 36 5b a4 00 	lea    0xa45b36(%rip),%rdx        # 14c2e28 <anon.f29bd53783d54abf9c05f2e13d9a3fb7.24.llvm.11816638417077940530+0x18>
  a7d2f2:	48 89 c7             	mov    %rax,%rdi
  a7d2f5:	ff 15 55 2b ab 00    	call   *0xab2b55(%rip)        # 152fe50 <_DYNAMIC+0x2b0>
  a7d2fb:	48 8d 15 e6 4b a4 00 	lea    0xa44be6(%rip),%rdx        # 14c1ee8 <anon.fc2f92b0223d15b7043d040ea72c4e93.10.llvm.5483804487471879235>
  a7d302:	48 89 de             	mov    %rbx,%rsi
  a7d305:	ff 15 45 2b ab 00    	call   *0xab2b45(%rip)        # 152fe50 <_DYNAMIC+0x2b0>
  a7d30b:	48 89 c3             	mov    %rax,%rbx
  a7d30e:	48 8d bc 24 d0 00 00 	lea    0xd0(%rsp),%rdi
  a7d315:	00 
  a7d316:	e8 55 04 00 00       	call   a7d770 <core::ptr::drop_glue::<(accesskit::NodeId, accesskit::Node)>>
  a7d31b:	eb 15                	jmp    a7d332 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x442>
  a7d31d:	ff 15 05 2b ab 00    	call   *0xab2b05(%rip)        # 152fe28 <_DYNAMIC+0x288>
  a7d323:	eb 00                	jmp    a7d325 <<gpui::runtime::query::SemanticSheet>::visit::<gpui::native::accessibility::project::{closure#1}>+0x435>
  a7d325:	48 89 c3             	mov    %rax,%rbx
  a7d328:	48 8d 7c 24 50       	lea    0x50(%rsp),%rdi
  a7d32d:	e8 9e 02 00 00       	call   a7d5d0 <core::ptr::drop_glue::<accesskit::Node>>
  a7d332:	48 89 df             	mov    %rbx,%rdi
  a7d335:	e8 36 d3 a3 00       	call   14ba670 <_Unwind_Resume@plt>
  a7d33a:	ff 15 e8 2a ab 00    	call   *0xab2ae8(%rip)        # 152fe28 <_DYNAMIC+0x288>
