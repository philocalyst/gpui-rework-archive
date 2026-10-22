
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006771a0 <<alloc::vec::Vec<gpui_canvas::text::layout::Stop> as alloc::vec::spec_from_iter_nested::SpecFromIterNested<gpui_canvas::text::layout::Stop, core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>>::from_iter>:
  6771a0:	41 57                	push   %r15
  6771a2:	41 56                	push   %r14
  6771a4:	41 55                	push   %r13
  6771a6:	41 54                	push   %r12
  6771a8:	53                   	push   %rbx
  6771a9:	48 83 ec 30          	sub    $0x30,%rsp
  6771ad:	4c 8b 66 20          	mov    0x20(%rsi),%r12
  6771b1:	45 31 ff             	xor    %r15d,%r15d
  6771b4:	4c 2b 66 18          	sub    0x18(%rsi),%r12
  6771b8:	4d 0f 42 e7          	cmovb  %r15,%r12
  6771bc:	4a 8d 04 a5 00 00 00 	lea    0x0(,%r12,4),%rax
  6771c3:	00 
  6771c4:	4c 8d 34 40          	lea    (%rax,%rax,2),%r14
  6771c8:	48 b8 aa aa aa aa aa 	movabs $0xaaaaaaaaaaaaaaa,%rax
  6771cf:	aa aa 0a 
  6771d2:	49 39 c4             	cmp    %rax,%r12
  6771d5:	76 0c                	jbe    6771e3 <<alloc::vec::Vec<gpui_canvas::text::layout::Stop> as alloc::vec::spec_from_iter_nested::SpecFromIterNested<gpui_canvas::text::layout::Stop, core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>>::from_iter+0x43>
  6771d7:	4c 89 ff             	mov    %r15,%rdi
  6771da:	4c 89 f6             	mov    %r14,%rsi
  6771dd:	ff 15 b5 26 11 00    	call   *0x1126b5(%rip)        # 789898 <_DYNAMIC+0x370>
  6771e3:	48 89 fb             	mov    %rdi,%rbx
  6771e6:	4d 85 f6             	test   %r14,%r14
  6771e9:	74 27                	je     677212 <<alloc::vec::Vec<gpui_canvas::text::layout::Stop> as alloc::vec::spec_from_iter_nested::SpecFromIterNested<gpui_canvas::text::layout::Stop, core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>>::from_iter+0x72>
  6771eb:	49 89 f5             	mov    %rsi,%r13
  6771ee:	ff 15 b4 26 11 00    	call   *0x1126b4(%rip)        # 7898a8 <_DYNAMIC+0x380>
  6771f4:	41 bf 04 00 00 00    	mov    $0x4,%r15d
  6771fa:	be 04 00 00 00       	mov    $0x4,%esi
  6771ff:	4c 89 f7             	mov    %r14,%rdi
  677202:	ff 15 a8 26 11 00    	call   *0x1126a8(%rip)        # 7898b0 <_DYNAMIC+0x388>
  677208:	48 85 c0             	test   %rax,%rax
  67720b:	74 ca                	je     6771d7 <<alloc::vec::Vec<gpui_canvas::text::layout::Stop> as alloc::vec::spec_from_iter_nested::SpecFromIterNested<gpui_canvas::text::layout::Stop, core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>>::from_iter+0x37>
  67720d:	4c 89 ee             	mov    %r13,%rsi
  677210:	eb 08                	jmp    67721a <<alloc::vec::Vec<gpui_canvas::text::layout::Stop> as alloc::vec::spec_from_iter_nested::SpecFromIterNested<gpui_canvas::text::layout::Stop, core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>>::from_iter+0x7a>
  677212:	b8 04 00 00 00       	mov    $0x4,%eax
  677217:	45 31 e4             	xor    %r12d,%r12d
  67721a:	4c 89 24 24          	mov    %r12,(%rsp)
  67721e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  677223:	48 8d 4c 24 10       	lea    0x10(%rsp),%rcx
  677228:	48 c7 44 24 10 00 00 	movq   $0x0,0x10(%rsp)
  67722f:	00 00 
  677231:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  677236:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  67723b:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  677242:	00 00 
  677244:	48 8d 44 24 18       	lea    0x18(%rsp),%rax
  677249:	48 89 f7             	mov    %rsi,%rdi
  67724c:	48 89 c6             	mov    %rax,%rsi
  67724f:	e8 9c 4d ff ff       	call   66bff0 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>>
  677254:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  677259:	48 89 43 10          	mov    %rax,0x10(%rbx)
  67725d:	0f 10 04 24          	movups (%rsp),%xmm0
  677261:	0f 11 03             	movups %xmm0,(%rbx)
  677264:	48 89 d8             	mov    %rbx,%rax
  677267:	48 83 c4 30          	add    $0x30,%rsp
  67726b:	5b                   	pop    %rbx
  67726c:	41 5c                	pop    %r12
  67726e:	41 5d                	pop    %r13
  677270:	41 5e                	pop    %r14
  677272:	41 5f                	pop    %r15
  677274:	c3                   	ret
  677275:	48 89 c3             	mov    %rax,%rbx
  677278:	48 8b 04 24          	mov    (%rsp),%rax
  67727c:	48 85 c0             	test   %rax,%rax
  67727f:	74 18                	je     677299 <<alloc::vec::Vec<gpui_canvas::text::layout::Stop> as alloc::vec::spec_from_iter_nested::SpecFromIterNested<gpui_canvas::text::layout::Stop, core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>>::from_iter+0xf9>
  677281:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  677286:	48 c1 e0 02          	shl    $0x2,%rax
  67728a:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  67728e:	ba 04 00 00 00       	mov    $0x4,%edx
  677293:	ff 15 d7 24 11 00    	call   *0x1124d7(%rip)        # 789770 <_DYNAMIC+0x248>
  677299:	48 89 df             	mov    %rbx,%rdi
  67729c:	e8 6f 65 10 00       	call   77d810 <_Unwind_Resume@plt>
