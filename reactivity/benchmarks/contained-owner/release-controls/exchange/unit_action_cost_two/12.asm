
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000074db00 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>>:
  74db00:	41 57                	push   %r15
  74db02:	41 56                	push   %r14
  74db04:	41 55                	push   %r13
  74db06:	41 54                	push   %r12
  74db08:	53                   	push   %rbx
  74db09:	48 83 ec 70          	sub    $0x70,%rsp
  74db0d:	48 89 fb             	mov    %rdi,%rbx
  74db10:	49 c7 c7 68 f3 ff ff 	mov    $0xfffffffffffff368,%r15
  74db17:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  74db1e:	00 00 
  74db20:	4d 01 fe             	add    %r15,%r14
  74db23:	64 41 80 bf 10 0c 00 	cmpb   $0x0,%fs:0xc10(%r15)
  74db2a:	00 00 
  74db2c:	0f 84 90 00 00 00    	je     74dbc2 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0xc2>
  74db32:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  74db37:	0f 85 b5 00 00 00    	jne    74dbf2 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0xf2>
  74db3d:	64 49 c7 07 ff ff ff 	movq   $0xffffffffffffffff,%fs:(%r15)
  74db44:	ff 
  74db45:	64 41 8b 87 08 0c 00 	mov    %fs:0xc08(%r15),%eax
  74db4c:	00 
  74db4d:	ff c0                	inc    %eax
  74db4f:	64 41 89 87 08 0c 00 	mov    %eax,%fs:0xc08(%r15)
  74db56:	00 
  74db57:	83 f8 40             	cmp    $0x40,%eax
  74db5a:	0f 83 9f 00 00 00    	jae    74dbff <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0xff>
  74db60:	89 c0                	mov    %eax,%eax
  74db62:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  74db66:	48 c1 e0 04          	shl    $0x4,%rax
  74db6a:	0f 57 c0             	xorps  %xmm0,%xmm0
  74db6d:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  74db73:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  74db79:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  74db7f:	64 49 c7 07 00 00 00 	movq   $0x0,%fs:(%r15)
  74db86:	00 
  74db87:	48 8b 02             	mov    (%rdx),%rax
  74db8a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  74db8e:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
  74db93:	48 89 c2             	mov    %rax,%rdx
  74db96:	e8 85 e7 fb ff       	call   70c320 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click>
  74db9b:	83 7c 24 38 fe       	cmpl   $0xfffffffe,0x38(%rsp)
  74dba0:	75 78                	jne    74dc1a <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0x11a>
  74dba2:	48 8d 35 67 e0 3a 00 	lea    0x3ae067(%rip),%rsi        # afbc10 <anon.2d1f820267f84878e0cbda50021465a1.0.llvm.17676285964678017166>
  74dba9:	48 89 df             	mov    %rbx,%rdi
  74dbac:	e8 4f f6 01 00       	call   76d200 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost_two::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  74dbb1:	48 89 d8             	mov    %rbx,%rax
  74dbb4:	48 83 c4 70          	add    $0x70,%rsp
  74dbb8:	5b                   	pop    %rbx
  74dbb9:	41 5c                	pop    %r12
  74dbbb:	41 5d                	pop    %r13
  74dbbd:	41 5e                	pop    %r14
  74dbbf:	41 5f                	pop    %r15
  74dbc1:	c3                   	ret
  74dbc2:	49 89 d4             	mov    %rdx,%r12
  74dbc5:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  74dbca:	4c 89 f7             	mov    %r14,%rdi
  74dbcd:	49 89 f5             	mov    %rsi,%r13
  74dbd0:	31 f6                	xor    %esi,%esi
  74dbd2:	ff 15 60 bc 3d 00    	call   *0x3dbc60(%rip)        # b29838 <memset@GLIBC_2.2.5>
  74dbd8:	4c 89 e2             	mov    %r12,%rdx
  74dbdb:	4c 89 ee             	mov    %r13,%rsi
  74dbde:	64 41 c6 87 10 0c 00 	movb   $0x1,%fs:0xc10(%r15)
  74dbe5:	00 01 
  74dbe7:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  74dbec:	0f 84 4b ff ff ff    	je     74db3d <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0x3d>
  74dbf2:	48 8d 3d f7 ec 3a 00 	lea    0x3aecf7(%rip),%rdi        # afc8f0 <anon.cf030bdcd33bba1955553babc00e59a7.15.llvm.14032215357312518664>
  74dbf9:	ff 15 41 bc 3d 00    	call   *0x3dbc41(%rip)        # b29840 <_DYNAMIC+0x7b8>
  74dbff:	48 8d 3d c2 e1 91 ff 	lea    -0x6e1e3e(%rip),%rdi        # 6bdc8 <anon.cf030bdcd33bba1955553babc00e59a7.12.llvm.14032215357312518664>
  74dc06:	48 8d 15 cb ec 3a 00 	lea    0x3aeccb(%rip),%rdx        # afc8d8 <anon.cf030bdcd33bba1955553babc00e59a7.14.llvm.14032215357312518664>
  74dc0d:	be 4b 00 00 00       	mov    $0x4b,%esi
  74dc12:	ff 15 b8 b8 3d 00    	call   *0x3db8b8(%rip)        # b294d0 <_DYNAMIC+0x448>
  74dc18:	eb 4a                	jmp    74dc64 <allocation_counter::measure::<unit_action_cost_two::ordinary_unit_action_cost::{closure#1}>+0x164>
  74dc1a:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  74dc1f:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  74dc24:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  74dc29:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  74dc2e:	0f 10 54 24 58       	movups 0x58(%rsp),%xmm2
  74dc33:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
  74dc38:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  74dc3d:	0f 29 04 24          	movaps %xmm0,(%rsp)
  74dc41:	48 8d 3d ac d2 91 ff 	lea    -0x6e2d54(%rip),%rdi        # 6aef4 <anon.2d1f820267f84878e0cbda50021465a1.8.llvm.17676285964678017166>
  74dc48:	48 8d 0d 29 e0 3a 00 	lea    0x3ae029(%rip),%rcx        # afbc78 <anon.2d1f820267f84878e0cbda50021465a1.7.llvm.17676285964678017166>
  74dc4f:	4c 8d 05 da df 3a 00 	lea    0x3adfda(%rip),%r8        # afbc30 <anon.2d1f820267f84878e0cbda50021465a1.3.llvm.17676285964678017166>
  74dc56:	48 89 e2             	mov    %rsp,%rdx
  74dc59:	be 2b 00 00 00       	mov    $0x2b,%esi
  74dc5e:	ff 15 74 b7 3d 00    	call   *0x3db774(%rip)        # b293d8 <_DYNAMIC+0x350>
  74dc64:	0f 0b                	ud2
  74dc66:	48 89 c3             	mov    %rax,%rbx
  74dc69:	48 89 e7             	mov    %rsp,%rdi
  74dc6c:	e8 df 2c 00 00       	call   750950 <core::ptr::drop_glue::<gpui::runtime::Error>>
  74dc71:	48 89 df             	mov    %rbx,%rdi
  74dc74:	e8 37 b8 3a 00       	call   af94b0 <_Unwind_Resume@plt>
  74dc79:	64 49 ff 07          	incq   %fs:(%r15)
  74dc7d:	48 89 c7             	mov    %rax,%rdi
  74dc80:	e8 2b b8 3a 00       	call   af94b0 <_Unwind_Resume@plt>
