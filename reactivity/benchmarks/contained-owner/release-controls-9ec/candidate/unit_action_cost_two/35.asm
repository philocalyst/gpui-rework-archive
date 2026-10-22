
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000074dd20 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>>:
  74dd20:	55                   	push   %rbp
  74dd21:	41 57                	push   %r15
  74dd23:	41 56                	push   %r14
  74dd25:	41 55                	push   %r13
  74dd27:	41 54                	push   %r12
  74dd29:	53                   	push   %rbx
  74dd2a:	48 81 ec 68 01 00 00 	sub    $0x168,%rsp
  74dd31:	48 89 f3             	mov    %rsi,%rbx
  74dd34:	49 89 ff             	mov    %rdi,%r15
  74dd37:	49 c7 c4 68 f3 ff ff 	mov    $0xfffffffffffff368,%r12
  74dd3e:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  74dd45:	00 00 
  74dd47:	4d 01 e6             	add    %r12,%r14
  74dd4a:	64 41 80 bc 24 10 0c 	cmpb   $0x0,%fs:0xc10(%r12)
  74dd51:	00 00 00 
  74dd54:	0f 84 59 05 00 00    	je     74e2b3 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x593>
  74dd5a:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  74dd60:	0f 85 73 05 00 00    	jne    74e2d9 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x5b9>
  74dd66:	64 49 c7 04 24 ff ff 	movq   $0xffffffffffffffff,%fs:(%r12)
  74dd6d:	ff ff 
  74dd6f:	64 41 8b 84 24 08 0c 	mov    %fs:0xc08(%r12),%eax
  74dd76:	00 00 
  74dd78:	ff c0                	inc    %eax
  74dd7a:	64 41 89 84 24 08 0c 	mov    %eax,%fs:0xc08(%r12)
  74dd81:	00 00 
  74dd83:	83 f8 40             	cmp    $0x40,%eax
  74dd86:	0f 83 5a 05 00 00    	jae    74e2e6 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x5c6>
  74dd8c:	89 c0                	mov    %eax,%eax
  74dd8e:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  74dd92:	48 c1 e0 04          	shl    $0x4,%rax
  74dd96:	0f 57 c0             	xorps  %xmm0,%xmm0
  74dd99:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  74dd9f:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  74dda5:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  74ddab:	64 49 c7 04 24 00 00 	movq   $0x0,%fs:(%r12)
  74ddb2:	00 00 
  74ddb4:	0f 28 05 05 c9 90 ff 	movaps -0x6f36fb(%rip),%xmm0        # 5a6c0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x860>
  74ddbb:	0f 29 84 24 50 01 00 	movaps %xmm0,0x150(%rsp)
  74ddc2:	00 
  74ddc3:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
  74ddca:	00 
  74ddcb:	0f 29 84 24 30 01 00 	movaps %xmm0,0x130(%rsp)
  74ddd2:	00 
  74ddd3:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  74ddda:	00 
  74dddb:	0f 29 84 24 10 01 00 	movaps %xmm0,0x110(%rsp)
  74dde2:	00 
  74dde3:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  74ddea:	00 
  74ddeb:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  74ddf2:	00 
  74ddf3:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  74ddfa:	00 
  74ddfb:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  74de02:	00 
  74de03:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  74de0a:	00 
  74de0b:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  74de12:	00 
  74de13:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  74de1a:	00 
  74de1b:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  74de22:	00 
  74de23:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  74de2a:	00 
  74de2b:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  74de30:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  74de35:	c7 84 24 60 01 00 00 	movl   $0x0,0x160(%rsp)
  74de3c:	00 00 00 00 
  74de40:	48 b8 80 02 00 00 e0 	movabs $0x1e000000280,%rax
  74de47:	01 00 00 
  74de4a:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  74de4f:	c7 44 24 48 00 00 00 	movl   $0x0,0x48(%rsp)
  74de56:	00 
  74de57:	c7 44 24 50 00 00 4b 	movl   $0x434b0000,0x50(%rsp)
  74de5e:	43 
  74de5f:	66 c7 44 24 54 00 00 	movw   $0x0,0x54(%rsp)
  74de66:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  74de6b:	48 8d 74 24 60       	lea    0x60(%rsp),%rsi
  74de70:	48 8d 54 24 48       	lea    0x48(%rsp),%rdx
  74de75:	f3 0f 10 05 2b b8 90 	movss  -0x6f47d5(%rip),%xmm0        # 596a8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.312.llvm.6319143315422321905+0x38>
  74de7c:	ff 
  74de7d:	b9 01 00 00 00       	mov    $0x1,%ecx
  74de82:	45 31 c0             	xor    %r8d,%r8d
  74de85:	e8 b6 cc fb ff       	call   70ab40 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::mount_lanes>
  74de8a:	83 7c 24 10 fe       	cmpl   $0xfffffffe,0x10(%rsp)
  74de8f:	0f 85 6c 04 00 00    	jne    74e301 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x5e1>
  74de95:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  74de9a:	48 83 3b 00          	cmpq   $0x0,(%rbx)
  74de9e:	0f 84 e0 03 00 00    	je     74e284 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x564>
  74dea4:	4c 8b 73 08          	mov    0x8(%rbx),%r14
  74dea8:	4d 85 f6             	test   %r14,%r14
  74deab:	0f 84 d3 03 00 00    	je     74e284 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x564>
  74deb1:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  74deb6:	4d 8d a6 40 02 00 00 	lea    0x240(%r14),%r12
  74debd:	4c 89 e7             	mov    %r12,%rdi
  74dec0:	e8 4b 5d ff ff       	call   743c10 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>> as core::ops::drop::Drop>::drop>
  74dec5:	49 8b 34 24          	mov    (%r12),%rsi
  74dec9:	48 85 f6             	test   %rsi,%rsi
  74decc:	74 16                	je     74dee4 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x1c4>
  74dece:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  74ded5:	48 c1 e6 04          	shl    $0x4,%rsi
  74ded9:	ba 08 00 00 00       	mov    $0x8,%edx
  74dede:	ff 15 64 b4 3d 00    	call   *0x3db464(%rip)        # b29348 <_DYNAMIC+0x248>
  74dee4:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  74deeb:	48 85 f6             	test   %rsi,%rsi
  74deee:	74 16                	je     74df06 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x1e6>
  74def0:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  74def7:	48 c1 e6 03          	shl    $0x3,%rsi
  74defb:	ba 08 00 00 00       	mov    $0x8,%edx
  74df00:	ff 15 42 b4 3d 00    	call   *0x3db442(%rip)        # b29348 <_DYNAMIC+0x248>
  74df06:	4d 8d a6 70 02 00 00 	lea    0x270(%r14),%r12
  74df0d:	4c 89 e7             	mov    %r12,%rdi
  74df10:	e8 fb 5c ff ff       	call   743c10 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>> as core::ops::drop::Drop>::drop>
  74df15:	49 8b 34 24          	mov    (%r12),%rsi
  74df19:	48 85 f6             	test   %rsi,%rsi
  74df1c:	74 16                	je     74df34 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x214>
  74df1e:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  74df25:	48 c1 e6 04          	shl    $0x4,%rsi
  74df29:	ba 08 00 00 00       	mov    $0x8,%edx
  74df2e:	ff 15 14 b4 3d 00    	call   *0x3db414(%rip)        # b29348 <_DYNAMIC+0x248>
  74df34:	4d 8d a6 90 02 00 00 	lea    0x290(%r14),%r12
  74df3b:	4c 89 e7             	mov    %r12,%rdi
  74df3e:	e8 ed 5f ff ff       	call   743f30 <<alloc::vec::Vec<gpui::runtime::Node> as core::ops::drop::Drop>::drop>
  74df43:	49 8b 04 24          	mov    (%r12),%rax
  74df47:	48 85 c0             	test   %rax,%rax
  74df4a:	74 1a                	je     74df66 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x246>
  74df4c:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  74df53:	48 c1 e0 03          	shl    $0x3,%rax
  74df57:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74df5b:	ba 08 00 00 00       	mov    $0x8,%edx
  74df60:	ff 15 e2 b3 3d 00    	call   *0x3db3e2(%rip)        # b29348 <_DYNAMIC+0x248>
  74df66:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  74df6d:	e8 0e 2d 00 00       	call   750c80 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  74df72:	4d 8d a6 a8 02 00 00 	lea    0x2a8(%r14),%r12
  74df79:	4c 89 e7             	mov    %r12,%rdi
  74df7c:	e8 1f 5e ff ff       	call   743da0 <<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>> as core::ops::drop::Drop>::drop>
  74df81:	49 8b 04 24          	mov    (%r12),%rax
  74df85:	48 85 c0             	test   %rax,%rax
  74df88:	74 1a                	je     74dfa4 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x284>
  74df8a:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  74df91:	48 c1 e0 04          	shl    $0x4,%rax
  74df95:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74df99:	ba 08 00 00 00       	mov    $0x8,%edx
  74df9e:	ff 15 a4 b3 3d 00    	call   *0x3db3a4(%rip)        # b29348 <_DYNAMIC+0x248>
  74dfa4:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  74dfab:	e8 00 12 00 00       	call   74f1b0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  74dfb0:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  74dfb7:	48 85 c0             	test   %rax,%rax
  74dfba:	74 49                	je     74e005 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2e5>
  74dfbc:	83 f8 01             	cmp    $0x1,%eax
  74dfbf:	75 1e                	jne    74dfdf <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2bf>
  74dfc1:	49 8b b6 f8 01 00 00 	mov    0x1f8(%r14),%rsi
  74dfc8:	48 85 f6             	test   %rsi,%rsi
  74dfcb:	74 38                	je     74e005 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2e5>
  74dfcd:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  74dfd4:	48 c1 e6 04          	shl    $0x4,%rsi
  74dfd8:	ba 08 00 00 00       	mov    $0x8,%edx
  74dfdd:	eb 20                	jmp    74dfff <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2df>
  74dfdf:	49 8b 86 f8 01 00 00 	mov    0x1f8(%r14),%rax
  74dfe6:	48 85 c0             	test   %rax,%rax
  74dfe9:	74 1a                	je     74e005 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2e5>
  74dfeb:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  74dff2:	48 c1 e0 02          	shl    $0x2,%rax
  74dff6:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  74dffa:	ba 04 00 00 00       	mov    $0x4,%edx
  74dfff:	ff 15 43 b3 3d 00    	call   *0x3db343(%rip)        # b29348 <_DYNAMIC+0x248>
  74e005:	49 8b 8e c8 05 00 00 	mov    0x5c8(%r14),%rcx
  74e00c:	48 85 c9             	test   %rcx,%rcx
  74e00f:	74 44                	je     74e055 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x335>
  74e011:	49 8b 96 d0 05 00 00 	mov    0x5d0(%r14),%rdx
  74e018:	49 8b 86 d8 05 00 00 	mov    0x5d8(%r14),%rax
  74e01f:	48 c7 44 24 68 00 00 	movq   $0x0,0x68(%rsp)
  74e026:	00 00 
  74e028:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  74e02d:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
  74e032:	48 c7 84 24 88 00 00 	movq   $0x0,0x88(%rsp)
  74e039:	00 00 00 00 00 
  74e03e:	48 89 8c 24 90 00 00 	mov    %rcx,0x90(%rsp)
  74e045:	00 
  74e046:	48 89 94 24 98 00 00 	mov    %rdx,0x98(%rsp)
  74e04d:	00 
  74e04e:	b9 01 00 00 00       	mov    $0x1,%ecx
  74e053:	eb 04                	jmp    74e059 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x339>
  74e055:	31 c9                	xor    %ecx,%ecx
  74e057:	31 c0                	xor    %eax,%eax
  74e059:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  74e05e:	48 89 8c 24 80 00 00 	mov    %rcx,0x80(%rsp)
  74e065:	00 
  74e066:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  74e06d:	00 
  74e06e:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  74e073:	48 8d 74 24 60       	lea    0x60(%rsp),%rsi
  74e078:	e8 23 81 ff ff       	call   7461a0 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  74e07d:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  74e082:	48 85 c0             	test   %rax,%rax
  74e085:	74 58                	je     74e0df <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x3bf>
  74e087:	4c 8d 64 24 10       	lea    0x10(%rsp),%r12
  74e08c:	4c 8d 6c 24 60       	lea    0x60(%rsp),%r13
  74e091:	48 8b 2d b0 b2 3d 00 	mov    0x3db2b0(%rip),%rbp        # b29348 <_DYNAMIC+0x248>
  74e098:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  74e09f:	00 
  74e0a0:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  74e0a5:	48 c1 e1 05          	shl    $0x5,%rcx
  74e0a9:	48 8b 34 08          	mov    (%rax,%rcx,1),%rsi
  74e0ad:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  74e0b1:	74 17                	je     74e0ca <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x3aa>
  74e0b3:	48 85 f6             	test   %rsi,%rsi
  74e0b6:	74 12                	je     74e0ca <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x3aa>
  74e0b8:	48 01 c8             	add    %rcx,%rax
  74e0bb:	48 8b 78 08          	mov    0x8(%rax),%rdi
  74e0bf:	48 c1 e6 02          	shl    $0x2,%rsi
  74e0c3:	ba 04 00 00 00       	mov    $0x4,%edx
  74e0c8:	ff d5                	call   *%rbp
  74e0ca:	4c 89 e7             	mov    %r12,%rdi
  74e0cd:	4c 89 ee             	mov    %r13,%rsi
  74e0d0:	e8 cb 80 ff ff       	call   7461a0 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  74e0d5:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  74e0da:	48 85 c0             	test   %rax,%rax
  74e0dd:	75 c1                	jne    74e0a0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x380>
  74e0df:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  74e0e6:	e8 d5 af ff ff       	call   7490c0 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  74e0eb:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  74e0f2:	e8 59 14 00 00       	call   74f550 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  74e0f7:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  74e0fe:	e8 ed 9f ff ff       	call   7480f0 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  74e103:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  74e10a:	e8 51 a3 ff ff       	call   748460 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  74e10f:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  74e116:	e8 85 1f 00 00       	call   7500a0 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  74e11b:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  74e122:	48 85 f6             	test   %rsi,%rsi
  74e125:	74 16                	je     74e13d <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x41d>
  74e127:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  74e12e:	48 c1 e6 04          	shl    $0x4,%rsi
  74e132:	ba 08 00 00 00       	mov    $0x8,%edx
  74e137:	ff 15 0b b2 3d 00    	call   *0x3db20b(%rip)        # b29348 <_DYNAMIC+0x248>
  74e13d:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  74e144:	e8 27 94 ff ff       	call   747570 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  74e149:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74e150:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  74e154:	0f 84 7e 00 00 00    	je     74e1d8 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4b8>
  74e15a:	4d 8b a6 98 05 00 00 	mov    0x598(%r14),%r12
  74e161:	4d 85 e4             	test   %r12,%r12
  74e164:	74 53                	je     74e1b9 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x499>
  74e166:	4d 8b ae 90 05 00 00 	mov    0x590(%r14),%r13
  74e16d:	49 83 c5 78          	add    $0x78,%r13
  74e171:	48 8b 2d 08 b2 3d 00 	mov    0x3db208(%rip),%rbp        # b29380 <_DYNAMIC+0x280>
  74e178:	eb 0f                	jmp    74e189 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x469>
  74e17a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  74e180:	49 83 c5 50          	add    $0x50,%r13
  74e184:	49 ff cc             	dec    %r12
  74e187:	74 29                	je     74e1b2 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x492>
  74e189:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  74e18d:	48 85 ff             	test   %rdi,%rdi
  74e190:	74 ee                	je     74e180 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74e192:	f6 07 01             	testb  $0x1,(%rdi)
  74e195:	75 e9                	jne    74e180 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74e197:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74e19b:	a8 01                	test   $0x1,%al
  74e19d:	75 e1                	jne    74e180 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74e19f:	48 8d 47 08          	lea    0x8(%rdi),%rax
  74e1a3:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  74e1a8:	75 d6                	jne    74e180 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74e1aa:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74e1ae:	ff d5                	call   *%rbp
  74e1b0:	eb ce                	jmp    74e180 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74e1b2:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74e1b9:	48 85 c0             	test   %rax,%rax
  74e1bc:	74 1a                	je     74e1d8 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4b8>
  74e1be:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  74e1c5:	48 c1 e0 04          	shl    $0x4,%rax
  74e1c9:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e1cd:	ba 08 00 00 00       	mov    $0x8,%edx
  74e1d2:	ff 15 70 b1 3d 00    	call   *0x3db170(%rip)        # b29348 <_DYNAMIC+0x248>
  74e1d8:	4d 8b a6 80 05 00 00 	mov    0x580(%r14),%r12
  74e1df:	4d 85 e4             	test   %r12,%r12
  74e1e2:	74 4e                	je     74e232 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x512>
  74e1e4:	4d 8b ae 78 05 00 00 	mov    0x578(%r14),%r13
  74e1eb:	49 83 c5 78          	add    $0x78,%r13
  74e1ef:	48 8b 2d 8a b1 3d 00 	mov    0x3db18a(%rip),%rbp        # b29380 <_DYNAMIC+0x280>
  74e1f6:	eb 11                	jmp    74e209 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e9>
  74e1f8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  74e1ff:	00 
  74e200:	49 83 c5 50          	add    $0x50,%r13
  74e204:	49 ff cc             	dec    %r12
  74e207:	74 29                	je     74e232 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x512>
  74e209:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  74e20d:	48 85 ff             	test   %rdi,%rdi
  74e210:	74 ee                	je     74e200 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74e212:	f6 07 01             	testb  $0x1,(%rdi)
  74e215:	75 e9                	jne    74e200 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74e217:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74e21b:	a8 01                	test   $0x1,%al
  74e21d:	75 e1                	jne    74e200 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74e21f:	48 8d 47 08          	lea    0x8(%rdi),%rax
  74e223:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  74e228:	75 d6                	jne    74e200 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74e22a:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74e22e:	ff d5                	call   *%rbp
  74e230:	eb ce                	jmp    74e200 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74e232:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  74e239:	48 85 c0             	test   %rax,%rax
  74e23c:	74 1a                	je     74e258 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x538>
  74e23e:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  74e245:	48 c1 e0 04          	shl    $0x4,%rax
  74e249:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e24d:	ba 08 00 00 00       	mov    $0x8,%edx
  74e252:	ff 15 f0 b0 3d 00    	call   *0x3db0f0(%rip)        # b29348 <_DYNAMIC+0x248>
  74e258:	4c 89 f7             	mov    %r14,%rdi
  74e25b:	e8 f0 23 00 00       	call   750650 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  74e260:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  74e267:	e8 04 0d 00 00       	call   74ef70 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  74e26c:	be 28 08 00 00       	mov    $0x828,%esi
  74e271:	ba 08 00 00 00       	mov    $0x8,%edx
  74e276:	4c 89 f7             	mov    %r14,%rdi
  74e279:	ff 15 c9 b0 3d 00    	call   *0x3db0c9(%rip)        # b29348 <_DYNAMIC+0x248>
  74e27f:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  74e284:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  74e28b:	48 89 43 08          	mov    %rax,0x8(%rbx)
  74e28f:	48 8d 35 aa d9 3a 00 	lea    0x3ad9aa(%rip),%rsi        # afbc40 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166>
  74e296:	4c 89 ff             	mov    %r15,%rdi
  74e299:	e8 f2 ef 01 00       	call   76d290 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  74e29e:	4c 89 f8             	mov    %r15,%rax
  74e2a1:	48 81 c4 68 01 00 00 	add    $0x168,%rsp
  74e2a8:	5b                   	pop    %rbx
  74e2a9:	41 5c                	pop    %r12
  74e2ab:	41 5d                	pop    %r13
  74e2ad:	41 5e                	pop    %r14
  74e2af:	41 5f                	pop    %r15
  74e2b1:	5d                   	pop    %rbp
  74e2b2:	c3                   	ret
  74e2b3:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  74e2b8:	4c 89 f7             	mov    %r14,%rdi
  74e2bb:	31 f6                	xor    %esi,%esi
  74e2bd:	ff 15 ed b5 3d 00    	call   *0x3db5ed(%rip)        # b298b0 <memset@GLIBC_2.2.5>
  74e2c3:	64 41 c6 84 24 10 0c 	movb   $0x1,%fs:0xc10(%r12)
  74e2ca:	00 00 01 
  74e2cd:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  74e2d3:	0f 84 8d fa ff ff    	je     74dd66 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x46>
  74e2d9:	48 8d 3d 68 e6 3a 00 	lea    0x3ae668(%rip),%rdi        # afc948 <anon.547532fe00eaf98ca33efb65e1aed586.15.llvm.9042944481482549913>
  74e2e0:	ff 15 d2 b5 3d 00    	call   *0x3db5d2(%rip)        # b298b8 <_DYNAMIC+0x7b8>
  74e2e6:	48 8d 3d 83 db 91 ff 	lea    -0x6e247d(%rip),%rdi        # 6be70 <anon.547532fe00eaf98ca33efb65e1aed586.12.llvm.9042944481482549913>
  74e2ed:	48 8d 15 3c e6 3a 00 	lea    0x3ae63c(%rip),%rdx        # afc930 <anon.547532fe00eaf98ca33efb65e1aed586.14.llvm.9042944481482549913>
  74e2f4:	be 4b 00 00 00       	mov    $0x4b,%esi
  74e2f9:	ff 15 49 b2 3d 00    	call   *0x3db249(%rip)        # b29548 <_DYNAMIC+0x448>
  74e2ff:	eb 53                	jmp    74e354 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x634>
  74e301:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  74e306:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  74e30d:	00 
  74e30e:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  74e313:	0f 10 4c 24 20       	movups 0x20(%rsp),%xmm1
  74e318:	0f 10 54 24 30       	movups 0x30(%rsp),%xmm2
  74e31d:	0f 29 94 24 80 00 00 	movaps %xmm2,0x80(%rsp)
  74e324:	00 
  74e325:	0f 29 4c 24 70       	movaps %xmm1,0x70(%rsp)
  74e32a:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  74e32f:	48 8d 3d 1e cc 91 ff 	lea    -0x6e33e2(%rip),%rdi        # 6af54 <anon.2d1f820267f84878e0cbda50021465a1.8.llvm.17676285964678017166>
  74e336:	48 8d 0d 6b d9 3a 00 	lea    0x3ad96b(%rip),%rcx        # afbca8 <anon.2d1f820267f84878e0cbda50021465a1.7.llvm.17676285964678017166>
  74e33d:	4c 8d 05 34 d9 3a 00 	lea    0x3ad934(%rip),%r8        # afbc78 <anon.2d1f820267f84878e0cbda50021465a1.3.llvm.17676285964678017166+0x18>
  74e344:	48 8d 54 24 60       	lea    0x60(%rsp),%rdx
  74e349:	be 2b 00 00 00       	mov    $0x2b,%esi
  74e34e:	ff 15 fc b0 3d 00    	call   *0x3db0fc(%rip)        # b29450 <_DYNAMIC+0x350>
  74e354:	0f 0b                	ud2
  74e356:	49 89 c7             	mov    %rax,%r15
  74e359:	49 ff cc             	dec    %r12
  74e35c:	74 0f                	je     74e36d <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x64d>
  74e35e:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  74e362:	49 83 c5 50          	add    $0x50,%r13
  74e366:	e8 15 3a ff ff       	call   741d80 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  74e36b:	eb ec                	jmp    74e359 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x639>
  74e36d:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74e374:	48 85 c0             	test   %rax,%rax
  74e377:	0f 84 59 02 00 00    	je     74e5d6 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8b6>
  74e37d:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  74e384:	48 c1 e0 04          	shl    $0x4,%rax
  74e388:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e38c:	ba 08 00 00 00       	mov    $0x8,%edx
  74e391:	ff 15 b1 af 3d 00    	call   *0x3dafb1(%rip)        # b29348 <_DYNAMIC+0x248>
  74e397:	e9 3a 02 00 00       	jmp    74e5d6 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8b6>
  74e39c:	ff 15 d6 af 3d 00    	call   *0x3dafd6(%rip)        # b29378 <_DYNAMIC+0x278>
  74e3a2:	49 89 c7             	mov    %rax,%r15
  74e3a5:	49 ff cc             	dec    %r12
  74e3a8:	74 0f                	je     74e3b9 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x699>
  74e3aa:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  74e3ae:	49 83 c5 50          	add    $0x50,%r13
  74e3b2:	e8 c9 39 ff ff       	call   741d80 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  74e3b7:	eb ec                	jmp    74e3a5 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x685>
  74e3b9:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  74e3c0:	48 85 c0             	test   %rax,%rax
  74e3c3:	0f 84 19 02 00 00    	je     74e5e2 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8c2>
  74e3c9:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  74e3d0:	48 c1 e0 04          	shl    $0x4,%rax
  74e3d4:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e3d8:	ba 08 00 00 00       	mov    $0x8,%edx
  74e3dd:	ff 15 65 af 3d 00    	call   *0x3daf65(%rip)        # b29348 <_DYNAMIC+0x248>
  74e3e3:	e9 fa 01 00 00       	jmp    74e5e2 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8c2>
  74e3e8:	ff 15 8a af 3d 00    	call   *0x3daf8a(%rip)        # b29378 <_DYNAMIC+0x278>
  74e3ee:	49 89 c7             	mov    %rax,%r15
  74e3f1:	e9 00 02 00 00       	jmp    74e5f6 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8d6>
  74e3f6:	49 89 c7             	mov    %rax,%r15
  74e3f9:	e9 ec 01 00 00       	jmp    74e5ea <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8ca>
  74e3fe:	49 89 c7             	mov    %rax,%r15
  74e401:	e9 c4 01 00 00       	jmp    74e5ca <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8aa>
  74e406:	49 89 c7             	mov    %rax,%r15
  74e409:	e9 8e 01 00 00       	jmp    74e59c <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x87c>
  74e40e:	49 89 c7             	mov    %rax,%r15
  74e411:	e9 7a 01 00 00       	jmp    74e590 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x870>
  74e416:	49 89 c7             	mov    %rax,%r15
  74e419:	e9 66 01 00 00       	jmp    74e584 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x864>
  74e41e:	49 89 c7             	mov    %rax,%r15
  74e421:	e9 52 01 00 00       	jmp    74e578 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x858>
  74e426:	49 89 c7             	mov    %rax,%r15
  74e429:	e9 3e 01 00 00       	jmp    74e56c <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x84c>
  74e42e:	e9 2a 01 00 00       	jmp    74e55d <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x83d>
  74e433:	49 89 c7             	mov    %rax,%r15
  74e436:	e9 02 01 00 00       	jmp    74e53d <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x81d>
  74e43b:	49 89 c7             	mov    %rax,%r15
  74e43e:	49 8b 04 24          	mov    (%r12),%rax
  74e442:	48 85 c0             	test   %rax,%rax
  74e445:	0f 84 e6 00 00 00    	je     74e531 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x811>
  74e44b:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  74e452:	48 c1 e0 04          	shl    $0x4,%rax
  74e456:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e45a:	ba 08 00 00 00       	mov    $0x8,%edx
  74e45f:	ff 15 e3 ae 3d 00    	call   *0x3daee3(%rip)        # b29348 <_DYNAMIC+0x248>
  74e465:	e9 c7 00 00 00       	jmp    74e531 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x811>
  74e46a:	49 89 c7             	mov    %rax,%r15
  74e46d:	49 8b 04 24          	mov    (%r12),%rax
  74e471:	48 85 c0             	test   %rax,%rax
  74e474:	0f 84 9f 00 00 00    	je     74e519 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7f9>
  74e47a:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  74e481:	48 c1 e0 03          	shl    $0x3,%rax
  74e485:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e489:	ba 08 00 00 00       	mov    $0x8,%edx
  74e48e:	ff 15 b4 ae 3d 00    	call   *0x3daeb4(%rip)        # b29348 <_DYNAMIC+0x248>
  74e494:	e9 80 00 00 00       	jmp    74e519 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7f9>
  74e499:	49 89 c7             	mov    %rax,%r15
  74e49c:	49 8b 34 24          	mov    (%r12),%rsi
  74e4a0:	48 85 f6             	test   %rsi,%rsi
  74e4a3:	74 68                	je     74e50d <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7ed>
  74e4a5:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  74e4ac:	48 c1 e6 04          	shl    $0x4,%rsi
  74e4b0:	ba 08 00 00 00       	mov    $0x8,%edx
  74e4b5:	ff 15 8d ae 3d 00    	call   *0x3dae8d(%rip)        # b29348 <_DYNAMIC+0x248>
  74e4bb:	eb 50                	jmp    74e50d <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7ed>
  74e4bd:	49 89 c7             	mov    %rax,%r15
  74e4c0:	49 8b 34 24          	mov    (%r12),%rsi
  74e4c4:	48 85 f6             	test   %rsi,%rsi
  74e4c7:	74 16                	je     74e4df <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7bf>
  74e4c9:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  74e4d0:	48 c1 e6 04          	shl    $0x4,%rsi
  74e4d4:	ba 08 00 00 00       	mov    $0x8,%edx
  74e4d9:	ff 15 69 ae 3d 00    	call   *0x3dae69(%rip)        # b29348 <_DYNAMIC+0x248>
  74e4df:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  74e4e6:	48 85 f6             	test   %rsi,%rsi
  74e4e9:	74 16                	je     74e501 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7e1>
  74e4eb:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  74e4f2:	48 c1 e6 03          	shl    $0x3,%rsi
  74e4f6:	ba 08 00 00 00       	mov    $0x8,%edx
  74e4fb:	ff 15 47 ae 3d 00    	call   *0x3dae47(%rip)        # b29348 <_DYNAMIC+0x248>
  74e501:	49 8d be 70 02 00 00 	lea    0x270(%r14),%rdi
  74e508:	e8 b3 14 00 00       	call   74f9c0 <core::ptr::drop_glue::<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>>>>
  74e50d:	49 8d be 90 02 00 00 	lea    0x290(%r14),%rdi
  74e514:	e8 f7 16 00 00       	call   74fc10 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Node>>>
  74e519:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  74e520:	e8 5b 27 00 00       	call   750c80 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  74e525:	49 8d be a8 02 00 00 	lea    0x2a8(%r14),%rdi
  74e52c:	e8 1f 14 00 00       	call   74f950 <core::ptr::drop_glue::<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>>>>
  74e531:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  74e538:	e8 73 0c 00 00       	call   74f1b0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  74e53d:	49 8d be e8 01 00 00 	lea    0x1e8(%r14),%rdi
  74e544:	e8 37 26 00 00       	call   750b80 <core::ptr::drop_glue::<gpui::runtime::identity_index::IdentityIndex>>
  74e549:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  74e550:	e8 0b 94 ff ff       	call   747960 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout> as core::ops::drop::Drop>::drop>
  74e555:	eb 09                	jmp    74e560 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x840>
  74e557:	ff 15 1b ae 3d 00    	call   *0x3dae1b(%rip)        # b29378 <_DYNAMIC+0x278>
  74e55d:	49 89 c7             	mov    %rax,%r15
  74e560:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  74e567:	e8 54 ab ff ff       	call   7490c0 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  74e56c:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  74e573:	e8 d8 0f 00 00       	call   74f550 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  74e578:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  74e57f:	e8 6c 9b ff ff       	call   7480f0 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  74e584:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  74e58b:	e8 d0 9e ff ff       	call   748460 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  74e590:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  74e597:	e8 04 1b 00 00       	call   7500a0 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  74e59c:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  74e5a3:	48 85 f6             	test   %rsi,%rsi
  74e5a6:	74 16                	je     74e5be <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x89e>
  74e5a8:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  74e5af:	48 c1 e6 04          	shl    $0x4,%rsi
  74e5b3:	ba 08 00 00 00       	mov    $0x8,%edx
  74e5b8:	ff 15 8a ad 3d 00    	call   *0x3dad8a(%rip)        # b29348 <_DYNAMIC+0x248>
  74e5be:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  74e5c5:	e8 a6 8f ff ff       	call   747570 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  74e5ca:	49 8d be 88 05 00 00 	lea    0x588(%r14),%rdi
  74e5d1:	e8 9a 11 00 00       	call   74f770 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Prepared>>>
  74e5d6:	49 8d be 70 05 00 00 	lea    0x570(%r14),%rdi
  74e5dd:	e8 9e 16 00 00       	call   74fc80 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Presented>>>
  74e5e2:	4c 89 f7             	mov    %r14,%rdi
  74e5e5:	e8 66 20 00 00       	call   750650 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  74e5ea:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  74e5f1:	e8 7a 09 00 00       	call   74ef70 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  74e5f6:	be 28 08 00 00       	mov    $0x828,%esi
  74e5fb:	ba 08 00 00 00       	mov    $0x8,%edx
  74e600:	4c 89 f7             	mov    %r14,%rdi
  74e603:	ff 15 3f ad 3d 00    	call   *0x3dad3f(%rip)        # b29348 <_DYNAMIC+0x248>
  74e609:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  74e610:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  74e615:	48 89 43 08          	mov    %rax,0x8(%rbx)
  74e619:	4c 89 ff             	mov    %r15,%rdi
  74e61c:	e8 bf ae 3a 00       	call   af94e0 <_Unwind_Resume@plt>
  74e621:	ff 15 51 ad 3d 00    	call   *0x3dad51(%rip)        # b29378 <_DYNAMIC+0x278>
  74e627:	49 89 c7             	mov    %rax,%r15
  74e62a:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  74e62f:	e8 ac 23 00 00       	call   7509e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  74e634:	4c 89 ff             	mov    %r15,%rdi
  74e637:	e8 a4 ae 3a 00       	call   af94e0 <_Unwind_Resume@plt>
  74e63c:	64 49 ff 04 24       	incq   %fs:(%r12)
  74e641:	48 89 c7             	mov    %rax,%rdi
  74e644:	e8 97 ae 3a 00       	call   af94e0 <_Unwind_Resume@plt>
