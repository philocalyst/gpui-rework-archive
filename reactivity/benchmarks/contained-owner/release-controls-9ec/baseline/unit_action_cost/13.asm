
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000073cb70 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>>:
  73cb70:	55                   	push   %rbp
  73cb71:	41 57                	push   %r15
  73cb73:	41 56                	push   %r14
  73cb75:	41 55                	push   %r13
  73cb77:	41 54                	push   %r12
  73cb79:	53                   	push   %rbx
  73cb7a:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  73cb81:	48 89 f3             	mov    %rsi,%rbx
  73cb84:	49 89 ff             	mov    %rdi,%r15
  73cb87:	49 c7 c4 68 f3 ff ff 	mov    $0xfffffffffffff368,%r12
  73cb8e:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  73cb95:	00 00 
  73cb97:	4d 01 e6             	add    %r12,%r14
  73cb9a:	64 41 80 bc 24 10 0c 	cmpb   $0x0,%fs:0xc10(%r12)
  73cba1:	00 00 00 
  73cba4:	0f 84 b9 04 00 00    	je     73d063 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x4f3>
  73cbaa:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  73cbb0:	0f 85 d3 04 00 00    	jne    73d089 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x519>
  73cbb6:	64 49 c7 04 24 ff ff 	movq   $0xffffffffffffffff,%fs:(%r12)
  73cbbd:	ff ff 
  73cbbf:	64 41 8b 84 24 08 0c 	mov    %fs:0xc08(%r12),%eax
  73cbc6:	00 00 
  73cbc8:	ff c0                	inc    %eax
  73cbca:	64 41 89 84 24 08 0c 	mov    %eax,%fs:0xc08(%r12)
  73cbd1:	00 00 
  73cbd3:	83 f8 40             	cmp    $0x40,%eax
  73cbd6:	0f 83 ba 04 00 00    	jae    73d096 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x526>
  73cbdc:	89 c0                	mov    %eax,%eax
  73cbde:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  73cbe2:	48 c1 e0 04          	shl    $0x4,%rax
  73cbe6:	0f 57 c0             	xorps  %xmm0,%xmm0
  73cbe9:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  73cbef:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  73cbf5:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  73cbfb:	64 49 c7 04 24 00 00 	movq   $0x0,%fs:(%r12)
  73cc02:	00 00 
  73cc04:	48 b8 80 02 00 00 e0 	movabs $0x1e000000280,%rax
  73cc0b:	01 00 00 
  73cc0e:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  73cc13:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  73cc1a:	00 
  73cc1b:	c7 44 24 18 00 00 4b 	movl   $0x434b0000,0x18(%rsp)
  73cc22:	43 
  73cc23:	66 c7 44 24 1c 00 00 	movw   $0x0,0x1c(%rsp)
  73cc2a:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  73cc2f:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  73cc34:	f3 0f 10 05 30 79 92 	movss  -0x6d86d0(%rip),%xmm0        # 6456c <anon.079f5e587c394fcac2765eb4d0cf0bc2.312.llvm.6319143315422321905+0x28>
  73cc3b:	ff 
  73cc3c:	31 f6                	xor    %esi,%esi
  73cc3e:	b9 01 00 00 00       	mov    $0x1,%ecx
  73cc43:	45 31 c0             	xor    %r8d,%r8d
  73cc46:	e8 b5 1b fd ff       	call   70e800 <<gpui::runtime::Win<unit_action_cost::Model>>::mount_lanes>
  73cc4b:	83 7c 24 60 fe       	cmpl   $0xfffffffe,0x60(%rsp)
  73cc50:	0f 85 5b 04 00 00    	jne    73d0b1 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x541>
  73cc56:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  73cc5b:	48 83 3b 00          	cmpq   $0x0,(%rbx)
  73cc5f:	0f 84 cf 03 00 00    	je     73d034 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x4c4>
  73cc65:	4c 8b 73 08          	mov    0x8(%rbx),%r14
  73cc69:	4d 85 f6             	test   %r14,%r14
  73cc6c:	0f 84 c2 03 00 00    	je     73d034 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x4c4>
  73cc72:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  73cc77:	4d 8d a6 40 02 00 00 	lea    0x240(%r14),%r12
  73cc7e:	4c 89 e7             	mov    %r12,%rdi
  73cc81:	e8 3a ef fe ff       	call   72bbc0 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost::Model>>> as core::ops::drop::Drop>::drop>
  73cc86:	49 8b 34 24          	mov    (%r12),%rsi
  73cc8a:	48 85 f6             	test   %rsi,%rsi
  73cc8d:	74 16                	je     73cca5 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x135>
  73cc8f:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  73cc96:	48 c1 e6 04          	shl    $0x4,%rsi
  73cc9a:	ba 08 00 00 00       	mov    $0x8,%edx
  73cc9f:	ff 15 93 46 3c 00    	call   *0x3c4693(%rip)        # b01338 <_DYNAMIC+0x248>
  73cca5:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  73ccac:	48 85 f6             	test   %rsi,%rsi
  73ccaf:	74 16                	je     73ccc7 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x157>
  73ccb1:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  73ccb8:	48 c1 e6 03          	shl    $0x3,%rsi
  73ccbc:	ba 08 00 00 00       	mov    $0x8,%edx
  73ccc1:	ff 15 71 46 3c 00    	call   *0x3c4671(%rip)        # b01338 <_DYNAMIC+0x248>
  73ccc7:	4d 8d a6 70 02 00 00 	lea    0x270(%r14),%r12
  73ccce:	4c 89 e7             	mov    %r12,%rdi
  73ccd1:	e8 ea ee fe ff       	call   72bbc0 <<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost::Model>>> as core::ops::drop::Drop>::drop>
  73ccd6:	49 8b 34 24          	mov    (%r12),%rsi
  73ccda:	48 85 f6             	test   %rsi,%rsi
  73ccdd:	74 16                	je     73ccf5 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x185>
  73ccdf:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  73cce6:	48 c1 e6 04          	shl    $0x4,%rsi
  73ccea:	ba 08 00 00 00       	mov    $0x8,%edx
  73ccef:	ff 15 43 46 3c 00    	call   *0x3c4643(%rip)        # b01338 <_DYNAMIC+0x248>
  73ccf5:	4d 8d a6 90 02 00 00 	lea    0x290(%r14),%r12
  73ccfc:	4c 89 e7             	mov    %r12,%rdi
  73ccff:	e8 dc f1 fe ff       	call   72bee0 <<alloc::vec::Vec<gpui::runtime::Node> as core::ops::drop::Drop>::drop>
  73cd04:	49 8b 04 24          	mov    (%r12),%rax
  73cd08:	48 85 c0             	test   %rax,%rax
  73cd0b:	74 1a                	je     73cd27 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x1b7>
  73cd0d:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  73cd14:	48 c1 e0 03          	shl    $0x3,%rax
  73cd18:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73cd1c:	ba 08 00 00 00       	mov    $0x8,%edx
  73cd21:	ff 15 11 46 3c 00    	call   *0x3c4611(%rip)        # b01338 <_DYNAMIC+0x248>
  73cd27:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  73cd2e:	e8 4d 2d 00 00       	call   73fa80 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  73cd33:	4d 8d a6 a8 02 00 00 	lea    0x2a8(%r14),%r12
  73cd3a:	4c 89 e7             	mov    %r12,%rdi
  73cd3d:	e8 0e f0 fe ff       	call   72bd50 <<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>> as core::ops::drop::Drop>::drop>
  73cd42:	49 8b 04 24          	mov    (%r12),%rax
  73cd46:	48 85 c0             	test   %rax,%rax
  73cd49:	74 1a                	je     73cd65 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x1f5>
  73cd4b:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  73cd52:	48 c1 e0 04          	shl    $0x4,%rax
  73cd56:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73cd5a:	ba 08 00 00 00       	mov    $0x8,%edx
  73cd5f:	ff 15 d3 45 3c 00    	call   *0x3c45d3(%rip)        # b01338 <_DYNAMIC+0x248>
  73cd65:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  73cd6c:	e8 cf 12 00 00       	call   73e040 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  73cd71:	49 8b 86 e8 01 00 00 	mov    0x1e8(%r14),%rax
  73cd78:	48 85 c0             	test   %rax,%rax
  73cd7b:	74 49                	je     73cdc6 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x256>
  73cd7d:	83 f8 01             	cmp    $0x1,%eax
  73cd80:	75 1e                	jne    73cda0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x230>
  73cd82:	49 8b b6 f8 01 00 00 	mov    0x1f8(%r14),%rsi
  73cd89:	48 85 f6             	test   %rsi,%rsi
  73cd8c:	74 38                	je     73cdc6 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x256>
  73cd8e:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  73cd95:	48 c1 e6 04          	shl    $0x4,%rsi
  73cd99:	ba 08 00 00 00       	mov    $0x8,%edx
  73cd9e:	eb 20                	jmp    73cdc0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x250>
  73cda0:	49 8b 86 f8 01 00 00 	mov    0x1f8(%r14),%rax
  73cda7:	48 85 c0             	test   %rax,%rax
  73cdaa:	74 1a                	je     73cdc6 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x256>
  73cdac:	49 8b be f0 01 00 00 	mov    0x1f0(%r14),%rdi
  73cdb3:	48 c1 e0 02          	shl    $0x2,%rax
  73cdb7:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  73cdbb:	ba 04 00 00 00       	mov    $0x4,%edx
  73cdc0:	ff 15 72 45 3c 00    	call   *0x3c4572(%rip)        # b01338 <_DYNAMIC+0x248>
  73cdc6:	49 8b 8e c8 05 00 00 	mov    0x5c8(%r14),%rcx
  73cdcd:	48 85 c9             	test   %rcx,%rcx
  73cdd0:	74 3b                	je     73ce0d <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x29d>
  73cdd2:	49 8b 96 d0 05 00 00 	mov    0x5d0(%r14),%rdx
  73cdd9:	49 8b 86 d8 05 00 00 	mov    0x5d8(%r14),%rax
  73cde0:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
  73cde7:	00 00 
  73cde9:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  73cdee:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
  73cdf3:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  73cdfa:	00 00 
  73cdfc:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
  73ce01:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  73ce06:	b9 01 00 00 00       	mov    $0x1,%ecx
  73ce0b:	eb 04                	jmp    73ce11 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x2a1>
  73ce0d:	31 c9                	xor    %ecx,%ecx
  73ce0f:	31 c0                	xor    %eax,%eax
  73ce11:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  73ce16:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  73ce1b:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  73ce20:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  73ce25:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  73ce2a:	e8 f1 4c fe ff       	call   721b20 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  73ce2f:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  73ce34:	48 85 c0             	test   %rax,%rax
  73ce37:	74 56                	je     73ce8f <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x31f>
  73ce39:	4c 8d 64 24 60       	lea    0x60(%rsp),%r12
  73ce3e:	4c 8d 6c 24 10       	lea    0x10(%rsp),%r13
  73ce43:	48 8b 2d ee 44 3c 00 	mov    0x3c44ee(%rip),%rbp        # b01338 <_DYNAMIC+0x248>
  73ce4a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  73ce50:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  73ce55:	48 c1 e1 05          	shl    $0x5,%rcx
  73ce59:	48 8b 34 08          	mov    (%rax,%rcx,1),%rsi
  73ce5d:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  73ce61:	74 17                	je     73ce7a <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x30a>
  73ce63:	48 85 f6             	test   %rsi,%rsi
  73ce66:	74 12                	je     73ce7a <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x30a>
  73ce68:	48 01 c8             	add    %rcx,%rax
  73ce6b:	48 8b 78 08          	mov    0x8(%rax),%rdi
  73ce6f:	48 c1 e6 02          	shl    $0x2,%rsi
  73ce73:	ba 04 00 00 00       	mov    $0x4,%edx
  73ce78:	ff d5                	call   *%rbp
  73ce7a:	4c 89 e7             	mov    %r12,%rdi
  73ce7d:	4c 89 ee             	mov    %r13,%rsi
  73ce80:	e8 9b 4c fe ff       	call   721b20 <<alloc::collections::btree::map::IntoIter<gpui::source::FieldId, gpui::runtime::Fanout>>::dying_next>
  73ce85:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  73ce8a:	48 85 c0             	test   %rax,%rax
  73ce8d:	75 c1                	jne    73ce50 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x2e0>
  73ce8f:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  73ce96:	e8 a5 7b fe ff       	call   724a40 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  73ce9b:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  73cea2:	e8 39 15 00 00       	call   73e3e0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  73cea7:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  73ceae:	e8 bd 6b fe ff       	call   723a70 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  73ceb3:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  73ceba:	e8 21 6f fe ff       	call   723de0 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  73cebf:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  73cec6:	e8 d5 1f 00 00       	call   73eea0 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  73cecb:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  73ced2:	48 85 f6             	test   %rsi,%rsi
  73ced5:	74 16                	je     73ceed <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x37d>
  73ced7:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  73cede:	48 c1 e6 04          	shl    $0x4,%rsi
  73cee2:	ba 08 00 00 00       	mov    $0x8,%edx
  73cee7:	ff 15 4b 44 3c 00    	call   *0x3c444b(%rip)        # b01338 <_DYNAMIC+0x248>
  73ceed:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  73cef4:	e8 f7 5f fe ff       	call   722ef0 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  73cef9:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  73cf00:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  73cf04:	0f 84 7e 00 00 00    	je     73cf88 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x418>
  73cf0a:	4d 8b a6 98 05 00 00 	mov    0x598(%r14),%r12
  73cf11:	4d 85 e4             	test   %r12,%r12
  73cf14:	74 53                	je     73cf69 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3f9>
  73cf16:	4d 8b ae 90 05 00 00 	mov    0x590(%r14),%r13
  73cf1d:	49 83 c5 78          	add    $0x78,%r13
  73cf21:	48 8b 2d 70 44 3c 00 	mov    0x3c4470(%rip),%rbp        # b01398 <_DYNAMIC+0x2a8>
  73cf28:	eb 0f                	jmp    73cf39 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c9>
  73cf2a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  73cf30:	49 83 c5 50          	add    $0x50,%r13
  73cf34:	49 ff cc             	dec    %r12
  73cf37:	74 29                	je     73cf62 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3f2>
  73cf39:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  73cf3d:	48 85 ff             	test   %rdi,%rdi
  73cf40:	74 ee                	je     73cf30 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73cf42:	f6 07 01             	testb  $0x1,(%rdi)
  73cf45:	75 e9                	jne    73cf30 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73cf47:	48 8b 47 08          	mov    0x8(%rdi),%rax
  73cf4b:	a8 01                	test   $0x1,%al
  73cf4d:	75 e1                	jne    73cf30 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73cf4f:	48 8d 47 08          	lea    0x8(%rdi),%rax
  73cf53:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  73cf58:	75 d6                	jne    73cf30 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73cf5a:	48 8b 47 08          	mov    0x8(%rdi),%rax
  73cf5e:	ff d5                	call   *%rbp
  73cf60:	eb ce                	jmp    73cf30 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x3c0>
  73cf62:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  73cf69:	48 85 c0             	test   %rax,%rax
  73cf6c:	74 1a                	je     73cf88 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x418>
  73cf6e:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  73cf75:	48 c1 e0 04          	shl    $0x4,%rax
  73cf79:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73cf7d:	ba 08 00 00 00       	mov    $0x8,%edx
  73cf82:	ff 15 b0 43 3c 00    	call   *0x3c43b0(%rip)        # b01338 <_DYNAMIC+0x248>
  73cf88:	4d 8b a6 80 05 00 00 	mov    0x580(%r14),%r12
  73cf8f:	4d 85 e4             	test   %r12,%r12
  73cf92:	74 4e                	je     73cfe2 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x472>
  73cf94:	4d 8b ae 78 05 00 00 	mov    0x578(%r14),%r13
  73cf9b:	49 83 c5 78          	add    $0x78,%r13
  73cf9f:	48 8b 2d f2 43 3c 00 	mov    0x3c43f2(%rip),%rbp        # b01398 <_DYNAMIC+0x2a8>
  73cfa6:	eb 11                	jmp    73cfb9 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x449>
  73cfa8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  73cfaf:	00 
  73cfb0:	49 83 c5 50          	add    $0x50,%r13
  73cfb4:	49 ff cc             	dec    %r12
  73cfb7:	74 29                	je     73cfe2 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x472>
  73cfb9:	49 8b 7d b0          	mov    -0x50(%r13),%rdi
  73cfbd:	48 85 ff             	test   %rdi,%rdi
  73cfc0:	74 ee                	je     73cfb0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73cfc2:	f6 07 01             	testb  $0x1,(%rdi)
  73cfc5:	75 e9                	jne    73cfb0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73cfc7:	48 8b 47 08          	mov    0x8(%rdi),%rax
  73cfcb:	a8 01                	test   $0x1,%al
  73cfcd:	75 e1                	jne    73cfb0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73cfcf:	48 8d 47 08          	lea    0x8(%rdi),%rax
  73cfd3:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  73cfd8:	75 d6                	jne    73cfb0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73cfda:	48 8b 47 08          	mov    0x8(%rdi),%rax
  73cfde:	ff d5                	call   *%rbp
  73cfe0:	eb ce                	jmp    73cfb0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x440>
  73cfe2:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  73cfe9:	48 85 c0             	test   %rax,%rax
  73cfec:	74 1a                	je     73d008 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x498>
  73cfee:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  73cff5:	48 c1 e0 04          	shl    $0x4,%rax
  73cff9:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73cffd:	ba 08 00 00 00       	mov    $0x8,%edx
  73d002:	ff 15 30 43 3c 00    	call   *0x3c4330(%rip)        # b01338 <_DYNAMIC+0x248>
  73d008:	4c 89 f7             	mov    %r14,%rdi
  73d00b:	e8 40 24 00 00       	call   73f450 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  73d010:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  73d017:	e8 f4 0c 00 00       	call   73dd10 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  73d01c:	be 28 07 00 00       	mov    $0x728,%esi
  73d021:	ba 08 00 00 00       	mov    $0x8,%edx
  73d026:	4c 89 f7             	mov    %r14,%rdi
  73d029:	ff 15 09 43 3c 00    	call   *0x3c4309(%rip)        # b01338 <_DYNAMIC+0x248>
  73d02f:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  73d034:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  73d03b:	48 89 43 08          	mov    %rax,0x8(%rbx)
  73d03f:	48 8d 35 7a 75 39 00 	lea    0x39757a(%rip),%rsi        # ad45c0 <anon.d860f86f9d097745b4f11ed46a5e2623.0.llvm.13997896436471750083>
  73d046:	4c 89 ff             	mov    %r15,%rdi
  73d049:	e8 72 a0 ff ff       	call   7370c0 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  73d04e:	4c 89 f8             	mov    %r15,%rax
  73d051:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  73d058:	5b                   	pop    %rbx
  73d059:	41 5c                	pop    %r12
  73d05b:	41 5d                	pop    %r13
  73d05d:	41 5e                	pop    %r14
  73d05f:	41 5f                	pop    %r15
  73d061:	5d                   	pop    %rbp
  73d062:	c3                   	ret
  73d063:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  73d068:	4c 89 f7             	mov    %r14,%rdi
  73d06b:	31 f6                	xor    %esi,%esi
  73d06d:	ff 15 5d 48 3c 00    	call   *0x3c485d(%rip)        # b018d0 <memset@GLIBC_2.2.5>
  73d073:	64 41 c6 84 24 10 0c 	movb   $0x1,%fs:0xc10(%r12)
  73d07a:	00 00 01 
  73d07d:	64 49 83 3c 24 00    	cmpq   $0x0,%fs:(%r12)
  73d083:	0f 84 2d fb ff ff    	je     73cbb6 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x46>
  73d089:	48 8d 3d 88 71 39 00 	lea    0x397188(%rip),%rdi        # ad4218 <anon.ff3cab21037877729def149be6643aa6.6.llvm.17844888298126827638>
  73d090:	ff 15 42 48 3c 00    	call   *0x3c4842(%rip)        # b018d8 <_DYNAMIC+0x7e8>
  73d096:	48 8d 3d 4f cb 92 ff 	lea    -0x6d34b1(%rip),%rdi        # 69bec <anon.ff3cab21037877729def149be6643aa6.3.llvm.17844888298126827638>
  73d09d:	48 8d 15 5c 71 39 00 	lea    0x39715c(%rip),%rdx        # ad4200 <anon.ff3cab21037877729def149be6643aa6.5.llvm.17844888298126827638>
  73d0a4:	be 4b 00 00 00       	mov    $0x4b,%esi
  73d0a9:	ff 15 e1 42 3c 00    	call   *0x3c42e1(%rip)        # b01390 <_DYNAMIC+0x2a0>
  73d0af:	eb 53                	jmp    73d104 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x594>
  73d0b1:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  73d0b8:	00 
  73d0b9:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  73d0be:	0f 10 44 24 60       	movups 0x60(%rsp),%xmm0
  73d0c3:	0f 10 4c 24 70       	movups 0x70(%rsp),%xmm1
  73d0c8:	0f 10 94 24 80 00 00 	movups 0x80(%rsp),%xmm2
  73d0cf:	00 
  73d0d0:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  73d0d5:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  73d0da:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  73d0df:	48 8d 3d aa d0 92 ff 	lea    -0x6d2f56(%rip),%rdi        # 6a190 <anon.d860f86f9d097745b4f11ed46a5e2623.5.llvm.13997896436471750083>
  73d0e6:	48 8d 0d 0b 75 39 00 	lea    0x39750b(%rip),%rcx        # ad45f8 <anon.d860f86f9d097745b4f11ed46a5e2623.4.llvm.13997896436471750083>
  73d0ed:	4c 8d 05 d4 74 39 00 	lea    0x3974d4(%rip),%r8        # ad45c8 <anon.d860f86f9d097745b4f11ed46a5e2623.0.llvm.13997896436471750083+0x8>
  73d0f4:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  73d0f9:	be 2b 00 00 00       	mov    $0x2b,%esi
  73d0fe:	ff 15 5c 43 3c 00    	call   *0x3c435c(%rip)        # b01460 <_DYNAMIC+0x370>
  73d104:	0f 0b                	ud2
  73d106:	49 89 c7             	mov    %rax,%r15
  73d109:	49 ff cc             	dec    %r12
  73d10c:	74 0f                	je     73d11d <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x5ad>
  73d10e:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  73d112:	49 83 c5 50          	add    $0x50,%r13
  73d116:	e8 25 cd fe ff       	call   729e40 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  73d11b:	eb ec                	jmp    73d109 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x599>
  73d11d:	49 8b 86 88 05 00 00 	mov    0x588(%r14),%rax
  73d124:	48 85 c0             	test   %rax,%rax
  73d127:	0f 84 59 02 00 00    	je     73d386 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x816>
  73d12d:	49 8b be 90 05 00 00 	mov    0x590(%r14),%rdi
  73d134:	48 c1 e0 04          	shl    $0x4,%rax
  73d138:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73d13c:	ba 08 00 00 00       	mov    $0x8,%edx
  73d141:	ff 15 f1 41 3c 00    	call   *0x3c41f1(%rip)        # b01338 <_DYNAMIC+0x248>
  73d147:	e9 3a 02 00 00       	jmp    73d386 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x816>
  73d14c:	ff 15 36 42 3c 00    	call   *0x3c4236(%rip)        # b01388 <_DYNAMIC+0x298>
  73d152:	49 89 c7             	mov    %rax,%r15
  73d155:	49 ff cc             	dec    %r12
  73d158:	74 0f                	je     73d169 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x5f9>
  73d15a:	49 8b 7d 00          	mov    0x0(%r13),%rdi
  73d15e:	49 83 c5 50          	add    $0x50,%r13
  73d162:	e8 d9 cc fe ff       	call   729e40 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  73d167:	eb ec                	jmp    73d155 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x5e5>
  73d169:	49 8b 86 70 05 00 00 	mov    0x570(%r14),%rax
  73d170:	48 85 c0             	test   %rax,%rax
  73d173:	0f 84 19 02 00 00    	je     73d392 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x822>
  73d179:	49 8b be 78 05 00 00 	mov    0x578(%r14),%rdi
  73d180:	48 c1 e0 04          	shl    $0x4,%rax
  73d184:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73d188:	ba 08 00 00 00       	mov    $0x8,%edx
  73d18d:	ff 15 a5 41 3c 00    	call   *0x3c41a5(%rip)        # b01338 <_DYNAMIC+0x248>
  73d193:	e9 fa 01 00 00       	jmp    73d392 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x822>
  73d198:	ff 15 ea 41 3c 00    	call   *0x3c41ea(%rip)        # b01388 <_DYNAMIC+0x298>
  73d19e:	49 89 c7             	mov    %rax,%r15
  73d1a1:	e9 00 02 00 00       	jmp    73d3a6 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x836>
  73d1a6:	49 89 c7             	mov    %rax,%r15
  73d1a9:	e9 ec 01 00 00       	jmp    73d39a <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x82a>
  73d1ae:	49 89 c7             	mov    %rax,%r15
  73d1b1:	e9 c4 01 00 00       	jmp    73d37a <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x80a>
  73d1b6:	49 89 c7             	mov    %rax,%r15
  73d1b9:	e9 8e 01 00 00       	jmp    73d34c <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7dc>
  73d1be:	49 89 c7             	mov    %rax,%r15
  73d1c1:	e9 7a 01 00 00       	jmp    73d340 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7d0>
  73d1c6:	49 89 c7             	mov    %rax,%r15
  73d1c9:	e9 66 01 00 00       	jmp    73d334 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7c4>
  73d1ce:	49 89 c7             	mov    %rax,%r15
  73d1d1:	e9 52 01 00 00       	jmp    73d328 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7b8>
  73d1d6:	49 89 c7             	mov    %rax,%r15
  73d1d9:	e9 3e 01 00 00       	jmp    73d31c <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7ac>
  73d1de:	e9 2a 01 00 00       	jmp    73d30d <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x79d>
  73d1e3:	49 89 c7             	mov    %rax,%r15
  73d1e6:	e9 02 01 00 00       	jmp    73d2ed <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x77d>
  73d1eb:	49 89 c7             	mov    %rax,%r15
  73d1ee:	49 8b 04 24          	mov    (%r12),%rax
  73d1f2:	48 85 c0             	test   %rax,%rax
  73d1f5:	0f 84 e6 00 00 00    	je     73d2e1 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x771>
  73d1fb:	49 8b be b0 02 00 00 	mov    0x2b0(%r14),%rdi
  73d202:	48 c1 e0 04          	shl    $0x4,%rax
  73d206:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73d20a:	ba 08 00 00 00       	mov    $0x8,%edx
  73d20f:	ff 15 23 41 3c 00    	call   *0x3c4123(%rip)        # b01338 <_DYNAMIC+0x248>
  73d215:	e9 c7 00 00 00       	jmp    73d2e1 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x771>
  73d21a:	49 89 c7             	mov    %rax,%r15
  73d21d:	49 8b 04 24          	mov    (%r12),%rax
  73d221:	48 85 c0             	test   %rax,%rax
  73d224:	0f 84 9f 00 00 00    	je     73d2c9 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x759>
  73d22a:	49 8b be 98 02 00 00 	mov    0x298(%r14),%rdi
  73d231:	48 c1 e0 03          	shl    $0x3,%rax
  73d235:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  73d239:	ba 08 00 00 00       	mov    $0x8,%edx
  73d23e:	ff 15 f4 40 3c 00    	call   *0x3c40f4(%rip)        # b01338 <_DYNAMIC+0x248>
  73d244:	e9 80 00 00 00       	jmp    73d2c9 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x759>
  73d249:	49 89 c7             	mov    %rax,%r15
  73d24c:	49 8b 34 24          	mov    (%r12),%rsi
  73d250:	48 85 f6             	test   %rsi,%rsi
  73d253:	74 68                	je     73d2bd <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x74d>
  73d255:	49 8b be 78 02 00 00 	mov    0x278(%r14),%rdi
  73d25c:	48 c1 e6 04          	shl    $0x4,%rsi
  73d260:	ba 08 00 00 00       	mov    $0x8,%edx
  73d265:	ff 15 cd 40 3c 00    	call   *0x3c40cd(%rip)        # b01338 <_DYNAMIC+0x248>
  73d26b:	eb 50                	jmp    73d2bd <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x74d>
  73d26d:	49 89 c7             	mov    %rax,%r15
  73d270:	49 8b 34 24          	mov    (%r12),%rsi
  73d274:	48 85 f6             	test   %rsi,%rsi
  73d277:	74 16                	je     73d28f <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x71f>
  73d279:	49 8b be 48 02 00 00 	mov    0x248(%r14),%rdi
  73d280:	48 c1 e6 04          	shl    $0x4,%rsi
  73d284:	ba 08 00 00 00       	mov    $0x8,%edx
  73d289:	ff 15 a9 40 3c 00    	call   *0x3c40a9(%rip)        # b01338 <_DYNAMIC+0x248>
  73d28f:	49 8b b6 58 02 00 00 	mov    0x258(%r14),%rsi
  73d296:	48 85 f6             	test   %rsi,%rsi
  73d299:	74 16                	je     73d2b1 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x741>
  73d29b:	49 8b be 60 02 00 00 	mov    0x260(%r14),%rdi
  73d2a2:	48 c1 e6 03          	shl    $0x3,%rsi
  73d2a6:	ba 08 00 00 00       	mov    $0x8,%edx
  73d2ab:	ff 15 87 40 3c 00    	call   *0x3c4087(%rip)        # b01338 <_DYNAMIC+0x248>
  73d2b1:	49 8d be 70 02 00 00 	lea    0x270(%r14),%rdi
  73d2b8:	e8 93 15 00 00       	call   73e850 <core::ptr::drop_glue::<alloc::vec::Vec<alloc::boxed::Box<dyn gpui::source::ComponentSchema<unit_action_cost::Model>>>>>
  73d2bd:	49 8d be 90 02 00 00 	lea    0x290(%r14),%rdi
  73d2c4:	e8 77 17 00 00       	call   73ea40 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Node>>>
  73d2c9:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  73d2d0:	e8 ab 27 00 00       	call   73fa80 <core::ptr::drop_glue::<gpui::runtime::styles::Styles>>
  73d2d5:	49 8d be a8 02 00 00 	lea    0x2a8(%r14),%rdi
  73d2dc:	e8 ff 14 00 00       	call   73e7e0 <core::ptr::drop_glue::<alloc::vec::Vec<core::option::Option<gpui::runtime::TextSite>>>>
  73d2e1:	49 8b be c0 05 00 00 	mov    0x5c0(%r14),%rdi
  73d2e8:	e8 53 0d 00 00       	call   73e040 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::image::Images>>>>
  73d2ed:	49 8d be e8 01 00 00 	lea    0x1e8(%r14),%rdi
  73d2f4:	e8 87 26 00 00       	call   73f980 <core::ptr::drop_glue::<gpui::runtime::identity_index::IdentityIndex>>
  73d2f9:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  73d300:	e8 db 5f fe ff       	call   7232e0 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout> as core::ops::drop::Drop>::drop>
  73d305:	eb 09                	jmp    73d310 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7a0>
  73d307:	ff 15 7b 40 3c 00    	call   *0x3c407b(%rip)        # b01388 <_DYNAMIC+0x298>
  73d30d:	49 89 c7             	mov    %rax,%r15
  73d310:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  73d317:	e8 24 77 fe ff       	call   724a40 <<alloc::collections::btree::map::BTreeMap<u64, gpui::property::Overlay<gpui::style::Style>> as core::ops::drop::Drop>::drop>
  73d31c:	49 8b be 10 06 00 00 	mov    0x610(%r14),%rdi
  73d323:	e8 b8 10 00 00       	call   73e3e0 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::metadata::Metadata>>>>
  73d328:	49 8d be 18 06 00 00 	lea    0x618(%r14),%rdi
  73d32f:	e8 3c 67 fe ff       	call   723a70 <<alloc::collections::btree::map::BTreeMap<gpui::runtime::scroll::ViewportKey, gpui::runtime::scroll::ViewportState> as core::ops::drop::Drop>::drop>
  73d334:	49 8d be 30 06 00 00 	lea    0x630(%r14),%rdi
  73d33b:	e8 a0 6a fe ff       	call   723de0 <<alloc::collections::btree::map::BTreeMap<(core::option::Option<u64>, gpui::list::ListId, gpui::element::NodeKind), usize> as core::ops::drop::Drop>::drop>
  73d340:	49 8d be c0 02 00 00 	lea    0x2c0(%r14),%rdi
  73d347:	e8 54 1b 00 00       	call   73eea0 <core::ptr::drop_glue::<gpui_reactivity_core::layout::LayoutTree>>
  73d34c:	49 8b b6 58 05 00 00 	mov    0x558(%r14),%rsi
  73d353:	48 85 f6             	test   %rsi,%rsi
  73d356:	74 16                	je     73d36e <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#0}>+0x7fe>
  73d358:	49 8b be 60 05 00 00 	mov    0x560(%r14),%rdi
  73d35f:	48 c1 e6 04          	shl    $0x4,%rsi
  73d363:	ba 08 00 00 00       	mov    $0x8,%edx
  73d368:	ff 15 ca 3f 3c 00    	call   *0x3c3fca(%rip)        # b01338 <_DYNAMIC+0x248>
  73d36e:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  73d375:	e8 76 5b fe ff       	call   722ef0 <<alloc::collections::btree::map::BTreeMap<gpui::list::ListId, alloc::collections::btree::set_val::SetValZST> as core::ops::drop::Drop>::drop>
  73d37a:	49 8d be 88 05 00 00 	lea    0x588(%r14),%rdi
  73d381:	e8 7a 12 00 00       	call   73e600 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Prepared>>>
  73d386:	49 8d be 70 05 00 00 	lea    0x570(%r14),%rdi
  73d38d:	e8 1e 17 00 00       	call   73eab0 <core::ptr::drop_glue::<alloc::vec::Vec<gpui::runtime::Presented>>>
  73d392:	4c 89 f7             	mov    %r14,%rdi
  73d395:	e8 b6 20 00 00       	call   73f450 <core::ptr::drop_glue::<gpui_canvas::canvas::Canvas>>
  73d39a:	49 8b be 98 06 00 00 	mov    0x698(%r14),%rdi
  73d3a1:	e8 6a 09 00 00       	call   73dd10 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::text_geometry::TextResources>>>>
  73d3a6:	be 28 07 00 00       	mov    $0x728,%esi
  73d3ab:	ba 08 00 00 00       	mov    $0x8,%edx
  73d3b0:	4c 89 f7             	mov    %r14,%rdi
  73d3b3:	ff 15 7f 3f 3c 00    	call   *0x3c3f7f(%rip)        # b01338 <_DYNAMIC+0x248>
  73d3b9:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  73d3c0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  73d3c5:	48 89 43 08          	mov    %rax,0x8(%rbx)
  73d3c9:	4c 89 ff             	mov    %r15,%rdi
  73d3cc:	e8 0f 44 39 00       	call   ad17e0 <_Unwind_Resume@plt>
  73d3d1:	ff 15 b1 3f 3c 00    	call   *0x3c3fb1(%rip)        # b01388 <_DYNAMIC+0x298>
  73d3d7:	49 89 c7             	mov    %rax,%r15
  73d3da:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  73d3df:	e8 fc 23 00 00       	call   73f7e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  73d3e4:	4c 89 ff             	mov    %r15,%rdi
  73d3e7:	e8 f4 43 39 00       	call   ad17e0 <_Unwind_Resume@plt>
  73d3ec:	64 49 ff 04 24       	incq   %fs:(%r12)
  73d3f1:	48 89 c7             	mov    %rax,%rdi
  73d3f4:	e8 e7 43 39 00       	call   ad17e0 <_Unwind_Resume@plt>
