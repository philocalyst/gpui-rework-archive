
/tmp/gpui-bin-miss-artifacts/subset-7a94cb136a993e1a535332d17901b00336dce182a216184f06849274703270de:     file format elf64-x86-64


Disassembly of section .text:

0000000000092e60 <<gpui_canvas::canvas::bins::RasterScratch>::prepare>:
   92e60:	55                   	push   %rbp
   92e61:	41 57                	push   %r15
   92e63:	41 56                	push   %r14
   92e65:	41 55                	push   %r13
   92e67:	41 54                	push   %r12
   92e69:	53                   	push   %rbx
   92e6a:	48 81 ec d8 00 00 00 	sub    $0xd8,%rsp
   92e71:	4c 8b 02             	mov    (%rdx),%r8
   92e74:	4c 8b 7a 08          	mov    0x8(%rdx),%r15
   92e78:	66 44 39 47 48       	cmp    %r8w,0x48(%rdi)
   92e7d:	0f 96 c0             	setbe  %al
   92e80:	66 44 39 7f 4a       	cmp    %r15w,0x4a(%rdi)
   92e85:	0f 96 c1             	setbe  %cl
   92e88:	4c 8b 52 10          	mov    0x10(%rdx),%r10
   92e8c:	20 c1                	and    %al,%cl
   92e8e:	66 44 39 57 4c       	cmp    %r10w,0x4c(%rdi)
   92e93:	4c 8b 4a 18          	mov    0x18(%rdx),%r9
   92e97:	0f 93 c2             	setae  %dl
   92e9a:	66 44 39 4f 4e       	cmp    %r9w,0x4e(%rdi)
   92e9f:	48 89 74 24 48       	mov    %rsi,0x48(%rsp)
   92ea4:	0f 93 c0             	setae  %al
   92ea7:	20 d0                	and    %dl,%al
   92ea9:	20 c8                	and    %cl,%al
   92eab:	0f 85 ea 07 00 00    	jne    9369b <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x83b>
   92eb1:	88 44 24 17          	mov    %al,0x17(%rsp)
   92eb5:	48 c7 47 48 00 00 00 	movq   $0x0,0x48(%rdi)
   92ebc:	00 
   92ebd:	4c 89 d0             	mov    %r10,%rax
   92ec0:	4c 29 c0             	sub    %r8,%rax
   92ec3:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
   92ec8:	4c 89 ca             	mov    %r9,%rdx
   92ecb:	4c 29 fa             	sub    %r15,%rdx
   92ece:	48 0f af d0          	imul   %rax,%rdx
   92ed2:	48 c7 47 10 00 00 00 	movq   $0x0,0x10(%rdi)
   92ed9:	00 
   92eda:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
   92edf:	48 ff c2             	inc    %rdx
   92ee2:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
   92ee7:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
   92eec:	4c 89 4c 24 50       	mov    %r9,0x50(%rsp)
   92ef1:	4c 89 54 24 38       	mov    %r10,0x38(%rsp)
   92ef6:	75 05                	jne    92efd <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x9d>
   92ef8:	45 31 e4             	xor    %r12d,%r12d
   92efb:	eb 47                	jmp    92f44 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0xe4>
   92efd:	48 3b 17             	cmp    (%rdi),%rdx
   92f00:	0f 87 78 08 00 00    	ja     9377e <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x91e>
   92f06:	45 31 e4             	xor    %r12d,%r12d
   92f09:	48 8b 5f 08          	mov    0x8(%rdi),%rbx
   92f0d:	4a 8d 3c e3          	lea    (%rbx,%r12,8),%rdi
   92f11:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   92f16:	48 85 c0             	test   %rax,%rax
   92f19:	74 1a                	je     92f35 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0xd5>
   92f1b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   92f22:	00 
   92f23:	31 f6                	xor    %esi,%esi
   92f25:	49 89 c6             	mov    %rax,%r14
   92f28:	ff 15 6a f5 05 00    	call   *0x5f56a(%rip)        # f2498 <memset@GLIBC_2.2.5>
   92f2e:	4d 01 f4             	add    %r14,%r12
   92f31:	4a 8d 3c e3          	lea    (%rbx,%r12,8),%rdi
   92f35:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
   92f3c:	49 ff c4             	inc    %r12
   92f3f:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
   92f44:	4c 89 67 10          	mov    %r12,0x10(%rdi)
   92f48:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
   92f4d:	48 8b 41 78          	mov    0x78(%rcx),%rax
   92f51:	48 8b 89 80 00 00 00 	mov    0x80(%rcx),%rcx
   92f58:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
   92f5d:	48 8d 04 88          	lea    (%rax,%rcx,4),%rax
   92f61:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
   92f68:	00 
   92f69:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
   92f70:	00 
   92f71:	48 85 c9             	test   %rcx,%rcx
   92f74:	4c 89 7c 24 58       	mov    %r15,0x58(%rsp)
   92f79:	0f 84 6a 03 00 00    	je     932e9 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x489>
   92f7f:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
   92f84:	48 8b 88 90 00 00 00 	mov    0x90(%rax),%rcx
   92f8b:	48 89 8c 24 c0 00 00 	mov    %rcx,0xc0(%rsp)
   92f92:	00 
   92f93:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
   92f9a:	48 89 8c 24 80 00 00 	mov    %rcx,0x80(%rsp)
   92fa1:	00 
   92fa2:	48 8b 88 f8 00 00 00 	mov    0xf8(%rax),%rcx
   92fa9:	48 89 8c 24 88 00 00 	mov    %rcx,0x88(%rsp)
   92fb0:	00 
   92fb1:	48 8b 80 f0 00 00 00 	mov    0xf0(%rax),%rax
   92fb8:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
   92fbf:	00 
   92fc0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   92fc5:	4c 8b 40 08          	mov    0x8(%rax),%r8
   92fc9:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
   92fce:	48 89 c8             	mov    %rcx,%rax
   92fd1:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
   92fd6:	48 29 d0             	sub    %rdx,%rax
   92fd9:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
   92fde:	48 8d 04 cd 00 00 00 	lea    0x0(,%rcx,8),%rax
   92fe5:	00 
   92fe6:	4c 89 c6             	mov    %r8,%rsi
   92fe9:	48 29 c6             	sub    %rax,%rsi
   92fec:	48 83 c6 18          	add    $0x18,%rsi
   92ff0:	48 89 b4 24 b8 00 00 	mov    %rsi,0xb8(%rsp)
   92ff7:	00 
   92ff8:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
   92ffd:	48 8d 34 f5 00 00 00 	lea    0x0(,%rsi,8),%rsi
   93004:	00 
   93005:	48 89 b4 24 b0 00 00 	mov    %rsi,0xb0(%rsp)
   9300c:	00 
   9300d:	48 8d 14 d5 00 00 00 	lea    0x0(,%rdx,8),%rdx
   93014:	00 
   93015:	48 29 c2             	sub    %rax,%rdx
   93018:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
   9301d:	b8 01 00 00 00       	mov    $0x1,%eax
   93022:	48 29 c8             	sub    %rcx,%rax
   93025:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
   9302c:	00 
   9302d:	48 8d 41 ff          	lea    -0x1(%rcx),%rax
   93031:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
   93038:	00 
   93039:	66 0f 76 c0          	pcmpeqd %xmm0,%xmm0
   9303d:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
   93042:	eb 2b                	jmp    9306f <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x20f>
   93044:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   9304b:	00 00 00 00 00 
   93050:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
   93057:	00 
   93058:	48 83 c0 04          	add    $0x4,%rax
   9305c:	48 3b 84 24 90 00 00 	cmp    0x90(%rsp),%rax
   93063:	00 
   93064:	4c 8b 7c 24 58       	mov    0x58(%rsp),%r15
   93069:	0f 84 7a 02 00 00    	je     932e9 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x489>
   9306f:	48 63 38             	movslq (%rax),%rdi
   93072:	48 85 ff             	test   %rdi,%rdi
   93075:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
   9307c:	00 
   9307d:	78 31                	js     930b0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x250>
   9307f:	48 39 bc 24 88 00 00 	cmp    %rdi,0x88(%rsp)
   93086:	00 
   93087:	0f 86 16 07 00 00    	jbe    937a3 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x943>
   9308d:	48 c1 e7 05          	shl    $0x5,%rdi
   93091:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
   93098:	00 
   93099:	48 01 f8             	add    %rdi,%rax
   9309c:	48 83 c0 10          	add    $0x10,%rax
   930a0:	eb 35                	jmp    930d7 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x277>
   930a2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   930a9:	1f 84 00 00 00 00 00 
   930b0:	81 e7 ff ff ff 7f    	and    $0x7fffffff,%edi
   930b6:	48 39 bc 24 80 00 00 	cmp    %rdi,0x80(%rsp)
   930bd:	00 
   930be:	0f 86 06 07 00 00    	jbe    937ca <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x96a>
   930c4:	48 6b c7 68          	imul   $0x68,%rdi,%rax
   930c8:	48 8b 8c 24 c0 00 00 	mov    0xc0(%rsp),%rcx
   930cf:	00 
   930d0:	48 01 c8             	add    %rcx,%rax
   930d3:	48 83 c0 60          	add    $0x60,%rax
   930d7:	48 8b 08             	mov    (%rax),%rcx
   930da:	89 ce                	mov    %ecx,%esi
   930dc:	c1 ee 14             	shr    $0x14,%esi
   930df:	49 39 f7             	cmp    %rsi,%r15
   930e2:	49 0f 47 f7          	cmova  %r15,%rsi
   930e6:	49 89 ca             	mov    %rcx,%r10
   930e9:	49 c1 ea 34          	shr    $0x34,%r10
   930ed:	48 89 c8             	mov    %rcx,%rax
   930f0:	48 ba 00 00 00 00 00 	movabs $0xf000000000000,%rdx
   930f7:	00 0f 00 
   930fa:	48 21 d0             	and    %rdx,%rax
   930fd:	48 83 f8 01          	cmp    $0x1,%rax
   93101:	49 83 da ff          	sbb    $0xffffffffffffffff,%r10
   93105:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
   9310a:	4c 39 d0             	cmp    %r10,%rax
   9310d:	4c 0f 42 d0          	cmovb  %rax,%r10
   93111:	4c 39 d6             	cmp    %r10,%rsi
   93114:	4c 8b 7c 24 30       	mov    0x30(%rsp),%r15
   93119:	0f 83 31 ff ff ff    	jae    93050 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x1f0>
   9311f:	89 ca                	mov    %ecx,%edx
   93121:	c1 ea 04             	shr    $0x4,%edx
   93124:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
   9312a:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
   9312f:	48 39 d0             	cmp    %rdx,%rax
   93132:	48 0f 47 d0          	cmova  %rax,%rdx
   93136:	48 89 cf             	mov    %rcx,%rdi
   93139:	48 c1 ef 24          	shr    $0x24,%rdi
   9313d:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
   93143:	48 b8 00 00 00 00 0f 	movabs $0xf00000000,%rax
   9314a:	00 00 00 
   9314d:	48 21 c1             	and    %rax,%rcx
   93150:	48 83 f9 01          	cmp    $0x1,%rcx
   93154:	48 83 df ff          	sbb    $0xffffffffffffffff,%rdi
   93158:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   9315d:	48 39 f8             	cmp    %rdi,%rax
   93160:	48 0f 42 f8          	cmovb  %rax,%rdi
   93164:	48 39 fa             	cmp    %rdi,%rdx
   93167:	0f 83 e3 fe ff ff    	jae    93050 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x1f0>
   9316d:	48 89 f8             	mov    %rdi,%rax
   93170:	49 89 d3             	mov    %rdx,%r11
   93173:	49 f7 d3             	not    %r11
   93176:	49 89 fd             	mov    %rdi,%r13
   93179:	49 01 c3             	add    %rax,%r11
   9317c:	48 89 d1             	mov    %rdx,%rcx
   9317f:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
   93184:	48 29 c1             	sub    %rax,%rcx
   93187:	48 89 f7             	mov    %rsi,%rdi
   9318a:	48 2b 7c 24 58       	sub    0x58(%rsp),%rdi
   9318f:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
   93194:	48 0f af df          	imul   %rdi,%rbx
   93198:	48 01 d9             	add    %rbx,%rcx
   9319b:	48 ff c1             	inc    %rcx
   9319e:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
   931a3:	48 89 d9             	mov    %rbx,%rcx
   931a6:	48 f7 d1             	not    %rcx
   931a9:	48 01 c1             	add    %rax,%rcx
   931ac:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
   931b1:	48 29 d1             	sub    %rdx,%rcx
   931b4:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
   931b9:	48 0f af bc 24 b0 00 	imul   0xb0(%rsp),%rdi
   931c0:	00 00 
   931c2:	48 8d 2c d7          	lea    (%rdi,%rdx,8),%rbp
   931c6:	48 03 ac 24 b8 00 00 	add    0xb8(%rsp),%rbp
   931cd:	00 
   931ce:	48 8b 8c 24 a8 00 00 	mov    0xa8(%rsp),%rcx
   931d5:	00 
   931d6:	4c 8d 0c 11          	lea    (%rcx,%rdx,1),%r9
   931da:	49 01 d9             	add    %rbx,%r9
   931dd:	4c 8b b4 24 a0 00 00 	mov    0xa0(%rsp),%r14
   931e4:	00 
   931e5:	49 29 de             	sub    %rbx,%r14
   931e8:	49 29 d6             	sub    %rdx,%r14
   931eb:	49 f7 dd             	neg    %r13
   931ee:	4c 89 6c 24 40       	mov    %r13,0x40(%rsp)
   931f3:	48 01 cb             	add    %rcx,%rbx
   931f6:	31 c9                	xor    %ecx,%ecx
   931f8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   931ff:	00 
   93200:	4d 39 cc             	cmp    %r9,%r12
   93203:	4d 89 cd             	mov    %r9,%r13
   93206:	4d 0f 47 ec          	cmova  %r12,%r13
   9320a:	4d 01 f5             	add    %r14,%r13
   9320d:	4d 39 eb             	cmp    %r13,%r11
   93210:	4d 0f 42 eb          	cmovb  %r11,%r13
   93214:	48 89 c7             	mov    %rax,%rdi
   93217:	48 0f af f9          	imul   %rcx,%rdi
   9321b:	48 03 7c 24 70       	add    0x70(%rsp),%rdi
   93220:	49 39 fc             	cmp    %rdi,%r12
   93223:	49 0f 47 fc          	cmova  %r12,%rdi
   93227:	4c 0f af f9          	imul   %rcx,%r15
   9322b:	4c 03 7c 24 68       	add    0x68(%rsp),%r15
   93230:	49 01 ff             	add    %rdi,%r15
   93233:	4d 39 fb             	cmp    %r15,%r11
   93236:	4d 0f 42 fb          	cmovb  %r11,%r15
   9323a:	49 ff c7             	inc    %r15
   9323d:	48 89 d7             	mov    %rdx,%rdi
   93240:	49 83 ff 05          	cmp    $0x5,%r15
   93244:	72 5c                	jb     932a2 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x442>
   93246:	44 89 f8             	mov    %r15d,%eax
   93249:	83 e0 03             	and    $0x3,%eax
   9324c:	bf 04 00 00 00       	mov    $0x4,%edi
   93251:	48 0f 44 c7          	cmove  %rdi,%rax
   93255:	49 29 c7             	sub    %rax,%r15
   93258:	4c 89 ff             	mov    %r15,%rdi
   9325b:	48 01 d7             	add    %rdx,%rdi
   9325e:	49 29 c5             	sub    %rax,%r13
   93261:	49 ff c5             	inc    %r13
   93264:	45 31 ff             	xor    %r15d,%r15d
   93267:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   9326e:	00 00 
   93270:	f3 42 0f 6f 4c fd f0 	movdqu -0x10(%rbp,%r15,8),%xmm1
   93277:	f3 42 0f 6f 54 fd 00 	movdqu 0x0(%rbp,%r15,8),%xmm2
   9327e:	66 0f fb c8          	psubq  %xmm0,%xmm1
   93282:	66 0f fb d0          	psubq  %xmm0,%xmm2
   93286:	f3 42 0f 7f 4c fd f0 	movdqu %xmm1,-0x10(%rbp,%r15,8)
   9328d:	f3 42 0f 7f 54 fd 00 	movdqu %xmm2,0x0(%rbp,%r15,8)
   93294:	49 83 c7 04          	add    $0x4,%r15
   93298:	4d 39 fd             	cmp    %r15,%r13
   9329b:	75 d3                	jne    93270 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x410>
   9329d:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
   932a2:	48 ff c6             	inc    %rsi
   932a5:	4c 8b 7c 24 40       	mov    0x40(%rsp),%r15
   932aa:	49 01 ff             	add    %rdi,%r15
   932ad:	48 01 df             	add    %rbx,%rdi
   932b0:	4c 39 e7             	cmp    %r12,%rdi
   932b3:	0f 83 f4 03 00 00    	jae    936ad <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x84d>
   932b9:	49 ff 04 f8          	incq   (%r8,%rdi,8)
   932bd:	48 ff c7             	inc    %rdi
   932c0:	49 ff c7             	inc    %r15
   932c3:	75 eb                	jne    932b0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x450>
   932c5:	48 ff c1             	inc    %rcx
   932c8:	48 03 6c 24 60       	add    0x60(%rsp),%rbp
   932cd:	49 01 c1             	add    %rax,%r9
   932d0:	4c 8b 7c 24 30       	mov    0x30(%rsp),%r15
   932d5:	4d 01 fe             	add    %r15,%r14
   932d8:	48 01 c3             	add    %rax,%rbx
   932db:	4c 39 d6             	cmp    %r10,%rsi
   932de:	0f 85 1c ff ff ff    	jne    93200 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x3a0>
   932e4:	e9 67 fd ff ff       	jmp    93050 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x1f0>
   932e9:	49 83 fc 02          	cmp    $0x2,%r12
   932ed:	72 30                	jb     9331f <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x4bf>
   932ef:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   932f4:	48 8b 40 08          	mov    0x8(%rax),%rax
   932f8:	48 8b 08             	mov    (%rax),%rcx
   932fb:	49 8d 7c 24 ff       	lea    -0x1(%r12),%rdi
   93300:	4d 8d 44 24 fe       	lea    -0x2(%r12),%r8
   93305:	89 fa                	mov    %edi,%edx
   93307:	83 e2 03             	and    $0x3,%edx
   9330a:	be 01 00 00 00       	mov    $0x1,%esi
   9330f:	49 83 f8 03          	cmp    $0x3,%r8
   93313:	73 42                	jae    93357 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x4f7>
   93315:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
   9331a:	e9 7f 00 00 00       	jmp    9339e <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x53e>
   9331f:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
   93324:	48 c7 41 28 00 00 00 	movq   $0x0,0x28(%rcx)
   9332b:	00 
   9332c:	4d 85 e4             	test   %r12,%r12
   9332f:	0f 84 c0 03 00 00    	je     936f5 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x895>
   93335:	48 8d 69 28          	lea    0x28(%rcx),%rbp
   93339:	48 8b 41 08          	mov    0x8(%rcx),%rax
   9333d:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
   93342:	4e 8b 6c e0 f8       	mov    -0x8(%rax,%r12,8),%r13
   93347:	4d 85 ed             	test   %r13,%r13
   9334a:	0f 85 8f 00 00 00    	jne    933df <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x57f>
   93350:	31 db                	xor    %ebx,%ebx
   93352:	e9 db 00 00 00       	jmp    93432 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x5d2>
   93357:	48 83 e7 fc          	and    $0xfffffffffffffffc,%rdi
   9335b:	31 f6                	xor    %esi,%esi
   9335d:	0f 1f 00             	nopl   (%rax)
   93360:	48 03 4c f0 08       	add    0x8(%rax,%rsi,8),%rcx
   93365:	48 89 4c f0 08       	mov    %rcx,0x8(%rax,%rsi,8)
   9336a:	48 03 4c f0 10       	add    0x10(%rax,%rsi,8),%rcx
   9336f:	48 89 4c f0 10       	mov    %rcx,0x10(%rax,%rsi,8)
   93374:	48 03 4c f0 18       	add    0x18(%rax,%rsi,8),%rcx
   93379:	48 89 4c f0 18       	mov    %rcx,0x18(%rax,%rsi,8)
   9337e:	48 03 4c f0 20       	add    0x20(%rax,%rsi,8),%rcx
   93383:	48 89 4c f0 20       	mov    %rcx,0x20(%rax,%rsi,8)
   93388:	48 83 c6 04          	add    $0x4,%rsi
   9338c:	48 39 f7             	cmp    %rsi,%rdi
   9338f:	75 cf                	jne    93360 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x500>
   93391:	48 85 d2             	test   %rdx,%rdx
   93394:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
   93399:	74 25                	je     933c0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x560>
   9339b:	48 ff c6             	inc    %rsi
   9339e:	48 8d 34 f0          	lea    (%rax,%rsi,8),%rsi
   933a2:	31 ff                	xor    %edi,%edi
   933a4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   933ab:	00 00 00 00 00 
   933b0:	48 03 0c fe          	add    (%rsi,%rdi,8),%rcx
   933b4:	48 89 0c fe          	mov    %rcx,(%rsi,%rdi,8)
   933b8:	48 ff c7             	inc    %rdi
   933bb:	48 39 fa             	cmp    %rdi,%rdx
   933be:	75 f0                	jne    933b0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x550>
   933c0:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
   933c5:	48 8d 69 28          	lea    0x28(%rcx),%rbp
   933c9:	48 c7 41 28 00 00 00 	movq   $0x0,0x28(%rcx)
   933d0:	00 
   933d1:	4e 8b 6c e0 f8       	mov    -0x8(%rax,%r12,8),%r13
   933d6:	4d 85 ed             	test   %r13,%r13
   933d9:	0f 84 71 ff ff ff    	je     93350 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x4f0>
   933df:	4c 3b 69 18          	cmp    0x18(%rcx),%r13
   933e3:	0f 87 52 03 00 00    	ja     9373b <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x8db>
   933e9:	31 db                	xor    %ebx,%ebx
   933eb:	4c 8b 71 20          	mov    0x20(%rcx),%r14
   933ef:	49 8d 3c 9e          	lea    (%r14,%rbx,4),%rdi
   933f3:	49 83 fd 01          	cmp    $0x1,%r13
   933f7:	74 27                	je     93420 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x5c0>
   933f9:	4a 8d 14 ad fc ff ff 	lea    -0x4(,%r13,4),%rdx
   93400:	ff 
   93401:	31 f6                	xor    %esi,%esi
   93403:	ff 15 8f f0 05 00    	call   *0x5f08f(%rip)        # f2498 <memset@GLIBC_2.2.5>
   93409:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
   9340e:	4a 8d 04 2b          	lea    (%rbx,%r13,1),%rax
   93412:	49 8d 3c 86          	lea    (%r14,%rax,4),%rdi
   93416:	48 83 c7 fc          	add    $0xfffffffffffffffc,%rdi
   9341a:	4c 01 eb             	add    %r13,%rbx
   9341d:	48 ff cb             	dec    %rbx
   93420:	c7 07 00 00 00 00    	movl   $0x0,(%rdi)
   93426:	48 ff c3             	inc    %rbx
   93429:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
   9342e:	4c 8b 61 10          	mov    0x10(%rcx),%r12
   93432:	48 89 59 28          	mov    %rbx,0x28(%rcx)
   93436:	48 c7 41 40 00 00 00 	movq   $0x0,0x40(%rcx)
   9343d:	00 
   9343e:	4d 39 e0             	cmp    %r12,%r8
   93441:	0f 87 99 02 00 00    	ja     936e0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x880>
   93447:	48 8b 71 08          	mov    0x8(%rcx),%rsi
   9344b:	4c 3b 41 30          	cmp    0x30(%rcx),%r8
   9344f:	0f 87 ad 02 00 00    	ja     93702 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x8a2>
   93455:	45 31 e4             	xor    %r12d,%r12d
   93458:	4d 85 c0             	test   %r8,%r8
   9345b:	74 29                	je     93486 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x626>
   9345d:	4a 8d 3c e5 00 00 00 	lea    0x0(,%r12,8),%rdi
   93464:	00 
   93465:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   9346a:	48 03 78 38          	add    0x38(%rax),%rdi
   9346e:	4a 8d 14 c5 00 00 00 	lea    0x0(,%r8,8),%rdx
   93475:	00 
   93476:	ff 15 8c ef 05 00    	call   *0x5ef8c(%rip)        # f2408 <memcpy@GLIBC_2.14>
   9347c:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
   93481:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
   93486:	4d 01 c4             	add    %r8,%r12
   93489:	4c 89 61 40          	mov    %r12,0x40(%rcx)
   9348d:	48 83 bc 24 98 00 00 	cmpq   $0x0,0x98(%rsp)
   93494:	00 00 
   93496:	48 8b 54 24 78       	mov    0x78(%rsp),%rdx
   9349b:	0f 84 c8 01 00 00    	je     93669 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x809>
   934a1:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
   934a6:	48 8b 88 90 00 00 00 	mov    0x90(%rax),%rcx
   934ad:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
   934b2:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
   934b9:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
   934be:	48 8b 88 f8 00 00 00 	mov    0xf8(%rax),%rcx
   934c5:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
   934ca:	4c 8b 88 f0 00 00 00 	mov    0xf0(%rax),%r9
   934d1:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
   934d6:	4c 8b 51 20          	mov    0x20(%rcx),%r10
   934da:	4c 8b 59 38          	mov    0x38(%rcx),%r11
   934de:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
   934e3:	48 f7 d8             	neg    %rax
   934e6:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
   934eb:	4c 89 f8             	mov    %r15,%rax
   934ee:	48 f7 d8             	neg    %rax
   934f1:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
   934f6:	45 31 ed             	xor    %r13d,%r13d
   934f9:	eb 22                	jmp    9351d <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x6bd>
   934fb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   93500:	48 89 c2             	mov    %rax,%rdx
   93503:	48 83 c2 04          	add    $0x4,%rdx
   93507:	41 ff c5             	inc    %r13d
   9350a:	48 3b 94 24 90 00 00 	cmp    0x90(%rsp),%rdx
   93511:	00 
   93512:	4c 8b 7c 24 58       	mov    0x58(%rsp),%r15
   93517:	0f 84 4c 01 00 00    	je     93669 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x809>
   9351d:	48 89 d0             	mov    %rdx,%rax
   93520:	48 63 3a             	movslq (%rdx),%rdi
   93523:	48 85 ff             	test   %rdi,%rdi
   93526:	78 28                	js     93550 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x6f0>
   93528:	48 39 7c 24 30       	cmp    %rdi,0x30(%rsp)
   9352d:	0f 86 85 02 00 00    	jbe    937b8 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x958>
   93533:	48 c1 e7 05          	shl    $0x5,%rdi
   93537:	49 8d 0c 39          	lea    (%r9,%rdi,1),%rcx
   9353b:	48 83 c1 10          	add    $0x10,%rcx
   9353f:	eb 30                	jmp    93571 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x711>
   93541:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   93548:	0f 1f 84 00 00 00 00 
   9354f:	00 
   93550:	81 e7 ff ff ff 7f    	and    $0x7fffffff,%edi
   93556:	48 39 7c 24 40       	cmp    %rdi,0x40(%rsp)
   9355b:	0f 86 7e 02 00 00    	jbe    937df <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x97f>
   93561:	48 6b cf 68          	imul   $0x68,%rdi,%rcx
   93565:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
   9356a:	48 01 d1             	add    %rdx,%rcx
   9356d:	48 83 c1 60          	add    $0x60,%rcx
   93571:	48 8b 09             	mov    (%rcx),%rcx
   93574:	41 89 ce             	mov    %ecx,%r14d
   93577:	41 c1 ee 14          	shr    $0x14,%r14d
   9357b:	4d 39 f7             	cmp    %r14,%r15
   9357e:	4d 0f 47 f7          	cmova  %r15,%r14
   93582:	48 89 cb             	mov    %rcx,%rbx
   93585:	48 c1 eb 34          	shr    $0x34,%rbx
   93589:	48 89 ca             	mov    %rcx,%rdx
   9358c:	48 be 00 00 00 00 00 	movabs $0xf000000000000,%rsi
   93593:	00 0f 00 
   93596:	48 21 f2             	and    %rsi,%rdx
   93599:	48 83 fa 01          	cmp    $0x1,%rdx
   9359d:	48 83 db ff          	sbb    $0xffffffffffffffff,%rbx
   935a1:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
   935a6:	48 39 da             	cmp    %rbx,%rdx
   935a9:	48 0f 42 da          	cmovb  %rdx,%rbx
   935ad:	49 39 de             	cmp    %rbx,%r14
   935b0:	0f 83 4a ff ff ff    	jae    93500 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x6a0>
   935b6:	89 cf                	mov    %ecx,%edi
   935b8:	c1 ef 04             	shr    $0x4,%edi
   935bb:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
   935c1:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
   935c6:	48 39 fa             	cmp    %rdi,%rdx
   935c9:	48 0f 47 fa          	cmova  %rdx,%rdi
   935cd:	48 89 ca             	mov    %rcx,%rdx
   935d0:	48 c1 ea 24          	shr    $0x24,%rdx
   935d4:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
   935da:	48 be 00 00 00 00 0f 	movabs $0xf00000000,%rsi
   935e1:	00 00 00 
   935e4:	48 21 f1             	and    %rsi,%rcx
   935e7:	48 83 f9 01          	cmp    $0x1,%rcx
   935eb:	48 83 da ff          	sbb    $0xffffffffffffffff,%rdx
   935ef:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
   935f4:	48 39 d1             	cmp    %rdx,%rcx
   935f7:	48 0f 42 d1          	cmovb  %rcx,%rdx
   935fb:	48 89 fe             	mov    %rdi,%rsi
   935fe:	48 29 d6             	sub    %rdx,%rsi
   93601:	0f 83 f9 fe ff ff    	jae    93500 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x6a0>
   93607:	48 03 7c 24 68       	add    0x68(%rsp),%rdi
   9360c:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
   93611:	4a 8d 14 31          	lea    (%rcx,%r14,1),%rdx
   93615:	48 0f af 54 24 28    	imul   0x28(%rsp),%rdx
   9361b:	48 01 fa             	add    %rdi,%rdx
   9361e:	66 90                	xchg   %ax,%ax
   93620:	49 ff c6             	inc    %r14
   93623:	48 89 d7             	mov    %rdx,%rdi
   93626:	49 89 f7             	mov    %rsi,%r15
   93629:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   93630:	4c 39 e7             	cmp    %r12,%rdi
   93633:	0f 83 84 00 00 00    	jae    936bd <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x85d>
   93639:	49 8b 0c fb          	mov    (%r11,%rdi,8),%rcx
   9363d:	4c 8b 45 00          	mov    0x0(%rbp),%r8
   93641:	4c 39 c1             	cmp    %r8,%rcx
   93644:	0f 83 83 00 00 00    	jae    936cd <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x86d>
   9364a:	45 89 2c 8a          	mov    %r13d,(%r10,%rcx,4)
   9364e:	49 ff 04 fb          	incq   (%r11,%rdi,8)
   93652:	48 ff c7             	inc    %rdi
   93655:	49 ff c7             	inc    %r15
   93658:	75 d6                	jne    93630 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x7d0>
   9365a:	48 03 54 24 28       	add    0x28(%rsp),%rdx
   9365f:	49 39 de             	cmp    %rbx,%r14
   93662:	75 bc                	jne    93620 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x7c0>
   93664:	e9 97 fe ff ff       	jmp    93500 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x6a0>
   93669:	0f b7 44 24 38       	movzwl 0x38(%rsp),%eax
   9366e:	41 c1 e7 10          	shl    $0x10,%r15d
   93672:	0f b7 4c 24 20       	movzwl 0x20(%rsp),%ecx
   93677:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
   9367c:	48 c1 e2 30          	shl    $0x30,%rdx
   93680:	48 c1 e0 20          	shl    $0x20,%rax
   93684:	48 09 d0             	or     %rdx,%rax
   93687:	4c 09 f9             	or     %r15,%rcx
   9368a:	48 09 c1             	or     %rax,%rcx
   9368d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   93692:	48 89 48 48          	mov    %rcx,0x48(%rax)
   93696:	0f b6 44 24 17       	movzbl 0x17(%rsp),%eax
   9369b:	48 81 c4 d8 00 00 00 	add    $0xd8,%rsp
   936a2:	5b                   	pop    %rbx
   936a3:	41 5c                	pop    %r12
   936a5:	41 5d                	pop    %r13
   936a7:	41 5e                	pop    %r14
   936a9:	41 5f                	pop    %r15
   936ab:	5d                   	pop    %rbp
   936ac:	c3                   	ret
   936ad:	48 8d 15 9c c0 05 00 	lea    0x5c09c(%rip),%rdx        # ef750 <anon.9665fe5551a4cd8677c880f803fa1863.24.llvm.144352400316525355+0x48>
   936b4:	4c 89 e6             	mov    %r12,%rsi
   936b7:	ff 15 fb ec 05 00    	call   *0x5ecfb(%rip)        # f23b8 <_DYNAMIC+0x278>
   936bd:	48 8d 15 5c c0 05 00 	lea    0x5c05c(%rip),%rdx        # ef720 <anon.9665fe5551a4cd8677c880f803fa1863.24.llvm.144352400316525355+0x18>
   936c4:	4c 89 e6             	mov    %r12,%rsi
   936c7:	ff 15 eb ec 05 00    	call   *0x5eceb(%rip)        # f23b8 <_DYNAMIC+0x278>
   936cd:	48 8d 15 64 c0 05 00 	lea    0x5c064(%rip),%rdx        # ef738 <anon.9665fe5551a4cd8677c880f803fa1863.24.llvm.144352400316525355+0x30>
   936d4:	48 89 cf             	mov    %rcx,%rdi
   936d7:	4c 89 c6             	mov    %r8,%rsi
   936da:	ff 15 d8 ec 05 00    	call   *0x5ecd8(%rip)        # f23b8 <_DYNAMIC+0x278>
   936e0:	48 8d 0d c9 c0 05 00 	lea    0x5c0c9(%rip),%rcx        # ef7b0 <anon.9665fe5551a4cd8677c880f803fa1863.24.llvm.144352400316525355+0xa8>
   936e7:	31 ff                	xor    %edi,%edi
   936e9:	4c 89 c6             	mov    %r8,%rsi
   936ec:	4c 89 e2             	mov    %r12,%rdx
   936ef:	ff 15 eb ef 05 00    	call   *0x5efeb(%rip)        # f26e0 <_DYNAMIC+0x5a0>
   936f5:	48 8d 3d 9c c0 05 00 	lea    0x5c09c(%rip),%rdi        # ef798 <anon.9665fe5551a4cd8677c880f803fa1863.24.llvm.144352400316525355+0x90>
   936fc:	ff 15 1e ed 05 00    	call   *0x5ed1e(%rip)        # f2420 <_DYNAMIC+0x2e0>
   93702:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   93707:	48 8d 78 30          	lea    0x30(%rax),%rdi
   9370b:	b9 08 00 00 00       	mov    $0x8,%ecx
   93710:	41 b8 08 00 00 00    	mov    $0x8,%r8d
   93716:	48 89 f3             	mov    %rsi,%rbx
   93719:	31 f6                	xor    %esi,%esi
   9371b:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
   93720:	e8 ab 92 ff ff       	call   8c9d0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
   93725:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
   9372a:	48 89 de             	mov    %rbx,%rsi
   9372d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   93732:	4c 8b 60 40          	mov    0x40(%rax),%r12
   93736:	e9 22 fd ff ff       	jmp    9345d <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x5fd>
   9373b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   93740:	48 8d 78 18          	lea    0x18(%rax),%rdi
   93744:	b9 04 00 00 00       	mov    $0x4,%ecx
   93749:	41 b8 04 00 00 00    	mov    $0x4,%r8d
   9374f:	31 f6                	xor    %esi,%esi
   93751:	4c 89 ea             	mov    %r13,%rdx
   93754:	e8 77 92 ff ff       	call   8c9d0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
   93759:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
   9375e:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
   93763:	48 8b 59 28          	mov    0x28(%rcx),%rbx
   93767:	4c 8b 71 20          	mov    0x20(%rcx),%r14
   9376b:	49 8d 3c 9e          	lea    (%r14,%rbx,4),%rdi
   9376f:	49 83 fd 01          	cmp    $0x1,%r13
   93773:	0f 85 80 fc ff ff    	jne    933f9 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x599>
   93779:	e9 a2 fc ff ff       	jmp    93420 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x5c0>
   9377e:	b9 08 00 00 00       	mov    $0x8,%ecx
   93783:	41 b8 08 00 00 00    	mov    $0x8,%r8d
   93789:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
   9378e:	31 f6                	xor    %esi,%esi
   93790:	e8 3b 92 ff ff       	call   8c9d0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
   93795:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
   9379a:	4c 8b 67 10          	mov    0x10(%rdi),%r12
   9379e:	e9 66 f7 ff ff       	jmp    92f09 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0xa9>
   937a3:	48 8d 15 be bf 05 00 	lea    0x5bfbe(%rip),%rdx        # ef768 <anon.9665fe5551a4cd8677c880f803fa1863.24.llvm.144352400316525355+0x60>
   937aa:	48 8b b4 24 88 00 00 	mov    0x88(%rsp),%rsi
   937b1:	00 
   937b2:	ff 15 00 ec 05 00    	call   *0x5ec00(%rip)        # f23b8 <_DYNAMIC+0x278>
   937b8:	48 8d 15 a9 bf 05 00 	lea    0x5bfa9(%rip),%rdx        # ef768 <anon.9665fe5551a4cd8677c880f803fa1863.24.llvm.144352400316525355+0x60>
   937bf:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
   937c4:	ff 15 ee eb 05 00    	call   *0x5ebee(%rip)        # f23b8 <_DYNAMIC+0x278>
   937ca:	48 8d 15 af bf 05 00 	lea    0x5bfaf(%rip),%rdx        # ef780 <anon.9665fe5551a4cd8677c880f803fa1863.24.llvm.144352400316525355+0x78>
   937d1:	48 8b b4 24 80 00 00 	mov    0x80(%rsp),%rsi
   937d8:	00 
   937d9:	ff 15 d9 eb 05 00    	call   *0x5ebd9(%rip)        # f23b8 <_DYNAMIC+0x278>
   937df:	48 8d 15 9a bf 05 00 	lea    0x5bf9a(%rip),%rdx        # ef780 <anon.9665fe5551a4cd8677c880f803fa1863.24.llvm.144352400316525355+0x78>
   937e6:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
   937eb:	ff 15 c7 eb 05 00    	call   *0x5ebc7(%rip)        # f23b8 <_DYNAMIC+0x278>
