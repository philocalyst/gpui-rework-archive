
/tmp/gpui-caret-transaction-bin/62e-codegen:     file format elf64-x86-64


Disassembly of section .text:

000000000001bb00 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>>:
   1bb00:	55                   	push   %rbp
   1bb01:	41 57                	push   %r15
   1bb03:	41 56                	push   %r14
   1bb05:	41 55                	push   %r13
   1bb07:	41 54                	push   %r12
   1bb09:	53                   	push   %rbx
   1bb0a:	48 81 ec a8 02 00 00 	sub    $0x2a8,%rsp
   1bb11:	48 89 54 24 58       	mov    %rdx,0x58(%rsp)
   1bb16:	4c 8b a7 50 01 00 00 	mov    0x150(%rdi),%r12
   1bb1d:	4c 89 e0             	mov    %r12,%rax
   1bb20:	48 c1 e8 20          	shr    $0x20,%rax
   1bb24:	74 16                	je     1bb3c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x3c>
   1bb26:	48 81 c4 a8 02 00 00 	add    $0x2a8,%rsp
   1bb2d:	5b                   	pop    %rbx
   1bb2e:	41 5c                	pop    %r12
   1bb30:	41 5d                	pop    %r13
   1bb32:	41 5e                	pop    %r14
   1bb34:	41 5f                	pop    %r15
   1bb36:	5d                   	pop    %rbp
   1bb37:	e9 b4 15 00 00       	jmp    1d0f0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>>
   1bb3c:	f3 0f 11 44 24 50    	movss  %xmm0,0x50(%rsp)
   1bb42:	48 8b 57 70          	mov    0x70(%rdi),%rdx
   1bb46:	48 89 d0             	mov    %rdx,%rax
   1bb49:	48 c1 e8 20          	shr    $0x20,%rax
   1bb4d:	40 b5 02             	mov    $0x2,%bpl
   1bb50:	0f 85 aa 0f 00 00    	jne    1cb00 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1000>
   1bb56:	48 8b 8f 18 01 00 00 	mov    0x118(%rdi),%rcx
   1bb5d:	48 89 c8             	mov    %rcx,%rax
   1bb60:	48 c1 e8 20          	shr    $0x20,%rax
   1bb64:	0f 85 96 0f 00 00    	jne    1cb00 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1000>
   1bb6a:	48 89 b4 24 c0 00 00 	mov    %rsi,0xc0(%rsp)
   1bb71:	00 
   1bb72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   1bb77:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
   1bb7e:	00 
   1bb7f:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
   1bb86:	00 00 00 00 00 
   1bb8b:	48 c7 84 24 a8 00 00 	movq   $0x4,0xa8(%rsp)
   1bb92:	00 04 00 00 00 
   1bb97:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
   1bb9e:	00 00 00 00 00 
   1bba3:	4c 8b b7 10 01 00 00 	mov    0x110(%rdi),%r14
   1bbaa:	48 6b c1 70          	imul   $0x70,%rcx,%rax
   1bbae:	4c 01 f0             	add    %r14,%rax
   1bbb1:	48 89 84 24 d8 01 00 	mov    %rax,0x1d8(%rsp)
   1bbb8:	00 
   1bbb9:	48 85 c9             	test   %rcx,%rcx
   1bbbc:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
   1bbc1:	48 89 8c 24 40 02 00 	mov    %rcx,0x240(%rsp)
   1bbc8:	00 
   1bbc9:	0f 84 8f 04 00 00    	je     1c05e <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x55e>
   1bbcf:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
   1bbd4:	48 8b 87 30 01 00 00 	mov    0x130(%rdi),%rax
   1bbdb:	48 89 84 24 58 02 00 	mov    %rax,0x258(%rsp)
   1bbe2:	00 
   1bbe3:	48 8b 87 28 01 00 00 	mov    0x128(%rdi),%rax
   1bbea:	48 89 84 24 60 02 00 	mov    %rax,0x260(%rsp)
   1bbf1:	00 
   1bbf2:	48 8b 47 50          	mov    0x50(%rdi),%rax
   1bbf6:	48 89 84 24 d0 01 00 	mov    %rax,0x1d0(%rsp)
   1bbfd:	00 
   1bbfe:	48 8b 47 58          	mov    0x58(%rdi),%rax
   1bc02:	48 8b 8f e8 00 00 00 	mov    0xe8(%rdi),%rcx
   1bc09:	48 39 c8             	cmp    %rcx,%rax
   1bc0c:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
   1bc13:	00 
   1bc14:	48 0f 42 c8          	cmovb  %rax,%rcx
   1bc18:	48 89 8c 24 50 02 00 	mov    %rcx,0x250(%rsp)
   1bc1f:	00 
   1bc20:	48 8b 47 68          	mov    0x68(%rdi),%rax
   1bc24:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   1bc29:	48 8b 87 80 00 00 00 	mov    0x80(%rdi),%rax
   1bc30:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
   1bc35:	4c 8b af 88 00 00 00 	mov    0x88(%rdi),%r13
   1bc3c:	48 8b 87 98 00 00 00 	mov    0x98(%rdi),%rax
   1bc43:	48 89 84 24 e8 01 00 	mov    %rax,0x1e8(%rsp)
   1bc4a:	00 
   1bc4b:	48 8b 87 a0 00 00 00 	mov    0xa0(%rdi),%rax
   1bc52:	48 89 84 24 e0 01 00 	mov    %rax,0x1e0(%rsp)
   1bc59:	00 
   1bc5a:	48 c7 44 24 30 00 00 	movq   $0x0,0x30(%rsp)
   1bc61:	00 00 
   1bc63:	48 8d ac 24 d8 00 00 	lea    0xd8(%rsp),%rbp
   1bc6a:	00 
   1bc6b:	4c 8d 84 24 98 00 00 	lea    0x98(%rsp),%r8
   1bc72:	00 
   1bc73:	4c 8d 8c 24 a0 00 00 	lea    0xa0(%rsp),%r9
   1bc7a:	00 
   1bc7b:	48 8d 05 6e 25 04 00 	lea    0x4256e(%rip),%rax        # 5e1f0 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.14256054827572741256+0x138>
   1bc82:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
   1bc89:	00 
   1bc8a:	48 c7 44 24 48 00 00 	movq   $0x0,0x48(%rsp)
   1bc91:	00 00 
   1bc93:	48 c7 44 24 10 00 00 	movq   $0x0,0x10(%rsp)
   1bc9a:	00 00 
   1bc9c:	4c 89 f0             	mov    %r14,%rax
   1bc9f:	4c 89 b4 24 88 00 00 	mov    %r14,0x88(%rsp)
   1bca6:	00 
   1bca7:	4c 89 ac 24 c8 00 00 	mov    %r13,0xc8(%rsp)
   1bcae:	00 
   1bcaf:	eb 29                	jmp    1bcda <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1da>
   1bcb1:	48 8b 8c 24 68 02 00 	mov    0x268(%rsp),%rcx
   1bcb8:	00 
   1bcb9:	48 89 c8             	mov    %rcx,%rax
   1bcbc:	48 3b 8c 24 d8 01 00 	cmp    0x1d8(%rsp),%rcx
   1bcc3:	00 
   1bcc4:	4c 8d 84 24 98 00 00 	lea    0x98(%rsp),%r8
   1bccb:	00 
   1bccc:	4c 8d 8c 24 a0 00 00 	lea    0xa0(%rsp),%r9
   1bcd3:	00 
   1bcd4:	0f 84 8d 03 00 00    	je     1c067 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x567>
   1bcda:	48 8b 50 10          	mov    0x10(%rax),%rdx
   1bcde:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
   1bce5:	00 
   1bce6:	48 8b 48 18          	mov    0x18(%rax),%rcx
   1bcea:	48 89 fe             	mov    %rdi,%rsi
   1bced:	48 89 ef             	mov    %rbp,%rdi
   1bcf0:	48 89 f3             	mov    %rsi,%rbx
   1bcf3:	e8 a8 0f 00 00       	call   1cca0 <parley::editing::geometry::source_runs::<()>>
   1bcf8:	4c 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%r15
   1bcff:	00 
   1bd00:	4d 85 ff             	test   %r15,%r15
   1bd03:	0f 84 3e 0b 00 00    	je     1c847 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xd47>
   1bd09:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
   1bd10:	00 
   1bd11:	48 83 c0 70          	add    $0x70,%rax
   1bd15:	48 89 84 24 68 02 00 	mov    %rax,0x268(%rsp)
   1bd1c:	00 
   1bd1d:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
   1bd24:	00 
   1bd25:	4d 8d 2c c7          	lea    (%r15,%rax,8),%r13
   1bd29:	48 89 df             	mov    %rbx,%rdi
   1bd2c:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
   1bd31:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   1bd38:	0f 1f 84 00 00 00 00 
   1bd3f:	00 
   1bd40:	4d 39 ef             	cmp    %r13,%r15
   1bd43:	0f 84 68 ff ff ff    	je     1bcb1 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1b1>
   1bd49:	41 8b 07             	mov    (%r15),%eax
   1bd4c:	49 83 c7 08          	add    $0x8,%r15
   1bd50:	48 39 c8             	cmp    %rcx,%rax
   1bd53:	74 eb                	je     1bd40 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x240>
   1bd55:	48 8b 8c 24 90 00 00 	mov    0x90(%rsp),%rcx
   1bd5c:	00 
   1bd5d:	48 03 41 10          	add    0x10(%rcx),%rax
   1bd61:	40 b5 02             	mov    $0x2,%bpl
   1bd64:	48 3b 41 18          	cmp    0x18(%rcx),%rax
   1bd68:	48 8b 8c 24 60 02 00 	mov    0x260(%rsp),%rcx
   1bd6f:	00 
   1bd70:	0f 83 66 0d 00 00    	jae    1cadc <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfdc>
   1bd76:	48 3b 84 24 58 02 00 	cmp    0x258(%rsp),%rax
   1bd7d:	00 
   1bd7e:	0f 83 58 0d 00 00    	jae    1cadc <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfdc>
   1bd84:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
   1bd88:	80 7c c1 21 00       	cmpb   $0x0,0x21(%rcx,%rax,8)
   1bd8d:	0f 85 49 0d 00 00    	jne    1cadc <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfdc>
   1bd93:	48 8d 04 c1          	lea    (%rcx,%rax,8),%rax
   1bd97:	48 8b 48 10          	mov    0x10(%rax),%rcx
   1bd9b:	48 3b 8c 24 50 02 00 	cmp    0x250(%rsp),%rcx
   1bda2:	00 
   1bda3:	0f 83 33 0d 00 00    	jae    1cadc <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfdc>
   1bda9:	48 89 8c 24 48 02 00 	mov    %rcx,0x248(%rsp)
   1bdb0:	00 
   1bdb1:	89 cd                	mov    %ecx,%ebp
   1bdb3:	48 39 ac 24 80 00 00 	cmp    %rbp,0x80(%rsp)
   1bdba:	00 
   1bdbb:	0f 86 19 0e 00 00    	jbe    1cbda <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10da>
   1bdc1:	48 8d 0c ed 00 00 00 	lea    0x0(,%rbp,8),%rcx
   1bdc8:	00 
   1bdc9:	48 01 e9             	add    %rbp,%rcx
   1bdcc:	48 c1 e1 04          	shl    $0x4,%rcx
   1bdd0:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
   1bdd5:	48 89 94 24 08 02 00 	mov    %rdx,0x208(%rsp)
   1bddc:	00 
   1bddd:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
   1bde2:	48 89 94 24 10 02 00 	mov    %rdx,0x210(%rsp)
   1bde9:	00 
   1bdea:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
   1bdef:	48 89 94 24 18 02 00 	mov    %rdx,0x218(%rsp)
   1bdf6:	00 
   1bdf7:	48 8b b4 24 c8 00 00 	mov    0xc8(%rsp),%rsi
   1bdfe:	00 
   1bdff:	48 89 b4 24 20 02 00 	mov    %rsi,0x220(%rsp)
   1be06:	00 
   1be07:	48 8b 94 24 e8 01 00 	mov    0x1e8(%rsp),%rdx
   1be0e:	00 
   1be0f:	48 89 94 24 28 02 00 	mov    %rdx,0x228(%rsp)
   1be16:	00 
   1be17:	48 8b 94 24 e0 01 00 	mov    0x1e0(%rsp),%rdx
   1be1e:	00 
   1be1f:	48 89 94 24 30 02 00 	mov    %rdx,0x230(%rsp)
   1be26:	00 
   1be27:	48 8b 94 24 d0 01 00 	mov    0x1d0(%rsp),%rdx
   1be2e:	00 
   1be2f:	48 8b 4c 0a 50       	mov    0x50(%rdx,%rcx,1),%rcx
   1be34:	48 89 8c 24 38 02 00 	mov    %rcx,0x238(%rsp)
   1be3b:	00 
   1be3c:	8b 68 18             	mov    0x18(%rax),%ebp
   1be3f:	8b 58 1c             	mov    0x1c(%rax),%ebx
   1be42:	39 dd                	cmp    %ebx,%ebp
   1be44:	75 08                	jne    1be4e <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x34e>
   1be46:	0f 57 c0             	xorps  %xmm0,%xmm0
   1be49:	45 31 f6             	xor    %r14d,%r14d
   1be4c:	eb 67                	jmp    1beb5 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x3b5>
   1be4e:	48 39 ee             	cmp    %rbp,%rsi
   1be51:	0f 86 50 0d 00 00    	jbe    1cba7 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10a7>
   1be57:	48 8d 43 ff          	lea    -0x1(%rbx),%rax
   1be5b:	48 39 f0             	cmp    %rsi,%rax
   1be5e:	0f 83 54 0d 00 00    	jae    1cbb8 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10b8>
   1be64:	48 8d 04 6d 00 00 00 	lea    0x0(,%rbp,2),%rax
   1be6b:	00 
   1be6c:	48 01 e8             	add    %rbp,%rax
   1be6f:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
   1be74:	48 8d 3c c1          	lea    (%rcx,%rax,8),%rdi
   1be78:	44 8b 34 c1          	mov    (%rcx,%rax,8),%r14d
   1be7c:	f3 0f 10 44 c1 10    	movss  0x10(%rcx,%rax,8),%xmm0
   1be82:	f3 0f 11 84 24 d0 00 	movss  %xmm0,0xd0(%rsp)
   1be89:	00 00 
   1be8b:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
   1be90:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
   1be95:	ff 15 25 45 04 00    	call   *0x44525(%rip)        # 603c0 <_DYNAMIC+0x2a8>
   1be9b:	89 c0                	mov    %eax,%eax
   1be9d:	0f 57 c0             	xorps  %xmm0,%xmm0
   1bea0:	f3 48 0f 2a c0       	cvtsi2ss %rax,%xmm0
   1bea5:	f3 0f 10 8c 24 d0 00 	movss  0xd0(%rsp),%xmm1
   1beac:	00 00 
   1beae:	f3 0f 5e c8          	divss  %xmm0,%xmm1
   1beb2:	0f 28 c1             	movaps %xmm1,%xmm0
   1beb5:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   1beba:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
   1bec1:	00 
   1bec2:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
   1bec7:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
   1bece:	00 
   1becf:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
   1bed4:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
   1bedb:	00 
   1bedc:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
   1bee3:	00 
   1bee4:	48 89 84 24 f0 00 00 	mov    %rax,0xf0(%rsp)
   1beeb:	00 
   1beec:	48 8b 84 24 e8 01 00 	mov    0x1e8(%rsp),%rax
   1bef3:	00 
   1bef4:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
   1befb:	00 
   1befc:	48 8b 84 24 e0 01 00 	mov    0x1e0(%rsp),%rax
   1bf03:	00 
   1bf04:	48 89 84 24 00 01 00 	mov    %rax,0x100(%rsp)
   1bf0b:	00 
   1bf0c:	89 ac 24 08 01 00 00 	mov    %ebp,0x108(%rsp)
   1bf13:	89 9c 24 0c 01 00 00 	mov    %ebx,0x10c(%rsp)
   1bf1a:	44 89 b4 24 10 01 00 	mov    %r14d,0x110(%rsp)
   1bf21:	00 
   1bf22:	89 ac 24 14 01 00 00 	mov    %ebp,0x114(%rsp)
   1bf29:	f3 0f 11 84 24 18 01 	movss  %xmm0,0x118(%rsp)
   1bf30:	00 00 
   1bf32:	4d 85 e4             	test   %r12,%r12
   1bf35:	0f 84 8d 00 00 00    	je     1bfc8 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x4c8>
   1bf3b:	31 db                	xor    %ebx,%ebx
   1bf3d:	0f 1f 00             	nopl   (%rax)
   1bf40:	48 8d ac 24 d8 00 00 	lea    0xd8(%rsp),%rbp
   1bf47:	00 
   1bf48:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
   1bf4f:	00 
   1bf50:	48 89 ee             	mov    %rbp,%rsi
   1bf53:	ff 15 6f 44 04 00    	call   *0x4446f(%rip)        # 603c8 <_DYNAMIC+0x2b0>
   1bf59:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   1bf5e:	4c 8d 34 18          	lea    (%rax,%rbx,1),%r14
   1bf62:	83 bc 24 60 01 00 00 	cmpl   $0x1,0x160(%rsp)
   1bf69:	01 
   1bf6a:	0f 85 a3 00 00 00    	jne    1c013 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x513>
   1bf70:	8b b4 24 64 01 00 00 	mov    0x164(%rsp),%esi
   1bf77:	8b 94 24 68 01 00 00 	mov    0x168(%rsp),%edx
   1bf7e:	48 8d bc 24 08 02 00 	lea    0x208(%rsp),%rdi
   1bf85:	00 
   1bf86:	ff 15 d4 43 04 00    	call   *0x443d4(%rip)        # 60360 <_DYNAMIC+0x248>
   1bf8c:	40 b5 02             	mov    $0x2,%bpl
   1bf8f:	48 39 d0             	cmp    %rdx,%rax
   1bf92:	0f 87 44 0b 00 00    	ja     1cadc <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfdc>
   1bf98:	4c 39 e2             	cmp    %r12,%rdx
   1bf9b:	0f 87 3b 0b 00 00    	ja     1cadc <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfdc>
   1bfa1:	48 39 d0             	cmp    %rdx,%rax
   1bfa4:	73 10                	jae    1bfb6 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x4b6>
   1bfa6:	48 3b 44 24 30       	cmp    0x30(%rsp),%rax
   1bfab:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
   1bfb0:	0f 82 1e 01 00 00    	jb     1c0d4 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x5d4>
   1bfb6:	49 c1 ee 20          	shr    $0x20,%r14
   1bfba:	0f 85 1c 0b 00 00    	jne    1cadc <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfdc>
   1bfc0:	48 ff c3             	inc    %rbx
   1bfc3:	e9 78 ff ff ff       	jmp    1bf40 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x440>
   1bfc8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   1bfcd:	4c 8d 70 01          	lea    0x1(%rax),%r14
   1bfd1:	31 db                	xor    %ebx,%ebx
   1bfd3:	48 8d ac 24 d8 00 00 	lea    0xd8(%rsp),%rbp
   1bfda:	00 
   1bfdb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   1bfe0:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
   1bfe7:	00 
   1bfe8:	48 89 ee             	mov    %rbp,%rsi
   1bfeb:	ff 15 d7 43 04 00    	call   *0x443d7(%rip)        # 603c8 <_DYNAMIC+0x2b0>
   1bff1:	83 bc 24 60 01 00 00 	cmpl   $0x1,0x160(%rsp)
   1bff8:	01 
   1bff9:	75 0e                	jne    1c009 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x509>
   1bffb:	49 39 de             	cmp    %rbx,%r14
   1bffe:	0f 84 10 0b 00 00    	je     1cb14 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1014>
   1c004:	48 ff cb             	dec    %rbx
   1c007:	eb d7                	jmp    1bfe0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x4e0>
   1c009:	48 29 5c 24 10       	sub    %rbx,0x10(%rsp)
   1c00e:	48 f7 db             	neg    %rbx
   1c011:	eb 05                	jmp    1c018 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x518>
   1c013:	4c 89 74 24 10       	mov    %r14,0x10(%rsp)
   1c018:	48 8b 84 24 48 02 00 	mov    0x248(%rsp),%rax
   1c01f:	00 
   1c020:	48 8d 04 c0          	lea    (%rax,%rax,8),%rax
   1c024:	48 c1 e0 04          	shl    $0x4,%rax
   1c028:	48 03 84 24 d0 01 00 	add    0x1d0(%rsp),%rax
   1c02f:	00 
   1c030:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
   1c035:	48 39 cb             	cmp    %rcx,%rbx
   1c038:	48 0f 46 d9          	cmovbe %rcx,%rbx
   1c03c:	f6 80 8c 00 00 00 01 	testb  $0x1,0x8c(%rax)
   1c043:	48 0f 45 cb          	cmovne %rbx,%rcx
   1c047:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
   1c04c:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
   1c051:	4c 8b b4 24 88 00 00 	mov    0x88(%rsp),%r14
   1c058:	00 
   1c059:	e9 ce fc ff ff       	jmp    1bd2c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x22c>
   1c05e:	48 c7 44 24 48 00 00 	movq   $0x0,0x48(%rsp)
   1c065:	00 00 
   1c067:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
   1c06c:	4c 8d 3c 85 00 00 00 	lea    0x0(,%rax,4),%r15
   1c073:	00 
   1c074:	48 c1 e8 3e          	shr    $0x3e,%rax
   1c078:	0f 95 c0             	setne  %al
   1c07b:	48 b9 fc ff ff ff ff 	movabs $0x7ffffffffffffffc,%rcx
   1c082:	ff ff 7f 
   1c085:	49 39 cf             	cmp    %rcx,%r15
   1c088:	0f 97 c1             	seta   %cl
   1c08b:	08 c1                	or     %al,%cl
   1c08d:	74 14                	je     1c0a3 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x5a3>
   1c08f:	45 31 e4             	xor    %r12d,%r12d
   1c092:	4c 89 e7             	mov    %r12,%rdi
   1c095:	4c 89 fe             	mov    %r15,%rsi
   1c098:	ff 15 e2 42 04 00    	call   *0x442e2(%rip)        # 60380 <_DYNAMIC+0x268>
   1c09e:	e9 50 0b 00 00       	jmp    1cbf3 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10f3>
   1c0a3:	4d 85 ff             	test   %r15,%r15
   1c0a6:	74 4e                	je     1c0f6 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x5f6>
   1c0a8:	48 89 fb             	mov    %rdi,%rbx
   1c0ab:	ff 15 e7 42 04 00    	call   *0x442e7(%rip)        # 60398 <_DYNAMIC+0x280>
   1c0b1:	41 bc 04 00 00 00    	mov    $0x4,%r12d
   1c0b7:	be 04 00 00 00       	mov    $0x4,%esi
   1c0bc:	4c 89 ff             	mov    %r15,%rdi
   1c0bf:	ff 15 db 42 04 00    	call   *0x442db(%rip)        # 603a0 <_DYNAMIC+0x288>
   1c0c5:	48 85 c0             	test   %rax,%rax
   1c0c8:	74 c8                	je     1c092 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x592>
   1c0ca:	48 89 df             	mov    %rbx,%rdi
   1c0cd:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
   1c0d2:	eb 29                	jmp    1c0fd <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x5fd>
   1c0d4:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
   1c0d9:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
   1c0de:	48 8b b4 24 c0 00 00 	mov    0xc0(%rsp),%rsi
   1c0e5:	00 
   1c0e6:	f3 0f 10 44 24 50    	movss  0x50(%rsp),%xmm0
   1c0ec:	e8 ff 0f 00 00       	call   1d0f0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>>
   1c0f1:	e9 6c 07 00 00       	jmp    1c862 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xd62>
   1c0f6:	b8 04 00 00 00       	mov    $0x4,%eax
   1c0fb:	31 c9                	xor    %ecx,%ecx
   1c0fd:	48 89 8c 24 b8 01 00 	mov    %rcx,0x1b8(%rsp)
   1c104:	00 
   1c105:	48 89 84 24 c0 01 00 	mov    %rax,0x1c0(%rsp)
   1c10c:	00 
   1c10d:	48 c7 84 24 c8 01 00 	movq   $0x0,0x1c8(%rsp)
   1c114:	00 00 00 00 00 
   1c119:	f3 0f 10 44 24 50    	movss  0x50(%rsp),%xmm0
   1c11f:	f3 0f 11 44 24 3c    	movss  %xmm0,0x3c(%rsp)
   1c125:	48 8b 8c 24 c0 00 00 	mov    0xc0(%rsp),%rcx
   1c12c:	00 
   1c12d:	48 8b 41 10          	mov    0x10(%rcx),%rax
   1c131:	48 89 84 24 b0 01 00 	mov    %rax,0x1b0(%rsp)
   1c138:	00 
   1c139:	0f 10 01             	movups (%rcx),%xmm0
   1c13c:	0f 11 84 24 a0 01 00 	movups %xmm0,0x1a0(%rsp)
   1c143:	00 
   1c144:	48 c7 84 24 90 01 00 	movq   $0x2,0x190(%rsp)
   1c14b:	00 02 00 00 00 
   1c150:	48 c7 84 24 f0 01 00 	movq   $0x0,0x1f0(%rsp)
   1c157:	00 00 00 00 00 
   1c15c:	c7 84 24 94 02 00 00 	movl   $0x0,0x294(%rsp)
   1c163:	00 00 00 00 
   1c167:	48 c7 84 24 00 02 00 	movq   $0x0,0x200(%rsp)
   1c16e:	00 00 00 00 00 
   1c173:	48 c7 84 24 70 02 00 	movq   $0x0,0x270(%rsp)
   1c17a:	00 00 00 00 00 
   1c17f:	48 c7 84 24 78 02 00 	movq   $0x0,0x278(%rsp)
   1c186:	00 00 00 00 00 
   1c18b:	48 83 bc 24 40 02 00 	cmpq   $0x0,0x240(%rsp)
   1c192:	00 00 
   1c194:	0f 84 60 05 00 00    	je     1c6fa <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xbfa>
   1c19a:	31 db                	xor    %ebx,%ebx
   1c19c:	4c 8d 94 24 d8 00 00 	lea    0xd8(%rsp),%r10
   1c1a3:	00 
   1c1a4:	4c 8d 84 24 98 00 00 	lea    0x98(%rsp),%r8
   1c1ab:	00 
   1c1ac:	4c 8d 8c 24 a0 00 00 	lea    0xa0(%rsp),%r9
   1c1b3:	00 
   1c1b4:	48 8d 05 5d 1f 04 00 	lea    0x41f5d(%rip),%rax        # 5e118 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.14256054827572741256+0x60>
   1c1bb:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
   1c1c0:	48 8d 05 b1 1f 04 00 	lea    0x41fb1(%rip),%rax        # 5e178 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.14256054827572741256+0xc0>
   1c1c7:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   1c1cc:	eb 38                	jmp    1c206 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x706>
   1c1ce:	4c 8b b4 24 88 00 00 	mov    0x88(%rsp),%r14
   1c1d5:	00 
   1c1d6:	4c 3b b4 24 d8 01 00 	cmp    0x1d8(%rsp),%r14
   1c1dd:	00 
   1c1de:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
   1c1e3:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
   1c1e8:	4c 8d 94 24 d8 00 00 	lea    0xd8(%rsp),%r10
   1c1ef:	00 
   1c1f0:	4c 8d 84 24 98 00 00 	lea    0x98(%rsp),%r8
   1c1f7:	00 
   1c1f8:	4c 8d 8c 24 a0 00 00 	lea    0xa0(%rsp),%r9
   1c1ff:	00 
   1c200:	0f 84 f4 04 00 00    	je     1c6fa <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xbfa>
   1c206:	48 89 7c 24 68       	mov    %rdi,0x68(%rsp)
   1c20b:	4c 89 74 24 70       	mov    %r14,0x70(%rsp)
   1c210:	89 5c 24 78          	mov    %ebx,0x78(%rsp)
   1c214:	49 8b 56 10          	mov    0x10(%r14),%rdx
   1c218:	49 8b 4e 18          	mov    0x18(%r14),%rcx
   1c21c:	48 89 fe             	mov    %rdi,%rsi
   1c21f:	4c 89 d7             	mov    %r10,%rdi
   1c222:	e8 79 0a 00 00       	call   1cca0 <parley::editing::geometry::source_runs::<()>>
   1c227:	4c 89 b4 24 88 00 00 	mov    %r14,0x88(%rsp)
   1c22e:	00 
   1c22f:	4c 8b a4 24 e0 00 00 	mov    0xe0(%rsp),%r12
   1c236:	00 
   1c237:	4d 85 e4             	test   %r12,%r12
   1c23a:	0f 84 9c 04 00 00    	je     1c6dc <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xbdc>
   1c240:	48 89 5c 24 28       	mov    %rbx,0x28(%rsp)
   1c245:	4c 8b 74 24 68       	mov    0x68(%rsp),%r14
   1c24a:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
   1c24f:	48 8b 78 10          	mov    0x10(%rax),%rdi
   1c253:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
   1c258:	48 8b 70 18          	mov    0x18(%rax),%rsi
   1c25c:	49 8b 96 30 01 00 00 	mov    0x130(%r14),%rdx
   1c263:	48 39 fe             	cmp    %rdi,%rsi
   1c266:	0f 82 ba 08 00 00    	jb     1cb26 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1026>
   1c26c:	48 39 d6             	cmp    %rdx,%rsi
   1c26f:	0f 87 b1 08 00 00    	ja     1cb26 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1026>
   1c275:	4c 8b ac 24 e8 00 00 	mov    0xe8(%rsp),%r13
   1c27c:	00 
   1c27d:	48 39 f7             	cmp    %rsi,%rdi
   1c280:	0f 85 e2 02 00 00    	jne    1c568 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xa68>
   1c286:	48 83 84 24 88 00 00 	addq   $0x70,0x88(%rsp)
   1c28d:	00 70 
   1c28f:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
   1c294:	ff c0                	inc    %eax
   1c296:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
   1c29b:	49 c1 e5 03          	shl    $0x3,%r13
   1c29f:	45 31 f6             	xor    %r14d,%r14d
   1c2a2:	eb 10                	jmp    1c2b4 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x7b4>
   1c2a4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   1c2ab:	00 00 00 00 00 
   1c2b0:	49 83 c6 08          	add    $0x8,%r14
   1c2b4:	4d 39 f5             	cmp    %r14,%r13
   1c2b7:	0f 84 11 ff ff ff    	je     1c1ce <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x6ce>
   1c2bd:	43 8b 04 34          	mov    (%r12,%r14,1),%eax
   1c2c1:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
   1c2c6:	48 39 c8             	cmp    %rcx,%rax
   1c2c9:	74 e5                	je     1c2b0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x7b0>
   1c2cb:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
   1c2d0:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
   1c2d4:	48 01 c1             	add    %rax,%rcx
   1c2d7:	48 3b 4a 18          	cmp    0x18(%rdx),%rcx
   1c2db:	0f 83 76 08 00 00    	jae    1cb57 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1057>
   1c2e1:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
   1c2e6:	48 3b 8b 30 01 00 00 	cmp    0x130(%rbx),%rcx
   1c2ed:	0f 83 64 08 00 00    	jae    1cb57 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1057>
   1c2f3:	48 8b 93 28 01 00 00 	mov    0x128(%rbx),%rdx
   1c2fa:	48 8d 34 89          	lea    (%rcx,%rcx,4),%rsi
   1c2fe:	48 8d 0c f2          	lea    (%rdx,%rsi,8),%rcx
   1c302:	80 7c f2 21 01       	cmpb   $0x1,0x21(%rdx,%rsi,8)
   1c307:	0f 84 2b 08 00 00    	je     1cb38 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1038>
   1c30d:	4c 8b 79 10          	mov    0x10(%rcx),%r15
   1c311:	48 8b 73 58          	mov    0x58(%rbx),%rsi
   1c315:	49 39 f7             	cmp    %rsi,%r15
   1c318:	0f 83 39 08 00 00    	jae    1cb57 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1057>
   1c31e:	4c 3b bb e8 00 00 00 	cmp    0xe8(%rbx),%r15
   1c325:	0f 83 2c 08 00 00    	jae    1cb57 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1057>
   1c32b:	f3 43 0f 10 44 34 04 	movss  0x4(%r12,%r14,1),%xmm0
   1c332:	8b 54 24 78          	mov    0x78(%rsp),%edx
   1c336:	48 8b 7b 50          	mov    0x50(%rbx),%rdi
   1c33a:	4f 8d 04 ff          	lea    (%r15,%r15,8),%r8
   1c33e:	49 c1 e0 04          	shl    $0x4,%r8
   1c342:	4f 8d 0c bf          	lea    (%r15,%r15,4),%r9
   1c346:	49 c1 e1 04          	shl    $0x4,%r9
   1c34a:	4c 03 8b e0 00 00 00 	add    0xe0(%rbx),%r9
   1c351:	4e 8d 14 07          	lea    (%rdi,%r8,1),%r10
   1c355:	48 89 9c 24 60 01 00 	mov    %rbx,0x160(%rsp)
   1c35c:	00 
   1c35d:	4c 89 94 24 68 01 00 	mov    %r10,0x168(%rsp)
   1c364:	00 
   1c365:	4c 89 8c 24 70 01 00 	mov    %r9,0x170(%rsp)
   1c36c:	00 
   1c36d:	48 89 8c 24 78 01 00 	mov    %rcx,0x178(%rsp)
   1c374:	00 
   1c375:	89 94 24 80 01 00 00 	mov    %edx,0x180(%rsp)
   1c37c:	89 84 24 84 01 00 00 	mov    %eax,0x184(%rsp)
   1c383:	44 89 bc 24 88 01 00 	mov    %r15d,0x188(%rsp)
   1c38a:	00 
   1c38b:	f3 0f 11 44 24 64    	movss  %xmm0,0x64(%rsp)
   1c391:	48 c7 84 24 c8 01 00 	movq   $0x0,0x1c8(%rsp)
   1c398:	00 00 00 00 00 
   1c39d:	42 f6 84 07 8c 00 00 	testb  $0x1,0x8c(%rdi,%r8,1)
   1c3a4:	00 01 
   1c3a6:	74 23                	je     1c3cb <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x8cb>
   1c3a8:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
   1c3af:	00 
   1c3b0:	be 01 00 00 00       	mov    $0x1,%esi
   1c3b5:	48 8d 94 24 b8 01 00 	lea    0x1b8(%rsp),%rdx
   1c3bc:	00 
   1c3bd:	48 8d 4c 24 64       	lea    0x64(%rsp),%rcx
   1c3c2:	e8 99 24 00 00       	call   1e860 <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>>
   1c3c7:	48 8b 73 58          	mov    0x58(%rbx),%rsi
   1c3cb:	48 c7 84 24 80 02 00 	movq   $0x0,0x280(%rsp)
   1c3d2:	00 00 00 00 00 
   1c3d7:	c7 84 24 d4 00 00 00 	movl   $0x0,0xd4(%rsp)
   1c3de:	00 00 00 00 
   1c3e2:	c6 44 24 0f 00       	movb   $0x0,0xf(%rsp)
   1c3e7:	44 89 ff             	mov    %r15d,%edi
   1c3ea:	48 39 fe             	cmp    %rdi,%rsi
   1c3ed:	0f 86 74 07 00 00    	jbe    1cb67 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1067>
   1c3f3:	0f 10 43 68          	movups 0x68(%rbx),%xmm0
   1c3f7:	0f 10 8b 80 00 00 00 	movups 0x80(%rbx),%xmm1
   1c3fe:	f3 0f 6f 93 98 00 00 	movdqu 0x98(%rbx),%xmm2
   1c405:	00 
   1c406:	48 8b 43 50          	mov    0x50(%rbx),%rax
   1c40a:	48 8d 0c ff          	lea    (%rdi,%rdi,8),%rcx
   1c40e:	48 c1 e1 04          	shl    $0x4,%rcx
   1c412:	0f 11 84 24 08 02 00 	movups %xmm0,0x208(%rsp)
   1c419:	00 
   1c41a:	0f 11 8c 24 18 02 00 	movups %xmm1,0x218(%rsp)
   1c421:	00 
   1c422:	f3 0f 7f 94 24 28 02 	movdqu %xmm2,0x228(%rsp)
   1c429:	00 00 
   1c42b:	48 8b 44 08 50       	mov    0x50(%rax,%rcx,1),%rax
   1c430:	48 89 84 24 38 02 00 	mov    %rax,0x238(%rsp)
   1c437:	00 
   1c438:	48 c7 84 24 88 02 00 	movq   $0x0,0x288(%rsp)
   1c43f:	00 00 00 00 00 
   1c444:	48 8d 84 24 08 02 00 	lea    0x208(%rsp),%rax
   1c44b:	00 
   1c44c:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
   1c453:	00 
   1c454:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
   1c459:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
   1c460:	00 
   1c461:	48 8d 84 24 78 02 00 	lea    0x278(%rsp),%rax
   1c468:	00 
   1c469:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
   1c470:	00 
   1c471:	48 8d 84 24 70 02 00 	lea    0x270(%rsp),%rax
   1c478:	00 
   1c479:	48 89 84 24 f0 00 00 	mov    %rax,0xf0(%rsp)
   1c480:	00 
   1c481:	48 8d 84 24 b8 01 00 	lea    0x1b8(%rsp),%rax
   1c488:	00 
   1c489:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
   1c490:	00 
   1c491:	48 8d 84 24 88 02 00 	lea    0x288(%rsp),%rax
   1c498:	00 
   1c499:	48 89 84 24 00 01 00 	mov    %rax,0x100(%rsp)
   1c4a0:	00 
   1c4a1:	48 8d 44 24 64       	lea    0x64(%rsp),%rax
   1c4a6:	48 89 84 24 08 01 00 	mov    %rax,0x108(%rsp)
   1c4ad:	00 
   1c4ae:	48 8d 44 24 0f       	lea    0xf(%rsp),%rax
   1c4b3:	48 89 84 24 10 01 00 	mov    %rax,0x110(%rsp)
   1c4ba:	00 
   1c4bb:	48 8d 84 24 90 01 00 	lea    0x190(%rsp),%rax
   1c4c2:	00 
   1c4c3:	48 89 84 24 18 01 00 	mov    %rax,0x118(%rsp)
   1c4ca:	00 
   1c4cb:	48 8d 84 24 f0 01 00 	lea    0x1f0(%rsp),%rax
   1c4d2:	00 
   1c4d3:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
   1c4da:	00 
   1c4db:	48 8d 44 24 3c       	lea    0x3c(%rsp),%rax
   1c4e0:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
   1c4e7:	00 
   1c4e8:	48 8d 44 24 58       	lea    0x58(%rsp),%rax
   1c4ed:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
   1c4f4:	00 
   1c4f5:	48 8d 84 24 80 02 00 	lea    0x280(%rsp),%rax
   1c4fc:	00 
   1c4fd:	48 89 84 24 38 01 00 	mov    %rax,0x138(%rsp)
   1c504:	00 
   1c505:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
   1c50a:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
   1c511:	00 
   1c512:	48 8d 84 24 d4 00 00 	lea    0xd4(%rsp),%rax
   1c519:	00 
   1c51a:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
   1c521:	00 
   1c522:	48 8d 84 24 94 02 00 	lea    0x294(%rsp),%rax
   1c529:	00 
   1c52a:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
   1c531:	00 
   1c532:	48 8d 84 24 00 02 00 	lea    0x200(%rsp),%rax
   1c539:	00 
   1c53a:	48 89 84 24 58 01 00 	mov    %rax,0x158(%rsp)
   1c541:	00 
   1c542:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
   1c549:	00 
   1c54a:	31 f6                	xor    %esi,%esi
   1c54c:	48 8d 94 24 d8 00 00 	lea    0xd8(%rsp),%rdx
   1c553:	00 
   1c554:	e8 f7 1c 00 00       	call   1e250 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>>
   1c559:	89 c5                	mov    %eax,%ebp
   1c55b:	3c ff                	cmp    $0xff,%al
   1c55d:	0f 84 4d fd ff ff    	je     1c2b0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x7b0>
   1c563:	e9 6a 01 00 00       	jmp    1c6d2 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xbd2>
   1c568:	48 8b 84 24 d8 00 00 	mov    0xd8(%rsp),%rax
   1c56f:	00 
   1c570:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
   1c575:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   1c57a:	f3 0f 10 48 28       	movss  0x28(%rax),%xmm1
   1c57f:	8b 44 24 78          	mov    0x78(%rsp),%eax
   1c583:	89 84 24 90 00 00 00 	mov    %eax,0x90(%rsp)
   1c58a:	48 c1 e7 03          	shl    $0x3,%rdi
   1c58e:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
   1c592:	49 8b 9e 28 01 00 00 	mov    0x128(%r14),%rbx
   1c599:	48 01 c3             	add    %rax,%rbx
   1c59c:	48 c1 e6 03          	shl    $0x3,%rsi
   1c5a0:	4c 8d 3c b6          	lea    (%rsi,%rsi,4),%r15
   1c5a4:	49 29 c7             	sub    %rax,%r15
   1c5a7:	31 ed                	xor    %ebp,%ebp
   1c5a9:	eb 20                	jmp    1c5cb <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xacb>
   1c5ab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   1c5b0:	f3 0f 10 4c 24 10    	movss  0x10(%rsp),%xmm1
   1c5b6:	48 83 c3 28          	add    $0x28,%rbx
   1c5ba:	f3 0f 58 c8          	addss  %xmm0,%xmm1
   1c5be:	48 ff c5             	inc    %rbp
   1c5c1:	49 83 c7 d8          	add    $0xffffffffffffffd8,%r15
   1c5c5:	0f 84 bb fc ff ff    	je     1c286 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x786>
   1c5cb:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
   1c5cf:	80 7b 21 01          	cmpb   $0x1,0x21(%rbx)
   1c5d3:	75 2b                	jne    1c600 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xb00>
   1c5d5:	49 8b 76 40          	mov    0x40(%r14),%rsi
   1c5d9:	48 39 f7             	cmp    %rsi,%rdi
   1c5dc:	0f 83 a0 05 00 00    	jae    1cb82 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1082>
   1c5e2:	49 8b 46 38          	mov    0x38(%r14),%rax
   1c5e6:	48 6b cf 38          	imul   $0x38,%rdi,%rcx
   1c5ea:	f3 0f 10 44 08 24    	movss  0x24(%rax,%rcx,1),%xmm0
   1c5f0:	eb c4                	jmp    1c5b6 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xab6>
   1c5f2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   1c5f9:	1f 84 00 00 00 00 00 
   1c600:	49 8b 76 58          	mov    0x58(%r14),%rsi
   1c604:	48 39 f7             	cmp    %rsi,%rdi
   1c607:	0f 83 8d 05 00 00    	jae    1cb9a <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x109a>
   1c60d:	49 8b b6 e8 00 00 00 	mov    0xe8(%r14),%rsi
   1c614:	48 39 f7             	cmp    %rsi,%rdi
   1c617:	0f 83 5c 05 00 00    	jae    1cb79 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1079>
   1c61d:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   1c621:	48 c1 e0 04          	shl    $0x4,%rax
   1c625:	49 03 46 50          	add    0x50(%r14),%rax
   1c629:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
   1c62d:	48 c1 e1 04          	shl    $0x4,%rcx
   1c631:	49 03 8e e0 00 00 00 	add    0xe0(%r14),%rcx
   1c638:	4c 89 b4 24 d8 00 00 	mov    %r14,0xd8(%rsp)
   1c63f:	00 
   1c640:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
   1c647:	00 
   1c648:	48 89 8c 24 e8 00 00 	mov    %rcx,0xe8(%rsp)
   1c64f:	00 
   1c650:	48 89 9c 24 f0 00 00 	mov    %rbx,0xf0(%rsp)
   1c657:	00 
   1c658:	8b 84 24 90 00 00 00 	mov    0x90(%rsp),%eax
   1c65f:	89 84 24 f8 00 00 00 	mov    %eax,0xf8(%rsp)
   1c666:	89 ac 24 fc 00 00 00 	mov    %ebp,0xfc(%rsp)
   1c66d:	89 bc 24 00 01 00 00 	mov    %edi,0x100(%rsp)
   1c674:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
   1c679:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
   1c67e:	48 8b 79 10          	mov    0x10(%rcx),%rdi
   1c682:	48 01 ef             	add    %rbp,%rdi
   1c685:	48 8b b0 30 01 00 00 	mov    0x130(%rax),%rsi
   1c68c:	48 39 f7             	cmp    %rsi,%rdi
   1c68f:	0f 83 db 04 00 00    	jae    1cb70 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1070>
   1c695:	48 8b 80 28 01 00 00 	mov    0x128(%rax),%rax
   1c69c:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
   1c6a0:	48 8b 7c c8 10       	mov    0x10(%rax,%rcx,8),%rdi
   1c6a5:	48 2b 7c 24 50       	sub    0x50(%rsp),%rdi
   1c6aa:	4c 39 ef             	cmp    %r13,%rdi
   1c6ad:	0f 83 d8 04 00 00    	jae    1cb8b <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x108b>
   1c6b3:	f3 0f 11 4c 24 10    	movss  %xmm1,0x10(%rsp)
   1c6b9:	f3 41 0f 11 4c fc 04 	movss  %xmm1,0x4(%r12,%rdi,8)
   1c6c0:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
   1c6c7:	00 
   1c6c8:	e8 93 2c 00 00       	call   1f360 <<parley::layout::run::Run<()>>::advance>
   1c6cd:	e9 de fe ff ff       	jmp    1c5b0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xab0>
   1c6d2:	40 80 fd 02          	cmp    $0x2,%bpl
   1c6d6:	0f 85 dc 03 00 00    	jne    1cab8 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfb8>
   1c6dc:	48 8d 3d c0 a0 fe ff 	lea    -0x15f40(%rip),%rdi        # 67a3 <anon.5cab36dad6fad55fc602ca21d50a03ec.33.llvm.4639087895861959750+0x27c>
   1c6e3:	48 8d 15 e6 19 04 00 	lea    0x419e6(%rip),%rdx        # 5e0d0 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.14256054827572741256+0x18>
   1c6ea:	be 6b 00 00 00       	mov    $0x6b,%esi
   1c6ef:	ff 15 db 3c 04 00    	call   *0x43cdb(%rip)        # 603d0 <_DYNAMIC+0x2b8>
   1c6f5:	e9 f9 04 00 00       	jmp    1cbf3 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10f3>
   1c6fa:	4c 8d a4 24 98 02 00 	lea    0x298(%rsp),%r12
   1c701:	00 
   1c702:	45 31 ed             	xor    %r13d,%r13d
   1c705:	4c 8d b4 24 d8 00 00 	lea    0xd8(%rsp),%r14
   1c70c:	00 
   1c70d:	eb 03                	jmp    1c712 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc12>
   1c70f:	4c 89 38             	mov    %r15,(%rax)
   1c712:	48 8b 8c 24 90 01 00 	mov    0x190(%rsp),%rcx
   1c719:	00 
   1c71a:	48 83 f9 02          	cmp    $0x2,%rcx
   1c71e:	75 4d                	jne    1c76d <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc6d>
   1c720:	80 bc 24 b0 01 00 00 	cmpb   $0x0,0x1b0(%rsp)
   1c727:	00 
   1c728:	75 12                	jne    1c73c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc3c>
   1c72a:	48 8b 84 24 a0 01 00 	mov    0x1a0(%rsp),%rax
   1c731:	00 
   1c732:	48 3b 84 24 a8 01 00 	cmp    0x1a8(%rsp),%rax
   1c739:	00 
   1c73a:	76 04                	jbe    1c740 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc40>
   1c73c:	31 c9                	xor    %ecx,%ecx
   1c73e:	eb 1d                	jmp    1c75d <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc5d>
   1c740:	73 0e                	jae    1c750 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc50>
   1c742:	48 8d 48 01          	lea    0x1(%rax),%rcx
   1c746:	48 89 8c 24 a0 01 00 	mov    %rcx,0x1a0(%rsp)
   1c74d:	00 
   1c74e:	eb 08                	jmp    1c758 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc58>
   1c750:	c6 84 24 b0 01 00 00 	movb   $0x1,0x1b0(%rsp)
   1c757:	01 
   1c758:	b9 01 00 00 00       	mov    $0x1,%ecx
   1c75d:	48 89 8c 24 90 01 00 	mov    %rcx,0x190(%rsp)
   1c764:	00 
   1c765:	48 89 84 24 98 01 00 	mov    %rax,0x198(%rsp)
   1c76c:	00 
   1c76d:	83 f9 01             	cmp    $0x1,%ecx
   1c770:	0f 85 40 03 00 00    	jne    1cab6 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfb6>
   1c776:	4c 8b bc 24 98 01 00 	mov    0x198(%rsp),%r15
   1c77d:	00 
   1c77e:	83 bc 24 f0 01 00 00 	cmpl   $0x1,0x1f0(%rsp)
   1c785:	01 
   1c786:	75 0e                	jne    1c796 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc96>
   1c788:	4c 3b bc 24 f8 01 00 	cmp    0x1f8(%rsp),%r15
   1c78f:	00 
   1c790:	0f 82 e4 00 00 00    	jb     1c87a <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xd7a>
   1c796:	48 c7 84 24 90 01 00 	movq   $0x2,0x190(%rsp)
   1c79d:	00 02 00 00 00 
   1c7a2:	48 c7 84 24 f0 01 00 	movq   $0x1,0x1f0(%rsp)
   1c7a9:	00 01 00 00 00 
   1c7ae:	4c 89 bc 24 f8 01 00 	mov    %r15,0x1f8(%rsp)
   1c7b5:	00 
   1c7b6:	4c 89 e1             	mov    %r12,%rcx
   1c7b9:	4c 39 bc 24 00 02 00 	cmp    %r15,0x200(%rsp)
   1c7c0:	00 
   1c7c1:	74 02                	je     1c7c5 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xcc5>
   1c7c3:	31 c9                	xor    %ecx,%ecx
   1c7c5:	80 bc 24 94 02 00 00 	cmpb   $0x0,0x294(%rsp)
   1c7cc:	00 
   1c7cd:	49 0f 44 cd          	cmove  %r13,%rcx
   1c7d1:	66 0f 6e 44 24 3c    	movd   0x3c(%rsp),%xmm0
   1c7d7:	4c 89 f7             	mov    %r14,%rdi
   1c7da:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
   1c7df:	4c 89 fa             	mov    %r15,%rdx
   1c7e2:	45 31 c0             	xor    %r8d,%r8d
   1c7e5:	e8 06 16 00 00       	call   1ddf0 <parley::editing::geometry::pair_from_entries::<()>>
   1c7ea:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
   1c7ef:	4c 33 38             	xor    (%rax),%r15
   1c7f2:	48 83 bc 24 d8 00 00 	cmpq   $0x1,0xd8(%rsp)
   1c7f9:	00 01 
   1c7fb:	0f 85 0e ff ff ff    	jne    1c70f <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc0f>
   1c801:	f3 0f 6f 84 24 e0 00 	movdqu 0xe0(%rsp),%xmm0
   1c808:	00 00 
   1c80a:	f3 0f 6f 8c 24 f0 00 	movdqu 0xf0(%rsp),%xmm1
   1c811:	00 00 
   1c813:	f3 0f 6f 94 24 00 01 	movdqu 0x100(%rsp),%xmm2
   1c81a:	00 00 
   1c81c:	66 0f ef d0          	pxor   %xmm0,%xmm2
   1c820:	f3 0f 6f 84 24 10 01 	movdqu 0x110(%rsp),%xmm0
   1c827:	00 00 
   1c829:	66 0f ef c1          	pxor   %xmm1,%xmm0
   1c82d:	66 0f ef c2          	pxor   %xmm2,%xmm0
   1c831:	66 0f 70 c8 ee       	pshufd $0xee,%xmm0,%xmm1
   1c836:	66 0f ef c8          	pxor   %xmm0,%xmm1
   1c83a:	66 48 0f 7e c9       	movq   %xmm1,%rcx
   1c83f:	49 31 cf             	xor    %rcx,%r15
   1c842:	e9 c8 fe ff ff       	jmp    1c70f <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc0f>
   1c847:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
   1c84c:	48 89 df             	mov    %rbx,%rdi
   1c84f:	48 8b b4 24 c0 00 00 	mov    0xc0(%rsp),%rsi
   1c856:	00 
   1c857:	f3 0f 10 44 24 50    	movss  0x50(%rsp),%xmm0
   1c85d:	e8 8e 08 00 00       	call   1d0f0 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>>
   1c862:	89 c5                	mov    %eax,%ebp
   1c864:	48 8b b4 24 a0 00 00 	mov    0xa0(%rsp),%rsi
   1c86b:	00 
   1c86c:	48 85 f6             	test   %rsi,%rsi
   1c86f:	0f 85 74 02 00 00    	jne    1cae9 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfe9>
   1c875:	e9 86 02 00 00       	jmp    1cb00 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1000>
   1c87a:	4c 8b b4 24 a0 01 00 	mov    0x1a0(%rsp),%r14
   1c881:	00 
   1c882:	4c 8b a4 24 a8 01 00 	mov    0x1a8(%rsp),%r12
   1c889:	00 
   1c88a:	0f b6 84 24 b0 01 00 	movzbl 0x1b0(%rsp),%eax
   1c891:	00 
   1c892:	88 44 24 30          	mov    %al,0x30(%rsp)
   1c896:	f3 0f 10 44 24 3c    	movss  0x3c(%rsp),%xmm0
   1c89c:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
   1c8a2:	4c 8b 6c 24 58       	mov    0x58(%rsp),%r13
   1c8a7:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
   1c8ac:	4c 89 fe             	mov    %r15,%rsi
   1c8af:	ba 01 00 00 00       	mov    $0x1,%edx
   1c8b4:	e8 e7 e3 ff ff       	call   1aca0 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
   1c8b9:	48 8d ac 24 f8 00 00 	lea    0xf8(%rsp),%rbp
   1c8c0:	00 
   1c8c1:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
   1c8c6:	80 e2 01             	and    $0x1,%dl
   1c8c9:	88 54 24 70          	mov    %dl,0x70(%rsp)
   1c8cd:	4c 39 f8             	cmp    %r15,%rax
   1c8d0:	0f 85 b9 00 00 00    	jne    1c98f <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xe8f>
   1c8d6:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
   1c8dd:	00 
   1c8de:	48 8d 74 24 68       	lea    0x68(%rsp),%rsi
   1c8e3:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
   1c8e8:	48 89 da             	mov    %rbx,%rdx
   1c8eb:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
   1c8f1:	e8 6a e4 ff ff       	call   1ad60 <<parley::editing::cursor::Cursor>::geometry::<()>>
   1c8f6:	48 89 df             	mov    %rbx,%rdi
   1c8f9:	4c 89 fe             	mov    %r15,%rsi
   1c8fc:	31 d2                	xor    %edx,%edx
   1c8fe:	e8 9d e3 ff ff       	call   1aca0 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
   1c903:	48 89 84 24 60 01 00 	mov    %rax,0x160(%rsp)
   1c90a:	00 
   1c90b:	80 e2 01             	and    $0x1,%dl
   1c90e:	88 94 24 68 01 00 00 	mov    %dl,0x168(%rsp)
   1c915:	48 8d bc 24 08 02 00 	lea    0x208(%rsp),%rdi
   1c91c:	00 
   1c91d:	48 8d b4 24 60 01 00 	lea    0x160(%rsp),%rsi
   1c924:	00 
   1c925:	48 89 da             	mov    %rbx,%rdx
   1c928:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
   1c92e:	e8 2d e4 ff ff       	call   1ad60 <<parley::editing::cursor::Cursor>::geometry::<()>>
   1c933:	0f 10 84 24 08 02 00 	movups 0x208(%rsp),%xmm0
   1c93a:	00 
   1c93b:	0f 10 8c 24 18 02 00 	movups 0x218(%rsp),%xmm1
   1c942:	00 
   1c943:	0f 11 4d 10          	movups %xmm1,0x10(%rbp)
   1c947:	0f 11 45 00          	movups %xmm0,0x0(%rbp)
   1c94b:	f3 0f 6f 84 24 d8 00 	movdqu 0xd8(%rsp),%xmm0
   1c952:	00 00 
   1c954:	f3 0f 6f 8c 24 e8 00 	movdqu 0xe8(%rsp),%xmm1
   1c95b:	00 00 
   1c95d:	f3 0f 6f 94 24 f8 00 	movdqu 0xf8(%rsp),%xmm2
   1c964:	00 00 
   1c966:	66 0f ef d0          	pxor   %xmm0,%xmm2
   1c96a:	f3 0f 6f 84 24 08 01 	movdqu 0x108(%rsp),%xmm0
   1c971:	00 00 
   1c973:	66 0f ef c1          	pxor   %xmm1,%xmm0
   1c977:	66 0f ef c2          	pxor   %xmm2,%xmm0
   1c97b:	66 0f 70 c8 ee       	pshufd $0xee,%xmm0,%xmm1
   1c980:	66 0f ef c8          	pxor   %xmm0,%xmm1
   1c984:	66 48 0f 7e c8       	movq   %xmm1,%rax
   1c989:	49 33 45 00          	xor    0x0(%r13),%rax
   1c98d:	eb 04                	jmp    1c993 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xe93>
   1c98f:	49 8b 45 00          	mov    0x0(%r13),%rax
   1c993:	4c 31 f8             	xor    %r15,%rax
   1c996:	49 89 45 00          	mov    %rax,0x0(%r13)
   1c99a:	4d 39 e6             	cmp    %r12,%r14
   1c99d:	0f 97 c0             	seta   %al
   1c9a0:	0f b6 4c 24 30       	movzbl 0x30(%rsp),%ecx
   1c9a5:	08 c1                	or     %al,%cl
   1c9a7:	f6 c1 01             	test   $0x1,%cl
   1c9aa:	0f 85 06 01 00 00    	jne    1cab6 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfb6>
   1c9b0:	4c 89 f3             	mov    %r14,%rbx
   1c9b3:	4c 8b 7c 24 20       	mov    0x20(%rsp),%r15
   1c9b8:	4d 39 e6             	cmp    %r12,%r14
   1c9bb:	48 83 d3 00          	adc    $0x0,%rbx
   1c9bf:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
   1c9c4:	4c 89 f6             	mov    %r14,%rsi
   1c9c7:	ba 01 00 00 00       	mov    $0x1,%edx
   1c9cc:	e8 cf e2 ff ff       	call   1aca0 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
   1c9d1:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
   1c9d6:	80 e2 01             	and    $0x1,%dl
   1c9d9:	88 54 24 70          	mov    %dl,0x70(%rsp)
   1c9dd:	4c 39 f0             	cmp    %r14,%rax
   1c9e0:	0f 85 b4 00 00 00    	jne    1ca9a <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xf9a>
   1c9e6:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
   1c9ed:	00 
   1c9ee:	48 8d 74 24 68       	lea    0x68(%rsp),%rsi
   1c9f3:	4c 89 fa             	mov    %r15,%rdx
   1c9f6:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
   1c9fc:	e8 5f e3 ff ff       	call   1ad60 <<parley::editing::cursor::Cursor>::geometry::<()>>
   1ca01:	4c 89 ff             	mov    %r15,%rdi
   1ca04:	4c 89 f6             	mov    %r14,%rsi
   1ca07:	31 d2                	xor    %edx,%edx
   1ca09:	e8 92 e2 ff ff       	call   1aca0 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
   1ca0e:	48 89 84 24 60 01 00 	mov    %rax,0x160(%rsp)
   1ca15:	00 
   1ca16:	80 e2 01             	and    $0x1,%dl
   1ca19:	88 94 24 68 01 00 00 	mov    %dl,0x168(%rsp)
   1ca20:	48 8d bc 24 08 02 00 	lea    0x208(%rsp),%rdi
   1ca27:	00 
   1ca28:	48 8d b4 24 60 01 00 	lea    0x160(%rsp),%rsi
   1ca2f:	00 
   1ca30:	4c 89 fa             	mov    %r15,%rdx
   1ca33:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
   1ca39:	e8 22 e3 ff ff       	call   1ad60 <<parley::editing::cursor::Cursor>::geometry::<()>>
   1ca3e:	0f 10 84 24 08 02 00 	movups 0x208(%rsp),%xmm0
   1ca45:	00 
   1ca46:	0f 10 8c 24 18 02 00 	movups 0x218(%rsp),%xmm1
   1ca4d:	00 
   1ca4e:	0f 11 4d 10          	movups %xmm1,0x10(%rbp)
   1ca52:	0f 11 45 00          	movups %xmm0,0x0(%rbp)
   1ca56:	f3 0f 6f 84 24 d8 00 	movdqu 0xd8(%rsp),%xmm0
   1ca5d:	00 00 
   1ca5f:	f3 0f 6f 8c 24 e8 00 	movdqu 0xe8(%rsp),%xmm1
   1ca66:	00 00 
   1ca68:	f3 0f 6f 94 24 f8 00 	movdqu 0xf8(%rsp),%xmm2
   1ca6f:	00 00 
   1ca71:	66 0f ef d0          	pxor   %xmm0,%xmm2
   1ca75:	f3 0f 6f 84 24 08 01 	movdqu 0x108(%rsp),%xmm0
   1ca7c:	00 00 
   1ca7e:	66 0f ef c1          	pxor   %xmm1,%xmm0
   1ca82:	66 0f ef c2          	pxor   %xmm2,%xmm0
   1ca86:	66 0f 70 c8 ee       	pshufd $0xee,%xmm0,%xmm1
   1ca8b:	66 0f ef c8          	pxor   %xmm0,%xmm1
   1ca8f:	66 48 0f 7e c8       	movq   %xmm1,%rax
   1ca94:	49 33 45 00          	xor    0x0(%r13),%rax
   1ca98:	eb 04                	jmp    1ca9e <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xf9e>
   1ca9a:	49 8b 45 00          	mov    0x0(%r13),%rax
   1ca9e:	4c 31 f0             	xor    %r14,%rax
   1caa1:	49 89 45 00          	mov    %rax,0x0(%r13)
   1caa5:	4d 39 e6             	cmp    %r12,%r14
   1caa8:	73 0c                	jae    1cab6 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfb6>
   1caaa:	49 89 de             	mov    %rbx,%r14
   1caad:	4c 39 e3             	cmp    %r12,%rbx
   1cab0:	0f 86 02 ff ff ff    	jbe    1c9b8 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xeb8>
   1cab6:	31 ed                	xor    %ebp,%ebp
   1cab8:	48 8b b4 24 b8 01 00 	mov    0x1b8(%rsp),%rsi
   1cabf:	00 
   1cac0:	48 85 f6             	test   %rsi,%rsi
   1cac3:	74 17                	je     1cadc <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfdc>
   1cac5:	48 8b bc 24 c0 01 00 	mov    0x1c0(%rsp),%rdi
   1cacc:	00 
   1cacd:	48 c1 e6 02          	shl    $0x2,%rsi
   1cad1:	ba 04 00 00 00       	mov    $0x4,%edx
   1cad6:	ff 15 d4 38 04 00    	call   *0x438d4(%rip)        # 603b0 <_DYNAMIC+0x298>
   1cadc:	48 8b b4 24 a0 00 00 	mov    0xa0(%rsp),%rsi
   1cae3:	00 
   1cae4:	48 85 f6             	test   %rsi,%rsi
   1cae7:	74 17                	je     1cb00 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1000>
   1cae9:	48 8b bc 24 a8 00 00 	mov    0xa8(%rsp),%rdi
   1caf0:	00 
   1caf1:	48 c1 e6 03          	shl    $0x3,%rsi
   1caf5:	ba 04 00 00 00       	mov    $0x4,%edx
   1cafa:	ff 15 b0 38 04 00    	call   *0x438b0(%rip)        # 603b0 <_DYNAMIC+0x298>
   1cb00:	89 e8                	mov    %ebp,%eax
   1cb02:	48 81 c4 a8 02 00 00 	add    $0x2a8,%rsp
   1cb09:	5b                   	pop    %rbx
   1cb0a:	41 5c                	pop    %r12
   1cb0c:	41 5d                	pop    %r13
   1cb0e:	41 5e                	pop    %r14
   1cb10:	41 5f                	pop    %r15
   1cb12:	5d                   	pop    %rbp
   1cb13:	c3                   	ret
   1cb14:	40 b5 02             	mov    $0x2,%bpl
   1cb17:	48 8b b4 24 a0 00 00 	mov    0xa0(%rsp),%rsi
   1cb1e:	00 
   1cb1f:	48 85 f6             	test   %rsi,%rsi
   1cb22:	75 c5                	jne    1cae9 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfe9>
   1cb24:	eb da                	jmp    1cb00 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1000>
   1cb26:	48 8d 0d 13 15 04 00 	lea    0x41513(%rip),%rcx        # 5e040 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.10.llvm.14256054827572741256>
   1cb2d:	ff 15 1d 38 04 00    	call   *0x4381d(%rip)        # 60350 <_DYNAMIC+0x238>
   1cb33:	e9 bb 00 00 00       	jmp    1cbf3 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10f3>
   1cb38:	48 8b 41 10          	mov    0x10(%rcx),%rax
   1cb3c:	48 3b 43 40          	cmp    0x40(%rbx),%rax
   1cb40:	48 8d 05 e9 15 04 00 	lea    0x415e9(%rip),%rax        # 5e130 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.14256054827572741256+0x78>
   1cb47:	48 8d 0d ca 15 04 00 	lea    0x415ca(%rip),%rcx        # 5e118 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.14256054827572741256+0x60>
   1cb4e:	48 0f 42 c8          	cmovb  %rax,%rcx
   1cb52:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
   1cb57:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
   1cb5c:	ff 15 16 38 04 00    	call   *0x43816(%rip)        # 60378 <_DYNAMIC+0x260>
   1cb62:	e9 8c 00 00 00       	jmp    1cbf3 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10f3>
   1cb67:	48 8d 05 82 16 04 00 	lea    0x41682(%rip),%rax        # 5e1f0 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.14256054827572741256+0x138>
   1cb6e:	eb 25                	jmp    1cb95 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1095>
   1cb70:	48 8d 05 d1 15 04 00 	lea    0x415d1(%rip),%rax        # 5e148 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.14256054827572741256+0x90>
   1cb77:	eb 1c                	jmp    1cb95 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1095>
   1cb79:	48 8d 05 10 16 04 00 	lea    0x41610(%rip),%rax        # 5e190 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.14256054827572741256+0xd8>
   1cb80:	eb 13                	jmp    1cb95 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1095>
   1cb82:	48 8d 05 1f 16 04 00 	lea    0x4161f(%rip),%rax        # 5e1a8 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.14256054827572741256+0xf0>
   1cb89:	eb 0a                	jmp    1cb95 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1095>
   1cb8b:	4c 89 ee             	mov    %r13,%rsi
   1cb8e:	48 8d 05 cb 15 04 00 	lea    0x415cb(%rip),%rax        # 5e160 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.14256054827572741256+0xa8>
   1cb95:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   1cb9a:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
   1cb9f:	ff 15 a3 37 04 00    	call   *0x437a3(%rip)        # 60348 <_DYNAMIC+0x230>
   1cba5:	eb 4c                	jmp    1cbf3 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10f3>
   1cba7:	48 89 b4 24 80 00 00 	mov    %rsi,0x80(%rsp)
   1cbae:	00 
   1cbaf:	48 8d 05 0a 16 04 00 	lea    0x4160a(%rip),%rax        # 5e1c0 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.14256054827572741256+0x108>
   1cbb6:	eb 1a                	jmp    1cbd2 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10d2>
   1cbb8:	48 89 c5             	mov    %rax,%rbp
   1cbbb:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
   1cbc2:	00 
   1cbc3:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
   1cbca:	00 
   1cbcb:	48 8d 05 06 16 04 00 	lea    0x41606(%rip),%rax        # 5e1d8 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.14256054827572741256+0x120>
   1cbd2:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
   1cbd9:	00 
   1cbda:	48 89 ef             	mov    %rbp,%rdi
   1cbdd:	48 8b b4 24 80 00 00 	mov    0x80(%rsp),%rsi
   1cbe4:	00 
   1cbe5:	48 8b 94 24 b8 00 00 	mov    0xb8(%rsp),%rdx
   1cbec:	00 
   1cbed:	ff 15 55 37 04 00    	call   *0x43755(%rip)        # 60348 <_DYNAMIC+0x230>
   1cbf3:	0f 0b                	ud2
   1cbf5:	eb 10                	jmp    1cc07 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1107>
   1cbf7:	eb 37                	jmp    1cc30 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1130>
   1cbf9:	eb 0c                	jmp    1cc07 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1107>
   1cbfb:	eb 0a                	jmp    1cc07 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1107>
   1cbfd:	eb 31                	jmp    1cc30 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1130>
   1cbff:	eb 06                	jmp    1cc07 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1107>
   1cc01:	eb 04                	jmp    1cc07 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1107>
   1cc03:	eb 2b                	jmp    1cc30 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1130>
   1cc05:	eb 29                	jmp    1cc30 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1130>
   1cc07:	48 89 c3             	mov    %rax,%rbx
   1cc0a:	48 8b b4 24 b8 01 00 	mov    0x1b8(%rsp),%rsi
   1cc11:	00 
   1cc12:	48 85 f6             	test   %rsi,%rsi
   1cc15:	74 1c                	je     1cc33 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1133>
   1cc17:	48 8b bc 24 c0 01 00 	mov    0x1c0(%rsp),%rdi
   1cc1e:	00 
   1cc1f:	48 c1 e6 02          	shl    $0x2,%rsi
   1cc23:	ba 04 00 00 00       	mov    $0x4,%edx
   1cc28:	ff 15 82 37 04 00    	call   *0x43782(%rip)        # 603b0 <_DYNAMIC+0x298>
   1cc2e:	eb 03                	jmp    1cc33 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1133>
   1cc30:	48 89 c3             	mov    %rax,%rbx
   1cc33:	48 8b b4 24 a0 00 00 	mov    0xa0(%rsp),%rsi
   1cc3a:	00 
   1cc3b:	48 85 f6             	test   %rsi,%rsi
   1cc3e:	74 17                	je     1cc57 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1157>
   1cc40:	48 8b bc 24 a8 00 00 	mov    0xa8(%rsp),%rdi
   1cc47:	00 
   1cc48:	48 c1 e6 03          	shl    $0x3,%rsi
   1cc4c:	ba 04 00 00 00       	mov    $0x4,%edx
   1cc51:	ff 15 59 37 04 00    	call   *0x43759(%rip)        # 603b0 <_DYNAMIC+0x298>
   1cc57:	48 89 df             	mov    %rbx,%rdi
   1cc5a:	e8 f1 02 04 00       	call   5cf50 <_Unwind_Resume@plt>
