
/tmp/gpui-style-compact-release-target/release/deps/gpui-559efaa5b4b411d5:     file format elf64-x86-64


Disassembly of section .text:

00000000008e7ca0 <gpui::runtime::style_ledger::batch_phase::read_probe>:
  8e7ca0:	41 56                	push   %r14
  8e7ca2:	53                   	push   %rbx
  8e7ca3:	48 83 ec 38          	sub    $0x38,%rsp
  8e7ca7:	48 85 ff             	test   %rdi,%rdi
  8e7caa:	0f 84 a7 0f 00 00    	je     8e8c57 <gpui::runtime::style_ledger::batch_phase::read_probe+0xfb7>
  8e7cb0:	48 89 f9             	mov    %rdi,%rcx
  8e7cb3:	48 8b 97 c8 02 00 00 	mov    0x2c8(%rdi),%rdx
  8e7cba:	48 85 d2             	test   %rdx,%rdx
  8e7cbd:	74 2c                	je     8e7ceb <gpui::runtime::style_ledger::batch_phase::read_probe+0x4b>
  8e7cbf:	48 8b 81 28 02 00 00 	mov    0x228(%rcx),%rax
  8e7cc6:	48 83 f8 01          	cmp    $0x1,%rax
  8e7cca:	74 27                	je     8e7cf3 <gpui::runtime::style_ledger::batch_phase::read_probe+0x53>
  8e7ccc:	48 85 c0             	test   %rax,%rax
  8e7ccf:	0f 85 99 00 00 00    	jne    8e7d6e <gpui::runtime::style_ledger::batch_phase::read_probe+0xce>
  8e7cd5:	48 b8 00 00 00 18 04 	movabs $0x418000000,%rax
  8e7cdc:	00 00 00 
  8e7cdf:	48 0f af d0          	imul   %rax,%rdx
  8e7ce3:	49 89 d0             	mov    %rdx,%r8
  8e7ce6:	e9 1f 0f 00 00       	jmp    8e8c0a <gpui::runtime::style_ledger::batch_phase::read_probe+0xf6a>
  8e7ceb:	45 31 c0             	xor    %r8d,%r8d
  8e7cee:	e9 17 0f 00 00       	jmp    8e8c0a <gpui::runtime::style_ledger::batch_phase::read_probe+0xf6a>
  8e7cf3:	48 8b b1 40 02 00 00 	mov    0x240(%rcx),%rsi
  8e7cfa:	bf 18 00 00 00       	mov    $0x18,%edi
  8e7cff:	45 31 c0             	xor    %r8d,%r8d
  8e7d02:	45 31 c9             	xor    %r9d,%r9d
  8e7d05:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  8e7d0c:	00 00 00 00 
  8e7d10:	4c 39 ce             	cmp    %r9,%rsi
  8e7d13:	0f 84 24 0f 00 00    	je     8e8c3d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf9d>
  8e7d19:	49 ff c1             	inc    %r9
  8e7d1c:	48 8b 81 38 02 00 00 	mov    0x238(%rcx),%rax
  8e7d23:	44 8b 54 38 f8       	mov    -0x8(%rax,%rdi,1),%r10d
  8e7d28:	4d 89 c3             	mov    %r8,%r11
  8e7d2b:	44 8b 04 38          	mov    (%rax,%rdi,1),%r8d
  8e7d2f:	4d 01 d3             	add    %r10,%r11
  8e7d32:	4d 01 d8             	add    %r11,%r8
  8e7d35:	48 83 c7 58          	add    $0x58,%rdi
  8e7d39:	4c 39 ca             	cmp    %r9,%rdx
  8e7d3c:	75 d2                	jne    8e7d10 <gpui::runtime::style_ledger::batch_phase::read_probe+0x70>
  8e7d3e:	4c 8d 4a ff          	lea    -0x1(%rdx),%r9
  8e7d42:	48 89 f7             	mov    %rsi,%rdi
  8e7d45:	4c 39 ce             	cmp    %r9,%rsi
  8e7d48:	0f 86 fc 0e 00 00    	jbe    8e8c4a <gpui::runtime::style_ledger::batch_phase::read_probe+0xfaa>
  8e7d4e:	48 be fc ff ff ff ff 	movabs $0x3fffffffffffffc,%rsi
  8e7d55:	ff ff 03 
  8e7d58:	89 d1                	mov    %edx,%ecx
  8e7d5a:	83 e1 03             	and    $0x3,%ecx
  8e7d5d:	49 83 f9 03          	cmp    $0x3,%r9
  8e7d61:	0f 83 63 04 00 00    	jae    8e81ca <gpui::runtime::style_ledger::batch_phase::read_probe+0x52a>
  8e7d67:	31 ff                	xor    %edi,%edi
  8e7d69:	e9 ca 04 00 00       	jmp    8e8238 <gpui::runtime::style_ledger::batch_phase::read_probe+0x598>
  8e7d6e:	48 8b b9 48 02 00 00 	mov    0x248(%rcx),%rdi
  8e7d75:	48 85 ff             	test   %rdi,%rdi
  8e7d78:	0f 84 9f 0e 00 00    	je     8e8c1d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  8e7d7e:	48 8b b1 38 02 00 00 	mov    0x238(%rcx),%rsi
  8e7d85:	4c 8b 89 40 02 00 00 	mov    0x240(%rcx),%r9
  8e7d8c:	41 0f b6 01          	movzbl (%r9),%eax
  8e7d90:	48 39 c6             	cmp    %rax,%rsi
  8e7d93:	0f 86 94 0e 00 00    	jbe    8e8c2d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  8e7d99:	48 8b 89 30 02 00 00 	mov    0x230(%rcx),%rcx
  8e7da0:	48 6b c0 58          	imul   $0x58,%rax,%rax
  8e7da4:	44 8b 54 01 10       	mov    0x10(%rcx,%rax,1),%r10d
  8e7da9:	44 8b 44 01 18       	mov    0x18(%rcx,%rax,1),%r8d
  8e7dae:	4d 01 d0             	add    %r10,%r8
  8e7db1:	48 83 fa 01          	cmp    $0x1,%rdx
  8e7db5:	75 09                	jne    8e7dc0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x120>
  8e7db7:	49 c1 e0 04          	shl    $0x4,%r8
  8e7dbb:	e9 4a 0e 00 00       	jmp    8e8c0a <gpui::runtime::style_ledger::batch_phase::read_probe+0xf6a>
  8e7dc0:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  8e7dc6:	4d 89 c2             	mov    %r8,%r10
  8e7dc9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8e7dd0:	4c 39 df             	cmp    %r11,%rdi
  8e7dd3:	0f 84 44 0e 00 00    	je     8e8c1d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  8e7dd9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  8e7dde:	48 39 c6             	cmp    %rax,%rsi
  8e7de1:	0f 86 46 0e 00 00    	jbe    8e8c2d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  8e7de7:	49 ff c3             	inc    %r11
  8e7dea:	48 6b c0 58          	imul   $0x58,%rax,%rax
  8e7dee:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  8e7df2:	4d 89 d6             	mov    %r10,%r14
  8e7df5:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  8e7dfa:	49 01 de             	add    %rbx,%r14
  8e7dfd:	4d 01 f2             	add    %r14,%r10
  8e7e00:	4c 39 da             	cmp    %r11,%rdx
  8e7e03:	75 cb                	jne    8e7dd0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x130>
  8e7e05:	4d 01 c2             	add    %r8,%r10
  8e7e08:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  8e7e0e:	66 90                	xchg   %ax,%ax
  8e7e10:	4c 39 df             	cmp    %r11,%rdi
  8e7e13:	0f 84 04 0e 00 00    	je     8e8c1d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  8e7e19:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  8e7e1e:	48 39 c6             	cmp    %rax,%rsi
  8e7e21:	0f 86 06 0e 00 00    	jbe    8e8c2d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  8e7e27:	49 ff c3             	inc    %r11
  8e7e2a:	48 6b c0 58          	imul   $0x58,%rax,%rax
  8e7e2e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  8e7e32:	4d 89 d6             	mov    %r10,%r14
  8e7e35:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  8e7e3a:	49 01 de             	add    %rbx,%r14
  8e7e3d:	4d 01 f2             	add    %r14,%r10
  8e7e40:	4c 39 da             	cmp    %r11,%rdx
  8e7e43:	75 cb                	jne    8e7e10 <gpui::runtime::style_ledger::batch_phase::read_probe+0x170>
  8e7e45:	4d 01 c2             	add    %r8,%r10
  8e7e48:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  8e7e4e:	66 90                	xchg   %ax,%ax
  8e7e50:	4c 39 df             	cmp    %r11,%rdi
  8e7e53:	0f 84 c4 0d 00 00    	je     8e8c1d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  8e7e59:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  8e7e5e:	48 39 c6             	cmp    %rax,%rsi
  8e7e61:	0f 86 c6 0d 00 00    	jbe    8e8c2d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  8e7e67:	49 ff c3             	inc    %r11
  8e7e6a:	48 6b c0 58          	imul   $0x58,%rax,%rax
  8e7e6e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  8e7e72:	4d 89 d6             	mov    %r10,%r14
  8e7e75:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  8e7e7a:	49 01 de             	add    %rbx,%r14
  8e7e7d:	4d 01 f2             	add    %r14,%r10
  8e7e80:	4c 39 da             	cmp    %r11,%rdx
  8e7e83:	75 cb                	jne    8e7e50 <gpui::runtime::style_ledger::batch_phase::read_probe+0x1b0>
  8e7e85:	4d 01 c2             	add    %r8,%r10
  8e7e88:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  8e7e8e:	66 90                	xchg   %ax,%ax
  8e7e90:	4c 39 df             	cmp    %r11,%rdi
  8e7e93:	0f 84 84 0d 00 00    	je     8e8c1d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  8e7e99:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  8e7e9e:	48 39 c6             	cmp    %rax,%rsi
  8e7ea1:	0f 86 86 0d 00 00    	jbe    8e8c2d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  8e7ea7:	49 ff c3             	inc    %r11
  8e7eaa:	48 6b c0 58          	imul   $0x58,%rax,%rax
  8e7eae:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  8e7eb2:	4d 89 d6             	mov    %r10,%r14
  8e7eb5:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  8e7eba:	49 01 de             	add    %rbx,%r14
  8e7ebd:	4d 01 f2             	add    %r14,%r10
  8e7ec0:	4c 39 da             	cmp    %r11,%rdx
  8e7ec3:	75 cb                	jne    8e7e90 <gpui::runtime::style_ledger::batch_phase::read_probe+0x1f0>
  8e7ec5:	4d 01 c2             	add    %r8,%r10
  8e7ec8:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  8e7ece:	66 90                	xchg   %ax,%ax
  8e7ed0:	4c 39 df             	cmp    %r11,%rdi
  8e7ed3:	0f 84 44 0d 00 00    	je     8e8c1d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  8e7ed9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  8e7ede:	48 39 c6             	cmp    %rax,%rsi
  8e7ee1:	0f 86 46 0d 00 00    	jbe    8e8c2d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  8e7ee7:	49 ff c3             	inc    %r11
  8e7eea:	48 6b c0 58          	imul   $0x58,%rax,%rax
  8e7eee:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  8e7ef2:	4d 89 d6             	mov    %r10,%r14
  8e7ef5:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  8e7efa:	49 01 de             	add    %rbx,%r14
  8e7efd:	4d 01 f2             	add    %r14,%r10
  8e7f00:	4c 39 da             	cmp    %r11,%rdx
  8e7f03:	75 cb                	jne    8e7ed0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x230>
  8e7f05:	4d 01 c2             	add    %r8,%r10
  8e7f08:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  8e7f0e:	66 90                	xchg   %ax,%ax
  8e7f10:	4c 39 df             	cmp    %r11,%rdi
  8e7f13:	0f 84 04 0d 00 00    	je     8e8c1d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  8e7f19:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  8e7f1e:	48 39 c6             	cmp    %rax,%rsi
  8e7f21:	0f 86 06 0d 00 00    	jbe    8e8c2d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  8e7f27:	49 ff c3             	inc    %r11
  8e7f2a:	48 6b c0 58          	imul   $0x58,%rax,%rax
  8e7f2e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  8e7f32:	4d 89 d6             	mov    %r10,%r14
  8e7f35:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  8e7f3a:	49 01 de             	add    %rbx,%r14
  8e7f3d:	4d 01 f2             	add    %r14,%r10
  8e7f40:	4c 39 da             	cmp    %r11,%rdx
  8e7f43:	75 cb                	jne    8e7f10 <gpui::runtime::style_ledger::batch_phase::read_probe+0x270>
  8e7f45:	4d 01 c2             	add    %r8,%r10
  8e7f48:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  8e7f4e:	66 90                	xchg   %ax,%ax
  8e7f50:	4c 39 df             	cmp    %r11,%rdi
  8e7f53:	0f 84 c4 0c 00 00    	je     8e8c1d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  8e7f59:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  8e7f5e:	48 39 c6             	cmp    %rax,%rsi
  8e7f61:	0f 86 c6 0c 00 00    	jbe    8e8c2d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  8e7f67:	49 ff c3             	inc    %r11
  8e7f6a:	48 6b c0 58          	imul   $0x58,%rax,%rax
  8e7f6e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  8e7f72:	4d 89 d6             	mov    %r10,%r14
  8e7f75:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  8e7f7a:	49 01 de             	add    %rbx,%r14
  8e7f7d:	4d 01 f2             	add    %r14,%r10
  8e7f80:	4c 39 da             	cmp    %r11,%rdx
  8e7f83:	75 cb                	jne    8e7f50 <gpui::runtime::style_ledger::batch_phase::read_probe+0x2b0>
  8e7f85:	4d 01 c2             	add    %r8,%r10
  8e7f88:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  8e7f8e:	66 90                	xchg   %ax,%ax
  8e7f90:	4c 39 df             	cmp    %r11,%rdi
  8e7f93:	0f 84 84 0c 00 00    	je     8e8c1d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  8e7f99:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  8e7f9e:	48 39 c6             	cmp    %rax,%rsi
  8e7fa1:	0f 86 86 0c 00 00    	jbe    8e8c2d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  8e7fa7:	49 ff c3             	inc    %r11
  8e7faa:	48 6b c0 58          	imul   $0x58,%rax,%rax
  8e7fae:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  8e7fb2:	4d 89 d6             	mov    %r10,%r14
  8e7fb5:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  8e7fba:	49 01 de             	add    %rbx,%r14
  8e7fbd:	4d 01 f2             	add    %r14,%r10
  8e7fc0:	4c 39 da             	cmp    %r11,%rdx
  8e7fc3:	75 cb                	jne    8e7f90 <gpui::runtime::style_ledger::batch_phase::read_probe+0x2f0>
  8e7fc5:	4d 01 c2             	add    %r8,%r10
  8e7fc8:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  8e7fce:	66 90                	xchg   %ax,%ax
  8e7fd0:	4c 39 df             	cmp    %r11,%rdi
  8e7fd3:	0f 84 44 0c 00 00    	je     8e8c1d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  8e7fd9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  8e7fde:	48 39 c6             	cmp    %rax,%rsi
  8e7fe1:	0f 86 46 0c 00 00    	jbe    8e8c2d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  8e7fe7:	49 ff c3             	inc    %r11
  8e7fea:	48 6b c0 58          	imul   $0x58,%rax,%rax
  8e7fee:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  8e7ff2:	4d 89 d6             	mov    %r10,%r14
  8e7ff5:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  8e7ffa:	49 01 de             	add    %rbx,%r14
  8e7ffd:	4d 01 f2             	add    %r14,%r10
  8e8000:	4c 39 da             	cmp    %r11,%rdx
  8e8003:	75 cb                	jne    8e7fd0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x330>
  8e8005:	4d 01 c2             	add    %r8,%r10
  8e8008:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  8e800e:	66 90                	xchg   %ax,%ax
  8e8010:	4c 39 df             	cmp    %r11,%rdi
  8e8013:	0f 84 04 0c 00 00    	je     8e8c1d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  8e8019:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  8e801e:	48 39 c6             	cmp    %rax,%rsi
  8e8021:	0f 86 06 0c 00 00    	jbe    8e8c2d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  8e8027:	49 ff c3             	inc    %r11
  8e802a:	48 6b c0 58          	imul   $0x58,%rax,%rax
  8e802e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  8e8032:	4d 89 d6             	mov    %r10,%r14
  8e8035:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  8e803a:	49 01 de             	add    %rbx,%r14
  8e803d:	4d 01 f2             	add    %r14,%r10
  8e8040:	4c 39 da             	cmp    %r11,%rdx
  8e8043:	75 cb                	jne    8e8010 <gpui::runtime::style_ledger::batch_phase::read_probe+0x370>
  8e8045:	4d 01 c2             	add    %r8,%r10
  8e8048:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  8e804e:	66 90                	xchg   %ax,%ax
  8e8050:	4c 39 df             	cmp    %r11,%rdi
  8e8053:	0f 84 c4 0b 00 00    	je     8e8c1d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  8e8059:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  8e805e:	48 39 c6             	cmp    %rax,%rsi
  8e8061:	0f 86 c6 0b 00 00    	jbe    8e8c2d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  8e8067:	49 ff c3             	inc    %r11
  8e806a:	48 6b c0 58          	imul   $0x58,%rax,%rax
  8e806e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  8e8072:	4d 89 d6             	mov    %r10,%r14
  8e8075:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  8e807a:	49 01 de             	add    %rbx,%r14
  8e807d:	4d 01 f2             	add    %r14,%r10
  8e8080:	4c 39 da             	cmp    %r11,%rdx
  8e8083:	75 cb                	jne    8e8050 <gpui::runtime::style_ledger::batch_phase::read_probe+0x3b0>
  8e8085:	4d 01 c2             	add    %r8,%r10
  8e8088:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  8e808e:	66 90                	xchg   %ax,%ax
  8e8090:	4c 39 df             	cmp    %r11,%rdi
  8e8093:	0f 84 84 0b 00 00    	je     8e8c1d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  8e8099:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  8e809e:	48 39 c6             	cmp    %rax,%rsi
  8e80a1:	0f 86 86 0b 00 00    	jbe    8e8c2d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  8e80a7:	49 ff c3             	inc    %r11
  8e80aa:	48 6b c0 58          	imul   $0x58,%rax,%rax
  8e80ae:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  8e80b2:	4d 89 d6             	mov    %r10,%r14
  8e80b5:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  8e80ba:	49 01 de             	add    %rbx,%r14
  8e80bd:	4d 01 f2             	add    %r14,%r10
  8e80c0:	4c 39 da             	cmp    %r11,%rdx
  8e80c3:	75 cb                	jne    8e8090 <gpui::runtime::style_ledger::batch_phase::read_probe+0x3f0>
  8e80c5:	4d 01 c2             	add    %r8,%r10
  8e80c8:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  8e80ce:	66 90                	xchg   %ax,%ax
  8e80d0:	4c 39 df             	cmp    %r11,%rdi
  8e80d3:	0f 84 44 0b 00 00    	je     8e8c1d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  8e80d9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  8e80de:	48 39 c6             	cmp    %rax,%rsi
  8e80e1:	0f 86 46 0b 00 00    	jbe    8e8c2d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  8e80e7:	49 ff c3             	inc    %r11
  8e80ea:	48 6b c0 58          	imul   $0x58,%rax,%rax
  8e80ee:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  8e80f2:	4d 89 d6             	mov    %r10,%r14
  8e80f5:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  8e80fa:	49 01 de             	add    %rbx,%r14
  8e80fd:	4d 01 f2             	add    %r14,%r10
  8e8100:	4c 39 da             	cmp    %r11,%rdx
  8e8103:	75 cb                	jne    8e80d0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x430>
  8e8105:	4d 01 c2             	add    %r8,%r10
  8e8108:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  8e810e:	66 90                	xchg   %ax,%ax
  8e8110:	4c 39 df             	cmp    %r11,%rdi
  8e8113:	0f 84 04 0b 00 00    	je     8e8c1d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  8e8119:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  8e811e:	48 39 c6             	cmp    %rax,%rsi
  8e8121:	0f 86 06 0b 00 00    	jbe    8e8c2d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  8e8127:	49 ff c3             	inc    %r11
  8e812a:	48 6b c0 58          	imul   $0x58,%rax,%rax
  8e812e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  8e8132:	4d 89 d6             	mov    %r10,%r14
  8e8135:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  8e813a:	49 01 de             	add    %rbx,%r14
  8e813d:	4d 01 f2             	add    %r14,%r10
  8e8140:	4c 39 da             	cmp    %r11,%rdx
  8e8143:	75 cb                	jne    8e8110 <gpui::runtime::style_ledger::batch_phase::read_probe+0x470>
  8e8145:	4d 01 c2             	add    %r8,%r10
  8e8148:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  8e814e:	66 90                	xchg   %ax,%ax
  8e8150:	4c 39 df             	cmp    %r11,%rdi
  8e8153:	0f 84 c4 0a 00 00    	je     8e8c1d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  8e8159:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  8e815e:	48 39 c6             	cmp    %rax,%rsi
  8e8161:	0f 86 c6 0a 00 00    	jbe    8e8c2d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  8e8167:	49 ff c3             	inc    %r11
  8e816a:	48 6b c0 58          	imul   $0x58,%rax,%rax
  8e816e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  8e8172:	4d 89 d6             	mov    %r10,%r14
  8e8175:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  8e817a:	49 01 de             	add    %rbx,%r14
  8e817d:	4d 01 f2             	add    %r14,%r10
  8e8180:	4c 39 da             	cmp    %r11,%rdx
  8e8183:	75 cb                	jne    8e8150 <gpui::runtime::style_ledger::batch_phase::read_probe+0x4b0>
  8e8185:	4d 01 c2             	add    %r8,%r10
  8e8188:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  8e818e:	66 90                	xchg   %ax,%ax
  8e8190:	4c 39 df             	cmp    %r11,%rdi
  8e8193:	0f 84 84 0a 00 00    	je     8e8c1d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  8e8199:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  8e819e:	48 39 c6             	cmp    %rax,%rsi
  8e81a1:	0f 86 86 0a 00 00    	jbe    8e8c2d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  8e81a7:	49 ff c3             	inc    %r11
  8e81aa:	48 6b c0 58          	imul   $0x58,%rax,%rax
  8e81ae:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  8e81b2:	44 8b 44 01 18       	mov    0x18(%rcx,%rax,1),%r8d
  8e81b7:	49 01 da             	add    %rbx,%r10
  8e81ba:	4d 01 d0             	add    %r10,%r8
  8e81bd:	4d 89 c2             	mov    %r8,%r10
  8e81c0:	4c 39 da             	cmp    %r11,%rdx
  8e81c3:	75 cb                	jne    8e8190 <gpui::runtime::style_ledger::batch_phase::read_probe+0x4f0>
  8e81c5:	e9 40 0a 00 00       	jmp    8e8c0a <gpui::runtime::style_ledger::batch_phase::read_probe+0xf6a>
  8e81ca:	49 89 d2             	mov    %rdx,%r10
  8e81cd:	49 21 f2             	and    %rsi,%r10
  8e81d0:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  8e81d7:	31 ff                	xor    %edi,%edi
  8e81d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8e81e0:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  8e81e7:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  8e81ee:	4c 01 c3             	add    %r8,%rbx
  8e81f1:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  8e81f8:	4d 01 f0             	add    %r14,%r8
  8e81fb:	49 01 d8             	add    %rbx,%r8
  8e81fe:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  8e8205:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  8e8209:	49 01 de             	add    %rbx,%r14
  8e820c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  8e8210:	4c 01 f3             	add    %r14,%rbx
  8e8213:	4c 01 c3             	add    %r8,%rbx
  8e8216:	48 83 c7 04          	add    $0x4,%rdi
  8e821a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  8e821e:	45 8b 03             	mov    (%r11),%r8d
  8e8221:	4d 01 f0             	add    %r14,%r8
  8e8224:	49 01 d8             	add    %rbx,%r8
  8e8227:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  8e822e:	49 39 fa             	cmp    %rdi,%r10
  8e8231:	75 ad                	jne    8e81e0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x540>
  8e8233:	48 85 c9             	test   %rcx,%rcx
  8e8236:	74 33                	je     8e826b <gpui::runtime::style_ledger::batch_phase::read_probe+0x5cb>
  8e8238:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  8e823c:	48 01 c7             	add    %rax,%rdi
  8e823f:	48 83 c7 18          	add    $0x18,%rdi
  8e8243:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  8e8247:	45 31 db             	xor    %r11d,%r11d
  8e824a:	4c 89 c3             	mov    %r8,%rbx
  8e824d:	0f 1f 00             	nopl   (%rax)
  8e8250:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  8e8255:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  8e8259:	49 01 de             	add    %rbx,%r14
  8e825c:	4d 01 f0             	add    %r14,%r8
  8e825f:	49 83 c3 58          	add    $0x58,%r11
  8e8263:	4c 89 c3             	mov    %r8,%rbx
  8e8266:	4d 39 da             	cmp    %r11,%r10
  8e8269:	75 e5                	jne    8e8250 <gpui::runtime::style_ledger::batch_phase::read_probe+0x5b0>
  8e826b:	49 83 f9 03          	cmp    $0x3,%r9
  8e826f:	73 04                	jae    8e8275 <gpui::runtime::style_ledger::batch_phase::read_probe+0x5d5>
  8e8271:	31 ff                	xor    %edi,%edi
  8e8273:	eb 73                	jmp    8e82e8 <gpui::runtime::style_ledger::batch_phase::read_probe+0x648>
  8e8275:	49 89 d2             	mov    %rdx,%r10
  8e8278:	49 21 f2             	and    %rsi,%r10
  8e827b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  8e8282:	31 ff                	xor    %edi,%edi
  8e8284:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  8e828b:	00 00 00 00 00 
  8e8290:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  8e8297:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  8e829e:	4c 01 c3             	add    %r8,%rbx
  8e82a1:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  8e82a8:	4d 01 f0             	add    %r14,%r8
  8e82ab:	49 01 d8             	add    %rbx,%r8
  8e82ae:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  8e82b5:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  8e82b9:	49 01 de             	add    %rbx,%r14
  8e82bc:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  8e82c0:	4c 01 f3             	add    %r14,%rbx
  8e82c3:	4c 01 c3             	add    %r8,%rbx
  8e82c6:	48 83 c7 04          	add    $0x4,%rdi
  8e82ca:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  8e82ce:	45 8b 03             	mov    (%r11),%r8d
  8e82d1:	4d 01 f0             	add    %r14,%r8
  8e82d4:	49 01 d8             	add    %rbx,%r8
  8e82d7:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  8e82de:	49 39 fa             	cmp    %rdi,%r10
  8e82e1:	75 ad                	jne    8e8290 <gpui::runtime::style_ledger::batch_phase::read_probe+0x5f0>
  8e82e3:	f6 c2 03             	test   $0x3,%dl
  8e82e6:	74 33                	je     8e831b <gpui::runtime::style_ledger::batch_phase::read_probe+0x67b>
  8e82e8:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  8e82ec:	48 01 c7             	add    %rax,%rdi
  8e82ef:	48 83 c7 18          	add    $0x18,%rdi
  8e82f3:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  8e82f7:	45 31 db             	xor    %r11d,%r11d
  8e82fa:	4c 89 c3             	mov    %r8,%rbx
  8e82fd:	0f 1f 00             	nopl   (%rax)
  8e8300:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  8e8305:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  8e8309:	49 01 de             	add    %rbx,%r14
  8e830c:	4d 01 f0             	add    %r14,%r8
  8e830f:	49 83 c3 58          	add    $0x58,%r11
  8e8313:	4c 89 c3             	mov    %r8,%rbx
  8e8316:	4d 39 da             	cmp    %r11,%r10
  8e8319:	75 e5                	jne    8e8300 <gpui::runtime::style_ledger::batch_phase::read_probe+0x660>
  8e831b:	49 83 f9 03          	cmp    $0x3,%r9
  8e831f:	73 04                	jae    8e8325 <gpui::runtime::style_ledger::batch_phase::read_probe+0x685>
  8e8321:	31 ff                	xor    %edi,%edi
  8e8323:	eb 73                	jmp    8e8398 <gpui::runtime::style_ledger::batch_phase::read_probe+0x6f8>
  8e8325:	49 89 d2             	mov    %rdx,%r10
  8e8328:	49 21 f2             	and    %rsi,%r10
  8e832b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  8e8332:	31 ff                	xor    %edi,%edi
  8e8334:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  8e833b:	00 00 00 00 00 
  8e8340:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  8e8347:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  8e834e:	4c 01 c3             	add    %r8,%rbx
  8e8351:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  8e8358:	4d 01 f0             	add    %r14,%r8
  8e835b:	49 01 d8             	add    %rbx,%r8
  8e835e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  8e8365:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  8e8369:	49 01 de             	add    %rbx,%r14
  8e836c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  8e8370:	4c 01 f3             	add    %r14,%rbx
  8e8373:	4c 01 c3             	add    %r8,%rbx
  8e8376:	48 83 c7 04          	add    $0x4,%rdi
  8e837a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  8e837e:	45 8b 03             	mov    (%r11),%r8d
  8e8381:	4d 01 f0             	add    %r14,%r8
  8e8384:	49 01 d8             	add    %rbx,%r8
  8e8387:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  8e838e:	49 39 fa             	cmp    %rdi,%r10
  8e8391:	75 ad                	jne    8e8340 <gpui::runtime::style_ledger::batch_phase::read_probe+0x6a0>
  8e8393:	f6 c2 03             	test   $0x3,%dl
  8e8396:	74 33                	je     8e83cb <gpui::runtime::style_ledger::batch_phase::read_probe+0x72b>
  8e8398:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  8e839c:	48 01 c7             	add    %rax,%rdi
  8e839f:	48 83 c7 18          	add    $0x18,%rdi
  8e83a3:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  8e83a7:	45 31 db             	xor    %r11d,%r11d
  8e83aa:	4c 89 c3             	mov    %r8,%rbx
  8e83ad:	0f 1f 00             	nopl   (%rax)
  8e83b0:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  8e83b5:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  8e83b9:	49 01 de             	add    %rbx,%r14
  8e83bc:	4d 01 f0             	add    %r14,%r8
  8e83bf:	49 83 c3 58          	add    $0x58,%r11
  8e83c3:	4c 89 c3             	mov    %r8,%rbx
  8e83c6:	4d 39 da             	cmp    %r11,%r10
  8e83c9:	75 e5                	jne    8e83b0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x710>
  8e83cb:	49 83 f9 03          	cmp    $0x3,%r9
  8e83cf:	73 04                	jae    8e83d5 <gpui::runtime::style_ledger::batch_phase::read_probe+0x735>
  8e83d1:	31 ff                	xor    %edi,%edi
  8e83d3:	eb 73                	jmp    8e8448 <gpui::runtime::style_ledger::batch_phase::read_probe+0x7a8>
  8e83d5:	49 89 d2             	mov    %rdx,%r10
  8e83d8:	49 21 f2             	and    %rsi,%r10
  8e83db:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  8e83e2:	31 ff                	xor    %edi,%edi
  8e83e4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  8e83eb:	00 00 00 00 00 
  8e83f0:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  8e83f7:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  8e83fe:	4c 01 c3             	add    %r8,%rbx
  8e8401:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  8e8408:	4d 01 f0             	add    %r14,%r8
  8e840b:	49 01 d8             	add    %rbx,%r8
  8e840e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  8e8415:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  8e8419:	49 01 de             	add    %rbx,%r14
  8e841c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  8e8420:	4c 01 f3             	add    %r14,%rbx
  8e8423:	4c 01 c3             	add    %r8,%rbx
  8e8426:	48 83 c7 04          	add    $0x4,%rdi
  8e842a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  8e842e:	45 8b 03             	mov    (%r11),%r8d
  8e8431:	4d 01 f0             	add    %r14,%r8
  8e8434:	49 01 d8             	add    %rbx,%r8
  8e8437:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  8e843e:	49 39 fa             	cmp    %rdi,%r10
  8e8441:	75 ad                	jne    8e83f0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x750>
  8e8443:	f6 c2 03             	test   $0x3,%dl
  8e8446:	74 33                	je     8e847b <gpui::runtime::style_ledger::batch_phase::read_probe+0x7db>
  8e8448:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  8e844c:	48 01 c7             	add    %rax,%rdi
  8e844f:	48 83 c7 18          	add    $0x18,%rdi
  8e8453:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  8e8457:	45 31 db             	xor    %r11d,%r11d
  8e845a:	4c 89 c3             	mov    %r8,%rbx
  8e845d:	0f 1f 00             	nopl   (%rax)
  8e8460:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  8e8465:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  8e8469:	49 01 de             	add    %rbx,%r14
  8e846c:	4d 01 f0             	add    %r14,%r8
  8e846f:	49 83 c3 58          	add    $0x58,%r11
  8e8473:	4c 89 c3             	mov    %r8,%rbx
  8e8476:	4d 39 da             	cmp    %r11,%r10
  8e8479:	75 e5                	jne    8e8460 <gpui::runtime::style_ledger::batch_phase::read_probe+0x7c0>
  8e847b:	49 83 f9 03          	cmp    $0x3,%r9
  8e847f:	73 04                	jae    8e8485 <gpui::runtime::style_ledger::batch_phase::read_probe+0x7e5>
  8e8481:	31 ff                	xor    %edi,%edi
  8e8483:	eb 73                	jmp    8e84f8 <gpui::runtime::style_ledger::batch_phase::read_probe+0x858>
  8e8485:	49 89 d2             	mov    %rdx,%r10
  8e8488:	49 21 f2             	and    %rsi,%r10
  8e848b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  8e8492:	31 ff                	xor    %edi,%edi
  8e8494:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  8e849b:	00 00 00 00 00 
  8e84a0:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  8e84a7:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  8e84ae:	4c 01 c3             	add    %r8,%rbx
  8e84b1:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  8e84b8:	4d 01 f0             	add    %r14,%r8
  8e84bb:	49 01 d8             	add    %rbx,%r8
  8e84be:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  8e84c5:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  8e84c9:	49 01 de             	add    %rbx,%r14
  8e84cc:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  8e84d0:	4c 01 f3             	add    %r14,%rbx
  8e84d3:	4c 01 c3             	add    %r8,%rbx
  8e84d6:	48 83 c7 04          	add    $0x4,%rdi
  8e84da:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  8e84de:	45 8b 03             	mov    (%r11),%r8d
  8e84e1:	4d 01 f0             	add    %r14,%r8
  8e84e4:	49 01 d8             	add    %rbx,%r8
  8e84e7:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  8e84ee:	49 39 fa             	cmp    %rdi,%r10
  8e84f1:	75 ad                	jne    8e84a0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x800>
  8e84f3:	f6 c2 03             	test   $0x3,%dl
  8e84f6:	74 33                	je     8e852b <gpui::runtime::style_ledger::batch_phase::read_probe+0x88b>
  8e84f8:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  8e84fc:	48 01 c7             	add    %rax,%rdi
  8e84ff:	48 83 c7 18          	add    $0x18,%rdi
  8e8503:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  8e8507:	45 31 db             	xor    %r11d,%r11d
  8e850a:	4c 89 c3             	mov    %r8,%rbx
  8e850d:	0f 1f 00             	nopl   (%rax)
  8e8510:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  8e8515:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  8e8519:	49 01 de             	add    %rbx,%r14
  8e851c:	4d 01 f0             	add    %r14,%r8
  8e851f:	49 83 c3 58          	add    $0x58,%r11
  8e8523:	4c 89 c3             	mov    %r8,%rbx
  8e8526:	4d 39 da             	cmp    %r11,%r10
  8e8529:	75 e5                	jne    8e8510 <gpui::runtime::style_ledger::batch_phase::read_probe+0x870>
  8e852b:	49 83 f9 03          	cmp    $0x3,%r9
  8e852f:	73 04                	jae    8e8535 <gpui::runtime::style_ledger::batch_phase::read_probe+0x895>
  8e8531:	31 ff                	xor    %edi,%edi
  8e8533:	eb 73                	jmp    8e85a8 <gpui::runtime::style_ledger::batch_phase::read_probe+0x908>
  8e8535:	49 89 d2             	mov    %rdx,%r10
  8e8538:	49 21 f2             	and    %rsi,%r10
  8e853b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  8e8542:	31 ff                	xor    %edi,%edi
  8e8544:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  8e854b:	00 00 00 00 00 
  8e8550:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  8e8557:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  8e855e:	4c 01 c3             	add    %r8,%rbx
  8e8561:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  8e8568:	4d 01 f0             	add    %r14,%r8
  8e856b:	49 01 d8             	add    %rbx,%r8
  8e856e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  8e8575:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  8e8579:	49 01 de             	add    %rbx,%r14
  8e857c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  8e8580:	4c 01 f3             	add    %r14,%rbx
  8e8583:	4c 01 c3             	add    %r8,%rbx
  8e8586:	48 83 c7 04          	add    $0x4,%rdi
  8e858a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  8e858e:	45 8b 03             	mov    (%r11),%r8d
  8e8591:	4d 01 f0             	add    %r14,%r8
  8e8594:	49 01 d8             	add    %rbx,%r8
  8e8597:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  8e859e:	49 39 fa             	cmp    %rdi,%r10
  8e85a1:	75 ad                	jne    8e8550 <gpui::runtime::style_ledger::batch_phase::read_probe+0x8b0>
  8e85a3:	f6 c2 03             	test   $0x3,%dl
  8e85a6:	74 33                	je     8e85db <gpui::runtime::style_ledger::batch_phase::read_probe+0x93b>
  8e85a8:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  8e85ac:	48 01 c7             	add    %rax,%rdi
  8e85af:	48 83 c7 18          	add    $0x18,%rdi
  8e85b3:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  8e85b7:	45 31 db             	xor    %r11d,%r11d
  8e85ba:	4c 89 c3             	mov    %r8,%rbx
  8e85bd:	0f 1f 00             	nopl   (%rax)
  8e85c0:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  8e85c5:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  8e85c9:	49 01 de             	add    %rbx,%r14
  8e85cc:	4d 01 f0             	add    %r14,%r8
  8e85cf:	49 83 c3 58          	add    $0x58,%r11
  8e85d3:	4c 89 c3             	mov    %r8,%rbx
  8e85d6:	4d 39 da             	cmp    %r11,%r10
  8e85d9:	75 e5                	jne    8e85c0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x920>
  8e85db:	49 83 f9 03          	cmp    $0x3,%r9
  8e85df:	73 04                	jae    8e85e5 <gpui::runtime::style_ledger::batch_phase::read_probe+0x945>
  8e85e1:	31 ff                	xor    %edi,%edi
  8e85e3:	eb 73                	jmp    8e8658 <gpui::runtime::style_ledger::batch_phase::read_probe+0x9b8>
  8e85e5:	49 89 d2             	mov    %rdx,%r10
  8e85e8:	49 21 f2             	and    %rsi,%r10
  8e85eb:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  8e85f2:	31 ff                	xor    %edi,%edi
  8e85f4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  8e85fb:	00 00 00 00 00 
  8e8600:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  8e8607:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  8e860e:	4c 01 c3             	add    %r8,%rbx
  8e8611:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  8e8618:	4d 01 f0             	add    %r14,%r8
  8e861b:	49 01 d8             	add    %rbx,%r8
  8e861e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  8e8625:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  8e8629:	49 01 de             	add    %rbx,%r14
  8e862c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  8e8630:	4c 01 f3             	add    %r14,%rbx
  8e8633:	4c 01 c3             	add    %r8,%rbx
  8e8636:	48 83 c7 04          	add    $0x4,%rdi
  8e863a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  8e863e:	45 8b 03             	mov    (%r11),%r8d
  8e8641:	4d 01 f0             	add    %r14,%r8
  8e8644:	49 01 d8             	add    %rbx,%r8
  8e8647:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  8e864e:	49 39 fa             	cmp    %rdi,%r10
  8e8651:	75 ad                	jne    8e8600 <gpui::runtime::style_ledger::batch_phase::read_probe+0x960>
  8e8653:	f6 c2 03             	test   $0x3,%dl
  8e8656:	74 33                	je     8e868b <gpui::runtime::style_ledger::batch_phase::read_probe+0x9eb>
  8e8658:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  8e865c:	48 01 c7             	add    %rax,%rdi
  8e865f:	48 83 c7 18          	add    $0x18,%rdi
  8e8663:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  8e8667:	45 31 db             	xor    %r11d,%r11d
  8e866a:	4c 89 c3             	mov    %r8,%rbx
  8e866d:	0f 1f 00             	nopl   (%rax)
  8e8670:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  8e8675:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  8e8679:	49 01 de             	add    %rbx,%r14
  8e867c:	4d 01 f0             	add    %r14,%r8
  8e867f:	49 83 c3 58          	add    $0x58,%r11
  8e8683:	4c 89 c3             	mov    %r8,%rbx
  8e8686:	4d 39 da             	cmp    %r11,%r10
  8e8689:	75 e5                	jne    8e8670 <gpui::runtime::style_ledger::batch_phase::read_probe+0x9d0>
  8e868b:	49 83 f9 03          	cmp    $0x3,%r9
  8e868f:	73 04                	jae    8e8695 <gpui::runtime::style_ledger::batch_phase::read_probe+0x9f5>
  8e8691:	31 ff                	xor    %edi,%edi
  8e8693:	eb 73                	jmp    8e8708 <gpui::runtime::style_ledger::batch_phase::read_probe+0xa68>
  8e8695:	49 89 d2             	mov    %rdx,%r10
  8e8698:	49 21 f2             	and    %rsi,%r10
  8e869b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  8e86a2:	31 ff                	xor    %edi,%edi
  8e86a4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  8e86ab:	00 00 00 00 00 
  8e86b0:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  8e86b7:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  8e86be:	4c 01 c3             	add    %r8,%rbx
  8e86c1:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  8e86c8:	4d 01 f0             	add    %r14,%r8
  8e86cb:	49 01 d8             	add    %rbx,%r8
  8e86ce:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  8e86d5:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  8e86d9:	49 01 de             	add    %rbx,%r14
  8e86dc:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  8e86e0:	4c 01 f3             	add    %r14,%rbx
  8e86e3:	4c 01 c3             	add    %r8,%rbx
  8e86e6:	48 83 c7 04          	add    $0x4,%rdi
  8e86ea:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  8e86ee:	45 8b 03             	mov    (%r11),%r8d
  8e86f1:	4d 01 f0             	add    %r14,%r8
  8e86f4:	49 01 d8             	add    %rbx,%r8
  8e86f7:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  8e86fe:	49 39 fa             	cmp    %rdi,%r10
  8e8701:	75 ad                	jne    8e86b0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xa10>
  8e8703:	f6 c2 03             	test   $0x3,%dl
  8e8706:	74 33                	je     8e873b <gpui::runtime::style_ledger::batch_phase::read_probe+0xa9b>
  8e8708:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  8e870c:	48 01 c7             	add    %rax,%rdi
  8e870f:	48 83 c7 18          	add    $0x18,%rdi
  8e8713:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  8e8717:	45 31 db             	xor    %r11d,%r11d
  8e871a:	4c 89 c3             	mov    %r8,%rbx
  8e871d:	0f 1f 00             	nopl   (%rax)
  8e8720:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  8e8725:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  8e8729:	49 01 de             	add    %rbx,%r14
  8e872c:	4d 01 f0             	add    %r14,%r8
  8e872f:	49 83 c3 58          	add    $0x58,%r11
  8e8733:	4c 89 c3             	mov    %r8,%rbx
  8e8736:	4d 39 da             	cmp    %r11,%r10
  8e8739:	75 e5                	jne    8e8720 <gpui::runtime::style_ledger::batch_phase::read_probe+0xa80>
  8e873b:	49 83 f9 03          	cmp    $0x3,%r9
  8e873f:	73 04                	jae    8e8745 <gpui::runtime::style_ledger::batch_phase::read_probe+0xaa5>
  8e8741:	31 ff                	xor    %edi,%edi
  8e8743:	eb 73                	jmp    8e87b8 <gpui::runtime::style_ledger::batch_phase::read_probe+0xb18>
  8e8745:	49 89 d2             	mov    %rdx,%r10
  8e8748:	49 21 f2             	and    %rsi,%r10
  8e874b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  8e8752:	31 ff                	xor    %edi,%edi
  8e8754:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  8e875b:	00 00 00 00 00 
  8e8760:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  8e8767:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  8e876e:	4c 01 c3             	add    %r8,%rbx
  8e8771:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  8e8778:	4d 01 f0             	add    %r14,%r8
  8e877b:	49 01 d8             	add    %rbx,%r8
  8e877e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  8e8785:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  8e8789:	49 01 de             	add    %rbx,%r14
  8e878c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  8e8790:	4c 01 f3             	add    %r14,%rbx
  8e8793:	4c 01 c3             	add    %r8,%rbx
  8e8796:	48 83 c7 04          	add    $0x4,%rdi
  8e879a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  8e879e:	45 8b 03             	mov    (%r11),%r8d
  8e87a1:	4d 01 f0             	add    %r14,%r8
  8e87a4:	49 01 d8             	add    %rbx,%r8
  8e87a7:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  8e87ae:	49 39 fa             	cmp    %rdi,%r10
  8e87b1:	75 ad                	jne    8e8760 <gpui::runtime::style_ledger::batch_phase::read_probe+0xac0>
  8e87b3:	f6 c2 03             	test   $0x3,%dl
  8e87b6:	74 33                	je     8e87eb <gpui::runtime::style_ledger::batch_phase::read_probe+0xb4b>
  8e87b8:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  8e87bc:	48 01 c7             	add    %rax,%rdi
  8e87bf:	48 83 c7 18          	add    $0x18,%rdi
  8e87c3:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  8e87c7:	45 31 db             	xor    %r11d,%r11d
  8e87ca:	4c 89 c3             	mov    %r8,%rbx
  8e87cd:	0f 1f 00             	nopl   (%rax)
  8e87d0:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  8e87d5:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  8e87d9:	49 01 de             	add    %rbx,%r14
  8e87dc:	4d 01 f0             	add    %r14,%r8
  8e87df:	49 83 c3 58          	add    $0x58,%r11
  8e87e3:	4c 89 c3             	mov    %r8,%rbx
  8e87e6:	4d 39 da             	cmp    %r11,%r10
  8e87e9:	75 e5                	jne    8e87d0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xb30>
  8e87eb:	49 83 f9 03          	cmp    $0x3,%r9
  8e87ef:	73 04                	jae    8e87f5 <gpui::runtime::style_ledger::batch_phase::read_probe+0xb55>
  8e87f1:	31 ff                	xor    %edi,%edi
  8e87f3:	eb 73                	jmp    8e8868 <gpui::runtime::style_ledger::batch_phase::read_probe+0xbc8>
  8e87f5:	49 89 d2             	mov    %rdx,%r10
  8e87f8:	49 21 f2             	and    %rsi,%r10
  8e87fb:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  8e8802:	31 ff                	xor    %edi,%edi
  8e8804:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  8e880b:	00 00 00 00 00 
  8e8810:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  8e8817:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  8e881e:	4c 01 c3             	add    %r8,%rbx
  8e8821:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  8e8828:	4d 01 f0             	add    %r14,%r8
  8e882b:	49 01 d8             	add    %rbx,%r8
  8e882e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  8e8835:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  8e8839:	49 01 de             	add    %rbx,%r14
  8e883c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  8e8840:	4c 01 f3             	add    %r14,%rbx
  8e8843:	4c 01 c3             	add    %r8,%rbx
  8e8846:	48 83 c7 04          	add    $0x4,%rdi
  8e884a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  8e884e:	45 8b 03             	mov    (%r11),%r8d
  8e8851:	4d 01 f0             	add    %r14,%r8
  8e8854:	49 01 d8             	add    %rbx,%r8
  8e8857:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  8e885e:	49 39 fa             	cmp    %rdi,%r10
  8e8861:	75 ad                	jne    8e8810 <gpui::runtime::style_ledger::batch_phase::read_probe+0xb70>
  8e8863:	f6 c2 03             	test   $0x3,%dl
  8e8866:	74 33                	je     8e889b <gpui::runtime::style_ledger::batch_phase::read_probe+0xbfb>
  8e8868:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  8e886c:	48 01 c7             	add    %rax,%rdi
  8e886f:	48 83 c7 18          	add    $0x18,%rdi
  8e8873:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  8e8877:	45 31 db             	xor    %r11d,%r11d
  8e887a:	4c 89 c3             	mov    %r8,%rbx
  8e887d:	0f 1f 00             	nopl   (%rax)
  8e8880:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  8e8885:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  8e8889:	49 01 de             	add    %rbx,%r14
  8e888c:	4d 01 f0             	add    %r14,%r8
  8e888f:	49 83 c3 58          	add    $0x58,%r11
  8e8893:	4c 89 c3             	mov    %r8,%rbx
  8e8896:	4d 39 da             	cmp    %r11,%r10
  8e8899:	75 e5                	jne    8e8880 <gpui::runtime::style_ledger::batch_phase::read_probe+0xbe0>
  8e889b:	49 83 f9 03          	cmp    $0x3,%r9
  8e889f:	73 04                	jae    8e88a5 <gpui::runtime::style_ledger::batch_phase::read_probe+0xc05>
  8e88a1:	31 ff                	xor    %edi,%edi
  8e88a3:	eb 73                	jmp    8e8918 <gpui::runtime::style_ledger::batch_phase::read_probe+0xc78>
  8e88a5:	49 89 d2             	mov    %rdx,%r10
  8e88a8:	49 21 f2             	and    %rsi,%r10
  8e88ab:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  8e88b2:	31 ff                	xor    %edi,%edi
  8e88b4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  8e88bb:	00 00 00 00 00 
  8e88c0:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  8e88c7:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  8e88ce:	4c 01 c3             	add    %r8,%rbx
  8e88d1:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  8e88d8:	4d 01 f0             	add    %r14,%r8
  8e88db:	49 01 d8             	add    %rbx,%r8
  8e88de:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  8e88e5:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  8e88e9:	49 01 de             	add    %rbx,%r14
  8e88ec:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  8e88f0:	4c 01 f3             	add    %r14,%rbx
  8e88f3:	4c 01 c3             	add    %r8,%rbx
  8e88f6:	48 83 c7 04          	add    $0x4,%rdi
  8e88fa:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  8e88fe:	45 8b 03             	mov    (%r11),%r8d
  8e8901:	4d 01 f0             	add    %r14,%r8
  8e8904:	49 01 d8             	add    %rbx,%r8
  8e8907:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  8e890e:	49 39 fa             	cmp    %rdi,%r10
  8e8911:	75 ad                	jne    8e88c0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xc20>
  8e8913:	f6 c2 03             	test   $0x3,%dl
  8e8916:	74 33                	je     8e894b <gpui::runtime::style_ledger::batch_phase::read_probe+0xcab>
  8e8918:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  8e891c:	48 01 c7             	add    %rax,%rdi
  8e891f:	48 83 c7 18          	add    $0x18,%rdi
  8e8923:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  8e8927:	45 31 db             	xor    %r11d,%r11d
  8e892a:	4c 89 c3             	mov    %r8,%rbx
  8e892d:	0f 1f 00             	nopl   (%rax)
  8e8930:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  8e8935:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  8e8939:	49 01 de             	add    %rbx,%r14
  8e893c:	4d 01 f0             	add    %r14,%r8
  8e893f:	49 83 c3 58          	add    $0x58,%r11
  8e8943:	4c 89 c3             	mov    %r8,%rbx
  8e8946:	4d 39 da             	cmp    %r11,%r10
  8e8949:	75 e5                	jne    8e8930 <gpui::runtime::style_ledger::batch_phase::read_probe+0xc90>
  8e894b:	49 83 f9 03          	cmp    $0x3,%r9
  8e894f:	73 04                	jae    8e8955 <gpui::runtime::style_ledger::batch_phase::read_probe+0xcb5>
  8e8951:	31 ff                	xor    %edi,%edi
  8e8953:	eb 73                	jmp    8e89c8 <gpui::runtime::style_ledger::batch_phase::read_probe+0xd28>
  8e8955:	49 89 d2             	mov    %rdx,%r10
  8e8958:	49 21 f2             	and    %rsi,%r10
  8e895b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  8e8962:	31 ff                	xor    %edi,%edi
  8e8964:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  8e896b:	00 00 00 00 00 
  8e8970:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  8e8977:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  8e897e:	4c 01 c3             	add    %r8,%rbx
  8e8981:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  8e8988:	4d 01 f0             	add    %r14,%r8
  8e898b:	49 01 d8             	add    %rbx,%r8
  8e898e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  8e8995:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  8e8999:	49 01 de             	add    %rbx,%r14
  8e899c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  8e89a0:	4c 01 f3             	add    %r14,%rbx
  8e89a3:	4c 01 c3             	add    %r8,%rbx
  8e89a6:	48 83 c7 04          	add    $0x4,%rdi
  8e89aa:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  8e89ae:	45 8b 03             	mov    (%r11),%r8d
  8e89b1:	4d 01 f0             	add    %r14,%r8
  8e89b4:	49 01 d8             	add    %rbx,%r8
  8e89b7:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  8e89be:	49 39 fa             	cmp    %rdi,%r10
  8e89c1:	75 ad                	jne    8e8970 <gpui::runtime::style_ledger::batch_phase::read_probe+0xcd0>
  8e89c3:	f6 c2 03             	test   $0x3,%dl
  8e89c6:	74 33                	je     8e89fb <gpui::runtime::style_ledger::batch_phase::read_probe+0xd5b>
  8e89c8:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  8e89cc:	48 01 c7             	add    %rax,%rdi
  8e89cf:	48 83 c7 18          	add    $0x18,%rdi
  8e89d3:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  8e89d7:	45 31 db             	xor    %r11d,%r11d
  8e89da:	4c 89 c3             	mov    %r8,%rbx
  8e89dd:	0f 1f 00             	nopl   (%rax)
  8e89e0:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  8e89e5:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  8e89e9:	49 01 de             	add    %rbx,%r14
  8e89ec:	4d 01 f0             	add    %r14,%r8
  8e89ef:	49 83 c3 58          	add    $0x58,%r11
  8e89f3:	4c 89 c3             	mov    %r8,%rbx
  8e89f6:	4d 39 da             	cmp    %r11,%r10
  8e89f9:	75 e5                	jne    8e89e0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xd40>
  8e89fb:	49 83 f9 03          	cmp    $0x3,%r9
  8e89ff:	73 04                	jae    8e8a05 <gpui::runtime::style_ledger::batch_phase::read_probe+0xd65>
  8e8a01:	31 ff                	xor    %edi,%edi
  8e8a03:	eb 73                	jmp    8e8a78 <gpui::runtime::style_ledger::batch_phase::read_probe+0xdd8>
  8e8a05:	49 89 d2             	mov    %rdx,%r10
  8e8a08:	49 21 f2             	and    %rsi,%r10
  8e8a0b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  8e8a12:	31 ff                	xor    %edi,%edi
  8e8a14:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  8e8a1b:	00 00 00 00 00 
  8e8a20:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  8e8a27:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  8e8a2e:	4c 01 c3             	add    %r8,%rbx
  8e8a31:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  8e8a38:	4d 01 f0             	add    %r14,%r8
  8e8a3b:	49 01 d8             	add    %rbx,%r8
  8e8a3e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  8e8a45:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  8e8a49:	49 01 de             	add    %rbx,%r14
  8e8a4c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  8e8a50:	4c 01 f3             	add    %r14,%rbx
  8e8a53:	4c 01 c3             	add    %r8,%rbx
  8e8a56:	48 83 c7 04          	add    $0x4,%rdi
  8e8a5a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  8e8a5e:	45 8b 03             	mov    (%r11),%r8d
  8e8a61:	4d 01 f0             	add    %r14,%r8
  8e8a64:	49 01 d8             	add    %rbx,%r8
  8e8a67:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  8e8a6e:	49 39 fa             	cmp    %rdi,%r10
  8e8a71:	75 ad                	jne    8e8a20 <gpui::runtime::style_ledger::batch_phase::read_probe+0xd80>
  8e8a73:	f6 c2 03             	test   $0x3,%dl
  8e8a76:	74 33                	je     8e8aab <gpui::runtime::style_ledger::batch_phase::read_probe+0xe0b>
  8e8a78:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  8e8a7c:	48 01 c7             	add    %rax,%rdi
  8e8a7f:	48 83 c7 18          	add    $0x18,%rdi
  8e8a83:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  8e8a87:	45 31 db             	xor    %r11d,%r11d
  8e8a8a:	4c 89 c3             	mov    %r8,%rbx
  8e8a8d:	0f 1f 00             	nopl   (%rax)
  8e8a90:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  8e8a95:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  8e8a99:	49 01 de             	add    %rbx,%r14
  8e8a9c:	4d 01 f0             	add    %r14,%r8
  8e8a9f:	49 83 c3 58          	add    $0x58,%r11
  8e8aa3:	4c 89 c3             	mov    %r8,%rbx
  8e8aa6:	4d 39 da             	cmp    %r11,%r10
  8e8aa9:	75 e5                	jne    8e8a90 <gpui::runtime::style_ledger::batch_phase::read_probe+0xdf0>
  8e8aab:	49 83 f9 03          	cmp    $0x3,%r9
  8e8aaf:	73 04                	jae    8e8ab5 <gpui::runtime::style_ledger::batch_phase::read_probe+0xe15>
  8e8ab1:	31 ff                	xor    %edi,%edi
  8e8ab3:	eb 73                	jmp    8e8b28 <gpui::runtime::style_ledger::batch_phase::read_probe+0xe88>
  8e8ab5:	49 89 d2             	mov    %rdx,%r10
  8e8ab8:	49 21 f2             	and    %rsi,%r10
  8e8abb:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  8e8ac2:	31 ff                	xor    %edi,%edi
  8e8ac4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  8e8acb:	00 00 00 00 00 
  8e8ad0:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  8e8ad7:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  8e8ade:	4c 01 c3             	add    %r8,%rbx
  8e8ae1:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  8e8ae8:	4d 01 f0             	add    %r14,%r8
  8e8aeb:	49 01 d8             	add    %rbx,%r8
  8e8aee:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  8e8af5:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  8e8af9:	49 01 de             	add    %rbx,%r14
  8e8afc:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  8e8b00:	4c 01 f3             	add    %r14,%rbx
  8e8b03:	4c 01 c3             	add    %r8,%rbx
  8e8b06:	48 83 c7 04          	add    $0x4,%rdi
  8e8b0a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  8e8b0e:	45 8b 03             	mov    (%r11),%r8d
  8e8b11:	4d 01 f0             	add    %r14,%r8
  8e8b14:	49 01 d8             	add    %rbx,%r8
  8e8b17:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  8e8b1e:	49 39 fa             	cmp    %rdi,%r10
  8e8b21:	75 ad                	jne    8e8ad0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xe30>
  8e8b23:	f6 c2 03             	test   $0x3,%dl
  8e8b26:	74 33                	je     8e8b5b <gpui::runtime::style_ledger::batch_phase::read_probe+0xebb>
  8e8b28:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  8e8b2c:	48 01 c7             	add    %rax,%rdi
  8e8b2f:	48 83 c7 18          	add    $0x18,%rdi
  8e8b33:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  8e8b37:	45 31 db             	xor    %r11d,%r11d
  8e8b3a:	4c 89 c3             	mov    %r8,%rbx
  8e8b3d:	0f 1f 00             	nopl   (%rax)
  8e8b40:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  8e8b45:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  8e8b49:	49 01 de             	add    %rbx,%r14
  8e8b4c:	4d 01 f0             	add    %r14,%r8
  8e8b4f:	49 83 c3 58          	add    $0x58,%r11
  8e8b53:	4c 89 c3             	mov    %r8,%rbx
  8e8b56:	4d 39 da             	cmp    %r11,%r10
  8e8b59:	75 e5                	jne    8e8b40 <gpui::runtime::style_ledger::batch_phase::read_probe+0xea0>
  8e8b5b:	49 83 f9 03          	cmp    $0x3,%r9
  8e8b5f:	73 04                	jae    8e8b65 <gpui::runtime::style_ledger::batch_phase::read_probe+0xec5>
  8e8b61:	31 ff                	xor    %edi,%edi
  8e8b63:	eb 73                	jmp    8e8bd8 <gpui::runtime::style_ledger::batch_phase::read_probe+0xf38>
  8e8b65:	48 21 d6             	and    %rdx,%rsi
  8e8b68:	4c 8d 88 20 01 00 00 	lea    0x120(%rax),%r9
  8e8b6f:	31 ff                	xor    %edi,%edi
  8e8b71:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  8e8b78:	0f 1f 84 00 00 00 00 
  8e8b7f:	00 
  8e8b80:	45 8b 91 f0 fe ff ff 	mov    -0x110(%r9),%r10d
  8e8b87:	45 8b 99 f8 fe ff ff 	mov    -0x108(%r9),%r11d
  8e8b8e:	4d 01 c2             	add    %r8,%r10
  8e8b91:	45 8b 81 48 ff ff ff 	mov    -0xb8(%r9),%r8d
  8e8b98:	4d 01 d8             	add    %r11,%r8
  8e8b9b:	4d 01 d0             	add    %r10,%r8
  8e8b9e:	45 8b 91 50 ff ff ff 	mov    -0xb0(%r9),%r10d
  8e8ba5:	45 8b 59 a0          	mov    -0x60(%r9),%r11d
  8e8ba9:	4d 01 d3             	add    %r10,%r11
  8e8bac:	45 8b 51 a8          	mov    -0x58(%r9),%r10d
  8e8bb0:	4d 01 da             	add    %r11,%r10
  8e8bb3:	4d 01 c2             	add    %r8,%r10
  8e8bb6:	48 83 c7 04          	add    $0x4,%rdi
  8e8bba:	45 8b 59 f8          	mov    -0x8(%r9),%r11d
  8e8bbe:	45 8b 01             	mov    (%r9),%r8d
  8e8bc1:	4d 01 d8             	add    %r11,%r8
  8e8bc4:	4d 01 d0             	add    %r10,%r8
  8e8bc7:	49 81 c1 60 01 00 00 	add    $0x160,%r9
  8e8bce:	48 39 fe             	cmp    %rdi,%rsi
  8e8bd1:	75 ad                	jne    8e8b80 <gpui::runtime::style_ledger::batch_phase::read_probe+0xee0>
  8e8bd3:	f6 c2 03             	test   $0x3,%dl
  8e8bd6:	74 32                	je     8e8c0a <gpui::runtime::style_ledger::batch_phase::read_probe+0xf6a>
  8e8bd8:	48 6b d7 58          	imul   $0x58,%rdi,%rdx
  8e8bdc:	48 01 d0             	add    %rdx,%rax
  8e8bdf:	48 83 c0 18          	add    $0x18,%rax
  8e8be3:	48 6b c9 58          	imul   $0x58,%rcx,%rcx
  8e8be7:	31 d2                	xor    %edx,%edx
  8e8be9:	4c 89 c6             	mov    %r8,%rsi
  8e8bec:	0f 1f 40 00          	nopl   0x0(%rax)
  8e8bf0:	8b 7c 10 f8          	mov    -0x8(%rax,%rdx,1),%edi
  8e8bf4:	44 8b 04 10          	mov    (%rax,%rdx,1),%r8d
  8e8bf8:	48 01 f7             	add    %rsi,%rdi
  8e8bfb:	49 01 f8             	add    %rdi,%r8
  8e8bfe:	48 83 c2 58          	add    $0x58,%rdx
  8e8c02:	4c 89 c6             	mov    %r8,%rsi
  8e8c05:	48 39 d1             	cmp    %rdx,%rcx
  8e8c08:	75 e6                	jne    8e8bf0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xf50>
  8e8c0a:	4c 89 04 24          	mov    %r8,(%rsp)
  8e8c0e:	48 89 e0             	mov    %rsp,%rax
  8e8c11:	48 8b 04 24          	mov    (%rsp),%rax
  8e8c15:	48 83 c4 38          	add    $0x38,%rsp
  8e8c19:	5b                   	pop    %rbx
  8e8c1a:	41 5e                	pop    %r14
  8e8c1c:	c3                   	ret
  8e8c1d:	48 8d 15 64 a6 37 00 	lea    0x37a664(%rip),%rdx        # c63288 <anon.8e7f7beb62b89ca650cc5690a13cb3a4.87.llvm.11208107661761841984+0x78>
  8e8c24:	48 89 fe             	mov    %rdi,%rsi
  8e8c27:	ff 15 7b 93 3a 00    	call   *0x3a937b(%rip)        # c91fa8 <_DYNAMIC+0x288>
  8e8c2d:	48 8d 15 6c a6 37 00 	lea    0x37a66c(%rip),%rdx        # c632a0 <anon.8e7f7beb62b89ca650cc5690a13cb3a4.87.llvm.11208107661761841984+0x90>
  8e8c34:	48 89 c7             	mov    %rax,%rdi
  8e8c37:	ff 15 6b 93 3a 00    	call   *0x3a936b(%rip)        # c91fa8 <_DYNAMIC+0x288>
  8e8c3d:	48 ff ca             	dec    %rdx
  8e8c40:	48 39 d6             	cmp    %rdx,%rsi
  8e8c43:	48 0f 42 d6          	cmovb  %rsi,%rdx
  8e8c47:	48 89 d7             	mov    %rdx,%rdi
  8e8c4a:	48 8d 15 1f a6 37 00 	lea    0x37a61f(%rip),%rdx        # c63270 <anon.8e7f7beb62b89ca650cc5690a13cb3a4.87.llvm.11208107661761841984+0x60>
  8e8c51:	ff 15 51 93 3a 00    	call   *0x3a9351(%rip)        # c91fa8 <_DYNAMIC+0x288>
  8e8c57:	48 c7 04 24 0d 00 00 	movq   $0xd,(%rsp)
  8e8c5e:	00 
  8e8c5f:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  8e8c66:	00 00 
  8e8c68:	48 8d 3d 09 3f 7a ff 	lea    -0x85c0f7(%rip),%rdi        # 8cb78 <anon.8e7f7beb62b89ca650cc5690a13cb3a4.80.llvm.11208107661761841984>
  8e8c6f:	48 8d 0d ba a4 37 00 	lea    0x37a4ba(%rip),%rcx        # c63130 <anon.8e7f7beb62b89ca650cc5690a13cb3a4.79.llvm.11208107661761841984>
  8e8c76:	4c 8d 05 7b a9 37 00 	lea    0x37a97b(%rip),%r8        # c635f8 <anon.8e7f7beb62b89ca650cc5690a13cb3a4.148.llvm.11208107661761841984+0x160>
  8e8c7d:	48 89 e2             	mov    %rsp,%rdx
  8e8c80:	be 2b 00 00 00       	mov    $0x2b,%esi
  8e8c85:	ff 15 d5 93 3a 00    	call   *0x3a93d5(%rip)        # c92060 <_DYNAMIC+0x340>
  8e8c8b:	0f 0b                	ud2
  8e8c8d:	48 89 c3             	mov    %rax,%rbx
  8e8c90:	48 89 e7             	mov    %rsp,%rdi
  8e8c93:	e8 f8 81 ff ff       	call   8e0e90 <core::ptr::drop_glue::<gpui::runtime::Error>>
  8e8c98:	48 89 df             	mov    %rbx,%rdi
  8e8c9b:	e8 90 2e 37 00       	call   c5bb30 <_Unwind_Resume@plt>
