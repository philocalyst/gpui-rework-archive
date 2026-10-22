
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000074dc90 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>>:
  74dc90:	55                   	push   %rbp
  74dc91:	41 57                	push   %r15
  74dc93:	41 56                	push   %r14
  74dc95:	41 55                	push   %r13
  74dc97:	41 54                	push   %r12
  74dc99:	53                   	push   %rbx
  74dc9a:	48 81 ec 68 01 00 00 	sub    $0x168,%rsp
  74dca1:	48 89 f3             	mov    %rsi,%rbx
  74dca4:	49 89 ff             	mov    %rdi,%r15
  74dca7:	49 c7 c4 68 f3 ff ff 	mov    $0xfffffffffffff368,%r12
  74dcae:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  74dcb5:	00 00 
  74dcb7:	4d 01 e6             	add    %r12,%r14
  74dcba:	64 41 80 bc 24 10 0c 	cmpb   $0x0,%fs:0xc10(%r12)
  74dcc1:	00 00 00 
  74dcc4:	0f 84 59 05 00 00    	je     74e223 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x593>
  74dcca:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  74dcd0:	0f 85 73 05 00 00    	jne    74e249 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x5b9>
  74dcd6:	64 49 c7 04 24 ff ff 	movq   $0xffffffffffffffff,%fs:(%r12)
  74dcdd:	ff ff 
  74dcdf:	64 41 8b 84 24 08 0c 	mov    %fs:0xc08(%r12),%eax
  74dce6:	00 00 
  74dce8:	ff c0                	inc    %eax
  74dcea:	64 41 89 84 24 08 0c 	mov    %eax,%fs:0xc08(%r12)
  74dcf1:	00 00 
  74dcf3:	83 f8 40             	cmp    $0x40,%eax
  74dcf6:	0f 83 5a 05 00 00    	jae    74e256 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x5c6>
  74dcfc:	89 c0                	mov    %eax,%eax
  74dcfe:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  74dd02:	48 c1 e0 04          	shl    $0x4,%rax
  74dd06:	0f 57 c0             	xorps  %xmm0,%xmm0
  74dd09:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  74dd0f:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  74dd15:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  74dd1b:	64 49 c7 04 24 00 00 	movq   $0x0,%fs:(%r12)
  74dd22:	00 00 
  74dd24:	0f 28 05 35 c9 90 ff 	movaps -0x6f36cb(%rip),%xmm0        # 5a660 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x860>
  74dd2b:	0f 29 84 24 50 01 00 	movaps %xmm0,0x150(%rsp)
  74dd32:	00 
  74dd33:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
  74dd3a:	00 
  74dd3b:	0f 29 84 24 30 01 00 	movaps %xmm0,0x130(%rsp)
  74dd42:	00 
  74dd43:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  74dd4a:	00 
  74dd4b:	0f 29 84 24 10 01 00 	movaps %xmm0,0x110(%rsp)
  74dd52:	00 
  74dd53:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  74dd5a:	00 
  74dd5b:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  74dd62:	00 
  74dd63:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  74dd6a:	00 
  74dd6b:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  74dd72:	00 
  74dd73:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  74dd7a:	00 
  74dd7b:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  74dd82:	00 
  74dd83:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  74dd8a:	00 
  74dd8b:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  74dd92:	00 
  74dd93:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  74dd9a:	00 
  74dd9b:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  74dda0:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  74dda5:	c7 84 24 60 01 00 00 	movl   $0x0,0x160(%rsp)
  74ddac:	00 00 00 00 
  74ddb0:	48 b8 80 02 00 00 e0 	movabs $0x1e000000280,%rax
  74ddb7:	01 00 00 
  74ddba:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  74ddbf:	c7 44 24 48 00 00 00 	movl   $0x0,0x48(%rsp)
  74ddc6:	00 
  74ddc7:	c7 44 24 50 00 00 4b 	movl   $0x434b0000,0x50(%rsp)
  74ddce:	43 
  74ddcf:	66 c7 44 24 54 00 00 	movw   $0x0,0x54(%rsp)
  74ddd6:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  74dddb:	48 8d 74 24 60       	lea    0x60(%rsp),%rsi
  74dde0:	48 8d 54 24 48       	lea    0x48(%rsp),%rdx
  74dde5:	f3 0f 10 05 5b b8 90 	movss  -0x6f47a5(%rip),%xmm0        # 59648 <anon.079f5e587c394fcac2765eb4d0cf0bc2.312.llvm.6319143315422321905+0x38>
  74ddec:	ff 
  74dded:	b9 01 00 00 00       	mov    $0x1,%ecx
  74ddf2:	45 31 c0             	xor    %r8d,%r8d
  74ddf5:	e8 b6 cc fb ff       	call   70aab0 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::mount_lanes>
  74ddfa:	83 7c 24 10 fe       	cmpl   $0xfffffffe,0x10(%rsp)
  74ddff:	0f 85 6c 04 00 00    	jne    74e271 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x5e1>
  74de05:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  74de0a:	48 83 3b 00          	cmpq   $0x0,(%rbx)
  74de0e:	0f 84 e0 03 00 00    	je     74e1f4 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x564>
  74de14:	4c 8b 73 08          	mov    0x8(%rbx),%r14
  74de18:	4d 85 f6             	test   %r14,%r14
  74de1b:	0f 84 d3 03 00 00    	je     74e1f4 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x564>
  74de21:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  74de26:	4d 8d a6 40 02 00 00 	lea    0x240(%r14),%r12
  74de2d:	4c 89 e7             	mov    %r12,%rdi
  74de30:	e8 4b 5d ff ff       	call   743b80 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>> as core::ops::drop::Drop>::drop>
  74de35:	49 8b 34 24          	mov    (%r12),%rsi
  74de39:	48 85 f6             	test   %rsi,%rsi
  74de3c:	74 16                	je     74de54 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x1c4>
  74de3e:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  74de45:	48 c1 e6 04          	shl    $0x4,%rsi
  74de49:	ba 08 00 00 00       	mov    $0x8,%edx
  74de4e:	ff 15 7c b4 3d 00    	call   *0x3db47c(%rip)        # b292d0 <_DYNAMIC+0x248>
  74de54:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  74de5b:	48 85 f6             	test   %rsi,%rsi
  74de5e:	74 16                	je     74de76 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x1e6>
  74de60:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  74de67:	48 c1 e6 03          	shl    $0x3,%rsi
  74de6b:	ba 08 00 00 00       	mov    $0x8,%edx
  74de70:	ff 15 5a b4 3d 00    	call   *0x3db45a(%rip)        # b292d0 <_DYNAMIC+0x248>
  74de76:	4d 8d a6 70 02 00 00 	lea    0x270(%r14),%r12
  74de7d:	4c 89 e7             	mov    %r12,%rdi
  74de80:	e8 fb 5c ff ff       	call   743b80 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>> as core::ops::drop::Drop>::drop>
  74de85:	49 8b 34 24          	mov    (%r12),%rsi
  74de89:	48 85 f6             	test   %rsi,%rsi
  74de8c:	74 16                	je     74dea4 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x214>
  74de8e:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  74de95:	48 c1 e6 04          	shl    $0x4,%rsi
  74de99:	ba 08 00 00 00       	mov    $0x8,%edx
  74de9e:	ff 15 2c b4 3d 00    	call   *0x3db42c(%rip)        # b292d0 <_DYNAMIC+0x248>
  74dea4:	4d 8d a6 90 02 00 00 	lea    0x290(%r14),%r12
  74deab:	4c 89 e7             	mov    %r12,%rdi
  74deae:	e8 ed 5f ff ff       	call   743ea0 <<alloc::vec::Vec<gpui::runtime::Node> as core::ops::drop::Drop>::drop>
  74deb3:	49 8b 04 24          	mov    (%r12),%rax
  74deb7:	48 85 c0             	test   %rax,%rax
  74deba:	74 1a                	je     74ded6 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x246>
  74debc:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  74dec3:	48 c1 e0 03          	shl    $0x3,%rax
  74dec7:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74decb:	ba 08 00 00 00       	mov    $0x8,%edx
  74ded0:	ff 15 fa b3 3d 00    	call   *0x3db3fa(%rip)        # b292d0 <_DYNAMIC+0x248>
  74ded6:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  74dedd:	e8 0e 2d 00 00       	call   750bf0 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  74dee2:	4d 8d a6 a8 02 00 00 	lea    0x2a8(%r14),%r12
  74dee9:	4c 89 e7             	mov    %r12,%rdi
  74deec:	e8 1f 5e ff ff       	call   743d10 <<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>> as core::ops::drop::Drop>::drop>
  74def1:	49 8b 04 24          	mov    (%r12),%rax
  74def5:	48 85 c0             	test   %rax,%rax
  74def8:	74 1a                	je     74df14 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x284>
  74defa:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  74df01:	48 c1 e0 04          	shl    $0x4,%rax
  74df05:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74df09:	ba 08 00 00 00       	mov    $0x8,%edx
  74df0e:	ff 15 bc b3 3d 00    	call   *0x3db3bc(%rip)        # b292d0 <_DYNAMIC+0x248>
  74df14:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  74df1b:	e8 00 12 00 00       	call   74f120 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  74df20:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  74df27:	48 85 c0             	test   %rax,%rax
  74df2a:	74 49                	je     74df75 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2e5>
  74df2c:	83 f8 01             	cmp    $0x1,%eax
  74df2f:	75 1e                	jne    74df4f <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2bf>
  74df31:	49 8b b6 f8 01 00 00 	mov    0x1f8(%r14),%rsi
  74df38:	48 85 f6             	test   %rsi,%rsi
  74df3b:	74 38                	je     74df75 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2e5>
  74df3d:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  74df44:	48 c1 e6 04          	shl    $0x4,%rsi
  74df48:	ba 08 00 00 00       	mov    $0x8,%edx
  74df4d:	eb 20                	jmp    74df6f <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2df>
  74df4f:	49 8b 86 f8 01 00 00 	mov    0x1f8(%r14),%rax
  74df56:	48 85 c0             	test   %rax,%rax
  74df59:	74 1a                	je     74df75 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x2e5>
  74df5b:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  74df62:	48 c1 e0 02          	shl    $0x2,%rax
  74df66:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  74df6a:	ba 04 00 00 00       	mov    $0x4,%edx
  74df6f:	ff 15 5b b3 3d 00    	call   *0x3db35b(%rip)        # b292d0 <_DYNAMIC+0x248>
  74df75:	49 8b 8e c8 05 00 00 	mov    0x5c8(%r14),%rcx
  74df7c:	48 85 c9             	test   %rcx,%rcx
  74df7f:	74 44                	je     74dfc5 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x335>
  74df81:	49 8b 96 d0 05 00 00 	mov    0x5d0(%r14),%rdx
  74df88:	49 8b 86 d8 05 00 00 	mov    0x5d8(%r14),%rax
  74df8f:	48 c7 44 24 68 00 00 	movq   $0x0,0x68(%rsp)
  74df96:	00 00 
  74df98:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  74df9d:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
  74dfa2:	48 c7 84 24 88 00 00 	movq   $0x0,0x88(%rsp)
  74dfa9:	00 00 00 00 00 
  74dfae:	48 89 8c 24 90 00 00 	mov    %rcx,0x90(%rsp)
  74dfb5:	00 
  74dfb6:	48 89 94 24 98 00 00 	mov    %rdx,0x98(%rsp)
  74dfbd:	00 
  74dfbe:	b9 01 00 00 00       	mov    $0x1,%ecx
  74dfc3:	eb 04                	jmp    74dfc9 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x339>
  74dfc5:	31 c9                	xor    %ecx,%ecx
  74dfc7:	31 c0                	xor    %eax,%eax
  74dfc9:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  74dfce:	48 89 8c 24 80 00 00 	mov    %rcx,0x80(%rsp)
  74dfd5:	00 
  74dfd6:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  74dfdd:	00 
  74dfde:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  74dfe3:	48 8d 74 24 60       	lea    0x60(%rsp),%rsi
  74dfe8:	e8 23 81 ff ff       	call   746110 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  74dfed:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  74dff2:	48 85 c0             	test   %rax,%rax
  74dff5:	74 58                	je     74e04f <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x3bf>
  74dff7:	4c 8d 64 24 10       	lea    0x10(%rsp),%r12
  74dffc:	4c 8d 6c 24 60       	lea    0x60(%rsp),%r13
  74e001:	48 8b 2d c8 b2 3d 00 	mov    0x3db2c8(%rip),%rbp        # b292d0 <_DYNAMIC+0x248>
  74e008:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  74e00f:	00 
  74e010:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  74e015:	48 c1 e1 05          	shl    $0x5,%rcx
  74e019:	48 8b 34 08          	mov    (%rax,%rcx,1),%rsi
  74e01d:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  74e021:	74 17                	je     74e03a <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x3aa>
  74e023:	48 85 f6             	test   %rsi,%rsi
  74e026:	74 12                	je     74e03a <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x3aa>
  74e028:	48 01 c8             	add    %rcx,%rax
  74e02b:	48 8b 78 08          	mov    0x8(%rax),%rdi
  74e02f:	48 c1 e6 02          	shl    $0x2,%rsi
  74e033:	ba 04 00 00 00       	mov    $0x4,%edx
  74e038:	ff d5                	call   *%rbp
  74e03a:	4c 89 e7             	mov    %r12,%rdi
  74e03d:	4c 89 ee             	mov    %r13,%rsi
  74e040:	e8 cb 80 ff ff       	call   746110 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  74e045:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  74e04a:	48 85 c0             	test   %rax,%rax
  74e04d:	75 c1                	jne    74e010 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x380>
  74e04f:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  74e056:	e8 d5 af ff ff       	call   749030 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  74e05b:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  74e062:	e8 59 14 00 00       	call   74f4c0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  74e067:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  74e06e:	e8 ed 9f ff ff       	call   748060 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  74e073:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  74e07a:	e8 51 a3 ff ff       	call   7483d0 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  74e07f:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  74e086:	e8 85 1f 00 00       	call   750010 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  74e08b:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  74e092:	48 85 f6             	test   %rsi,%rsi
  74e095:	74 16                	je     74e0ad <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x41d>
  74e097:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  74e09e:	48 c1 e6 04          	shl    $0x4,%rsi
  74e0a2:	ba 08 00 00 00       	mov    $0x8,%edx
  74e0a7:	ff 15 23 b2 3d 00    	call   *0x3db223(%rip)        # b292d0 <_DYNAMIC+0x248>
  74e0ad:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  74e0b4:	e8 27 94 ff ff       	call   7474e0 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  74e0b9:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74e0c0:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  74e0c4:	0f 84 7e 00 00 00    	je     74e148 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4b8>
  74e0ca:	4d 8b a6 98 05 00 00 	mov    0x598(%r14),%r12
  74e0d1:	4d 85 e4             	test   %r12,%r12
  74e0d4:	74 53                	je     74e129 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x499>
  74e0d6:	4d 8b ae 90 05 00 00 	mov    0x590(%r14),%r13
  74e0dd:	49 83 c5 78          	add    $0x78,%r13
  74e0e1:	48 8b 2d 20 b2 3d 00 	mov    0x3db220(%rip),%rbp        # b29308 <_DYNAMIC+0x280>
  74e0e8:	eb 0f                	jmp    74e0f9 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x469>
  74e0ea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  74e0f0:	49 83 c5 50          	add    $0x50,%r13
  74e0f4:	49 ff cc             	dec    %r12
  74e0f7:	74 29                	je     74e122 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x492>
  74e0f9:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  74e0fd:	48 85 ff             	test   %rdi,%rdi
  74e100:	74 ee                	je     74e0f0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74e102:	f6 07 01             	testb  $0x1,(%rdi)
  74e105:	75 e9                	jne    74e0f0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74e107:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74e10b:	a8 01                	test   $0x1,%al
  74e10d:	75 e1                	jne    74e0f0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74e10f:	48 8d 47 08          	lea    0x8(%rdi),%rax
  74e113:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  74e118:	75 d6                	jne    74e0f0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74e11a:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74e11e:	ff d5                	call   *%rbp
  74e120:	eb ce                	jmp    74e0f0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x460>
  74e122:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74e129:	48 85 c0             	test   %rax,%rax
  74e12c:	74 1a                	je     74e148 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4b8>
  74e12e:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  74e135:	48 c1 e0 04          	shl    $0x4,%rax
  74e139:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e13d:	ba 08 00 00 00       	mov    $0x8,%edx
  74e142:	ff 15 88 b1 3d 00    	call   *0x3db188(%rip)        # b292d0 <_DYNAMIC+0x248>
  74e148:	4d 8b a6 80 05 00 00 	mov    0x580(%r14),%r12
  74e14f:	4d 85 e4             	test   %r12,%r12
  74e152:	74 4e                	je     74e1a2 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x512>
  74e154:	4d 8b ae 78 05 00 00 	mov    0x578(%r14),%r13
  74e15b:	49 83 c5 78          	add    $0x78,%r13
  74e15f:	48 8b 2d a2 b1 3d 00 	mov    0x3db1a2(%rip),%rbp        # b29308 <_DYNAMIC+0x280>
  74e166:	eb 11                	jmp    74e179 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e9>
  74e168:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  74e16f:	00 
  74e170:	49 83 c5 50          	add    $0x50,%r13
  74e174:	49 ff cc             	dec    %r12
  74e177:	74 29                	je     74e1a2 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x512>
  74e179:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  74e17d:	48 85 ff             	test   %rdi,%rdi
  74e180:	74 ee                	je     74e170 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74e182:	f6 07 01             	testb  $0x1,(%rdi)
  74e185:	75 e9                	jne    74e170 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74e187:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74e18b:	a8 01                	test   $0x1,%al
  74e18d:	75 e1                	jne    74e170 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74e18f:	48 8d 47 08          	lea    0x8(%rdi),%rax
  74e193:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  74e198:	75 d6                	jne    74e170 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74e19a:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74e19e:	ff d5                	call   *%rbp
  74e1a0:	eb ce                	jmp    74e170 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x4e0>
  74e1a2:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  74e1a9:	48 85 c0             	test   %rax,%rax
  74e1ac:	74 1a                	je     74e1c8 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x538>
  74e1ae:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  74e1b5:	48 c1 e0 04          	shl    $0x4,%rax
  74e1b9:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e1bd:	ba 08 00 00 00       	mov    $0x8,%edx
  74e1c2:	ff 15 08 b1 3d 00    	call   *0x3db108(%rip)        # b292d0 <_DYNAMIC+0x248>
  74e1c8:	4c 89 f7             	mov    %r14,%rdi
  74e1cb:	e8 f0 23 00 00       	call   7505c0 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  74e1d0:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  74e1d7:	e8 04 0d 00 00       	call   74eee0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  74e1dc:	be 28 08 00 00       	mov    $0x828,%esi
  74e1e1:	ba 08 00 00 00       	mov    $0x8,%edx
  74e1e6:	4c 89 f7             	mov    %r14,%rdi
  74e1e9:	ff 15 e1 b0 3d 00    	call   *0x3db0e1(%rip)        # b292d0 <_DYNAMIC+0x248>
  74e1ef:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  74e1f4:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  74e1fb:	48 89 43 08          	mov    %rax,0x8(%rbx)
  74e1ff:	48 8d 35 0a da 3a 00 	lea    0x3ada0a(%rip),%rsi        # afbc10 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166>
  74e206:	4c 89 ff             	mov    %r15,%rdi
  74e209:	e8 f2 ef 01 00       	call   76d200 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  74e20e:	4c 89 f8             	mov    %r15,%rax
  74e211:	48 81 c4 68 01 00 00 	add    $0x168,%rsp
  74e218:	5b                   	pop    %rbx
  74e219:	41 5c                	pop    %r12
  74e21b:	41 5d                	pop    %r13
  74e21d:	41 5e                	pop    %r14
  74e21f:	41 5f                	pop    %r15
  74e221:	5d                   	pop    %rbp
  74e222:	c3                   	ret
  74e223:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  74e228:	4c 89 f7             	mov    %r14,%rdi
  74e22b:	31 f6                	xor    %esi,%esi
  74e22d:	ff 15 05 b6 3d 00    	call   *0x3db605(%rip)        # b29838 <memset@GLIBC_2.2.5>
  74e233:	64 41 c6 84 24 10 0c 	movb   $0x1,%fs:0xc10(%r12)
  74e23a:	00 00 01 
  74e23d:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  74e243:	0f 84 8d fa ff ff    	je     74dcd6 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x46>
  74e249:	48 8d 3d a0 e6 3a 00 	lea    0x3ae6a0(%rip),%rdi        # afc8f0 <anon.cf030bdcd33bba1955553babc00e59a7.15.llvm.14032215357312518664>
  74e250:	ff 15 ea b5 3d 00    	call   *0x3db5ea(%rip)        # b29840 <_DYNAMIC+0x7b8>
  74e256:	48 8d 3d 6b db 91 ff 	lea    -0x6e2495(%rip),%rdi        # 6bdc8 <anon.cf030bdcd33bba1955553babc00e59a7.12.llvm.14032215357312518664>
  74e25d:	48 8d 15 74 e6 3a 00 	lea    0x3ae674(%rip),%rdx        # afc8d8 <anon.cf030bdcd33bba1955553babc00e59a7.14.llvm.14032215357312518664>
  74e264:	be 4b 00 00 00       	mov    $0x4b,%esi
  74e269:	ff 15 61 b2 3d 00    	call   *0x3db261(%rip)        # b294d0 <_DYNAMIC+0x448>
  74e26f:	eb 53                	jmp    74e2c4 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x634>
  74e271:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  74e276:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  74e27d:	00 
  74e27e:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  74e283:	0f 10 4c 24 20       	movups 0x20(%rsp),%xmm1
  74e288:	0f 10 54 24 30       	movups 0x30(%rsp),%xmm2
  74e28d:	0f 29 94 24 80 00 00 	movaps %xmm2,0x80(%rsp)
  74e294:	00 
  74e295:	0f 29 4c 24 70       	movaps %xmm1,0x70(%rsp)
  74e29a:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  74e29f:	48 8d 3d 4e cc 91 ff 	lea    -0x6e33b2(%rip),%rdi        # 6aef4 <anon.2d1f820267f84878e0cbda50021465a1.8.llvm.17676285964678017166>
  74e2a6:	48 8d 0d cb d9 3a 00 	lea    0x3ad9cb(%rip),%rcx        # afbc78 <anon.2d1f820267f84878e0cbda50021465a1.7.llvm.17676285964678017166>
  74e2ad:	4c 8d 05 94 d9 3a 00 	lea    0x3ad994(%rip),%r8        # afbc48 <anon.2d1f820267f84878e0cbda50021465a1.3.llvm.17676285964678017166+0x18>
  74e2b4:	48 8d 54 24 60       	lea    0x60(%rsp),%rdx
  74e2b9:	be 2b 00 00 00       	mov    $0x2b,%esi
  74e2be:	ff 15 14 b1 3d 00    	call   *0x3db114(%rip)        # b293d8 <_DYNAMIC+0x350>
  74e2c4:	0f 0b                	ud2
  74e2c6:	49 89 c7             	mov    %rax,%r15
  74e2c9:	49 ff cc             	dec    %r12
  74e2cc:	74 0f                	je     74e2dd <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x64d>
  74e2ce:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  74e2d2:	49 83 c5 50          	add    $0x50,%r13
  74e2d6:	e8 15 3a ff ff       	call   741cf0 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  74e2db:	eb ec                	jmp    74e2c9 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x639>
  74e2dd:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74e2e4:	48 85 c0             	test   %rax,%rax
  74e2e7:	0f 84 59 02 00 00    	je     74e546 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8b6>
  74e2ed:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  74e2f4:	48 c1 e0 04          	shl    $0x4,%rax
  74e2f8:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e2fc:	ba 08 00 00 00       	mov    $0x8,%edx
  74e301:	ff 15 c9 af 3d 00    	call   *0x3dafc9(%rip)        # b292d0 <_DYNAMIC+0x248>
  74e307:	e9 3a 02 00 00       	jmp    74e546 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8b6>
  74e30c:	ff 15 ee af 3d 00    	call   *0x3dafee(%rip)        # b29300 <_DYNAMIC+0x278>
  74e312:	49 89 c7             	mov    %rax,%r15
  74e315:	49 ff cc             	dec    %r12
  74e318:	74 0f                	je     74e329 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x699>
  74e31a:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  74e31e:	49 83 c5 50          	add    $0x50,%r13
  74e322:	e8 c9 39 ff ff       	call   741cf0 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  74e327:	eb ec                	jmp    74e315 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x685>
  74e329:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  74e330:	48 85 c0             	test   %rax,%rax
  74e333:	0f 84 19 02 00 00    	je     74e552 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8c2>
  74e339:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  74e340:	48 c1 e0 04          	shl    $0x4,%rax
  74e344:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e348:	ba 08 00 00 00       	mov    $0x8,%edx
  74e34d:	ff 15 7d af 3d 00    	call   *0x3daf7d(%rip)        # b292d0 <_DYNAMIC+0x248>
  74e353:	e9 fa 01 00 00       	jmp    74e552 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8c2>
  74e358:	ff 15 a2 af 3d 00    	call   *0x3dafa2(%rip)        # b29300 <_DYNAMIC+0x278>
  74e35e:	49 89 c7             	mov    %rax,%r15
  74e361:	e9 00 02 00 00       	jmp    74e566 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8d6>
  74e366:	49 89 c7             	mov    %rax,%r15
  74e369:	e9 ec 01 00 00       	jmp    74e55a <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8ca>
  74e36e:	49 89 c7             	mov    %rax,%r15
  74e371:	e9 c4 01 00 00       	jmp    74e53a <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x8aa>
  74e376:	49 89 c7             	mov    %rax,%r15
  74e379:	e9 8e 01 00 00       	jmp    74e50c <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x87c>
  74e37e:	49 89 c7             	mov    %rax,%r15
  74e381:	e9 7a 01 00 00       	jmp    74e500 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x870>
  74e386:	49 89 c7             	mov    %rax,%r15
  74e389:	e9 66 01 00 00       	jmp    74e4f4 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x864>
  74e38e:	49 89 c7             	mov    %rax,%r15
  74e391:	e9 52 01 00 00       	jmp    74e4e8 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x858>
  74e396:	49 89 c7             	mov    %rax,%r15
  74e399:	e9 3e 01 00 00       	jmp    74e4dc <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x84c>
  74e39e:	e9 2a 01 00 00       	jmp    74e4cd <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x83d>
  74e3a3:	49 89 c7             	mov    %rax,%r15
  74e3a6:	e9 02 01 00 00       	jmp    74e4ad <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x81d>
  74e3ab:	49 89 c7             	mov    %rax,%r15
  74e3ae:	49 8b 04 24          	mov    (%r12),%rax
  74e3b2:	48 85 c0             	test   %rax,%rax
  74e3b5:	0f 84 e6 00 00 00    	je     74e4a1 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x811>
  74e3bb:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  74e3c2:	48 c1 e0 04          	shl    $0x4,%rax
  74e3c6:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e3ca:	ba 08 00 00 00       	mov    $0x8,%edx
  74e3cf:	ff 15 fb ae 3d 00    	call   *0x3daefb(%rip)        # b292d0 <_DYNAMIC+0x248>
  74e3d5:	e9 c7 00 00 00       	jmp    74e4a1 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x811>
  74e3da:	49 89 c7             	mov    %rax,%r15
  74e3dd:	49 8b 04 24          	mov    (%r12),%rax
  74e3e1:	48 85 c0             	test   %rax,%rax
  74e3e4:	0f 84 9f 00 00 00    	je     74e489 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7f9>
  74e3ea:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  74e3f1:	48 c1 e0 03          	shl    $0x3,%rax
  74e3f5:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74e3f9:	ba 08 00 00 00       	mov    $0x8,%edx
  74e3fe:	ff 15 cc ae 3d 00    	call   *0x3daecc(%rip)        # b292d0 <_DYNAMIC+0x248>
  74e404:	e9 80 00 00 00       	jmp    74e489 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7f9>
  74e409:	49 89 c7             	mov    %rax,%r15
  74e40c:	49 8b 34 24          	mov    (%r12),%rsi
  74e410:	48 85 f6             	test   %rsi,%rsi
  74e413:	74 68                	je     74e47d <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7ed>
  74e415:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  74e41c:	48 c1 e6 04          	shl    $0x4,%rsi
  74e420:	ba 08 00 00 00       	mov    $0x8,%edx
  74e425:	ff 15 a5 ae 3d 00    	call   *0x3daea5(%rip)        # b292d0 <_DYNAMIC+0x248>
  74e42b:	eb 50                	jmp    74e47d <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7ed>
  74e42d:	49 89 c7             	mov    %rax,%r15
  74e430:	49 8b 34 24          	mov    (%r12),%rsi
  74e434:	48 85 f6             	test   %rsi,%rsi
  74e437:	74 16                	je     74e44f <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7bf>
  74e439:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  74e440:	48 c1 e6 04          	shl    $0x4,%rsi
  74e444:	ba 08 00 00 00       	mov    $0x8,%edx
  74e449:	ff 15 81 ae 3d 00    	call   *0x3dae81(%rip)        # b292d0 <_DYNAMIC+0x248>
  74e44f:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  74e456:	48 85 f6             	test   %rsi,%rsi
  74e459:	74 16                	je     74e471 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x7e1>
  74e45b:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  74e462:	48 c1 e6 03          	shl    $0x3,%rsi
  74e466:	ba 08 00 00 00       	mov    $0x8,%edx
  74e46b:	ff 15 5f ae 3d 00    	call   *0x3dae5f(%rip)        # b292d0 <_DYNAMIC+0x248>
  74e471:	49 8d be 70 02 00 00 	lea    0x270(%r14),%rdi
  74e478:	e8 b3 14 00 00       	call   74f930 <core::ptr::drop_glue::<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>>>>
  74e47d:	49 8d be 90 02 00 00 	lea    0x290(%r14),%rdi
  74e484:	e8 f7 16 00 00       	call   74fb80 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Node>>>
  74e489:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  74e490:	e8 5b 27 00 00       	call   750bf0 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  74e495:	49 8d be a8 02 00 00 	lea    0x2a8(%r14),%rdi
  74e49c:	e8 1f 14 00 00       	call   74f8c0 <core::ptr::drop_glue::<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>>>>
  74e4a1:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  74e4a8:	e8 73 0c 00 00       	call   74f120 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  74e4ad:	49 8d be e8 01 00 00 	lea    0x1e8(%r14),%rdi
  74e4b4:	e8 37 26 00 00       	call   750af0 <core::ptr::drop_glue::<gpui::runtime::identity_index::IdentityIndex>>
  74e4b9:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  74e4c0:	e8 0b 94 ff ff       	call   7478d0 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout> as core::ops::drop::Drop>::drop>
  74e4c5:	eb 09                	jmp    74e4d0 <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x840>
  74e4c7:	ff 15 33 ae 3d 00    	call   *0x3dae33(%rip)        # b29300 <_DYNAMIC+0x278>
  74e4cd:	49 89 c7             	mov    %rax,%r15
  74e4d0:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  74e4d7:	e8 54 ab ff ff       	call   749030 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  74e4dc:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  74e4e3:	e8 d8 0f 00 00       	call   74f4c0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  74e4e8:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  74e4ef:	e8 6c 9b ff ff       	call   748060 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  74e4f4:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  74e4fb:	e8 d0 9e ff ff       	call   7483d0 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  74e500:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  74e507:	e8 04 1b 00 00       	call   750010 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  74e50c:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  74e513:	48 85 f6             	test   %rsi,%rsi
  74e516:	74 16                	je     74e52e <allocation_counter::measure::<unit_action_cost_two::second_ordinary_unit_action_cost::{closure#0}>+0x89e>
  74e518:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  74e51f:	48 c1 e6 04          	shl    $0x4,%rsi
  74e523:	ba 08 00 00 00       	mov    $0x8,%edx
  74e528:	ff 15 a2 ad 3d 00    	call   *0x3dada2(%rip)        # b292d0 <_DYNAMIC+0x248>
  74e52e:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  74e535:	e8 a6 8f ff ff       	call   7474e0 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  74e53a:	49 8d be 88 05 00 00 	lea    0x588(%r14),%rdi
  74e541:	e8 9a 11 00 00       	call   74f6e0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Prepared>>>
  74e546:	49 8d be 70 05 00 00 	lea    0x570(%r14),%rdi
  74e54d:	e8 9e 16 00 00       	call   74fbf0 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Presented>>>
  74e552:	4c 89 f7             	mov    %r14,%rdi
  74e555:	e8 66 20 00 00       	call   7505c0 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  74e55a:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  74e561:	e8 7a 09 00 00       	call   74eee0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  74e566:	be 28 08 00 00       	mov    $0x828,%esi
  74e56b:	ba 08 00 00 00       	mov    $0x8,%edx
  74e570:	4c 89 f7             	mov    %r14,%rdi
  74e573:	ff 15 57 ad 3d 00    	call   *0x3dad57(%rip)        # b292d0 <_DYNAMIC+0x248>
  74e579:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  74e580:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  74e585:	48 89 43 08          	mov    %rax,0x8(%rbx)
  74e589:	4c 89 ff             	mov    %r15,%rdi
  74e58c:	e8 1f af 3a 00       	call   af94b0 <_Unwind_Resume@plt>
  74e591:	ff 15 69 ad 3d 00    	call   *0x3dad69(%rip)        # b29300 <_DYNAMIC+0x278>
  74e597:	49 89 c7             	mov    %rax,%r15
  74e59a:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  74e59f:	e8 ac 23 00 00       	call   750950 <core::ptr::drop_glue::<gpui::runtime::Error>>
  74e5a4:	4c 89 ff             	mov    %r15,%rdi
  74e5a7:	e8 04 af 3a 00       	call   af94b0 <_Unwind_Resume@plt>
  74e5ac:	64 49 ff 04 24       	incq   %fs:(%r12)
  74e5b1:	48 89 c7             	mov    %rax,%rdi
  74e5b4:	e8 f7 ae 3a 00       	call   af94b0 <_Unwind_Resume@plt>
