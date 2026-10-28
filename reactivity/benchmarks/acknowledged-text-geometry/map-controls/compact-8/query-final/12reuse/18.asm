
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000067a930 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow>:
  67a930:	53                   	push   %rbx
  67a931:	48 8b 1f             	mov    (%rdi),%rbx
  67a934:	48 8b 43 10          	mov    0x10(%rbx),%rax
  67a938:	48 85 c0             	test   %rax,%rax
  67a93b:	74 17                	je     67a954 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x24>
  67a93d:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
  67a941:	48 c1 e0 03          	shl    $0x3,%rax
  67a945:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  67a949:	ba 04 00 00 00       	mov    $0x4,%edx
  67a94e:	ff 15 14 cc 10 00    	call   *0x10cc14(%rip)        # 787568 <_DYNAMIC+0x248>
  67a954:	48 8b 43 28          	mov    0x28(%rbx),%rax
  67a958:	48 85 c0             	test   %rax,%rax
  67a95b:	74 17                	je     67a974 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x44>
  67a95d:	48 8b 7b 30          	mov    0x30(%rbx),%rdi
  67a961:	48 c1 e0 03          	shl    $0x3,%rax
  67a965:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  67a969:	ba 04 00 00 00       	mov    $0x4,%edx
  67a96e:	ff 15 f4 cb 10 00    	call   *0x10cbf4(%rip)        # 787568 <_DYNAMIC+0x248>
  67a974:	48 8b 43 40          	mov    0x40(%rbx),%rax
  67a978:	48 85 c0             	test   %rax,%rax
  67a97b:	7e 17                	jle    67a994 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x64>
  67a97d:	48 8b 7b 48          	mov    0x48(%rbx),%rdi
  67a981:	48 c1 e0 02          	shl    $0x2,%rax
  67a985:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  67a989:	ba 04 00 00 00       	mov    $0x4,%edx
  67a98e:	ff 15 d4 cb 10 00    	call   *0x10cbd4(%rip)        # 787568 <_DYNAMIC+0x248>
  67a994:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  67a998:	74 1b                	je     67a9b5 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x85>
  67a99a:	f0 48 ff 4b 08       	lock decq 0x8(%rbx)
  67a99f:	75 14                	jne    67a9b5 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x85>
  67a9a1:	be 60 00 00 00       	mov    $0x60,%esi
  67a9a6:	ba 08 00 00 00       	mov    $0x8,%edx
  67a9ab:	48 89 df             	mov    %rbx,%rdi
  67a9ae:	5b                   	pop    %rbx
  67a9af:	ff 25 b3 cb 10 00    	jmp    *0x10cbb3(%rip)        # 787568 <_DYNAMIC+0x248>
  67a9b5:	5b                   	pop    %rbx
  67a9b6:	c3                   	ret
