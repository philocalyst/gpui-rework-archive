
/tmp/gpui-text-map-query-final/12reuse/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000065ffa0 <selection_queries::selected>:
  65ffa0:	50                   	push   %rax
  65ffa1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  65ffa8:	00 
  65ffa9:	48 89 e2             	mov    %rsp,%rdx
  65ffac:	e8 af 02 00 00       	call   660260 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>>
  65ffb1:	84 c0                	test   %al,%al
  65ffb3:	74 06                	je     65ffbb <selection_queries::selected+0x1b>
  65ffb5:	48 8b 04 24          	mov    (%rsp),%rax
  65ffb9:	59                   	pop    %rcx
  65ffba:	c3                   	ret
  65ffbb:	48 8d 3d 3d 48 9c ff 	lea    -0x63b7c3(%rip),%rdi        # 247ff <anon.fc7a94f9b2531d69817906392dce0d0f.32.llvm.8356244060496160781+0x24f>
  65ffc2:	48 8d 15 a7 c7 11 00 	lea    0x11c7a7(%rip),%rdx        # 77c770 <__frame_dummy_init_array_entry+0x110>
  65ffc9:	be 4c 01 00 00       	mov    $0x14c,%esi
  65ffce:	ff 15 e4 75 12 00    	call   *0x1275e4(%rip)        # 7875b8 <_DYNAMIC+0x298>
