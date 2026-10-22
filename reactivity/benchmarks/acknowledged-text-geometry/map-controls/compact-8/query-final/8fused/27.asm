
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000675420 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow>:
  675420:	53                   	push   %rbx
  675421:	48 8b 1f             	mov    (%rdi),%rbx
  675424:	48 8b 43 28          	mov    0x28(%rbx),%rax
  675428:	48 85 c0             	test   %rax,%rax
  67542b:	74 17                	je     675444 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x24>
  67542d:	48 8b 7b 30          	mov    0x30(%rbx),%rdi
  675431:	48 c1 e0 03          	shl    $0x3,%rax
  675435:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  675439:	ba 04 00 00 00       	mov    $0x4,%edx
  67543e:	ff 15 2c 43 11 00    	call   *0x11432c(%rip)        # 789770 <_DYNAMIC+0x248>
  675444:	48 8b 43 40          	mov    0x40(%rbx),%rax
  675448:	48 85 c0             	test   %rax,%rax
  67544b:	74 17                	je     675464 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x44>
  67544d:	48 8b 7b 48          	mov    0x48(%rbx),%rdi
  675451:	48 c1 e0 03          	shl    $0x3,%rax
  675455:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  675459:	ba 04 00 00 00       	mov    $0x4,%edx
  67545e:	ff 15 0c 43 11 00    	call   *0x11430c(%rip)        # 789770 <_DYNAMIC+0x248>
  675464:	48 8b 43 10          	mov    0x10(%rbx),%rax
  675468:	48 83 f8 02          	cmp    $0x2,%rax
  67546c:	74 34                	je     6754a2 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x82>
  67546e:	48 8b 73 20          	mov    0x20(%rbx),%rsi
  675472:	48 85 c0             	test   %rax,%rax
  675475:	74 13                	je     67548a <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x6a>
  675477:	48 85 f6             	test   %rsi,%rsi
  67547a:	74 26                	je     6754a2 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x82>
  67547c:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
  675480:	48 c1 e6 02          	shl    $0x2,%rsi
  675484:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  675488:	eb 0d                	jmp    675497 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x77>
  67548a:	48 85 f6             	test   %rsi,%rsi
  67548d:	74 13                	je     6754a2 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x82>
  67548f:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
  675493:	48 c1 e6 03          	shl    $0x3,%rsi
  675497:	ba 04 00 00 00       	mov    $0x4,%edx
  67549c:	ff 15 ce 42 11 00    	call   *0x1142ce(%rip)        # 789770 <_DYNAMIC+0x248>
  6754a2:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  6754a6:	74 1b                	je     6754c3 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0xa3>
  6754a8:	f0 48 ff 4b 08       	lock decq 0x8(%rbx)
  6754ad:	75 14                	jne    6754c3 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0xa3>
  6754af:	be 60 00 00 00       	mov    $0x60,%esi
  6754b4:	ba 08 00 00 00       	mov    $0x8,%edx
  6754b9:	48 89 df             	mov    %rbx,%rdi
  6754bc:	5b                   	pop    %rbx
  6754bd:	ff 25 ad 42 11 00    	jmp    *0x1142ad(%rip)        # 789770 <_DYNAMIC+0x248>
  6754c3:	5b                   	pop    %rbx
  6754c4:	c3                   	ret
