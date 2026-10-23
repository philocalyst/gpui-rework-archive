
/tmp/gpui-caret-transaction-bin/matched-partial-caret_pair_measure:     file format elf64-x86-64


Disassembly of section .text:

0000000000685f50 <parley::editing::geometry::pair_from_entries::<()>>:
  685f50:	55                   	push   %rbp
  685f51:	41 57                	push   %r15
  685f53:	41 56                	push   %r14
  685f55:	41 55                	push   %r13
  685f57:	41 54                	push   %r12
  685f59:	53                   	push   %rbx
  685f5a:	48 81 ec c8 01 00 00 	sub    $0x1c8,%rsp
  685f61:	4d 89 c7             	mov    %r8,%r15
  685f64:	49 89 ce             	mov    %rcx,%r14
  685f67:	f3 0f 11 44 24 04    	movss  %xmm0,0x4(%rsp)
  685f6d:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
  685f72:	48 89 f5             	mov    %rsi,%rbp
  685f75:	48 89 fb             	mov    %rdi,%rbx
  685f78:	4d 85 c0             	test   %r8,%r8
  685f7b:	0f 84 b4 00 00 00    	je     686035 <parley::editing::geometry::pair_from_entries::<()>+0xe5>
  685f81:	4c 8d ac 24 a8 00 00 	lea    0xa8(%rsp),%r13
  685f88:	00 
  685f89:	4c 89 ef             	mov    %r13,%rdi
  685f8c:	4c 89 fe             	mov    %r15,%rsi
  685f8f:	48 89 ea             	mov    %rbp,%rdx
  685f92:	e8 c9 ba ff ff       	call   681a60 <<parley::layout::cluster::ClusterPath>::cluster::<()>>
  685f97:	48 8b 84 24 a8 00 00 	mov    0xa8(%rsp),%rax
  685f9e:	00 
  685f9f:	48 85 c0             	test   %rax,%rax
  685fa2:	0f 84 99 00 00 00    	je     686041 <parley::editing::geometry::pair_from_entries::<()>+0xf1>
  685fa8:	8b bc 24 d0 00 00 00 	mov    0xd0(%rsp),%edi
  685faf:	48 8b 70 58          	mov    0x58(%rax),%rsi
  685fb3:	48 39 fe             	cmp    %rdi,%rsi
  685fb6:	0f 86 37 02 00 00    	jbe    6861f3 <parley::editing::geometry::pair_from_entries::<()>+0x2a3>
  685fbc:	48 8b 48 50          	mov    0x50(%rax),%rcx
  685fc0:	48 8d 14 ff          	lea    (%rdi,%rdi,8),%rdx
  685fc4:	48 c1 e2 04          	shl    $0x4,%rdx
  685fc8:	0f 10 40 68          	movups 0x68(%rax),%xmm0
  685fcc:	0f 10 88 80 00 00 00 	movups 0x80(%rax),%xmm1
  685fd3:	0f 10 90 98 00 00 00 	movups 0x98(%rax),%xmm2
  685fda:	0f 11 84 24 38 01 00 	movups %xmm0,0x138(%rsp)
  685fe1:	00 
  685fe2:	0f 11 8c 24 48 01 00 	movups %xmm1,0x148(%rsp)
  685fe9:	00 
  685fea:	0f 11 94 24 58 01 00 	movups %xmm2,0x158(%rsp)
  685ff1:	00 
  685ff2:	48 8b 44 11 50       	mov    0x50(%rcx,%rdx,1),%rax
  685ff7:	48 89 84 24 68 01 00 	mov    %rax,0x168(%rsp)
  685ffe:	00 
  685fff:	8b b4 24 28 01 00 00 	mov    0x128(%rsp),%esi
  686006:	8b 94 24 2c 01 00 00 	mov    0x12c(%rsp),%edx
  68600d:	48 8d bc 24 38 01 00 	lea    0x138(%rsp),%rdi
  686014:	00 
  686015:	ff 15 65 33 10 00    	call   *0x103365(%rip)        # 789380 <_DYNAMIC+0x568>
  68601b:	48 85 c0             	test   %rax,%rax
  68601e:	41 0f 95 c4          	setne  %r12b
  686022:	48 3b 44 24 10       	cmp    0x10(%rsp),%rax
  686027:	74 2c                	je     686055 <parley::editing::geometry::pair_from_entries::<()>+0x105>
  686029:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
  686030:	e9 a9 01 00 00       	jmp    6861de <parley::editing::geometry::pair_from_entries::<()>+0x28e>
  686035:	48 c7 84 24 a8 00 00 	movq   $0x0,0xa8(%rsp)
  68603c:	00 00 00 00 00 
  686041:	48 8b 85 50 01 00 00 	mov    0x150(%rbp),%rax
  686048:	41 b4 01             	mov    $0x1,%r12b
  68604b:	45 31 ed             	xor    %r13d,%r13d
  68604e:	48 3b 44 24 10       	cmp    0x10(%rsp),%rax
  686053:	75 d4                	jne    686029 <parley::editing::geometry::pair_from_entries::<()>+0xd9>
  686055:	4c 89 6c 24 08       	mov    %r13,0x8(%rsp)
  68605a:	4d 85 f6             	test   %r14,%r14
  68605d:	74 27                	je     686086 <parley::editing::geometry::pair_from_entries::<()>+0x136>
  68605f:	4c 8d ac 24 38 01 00 	lea    0x138(%rsp),%r13
  686066:	00 
  686067:	4c 89 ef             	mov    %r13,%rdi
  68606a:	4c 89 f6             	mov    %r14,%rsi
  68606d:	48 89 ea             	mov    %rbp,%rdx
  686070:	e8 eb b9 ff ff       	call   681a60 <<parley::layout::cluster::ClusterPath>::cluster::<()>>
  686075:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  68607c:	00 
  68607d:	48 85 c0             	test   %rax,%rax
  686080:	4c 0f 44 e8          	cmove  %rax,%r13
  686084:	eb 0f                	jmp    686095 <parley::editing::geometry::pair_from_entries::<()>+0x145>
  686086:	48 c7 84 24 38 01 00 	movq   $0x0,0x138(%rsp)
  68608d:	00 00 00 00 00 
  686092:	45 31 ed             	xor    %r13d,%r13d
  686095:	48 8b 95 10 01 00 00 	mov    0x110(%rbp),%rdx
  68609c:	48 8b ad 18 01 00 00 	mov    0x118(%rbp),%rbp
  6860a3:	41 0f b6 f4          	movzbl %r12b,%esi
  6860a7:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  6860ac:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6860b1:	48 89 e9             	mov    %rbp,%rcx
  6860b4:	f3 0f 10 44 24 04    	movss  0x4(%rsp),%xmm0
  6860ba:	4d 89 e8             	mov    %r13,%r8
  6860bd:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
  6860c2:	41 57                	push   %r15
  6860c4:	4d 89 f4             	mov    %r14,%r12
  6860c7:	41 56                	push   %r14
  6860c9:	e8 b2 e9 ff ff       	call   684a80 <<parley::editing::cursor::Cursor>::geometry_with::<(), parley::editing::geometry::pair_from_entries<()>::{closure#2}::{closure#0}>>
  6860ce:	48 83 c4 10          	add    $0x10,%rsp
  6860d2:	48 83 7c 24 10 00    	cmpq   $0x0,0x10(%rsp)
  6860d8:	0f 84 a7 00 00 00    	je     686185 <parley::editing::geometry::pair_from_entries::<()>+0x235>
  6860de:	48 8b 84 24 a8 00 00 	mov    0xa8(%rsp),%rax
  6860e5:	00 
  6860e6:	48 85 c0             	test   %rax,%rax
  6860e9:	0f 84 96 00 00 00    	je     686185 <parley::editing::geometry::pair_from_entries::<()>+0x235>
  6860ef:	8b bc 24 d0 00 00 00 	mov    0xd0(%rsp),%edi
  6860f6:	48 8b 70 58          	mov    0x58(%rax),%rsi
  6860fa:	48 39 fe             	cmp    %rdi,%rsi
  6860fd:	0f 86 f0 00 00 00    	jbe    6861f3 <parley::editing::geometry::pair_from_entries::<()>+0x2a3>
  686103:	48 8b 48 50          	mov    0x50(%rax),%rcx
  686107:	48 8d 14 ff          	lea    (%rdi,%rdi,8),%rdx
  68610b:	48 c1 e2 04          	shl    $0x4,%rdx
  68610f:	0f 10 40 68          	movups 0x68(%rax),%xmm0
  686113:	0f 10 88 80 00 00 00 	movups 0x80(%rax),%xmm1
  68611a:	0f 10 90 98 00 00 00 	movups 0x98(%rax),%xmm2
  686121:	0f 11 44 24 60       	movups %xmm0,0x60(%rsp)
  686126:	0f 11 4c 24 70       	movups %xmm1,0x70(%rsp)
  68612b:	0f 11 94 24 80 00 00 	movups %xmm2,0x80(%rsp)
  686132:	00 
  686133:	48 8b 44 11 50       	mov    0x50(%rcx,%rdx,1),%rax
  686138:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  68613f:	00 
  686140:	8b b4 24 28 01 00 00 	mov    0x128(%rsp),%esi
  686147:	8b 94 24 2c 01 00 00 	mov    0x12c(%rsp),%edx
  68614e:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  686153:	ff 15 27 32 10 00    	call   *0x103227(%rip)        # 789380 <_DYNAMIC+0x568>
  686159:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  68615e:	31 f6                	xor    %esi,%esi
  686160:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  686165:	48 89 e9             	mov    %rbp,%rcx
  686168:	f3 0f 10 44 24 04    	movss  0x4(%rsp),%xmm0
  68616e:	4d 89 e8             	mov    %r13,%r8
  686171:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
  686176:	41 57                	push   %r15
  686178:	41 54                	push   %r12
  68617a:	e8 01 e9 ff ff       	call   684a80 <<parley::editing::cursor::Cursor>::geometry_with::<(), parley::editing::geometry::pair_from_entries<()>::{closure#2}::{closure#0}>>
  68617f:	48 83 c4 10          	add    $0x10,%rsp
  686183:	eb 14                	jmp    686199 <parley::editing::geometry::pair_from_entries::<()>+0x249>
  686185:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  68618a:	0f 10 4c 24 50       	movups 0x50(%rsp),%xmm1
  68618f:	0f 29 4c 24 30       	movaps %xmm1,0x30(%rsp)
  686194:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  686199:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  68619e:	0f 10 4c 24 50       	movups 0x50(%rsp),%xmm1
  6861a3:	0f 29 4c 24 70       	movaps %xmm1,0x70(%rsp)
  6861a8:	0f 29 44 24 60       	movaps %xmm0,0x60(%rsp)
  6861ad:	0f 28 54 24 20       	movaps 0x20(%rsp),%xmm2
  6861b2:	0f 28 5c 24 30       	movaps 0x30(%rsp),%xmm3
  6861b7:	0f 29 94 24 80 00 00 	movaps %xmm2,0x80(%rsp)
  6861be:	00 
  6861bf:	0f 29 9c 24 90 00 00 	movaps %xmm3,0x90(%rsp)
  6861c6:	00 
  6861c7:	0f 11 5b 38          	movups %xmm3,0x38(%rbx)
  6861cb:	0f 11 53 28          	movups %xmm2,0x28(%rbx)
  6861cf:	0f 11 4b 18          	movups %xmm1,0x18(%rbx)
  6861d3:	0f 11 43 08          	movups %xmm0,0x8(%rbx)
  6861d7:	48 c7 03 01 00 00 00 	movq   $0x1,(%rbx)
  6861de:	48 89 d8             	mov    %rbx,%rax
  6861e1:	48 81 c4 c8 01 00 00 	add    $0x1c8,%rsp
  6861e8:	5b                   	pop    %rbx
  6861e9:	41 5c                	pop    %r12
  6861eb:	41 5d                	pop    %r13
  6861ed:	41 5e                	pop    %r14
  6861ef:	41 5f                	pop    %r15
  6861f1:	5d                   	pop    %rbp
  6861f2:	c3                   	ret
  6861f3:	48 8d 15 16 94 0f 00 	lea    0xf9416(%rip),%rdx        # 77f610 <anon.d4a86088305c8823b863e6abd2e38045.52.llvm.2509172480284221941>
  6861fa:	ff 15 78 2f 10 00    	call   *0x102f78(%rip)        # 789178 <_DYNAMIC+0x360>
