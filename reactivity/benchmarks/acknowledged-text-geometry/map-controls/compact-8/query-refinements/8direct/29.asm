
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000679e10 <<alloc::vec::Vec<gpui_canvas::text::layout::Stop> as alloc::vec::spec_from_iter_nested::SpecFromIterNested<gpui_canvas::text::layout::Stop, core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>>::from_iter>:
  679e10:	41 57                	push   %r15
  679e12:	41 56                	push   %r14
  679e14:	41 55                	push   %r13
  679e16:	41 54                	push   %r12
  679e18:	53                   	push   %rbx
  679e19:	48 83 ec 30          	sub    $0x30,%rsp
  679e1d:	4c 8b 66 20          	mov    0x20(%rsi),%r12
  679e21:	45 31 ff             	xor    %r15d,%r15d
  679e24:	4c 2b 66 18          	sub    0x18(%rsi),%r12
  679e28:	4d 0f 42 e7          	cmovb  %r15,%r12
  679e2c:	4a 8d 04 a5 00 00 00 	lea    0x0(,%r12,4),%rax
  679e33:	00 
  679e34:	4c 8d 34 40          	lea    (%rax,%rax,2),%r14
  679e38:	48 b8 aa aa aa aa aa 	movabs $0xaaaaaaaaaaaaaaa,%rax
  679e3f:	aa aa 0a 
  679e42:	49 39 c4             	cmp    %rax,%r12
  679e45:	76 0c                	jbe    679e53 <<alloc::vec::Vec<gpui_canvas::text::layout::Stop> as alloc::vec::spec_from_iter_nested::SpecFromIterNested<gpui_canvas::text::layout::Stop, core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>>::from_iter+0x43>
  679e47:	4c 89 ff             	mov    %r15,%rdi
  679e4a:	4c 89 f6             	mov    %r14,%rsi
  679e4d:	ff 15 8d f9 10 00    	call   *0x10f98d(%rip)        # 7897e0 <_DYNAMIC+0x378>
  679e53:	48 89 fb             	mov    %rdi,%rbx
  679e56:	4d 85 f6             	test   %r14,%r14
  679e59:	74 27                	je     679e82 <<alloc::vec::Vec<gpui_canvas::text::layout::Stop> as alloc::vec::spec_from_iter_nested::SpecFromIterNested<gpui_canvas::text::layout::Stop, core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>>::from_iter+0x72>
  679e5b:	49 89 f5             	mov    %rsi,%r13
  679e5e:	ff 15 8c f9 10 00    	call   *0x10f98c(%rip)        # 7897f0 <_DYNAMIC+0x388>
  679e64:	41 bf 04 00 00 00    	mov    $0x4,%r15d
  679e6a:	be 04 00 00 00       	mov    $0x4,%esi
  679e6f:	4c 89 f7             	mov    %r14,%rdi
  679e72:	ff 15 80 f9 10 00    	call   *0x10f980(%rip)        # 7897f8 <_DYNAMIC+0x390>
  679e78:	48 85 c0             	test   %rax,%rax
  679e7b:	74 ca                	je     679e47 <<alloc::vec::Vec<gpui_canvas::text::layout::Stop> as alloc::vec::spec_from_iter_nested::SpecFromIterNested<gpui_canvas::text::layout::Stop, core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>>::from_iter+0x37>
  679e7d:	4c 89 ee             	mov    %r13,%rsi
  679e80:	eb 08                	jmp    679e8a <<alloc::vec::Vec<gpui_canvas::text::layout::Stop> as alloc::vec::spec_from_iter_nested::SpecFromIterNested<gpui_canvas::text::layout::Stop, core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>>::from_iter+0x7a>
  679e82:	b8 04 00 00 00       	mov    $0x4,%eax
  679e87:	45 31 e4             	xor    %r12d,%r12d
  679e8a:	4c 89 24 24          	mov    %r12,(%rsp)
  679e8e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  679e93:	48 8d 4c 24 10       	lea    0x10(%rsp),%rcx
  679e98:	48 c7 44 24 10 00 00 	movq   $0x0,0x10(%rsp)
  679e9f:	00 00 
  679ea1:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  679ea6:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  679eab:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  679eb2:	00 00 
  679eb4:	48 8d 44 24 18       	lea    0x18(%rsp),%rax
  679eb9:	48 89 f7             	mov    %rsi,%rdi
  679ebc:	48 89 c6             	mov    %rax,%rsi
  679ebf:	e8 dc 78 00 00       	call   6817a0 <<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}> as core::iter::traits::iterator::Iterator>::fold::<(), core::iter::traits::iterator::Iterator::for_each::call<gpui_canvas::text::layout::Stop, <alloc::vec::Vec<gpui_canvas::text::layout::Stop>>::extend_trusted<core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>::{closure#0}>::{closure#0}>>
  679ec4:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  679ec9:	48 89 43 10          	mov    %rax,0x10(%rbx)
  679ecd:	0f 10 04 24          	movups (%rsp),%xmm0
  679ed1:	0f 11 03             	movups %xmm0,(%rbx)
  679ed4:	48 89 d8             	mov    %rbx,%rax
  679ed7:	48 83 c4 30          	add    $0x30,%rsp
  679edb:	5b                   	pop    %rbx
  679edc:	41 5c                	pop    %r12
  679ede:	41 5d                	pop    %r13
  679ee0:	41 5e                	pop    %r14
  679ee2:	41 5f                	pop    %r15
  679ee4:	c3                   	ret
  679ee5:	48 89 c3             	mov    %rax,%rbx
  679ee8:	48 8b 04 24          	mov    (%rsp),%rax
  679eec:	48 85 c0             	test   %rax,%rax
  679eef:	74 18                	je     679f09 <<alloc::vec::Vec<gpui_canvas::text::layout::Stop> as alloc::vec::spec_from_iter_nested::SpecFromIterNested<gpui_canvas::text::layout::Stop, core::iter::adapters::map::Map<core::ops::range::Range<usize>, <gpui_canvas::text::layout::Stops>::iter::{closure#0}>>>::from_iter+0xf9>
  679ef1:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  679ef6:	48 c1 e0 02          	shl    $0x2,%rax
  679efa:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  679efe:	ba 04 00 00 00       	mov    $0x4,%edx
  679f03:	ff 15 a7 f7 10 00    	call   *0x10f7a7(%rip)        # 7896b0 <_DYNAMIC+0x248>
  679f09:	48 89 df             	mov    %rbx,%rdi
  679f0c:	e8 6f 38 10 00       	call   77d780 <_Unwind_Resume@plt>
