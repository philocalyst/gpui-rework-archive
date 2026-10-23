
/tmp/gpui-caret-transaction-bin/d54-codegen:     file format elf64-x86-64


Disassembly of section .text:

000000000001bb60 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>>:
   1bb60:	55                   	push   %rbp
   1bb61:	41 57                	push   %r15
   1bb63:	41 56                	push   %r14
   1bb65:	41 55                	push   %r13
   1bb67:	41 54                	push   %r12
   1bb69:	53                   	push   %rbx
   1bb6a:	48 81 ec a8 02 00 00 	sub    $0x2a8,%rsp
   1bb71:	48 89 54 24 58       	mov    %rdx,0x58(%rsp)
   1bb76:	4c 8b a7 50 01 00 00 	mov    0x150(%rdi),%r12
   1bb7d:	4c 89 e0             	mov    %r12,%rax
   1bb80:	48 c1 e8 20          	shr    $0x20,%rax
   1bb84:	74 16                	je     1bb9c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x3c>
   1bb86:	48 81 c4 a8 02 00 00 	add    $0x2a8,%rsp
   1bb8d:	5b                   	pop    %rbx
   1bb8e:	41 5c                	pop    %r12
   1bb90:	41 5d                	pop    %r13
   1bb92:	41 5e                	pop    %r14
   1bb94:	41 5f                	pop    %r15
   1bb96:	5d                   	pop    %rbp
   1bb97:	e9 c4 15 00 00       	jmp    1d160 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>>
   1bb9c:	f3 0f 11 44 24 50    	movss  %xmm0,0x50(%rsp)
   1bba2:	48 8b 57 70          	mov    0x70(%rdi),%rdx
   1bba6:	48 89 d0             	mov    %rdx,%rax
   1bba9:	48 c1 e8 20          	shr    $0x20,%rax
   1bbad:	40 b5 02             	mov    $0x2,%bpl
   1bbb0:	0f 85 b6 0f 00 00    	jne    1cb6c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x100c>
   1bbb6:	48 8b 8f 18 01 00 00 	mov    0x118(%rdi),%rcx
   1bbbd:	48 89 c8             	mov    %rcx,%rax
   1bbc0:	48 c1 e8 20          	shr    $0x20,%rax
   1bbc4:	0f 85 a2 0f 00 00    	jne    1cb6c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x100c>
   1bbca:	48 89 b4 24 c0 00 00 	mov    %rsi,0xc0(%rsp)
   1bbd1:	00 
   1bbd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   1bbd7:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
   1bbde:	00 
   1bbdf:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
   1bbe6:	00 00 00 00 00 
   1bbeb:	48 c7 84 24 a8 00 00 	movq   $0x4,0xa8(%rsp)
   1bbf2:	00 04 00 00 00 
   1bbf7:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
   1bbfe:	00 00 00 00 00 
   1bc03:	4c 8b b7 10 01 00 00 	mov    0x110(%rdi),%r14
   1bc0a:	48 6b c1 70          	imul   $0x70,%rcx,%rax
   1bc0e:	4c 01 f0             	add    %r14,%rax
   1bc11:	48 89 84 24 d8 01 00 	mov    %rax,0x1d8(%rsp)
   1bc18:	00 
   1bc19:	48 85 c9             	test   %rcx,%rcx
   1bc1c:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
   1bc21:	48 89 8c 24 40 02 00 	mov    %rcx,0x240(%rsp)
   1bc28:	00 
   1bc29:	0f 84 8f 04 00 00    	je     1c0be <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x55e>
   1bc2f:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
   1bc34:	48 8b 87 30 01 00 00 	mov    0x130(%rdi),%rax
   1bc3b:	48 89 84 24 58 02 00 	mov    %rax,0x258(%rsp)
   1bc42:	00 
   1bc43:	48 8b 87 28 01 00 00 	mov    0x128(%rdi),%rax
   1bc4a:	48 89 84 24 60 02 00 	mov    %rax,0x260(%rsp)
   1bc51:	00 
   1bc52:	48 8b 47 50          	mov    0x50(%rdi),%rax
   1bc56:	48 89 84 24 d0 01 00 	mov    %rax,0x1d0(%rsp)
   1bc5d:	00 
   1bc5e:	48 8b 47 58          	mov    0x58(%rdi),%rax
   1bc62:	48 8b 8f e8 00 00 00 	mov    0xe8(%rdi),%rcx
   1bc69:	48 39 c8             	cmp    %rcx,%rax
   1bc6c:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
   1bc73:	00 
   1bc74:	48 0f 42 c8          	cmovb  %rax,%rcx
   1bc78:	48 89 8c 24 50 02 00 	mov    %rcx,0x250(%rsp)
   1bc7f:	00 
   1bc80:	48 8b 47 68          	mov    0x68(%rdi),%rax
   1bc84:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   1bc89:	48 8b 87 80 00 00 00 	mov    0x80(%rdi),%rax
   1bc90:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
   1bc95:	4c 8b af 88 00 00 00 	mov    0x88(%rdi),%r13
   1bc9c:	48 8b 87 98 00 00 00 	mov    0x98(%rdi),%rax
   1bca3:	48 89 84 24 e8 01 00 	mov    %rax,0x1e8(%rsp)
   1bcaa:	00 
   1bcab:	48 8b 87 a0 00 00 00 	mov    0xa0(%rdi),%rax
   1bcb2:	48 89 84 24 e0 01 00 	mov    %rax,0x1e0(%rsp)
   1bcb9:	00 
   1bcba:	48 c7 44 24 30 00 00 	movq   $0x0,0x30(%rsp)
   1bcc1:	00 00 
   1bcc3:	48 8d ac 24 d8 00 00 	lea    0xd8(%rsp),%rbp
   1bcca:	00 
   1bccb:	4c 8d 84 24 98 00 00 	lea    0x98(%rsp),%r8
   1bcd2:	00 
   1bcd3:	4c 8d 8c 24 a0 00 00 	lea    0xa0(%rsp),%r9
   1bcda:	00 
   1bcdb:	48 8d 05 be 25 04 00 	lea    0x425be(%rip),%rax        # 5e2a0 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.16159360244280900074+0x158>
   1bce2:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
   1bce9:	00 
   1bcea:	48 c7 44 24 48 00 00 	movq   $0x0,0x48(%rsp)
   1bcf1:	00 00 
   1bcf3:	48 c7 44 24 10 00 00 	movq   $0x0,0x10(%rsp)
   1bcfa:	00 00 
   1bcfc:	4c 89 f0             	mov    %r14,%rax
   1bcff:	4c 89 b4 24 88 00 00 	mov    %r14,0x88(%rsp)
   1bd06:	00 
   1bd07:	4c 89 ac 24 c8 00 00 	mov    %r13,0xc8(%rsp)
   1bd0e:	00 
   1bd0f:	eb 29                	jmp    1bd3a <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1da>
   1bd11:	48 8b 8c 24 68 02 00 	mov    0x268(%rsp),%rcx
   1bd18:	00 
   1bd19:	48 89 c8             	mov    %rcx,%rax
   1bd1c:	48 3b 8c 24 d8 01 00 	cmp    0x1d8(%rsp),%rcx
   1bd23:	00 
   1bd24:	4c 8d 84 24 98 00 00 	lea    0x98(%rsp),%r8
   1bd2b:	00 
   1bd2c:	4c 8d 8c 24 a0 00 00 	lea    0xa0(%rsp),%r9
   1bd33:	00 
   1bd34:	0f 84 8d 03 00 00    	je     1c0c7 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x567>
   1bd3a:	48 8b 50 10          	mov    0x10(%rax),%rdx
   1bd3e:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
   1bd45:	00 
   1bd46:	48 8b 48 18          	mov    0x18(%rax),%rcx
   1bd4a:	48 89 fe             	mov    %rdi,%rsi
   1bd4d:	48 89 ef             	mov    %rbp,%rdi
   1bd50:	48 89 f3             	mov    %rsi,%rbx
   1bd53:	e8 b8 0f 00 00       	call   1cd10 <parley::editing::geometry::source_runs::<()>>
   1bd58:	4c 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%r15
   1bd5f:	00 
   1bd60:	4d 85 ff             	test   %r15,%r15
   1bd63:	0f 84 4a 0b 00 00    	je     1c8b3 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xd53>
   1bd69:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
   1bd70:	00 
   1bd71:	48 83 c0 70          	add    $0x70,%rax
   1bd75:	48 89 84 24 68 02 00 	mov    %rax,0x268(%rsp)
   1bd7c:	00 
   1bd7d:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
   1bd84:	00 
   1bd85:	4d 8d 2c c7          	lea    (%r15,%rax,8),%r13
   1bd89:	48 89 df             	mov    %rbx,%rdi
   1bd8c:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
   1bd91:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   1bd98:	0f 1f 84 00 00 00 00 
   1bd9f:	00 
   1bda0:	4d 39 ef             	cmp    %r13,%r15
   1bda3:	0f 84 68 ff ff ff    	je     1bd11 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1b1>
   1bda9:	41 8b 07             	mov    (%r15),%eax
   1bdac:	49 83 c7 08          	add    $0x8,%r15
   1bdb0:	48 39 c8             	cmp    %rcx,%rax
   1bdb3:	74 eb                	je     1bda0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x240>
   1bdb5:	48 8b 8c 24 90 00 00 	mov    0x90(%rsp),%rcx
   1bdbc:	00 
   1bdbd:	48 03 41 10          	add    0x10(%rcx),%rax
   1bdc1:	40 b5 02             	mov    $0x2,%bpl
   1bdc4:	48 3b 41 18          	cmp    0x18(%rcx),%rax
   1bdc8:	48 8b 8c 24 60 02 00 	mov    0x260(%rsp),%rcx
   1bdcf:	00 
   1bdd0:	0f 83 72 0d 00 00    	jae    1cb48 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfe8>
   1bdd6:	48 3b 84 24 58 02 00 	cmp    0x258(%rsp),%rax
   1bddd:	00 
   1bdde:	0f 83 64 0d 00 00    	jae    1cb48 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfe8>
   1bde4:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
   1bde8:	80 7c c1 21 00       	cmpb   $0x0,0x21(%rcx,%rax,8)
   1bded:	0f 85 55 0d 00 00    	jne    1cb48 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfe8>
   1bdf3:	48 8d 04 c1          	lea    (%rcx,%rax,8),%rax
   1bdf7:	48 8b 48 10          	mov    0x10(%rax),%rcx
   1bdfb:	48 3b 8c 24 50 02 00 	cmp    0x250(%rsp),%rcx
   1be02:	00 
   1be03:	0f 83 3f 0d 00 00    	jae    1cb48 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfe8>
   1be09:	48 89 8c 24 48 02 00 	mov    %rcx,0x248(%rsp)
   1be10:	00 
   1be11:	89 cd                	mov    %ecx,%ebp
   1be13:	48 39 ac 24 80 00 00 	cmp    %rbp,0x80(%rsp)
   1be1a:	00 
   1be1b:	0f 86 25 0e 00 00    	jbe    1cc46 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10e6>
   1be21:	48 8d 0c ed 00 00 00 	lea    0x0(,%rbp,8),%rcx
   1be28:	00 
   1be29:	48 01 e9             	add    %rbp,%rcx
   1be2c:	48 c1 e1 04          	shl    $0x4,%rcx
   1be30:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
   1be35:	48 89 94 24 08 02 00 	mov    %rdx,0x208(%rsp)
   1be3c:	00 
   1be3d:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
   1be42:	48 89 94 24 10 02 00 	mov    %rdx,0x210(%rsp)
   1be49:	00 
   1be4a:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
   1be4f:	48 89 94 24 18 02 00 	mov    %rdx,0x218(%rsp)
   1be56:	00 
   1be57:	48 8b b4 24 c8 00 00 	mov    0xc8(%rsp),%rsi
   1be5e:	00 
   1be5f:	48 89 b4 24 20 02 00 	mov    %rsi,0x220(%rsp)
   1be66:	00 
   1be67:	48 8b 94 24 e8 01 00 	mov    0x1e8(%rsp),%rdx
   1be6e:	00 
   1be6f:	48 89 94 24 28 02 00 	mov    %rdx,0x228(%rsp)
   1be76:	00 
   1be77:	48 8b 94 24 e0 01 00 	mov    0x1e0(%rsp),%rdx
   1be7e:	00 
   1be7f:	48 89 94 24 30 02 00 	mov    %rdx,0x230(%rsp)
   1be86:	00 
   1be87:	48 8b 94 24 d0 01 00 	mov    0x1d0(%rsp),%rdx
   1be8e:	00 
   1be8f:	48 8b 4c 0a 50       	mov    0x50(%rdx,%rcx,1),%rcx
   1be94:	48 89 8c 24 38 02 00 	mov    %rcx,0x238(%rsp)
   1be9b:	00 
   1be9c:	8b 68 18             	mov    0x18(%rax),%ebp
   1be9f:	8b 58 1c             	mov    0x1c(%rax),%ebx
   1bea2:	39 dd                	cmp    %ebx,%ebp
   1bea4:	75 08                	jne    1beae <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x34e>
   1bea6:	0f 57 c0             	xorps  %xmm0,%xmm0
   1bea9:	45 31 f6             	xor    %r14d,%r14d
   1beac:	eb 67                	jmp    1bf15 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x3b5>
   1beae:	48 39 ee             	cmp    %rbp,%rsi
   1beb1:	0f 86 5c 0d 00 00    	jbe    1cc13 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10b3>
   1beb7:	48 8d 43 ff          	lea    -0x1(%rbx),%rax
   1bebb:	48 39 f0             	cmp    %rsi,%rax
   1bebe:	0f 83 60 0d 00 00    	jae    1cc24 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10c4>
   1bec4:	48 8d 04 6d 00 00 00 	lea    0x0(,%rbp,2),%rax
   1becb:	00 
   1becc:	48 01 e8             	add    %rbp,%rax
   1becf:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
   1bed4:	48 8d 3c c1          	lea    (%rcx,%rax,8),%rdi
   1bed8:	44 8b 34 c1          	mov    (%rcx,%rax,8),%r14d
   1bedc:	f3 0f 10 44 c1 10    	movss  0x10(%rcx,%rax,8),%xmm0
   1bee2:	f3 0f 11 84 24 d0 00 	movss  %xmm0,0xd0(%rsp)
   1bee9:	00 00 
   1beeb:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
   1bef0:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
   1bef5:	ff 15 75 45 04 00    	call   *0x44575(%rip)        # 60470 <_DYNAMIC+0x2a8>
   1befb:	89 c0                	mov    %eax,%eax
   1befd:	0f 57 c0             	xorps  %xmm0,%xmm0
   1bf00:	f3 48 0f 2a c0       	cvtsi2ss %rax,%xmm0
   1bf05:	f3 0f 10 8c 24 d0 00 	movss  0xd0(%rsp),%xmm1
   1bf0c:	00 00 
   1bf0e:	f3 0f 5e c8          	divss  %xmm0,%xmm1
   1bf12:	0f 28 c1             	movaps %xmm1,%xmm0
   1bf15:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   1bf1a:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
   1bf21:	00 
   1bf22:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
   1bf27:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
   1bf2e:	00 
   1bf2f:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
   1bf34:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
   1bf3b:	00 
   1bf3c:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
   1bf43:	00 
   1bf44:	48 89 84 24 f0 00 00 	mov    %rax,0xf0(%rsp)
   1bf4b:	00 
   1bf4c:	48 8b 84 24 e8 01 00 	mov    0x1e8(%rsp),%rax
   1bf53:	00 
   1bf54:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
   1bf5b:	00 
   1bf5c:	48 8b 84 24 e0 01 00 	mov    0x1e0(%rsp),%rax
   1bf63:	00 
   1bf64:	48 89 84 24 00 01 00 	mov    %rax,0x100(%rsp)
   1bf6b:	00 
   1bf6c:	89 ac 24 08 01 00 00 	mov    %ebp,0x108(%rsp)
   1bf73:	89 9c 24 0c 01 00 00 	mov    %ebx,0x10c(%rsp)
   1bf7a:	44 89 b4 24 10 01 00 	mov    %r14d,0x110(%rsp)
   1bf81:	00 
   1bf82:	89 ac 24 14 01 00 00 	mov    %ebp,0x114(%rsp)
   1bf89:	f3 0f 11 84 24 18 01 	movss  %xmm0,0x118(%rsp)
   1bf90:	00 00 
   1bf92:	4d 85 e4             	test   %r12,%r12
   1bf95:	0f 84 8d 00 00 00    	je     1c028 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x4c8>
   1bf9b:	31 db                	xor    %ebx,%ebx
   1bf9d:	0f 1f 00             	nopl   (%rax)
   1bfa0:	48 8d ac 24 d8 00 00 	lea    0xd8(%rsp),%rbp
   1bfa7:	00 
   1bfa8:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
   1bfaf:	00 
   1bfb0:	48 89 ee             	mov    %rbp,%rsi
   1bfb3:	ff 15 bf 44 04 00    	call   *0x444bf(%rip)        # 60478 <_DYNAMIC+0x2b0>
   1bfb9:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   1bfbe:	4c 8d 34 18          	lea    (%rax,%rbx,1),%r14
   1bfc2:	83 bc 24 60 01 00 00 	cmpl   $0x1,0x160(%rsp)
   1bfc9:	01 
   1bfca:	0f 85 a3 00 00 00    	jne    1c073 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x513>
   1bfd0:	8b b4 24 64 01 00 00 	mov    0x164(%rsp),%esi
   1bfd7:	8b 94 24 68 01 00 00 	mov    0x168(%rsp),%edx
   1bfde:	48 8d bc 24 08 02 00 	lea    0x208(%rsp),%rdi
   1bfe5:	00 
   1bfe6:	ff 15 24 44 04 00    	call   *0x44424(%rip)        # 60410 <_DYNAMIC+0x248>
   1bfec:	40 b5 02             	mov    $0x2,%bpl
   1bfef:	48 39 d0             	cmp    %rdx,%rax
   1bff2:	0f 87 50 0b 00 00    	ja     1cb48 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfe8>
   1bff8:	4c 39 e2             	cmp    %r12,%rdx
   1bffb:	0f 87 47 0b 00 00    	ja     1cb48 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfe8>
   1c001:	48 39 d0             	cmp    %rdx,%rax
   1c004:	73 10                	jae    1c016 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x4b6>
   1c006:	48 3b 44 24 30       	cmp    0x30(%rsp),%rax
   1c00b:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
   1c010:	0f 82 1e 01 00 00    	jb     1c134 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x5d4>
   1c016:	49 c1 ee 20          	shr    $0x20,%r14
   1c01a:	0f 85 28 0b 00 00    	jne    1cb48 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfe8>
   1c020:	48 ff c3             	inc    %rbx
   1c023:	e9 78 ff ff ff       	jmp    1bfa0 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x440>
   1c028:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   1c02d:	4c 8d 70 01          	lea    0x1(%rax),%r14
   1c031:	31 db                	xor    %ebx,%ebx
   1c033:	48 8d ac 24 d8 00 00 	lea    0xd8(%rsp),%rbp
   1c03a:	00 
   1c03b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   1c040:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
   1c047:	00 
   1c048:	48 89 ee             	mov    %rbp,%rsi
   1c04b:	ff 15 27 44 04 00    	call   *0x44427(%rip)        # 60478 <_DYNAMIC+0x2b0>
   1c051:	83 bc 24 60 01 00 00 	cmpl   $0x1,0x160(%rsp)
   1c058:	01 
   1c059:	75 0e                	jne    1c069 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x509>
   1c05b:	49 39 de             	cmp    %rbx,%r14
   1c05e:	0f 84 1c 0b 00 00    	je     1cb80 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1020>
   1c064:	48 ff cb             	dec    %rbx
   1c067:	eb d7                	jmp    1c040 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x4e0>
   1c069:	48 29 5c 24 10       	sub    %rbx,0x10(%rsp)
   1c06e:	48 f7 db             	neg    %rbx
   1c071:	eb 05                	jmp    1c078 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x518>
   1c073:	4c 89 74 24 10       	mov    %r14,0x10(%rsp)
   1c078:	48 8b 84 24 48 02 00 	mov    0x248(%rsp),%rax
   1c07f:	00 
   1c080:	48 8d 04 c0          	lea    (%rax,%rax,8),%rax
   1c084:	48 c1 e0 04          	shl    $0x4,%rax
   1c088:	48 03 84 24 d0 01 00 	add    0x1d0(%rsp),%rax
   1c08f:	00 
   1c090:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
   1c095:	48 39 cb             	cmp    %rcx,%rbx
   1c098:	48 0f 46 d9          	cmovbe %rcx,%rbx
   1c09c:	f6 80 8c 00 00 00 01 	testb  $0x1,0x8c(%rax)
   1c0a3:	48 0f 45 cb          	cmovne %rbx,%rcx
   1c0a7:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
   1c0ac:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
   1c0b1:	4c 8b b4 24 88 00 00 	mov    0x88(%rsp),%r14
   1c0b8:	00 
   1c0b9:	e9 ce fc ff ff       	jmp    1bd8c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x22c>
   1c0be:	48 c7 44 24 48 00 00 	movq   $0x0,0x48(%rsp)
   1c0c5:	00 00 
   1c0c7:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
   1c0cc:	4c 8d 3c 85 00 00 00 	lea    0x0(,%rax,4),%r15
   1c0d3:	00 
   1c0d4:	48 c1 e8 3e          	shr    $0x3e,%rax
   1c0d8:	0f 95 c0             	setne  %al
   1c0db:	48 b9 fc ff ff ff ff 	movabs $0x7ffffffffffffffc,%rcx
   1c0e2:	ff ff 7f 
   1c0e5:	49 39 cf             	cmp    %rcx,%r15
   1c0e8:	0f 97 c1             	seta   %cl
   1c0eb:	08 c1                	or     %al,%cl
   1c0ed:	74 14                	je     1c103 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x5a3>
   1c0ef:	45 31 e4             	xor    %r12d,%r12d
   1c0f2:	4c 89 e7             	mov    %r12,%rdi
   1c0f5:	4c 89 fe             	mov    %r15,%rsi
   1c0f8:	ff 15 32 43 04 00    	call   *0x44332(%rip)        # 60430 <_DYNAMIC+0x268>
   1c0fe:	e9 5c 0b 00 00       	jmp    1cc5f <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10ff>
   1c103:	4d 85 ff             	test   %r15,%r15
   1c106:	74 4e                	je     1c156 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x5f6>
   1c108:	48 89 fb             	mov    %rdi,%rbx
   1c10b:	ff 15 37 43 04 00    	call   *0x44337(%rip)        # 60448 <_DYNAMIC+0x280>
   1c111:	41 bc 04 00 00 00    	mov    $0x4,%r12d
   1c117:	be 04 00 00 00       	mov    $0x4,%esi
   1c11c:	4c 89 ff             	mov    %r15,%rdi
   1c11f:	ff 15 2b 43 04 00    	call   *0x4432b(%rip)        # 60450 <_DYNAMIC+0x288>
   1c125:	48 85 c0             	test   %rax,%rax
   1c128:	74 c8                	je     1c0f2 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x592>
   1c12a:	48 89 df             	mov    %rbx,%rdi
   1c12d:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
   1c132:	eb 29                	jmp    1c15d <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x5fd>
   1c134:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
   1c139:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
   1c13e:	48 8b b4 24 c0 00 00 	mov    0xc0(%rsp),%rsi
   1c145:	00 
   1c146:	f3 0f 10 44 24 50    	movss  0x50(%rsp),%xmm0
   1c14c:	e8 0f 10 00 00       	call   1d160 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>>
   1c151:	e9 78 07 00 00       	jmp    1c8ce <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xd6e>
   1c156:	b8 04 00 00 00       	mov    $0x4,%eax
   1c15b:	31 c9                	xor    %ecx,%ecx
   1c15d:	48 89 8c 24 b8 01 00 	mov    %rcx,0x1b8(%rsp)
   1c164:	00 
   1c165:	48 89 84 24 c0 01 00 	mov    %rax,0x1c0(%rsp)
   1c16c:	00 
   1c16d:	48 c7 84 24 c8 01 00 	movq   $0x0,0x1c8(%rsp)
   1c174:	00 00 00 00 00 
   1c179:	f3 0f 10 44 24 50    	movss  0x50(%rsp),%xmm0
   1c17f:	f3 0f 11 44 24 38    	movss  %xmm0,0x38(%rsp)
   1c185:	48 8b 8c 24 c0 00 00 	mov    0xc0(%rsp),%rcx
   1c18c:	00 
   1c18d:	48 8b 41 10          	mov    0x10(%rcx),%rax
   1c191:	48 89 84 24 b0 01 00 	mov    %rax,0x1b0(%rsp)
   1c198:	00 
   1c199:	0f 10 01             	movups (%rcx),%xmm0
   1c19c:	0f 11 84 24 a0 01 00 	movups %xmm0,0x1a0(%rsp)
   1c1a3:	00 
   1c1a4:	48 c7 84 24 90 01 00 	movq   $0x2,0x190(%rsp)
   1c1ab:	00 02 00 00 00 
   1c1b0:	48 c7 84 24 f0 01 00 	movq   $0x0,0x1f0(%rsp)
   1c1b7:	00 00 00 00 00 
   1c1bc:	c7 84 24 94 02 00 00 	movl   $0x0,0x294(%rsp)
   1c1c3:	00 00 00 00 
   1c1c7:	48 c7 84 24 00 02 00 	movq   $0x0,0x200(%rsp)
   1c1ce:	00 00 00 00 00 
   1c1d3:	48 c7 84 24 70 02 00 	movq   $0x0,0x270(%rsp)
   1c1da:	00 00 00 00 00 
   1c1df:	48 c7 84 24 78 02 00 	movq   $0x0,0x278(%rsp)
   1c1e6:	00 00 00 00 00 
   1c1eb:	48 83 bc 24 40 02 00 	cmpq   $0x0,0x240(%rsp)
   1c1f2:	00 00 
   1c1f4:	0f 84 6c 05 00 00    	je     1c766 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc06>
   1c1fa:	31 db                	xor    %ebx,%ebx
   1c1fc:	4c 8d 94 24 d8 00 00 	lea    0xd8(%rsp),%r10
   1c203:	00 
   1c204:	4c 8d 84 24 98 00 00 	lea    0x98(%rsp),%r8
   1c20b:	00 
   1c20c:	4c 8d 8c 24 a0 00 00 	lea    0xa0(%rsp),%r9
   1c213:	00 
   1c214:	48 8d 05 8d 1f 04 00 	lea    0x41f8d(%rip),%rax        # 5e1a8 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.16159360244280900074+0x60>
   1c21b:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
   1c220:	48 8d 05 e1 1f 04 00 	lea    0x41fe1(%rip),%rax        # 5e208 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.16159360244280900074+0xc0>
   1c227:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   1c22c:	eb 38                	jmp    1c266 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x706>
   1c22e:	4c 8b b4 24 88 00 00 	mov    0x88(%rsp),%r14
   1c235:	00 
   1c236:	4c 3b b4 24 d8 01 00 	cmp    0x1d8(%rsp),%r14
   1c23d:	00 
   1c23e:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
   1c243:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
   1c248:	4c 8d 94 24 d8 00 00 	lea    0xd8(%rsp),%r10
   1c24f:	00 
   1c250:	4c 8d 84 24 98 00 00 	lea    0x98(%rsp),%r8
   1c257:	00 
   1c258:	4c 8d 8c 24 a0 00 00 	lea    0xa0(%rsp),%r9
   1c25f:	00 
   1c260:	0f 84 00 05 00 00    	je     1c766 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc06>
   1c266:	48 89 7c 24 68       	mov    %rdi,0x68(%rsp)
   1c26b:	4c 89 74 24 70       	mov    %r14,0x70(%rsp)
   1c270:	89 5c 24 78          	mov    %ebx,0x78(%rsp)
   1c274:	49 8b 56 10          	mov    0x10(%r14),%rdx
   1c278:	49 8b 4e 18          	mov    0x18(%r14),%rcx
   1c27c:	48 89 fe             	mov    %rdi,%rsi
   1c27f:	4c 89 d7             	mov    %r10,%rdi
   1c282:	e8 89 0a 00 00       	call   1cd10 <parley::editing::geometry::source_runs::<()>>
   1c287:	4c 89 b4 24 88 00 00 	mov    %r14,0x88(%rsp)
   1c28e:	00 
   1c28f:	4c 8b a4 24 e0 00 00 	mov    0xe0(%rsp),%r12
   1c296:	00 
   1c297:	4d 85 e4             	test   %r12,%r12
   1c29a:	0f 84 9c 04 00 00    	je     1c73c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xbdc>
   1c2a0:	48 89 5c 24 28       	mov    %rbx,0x28(%rsp)
   1c2a5:	4c 8b 74 24 68       	mov    0x68(%rsp),%r14
   1c2aa:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
   1c2af:	48 8b 78 10          	mov    0x10(%rax),%rdi
   1c2b3:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
   1c2b8:	48 8b 70 18          	mov    0x18(%rax),%rsi
   1c2bc:	49 8b 96 30 01 00 00 	mov    0x130(%r14),%rdx
   1c2c3:	48 39 fe             	cmp    %rdi,%rsi
   1c2c6:	0f 82 c6 08 00 00    	jb     1cb92 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1032>
   1c2cc:	48 39 d6             	cmp    %rdx,%rsi
   1c2cf:	0f 87 bd 08 00 00    	ja     1cb92 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1032>
   1c2d5:	4c 8b ac 24 e8 00 00 	mov    0xe8(%rsp),%r13
   1c2dc:	00 
   1c2dd:	48 39 f7             	cmp    %rsi,%rdi
   1c2e0:	0f 85 e2 02 00 00    	jne    1c5c8 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xa68>
   1c2e6:	48 83 84 24 88 00 00 	addq   $0x70,0x88(%rsp)
   1c2ed:	00 70 
   1c2ef:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
   1c2f4:	ff c0                	inc    %eax
   1c2f6:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
   1c2fb:	49 c1 e5 03          	shl    $0x3,%r13
   1c2ff:	45 31 f6             	xor    %r14d,%r14d
   1c302:	eb 10                	jmp    1c314 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x7b4>
   1c304:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   1c30b:	00 00 00 00 00 
   1c310:	49 83 c6 08          	add    $0x8,%r14
   1c314:	4d 39 f5             	cmp    %r14,%r13
   1c317:	0f 84 11 ff ff ff    	je     1c22e <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x6ce>
   1c31d:	43 8b 04 34          	mov    (%r12,%r14,1),%eax
   1c321:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
   1c326:	48 39 c8             	cmp    %rcx,%rax
   1c329:	74 e5                	je     1c310 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x7b0>
   1c32b:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
   1c330:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
   1c334:	48 01 c1             	add    %rax,%rcx
   1c337:	48 3b 4a 18          	cmp    0x18(%rdx),%rcx
   1c33b:	0f 83 82 08 00 00    	jae    1cbc3 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1063>
   1c341:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
   1c346:	48 3b 8b 30 01 00 00 	cmp    0x130(%rbx),%rcx
   1c34d:	0f 83 70 08 00 00    	jae    1cbc3 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1063>
   1c353:	48 8b 93 28 01 00 00 	mov    0x128(%rbx),%rdx
   1c35a:	48 8d 34 89          	lea    (%rcx,%rcx,4),%rsi
   1c35e:	48 8d 0c f2          	lea    (%rdx,%rsi,8),%rcx
   1c362:	80 7c f2 21 01       	cmpb   $0x1,0x21(%rdx,%rsi,8)
   1c367:	0f 84 37 08 00 00    	je     1cba4 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1044>
   1c36d:	4c 8b 79 10          	mov    0x10(%rcx),%r15
   1c371:	48 8b 73 58          	mov    0x58(%rbx),%rsi
   1c375:	49 39 f7             	cmp    %rsi,%r15
   1c378:	0f 83 45 08 00 00    	jae    1cbc3 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1063>
   1c37e:	4c 3b bb e8 00 00 00 	cmp    0xe8(%rbx),%r15
   1c385:	0f 83 38 08 00 00    	jae    1cbc3 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1063>
   1c38b:	f3 43 0f 10 44 34 04 	movss  0x4(%r12,%r14,1),%xmm0
   1c392:	8b 54 24 78          	mov    0x78(%rsp),%edx
   1c396:	48 8b 7b 50          	mov    0x50(%rbx),%rdi
   1c39a:	4f 8d 04 ff          	lea    (%r15,%r15,8),%r8
   1c39e:	49 c1 e0 04          	shl    $0x4,%r8
   1c3a2:	4f 8d 0c bf          	lea    (%r15,%r15,4),%r9
   1c3a6:	49 c1 e1 04          	shl    $0x4,%r9
   1c3aa:	4c 03 8b e0 00 00 00 	add    0xe0(%rbx),%r9
   1c3b1:	4e 8d 14 07          	lea    (%rdi,%r8,1),%r10
   1c3b5:	48 89 9c 24 60 01 00 	mov    %rbx,0x160(%rsp)
   1c3bc:	00 
   1c3bd:	4c 89 94 24 68 01 00 	mov    %r10,0x168(%rsp)
   1c3c4:	00 
   1c3c5:	4c 89 8c 24 70 01 00 	mov    %r9,0x170(%rsp)
   1c3cc:	00 
   1c3cd:	48 89 8c 24 78 01 00 	mov    %rcx,0x178(%rsp)
   1c3d4:	00 
   1c3d5:	89 94 24 80 01 00 00 	mov    %edx,0x180(%rsp)
   1c3dc:	89 84 24 84 01 00 00 	mov    %eax,0x184(%rsp)
   1c3e3:	44 89 bc 24 88 01 00 	mov    %r15d,0x188(%rsp)
   1c3ea:	00 
   1c3eb:	f3 0f 11 44 24 64    	movss  %xmm0,0x64(%rsp)
   1c3f1:	48 c7 84 24 c8 01 00 	movq   $0x0,0x1c8(%rsp)
   1c3f8:	00 00 00 00 00 
   1c3fd:	42 f6 84 07 8c 00 00 	testb  $0x1,0x8c(%rdi,%r8,1)
   1c404:	00 01 
   1c406:	74 23                	je     1c42b <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x8cb>
   1c408:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
   1c40f:	00 
   1c410:	be 01 00 00 00       	mov    $0x1,%esi
   1c415:	48 8d 94 24 b8 01 00 	lea    0x1b8(%rsp),%rdx
   1c41c:	00 
   1c41d:	48 8d 4c 24 64       	lea    0x64(%rsp),%rcx
   1c422:	e8 c9 24 00 00       	call   1e8f0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<(), parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#1}>>
   1c427:	48 8b 73 58          	mov    0x58(%rbx),%rsi
   1c42b:	48 c7 84 24 80 02 00 	movq   $0x0,0x280(%rsp)
   1c432:	00 00 00 00 00 
   1c437:	c7 84 24 d4 00 00 00 	movl   $0x0,0xd4(%rsp)
   1c43e:	00 00 00 00 
   1c442:	c6 44 24 0f 00       	movb   $0x0,0xf(%rsp)
   1c447:	44 89 ff             	mov    %r15d,%edi
   1c44a:	48 39 fe             	cmp    %rdi,%rsi
   1c44d:	0f 86 80 07 00 00    	jbe    1cbd3 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1073>
   1c453:	0f 10 43 68          	movups 0x68(%rbx),%xmm0
   1c457:	0f 10 8b 80 00 00 00 	movups 0x80(%rbx),%xmm1
   1c45e:	f3 0f 6f 93 98 00 00 	movdqu 0x98(%rbx),%xmm2
   1c465:	00 
   1c466:	48 8b 43 50          	mov    0x50(%rbx),%rax
   1c46a:	48 8d 0c ff          	lea    (%rdi,%rdi,8),%rcx
   1c46e:	48 c1 e1 04          	shl    $0x4,%rcx
   1c472:	0f 11 84 24 08 02 00 	movups %xmm0,0x208(%rsp)
   1c479:	00 
   1c47a:	0f 11 8c 24 18 02 00 	movups %xmm1,0x218(%rsp)
   1c481:	00 
   1c482:	f3 0f 7f 94 24 28 02 	movdqu %xmm2,0x228(%rsp)
   1c489:	00 00 
   1c48b:	48 8b 44 08 50       	mov    0x50(%rax,%rcx,1),%rax
   1c490:	48 89 84 24 38 02 00 	mov    %rax,0x238(%rsp)
   1c497:	00 
   1c498:	48 c7 84 24 88 02 00 	movq   $0x0,0x288(%rsp)
   1c49f:	00 00 00 00 00 
   1c4a4:	48 8d 84 24 08 02 00 	lea    0x208(%rsp),%rax
   1c4ab:	00 
   1c4ac:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
   1c4b3:	00 
   1c4b4:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
   1c4b9:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
   1c4c0:	00 
   1c4c1:	48 8d 84 24 78 02 00 	lea    0x278(%rsp),%rax
   1c4c8:	00 
   1c4c9:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
   1c4d0:	00 
   1c4d1:	48 8d 84 24 70 02 00 	lea    0x270(%rsp),%rax
   1c4d8:	00 
   1c4d9:	48 89 84 24 f0 00 00 	mov    %rax,0xf0(%rsp)
   1c4e0:	00 
   1c4e1:	48 8d 84 24 b8 01 00 	lea    0x1b8(%rsp),%rax
   1c4e8:	00 
   1c4e9:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
   1c4f0:	00 
   1c4f1:	48 8d 84 24 88 02 00 	lea    0x288(%rsp),%rax
   1c4f8:	00 
   1c4f9:	48 89 84 24 00 01 00 	mov    %rax,0x100(%rsp)
   1c500:	00 
   1c501:	48 8d 44 24 64       	lea    0x64(%rsp),%rax
   1c506:	48 89 84 24 08 01 00 	mov    %rax,0x108(%rsp)
   1c50d:	00 
   1c50e:	48 8d 44 24 0f       	lea    0xf(%rsp),%rax
   1c513:	48 89 84 24 10 01 00 	mov    %rax,0x110(%rsp)
   1c51a:	00 
   1c51b:	48 8d 84 24 90 01 00 	lea    0x190(%rsp),%rax
   1c522:	00 
   1c523:	48 89 84 24 18 01 00 	mov    %rax,0x118(%rsp)
   1c52a:	00 
   1c52b:	48 8d 84 24 f0 01 00 	lea    0x1f0(%rsp),%rax
   1c532:	00 
   1c533:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
   1c53a:	00 
   1c53b:	48 8d 44 24 38       	lea    0x38(%rsp),%rax
   1c540:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
   1c547:	00 
   1c548:	48 8d 44 24 58       	lea    0x58(%rsp),%rax
   1c54d:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
   1c554:	00 
   1c555:	48 8d 84 24 80 02 00 	lea    0x280(%rsp),%rax
   1c55c:	00 
   1c55d:	48 89 84 24 38 01 00 	mov    %rax,0x138(%rsp)
   1c564:	00 
   1c565:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
   1c56a:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
   1c571:	00 
   1c572:	48 8d 84 24 d4 00 00 	lea    0xd4(%rsp),%rax
   1c579:	00 
   1c57a:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
   1c581:	00 
   1c582:	48 8d 84 24 94 02 00 	lea    0x294(%rsp),%rax
   1c589:	00 
   1c58a:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
   1c591:	00 
   1c592:	48 8d 84 24 00 02 00 	lea    0x200(%rsp),%rax
   1c599:	00 
   1c59a:	48 89 84 24 58 01 00 	mov    %rax,0x158(%rsp)
   1c5a1:	00 
   1c5a2:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
   1c5a9:	00 
   1c5aa:	31 f6                	xor    %esi,%esi
   1c5ac:	48 8d 94 24 d8 00 00 	lea    0xd8(%rsp),%rdx
   1c5b3:	00 
   1c5b4:	e8 27 1d 00 00       	call   1e2e0 <<parley::layout::run::Run<()>>::try_for_each_cluster::<core::result::Result<core::ops::control_flow::ControlFlow<()>, parley::editing::geometry::CursorGeometryRestart>, parley::editing::geometry::visit_source_pairs<false, (), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>::{closure#2}>>
   1c5b9:	89 c5                	mov    %eax,%ebp
   1c5bb:	3c ff                	cmp    $0xff,%al
   1c5bd:	0f 84 4d fd ff ff    	je     1c310 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x7b0>
   1c5c3:	e9 6a 01 00 00       	jmp    1c732 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xbd2>
   1c5c8:	48 8b 84 24 d8 00 00 	mov    0xd8(%rsp),%rax
   1c5cf:	00 
   1c5d0:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
   1c5d5:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   1c5da:	f3 0f 10 48 28       	movss  0x28(%rax),%xmm1
   1c5df:	8b 44 24 78          	mov    0x78(%rsp),%eax
   1c5e3:	89 84 24 90 00 00 00 	mov    %eax,0x90(%rsp)
   1c5ea:	48 c1 e7 03          	shl    $0x3,%rdi
   1c5ee:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
   1c5f2:	49 8b 9e 28 01 00 00 	mov    0x128(%r14),%rbx
   1c5f9:	48 01 c3             	add    %rax,%rbx
   1c5fc:	48 c1 e6 03          	shl    $0x3,%rsi
   1c600:	4c 8d 3c b6          	lea    (%rsi,%rsi,4),%r15
   1c604:	49 29 c7             	sub    %rax,%r15
   1c607:	31 ed                	xor    %ebp,%ebp
   1c609:	eb 20                	jmp    1c62b <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xacb>
   1c60b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   1c610:	f3 0f 10 4c 24 10    	movss  0x10(%rsp),%xmm1
   1c616:	48 83 c3 28          	add    $0x28,%rbx
   1c61a:	f3 0f 58 c8          	addss  %xmm0,%xmm1
   1c61e:	48 ff c5             	inc    %rbp
   1c621:	49 83 c7 d8          	add    $0xffffffffffffffd8,%r15
   1c625:	0f 84 bb fc ff ff    	je     1c2e6 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x786>
   1c62b:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
   1c62f:	80 7b 21 01          	cmpb   $0x1,0x21(%rbx)
   1c633:	75 2b                	jne    1c660 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xb00>
   1c635:	49 8b 76 40          	mov    0x40(%r14),%rsi
   1c639:	48 39 f7             	cmp    %rsi,%rdi
   1c63c:	0f 83 ac 05 00 00    	jae    1cbee <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x108e>
   1c642:	49 8b 46 38          	mov    0x38(%r14),%rax
   1c646:	48 6b cf 38          	imul   $0x38,%rdi,%rcx
   1c64a:	f3 0f 10 44 08 24    	movss  0x24(%rax,%rcx,1),%xmm0
   1c650:	eb c4                	jmp    1c616 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xab6>
   1c652:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   1c659:	1f 84 00 00 00 00 00 
   1c660:	49 8b 76 58          	mov    0x58(%r14),%rsi
   1c664:	48 39 f7             	cmp    %rsi,%rdi
   1c667:	0f 83 99 05 00 00    	jae    1cc06 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10a6>
   1c66d:	49 8b b6 e8 00 00 00 	mov    0xe8(%r14),%rsi
   1c674:	48 39 f7             	cmp    %rsi,%rdi
   1c677:	0f 83 68 05 00 00    	jae    1cbe5 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1085>
   1c67d:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   1c681:	48 c1 e0 04          	shl    $0x4,%rax
   1c685:	49 03 46 50          	add    0x50(%r14),%rax
   1c689:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
   1c68d:	48 c1 e1 04          	shl    $0x4,%rcx
   1c691:	49 03 8e e0 00 00 00 	add    0xe0(%r14),%rcx
   1c698:	4c 89 b4 24 d8 00 00 	mov    %r14,0xd8(%rsp)
   1c69f:	00 
   1c6a0:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
   1c6a7:	00 
   1c6a8:	48 89 8c 24 e8 00 00 	mov    %rcx,0xe8(%rsp)
   1c6af:	00 
   1c6b0:	48 89 9c 24 f0 00 00 	mov    %rbx,0xf0(%rsp)
   1c6b7:	00 
   1c6b8:	8b 84 24 90 00 00 00 	mov    0x90(%rsp),%eax
   1c6bf:	89 84 24 f8 00 00 00 	mov    %eax,0xf8(%rsp)
   1c6c6:	89 ac 24 fc 00 00 00 	mov    %ebp,0xfc(%rsp)
   1c6cd:	89 bc 24 00 01 00 00 	mov    %edi,0x100(%rsp)
   1c6d4:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
   1c6d9:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
   1c6de:	48 8b 79 10          	mov    0x10(%rcx),%rdi
   1c6e2:	48 01 ef             	add    %rbp,%rdi
   1c6e5:	48 8b b0 30 01 00 00 	mov    0x130(%rax),%rsi
   1c6ec:	48 39 f7             	cmp    %rsi,%rdi
   1c6ef:	0f 83 e7 04 00 00    	jae    1cbdc <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x107c>
   1c6f5:	48 8b 80 28 01 00 00 	mov    0x128(%rax),%rax
   1c6fc:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
   1c700:	48 8b 7c c8 10       	mov    0x10(%rax,%rcx,8),%rdi
   1c705:	48 2b 7c 24 50       	sub    0x50(%rsp),%rdi
   1c70a:	4c 39 ef             	cmp    %r13,%rdi
   1c70d:	0f 83 e4 04 00 00    	jae    1cbf7 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1097>
   1c713:	f3 0f 11 4c 24 10    	movss  %xmm1,0x10(%rsp)
   1c719:	f3 41 0f 11 4c fc 04 	movss  %xmm1,0x4(%r12,%rdi,8)
   1c720:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
   1c727:	00 
   1c728:	e8 c3 2c 00 00       	call   1f3f0 <<parley::layout::run::Run<()>>::advance>
   1c72d:	e9 de fe ff ff       	jmp    1c610 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xab0>
   1c732:	40 80 fd 02          	cmp    $0x2,%bpl
   1c736:	0f 85 e8 03 00 00    	jne    1cb24 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfc4>
   1c73c:	48 8d 3d 80 a0 fe ff 	lea    -0x15f80(%rip),%rdi        # 67c3 <anon.5cab36dad6fad55fc602ca21d50a03ec.33.llvm.18336280871641450522+0x27c>
   1c743:	48 8d 0d 06 1b 04 00 	lea    0x41b06(%rip),%rcx        # 5e250 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.16159360244280900074+0x108>
   1c74a:	4c 8d 05 0f 1a 04 00 	lea    0x41a0f(%rip),%r8        # 5e160 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.16159360244280900074+0x18>
   1c751:	48 8d 54 24 3f       	lea    0x3f(%rsp),%rdx
   1c756:	be 35 00 00 00       	mov    $0x35,%esi
   1c75b:	ff 15 1f 3d 04 00    	call   *0x43d1f(%rip)        # 60480 <_DYNAMIC+0x2b8>
   1c761:	e9 f9 04 00 00       	jmp    1cc5f <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10ff>
   1c766:	4c 8d a4 24 98 02 00 	lea    0x298(%rsp),%r12
   1c76d:	00 
   1c76e:	45 31 ed             	xor    %r13d,%r13d
   1c771:	4c 8d b4 24 d8 00 00 	lea    0xd8(%rsp),%r14
   1c778:	00 
   1c779:	eb 03                	jmp    1c77e <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc1e>
   1c77b:	4c 89 38             	mov    %r15,(%rax)
   1c77e:	48 8b 8c 24 90 01 00 	mov    0x190(%rsp),%rcx
   1c785:	00 
   1c786:	48 83 f9 02          	cmp    $0x2,%rcx
   1c78a:	75 4d                	jne    1c7d9 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc79>
   1c78c:	80 bc 24 b0 01 00 00 	cmpb   $0x0,0x1b0(%rsp)
   1c793:	00 
   1c794:	75 12                	jne    1c7a8 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc48>
   1c796:	48 8b 84 24 a0 01 00 	mov    0x1a0(%rsp),%rax
   1c79d:	00 
   1c79e:	48 3b 84 24 a8 01 00 	cmp    0x1a8(%rsp),%rax
   1c7a5:	00 
   1c7a6:	76 04                	jbe    1c7ac <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc4c>
   1c7a8:	31 c9                	xor    %ecx,%ecx
   1c7aa:	eb 1d                	jmp    1c7c9 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc69>
   1c7ac:	73 0e                	jae    1c7bc <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc5c>
   1c7ae:	48 8d 48 01          	lea    0x1(%rax),%rcx
   1c7b2:	48 89 8c 24 a0 01 00 	mov    %rcx,0x1a0(%rsp)
   1c7b9:	00 
   1c7ba:	eb 08                	jmp    1c7c4 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc64>
   1c7bc:	c6 84 24 b0 01 00 00 	movb   $0x1,0x1b0(%rsp)
   1c7c3:	01 
   1c7c4:	b9 01 00 00 00       	mov    $0x1,%ecx
   1c7c9:	48 89 8c 24 90 01 00 	mov    %rcx,0x190(%rsp)
   1c7d0:	00 
   1c7d1:	48 89 84 24 98 01 00 	mov    %rax,0x198(%rsp)
   1c7d8:	00 
   1c7d9:	83 f9 01             	cmp    $0x1,%ecx
   1c7dc:	0f 85 40 03 00 00    	jne    1cb22 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfc2>
   1c7e2:	4c 8b bc 24 98 01 00 	mov    0x198(%rsp),%r15
   1c7e9:	00 
   1c7ea:	83 bc 24 f0 01 00 00 	cmpl   $0x1,0x1f0(%rsp)
   1c7f1:	01 
   1c7f2:	75 0e                	jne    1c802 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xca2>
   1c7f4:	4c 3b bc 24 f8 01 00 	cmp    0x1f8(%rsp),%r15
   1c7fb:	00 
   1c7fc:	0f 82 e4 00 00 00    	jb     1c8e6 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xd86>
   1c802:	48 c7 84 24 90 01 00 	movq   $0x2,0x190(%rsp)
   1c809:	00 02 00 00 00 
   1c80e:	48 c7 84 24 f0 01 00 	movq   $0x1,0x1f0(%rsp)
   1c815:	00 01 00 00 00 
   1c81a:	4c 89 bc 24 f8 01 00 	mov    %r15,0x1f8(%rsp)
   1c821:	00 
   1c822:	4c 89 e1             	mov    %r12,%rcx
   1c825:	4c 39 bc 24 00 02 00 	cmp    %r15,0x200(%rsp)
   1c82c:	00 
   1c82d:	74 02                	je     1c831 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xcd1>
   1c82f:	31 c9                	xor    %ecx,%ecx
   1c831:	80 bc 24 94 02 00 00 	cmpb   $0x0,0x294(%rsp)
   1c838:	00 
   1c839:	49 0f 44 cd          	cmove  %r13,%rcx
   1c83d:	66 0f 6e 44 24 38    	movd   0x38(%rsp),%xmm0
   1c843:	4c 89 f7             	mov    %r14,%rdi
   1c846:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
   1c84b:	4c 89 fa             	mov    %r15,%rdx
   1c84e:	45 31 c0             	xor    %r8d,%r8d
   1c851:	e8 0a 16 00 00       	call   1de60 <parley::editing::geometry::pair_from_entries::<()>>
   1c856:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
   1c85b:	4c 33 38             	xor    (%rax),%r15
   1c85e:	48 83 bc 24 d8 00 00 	cmpq   $0x1,0xd8(%rsp)
   1c865:	00 01 
   1c867:	0f 85 0e ff ff ff    	jne    1c77b <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc1b>
   1c86d:	f3 0f 6f 84 24 e0 00 	movdqu 0xe0(%rsp),%xmm0
   1c874:	00 00 
   1c876:	f3 0f 6f 8c 24 f0 00 	movdqu 0xf0(%rsp),%xmm1
   1c87d:	00 00 
   1c87f:	f3 0f 6f 94 24 00 01 	movdqu 0x100(%rsp),%xmm2
   1c886:	00 00 
   1c888:	66 0f ef d0          	pxor   %xmm0,%xmm2
   1c88c:	f3 0f 6f 84 24 10 01 	movdqu 0x110(%rsp),%xmm0
   1c893:	00 00 
   1c895:	66 0f ef c1          	pxor   %xmm1,%xmm0
   1c899:	66 0f ef c2          	pxor   %xmm2,%xmm0
   1c89d:	66 0f 70 c8 ee       	pshufd $0xee,%xmm0,%xmm1
   1c8a2:	66 0f ef c8          	pxor   %xmm0,%xmm1
   1c8a6:	66 48 0f 7e c9       	movq   %xmm1,%rcx
   1c8ab:	49 31 cf             	xor    %rcx,%r15
   1c8ae:	e9 c8 fe ff ff       	jmp    1c77b <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xc1b>
   1c8b3:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
   1c8b8:	48 89 df             	mov    %rbx,%rdi
   1c8bb:	48 8b b4 24 c0 00 00 	mov    0xc0(%rsp),%rsi
   1c8c2:	00 
   1c8c3:	f3 0f 10 44 24 50    	movss  0x50(%rsp),%xmm0
   1c8c9:	e8 92 08 00 00       	call   1d160 <parley::editing::geometry::visit_indexed::<(), (), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>>
   1c8ce:	89 c5                	mov    %eax,%ebp
   1c8d0:	48 8b b4 24 a0 00 00 	mov    0xa0(%rsp),%rsi
   1c8d7:	00 
   1c8d8:	48 85 f6             	test   %rsi,%rsi
   1c8db:	0f 85 74 02 00 00    	jne    1cb55 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xff5>
   1c8e1:	e9 86 02 00 00       	jmp    1cb6c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x100c>
   1c8e6:	4c 8b b4 24 a0 01 00 	mov    0x1a0(%rsp),%r14
   1c8ed:	00 
   1c8ee:	4c 8b a4 24 a8 01 00 	mov    0x1a8(%rsp),%r12
   1c8f5:	00 
   1c8f6:	0f b6 84 24 b0 01 00 	movzbl 0x1b0(%rsp),%eax
   1c8fd:	00 
   1c8fe:	88 44 24 30          	mov    %al,0x30(%rsp)
   1c902:	f3 0f 10 44 24 38    	movss  0x38(%rsp),%xmm0
   1c908:	f3 0f 11 44 24 10    	movss  %xmm0,0x10(%rsp)
   1c90e:	4c 8b 6c 24 58       	mov    0x58(%rsp),%r13
   1c913:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
   1c918:	4c 89 fe             	mov    %r15,%rsi
   1c91b:	ba 01 00 00 00       	mov    $0x1,%edx
   1c920:	e8 db e3 ff ff       	call   1ad00 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
   1c925:	48 8d ac 24 f8 00 00 	lea    0xf8(%rsp),%rbp
   1c92c:	00 
   1c92d:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
   1c932:	80 e2 01             	and    $0x1,%dl
   1c935:	88 54 24 70          	mov    %dl,0x70(%rsp)
   1c939:	4c 39 f8             	cmp    %r15,%rax
   1c93c:	0f 85 b9 00 00 00    	jne    1c9fb <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xe9b>
   1c942:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
   1c949:	00 
   1c94a:	48 8d 74 24 68       	lea    0x68(%rsp),%rsi
   1c94f:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
   1c954:	48 89 da             	mov    %rbx,%rdx
   1c957:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
   1c95d:	e8 5e e4 ff ff       	call   1adc0 <<parley::editing::cursor::Cursor>::geometry::<()>>
   1c962:	48 89 df             	mov    %rbx,%rdi
   1c965:	4c 89 fe             	mov    %r15,%rsi
   1c968:	31 d2                	xor    %edx,%edx
   1c96a:	e8 91 e3 ff ff       	call   1ad00 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
   1c96f:	48 89 84 24 60 01 00 	mov    %rax,0x160(%rsp)
   1c976:	00 
   1c977:	80 e2 01             	and    $0x1,%dl
   1c97a:	88 94 24 68 01 00 00 	mov    %dl,0x168(%rsp)
   1c981:	48 8d bc 24 08 02 00 	lea    0x208(%rsp),%rdi
   1c988:	00 
   1c989:	48 8d b4 24 60 01 00 	lea    0x160(%rsp),%rsi
   1c990:	00 
   1c991:	48 89 da             	mov    %rbx,%rdx
   1c994:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
   1c99a:	e8 21 e4 ff ff       	call   1adc0 <<parley::editing::cursor::Cursor>::geometry::<()>>
   1c99f:	0f 10 84 24 08 02 00 	movups 0x208(%rsp),%xmm0
   1c9a6:	00 
   1c9a7:	0f 10 8c 24 18 02 00 	movups 0x218(%rsp),%xmm1
   1c9ae:	00 
   1c9af:	0f 11 4d 10          	movups %xmm1,0x10(%rbp)
   1c9b3:	0f 11 45 00          	movups %xmm0,0x0(%rbp)
   1c9b7:	f3 0f 6f 84 24 d8 00 	movdqu 0xd8(%rsp),%xmm0
   1c9be:	00 00 
   1c9c0:	f3 0f 6f 8c 24 e8 00 	movdqu 0xe8(%rsp),%xmm1
   1c9c7:	00 00 
   1c9c9:	f3 0f 6f 94 24 f8 00 	movdqu 0xf8(%rsp),%xmm2
   1c9d0:	00 00 
   1c9d2:	66 0f ef d0          	pxor   %xmm0,%xmm2
   1c9d6:	f3 0f 6f 84 24 08 01 	movdqu 0x108(%rsp),%xmm0
   1c9dd:	00 00 
   1c9df:	66 0f ef c1          	pxor   %xmm1,%xmm0
   1c9e3:	66 0f ef c2          	pxor   %xmm2,%xmm0
   1c9e7:	66 0f 70 c8 ee       	pshufd $0xee,%xmm0,%xmm1
   1c9ec:	66 0f ef c8          	pxor   %xmm0,%xmm1
   1c9f0:	66 48 0f 7e c8       	movq   %xmm1,%rax
   1c9f5:	49 33 45 00          	xor    0x0(%r13),%rax
   1c9f9:	eb 04                	jmp    1c9ff <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xe9f>
   1c9fb:	49 8b 45 00          	mov    0x0(%r13),%rax
   1c9ff:	4c 31 f8             	xor    %r15,%rax
   1ca02:	49 89 45 00          	mov    %rax,0x0(%r13)
   1ca06:	4d 39 e6             	cmp    %r12,%r14
   1ca09:	0f 97 c0             	seta   %al
   1ca0c:	0f b6 4c 24 30       	movzbl 0x30(%rsp),%ecx
   1ca11:	08 c1                	or     %al,%cl
   1ca13:	f6 c1 01             	test   $0x1,%cl
   1ca16:	0f 85 06 01 00 00    	jne    1cb22 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfc2>
   1ca1c:	4c 89 f3             	mov    %r14,%rbx
   1ca1f:	4c 8b 7c 24 20       	mov    0x20(%rsp),%r15
   1ca24:	4d 39 e6             	cmp    %r12,%r14
   1ca27:	48 83 d3 00          	adc    $0x0,%rbx
   1ca2b:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
   1ca30:	4c 89 f6             	mov    %r14,%rsi
   1ca33:	ba 01 00 00 00       	mov    $0x1,%edx
   1ca38:	e8 c3 e2 ff ff       	call   1ad00 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
   1ca3d:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
   1ca42:	80 e2 01             	and    $0x1,%dl
   1ca45:	88 54 24 70          	mov    %dl,0x70(%rsp)
   1ca49:	4c 39 f0             	cmp    %r14,%rax
   1ca4c:	0f 85 b4 00 00 00    	jne    1cb06 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfa6>
   1ca52:	48 8d bc 24 d8 00 00 	lea    0xd8(%rsp),%rdi
   1ca59:	00 
   1ca5a:	48 8d 74 24 68       	lea    0x68(%rsp),%rsi
   1ca5f:	4c 89 fa             	mov    %r15,%rdx
   1ca62:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
   1ca68:	e8 53 e3 ff ff       	call   1adc0 <<parley::editing::cursor::Cursor>::geometry::<()>>
   1ca6d:	4c 89 ff             	mov    %r15,%rdi
   1ca70:	4c 89 f6             	mov    %r14,%rsi
   1ca73:	31 d2                	xor    %edx,%edx
   1ca75:	e8 86 e2 ff ff       	call   1ad00 <<parley::editing::cursor::Cursor>::from_byte_index::<()>>
   1ca7a:	48 89 84 24 60 01 00 	mov    %rax,0x160(%rsp)
   1ca81:	00 
   1ca82:	80 e2 01             	and    $0x1,%dl
   1ca85:	88 94 24 68 01 00 00 	mov    %dl,0x168(%rsp)
   1ca8c:	48 8d bc 24 08 02 00 	lea    0x208(%rsp),%rdi
   1ca93:	00 
   1ca94:	48 8d b4 24 60 01 00 	lea    0x160(%rsp),%rsi
   1ca9b:	00 
   1ca9c:	4c 89 fa             	mov    %r15,%rdx
   1ca9f:	f3 0f 10 44 24 10    	movss  0x10(%rsp),%xmm0
   1caa5:	e8 16 e3 ff ff       	call   1adc0 <<parley::editing::cursor::Cursor>::geometry::<()>>
   1caaa:	0f 10 84 24 08 02 00 	movups 0x208(%rsp),%xmm0
   1cab1:	00 
   1cab2:	0f 10 8c 24 18 02 00 	movups 0x218(%rsp),%xmm1
   1cab9:	00 
   1caba:	0f 11 4d 10          	movups %xmm1,0x10(%rbp)
   1cabe:	0f 11 45 00          	movups %xmm0,0x0(%rbp)
   1cac2:	f3 0f 6f 84 24 d8 00 	movdqu 0xd8(%rsp),%xmm0
   1cac9:	00 00 
   1cacb:	f3 0f 6f 8c 24 e8 00 	movdqu 0xe8(%rsp),%xmm1
   1cad2:	00 00 
   1cad4:	f3 0f 6f 94 24 f8 00 	movdqu 0xf8(%rsp),%xmm2
   1cadb:	00 00 
   1cadd:	66 0f ef d0          	pxor   %xmm0,%xmm2
   1cae1:	f3 0f 6f 84 24 08 01 	movdqu 0x108(%rsp),%xmm0
   1cae8:	00 00 
   1caea:	66 0f ef c1          	pxor   %xmm1,%xmm0
   1caee:	66 0f ef c2          	pxor   %xmm2,%xmm0
   1caf2:	66 0f 70 c8 ee       	pshufd $0xee,%xmm0,%xmm1
   1caf7:	66 0f ef c8          	pxor   %xmm0,%xmm1
   1cafb:	66 48 0f 7e c8       	movq   %xmm1,%rax
   1cb00:	49 33 45 00          	xor    0x0(%r13),%rax
   1cb04:	eb 04                	jmp    1cb0a <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfaa>
   1cb06:	49 8b 45 00          	mov    0x0(%r13),%rax
   1cb0a:	4c 31 f0             	xor    %r14,%rax
   1cb0d:	49 89 45 00          	mov    %rax,0x0(%r13)
   1cb11:	4d 39 e6             	cmp    %r12,%r14
   1cb14:	73 0c                	jae    1cb22 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfc2>
   1cb16:	49 89 de             	mov    %rbx,%r14
   1cb19:	4c 39 e3             	cmp    %r12,%rbx
   1cb1c:	0f 86 02 ff ff ff    	jbe    1ca24 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xec4>
   1cb22:	31 ed                	xor    %ebp,%ebp
   1cb24:	48 8b b4 24 b8 01 00 	mov    0x1b8(%rsp),%rsi
   1cb2b:	00 
   1cb2c:	48 85 f6             	test   %rsi,%rsi
   1cb2f:	74 17                	je     1cb48 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xfe8>
   1cb31:	48 8b bc 24 c0 01 00 	mov    0x1c0(%rsp),%rdi
   1cb38:	00 
   1cb39:	48 c1 e6 02          	shl    $0x2,%rsi
   1cb3d:	ba 04 00 00 00       	mov    $0x4,%edx
   1cb42:	ff 15 18 39 04 00    	call   *0x43918(%rip)        # 60460 <_DYNAMIC+0x298>
   1cb48:	48 8b b4 24 a0 00 00 	mov    0xa0(%rsp),%rsi
   1cb4f:	00 
   1cb50:	48 85 f6             	test   %rsi,%rsi
   1cb53:	74 17                	je     1cb6c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x100c>
   1cb55:	48 8b bc 24 a8 00 00 	mov    0xa8(%rsp),%rdi
   1cb5c:	00 
   1cb5d:	48 c1 e6 03          	shl    $0x3,%rsi
   1cb61:	ba 04 00 00 00       	mov    $0x4,%edx
   1cb66:	ff 15 f4 38 04 00    	call   *0x438f4(%rip)        # 60460 <_DYNAMIC+0x298>
   1cb6c:	89 e8                	mov    %ebp,%eax
   1cb6e:	48 81 c4 a8 02 00 00 	add    $0x2a8,%rsp
   1cb75:	5b                   	pop    %rbx
   1cb76:	41 5c                	pop    %r12
   1cb78:	41 5d                	pop    %r13
   1cb7a:	41 5e                	pop    %r14
   1cb7c:	41 5f                	pop    %r15
   1cb7e:	5d                   	pop    %rbp
   1cb7f:	c3                   	ret
   1cb80:	40 b5 02             	mov    $0x2,%bpl
   1cb83:	48 8b b4 24 a0 00 00 	mov    0xa0(%rsp),%rsi
   1cb8a:	00 
   1cb8b:	48 85 f6             	test   %rsi,%rsi
   1cb8e:	75 c5                	jne    1cb55 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0xff5>
   1cb90:	eb da                	jmp    1cb6c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x100c>
   1cb92:	48 8d 0d 37 15 04 00 	lea    0x41537(%rip),%rcx        # 5e0d0 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.10.llvm.16159360244280900074>
   1cb99:	ff 15 61 38 04 00    	call   *0x43861(%rip)        # 60400 <_DYNAMIC+0x238>
   1cb9f:	e9 bb 00 00 00       	jmp    1cc5f <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10ff>
   1cba4:	48 8b 41 10          	mov    0x10(%rcx),%rax
   1cba8:	48 3b 43 40          	cmp    0x40(%rbx),%rax
   1cbac:	48 8d 05 0d 16 04 00 	lea    0x4160d(%rip),%rax        # 5e1c0 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.16159360244280900074+0x78>
   1cbb3:	48 8d 0d ee 15 04 00 	lea    0x415ee(%rip),%rcx        # 5e1a8 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.16159360244280900074+0x60>
   1cbba:	48 0f 42 c8          	cmovb  %rax,%rcx
   1cbbe:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
   1cbc3:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
   1cbc8:	ff 15 5a 38 04 00    	call   *0x4385a(%rip)        # 60428 <_DYNAMIC+0x260>
   1cbce:	e9 8c 00 00 00       	jmp    1cc5f <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10ff>
   1cbd3:	48 8d 05 c6 16 04 00 	lea    0x416c6(%rip),%rax        # 5e2a0 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.16159360244280900074+0x158>
   1cbda:	eb 25                	jmp    1cc01 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10a1>
   1cbdc:	48 8d 05 f5 15 04 00 	lea    0x415f5(%rip),%rax        # 5e1d8 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.16159360244280900074+0x90>
   1cbe3:	eb 1c                	jmp    1cc01 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10a1>
   1cbe5:	48 8d 05 34 16 04 00 	lea    0x41634(%rip),%rax        # 5e220 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.16159360244280900074+0xd8>
   1cbec:	eb 13                	jmp    1cc01 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10a1>
   1cbee:	48 8d 05 43 16 04 00 	lea    0x41643(%rip),%rax        # 5e238 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.16159360244280900074+0xf0>
   1cbf5:	eb 0a                	jmp    1cc01 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10a1>
   1cbf7:	4c 89 ee             	mov    %r13,%rsi
   1cbfa:	48 8d 05 ef 15 04 00 	lea    0x415ef(%rip),%rax        # 5e1f0 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.16159360244280900074+0xa8>
   1cc01:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   1cc06:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
   1cc0b:	ff 15 e7 37 04 00    	call   *0x437e7(%rip)        # 603f8 <_DYNAMIC+0x230>
   1cc11:	eb 4c                	jmp    1cc5f <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10ff>
   1cc13:	48 89 b4 24 80 00 00 	mov    %rsi,0x80(%rsp)
   1cc1a:	00 
   1cc1b:	48 8d 05 4e 16 04 00 	lea    0x4164e(%rip),%rax        # 5e270 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.16159360244280900074+0x128>
   1cc22:	eb 1a                	jmp    1cc3e <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x10de>
   1cc24:	48 89 c5             	mov    %rax,%rbp
   1cc27:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
   1cc2e:	00 
   1cc2f:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
   1cc36:	00 
   1cc37:	48 8d 05 4a 16 04 00 	lea    0x4164a(%rip),%rax        # 5e288 <anon.fdcf7daaf1972ae73d3bbc4864918d1e.18.llvm.16159360244280900074+0x140>
   1cc3e:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
   1cc45:	00 
   1cc46:	48 89 ef             	mov    %rbp,%rdi
   1cc49:	48 8b b4 24 80 00 00 	mov    0x80(%rsp),%rsi
   1cc50:	00 
   1cc51:	48 8b 94 24 b8 00 00 	mov    0xb8(%rsp),%rdx
   1cc58:	00 
   1cc59:	ff 15 99 37 04 00    	call   *0x43799(%rip)        # 603f8 <_DYNAMIC+0x230>
   1cc5f:	0f 0b                	ud2
   1cc61:	eb 10                	jmp    1cc73 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1113>
   1cc63:	eb 37                	jmp    1cc9c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x113c>
   1cc65:	eb 0c                	jmp    1cc73 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1113>
   1cc67:	eb 0a                	jmp    1cc73 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1113>
   1cc69:	eb 31                	jmp    1cc9c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x113c>
   1cc6b:	eb 06                	jmp    1cc73 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1113>
   1cc6d:	eb 04                	jmp    1cc73 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1113>
   1cc6f:	eb 2b                	jmp    1cc9c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x113c>
   1cc71:	eb 29                	jmp    1cc9c <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x113c>
   1cc73:	48 89 c3             	mov    %rax,%rbx
   1cc76:	48 8b b4 24 b8 01 00 	mov    0x1b8(%rsp),%rsi
   1cc7d:	00 
   1cc7e:	48 85 f6             	test   %rsi,%rsi
   1cc81:	74 1c                	je     1cc9f <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x113f>
   1cc83:	48 8b bc 24 c0 01 00 	mov    0x1c0(%rsp),%rdi
   1cc8a:	00 
   1cc8b:	48 c1 e6 02          	shl    $0x2,%rsi
   1cc8f:	ba 04 00 00 00       	mov    $0x4,%edx
   1cc94:	ff 15 c6 37 04 00    	call   *0x437c6(%rip)        # 60460 <_DYNAMIC+0x298>
   1cc9a:	eb 03                	jmp    1cc9f <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x113f>
   1cc9c:	48 89 c3             	mov    %rax,%rbx
   1cc9f:	48 8b b4 24 a0 00 00 	mov    0xa0(%rsp),%rsi
   1cca6:	00 
   1cca7:	48 85 f6             	test   %rsi,%rsi
   1ccaa:	74 17                	je     1ccc3 <<parley::editing::geometry::CursorGeometry<()>>::try_for_each_pair::<(), core::ops::range::RangeInclusive<usize>, transaction_codegen::atomic::{closure#0}>+0x1163>
   1ccac:	48 8b bc 24 a8 00 00 	mov    0xa8(%rsp),%rdi
   1ccb3:	00 
   1ccb4:	48 c1 e6 03          	shl    $0x3,%rsi
   1ccb8:	ba 04 00 00 00       	mov    $0x4,%edx
   1ccbd:	ff 15 9d 37 04 00    	call   *0x4379d(%rip)        # 60460 <_DYNAMIC+0x298>
   1ccc3:	48 89 df             	mov    %rbx,%rdi
   1ccc6:	e8 15 03 04 00       	call   5cfe0 <_Unwind_Resume@plt>
