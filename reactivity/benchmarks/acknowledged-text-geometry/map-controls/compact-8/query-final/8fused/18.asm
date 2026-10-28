
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000067d940 <<gpui_canvas::text::layout::TextGeometry>::caret_stop>:
  67d940:	53                   	push   %rbx
  67d941:	48 83 ec 70          	sub    $0x70,%rsp
  67d945:	48 89 fb             	mov    %rdi,%rbx
  67d948:	89 54 24 08          	mov    %edx,0x8(%rsp)
  67d94c:	88 4c 24 0c          	mov    %cl,0xc(%rsp)
  67d950:	48 8b 06             	mov    (%rsi),%rax
  67d953:	48 85 c0             	test   %rax,%rax
  67d956:	74 11                	je     67d969 <<gpui_canvas::text::layout::TextGeometry>::caret_stop+0x29>
  67d958:	83 f8 02             	cmp    $0x2,%eax
  67d95b:	75 5d                	jne    67d9ba <<gpui_canvas::text::layout::TextGeometry>::caret_stop+0x7a>
  67d95d:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  67d963:	48 83 c4 70          	add    $0x70,%rsp
  67d967:	5b                   	pop    %rbx
  67d968:	c3                   	ret
  67d969:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
  67d96d:	48 8b 46 10          	mov    0x10(%rsi),%rax
  67d971:	fe c1                	inc    %cl
  67d973:	88 4c 24 07          	mov    %cl,0x7(%rsp)
  67d977:	48 89 c1             	mov    %rax,%rcx
  67d97a:	48 85 c0             	test   %rax,%rax
  67d97d:	74 33                	je     67d9b2 <<gpui_canvas::text::layout::TextGeometry>::caret_stop+0x72>
  67d97f:	31 c9                	xor    %ecx,%ecx
  67d981:	48 83 f8 01          	cmp    $0x1,%rax
  67d985:	74 24                	je     67d9ab <<gpui_canvas::text::layout::TextGeometry>::caret_stop+0x6b>
  67d987:	48 89 c6             	mov    %rax,%rsi
  67d98a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  67d990:	49 89 f0             	mov    %rsi,%r8
  67d993:	49 d1 e8             	shr    $1,%r8
  67d996:	4d 8d 0c 08          	lea    (%r8,%rcx,1),%r9
  67d99a:	42 39 14 cf          	cmp    %edx,(%rdi,%r9,8)
  67d99e:	49 0f 42 c9          	cmovb  %r9,%rcx
  67d9a2:	4c 29 c6             	sub    %r8,%rsi
  67d9a5:	48 83 fe 01          	cmp    $0x1,%rsi
  67d9a9:	77 e5                	ja     67d990 <<gpui_canvas::text::layout::TextGeometry>::caret_stop+0x50>
  67d9ab:	39 14 cf             	cmp    %edx,(%rdi,%rcx,8)
  67d9ae:	48 83 d1 00          	adc    $0x0,%rcx
  67d9b2:	48 8d 14 cf          	lea    (%rdi,%rcx,8),%rdx
  67d9b6:	31 f6                	xor    %esi,%esi
  67d9b8:	eb 5d                	jmp    67da17 <<gpui_canvas::text::layout::TextGeometry>::caret_stop+0xd7>
  67d9ba:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
  67d9be:	48 8b 46 10          	mov    0x10(%rsi),%rax
  67d9c2:	fe c1                	inc    %cl
  67d9c4:	88 4c 24 07          	mov    %cl,0x7(%rsp)
  67d9c8:	48 89 c1             	mov    %rax,%rcx
  67d9cb:	48 85 c0             	test   %rax,%rax
  67d9ce:	74 3a                	je     67da0a <<gpui_canvas::text::layout::TextGeometry>::caret_stop+0xca>
  67d9d0:	31 c9                	xor    %ecx,%ecx
  67d9d2:	48 83 f8 01          	cmp    $0x1,%rax
  67d9d6:	74 27                	je     67d9ff <<gpui_canvas::text::layout::TextGeometry>::caret_stop+0xbf>
  67d9d8:	48 89 c6             	mov    %rax,%rsi
  67d9db:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  67d9e0:	49 89 f0             	mov    %rsi,%r8
  67d9e3:	49 d1 e8             	shr    $1,%r8
  67d9e6:	4d 8d 0c 08          	lea    (%r8,%rcx,1),%r9
  67d9ea:	4f 8d 14 49          	lea    (%r9,%r9,2),%r10
  67d9ee:	42 39 14 97          	cmp    %edx,(%rdi,%r10,4)
  67d9f2:	49 0f 42 c9          	cmovb  %r9,%rcx
  67d9f6:	4c 29 c6             	sub    %r8,%rsi
  67d9f9:	48 83 fe 01          	cmp    $0x1,%rsi
  67d9fd:	77 e1                	ja     67d9e0 <<gpui_canvas::text::layout::TextGeometry>::caret_stop+0xa0>
  67d9ff:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  67da03:	39 14 b7             	cmp    %edx,(%rdi,%rsi,4)
  67da06:	48 83 d1 00          	adc    $0x0,%rcx
  67da0a:	48 8d 14 49          	lea    (%rcx,%rcx,2),%rdx
  67da0e:	48 8d 14 97          	lea    (%rdi,%rdx,4),%rdx
  67da12:	be 01 00 00 00       	mov    $0x1,%esi
  67da17:	48 29 c8             	sub    %rcx,%rax
  67da1a:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
  67da1f:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
  67da24:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  67da29:	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
  67da30:	00 00 
  67da32:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  67da37:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  67da3c:	c6 44 24 68 00       	movb   $0x0,0x68(%rsp)
  67da41:	48 8d 4c 24 60       	lea    0x60(%rsp),%rcx
  67da46:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  67da4b:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  67da50:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  67da55:	48 8d 4c 24 07       	lea    0x7(%rsp),%rcx
  67da5a:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  67da5f:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  67da64:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  67da69:	48 8d 74 24 38       	lea    0x38(%rsp),%rsi
  67da6e:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  67da73:	e8 b8 e6 fe ff       	call   66c130 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_stop::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>>
  67da78:	8b 4c 24 28          	mov    0x28(%rsp),%ecx
  67da7c:	83 f9 02             	cmp    $0x2,%ecx
  67da7f:	75 0a                	jne    67da8b <<gpui_canvas::text::layout::TextGeometry>::caret_stop+0x14b>
  67da81:	31 c0                	xor    %eax,%eax
  67da83:	89 03                	mov    %eax,(%rbx)
  67da85:	48 83 c4 70          	add    $0x70,%rsp
  67da89:	5b                   	pop    %rbx
  67da8a:	c3                   	ret
  67da8b:	8b 44 24 34          	mov    0x34(%rsp),%eax
  67da8f:	89 44 24 18          	mov    %eax,0x18(%rsp)
  67da93:	48 8b 44 24 2c       	mov    0x2c(%rsp),%rax
  67da98:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  67da9d:	31 c0                	xor    %eax,%eax
  67da9f:	83 f9 01             	cmp    $0x1,%ecx
  67daa2:	75 15                	jne    67dab9 <<gpui_canvas::text::layout::TextGeometry>::caret_stop+0x179>
  67daa4:	8b 44 24 18          	mov    0x18(%rsp),%eax
  67daa8:	89 43 0c             	mov    %eax,0xc(%rbx)
  67daab:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  67dab0:	48 89 43 04          	mov    %rax,0x4(%rbx)
  67dab4:	b8 01 00 00 00       	mov    $0x1,%eax
  67dab9:	89 03                	mov    %eax,(%rbx)
  67dabb:	48 83 c4 70          	add    $0x70,%rsp
  67dabf:	5b                   	pop    %rbx
  67dac0:	c3                   	ret
