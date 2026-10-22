
/tmp/gpui-text-map-query-refinements/12checked/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000065ff70 <selection_queries::selected>:
  65ff70:	50                   	push   %rax
  65ff71:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  65ff78:	00 
  65ff79:	48 89 e2             	mov    %rsp,%rdx
  65ff7c:	e8 af 02 00 00       	call   660230 <<gpui_canvas::text::TextLayout>::selection_rects::<selection_queries::selected::{closure#0}>>
  65ff81:	84 c0                	test   %al,%al
  65ff83:	74 06                	je     65ff8b <selection_queries::selected+0x1b>
  65ff85:	48 8b 04 24          	mov    (%rsp),%rax
  65ff89:	59                   	pop    %rcx
  65ff8a:	c3                   	ret
  65ff8b:	48 8d 3d 3d 48 9c ff 	lea    -0x63b7c3(%rip),%rdi        # 247cf <anon.fc7a94f9b2531d69817906392dce0d0f.32.llvm.8356244060496160781+0x24f>
  65ff92:	48 8d 15 07 c6 11 00 	lea    0x11c607(%rip),%rdx        # 77c5a0 <__frame_dummy_init_array_entry+0x110>
  65ff99:	be 4c 01 00 00       	mov    $0x14c,%esi
  65ff9e:	ff 15 14 74 12 00    	call   *0x127414(%rip)        # 7873b8 <_DYNAMIC+0x298>
