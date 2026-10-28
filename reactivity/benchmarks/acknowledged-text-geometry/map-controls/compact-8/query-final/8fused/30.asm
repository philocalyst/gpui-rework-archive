
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000661510 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by>:
  661510:	55                   	push   %rbp
  661511:	41 57                	push   %r15
  661513:	41 56                	push   %r14
  661515:	41 55                	push   %r13
  661517:	41 54                	push   %r12
  661519:	53                   	push   %rbx
  66151a:	48 83 ec 18          	sub    $0x18,%rsp
  66151e:	48 85 f6             	test   %rsi,%rsi
  661521:	0f 84 15 01 00 00    	je     66163c <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x12c>
  661527:	48 89 f3             	mov    %rsi,%rbx
  66152a:	49 89 fe             	mov    %rdi,%r14
  66152d:	4c 8b 6f 08          	mov    0x8(%rdi),%r13
  661531:	48 8b 6f 10          	mov    0x10(%rdi),%rbp
  661535:	48 8b 57 18          	mov    0x18(%rdi),%rdx
  661539:	48 83 3f 01          	cmpq   $0x1,(%rdi)
  66153d:	0f 85 8d 00 00 00    	jne    6615d0 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0xc0>
  661543:	48 39 ea             	cmp    %rbp,%rdx
  661546:	0f 83 f2 00 00 00    	jae    66163e <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x12e>
  66154c:	4c 8d 7d ff          	lea    -0x1(%rbp),%r15
  661550:	49 89 d4             	mov    %rdx,%r12
  661553:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  66155a:	84 00 00 00 00 00 
  661560:	48 8d 04 95 00 00 00 	lea    0x0(,%rdx,4),%rax
  661567:	00 
  661568:	48 8d 0c 40          	lea    (%rax,%rax,2),%rcx
  66156c:	41 8b 44 0d 00       	mov    0x0(%r13,%rcx,1),%eax
  661571:	49 8d 75 0c          	lea    0xc(%r13),%rsi
  661575:	48 01 f1             	add    %rsi,%rcx
  661578:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  66157f:	00 
  661580:	4d 39 e7             	cmp    %r12,%r15
  661583:	74 1b                	je     6615a0 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x90>
  661585:	49 ff c4             	inc    %r12
  661588:	39 01                	cmp    %eax,(%rcx)
  66158a:	48 8d 49 0c          	lea    0xc(%rcx),%rcx
  66158e:	74 f0                	je     661580 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x70>
  661590:	eb 11                	jmp    6615a3 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x93>
  661592:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  661599:	1f 84 00 00 00 00 00 
  6615a0:	49 89 ec             	mov    %rbp,%r12
  6615a3:	4d 89 66 18          	mov    %r12,0x18(%r14)
  6615a7:	48 89 e7             	mov    %rsp,%rdi
  6615aa:	4c 89 f6             	mov    %r14,%rsi
  6615ad:	4c 89 e1             	mov    %r12,%rcx
  6615b0:	ff 15 ca 82 12 00    	call   *0x1282ca(%rip)        # 789880 <_DYNAMIC+0x358>
  6615b6:	48 83 3c 24 02       	cmpq   $0x2,(%rsp)
  6615bb:	0f 84 7d 00 00 00    	je     66163e <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x12e>
  6615c1:	48 ff cb             	dec    %rbx
  6615c4:	74 76                	je     66163c <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x12c>
  6615c6:	4c 89 e2             	mov    %r12,%rdx
  6615c9:	49 39 ec             	cmp    %rbp,%r12
  6615cc:	72 92                	jb     661560 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x50>
  6615ce:	eb 6e                	jmp    66163e <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x12e>
  6615d0:	48 39 ea             	cmp    %rbp,%rdx
  6615d3:	73 69                	jae    66163e <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x12e>
  6615d5:	4c 8d 7d ff          	lea    -0x1(%rbp),%r15
  6615d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  6615e0:	41 8b 44 d5 00       	mov    0x0(%r13,%rdx,8),%eax
  6615e5:	48 89 d1             	mov    %rdx,%rcx
  6615e8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  6615ef:	00 
  6615f0:	49 39 cf             	cmp    %rcx,%r15
  6615f3:	74 1b                	je     661610 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x100>
  6615f5:	4c 8d 61 01          	lea    0x1(%rcx),%r12
  6615f9:	41 39 44 cd 08       	cmp    %eax,0x8(%r13,%rcx,8)
  6615fe:	4c 89 e1             	mov    %r12,%rcx
  661601:	74 ed                	je     6615f0 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0xe0>
  661603:	eb 0e                	jmp    661613 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x103>
  661605:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  66160c:	00 00 00 00 
  661610:	49 89 ec             	mov    %rbp,%r12
  661613:	4d 89 66 18          	mov    %r12,0x18(%r14)
  661617:	48 89 e7             	mov    %rsp,%rdi
  66161a:	4c 89 f6             	mov    %r14,%rsi
  66161d:	4c 89 e1             	mov    %r12,%rcx
  661620:	ff 15 5a 82 12 00    	call   *0x12825a(%rip)        # 789880 <_DYNAMIC+0x358>
  661626:	48 83 3c 24 02       	cmpq   $0x2,(%rsp)
  66162b:	74 11                	je     66163e <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x12e>
  66162d:	48 ff cb             	dec    %rbx
  661630:	74 0a                	je     66163c <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x12c>
  661632:	4c 89 e2             	mov    %r12,%rdx
  661635:	49 39 ec             	cmp    %rbp,%r12
  661638:	72 a6                	jb     6615e0 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0xd0>
  66163a:	eb 02                	jmp    66163e <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator::advance_by::SpecAdvanceBy>::spec_advance_by+0x12e>
  66163c:	31 db                	xor    %ebx,%ebx
  66163e:	48 89 d8             	mov    %rbx,%rax
  661641:	48 83 c4 18          	add    $0x18,%rsp
  661645:	5b                   	pop    %rbx
  661646:	41 5c                	pop    %r12
  661648:	41 5d                	pop    %r13
  66164a:	41 5e                	pop    %r14
  66164c:	41 5f                	pop    %r15
  66164e:	5d                   	pop    %rbp
  66164f:	c3                   	ret
