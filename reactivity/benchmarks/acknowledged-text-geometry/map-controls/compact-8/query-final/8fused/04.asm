
/tmp/gpui-text-map-query-final/8fused/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

000000000067cd30 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}>:
  67cd30:	41 57                	push   %r15
  67cd32:	41 56                	push   %r14
  67cd34:	41 54                	push   %r12
  67cd36:	53                   	push   %rbx
  67cd37:	50                   	push   %rax
  67cd38:	4c 8b 42 08          	mov    0x8(%rdx),%r8
  67cd3c:	4c 8b 52 10          	mov    0x10(%rdx),%r10
  67cd40:	48 8b 4a 18          	mov    0x18(%rdx),%rcx
  67cd44:	4c 8b 4a 20          	mov    0x20(%rdx),%r9
  67cd48:	48 8b 42 28          	mov    0x28(%rdx),%rax
  67cd4c:	48 83 3a 01          	cmpq   $0x1,(%rdx)
  67cd50:	75 2b                	jne    67cd7d <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x4d>
  67cd52:	4d 85 d2             	test   %r10,%r10
  67cd55:	0f 84 d4 01 00 00    	je     67cf2f <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1ff>
  67cd5b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  67cd60:	45 0f b6 58 08       	movzbl 0x8(%r8),%r11d
  67cd65:	41 f6 c3 02          	test   $0x2,%r11b
  67cd69:	0f 85 96 00 00 00    	jne    67ce05 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0xd5>
  67cd6f:	49 83 c0 0c          	add    $0xc,%r8
  67cd73:	49 ff ca             	dec    %r10
  67cd76:	75 e8                	jne    67cd60 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x30>
  67cd78:	e9 b2 01 00 00       	jmp    67cf2f <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1ff>
  67cd7d:	4d 85 d2             	test   %r10,%r10
  67cd80:	0f 84 a9 01 00 00    	je     67cf2f <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1ff>
  67cd86:	41 8b 10             	mov    (%r8),%edx
  67cd89:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  67cd8f:	4d 29 d3             	sub    %r10,%r11
  67cd92:	49 ff ca             	dec    %r10
  67cd95:	48 c7 c3 ff ff ff ff 	mov    $0xffffffffffffffff,%rbx
  67cd9c:	0f 1f 40 00          	nopl   0x0(%rax)
  67cda0:	4d 8d 34 1b          	lea    (%r11,%rbx,1),%r14
  67cda4:	49 83 fe ff          	cmp    $0xffffffffffffffff,%r14
  67cda8:	0f 84 8a 01 00 00    	je     67cf38 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x208>
  67cdae:	4c 8d 73 01          	lea    0x1(%rbx),%r14
  67cdb2:	41 39 54 d8 10       	cmp    %edx,0x10(%r8,%rbx,8)
  67cdb7:	4c 89 f3             	mov    %r14,%rbx
  67cdba:	74 e4                	je     67cda0 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x70>
  67cdbc:	4f 8d 04 f0          	lea    (%r8,%r14,8),%r8
  67cdc0:	4d 85 f6             	test   %r14,%r14
  67cdc3:	0f 84 7f 01 00 00    	je     67cf48 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x218>
  67cdc9:	41 39 50 f8          	cmp    %edx,-0x8(%r8)
  67cdcd:	41 0f 94 c3          	sete   %r11b
  67cdd1:	41 80 f3 03          	xor    $0x3,%r11b
  67cdd5:	f3 41 0f 10 48 04    	movss  0x4(%r8),%xmm1
  67cddb:	f6 c1 01             	test   $0x1,%cl
  67cdde:	74 33                	je     67ce13 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0xe3>
  67cde0:	48 85 c0             	test   %rax,%rax
  67cde3:	0f 84 46 01 00 00    	je     67cf2f <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1ff>
  67cde9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  67cdf0:	41 f6 41 08 01       	testb  $0x1,0x8(%r9)
  67cdf5:	75 25                	jne    67ce1c <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0xec>
  67cdf7:	49 83 c1 0c          	add    $0xc,%r9
  67cdfb:	48 ff c8             	dec    %rax
  67cdfe:	75 f0                	jne    67cdf0 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0xc0>
  67ce00:	e9 2a 01 00 00       	jmp    67cf2f <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1ff>
  67ce05:	41 8b 10             	mov    (%r8),%edx
  67ce08:	f3 41 0f 10 48 04    	movss  0x4(%r8),%xmm1
  67ce0e:	f6 c1 01             	test   $0x1,%cl
  67ce11:	75 cd                	jne    67cde0 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0xb0>
  67ce13:	48 85 c0             	test   %rax,%rax
  67ce16:	0f 84 13 01 00 00    	je     67cf2f <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1ff>
  67ce1c:	4c 8b 56 38          	mov    0x38(%rsi),%r10
  67ce20:	48 8b 4e 40          	mov    0x40(%rsi),%rcx
  67ce24:	48 89 c8             	mov    %rcx,%rax
  67ce27:	48 85 c9             	test   %rcx,%rcx
  67ce2a:	74 4d                	je     67ce79 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x149>
  67ce2c:	45 31 c0             	xor    %r8d,%r8d
  67ce2f:	48 83 f9 01          	cmp    $0x1,%rcx
  67ce33:	74 2c                	je     67ce61 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x131>
  67ce35:	48 89 c8             	mov    %rcx,%rax
  67ce38:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  67ce3f:	00 
  67ce40:	4c 89 c3             	mov    %r8,%rbx
  67ce43:	49 89 c6             	mov    %rax,%r14
  67ce46:	49 d1 ee             	shr    $1,%r14
  67ce49:	4d 01 f0             	add    %r14,%r8
  67ce4c:	4f 8d 3c 40          	lea    (%r8,%r8,2),%r15
  67ce50:	43 39 14 fa          	cmp    %edx,(%r10,%r15,8)
  67ce54:	4c 0f 47 c3          	cmova  %rbx,%r8
  67ce58:	4c 29 f0             	sub    %r14,%rax
  67ce5b:	48 83 f8 01          	cmp    $0x1,%rax
  67ce5f:	77 df                	ja     67ce40 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x110>
  67ce61:	4b 8d 1c 40          	lea    (%r8,%r8,2),%rbx
  67ce65:	31 c0                	xor    %eax,%eax
  67ce67:	41 39 14 da          	cmp    %edx,(%r10,%rbx,8)
  67ce6b:	0f 96 c0             	setbe  %al
  67ce6e:	4c 01 c0             	add    %r8,%rax
  67ce71:	48 83 f8 01          	cmp    $0x1,%rax
  67ce75:	48 83 d0 ff          	adc    $0xffffffffffffffff,%rax
  67ce79:	48 39 c8             	cmp    %rcx,%rax
  67ce7c:	0f 83 1c 02 00 00    	jae    67d09e <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x36e>
  67ce82:	48 8d 1c 40          	lea    (%rax,%rax,2),%rbx
  67ce86:	49 89 c0             	mov    %rax,%r8
  67ce89:	41 f6 c3 01          	test   $0x1,%r11b
  67ce8d:	74 69                	je     67cef8 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1c8>
  67ce8f:	49 89 c0             	mov    %rax,%r8
  67ce92:	85 d2                	test   %edx,%edx
  67ce94:	74 62                	je     67cef8 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1c8>
  67ce96:	49 89 c0             	mov    %rax,%r8
  67ce99:	48 85 c0             	test   %rax,%rax
  67ce9c:	74 5a                	je     67cef8 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1c8>
  67ce9e:	4d 8d 1c da          	lea    (%r10,%rbx,8),%r11
  67cea2:	49 89 c0             	mov    %rax,%r8
  67cea5:	41 39 53 ec          	cmp    %edx,-0x14(%r11)
  67cea9:	75 4d                	jne    67cef8 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1c8>
  67ceab:	45 31 c0             	xor    %r8d,%r8d
  67ceae:	49 89 cb             	mov    %rcx,%r11
  67ceb1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  67ceb8:	0f 1f 84 00 00 00 00 
  67cebf:	00 
  67cec0:	4d 89 de             	mov    %r11,%r14
  67cec3:	49 d1 ee             	shr    $1,%r14
  67cec6:	4f 8d 3c 06          	lea    (%r14,%r8,1),%r15
  67ceca:	4f 8d 24 7f          	lea    (%r15,%r15,2),%r12
  67cece:	43 39 54 e2 04       	cmp    %edx,0x4(%r10,%r12,8)
  67ced3:	4d 0f 42 c7          	cmovb  %r15,%r8
  67ced7:	4d 29 f3             	sub    %r14,%r11
  67ceda:	49 83 fb 01          	cmp    $0x1,%r11
  67cede:	77 e0                	ja     67cec0 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x190>
  67cee0:	4f 8d 1c 40          	lea    (%r8,%r8,2),%r11
  67cee4:	43 39 54 da 04       	cmp    %edx,0x4(%r10,%r11,8)
  67cee9:	49 83 d0 00          	adc    $0x0,%r8
  67ceed:	4c 8d 59 ff          	lea    -0x1(%rcx),%r11
  67cef1:	4d 39 c3             	cmp    %r8,%r11
  67cef4:	4d 0f 42 c3          	cmovb  %r11,%r8
  67cef8:	49 39 c8             	cmp    %rcx,%r8
  67cefb:	0f 83 b0 01 00 00    	jae    67d0b1 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x381>
  67cf01:	41 8b 09             	mov    (%r9),%ecx
  67cf04:	f3 41 0f 10 51 04    	movss  0x4(%r9),%xmm2
  67cf0a:	45 8b 4c da 04       	mov    0x4(%r10,%rbx,8),%r9d
  67cf0f:	4f 8d 04 40          	lea    (%r8,%r8,2),%r8
  67cf13:	4f 8d 04 c2          	lea    (%r10,%r8,8),%r8
  67cf17:	0f 2e ca             	ucomiss %xmm2,%xmm1
  67cf1a:	75 02                	jne    67cf1e <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x1ee>
  67cf1c:	7b 41                	jnp    67cf5f <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x22f>
  67cf1e:	44 39 c9             	cmp    %r9d,%ecx
  67cf21:	77 3c                	ja     67cf5f <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x22f>
  67cf23:	0f 2e d1             	ucomiss %xmm1,%xmm2
  67cf26:	40 0f 96 c6          	setbe  %sil
  67cf2a:	e9 db 00 00 00       	jmp    67d00a <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x2da>
  67cf2f:	c6 47 04 02          	movb   $0x2,0x4(%rdi)
  67cf33:	e9 41 01 00 00       	jmp    67d079 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x349>
  67cf38:	4d 89 d6             	mov    %r10,%r14
  67cf3b:	4f 8d 04 f0          	lea    (%r8,%r14,8),%r8
  67cf3f:	4d 85 f6             	test   %r14,%r14
  67cf42:	0f 85 81 fe ff ff    	jne    67cdc9 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x99>
  67cf48:	41 b3 03             	mov    $0x3,%r11b
  67cf4b:	f3 41 0f 10 48 04    	movss  0x4(%r8),%xmm1
  67cf51:	f6 c1 01             	test   $0x1,%cl
  67cf54:	0f 85 86 fe ff ff    	jne    67cde0 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0xb0>
  67cf5a:	e9 b4 fe ff ff       	jmp    67ce13 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0xe3>
  67cf5f:	4c 8b 56 20          	mov    0x20(%rsi),%r10
  67cf63:	48 8b 76 28          	mov    0x28(%rsi),%rsi
  67cf67:	49 89 f3             	mov    %rsi,%r11
  67cf6a:	48 85 f6             	test   %rsi,%rsi
  67cf6d:	74 44                	je     67cfb3 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x283>
  67cf6f:	45 31 db             	xor    %r11d,%r11d
  67cf72:	48 83 fe 01          	cmp    $0x1,%rsi
  67cf76:	74 2b                	je     67cfa3 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x273>
  67cf78:	48 89 f3             	mov    %rsi,%rbx
  67cf7b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  67cf80:	49 89 de             	mov    %rbx,%r14
  67cf83:	49 d1 ee             	shr    $1,%r14
  67cf86:	4f 8d 3c 1e          	lea    (%r14,%r11,1),%r15
  67cf8a:	4f 8d 24 7f          	lea    (%r15,%r15,2),%r12
  67cf8e:	47 8b 64 e2 10       	mov    0x10(%r10,%r12,8),%r12d
  67cf93:	4c 39 e0             	cmp    %r12,%rax
  67cf96:	4d 0f 47 df          	cmova  %r15,%r11
  67cf9a:	4c 29 f3             	sub    %r14,%rbx
  67cf9d:	48 83 fb 01          	cmp    $0x1,%rbx
  67cfa1:	77 dd                	ja     67cf80 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x250>
  67cfa3:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  67cfa7:	41 8b 5c da 10       	mov    0x10(%r10,%rbx,8),%ebx
  67cfac:	48 39 c3             	cmp    %rax,%rbx
  67cfaf:	49 83 d3 00          	adc    $0x0,%r11
  67cfb3:	49 c1 e3 03          	shl    $0x3,%r11
  67cfb7:	4f 8d 1c 5b          	lea    (%r11,%r11,2),%r11
  67cfbb:	4b 8d 1c 1a          	lea    (%r10,%r11,1),%rbx
  67cfbf:	48 c1 e6 03          	shl    $0x3,%rsi
  67cfc3:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
  67cfc7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  67cfce:	00 00 
  67cfd0:	4c 39 de             	cmp    %r11,%rsi
  67cfd3:	0f 84 ac 00 00 00    	je     67d085 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x355>
  67cfd9:	49 89 de             	mov    %rbx,%r14
  67cfdc:	8b 5b 10             	mov    0x10(%rbx),%ebx
  67cfdf:	48 39 d8             	cmp    %rbx,%rax
  67cfe2:	0f 85 9d 00 00 00    	jne    67d085 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x355>
  67cfe8:	49 8d 5e 18          	lea    0x18(%r14),%rbx
  67cfec:	49 83 c3 18          	add    $0x18,%r11
  67cff0:	41 39 16             	cmp    %edx,(%r14)
  67cff3:	77 db                	ja     67cfd0 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x2a0>
  67cff5:	41 3b 56 04          	cmp    0x4(%r14),%edx
  67cff9:	77 d5                	ja     67cfd0 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x2a0>
  67cffb:	43 0f b6 74 1a fd    	movzbl -0x3(%r10,%r11,1),%esi
  67d001:	44 39 c9             	cmp    %r9d,%ecx
  67d004:	0f 87 86 00 00 00    	ja     67d090 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x360>
  67d00a:	0f 28 c1             	movaps %xmm1,%xmm0
  67d00d:	f3 0f 5d c2          	minss  %xmm2,%xmm0
  67d011:	0f 28 d8             	movaps %xmm0,%xmm3
  67d014:	f3 0f c2 d8 03       	cmpunordss %xmm0,%xmm3
  67d019:	0f 28 e3             	movaps %xmm3,%xmm4
  67d01c:	0f 55 e0             	andnps %xmm0,%xmm4
  67d01f:	0f 54 d9             	andps  %xmm1,%xmm3
  67d022:	0f 56 dc             	orps   %xmm4,%xmm3
  67d025:	0f 28 c2             	movaps %xmm2,%xmm0
  67d028:	f3 0f 5c c1          	subss  %xmm1,%xmm0
  67d02c:	0f 54 05 cd 82 9a ff 	andps  -0x657d33(%rip),%xmm0        # 25300 <anon.1508e9dce0c1a49d095b8c30671814b4.0.llvm.16300762181250184790+0x7e0>
  67d033:	44 39 c9             	cmp    %r9d,%ecx
  67d036:	f3 41 0f 10 60 08    	movss  0x8(%r8),%xmm4
  67d03c:	f3 41 0f 10 68 0c    	movss  0xc(%r8),%xmm5
  67d042:	89 17                	mov    %edx,(%rdi)
  67d044:	c6 47 04 01          	movb   $0x1,0x4(%rdi)
  67d048:	89 4f 08             	mov    %ecx,0x8(%rdi)
  67d04b:	c6 47 0c 00          	movb   $0x0,0xc(%rdi)
  67d04f:	f3 0f 11 5f 10       	movss  %xmm3,0x10(%rdi)
  67d054:	f3 0f 11 67 14       	movss  %xmm4,0x14(%rdi)
  67d059:	f3 0f 11 47 18       	movss  %xmm0,0x18(%rdi)
  67d05e:	f3 0f 11 6f 1c       	movss  %xmm5,0x1c(%rdi)
  67d063:	48 89 47 20          	mov    %rax,0x20(%rdi)
  67d067:	f3 0f 11 4f 28       	movss  %xmm1,0x28(%rdi)
  67d06c:	f3 0f 11 57 2c       	movss  %xmm2,0x2c(%rdi)
  67d071:	0f 97 47 30          	seta   0x30(%rdi)
  67d075:	40 88 77 31          	mov    %sil,0x31(%rdi)
  67d079:	48 83 c4 08          	add    $0x8,%rsp
  67d07d:	5b                   	pop    %rbx
  67d07e:	41 5c                	pop    %r12
  67d080:	41 5e                	pop    %r14
  67d082:	41 5f                	pop    %r15
  67d084:	c3                   	ret
  67d085:	31 f6                	xor    %esi,%esi
  67d087:	44 39 c9             	cmp    %r9d,%ecx
  67d08a:	0f 86 7a ff ff ff    	jbe    67d00a <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x2da>
  67d090:	0f 28 d9             	movaps %xmm1,%xmm3
  67d093:	40 84 f6             	test   %sil,%sil
  67d096:	74 9b                	je     67d033 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x303>
  67d098:	f3 0f 5c d8          	subss  %xmm0,%xmm3
  67d09c:	eb 95                	jmp    67d033 <<gpui_canvas::text::layout::TextGeometry>::intervals::{closure#0}+0x303>
  67d09e:	48 8d 15 43 26 10 00 	lea    0x102643(%rip),%rdx        # 77f6e8 <anon.02b0c3b15283a2e59147821be92759e6.3.llvm.7075943132055672965+0x90>
  67d0a5:	48 89 c7             	mov    %rax,%rdi
  67d0a8:	48 89 ce             	mov    %rcx,%rsi
  67d0ab:	ff 15 df c7 10 00    	call   *0x10c7df(%rip)        # 789890 <_DYNAMIC+0x368>
  67d0b1:	48 8d 15 48 26 10 00 	lea    0x102648(%rip),%rdx        # 77f700 <anon.02b0c3b15283a2e59147821be92759e6.3.llvm.7075943132055672965+0xa8>
  67d0b8:	4c 89 c7             	mov    %r8,%rdi
  67d0bb:	48 89 ce             	mov    %rcx,%rsi
  67d0be:	ff 15 cc c7 10 00    	call   *0x10c7cc(%rip)        # 789890 <_DYNAMIC+0x368>
