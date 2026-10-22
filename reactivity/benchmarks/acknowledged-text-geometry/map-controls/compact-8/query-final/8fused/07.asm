
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000660570 <selection_queries::selected>:
  660570:	50                   	push   %rax
  660571:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  660578:	00 
  660579:	48 85 ff             	test   %rdi,%rdi
  66057c:	74 16                	je     660594 <selection_queries::selected+0x24>
  66057e:	48 83 c7 10          	add    $0x10,%rdi
  660582:	48 89 e2             	mov    %rsp,%rdx
  660585:	e8 a6 02 00 00       	call   660830 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>>
  66058a:	84 c0                	test   %al,%al
  66058c:	74 06                	je     660594 <selection_queries::selected+0x24>
  66058e:	48 8b 04 24          	mov    (%rsp),%rax
  660592:	59                   	pop    %rcx
  660593:	c3                   	ret
  660594:	48 8d 3d a4 43 9c ff 	lea    -0x63bc5c(%rip),%rdi        # 2493f <anon.fc7a94f9b2531d69817906392dce0d0f.32.llvm.8356244060496160781+0x250>
  66059b:	48 8d 15 be e3 11 00 	lea    0x11e3be(%rip),%rdx        # 77e960 <__frame_dummy_init_array_entry+0x110>
  6605a2:	be 4c 01 00 00       	mov    $0x14c,%esi
  6605a7:	ff 15 13 92 12 00    	call   *0x129213(%rip)        # 7897c0 <_DYNAMIC+0x298>
