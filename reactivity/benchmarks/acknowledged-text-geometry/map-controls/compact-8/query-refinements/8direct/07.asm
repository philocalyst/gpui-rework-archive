
/tmp/gpui-text-map-query-refinements/8direct/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000660590 <selection_queries::selected>:
  660590:	50                   	push   %rax
  660591:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  660598:	00 
  660599:	48 85 ff             	test   %rdi,%rdi
  66059c:	74 16                	je     6605b4 <selection_queries::selected+0x24>
  66059e:	48 83 c7 10          	add    $0x10,%rdi
  6605a2:	48 89 e2             	mov    %rsp,%rdx
  6605a5:	e8 a6 02 00 00       	call   660850 <<gpui_canvas::text::layout::TextGeometry>::selection_rects::<selection_queries::selected::{closure#0}>>
  6605aa:	84 c0                	test   %al,%al
  6605ac:	74 06                	je     6605b4 <selection_queries::selected+0x24>
  6605ae:	48 8b 04 24          	mov    (%rsp),%rax
  6605b2:	59                   	pop    %rcx
  6605b3:	c3                   	ret
  6605b4:	48 8d 3d 64 43 9c ff 	lea    -0x63bc9c(%rip),%rdi        # 2491f <anon.fc7a94f9b2531d69817906392dce0d0f.32.llvm.8356244060496160781+0x250>
  6605bb:	48 8d 15 0e e3 11 00 	lea    0x11e30e(%rip),%rdx        # 77e8d0 <__frame_dummy_init_array_entry+0x110>
  6605c2:	be 4c 01 00 00       	mov    $0x14c,%esi
  6605c7:	ff 15 33 91 12 00    	call   *0x129133(%rip)        # 789700 <_DYNAMIC+0x298>
