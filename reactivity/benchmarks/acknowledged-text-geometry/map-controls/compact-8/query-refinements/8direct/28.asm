
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006623b0 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow>:
  6623b0:	53                   	push   %rbx
  6623b1:	48 8b 1f             	mov    (%rdi),%rbx
  6623b4:	48 8b 43 28          	mov    0x28(%rbx),%rax
  6623b8:	48 85 c0             	test   %rax,%rax
  6623bb:	74 17                	je     6623d4 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x24>
  6623bd:	48 8b 7b 30          	mov    0x30(%rbx),%rdi
  6623c1:	48 c1 e0 03          	shl    $0x3,%rax
  6623c5:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  6623c9:	ba 04 00 00 00       	mov    $0x4,%edx
  6623ce:	ff 15 dc 72 12 00    	call   *0x1272dc(%rip)        # 7896b0 <_DYNAMIC+0x248>
  6623d4:	48 8b 43 40          	mov    0x40(%rbx),%rax
  6623d8:	48 85 c0             	test   %rax,%rax
  6623db:	74 17                	je     6623f4 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x44>
  6623dd:	48 8b 7b 48          	mov    0x48(%rbx),%rdi
  6623e1:	48 c1 e0 03          	shl    $0x3,%rax
  6623e5:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  6623e9:	ba 04 00 00 00       	mov    $0x4,%edx
  6623ee:	ff 15 bc 72 12 00    	call   *0x1272bc(%rip)        # 7896b0 <_DYNAMIC+0x248>
  6623f4:	48 8b 43 10          	mov    0x10(%rbx),%rax
  6623f8:	48 83 f8 02          	cmp    $0x2,%rax
  6623fc:	74 34                	je     662432 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x82>
  6623fe:	48 8b 73 20          	mov    0x20(%rbx),%rsi
  662402:	48 85 c0             	test   %rax,%rax
  662405:	74 13                	je     66241a <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x6a>
  662407:	48 85 f6             	test   %rsi,%rsi
  66240a:	74 26                	je     662432 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x82>
  66240c:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
  662410:	48 c1 e6 02          	shl    $0x2,%rsi
  662414:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  662418:	eb 0d                	jmp    662427 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x77>
  66241a:	48 85 f6             	test   %rsi,%rsi
  66241d:	74 13                	je     662432 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x82>
  66241f:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
  662423:	48 c1 e6 03          	shl    $0x3,%rsi
  662427:	ba 04 00 00 00       	mov    $0x4,%edx
  66242c:	ff 15 7e 72 12 00    	call   *0x12727e(%rip)        # 7896b0 <_DYNAMIC+0x248>
  662432:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  662436:	74 1b                	je     662453 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0xa3>
  662438:	f0 48 ff 4b 08       	lock decq 0x8(%rbx)
  66243d:	75 14                	jne    662453 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0xa3>
  66243f:	be 60 00 00 00       	mov    $0x60,%esi
  662444:	ba 08 00 00 00       	mov    $0x8,%edx
  662449:	48 89 df             	mov    %rbx,%rdi
  66244c:	5b                   	pop    %rbx
  66244d:	ff 25 5d 72 12 00    	jmp    *0x12725d(%rip)        # 7896b0 <_DYNAMIC+0x248>
  662453:	5b                   	pop    %rbx
  662454:	c3                   	ret
