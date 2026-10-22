
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000683f20 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds>:
  683f20:	41 56                	push   %r14
  683f22:	53                   	push   %rbx
  683f23:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  683f2a:	48 89 fb             	mov    %rdi,%rbx
  683f2d:	89 54 24 10          	mov    %edx,0x10(%rsp)
  683f31:	88 4c 24 14          	mov    %cl,0x14(%rsp)
  683f35:	48 8b 06             	mov    (%rsi),%rax
  683f38:	48 85 c0             	test   %rax,%rax
  683f3b:	74 10                	je     683f4d <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x2d>
  683f3d:	83 f8 02             	cmp    $0x2,%eax
  683f40:	75 5b                	jne    683f9d <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x7d>
  683f42:	c7 03 00 00 00 00    	movl   $0x0,(%rbx)
  683f48:	e9 64 01 00 00       	jmp    6840b1 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x191>
  683f4d:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
  683f51:	48 8b 46 10          	mov    0x10(%rsi),%rax
  683f55:	fe c1                	inc    %cl
  683f57:	88 4c 24 0f          	mov    %cl,0xf(%rsp)
  683f5b:	48 89 c1             	mov    %rax,%rcx
  683f5e:	48 85 c0             	test   %rax,%rax
  683f61:	74 2f                	je     683f92 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x72>
  683f63:	31 c9                	xor    %ecx,%ecx
  683f65:	48 83 f8 01          	cmp    $0x1,%rax
  683f69:	74 20                	je     683f8b <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x6b>
  683f6b:	49 89 c0             	mov    %rax,%r8
  683f6e:	66 90                	xchg   %ax,%ax
  683f70:	4d 89 c1             	mov    %r8,%r9
  683f73:	49 d1 e9             	shr    $1,%r9
  683f76:	4d 8d 14 09          	lea    (%r9,%rcx,1),%r10
  683f7a:	42 39 14 d7          	cmp    %edx,(%rdi,%r10,8)
  683f7e:	49 0f 42 ca          	cmovb  %r10,%rcx
  683f82:	4d 29 c8             	sub    %r9,%r8
  683f85:	49 83 f8 01          	cmp    $0x1,%r8
  683f89:	77 e5                	ja     683f70 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x50>
  683f8b:	39 14 cf             	cmp    %edx,(%rdi,%rcx,8)
  683f8e:	48 83 d1 00          	adc    $0x0,%rcx
  683f92:	49 89 f6             	mov    %rsi,%r14
  683f95:	48 8d 14 cf          	lea    (%rdi,%rcx,8),%rdx
  683f99:	31 f6                	xor    %esi,%esi
  683f9b:	eb 5e                	jmp    683ffb <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0xdb>
  683f9d:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
  683fa1:	48 8b 46 10          	mov    0x10(%rsi),%rax
  683fa5:	fe c1                	inc    %cl
  683fa7:	88 4c 24 0f          	mov    %cl,0xf(%rsp)
  683fab:	48 89 c1             	mov    %rax,%rcx
  683fae:	48 85 c0             	test   %rax,%rax
  683fb1:	74 38                	je     683feb <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0xcb>
  683fb3:	31 c9                	xor    %ecx,%ecx
  683fb5:	48 83 f8 01          	cmp    $0x1,%rax
  683fb9:	74 24                	je     683fdf <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0xbf>
  683fbb:	49 89 c0             	mov    %rax,%r8
  683fbe:	66 90                	xchg   %ax,%ax
  683fc0:	4d 89 c1             	mov    %r8,%r9
  683fc3:	49 d1 e9             	shr    $1,%r9
  683fc6:	4d 8d 14 09          	lea    (%r9,%rcx,1),%r10
  683fca:	4f 8d 1c 52          	lea    (%r10,%r10,2),%r11
  683fce:	42 39 14 9f          	cmp    %edx,(%rdi,%r11,4)
  683fd2:	49 0f 42 ca          	cmovb  %r10,%rcx
  683fd6:	4d 29 c8             	sub    %r9,%r8
  683fd9:	49 83 f8 01          	cmp    $0x1,%r8
  683fdd:	77 e1                	ja     683fc0 <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0xa0>
  683fdf:	4c 8d 04 49          	lea    (%rcx,%rcx,2),%r8
  683fe3:	42 39 14 87          	cmp    %edx,(%rdi,%r8,4)
  683fe7:	48 83 d1 00          	adc    $0x0,%rcx
  683feb:	49 89 f6             	mov    %rsi,%r14
  683fee:	48 8d 14 49          	lea    (%rcx,%rcx,2),%rdx
  683ff2:	48 8d 14 97          	lea    (%rdi,%rdx,4),%rdx
  683ff6:	be 01 00 00 00       	mov    $0x1,%esi
  683ffb:	48 29 c8             	sub    %rcx,%rax
  683ffe:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
  684003:	48 89 54 24 58       	mov    %rdx,0x58(%rsp)
  684008:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  68400d:	48 c7 44 24 68 00 00 	movq   $0x0,0x68(%rsp)
  684014:	00 00 
  684016:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  68401b:	48 8d 84 24 80 00 00 	lea    0x80(%rsp),%rax
  684022:	00 
  684023:	c6 84 24 80 00 00 00 	movb   $0x0,0x80(%rsp)
  68402a:	00 
  68402b:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  684030:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  684035:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
  68403a:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  68403f:	48 8d 4c 24 0f       	lea    0xf(%rsp),%rcx
  684044:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  684049:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  68404e:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  684053:	48 8d 74 24 50       	lea    0x50(%rsp),%rsi
  684058:	48 8d 54 24 28       	lea    0x28(%rsp),%rdx
  68405d:	e8 7e d8 ff ff       	call   6818e0 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::try_fold::<(), <core::iter::adapters::take_while::TakeWhile<_, _> as core::iter::traits::iterator::Iterator>::try_fold::check<gpui_canvas::text::layout::Stop, (), core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#0}, core::iter::traits::iterator::Iterator::find::check<gpui_canvas::text::layout::Stop, <gpui_canvas::text::layout::TextGeometry>::caret_bounds::{closure#1}>::{closure#0}>::{closure#0}, core::ops::control_flow::ControlFlow<core::ops::control_flow::ControlFlow<gpui_canvas::text::layout::Stop>>>>
  684062:	8b 44 24 40          	mov    0x40(%rsp),%eax
  684066:	83 f8 02             	cmp    $0x2,%eax
  684069:	74 42                	je     6840ad <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x18d>
  68406b:	8b 4c 24 4c          	mov    0x4c(%rsp),%ecx
  68406f:	89 4c 24 20          	mov    %ecx,0x20(%rsp)
  684073:	48 8b 4c 24 44       	mov    0x44(%rsp),%rcx
  684078:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  68407d:	83 f8 01             	cmp    $0x1,%eax
  684080:	75 2b                	jne    6840ad <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x18d>
  684082:	8b 44 24 20          	mov    0x20(%rsp),%eax
  684086:	89 44 24 30          	mov    %eax,0x30(%rsp)
  68408a:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  68408f:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  684094:	48 8d 7b 04          	lea    0x4(%rbx),%rdi
  684098:	48 8d 54 24 28       	lea    0x28(%rsp),%rdx
  68409d:	4c 89 f6             	mov    %r14,%rsi
  6840a0:	ff 15 2a 57 10 00    	call   *0x10572a(%rip)        # 7897d0 <_DYNAMIC+0x368>
  6840a6:	b8 01 00 00 00       	mov    $0x1,%eax
  6840ab:	eb 02                	jmp    6840af <<gpui_canvas::text::layout::TextGeometry>::caret_bounds+0x18f>
  6840ad:	31 c0                	xor    %eax,%eax
  6840af:	89 03                	mov    %eax,(%rbx)
  6840b1:	48 89 d8             	mov    %rbx,%rax
  6840b4:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  6840bb:	5b                   	pop    %rbx
  6840bc:	41 5e                	pop    %r14
  6840be:	c3                   	ret
