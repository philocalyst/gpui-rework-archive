
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000687260 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth>:
  687260:	41 56                	push   %r14
  687262:	53                   	push   %rbx
  687263:	50                   	push   %rax
  687264:	48 89 d1             	mov    %rdx,%rcx
  687267:	48 89 f0             	mov    %rsi,%rax
  68726a:	4c 8b 16             	mov    (%rsi),%r10
  68726d:	4c 8b 4e 08          	mov    0x8(%rsi),%r9
  687271:	48 8b 56 10          	mov    0x10(%rsi),%rdx
  687275:	4c 8b 46 18          	mov    0x18(%rsi),%r8
  687279:	49 83 fa 01          	cmp    $0x1,%r10
  68727d:	75 26                	jne    6872a5 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x45>
  68727f:	4d 8d 59 0c          	lea    0xc(%r9),%r11
  687283:	eb 7c                	jmp    687301 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xa1>
  687285:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  68728c:	00 00 00 00 
  687290:	48 89 70 18          	mov    %rsi,0x18(%rax)
  687294:	4c 39 c6             	cmp    %r8,%rsi
  687297:	72 46                	jb     6872df <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x7f>
  687299:	49 89 f0             	mov    %rsi,%r8
  68729c:	48 ff c9             	dec    %rcx
  68729f:	0f 84 ad 00 00 00    	je     687352 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xf2>
  6872a5:	49 39 d0             	cmp    %rdx,%r8
  6872a8:	0f 83 45 01 00 00    	jae    6873f3 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x193>
  6872ae:	49 8d 70 01          	lea    0x1(%r8),%rsi
  6872b2:	48 39 d6             	cmp    %rdx,%rsi
  6872b5:	73 1a                	jae    6872d1 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x71>
  6872b7:	47 8b 1c c1          	mov    (%r9,%r8,8),%r11d
  6872bb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  6872c0:	45 39 1c f1          	cmp    %r11d,(%r9,%rsi,8)
  6872c4:	75 ca                	jne    687290 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x30>
  6872c6:	48 ff c6             	inc    %rsi
  6872c9:	48 39 f2             	cmp    %rsi,%rdx
  6872cc:	75 f2                	jne    6872c0 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x60>
  6872ce:	48 89 d6             	mov    %rdx,%rsi
  6872d1:	48 89 70 18          	mov    %rsi,0x18(%rax)
  6872d5:	4c 39 c6             	cmp    %r8,%rsi
  6872d8:	72 05                	jb     6872df <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x7f>
  6872da:	48 39 d6             	cmp    %rdx,%rsi
  6872dd:	76 ba                	jbe    687299 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x39>
  6872df:	48 8d 0d ea 8a 0f 00 	lea    0xf8aea(%rip),%rcx        # 77fdd0 <anon.fbd43a41ff80879e00dce0ef788d434c.11.llvm.13268200981076639468+0x1c8>
  6872e6:	4c 89 c7             	mov    %r8,%rdi
  6872e9:	ff 15 49 26 10 00    	call   *0x102649(%rip)        # 789938 <_DYNAMIC+0x4d0>
  6872ef:	90                   	nop
  6872f0:	48 89 70 18          	mov    %rsi,0x18(%rax)
  6872f4:	4c 39 c6             	cmp    %r8,%rsi
  6872f7:	72 49                	jb     687342 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xe2>
  6872f9:	49 89 f0             	mov    %rsi,%r8
  6872fc:	48 ff c9             	dec    %rcx
  6872ff:	74 51                	je     687352 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xf2>
  687301:	49 39 d0             	cmp    %rdx,%r8
  687304:	0f 83 e9 00 00 00    	jae    6873f3 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x193>
  68730a:	49 8d 70 01          	lea    0x1(%r8),%rsi
  68730e:	48 39 d6             	cmp    %rdx,%rsi
  687311:	73 21                	jae    687334 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xd4>
  687313:	4f 8d 34 40          	lea    (%r8,%r8,2),%r14
  687317:	43 8b 1c b1          	mov    (%r9,%r14,4),%ebx
  68731b:	4f 8d 34 b3          	lea    (%r11,%r14,4),%r14
  68731f:	90                   	nop
  687320:	41 39 1e             	cmp    %ebx,(%r14)
  687323:	75 cb                	jne    6872f0 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x90>
  687325:	48 ff c6             	inc    %rsi
  687328:	49 83 c6 0c          	add    $0xc,%r14
  68732c:	48 39 f2             	cmp    %rsi,%rdx
  68732f:	75 ef                	jne    687320 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xc0>
  687331:	48 89 d6             	mov    %rdx,%rsi
  687334:	48 89 70 18          	mov    %rsi,0x18(%rax)
  687338:	4c 39 c6             	cmp    %r8,%rsi
  68733b:	72 05                	jb     687342 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0xe2>
  68733d:	48 39 d6             	cmp    %rdx,%rsi
  687340:	76 b7                	jbe    6872f9 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x99>
  687342:	48 8d 0d 9f 8a 0f 00 	lea    0xf8a9f(%rip),%rcx        # 77fde8 <anon.fbd43a41ff80879e00dce0ef788d434c.11.llvm.13268200981076639468+0x1e0>
  687349:	4c 89 c7             	mov    %r8,%rdi
  68734c:	ff 15 e6 25 10 00    	call   *0x1025e6(%rip)        # 789938 <_DYNAMIC+0x4d0>
  687352:	41 f6 c2 01          	test   $0x1,%r10b
  687356:	74 58                	je     6873b0 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x150>
  687358:	48 39 d6             	cmp    %rdx,%rsi
  68735b:	0f 83 92 00 00 00    	jae    6873f3 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x193>
  687361:	4c 8d 1c 76          	lea    (%rsi,%rsi,2),%r11
  687365:	4b 8d 0c 99          	lea    (%r9,%r11,4),%rcx
  687369:	4c 8d 46 01          	lea    0x1(%rsi),%r8
  68736d:	49 39 d0             	cmp    %rdx,%r8
  687370:	73 22                	jae    687394 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x134>
  687372:	47 8b 14 99          	mov    (%r9,%r11,4),%r10d
  687376:	4f 8d 0c 99          	lea    (%r9,%r11,4),%r9
  68737a:	49 83 c1 0c          	add    $0xc,%r9
  68737e:	66 90                	xchg   %ax,%ax
  687380:	45 39 11             	cmp    %r10d,(%r9)
  687383:	75 7d                	jne    687402 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1a2>
  687385:	49 ff c0             	inc    %r8
  687388:	49 83 c1 0c          	add    $0xc,%r9
  68738c:	4c 39 c2             	cmp    %r8,%rdx
  68738f:	75 ef                	jne    687380 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x120>
  687391:	49 89 d0             	mov    %rdx,%r8
  687394:	4c 89 40 18          	mov    %r8,0x18(%rax)
  687398:	49 39 f0             	cmp    %rsi,%r8
  68739b:	0f 82 a1 00 00 00    	jb     687442 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1e2>
  6873a1:	b8 01 00 00 00       	mov    $0x1,%eax
  6873a6:	49 39 d0             	cmp    %rdx,%r8
  6873a9:	76 65                	jbe    687410 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1b0>
  6873ab:	e9 92 00 00 00       	jmp    687442 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1e2>
  6873b0:	48 39 d6             	cmp    %rdx,%rsi
  6873b3:	73 3e                	jae    6873f3 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x193>
  6873b5:	49 8d 0c f1          	lea    (%r9,%rsi,8),%rcx
  6873b9:	4c 8d 46 01          	lea    0x1(%rsi),%r8
  6873bd:	49 39 d0             	cmp    %rdx,%r8
  6873c0:	73 1f                	jae    6873e1 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x181>
  6873c2:	45 8b 14 f1          	mov    (%r9,%rsi,8),%r10d
  6873c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  6873cd:	00 00 00 
  6873d0:	47 39 14 c1          	cmp    %r10d,(%r9,%r8,8)
  6873d4:	75 50                	jne    687426 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1c6>
  6873d6:	49 ff c0             	inc    %r8
  6873d9:	4c 39 c2             	cmp    %r8,%rdx
  6873dc:	75 f2                	jne    6873d0 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x170>
  6873de:	49 89 d0             	mov    %rdx,%r8
  6873e1:	4c 89 40 18          	mov    %r8,0x18(%rax)
  6873e5:	49 39 f0             	cmp    %rsi,%r8
  6873e8:	72 45                	jb     68742f <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1cf>
  6873ea:	49 39 d0             	cmp    %rdx,%r8
  6873ed:	77 40                	ja     68742f <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1cf>
  6873ef:	31 c0                	xor    %eax,%eax
  6873f1:	eb 1d                	jmp    687410 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1b0>
  6873f3:	48 c7 07 02 00 00 00 	movq   $0x2,(%rdi)
  6873fa:	48 83 c4 08          	add    $0x8,%rsp
  6873fe:	5b                   	pop    %rbx
  6873ff:	41 5e                	pop    %r14
  687401:	c3                   	ret
  687402:	4c 89 40 18          	mov    %r8,0x18(%rax)
  687406:	b8 01 00 00 00       	mov    $0x1,%eax
  68740b:	49 39 f0             	cmp    %rsi,%r8
  68740e:	72 32                	jb     687442 <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x1e2>
  687410:	49 29 f0             	sub    %rsi,%r8
  687413:	48 89 07             	mov    %rax,(%rdi)
  687416:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  68741a:	4c 89 47 10          	mov    %r8,0x10(%rdi)
  68741e:	48 83 c4 08          	add    $0x8,%rsp
  687422:	5b                   	pop    %rbx
  687423:	41 5e                	pop    %r14
  687425:	c3                   	ret
  687426:	4c 89 40 18          	mov    %r8,0x18(%rax)
  68742a:	49 39 f0             	cmp    %rsi,%r8
  68742d:	73 c0                	jae    6873ef <<core::iter::sources::from_fn::FromFn<<gpui_canvas::text::layout::Stops>::groups::{closure#0}> as core::iter::traits::iterator::Iterator>::nth+0x18f>
  68742f:	48 8d 0d 9a 89 0f 00 	lea    0xf899a(%rip),%rcx        # 77fdd0 <anon.fbd43a41ff80879e00dce0ef788d434c.11.llvm.13268200981076639468+0x1c8>
  687436:	48 89 f7             	mov    %rsi,%rdi
  687439:	4c 89 c6             	mov    %r8,%rsi
  68743c:	ff 15 f6 24 10 00    	call   *0x1024f6(%rip)        # 789938 <_DYNAMIC+0x4d0>
  687442:	48 8d 0d 9f 89 0f 00 	lea    0xf899f(%rip),%rcx        # 77fde8 <anon.fbd43a41ff80879e00dce0ef788d434c.11.llvm.13268200981076639468+0x1e0>
  687449:	48 89 f7             	mov    %rsi,%rdi
  68744c:	4c 89 c6             	mov    %r8,%rsi
  68744f:	ff 15 e3 24 10 00    	call   *0x1024e3(%rip)        # 789938 <_DYNAMIC+0x4d0>
