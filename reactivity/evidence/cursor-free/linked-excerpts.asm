Linked release unit-test binary; render_band is deliberately out of line.

  4c6b9f:	cc                   	int3

00000000004c6ba0 <gpui_canvas::canvas::render_rows::<gpui_canvas::canvas::BgrxEncoder>>:
  4c6ba0:	55                   	push   %rbp
  4c6ba1:	41 57                	push   %r15
  4c6ba3:	41 56                	push   %r14
  4c6ba5:	41 55                	push   %r13
  4c6ba7:	41 54                	push   %r12
  4c6ba9:	53                   	push   %rbx
  4c6baa:	48 81 ec 18 03 00 00 	sub    $0x318,%rsp
  4c6bb1:	48 89 fb             	mov    %rdi,%rbx
  4c6bb4:	48 8b ac 24 60 03 00 	mov    0x360(%rsp),%rbp
  4c6bbb:	00 
  4c6bbc:	4c 8b 94 24 58 03 00 	mov    0x358(%rsp),%r10
  4c6bc3:	00 
  4c6bc4:	4c 8b 9c 24 50 03 00 	mov    0x350(%rsp),%r11
  4c6bcb:	00 
  4c6bcc:	4c 8b 66 38          	mov    0x38(%rsi),%r12
  4c6bd0:	48 8b 7e 48          	mov    0x48(%rsi),%rdi
  4c6bd4:	4c 29 e7             	sub    %r12,%rdi
  4c6bd7:	48 83 ff 01          	cmp    $0x1,%rdi
  4c6bdb:	75 1a                	jne    4c6bf7 <gpui_canvas::canvas::render_rows::<gpui_canvas::canvas::BgrxEncoder>+0x57>

  4c1c1f:	cc                   	int3

00000000004c1c20 <gpui_canvas::canvas::render_band::<gpui_canvas::canvas::BgrxEncoder>>:
  4c1c20:	55                   	push   %rbp
  4c1c21:	41 57                	push   %r15
  4c1c23:	41 56                	push   %r14
  4c1c25:	41 55                	push   %r13
  4c1c27:	41 54                	push   %r12
  4c1c29:	53                   	push   %rbx
  4c1c2a:	49 89 e3             	mov    %rsp,%r11
  4c1c2d:	49 81 eb 00 10 01 00 	sub    $0x11000,%r11
  4c1c34:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
  4c1c3b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  4c1c42:	00 
  4c1c43:	4c 39 dc             	cmp    %r11,%rsp
  4c1c46:	75 ec                	jne    4c1c34 <gpui_canvas::canvas::render_band::<gpui_canvas::canvas::BgrxEncoder>+0x14>
  4c1c48:	48 81 ec b8 0b 00 00 	sub    $0xbb8,%rsp
  4c1c4f:	4c 89 8c 24 88 01 00 	mov    %r9,0x188(%rsp)
  4c1c56:	00 
  4c1c57:	4c 89 84 24 a0 00 00 	mov    %r8,0xa0(%rsp)
  4c1c5e:	00 
  4c1c5f:	48 89 8c 24 70 01 00 	mov    %rcx,0x170(%rsp)

  4c23ba:	0f 84 50 0b 00 00    	je     4c2f10 <gpui_canvas::canvas::render_band::<gpui_canvas::canvas::BgrxEncoder>+0x12f0>
  4c23c0:	49 89 fc             	mov    %rdi,%r12
  4c23c3:	0f b7 3b             	movzwl (%rbx),%edi
  4c23c6:	49 8b b6 80 00 00 00 	mov    0x80(%r14),%rsi
  4c23cd:	48 39 fe             	cmp    %rdi,%rsi
  4c23d0:	0f 86 19 14 00 00    	jbe    4c37ef <gpui_canvas::canvas::render_band::<gpui_canvas::canvas::BgrxEncoder>+0x1bcf>
  4c23d6:	48 83 c3 04          	add    $0x4,%rbx
  4c23da:	48 89 5c 24 08       	mov    %rbx,0x8(%rsp)
  4c23df:	49 8b 46 78          	mov    0x78(%r14),%rax
  4c23e3:	8b 14 b8             	mov    (%rax,%rdi,4),%edx
  4c23e6:	4c 8d bc 24 a8 02 00 	lea    0x2a8(%rsp),%r15
  4c23ed:	00 
  4c23ee:	4c 89 ff             	mov    %r15,%rdi
  4c23f1:	4c 89 f6             	mov    %r14,%rsi
  4c23f4:	e8 07 76 00 00       	call   4c9a00 <<gpui_canvas::canvas::DisplayList>::get>
  4c23f9:	8b 9c 24 a8 02 00 00 	mov    0x2a8(%rsp),%ebx
  4c2400:	85 db                	test   %ebx,%ebx
  4c2402:	0f 94 c0             	sete   %al
  4c2405:	84 44 24 03          	test   %al,0x3(%rsp)
  4c2409:	74 75                	je     4c2480 <gpui_canvas::canvas::render_band::<gpui_canvas::canvas::BgrxEncoder>+0x860>
  4c240b:	4c 89 ff             	mov    %r15,%rdi
  4c240e:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi

  4c2f6d:	4d 39 e7             	cmp    %r12,%r15
  4c2f70:	0f 84 d6 f2 ff ff    	je     4c224c <gpui_canvas::canvas::render_band::<gpui_canvas::canvas::BgrxEncoder>+0x62c>
  4c2f76:	43 0f b7 7c 25 fc    	movzwl -0x4(%r13,%r12,1),%edi
  4c2f7c:	48 8b 8c 24 38 01 00 	mov    0x138(%rsp),%rcx
  4c2f83:	00 
  4c2f84:	48 8b b1 80 00 00 00 	mov    0x80(%rcx),%rsi
  4c2f8b:	48 39 fe             	cmp    %rdi,%rsi
  4c2f8e:	0f 86 68 08 00 00    	jbe    4c37fc <gpui_canvas::canvas::render_band::<gpui_canvas::canvas::BgrxEncoder>+0x1bdc>
  4c2f94:	48 8b 41 78          	mov    0x78(%rcx),%rax
  4c2f98:	8b 14 b8             	mov    (%rax,%rdi,4),%edx
  4c2f9b:	48 8d bc 24 80 03 00 	lea    0x380(%rsp),%rdi
  4c2fa2:	00 
  4c2fa3:	48 89 ce             	mov    %rcx,%rsi
  4c2fa6:	e8 55 6a 00 00       	call   4c9a00 <<gpui_canvas::canvas::DisplayList>::get>
  4c2fab:	f3 0f 10 84 24 ec 03 	movss  0x3ec(%rsp),%xmm0
  4c2fb2:	00 00 
  4c2fb4:	0f 2e 05 1d a4 b6 ff 	ucomiss -0x495be3(%rip),%xmm0        # 2d3d8 <anon.6012f703f76728adc1ab0e9d1e27dcb4.306.llvm.4097891651611014805+0x38>
  4c2fbb:	75 a3                	jne    4c2f60 <gpui_canvas::canvas::render_band::<gpui_canvas::canvas::BgrxEncoder>+0x1340>
  4c2fbd:	7a a1                	jp     4c2f60 <gpui_canvas::canvas::render_band::<gpui_canvas::canvas::BgrxEncoder>+0x1340>
  4c2fbf:	83 bc 24 80 03 00 00 	cmpl   $0x0,0x380(%rsp)
  4c2fc6:	00 
  4c2fc7:	75 97                	jne    4c2f60 <gpui_canvas::canvas::render_band::<gpui_canvas::canvas::BgrxEncoder>+0x1340>

