
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000074dd90 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>>:
  74dd90:	55                   	push   %rbp
  74dd91:	41 57                	push   %r15
  74dd93:	41 56                	push   %r14
  74dd95:	41 55                	push   %r13
  74dd97:	41 54                	push   %r12
  74dd99:	53                   	push   %rbx
  74dd9a:	48 81 ec 68 01 00 00 	sub    $0x168,%rsp
  74dda1:	48 89 f3             	mov    %rsi,%rbx
  74dda4:	49 89 ff             	mov    %rdi,%r15
  74dda7:	49 c7 c4 68 f3 ff ff 	mov    $0xfffffffffffff368,%r12
  74ddae:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  74ddb5:	00 00 
  74ddb7:	4d 01 e6             	add    %r12,%r14
  74ddba:	64 41 80 bc 24 10 0c 	cmpb   $0x0,%fs:0xc10(%r12)
  74ddc1:	00 00 00 
  74ddc4:	0f 84 59 05 00 00    	je     74e323 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x593>
  74ddca:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  74ddd0:	0f 85 73 05 00 00    	jne    74e349 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x5b9>
  74ddd6:	64 49 c7 04 24 ff ff 	movq   $0xffffffffffffffff,%fs:(%r12)
  74dddd:	ff ff 
  74dddf:	64 41 8b 84 24 08 0c 	mov    %fs:0xc08(%r12),%eax
  74dde6:	00 00 
  74dde8:	ff c0                	inc    %eax
  74ddea:	64 41 89 84 24 08 0c 	mov    %eax,%fs:0xc08(%r12)
  74ddf1:	00 00 
  74ddf3:	83 f8 40             	cmp    $0x40,%eax
  74ddf6:	0f 83 5a 05 00 00    	jae    74e356 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x5c6>
  74ddfc:	89 c0                	mov    %eax,%eax
  74ddfe:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  74de02:	48 c1 e0 04          	shl    $0x4,%rax
  74de06:	0f 57 c0             	xorps  %xmm0,%xmm0
  74de09:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  74de0f:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  74de15:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  74de1b:	64 49 c7 04 24 00 00 	movq   $0x0,%fs:(%r12)
  74de22:	00 00 
  74de24:	0f 28 05 a5 c8 90 ff 	movaps -0x6f375b(%rip),%xmm0        # 5a6d0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x860>
  74de2b:	0f 29 84 24 50 01 00 	movaps %xmm0,0x150(%rsp)
  74de32:	00 
  74de33:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
  74de3a:	00 
  74de3b:	0f 29 84 24 30 01 00 	movaps %xmm0,0x130(%rsp)
  74de42:	00 
  74de43:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  74de4a:	00 
  74de4b:	0f 29 84 24 10 01 00 	movaps %xmm0,0x110(%rsp)
  74de52:	00 
  74de53:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  74de5a:	00 
  74de5b:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  74de62:	00 
  74de63:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  74de6a:	00 
  74de6b:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  74de72:	00 
  74de73:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  74de7a:	00 
  74de7b:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  74de82:	00 
  74de83:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  74de8a:	00 
  74de8b:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  74de92:	00 
  74de93:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  74de9a:	00 
  74de9b:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  74dea0:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  74dea5:	c7 84 24 60 01 00 00 	movl   $0x0,0x160(%rsp)
  74deac:	00 00 00 00 
  74deb0:	48 b8 80 02 00 00 e0 	movabs $0x1e000000280,%rax
  74deb7:	01 00 00 
  74deba:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  74debf:	c7 44 24 48 00 00 00 	movl   $0x0,0x48(%rsp)
  74dec6:	00 
  74dec7:	c7 44 24 50 00 00 4b 	movl   $0x434b0000,0x50(%rsp)
  74dece:	43 
  74decf:	66 c7 44 24 54 00 00 	movw   $0x0,0x54(%rsp)
  74ded6:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  74dedb:	48 8d 74 24 60       	lea    0x60(%rsp),%rsi
  74dee0:	48 8d 54 24 48       	lea    0x48(%rsp),%rdx
  74dee5:	f3 0f 10 05 cb b7 90 	movss  -0x6f4835(%rip),%xmm0        # 596b8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.312.llvm.6319143315422321905+0x38>
  74deec:	ff 
  74deed:	b9 01 00 00 00       	mov    $0x1,%ecx
  74def2:	45 31 c0             	xor    %r8d,%r8d
  74def5:	e8 b6 cc fb ff       	call   70abb0 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::mount_lanes>
  74defa:	83 7c 24 10 fe       	cmpl   $0xfffffffe,0x10(%rsp)
  74deff:	0f 85 6c 04 00 00    	jne    74e371 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x5e1>
  74df05:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  74df0a:	48 83 3b 00          	cmpq   $0x0,(%rbx)
  74df0e:	0f 84 e0 03 00 00    	je     74e2f4 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x564>
  74df14:	4c 8b 73 08          	mov    0x8(%rbx),%r14
  74df18:	4d 85 f6             	test   %r14,%r14
  74df1b:	0f 84 d3 03 00 00    	je     74e2f4 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x564>
  74df21:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  74df26:	4d 8d a6 40 02 00 00 	lea    0x240(%r14),%r12
  74df2d:	4c 89 e7             	mov    %r12,%rdi
  74df30:	e8 4b 5d ff ff       	call   743c80 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>> as core::ops::drop::Drop>::drop>
  74df35:	49 8b 34 24          	mov    (%r12),%rsi
  74df39:	48 85 f6             	test   %rsi,%rsi
  74df3c:	74 16                	je     74df54 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x1c4>
  74df3e:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  74df45:	48 c1 e6 04          	shl    $0x4,%rsi
  74df49:	ba 08 00 00 00       	mov    $0x8,%edx
  74df4e:	ff 15 64 b4 3d 00    	call   *0x3db464(%rip)        # b293b8 <_DYNAMIC+0x248>
  74df54:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  74df5b:	48 85 f6             	test   %rsi,%rsi
  74df5e:	74 16                	je     74df76 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x1e6>
  74df60:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  74df67:	48 c1 e6 03          	shl    $0x3,%rsi
  74df6b:	ba 08 00 00 00       	mov    $0x8,%edx
  74df70:	ff 15 42 b4 3d 00    	call   *0x3db442(%rip)        # b293b8 <_DYNAMIC+0x248>
  74df76:	4d 8d a6 70 02 00 00 	lea    0x270(%r14),%r12
  74df7d:	4c 89 e7             	mov    %r12,%rdi
  74df80:	e8 fb 5c ff ff       	call   743c80 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>> as core::ops::drop::Drop>::drop>
  74df85:	49 8b 34 24          	mov    (%r12),%rsi
  74df89:	48 85 f6             	test   %rsi,%rsi
  74df8c:	74 16                	je     74dfa4 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x214>
  74df8e:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  74df95:	48 c1 e6 04          	shl    $0x4,%rsi
  74df99:	ba 08 00 00 00       	mov    $0x8,%edx
  74df9e:	ff 15 14 b4 3d 00    	call   *0x3db414(%rip)        # b293b8 <_DYNAMIC+0x248>
  74dfa4:	4d 8d a6 90 02 00 00 	lea    0x290(%r14),%r12
  74dfab:	4c 89 e7             	mov    %r12,%rdi
  74dfae:	e8 ed 5f ff ff       	call   743fa0 <<alloc::vec::Vec<gpui::runtime::Node> as core::ops::drop::Drop>::drop>
  74dfb3:	49 8b 04 24          	mov    (%r12),%rax
  74dfb7:	48 85 c0             	test   %rax,%rax
  74dfba:	74 1a                	je     74dfd6 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x246>
  74dfbc:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  74dfc3:	48 c1 e0 03          	shl    $0x3,%rax
  74dfc7:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74dfcb:	ba 08 00 00 00       	mov    $0x8,%edx
  74dfd0:	ff 15 e2 b3 3d 00    	call   *0x3db3e2(%rip)        # b293b8 <_DYNAMIC+0x248>
  74dfd6:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  74dfdd:	e8 0e 2d 00 00       	call   750cf0 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  74dfe2:	4d 8d a6 a8 02 00 00 	lea    0x2a8(%r14),%r12
  74dfe9:	4c 89 e7             	mov    %r12,%rdi
  74dfec:	e8 1f 5e ff ff       	call   743e10 <<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>> as core::ops::drop::Drop>::drop>
  74dff1:	49 8b 04 24          	mov    (%r12),%rax
  74dff5:	48 85 c0             	test   %rax,%rax
  74dff8:	74 1a                	je     74e014 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x284>
  74dffa:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  74e001:	48 c1 e0 04          	shl    $0x4,%rax
  74e005:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e009:	ba 08 00 00 00       	mov    $0x8,%edx
  74e00e:	ff 15 a4 b3 3d 00    	call   *0x3db3a4(%rip)        # b293b8 <_DYNAMIC+0x248>
  74e014:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  74e01b:	e8 00 12 00 00       	call   74f220 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  74e020:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  74e027:	48 85 c0             	test   %rax,%rax
  74e02a:	74 49                	je     74e075 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2e5>
  74e02c:	83 f8 01             	cmp    $0x1,%eax
  74e02f:	75 1e                	jne    74e04f <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2bf>
  74e031:	49 8b b6 f8 01 00 00 	mov    0x1f8(%r14),%rsi
  74e038:	48 85 f6             	test   %rsi,%rsi
  74e03b:	74 38                	je     74e075 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2e5>
  74e03d:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  74e044:	48 c1 e6 04          	shl    $0x4,%rsi
  74e048:	ba 08 00 00 00       	mov    $0x8,%edx
  74e04d:	eb 20                	jmp    74e06f <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2df>
  74e04f:	49 8b 86 f8 01 00 00 	mov    0x1f8(%r14),%rax
  74e056:	48 85 c0             	test   %rax,%rax
  74e059:	74 1a                	je     74e075 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2e5>
  74e05b:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  74e062:	48 c1 e0 02          	shl    $0x2,%rax
  74e066:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  74e06a:	ba 04 00 00 00       	mov    $0x4,%edx
  74e06f:	ff 15 43 b3 3d 00    	call   *0x3db343(%rip)        # b293b8 <_DYNAMIC+0x248>
  74e075:	49 8b 8e c8 05 00 00 	mov    0x5c8(%r14),%rcx
  74e07c:	48 85 c9             	test   %rcx,%rcx
  74e07f:	74 44                	je     74e0c5 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x335>
  74e081:	49 8b 96 d0 05 00 00 	mov    0x5d0(%r14),%rdx
  74e088:	49 8b 86 d8 05 00 00 	mov    0x5d8(%r14),%rax
  74e08f:	48 c7 44 24 68 00 00 	movq   $0x0,0x68(%rsp)
  74e096:	00 00 
  74e098:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  74e09d:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
  74e0a2:	48 c7 84 24 88 00 00 	movq   $0x0,0x88(%rsp)
  74e0a9:	00 00 00 00 00 
  74e0ae:	48 89 8c 24 90 00 00 	mov    %rcx,0x90(%rsp)
  74e0b5:	00 
  74e0b6:	48 89 94 24 98 00 00 	mov    %rdx,0x98(%rsp)
  74e0bd:	00 
  74e0be:	b9 01 00 00 00       	mov    $0x1,%ecx
  74e0c3:	eb 04                	jmp    74e0c9 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x339>
  74e0c5:	31 c9                	xor    %ecx,%ecx
  74e0c7:	31 c0                	xor    %eax,%eax
  74e0c9:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  74e0ce:	48 89 8c 24 80 00 00 	mov    %rcx,0x80(%rsp)
  74e0d5:	00 
  74e0d6:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  74e0dd:	00 
  74e0de:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  74e0e3:	48 8d 74 24 60       	lea    0x60(%rsp),%rsi
  74e0e8:	e8 23 81 ff ff       	call   746210 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  74e0ed:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  74e0f2:	48 85 c0             	test   %rax,%rax
  74e0f5:	74 58                	je     74e14f <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x3bf>
  74e0f7:	4c 8d 64 24 10       	lea    0x10(%rsp),%r12
  74e0fc:	4c 8d 6c 24 60       	lea    0x60(%rsp),%r13
  74e101:	48 8b 2d b0 b2 3d 00 	mov    0x3db2b0(%rip),%rbp        # b293b8 <_DYNAMIC+0x248>
  74e108:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  74e10f:	00 
  74e110:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  74e115:	48 c1 e1 05          	shl    $0x5,%rcx
  74e119:	48 8b 34 08          	mov    (%rax,%rcx,1),%rsi
  74e11d:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  74e121:	74 17                	je     74e13a <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x3aa>
  74e123:	48 85 f6             	test   %rsi,%rsi
  74e126:	74 12                	je     74e13a <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x3aa>
  74e128:	48 01 c8             	add    %rcx,%rax
  74e12b:	48 8b 78 08          	mov    0x8(%rax),%rdi
  74e12f:	48 c1 e6 02          	shl    $0x2,%rsi
  74e133:	ba 04 00 00 00       	mov    $0x4,%edx
  74e138:	ff d5                	call   *%rbp
  74e13a:	4c 89 e7             	mov    %r12,%rdi
  74e13d:	4c 89 ee             	mov    %r13,%rsi
  74e140:	e8 cb 80 ff ff       	call   746210 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  74e145:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  74e14a:	48 85 c0             	test   %rax,%rax
  74e14d:	75 c1                	jne    74e110 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x380>
  74e14f:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  74e156:	e8 d5 af ff ff       	call   749130 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  74e15b:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  74e162:	e8 59 14 00 00       	call   74f5c0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  74e167:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  74e16e:	e8 ed 9f ff ff       	call   748160 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  74e173:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  74e17a:	e8 51 a3 ff ff       	call   7484d0 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  74e17f:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  74e186:	e8 85 1f 00 00       	call   750110 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  74e18b:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  74e192:	48 85 f6             	test   %rsi,%rsi
  74e195:	74 16                	je     74e1ad <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x41d>
  74e197:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  74e19e:	48 c1 e6 04          	shl    $0x4,%rsi
  74e1a2:	ba 08 00 00 00       	mov    $0x8,%edx
  74e1a7:	ff 15 0b b2 3d 00    	call   *0x3db20b(%rip)        # b293b8 <_DYNAMIC+0x248>
  74e1ad:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  74e1b4:	e8 27 94 ff ff       	call   7475e0 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  74e1b9:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74e1c0:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  74e1c4:	0f 84 7e 00 00 00    	je     74e248 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4b8>
  74e1ca:	4d 8b a6 98 05 00 00 	mov    0x598(%r14),%r12
  74e1d1:	4d 85 e4             	test   %r12,%r12
  74e1d4:	74 53                	je     74e229 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x499>
  74e1d6:	4d 8b ae 90 05 00 00 	mov    0x590(%r14),%r13
  74e1dd:	49 83 c5 78          	add    $0x78,%r13
  74e1e1:	48 8b 2d 08 b2 3d 00 	mov    0x3db208(%rip),%rbp        # b293f0 <_DYNAMIC+0x280>
  74e1e8:	eb 0f                	jmp    74e1f9 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x469>
  74e1ea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  74e1f0:	49 83 c5 50          	add    $0x50,%r13
  74e1f4:	49 ff cc             	dec    %r12
  74e1f7:	74 29                	je     74e222 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x492>
  74e1f9:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  74e1fd:	48 85 ff             	test   %rdi,%rdi
  74e200:	74 ee                	je     74e1f0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74e202:	f6 07 01             	testb  $0x1,(%rdi)
  74e205:	75 e9                	jne    74e1f0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74e207:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74e20b:	a8 01                	test   $0x1,%al
  74e20d:	75 e1                	jne    74e1f0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74e20f:	48 8d 47 08          	lea    0x8(%rdi),%rax
  74e213:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  74e218:	75 d6                	jne    74e1f0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74e21a:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74e21e:	ff d5                	call   *%rbp
  74e220:	eb ce                	jmp    74e1f0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74e222:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74e229:	48 85 c0             	test   %rax,%rax
  74e22c:	74 1a                	je     74e248 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4b8>
  74e22e:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  74e235:	48 c1 e0 04          	shl    $0x4,%rax
  74e239:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e23d:	ba 08 00 00 00       	mov    $0x8,%edx
  74e242:	ff 15 70 b1 3d 00    	call   *0x3db170(%rip)        # b293b8 <_DYNAMIC+0x248>
  74e248:	4d 8b a6 80 05 00 00 	mov    0x580(%r14),%r12
  74e24f:	4d 85 e4             	test   %r12,%r12
  74e252:	74 4e                	je     74e2a2 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x512>
  74e254:	4d 8b ae 78 05 00 00 	mov    0x578(%r14),%r13
  74e25b:	49 83 c5 78          	add    $0x78,%r13
  74e25f:	48 8b 2d 8a b1 3d 00 	mov    0x3db18a(%rip),%rbp        # b293f0 <_DYNAMIC+0x280>
  74e266:	eb 11                	jmp    74e279 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e9>
  74e268:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  74e26f:	00 
  74e270:	49 83 c5 50          	add    $0x50,%r13
  74e274:	49 ff cc             	dec    %r12
  74e277:	74 29                	je     74e2a2 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x512>
  74e279:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  74e27d:	48 85 ff             	test   %rdi,%rdi
  74e280:	74 ee                	je     74e270 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74e282:	f6 07 01             	testb  $0x1,(%rdi)
  74e285:	75 e9                	jne    74e270 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74e287:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74e28b:	a8 01                	test   $0x1,%al
  74e28d:	75 e1                	jne    74e270 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74e28f:	48 8d 47 08          	lea    0x8(%rdi),%rax
  74e293:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  74e298:	75 d6                	jne    74e270 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74e29a:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74e29e:	ff d5                	call   *%rbp
  74e2a0:	eb ce                	jmp    74e270 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74e2a2:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  74e2a9:	48 85 c0             	test   %rax,%rax
  74e2ac:	74 1a                	je     74e2c8 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x538>
  74e2ae:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  74e2b5:	48 c1 e0 04          	shl    $0x4,%rax
  74e2b9:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e2bd:	ba 08 00 00 00       	mov    $0x8,%edx
  74e2c2:	ff 15 f0 b0 3d 00    	call   *0x3db0f0(%rip)        # b293b8 <_DYNAMIC+0x248>
  74e2c8:	4c 89 f7             	mov    %r14,%rdi
  74e2cb:	e8 f0 23 00 00       	call   7506c0 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  74e2d0:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  74e2d7:	e8 04 0d 00 00       	call   74efe0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  74e2dc:	be 28 08 00 00       	mov    $0x828,%esi
  74e2e1:	ba 08 00 00 00       	mov    $0x8,%edx
  74e2e6:	4c 89 f7             	mov    %r14,%rdi
  74e2e9:	ff 15 c9 b0 3d 00    	call   *0x3db0c9(%rip)        # b293b8 <_DYNAMIC+0x248>
  74e2ef:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  74e2f4:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  74e2fb:	48 89 43 08          	mov    %rax,0x8(%rbx)
  74e2ff:	48 8d 35 aa d9 3a 00 	lea    0x3ad9aa(%rip),%rsi        # afbcb0 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166>
  74e306:	4c 89 ff             	mov    %r15,%rdi
  74e309:	e8 f2 ef 01 00       	call   76d300 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  74e30e:	4c 89 f8             	mov    %r15,%rax
  74e311:	48 81 c4 68 01 00 00 	add    $0x168,%rsp
  74e318:	5b                   	pop    %rbx
  74e319:	41 5c                	pop    %r12
  74e31b:	41 5d                	pop    %r13
  74e31d:	41 5e                	pop    %r14
  74e31f:	41 5f                	pop    %r15
  74e321:	5d                   	pop    %rbp
  74e322:	c3                   	ret
  74e323:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  74e328:	4c 89 f7             	mov    %r14,%rdi
  74e32b:	31 f6                	xor    %esi,%esi
  74e32d:	ff 15 ed b5 3d 00    	call   *0x3db5ed(%rip)        # b29920 <memset@GLIBC_2.2.5>
  74e333:	64 41 c6 84 24 10 0c 	movb   $0x1,%fs:0xc10(%r12)
  74e33a:	00 00 01 
  74e33d:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  74e343:	0f 84 8d fa ff ff    	je     74ddd6 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x46>
  74e349:	48 8d 3d 68 e6 3a 00 	lea    0x3ae668(%rip),%rdi        # afc9b8 <anon.547532fe00eaf98ca33efb65e1aed586.15.llvm.9042944481482549913>
  74e350:	ff 15 d2 b5 3d 00    	call   *0x3db5d2(%rip)        # b29928 <_DYNAMIC+0x7b8>
  74e356:	48 8d 3d 23 db 91 ff 	lea    -0x6e24dd(%rip),%rdi        # 6be80 <anon.547532fe00eaf98ca33efb65e1aed586.12.llvm.9042944481482549913>
  74e35d:	48 8d 15 3c e6 3a 00 	lea    0x3ae63c(%rip),%rdx        # afc9a0 <anon.547532fe00eaf98ca33efb65e1aed586.14.llvm.9042944481482549913>
  74e364:	be 4b 00 00 00       	mov    $0x4b,%esi
  74e369:	ff 15 49 b2 3d 00    	call   *0x3db249(%rip)        # b295b8 <_DYNAMIC+0x448>
  74e36f:	eb 53                	jmp    74e3c4 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x634>
  74e371:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  74e376:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  74e37d:	00 
  74e37e:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  74e383:	0f 10 4c 24 20       	movups 0x20(%rsp),%xmm1
  74e388:	0f 10 54 24 30       	movups 0x30(%rsp),%xmm2
  74e38d:	0f 29 94 24 80 00 00 	movaps %xmm2,0x80(%rsp)
  74e394:	00 
  74e395:	0f 29 4c 24 70       	movaps %xmm1,0x70(%rsp)
  74e39a:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  74e39f:	48 8d 3d be cb 91 ff 	lea    -0x6e3442(%rip),%rdi        # 6af64 <anon.2d1f820267f84878e0cbda50021465a1.8.llvm.17676285964678017166>
  74e3a6:	48 8d 0d 6b d9 3a 00 	lea    0x3ad96b(%rip),%rcx        # afbd18 <anon.2d1f820267f84878e0cbda50021465a1.7.llvm.17676285964678017166>
  74e3ad:	4c 8d 05 34 d9 3a 00 	lea    0x3ad934(%rip),%r8        # afbce8 <anon.2d1f820267f84878e0cbda50021465a1.3.llvm.17676285964678017166+0x18>
  74e3b4:	48 8d 54 24 60       	lea    0x60(%rsp),%rdx
  74e3b9:	be 2b 00 00 00       	mov    $0x2b,%esi
  74e3be:	ff 15 fc b0 3d 00    	call   *0x3db0fc(%rip)        # b294c0 <_DYNAMIC+0x350>
  74e3c4:	0f 0b                	ud2
  74e3c6:	49 89 c7             	mov    %rax,%r15
  74e3c9:	49 ff cc             	dec    %r12
  74e3cc:	74 0f                	je     74e3dd <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x64d>
  74e3ce:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  74e3d2:	49 83 c5 50          	add    $0x50,%r13
  74e3d6:	e8 15 3a ff ff       	call   741df0 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  74e3db:	eb ec                	jmp    74e3c9 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x639>
  74e3dd:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74e3e4:	48 85 c0             	test   %rax,%rax
  74e3e7:	0f 84 59 02 00 00    	je     74e646 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8b6>
  74e3ed:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  74e3f4:	48 c1 e0 04          	shl    $0x4,%rax
  74e3f8:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e3fc:	ba 08 00 00 00       	mov    $0x8,%edx
  74e401:	ff 15 b1 af 3d 00    	call   *0x3dafb1(%rip)        # b293b8 <_DYNAMIC+0x248>
  74e407:	e9 3a 02 00 00       	jmp    74e646 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8b6>
  74e40c:	ff 15 d6 af 3d 00    	call   *0x3dafd6(%rip)        # b293e8 <_DYNAMIC+0x278>
  74e412:	49 89 c7             	mov    %rax,%r15
  74e415:	49 ff cc             	dec    %r12
  74e418:	74 0f                	je     74e429 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x699>
  74e41a:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  74e41e:	49 83 c5 50          	add    $0x50,%r13
  74e422:	e8 c9 39 ff ff       	call   741df0 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  74e427:	eb ec                	jmp    74e415 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x685>
  74e429:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  74e430:	48 85 c0             	test   %rax,%rax
  74e433:	0f 84 19 02 00 00    	je     74e652 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8c2>
  74e439:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  74e440:	48 c1 e0 04          	shl    $0x4,%rax
  74e444:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e448:	ba 08 00 00 00       	mov    $0x8,%edx
  74e44d:	ff 15 65 af 3d 00    	call   *0x3daf65(%rip)        # b293b8 <_DYNAMIC+0x248>
  74e453:	e9 fa 01 00 00       	jmp    74e652 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8c2>
  74e458:	ff 15 8a af 3d 00    	call   *0x3daf8a(%rip)        # b293e8 <_DYNAMIC+0x278>
  74e45e:	49 89 c7             	mov    %rax,%r15
  74e461:	e9 00 02 00 00       	jmp    74e666 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8d6>
  74e466:	49 89 c7             	mov    %rax,%r15
  74e469:	e9 ec 01 00 00       	jmp    74e65a <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8ca>
  74e46e:	49 89 c7             	mov    %rax,%r15
  74e471:	e9 c4 01 00 00       	jmp    74e63a <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8aa>
  74e476:	49 89 c7             	mov    %rax,%r15
  74e479:	e9 8e 01 00 00       	jmp    74e60c <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x87c>
  74e47e:	49 89 c7             	mov    %rax,%r15
  74e481:	e9 7a 01 00 00       	jmp    74e600 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x870>
  74e486:	49 89 c7             	mov    %rax,%r15
  74e489:	e9 66 01 00 00       	jmp    74e5f4 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x864>
  74e48e:	49 89 c7             	mov    %rax,%r15
  74e491:	e9 52 01 00 00       	jmp    74e5e8 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x858>
  74e496:	49 89 c7             	mov    %rax,%r15
  74e499:	e9 3e 01 00 00       	jmp    74e5dc <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x84c>
  74e49e:	e9 2a 01 00 00       	jmp    74e5cd <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x83d>
  74e4a3:	49 89 c7             	mov    %rax,%r15
  74e4a6:	e9 02 01 00 00       	jmp    74e5ad <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x81d>
  74e4ab:	49 89 c7             	mov    %rax,%r15
  74e4ae:	49 8b 04 24          	mov    (%r12),%rax
  74e4b2:	48 85 c0             	test   %rax,%rax
  74e4b5:	0f 84 e6 00 00 00    	je     74e5a1 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x811>
  74e4bb:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  74e4c2:	48 c1 e0 04          	shl    $0x4,%rax
  74e4c6:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e4ca:	ba 08 00 00 00       	mov    $0x8,%edx
  74e4cf:	ff 15 e3 ae 3d 00    	call   *0x3daee3(%rip)        # b293b8 <_DYNAMIC+0x248>
  74e4d5:	e9 c7 00 00 00       	jmp    74e5a1 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x811>
  74e4da:	49 89 c7             	mov    %rax,%r15
  74e4dd:	49 8b 04 24          	mov    (%r12),%rax
  74e4e1:	48 85 c0             	test   %rax,%rax
  74e4e4:	0f 84 9f 00 00 00    	je     74e589 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7f9>
  74e4ea:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  74e4f1:	48 c1 e0 03          	shl    $0x3,%rax
  74e4f5:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e4f9:	ba 08 00 00 00       	mov    $0x8,%edx
  74e4fe:	ff 15 b4 ae 3d 00    	call   *0x3daeb4(%rip)        # b293b8 <_DYNAMIC+0x248>
  74e504:	e9 80 00 00 00       	jmp    74e589 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7f9>
  74e509:	49 89 c7             	mov    %rax,%r15
  74e50c:	49 8b 34 24          	mov    (%r12),%rsi
  74e510:	48 85 f6             	test   %rsi,%rsi
  74e513:	74 68                	je     74e57d <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7ed>
  74e515:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  74e51c:	48 c1 e6 04          	shl    $0x4,%rsi
  74e520:	ba 08 00 00 00       	mov    $0x8,%edx
  74e525:	ff 15 8d ae 3d 00    	call   *0x3dae8d(%rip)        # b293b8 <_DYNAMIC+0x248>
  74e52b:	eb 50                	jmp    74e57d <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7ed>
  74e52d:	49 89 c7             	mov    %rax,%r15
  74e530:	49 8b 34 24          	mov    (%r12),%rsi
  74e534:	48 85 f6             	test   %rsi,%rsi
  74e537:	74 16                	je     74e54f <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7bf>
  74e539:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  74e540:	48 c1 e6 04          	shl    $0x4,%rsi
  74e544:	ba 08 00 00 00       	mov    $0x8,%edx
  74e549:	ff 15 69 ae 3d 00    	call   *0x3dae69(%rip)        # b293b8 <_DYNAMIC+0x248>
  74e54f:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  74e556:	48 85 f6             	test   %rsi,%rsi
  74e559:	74 16                	je     74e571 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7e1>
  74e55b:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  74e562:	48 c1 e6 03          	shl    $0x3,%rsi
  74e566:	ba 08 00 00 00       	mov    $0x8,%edx
  74e56b:	ff 15 47 ae 3d 00    	call   *0x3dae47(%rip)        # b293b8 <_DYNAMIC+0x248>
  74e571:	49 8d be 70 02 00 00 	lea    0x270(%r14),%rdi
  74e578:	e8 b3 14 00 00       	call   74fa30 <core::ptr::drop_glue::<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>>>>
  74e57d:	49 8d be 90 02 00 00 	lea    0x290(%r14),%rdi
  74e584:	e8 f7 16 00 00       	call   74fc80 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Node>>>
  74e589:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  74e590:	e8 5b 27 00 00       	call   750cf0 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  74e595:	49 8d be a8 02 00 00 	lea    0x2a8(%r14),%rdi
  74e59c:	e8 1f 14 00 00       	call   74f9c0 <core::ptr::drop_glue::<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>>>>
  74e5a1:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  74e5a8:	e8 73 0c 00 00       	call   74f220 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  74e5ad:	49 8d be e8 01 00 00 	lea    0x1e8(%r14),%rdi
  74e5b4:	e8 37 26 00 00       	call   750bf0 <core::ptr::drop_glue::<gpui::runtime::identity_index::IdentityIndex>>
  74e5b9:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  74e5c0:	e8 0b 94 ff ff       	call   7479d0 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout> as core::ops::drop::Drop>::drop>
  74e5c5:	eb 09                	jmp    74e5d0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x840>
  74e5c7:	ff 15 1b ae 3d 00    	call   *0x3dae1b(%rip)        # b293e8 <_DYNAMIC+0x278>
  74e5cd:	49 89 c7             	mov    %rax,%r15
  74e5d0:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  74e5d7:	e8 54 ab ff ff       	call   749130 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  74e5dc:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  74e5e3:	e8 d8 0f 00 00       	call   74f5c0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  74e5e8:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  74e5ef:	e8 6c 9b ff ff       	call   748160 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  74e5f4:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  74e5fb:	e8 d0 9e ff ff       	call   7484d0 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  74e600:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  74e607:	e8 04 1b 00 00       	call   750110 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  74e60c:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  74e613:	48 85 f6             	test   %rsi,%rsi
  74e616:	74 16                	je     74e62e <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x89e>
  74e618:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  74e61f:	48 c1 e6 04          	shl    $0x4,%rsi
  74e623:	ba 08 00 00 00       	mov    $0x8,%edx
  74e628:	ff 15 8a ad 3d 00    	call   *0x3dad8a(%rip)        # b293b8 <_DYNAMIC+0x248>
  74e62e:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  74e635:	e8 a6 8f ff ff       	call   7475e0 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  74e63a:	49 8d be 88 05 00 00 	lea    0x588(%r14),%rdi
  74e641:	e8 9a 11 00 00       	call   74f7e0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Prepared>>>
  74e646:	49 8d be 70 05 00 00 	lea    0x570(%r14),%rdi
  74e64d:	e8 9e 16 00 00       	call   74fcf0 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Presented>>>
  74e652:	4c 89 f7             	mov    %r14,%rdi
  74e655:	e8 66 20 00 00       	call   7506c0 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  74e65a:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  74e661:	e8 7a 09 00 00       	call   74efe0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  74e666:	be 28 08 00 00       	mov    $0x828,%esi
  74e66b:	ba 08 00 00 00       	mov    $0x8,%edx
  74e670:	4c 89 f7             	mov    %r14,%rdi
  74e673:	ff 15 3f ad 3d 00    	call   *0x3dad3f(%rip)        # b293b8 <_DYNAMIC+0x248>
  74e679:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  74e680:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  74e685:	48 89 43 08          	mov    %rax,0x8(%rbx)
  74e689:	4c 89 ff             	mov    %r15,%rdi
  74e68c:	e8 bf ae 3a 00       	call   af9550 <_Unwind_Resume@plt>
  74e691:	ff 15 51 ad 3d 00    	call   *0x3dad51(%rip)        # b293e8 <_DYNAMIC+0x278>
  74e697:	49 89 c7             	mov    %rax,%r15
  74e69a:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  74e69f:	e8 ac 23 00 00       	call   750a50 <core::ptr::drop_glue::<gpui::runtime::Error>>
  74e6a4:	4c 89 ff             	mov    %r15,%rdi
  74e6a7:	e8 a4 ae 3a 00       	call   af9550 <_Unwind_Resume@plt>
  74e6ac:	64 49 ff 04 24       	incq   %fs:(%r12)
  74e6b1:	48 89 c7             	mov    %rax,%rdi
  74e6b4:	e8 97 ae 3a 00       	call   af9550 <_Unwind_Resume@plt>
