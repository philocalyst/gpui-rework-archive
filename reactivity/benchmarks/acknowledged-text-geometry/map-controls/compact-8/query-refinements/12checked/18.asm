
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000685a10 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow>:
  685a10:	53                   	push   %rbx
  685a11:	48 8b 1f             	mov    (%rdi),%rbx
  685a14:	48 8b 43 10          	mov    0x10(%rbx),%rax
  685a18:	48 85 c0             	test   %rax,%rax
  685a1b:	74 17                	je     685a34 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x24>
  685a1d:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
  685a21:	48 c1 e0 03          	shl    $0x3,%rax
  685a25:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  685a29:	ba 04 00 00 00       	mov    $0x4,%edx
  685a2e:	ff 15 34 19 10 00    	call   *0x101934(%rip)        # 787368 <_DYNAMIC+0x248>
  685a34:	48 8b 43 28          	mov    0x28(%rbx),%rax
  685a38:	48 85 c0             	test   %rax,%rax
  685a3b:	74 17                	je     685a54 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x44>
  685a3d:	48 8b 7b 30          	mov    0x30(%rbx),%rdi
  685a41:	48 c1 e0 03          	shl    $0x3,%rax
  685a45:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  685a49:	ba 04 00 00 00       	mov    $0x4,%edx
  685a4e:	ff 15 14 19 10 00    	call   *0x101914(%rip)        # 787368 <_DYNAMIC+0x248>
  685a54:	48 8b 43 40          	mov    0x40(%rbx),%rax
  685a58:	48 85 c0             	test   %rax,%rax
  685a5b:	7e 17                	jle    685a74 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x64>
  685a5d:	48 8b 7b 48          	mov    0x48(%rbx),%rdi
  685a61:	48 c1 e0 02          	shl    $0x2,%rax
  685a65:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  685a69:	ba 04 00 00 00       	mov    $0x4,%edx
  685a6e:	ff 15 f4 18 10 00    	call   *0x1018f4(%rip)        # 787368 <_DYNAMIC+0x248>
  685a74:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  685a78:	74 1b                	je     685a95 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x85>
  685a7a:	f0 48 ff 4b 08       	lock decq 0x8(%rbx)
  685a7f:	75 14                	jne    685a95 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x85>
  685a81:	be 60 00 00 00       	mov    $0x60,%esi
  685a86:	ba 08 00 00 00       	mov    $0x8,%edx
  685a8b:	48 89 df             	mov    %rbx,%rdi
  685a8e:	5b                   	pop    %rbx
  685a8f:	ff 25 d3 18 10 00    	jmp    *0x1018d3(%rip)        # 787368 <_DYNAMIC+0x248>
  685a95:	5b                   	pop    %rbx
  685a96:	c3                   	ret
