
/tmp/gpui-text-map-query-refinements/24trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000065fec0 <selection_queries::selected>:
  65fec0:	50                   	push   %rax
  65fec1:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  65fec8:	00 
  65fec9:	48 89 e2             	mov    %rsp,%rdx
  65fecc:	e8 af 02 00 00       	call   660180 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>>
  65fed1:	84 c0                	test   %al,%al
  65fed3:	74 06                	je     65fedb <selection_queries::selected+0x1b>
  65fed5:	48 8b 04 24          	mov    (%rsp),%rax
  65fed9:	59                   	pop    %rcx
  65feda:	c3                   	ret
  65fedb:	48 8d 3d bd 48 9c ff 	lea    -0x63b743(%rip),%rdi        # 2479f <anon.fc7a94f9b2531d69817906392dce0d0f.32.llvm.8356244060496160781+0x250>
  65fee2:	48 8d 15 37 c6 11 00 	lea    0x11c637(%rip),%rdx        # 77c520 <__frame_dummy_init_array_entry+0x110>
  65fee9:	be 4c 01 00 00       	mov    $0x14c,%esi
  65feee:	ff 15 2c 74 12 00    	call   *0x12742c(%rip)        # 787320 <_DYNAMIC+0x298>
