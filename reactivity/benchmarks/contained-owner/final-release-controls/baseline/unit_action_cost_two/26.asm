
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000074bdc0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>>:
  74bdc0:	55                   	push   %rbp
  74bdc1:	41 57                	push   %r15
  74bdc3:	41 56                	push   %r14
  74bdc5:	41 55                	push   %r13
  74bdc7:	41 54                	push   %r12
  74bdc9:	53                   	push   %rbx
  74bdca:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  74bdd1:	48 89 f3             	mov    %rsi,%rbx
  74bdd4:	49 89 ff             	mov    %rdi,%r15
  74bdd7:	49 c7 c4 68 f3 ff ff 	mov    $0xfffffffffffff368,%r12
  74bdde:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  74bde5:	00 00 
  74bde7:	4d 01 e6             	add    %r12,%r14
  74bdea:	64 41 80 bc 24 10 0c 	cmpb   $0x0,%fs:0xc10(%r12)
  74bdf1:	00 00 00 
  74bdf4:	0f 84 b9 04 00 00    	je     74c2b3 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x4f3>
  74bdfa:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  74be00:	0f 85 d3 04 00 00    	jne    74c2d9 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x519>
  74be06:	64 49 c7 04 24 ff ff 	movq   $0xffffffffffffffff,%fs:(%r12)
  74be0d:	ff ff 
  74be0f:	64 41 8b 84 24 08 0c 	mov    %fs:0xc08(%r12),%eax
  74be16:	00 00 
  74be18:	ff c0                	inc    %eax
  74be1a:	64 41 89 84 24 08 0c 	mov    %eax,%fs:0xc08(%r12)
  74be21:	00 00 
  74be23:	83 f8 40             	cmp    $0x40,%eax
  74be26:	0f 83 ba 04 00 00    	jae    74c2e6 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x526>
  74be2c:	89 c0                	mov    %eax,%eax
  74be2e:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  74be32:	48 c1 e0 04          	shl    $0x4,%rax
  74be36:	0f 57 c0             	xorps  %xmm0,%xmm0
  74be39:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  74be3f:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  74be45:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  74be4b:	64 49 c7 04 24 00 00 	movq   $0x0,%fs:(%r12)
  74be52:	00 00 
  74be54:	48 b8 80 02 00 00 e0 	movabs $0x1e000000280,%rax
  74be5b:	01 00 00 
  74be5e:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  74be63:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  74be6a:	00 
  74be6b:	c7 44 24 18 00 00 4b 	movl   $0x434b0000,0x18(%rsp)
  74be72:	43 
  74be73:	66 c7 44 24 1c 00 00 	movw   $0x0,0x1c(%rsp)
  74be7a:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  74be7f:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  74be84:	f3 0f 10 05 2c d6 90 	movss  -0x6f29d4(%rip),%xmm0        # 594b8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.312.llvm.6319143315422321905+0x38>
  74be8b:	ff 
  74be8c:	31 f6                	xor    %esi,%esi
  74be8e:	b9 01 00 00 00       	mov    $0x1,%ecx
  74be93:	45 31 c0             	xor    %r8d,%r8d
  74be96:	e8 95 e7 fb ff       	call   70a630 <<gpui::runtime::Win<unit_action_cost_two::Model>>::mount_lanes>
  74be9b:	83 7c 24 60 fe       	cmpl   $0xfffffffe,0x60(%rsp)
  74bea0:	0f 85 5b 04 00 00    	jne    74c301 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x541>
  74bea6:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  74beab:	48 83 3b 00          	cmpq   $0x0,(%rbx)
  74beaf:	0f 84 cf 03 00 00    	je     74c284 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x4c4>
  74beb5:	4c 8b 73 08          	mov    0x8(%rbx),%r14
  74beb9:	4d 85 f6             	test   %r14,%r14
  74bebc:	0f 84 c2 03 00 00    	je     74c284 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x4c4>
  74bec2:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  74bec7:	4d 8d a6 40 02 00 00 	lea    0x240(%r14),%r12
  74bece:	4c 89 e7             	mov    %r12,%rdi
  74bed1:	e8 fa 67 ff ff       	call   7426d0 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>> as core::ops::drop::Drop>::drop>
  74bed6:	49 8b 34 24          	mov    (%r12),%rsi
  74beda:	48 85 f6             	test   %rsi,%rsi
  74bedd:	74 16                	je     74bef5 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x135>
  74bedf:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  74bee6:	48 c1 e6 04          	shl    $0x4,%rsi
  74beea:	ba 08 00 00 00       	mov    $0x8,%edx
  74beef:	ff 15 0b c0 3d 00    	call   *0x3dc00b(%rip)        # b27f00 <_DYNAMIC+0x248>
  74bef5:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  74befc:	48 85 f6             	test   %rsi,%rsi
  74beff:	74 16                	je     74bf17 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x157>
  74bf01:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  74bf08:	48 c1 e6 03          	shl    $0x3,%rsi
  74bf0c:	ba 08 00 00 00       	mov    $0x8,%edx
  74bf11:	ff 15 e9 bf 3d 00    	call   *0x3dbfe9(%rip)        # b27f00 <_DYNAMIC+0x248>
  74bf17:	4d 8d a6 70 02 00 00 	lea    0x270(%r14),%r12
  74bf1e:	4c 89 e7             	mov    %r12,%rdi
  74bf21:	e8 aa 67 ff ff       	call   7426d0 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::SecondModel>>> as core::ops::drop::Drop>::drop>
  74bf26:	49 8b 34 24          	mov    (%r12),%rsi
  74bf2a:	48 85 f6             	test   %rsi,%rsi
  74bf2d:	74 16                	je     74bf45 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x185>
  74bf2f:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  74bf36:	48 c1 e6 04          	shl    $0x4,%rsi
  74bf3a:	ba 08 00 00 00       	mov    $0x8,%edx
  74bf3f:	ff 15 bb bf 3d 00    	call   *0x3dbfbb(%rip)        # b27f00 <_DYNAMIC+0x248>
  74bf45:	4d 8d a6 90 02 00 00 	lea    0x290(%r14),%r12
  74bf4c:	4c 89 e7             	mov    %r12,%rdi
  74bf4f:	e8 9c 6a ff ff       	call   7429f0 <<alloc::vec::Vec<gpui::runtime::Node> as core::ops::drop::Drop>::drop>
  74bf54:	49 8b 04 24          	mov    (%r12),%rax
  74bf58:	48 85 c0             	test   %rax,%rax
  74bf5b:	74 1a                	je     74bf77 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x1b7>
  74bf5d:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  74bf64:	48 c1 e0 03          	shl    $0x3,%rax
  74bf68:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74bf6c:	ba 08 00 00 00       	mov    $0x8,%edx
  74bf71:	ff 15 89 bf 3d 00    	call   *0x3dbf89(%rip)        # b27f00 <_DYNAMIC+0x248>
  74bf77:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  74bf7e:	e8 bd 37 00 00       	call   74f740 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  74bf83:	4d 8d a6 a8 02 00 00 	lea    0x2a8(%r14),%r12
  74bf8a:	4c 89 e7             	mov    %r12,%rdi
  74bf8d:	e8 ce 68 ff ff       	call   742860 <<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>> as core::ops::drop::Drop>::drop>
  74bf92:	49 8b 04 24          	mov    (%r12),%rax
  74bf96:	48 85 c0             	test   %rax,%rax
  74bf99:	74 1a                	je     74bfb5 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x1f5>
  74bf9b:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  74bfa2:	48 c1 e0 04          	shl    $0x4,%rax
  74bfa6:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74bfaa:	ba 08 00 00 00       	mov    $0x8,%edx
  74bfaf:	ff 15 4b bf 3d 00    	call   *0x3dbf4b(%rip)        # b27f00 <_DYNAMIC+0x248>
  74bfb5:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  74bfbc:	e8 af 1c 00 00       	call   74dc70 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  74bfc1:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  74bfc8:	48 85 c0             	test   %rax,%rax
  74bfcb:	74 49                	je     74c016 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x256>
  74bfcd:	83 f8 01             	cmp    $0x1,%eax
  74bfd0:	75 1e                	jne    74bff0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x230>
  74bfd2:	49 8b b6 f8 01 00 00 	mov    0x1f8(%r14),%rsi
  74bfd9:	48 85 f6             	test   %rsi,%rsi
  74bfdc:	74 38                	je     74c016 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x256>
  74bfde:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  74bfe5:	48 c1 e6 04          	shl    $0x4,%rsi
  74bfe9:	ba 08 00 00 00       	mov    $0x8,%edx
  74bfee:	eb 20                	jmp    74c010 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x250>
  74bff0:	49 8b 86 f8 01 00 00 	mov    0x1f8(%r14),%rax
  74bff7:	48 85 c0             	test   %rax,%rax
  74bffa:	74 1a                	je     74c016 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x256>
  74bffc:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  74c003:	48 c1 e0 02          	shl    $0x2,%rax
  74c007:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  74c00b:	ba 04 00 00 00       	mov    $0x4,%edx
  74c010:	ff 15 ea be 3d 00    	call   *0x3dbeea(%rip)        # b27f00 <_DYNAMIC+0x248>
  74c016:	49 8b 8e c8 05 00 00 	mov    0x5c8(%r14),%rcx
  74c01d:	48 85 c9             	test   %rcx,%rcx
  74c020:	74 3b                	je     74c05d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x29d>
  74c022:	49 8b 96 d0 05 00 00 	mov    0x5d0(%r14),%rdx
  74c029:	49 8b 86 d8 05 00 00 	mov    0x5d8(%r14),%rax
  74c030:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
  74c037:	00 00 
  74c039:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  74c03e:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
  74c043:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  74c04a:	00 00 
  74c04c:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
  74c051:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  74c056:	b9 01 00 00 00       	mov    $0x1,%ecx
  74c05b:	eb 04                	jmp    74c061 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x2a1>
  74c05d:	31 c9                	xor    %ecx,%ecx
  74c05f:	31 c0                	xor    %eax,%eax
  74c061:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  74c066:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  74c06b:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  74c070:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  74c075:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  74c07a:	e8 e1 8b ff ff       	call   744c60 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  74c07f:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  74c084:	48 85 c0             	test   %rax,%rax
  74c087:	74 56                	je     74c0df <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x31f>
  74c089:	4c 8d 64 24 60       	lea    0x60(%rsp),%r12
  74c08e:	4c 8d 6c 24 10       	lea    0x10(%rsp),%r13
  74c093:	48 8b 2d 66 be 3d 00 	mov    0x3dbe66(%rip),%rbp        # b27f00 <_DYNAMIC+0x248>
  74c09a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  74c0a0:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  74c0a5:	48 c1 e1 05          	shl    $0x5,%rcx
  74c0a9:	48 8b 34 08          	mov    (%rax,%rcx,1),%rsi
  74c0ad:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  74c0b1:	74 17                	je     74c0ca <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x30a>
  74c0b3:	48 85 f6             	test   %rsi,%rsi
  74c0b6:	74 12                	je     74c0ca <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x30a>
  74c0b8:	48 01 c8             	add    %rcx,%rax
  74c0bb:	48 8b 78 08          	mov    0x8(%rax),%rdi
  74c0bf:	48 c1 e6 02          	shl    $0x2,%rsi
  74c0c3:	ba 04 00 00 00       	mov    $0x4,%edx
  74c0c8:	ff d5                	call   *%rbp
  74c0ca:	4c 89 e7             	mov    %r12,%rdi
  74c0cd:	4c 89 ee             	mov    %r13,%rsi
  74c0d0:	e8 8b 8b ff ff       	call   744c60 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  74c0d5:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  74c0da:	48 85 c0             	test   %rax,%rax
  74c0dd:	75 c1                	jne    74c0a0 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x2e0>
  74c0df:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  74c0e6:	e8 95 ba ff ff       	call   747b80 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  74c0eb:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  74c0f2:	e8 19 1f 00 00       	call   74e010 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  74c0f7:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  74c0fe:	e8 ad aa ff ff       	call   746bb0 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  74c103:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  74c10a:	e8 11 ae ff ff       	call   746f20 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  74c10f:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  74c116:	e8 45 2a 00 00       	call   74eb60 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  74c11b:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  74c122:	48 85 f6             	test   %rsi,%rsi
  74c125:	74 16                	je     74c13d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x37d>
  74c127:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  74c12e:	48 c1 e6 04          	shl    $0x4,%rsi
  74c132:	ba 08 00 00 00       	mov    $0x8,%edx
  74c137:	ff 15 c3 bd 3d 00    	call   *0x3dbdc3(%rip)        # b27f00 <_DYNAMIC+0x248>
  74c13d:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  74c144:	e8 e7 9e ff ff       	call   746030 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  74c149:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74c150:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  74c154:	0f 84 7e 00 00 00    	je     74c1d8 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x418>
  74c15a:	4d 8b a6 98 05 00 00 	mov    0x598(%r14),%r12
  74c161:	4d 85 e4             	test   %r12,%r12
  74c164:	74 53                	je     74c1b9 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3f9>
  74c166:	4d 8b ae 90 05 00 00 	mov    0x590(%r14),%r13
  74c16d:	49 83 c5 78          	add    $0x78,%r13
  74c171:	48 8b 2d c0 bd 3d 00 	mov    0x3dbdc0(%rip),%rbp        # b27f38 <_DYNAMIC+0x280>
  74c178:	eb 0f                	jmp    74c189 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c9>
  74c17a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  74c180:	49 83 c5 50          	add    $0x50,%r13
  74c184:	49 ff cc             	dec    %r12
  74c187:	74 29                	je     74c1b2 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3f2>
  74c189:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  74c18d:	48 85 ff             	test   %rdi,%rdi
  74c190:	74 ee                	je     74c180 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74c192:	f6 07 01             	testb  $0x1,(%rdi)
  74c195:	75 e9                	jne    74c180 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74c197:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74c19b:	a8 01                	test   $0x1,%al
  74c19d:	75 e1                	jne    74c180 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74c19f:	48 8d 47 08          	lea    0x8(%rdi),%rax
  74c1a3:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  74c1a8:	75 d6                	jne    74c180 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74c1aa:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74c1ae:	ff d5                	call   *%rbp
  74c1b0:	eb ce                	jmp    74c180 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  74c1b2:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74c1b9:	48 85 c0             	test   %rax,%rax
  74c1bc:	74 1a                	je     74c1d8 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x418>
  74c1be:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  74c1c5:	48 c1 e0 04          	shl    $0x4,%rax
  74c1c9:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74c1cd:	ba 08 00 00 00       	mov    $0x8,%edx
  74c1d2:	ff 15 28 bd 3d 00    	call   *0x3dbd28(%rip)        # b27f00 <_DYNAMIC+0x248>
  74c1d8:	4d 8b a6 80 05 00 00 	mov    0x580(%r14),%r12
  74c1df:	4d 85 e4             	test   %r12,%r12
  74c1e2:	74 4e                	je     74c232 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x472>
  74c1e4:	4d 8b ae 78 05 00 00 	mov    0x578(%r14),%r13
  74c1eb:	49 83 c5 78          	add    $0x78,%r13
  74c1ef:	48 8b 2d 42 bd 3d 00 	mov    0x3dbd42(%rip),%rbp        # b27f38 <_DYNAMIC+0x280>
  74c1f6:	eb 11                	jmp    74c209 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x449>
  74c1f8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  74c1ff:	00 
  74c200:	49 83 c5 50          	add    $0x50,%r13
  74c204:	49 ff cc             	dec    %r12
  74c207:	74 29                	je     74c232 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x472>
  74c209:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  74c20d:	48 85 ff             	test   %rdi,%rdi
  74c210:	74 ee                	je     74c200 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74c212:	f6 07 01             	testb  $0x1,(%rdi)
  74c215:	75 e9                	jne    74c200 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74c217:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74c21b:	a8 01                	test   $0x1,%al
  74c21d:	75 e1                	jne    74c200 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74c21f:	48 8d 47 08          	lea    0x8(%rdi),%rax
  74c223:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  74c228:	75 d6                	jne    74c200 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74c22a:	48 8b 47 08          	mov    0x8(%rdi),%rax
  74c22e:	ff d5                	call   *%rbp
  74c230:	eb ce                	jmp    74c200 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x440>
  74c232:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  74c239:	48 85 c0             	test   %rax,%rax
  74c23c:	74 1a                	je     74c258 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x498>
  74c23e:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  74c245:	48 c1 e0 04          	shl    $0x4,%rax
  74c249:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74c24d:	ba 08 00 00 00       	mov    $0x8,%edx
  74c252:	ff 15 a8 bc 3d 00    	call   *0x3dbca8(%rip)        # b27f00 <_DYNAMIC+0x248>
  74c258:	4c 89 f7             	mov    %r14,%rdi
  74c25b:	e8 b0 2e 00 00       	call   74f110 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  74c260:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  74c267:	e8 c4 17 00 00       	call   74da30 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  74c26c:	be 28 07 00 00       	mov    $0x728,%esi
  74c271:	ba 08 00 00 00       	mov    $0x8,%edx
  74c276:	4c 89 f7             	mov    %r14,%rdi
  74c279:	ff 15 81 bc 3d 00    	call   *0x3dbc81(%rip)        # b27f00 <_DYNAMIC+0x248>
  74c27f:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  74c284:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  74c28b:	48 89 43 08          	mov    %rax,0x8(%rbx)
  74c28f:	48 8d 35 f2 e5 3a 00 	lea    0x3ae5f2(%rip),%rsi        # afa888 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166>
  74c296:	4c 89 ff             	mov    %r15,%rdi
  74c299:	e8 f2 8c 00 00       	call   754f90 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  74c29e:	4c 89 f8             	mov    %r15,%rax
  74c2a1:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  74c2a8:	5b                   	pop    %rbx
  74c2a9:	41 5c                	pop    %r12
  74c2ab:	41 5d                	pop    %r13
  74c2ad:	41 5e                	pop    %r14
  74c2af:	41 5f                	pop    %r15
  74c2b1:	5d                   	pop    %rbp
  74c2b2:	c3                   	ret
  74c2b3:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  74c2b8:	4c 89 f7             	mov    %r14,%rdi
  74c2bb:	31 f6                	xor    %esi,%esi
  74c2bd:	ff 15 95 c1 3d 00    	call   *0x3dc195(%rip)        # b28458 <memset@GLIBC_2.2.5>
  74c2c3:	64 41 c6 84 24 10 0c 	movb   $0x1,%fs:0xc10(%r12)
  74c2ca:	00 00 01 
  74c2cd:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  74c2d3:	0f 84 2d fb ff ff    	je     74be06 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x46>
  74c2d9:	48 8d 3d 60 e9 3a 00 	lea    0x3ae960(%rip),%rdi        # afac40 <anon.cf030bdcd33bba1955553babc00e59a7.15.llvm.15067004318175258651>
  74c2e0:	ff 15 7a c1 3d 00    	call   *0x3dc17a(%rip)        # b28460 <_DYNAMIC+0x7a8>
  74c2e6:	48 8d 3d bf ed 91 ff 	lea    -0x6e1241(%rip),%rdi        # 6b0ac <anon.cf030bdcd33bba1955553babc00e59a7.12.llvm.15067004318175258651>
  74c2ed:	48 8d 15 34 e9 3a 00 	lea    0x3ae934(%rip),%rdx        # afac28 <anon.cf030bdcd33bba1955553babc00e59a7.14.llvm.15067004318175258651>
  74c2f4:	be 4b 00 00 00       	mov    $0x4b,%esi
  74c2f9:	ff 15 f1 bd 3d 00    	call   *0x3dbdf1(%rip)        # b280f0 <_DYNAMIC+0x438>
  74c2ff:	eb 53                	jmp    74c354 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x594>
  74c301:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  74c308:	00 
  74c309:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  74c30e:	0f 10 44 24 60       	movups 0x60(%rsp),%xmm0
  74c313:	0f 10 4c 24 70       	movups 0x70(%rsp),%xmm1
  74c318:	0f 10 94 24 80 00 00 	movups 0x80(%rsp),%xmm2
  74c31f:	00 
  74c320:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  74c325:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  74c32a:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  74c32f:	48 8d 3d 1e ea 91 ff 	lea    -0x6e15e2(%rip),%rdi        # 6ad54 <anon.2d1f820267f84878e0cbda50021465a1.8.llvm.17676285964678017166>
  74c336:	48 8d 0d b3 e5 3a 00 	lea    0x3ae5b3(%rip),%rcx        # afa8f0 <anon.2d1f820267f84878e0cbda50021465a1.7.llvm.17676285964678017166>
  74c33d:	4c 8d 05 4c e5 3a 00 	lea    0x3ae54c(%rip),%r8        # afa890 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166+0x8>
  74c344:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  74c349:	be 2b 00 00 00       	mov    $0x2b,%esi
  74c34e:	ff 15 b4 bc 3d 00    	call   *0x3dbcb4(%rip)        # b28008 <_DYNAMIC+0x350>
  74c354:	0f 0b                	ud2
  74c356:	49 89 c7             	mov    %rax,%r15
  74c359:	49 ff cc             	dec    %r12
  74c35c:	74 0f                	je     74c36d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x5ad>
  74c35e:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  74c362:	49 83 c5 50          	add    $0x50,%r13
  74c366:	e8 55 46 ff ff       	call   7409c0 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  74c36b:	eb ec                	jmp    74c359 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x599>
  74c36d:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  74c374:	48 85 c0             	test   %rax,%rax
  74c377:	0f 84 59 02 00 00    	je     74c5d6 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x816>
  74c37d:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  74c384:	48 c1 e0 04          	shl    $0x4,%rax
  74c388:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74c38c:	ba 08 00 00 00       	mov    $0x8,%edx
  74c391:	ff 15 69 bb 3d 00    	call   *0x3dbb69(%rip)        # b27f00 <_DYNAMIC+0x248>
  74c397:	e9 3a 02 00 00       	jmp    74c5d6 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x816>
  74c39c:	ff 15 8e bb 3d 00    	call   *0x3dbb8e(%rip)        # b27f30 <_DYNAMIC+0x278>
  74c3a2:	49 89 c7             	mov    %rax,%r15
  74c3a5:	49 ff cc             	dec    %r12
  74c3a8:	74 0f                	je     74c3b9 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x5f9>
  74c3aa:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  74c3ae:	49 83 c5 50          	add    $0x50,%r13
  74c3b2:	e8 09 46 ff ff       	call   7409c0 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  74c3b7:	eb ec                	jmp    74c3a5 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x5e5>
  74c3b9:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  74c3c0:	48 85 c0             	test   %rax,%rax
  74c3c3:	0f 84 19 02 00 00    	je     74c5e2 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x822>
  74c3c9:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  74c3d0:	48 c1 e0 04          	shl    $0x4,%rax
  74c3d4:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74c3d8:	ba 08 00 00 00       	mov    $0x8,%edx
  74c3dd:	ff 15 1d bb 3d 00    	call   *0x3dbb1d(%rip)        # b27f00 <_DYNAMIC+0x248>
  74c3e3:	e9 fa 01 00 00       	jmp    74c5e2 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x822>
  74c3e8:	ff 15 42 bb 3d 00    	call   *0x3dbb42(%rip)        # b27f30 <_DYNAMIC+0x278>
  74c3ee:	49 89 c7             	mov    %rax,%r15
  74c3f1:	e9 00 02 00 00       	jmp    74c5f6 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x836>
  74c3f6:	49 89 c7             	mov    %rax,%r15
  74c3f9:	e9 ec 01 00 00       	jmp    74c5ea <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x82a>
  74c3fe:	49 89 c7             	mov    %rax,%r15
  74c401:	e9 c4 01 00 00       	jmp    74c5ca <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x80a>
  74c406:	49 89 c7             	mov    %rax,%r15
  74c409:	e9 8e 01 00 00       	jmp    74c59c <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7dc>
  74c40e:	49 89 c7             	mov    %rax,%r15
  74c411:	e9 7a 01 00 00       	jmp    74c590 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7d0>
  74c416:	49 89 c7             	mov    %rax,%r15
  74c419:	e9 66 01 00 00       	jmp    74c584 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7c4>
  74c41e:	49 89 c7             	mov    %rax,%r15
  74c421:	e9 52 01 00 00       	jmp    74c578 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7b8>
  74c426:	49 89 c7             	mov    %rax,%r15
  74c429:	e9 3e 01 00 00       	jmp    74c56c <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7ac>
  74c42e:	e9 2a 01 00 00       	jmp    74c55d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x79d>
  74c433:	49 89 c7             	mov    %rax,%r15
  74c436:	e9 02 01 00 00       	jmp    74c53d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x77d>
  74c43b:	49 89 c7             	mov    %rax,%r15
  74c43e:	49 8b 04 24          	mov    (%r12),%rax
  74c442:	48 85 c0             	test   %rax,%rax
  74c445:	0f 84 e6 00 00 00    	je     74c531 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x771>
  74c44b:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  74c452:	48 c1 e0 04          	shl    $0x4,%rax
  74c456:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74c45a:	ba 08 00 00 00       	mov    $0x8,%edx
  74c45f:	ff 15 9b ba 3d 00    	call   *0x3dba9b(%rip)        # b27f00 <_DYNAMIC+0x248>
  74c465:	e9 c7 00 00 00       	jmp    74c531 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x771>
  74c46a:	49 89 c7             	mov    %rax,%r15
  74c46d:	49 8b 04 24          	mov    (%r12),%rax
  74c471:	48 85 c0             	test   %rax,%rax
  74c474:	0f 84 9f 00 00 00    	je     74c519 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x759>
  74c47a:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  74c481:	48 c1 e0 03          	shl    $0x3,%rax
  74c485:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  74c489:	ba 08 00 00 00       	mov    $0x8,%edx
  74c48e:	ff 15 6c ba 3d 00    	call   *0x3dba6c(%rip)        # b27f00 <_DYNAMIC+0x248>
  74c494:	e9 80 00 00 00       	jmp    74c519 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x759>
  74c499:	49 89 c7             	mov    %rax,%r15
  74c49c:	49 8b 34 24          	mov    (%r12),%rsi
  74c4a0:	48 85 f6             	test   %rsi,%rsi
  74c4a3:	74 68                	je     74c50d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x74d>
  74c4a5:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  74c4ac:	48 c1 e6 04          	shl    $0x4,%rsi
  74c4b0:	ba 08 00 00 00       	mov    $0x8,%edx
  74c4b5:	ff 15 45 ba 3d 00    	call   *0x3dba45(%rip)        # b27f00 <_DYNAMIC+0x248>
  74c4bb:	eb 50                	jmp    74c50d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x74d>
  74c4bd:	49 89 c7             	mov    %rax,%r15
  74c4c0:	49 8b 34 24          	mov    (%r12),%rsi
  74c4c4:	48 85 f6             	test   %rsi,%rsi
  74c4c7:	74 16                	je     74c4df <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x71f>
  74c4c9:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  74c4d0:	48 c1 e6 04          	shl    $0x4,%rsi
  74c4d4:	ba 08 00 00 00       	mov    $0x8,%edx
  74c4d9:	ff 15 21 ba 3d 00    	call   *0x3dba21(%rip)        # b27f00 <_DYNAMIC+0x248>
  74c4df:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  74c4e6:	48 85 f6             	test   %rsi,%rsi
  74c4e9:	74 16                	je     74c501 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x741>
  74c4eb:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  74c4f2:	48 c1 e6 03          	shl    $0x3,%rsi
  74c4f6:	ba 08 00 00 00       	mov    $0x8,%edx
  74c4fb:	ff 15 ff b9 3d 00    	call   *0x3db9ff(%rip)        # b27f00 <_DYNAMIC+0x248>
  74c501:	49 8d be 70 02 00 00 	lea    0x270(%r14),%rdi
  74c508:	e8 d3 1f 00 00       	call   74e4e0 <core::ptr::drop_glue::<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost_two::Model>>>>>
  74c50d:	49 8d be 90 02 00 00 	lea    0x290(%r14),%rdi
  74c514:	e8 b7 21 00 00       	call   74e6d0 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Node>>>
  74c519:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  74c520:	e8 1b 32 00 00       	call   74f740 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  74c525:	49 8d be a8 02 00 00 	lea    0x2a8(%r14),%rdi
  74c52c:	e8 df 1e 00 00       	call   74e410 <core::ptr::drop_glue::<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>>>>
  74c531:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  74c538:	e8 33 17 00 00       	call   74dc70 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  74c53d:	49 8d be e8 01 00 00 	lea    0x1e8(%r14),%rdi
  74c544:	e8 f7 30 00 00       	call   74f640 <core::ptr::drop_glue::<gpui::runtime::identity_index::IdentityIndex>>
  74c549:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  74c550:	e8 cb 9e ff ff       	call   746420 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout> as core::ops::drop::Drop>::drop>
  74c555:	eb 09                	jmp    74c560 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7a0>
  74c557:	ff 15 d3 b9 3d 00    	call   *0x3db9d3(%rip)        # b27f30 <_DYNAMIC+0x278>
  74c55d:	49 89 c7             	mov    %rax,%r15
  74c560:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  74c567:	e8 14 b6 ff ff       	call   747b80 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  74c56c:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  74c573:	e8 98 1a 00 00       	call   74e010 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  74c578:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  74c57f:	e8 2c a6 ff ff       	call   746bb0 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  74c584:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  74c58b:	e8 90 a9 ff ff       	call   746f20 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  74c590:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  74c597:	e8 c4 25 00 00       	call   74eb60 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  74c59c:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  74c5a3:	48 85 f6             	test   %rsi,%rsi
  74c5a6:	74 16                	je     74c5be <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>+0x7fe>
  74c5a8:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  74c5af:	48 c1 e6 04          	shl    $0x4,%rsi
  74c5b3:	ba 08 00 00 00       	mov    $0x8,%edx
  74c5b8:	ff 15 42 b9 3d 00    	call   *0x3db942(%rip)        # b27f00 <_DYNAMIC+0x248>
  74c5be:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  74c5c5:	e8 66 9a ff ff       	call   746030 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  74c5ca:	49 8d be 88 05 00 00 	lea    0x588(%r14),%rdi
  74c5d1:	e8 5a 1c 00 00       	call   74e230 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Prepared>>>
  74c5d6:	49 8d be 70 05 00 00 	lea    0x570(%r14),%rdi
  74c5dd:	e8 5e 21 00 00       	call   74e740 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Presented>>>
  74c5e2:	4c 89 f7             	mov    %r14,%rdi
  74c5e5:	e8 26 2b 00 00       	call   74f110 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  74c5ea:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  74c5f1:	e8 3a 14 00 00       	call   74da30 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  74c5f6:	be 28 07 00 00       	mov    $0x728,%esi
  74c5fb:	ba 08 00 00 00       	mov    $0x8,%edx
  74c600:	4c 89 f7             	mov    %r14,%rdi
  74c603:	ff 15 f7 b8 3d 00    	call   *0x3db8f7(%rip)        # b27f00 <_DYNAMIC+0x248>
  74c609:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  74c610:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  74c615:	48 89 43 08          	mov    %rax,0x8(%rbx)
  74c619:	4c 89 ff             	mov    %r15,%rdi
  74c61c:	e8 4f bb 3a 00       	call   af8170 <_Unwind_Resume@plt>
  74c621:	ff 15 09 b9 3d 00    	call   *0x3db909(%rip)        # b27f30 <_DYNAMIC+0x278>
  74c627:	49 89 c7             	mov    %rax,%r15
  74c62a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  74c62f:	e8 6c 2e 00 00       	call   74f4a0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  74c634:	4c 89 ff             	mov    %r15,%rdi
  74c637:	e8 34 bb 3a 00       	call   af8170 <_Unwind_Resume@plt>
  74c63c:	64 49 ff 04 24       	incq   %fs:(%r12)
  74c641:	48 89 c7             	mov    %rax,%rdi
  74c644:	e8 27 bb 3a 00       	call   af8170 <_Unwind_Resume@plt>
