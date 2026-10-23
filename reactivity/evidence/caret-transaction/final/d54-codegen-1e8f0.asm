
/tmp/gpui-caret-transaction-bin/d54-codegen:     file format elf64-x86-64


Disassembly of section .text:

000000000001e8f0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>>:
   1e8f0:	55                   	push   %rbp
   1e8f1:	41 57                	push   %r15
   1e8f3:	41 56                	push   %r14
   1e8f5:	41 55                	push   %r13
   1e8f7:	41 54                	push   %r12
   1e8f9:	53                   	push   %rbx
   1e8fa:	48 81 ec 68 01 00 00 	sub    $0x168,%rsp
   1e901:	48 89 cb             	mov    %rcx,%rbx
   1e904:	49 89 d6             	mov    %rdx,%r14
   1e907:	89 f2                	mov    %esi,%edx
   1e909:	48 89 fe             	mov    %rdi,%rsi
   1e90c:	4c 8d 7c 24 58       	lea    0x58(%rsp),%r15
   1e911:	4c 89 ff             	mov    %r15,%rdi
   1e914:	e8 27 0e 00 00       	call   1f740 <<parley::layout::run::Clusters<()>>::new>
   1e919:	f3 0f 10 03          	movss  (%rbx),%xmm0
   1e91d:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
   1e923:	48 8d 7c 24 24       	lea    0x24(%rsp),%rdi
   1e928:	4c 89 fe             	mov    %r15,%rsi
   1e92b:	e8 00 11 00 00       	call   1fa30 <<parley::layout::run::Clusters<()>>::advance_cursor>
   1e930:	83 7c 24 24 01       	cmpl   $0x1,0x24(%rsp)
   1e935:	0f 85 0b 01 00 00    	jne    1ea46 <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>+0x156>
   1e93b:	4c 8d a4 24 10 01 00 	lea    0x110(%rsp),%r12
   1e942:	00 
   1e943:	4c 8d 6c 24 48       	lea    0x48(%rsp),%r13
   1e948:	eb 74                	jmp    1e9be <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>+0xce>
   1e94a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   1e950:	0f 57 c0             	xorps  %xmm0,%xmm0
   1e953:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   1e958:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
   1e95d:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
   1e962:	f2 0f 10 4a 44       	movsd  0x44(%rdx),%xmm1
   1e967:	f2 0f 11 4c 24 10    	movsd  %xmm1,0x10(%rsp)
   1e96d:	f3 0f 11 44 24 18    	movss  %xmm0,0x18(%rsp)
   1e973:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
   1e977:	0f b6 89 8c 00 00 00 	movzbl 0x8c(%rcx),%ecx
   1e97e:	83 e1 01             	and    $0x1,%ecx
   1e981:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
   1e986:	4c 89 e6             	mov    %r12,%rsi
   1e989:	4c 89 ea             	mov    %r13,%rdx
   1e98c:	ff 15 8e 1a 04 00    	call   *0x41a8e(%rip)        # 60420 <_DYNAMIC+0x258>
   1e992:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
   1e998:	f3 0f 58 c8          	addss  %xmm0,%xmm1
   1e99c:	f3 0f 11 4c 24 0c    	movss  %xmm1,0xc(%rsp)
   1e9a2:	f3 0f 11 0b          	movss  %xmm1,(%rbx)
   1e9a6:	48 8d 7c 24 24       	lea    0x24(%rsp),%rdi
   1e9ab:	4c 89 fe             	mov    %r15,%rsi
   1e9ae:	e8 7d 10 00 00       	call   1fa30 <<parley::layout::run::Clusters<()>>::advance_cursor>
   1e9b3:	80 7c 24 24 00       	cmpb   $0x0,0x24(%rsp)
   1e9b8:	0f 84 88 00 00 00    	je     1ea46 <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>+0x156>
   1e9be:	48 83 bc 24 10 01 00 	cmpq   $0x0,0x110(%rsp)
   1e9c5:	00 00 
   1e9c7:	0f 84 8d 00 00 00    	je     1ea5a <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>+0x16a>
   1e9cd:	4c 89 7c 24 38       	mov    %r15,0x38(%rsp)
   1e9d2:	4c 89 64 24 40       	mov    %r12,0x40(%rsp)
   1e9d7:	48 8d 44 24 28       	lea    0x28(%rsp),%rax
   1e9dc:	0f 10 00             	movups (%rax),%xmm0
   1e9df:	41 0f 11 45 00       	movups %xmm0,0x0(%r13)
   1e9e4:	49 8b 6e 10          	mov    0x10(%r14),%rbp
   1e9e8:	49 3b 2e             	cmp    (%r14),%rbp
   1e9eb:	75 08                	jne    1e9f5 <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>+0x105>
   1e9ed:	4c 89 f7             	mov    %r14,%rdi
   1e9f0:	e8 2b d0 ff ff       	call   1ba20 <<alloc::raw_vec::RawVec<f32>>::grow_one>
   1e9f5:	49 8b 46 08          	mov    0x8(%r14),%rax
   1e9f9:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
   1e9ff:	f3 0f 11 04 a8       	movss  %xmm0,(%rax,%rbp,4)
   1ea04:	48 ff c5             	inc    %rbp
   1ea07:	49 89 6e 10          	mov    %rbp,0x10(%r14)
   1ea0b:	48 83 7c 24 70 00    	cmpq   $0x0,0x70(%rsp)
   1ea11:	0f 84 39 ff ff ff    	je     1e950 <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>+0x60>
   1ea17:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
   1ea1c:	8b 7c 24 78          	mov    0x78(%rsp),%edi
   1ea20:	48 8b b0 18 01 00 00 	mov    0x118(%rax),%rsi
   1ea27:	48 39 fe             	cmp    %rdi,%rsi
   1ea2a:	76 47                	jbe    1ea73 <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>+0x183>
   1ea2c:	48 8b 80 10 01 00 00 	mov    0x110(%rax),%rax
   1ea33:	48 6b cf 70          	imul   $0x70,%rdi,%rcx
   1ea37:	f3 0f 10 44 08 50    	movss  0x50(%rax,%rcx,1),%xmm0
   1ea3d:	8b 44 08 54          	mov    0x54(%rax,%rcx,1),%eax
   1ea41:	e9 12 ff ff ff       	jmp    1e958 <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>+0x68>
   1ea46:	31 c0                	xor    %eax,%eax
   1ea48:	48 81 c4 68 01 00 00 	add    $0x168,%rsp
   1ea4f:	5b                   	pop    %rbx
   1ea50:	41 5c                	pop    %r12
   1ea52:	41 5d                	pop    %r13
   1ea54:	41 5e                	pop    %r14
   1ea56:	41 5f                	pop    %r15
   1ea58:	5d                   	pop    %rbp
   1ea59:	c3                   	ret
   1ea5a:	48 8d 3d ac 7d fe ff 	lea    -0x18254(%rip),%rdi        # 680d <anon.5cab36dad6fad55fc602ca21d50a03ec.0.llvm.18336280871641450522>
   1ea61:	48 8d 15 50 f8 03 00 	lea    0x3f850(%rip),%rdx        # 5e2b8 <anon.5cab36dad6fad55fc602ca21d50a03ec.2.llvm.18336280871641450522>
   1ea68:	be 63 00 00 00       	mov    $0x63,%esi
   1ea6d:	ff 15 95 19 04 00    	call   *0x41995(%rip)        # 60408 <_DYNAMIC+0x240>
   1ea73:	48 8d 15 56 f8 03 00 	lea    0x3f856(%rip),%rdx        # 5e2d0 <anon.5cab36dad6fad55fc602ca21d50a03ec.3.llvm.18336280871641450522>
   1ea7a:	ff 15 78 19 04 00    	call   *0x41978(%rip)        # 603f8 <_DYNAMIC+0x230>
