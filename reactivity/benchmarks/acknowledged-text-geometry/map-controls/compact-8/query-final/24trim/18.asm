
/tmp/gpui-text-map-query-final/24trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000660b80 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut>:
  660b80:	55                   	push   %rbp
  660b81:	41 57                	push   %r15
  660b83:	41 56                	push   %r14
  660b85:	41 55                	push   %r13
  660b87:	41 54                	push   %r12
  660b89:	53                   	push   %rbx
  660b8a:	48 83 ec 28          	sub    $0x28,%rsp
  660b8e:	4c 8b 3a             	mov    (%rdx),%r15
  660b91:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  660b95:	4c 8b 6a 10          	mov    0x10(%rdx),%r13
  660b99:	48 8b 42 18          	mov    0x18(%rdx),%rax
  660b9d:	48 8b 16             	mov    (%rsi),%rdx
  660ba0:	4c 8b 32             	mov    (%rdx),%r14
  660ba3:	f3 0f 10 42 08       	movss  0x8(%rdx),%xmm0
  660ba8:	48 c1 e1 03          	shl    $0x3,%rcx
  660bac:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  660bb0:	31 d2                	xor    %edx,%edx
  660bb2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  660bb9:	1f 84 00 00 00 00 00 
  660bc0:	48 39 d1             	cmp    %rdx,%rcx
  660bc3:	0f 84 a0 00 00 00    	je     660c69 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0xe9>
  660bc9:	4c 8d 62 18          	lea    0x18(%rdx),%r12
  660bcd:	41 f6 44 17 14 02    	testb  $0x2,0x14(%r15,%rdx,1)
  660bd3:	4c 89 e2             	mov    %r12,%rdx
  660bd6:	74 e8                	je     660bc0 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x40>
  660bd8:	48 c1 e0 03          	shl    $0x3,%rax
  660bdc:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  660be0:	31 c9                	xor    %ecx,%ecx
  660be2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  660be9:	1f 84 00 00 00 00 00 
  660bf0:	48 39 c8             	cmp    %rcx,%rax
  660bf3:	74 74                	je     660c69 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0xe9>
  660bf5:	48 8d 59 18          	lea    0x18(%rcx),%rbx
  660bf9:	41 f6 44 0d 14 01    	testb  $0x1,0x14(%r13,%rcx,1)
  660bff:	48 89 d9             	mov    %rbx,%rcx
  660c02:	74 ec                	je     660bf0 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x70>
  660c04:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  660c09:	48 89 fd             	mov    %rdi,%rbp
  660c0c:	43 8b 74 27 f8       	mov    -0x8(%r15,%r12,1),%esi
  660c11:	4c 89 f7             	mov    %r14,%rdi
  660c14:	89 74 24 0c          	mov    %esi,0xc(%rsp)
  660c18:	ba 01 00 00 00       	mov    $0x1,%edx
  660c1d:	ff 15 f5 67 12 00    	call   *0x1267f5(%rip)        # 787418 <_DYNAMIC+0x390>
  660c23:	49 8b 76 28          	mov    0x28(%r14),%rsi
  660c27:	48 39 f0             	cmp    %rsi,%rax
  660c2a:	0f 83 98 01 00 00    	jae    660dc8 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x248>
  660c30:	41 8b 4c 1d f8       	mov    -0x8(%r13,%rbx,1),%ecx
  660c35:	49 8b 56 20          	mov    0x20(%r14),%rdx
  660c39:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  660c3d:	8b 54 f2 04          	mov    0x4(%rdx,%rsi,8),%edx
  660c41:	f3 43 0f 10 44 27 e8 	movss  -0x18(%r15,%r12,1),%xmm0
  660c48:	f3 41 0f 10 4c 1d e8 	movss  -0x18(%r13,%rbx,1),%xmm1
  660c4f:	39 d1                	cmp    %edx,%ecx
  660c51:	77 1f                	ja     660c72 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0xf2>
  660c53:	0f 2e c1             	ucomiss %xmm1,%xmm0
  660c56:	75 02                	jne    660c5a <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0xda>
  660c58:	7b 18                	jnp    660c72 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0xf2>
  660c5a:	0f 2e c8             	ucomiss %xmm0,%xmm1
  660c5d:	40 0f 96 c6          	setbe  %sil
  660c61:	48 89 ef             	mov    %rbp,%rdi
  660c64:	e9 c1 00 00 00       	jmp    660d2a <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1aa>
  660c69:	c6 47 04 02          	movb   $0x2,0x4(%rdi)
  660c6d:	e9 2c 01 00 00       	jmp    660d9e <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x21e>
  660c72:	49 8b 76 08          	mov    0x8(%r14),%rsi
  660c76:	4d 8b 46 10          	mov    0x10(%r14),%r8
  660c7a:	4d 89 c1             	mov    %r8,%r9
  660c7d:	4d 85 c0             	test   %r8,%r8
  660c80:	48 89 ef             	mov    %rbp,%rdi
  660c83:	0f 28 6c 24 10       	movaps 0x10(%rsp),%xmm5
  660c88:	74 49                	je     660cd3 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x153>
  660c8a:	45 31 c9             	xor    %r9d,%r9d
  660c8d:	49 83 f8 01          	cmp    $0x1,%r8
  660c91:	74 30                	je     660cc3 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x143>
  660c93:	4d 89 c2             	mov    %r8,%r10
  660c96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  660c9d:	00 00 00 
  660ca0:	4d 89 d3             	mov    %r10,%r11
  660ca3:	49 d1 eb             	shr    $1,%r11
  660ca6:	4b 8d 1c 0b          	lea    (%r11,%r9,1),%rbx
  660caa:	4c 8d 34 5b          	lea    (%rbx,%rbx,2),%r14
  660cae:	46 8b 74 f6 10       	mov    0x10(%rsi,%r14,8),%r14d
  660cb3:	4c 39 f0             	cmp    %r14,%rax
  660cb6:	4c 0f 47 cb          	cmova  %rbx,%r9
  660cba:	4d 29 da             	sub    %r11,%r10
  660cbd:	49 83 fa 01          	cmp    $0x1,%r10
  660cc1:	77 dd                	ja     660ca0 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x120>
  660cc3:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  660cc7:	46 8b 54 d6 10       	mov    0x10(%rsi,%r10,8),%r10d
  660ccc:	49 39 c2             	cmp    %rax,%r10
  660ccf:	49 83 d1 00          	adc    $0x0,%r9
  660cd3:	49 c1 e1 03          	shl    $0x3,%r9
  660cd7:	4f 8d 0c 49          	lea    (%r9,%r9,2),%r9
  660cdb:	4e 8d 1c 0e          	lea    (%rsi,%r9,1),%r11
  660cdf:	47 8b 54 27 f8       	mov    -0x8(%r15,%r12,1),%r10d
  660ce4:	49 c1 e0 03          	shl    $0x3,%r8
  660ce8:	4f 8d 04 40          	lea    (%r8,%r8,2),%r8
  660cec:	0f 1f 40 00          	nopl   0x0(%rax)
  660cf0:	4d 39 c8             	cmp    %r9,%r8
  660cf3:	0f 84 b7 00 00 00    	je     660db0 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x230>
  660cf9:	4c 89 db             	mov    %r11,%rbx
  660cfc:	45 8b 5b 10          	mov    0x10(%r11),%r11d
  660d00:	4c 39 d8             	cmp    %r11,%rax
  660d03:	0f 85 a7 00 00 00    	jne    660db0 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x230>
  660d09:	4c 8d 5b 18          	lea    0x18(%rbx),%r11
  660d0d:	49 83 c1 18          	add    $0x18,%r9
  660d11:	44 39 13             	cmp    %r10d,(%rbx)
  660d14:	77 da                	ja     660cf0 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x170>
  660d16:	44 3b 53 04          	cmp    0x4(%rbx),%r10d
  660d1a:	77 d4                	ja     660cf0 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x170>
  660d1c:	42 0f b6 74 0e fd    	movzbl -0x3(%rsi,%r9,1),%esi
  660d22:	39 d1                	cmp    %edx,%ecx
  660d24:	0f 87 90 00 00 00    	ja     660dba <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x23a>
  660d2a:	0f 28 d8             	movaps %xmm0,%xmm3
  660d2d:	f3 0f 5d d9          	minss  %xmm1,%xmm3
  660d31:	0f 28 d3             	movaps %xmm3,%xmm2
  660d34:	f3 0f c2 d3 03       	cmpunordss %xmm3,%xmm2
  660d39:	0f 28 e2             	movaps %xmm2,%xmm4
  660d3c:	0f 55 e3             	andnps %xmm3,%xmm4
  660d3f:	0f 54 d0             	andps  %xmm0,%xmm2
  660d42:	0f 56 d4             	orps   %xmm4,%xmm2
  660d45:	0f 28 e9             	movaps %xmm1,%xmm5
  660d48:	f3 0f 5c e8          	subss  %xmm0,%xmm5
  660d4c:	0f 54 2d 0d 44 9c ff 	andps  -0x63bbf3(%rip),%xmm5        # 25160 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x7e0>
  660d53:	39 d1                	cmp    %edx,%ecx
  660d55:	f3 43 0f 10 5c 27 ec 	movss  -0x14(%r15,%r12,1),%xmm3
  660d5c:	f3 43 0f 10 64 27 f4 	movss  -0xc(%r15,%r12,1),%xmm4
  660d63:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  660d67:	89 17                	mov    %edx,(%rdi)
  660d69:	c6 47 04 01          	movb   $0x1,0x4(%rdi)
  660d6d:	89 4f 08             	mov    %ecx,0x8(%rdi)
  660d70:	c6 47 0c 00          	movb   $0x0,0xc(%rdi)
  660d74:	f3 0f 11 57 10       	movss  %xmm2,0x10(%rdi)
  660d79:	f3 0f 11 5f 14       	movss  %xmm3,0x14(%rdi)
  660d7e:	f3 0f 11 6f 18       	movss  %xmm5,0x18(%rdi)
  660d83:	f3 0f 11 67 1c       	movss  %xmm4,0x1c(%rdi)
  660d88:	48 89 47 20          	mov    %rax,0x20(%rdi)
  660d8c:	f3 0f 11 47 28       	movss  %xmm0,0x28(%rdi)
  660d91:	f3 0f 11 4f 2c       	movss  %xmm1,0x2c(%rdi)
  660d96:	0f 97 47 30          	seta   0x30(%rdi)
  660d9a:	40 88 77 31          	mov    %sil,0x31(%rdi)
  660d9e:	48 89 f8             	mov    %rdi,%rax
  660da1:	48 83 c4 28          	add    $0x28,%rsp
  660da5:	5b                   	pop    %rbx
  660da6:	41 5c                	pop    %r12
  660da8:	41 5d                	pop    %r13
  660daa:	41 5e                	pop    %r14
  660dac:	41 5f                	pop    %r15
  660dae:	5d                   	pop    %rbp
  660daf:	c3                   	ret
  660db0:	31 f6                	xor    %esi,%esi
  660db2:	39 d1                	cmp    %edx,%ecx
  660db4:	0f 86 70 ff ff ff    	jbe    660d2a <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1aa>
  660dba:	0f 28 d0             	movaps %xmm0,%xmm2
  660dbd:	40 84 f6             	test   %sil,%sil
  660dc0:	74 91                	je     660d53 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1d3>
  660dc2:	f3 0f 5c d5          	subss  %xmm5,%xmm2
  660dc6:	eb 8b                	jmp    660d53 <<&mut <gpui_canvas::text::layout::TextGeometry>::intervals::{closure#1} as core::ops::function::FnMut<((&[gpui_canvas::text::layout::Stop], &[gpui_canvas::text::layout::Stop]),)>>::call_mut+0x1d3>
  660dc8:	48 8d 15 61 b8 11 00 	lea    0x11b861(%rip),%rdx        # 77c630 <anon.131d754ff6fdc2dfddc852c3e2010d7b.4.llvm.8511590685880311727+0x30>
  660dcf:	48 89 c7             	mov    %rax,%rdi
  660dd2:	ff 15 48 66 12 00    	call   *0x126648(%rip)        # 787420 <_DYNAMIC+0x398>
