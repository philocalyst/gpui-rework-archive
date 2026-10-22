
/tmp/gpui-text-map-query-controls/12trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000065ffc0 <selection_queries::selected>:
  65ffc0:	50                   	push   %rax
  65ffc1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  65ffc8:	00 
  65ffc9:	48 89 e2             	mov    %rsp,%rdx
  65ffcc:	e8 af 02 00 00       	call   660280 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>>
  65ffd1:	84 c0                	test   %al,%al
  65ffd3:	74 06                	je     65ffdb <selection_queries::selected+0x1b>
  65ffd5:	48 8b 04 24          	mov    (%rsp),%rax
  65ffd9:	59                   	pop    %rcx
  65ffda:	c3                   	ret
  65ffdb:	48 8d 3d ed 47 9c ff 	lea    -0x63b813(%rip),%rdi        # 247cf <anon.fc7a94f9b2531d69817906392dce0d0f.32.llvm.8356244060496160781+0x24f>
  65ffe2:	48 8d 15 47 c7 11 00 	lea    0x11c747(%rip),%rdx        # 77c730 <__frame_dummy_init_array_entry+0x110>
  65ffe9:	be 4c 01 00 00       	mov    $0x14c,%esi
  65ffee:	ff 15 54 75 12 00    	call   *0x127554(%rip)        # 787548 <_DYNAMIC+0x298>
