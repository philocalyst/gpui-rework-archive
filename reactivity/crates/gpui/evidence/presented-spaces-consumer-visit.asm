
/tmp/gpui-spaces-borrowed-final-consumer:     file format elf64-x86-64


Disassembly of section .text:

00000000004c1fe0 <<gpui::runtime::Win<presented_space_consumer::Panels>>::visit::<presented_space_consumer::inspect::{closure#0}>>:
  4c1fe0:	55                   	push   %rbp
  4c1fe1:	41 57                	push   %r15
  4c1fe3:	41 56                	push   %r14
  4c1fe5:	41 55                	push   %r13
  4c1fe7:	41 54                	push   %r12
  4c1fe9:	53                   	push   %rbx
  4c1fea:	48 81 ec 38 01 00 00 	sub    $0x138,%rsp
  4c1ff1:	4c 8b 2e             	mov    (%rsi),%r13
  4c1ff4:	4d 85 ed             	test   %r13,%r13
  4c1ff7:	0f 84 f6 02 00 00    	je     4c22f3 <<gpui::runtime::Win<presented_space_consumer::Panels>>::visit::<presented_space_consumer::inspect::{closure#0}>+0x313>
  4c1ffd:	b9 0e 00 00 00       	mov    $0xe,%ecx
  4c2002:	41 80 bd 7e 09 00 00 	cmpb   $0x0,0x97e(%r13)
  4c2009:	00 
  4c200a:	0f 85 f6 02 00 00    	jne    4c2306 <<gpui::runtime::Win<presented_space_consumer::Panels>>::visit::<presented_space_consumer::inspect::{closure#0}>+0x326>
  4c2010:	b9 12 00 00 00       	mov    $0x12,%ecx
  4c2015:	41 80 bd 7c 09 00 00 	cmpb   $0x1,0x97c(%r13)
  4c201c:	01 
  4c201d:	0f 85 e3 02 00 00    	jne    4c2306 <<gpui::runtime::Win<presented_space_consumer::Panels>>::visit::<presented_space_consumer::inspect::{closure#0}>+0x326>
  4c2023:	49 8b 85 50 07 00 00 	mov    0x750(%r13),%rax
  4c202a:	48 c7 c1 fe ff ff ff 	mov    $0xfffffffffffffffe,%rcx
  4c2031:	48 85 c0             	test   %rax,%rax
  4c2034:	0f 84 cc 02 00 00    	je     4c2306 <<gpui::runtime::Win<presented_space_consumer::Panels>>::visit::<presented_space_consumer::inspect::{closure#0}>+0x326>
  4c203a:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  4c203f:	4d 8b b5 48 07 00 00 	mov    0x748(%r13),%r14
  4c2046:	48 6b e8 38          	imul   $0x38,%rax,%rbp
  4c204a:	48 8b 02             	mov    (%rdx),%rax
  4c204d:	49 8d 5e 20          	lea    0x20(%r14),%rbx
  4c2051:	48 ff c0             	inc    %rax
  4c2054:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  4c2059:	45 31 ff             	xor    %r15d,%r15d
  4c205c:	45 31 e4             	xor    %r12d,%r12d
  4c205f:	4c 89 74 24 10       	mov    %r14,0x10(%rsp)
  4c2064:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  4c2069:	e9 80 00 00 00       	jmp    4c20ee <<gpui::runtime::Win<presented_space_consumer::Panels>>::visit::<presented_space_consumer::inspect::{closure#0}>+0x10e>
  4c206e:	66 90                	xchg   %ax,%ax
  4c2070:	f2 0f 10 13          	movsd  (%rbx),%xmm2
  4c2074:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%rsp)
  4c207b:	00 
  4c207c:	31 c0                	xor    %eax,%eax
  4c207e:	89 44 24 40          	mov    %eax,0x40(%rsp)
  4c2082:	f3 0f 11 74 24 44    	movss  %xmm6,0x44(%rsp)
  4c2088:	f3 0f 11 6c 24 48    	movss  %xmm5,0x48(%rsp)
  4c208e:	f3 0f 11 64 24 4c    	movss  %xmm4,0x4c(%rsp)
  4c2094:	f3 0f 11 5c 24 50    	movss  %xmm3,0x50(%rsp)
  4c209a:	f3 0f 11 4c 24 54    	movss  %xmm1,0x54(%rsp)
  4c20a0:	f3 0f 11 44 24 58    	movss  %xmm0,0x58(%rsp)
  4c20a6:	0f 57 c0             	xorps  %xmm0,%xmm0
  4c20a9:	0f 16 c2             	movlhps %xmm2,%xmm0
  4c20ac:	0f 11 44 24 5c       	movups %xmm0,0x5c(%rsp)
  4c20b1:	8b 44 24 3c          	mov    0x3c(%rsp),%eax
  4c20b5:	48 8d 4c 24 6c       	lea    0x6c(%rsp),%rcx
  4c20ba:	89 41 10             	mov    %eax,0x10(%rcx)
  4c20bd:	0f 10 44 24 2c       	movups 0x2c(%rsp),%xmm0
  4c20c2:	0f 11 01             	movups %xmm0,(%rcx)
  4c20c5:	48 8d 44 24 40       	lea    0x40(%rsp),%rax
  4c20ca:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  4c20cf:	4c 01 f8             	add    %r15,%rax
  4c20d2:	48 89 02             	mov    %rax,(%rdx)
  4c20d5:	49 83 c6 38          	add    $0x38,%r14
  4c20d9:	48 83 c3 38          	add    $0x38,%rbx
  4c20dd:	49 ff c7             	inc    %r15
  4c20e0:	49 83 c4 18          	add    $0x18,%r12
  4c20e4:	48 83 c5 c8          	add    $0xffffffffffffffc8,%rbp
  4c20e8:	0f 84 0c 02 00 00    	je     4c22fa <<gpui::runtime::Win<presented_space_consumer::Panels>>::visit::<presented_space_consumer::inspect::{closure#0}>+0x31a>
  4c20ee:	0f b6 7b 14          	movzbl 0x14(%rbx),%edi
  4c20f2:	48 81 ff ff 00 00 00 	cmp    $0xff,%rdi
  4c20f9:	0f 84 71 ff ff ff    	je     4c2070 <<gpui::runtime::Win<presented_space_consumer::Panels>>::visit::<presented_space_consumer::inspect::{closure#0}>+0x90>
  4c20ff:	49 8b 85 98 07 00 00 	mov    0x798(%r13),%rax
  4c2106:	49 89 c0             	mov    %rax,%r8
  4c2109:	48 b9 00 00 00 00 00 	movabs $0x8000000000000000,%rcx
  4c2110:	00 00 80 
  4c2113:	49 31 c8             	xor    %rcx,%r8
  4c2116:	48 85 c0             	test   %rax,%rax
  4c2119:	b8 02 00 00 00       	mov    $0x2,%eax
  4c211e:	4c 0f 49 c0          	cmovns %rax,%r8
  4c2122:	49 8d b5 ac 07 00 00 	lea    0x7ac(%r13),%rsi
  4c2129:	49 8d 95 a8 07 00 00 	lea    0x7a8(%r13),%rdx
  4c2130:	49 8d 8d a4 07 00 00 	lea    0x7a4(%r13),%rcx
  4c2137:	49 8d 85 a0 07 00 00 	lea    0x7a0(%r13),%rax
  4c213e:	4d 85 c0             	test   %r8,%r8
  4c2141:	74 41                	je     4c2184 <<gpui::runtime::Win<presented_space_consumer::Panels>>::visit::<presented_space_consumer::inspect::{closure#0}>+0x1a4>
  4c2143:	49 83 f8 01          	cmp    $0x1,%r8
  4c2147:	75 47                	jne    4c2190 <<gpui::runtime::Win<presented_space_consumer::Panels>>::visit::<presented_space_consumer::inspect::{closure#0}>+0x1b0>
  4c2149:	49 8d 85 a8 07 00 00 	lea    0x7a8(%r13),%rax
  4c2150:	48 8b 30             	mov    (%rax),%rsi
  4c2153:	48 39 fe             	cmp    %rdi,%rsi
  4c2156:	0f 86 d2 01 00 00    	jbe    4c232e <<gpui::runtime::Win<presented_space_consumer::Panels>>::visit::<presented_space_consumer::inspect::{closure#0}>+0x34e>
  4c215c:	49 8d 85 a0 07 00 00 	lea    0x7a0(%r13),%rax
  4c2163:	48 8b 30             	mov    (%rax),%rsi
  4c2166:	c1 e7 04             	shl    $0x4,%edi
  4c2169:	48 8d 04 3e          	lea    (%rsi,%rdi,1),%rax
  4c216d:	48 8d 0c 3e          	lea    (%rsi,%rdi,1),%rcx
  4c2171:	48 83 c1 04          	add    $0x4,%rcx
  4c2175:	48 8d 14 3e          	lea    (%rsi,%rdi,1),%rdx
  4c2179:	48 83 c2 08          	add    $0x8,%rdx
  4c217d:	48 01 fe             	add    %rdi,%rsi
  4c2180:	48 83 c6 0c          	add    $0xc,%rsi
  4c2184:	4c 8d 43 0c          	lea    0xc(%rbx),%r8
  4c2188:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  4c218c:	eb 68                	jmp    4c21f6 <<gpui::runtime::Win<presented_space_consumer::Panels>>::visit::<presented_space_consumer::inspect::{closure#0}>+0x216>
  4c218e:	66 90                	xchg   %ax,%ax
  4c2190:	4c 89 f0             	mov    %r14,%rax
  4c2193:	48 2b 44 24 10       	sub    0x10(%rsp),%rax
  4c2198:	48 c1 e8 03          	shr    $0x3,%rax
  4c219c:	48 b9 93 24 49 92 24 	movabs $0x2492492492492493,%rcx
  4c21a3:	49 92 24 
  4c21a6:	48 f7 e1             	mul    %rcx
  4c21a9:	49 8d 85 a8 07 00 00 	lea    0x7a8(%r13),%rax
  4c21b0:	48 8b 30             	mov    (%rax),%rsi
  4c21b3:	49 39 f7             	cmp    %rsi,%r15
  4c21b6:	0f 83 62 01 00 00    	jae    4c231e <<gpui::runtime::Win<presented_space_consumer::Panels>>::visit::<presented_space_consumer::inspect::{closure#0}>+0x33e>
  4c21bc:	49 8d 85 a0 07 00 00 	lea    0x7a0(%r13),%rax
  4c21c3:	4c 8b 00             	mov    (%rax),%r8
  4c21c6:	4c 8d 0c 52          	lea    (%rdx,%rdx,2),%r9
  4c21ca:	4b 8d 04 20          	lea    (%r8,%r12,1),%rax
  4c21ce:	4b 8d 0c 20          	lea    (%r8,%r12,1),%rcx
  4c21d2:	48 83 c1 04          	add    $0x4,%rcx
  4c21d6:	4b 8d 14 20          	lea    (%r8,%r12,1),%rdx
  4c21da:	48 83 c2 08          	add    $0x8,%rdx
  4c21de:	4b 8d 34 20          	lea    (%r8,%r12,1),%rsi
  4c21e2:	48 83 c6 0c          	add    $0xc,%rsi
  4c21e6:	4b 8d 3c c8          	lea    (%r8,%r9,8),%rdi
  4c21ea:	48 83 c7 10          	add    $0x10,%rdi
  4c21ee:	4f 8d 04 c8          	lea    (%r8,%r9,8),%r8
  4c21f2:	49 83 c0 14          	add    $0x14,%r8
  4c21f6:	f3 41 0f 10 08       	movss  (%r8),%xmm1
  4c21fb:	0f 29 8c 24 90 00 00 	movaps %xmm1,0x90(%rsp)
  4c2202:	00 
  4c2203:	f3 0f 10 17          	movss  (%rdi),%xmm2
  4c2207:	0f 29 94 24 a0 00 00 	movaps %xmm2,0xa0(%rsp)
  4c220e:	00 
  4c220f:	f3 0f 10 1e          	movss  (%rsi),%xmm3
  4c2213:	0f 29 9c 24 b0 00 00 	movaps %xmm3,0xb0(%rsp)
  4c221a:	00 
  4c221b:	f3 0f 10 22          	movss  (%rdx),%xmm4
  4c221f:	0f 29 a4 24 c0 00 00 	movaps %xmm4,0xc0(%rsp)
  4c2226:	00 
  4c2227:	f3 0f 10 29          	movss  (%rcx),%xmm5
  4c222b:	0f 29 ac 24 d0 00 00 	movaps %xmm5,0xd0(%rsp)
  4c2232:	00 
  4c2233:	f3 0f 10 00          	movss  (%rax),%xmm0
  4c2237:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
  4c223e:	00 
  4c223f:	0f 14 c5             	unpcklps %xmm5,%xmm0
  4c2242:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  4c2245:	f2 0f 10 2b          	movsd  (%rbx),%xmm5
  4c2249:	0f 29 ac 24 80 00 00 	movaps %xmm5,0x80(%rsp)
  4c2250:	00 
  4c2251:	0f 29 84 24 00 01 00 	movaps %xmm0,0x100(%rsp)
  4c2258:	00 
  4c2259:	0f 28 c4             	movaps %xmm4,%xmm0
  4c225c:	0f 14 c3             	unpcklps %xmm3,%xmm0
  4c225f:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  4c2262:	0f 29 84 24 10 01 00 	movaps %xmm0,0x110(%rsp)
  4c2269:	00 
  4c226a:	0f 28 c2             	movaps %xmm2,%xmm0
  4c226d:	0f 14 c1             	unpcklps %xmm1,%xmm0
  4c2270:	0f 5a c0             	cvtps2pd %xmm0,%xmm0
  4c2273:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
  4c227a:	00 
  4c227b:	c6 84 24 30 01 00 00 	movb   $0x0,0x130(%rsp)
  4c2282:	00 
  4c2283:	0f 57 c0             	xorps  %xmm0,%xmm0
  4c2286:	0f 16 c5             	movlhps %xmm5,%xmm0
  4c2289:	0f 11 84 24 f0 00 00 	movups %xmm0,0xf0(%rsp)
  4c2290:	00 
  4c2291:	48 8d 7c 24 2c       	lea    0x2c(%rsp),%rdi
  4c2296:	48 8d b4 24 00 01 00 	lea    0x100(%rsp),%rsi
  4c229d:	00 
  4c229e:	48 8d 94 24 f0 00 00 	lea    0xf0(%rsp),%rdx
  4c22a5:	00 
  4c22a6:	ff 15 ac ad 2d 00    	call   *0x2dadac(%rip)        # 79d058 <_DYNAMIC+0x2a0>
  4c22ac:	0f 28 b4 24 e0 00 00 	movaps 0xe0(%rsp),%xmm6
  4c22b3:	00 
  4c22b4:	0f 28 ac 24 d0 00 00 	movaps 0xd0(%rsp),%xmm5
  4c22bb:	00 
  4c22bc:	0f 28 a4 24 c0 00 00 	movaps 0xc0(%rsp),%xmm4
  4c22c3:	00 
  4c22c4:	0f 28 9c 24 b0 00 00 	movaps 0xb0(%rsp),%xmm3
  4c22cb:	00 
  4c22cc:	0f 28 94 24 80 00 00 	movaps 0x80(%rsp),%xmm2
  4c22d3:	00 
  4c22d4:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  4c22db:	00 
  4c22dc:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
  4c22e3:	00 
  4c22e4:	b8 01 00 00 00       	mov    $0x1,%eax
  4c22e9:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  4c22ee:	e9 8b fd ff ff       	jmp    4c207e <<gpui::runtime::Win<presented_space_consumer::Panels>>::visit::<presented_space_consumer::inspect::{closure#0}>+0x9e>
  4c22f3:	b9 0d 00 00 00       	mov    $0xd,%ecx
  4c22f8:	eb 0c                	jmp    4c2306 <<gpui::runtime::Win<presented_space_consumer::Panels>>::visit::<presented_space_consumer::inspect::{closure#0}>+0x326>
  4c22fa:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  4c22ff:	48 c7 c1 fe ff ff ff 	mov    $0xfffffffffffffffe,%rcx
  4c2306:	48 89 0f             	mov    %rcx,(%rdi)
  4c2309:	48 89 f8             	mov    %rdi,%rax
  4c230c:	48 81 c4 38 01 00 00 	add    $0x138,%rsp
  4c2313:	5b                   	pop    %rbx
  4c2314:	41 5c                	pop    %r12
  4c2316:	41 5d                	pop    %r13
  4c2318:	41 5e                	pop    %r14
  4c231a:	41 5f                	pop    %r15
  4c231c:	5d                   	pop    %rbp
  4c231d:	c3                   	ret
  4c231e:	48 8d 15 93 9e 2b 00 	lea    0x2b9e93(%rip),%rdx        # 77c1b8 <__frame_dummy_init_array_entry+0x200>
  4c2325:	4c 89 ff             	mov    %r15,%rdi
  4c2328:	ff 15 32 ad 2d 00    	call   *0x2dad32(%rip)        # 79d060 <_DYNAMIC+0x2a8>
  4c232e:	48 8d 15 6b 9e 2b 00 	lea    0x2b9e6b(%rip),%rdx        # 77c1a0 <__frame_dummy_init_array_entry+0x1e8>
  4c2335:	ff 15 25 ad 2d 00    	call   *0x2dad25(%rip)        # 79d060 <_DYNAMIC+0x2a8>
