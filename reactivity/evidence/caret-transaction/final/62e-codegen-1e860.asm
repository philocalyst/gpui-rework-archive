
/tmp/gpui-caret-transaction-bin/62e-codegen:     file format elf64-x86-64


Disassembly of section .text:

000000000001e860 <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>>:
   1e860:	55                   	push   %rbp
   1e861:	41 57                	push   %r15
   1e863:	41 56                	push   %r14
   1e865:	41 55                	push   %r13
   1e867:	41 54                	push   %r12
   1e869:	53                   	push   %rbx
   1e86a:	48 81 ec 68 01 00 00 	sub    $0x168,%rsp
   1e871:	48 89 cb             	mov    %rcx,%rbx
   1e874:	49 89 d6             	mov    %rdx,%r14
   1e877:	89 f2                	mov    %esi,%edx
   1e879:	48 89 fe             	mov    %rdi,%rsi
   1e87c:	4c 8d 7c 24 58       	lea    0x58(%rsp),%r15
   1e881:	4c 89 ff             	mov    %r15,%rdi
   1e884:	e8 27 0e 00 00       	call   1f6b0 <<parley::layout::run::Clusters<()>>::new>
   1e889:	f3 0f 10 03          	movss  (%rbx),%xmm0
   1e88d:	f3 0f 11 44 24 0c    	movss  %xmm0,0xc(%rsp)
   1e893:	48 8d 7c 24 24       	lea    0x24(%rsp),%rdi
   1e898:	4c 89 fe             	mov    %r15,%rsi
   1e89b:	e8 00 11 00 00       	call   1f9a0 <<parley::layout::run::Clusters<()>>::advance_cursor>
   1e8a0:	83 7c 24 24 01       	cmpl   $0x1,0x24(%rsp)
   1e8a5:	0f 85 0b 01 00 00    	jne    1e9b6 <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>+0x156>
   1e8ab:	4c 8d a4 24 10 01 00 	lea    0x110(%rsp),%r12
   1e8b2:	00 
   1e8b3:	4c 8d 6c 24 48       	lea    0x48(%rsp),%r13
   1e8b8:	eb 74                	jmp    1e92e <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>+0xce>
   1e8ba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   1e8c0:	0f 57 c0             	xorps  %xmm0,%xmm0
   1e8c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   1e8c8:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
   1e8cd:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
   1e8d2:	f2 0f 10 4a 44       	movsd  0x44(%rdx),%xmm1
   1e8d7:	f2 0f 11 4c 24 10    	movsd  %xmm1,0x10(%rsp)
   1e8dd:	f3 0f 11 44 24 18    	movss  %xmm0,0x18(%rsp)
   1e8e3:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
   1e8e7:	0f b6 89 8c 00 00 00 	movzbl 0x8c(%rcx),%ecx
   1e8ee:	83 e1 01             	and    $0x1,%ecx
   1e8f1:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
   1e8f6:	4c 89 e6             	mov    %r12,%rsi
   1e8f9:	4c 89 ea             	mov    %r13,%rdx
   1e8fc:	ff 15 6e 1a 04 00    	call   *0x41a6e(%rip)        # 60370 <_DYNAMIC+0x258>
   1e902:	f3 0f 10 4c 24 0c    	movss  0xc(%rsp),%xmm1
   1e908:	f3 0f 58 c8          	addss  %xmm0,%xmm1
   1e90c:	f3 0f 11 4c 24 0c    	movss  %xmm1,0xc(%rsp)
   1e912:	f3 0f 11 0b          	movss  %xmm1,(%rbx)
   1e916:	48 8d 7c 24 24       	lea    0x24(%rsp),%rdi
   1e91b:	4c 89 fe             	mov    %r15,%rsi
   1e91e:	e8 7d 10 00 00       	call   1f9a0 <<parley::layout::run::Clusters<()>>::advance_cursor>
   1e923:	80 7c 24 24 00       	cmpb   $0x0,0x24(%rsp)
   1e928:	0f 84 88 00 00 00    	je     1e9b6 <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>+0x156>
   1e92e:	48 83 bc 24 10 01 00 	cmpq   $0x0,0x110(%rsp)
   1e935:	00 00 
   1e937:	0f 84 8d 00 00 00    	je     1e9ca <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>+0x16a>
   1e93d:	4c 89 7c 24 38       	mov    %r15,0x38(%rsp)
   1e942:	4c 89 64 24 40       	mov    %r12,0x40(%rsp)
   1e947:	48 8d 44 24 28       	lea    0x28(%rsp),%rax
   1e94c:	0f 10 00             	movups (%rax),%xmm0
   1e94f:	41 0f 11 45 00       	movups %xmm0,0x0(%r13)
   1e954:	49 8b 6e 10          	mov    0x10(%r14),%rbp
   1e958:	49 3b 2e             	cmp    (%r14),%rbp
   1e95b:	75 08                	jne    1e965 <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>+0x105>
   1e95d:	4c 89 f7             	mov    %r14,%rdi
   1e960:	e8 5b d0 ff ff       	call   1b9c0 <<alloc::raw_vec::RawVec<f32>>::grow_one>
   1e965:	49 8b 46 08          	mov    0x8(%r14),%rax
   1e969:	f3 0f 10 44 24 0c    	movss  0xc(%rsp),%xmm0
   1e96f:	f3 0f 11 04 a8       	movss  %xmm0,(%rax,%rbp,4)
   1e974:	48 ff c5             	inc    %rbp
   1e977:	49 89 6e 10          	mov    %rbp,0x10(%r14)
   1e97b:	48 83 7c 24 70 00    	cmpq   $0x0,0x70(%rsp)
   1e981:	0f 84 39 ff ff ff    	je     1e8c0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>+0x60>
   1e987:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
   1e98c:	8b 7c 24 78          	mov    0x78(%rsp),%edi
   1e990:	48 8b b0 18 01 00 00 	mov    0x118(%rax),%rsi
   1e997:	48 39 fe             	cmp    %rdi,%rsi
   1e99a:	76 47                	jbe    1e9e3 <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>+0x183>
   1e99c:	48 8b 80 10 01 00 00 	mov    0x110(%rax),%rax
   1e9a3:	48 6b cf 70          	imul   $0x70,%rdi,%rcx
   1e9a7:	f3 0f 10 44 08 50    	movss  0x50(%rax,%rcx,1),%xmm0
   1e9ad:	8b 44 08 54          	mov    0x54(%rax,%rcx,1),%eax
   1e9b1:	e9 12 ff ff ff       	jmp    1e8c8 <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>+0x68>
   1e9b6:	31 c0                	xor    %eax,%eax
   1e9b8:	48 81 c4 68 01 00 00 	add    $0x168,%rsp
   1e9bf:	5b                   	pop    %rbx
   1e9c0:	41 5c                	pop    %r12
   1e9c2:	41 5d                	pop    %r13
   1e9c4:	41 5e                	pop    %r14
   1e9c6:	41 5f                	pop    %r15
   1e9c8:	5d                   	pop    %rbp
   1e9c9:	c3                   	ret
   1e9ca:	48 8d 3d 07 7e fe ff 	lea    -0x181f9(%rip),%rdi        # 67d8 <anon.5cab36dad6fad55fc602ca21d50a03ec.0.llvm.4639087895861959750>
   1e9d1:	48 8d 15 30 f8 03 00 	lea    0x3f830(%rip),%rdx        # 5e208 <anon.5cab36dad6fad55fc602ca21d50a03ec.2.llvm.4639087895861959750>
   1e9d8:	be 63 00 00 00       	mov    $0x63,%esi
   1e9dd:	ff 15 75 19 04 00    	call   *0x41975(%rip)        # 60358 <_DYNAMIC+0x240>
   1e9e3:	48 8d 15 36 f8 03 00 	lea    0x3f836(%rip),%rdx        # 5e220 <anon.5cab36dad6fad55fc602ca21d50a03ec.3.llvm.4639087895861959750>
   1e9ea:	ff 15 58 19 04 00    	call   *0x41958(%rip)        # 60348 <_DYNAMIC+0x230>
