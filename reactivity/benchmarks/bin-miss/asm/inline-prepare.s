
/tmp/gpui-bin-miss-artifacts/inline-a22a9b21125d7aab88b97a97fd0982a3854cd16e015fa3363d7eb85b40ffd3ce:     file format elf64-x86-64


Disassembly of section .text:

0000000000092ef0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare>:
   92ef0:	55                   	push   %rbp
   92ef1:	41 57                	push   %r15
   92ef3:	41 56                	push   %r14
   92ef5:	41 55                	push   %r13
   92ef7:	41 54                	push   %r12
   92ef9:	53                   	push   %rbx
   92efa:	48 81 ec 48 01 00 00 	sub    $0x148,%rsp
   92f01:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
   92f06:	48 8b 32             	mov    (%rdx),%rsi
   92f09:	4c 8b 7a 08          	mov    0x8(%rdx),%r15
   92f0d:	4c 8b 42 10          	mov    0x10(%rdx),%r8
   92f11:	4c 8b 4a 18          	mov    0x18(%rdx),%r9
   92f15:	4c 89 c8             	mov    %r9,%rax
   92f18:	48 c1 e0 30          	shl    $0x30,%rax
   92f1c:	41 0f b7 c8          	movzwl %r8w,%ecx
   92f20:	48 c1 e1 20          	shl    $0x20,%rcx
   92f24:	48 09 c1             	or     %rax,%rcx
   92f27:	44 89 f8             	mov    %r15d,%eax
   92f2a:	c1 e0 10             	shl    $0x10,%eax
   92f2d:	48 09 c8             	or     %rcx,%rax
   92f30:	0f b7 ce             	movzwl %si,%ecx
   92f33:	48 09 c1             	or     %rax,%rcx
   92f36:	48 8b 47 48          	mov    0x48(%rdi),%rax
   92f3a:	48 39 c8             	cmp    %rcx,%rax
   92f3d:	0f 84 70 06 00 00    	je     935b3 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x6c3>
   92f43:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
   92f48:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
   92f4d:	48 c7 47 48 00 00 00 	movq   $0x0,0x48(%rdi)
   92f54:	00 
   92f55:	4d 89 c6             	mov    %r8,%r14
   92f58:	49 29 f6             	sub    %rsi,%r14
   92f5b:	4c 89 ca             	mov    %r9,%rdx
   92f5e:	4c 29 fa             	sub    %r15,%rdx
   92f61:	49 0f af d6          	imul   %r14,%rdx
   92f65:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
   92f6a:	48 c7 47 10 00 00 00 	movq   $0x0,0x10(%rdi)
   92f71:	00 
   92f72:	48 ff c2             	inc    %rdx
   92f75:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
   92f7a:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
   92f7f:	4c 89 4c 24 58       	mov    %r9,0x58(%rsp)
   92f84:	4c 89 74 24 28       	mov    %r14,0x28(%rsp)
   92f89:	75 05                	jne    92f90 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0xa0>
   92f8b:	45 31 e4             	xor    %r12d,%r12d
   92f8e:	eb 4a                	jmp    92fda <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0xea>
   92f90:	48 3b 17             	cmp    (%rdi),%rdx
   92f93:	49 89 fe             	mov    %rdi,%r14
   92f96:	0f 87 e4 06 00 00    	ja     93680 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x790>
   92f9c:	45 31 e4             	xor    %r12d,%r12d
   92f9f:	48 8b 5f 08          	mov    0x8(%rdi),%rbx
   92fa3:	4a 8d 3c e3          	lea    (%rbx,%r12,8),%rdi
   92fa7:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
   92fac:	4d 85 ed             	test   %r13,%r13
   92faf:	74 17                	je     92fc8 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0xd8>
   92fb1:	4a 8d 14 ed 00 00 00 	lea    0x0(,%r13,8),%rdx
   92fb8:	00 
   92fb9:	31 f6                	xor    %esi,%esi
   92fbb:	ff 15 1f f5 05 00    	call   *0x5f51f(%rip)        # f24e0 <memset@GLIBC_2.2.5>
   92fc1:	4d 01 ec             	add    %r13,%r12
   92fc4:	4a 8d 3c e3          	lea    (%rbx,%r12,8),%rdi
   92fc8:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
   92fcf:	49 ff c4             	inc    %r12
   92fd2:	4c 89 f7             	mov    %r14,%rdi
   92fd5:	4c 8b 74 24 28       	mov    0x28(%rsp),%r14
   92fda:	48 89 3c 24          	mov    %rdi,(%rsp)
   92fde:	4c 89 67 10          	mov    %r12,0x10(%rdi)
   92fe2:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   92fe7:	48 8b 48 78          	mov    0x78(%rax),%rcx
   92feb:	48 8b 90 80 00 00 00 	mov    0x80(%rax),%rdx
   92ff2:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
   92ff7:	48 8d 04 91          	lea    (%rcx,%rdx,4),%rax
   92ffb:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
   93000:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
   93005:	48 85 d2             	test   %rdx,%rdx
   93008:	4c 89 7c 24 18       	mov    %r15,0x18(%rsp)
   9300d:	0f 84 ba 02 00 00    	je     932cd <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x3dd>
   93013:	48 8b 04 24          	mov    (%rsp),%rax
   93017:	48 8b 68 08          	mov    0x8(%rax),%rbp
   9301b:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
   93020:	48 89 ce             	mov    %rcx,%rsi
   93023:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
   93028:	48 29 d6             	sub    %rdx,%rsi
   9302b:	48 8d 04 cd 00 00 00 	lea    0x0(,%rcx,8),%rax
   93032:	00 
   93033:	48 89 ef             	mov    %rbp,%rdi
   93036:	48 29 c7             	sub    %rax,%rdi
   93039:	48 83 c7 18          	add    $0x18,%rdi
   9303d:	48 89 bc 24 98 00 00 	mov    %rdi,0x98(%rsp)
   93044:	00 
   93045:	4a 8d 3c f5 00 00 00 	lea    0x0(,%r14,8),%rdi
   9304c:	00 
   9304d:	48 89 bc 24 90 00 00 	mov    %rdi,0x90(%rsp)
   93054:	00 
   93055:	48 8d 14 d5 00 00 00 	lea    0x0(,%rdx,8),%rdx
   9305c:	00 
   9305d:	48 29 c2             	sub    %rax,%rdx
   93060:	48 89 94 24 a8 00 00 	mov    %rdx,0xa8(%rsp)
   93067:	00 
   93068:	b8 01 00 00 00       	mov    $0x1,%eax
   9306d:	48 29 c8             	sub    %rcx,%rax
   93070:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
   93077:	00 
   93078:	48 8d 41 ff          	lea    -0x1(%rcx),%rax
   9307c:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
   93083:	00 
   93084:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
   93089:	48 89 74 24 60       	mov    %rsi,0x60(%rsp)
   9308e:	eb 1c                	jmp    930ac <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x1bc>
   93090:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
   93097:	00 
   93098:	48 83 c0 04          	add    $0x4,%rax
   9309c:	48 3b 44 24 50       	cmp    0x50(%rsp),%rax
   930a1:	4c 8b 7c 24 18       	mov    0x18(%rsp),%r15
   930a6:	0f 84 21 02 00 00    	je     932cd <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x3dd>
   930ac:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
   930b3:	00 
   930b4:	8b 10                	mov    (%rax),%edx
   930b6:	48 8d bc 24 b8 00 00 	lea    0xb8(%rsp),%rdi
   930bd:	00 
   930be:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
   930c3:	e8 e8 05 00 00       	call   936b0 <<gpui_canvas::canvas::DisplayList>::get>
   930c8:	66 0f 76 d2          	pcmpeqd %xmm2,%xmm2
   930cc:	48 8b 84 24 30 01 00 	mov    0x130(%rsp),%rax
   930d3:	00 
   930d4:	48 c1 e8 04          	shr    $0x4,%rax
   930d8:	49 39 c7             	cmp    %rax,%r15
   930db:	49 0f 47 c7          	cmova  %r15,%rax
   930df:	48 8b 94 24 40 01 00 	mov    0x140(%rsp),%rdx
   930e6:	00 
   930e7:	48 89 d1             	mov    %rdx,%rcx
   930ea:	48 c1 e9 04          	shr    $0x4,%rcx
   930ee:	83 e2 0f             	and    $0xf,%edx
   930f1:	48 83 fa 01          	cmp    $0x1,%rdx
   930f5:	48 83 d9 ff          	sbb    $0xffffffffffffffff,%rcx
   930f9:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
   930fe:	48 39 ca             	cmp    %rcx,%rdx
   93101:	48 0f 42 ca          	cmovb  %rdx,%rcx
   93105:	48 39 c8             	cmp    %rcx,%rax
   93108:	73 86                	jae    93090 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x1a0>
   9310a:	48 8b 94 24 28 01 00 	mov    0x128(%rsp),%rdx
   93111:	00 
   93112:	48 c1 ea 04          	shr    $0x4,%rdx
   93116:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
   9311b:	48 39 d6             	cmp    %rdx,%rsi
   9311e:	48 0f 47 d6          	cmova  %rsi,%rdx
   93122:	48 8b bc 24 38 01 00 	mov    0x138(%rsp),%rdi
   93129:	00 
   9312a:	49 89 f8             	mov    %rdi,%r8
   9312d:	49 c1 e8 04          	shr    $0x4,%r8
   93131:	83 e7 0f             	and    $0xf,%edi
   93134:	48 83 ff 01          	cmp    $0x1,%rdi
   93138:	49 83 d8 ff          	sbb    $0xffffffffffffffff,%r8
   9313c:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
   93141:	4c 39 c6             	cmp    %r8,%rsi
   93144:	4c 0f 42 c6          	cmovb  %rsi,%r8
   93148:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
   9314d:	4c 39 c2             	cmp    %r8,%rdx
   93150:	0f 83 3a ff ff ff    	jae    93090 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x1a0>
   93156:	49 89 d0             	mov    %rdx,%r8
   93159:	49 f7 d0             	not    %r8
   9315c:	4c 03 44 24 20       	add    0x20(%rsp),%r8
   93161:	48 89 d7             	mov    %rdx,%rdi
   93164:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
   93169:	48 29 f7             	sub    %rsi,%rdi
   9316c:	49 89 c2             	mov    %rax,%r10
   9316f:	4c 2b 54 24 18       	sub    0x18(%rsp),%r10
   93174:	4d 89 f1             	mov    %r14,%r9
   93177:	4d 0f af ca          	imul   %r10,%r9
   9317b:	4c 01 cf             	add    %r9,%rdi
   9317e:	48 ff c7             	inc    %rdi
   93181:	48 89 7c 24 40       	mov    %rdi,0x40(%rsp)
   93186:	4c 89 cf             	mov    %r9,%rdi
   93189:	48 f7 d7             	not    %rdi
   9318c:	48 01 f7             	add    %rsi,%rdi
   9318f:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
   93194:	48 29 d7             	sub    %rdx,%rdi
   93197:	48 89 bc 24 b0 00 00 	mov    %rdi,0xb0(%rsp)
   9319e:	00 
   9319f:	4c 0f af 94 24 90 00 	imul   0x90(%rsp),%r10
   931a6:	00 00 
   931a8:	49 8d 1c d2          	lea    (%r10,%rdx,8),%rbx
   931ac:	48 03 9c 24 98 00 00 	add    0x98(%rsp),%rbx
   931b3:	00 
   931b4:	48 8b bc 24 88 00 00 	mov    0x88(%rsp),%rdi
   931bb:	00 
   931bc:	4c 8d 1c 17          	lea    (%rdi,%rdx,1),%r11
   931c0:	4d 01 cb             	add    %r9,%r11
   931c3:	4c 8b bc 24 80 00 00 	mov    0x80(%rsp),%r15
   931ca:	00 
   931cb:	4d 29 cf             	sub    %r9,%r15
   931ce:	49 29 d7             	sub    %rdx,%r15
   931d1:	49 01 f9             	add    %rdi,%r9
   931d4:	45 31 d2             	xor    %r10d,%r10d
   931d7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   931de:	00 00 
   931e0:	4d 39 dc             	cmp    %r11,%r12
   931e3:	4d 89 dd             	mov    %r11,%r13
   931e6:	4d 0f 47 ec          	cmova  %r12,%r13
   931ea:	4d 01 fd             	add    %r15,%r13
   931ed:	4d 39 e8             	cmp    %r13,%r8
   931f0:	4d 0f 42 e8          	cmovb  %r8,%r13
   931f4:	4c 89 f7             	mov    %r14,%rdi
   931f7:	49 0f af fa          	imul   %r10,%rdi
   931fb:	48 03 7c 24 40       	add    0x40(%rsp),%rdi
   93200:	49 39 fc             	cmp    %rdi,%r12
   93203:	49 0f 47 fc          	cmova  %r12,%rdi
   93207:	49 89 f6             	mov    %rsi,%r14
   9320a:	4d 0f af f2          	imul   %r10,%r14
   9320e:	4c 03 b4 24 b0 00 00 	add    0xb0(%rsp),%r14
   93215:	00 
   93216:	49 01 fe             	add    %rdi,%r14
   93219:	4d 39 f0             	cmp    %r14,%r8
   9321c:	4d 0f 42 f0          	cmovb  %r8,%r14
   93220:	49 ff c6             	inc    %r14
   93223:	48 89 d7             	mov    %rdx,%rdi
   93226:	49 83 fe 05          	cmp    $0x5,%r14
   9322a:	72 54                	jb     93280 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x390>
   9322c:	44 89 f6             	mov    %r14d,%esi
   9322f:	83 e6 03             	and    $0x3,%esi
   93232:	bf 04 00 00 00       	mov    $0x4,%edi
   93237:	48 0f 44 f7          	cmove  %rdi,%rsi
   9323b:	49 29 f6             	sub    %rsi,%r14
   9323e:	4c 89 f7             	mov    %r14,%rdi
   93241:	48 01 d7             	add    %rdx,%rdi
   93244:	49 29 f5             	sub    %rsi,%r13
   93247:	49 ff c5             	inc    %r13
   9324a:	45 31 f6             	xor    %r14d,%r14d
   9324d:	0f 1f 00             	nopl   (%rax)
   93250:	f3 42 0f 6f 44 f3 f0 	movdqu -0x10(%rbx,%r14,8),%xmm0
   93257:	f3 42 0f 6f 0c f3    	movdqu (%rbx,%r14,8),%xmm1
   9325d:	66 0f fb c2          	psubq  %xmm2,%xmm0
   93261:	66 0f fb ca          	psubq  %xmm2,%xmm1
   93265:	f3 42 0f 7f 44 f3 f0 	movdqu %xmm0,-0x10(%rbx,%r14,8)
   9326c:	f3 42 0f 7f 0c f3    	movdqu %xmm1,(%rbx,%r14,8)
   93272:	49 83 c6 04          	add    $0x4,%r14
   93276:	4d 39 f5             	cmp    %r14,%r13
   93279:	75 d5                	jne    93250 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x360>
   9327b:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
   93280:	48 ff c0             	inc    %rax
   93283:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
   93288:	49 29 fe             	sub    %rdi,%r14
   9328b:	4c 01 cf             	add    %r9,%rdi
   9328e:	66 90                	xchg   %ax,%ax
   93290:	4c 39 e7             	cmp    %r12,%rdi
   93293:	0f 83 32 03 00 00    	jae    935cb <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x6db>
   93299:	48 ff 44 fd 00       	incq   0x0(%rbp,%rdi,8)
   9329e:	48 ff c7             	inc    %rdi
   932a1:	49 ff ce             	dec    %r14
   932a4:	75 ea                	jne    93290 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x3a0>
   932a6:	49 ff c2             	inc    %r10
   932a9:	48 03 9c 24 a8 00 00 	add    0xa8(%rsp),%rbx
   932b0:	00 
   932b1:	4c 8b 74 24 28       	mov    0x28(%rsp),%r14
   932b6:	4d 01 f3             	add    %r14,%r11
   932b9:	49 01 f7             	add    %rsi,%r15
   932bc:	4d 01 f1             	add    %r14,%r9
   932bf:	48 39 c8             	cmp    %rcx,%rax
   932c2:	0f 85 18 ff ff ff    	jne    931e0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x2f0>
   932c8:	e9 c3 fd ff ff       	jmp    93090 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x1a0>
   932cd:	49 83 fc 02          	cmp    $0x2,%r12
   932d1:	0f 82 ea 00 00 00    	jb     933c1 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x4d1>
   932d7:	4c 8b 3c 24          	mov    (%rsp),%r15
   932db:	49 8b 47 08          	mov    0x8(%r15),%rax
   932df:	48 8b 08             	mov    (%rax),%rcx
   932e2:	49 8d 7c 24 ff       	lea    -0x1(%r12),%rdi
   932e7:	4d 8d 44 24 fe       	lea    -0x2(%r12),%r8
   932ec:	89 fa                	mov    %edi,%edx
   932ee:	83 e2 03             	and    $0x3,%edx
   932f1:	be 01 00 00 00       	mov    $0x1,%esi
   932f6:	49 83 f8 03          	cmp    $0x3,%r8
   932fa:	72 4d                	jb     93349 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x459>
   932fc:	48 83 e7 fc          	and    $0xfffffffffffffffc,%rdi
   93300:	31 f6                	xor    %esi,%esi
   93302:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   93309:	1f 84 00 00 00 00 00 
   93310:	48 03 4c f0 08       	add    0x8(%rax,%rsi,8),%rcx
   93315:	48 89 4c f0 08       	mov    %rcx,0x8(%rax,%rsi,8)
   9331a:	48 03 4c f0 10       	add    0x10(%rax,%rsi,8),%rcx
   9331f:	48 89 4c f0 10       	mov    %rcx,0x10(%rax,%rsi,8)
   93324:	48 03 4c f0 18       	add    0x18(%rax,%rsi,8),%rcx
   93329:	48 89 4c f0 18       	mov    %rcx,0x18(%rax,%rsi,8)
   9332e:	48 03 4c f0 20       	add    0x20(%rax,%rsi,8),%rcx
   93333:	48 89 4c f0 20       	mov    %rcx,0x20(%rax,%rsi,8)
   93338:	48 83 c6 04          	add    $0x4,%rsi
   9333c:	48 39 f7             	cmp    %rsi,%rdi
   9333f:	75 cf                	jne    93310 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x420>
   93341:	48 85 d2             	test   %rdx,%rdx
   93344:	74 1a                	je     93360 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x470>
   93346:	48 ff c6             	inc    %rsi
   93349:	48 8d 34 f0          	lea    (%rax,%rsi,8),%rsi
   9334d:	31 ff                	xor    %edi,%edi
   9334f:	90                   	nop
   93350:	48 03 0c fe          	add    (%rsi,%rdi,8),%rcx
   93354:	48 89 0c fe          	mov    %rcx,(%rsi,%rdi,8)
   93358:	48 ff c7             	inc    %rdi
   9335b:	48 39 fa             	cmp    %rdi,%rdx
   9335e:	75 f0                	jne    93350 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x460>
   93360:	49 8d 6f 28          	lea    0x28(%r15),%rbp
   93364:	49 c7 47 28 00 00 00 	movq   $0x0,0x28(%r15)
   9336b:	00 
   9336c:	4e 8b 6c e0 f8       	mov    -0x8(%rax,%r12,8),%r13
   93371:	4d 85 ed             	test   %r13,%r13
   93374:	74 72                	je     933e8 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x4f8>
   93376:	4d 3b 6f 18          	cmp    0x18(%r15),%r13
   9337a:	0f 87 cc 02 00 00    	ja     9364c <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x75c>
   93380:	31 db                	xor    %ebx,%ebx
   93382:	4d 8b 77 20          	mov    0x20(%r15),%r14
   93386:	49 8d 3c 9e          	lea    (%r14,%rbx,4),%rdi
   9338a:	49 83 fd 01          	cmp    $0x1,%r13
   9338e:	74 22                	je     933b2 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x4c2>
   93390:	4a 8d 14 ad fc ff ff 	lea    -0x4(,%r13,4),%rdx
   93397:	ff 
   93398:	31 f6                	xor    %esi,%esi
   9339a:	ff 15 40 f1 05 00    	call   *0x5f140(%rip)        # f24e0 <memset@GLIBC_2.2.5>
   933a0:	4a 8d 04 2b          	lea    (%rbx,%r13,1),%rax
   933a4:	49 8d 3c 86          	lea    (%r14,%rax,4),%rdi
   933a8:	48 83 c7 fc          	add    $0xfffffffffffffffc,%rdi
   933ac:	4c 01 eb             	add    %r13,%rbx
   933af:	48 ff cb             	dec    %rbx
   933b2:	c7 07 00 00 00 00    	movl   $0x0,(%rdi)
   933b8:	48 ff c3             	inc    %rbx
   933bb:	4d 8b 67 10          	mov    0x10(%r15),%r12
   933bf:	eb 29                	jmp    933ea <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x4fa>
   933c1:	4c 8b 3c 24          	mov    (%rsp),%r15
   933c5:	49 c7 47 28 00 00 00 	movq   $0x0,0x28(%r15)
   933cc:	00 
   933cd:	4d 85 e4             	test   %r12,%r12
   933d0:	0f 84 3a 02 00 00    	je     93610 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x720>
   933d6:	49 8d 6f 28          	lea    0x28(%r15),%rbp
   933da:	49 8b 47 08          	mov    0x8(%r15),%rax
   933de:	4e 8b 6c e0 f8       	mov    -0x8(%rax,%r12,8),%r13
   933e3:	4d 85 ed             	test   %r13,%r13
   933e6:	75 8e                	jne    93376 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x486>
   933e8:	31 db                	xor    %ebx,%ebx
   933ea:	49 89 5f 28          	mov    %rbx,0x28(%r15)
   933ee:	49 c7 47 40 00 00 00 	movq   $0x0,0x40(%r15)
   933f5:	00 
   933f6:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
   933fb:	4c 39 e3             	cmp    %r12,%rbx
   933fe:	0f 87 f7 01 00 00    	ja     935fb <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x70b>
   93404:	49 8b 77 08          	mov    0x8(%r15),%rsi
   93408:	49 3b 5f 30          	cmp    0x30(%r15),%rbx
   9340c:	0f 87 0b 02 00 00    	ja     9361d <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x72d>
   93412:	45 31 e4             	xor    %r12d,%r12d
   93415:	48 85 db             	test   %rbx,%rbx
   93418:	74 1a                	je     93434 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x544>
   9341a:	4a 8d 3c e5 00 00 00 	lea    0x0(,%r12,8),%rdi
   93421:	00 
   93422:	49 03 7f 38          	add    0x38(%r15),%rdi
   93426:	48 8d 14 dd 00 00 00 	lea    0x0(,%rbx,8),%rdx
   9342d:	00 
   9342e:	ff 15 1c f0 05 00    	call   *0x5f01c(%rip)        # f2450 <memcpy@GLIBC_2.14>
   93434:	49 01 dc             	add    %rbx,%r12
   93437:	4d 89 67 40          	mov    %r12,0x40(%r15)
   9343b:	48 83 7c 24 78 00    	cmpq   $0x0,0x78(%rsp)
   93441:	4c 8b 6c 24 48       	mov    0x48(%rsp),%r13
   93446:	0f 84 55 01 00 00    	je     935a1 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x6b1>
   9344c:	48 8b 04 24          	mov    (%rsp),%rax
   93450:	48 8b 58 20          	mov    0x20(%rax),%rbx
   93454:	4c 8b 70 38          	mov    0x38(%rax),%r14
   93458:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   9345d:	48 f7 d8             	neg    %rax
   93460:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
   93465:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   9346a:	48 f7 d8             	neg    %rax
   9346d:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
   93472:	45 31 ff             	xor    %r15d,%r15d
   93475:	eb 1b                	jmp    93492 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x5a2>
   93477:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   9347e:	00 00 
   93480:	49 83 c5 04          	add    $0x4,%r13
   93484:	41 ff c7             	inc    %r15d
   93487:	4c 3b 6c 24 50       	cmp    0x50(%rsp),%r13
   9348c:	0f 84 0f 01 00 00    	je     935a1 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x6b1>
   93492:	41 8b 55 00          	mov    0x0(%r13),%edx
   93496:	48 8d bc 24 b8 00 00 	lea    0xb8(%rsp),%rdi
   9349d:	00 
   9349e:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
   934a3:	e8 08 02 00 00       	call   936b0 <<gpui_canvas::canvas::DisplayList>::get>
   934a8:	83 bc 24 b8 00 00 00 	cmpl   $0xffffffff,0xb8(%rsp)
   934af:	ff 
   934b0:	0f 84 eb 00 00 00    	je     935a1 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x6b1>
   934b6:	48 8b 8c 24 30 01 00 	mov    0x130(%rsp),%rcx
   934bd:	00 
   934be:	48 c1 e9 04          	shr    $0x4,%rcx
   934c2:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   934c7:	48 39 c8             	cmp    %rcx,%rax
   934ca:	48 0f 47 c8          	cmova  %rax,%rcx
   934ce:	48 8b 84 24 40 01 00 	mov    0x140(%rsp),%rax
   934d5:	00 
   934d6:	48 89 c2             	mov    %rax,%rdx
   934d9:	48 c1 ea 04          	shr    $0x4,%rdx
   934dd:	83 e0 0f             	and    $0xf,%eax
   934e0:	48 83 f8 01          	cmp    $0x1,%rax
   934e4:	48 83 da ff          	sbb    $0xffffffffffffffff,%rdx
   934e8:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
   934ed:	48 39 d0             	cmp    %rdx,%rax
   934f0:	48 0f 42 d0          	cmovb  %rax,%rdx
   934f4:	48 39 d1             	cmp    %rdx,%rcx
   934f7:	73 87                	jae    93480 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x590>
   934f9:	48 8b 84 24 28 01 00 	mov    0x128(%rsp),%rax
   93500:	00 
   93501:	48 c1 e8 04          	shr    $0x4,%rax
   93505:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
   9350a:	48 39 c6             	cmp    %rax,%rsi
   9350d:	48 0f 47 c6          	cmova  %rsi,%rax
   93511:	48 8b b4 24 38 01 00 	mov    0x138(%rsp),%rsi
   93518:	00 
   93519:	49 89 f0             	mov    %rsi,%r8
   9351c:	49 c1 e8 04          	shr    $0x4,%r8
   93520:	83 e6 0f             	and    $0xf,%esi
   93523:	48 83 fe 01          	cmp    $0x1,%rsi
   93527:	49 83 d8 ff          	sbb    $0xffffffffffffffff,%r8
   9352b:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
   93530:	4c 39 c6             	cmp    %r8,%rsi
   93533:	4c 0f 42 c6          	cmovb  %rsi,%r8
   93537:	49 29 c0             	sub    %rax,%r8
   9353a:	0f 86 40 ff ff ff    	jbe    93480 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x590>
   93540:	48 03 44 24 20       	add    0x20(%rsp),%rax
   93545:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
   9354a:	4c 8d 0c 0e          	lea    (%rsi,%rcx,1),%r9
   9354e:	4c 0f af 4c 24 28    	imul   0x28(%rsp),%r9
   93554:	49 01 c1             	add    %rax,%r9
   93557:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   9355e:	00 00 
   93560:	48 ff c1             	inc    %rcx
   93563:	4c 89 cf             	mov    %r9,%rdi
   93566:	4d 89 c2             	mov    %r8,%r10
   93569:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   93570:	4c 39 e7             	cmp    %r12,%rdi
   93573:	73 76                	jae    935eb <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x6fb>
   93575:	49 8b 04 fe          	mov    (%r14,%rdi,8),%rax
   93579:	48 8b 75 00          	mov    0x0(%rbp),%rsi
   9357d:	48 39 f0             	cmp    %rsi,%rax
   93580:	73 59                	jae    935db <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x6eb>
   93582:	44 89 3c 83          	mov    %r15d,(%rbx,%rax,4)
   93586:	49 ff 04 fe          	incq   (%r14,%rdi,8)
   9358a:	48 ff c7             	inc    %rdi
   9358d:	49 ff ca             	dec    %r10
   93590:	75 de                	jne    93570 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x680>
   93592:	4c 03 4c 24 28       	add    0x28(%rsp),%r9
   93597:	48 39 d1             	cmp    %rdx,%rcx
   9359a:	75 c4                	jne    93560 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x670>
   9359c:	e9 df fe ff ff       	jmp    93480 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x590>
   935a1:	48 8b 04 24          	mov    (%rsp),%rax
   935a5:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
   935aa:	48 89 48 48          	mov    %rcx,0x48(%rax)
   935ae:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
   935b3:	48 39 c8             	cmp    %rcx,%rax
   935b6:	0f 94 c0             	sete   %al
   935b9:	48 81 c4 48 01 00 00 	add    $0x148,%rsp
   935c0:	5b                   	pop    %rbx
   935c1:	41 5c                	pop    %r12
   935c3:	41 5d                	pop    %r13
   935c5:	41 5e                	pop    %r14
   935c7:	41 5f                	pop    %r15
   935c9:	5d                   	pop    %rbp
   935ca:	c3                   	ret
   935cb:	48 8d 15 4e c1 05 00 	lea    0x5c14e(%rip),%rdx        # ef720 <anon.8aced7916e4994fc22cafcb95f7e96d1.24.llvm.5645081430854820144+0x48>
   935d2:	4c 89 e6             	mov    %r12,%rsi
   935d5:	ff 15 25 ee 05 00    	call   *0x5ee25(%rip)        # f2400 <_DYNAMIC+0x278>
   935db:	48 8d 15 26 c1 05 00 	lea    0x5c126(%rip),%rdx        # ef708 <anon.8aced7916e4994fc22cafcb95f7e96d1.24.llvm.5645081430854820144+0x30>
   935e2:	48 89 c7             	mov    %rax,%rdi
   935e5:	ff 15 15 ee 05 00    	call   *0x5ee15(%rip)        # f2400 <_DYNAMIC+0x278>
   935eb:	48 8d 15 fe c0 05 00 	lea    0x5c0fe(%rip),%rdx        # ef6f0 <anon.8aced7916e4994fc22cafcb95f7e96d1.24.llvm.5645081430854820144+0x18>
   935f2:	4c 89 e6             	mov    %r12,%rsi
   935f5:	ff 15 05 ee 05 00    	call   *0x5ee05(%rip)        # f2400 <_DYNAMIC+0x278>
   935fb:	48 8d 0d 4e c1 05 00 	lea    0x5c14e(%rip),%rcx        # ef750 <anon.8aced7916e4994fc22cafcb95f7e96d1.24.llvm.5645081430854820144+0x78>
   93602:	31 ff                	xor    %edi,%edi
   93604:	48 89 de             	mov    %rbx,%rsi
   93607:	4c 89 e2             	mov    %r12,%rdx
   9360a:	ff 15 18 f1 05 00    	call   *0x5f118(%rip)        # f2728 <_DYNAMIC+0x5a0>
   93610:	48 8d 3d 21 c1 05 00 	lea    0x5c121(%rip),%rdi        # ef738 <anon.8aced7916e4994fc22cafcb95f7e96d1.24.llvm.5645081430854820144+0x60>
   93617:	ff 15 4b ee 05 00    	call   *0x5ee4b(%rip)        # f2468 <_DYNAMIC+0x2e0>
   9361d:	49 8d 7f 30          	lea    0x30(%r15),%rdi
   93621:	b9 08 00 00 00       	mov    $0x8,%ecx
   93626:	41 b8 08 00 00 00    	mov    $0x8,%r8d
   9362c:	48 89 f3             	mov    %rsi,%rbx
   9362f:	31 f6                	xor    %esi,%esi
   93631:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
   93636:	e8 25 93 ff ff       	call   8c960 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
   9363b:	48 89 de             	mov    %rbx,%rsi
   9363e:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
   93643:	4d 8b 67 40          	mov    0x40(%r15),%r12
   93647:	e9 ce fd ff ff       	jmp    9341a <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x52a>
   9364c:	49 8d 7f 18          	lea    0x18(%r15),%rdi
   93650:	b9 04 00 00 00       	mov    $0x4,%ecx
   93655:	41 b8 04 00 00 00    	mov    $0x4,%r8d
   9365b:	31 f6                	xor    %esi,%esi
   9365d:	4c 89 ea             	mov    %r13,%rdx
   93660:	e8 fb 92 ff ff       	call   8c960 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
   93665:	49 8b 5f 28          	mov    0x28(%r15),%rbx
   93669:	4d 8b 77 20          	mov    0x20(%r15),%r14
   9366d:	49 8d 3c 9e          	lea    (%r14,%rbx,4),%rdi
   93671:	49 83 fd 01          	cmp    $0x1,%r13
   93675:	0f 85 15 fd ff ff    	jne    93390 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x4a0>
   9367b:	e9 32 fd ff ff       	jmp    933b2 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x4c2>
   93680:	b9 08 00 00 00       	mov    $0x8,%ecx
   93685:	41 b8 08 00 00 00    	mov    $0x8,%r8d
   9368b:	4c 89 f7             	mov    %r14,%rdi
   9368e:	31 f6                	xor    %esi,%esi
   93690:	e8 cb 92 ff ff       	call   8c960 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
   93695:	4c 89 f7             	mov    %r14,%rdi
   93698:	4d 8b 66 10          	mov    0x10(%r14),%r12
   9369c:	e9 fe f8 ff ff       	jmp    92f9f <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0xaf>
