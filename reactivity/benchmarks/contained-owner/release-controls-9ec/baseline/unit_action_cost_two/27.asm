
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000074c7e0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>>:
  74c7e0:	55                   	push   %rbp
  74c7e1:	41 57                	push   %r15
  74c7e3:	41 56                	push   %r14
  74c7e5:	41 55                	push   %r13
  74c7e7:	41 54                	push   %r12
  74c7e9:	53                   	push   %rbx
  74c7ea:	48 81 ec 68 01 00 00 	sub    $0x168,%rsp
  74c7f1:	48 89 f3             	mov    %rsi,%rbx
  74c7f4:	49 89 ff             	mov    %rdi,%r15
  74c7f7:	49 c7 c4 68 f3 ff ff 	mov    $0xfffffffffffff368,%r12
  74c7fe:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  74c805:	00 00 
  74c807:	4d 01 e6             	add    %r12,%r14
  74c80a:	64 41 80 bc 24 10 0c 	cmpb   $0x0,%fs:0xc10(%r12)
  74c811:	00 00 00 
  74c814:	0f 84 59 05 00 00    	je     74cd73 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x593>
  74c81a:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  74c820:	0f 85 73 05 00 00    	jne    74cd99 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x5b9>
  74c826:	64 49 c7 04 24 ff ff 	movq   $0xffffffffffffffff,%fs:(%r12)
  74c82d:	ff ff 
  74c82f:	64 41 8b 84 24 08 0c 	mov    %fs:0xc08(%r12),%eax
  74c836:	00 00 
  74c838:	ff c0                	inc    %eax
  74c83a:	64 41 89 84 24 08 0c 	mov    %eax,%fs:0xc08(%r12)
  74c841:	00 00 
  74c843:	83 f8 40             	cmp    $0x40,%eax
  74c846:	0f 83 5a 05 00 00    	jae    74cda6 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x5c6>
  74c84c:	89 c0                	mov    %eax,%eax
  74c84e:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  74c852:	48 c1 e0 04          	shl    $0x4,%rax
  74c856:	0f 57 c0             	xorps  %xmm0,%xmm0
  74c859:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  74c85f:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  74c865:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  74c86b:	64 49 c7 04 24 00 00 	movq   $0x0,%fs:(%r12)
  74c872:	00 00 
  74c874:	0f 28 05 55 dc 90 ff 	movaps -0x6f23ab(%rip),%xmm0        # 5a4d0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x860>
  74c87b:	0f 29 84 24 50 01 00 	movaps %xmm0,0x150(%rsp)
  74c882:	00 
  74c883:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
  74c88a:	00 
  74c88b:	0f 29 84 24 30 01 00 	movaps %xmm0,0x130(%rsp)
  74c892:	00 
  74c893:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  74c89a:	00 
  74c89b:	0f 29 84 24 10 01 00 	movaps %xmm0,0x110(%rsp)
  74c8a2:	00 
  74c8a3:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  74c8aa:	00 
  74c8ab:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  74c8b2:	00 
  74c8b3:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  74c8ba:	00 
  74c8bb:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  74c8c2:	00 
  74c8c3:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  74c8ca:	00 
  74c8cb:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  74c8d2:	00 
  74c8d3:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  74c8da:	00 
  74c8db:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  74c8e2:	00 
  74c8e3:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  74c8ea:	00 
  74c8eb:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  74c8f0:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  74c8f5:	c7 84 24 60 01 00 00 	movl   $0x0,0x160(%rsp)
  74c8fc:	00 00 00 00 
  74c900:	48 b8 80 02 00 00 e0 	movabs $0x1e000000280,%rax
  74c907:	01 00 00 
  74c90a:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  74c90f:	c7 44 24 48 00 00 00 	movl   $0x0,0x48(%rsp)
  74c916:	00 
  74c917:	c7 44 24 50 00 00 4b 	movl   $0x434b0000,0x50(%rsp)
  74c91e:	43 
  74c91f:	66 c7 44 24 54 00 00 	movw   $0x0,0x54(%rsp)
  74c926:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  74c92b:	48 8d 74 24 60       	lea    0x60(%rsp),%rsi
  74c930:	48 8d 54 24 48       	lea    0x48(%rsp),%rdx
  74c935:	f3 0f 10 05 7b cb 90 	movss  -0x6f3485(%rip),%xmm0        # 594b8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.312.llvm.6319143315422321905+0x38>
  74c93c:	ff 
  74c93d:	b9 01 00 00 00       	mov    $0x1,%ecx
  74c942:	45 31 c0             	xor    %r8d,%r8d
  74c945:	e8 96 ce fb ff       	call   7097e0 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::mount_lanes>
  74c94a:	83 7c 24 10 fe       	cmpl   $0xfffffffe,0x10(%rsp)
  74c94f:	0f 85 6c 04 00 00    	jne    74cdc1 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x5e1>
  74c955:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  74c95a:	48 83 3b 00          	cmpq   $0x0,(%rbx)
  74c95e:	0f 84 e0 03 00 00    	je     74cd44 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x564>
  74c964:	4c 8b 73 08          	mov    0x8(%rbx),%r14
  74c968:	4d 85 f6             	test   %r14,%r14
  74c96b:	0f 84 d3 03 00 00    	je     74cd44 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x564>
  74c971:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  74c976:	4d 8d a6 40 02 00 00 	lea    0x240(%r14),%r12
  74c97d:	4c 89 e7             	mov    %r12,%rdi
  74c980:	e8 4b 5d ff ff       	call   7426d0 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>> as core::ops::drop::Drop>::drop>
  74c985:	49 8b 34 24          	mov    (%r12),%rsi
  74c989:	48 85 f6             	test   %rsi,%rsi
  74c98c:	74 16                	je     74c9a4 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x1c4>
  74c98e:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  74c995:	48 c1 e6 04          	shl    $0x4,%rsi
  74c999:	ba 08 00 00 00       	mov    $0x8,%edx
  74c99e:	ff 15 5c b5 3d 00    	call   *0x3db55c(%rip)        # b27f00 <_DYNAMIC+0x248>
  74c9a4:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  74c9ab:	48 85 f6             	test   %rsi,%rsi
  74c9ae:	74 16                	je     74c9c6 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x1e6>
  74c9b0:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  74c9b7:	48 c1 e6 03          	shl    $0x3,%rsi
  74c9bb:	ba 08 00 00 00       	mov    $0x8,%edx
  74c9c0:	ff 15 3a b5 3d 00    	call   *0x3db53a(%rip)        # b27f00 <_DYNAMIC+0x248>
  74c9c6:	4d 8d a6 70 02 00 00 	lea    0x270(%r14),%r12
  74c9cd:	4c 89 e7             	mov    %r12,%rdi
  74c9d0:	e8 fb 5c ff ff       	call   7426d0 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>> as core::ops::drop::Drop>::drop>
  74c9d5:	49 8b 34 24          	mov    (%r12),%rsi
  74c9d9:	48 85 f6             	test   %rsi,%rsi
  74c9dc:	74 16                	je     74c9f4 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x214>
  74c9de:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  74c9e5:	48 c1 e6 04          	shl    $0x4,%rsi
  74c9e9:	ba 08 00 00 00       	mov    $0x8,%edx
  74c9ee:	ff 15 0c b5 3d 00    	call   *0x3db50c(%rip)        # b27f00 <_DYNAMIC+0x248>
  74c9f4:	4d 8d a6 90 02 00 00 	lea    0x290(%r14),%r12
  74c9fb:	4c 89 e7             	mov    %r12,%rdi
  74c9fe:	e8 ed 5f ff ff       	call   7429f0 <<alloc::vec::Vec<gpui::runtime::Node> as core::ops::drop::Drop>::drop>
  74ca03:	49 8b 04 24          	mov    (%r12),%rax
  74ca07:	48 85 c0             	test   %rax,%rax
  74ca0a:	74 1a                	je     74ca26 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x246>
  74ca0c:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  74ca13:	48 c1 e0 03          	shl    $0x3,%rax
  74ca17:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74ca1b:	ba 08 00 00 00       	mov    $0x8,%edx
  74ca20:	ff 15 da b4 3d 00    	call   *0x3db4da(%rip)        # b27f00 <_DYNAMIC+0x248>
  74ca26:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  74ca2d:	e8 0e 2d 00 00       	call   74f740 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  74ca32:	4d 8d a6 a8 02 00 00 	lea    0x2a8(%r14),%r12
  74ca39:	4c 89 e7             	mov    %r12,%rdi
  74ca3c:	e8 1f 5e ff ff       	call   742860 <<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>> as core::ops::drop::Drop>::drop>
  74ca41:	49 8b 04 24          	mov    (%r12),%rax
  74ca45:	48 85 c0             	test   %rax,%rax
  74ca48:	74 1a                	je     74ca64 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x284>
  74ca4a:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  74ca51:	48 c1 e0 04          	shl    $0x4,%rax
  74ca55:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74ca59:	ba 08 00 00 00       	mov    $0x8,%edx
  74ca5e:	ff 15 9c b4 3d 00    	call   *0x3db49c(%rip)        # b27f00 <_DYNAMIC+0x248>
  74ca64:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  74ca6b:	e8 00 12 00 00       	call   74dc70 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  74ca70:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  74ca77:	48 85 c0             	test   %rax,%rax
  74ca7a:	74 49                	je     74cac5 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2e5>
  74ca7c:	83 f8 01             	cmp    $0x1,%eax
  74ca7f:	75 1e                	jne    74ca9f <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2bf>
  74ca81:	49 8b b6 f8 01 00 00 	mov    0x1f8(%r14),%rsi
  74ca88:	48 85 f6             	test   %rsi,%rsi
  74ca8b:	74 38                	je     74cac5 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2e5>
  74ca8d:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  74ca94:	48 c1 e6 04          	shl    $0x4,%rsi
  74ca98:	ba 08 00 00 00       	mov    $0x8,%edx
  74ca9d:	eb 20                	jmp    74cabf <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2df>
  74ca9f:	49 8b 86 f8 01 00 00 	mov    0x1f8(%r14),%rax
  74caa6:	48 85 c0             	test   %rax,%rax
  74caa9:	74 1a                	je     74cac5 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2e5>
  74caab:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  74cab2:	48 c1 e0 02          	shl    $0x2,%rax
  74cab6:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  74caba:	ba 04 00 00 00       	mov    $0x4,%edx
  74cabf:	ff 15 3b b4 3d 00    	call   *0x3db43b(%rip)        # b27f00 <_DYNAMIC+0x248>
  74cac5:	49 8b 8e c8 05 00 00 	mov    0x5c8(%r14),%rcx
  74cacc:	48 85 c9             	test   %rcx,%rcx
  74cacf:	74 44                	je     74cb15 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x335>
  74cad1:	49 8b 96 d0 05 00 00 	mov    0x5d0(%r14),%rdx
  74cad8:	49 8b 86 d8 05 00 00 	mov    0x5d8(%r14),%rax
  74cadf:	48 c7 44 24 68 00 00 	movq   $0x0,0x68(%rsp)
  74cae6:	00 00 
  74cae8:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  74caed:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
  74caf2:	48 c7 84 24 88 00 00 	movq   $0x0,0x88(%rsp)
  74caf9:	00 00 00 00 00 
  74cafe:	48 89 8c 24 90 00 00 	mov    %rcx,0x90(%rsp)
  74cb05:	00 
  74cb06:	48 89 94 24 98 00 00 	mov    %rdx,0x98(%rsp)
  74cb0d:	00 
  74cb0e:	b9 01 00 00 00       	mov    $0x1,%ecx
  74cb13:	eb 04                	jmp    74cb19 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x339>
  74cb15:	31 c9                	xor    %ecx,%ecx
  74cb17:	31 c0                	xor    %eax,%eax
  74cb19:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  74cb1e:	48 89 8c 24 80 00 00 	mov    %rcx,0x80(%rsp)
  74cb25:	00 
  74cb26:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  74cb2d:	00 
  74cb2e:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  74cb33:	48 8d 74 24 60       	lea    0x60(%rsp),%rsi
  74cb38:	e8 23 81 ff ff       	call   744c60 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  74cb3d:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  74cb42:	48 85 c0             	test   %rax,%rax
  74cb45:	74 58                	je     74cb9f <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x3bf>
  74cb47:	4c 8d 64 24 10       	lea    0x10(%rsp),%r12
  74cb4c:	4c 8d 6c 24 60       	lea    0x60(%rsp),%r13
  74cb51:	48 8b 2d a8 b3 3d 00 	mov    0x3db3a8(%rip),%rbp        # b27f00 <_DYNAMIC+0x248>
  74cb58:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  74cb5f:	00 
  74cb60:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  74cb65:	48 c1 e1 05          	shl    $0x5,%rcx
  74cb69:	48 8b 34 08          	mov    (%rax,%rcx,1),%rsi
  74cb6d:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  74cb71:	74 17                	je     74cb8a <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x3aa>
  74cb73:	48 85 f6             	test   %rsi,%rsi
  74cb76:	74 12                	je     74cb8a <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x3aa>
  74cb78:	48 01 c8             	add    %rcx,%rax
  74cb7b:	48 8b 78 08          	mov    0x8(%rax),%rdi
  74cb7f:	48 c1 e6 02          	shl    $0x2,%rsi
  74cb83:	ba 04 00 00 00       	mov    $0x4,%edx
  74cb88:	ff d5                	call   *%rbp
  74cb8a:	4c 89 e7             	mov    %r12,%rdi
  74cb8d:	4c 89 ee             	mov    %r13,%rsi
  74cb90:	e8 cb 80 ff ff       	call   744c60 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  74cb95:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  74cb9a:	48 85 c0             	test   %rax,%rax
  74cb9d:	75 c1                	jne    74cb60 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x380>
  74cb9f:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  74cba6:	e8 d5 af ff ff       	call   747b80 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  74cbab:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  74cbb2:	e8 59 14 00 00       	call   74e010 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  74cbb7:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  74cbbe:	e8 ed 9f ff ff       	call   746bb0 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  74cbc3:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  74cbca:	e8 51 a3 ff ff       	call   746f20 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  74cbcf:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  74cbd6:	e8 85 1f 00 00       	call   74eb60 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  74cbdb:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  74cbe2:	48 85 f6             	test   %rsi,%rsi
  74cbe5:	74 16                	je     74cbfd <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x41d>
  74cbe7:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  74cbee:	48 c1 e6 04          	shl    $0x4,%rsi
  74cbf2:	ba 08 00 00 00       	mov    $0x8,%edx
  74cbf7:	ff 15 03 b3 3d 00    	call   *0x3db303(%rip)        # b27f00 <_DYNAMIC+0x248>
  74cbfd:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  74cc04:	e8 27 94 ff ff       	call   746030 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  74cc09:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74cc10:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  74cc14:	0f 84 7e 00 00 00    	je     74cc98 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4b8>
  74cc1a:	4d 8b a6 98 05 00 00 	mov    0x598(%r14),%r12
  74cc21:	4d 85 e4             	test   %r12,%r12
  74cc24:	74 53                	je     74cc79 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x499>
  74cc26:	4d 8b ae 90 05 00 00 	mov    0x590(%r14),%r13
  74cc2d:	49 83 c5 78          	add    $0x78,%r13
  74cc31:	48 8b 2d 00 b3 3d 00 	mov    0x3db300(%rip),%rbp        # b27f38 <_DYNAMIC+0x280>
  74cc38:	eb 0f                	jmp    74cc49 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x469>
  74cc3a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  74cc40:	49 83 c5 50          	add    $0x50,%r13
  74cc44:	49 ff cc             	dec    %r12
  74cc47:	74 29                	je     74cc72 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x492>
  74cc49:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  74cc4d:	48 85 ff             	test   %rdi,%rdi
  74cc50:	74 ee                	je     74cc40 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74cc52:	f6 07 01             	testb  $0x1,(%rdi)
  74cc55:	75 e9                	jne    74cc40 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74cc57:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74cc5b:	a8 01                	test   $0x1,%al
  74cc5d:	75 e1                	jne    74cc40 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74cc5f:	48 8d 47 08          	lea    0x8(%rdi),%rax
  74cc63:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  74cc68:	75 d6                	jne    74cc40 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74cc6a:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74cc6e:	ff d5                	call   *%rbp
  74cc70:	eb ce                	jmp    74cc40 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74cc72:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74cc79:	48 85 c0             	test   %rax,%rax
  74cc7c:	74 1a                	je     74cc98 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4b8>
  74cc7e:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  74cc85:	48 c1 e0 04          	shl    $0x4,%rax
  74cc89:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74cc8d:	ba 08 00 00 00       	mov    $0x8,%edx
  74cc92:	ff 15 68 b2 3d 00    	call   *0x3db268(%rip)        # b27f00 <_DYNAMIC+0x248>
  74cc98:	4d 8b a6 80 05 00 00 	mov    0x580(%r14),%r12
  74cc9f:	4d 85 e4             	test   %r12,%r12
  74cca2:	74 4e                	je     74ccf2 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x512>
  74cca4:	4d 8b ae 78 05 00 00 	mov    0x578(%r14),%r13
  74ccab:	49 83 c5 78          	add    $0x78,%r13
  74ccaf:	48 8b 2d 82 b2 3d 00 	mov    0x3db282(%rip),%rbp        # b27f38 <_DYNAMIC+0x280>
  74ccb6:	eb 11                	jmp    74ccc9 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e9>
  74ccb8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  74ccbf:	00 
  74ccc0:	49 83 c5 50          	add    $0x50,%r13
  74ccc4:	49 ff cc             	dec    %r12
  74ccc7:	74 29                	je     74ccf2 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x512>
  74ccc9:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  74cccd:	48 85 ff             	test   %rdi,%rdi
  74ccd0:	74 ee                	je     74ccc0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74ccd2:	f6 07 01             	testb  $0x1,(%rdi)
  74ccd5:	75 e9                	jne    74ccc0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74ccd7:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74ccdb:	a8 01                	test   $0x1,%al
  74ccdd:	75 e1                	jne    74ccc0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74ccdf:	48 8d 47 08          	lea    0x8(%rdi),%rax
  74cce3:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  74cce8:	75 d6                	jne    74ccc0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74ccea:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74ccee:	ff d5                	call   *%rbp
  74ccf0:	eb ce                	jmp    74ccc0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74ccf2:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  74ccf9:	48 85 c0             	test   %rax,%rax
  74ccfc:	74 1a                	je     74cd18 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x538>
  74ccfe:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  74cd05:	48 c1 e0 04          	shl    $0x4,%rax
  74cd09:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74cd0d:	ba 08 00 00 00       	mov    $0x8,%edx
  74cd12:	ff 15 e8 b1 3d 00    	call   *0x3db1e8(%rip)        # b27f00 <_DYNAMIC+0x248>
  74cd18:	4c 89 f7             	mov    %r14,%rdi
  74cd1b:	e8 f0 23 00 00       	call   74f110 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  74cd20:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  74cd27:	e8 04 0d 00 00       	call   74da30 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  74cd2c:	be 28 08 00 00       	mov    $0x828,%esi
  74cd31:	ba 08 00 00 00       	mov    $0x8,%edx
  74cd36:	4c 89 f7             	mov    %r14,%rdi
  74cd39:	ff 15 c1 b1 3d 00    	call   *0x3db1c1(%rip)        # b27f00 <_DYNAMIC+0x248>
  74cd3f:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  74cd44:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  74cd4b:	48 89 43 08          	mov    %rax,0x8(%rbx)
  74cd4f:	48 8d 35 32 db 3a 00 	lea    0x3adb32(%rip),%rsi        # afa888 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166>
  74cd56:	4c 89 ff             	mov    %r15,%rdi
  74cd59:	e8 32 82 00 00       	call   754f90 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  74cd5e:	4c 89 f8             	mov    %r15,%rax
  74cd61:	48 81 c4 68 01 00 00 	add    $0x168,%rsp
  74cd68:	5b                   	pop    %rbx
  74cd69:	41 5c                	pop    %r12
  74cd6b:	41 5d                	pop    %r13
  74cd6d:	41 5e                	pop    %r14
  74cd6f:	41 5f                	pop    %r15
  74cd71:	5d                   	pop    %rbp
  74cd72:	c3                   	ret
  74cd73:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  74cd78:	4c 89 f7             	mov    %r14,%rdi
  74cd7b:	31 f6                	xor    %esi,%esi
  74cd7d:	ff 15 d5 b6 3d 00    	call   *0x3db6d5(%rip)        # b28458 <memset@GLIBC_2.2.5>
  74cd83:	64 41 c6 84 24 10 0c 	movb   $0x1,%fs:0xc10(%r12)
  74cd8a:	00 00 01 
  74cd8d:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  74cd93:	0f 84 8d fa ff ff    	je     74c826 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x46>
  74cd99:	48 8d 3d a0 de 3a 00 	lea    0x3adea0(%rip),%rdi        # afac40 <anon.cf030bdcd33bba1955553babc00e59a7.15.llvm.15067004318175258651>
  74cda0:	ff 15 ba b6 3d 00    	call   *0x3db6ba(%rip)        # b28460 <_DYNAMIC+0x7a8>
  74cda6:	48 8d 3d ff e2 91 ff 	lea    -0x6e1d01(%rip),%rdi        # 6b0ac <anon.cf030bdcd33bba1955553babc00e59a7.12.llvm.15067004318175258651>
  74cdad:	48 8d 15 74 de 3a 00 	lea    0x3ade74(%rip),%rdx        # afac28 <anon.cf030bdcd33bba1955553babc00e59a7.14.llvm.15067004318175258651>
  74cdb4:	be 4b 00 00 00       	mov    $0x4b,%esi
  74cdb9:	ff 15 31 b3 3d 00    	call   *0x3db331(%rip)        # b280f0 <_DYNAMIC+0x438>
  74cdbf:	eb 53                	jmp    74ce14 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x634>
  74cdc1:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  74cdc6:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  74cdcd:	00 
  74cdce:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  74cdd3:	0f 10 4c 24 20       	movups 0x20(%rsp),%xmm1
  74cdd8:	0f 10 54 24 30       	movups 0x30(%rsp),%xmm2
  74cddd:	0f 29 94 24 80 00 00 	movaps %xmm2,0x80(%rsp)
  74cde4:	00 
  74cde5:	0f 29 4c 24 70       	movaps %xmm1,0x70(%rsp)
  74cdea:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  74cdef:	48 8d 3d 5e df 91 ff 	lea    -0x6e20a2(%rip),%rdi        # 6ad54 <anon.2d1f820267f84878e0cbda50021465a1.8.llvm.17676285964678017166>
  74cdf6:	48 8d 0d f3 da 3a 00 	lea    0x3adaf3(%rip),%rcx        # afa8f0 <anon.2d1f820267f84878e0cbda50021465a1.7.llvm.17676285964678017166>
  74cdfd:	4c 8d 05 bc da 3a 00 	lea    0x3adabc(%rip),%r8        # afa8c0 <anon.2d1f820267f84878e0cbda50021465a1.3.llvm.17676285964678017166+0x18>
  74ce04:	48 8d 54 24 60       	lea    0x60(%rsp),%rdx
  74ce09:	be 2b 00 00 00       	mov    $0x2b,%esi
  74ce0e:	ff 15 f4 b1 3d 00    	call   *0x3db1f4(%rip)        # b28008 <_DYNAMIC+0x350>
  74ce14:	0f 0b                	ud2
  74ce16:	49 89 c7             	mov    %rax,%r15
  74ce19:	49 ff cc             	dec    %r12
  74ce1c:	74 0f                	je     74ce2d <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x64d>
  74ce1e:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  74ce22:	49 83 c5 50          	add    $0x50,%r13
  74ce26:	e8 95 3b ff ff       	call   7409c0 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  74ce2b:	eb ec                	jmp    74ce19 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x639>
  74ce2d:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74ce34:	48 85 c0             	test   %rax,%rax
  74ce37:	0f 84 59 02 00 00    	je     74d096 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8b6>
  74ce3d:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  74ce44:	48 c1 e0 04          	shl    $0x4,%rax
  74ce48:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74ce4c:	ba 08 00 00 00       	mov    $0x8,%edx
  74ce51:	ff 15 a9 b0 3d 00    	call   *0x3db0a9(%rip)        # b27f00 <_DYNAMIC+0x248>
  74ce57:	e9 3a 02 00 00       	jmp    74d096 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8b6>
  74ce5c:	ff 15 ce b0 3d 00    	call   *0x3db0ce(%rip)        # b27f30 <_DYNAMIC+0x278>
  74ce62:	49 89 c7             	mov    %rax,%r15
  74ce65:	49 ff cc             	dec    %r12
  74ce68:	74 0f                	je     74ce79 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x699>
  74ce6a:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  74ce6e:	49 83 c5 50          	add    $0x50,%r13
  74ce72:	e8 49 3b ff ff       	call   7409c0 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  74ce77:	eb ec                	jmp    74ce65 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x685>
  74ce79:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  74ce80:	48 85 c0             	test   %rax,%rax
  74ce83:	0f 84 19 02 00 00    	je     74d0a2 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8c2>
  74ce89:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  74ce90:	48 c1 e0 04          	shl    $0x4,%rax
  74ce94:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74ce98:	ba 08 00 00 00       	mov    $0x8,%edx
  74ce9d:	ff 15 5d b0 3d 00    	call   *0x3db05d(%rip)        # b27f00 <_DYNAMIC+0x248>
  74cea3:	e9 fa 01 00 00       	jmp    74d0a2 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8c2>
  74cea8:	ff 15 82 b0 3d 00    	call   *0x3db082(%rip)        # b27f30 <_DYNAMIC+0x278>
  74ceae:	49 89 c7             	mov    %rax,%r15
  74ceb1:	e9 00 02 00 00       	jmp    74d0b6 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8d6>
  74ceb6:	49 89 c7             	mov    %rax,%r15
  74ceb9:	e9 ec 01 00 00       	jmp    74d0aa <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8ca>
  74cebe:	49 89 c7             	mov    %rax,%r15
  74cec1:	e9 c4 01 00 00       	jmp    74d08a <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8aa>
  74cec6:	49 89 c7             	mov    %rax,%r15
  74cec9:	e9 8e 01 00 00       	jmp    74d05c <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x87c>
  74cece:	49 89 c7             	mov    %rax,%r15
  74ced1:	e9 7a 01 00 00       	jmp    74d050 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x870>
  74ced6:	49 89 c7             	mov    %rax,%r15
  74ced9:	e9 66 01 00 00       	jmp    74d044 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x864>
  74cede:	49 89 c7             	mov    %rax,%r15
  74cee1:	e9 52 01 00 00       	jmp    74d038 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x858>
  74cee6:	49 89 c7             	mov    %rax,%r15
  74cee9:	e9 3e 01 00 00       	jmp    74d02c <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x84c>
  74ceee:	e9 2a 01 00 00       	jmp    74d01d <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x83d>
  74cef3:	49 89 c7             	mov    %rax,%r15
  74cef6:	e9 02 01 00 00       	jmp    74cffd <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x81d>
  74cefb:	49 89 c7             	mov    %rax,%r15
  74cefe:	49 8b 04 24          	mov    (%r12),%rax
  74cf02:	48 85 c0             	test   %rax,%rax
  74cf05:	0f 84 e6 00 00 00    	je     74cff1 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x811>
  74cf0b:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  74cf12:	48 c1 e0 04          	shl    $0x4,%rax
  74cf16:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74cf1a:	ba 08 00 00 00       	mov    $0x8,%edx
  74cf1f:	ff 15 db af 3d 00    	call   *0x3dafdb(%rip)        # b27f00 <_DYNAMIC+0x248>
  74cf25:	e9 c7 00 00 00       	jmp    74cff1 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x811>
  74cf2a:	49 89 c7             	mov    %rax,%r15
  74cf2d:	49 8b 04 24          	mov    (%r12),%rax
  74cf31:	48 85 c0             	test   %rax,%rax
  74cf34:	0f 84 9f 00 00 00    	je     74cfd9 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7f9>
  74cf3a:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  74cf41:	48 c1 e0 03          	shl    $0x3,%rax
  74cf45:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74cf49:	ba 08 00 00 00       	mov    $0x8,%edx
  74cf4e:	ff 15 ac af 3d 00    	call   *0x3dafac(%rip)        # b27f00 <_DYNAMIC+0x248>
  74cf54:	e9 80 00 00 00       	jmp    74cfd9 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7f9>
  74cf59:	49 89 c7             	mov    %rax,%r15
  74cf5c:	49 8b 34 24          	mov    (%r12),%rsi
  74cf60:	48 85 f6             	test   %rsi,%rsi
  74cf63:	74 68                	je     74cfcd <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7ed>
  74cf65:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  74cf6c:	48 c1 e6 04          	shl    $0x4,%rsi
  74cf70:	ba 08 00 00 00       	mov    $0x8,%edx
  74cf75:	ff 15 85 af 3d 00    	call   *0x3daf85(%rip)        # b27f00 <_DYNAMIC+0x248>
  74cf7b:	eb 50                	jmp    74cfcd <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7ed>
  74cf7d:	49 89 c7             	mov    %rax,%r15
  74cf80:	49 8b 34 24          	mov    (%r12),%rsi
  74cf84:	48 85 f6             	test   %rsi,%rsi
  74cf87:	74 16                	je     74cf9f <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7bf>
  74cf89:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  74cf90:	48 c1 e6 04          	shl    $0x4,%rsi
  74cf94:	ba 08 00 00 00       	mov    $0x8,%edx
  74cf99:	ff 15 61 af 3d 00    	call   *0x3daf61(%rip)        # b27f00 <_DYNAMIC+0x248>
  74cf9f:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  74cfa6:	48 85 f6             	test   %rsi,%rsi
  74cfa9:	74 16                	je     74cfc1 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7e1>
  74cfab:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  74cfb2:	48 c1 e6 03          	shl    $0x3,%rsi
  74cfb6:	ba 08 00 00 00       	mov    $0x8,%edx
  74cfbb:	ff 15 3f af 3d 00    	call   *0x3daf3f(%rip)        # b27f00 <_DYNAMIC+0x248>
  74cfc1:	49 8d be 70 02 00 00 	lea    0x270(%r14),%rdi
  74cfc8:	e8 b3 14 00 00       	call   74e480 <core::ptr::drop_glue::<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>>>>
  74cfcd:	49 8d be 90 02 00 00 	lea    0x290(%r14),%rdi
  74cfd4:	e8 f7 16 00 00       	call   74e6d0 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Node>>>
  74cfd9:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  74cfe0:	e8 5b 27 00 00       	call   74f740 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  74cfe5:	49 8d be a8 02 00 00 	lea    0x2a8(%r14),%rdi
  74cfec:	e8 1f 14 00 00       	call   74e410 <core::ptr::drop_glue::<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>>>>
  74cff1:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  74cff8:	e8 73 0c 00 00       	call   74dc70 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  74cffd:	49 8d be e8 01 00 00 	lea    0x1e8(%r14),%rdi
  74d004:	e8 37 26 00 00       	call   74f640 <core::ptr::drop_glue::<gpui::runtime::identity_index::IdentityIndex>>
  74d009:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  74d010:	e8 0b 94 ff ff       	call   746420 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout> as core::ops::drop::Drop>::drop>
  74d015:	eb 09                	jmp    74d020 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x840>
  74d017:	ff 15 13 af 3d 00    	call   *0x3daf13(%rip)        # b27f30 <_DYNAMIC+0x278>
  74d01d:	49 89 c7             	mov    %rax,%r15
  74d020:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  74d027:	e8 54 ab ff ff       	call   747b80 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  74d02c:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  74d033:	e8 d8 0f 00 00       	call   74e010 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  74d038:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  74d03f:	e8 6c 9b ff ff       	call   746bb0 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  74d044:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  74d04b:	e8 d0 9e ff ff       	call   746f20 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  74d050:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  74d057:	e8 04 1b 00 00       	call   74eb60 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  74d05c:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  74d063:	48 85 f6             	test   %rsi,%rsi
  74d066:	74 16                	je     74d07e <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x89e>
  74d068:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  74d06f:	48 c1 e6 04          	shl    $0x4,%rsi
  74d073:	ba 08 00 00 00       	mov    $0x8,%edx
  74d078:	ff 15 82 ae 3d 00    	call   *0x3dae82(%rip)        # b27f00 <_DYNAMIC+0x248>
  74d07e:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  74d085:	e8 a6 8f ff ff       	call   746030 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  74d08a:	49 8d be 88 05 00 00 	lea    0x588(%r14),%rdi
  74d091:	e8 9a 11 00 00       	call   74e230 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Prepared>>>
  74d096:	49 8d be 70 05 00 00 	lea    0x570(%r14),%rdi
  74d09d:	e8 9e 16 00 00       	call   74e740 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Presented>>>
  74d0a2:	4c 89 f7             	mov    %r14,%rdi
  74d0a5:	e8 66 20 00 00       	call   74f110 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  74d0aa:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  74d0b1:	e8 7a 09 00 00       	call   74da30 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  74d0b6:	be 28 08 00 00       	mov    $0x828,%esi
  74d0bb:	ba 08 00 00 00       	mov    $0x8,%edx
  74d0c0:	4c 89 f7             	mov    %r14,%rdi
  74d0c3:	ff 15 37 ae 3d 00    	call   *0x3dae37(%rip)        # b27f00 <_DYNAMIC+0x248>
  74d0c9:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  74d0d0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  74d0d5:	48 89 43 08          	mov    %rax,0x8(%rbx)
  74d0d9:	4c 89 ff             	mov    %r15,%rdi
  74d0dc:	e8 8f b0 3a 00       	call   af8170 <_Unwind_Resume@plt>
  74d0e1:	ff 15 49 ae 3d 00    	call   *0x3dae49(%rip)        # b27f30 <_DYNAMIC+0x278>
  74d0e7:	49 89 c7             	mov    %rax,%r15
  74d0ea:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  74d0ef:	e8 ac 23 00 00       	call   74f4a0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  74d0f4:	4c 89 ff             	mov    %r15,%rdi
  74d0f7:	e8 74 b0 3a 00       	call   af8170 <_Unwind_Resume@plt>
  74d0fc:	64 49 ff 04 24       	incq   %fs:(%r12)
  74d101:	48 89 c7             	mov    %rax,%rdi
  74d104:	e8 67 b0 3a 00       	call   af8170 <_Unwind_Resume@plt>
