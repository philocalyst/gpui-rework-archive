
/tmp/gpui-text-map-query-refinements/24trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

00000000006786a0 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow>:
  6786a0:	53                   	push   %rbx
  6786a1:	48 8b 1f             	mov    (%rdi),%rbx
  6786a4:	48 8b 43 10          	mov    0x10(%rbx),%rax
  6786a8:	48 85 c0             	test   %rax,%rax
  6786ab:	74 17                	je     6786c4 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x24>
  6786ad:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
  6786b1:	48 c1 e0 03          	shl    $0x3,%rax
  6786b5:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  6786b9:	ba 04 00 00 00       	mov    $0x4,%edx
  6786be:	ff 15 0c ec 10 00    	call   *0x10ec0c(%rip)        # 7872d0 <_DYNAMIC+0x248>
  6786c4:	48 8b 43 28          	mov    0x28(%rbx),%rax
  6786c8:	48 85 c0             	test   %rax,%rax
  6786cb:	74 17                	je     6786e4 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x44>
  6786cd:	48 8b 7b 30          	mov    0x30(%rbx),%rdi
  6786d1:	48 c1 e0 03          	shl    $0x3,%rax
  6786d5:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  6786d9:	ba 04 00 00 00       	mov    $0x4,%edx
  6786de:	ff 15 ec eb 10 00    	call   *0x10ebec(%rip)        # 7872d0 <_DYNAMIC+0x248>
  6786e4:	48 8b 43 40          	mov    0x40(%rbx),%rax
  6786e8:	48 85 c0             	test   %rax,%rax
  6786eb:	7e 17                	jle    678704 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x64>
  6786ed:	48 8b 7b 48          	mov    0x48(%rbx),%rdi
  6786f1:	48 c1 e0 03          	shl    $0x3,%rax
  6786f5:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  6786f9:	ba 04 00 00 00       	mov    $0x4,%edx
  6786fe:	ff 15 cc eb 10 00    	call   *0x10ebcc(%rip)        # 7872d0 <_DYNAMIC+0x248>
  678704:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  678708:	74 1b                	je     678725 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x85>
  67870a:	f0 48 ff 4b 08       	lock decq 0x8(%rbx)
  67870f:	75 14                	jne    678725 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x85>
  678711:	be 60 00 00 00       	mov    $0x60,%esi
  678716:	ba 08 00 00 00       	mov    $0x8,%edx
  67871b:	48 89 df             	mov    %rbx,%rdi
  67871e:	5b                   	pop    %rbx
  67871f:	ff 25 ab eb 10 00    	jmp    *0x10ebab(%rip)        # 7872d0 <_DYNAMIC+0x248>
  678725:	5b                   	pop    %rbx
  678726:	c3                   	ret
