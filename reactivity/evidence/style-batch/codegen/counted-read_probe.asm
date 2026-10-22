
/tmp/gpui-style-counted-release-target/release/deps/gpui-559efaa5b4b411d5:     file format elf64-x86-64


Disassembly of section .text:

000000000086dc70 <gpui::runtime::style_ledger::batch_phase::read_probe>:
  86dc70:	41 56                	push   %r14
  86dc72:	53                   	push   %rbx
  86dc73:	48 83 ec 38          	sub    $0x38,%rsp
  86dc77:	48 85 ff             	test   %rdi,%rdi
  86dc7a:	0f 84 a7 0f 00 00    	je     86ec27 <gpui::runtime::style_ledger::batch_phase::read_probe+0xfb7>
  86dc80:	48 89 f9             	mov    %rdi,%rcx
  86dc83:	48 8b 97 c8 02 00 00 	mov    0x2c8(%rdi),%rdx
  86dc8a:	48 85 d2             	test   %rdx,%rdx
  86dc8d:	74 2c                	je     86dcbb <gpui::runtime::style_ledger::batch_phase::read_probe+0x4b>
  86dc8f:	48 8b 81 28 02 00 00 	mov    0x228(%rcx),%rax
  86dc96:	48 83 f8 01          	cmp    $0x1,%rax
  86dc9a:	74 27                	je     86dcc3 <gpui::runtime::style_ledger::batch_phase::read_probe+0x53>
  86dc9c:	48 85 c0             	test   %rax,%rax
  86dc9f:	0f 85 99 00 00 00    	jne    86dd3e <gpui::runtime::style_ledger::batch_phase::read_probe+0xce>
  86dca5:	48 b8 00 00 00 18 04 	movabs $0x418000000,%rax
  86dcac:	00 00 00 
  86dcaf:	48 0f af d0          	imul   %rax,%rdx
  86dcb3:	49 89 d0             	mov    %rdx,%r8
  86dcb6:	e9 1f 0f 00 00       	jmp    86ebda <gpui::runtime::style_ledger::batch_phase::read_probe+0xf6a>
  86dcbb:	45 31 c0             	xor    %r8d,%r8d
  86dcbe:	e9 17 0f 00 00       	jmp    86ebda <gpui::runtime::style_ledger::batch_phase::read_probe+0xf6a>
  86dcc3:	48 8b b1 40 02 00 00 	mov    0x240(%rcx),%rsi
  86dcca:	bf 18 00 00 00       	mov    $0x18,%edi
  86dccf:	45 31 c0             	xor    %r8d,%r8d
  86dcd2:	45 31 c9             	xor    %r9d,%r9d
  86dcd5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  86dcdc:	00 00 00 00 
  86dce0:	4c 39 ce             	cmp    %r9,%rsi
  86dce3:	0f 84 24 0f 00 00    	je     86ec0d <gpui::runtime::style_ledger::batch_phase::read_probe+0xf9d>
  86dce9:	49 ff c1             	inc    %r9
  86dcec:	48 8b 81 38 02 00 00 	mov    0x238(%rcx),%rax
  86dcf3:	44 8b 54 38 f8       	mov    -0x8(%rax,%rdi,1),%r10d
  86dcf8:	4d 89 c3             	mov    %r8,%r11
  86dcfb:	44 8b 04 38          	mov    (%rax,%rdi,1),%r8d
  86dcff:	4d 01 d3             	add    %r10,%r11
  86dd02:	4d 01 d8             	add    %r11,%r8
  86dd05:	48 83 c7 58          	add    $0x58,%rdi
  86dd09:	4c 39 ca             	cmp    %r9,%rdx
  86dd0c:	75 d2                	jne    86dce0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x70>
  86dd0e:	4c 8d 4a ff          	lea    -0x1(%rdx),%r9
  86dd12:	48 89 f7             	mov    %rsi,%rdi
  86dd15:	4c 39 ce             	cmp    %r9,%rsi
  86dd18:	0f 86 fc 0e 00 00    	jbe    86ec1a <gpui::runtime::style_ledger::batch_phase::read_probe+0xfaa>
  86dd1e:	48 be fc ff ff ff ff 	movabs $0x3fffffffffffffc,%rsi
  86dd25:	ff ff 03 
  86dd28:	89 d1                	mov    %edx,%ecx
  86dd2a:	83 e1 03             	and    $0x3,%ecx
  86dd2d:	49 83 f9 03          	cmp    $0x3,%r9
  86dd31:	0f 83 63 04 00 00    	jae    86e19a <gpui::runtime::style_ledger::batch_phase::read_probe+0x52a>
  86dd37:	31 ff                	xor    %edi,%edi
  86dd39:	e9 ca 04 00 00       	jmp    86e208 <gpui::runtime::style_ledger::batch_phase::read_probe+0x598>
  86dd3e:	48 8b b9 48 02 00 00 	mov    0x248(%rcx),%rdi
  86dd45:	48 85 ff             	test   %rdi,%rdi
  86dd48:	0f 84 9f 0e 00 00    	je     86ebed <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  86dd4e:	48 8b b1 38 02 00 00 	mov    0x238(%rcx),%rsi
  86dd55:	4c 8b 89 40 02 00 00 	mov    0x240(%rcx),%r9
  86dd5c:	41 0f b6 01          	movzbl (%r9),%eax
  86dd60:	48 39 c6             	cmp    %rax,%rsi
  86dd63:	0f 86 94 0e 00 00    	jbe    86ebfd <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  86dd69:	48 8b 89 30 02 00 00 	mov    0x230(%rcx),%rcx
  86dd70:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  86dd74:	44 8b 54 01 10       	mov    0x10(%rcx,%rax,1),%r10d
  86dd79:	44 8b 44 01 18       	mov    0x18(%rcx,%rax,1),%r8d
  86dd7e:	4d 01 d0             	add    %r10,%r8
  86dd81:	48 83 fa 01          	cmp    $0x1,%rdx
  86dd85:	75 09                	jne    86dd90 <gpui::runtime::style_ledger::batch_phase::read_probe+0x120>
  86dd87:	49 c1 e0 04          	shl    $0x4,%r8
  86dd8b:	e9 4a 0e 00 00       	jmp    86ebda <gpui::runtime::style_ledger::batch_phase::read_probe+0xf6a>
  86dd90:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  86dd96:	4d 89 c2             	mov    %r8,%r10
  86dd99:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  86dda0:	4c 39 df             	cmp    %r11,%rdi
  86dda3:	0f 84 44 0e 00 00    	je     86ebed <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  86dda9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  86ddae:	48 39 c6             	cmp    %rax,%rsi
  86ddb1:	0f 86 46 0e 00 00    	jbe    86ebfd <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  86ddb7:	49 ff c3             	inc    %r11
  86ddba:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  86ddbe:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  86ddc2:	4d 89 d6             	mov    %r10,%r14
  86ddc5:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  86ddca:	49 01 de             	add    %rbx,%r14
  86ddcd:	4d 01 f2             	add    %r14,%r10
  86ddd0:	4c 39 da             	cmp    %r11,%rdx
  86ddd3:	75 cb                	jne    86dda0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x130>
  86ddd5:	4d 01 c2             	add    %r8,%r10
  86ddd8:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  86ddde:	66 90                	xchg   %ax,%ax
  86dde0:	4c 39 df             	cmp    %r11,%rdi
  86dde3:	0f 84 04 0e 00 00    	je     86ebed <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  86dde9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  86ddee:	48 39 c6             	cmp    %rax,%rsi
  86ddf1:	0f 86 06 0e 00 00    	jbe    86ebfd <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  86ddf7:	49 ff c3             	inc    %r11
  86ddfa:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  86ddfe:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  86de02:	4d 89 d6             	mov    %r10,%r14
  86de05:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  86de0a:	49 01 de             	add    %rbx,%r14
  86de0d:	4d 01 f2             	add    %r14,%r10
  86de10:	4c 39 da             	cmp    %r11,%rdx
  86de13:	75 cb                	jne    86dde0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x170>
  86de15:	4d 01 c2             	add    %r8,%r10
  86de18:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  86de1e:	66 90                	xchg   %ax,%ax
  86de20:	4c 39 df             	cmp    %r11,%rdi
  86de23:	0f 84 c4 0d 00 00    	je     86ebed <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  86de29:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  86de2e:	48 39 c6             	cmp    %rax,%rsi
  86de31:	0f 86 c6 0d 00 00    	jbe    86ebfd <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  86de37:	49 ff c3             	inc    %r11
  86de3a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  86de3e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  86de42:	4d 89 d6             	mov    %r10,%r14
  86de45:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  86de4a:	49 01 de             	add    %rbx,%r14
  86de4d:	4d 01 f2             	add    %r14,%r10
  86de50:	4c 39 da             	cmp    %r11,%rdx
  86de53:	75 cb                	jne    86de20 <gpui::runtime::style_ledger::batch_phase::read_probe+0x1b0>
  86de55:	4d 01 c2             	add    %r8,%r10
  86de58:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  86de5e:	66 90                	xchg   %ax,%ax
  86de60:	4c 39 df             	cmp    %r11,%rdi
  86de63:	0f 84 84 0d 00 00    	je     86ebed <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  86de69:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  86de6e:	48 39 c6             	cmp    %rax,%rsi
  86de71:	0f 86 86 0d 00 00    	jbe    86ebfd <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  86de77:	49 ff c3             	inc    %r11
  86de7a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  86de7e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  86de82:	4d 89 d6             	mov    %r10,%r14
  86de85:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  86de8a:	49 01 de             	add    %rbx,%r14
  86de8d:	4d 01 f2             	add    %r14,%r10
  86de90:	4c 39 da             	cmp    %r11,%rdx
  86de93:	75 cb                	jne    86de60 <gpui::runtime::style_ledger::batch_phase::read_probe+0x1f0>
  86de95:	4d 01 c2             	add    %r8,%r10
  86de98:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  86de9e:	66 90                	xchg   %ax,%ax
  86dea0:	4c 39 df             	cmp    %r11,%rdi
  86dea3:	0f 84 44 0d 00 00    	je     86ebed <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  86dea9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  86deae:	48 39 c6             	cmp    %rax,%rsi
  86deb1:	0f 86 46 0d 00 00    	jbe    86ebfd <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  86deb7:	49 ff c3             	inc    %r11
  86deba:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  86debe:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  86dec2:	4d 89 d6             	mov    %r10,%r14
  86dec5:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  86deca:	49 01 de             	add    %rbx,%r14
  86decd:	4d 01 f2             	add    %r14,%r10
  86ded0:	4c 39 da             	cmp    %r11,%rdx
  86ded3:	75 cb                	jne    86dea0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x230>
  86ded5:	4d 01 c2             	add    %r8,%r10
  86ded8:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  86dede:	66 90                	xchg   %ax,%ax
  86dee0:	4c 39 df             	cmp    %r11,%rdi
  86dee3:	0f 84 04 0d 00 00    	je     86ebed <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  86dee9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  86deee:	48 39 c6             	cmp    %rax,%rsi
  86def1:	0f 86 06 0d 00 00    	jbe    86ebfd <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  86def7:	49 ff c3             	inc    %r11
  86defa:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  86defe:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  86df02:	4d 89 d6             	mov    %r10,%r14
  86df05:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  86df0a:	49 01 de             	add    %rbx,%r14
  86df0d:	4d 01 f2             	add    %r14,%r10
  86df10:	4c 39 da             	cmp    %r11,%rdx
  86df13:	75 cb                	jne    86dee0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x270>
  86df15:	4d 01 c2             	add    %r8,%r10
  86df18:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  86df1e:	66 90                	xchg   %ax,%ax
  86df20:	4c 39 df             	cmp    %r11,%rdi
  86df23:	0f 84 c4 0c 00 00    	je     86ebed <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  86df29:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  86df2e:	48 39 c6             	cmp    %rax,%rsi
  86df31:	0f 86 c6 0c 00 00    	jbe    86ebfd <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  86df37:	49 ff c3             	inc    %r11
  86df3a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  86df3e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  86df42:	4d 89 d6             	mov    %r10,%r14
  86df45:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  86df4a:	49 01 de             	add    %rbx,%r14
  86df4d:	4d 01 f2             	add    %r14,%r10
  86df50:	4c 39 da             	cmp    %r11,%rdx
  86df53:	75 cb                	jne    86df20 <gpui::runtime::style_ledger::batch_phase::read_probe+0x2b0>
  86df55:	4d 01 c2             	add    %r8,%r10
  86df58:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  86df5e:	66 90                	xchg   %ax,%ax
  86df60:	4c 39 df             	cmp    %r11,%rdi
  86df63:	0f 84 84 0c 00 00    	je     86ebed <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  86df69:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  86df6e:	48 39 c6             	cmp    %rax,%rsi
  86df71:	0f 86 86 0c 00 00    	jbe    86ebfd <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  86df77:	49 ff c3             	inc    %r11
  86df7a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  86df7e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  86df82:	4d 89 d6             	mov    %r10,%r14
  86df85:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  86df8a:	49 01 de             	add    %rbx,%r14
  86df8d:	4d 01 f2             	add    %r14,%r10
  86df90:	4c 39 da             	cmp    %r11,%rdx
  86df93:	75 cb                	jne    86df60 <gpui::runtime::style_ledger::batch_phase::read_probe+0x2f0>
  86df95:	4d 01 c2             	add    %r8,%r10
  86df98:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  86df9e:	66 90                	xchg   %ax,%ax
  86dfa0:	4c 39 df             	cmp    %r11,%rdi
  86dfa3:	0f 84 44 0c 00 00    	je     86ebed <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  86dfa9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  86dfae:	48 39 c6             	cmp    %rax,%rsi
  86dfb1:	0f 86 46 0c 00 00    	jbe    86ebfd <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  86dfb7:	49 ff c3             	inc    %r11
  86dfba:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  86dfbe:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  86dfc2:	4d 89 d6             	mov    %r10,%r14
  86dfc5:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  86dfca:	49 01 de             	add    %rbx,%r14
  86dfcd:	4d 01 f2             	add    %r14,%r10
  86dfd0:	4c 39 da             	cmp    %r11,%rdx
  86dfd3:	75 cb                	jne    86dfa0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x330>
  86dfd5:	4d 01 c2             	add    %r8,%r10
  86dfd8:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  86dfde:	66 90                	xchg   %ax,%ax
  86dfe0:	4c 39 df             	cmp    %r11,%rdi
  86dfe3:	0f 84 04 0c 00 00    	je     86ebed <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  86dfe9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  86dfee:	48 39 c6             	cmp    %rax,%rsi
  86dff1:	0f 86 06 0c 00 00    	jbe    86ebfd <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  86dff7:	49 ff c3             	inc    %r11
  86dffa:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  86dffe:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  86e002:	4d 89 d6             	mov    %r10,%r14
  86e005:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  86e00a:	49 01 de             	add    %rbx,%r14
  86e00d:	4d 01 f2             	add    %r14,%r10
  86e010:	4c 39 da             	cmp    %r11,%rdx
  86e013:	75 cb                	jne    86dfe0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x370>
  86e015:	4d 01 c2             	add    %r8,%r10
  86e018:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  86e01e:	66 90                	xchg   %ax,%ax
  86e020:	4c 39 df             	cmp    %r11,%rdi
  86e023:	0f 84 c4 0b 00 00    	je     86ebed <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  86e029:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  86e02e:	48 39 c6             	cmp    %rax,%rsi
  86e031:	0f 86 c6 0b 00 00    	jbe    86ebfd <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  86e037:	49 ff c3             	inc    %r11
  86e03a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  86e03e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  86e042:	4d 89 d6             	mov    %r10,%r14
  86e045:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  86e04a:	49 01 de             	add    %rbx,%r14
  86e04d:	4d 01 f2             	add    %r14,%r10
  86e050:	4c 39 da             	cmp    %r11,%rdx
  86e053:	75 cb                	jne    86e020 <gpui::runtime::style_ledger::batch_phase::read_probe+0x3b0>
  86e055:	4d 01 c2             	add    %r8,%r10
  86e058:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  86e05e:	66 90                	xchg   %ax,%ax
  86e060:	4c 39 df             	cmp    %r11,%rdi
  86e063:	0f 84 84 0b 00 00    	je     86ebed <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  86e069:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  86e06e:	48 39 c6             	cmp    %rax,%rsi
  86e071:	0f 86 86 0b 00 00    	jbe    86ebfd <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  86e077:	49 ff c3             	inc    %r11
  86e07a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  86e07e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  86e082:	4d 89 d6             	mov    %r10,%r14
  86e085:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  86e08a:	49 01 de             	add    %rbx,%r14
  86e08d:	4d 01 f2             	add    %r14,%r10
  86e090:	4c 39 da             	cmp    %r11,%rdx
  86e093:	75 cb                	jne    86e060 <gpui::runtime::style_ledger::batch_phase::read_probe+0x3f0>
  86e095:	4d 01 c2             	add    %r8,%r10
  86e098:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  86e09e:	66 90                	xchg   %ax,%ax
  86e0a0:	4c 39 df             	cmp    %r11,%rdi
  86e0a3:	0f 84 44 0b 00 00    	je     86ebed <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  86e0a9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  86e0ae:	48 39 c6             	cmp    %rax,%rsi
  86e0b1:	0f 86 46 0b 00 00    	jbe    86ebfd <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  86e0b7:	49 ff c3             	inc    %r11
  86e0ba:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  86e0be:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  86e0c2:	4d 89 d6             	mov    %r10,%r14
  86e0c5:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  86e0ca:	49 01 de             	add    %rbx,%r14
  86e0cd:	4d 01 f2             	add    %r14,%r10
  86e0d0:	4c 39 da             	cmp    %r11,%rdx
  86e0d3:	75 cb                	jne    86e0a0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x430>
  86e0d5:	4d 01 c2             	add    %r8,%r10
  86e0d8:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  86e0de:	66 90                	xchg   %ax,%ax
  86e0e0:	4c 39 df             	cmp    %r11,%rdi
  86e0e3:	0f 84 04 0b 00 00    	je     86ebed <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  86e0e9:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  86e0ee:	48 39 c6             	cmp    %rax,%rsi
  86e0f1:	0f 86 06 0b 00 00    	jbe    86ebfd <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  86e0f7:	49 ff c3             	inc    %r11
  86e0fa:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  86e0fe:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  86e102:	4d 89 d6             	mov    %r10,%r14
  86e105:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  86e10a:	49 01 de             	add    %rbx,%r14
  86e10d:	4d 01 f2             	add    %r14,%r10
  86e110:	4c 39 da             	cmp    %r11,%rdx
  86e113:	75 cb                	jne    86e0e0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x470>
  86e115:	4d 01 c2             	add    %r8,%r10
  86e118:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  86e11e:	66 90                	xchg   %ax,%ax
  86e120:	4c 39 df             	cmp    %r11,%rdi
  86e123:	0f 84 c4 0a 00 00    	je     86ebed <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  86e129:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  86e12e:	48 39 c6             	cmp    %rax,%rsi
  86e131:	0f 86 c6 0a 00 00    	jbe    86ebfd <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  86e137:	49 ff c3             	inc    %r11
  86e13a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  86e13e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  86e142:	4d 89 d6             	mov    %r10,%r14
  86e145:	44 8b 54 01 18       	mov    0x18(%rcx,%rax,1),%r10d
  86e14a:	49 01 de             	add    %rbx,%r14
  86e14d:	4d 01 f2             	add    %r14,%r10
  86e150:	4c 39 da             	cmp    %r11,%rdx
  86e153:	75 cb                	jne    86e120 <gpui::runtime::style_ledger::batch_phase::read_probe+0x4b0>
  86e155:	4d 01 c2             	add    %r8,%r10
  86e158:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  86e15e:	66 90                	xchg   %ax,%ax
  86e160:	4c 39 df             	cmp    %r11,%rdi
  86e163:	0f 84 84 0a 00 00    	je     86ebed <gpui::runtime::style_ledger::batch_phase::read_probe+0xf7d>
  86e169:	43 0f b6 04 19       	movzbl (%r9,%r11,1),%eax
  86e16e:	48 39 c6             	cmp    %rax,%rsi
  86e171:	0f 86 86 0a 00 00    	jbe    86ebfd <gpui::runtime::style_ledger::batch_phase::read_probe+0xf8d>
  86e177:	49 ff c3             	inc    %r11
  86e17a:	48 6b c0 5c          	imul   $0x5c,%rax,%rax
  86e17e:	8b 5c 01 10          	mov    0x10(%rcx,%rax,1),%ebx
  86e182:	44 8b 44 01 18       	mov    0x18(%rcx,%rax,1),%r8d
  86e187:	49 01 da             	add    %rbx,%r10
  86e18a:	4d 01 d0             	add    %r10,%r8
  86e18d:	4d 89 c2             	mov    %r8,%r10
  86e190:	4c 39 da             	cmp    %r11,%rdx
  86e193:	75 cb                	jne    86e160 <gpui::runtime::style_ledger::batch_phase::read_probe+0x4f0>
  86e195:	e9 40 0a 00 00       	jmp    86ebda <gpui::runtime::style_ledger::batch_phase::read_probe+0xf6a>
  86e19a:	49 89 d2             	mov    %rdx,%r10
  86e19d:	49 21 f2             	and    %rsi,%r10
  86e1a0:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  86e1a7:	31 ff                	xor    %edi,%edi
  86e1a9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  86e1b0:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  86e1b7:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  86e1be:	4c 01 c3             	add    %r8,%rbx
  86e1c1:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  86e1c8:	4d 01 f0             	add    %r14,%r8
  86e1cb:	49 01 d8             	add    %rbx,%r8
  86e1ce:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  86e1d5:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  86e1d9:	49 01 de             	add    %rbx,%r14
  86e1dc:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  86e1e0:	4c 01 f3             	add    %r14,%rbx
  86e1e3:	4c 01 c3             	add    %r8,%rbx
  86e1e6:	48 83 c7 04          	add    $0x4,%rdi
  86e1ea:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  86e1ee:	45 8b 03             	mov    (%r11),%r8d
  86e1f1:	4d 01 f0             	add    %r14,%r8
  86e1f4:	49 01 d8             	add    %rbx,%r8
  86e1f7:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  86e1fe:	49 39 fa             	cmp    %rdi,%r10
  86e201:	75 ad                	jne    86e1b0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x540>
  86e203:	48 85 c9             	test   %rcx,%rcx
  86e206:	74 33                	je     86e23b <gpui::runtime::style_ledger::batch_phase::read_probe+0x5cb>
  86e208:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  86e20c:	48 01 c7             	add    %rax,%rdi
  86e20f:	48 83 c7 18          	add    $0x18,%rdi
  86e213:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  86e217:	45 31 db             	xor    %r11d,%r11d
  86e21a:	4c 89 c3             	mov    %r8,%rbx
  86e21d:	0f 1f 00             	nopl   (%rax)
  86e220:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  86e225:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  86e229:	49 01 de             	add    %rbx,%r14
  86e22c:	4d 01 f0             	add    %r14,%r8
  86e22f:	49 83 c3 58          	add    $0x58,%r11
  86e233:	4c 89 c3             	mov    %r8,%rbx
  86e236:	4d 39 da             	cmp    %r11,%r10
  86e239:	75 e5                	jne    86e220 <gpui::runtime::style_ledger::batch_phase::read_probe+0x5b0>
  86e23b:	49 83 f9 03          	cmp    $0x3,%r9
  86e23f:	73 04                	jae    86e245 <gpui::runtime::style_ledger::batch_phase::read_probe+0x5d5>
  86e241:	31 ff                	xor    %edi,%edi
  86e243:	eb 73                	jmp    86e2b8 <gpui::runtime::style_ledger::batch_phase::read_probe+0x648>
  86e245:	49 89 d2             	mov    %rdx,%r10
  86e248:	49 21 f2             	and    %rsi,%r10
  86e24b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  86e252:	31 ff                	xor    %edi,%edi
  86e254:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  86e25b:	00 00 00 00 00 
  86e260:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  86e267:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  86e26e:	4c 01 c3             	add    %r8,%rbx
  86e271:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  86e278:	4d 01 f0             	add    %r14,%r8
  86e27b:	49 01 d8             	add    %rbx,%r8
  86e27e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  86e285:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  86e289:	49 01 de             	add    %rbx,%r14
  86e28c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  86e290:	4c 01 f3             	add    %r14,%rbx
  86e293:	4c 01 c3             	add    %r8,%rbx
  86e296:	48 83 c7 04          	add    $0x4,%rdi
  86e29a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  86e29e:	45 8b 03             	mov    (%r11),%r8d
  86e2a1:	4d 01 f0             	add    %r14,%r8
  86e2a4:	49 01 d8             	add    %rbx,%r8
  86e2a7:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  86e2ae:	49 39 fa             	cmp    %rdi,%r10
  86e2b1:	75 ad                	jne    86e260 <gpui::runtime::style_ledger::batch_phase::read_probe+0x5f0>
  86e2b3:	f6 c2 03             	test   $0x3,%dl
  86e2b6:	74 33                	je     86e2eb <gpui::runtime::style_ledger::batch_phase::read_probe+0x67b>
  86e2b8:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  86e2bc:	48 01 c7             	add    %rax,%rdi
  86e2bf:	48 83 c7 18          	add    $0x18,%rdi
  86e2c3:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  86e2c7:	45 31 db             	xor    %r11d,%r11d
  86e2ca:	4c 89 c3             	mov    %r8,%rbx
  86e2cd:	0f 1f 00             	nopl   (%rax)
  86e2d0:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  86e2d5:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  86e2d9:	49 01 de             	add    %rbx,%r14
  86e2dc:	4d 01 f0             	add    %r14,%r8
  86e2df:	49 83 c3 58          	add    $0x58,%r11
  86e2e3:	4c 89 c3             	mov    %r8,%rbx
  86e2e6:	4d 39 da             	cmp    %r11,%r10
  86e2e9:	75 e5                	jne    86e2d0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x660>
  86e2eb:	49 83 f9 03          	cmp    $0x3,%r9
  86e2ef:	73 04                	jae    86e2f5 <gpui::runtime::style_ledger::batch_phase::read_probe+0x685>
  86e2f1:	31 ff                	xor    %edi,%edi
  86e2f3:	eb 73                	jmp    86e368 <gpui::runtime::style_ledger::batch_phase::read_probe+0x6f8>
  86e2f5:	49 89 d2             	mov    %rdx,%r10
  86e2f8:	49 21 f2             	and    %rsi,%r10
  86e2fb:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  86e302:	31 ff                	xor    %edi,%edi
  86e304:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  86e30b:	00 00 00 00 00 
  86e310:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  86e317:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  86e31e:	4c 01 c3             	add    %r8,%rbx
  86e321:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  86e328:	4d 01 f0             	add    %r14,%r8
  86e32b:	49 01 d8             	add    %rbx,%r8
  86e32e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  86e335:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  86e339:	49 01 de             	add    %rbx,%r14
  86e33c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  86e340:	4c 01 f3             	add    %r14,%rbx
  86e343:	4c 01 c3             	add    %r8,%rbx
  86e346:	48 83 c7 04          	add    $0x4,%rdi
  86e34a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  86e34e:	45 8b 03             	mov    (%r11),%r8d
  86e351:	4d 01 f0             	add    %r14,%r8
  86e354:	49 01 d8             	add    %rbx,%r8
  86e357:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  86e35e:	49 39 fa             	cmp    %rdi,%r10
  86e361:	75 ad                	jne    86e310 <gpui::runtime::style_ledger::batch_phase::read_probe+0x6a0>
  86e363:	f6 c2 03             	test   $0x3,%dl
  86e366:	74 33                	je     86e39b <gpui::runtime::style_ledger::batch_phase::read_probe+0x72b>
  86e368:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  86e36c:	48 01 c7             	add    %rax,%rdi
  86e36f:	48 83 c7 18          	add    $0x18,%rdi
  86e373:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  86e377:	45 31 db             	xor    %r11d,%r11d
  86e37a:	4c 89 c3             	mov    %r8,%rbx
  86e37d:	0f 1f 00             	nopl   (%rax)
  86e380:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  86e385:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  86e389:	49 01 de             	add    %rbx,%r14
  86e38c:	4d 01 f0             	add    %r14,%r8
  86e38f:	49 83 c3 58          	add    $0x58,%r11
  86e393:	4c 89 c3             	mov    %r8,%rbx
  86e396:	4d 39 da             	cmp    %r11,%r10
  86e399:	75 e5                	jne    86e380 <gpui::runtime::style_ledger::batch_phase::read_probe+0x710>
  86e39b:	49 83 f9 03          	cmp    $0x3,%r9
  86e39f:	73 04                	jae    86e3a5 <gpui::runtime::style_ledger::batch_phase::read_probe+0x735>
  86e3a1:	31 ff                	xor    %edi,%edi
  86e3a3:	eb 73                	jmp    86e418 <gpui::runtime::style_ledger::batch_phase::read_probe+0x7a8>
  86e3a5:	49 89 d2             	mov    %rdx,%r10
  86e3a8:	49 21 f2             	and    %rsi,%r10
  86e3ab:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  86e3b2:	31 ff                	xor    %edi,%edi
  86e3b4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  86e3bb:	00 00 00 00 00 
  86e3c0:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  86e3c7:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  86e3ce:	4c 01 c3             	add    %r8,%rbx
  86e3d1:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  86e3d8:	4d 01 f0             	add    %r14,%r8
  86e3db:	49 01 d8             	add    %rbx,%r8
  86e3de:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  86e3e5:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  86e3e9:	49 01 de             	add    %rbx,%r14
  86e3ec:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  86e3f0:	4c 01 f3             	add    %r14,%rbx
  86e3f3:	4c 01 c3             	add    %r8,%rbx
  86e3f6:	48 83 c7 04          	add    $0x4,%rdi
  86e3fa:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  86e3fe:	45 8b 03             	mov    (%r11),%r8d
  86e401:	4d 01 f0             	add    %r14,%r8
  86e404:	49 01 d8             	add    %rbx,%r8
  86e407:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  86e40e:	49 39 fa             	cmp    %rdi,%r10
  86e411:	75 ad                	jne    86e3c0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x750>
  86e413:	f6 c2 03             	test   $0x3,%dl
  86e416:	74 33                	je     86e44b <gpui::runtime::style_ledger::batch_phase::read_probe+0x7db>
  86e418:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  86e41c:	48 01 c7             	add    %rax,%rdi
  86e41f:	48 83 c7 18          	add    $0x18,%rdi
  86e423:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  86e427:	45 31 db             	xor    %r11d,%r11d
  86e42a:	4c 89 c3             	mov    %r8,%rbx
  86e42d:	0f 1f 00             	nopl   (%rax)
  86e430:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  86e435:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  86e439:	49 01 de             	add    %rbx,%r14
  86e43c:	4d 01 f0             	add    %r14,%r8
  86e43f:	49 83 c3 58          	add    $0x58,%r11
  86e443:	4c 89 c3             	mov    %r8,%rbx
  86e446:	4d 39 da             	cmp    %r11,%r10
  86e449:	75 e5                	jne    86e430 <gpui::runtime::style_ledger::batch_phase::read_probe+0x7c0>
  86e44b:	49 83 f9 03          	cmp    $0x3,%r9
  86e44f:	73 04                	jae    86e455 <gpui::runtime::style_ledger::batch_phase::read_probe+0x7e5>
  86e451:	31 ff                	xor    %edi,%edi
  86e453:	eb 73                	jmp    86e4c8 <gpui::runtime::style_ledger::batch_phase::read_probe+0x858>
  86e455:	49 89 d2             	mov    %rdx,%r10
  86e458:	49 21 f2             	and    %rsi,%r10
  86e45b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  86e462:	31 ff                	xor    %edi,%edi
  86e464:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  86e46b:	00 00 00 00 00 
  86e470:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  86e477:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  86e47e:	4c 01 c3             	add    %r8,%rbx
  86e481:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  86e488:	4d 01 f0             	add    %r14,%r8
  86e48b:	49 01 d8             	add    %rbx,%r8
  86e48e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  86e495:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  86e499:	49 01 de             	add    %rbx,%r14
  86e49c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  86e4a0:	4c 01 f3             	add    %r14,%rbx
  86e4a3:	4c 01 c3             	add    %r8,%rbx
  86e4a6:	48 83 c7 04          	add    $0x4,%rdi
  86e4aa:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  86e4ae:	45 8b 03             	mov    (%r11),%r8d
  86e4b1:	4d 01 f0             	add    %r14,%r8
  86e4b4:	49 01 d8             	add    %rbx,%r8
  86e4b7:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  86e4be:	49 39 fa             	cmp    %rdi,%r10
  86e4c1:	75 ad                	jne    86e470 <gpui::runtime::style_ledger::batch_phase::read_probe+0x800>
  86e4c3:	f6 c2 03             	test   $0x3,%dl
  86e4c6:	74 33                	je     86e4fb <gpui::runtime::style_ledger::batch_phase::read_probe+0x88b>
  86e4c8:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  86e4cc:	48 01 c7             	add    %rax,%rdi
  86e4cf:	48 83 c7 18          	add    $0x18,%rdi
  86e4d3:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  86e4d7:	45 31 db             	xor    %r11d,%r11d
  86e4da:	4c 89 c3             	mov    %r8,%rbx
  86e4dd:	0f 1f 00             	nopl   (%rax)
  86e4e0:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  86e4e5:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  86e4e9:	49 01 de             	add    %rbx,%r14
  86e4ec:	4d 01 f0             	add    %r14,%r8
  86e4ef:	49 83 c3 58          	add    $0x58,%r11
  86e4f3:	4c 89 c3             	mov    %r8,%rbx
  86e4f6:	4d 39 da             	cmp    %r11,%r10
  86e4f9:	75 e5                	jne    86e4e0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x870>
  86e4fb:	49 83 f9 03          	cmp    $0x3,%r9
  86e4ff:	73 04                	jae    86e505 <gpui::runtime::style_ledger::batch_phase::read_probe+0x895>
  86e501:	31 ff                	xor    %edi,%edi
  86e503:	eb 73                	jmp    86e578 <gpui::runtime::style_ledger::batch_phase::read_probe+0x908>
  86e505:	49 89 d2             	mov    %rdx,%r10
  86e508:	49 21 f2             	and    %rsi,%r10
  86e50b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  86e512:	31 ff                	xor    %edi,%edi
  86e514:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  86e51b:	00 00 00 00 00 
  86e520:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  86e527:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  86e52e:	4c 01 c3             	add    %r8,%rbx
  86e531:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  86e538:	4d 01 f0             	add    %r14,%r8
  86e53b:	49 01 d8             	add    %rbx,%r8
  86e53e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  86e545:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  86e549:	49 01 de             	add    %rbx,%r14
  86e54c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  86e550:	4c 01 f3             	add    %r14,%rbx
  86e553:	4c 01 c3             	add    %r8,%rbx
  86e556:	48 83 c7 04          	add    $0x4,%rdi
  86e55a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  86e55e:	45 8b 03             	mov    (%r11),%r8d
  86e561:	4d 01 f0             	add    %r14,%r8
  86e564:	49 01 d8             	add    %rbx,%r8
  86e567:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  86e56e:	49 39 fa             	cmp    %rdi,%r10
  86e571:	75 ad                	jne    86e520 <gpui::runtime::style_ledger::batch_phase::read_probe+0x8b0>
  86e573:	f6 c2 03             	test   $0x3,%dl
  86e576:	74 33                	je     86e5ab <gpui::runtime::style_ledger::batch_phase::read_probe+0x93b>
  86e578:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  86e57c:	48 01 c7             	add    %rax,%rdi
  86e57f:	48 83 c7 18          	add    $0x18,%rdi
  86e583:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  86e587:	45 31 db             	xor    %r11d,%r11d
  86e58a:	4c 89 c3             	mov    %r8,%rbx
  86e58d:	0f 1f 00             	nopl   (%rax)
  86e590:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  86e595:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  86e599:	49 01 de             	add    %rbx,%r14
  86e59c:	4d 01 f0             	add    %r14,%r8
  86e59f:	49 83 c3 58          	add    $0x58,%r11
  86e5a3:	4c 89 c3             	mov    %r8,%rbx
  86e5a6:	4d 39 da             	cmp    %r11,%r10
  86e5a9:	75 e5                	jne    86e590 <gpui::runtime::style_ledger::batch_phase::read_probe+0x920>
  86e5ab:	49 83 f9 03          	cmp    $0x3,%r9
  86e5af:	73 04                	jae    86e5b5 <gpui::runtime::style_ledger::batch_phase::read_probe+0x945>
  86e5b1:	31 ff                	xor    %edi,%edi
  86e5b3:	eb 73                	jmp    86e628 <gpui::runtime::style_ledger::batch_phase::read_probe+0x9b8>
  86e5b5:	49 89 d2             	mov    %rdx,%r10
  86e5b8:	49 21 f2             	and    %rsi,%r10
  86e5bb:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  86e5c2:	31 ff                	xor    %edi,%edi
  86e5c4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  86e5cb:	00 00 00 00 00 
  86e5d0:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  86e5d7:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  86e5de:	4c 01 c3             	add    %r8,%rbx
  86e5e1:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  86e5e8:	4d 01 f0             	add    %r14,%r8
  86e5eb:	49 01 d8             	add    %rbx,%r8
  86e5ee:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  86e5f5:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  86e5f9:	49 01 de             	add    %rbx,%r14
  86e5fc:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  86e600:	4c 01 f3             	add    %r14,%rbx
  86e603:	4c 01 c3             	add    %r8,%rbx
  86e606:	48 83 c7 04          	add    $0x4,%rdi
  86e60a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  86e60e:	45 8b 03             	mov    (%r11),%r8d
  86e611:	4d 01 f0             	add    %r14,%r8
  86e614:	49 01 d8             	add    %rbx,%r8
  86e617:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  86e61e:	49 39 fa             	cmp    %rdi,%r10
  86e621:	75 ad                	jne    86e5d0 <gpui::runtime::style_ledger::batch_phase::read_probe+0x960>
  86e623:	f6 c2 03             	test   $0x3,%dl
  86e626:	74 33                	je     86e65b <gpui::runtime::style_ledger::batch_phase::read_probe+0x9eb>
  86e628:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  86e62c:	48 01 c7             	add    %rax,%rdi
  86e62f:	48 83 c7 18          	add    $0x18,%rdi
  86e633:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  86e637:	45 31 db             	xor    %r11d,%r11d
  86e63a:	4c 89 c3             	mov    %r8,%rbx
  86e63d:	0f 1f 00             	nopl   (%rax)
  86e640:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  86e645:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  86e649:	49 01 de             	add    %rbx,%r14
  86e64c:	4d 01 f0             	add    %r14,%r8
  86e64f:	49 83 c3 58          	add    $0x58,%r11
  86e653:	4c 89 c3             	mov    %r8,%rbx
  86e656:	4d 39 da             	cmp    %r11,%r10
  86e659:	75 e5                	jne    86e640 <gpui::runtime::style_ledger::batch_phase::read_probe+0x9d0>
  86e65b:	49 83 f9 03          	cmp    $0x3,%r9
  86e65f:	73 04                	jae    86e665 <gpui::runtime::style_ledger::batch_phase::read_probe+0x9f5>
  86e661:	31 ff                	xor    %edi,%edi
  86e663:	eb 73                	jmp    86e6d8 <gpui::runtime::style_ledger::batch_phase::read_probe+0xa68>
  86e665:	49 89 d2             	mov    %rdx,%r10
  86e668:	49 21 f2             	and    %rsi,%r10
  86e66b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  86e672:	31 ff                	xor    %edi,%edi
  86e674:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  86e67b:	00 00 00 00 00 
  86e680:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  86e687:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  86e68e:	4c 01 c3             	add    %r8,%rbx
  86e691:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  86e698:	4d 01 f0             	add    %r14,%r8
  86e69b:	49 01 d8             	add    %rbx,%r8
  86e69e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  86e6a5:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  86e6a9:	49 01 de             	add    %rbx,%r14
  86e6ac:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  86e6b0:	4c 01 f3             	add    %r14,%rbx
  86e6b3:	4c 01 c3             	add    %r8,%rbx
  86e6b6:	48 83 c7 04          	add    $0x4,%rdi
  86e6ba:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  86e6be:	45 8b 03             	mov    (%r11),%r8d
  86e6c1:	4d 01 f0             	add    %r14,%r8
  86e6c4:	49 01 d8             	add    %rbx,%r8
  86e6c7:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  86e6ce:	49 39 fa             	cmp    %rdi,%r10
  86e6d1:	75 ad                	jne    86e680 <gpui::runtime::style_ledger::batch_phase::read_probe+0xa10>
  86e6d3:	f6 c2 03             	test   $0x3,%dl
  86e6d6:	74 33                	je     86e70b <gpui::runtime::style_ledger::batch_phase::read_probe+0xa9b>
  86e6d8:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  86e6dc:	48 01 c7             	add    %rax,%rdi
  86e6df:	48 83 c7 18          	add    $0x18,%rdi
  86e6e3:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  86e6e7:	45 31 db             	xor    %r11d,%r11d
  86e6ea:	4c 89 c3             	mov    %r8,%rbx
  86e6ed:	0f 1f 00             	nopl   (%rax)
  86e6f0:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  86e6f5:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  86e6f9:	49 01 de             	add    %rbx,%r14
  86e6fc:	4d 01 f0             	add    %r14,%r8
  86e6ff:	49 83 c3 58          	add    $0x58,%r11
  86e703:	4c 89 c3             	mov    %r8,%rbx
  86e706:	4d 39 da             	cmp    %r11,%r10
  86e709:	75 e5                	jne    86e6f0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xa80>
  86e70b:	49 83 f9 03          	cmp    $0x3,%r9
  86e70f:	73 04                	jae    86e715 <gpui::runtime::style_ledger::batch_phase::read_probe+0xaa5>
  86e711:	31 ff                	xor    %edi,%edi
  86e713:	eb 73                	jmp    86e788 <gpui::runtime::style_ledger::batch_phase::read_probe+0xb18>
  86e715:	49 89 d2             	mov    %rdx,%r10
  86e718:	49 21 f2             	and    %rsi,%r10
  86e71b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  86e722:	31 ff                	xor    %edi,%edi
  86e724:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  86e72b:	00 00 00 00 00 
  86e730:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  86e737:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  86e73e:	4c 01 c3             	add    %r8,%rbx
  86e741:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  86e748:	4d 01 f0             	add    %r14,%r8
  86e74b:	49 01 d8             	add    %rbx,%r8
  86e74e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  86e755:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  86e759:	49 01 de             	add    %rbx,%r14
  86e75c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  86e760:	4c 01 f3             	add    %r14,%rbx
  86e763:	4c 01 c3             	add    %r8,%rbx
  86e766:	48 83 c7 04          	add    $0x4,%rdi
  86e76a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  86e76e:	45 8b 03             	mov    (%r11),%r8d
  86e771:	4d 01 f0             	add    %r14,%r8
  86e774:	49 01 d8             	add    %rbx,%r8
  86e777:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  86e77e:	49 39 fa             	cmp    %rdi,%r10
  86e781:	75 ad                	jne    86e730 <gpui::runtime::style_ledger::batch_phase::read_probe+0xac0>
  86e783:	f6 c2 03             	test   $0x3,%dl
  86e786:	74 33                	je     86e7bb <gpui::runtime::style_ledger::batch_phase::read_probe+0xb4b>
  86e788:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  86e78c:	48 01 c7             	add    %rax,%rdi
  86e78f:	48 83 c7 18          	add    $0x18,%rdi
  86e793:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  86e797:	45 31 db             	xor    %r11d,%r11d
  86e79a:	4c 89 c3             	mov    %r8,%rbx
  86e79d:	0f 1f 00             	nopl   (%rax)
  86e7a0:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  86e7a5:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  86e7a9:	49 01 de             	add    %rbx,%r14
  86e7ac:	4d 01 f0             	add    %r14,%r8
  86e7af:	49 83 c3 58          	add    $0x58,%r11
  86e7b3:	4c 89 c3             	mov    %r8,%rbx
  86e7b6:	4d 39 da             	cmp    %r11,%r10
  86e7b9:	75 e5                	jne    86e7a0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xb30>
  86e7bb:	49 83 f9 03          	cmp    $0x3,%r9
  86e7bf:	73 04                	jae    86e7c5 <gpui::runtime::style_ledger::batch_phase::read_probe+0xb55>
  86e7c1:	31 ff                	xor    %edi,%edi
  86e7c3:	eb 73                	jmp    86e838 <gpui::runtime::style_ledger::batch_phase::read_probe+0xbc8>
  86e7c5:	49 89 d2             	mov    %rdx,%r10
  86e7c8:	49 21 f2             	and    %rsi,%r10
  86e7cb:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  86e7d2:	31 ff                	xor    %edi,%edi
  86e7d4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  86e7db:	00 00 00 00 00 
  86e7e0:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  86e7e7:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  86e7ee:	4c 01 c3             	add    %r8,%rbx
  86e7f1:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  86e7f8:	4d 01 f0             	add    %r14,%r8
  86e7fb:	49 01 d8             	add    %rbx,%r8
  86e7fe:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  86e805:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  86e809:	49 01 de             	add    %rbx,%r14
  86e80c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  86e810:	4c 01 f3             	add    %r14,%rbx
  86e813:	4c 01 c3             	add    %r8,%rbx
  86e816:	48 83 c7 04          	add    $0x4,%rdi
  86e81a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  86e81e:	45 8b 03             	mov    (%r11),%r8d
  86e821:	4d 01 f0             	add    %r14,%r8
  86e824:	49 01 d8             	add    %rbx,%r8
  86e827:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  86e82e:	49 39 fa             	cmp    %rdi,%r10
  86e831:	75 ad                	jne    86e7e0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xb70>
  86e833:	f6 c2 03             	test   $0x3,%dl
  86e836:	74 33                	je     86e86b <gpui::runtime::style_ledger::batch_phase::read_probe+0xbfb>
  86e838:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  86e83c:	48 01 c7             	add    %rax,%rdi
  86e83f:	48 83 c7 18          	add    $0x18,%rdi
  86e843:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  86e847:	45 31 db             	xor    %r11d,%r11d
  86e84a:	4c 89 c3             	mov    %r8,%rbx
  86e84d:	0f 1f 00             	nopl   (%rax)
  86e850:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  86e855:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  86e859:	49 01 de             	add    %rbx,%r14
  86e85c:	4d 01 f0             	add    %r14,%r8
  86e85f:	49 83 c3 58          	add    $0x58,%r11
  86e863:	4c 89 c3             	mov    %r8,%rbx
  86e866:	4d 39 da             	cmp    %r11,%r10
  86e869:	75 e5                	jne    86e850 <gpui::runtime::style_ledger::batch_phase::read_probe+0xbe0>
  86e86b:	49 83 f9 03          	cmp    $0x3,%r9
  86e86f:	73 04                	jae    86e875 <gpui::runtime::style_ledger::batch_phase::read_probe+0xc05>
  86e871:	31 ff                	xor    %edi,%edi
  86e873:	eb 73                	jmp    86e8e8 <gpui::runtime::style_ledger::batch_phase::read_probe+0xc78>
  86e875:	49 89 d2             	mov    %rdx,%r10
  86e878:	49 21 f2             	and    %rsi,%r10
  86e87b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  86e882:	31 ff                	xor    %edi,%edi
  86e884:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  86e88b:	00 00 00 00 00 
  86e890:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  86e897:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  86e89e:	4c 01 c3             	add    %r8,%rbx
  86e8a1:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  86e8a8:	4d 01 f0             	add    %r14,%r8
  86e8ab:	49 01 d8             	add    %rbx,%r8
  86e8ae:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  86e8b5:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  86e8b9:	49 01 de             	add    %rbx,%r14
  86e8bc:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  86e8c0:	4c 01 f3             	add    %r14,%rbx
  86e8c3:	4c 01 c3             	add    %r8,%rbx
  86e8c6:	48 83 c7 04          	add    $0x4,%rdi
  86e8ca:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  86e8ce:	45 8b 03             	mov    (%r11),%r8d
  86e8d1:	4d 01 f0             	add    %r14,%r8
  86e8d4:	49 01 d8             	add    %rbx,%r8
  86e8d7:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  86e8de:	49 39 fa             	cmp    %rdi,%r10
  86e8e1:	75 ad                	jne    86e890 <gpui::runtime::style_ledger::batch_phase::read_probe+0xc20>
  86e8e3:	f6 c2 03             	test   $0x3,%dl
  86e8e6:	74 33                	je     86e91b <gpui::runtime::style_ledger::batch_phase::read_probe+0xcab>
  86e8e8:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  86e8ec:	48 01 c7             	add    %rax,%rdi
  86e8ef:	48 83 c7 18          	add    $0x18,%rdi
  86e8f3:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  86e8f7:	45 31 db             	xor    %r11d,%r11d
  86e8fa:	4c 89 c3             	mov    %r8,%rbx
  86e8fd:	0f 1f 00             	nopl   (%rax)
  86e900:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  86e905:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  86e909:	49 01 de             	add    %rbx,%r14
  86e90c:	4d 01 f0             	add    %r14,%r8
  86e90f:	49 83 c3 58          	add    $0x58,%r11
  86e913:	4c 89 c3             	mov    %r8,%rbx
  86e916:	4d 39 da             	cmp    %r11,%r10
  86e919:	75 e5                	jne    86e900 <gpui::runtime::style_ledger::batch_phase::read_probe+0xc90>
  86e91b:	49 83 f9 03          	cmp    $0x3,%r9
  86e91f:	73 04                	jae    86e925 <gpui::runtime::style_ledger::batch_phase::read_probe+0xcb5>
  86e921:	31 ff                	xor    %edi,%edi
  86e923:	eb 73                	jmp    86e998 <gpui::runtime::style_ledger::batch_phase::read_probe+0xd28>
  86e925:	49 89 d2             	mov    %rdx,%r10
  86e928:	49 21 f2             	and    %rsi,%r10
  86e92b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  86e932:	31 ff                	xor    %edi,%edi
  86e934:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  86e93b:	00 00 00 00 00 
  86e940:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  86e947:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  86e94e:	4c 01 c3             	add    %r8,%rbx
  86e951:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  86e958:	4d 01 f0             	add    %r14,%r8
  86e95b:	49 01 d8             	add    %rbx,%r8
  86e95e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  86e965:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  86e969:	49 01 de             	add    %rbx,%r14
  86e96c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  86e970:	4c 01 f3             	add    %r14,%rbx
  86e973:	4c 01 c3             	add    %r8,%rbx
  86e976:	48 83 c7 04          	add    $0x4,%rdi
  86e97a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  86e97e:	45 8b 03             	mov    (%r11),%r8d
  86e981:	4d 01 f0             	add    %r14,%r8
  86e984:	49 01 d8             	add    %rbx,%r8
  86e987:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  86e98e:	49 39 fa             	cmp    %rdi,%r10
  86e991:	75 ad                	jne    86e940 <gpui::runtime::style_ledger::batch_phase::read_probe+0xcd0>
  86e993:	f6 c2 03             	test   $0x3,%dl
  86e996:	74 33                	je     86e9cb <gpui::runtime::style_ledger::batch_phase::read_probe+0xd5b>
  86e998:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  86e99c:	48 01 c7             	add    %rax,%rdi
  86e99f:	48 83 c7 18          	add    $0x18,%rdi
  86e9a3:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  86e9a7:	45 31 db             	xor    %r11d,%r11d
  86e9aa:	4c 89 c3             	mov    %r8,%rbx
  86e9ad:	0f 1f 00             	nopl   (%rax)
  86e9b0:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  86e9b5:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  86e9b9:	49 01 de             	add    %rbx,%r14
  86e9bc:	4d 01 f0             	add    %r14,%r8
  86e9bf:	49 83 c3 58          	add    $0x58,%r11
  86e9c3:	4c 89 c3             	mov    %r8,%rbx
  86e9c6:	4d 39 da             	cmp    %r11,%r10
  86e9c9:	75 e5                	jne    86e9b0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xd40>
  86e9cb:	49 83 f9 03          	cmp    $0x3,%r9
  86e9cf:	73 04                	jae    86e9d5 <gpui::runtime::style_ledger::batch_phase::read_probe+0xd65>
  86e9d1:	31 ff                	xor    %edi,%edi
  86e9d3:	eb 73                	jmp    86ea48 <gpui::runtime::style_ledger::batch_phase::read_probe+0xdd8>
  86e9d5:	49 89 d2             	mov    %rdx,%r10
  86e9d8:	49 21 f2             	and    %rsi,%r10
  86e9db:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  86e9e2:	31 ff                	xor    %edi,%edi
  86e9e4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  86e9eb:	00 00 00 00 00 
  86e9f0:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  86e9f7:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  86e9fe:	4c 01 c3             	add    %r8,%rbx
  86ea01:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  86ea08:	4d 01 f0             	add    %r14,%r8
  86ea0b:	49 01 d8             	add    %rbx,%r8
  86ea0e:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  86ea15:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  86ea19:	49 01 de             	add    %rbx,%r14
  86ea1c:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  86ea20:	4c 01 f3             	add    %r14,%rbx
  86ea23:	4c 01 c3             	add    %r8,%rbx
  86ea26:	48 83 c7 04          	add    $0x4,%rdi
  86ea2a:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  86ea2e:	45 8b 03             	mov    (%r11),%r8d
  86ea31:	4d 01 f0             	add    %r14,%r8
  86ea34:	49 01 d8             	add    %rbx,%r8
  86ea37:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  86ea3e:	49 39 fa             	cmp    %rdi,%r10
  86ea41:	75 ad                	jne    86e9f0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xd80>
  86ea43:	f6 c2 03             	test   $0x3,%dl
  86ea46:	74 33                	je     86ea7b <gpui::runtime::style_ledger::batch_phase::read_probe+0xe0b>
  86ea48:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  86ea4c:	48 01 c7             	add    %rax,%rdi
  86ea4f:	48 83 c7 18          	add    $0x18,%rdi
  86ea53:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  86ea57:	45 31 db             	xor    %r11d,%r11d
  86ea5a:	4c 89 c3             	mov    %r8,%rbx
  86ea5d:	0f 1f 00             	nopl   (%rax)
  86ea60:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  86ea65:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  86ea69:	49 01 de             	add    %rbx,%r14
  86ea6c:	4d 01 f0             	add    %r14,%r8
  86ea6f:	49 83 c3 58          	add    $0x58,%r11
  86ea73:	4c 89 c3             	mov    %r8,%rbx
  86ea76:	4d 39 da             	cmp    %r11,%r10
  86ea79:	75 e5                	jne    86ea60 <gpui::runtime::style_ledger::batch_phase::read_probe+0xdf0>
  86ea7b:	49 83 f9 03          	cmp    $0x3,%r9
  86ea7f:	73 04                	jae    86ea85 <gpui::runtime::style_ledger::batch_phase::read_probe+0xe15>
  86ea81:	31 ff                	xor    %edi,%edi
  86ea83:	eb 73                	jmp    86eaf8 <gpui::runtime::style_ledger::batch_phase::read_probe+0xe88>
  86ea85:	49 89 d2             	mov    %rdx,%r10
  86ea88:	49 21 f2             	and    %rsi,%r10
  86ea8b:	4c 8d 98 20 01 00 00 	lea    0x120(%rax),%r11
  86ea92:	31 ff                	xor    %edi,%edi
  86ea94:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  86ea9b:	00 00 00 00 00 
  86eaa0:	41 8b 9b f0 fe ff ff 	mov    -0x110(%r11),%ebx
  86eaa7:	45 8b b3 f8 fe ff ff 	mov    -0x108(%r11),%r14d
  86eaae:	4c 01 c3             	add    %r8,%rbx
  86eab1:	45 8b 83 48 ff ff ff 	mov    -0xb8(%r11),%r8d
  86eab8:	4d 01 f0             	add    %r14,%r8
  86eabb:	49 01 d8             	add    %rbx,%r8
  86eabe:	41 8b 9b 50 ff ff ff 	mov    -0xb0(%r11),%ebx
  86eac5:	45 8b 73 a0          	mov    -0x60(%r11),%r14d
  86eac9:	49 01 de             	add    %rbx,%r14
  86eacc:	41 8b 5b a8          	mov    -0x58(%r11),%ebx
  86ead0:	4c 01 f3             	add    %r14,%rbx
  86ead3:	4c 01 c3             	add    %r8,%rbx
  86ead6:	48 83 c7 04          	add    $0x4,%rdi
  86eada:	45 8b 73 f8          	mov    -0x8(%r11),%r14d
  86eade:	45 8b 03             	mov    (%r11),%r8d
  86eae1:	4d 01 f0             	add    %r14,%r8
  86eae4:	49 01 d8             	add    %rbx,%r8
  86eae7:	49 81 c3 60 01 00 00 	add    $0x160,%r11
  86eaee:	49 39 fa             	cmp    %rdi,%r10
  86eaf1:	75 ad                	jne    86eaa0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xe30>
  86eaf3:	f6 c2 03             	test   $0x3,%dl
  86eaf6:	74 33                	je     86eb2b <gpui::runtime::style_ledger::batch_phase::read_probe+0xebb>
  86eaf8:	48 6b ff 58          	imul   $0x58,%rdi,%rdi
  86eafc:	48 01 c7             	add    %rax,%rdi
  86eaff:	48 83 c7 18          	add    $0x18,%rdi
  86eb03:	4c 6b d1 58          	imul   $0x58,%rcx,%r10
  86eb07:	45 31 db             	xor    %r11d,%r11d
  86eb0a:	4c 89 c3             	mov    %r8,%rbx
  86eb0d:	0f 1f 00             	nopl   (%rax)
  86eb10:	46 8b 74 1f f8       	mov    -0x8(%rdi,%r11,1),%r14d
  86eb15:	46 8b 04 1f          	mov    (%rdi,%r11,1),%r8d
  86eb19:	49 01 de             	add    %rbx,%r14
  86eb1c:	4d 01 f0             	add    %r14,%r8
  86eb1f:	49 83 c3 58          	add    $0x58,%r11
  86eb23:	4c 89 c3             	mov    %r8,%rbx
  86eb26:	4d 39 da             	cmp    %r11,%r10
  86eb29:	75 e5                	jne    86eb10 <gpui::runtime::style_ledger::batch_phase::read_probe+0xea0>
  86eb2b:	49 83 f9 03          	cmp    $0x3,%r9
  86eb2f:	73 04                	jae    86eb35 <gpui::runtime::style_ledger::batch_phase::read_probe+0xec5>
  86eb31:	31 ff                	xor    %edi,%edi
  86eb33:	eb 73                	jmp    86eba8 <gpui::runtime::style_ledger::batch_phase::read_probe+0xf38>
  86eb35:	48 21 d6             	and    %rdx,%rsi
  86eb38:	4c 8d 88 20 01 00 00 	lea    0x120(%rax),%r9
  86eb3f:	31 ff                	xor    %edi,%edi
  86eb41:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  86eb48:	0f 1f 84 00 00 00 00 
  86eb4f:	00 
  86eb50:	45 8b 91 f0 fe ff ff 	mov    -0x110(%r9),%r10d
  86eb57:	45 8b 99 f8 fe ff ff 	mov    -0x108(%r9),%r11d
  86eb5e:	4d 01 c2             	add    %r8,%r10
  86eb61:	45 8b 81 48 ff ff ff 	mov    -0xb8(%r9),%r8d
  86eb68:	4d 01 d8             	add    %r11,%r8
  86eb6b:	4d 01 d0             	add    %r10,%r8
  86eb6e:	45 8b 91 50 ff ff ff 	mov    -0xb0(%r9),%r10d
  86eb75:	45 8b 59 a0          	mov    -0x60(%r9),%r11d
  86eb79:	4d 01 d3             	add    %r10,%r11
  86eb7c:	45 8b 51 a8          	mov    -0x58(%r9),%r10d
  86eb80:	4d 01 da             	add    %r11,%r10
  86eb83:	4d 01 c2             	add    %r8,%r10
  86eb86:	48 83 c7 04          	add    $0x4,%rdi
  86eb8a:	45 8b 59 f8          	mov    -0x8(%r9),%r11d
  86eb8e:	45 8b 01             	mov    (%r9),%r8d
  86eb91:	4d 01 d8             	add    %r11,%r8
  86eb94:	4d 01 d0             	add    %r10,%r8
  86eb97:	49 81 c1 60 01 00 00 	add    $0x160,%r9
  86eb9e:	48 39 fe             	cmp    %rdi,%rsi
  86eba1:	75 ad                	jne    86eb50 <gpui::runtime::style_ledger::batch_phase::read_probe+0xee0>
  86eba3:	f6 c2 03             	test   $0x3,%dl
  86eba6:	74 32                	je     86ebda <gpui::runtime::style_ledger::batch_phase::read_probe+0xf6a>
  86eba8:	48 6b d7 58          	imul   $0x58,%rdi,%rdx
  86ebac:	48 01 d0             	add    %rdx,%rax
  86ebaf:	48 83 c0 18          	add    $0x18,%rax
  86ebb3:	48 6b c9 58          	imul   $0x58,%rcx,%rcx
  86ebb7:	31 d2                	xor    %edx,%edx
  86ebb9:	4c 89 c6             	mov    %r8,%rsi
  86ebbc:	0f 1f 40 00          	nopl   0x0(%rax)
  86ebc0:	8b 7c 10 f8          	mov    -0x8(%rax,%rdx,1),%edi
  86ebc4:	44 8b 04 10          	mov    (%rax,%rdx,1),%r8d
  86ebc8:	48 01 f7             	add    %rsi,%rdi
  86ebcb:	49 01 f8             	add    %rdi,%r8
  86ebce:	48 83 c2 58          	add    $0x58,%rdx
  86ebd2:	4c 89 c6             	mov    %r8,%rsi
  86ebd5:	48 39 d1             	cmp    %rdx,%rcx
  86ebd8:	75 e6                	jne    86ebc0 <gpui::runtime::style_ledger::batch_phase::read_probe+0xf50>
  86ebda:	4c 89 04 24          	mov    %r8,(%rsp)
  86ebde:	48 89 e0             	mov    %rsp,%rax
  86ebe1:	48 8b 04 24          	mov    (%rsp),%rax
  86ebe5:	48 83 c4 38          	add    $0x38,%rsp
  86ebe9:	5b                   	pop    %rbx
  86ebea:	41 5e                	pop    %r14
  86ebec:	c3                   	ret
  86ebed:	48 8d 15 14 48 3f 00 	lea    0x3f4814(%rip),%rdx        # c63408 <anon.0ccdd01f9eda8572f8ac6f637216e6b0.87.llvm.13523452353338582590+0x98>
  86ebf4:	48 89 fe             	mov    %rdi,%rsi
  86ebf7:	ff 15 3b 67 42 00    	call   *0x42673b(%rip)        # c95338 <_DYNAMIC+0x298>
  86ebfd:	48 8d 15 1c 48 3f 00 	lea    0x3f481c(%rip),%rdx        # c63420 <anon.0ccdd01f9eda8572f8ac6f637216e6b0.87.llvm.13523452353338582590+0xb0>
  86ec04:	48 89 c7             	mov    %rax,%rdi
  86ec07:	ff 15 2b 67 42 00    	call   *0x42672b(%rip)        # c95338 <_DYNAMIC+0x298>
  86ec0d:	48 ff ca             	dec    %rdx
  86ec10:	48 39 d6             	cmp    %rdx,%rsi
  86ec13:	48 0f 42 d6          	cmovb  %rsi,%rdx
  86ec17:	48 89 d7             	mov    %rdx,%rdi
  86ec1a:	48 8d 15 cf 47 3f 00 	lea    0x3f47cf(%rip),%rdx        # c633f0 <anon.0ccdd01f9eda8572f8ac6f637216e6b0.87.llvm.13523452353338582590+0x80>
  86ec21:	ff 15 11 67 42 00    	call   *0x426711(%rip)        # c95338 <_DYNAMIC+0x298>
  86ec27:	48 c7 04 24 0d 00 00 	movq   $0xd,(%rsp)
  86ec2e:	00 
  86ec2f:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  86ec36:	00 00 
  86ec38:	48 8d 3d d1 c8 81 ff 	lea    -0x7e372f(%rip),%rdi        # 8b510 <anon.0ccdd01f9eda8572f8ac6f637216e6b0.79.llvm.13523452353338582590>
  86ec3f:	48 8d 0d 4a 46 3f 00 	lea    0x3f464a(%rip),%rcx        # c63290 <anon.0ccdd01f9eda8572f8ac6f637216e6b0.80.llvm.13523452353338582590>
  86ec46:	4c 8d 05 3b 4e 3f 00 	lea    0x3f4e3b(%rip),%r8        # c63a88 <anon.0ccdd01f9eda8572f8ac6f637216e6b0.149.llvm.13523452353338582590+0x4a0>
  86ec4d:	48 89 e2             	mov    %rsp,%rdx
  86ec50:	be 2b 00 00 00       	mov    $0x2b,%esi
  86ec55:	ff 15 85 67 42 00    	call   *0x426785(%rip)        # c953e0 <_DYNAMIC+0x340>
  86ec5b:	0f 0b                	ud2
  86ec5d:	48 89 c3             	mov    %rax,%rbx
  86ec60:	48 89 e7             	mov    %rsp,%rdi
  86ec63:	e8 a8 65 ff ff       	call   865210 <core::ptr::drop_glue::<gpui::runtime::Error>>
  86ec68:	48 89 df             	mov    %rbx,%rdi
  86ec6b:	e8 10 fe 3e 00       	call   c5ea80 <_Unwind_Resume@plt>
