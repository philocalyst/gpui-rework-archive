
/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000660c80 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut>:
  660c80:	55                   	push   %rbp
  660c81:	41 57                	push   %r15
  660c83:	41 56                	push   %r14
  660c85:	41 55                	push   %r13
  660c87:	41 54                	push   %r12
  660c89:	53                   	push   %rbx
  660c8a:	48 83 ec 38          	sub    $0x38,%rsp
  660c8e:	48 8b 0a             	mov    (%rdx),%rcx
  660c91:	4c 8b 42 08          	mov    0x8(%rdx),%r8
  660c95:	48 8b 6a 10          	mov    0x10(%rdx),%rbp
  660c99:	48 8b 42 18          	mov    0x18(%rdx),%rax
  660c9d:	48 8b 16             	mov    (%rsi),%rdx
  660ca0:	4c 8b 3a             	mov    (%rdx),%r15
  660ca3:	f3 0f 10 42 08       	movss  0x8(%rdx),%xmm0
  660ca8:	48 83 c1 f4          	add    $0xfffffffffffffff4,%rcx
  660cac:	49 c1 e0 02          	shl    $0x2,%r8
  660cb0:	4b 8d 14 40          	lea    (%r8,%r8,2),%rdx
  660cb4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  660cbb:	00 00 00 00 00 
  660cc0:	48 85 d2             	test   %rdx,%rdx
  660cc3:	0f 84 be 00 00 00    	je     660d87 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x107>
  660cc9:	4c 8d 71 0c          	lea    0xc(%rcx),%r14
  660ccd:	48 83 c2 f4          	add    $0xfffffffffffffff4,%rdx
  660cd1:	f6 41 14 02          	testb  $0x2,0x14(%rcx)
  660cd5:	4c 89 f1             	mov    %r14,%rcx
  660cd8:	74 e6                	je     660cc0 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x40>
  660cda:	48 c1 e0 02          	shl    $0x2,%rax
  660cde:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  660ce2:	31 c9                	xor    %ecx,%ecx
  660ce4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  660ceb:	00 00 00 00 00 
  660cf0:	48 39 c8             	cmp    %rcx,%rax
  660cf3:	0f 84 8e 00 00 00    	je     660d87 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x107>
  660cf9:	4c 8d 61 0c          	lea    0xc(%rcx),%r12
  660cfd:	f6 44 0d 08 01       	testb  $0x1,0x8(%rbp,%rcx,1)
  660d02:	4c 89 e1             	mov    %r12,%rcx
  660d05:	74 e9                	je     660cf0 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x70>
  660d07:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  660d0c:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  660d11:	41 8b 36             	mov    (%r14),%esi
  660d14:	4c 89 ff             	mov    %r15,%rdi
  660d17:	89 74 24 04          	mov    %esi,0x4(%rsp)
  660d1b:	ba 01 00 00 00       	mov    $0x1,%edx
  660d20:	ff 15 1a 69 12 00    	call   *0x12691a(%rip)        # 787640 <_DYNAMIC+0x390>
  660d26:	48 89 c3             	mov    %rax,%rbx
  660d29:	49 8b 77 28          	mov    0x28(%r15),%rsi
  660d2d:	48 39 f0             	cmp    %rsi,%rax
  660d30:	0f 83 a7 01 00 00    	jae    660edd <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x25d>
  660d36:	46 8b 6c 25 f4       	mov    -0xc(%rbp,%r12,1),%r13d
  660d3b:	49 8b 47 20          	mov    0x20(%r15),%rax
  660d3f:	48 8d 0c 5b          	lea    (%rbx,%rbx,2),%rcx
  660d43:	8b 44 c8 04          	mov    0x4(%rax,%rcx,8),%eax
  660d47:	89 04 24             	mov    %eax,(%rsp)
  660d4a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  660d4f:	4c 89 fe             	mov    %r15,%rsi
  660d52:	4c 89 f2             	mov    %r14,%rdx
  660d55:	ff 15 ed 68 12 00    	call   *0x1268ed(%rip)        # 787648 <_DYNAMIC+0x398>
  660d5b:	f3 41 0f 10 46 04    	movss  0x4(%r14),%xmm0
  660d61:	f3 42 0f 10 4c 25 f8 	movss  -0x8(%rbp,%r12,1),%xmm1
  660d68:	8b 2c 24             	mov    (%rsp),%ebp
  660d6b:	41 39 ed             	cmp    %ebp,%r13d
  660d6e:	77 20                	ja     660d90 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x110>
  660d70:	0f 2e c1             	ucomiss %xmm1,%xmm0
  660d73:	75 02                	jne    660d77 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0xf7>
  660d75:	7b 19                	jnp    660d90 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x110>
  660d77:	0f 2e c8             	ucomiss %xmm0,%xmm1
  660d7a:	0f 96 c0             	setbe  %al
  660d7d:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  660d82:	e9 b7 00 00 00       	jmp    660e3e <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1be>
  660d87:	c6 47 04 02          	movb   $0x2,0x4(%rdi)
  660d8b:	e9 3b 01 00 00       	jmp    660ecb <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x24b>
  660d90:	49 8b 47 08          	mov    0x8(%r15),%rax
  660d94:	49 8b 4f 10          	mov    0x10(%r15),%rcx
  660d98:	48 89 ca             	mov    %rcx,%rdx
  660d9b:	48 85 c9             	test   %rcx,%rcx
  660d9e:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  660da3:	0f 28 6c 24 20       	movaps 0x20(%rsp),%xmm5
  660da8:	74 48                	je     660df2 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x172>
  660daa:	31 d2                	xor    %edx,%edx
  660dac:	48 83 f9 01          	cmp    $0x1,%rcx
  660db0:	74 31                	je     660de3 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x163>
  660db2:	48 89 ce             	mov    %rcx,%rsi
  660db5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  660dbc:	00 00 00 00 
  660dc0:	49 89 f0             	mov    %rsi,%r8
  660dc3:	49 d1 e8             	shr    $1,%r8
  660dc6:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
  660dca:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  660dce:	46 8b 54 d0 10       	mov    0x10(%rax,%r10,8),%r10d
  660dd3:	4c 39 d3             	cmp    %r10,%rbx
  660dd6:	49 0f 47 d1          	cmova  %r9,%rdx
  660dda:	4c 29 c6             	sub    %r8,%rsi
  660ddd:	48 83 fe 01          	cmp    $0x1,%rsi
  660de1:	77 dd                	ja     660dc0 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x140>
  660de3:	48 8d 34 52          	lea    (%rdx,%rdx,2),%rsi
  660de7:	8b 74 f0 10          	mov    0x10(%rax,%rsi,8),%esi
  660deb:	48 39 de             	cmp    %rbx,%rsi
  660dee:	48 83 d2 00          	adc    $0x0,%rdx
  660df2:	48 c1 e2 03          	shl    $0x3,%rdx
  660df6:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
  660dfa:	4c 8d 04 10          	lea    (%rax,%rdx,1),%r8
  660dfe:	41 8b 36             	mov    (%r14),%esi
  660e01:	48 c1 e1 03          	shl    $0x3,%rcx
  660e05:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  660e09:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  660e10:	48 39 d1             	cmp    %rdx,%rcx
  660e13:	74 5a                	je     660e6f <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1ef>
  660e15:	4d 89 c1             	mov    %r8,%r9
  660e18:	45 8b 40 10          	mov    0x10(%r8),%r8d
  660e1c:	4c 39 c3             	cmp    %r8,%rbx
  660e1f:	75 4e                	jne    660e6f <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1ef>
  660e21:	4d 8d 41 18          	lea    0x18(%r9),%r8
  660e25:	48 83 c2 18          	add    $0x18,%rdx
  660e29:	41 39 31             	cmp    %esi,(%r9)
  660e2c:	77 e2                	ja     660e10 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x190>
  660e2e:	41 3b 71 04          	cmp    0x4(%r9),%esi
  660e32:	77 dc                	ja     660e10 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x190>
  660e34:	0f b6 44 10 fd       	movzbl -0x3(%rax,%rdx,1),%eax
  660e39:	41 39 ed             	cmp    %ebp,%r13d
  660e3c:	77 38                	ja     660e76 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1f6>
  660e3e:	0f 28 d8             	movaps %xmm0,%xmm3
  660e41:	f3 0f 5d d9          	minss  %xmm1,%xmm3
  660e45:	0f 28 d3             	movaps %xmm3,%xmm2
  660e48:	f3 0f c2 d3 03       	cmpunordss %xmm3,%xmm2
  660e4d:	0f 28 e2             	movaps %xmm2,%xmm4
  660e50:	0f 55 e3             	andnps %xmm3,%xmm4
  660e53:	0f 54 d0             	andps  %xmm0,%xmm2
  660e56:	0f 56 d4             	orps   %xmm4,%xmm2
  660e59:	f3 0f 10 5c 24 14    	movss  0x14(%rsp),%xmm3
  660e5f:	0f 28 e9             	movaps %xmm1,%xmm5
  660e62:	f3 0f 5c e8          	subss  %xmm0,%xmm5
  660e66:	0f 54 2d 23 43 9c ff 	andps  -0x63bcdd(%rip),%xmm5        # 25190 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x7e0>
  660e6d:	eb 18                	jmp    660e87 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x207>
  660e6f:	31 c0                	xor    %eax,%eax
  660e71:	41 39 ed             	cmp    %ebp,%r13d
  660e74:	76 c8                	jbe    660e3e <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1be>
  660e76:	0f 28 d0             	movaps %xmm0,%xmm2
  660e79:	84 c0                	test   %al,%al
  660e7b:	74 04                	je     660e81 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x201>
  660e7d:	f3 0f 5c d5          	subss  %xmm5,%xmm2
  660e81:	f3 0f 10 5c 24 14    	movss  0x14(%rsp),%xmm3
  660e87:	41 39 ed             	cmp    %ebp,%r13d
  660e8a:	f3 0f 10 64 24 1c    	movss  0x1c(%rsp),%xmm4
  660e90:	8b 4c 24 04          	mov    0x4(%rsp),%ecx
  660e94:	89 0f                	mov    %ecx,(%rdi)
  660e96:	c6 47 04 01          	movb   $0x1,0x4(%rdi)
  660e9a:	44 89 6f 08          	mov    %r13d,0x8(%rdi)
  660e9e:	c6 47 0c 00          	movb   $0x0,0xc(%rdi)
  660ea2:	f3 0f 11 57 10       	movss  %xmm2,0x10(%rdi)
  660ea7:	f3 0f 11 5f 14       	movss  %xmm3,0x14(%rdi)
  660eac:	f3 0f 11 6f 18       	movss  %xmm5,0x18(%rdi)
  660eb1:	f3 0f 11 67 1c       	movss  %xmm4,0x1c(%rdi)
  660eb6:	48 89 5f 20          	mov    %rbx,0x20(%rdi)
  660eba:	f3 0f 11 47 28       	movss  %xmm0,0x28(%rdi)
  660ebf:	f3 0f 11 4f 2c       	movss  %xmm1,0x2c(%rdi)
  660ec4:	0f 97 47 30          	seta   0x30(%rdi)
  660ec8:	88 47 31             	mov    %al,0x31(%rdi)
  660ecb:	48 89 f8             	mov    %rdi,%rax
  660ece:	48 83 c4 38          	add    $0x38,%rsp
  660ed2:	5b                   	pop    %rbx
  660ed3:	41 5c                	pop    %r12
  660ed5:	41 5d                	pop    %r13
  660ed7:	41 5e                	pop    %r14
  660ed9:	41 5f                	pop    %r15
  660edb:	5d                   	pop    %rbp
  660edc:	c3                   	ret
  660edd:	48 8d 15 5c b9 11 00 	lea    0x11b95c(%rip),%rdx        # 77c840 <anon.131d754ff6fdc2dfddc852c3e2010d7b.4.llvm.17478163706573382256+0x30>
  660ee4:	48 89 df             	mov    %rbx,%rdi
  660ee7:	ff 15 63 67 12 00    	call   *0x126763(%rip)        # 787650 <_DYNAMIC+0x3a0>
