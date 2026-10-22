
/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000685ba0 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow>:
  685ba0:	53                   	push   %rbx
  685ba1:	48 8b 1f             	mov    (%rdi),%rbx
  685ba4:	48 8b 43 10          	mov    0x10(%rbx),%rax
  685ba8:	48 85 c0             	test   %rax,%rax
  685bab:	74 17                	je     685bc4 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x24>
  685bad:	48 8b 7b 18          	mov    0x18(%rbx),%rdi
  685bb1:	48 c1 e0 03          	shl    $0x3,%rax
  685bb5:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  685bb9:	ba 04 00 00 00       	mov    $0x4,%edx
  685bbe:	ff 15 34 19 10 00    	call   *0x101934(%rip)        # 7874f8 <_DYNAMIC+0x248>
  685bc4:	48 8b 43 28          	mov    0x28(%rbx),%rax
  685bc8:	48 85 c0             	test   %rax,%rax
  685bcb:	74 17                	je     685be4 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x44>
  685bcd:	48 8b 7b 30          	mov    0x30(%rbx),%rdi
  685bd1:	48 c1 e0 03          	shl    $0x3,%rax
  685bd5:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  685bd9:	ba 04 00 00 00       	mov    $0x4,%edx
  685bde:	ff 15 14 19 10 00    	call   *0x101914(%rip)        # 7874f8 <_DYNAMIC+0x248>
  685be4:	48 8b 43 40          	mov    0x40(%rbx),%rax
  685be8:	48 85 c0             	test   %rax,%rax
  685beb:	7e 17                	jle    685c04 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x64>
  685bed:	48 8b 7b 48          	mov    0x48(%rbx),%rdi
  685bf1:	48 c1 e0 02          	shl    $0x2,%rax
  685bf5:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  685bf9:	ba 04 00 00 00       	mov    $0x4,%edx
  685bfe:	ff 15 f4 18 10 00    	call   *0x1018f4(%rip)        # 7874f8 <_DYNAMIC+0x248>
  685c04:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  685c08:	74 1b                	je     685c25 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x85>
  685c0a:	f0 48 ff 4b 08       	lock decq 0x8(%rbx)
  685c0f:	75 14                	jne    685c25 <<alloc::sync::Arc<gpui_canvas::text::layout::TextGeometry>>::drop_slow+0x85>
  685c11:	be 60 00 00 00       	mov    $0x60,%esi
  685c16:	ba 08 00 00 00       	mov    $0x8,%edx
  685c1b:	48 89 df             	mov    %rbx,%rdi
  685c1e:	5b                   	pop    %rbx
  685c1f:	ff 25 d3 18 10 00    	jmp    *0x1018d3(%rip)        # 7874f8 <_DYNAMIC+0x248>
  685c25:	5b                   	pop    %rbx
  685c26:	c3                   	ret
