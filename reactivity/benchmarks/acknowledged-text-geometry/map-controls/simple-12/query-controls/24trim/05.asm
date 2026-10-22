
/tmp/gpui-text-map-query-controls/24trim/selection_queries:     file format elf64-x86-64


Disassembly of section .text:

0000000000684db0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line>:
  684db0:	55                   	push   %rbp
  684db1:	41 57                	push   %r15
  684db3:	41 56                	push   %r14
  684db5:	41 55                	push   %r13
  684db7:	41 54                	push   %r12
  684db9:	53                   	push   %rbx
  684dba:	48 83 ec 68          	sub    $0x68,%rsp
  684dbe:	48 83 7f 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rdi)
  684dc3:	74 79                	je     684e3e <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x8e>
  684dc5:	48 8b 47 28          	mov    0x28(%rdi),%rax
  684dc9:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  684dce:	48 39 c6             	cmp    %rax,%rsi
  684dd1:	0f 83 9e 07 00 00    	jae    685575 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x7c5>
  684dd7:	48 8b 47 38          	mov    0x38(%rdi),%rax
  684ddb:	4c 8b 77 40          	mov    0x40(%rdi),%r14
  684ddf:	4c 8b 47 20          	mov    0x20(%rdi),%r8
  684de3:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
  684de8:	48 8d 0c 76          	lea    (%rsi,%rsi,2),%rcx
  684dec:	41 8b 34 c8          	mov    (%r8,%rcx,8),%esi
  684df0:	85 f6                	test   %esi,%esi
  684df2:	74 51                	je     684e45 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x95>
  684df4:	4c 89 f2             	mov    %r14,%rdx
  684df7:	4d 85 f6             	test   %r14,%r14
  684dfa:	74 4b                	je     684e47 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x97>
  684dfc:	31 d2                	xor    %edx,%edx
  684dfe:	49 83 fe 01          	cmp    $0x1,%r14
  684e02:	74 2b                	je     684e2f <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x7f>
  684e04:	4d 89 f1             	mov    %r14,%r9
  684e07:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  684e0e:	00 00 
  684e10:	4d 89 ca             	mov    %r9,%r10
  684e13:	49 d1 ea             	shr    $1,%r10
  684e16:	4d 8d 1c 12          	lea    (%r10,%rdx,1),%r11
  684e1a:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
  684e1e:	39 74 d8 10          	cmp    %esi,0x10(%rax,%rbx,8)
  684e22:	49 0f 42 d3          	cmovb  %r11,%rdx
  684e26:	4d 29 d1             	sub    %r10,%r9
  684e29:	49 83 f9 01          	cmp    $0x1,%r9
  684e2d:	77 e1                	ja     684e10 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x60>
  684e2f:	4c 8d 0c 52          	lea    (%rdx,%rdx,2),%r9
  684e33:	42 39 74 c8 10       	cmp    %esi,0x10(%rax,%r9,8)
  684e38:	48 83 d2 00          	adc    $0x0,%rdx
  684e3c:	eb 09                	jmp    684e47 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x97>
  684e3e:	b2 02                	mov    $0x2,%dl
  684e40:	e9 c4 06 00 00       	jmp    685509 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x759>
  684e45:	31 d2                	xor    %edx,%edx
  684e47:	4c 89 44 24 28       	mov    %r8,0x28(%rsp)
  684e4c:	49 8d 0c c8          	lea    (%r8,%rcx,8),%rcx
  684e50:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
  684e55:	49 29 d6             	sub    %rdx,%r14
  684e58:	48 8d 0c 52          	lea    (%rdx,%rdx,2),%rcx
  684e5c:	48 8d 04 c8          	lea    (%rax,%rcx,8),%rax
  684e60:	48 8b 5f 08          	mov    0x8(%rdi),%rbx
  684e64:	48 8b 4f 10          	mov    0x10(%rdi),%rcx
  684e68:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  684e6d:	c6 44 24 0f 02       	movb   $0x2,0xf(%rsp)
  684e72:	45 31 d2             	xor    %r10d,%r10d
  684e75:	40 b6 02             	mov    $0x2,%sil
  684e78:	49 89 c7             	mov    %rax,%r15
  684e7b:	4d 89 f4             	mov    %r14,%r12
  684e7e:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  684e83:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  684e88:	4c 89 74 24 58       	mov    %r14,0x58(%rsp)
  684e8d:	4d 89 f5             	mov    %r14,%r13
  684e90:	48 89 5c 24 60       	mov    %rbx,0x60(%rsp)
  684e95:	89 f7                	mov    %esi,%edi
  684e97:	44 89 c0             	mov    %r8d,%eax
  684e9a:	0f 28 da             	movaps %xmm2,%xmm3
  684e9d:	0f 28 d3             	movaps %xmm3,%xmm2
  684ea0:	89 fe                	mov    %edi,%esi
  684ea2:	89 74 24 20          	mov    %esi,0x20(%rsp)
  684ea6:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  684eaa:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  684eaf:	eb 12                	jmp    684ec3 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x113>
  684eb1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  684eb8:	0f 1f 84 00 00 00 00 
  684ebf:	00 
  684ec0:	49 89 f1             	mov    %rsi,%r9
  684ec3:	4c 89 fd             	mov    %r15,%rbp
  684ec6:	4c 89 e0             	mov    %r12,%rax
  684ec9:	49 83 fc 01          	cmp    $0x1,%r12
  684ecd:	74 38                	je     684f07 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x157>
  684ecf:	4d 85 e4             	test   %r12,%r12
  684ed2:	0f 84 93 03 00 00    	je     68526b <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x4bb>
  684ed8:	48 8d 4d 28          	lea    0x28(%rbp),%rcx
  684edc:	49 8d 54 24 01       	lea    0x1(%r12),%rdx
  684ee1:	b8 01 00 00 00       	mov    $0x1,%eax
  684ee6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  684eed:	00 00 00 
  684ef0:	8b 79 e8             	mov    -0x18(%rcx),%edi
  684ef3:	3b 39                	cmp    (%rcx),%edi
  684ef5:	75 10                	jne    684f07 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x157>
  684ef7:	48 ff c0             	inc    %rax
  684efa:	48 83 c1 18          	add    $0x18,%rcx
  684efe:	48 ff ca             	dec    %rdx
  684f01:	48 83 fa 02          	cmp    $0x2,%rdx
  684f05:	77 e9                	ja     684ef0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x140>
  684f07:	49 29 c4             	sub    %rax,%r12
  684f0a:	0f 82 08 06 00 00    	jb     685518 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x768>
  684f10:	41 f6 c2 01          	test   $0x1,%r10b
  684f14:	0f 84 dc 01 00 00    	je     6850f6 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x346>
  684f1a:	4c 89 ef             	mov    %r13,%rdi
  684f1d:	49 83 fd 01          	cmp    $0x1,%r13
  684f21:	74 36                	je     684f59 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1a9>
  684f23:	4d 85 ed             	test   %r13,%r13
  684f26:	0f 84 3f 03 00 00    	je     68526b <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x4bb>
  684f2c:	49 8d 49 28          	lea    0x28(%r9),%rcx
  684f30:	49 8d 55 01          	lea    0x1(%r13),%rdx
  684f34:	bf 01 00 00 00       	mov    $0x1,%edi
  684f39:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  684f40:	44 8b 51 e8          	mov    -0x18(%rcx),%r10d
  684f44:	44 3b 11             	cmp    (%rcx),%r10d
  684f47:	75 10                	jne    684f59 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1a9>
  684f49:	48 ff c7             	inc    %rdi
  684f4c:	48 83 c1 18          	add    $0x18,%rcx
  684f50:	48 ff ca             	dec    %rdx
  684f53:	48 83 fa 02          	cmp    $0x2,%rdx
  684f57:	77 e7                	ja     684f40 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x190>
  684f59:	49 29 fd             	sub    %rdi,%r13
  684f5c:	0f 82 b6 05 00 00    	jb     685518 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x768>
  684f62:	48 8d 0c 7f          	lea    (%rdi,%rdi,2),%rcx
  684f66:	49 8d 34 c9          	lea    (%r9,%rcx,8),%rsi
  684f6a:	48 8d 0c 40          	lea    (%rax,%rax,2),%rcx
  684f6e:	4c 8d 3c cd 00 00 00 	lea    0x0(,%rcx,8),%r15
  684f75:	00 
  684f76:	49 01 ef             	add    %rbp,%r15
  684f79:	48 c1 e0 03          	shl    $0x3,%rax
  684f7d:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  684f81:	31 c9                	xor    %ecx,%ecx
  684f83:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  684f8a:	84 00 00 00 00 00 
  684f90:	41 b2 01             	mov    $0x1,%r10b
  684f93:	48 39 c8             	cmp    %rcx,%rax
  684f96:	0f 84 24 ff ff ff    	je     684ec0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x110>
  684f9c:	48 8d 51 18          	lea    0x18(%rcx),%rdx
  684fa0:	f6 44 0d 14 02       	testb  $0x2,0x14(%rbp,%rcx,1)
  684fa5:	48 89 d1             	mov    %rdx,%rcx
  684fa8:	74 e6                	je     684f90 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1e0>
  684faa:	48 c1 e7 03          	shl    $0x3,%rdi
  684fae:	48 8d 04 7f          	lea    (%rdi,%rdi,2),%rax
  684fb2:	31 c9                	xor    %ecx,%ecx
  684fb4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  684fbb:	00 00 00 00 00 
  684fc0:	48 39 c8             	cmp    %rcx,%rax
  684fc3:	0f 84 f7 fe ff ff    	je     684ec0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x110>
  684fc9:	4c 8d 59 18          	lea    0x18(%rcx),%r11
  684fcd:	41 f6 44 09 14 01    	testb  $0x1,0x14(%r9,%rcx,1)
  684fd3:	4c 89 d9             	mov    %r11,%rcx
  684fd6:	74 e8                	je     684fc0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x210>
  684fd8:	8b 44 15 f8          	mov    -0x8(%rbp,%rdx,1),%eax
  684fdc:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  684fe1:	48 89 cf             	mov    %rcx,%rdi
  684fe4:	48 85 c9             	test   %rcx,%rcx
  684fe7:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
  684fec:	74 65                	je     685053 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x2a3>
  684fee:	48 83 f9 01          	cmp    $0x1,%rcx
  684ff2:	75 09                	jne    684ffd <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x24d>
  684ff4:	31 c9                	xor    %ecx,%ecx
  684ff6:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  684ffb:	eb 34                	jmp    685031 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x281>
  684ffd:	48 89 cf             	mov    %rcx,%rdi
  685000:	31 c9                	xor    %ecx,%ecx
  685002:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  685007:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  68500e:	00 00 
  685010:	49 89 ce             	mov    %rcx,%r14
  685013:	48 89 fe             	mov    %rdi,%rsi
  685016:	48 d1 ee             	shr    $1,%rsi
  685019:	48 01 f1             	add    %rsi,%rcx
  68501c:	4c 8d 04 49          	lea    (%rcx,%rcx,2),%r8
  685020:	42 39 04 c3          	cmp    %eax,(%rbx,%r8,8)
  685024:	49 0f 47 ce          	cmova  %r14,%rcx
  685028:	48 29 f7             	sub    %rsi,%rdi
  68502b:	48 83 ff 01          	cmp    $0x1,%rdi
  68502f:	77 df                	ja     685010 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x260>
  685031:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  685035:	31 ff                	xor    %edi,%edi
  685037:	39 04 f3             	cmp    %eax,(%rbx,%rsi,8)
  68503a:	40 0f 96 c7          	setbe  %dil
  68503e:	48 01 cf             	add    %rcx,%rdi
  685041:	48 83 ff 01          	cmp    $0x1,%rdi
  685045:	48 83 d7 ff          	adc    $0xffffffffffffffff,%rdi
  685049:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  68504e:	48 8b 5c 24 60       	mov    0x60(%rsp),%rbx
  685053:	48 39 cf             	cmp    %rcx,%rdi
  685056:	0f 83 07 05 00 00    	jae    685563 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x7b3>
  68505c:	43 8b 4c 19 f8       	mov    -0x8(%r9,%r11,1),%ecx
  685061:	48 8d 34 7f          	lea    (%rdi,%rdi,2),%rsi
  685065:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
  68506a:	45 8b 74 f0 04       	mov    0x4(%r8,%rsi,8),%r14d
  68506f:	f3 0f 10 5c 15 e8    	movss  -0x18(%rbp,%rdx,1),%xmm3
  685075:	f3 43 0f 10 64 19 e8 	movss  -0x18(%r9,%r11,1),%xmm4
  68507c:	44 39 f1             	cmp    %r14d,%ecx
  68507f:	77 07                	ja     685088 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x2d8>
  685081:	0f 2e dc             	ucomiss %xmm4,%xmm3
  685084:	75 4a                	jne    6850d0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x320>
  685086:	7a 48                	jp     6850d0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x320>
  685088:	48 83 7c 24 38 02    	cmpq   $0x2,0x38(%rsp)
  68508e:	72 40                	jb     6850d0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x320>
  685090:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  685095:	45 31 c9             	xor    %r9d,%r9d
  685098:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  68509f:	00 
  6850a0:	48 89 d6             	mov    %rdx,%rsi
  6850a3:	48 d1 ee             	shr    $1,%rsi
  6850a6:	4e 8d 04 0e          	lea    (%rsi,%r9,1),%r8
  6850aa:	4f 8d 1c 40          	lea    (%r8,%r8,2),%r11
  6850ae:	46 8b 5c db 10       	mov    0x10(%rbx,%r11,8),%r11d
  6850b3:	4c 39 df             	cmp    %r11,%rdi
  6850b6:	4d 0f 47 c8          	cmova  %r8,%r9
  6850ba:	48 29 f2             	sub    %rsi,%rdx
  6850bd:	48 83 fa 01          	cmp    $0x1,%rdx
  6850c1:	77 dd                	ja     6850a0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x2f0>
  6850c3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6850ca:	84 00 00 00 00 00 
  6850d0:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  6850d5:	3b 42 04             	cmp    0x4(%rdx),%eax
  6850d8:	0f 87 8d 01 00 00    	ja     68526b <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x4bb>
  6850de:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  6850e3:	4c 89 fd             	mov    %r15,%rbp
  6850e6:	48 3b 7c 24 40       	cmp    0x40(%rsp),%rdi
  6850eb:	0f 85 d5 fd ff ff    	jne    684ec6 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x116>
  6850f1:	e9 a3 00 00 00       	jmp    685199 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3e9>
  6850f6:	4c 89 ea             	mov    %r13,%rdx
  6850f9:	49 83 fd 01          	cmp    $0x1,%r13
  6850fd:	74 2f                	je     68512e <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x37e>
  6850ff:	4d 85 ed             	test   %r13,%r13
  685102:	0f 84 63 01 00 00    	je     68526b <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x4bb>
  685108:	49 8d 49 28          	lea    0x28(%r9),%rcx
  68510c:	49 8d 7d 01          	lea    0x1(%r13),%rdi
  685110:	ba 01 00 00 00       	mov    $0x1,%edx
  685115:	44 8b 51 e8          	mov    -0x18(%rcx),%r10d
  685119:	44 3b 11             	cmp    (%rcx),%r10d
  68511c:	75 10                	jne    68512e <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x37e>
  68511e:	48 ff c2             	inc    %rdx
  685121:	48 83 c1 18          	add    $0x18,%rcx
  685125:	48 ff cf             	dec    %rdi
  685128:	48 83 ff 02          	cmp    $0x2,%rdi
  68512c:	77 e7                	ja     685115 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x365>
  68512e:	4c 89 e9             	mov    %r13,%rcx
  685131:	48 29 d1             	sub    %rdx,%rcx
  685134:	0f 82 de 03 00 00    	jb     685518 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x768>
  68513a:	4c 8d 14 52          	lea    (%rdx,%rdx,2),%r10
  68513e:	48 89 cf             	mov    %rcx,%rdi
  685141:	48 83 f9 01          	cmp    $0x1,%rcx
  685145:	74 35                	je     68517c <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3cc>
  685147:	48 85 c9             	test   %rcx,%rcx
  68514a:	0f 84 1b 01 00 00    	je     68526b <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x4bb>
  685150:	4f 8d 1c d1          	lea    (%r9,%r10,8),%r11
  685154:	49 83 c3 28          	add    $0x28,%r11
  685158:	49 29 d5             	sub    %rdx,%r13
  68515b:	49 ff c5             	inc    %r13
  68515e:	bf 01 00 00 00       	mov    $0x1,%edi
  685163:	41 8b 53 e8          	mov    -0x18(%r11),%edx
  685167:	41 3b 13             	cmp    (%r11),%edx
  68516a:	75 10                	jne    68517c <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3cc>
  68516c:	48 ff c7             	inc    %rdi
  68516f:	49 83 c3 18          	add    $0x18,%r11
  685173:	49 ff cd             	dec    %r13
  685176:	49 83 fd 02          	cmp    $0x2,%r13
  68517a:	77 e7                	ja     685163 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x3b3>
  68517c:	48 29 f9             	sub    %rdi,%rcx
  68517f:	0f 82 93 03 00 00    	jb     685518 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x768>
  685185:	4f 8d 0c d1          	lea    (%r9,%r10,8),%r9
  685189:	48 8d 14 7f          	lea    (%rdi,%rdi,2),%rdx
  68518d:	49 8d 34 d1          	lea    (%r9,%rdx,8),%rsi
  685191:	49 89 cd             	mov    %rcx,%r13
  685194:	e9 d1 fd ff ff       	jmp    684f6a <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x1ba>
  685199:	40 b7 01             	mov    $0x1,%dil
  68519c:	44 39 f1             	cmp    %r14d,%ecx
  68519f:	76 3b                	jbe    6851dc <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x42c>
  6851a1:	89 c2                	mov    %eax,%edx
  6851a3:	b1 01                	mov    $0x1,%cl
  6851a5:	0f 28 eb             	movaps %xmm3,%xmm5
  6851a8:	8b 74 24 20          	mov    0x20(%rsp),%esi
  6851ac:	44 8b 44 24 1c       	mov    0x1c(%rsp),%r8d
  6851b1:	0f 2e d8             	ucomiss %xmm0,%xmm3
  6851b4:	0f 87 86 00 00 00    	ja     685240 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x490>
  6851ba:	0f 2e c5             	ucomiss %xmm5,%xmm0
  6851bd:	0f 86 78 03 00 00    	jbe    68553b <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x78b>
  6851c3:	41 b2 01             	mov    $0x1,%r10b
  6851c6:	80 7c 24 0f 02       	cmpb   $0x2,0xf(%rsp)
  6851cb:	0f 84 8a 00 00 00    	je     68525b <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x4ab>
  6851d1:	0f 2e e9             	ucomiss %xmm1,%xmm5
  6851d4:	0f 86 d0 fc ff ff    	jbe    684eaa <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0xfa>
  6851da:	eb 7f                	jmp    68525b <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x4ab>
  6851dc:	0f 28 eb             	movaps %xmm3,%xmm5
  6851df:	f3 0f 5d ec          	minss  %xmm4,%xmm5
  6851e3:	0f 28 f5             	movaps %xmm5,%xmm6
  6851e6:	f3 0f c2 f5 03       	cmpunordss %xmm5,%xmm6
  6851eb:	0f 28 fe             	movaps %xmm6,%xmm7
  6851ee:	0f 55 fd             	andnps %xmm5,%xmm7
  6851f1:	0f 54 f3             	andps  %xmm3,%xmm6
  6851f4:	0f 56 f7             	orps   %xmm7,%xmm6
  6851f7:	0f 28 fb             	movaps %xmm3,%xmm7
  6851fa:	f3 0f 5f fc          	maxss  %xmm4,%xmm7
  6851fe:	0f 28 ef             	movaps %xmm7,%xmm5
  685201:	f3 0f c2 ef 03       	cmpunordss %xmm7,%xmm5
  685206:	44 0f 28 c5          	movaps %xmm5,%xmm8
  68520a:	44 0f 55 c7          	andnps %xmm7,%xmm8
  68520e:	0f 54 eb             	andps  %xmm3,%xmm5
  685211:	41 0f 56 e8          	orps   %xmm8,%xmm5
  685215:	0f 2e e3             	ucomiss %xmm3,%xmm4
  685218:	40 0f 97 c7          	seta   %dil
  68521c:	89 ce                	mov    %ecx,%esi
  68521e:	0f 47 f0             	cmova  %eax,%esi
  685221:	89 c2                	mov    %eax,%edx
  685223:	0f 47 d1             	cmova  %ecx,%edx
  685226:	0f 96 c1             	setbe  %cl
  685229:	0f 28 de             	movaps %xmm6,%xmm3
  68522c:	89 f0                	mov    %esi,%eax
  68522e:	8b 74 24 20          	mov    0x20(%rsp),%esi
  685232:	44 8b 44 24 1c       	mov    0x1c(%rsp),%r8d
  685237:	0f 2e d8             	ucomiss %xmm0,%xmm3
  68523a:	0f 86 7a ff ff ff    	jbe    6851ba <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x40a>
  685240:	41 b2 01             	mov    $0x1,%r10b
  685243:	40 80 fe 02          	cmp    $0x2,%sil
  685247:	0f 84 50 fc ff ff    	je     684e9d <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0xed>
  68524d:	0f 2e d3             	ucomiss %xmm3,%xmm2
  685250:	0f 86 54 fc ff ff    	jbe    684eaa <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0xfa>
  685256:	e9 42 fc ff ff       	jmp    684e9d <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0xed>
  68525b:	88 4c 24 0f          	mov    %cl,0xf(%rsp)
  68525f:	89 54 24 24          	mov    %edx,0x24(%rsp)
  685263:	0f 28 cd             	movaps %xmm5,%xmm1
  685266:	e9 2a fc ff ff       	jmp    684e95 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0xe5>
  68526b:	0f b6 54 24 0f       	movzbl 0xf(%rsp),%edx
  685270:	80 fa 02             	cmp    $0x2,%dl
  685273:	75 4c                	jne    6852c1 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x511>
  685275:	8b 54 24 20          	mov    0x20(%rsp),%edx
  685279:	80 fa 02             	cmp    $0x2,%dl
  68527c:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  685280:	0f 85 83 02 00 00    	jne    685509 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x759>
  685286:	b2 02                	mov    $0x2,%dl
  685288:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  68528d:	48 85 c0             	test   %rax,%rax
  685290:	0f 84 73 02 00 00    	je     685509 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x759>
  685296:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  68529a:	4c 8b 64 24 50       	mov    0x50(%rsp),%r12
  68529f:	49 8d 3c c4          	lea    (%r12,%rax,8),%rdi
  6852a3:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  6852a8:	44 8b 48 04          	mov    0x4(%rax),%r9d
  6852ac:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  6852b1:	4c 8d 51 ff          	lea    -0x1(%rcx),%r10
  6852b5:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
  6852ba:	4c 8b 74 24 28       	mov    0x28(%rsp),%r14
  6852bf:	eb 49                	jmp    68530a <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x55a>
  6852c1:	8b 4c 24 20          	mov    0x20(%rsp),%ecx
  6852c5:	80 f9 02             	cmp    $0x2,%cl
  6852c8:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  6852cc:	0f 85 0b 02 00 00    	jne    6854dd <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x72d>
  6852d2:	8b 44 24 24          	mov    0x24(%rsp),%eax
  6852d6:	e9 2e 02 00 00       	jmp    685509 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x759>
  6852db:	4b 8d 0c 7f          	lea    (%r15,%r15,2),%rcx
  6852df:	41 39 44 ce 04       	cmp    %eax,0x4(%r14,%rcx,8)
  6852e4:	49 83 d7 00          	adc    $0x0,%r15
  6852e8:	4d 39 fa             	cmp    %r15,%r10
  6852eb:	4d 0f 42 fa          	cmovb  %r10,%r15
  6852ef:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  6852f4:	49 39 df             	cmp    %rbx,%r15
  6852f7:	0f 84 34 02 00 00    	je     685531 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x781>
  6852fd:	49 83 c4 18          	add    $0x18,%r12
  685301:	49 39 fc             	cmp    %rdi,%r12
  685304:	0f 84 ff 01 00 00    	je     685509 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x759>
  68530a:	41 8b 44 24 10       	mov    0x10(%r12),%eax
  68530f:	44 39 c8             	cmp    %r9d,%eax
  685312:	0f 87 f1 01 00 00    	ja     685509 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x759>
  685318:	41 0f b6 6c 24 14    	movzbl 0x14(%r12),%ebp
  68531e:	85 c0                	test   %eax,%eax
  685320:	74 2e                	je     685350 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5a0>
  685322:	40 f6 c5 02          	test   $0x2,%bpl
  685326:	0f 84 9d 00 00 00    	je     6853c9 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x619>
  68532c:	49 89 c8             	mov    %rcx,%r8
  68532f:	48 85 c9             	test   %rcx,%rcx
  685332:	0f 84 88 00 00 00    	je     6853c0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x610>
  685338:	48 83 f9 01          	cmp    $0x1,%rcx
  68533c:	75 39                	jne    685377 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5c7>
  68533e:	31 c9                	xor    %ecx,%ecx
  685340:	eb 5f                	jmp    6853a1 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5f1>
  685342:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  685349:	1f 84 00 00 00 00 00 
  685350:	40 f6 c5 02          	test   $0x2,%bpl
  685354:	0f 84 0f 01 00 00    	je     685469 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6b9>
  68535a:	49 89 c8             	mov    %rcx,%r8
  68535d:	48 85 c9             	test   %rcx,%rcx
  685360:	0f 84 fa 00 00 00    	je     685460 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6b0>
  685366:	48 83 f9 01          	cmp    $0x1,%rcx
  68536a:	0f 85 a5 00 00 00    	jne    685415 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x665>
  685370:	31 c9                	xor    %ecx,%ecx
  685372:	e9 c9 00 00 00       	jmp    685440 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x690>
  685377:	49 89 cf             	mov    %rcx,%r15
  68537a:	31 c9                	xor    %ecx,%ecx
  68537c:	0f 1f 40 00          	nopl   0x0(%rax)
  685380:	48 89 ce             	mov    %rcx,%rsi
  685383:	4d 89 f8             	mov    %r15,%r8
  685386:	49 d1 e8             	shr    $1,%r8
  685389:	4c 01 c1             	add    %r8,%rcx
  68538c:	4c 8d 1c 49          	lea    (%rcx,%rcx,2),%r11
  685390:	43 39 04 de          	cmp    %eax,(%r14,%r11,8)
  685394:	48 0f 47 ce          	cmova  %rsi,%rcx
  685398:	4d 29 c7             	sub    %r8,%r15
  68539b:	49 83 ff 01          	cmp    $0x1,%r15
  68539f:	77 df                	ja     685380 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x5d0>
  6853a1:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  6853a5:	45 31 c0             	xor    %r8d,%r8d
  6853a8:	41 39 04 f6          	cmp    %eax,(%r14,%rsi,8)
  6853ac:	41 0f 96 c0          	setbe  %r8b
  6853b0:	49 01 c8             	add    %rcx,%r8
  6853b3:	49 83 f8 01          	cmp    $0x1,%r8
  6853b7:	49 83 d0 ff          	adc    $0xffffffffffffffff,%r8
  6853bb:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  6853c0:	49 39 d8             	cmp    %rbx,%r8
  6853c3:	0f 84 6e 01 00 00    	je     685537 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x787>
  6853c9:	40 f6 c5 01          	test   $0x1,%bpl
  6853cd:	0f 84 2a ff ff ff    	je     6852fd <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x54d>
  6853d3:	49 89 cf             	mov    %rcx,%r15
  6853d6:	48 85 c9             	test   %rcx,%rcx
  6853d9:	0f 84 15 ff ff ff    	je     6852f4 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x544>
  6853df:	45 31 ff             	xor    %r15d,%r15d
  6853e2:	48 83 f9 01          	cmp    $0x1,%rcx
  6853e6:	0f 84 ef fe ff ff    	je     6852db <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x52b>
  6853ec:	0f 1f 40 00          	nopl   0x0(%rax)
  6853f0:	49 89 cb             	mov    %rcx,%r11
  6853f3:	49 d1 eb             	shr    $1,%r11
  6853f6:	4b 8d 34 3b          	lea    (%r11,%r15,1),%rsi
  6853fa:	4c 8d 04 76          	lea    (%rsi,%rsi,2),%r8
  6853fe:	43 39 44 c6 04       	cmp    %eax,0x4(%r14,%r8,8)
  685403:	4c 0f 42 fe          	cmovb  %rsi,%r15
  685407:	4c 29 d9             	sub    %r11,%rcx
  68540a:	48 83 f9 01          	cmp    $0x1,%rcx
  68540e:	77 e0                	ja     6853f0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x640>
  685410:	e9 c6 fe ff ff       	jmp    6852db <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x52b>
  685415:	49 89 cf             	mov    %rcx,%r15
  685418:	31 c9                	xor    %ecx,%ecx
  68541a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  685420:	4c 89 fe             	mov    %r15,%rsi
  685423:	48 d1 ee             	shr    $1,%rsi
  685426:	4c 8d 04 0e          	lea    (%rsi,%rcx,1),%r8
  68542a:	4f 8d 1c 40          	lea    (%r8,%r8,2),%r11
  68542e:	43 83 3c de 00       	cmpl   $0x0,(%r14,%r11,8)
  685433:	49 0f 44 c8          	cmove  %r8,%rcx
  685437:	49 29 f7             	sub    %rsi,%r15
  68543a:	49 83 ff 01          	cmp    $0x1,%r15
  68543e:	77 e0                	ja     685420 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x670>
  685440:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  685444:	45 31 c0             	xor    %r8d,%r8d
  685447:	41 83 3c f6 00       	cmpl   $0x0,(%r14,%rsi,8)
  68544c:	41 0f 94 c0          	sete   %r8b
  685450:	49 01 c8             	add    %rcx,%r8
  685453:	49 83 f8 01          	cmp    $0x1,%r8
  685457:	49 83 d0 ff          	adc    $0xffffffffffffffff,%r8
  68545b:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  685460:	49 39 d8             	cmp    %rbx,%r8
  685463:	0f 84 cc 00 00 00    	je     685535 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x785>
  685469:	40 f6 c5 01          	test   $0x1,%bpl
  68546d:	0f 84 8a fe ff ff    	je     6852fd <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x54d>
  685473:	48 85 c9             	test   %rcx,%rcx
  685476:	74 51                	je     6854c9 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x719>
  685478:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  68547d:	31 c0                	xor    %eax,%eax
  68547f:	48 83 f9 01          	cmp    $0x1,%rcx
  685483:	74 2b                	je     6854b0 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x700>
  685485:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  68548c:	00 00 00 00 
  685490:	49 89 cb             	mov    %rcx,%r11
  685493:	49 d1 eb             	shr    $1,%r11
  685496:	49 8d 34 03          	lea    (%r11,%rax,1),%rsi
  68549a:	4c 8d 04 76          	lea    (%rsi,%rsi,2),%r8
  68549e:	43 83 3c c6 00       	cmpl   $0x0,(%r14,%r8,8)
  6854a3:	48 0f 44 c6          	cmove  %rsi,%rax
  6854a7:	4c 29 d9             	sub    %r11,%rcx
  6854aa:	48 83 f9 01          	cmp    $0x1,%rcx
  6854ae:	77 e0                	ja     685490 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x6e0>
  6854b0:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
  6854b4:	31 c9                	xor    %ecx,%ecx
  6854b6:	41 83 3c f6 00       	cmpl   $0x0,(%r14,%rsi,8)
  6854bb:	0f 94 c1             	sete   %cl
  6854be:	48 01 c1             	add    %rax,%rcx
  6854c1:	48 83 f9 01          	cmp    $0x1,%rcx
  6854c5:	48 83 d1 ff          	adc    $0xffffffffffffffff,%rcx
  6854c9:	48 39 d9             	cmp    %rbx,%rcx
  6854cc:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  6854d1:	0f 85 26 fe ff ff    	jne    6852fd <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x54d>
  6854d7:	31 d2                	xor    %edx,%edx
  6854d9:	31 c0                	xor    %eax,%eax
  6854db:	eb 2c                	jmp    685509 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x759>
  6854dd:	f3 0f 5a c9          	cvtss2sd %xmm1,%xmm1
  6854e1:	f3 0f 5a d2          	cvtss2sd %xmm2,%xmm2
  6854e5:	f2 0f 58 d1          	addsd  %xmm1,%xmm2
  6854e9:	f2 0f 59 15 6f f1 99 	mulsd  -0x660e91(%rip),%xmm2        # 24660 <anon.fc7a94f9b2531d69817906392dce0d0f.32.llvm.8356244060496160781+0x111>
  6854f0:	ff 
  6854f1:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  6854f5:	66 0f 2e c2          	ucomisd %xmm2,%xmm0
  6854f9:	0f 46 44 24 24       	cmovbe 0x24(%rsp),%eax
  6854fe:	0f b6 c9             	movzbl %cl,%ecx
  685501:	0f b6 d2             	movzbl %dl,%edx
  685504:	0f 47 d1             	cmova  %ecx,%edx
  685507:	eb 00                	jmp    685509 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x759>
  685509:	48 83 c4 68          	add    $0x68,%rsp
  68550d:	5b                   	pop    %rbx
  68550e:	41 5c                	pop    %r12
  685510:	41 5d                	pop    %r13
  685512:	41 5e                	pop    %r14
  685514:	41 5f                	pop    %r15
  685516:	5d                   	pop    %rbp
  685517:	c3                   	ret
  685518:	48 8d 3d 9b 8b bd ff 	lea    -0x427465(%rip),%rdi        # 25e0ba <anon.694f5c156bcaaad1bfdfb170c855f1e5.14.llvm.4793427009722363920+0x3e2>
  68551f:	48 8d 15 22 86 0f 00 	lea    0xf8622(%rip),%rdx        # 77db48 <anon.54a4d576d54a94f5b464056acc886f06.3.llvm.4127220915301182839+0x60>
  685526:	be 13 00 00 00       	mov    $0x13,%esi
  68552b:	ff 15 a7 1d 10 00    	call   *0x101da7(%rip)        # 7872d8 <_DYNAMIC+0x250>
  685531:	31 d2                	xor    %edx,%edx
  685533:	eb d4                	jmp    685509 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x759>
  685535:	31 c0                	xor    %eax,%eax
  685537:	b2 01                	mov    $0x1,%dl
  685539:	eb ce                	jmp    685509 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x759>
  68553b:	f3 0f 5a cb          	cvtss2sd %xmm3,%xmm1
  68553f:	f3 0f 5a d5          	cvtss2sd %xmm5,%xmm2
  685543:	f2 0f 58 d1          	addsd  %xmm1,%xmm2
  685547:	f2 0f 59 15 11 f1 99 	mulsd  -0x660eef(%rip),%xmm2        # 24660 <anon.fc7a94f9b2531d69817906392dce0d0f.32.llvm.8356244060496160781+0x111>
  68554e:	ff 
  68554f:	f3 0f 5a c0          	cvtss2sd %xmm0,%xmm0
  685553:	66 0f 2e c2          	ucomisd %xmm2,%xmm0
  685557:	0f 47 c2             	cmova  %edx,%eax
  68555a:	0f b6 c9             	movzbl %cl,%ecx
  68555d:	40 0f b6 d7          	movzbl %dil,%edx
  685561:	eb a1                	jmp    685504 <<gpui_canvas::text::layout::TextGeometry>::position_on_line+0x754>
  685563:	48 8d 15 96 85 0f 00 	lea    0xf8596(%rip),%rdx        # 77db00 <anon.54a4d576d54a94f5b464056acc886f06.3.llvm.4127220915301182839+0x18>
  68556a:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  68556f:	ff 15 ab 1e 10 00    	call   *0x101eab(%rip)        # 787420 <_DYNAMIC+0x398>
  685575:	48 8d 15 b4 85 0f 00 	lea    0xf85b4(%rip),%rdx        # 77db30 <anon.54a4d576d54a94f5b464056acc886f06.3.llvm.4127220915301182839+0x48>
  68557c:	48 89 f7             	mov    %rsi,%rdi
  68557f:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  685584:	ff 15 96 1e 10 00    	call   *0x101e96(%rip)        # 787420 <_DYNAMIC+0x398>
