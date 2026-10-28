
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000665d60 <<gpui_canvas::text::TextLayout>::lines>:
  665d60:	48 89 f8             	mov    %rdi,%rax
  665d63:	48 8b 4e 20          	mov    0x20(%rsi),%rcx
  665d67:	48 85 c9             	test   %rcx,%rcx
  665d6a:	74 0c                	je     665d78 <<gpui_canvas::text::TextLayout>::lines+0x18>
  665d6c:	48 8b 71 48          	mov    0x48(%rcx),%rsi
  665d70:	48 8b 79 50          	mov    0x50(%rcx),%rdi
  665d74:	31 d2                	xor    %edx,%edx
  665d76:	eb 40                	jmp    665db8 <<gpui_canvas::text::TextLayout>::lines+0x58>
  665d78:	48 8b 56 10          	mov    0x10(%rsi),%rdx
  665d7c:	31 c9                	xor    %ecx,%ecx
  665d7e:	48 85 d2             	test   %rdx,%rdx
  665d81:	74 1f                	je     665da2 <<gpui_canvas::text::TextLayout>::lines+0x42>
  665d83:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
  665d87:	48 c1 e2 04          	shl    $0x4,%rdx
  665d8b:	4c 8d 04 17          	lea    (%rdi,%rdx,1),%r8
  665d8f:	49 83 c0 f0          	add    $0xfffffffffffffff0,%r8
  665d93:	4d 85 c0             	test   %r8,%r8
  665d96:	74 0a                	je     665da2 <<gpui_canvas::text::TextLayout>::lines+0x42>
  665d98:	48 01 d7             	add    %rdx,%rdi
  665d9b:	0f b6 4f ff          	movzbl -0x1(%rdi),%ecx
  665d9f:	03 4f f0             	add    -0x10(%rdi),%ecx
  665da2:	f2 0f 10 4e 2c       	movsd  0x2c(%rsi),%xmm1
  665da7:	f3 0f 10 46 28       	movss  0x28(%rsi),%xmm0
  665dac:	ba 01 00 00 00       	mov    $0x1,%edx
  665db1:	be 04 00 00 00       	mov    $0x4,%esi
  665db6:	31 ff                	xor    %edi,%edi
  665db8:	48 8d 3c 7f          	lea    (%rdi,%rdi,2),%rdi
  665dbc:	48 8d 3c fe          	lea    (%rsi,%rdi,8),%rdi
  665dc0:	48 89 30             	mov    %rsi,(%rax)
  665dc3:	48 89 78 08          	mov    %rdi,0x8(%rax)
  665dc7:	89 50 10             	mov    %edx,0x10(%rax)
  665dca:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%rax)
  665dd1:	89 48 18             	mov    %ecx,0x18(%rax)
  665dd4:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%rax)
  665ddb:	0f 13 48 20          	movlps %xmm1,0x20(%rax)
  665ddf:	f3 0f 11 40 28       	movss  %xmm0,0x28(%rax)
  665de4:	c3                   	ret
