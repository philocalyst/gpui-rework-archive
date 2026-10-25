
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000074dc00 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>>:
  74dc00:	41 57                	push   %r15
  74dc02:	41 56                	push   %r14
  74dc04:	41 55                	push   %r13
  74dc06:	41 54                	push   %r12
  74dc08:	53                   	push   %rbx
  74dc09:	48 83 ec 70          	sub    $0x70,%rsp
  74dc0d:	48 89 fb             	mov    %rdi,%rbx
  74dc10:	49 c7 c7 68 f3 ff ff 	mov    $0xfffffffffffff368,%r15
  74dc17:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  74dc1e:	00 00 
  74dc20:	4d 01 fe             	add    %r15,%r14
  74dc23:	64 41 80 bf 10 0c 00 	cmpb   $0x0,%fs:0xc10(%r15)
  74dc2a:	00 00 
  74dc2c:	0f 84 90 00 00 00    	je     74dcc2 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0xc2>
  74dc32:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  74dc37:	0f 85 b5 00 00 00    	jne    74dcf2 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0xf2>
  74dc3d:	64 49 c7 07 ff ff ff 	movq   $0xffffffffffffffff,%fs:(%r15)
  74dc44:	ff 
  74dc45:	64 41 8b 87 08 0c 00 	mov    %fs:0xc08(%r15),%eax
  74dc4c:	00 
  74dc4d:	ff c0                	inc    %eax
  74dc4f:	64 41 89 87 08 0c 00 	mov    %eax,%fs:0xc08(%r15)
  74dc56:	00 
  74dc57:	83 f8 40             	cmp    $0x40,%eax
  74dc5a:	0f 83 9f 00 00 00    	jae    74dcff <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0xff>
  74dc60:	89 c0                	mov    %eax,%eax
  74dc62:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  74dc66:	48 c1 e0 04          	shl    $0x4,%rax
  74dc6a:	0f 57 c0             	xorps  %xmm0,%xmm0
  74dc6d:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  74dc73:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  74dc79:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  74dc7f:	64 49 c7 07 00 00 00 	movq   $0x0,%fs:(%r15)
  74dc86:	00 
  74dc87:	48 8b 02             	mov    (%rdx),%rax
  74dc8a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  74dc8e:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
  74dc93:	48 89 c2             	mov    %rax,%rdx
  74dc96:	e8 85 e7 fb ff       	call   70c420 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click>
  74dc9b:	83 7c 24 38 fe       	cmpl   $0xfffffffe,0x38(%rsp)
  74dca0:	75 78                	jne    74dd1a <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0x11a>
  74dca2:	48 8d 35 07 e0 3a 00 	lea    0x3ae007(%rip),%rsi        # afbcb0 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166>
  74dca9:	48 89 df             	mov    %rbx,%rdi
  74dcac:	e8 4f f6 01 00       	call   76d300 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  74dcb1:	48 89 d8             	mov    %rbx,%rax
  74dcb4:	48 83 c4 70          	add    $0x70,%rsp
  74dcb8:	5b                   	pop    %rbx
  74dcb9:	41 5c                	pop    %r12
  74dcbb:	41 5d                	pop    %r13
  74dcbd:	41 5e                	pop    %r14
  74dcbf:	41 5f                	pop    %r15
  74dcc1:	c3                   	ret
  74dcc2:	49 89 d4             	mov    %rdx,%r12
  74dcc5:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  74dcca:	4c 89 f7             	mov    %r14,%rdi
  74dccd:	49 89 f5             	mov    %rsi,%r13
  74dcd0:	31 f6                	xor    %esi,%esi
  74dcd2:	ff 15 48 bc 3d 00    	call   *0x3dbc48(%rip)        # b29920 <memset@GLIBC_2.2.5>
  74dcd8:	4c 89 e2             	mov    %r12,%rdx
  74dcdb:	4c 89 ee             	mov    %r13,%rsi
  74dcde:	64 41 c6 87 10 0c 00 	movb   $0x1,%fs:0xc10(%r15)
  74dce5:	00 01 
  74dce7:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  74dcec:	0f 84 4b ff ff ff    	je     74dc3d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0x3d>
  74dcf2:	48 8d 3d bf ec 3a 00 	lea    0x3aecbf(%rip),%rdi        # afc9b8 <anon.547532fe00eaf98ca33efb65e1aed586.15.llvm.9042944481482549913>
  74dcf9:	ff 15 29 bc 3d 00    	call   *0x3dbc29(%rip)        # b29928 <_DYNAMIC+0x7b8>
  74dcff:	48 8d 3d 7a e1 91 ff 	lea    -0x6e1e86(%rip),%rdi        # 6be80 <anon.547532fe00eaf98ca33efb65e1aed586.12.llvm.9042944481482549913>
  74dd06:	48 8d 15 93 ec 3a 00 	lea    0x3aec93(%rip),%rdx        # afc9a0 <anon.547532fe00eaf98ca33efb65e1aed586.14.llvm.9042944481482549913>
  74dd0d:	be 4b 00 00 00       	mov    $0x4b,%esi
  74dd12:	ff 15 a0 b8 3d 00    	call   *0x3db8a0(%rip)        # b295b8 <_DYNAMIC+0x448>
  74dd18:	eb 4a                	jmp    74dd64 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0x164>
  74dd1a:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  74dd1f:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  74dd24:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  74dd29:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  74dd2e:	0f 10 54 24 58       	movups 0x58(%rsp),%xmm2
  74dd33:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
  74dd38:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  74dd3d:	0f 29 04 24          	movaps %xmm0,(%rsp)
  74dd41:	48 8d 3d 1c d2 91 ff 	lea    -0x6e2de4(%rip),%rdi        # 6af64 <anon.2d1f820267f84878e0cbda50021465a1.8.llvm.17676285964678017166>
  74dd48:	48 8d 0d c9 df 3a 00 	lea    0x3adfc9(%rip),%rcx        # afbd18 <anon.2d1f820267f84878e0cbda50021465a1.7.llvm.17676285964678017166>
  74dd4f:	4c 8d 05 7a df 3a 00 	lea    0x3adf7a(%rip),%r8        # afbcd0 <anon.2d1f820267f84878e0cbda50021465a1.3.llvm.17676285964678017166>
  74dd56:	48 89 e2             	mov    %rsp,%rdx
  74dd59:	be 2b 00 00 00       	mov    $0x2b,%esi
  74dd5e:	ff 15 5c b7 3d 00    	call   *0x3db75c(%rip)        # b294c0 <_DYNAMIC+0x350>
  74dd64:	0f 0b                	ud2
  74dd66:	48 89 c3             	mov    %rax,%rbx
  74dd69:	48 89 e7             	mov    %rsp,%rdi
  74dd6c:	e8 df 2c 00 00       	call   750a50 <core::ptr::drop_glue::<gpui::runtime::Error>>
  74dd71:	48 89 df             	mov    %rbx,%rdi
  74dd74:	e8 d7 b7 3a 00       	call   af9550 <_Unwind_Resume@plt>
  74dd79:	64 49 ff 07          	incq   %fs:(%r15)
  74dd7d:	48 89 c7             	mov    %rax,%rdi
  74dd80:	e8 cb b7 3a 00       	call   af9550 <_Unwind_Resume@plt>
