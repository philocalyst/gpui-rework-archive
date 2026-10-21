
/tmp/gpui-dimensions-candidate-text:     file format elf64-x86-64


Disassembly of section .text:

00000000002e32a0 <gpui::runtime::layout_changed>:
  2e32a0:	f3 0f 10 0f          	movss  (%rdi),%xmm1
  2e32a4:	f3 0f 10 06          	movss  (%rsi),%xmm0
  2e32a8:	0f 2e c9             	ucomiss %xmm1,%xmm1
  2e32ab:	7a 55                	jp     2e3302 <gpui::runtime::layout_changed+0x62>
  2e32ad:	0f 2e c8             	ucomiss %xmm0,%xmm1
  2e32b0:	75 42                	jne    2e32f4 <gpui::runtime::layout_changed+0x54>
  2e32b2:	7a 40                	jp     2e32f4 <gpui::runtime::layout_changed+0x54>
  2e32b4:	f3 0f 10 4f 04       	movss  0x4(%rdi),%xmm1
  2e32b9:	f3 0f 10 46 04       	movss  0x4(%rsi),%xmm0
  2e32be:	0f 2e c9             	ucomiss %xmm1,%xmm1
  2e32c1:	7a 48                	jp     2e330b <gpui::runtime::layout_changed+0x6b>
  2e32c3:	0f 2e c8             	ucomiss %xmm0,%xmm1
  2e32c6:	75 2c                	jne    2e32f4 <gpui::runtime::layout_changed+0x54>
  2e32c8:	7a 2a                	jp     2e32f4 <gpui::runtime::layout_changed+0x54>
  2e32ca:	f3 0f 10 47 08       	movss  0x8(%rdi),%xmm0
  2e32cf:	b0 01                	mov    $0x1,%al
  2e32d1:	0f 2e 46 08          	ucomiss 0x8(%rsi),%xmm0
  2e32d5:	75 1c                	jne    2e32f3 <gpui::runtime::layout_changed+0x53>
  2e32d7:	7a 1a                	jp     2e32f3 <gpui::runtime::layout_changed+0x53>
  2e32d9:	f3 0f 10 47 0c       	movss  0xc(%rdi),%xmm0
  2e32de:	0f 2e 46 0c          	ucomiss 0xc(%rsi),%xmm0
  2e32e2:	75 0f                	jne    2e32f3 <gpui::runtime::layout_changed+0x53>
  2e32e4:	7a 0d                	jp     2e32f3 <gpui::runtime::layout_changed+0x53>
  2e32e6:	f3 0f 10 47 10       	movss  0x10(%rdi),%xmm0
  2e32eb:	0f 2e 46 10          	ucomiss 0x10(%rsi),%xmm0
  2e32ef:	75 02                	jne    2e32f3 <gpui::runtime::layout_changed+0x53>
  2e32f1:	7b 04                	jnp    2e32f7 <gpui::runtime::layout_changed+0x57>
  2e32f3:	c3                   	ret
  2e32f4:	b0 01                	mov    $0x1,%al
  2e32f6:	c3                   	ret
  2e32f7:	0f b6 47 4c          	movzbl 0x4c(%rdi),%eax
  2e32fb:	3a 46 4c             	cmp    0x4c(%rsi),%al
  2e32fe:	0f 95 c0             	setne  %al
  2e3301:	c3                   	ret
  2e3302:	b0 01                	mov    $0x1,%al
  2e3304:	0f 2e c0             	ucomiss %xmm0,%xmm0
  2e3307:	7b ea                	jnp    2e32f3 <gpui::runtime::layout_changed+0x53>
  2e3309:	eb a9                	jmp    2e32b4 <gpui::runtime::layout_changed+0x14>
  2e330b:	b0 01                	mov    $0x1,%al
  2e330d:	0f 2e c0             	ucomiss %xmm0,%xmm0
  2e3310:	7b e1                	jnp    2e32f3 <gpui::runtime::layout_changed+0x53>
  2e3312:	eb b6                	jmp    2e32ca <gpui::runtime::layout_changed+0x2a>

Disassembly of section .init:

Disassembly of section .fini:

Disassembly of section .plt:
