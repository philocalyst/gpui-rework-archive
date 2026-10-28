
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000661480 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by>:
  661480:	55                   	push   %rbp
  661481:	41 57                	push   %r15
  661483:	41 56                	push   %r14
  661485:	41 55                	push   %r13
  661487:	41 54                	push   %r12
  661489:	53                   	push   %rbx
  66148a:	48 83 ec 18          	sub    $0x18,%rsp
  66148e:	48 85 f6             	test   %rsi,%rsi
  661491:	0f 84 15 01 00 00    	je     6615ac <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x12c>
  661497:	48 89 f3             	mov    %rsi,%rbx
  66149a:	49 89 fe             	mov    %rdi,%r14
  66149d:	4c 8b 6f 08          	mov    0x8(%rdi),%r13
  6614a1:	48 8b 6f 10          	mov    0x10(%rdi),%rbp
  6614a5:	48 8b 57 18          	mov    0x18(%rdi),%rdx
  6614a9:	48 83 3f 01          	cmpq   $0x1,(%rdi)
  6614ad:	0f 85 8d 00 00 00    	jne    661540 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0xc0>
  6614b3:	48 39 ea             	cmp    %rbp,%rdx
  6614b6:	0f 83 f2 00 00 00    	jae    6615ae <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x12e>
  6614bc:	4c 8d 7d ff          	lea    -0x1(%rbp),%r15
  6614c0:	49 89 d4             	mov    %rdx,%r12
  6614c3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6614ca:	84 00 00 00 00 00 
  6614d0:	48 8d 04 95 00 00 00 	lea    0x0(,%rdx,4),%rax
  6614d7:	00 
  6614d8:	48 8d 0c 40          	lea    (%rax,%rax,2),%rcx
  6614dc:	41 8b 44 0d 00       	mov    0x0(%r13,%rcx,1),%eax
  6614e1:	49 8d 75 0c          	lea    0xc(%r13),%rsi
  6614e5:	48 01 f1             	add    %rsi,%rcx
  6614e8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  6614ef:	00 
  6614f0:	4d 39 e7             	cmp    %r12,%r15
  6614f3:	74 1b                	je     661510 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x90>
  6614f5:	49 ff c4             	inc    %r12
  6614f8:	39 01                	cmp    %eax,(%rcx)
  6614fa:	48 8d 49 0c          	lea    0xc(%rcx),%rcx
  6614fe:	74 f0                	je     6614f0 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x70>
  661500:	eb 11                	jmp    661513 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x93>
  661502:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  661509:	1f 84 00 00 00 00 00 
  661510:	49 89 ec             	mov    %rbp,%r12
  661513:	4d 89 66 18          	mov    %r12,0x18(%r14)
  661517:	48 89 e7             	mov    %rsp,%rdi
  66151a:	4c 89 f6             	mov    %r14,%rsi
  66151d:	4c 89 e1             	mov    %r12,%rcx
  661520:	ff 15 9a 82 12 00    	call   *0x12829a(%rip)        # 7897c0 <_DYNAMIC+0x358>
  661526:	48 83 3c 24 02       	cmpq   $0x2,(%rsp)
  66152b:	0f 84 7d 00 00 00    	je     6615ae <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x12e>
  661531:	48 ff cb             	dec    %rbx
  661534:	74 76                	je     6615ac <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x12c>
  661536:	4c 89 e2             	mov    %r12,%rdx
  661539:	49 39 ec             	cmp    %rbp,%r12
  66153c:	72 92                	jb     6614d0 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x50>
  66153e:	eb 6e                	jmp    6615ae <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x12e>
  661540:	48 39 ea             	cmp    %rbp,%rdx
  661543:	73 69                	jae    6615ae <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x12e>
  661545:	4c 8d 7d ff          	lea    -0x1(%rbp),%r15
  661549:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  661550:	41 8b 44 d5 00       	mov    0x0(%r13,%rdx,8),%eax
  661555:	48 89 d1             	mov    %rdx,%rcx
  661558:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  66155f:	00 
  661560:	49 39 cf             	cmp    %rcx,%r15
  661563:	74 1b                	je     661580 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x100>
  661565:	4c 8d 61 01          	lea    0x1(%rcx),%r12
  661569:	41 39 44 cd 08       	cmp    %eax,0x8(%r13,%rcx,8)
  66156e:	4c 89 e1             	mov    %r12,%rcx
  661571:	74 ed                	je     661560 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0xe0>
  661573:	eb 0e                	jmp    661583 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x103>
  661575:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  66157c:	00 00 00 00 
  661580:	49 89 ec             	mov    %rbp,%r12
  661583:	4d 89 66 18          	mov    %r12,0x18(%r14)
  661587:	48 89 e7             	mov    %rsp,%rdi
  66158a:	4c 89 f6             	mov    %r14,%rsi
  66158d:	4c 89 e1             	mov    %r12,%rcx
  661590:	ff 15 2a 82 12 00    	call   *0x12822a(%rip)        # 7897c0 <_DYNAMIC+0x358>
  661596:	48 83 3c 24 02       	cmpq   $0x2,(%rsp)
  66159b:	74 11                	je     6615ae <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x12e>
  66159d:	48 ff cb             	dec    %rbx
  6615a0:	74 0a                	je     6615ac <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x12c>
  6615a2:	4c 89 e2             	mov    %r12,%rdx
  6615a5:	49 39 ec             	cmp    %rbp,%r12
  6615a8:	72 a6                	jb     661550 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0xd0>
  6615aa:	eb 02                	jmp    6615ae <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x12e>
  6615ac:	31 db                	xor    %ebx,%ebx
  6615ae:	48 89 d8             	mov    %rbx,%rax
  6615b1:	48 83 c4 18          	add    $0x18,%rsp
  6615b5:	5b                   	pop    %rbx
  6615b6:	41 5c                	pop    %r12
  6615b8:	41 5d                	pop    %r13
  6615ba:	41 5e                	pop    %r14
  6615bc:	41 5f                	pop    %r15
  6615be:	5d                   	pop    %rbp
  6615bf:	c3                   	ret
