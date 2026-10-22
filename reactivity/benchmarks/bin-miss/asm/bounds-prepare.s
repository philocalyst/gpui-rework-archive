
/tmp/gpui-bin-miss-artifacts/bounds-457d085b3ddb0948ff40e6a6a1e2796ed96906c51b22ccc8b2fd21fbc09a7af8:     file format elf64-x86-64


Disassembly of section .text:

0000000000092c00 <<gpui_canvas::canvas::bins::RasterScratch>::prepare>:
   92c00:	55                   	push   %rbp
   92c01:	41 57                	push   %r15
   92c03:	41 56                	push   %r14
   92c05:	41 55                	push   %r13
   92c07:	41 54                	push   %r12
   92c09:	53                   	push   %rbx
   92c0a:	48 81 ec d8 00 00 00 	sub    $0xd8,%rsp
   92c11:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
   92c16:	48 8b 32             	mov    (%rdx),%rsi
   92c19:	4c 8b 7a 08          	mov    0x8(%rdx),%r15
   92c1d:	4c 8b 42 10          	mov    0x10(%rdx),%r8
   92c21:	4c 8b 4a 18          	mov    0x18(%rdx),%r9
   92c25:	4c 89 c8             	mov    %r9,%rax
   92c28:	48 c1 e0 30          	shl    $0x30,%rax
   92c2c:	41 0f b7 c8          	movzwl %r8w,%ecx
   92c30:	48 c1 e1 20          	shl    $0x20,%rcx
   92c34:	48 09 c1             	or     %rax,%rcx
   92c37:	44 89 f8             	mov    %r15d,%eax
   92c3a:	c1 e0 10             	shl    $0x10,%eax
   92c3d:	48 09 c8             	or     %rcx,%rax
   92c40:	0f b7 ce             	movzwl %si,%ecx
   92c43:	48 09 c1             	or     %rax,%rcx
   92c46:	48 8b 47 48          	mov    0x48(%rdi),%rax
   92c4a:	48 39 c8             	cmp    %rcx,%rax
   92c4d:	0f 84 b6 07 00 00    	je     93409 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x809>
   92c53:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
   92c5a:	00 
   92c5b:	48 89 8c 24 90 00 00 	mov    %rcx,0x90(%rsp)
   92c62:	00 
   92c63:	48 c7 47 48 00 00 00 	movq   $0x0,0x48(%rdi)
   92c6a:	00 
   92c6b:	4c 89 c0             	mov    %r8,%rax
   92c6e:	48 29 f0             	sub    %rsi,%rax
   92c71:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
   92c76:	4c 89 ca             	mov    %r9,%rdx
   92c79:	4c 29 fa             	sub    %r15,%rdx
   92c7c:	48 0f af d0          	imul   %rax,%rdx
   92c80:	48 c7 47 10 00 00 00 	movq   $0x0,0x10(%rdi)
   92c87:	00 
   92c88:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   92c8d:	48 ff c2             	inc    %rdx
   92c90:	48 89 3c 24          	mov    %rdi,(%rsp)
   92c94:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
   92c99:	4c 89 44 24 38       	mov    %r8,0x38(%rsp)
   92c9e:	4c 89 8c 24 80 00 00 	mov    %r9,0x80(%rsp)
   92ca5:	00 
   92ca6:	75 05                	jne    92cad <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0xad>
   92ca8:	45 31 e4             	xor    %r12d,%r12d
   92cab:	eb 46                	jmp    92cf3 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0xf3>
   92cad:	48 3b 17             	cmp    (%rdi),%rdx
   92cb0:	0f 87 38 08 00 00    	ja     934ee <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x8ee>
   92cb6:	45 31 e4             	xor    %r12d,%r12d
   92cb9:	48 8b 5f 08          	mov    0x8(%rdi),%rbx
   92cbd:	4a 8d 3c e3          	lea    (%rbx,%r12,8),%rdi
   92cc1:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
   92cc6:	48 85 c0             	test   %rax,%rax
   92cc9:	74 1a                	je     92ce5 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0xe5>
   92ccb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
   92cd2:	00 
   92cd3:	31 f6                	xor    %esi,%esi
   92cd5:	49 89 c6             	mov    %rax,%r14
   92cd8:	ff 15 6a f6 05 00    	call   *0x5f66a(%rip)        # f2348 <memset@GLIBC_2.2.5>
   92cde:	4d 01 f4             	add    %r14,%r12
   92ce1:	4a 8d 3c e3          	lea    (%rbx,%r12,8),%rdi
   92ce5:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
   92cec:	49 ff c4             	inc    %r12
   92cef:	48 8b 3c 24          	mov    (%rsp),%rdi
   92cf3:	4c 89 67 10          	mov    %r12,0x10(%rdi)
   92cf7:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
   92cfc:	48 8b 41 78          	mov    0x78(%rcx),%rax
   92d00:	48 8b 89 80 00 00 00 	mov    0x80(%rcx),%rcx
   92d07:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
   92d0c:	48 8d 04 88          	lea    (%rax,%rcx,4),%rax
   92d10:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
   92d15:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
   92d1c:	00 
   92d1d:	48 85 c9             	test   %rcx,%rcx
   92d20:	4c 89 7c 24 40       	mov    %r15,0x40(%rsp)
   92d25:	0f 84 4e 03 00 00    	je     93079 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x479>
   92d2b:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   92d30:	48 8b 88 90 00 00 00 	mov    0x90(%rax),%rcx
   92d37:	48 89 8c 24 c0 00 00 	mov    %rcx,0xc0(%rsp)
   92d3e:	00 
   92d3f:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
   92d46:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
   92d4b:	48 8b 88 f8 00 00 00 	mov    0xf8(%rax),%rcx
   92d52:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
   92d57:	48 8b 80 f0 00 00 00 	mov    0xf0(%rax),%rax
   92d5e:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
   92d65:	00 
   92d66:	48 8b 04 24          	mov    (%rsp),%rax
   92d6a:	4c 8b 40 08          	mov    0x8(%rax),%r8
   92d6e:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
   92d73:	48 89 cb             	mov    %rcx,%rbx
   92d76:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
   92d7b:	48 29 d3             	sub    %rdx,%rbx
   92d7e:	48 8d 04 cd 00 00 00 	lea    0x0(,%rcx,8),%rax
   92d85:	00 
   92d86:	4c 89 c6             	mov    %r8,%rsi
   92d89:	48 29 c6             	sub    %rax,%rsi
   92d8c:	48 83 c6 18          	add    $0x18,%rsi
   92d90:	48 89 b4 24 b8 00 00 	mov    %rsi,0xb8(%rsp)
   92d97:	00 
   92d98:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
   92d9d:	48 8d 34 f5 00 00 00 	lea    0x0(,%rsi,8),%rsi
   92da4:	00 
   92da5:	48 89 b4 24 b0 00 00 	mov    %rsi,0xb0(%rsp)
   92dac:	00 
   92dad:	48 8d 14 d5 00 00 00 	lea    0x0(,%rdx,8),%rdx
   92db4:	00 
   92db5:	48 29 c2             	sub    %rax,%rdx
   92db8:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
   92dbd:	b8 01 00 00 00       	mov    $0x1,%eax
   92dc2:	48 29 c8             	sub    %rcx,%rax
   92dc5:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
   92dcc:	00 
   92dcd:	48 8d 41 ff          	lea    -0x1(%rcx),%rax
   92dd1:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
   92dd8:	00 
   92dd9:	66 0f 76 c0          	pcmpeqd %xmm0,%xmm0
   92ddd:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
   92de2:	eb 28                	jmp    92e0c <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x20c>
   92de4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   92deb:	00 00 00 00 00 
   92df0:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
   92df7:	00 
   92df8:	48 83 c0 04          	add    $0x4,%rax
   92dfc:	48 3b 44 24 78       	cmp    0x78(%rsp),%rax
   92e01:	4c 8b 7c 24 40       	mov    0x40(%rsp),%r15
   92e06:	0f 84 6d 02 00 00    	je     93079 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x479>
   92e0c:	48 63 38             	movslq (%rax),%rdi
   92e0f:	48 85 ff             	test   %rdi,%rdi
   92e12:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
   92e19:	00 
   92e1a:	78 24                	js     92e40 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x240>
   92e1c:	48 39 7c 24 70       	cmp    %rdi,0x70(%rsp)
   92e21:	0f 86 ea 06 00 00    	jbe    93511 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x911>
   92e27:	48 c1 e7 05          	shl    $0x5,%rdi
   92e2b:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
   92e32:	00 
   92e33:	48 01 f8             	add    %rdi,%rax
   92e36:	48 83 c0 10          	add    $0x10,%rax
   92e3a:	eb 28                	jmp    92e64 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x264>
   92e3c:	0f 1f 40 00          	nopl   0x0(%rax)
   92e40:	81 e7 ff ff ff 7f    	and    $0x7fffffff,%edi
   92e46:	48 39 7c 24 68       	cmp    %rdi,0x68(%rsp)
   92e4b:	0f 86 e4 06 00 00    	jbe    93535 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x935>
   92e51:	48 6b c7 68          	imul   $0x68,%rdi,%rax
   92e55:	48 8b 8c 24 c0 00 00 	mov    0xc0(%rsp),%rcx
   92e5c:	00 
   92e5d:	48 01 c8             	add    %rcx,%rax
   92e60:	48 83 c0 60          	add    $0x60,%rax
   92e64:	48 8b 08             	mov    (%rax),%rcx
   92e67:	89 ce                	mov    %ecx,%esi
   92e69:	c1 ee 14             	shr    $0x14,%esi
   92e6c:	49 39 f7             	cmp    %rsi,%r15
   92e6f:	49 0f 47 f7          	cmova  %r15,%rsi
   92e73:	48 89 cf             	mov    %rcx,%rdi
   92e76:	48 c1 ef 34          	shr    $0x34,%rdi
   92e7a:	48 89 c8             	mov    %rcx,%rax
   92e7d:	48 ba 00 00 00 00 00 	movabs $0xf000000000000,%rdx
   92e84:	00 0f 00 
   92e87:	48 21 d0             	and    %rdx,%rax
   92e8a:	48 83 f8 01          	cmp    $0x1,%rax
   92e8e:	48 83 df ff          	sbb    $0xffffffffffffffff,%rdi
   92e92:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
   92e99:	00 
   92e9a:	48 39 f8             	cmp    %rdi,%rax
   92e9d:	48 0f 42 f8          	cmovb  %rax,%rdi
   92ea1:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
   92ea6:	48 39 fe             	cmp    %rdi,%rsi
   92ea9:	0f 83 41 ff ff ff    	jae    92df0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x1f0>
   92eaf:	89 ca                	mov    %ecx,%edx
   92eb1:	c1 ea 04             	shr    $0x4,%edx
   92eb4:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
   92eba:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   92ebf:	48 39 d0             	cmp    %rdx,%rax
   92ec2:	48 0f 47 d0          	cmova  %rax,%rdx
   92ec6:	48 89 cf             	mov    %rcx,%rdi
   92ec9:	48 c1 ef 24          	shr    $0x24,%rdi
   92ecd:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
   92ed3:	48 b8 00 00 00 00 0f 	movabs $0xf00000000,%rax
   92eda:	00 00 00 
   92edd:	48 21 c1             	and    %rax,%rcx
   92ee0:	48 83 f9 01          	cmp    $0x1,%rcx
   92ee4:	48 83 df ff          	sbb    $0xffffffffffffffff,%rdi
   92ee8:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   92eed:	48 39 f8             	cmp    %rdi,%rax
   92ef0:	48 0f 42 f8          	cmovb  %rax,%rdi
   92ef4:	48 39 fa             	cmp    %rdi,%rdx
   92ef7:	0f 83 f3 fe ff ff    	jae    92df0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x1f0>
   92efd:	48 89 f8             	mov    %rdi,%rax
   92f00:	49 89 d3             	mov    %rdx,%r11
   92f03:	49 f7 d3             	not    %r11
   92f06:	49 89 fa             	mov    %rdi,%r10
   92f09:	49 01 c3             	add    %rax,%r11
   92f0c:	48 89 d1             	mov    %rdx,%rcx
   92f0f:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   92f14:	48 29 c1             	sub    %rax,%rcx
   92f17:	48 89 f7             	mov    %rsi,%rdi
   92f1a:	48 2b 7c 24 40       	sub    0x40(%rsp),%rdi
   92f1f:	4c 8b 7c 24 10       	mov    0x10(%rsp),%r15
   92f24:	4c 0f af ff          	imul   %rdi,%r15
   92f28:	4c 01 f9             	add    %r15,%rcx
   92f2b:	48 ff c1             	inc    %rcx
   92f2e:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
   92f33:	4c 89 f9             	mov    %r15,%rcx
   92f36:	48 f7 d1             	not    %rcx
   92f39:	48 01 c1             	add    %rax,%rcx
   92f3c:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   92f41:	48 29 d1             	sub    %rdx,%rcx
   92f44:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
   92f49:	48 0f af bc 24 b0 00 	imul   0xb0(%rsp),%rdi
   92f50:	00 00 
   92f52:	48 8d 2c d7          	lea    (%rdi,%rdx,8),%rbp
   92f56:	48 03 ac 24 b8 00 00 	add    0xb8(%rsp),%rbp
   92f5d:	00 
   92f5e:	48 8b 8c 24 a8 00 00 	mov    0xa8(%rsp),%rcx
   92f65:	00 
   92f66:	4c 8d 0c 11          	lea    (%rcx,%rdx,1),%r9
   92f6a:	4d 01 f9             	add    %r15,%r9
   92f6d:	4c 8b b4 24 a0 00 00 	mov    0xa0(%rsp),%r14
   92f74:	00 
   92f75:	4d 29 fe             	sub    %r15,%r14
   92f78:	49 29 d6             	sub    %rdx,%r14
   92f7b:	49 f7 da             	neg    %r10
   92f7e:	4c 89 54 24 20       	mov    %r10,0x20(%rsp)
   92f83:	49 01 cf             	add    %rcx,%r15
   92f86:	31 c9                	xor    %ecx,%ecx
   92f88:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   92f8f:	00 
   92f90:	4d 39 cc             	cmp    %r9,%r12
   92f93:	4d 89 cd             	mov    %r9,%r13
   92f96:	4d 0f 47 ec          	cmova  %r12,%r13
   92f9a:	4d 01 f5             	add    %r14,%r13
   92f9d:	4d 39 eb             	cmp    %r13,%r11
   92fa0:	4d 0f 42 eb          	cmovb  %r11,%r13
   92fa4:	48 89 c7             	mov    %rax,%rdi
   92fa7:	48 0f af f9          	imul   %rcx,%rdi
   92fab:	48 03 7c 24 58       	add    0x58(%rsp),%rdi
   92fb0:	49 39 fc             	cmp    %rdi,%r12
   92fb3:	49 0f 47 fc          	cmova  %r12,%rdi
   92fb7:	49 89 da             	mov    %rbx,%r10
   92fba:	48 0f af d9          	imul   %rcx,%rbx
   92fbe:	48 03 5c 24 50       	add    0x50(%rsp),%rbx
   92fc3:	48 01 fb             	add    %rdi,%rbx
   92fc6:	49 39 db             	cmp    %rbx,%r11
   92fc9:	49 0f 42 db          	cmovb  %r11,%rbx
   92fcd:	48 ff c3             	inc    %rbx
   92fd0:	48 89 d7             	mov    %rdx,%rdi
   92fd3:	48 83 fb 05          	cmp    $0x5,%rbx
   92fd7:	72 55                	jb     9302e <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x42e>
   92fd9:	89 d8                	mov    %ebx,%eax
   92fdb:	83 e0 03             	and    $0x3,%eax
   92fde:	bf 04 00 00 00       	mov    $0x4,%edi
   92fe3:	48 0f 44 c7          	cmove  %rdi,%rax
   92fe7:	48 29 c3             	sub    %rax,%rbx
   92fea:	48 89 df             	mov    %rbx,%rdi
   92fed:	48 01 d7             	add    %rdx,%rdi
   92ff0:	49 29 c5             	sub    %rax,%r13
   92ff3:	49 ff c5             	inc    %r13
   92ff6:	31 db                	xor    %ebx,%ebx
   92ff8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   92fff:	00 
   93000:	f3 0f 6f 4c dd f0    	movdqu -0x10(%rbp,%rbx,8),%xmm1
   93006:	f3 0f 6f 54 dd 00    	movdqu 0x0(%rbp,%rbx,8),%xmm2
   9300c:	66 0f fb c8          	psubq  %xmm0,%xmm1
   93010:	66 0f fb d0          	psubq  %xmm0,%xmm2
   93014:	f3 0f 7f 4c dd f0    	movdqu %xmm1,-0x10(%rbp,%rbx,8)
   9301a:	f3 0f 7f 54 dd 00    	movdqu %xmm2,0x0(%rbp,%rbx,8)
   93020:	48 83 c3 04          	add    $0x4,%rbx
   93024:	49 39 dd             	cmp    %rbx,%r13
   93027:	75 d7                	jne    93000 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x400>
   93029:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   9302e:	48 ff c6             	inc    %rsi
   93031:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
   93036:	48 01 fb             	add    %rdi,%rbx
   93039:	4c 01 ff             	add    %r15,%rdi
   9303c:	0f 1f 40 00          	nopl   0x0(%rax)
   93040:	4c 39 e7             	cmp    %r12,%rdi
   93043:	0f 83 d8 03 00 00    	jae    93421 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x821>
   93049:	49 ff 04 f8          	incq   (%r8,%rdi,8)
   9304d:	48 ff c7             	inc    %rdi
   93050:	48 ff c3             	inc    %rbx
   93053:	75 eb                	jne    93040 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x440>
   93055:	48 ff c1             	inc    %rcx
   93058:	48 03 6c 24 48       	add    0x48(%rsp),%rbp
   9305d:	49 01 c1             	add    %rax,%r9
   93060:	4c 89 d3             	mov    %r10,%rbx
   93063:	4d 01 d6             	add    %r10,%r14
   93066:	49 01 c7             	add    %rax,%r15
   93069:	48 3b 74 24 28       	cmp    0x28(%rsp),%rsi
   9306e:	0f 85 1c ff ff ff    	jne    92f90 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x390>
   93074:	e9 77 fd ff ff       	jmp    92df0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x1f0>
   93079:	49 83 fc 02          	cmp    $0x2,%r12
   9307d:	72 2f                	jb     930ae <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x4ae>
   9307f:	48 8b 04 24          	mov    (%rsp),%rax
   93083:	48 8b 40 08          	mov    0x8(%rax),%rax
   93087:	48 8b 08             	mov    (%rax),%rcx
   9308a:	49 8d 7c 24 ff       	lea    -0x1(%r12),%rdi
   9308f:	4d 8d 44 24 fe       	lea    -0x2(%r12),%r8
   93094:	89 fa                	mov    %edi,%edx
   93096:	83 e2 03             	and    $0x3,%edx
   93099:	be 01 00 00 00       	mov    $0x1,%esi
   9309e:	49 83 f8 03          	cmp    $0x3,%r8
   930a2:	73 41                	jae    930e5 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x4e5>
   930a4:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
   930a9:	e9 80 00 00 00       	jmp    9312e <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x52e>
   930ae:	48 8b 0c 24          	mov    (%rsp),%rcx
   930b2:	48 c7 41 28 00 00 00 	movq   $0x0,0x28(%rcx)
   930b9:	00 
   930ba:	4d 85 e4             	test   %r12,%r12
   930bd:	0f 84 a6 03 00 00    	je     93469 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x869>
   930c3:	48 8d 69 28          	lea    0x28(%rcx),%rbp
   930c7:	48 8b 41 08          	mov    0x8(%rcx),%rax
   930cb:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
   930d0:	4e 8b 6c e0 f8       	mov    -0x8(%rax,%r12,8),%r13
   930d5:	4d 85 ed             	test   %r13,%r13
   930d8:	0f 85 90 00 00 00    	jne    9316e <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x56e>
   930de:	31 db                	xor    %ebx,%ebx
   930e0:	e9 db 00 00 00       	jmp    931c0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x5c0>
   930e5:	48 83 e7 fc          	and    $0xfffffffffffffffc,%rdi
   930e9:	31 f6                	xor    %esi,%esi
   930eb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   930f0:	48 03 4c f0 08       	add    0x8(%rax,%rsi,8),%rcx
   930f5:	48 89 4c f0 08       	mov    %rcx,0x8(%rax,%rsi,8)
   930fa:	48 03 4c f0 10       	add    0x10(%rax,%rsi,8),%rcx
   930ff:	48 89 4c f0 10       	mov    %rcx,0x10(%rax,%rsi,8)
   93104:	48 03 4c f0 18       	add    0x18(%rax,%rsi,8),%rcx
   93109:	48 89 4c f0 18       	mov    %rcx,0x18(%rax,%rsi,8)
   9310e:	48 03 4c f0 20       	add    0x20(%rax,%rsi,8),%rcx
   93113:	48 89 4c f0 20       	mov    %rcx,0x20(%rax,%rsi,8)
   93118:	48 83 c6 04          	add    $0x4,%rsi
   9311c:	48 39 f7             	cmp    %rsi,%rdi
   9311f:	75 cf                	jne    930f0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x4f0>
   93121:	48 85 d2             	test   %rdx,%rdx
   93124:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
   93129:	74 25                	je     93150 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x550>
   9312b:	48 ff c6             	inc    %rsi
   9312e:	48 8d 34 f0          	lea    (%rax,%rsi,8),%rsi
   93132:	31 ff                	xor    %edi,%edi
   93134:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   9313b:	00 00 00 00 00 
   93140:	48 03 0c fe          	add    (%rsi,%rdi,8),%rcx
   93144:	48 89 0c fe          	mov    %rcx,(%rsi,%rdi,8)
   93148:	48 ff c7             	inc    %rdi
   9314b:	48 39 fa             	cmp    %rdi,%rdx
   9314e:	75 f0                	jne    93140 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x540>
   93150:	48 8b 0c 24          	mov    (%rsp),%rcx
   93154:	48 8d 69 28          	lea    0x28(%rcx),%rbp
   93158:	48 c7 41 28 00 00 00 	movq   $0x0,0x28(%rcx)
   9315f:	00 
   93160:	4e 8b 6c e0 f8       	mov    -0x8(%rax,%r12,8),%r13
   93165:	4d 85 ed             	test   %r13,%r13
   93168:	0f 84 70 ff ff ff    	je     930de <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x4de>
   9316e:	4c 3b 69 18          	cmp    0x18(%rcx),%r13
   93172:	0f 87 35 03 00 00    	ja     934ad <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x8ad>
   93178:	31 db                	xor    %ebx,%ebx
   9317a:	4c 8b 71 20          	mov    0x20(%rcx),%r14
   9317e:	49 8d 3c 9e          	lea    (%r14,%rbx,4),%rdi
   93182:	49 83 fd 01          	cmp    $0x1,%r13
   93186:	74 27                	je     931af <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x5af>
   93188:	4a 8d 14 ad fc ff ff 	lea    -0x4(,%r13,4),%rdx
   9318f:	ff 
   93190:	31 f6                	xor    %esi,%esi
   93192:	ff 15 b0 f1 05 00    	call   *0x5f1b0(%rip)        # f2348 <memset@GLIBC_2.2.5>
   93198:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
   9319d:	4a 8d 04 2b          	lea    (%rbx,%r13,1),%rax
   931a1:	49 8d 3c 86          	lea    (%r14,%rax,4),%rdi
   931a5:	48 83 c7 fc          	add    $0xfffffffffffffffc,%rdi
   931a9:	4c 01 eb             	add    %r13,%rbx
   931ac:	48 ff cb             	dec    %rbx
   931af:	c7 07 00 00 00 00    	movl   $0x0,(%rdi)
   931b5:	48 ff c3             	inc    %rbx
   931b8:	48 8b 0c 24          	mov    (%rsp),%rcx
   931bc:	4c 8b 61 10          	mov    0x10(%rcx),%r12
   931c0:	48 89 59 28          	mov    %rbx,0x28(%rcx)
   931c4:	48 c7 41 40 00 00 00 	movq   $0x0,0x40(%rcx)
   931cb:	00 
   931cc:	4d 39 e0             	cmp    %r12,%r8
   931cf:	0f 87 7f 02 00 00    	ja     93454 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x854>
   931d5:	48 8b 71 08          	mov    0x8(%rcx),%rsi
   931d9:	4c 3b 41 30          	cmp    0x30(%rcx),%r8
   931dd:	0f 87 93 02 00 00    	ja     93476 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x876>
   931e3:	45 31 e4             	xor    %r12d,%r12d
   931e6:	4d 85 c0             	test   %r8,%r8
   931e9:	74 27                	je     93212 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x612>
   931eb:	4a 8d 3c e5 00 00 00 	lea    0x0(,%r12,8),%rdi
   931f2:	00 
   931f3:	48 8b 04 24          	mov    (%rsp),%rax
   931f7:	48 03 78 38          	add    0x38(%rax),%rdi
   931fb:	4a 8d 14 c5 00 00 00 	lea    0x0(,%r8,8),%rdx
   93202:	00 
   93203:	ff 15 af f0 05 00    	call   *0x5f0af(%rip)        # f22b8 <memcpy@GLIBC_2.14>
   93209:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
   9320e:	48 8b 0c 24          	mov    (%rsp),%rcx
   93212:	4d 01 c4             	add    %r8,%r12
   93215:	4c 89 61 40          	mov    %r12,0x40(%rcx)
   93219:	48 83 bc 24 98 00 00 	cmpq   $0x0,0x98(%rsp)
   93220:	00 00 
   93222:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
   93227:	0f 84 c4 01 00 00    	je     933f1 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x7f1>
   9322d:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   93232:	48 8b 88 90 00 00 00 	mov    0x90(%rax),%rcx
   93239:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
   9323e:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
   93245:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
   9324a:	48 8b 88 f8 00 00 00 	mov    0xf8(%rax),%rcx
   93251:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
   93256:	4c 8b 88 f0 00 00 00 	mov    0xf0(%rax),%r9
   9325d:	48 8b 0c 24          	mov    (%rsp),%rcx
   93261:	4c 8b 51 20          	mov    0x20(%rcx),%r10
   93265:	4c 8b 59 38          	mov    0x38(%rcx),%r11
   93269:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   9326e:	48 f7 d8             	neg    %rax
   93271:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
   93276:	4c 89 f8             	mov    %r15,%rax
   93279:	48 f7 d8             	neg    %rax
   9327c:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
   93281:	45 31 ed             	xor    %r13d,%r13d
   93284:	eb 24                	jmp    932aa <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x6aa>
   93286:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   9328d:	00 00 00 
   93290:	48 89 c2             	mov    %rax,%rdx
   93293:	48 83 c2 04          	add    $0x4,%rdx
   93297:	41 ff c5             	inc    %r13d
   9329a:	48 3b 54 24 78       	cmp    0x78(%rsp),%rdx
   9329f:	4c 8b 7c 24 40       	mov    0x40(%rsp),%r15
   932a4:	0f 84 47 01 00 00    	je     933f1 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x7f1>
   932aa:	48 89 d0             	mov    %rdx,%rax
   932ad:	48 63 3a             	movslq (%rdx),%rdi
   932b0:	48 85 ff             	test   %rdi,%rdi
   932b3:	78 1b                	js     932d0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x6d0>
   932b5:	48 39 7c 24 28       	cmp    %rdi,0x28(%rsp)
   932ba:	0f 86 63 02 00 00    	jbe    93523 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x923>
   932c0:	48 c1 e7 05          	shl    $0x5,%rdi
   932c4:	49 8d 0c 39          	lea    (%r9,%rdi,1),%rcx
   932c8:	48 83 c1 10          	add    $0x10,%rcx
   932cc:	eb 23                	jmp    932f1 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x6f1>
   932ce:	66 90                	xchg   %ax,%ax
   932d0:	81 e7 ff ff ff 7f    	and    $0x7fffffff,%edi
   932d6:	48 39 7c 24 20       	cmp    %rdi,0x20(%rsp)
   932db:	0f 86 66 02 00 00    	jbe    93547 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x947>
   932e1:	48 6b cf 68          	imul   $0x68,%rdi,%rcx
   932e5:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
   932ea:	48 01 d1             	add    %rdx,%rcx
   932ed:	48 83 c1 60          	add    $0x60,%rcx
   932f1:	48 8b 09             	mov    (%rcx),%rcx
   932f4:	41 89 ce             	mov    %ecx,%r14d
   932f7:	41 c1 ee 14          	shr    $0x14,%r14d
   932fb:	4d 39 f7             	cmp    %r14,%r15
   932fe:	4d 0f 47 f7          	cmova  %r15,%r14
   93302:	49 89 cf             	mov    %rcx,%r15
   93305:	49 c1 ef 34          	shr    $0x34,%r15
   93309:	48 89 ca             	mov    %rcx,%rdx
   9330c:	48 be 00 00 00 00 00 	movabs $0xf000000000000,%rsi
   93313:	00 0f 00 
   93316:	48 21 f2             	and    %rsi,%rdx
   93319:	48 83 fa 01          	cmp    $0x1,%rdx
   9331d:	49 83 df ff          	sbb    $0xffffffffffffffff,%r15
   93321:	48 8b 94 24 80 00 00 	mov    0x80(%rsp),%rdx
   93328:	00 
   93329:	4c 39 fa             	cmp    %r15,%rdx
   9332c:	4c 0f 42 fa          	cmovb  %rdx,%r15
   93330:	4d 39 fe             	cmp    %r15,%r14
   93333:	0f 83 57 ff ff ff    	jae    93290 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x690>
   93339:	89 cf                	mov    %ecx,%edi
   9333b:	c1 ef 04             	shr    $0x4,%edi
   9333e:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
   93344:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
   93349:	48 39 fa             	cmp    %rdi,%rdx
   9334c:	48 0f 47 fa          	cmova  %rdx,%rdi
   93350:	48 89 ca             	mov    %rcx,%rdx
   93353:	48 c1 ea 24          	shr    $0x24,%rdx
   93357:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
   9335d:	48 be 00 00 00 00 0f 	movabs $0xf00000000,%rsi
   93364:	00 00 00 
   93367:	48 21 f1             	and    %rsi,%rcx
   9336a:	48 83 f9 01          	cmp    $0x1,%rcx
   9336e:	48 83 da ff          	sbb    $0xffffffffffffffff,%rdx
   93372:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
   93377:	48 39 d1             	cmp    %rdx,%rcx
   9337a:	48 0f 42 d1          	cmovb  %rcx,%rdx
   9337e:	48 89 fe             	mov    %rdi,%rsi
   93381:	48 29 d6             	sub    %rdx,%rsi
   93384:	0f 83 06 ff ff ff    	jae    93290 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x690>
   9338a:	48 03 7c 24 50       	add    0x50(%rsp),%rdi
   9338f:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
   93394:	4a 8d 14 31          	lea    (%rcx,%r14,1),%rdx
   93398:	48 0f af 54 24 10    	imul   0x10(%rsp),%rdx
   9339e:	48 01 fa             	add    %rdi,%rdx
   933a1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   933a8:	0f 1f 84 00 00 00 00 
   933af:	00 
   933b0:	49 ff c6             	inc    %r14
   933b3:	48 89 d7             	mov    %rdx,%rdi
   933b6:	48 89 f3             	mov    %rsi,%rbx
   933b9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   933c0:	4c 39 e7             	cmp    %r12,%rdi
   933c3:	73 6c                	jae    93431 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x831>
   933c5:	49 8b 0c fb          	mov    (%r11,%rdi,8),%rcx
   933c9:	4c 8b 45 00          	mov    0x0(%rbp),%r8
   933cd:	4c 39 c1             	cmp    %r8,%rcx
   933d0:	73 6f                	jae    93441 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x841>
   933d2:	45 89 2c 8a          	mov    %r13d,(%r10,%rcx,4)
   933d6:	49 ff 04 fb          	incq   (%r11,%rdi,8)
   933da:	48 ff c7             	inc    %rdi
   933dd:	48 ff c3             	inc    %rbx
   933e0:	75 de                	jne    933c0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x7c0>
   933e2:	48 03 54 24 10       	add    0x10(%rsp),%rdx
   933e7:	4d 39 fe             	cmp    %r15,%r14
   933ea:	75 c4                	jne    933b0 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x7b0>
   933ec:	e9 9f fe ff ff       	jmp    93290 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x690>
   933f1:	48 8b 04 24          	mov    (%rsp),%rax
   933f5:	48 8b 8c 24 90 00 00 	mov    0x90(%rsp),%rcx
   933fc:	00 
   933fd:	48 89 48 48          	mov    %rcx,0x48(%rax)
   93401:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
   93408:	00 
   93409:	48 39 c8             	cmp    %rcx,%rax
   9340c:	0f 94 c0             	sete   %al
   9340f:	48 81 c4 d8 00 00 00 	add    $0xd8,%rsp
   93416:	5b                   	pop    %rbx
   93417:	41 5c                	pop    %r12
   93419:	41 5d                	pop    %r13
   9341b:	41 5e                	pop    %r14
   9341d:	41 5f                	pop    %r15
   9341f:	5d                   	pop    %rbp
   93420:	c3                   	ret
   93421:	48 8d 15 d8 c1 05 00 	lea    0x5c1d8(%rip),%rdx        # ef600 <anon.adb0f0b225921b8b8746c3a83b398ca6.24.llvm.13774212389252568242+0x48>
   93428:	4c 89 e6             	mov    %r12,%rsi
   9342b:	ff 15 37 ee 05 00    	call   *0x5ee37(%rip)        # f2268 <_DYNAMIC+0x278>
   93431:	48 8d 15 98 c1 05 00 	lea    0x5c198(%rip),%rdx        # ef5d0 <anon.adb0f0b225921b8b8746c3a83b398ca6.24.llvm.13774212389252568242+0x18>
   93438:	4c 89 e6             	mov    %r12,%rsi
   9343b:	ff 15 27 ee 05 00    	call   *0x5ee27(%rip)        # f2268 <_DYNAMIC+0x278>
   93441:	48 8d 15 a0 c1 05 00 	lea    0x5c1a0(%rip),%rdx        # ef5e8 <anon.adb0f0b225921b8b8746c3a83b398ca6.24.llvm.13774212389252568242+0x30>
   93448:	48 89 cf             	mov    %rcx,%rdi
   9344b:	4c 89 c6             	mov    %r8,%rsi
   9344e:	ff 15 14 ee 05 00    	call   *0x5ee14(%rip)        # f2268 <_DYNAMIC+0x278>
   93454:	48 8d 0d 05 c2 05 00 	lea    0x5c205(%rip),%rcx        # ef660 <anon.adb0f0b225921b8b8746c3a83b398ca6.24.llvm.13774212389252568242+0xa8>
   9345b:	31 ff                	xor    %edi,%edi
   9345d:	4c 89 c6             	mov    %r8,%rsi
   93460:	4c 89 e2             	mov    %r12,%rdx
   93463:	ff 15 27 f1 05 00    	call   *0x5f127(%rip)        # f2590 <_DYNAMIC+0x5a0>
   93469:	48 8d 3d d8 c1 05 00 	lea    0x5c1d8(%rip),%rdi        # ef648 <anon.adb0f0b225921b8b8746c3a83b398ca6.24.llvm.13774212389252568242+0x90>
   93470:	ff 15 5a ee 05 00    	call   *0x5ee5a(%rip)        # f22d0 <_DYNAMIC+0x2e0>
   93476:	48 8b 04 24          	mov    (%rsp),%rax
   9347a:	48 8d 78 30          	lea    0x30(%rax),%rdi
   9347e:	b9 08 00 00 00       	mov    $0x8,%ecx
   93483:	41 b8 08 00 00 00    	mov    $0x8,%r8d
   93489:	48 89 f3             	mov    %rsi,%rbx
   9348c:	31 f6                	xor    %esi,%esi
   9348e:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
   93493:	e8 28 94 ff ff       	call   8c8c0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
   93498:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
   9349d:	48 89 de             	mov    %rbx,%rsi
   934a0:	48 8b 04 24          	mov    (%rsp),%rax
   934a4:	4c 8b 60 40          	mov    0x40(%rax),%r12
   934a8:	e9 3e fd ff ff       	jmp    931eb <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x5eb>
   934ad:	48 8b 04 24          	mov    (%rsp),%rax
   934b1:	48 8d 78 18          	lea    0x18(%rax),%rdi
   934b5:	b9 04 00 00 00       	mov    $0x4,%ecx
   934ba:	41 b8 04 00 00 00    	mov    $0x4,%r8d
   934c0:	31 f6                	xor    %esi,%esi
   934c2:	4c 89 ea             	mov    %r13,%rdx
   934c5:	e8 f6 93 ff ff       	call   8c8c0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
   934ca:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
   934cf:	48 8b 0c 24          	mov    (%rsp),%rcx
   934d3:	48 8b 59 28          	mov    0x28(%rcx),%rbx
   934d7:	4c 8b 71 20          	mov    0x20(%rcx),%r14
   934db:	49 8d 3c 9e          	lea    (%r14,%rbx,4),%rdi
   934df:	49 83 fd 01          	cmp    $0x1,%r13
   934e3:	0f 85 9f fc ff ff    	jne    93188 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x588>
   934e9:	e9 c1 fc ff ff       	jmp    931af <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0x5af>
   934ee:	b9 08 00 00 00       	mov    $0x8,%ecx
   934f3:	41 b8 08 00 00 00    	mov    $0x8,%r8d
   934f9:	48 8b 3c 24          	mov    (%rsp),%rdi
   934fd:	31 f6                	xor    %esi,%esi
   934ff:	e8 bc 93 ff ff       	call   8c8c0 <<alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>>
   93504:	48 8b 3c 24          	mov    (%rsp),%rdi
   93508:	4c 8b 67 10          	mov    0x10(%rdi),%r12
   9350c:	e9 a8 f7 ff ff       	jmp    92cb9 <<gpui_canvas::canvas::bins::RasterScratch>::prepare+0xb9>
   93511:	48 8d 15 00 c1 05 00 	lea    0x5c100(%rip),%rdx        # ef618 <anon.adb0f0b225921b8b8746c3a83b398ca6.24.llvm.13774212389252568242+0x60>
   93518:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
   9351d:	ff 15 45 ed 05 00    	call   *0x5ed45(%rip)        # f2268 <_DYNAMIC+0x278>
   93523:	48 8d 15 ee c0 05 00 	lea    0x5c0ee(%rip),%rdx        # ef618 <anon.adb0f0b225921b8b8746c3a83b398ca6.24.llvm.13774212389252568242+0x60>
   9352a:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
   9352f:	ff 15 33 ed 05 00    	call   *0x5ed33(%rip)        # f2268 <_DYNAMIC+0x278>
   93535:	48 8d 15 f4 c0 05 00 	lea    0x5c0f4(%rip),%rdx        # ef630 <anon.adb0f0b225921b8b8746c3a83b398ca6.24.llvm.13774212389252568242+0x78>
   9353c:	48 8b 74 24 68       	mov    0x68(%rsp),%rsi
   93541:	ff 15 21 ed 05 00    	call   *0x5ed21(%rip)        # f2268 <_DYNAMIC+0x278>
   93547:	48 8d 15 e2 c0 05 00 	lea    0x5c0e2(%rip),%rdx        # ef630 <anon.adb0f0b225921b8b8746c3a83b398ca6.24.llvm.13774212389252568242+0x78>
   9354e:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
   93553:	ff 15 0f ed 05 00    	call   *0x5ed0f(%rip)        # f2268 <_DYNAMIC+0x278>
