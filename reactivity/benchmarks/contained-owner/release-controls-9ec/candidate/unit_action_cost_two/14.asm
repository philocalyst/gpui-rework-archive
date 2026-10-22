
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000074db90 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>>:
  74db90:	41 57                	push   %r15
  74db92:	41 56                	push   %r14
  74db94:	41 55                	push   %r13
  74db96:	41 54                	push   %r12
  74db98:	53                   	push   %rbx
  74db99:	48 83 ec 70          	sub    $0x70,%rsp
  74db9d:	48 89 fb             	mov    %rdi,%rbx
  74dba0:	49 c7 c7 68 f3 ff ff 	mov    $0xfffffffffffff368,%r15
  74dba7:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  74dbae:	00 00 
  74dbb0:	4d 01 fe             	add    %r15,%r14
  74dbb3:	64 41 80 bf 10 0c 00 	cmpb   $0x0,%fs:0xc10(%r15)
  74dbba:	00 00 
  74dbbc:	0f 84 90 00 00 00    	je     74dc52 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0xc2>
  74dbc2:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  74dbc7:	0f 85 b5 00 00 00    	jne    74dc82 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0xf2>
  74dbcd:	64 49 c7 07 ff ff ff 	movq   $0xffffffffffffffff,%fs:(%r15)
  74dbd4:	ff 
  74dbd5:	64 41 8b 87 08 0c 00 	mov    %fs:0xc08(%r15),%eax
  74dbdc:	00 
  74dbdd:	ff c0                	inc    %eax
  74dbdf:	64 41 89 87 08 0c 00 	mov    %eax,%fs:0xc08(%r15)
  74dbe6:	00 
  74dbe7:	83 f8 40             	cmp    $0x40,%eax
  74dbea:	0f 83 9f 00 00 00    	jae    74dc8f <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0xff>
  74dbf0:	89 c0                	mov    %eax,%eax
  74dbf2:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  74dbf6:	48 c1 e0 04          	shl    $0x4,%rax
  74dbfa:	0f 57 c0             	xorps  %xmm0,%xmm0
  74dbfd:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  74dc03:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  74dc09:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  74dc0f:	64 49 c7 07 00 00 00 	movq   $0x0,%fs:(%r15)
  74dc16:	00 
  74dc17:	48 8b 02             	mov    (%rdx),%rax
  74dc1a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  74dc1e:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
  74dc23:	48 89 c2             	mov    %rax,%rdx
  74dc26:	e8 85 e7 fb ff       	call   70c3b0 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click>
  74dc2b:	83 7c 24 38 fe       	cmpl   $0xfffffffe,0x38(%rsp)
  74dc30:	75 78                	jne    74dcaa <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0x11a>
  74dc32:	48 8d 35 07 e0 3a 00 	lea    0x3ae007(%rip),%rsi        # afbc40 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166>
  74dc39:	48 89 df             	mov    %rbx,%rdi
  74dc3c:	e8 4f f6 01 00       	call   76d290 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  74dc41:	48 89 d8             	mov    %rbx,%rax
  74dc44:	48 83 c4 70          	add    $0x70,%rsp
  74dc48:	5b                   	pop    %rbx
  74dc49:	41 5c                	pop    %r12
  74dc4b:	41 5d                	pop    %r13
  74dc4d:	41 5e                	pop    %r14
  74dc4f:	41 5f                	pop    %r15
  74dc51:	c3                   	ret
  74dc52:	49 89 d4             	mov    %rdx,%r12
  74dc55:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  74dc5a:	4c 89 f7             	mov    %r14,%rdi
  74dc5d:	49 89 f5             	mov    %rsi,%r13
  74dc60:	31 f6                	xor    %esi,%esi
  74dc62:	ff 15 48 bc 3d 00    	call   *0x3dbc48(%rip)        # b298b0 <memset@GLIBC_2.2.5>
  74dc68:	4c 89 e2             	mov    %r12,%rdx
  74dc6b:	4c 89 ee             	mov    %r13,%rsi
  74dc6e:	64 41 c6 87 10 0c 00 	movb   $0x1,%fs:0xc10(%r15)
  74dc75:	00 01 
  74dc77:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  74dc7c:	0f 84 4b ff ff ff    	je     74dbcd <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0x3d>
  74dc82:	48 8d 3d bf ec 3a 00 	lea    0x3aecbf(%rip),%rdi        # afc948 <anon.547532fe00eaf98ca33efb65e1aed586.15.llvm.9042944481482549913>
  74dc89:	ff 15 29 bc 3d 00    	call   *0x3dbc29(%rip)        # b298b8 <_DYNAMIC+0x7b8>
  74dc8f:	48 8d 3d da e1 91 ff 	lea    -0x6e1e26(%rip),%rdi        # 6be70 <anon.547532fe00eaf98ca33efb65e1aed586.12.llvm.9042944481482549913>
  74dc96:	48 8d 15 93 ec 3a 00 	lea    0x3aec93(%rip),%rdx        # afc930 <anon.547532fe00eaf98ca33efb65e1aed586.14.llvm.9042944481482549913>
  74dc9d:	be 4b 00 00 00       	mov    $0x4b,%esi
  74dca2:	ff 15 a0 b8 3d 00    	call   *0x3db8a0(%rip)        # b29548 <_DYNAMIC+0x448>
  74dca8:	eb 4a                	jmp    74dcf4 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0x164>
  74dcaa:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  74dcaf:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  74dcb4:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  74dcb9:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  74dcbe:	0f 10 54 24 58       	movups 0x58(%rsp),%xmm2
  74dcc3:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
  74dcc8:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  74dccd:	0f 29 04 24          	movaps %xmm0,(%rsp)
  74dcd1:	48 8d 3d 7c d2 91 ff 	lea    -0x6e2d84(%rip),%rdi        # 6af54 <anon.2d1f820267f84878e0cbda50021465a1.8.llvm.17676285964678017166>
  74dcd8:	48 8d 0d c9 df 3a 00 	lea    0x3adfc9(%rip),%rcx        # afbca8 <anon.2d1f820267f84878e0cbda50021465a1.7.llvm.17676285964678017166>
  74dcdf:	4c 8d 05 7a df 3a 00 	lea    0x3adf7a(%rip),%r8        # afbc60 <anon.2d1f820267f84878e0cbda50021465a1.3.llvm.17676285964678017166>
  74dce6:	48 89 e2             	mov    %rsp,%rdx
  74dce9:	be 2b 00 00 00       	mov    $0x2b,%esi
  74dcee:	ff 15 5c b7 3d 00    	call   *0x3db75c(%rip)        # b29450 <_DYNAMIC+0x350>
  74dcf4:	0f 0b                	ud2
  74dcf6:	48 89 c3             	mov    %rax,%rbx
  74dcf9:	48 89 e7             	mov    %rsp,%rdi
  74dcfc:	e8 df 2c 00 00       	call   7509e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  74dd01:	48 89 df             	mov    %rbx,%rdi
  74dd04:	e8 d7 b7 3a 00       	call   af94e0 <_Unwind_Resume@plt>
  74dd09:	64 49 ff 07          	incq   %fs:(%r15)
  74dd0d:	48 89 c7             	mov    %rax,%rdi
  74dd10:	e8 cb b7 3a 00       	call   af94e0 <_Unwind_Resume@plt>
