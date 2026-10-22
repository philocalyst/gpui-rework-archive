
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000073dee0 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>>:
  73dee0:	41 57                	push   %r15
  73dee2:	41 56                	push   %r14
  73dee4:	41 55                	push   %r13
  73dee6:	41 54                	push   %r12
  73dee8:	53                   	push   %rbx
  73dee9:	48 83 ec 70          	sub    $0x70,%rsp
  73deed:	48 89 fb             	mov    %rdi,%rbx
  73def0:	49 c7 c7 68 f3 ff ff 	mov    $0xfffffffffffff368,%r15
  73def7:	64 4c 8b 34 25 00 00 	mov    %fs:0x0,%r14
  73defe:	00 00 
  73df00:	4d 01 fe             	add    %r15,%r14
  73df03:	64 41 80 bf 10 0c 00 	cmpb   $0x0,%fs:0xc10(%r15)
  73df0a:	00 00 
  73df0c:	0f 84 90 00 00 00    	je     73dfa2 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0xc2>
  73df12:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  73df17:	0f 85 b5 00 00 00    	jne    73dfd2 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0xf2>
  73df1d:	64 49 c7 07 ff ff ff 	movq   $0xffffffffffffffff,%fs:(%r15)
  73df24:	ff 
  73df25:	64 41 8b 87 08 0c 00 	mov    %fs:0xc08(%r15),%eax
  73df2c:	00 
  73df2d:	ff c0                	inc    %eax
  73df2f:	64 41 89 87 08 0c 00 	mov    %eax,%fs:0xc08(%r15)
  73df36:	00 
  73df37:	83 f8 40             	cmp    $0x40,%eax
  73df3a:	0f 83 9f 00 00 00    	jae    73dfdf <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0xff>
  73df40:	89 c0                	mov    %eax,%eax
  73df42:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  73df46:	48 c1 e0 04          	shl    $0x4,%rax
  73df4a:	0f 57 c0             	xorps  %xmm0,%xmm0
  73df4d:	41 0f 11 44 06 28    	movups %xmm0,0x28(%r14,%rax,1)
  73df53:	41 0f 11 44 06 18    	movups %xmm0,0x18(%r14,%rax,1)
  73df59:	41 0f 11 44 06 08    	movups %xmm0,0x8(%r14,%rax,1)
  73df5f:	64 49 c7 07 00 00 00 	movq   $0x0,%fs:(%r15)
  73df66:	00 
  73df67:	48 8b 02             	mov    (%rdx),%rax
  73df6a:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  73df6e:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
  73df73:	48 89 c2             	mov    %rax,%rdx
  73df76:	e8 35 1d fd ff       	call   70fcb0 <<gpui::runtime::Win<unit_action_cost::Model>>::click>
  73df7b:	83 7c 24 38 fe       	cmpl   $0xfffffffe,0x38(%rsp)
  73df80:	75 78                	jne    73dffa <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0x11a>
  73df82:	48 8d 35 6f 72 39 00 	lea    0x39726f(%rip),%rsi        # ad51f8 <anon.d860f86f9d097745b4f11ed46a5e2623.0.llvm.14368733740904100364>
  73df89:	48 89 df             	mov    %rbx,%rdi
  73df8c:	e8 0f 9c ff ff       	call   737ba0 <<std::thread::local::LocalKey<core::cell::RefCell<allocation_counter::allocator::AllocationInfoStack>>>::with::<allocation_counter::measure<unit_action_cost::ordinary_unit_action_cost::{closure#0}>::{closure#1}, allocation_counter::AllocationInfo>>
  73df91:	48 89 d8             	mov    %rbx,%rax
  73df94:	48 83 c4 70          	add    $0x70,%rsp
  73df98:	5b                   	pop    %rbx
  73df99:	41 5c                	pop    %r12
  73df9b:	41 5d                	pop    %r13
  73df9d:	41 5e                	pop    %r14
  73df9f:	41 5f                	pop    %r15
  73dfa1:	c3                   	ret
  73dfa2:	49 89 d4             	mov    %rdx,%r12
  73dfa5:	ba 0c 0c 00 00       	mov    $0xc0c,%edx
  73dfaa:	4c 89 f7             	mov    %r14,%rdi
  73dfad:	49 89 f5             	mov    %rsi,%r13
  73dfb0:	31 f6                	xor    %esi,%esi
  73dfb2:	ff 15 80 45 3c 00    	call   *0x3c4580(%rip)        # b02538 <memset@GLIBC_2.2.5>
  73dfb8:	4c 89 e2             	mov    %r12,%rdx
  73dfbb:	4c 89 ee             	mov    %r13,%rsi
  73dfbe:	64 41 c6 87 10 0c 00 	movb   $0x1,%fs:0xc10(%r15)
  73dfc5:	00 01 
  73dfc7:	64 49 83 3f 00       	cmpq   $0x0,%fs:(%r15)
  73dfcc:	0f 84 4b ff ff ff    	je     73df1d <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0x3d>
  73dfd2:	48 8d 3d 6f 6e 39 00 	lea    0x396e6f(%rip),%rdi        # ad4e48 <anon.ff3cab21037877729def149be6643aa6.6.llvm.17844888298126827638>
  73dfd9:	ff 15 61 45 3c 00    	call   *0x3c4561(%rip)        # b02540 <_DYNAMIC+0x7f8>
  73dfdf:	48 8d 3d ae bd 92 ff 	lea    -0x6d4252(%rip),%rdi        # 69d94 <anon.ff3cab21037877729def149be6643aa6.3.llvm.17844888298126827638>
  73dfe6:	48 8d 15 43 6e 39 00 	lea    0x396e43(%rip),%rdx        # ad4e30 <anon.ff3cab21037877729def149be6643aa6.5.llvm.17844888298126827638>
  73dfed:	be 4b 00 00 00       	mov    $0x4b,%esi
  73dff2:	ff 15 f0 3f 3c 00    	call   *0x3c3ff0(%rip)        # b01fe8 <_DYNAMIC+0x2a0>
  73dff8:	eb 4a                	jmp    73e044 <allocation_counter::measure::<unit_action_cost::ordinary_unit_action_cost::{closure#1}>+0x164>
  73dffa:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  73dfff:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  73e004:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  73e009:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  73e00e:	0f 10 54 24 58       	movups 0x58(%rsp),%xmm2
  73e013:	0f 29 54 24 20       	movaps %xmm2,0x20(%rsp)
  73e018:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  73e01d:	0f 29 04 24          	movaps %xmm0,(%rsp)
  73e021:	48 8d 3d 10 c3 92 ff 	lea    -0x6d3cf0(%rip),%rdi        # 6a338 <anon.d860f86f9d097745b4f11ed46a5e2623.5.llvm.14368733740904100364>
  73e028:	48 8d 0d 01 72 39 00 	lea    0x397201(%rip),%rcx        # ad5230 <anon.d860f86f9d097745b4f11ed46a5e2623.4.llvm.14368733740904100364>
  73e02f:	4c 8d 05 e2 71 39 00 	lea    0x3971e2(%rip),%r8        # ad5218 <anon.d860f86f9d097745b4f11ed46a5e2623.3.llvm.14368733740904100364>
  73e036:	48 89 e2             	mov    %rsp,%rdx
  73e039:	be 2b 00 00 00       	mov    $0x2b,%esi
  73e03e:	ff 15 74 40 3c 00    	call   *0x3c4074(%rip)        # b020b8 <_DYNAMIC+0x370>
  73e044:	0f 0b                	ud2
  73e046:	48 89 c3             	mov    %rax,%rbx
  73e049:	48 89 e7             	mov    %rsp,%rdi
  73e04c:	e8 6f 22 00 00       	call   7402c0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  73e051:	48 89 df             	mov    %rbx,%rdi
  73e054:	e8 57 43 39 00       	call   ad23b0 <_Unwind_Resume@plt>
  73e059:	64 49 ff 07          	incq   %fs:(%r15)
  73e05d:	48 89 c7             	mov    %rax,%rdi
  73e060:	e8 4b 43 39 00       	call   ad23b0 <_Unwind_Resume@plt>
