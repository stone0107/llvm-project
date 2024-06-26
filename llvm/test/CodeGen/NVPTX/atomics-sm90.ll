; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 4
; RUN: llc < %s -march=nvptx -mcpu=sm_90 -mattr=+ptx78 | FileCheck %s --check-prefixes=CHECK
; RUN: llc < %s -march=nvptx64 -mcpu=sm_90 -mattr=+ptx78 | FileCheck %s --check-prefixes=CHECK64
; RUN: llc < %s -march=nvptx -mcpu=sm_86 -mattr=+ptx71 | FileCheck %s --check-prefixes=CHECKPTX71
; RUN: %if ptxas && !ptxas-12.0 %{ llc < %s -march=nvptx -mcpu=sm_90 -mattr=+ptx78 | %ptxas-verify -arch=sm_90 %}
; RUN: %if ptxas %{ llc < %s -march=nvptx64 -mcpu=sm_90 -mattr=+ptx78 | %ptxas-verify -arch=sm_90 %}
; RUN: %if ptxas && !ptxas-12.0 %{ llc < %s -march=nvptx -mcpu=sm_86 -mattr=+ptx71 | %ptxas-verify -arch=sm_86 %}

target triple = "nvptx64-nvidia-cuda"

define void @test(ptr %dp0, ptr addrspace(1) %dp1, ptr addrspace(3) %dp3, bfloat %val) {
; CHECK-LABEL: test(
; CHECK:       {
; CHECK-NEXT:    .reg .b16 %rs<7>;
; CHECK-NEXT:    .reg .b32 %r<4>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    ld.param.u32 %r1, [test_param_0];
; CHECK-NEXT:    ld.param.b16 %rs1, [test_param_3];
; CHECK-NEXT:    atom.add.noftz.bf16 %rs2, [%r1], %rs1;
; CHECK-NEXT:    ld.param.u32 %r2, [test_param_1];
; CHECK-NEXT:    mov.b16 %rs3, 0x3F80;
; CHECK-NEXT:    atom.add.noftz.bf16 %rs4, [%r1], %rs3;
; CHECK-NEXT:    ld.param.u32 %r3, [test_param_2];
; CHECK-NEXT:    atom.global.add.noftz.bf16 %rs5, [%r2], %rs1;
; CHECK-NEXT:    atom.shared.add.noftz.bf16 %rs6, [%r3], %rs1;
; CHECK-NEXT:    ret;
;
; CHECK64-LABEL: test(
; CHECK64:       {
; CHECK64-NEXT:    .reg .b16 %rs<7>;
; CHECK64-NEXT:    .reg .b64 %rd<4>;
; CHECK64-EMPTY:
; CHECK64-NEXT:  // %bb.0:
; CHECK64-NEXT:    ld.param.u64 %rd1, [test_param_0];
; CHECK64-NEXT:    ld.param.b16 %rs1, [test_param_3];
; CHECK64-NEXT:    atom.add.noftz.bf16 %rs2, [%rd1], %rs1;
; CHECK64-NEXT:    ld.param.u64 %rd2, [test_param_1];
; CHECK64-NEXT:    mov.b16 %rs3, 0x3F80;
; CHECK64-NEXT:    atom.add.noftz.bf16 %rs4, [%rd1], %rs3;
; CHECK64-NEXT:    ld.param.u64 %rd3, [test_param_2];
; CHECK64-NEXT:    atom.global.add.noftz.bf16 %rs5, [%rd2], %rs1;
; CHECK64-NEXT:    atom.shared.add.noftz.bf16 %rs6, [%rd3], %rs1;
; CHECK64-NEXT:    ret;
;
; CHECKPTX71-LABEL: test(
; CHECKPTX71:       {
; CHECKPTX71-NEXT:    .reg .pred %p<5>;
; CHECKPTX71-NEXT:    .reg .b16 %rs<18>;
; CHECKPTX71-NEXT:    .reg .b32 %r<58>;
; CHECKPTX71-NEXT:    .reg .f32 %f<12>;
; CHECKPTX71-EMPTY:
; CHECKPTX71-NEXT:  // %bb.0:
; CHECKPTX71-NEXT:    ld.param.b16 %rs1, [test_param_3];
; CHECKPTX71-NEXT:    ld.param.u32 %r23, [test_param_2];
; CHECKPTX71-NEXT:    ld.param.u32 %r22, [test_param_1];
; CHECKPTX71-NEXT:    ld.param.u32 %r24, [test_param_0];
; CHECKPTX71-NEXT:    and.b32 %r1, %r24, -4;
; CHECKPTX71-NEXT:    and.b32 %r25, %r24, 3;
; CHECKPTX71-NEXT:    shl.b32 %r2, %r25, 3;
; CHECKPTX71-NEXT:    mov.b32 %r26, 65535;
; CHECKPTX71-NEXT:    shl.b32 %r27, %r26, %r2;
; CHECKPTX71-NEXT:    not.b32 %r3, %r27;
; CHECKPTX71-NEXT:    ld.u32 %r54, [%r1];
; CHECKPTX71-NEXT:    cvt.f32.bf16 %f2, %rs1;
; CHECKPTX71-NEXT:  $L__BB0_1: // %atomicrmw.start
; CHECKPTX71-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECKPTX71-NEXT:    shr.u32 %r28, %r54, %r2;
; CHECKPTX71-NEXT:    cvt.u16.u32 %rs2, %r28;
; CHECKPTX71-NEXT:    cvt.f32.bf16 %f1, %rs2;
; CHECKPTX71-NEXT:    add.rn.f32 %f3, %f1, %f2;
; CHECKPTX71-NEXT:    cvt.rn.bf16.f32 %rs4, %f3;
; CHECKPTX71-NEXT:    cvt.u32.u16 %r29, %rs4;
; CHECKPTX71-NEXT:    shl.b32 %r30, %r29, %r2;
; CHECKPTX71-NEXT:    and.b32 %r31, %r54, %r3;
; CHECKPTX71-NEXT:    or.b32 %r32, %r31, %r30;
; CHECKPTX71-NEXT:    atom.cas.b32 %r6, [%r1], %r54, %r32;
; CHECKPTX71-NEXT:    setp.ne.s32 %p1, %r6, %r54;
; CHECKPTX71-NEXT:    mov.u32 %r54, %r6;
; CHECKPTX71-NEXT:    @%p1 bra $L__BB0_1;
; CHECKPTX71-NEXT:  // %bb.2: // %atomicrmw.end
; CHECKPTX71-NEXT:    ld.u32 %r55, [%r1];
; CHECKPTX71-NEXT:  $L__BB0_3: // %atomicrmw.start9
; CHECKPTX71-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECKPTX71-NEXT:    shr.u32 %r33, %r55, %r2;
; CHECKPTX71-NEXT:    cvt.u16.u32 %rs6, %r33;
; CHECKPTX71-NEXT:    cvt.f32.bf16 %f4, %rs6;
; CHECKPTX71-NEXT:    add.rn.f32 %f5, %f4, 0f3F800000;
; CHECKPTX71-NEXT:    cvt.rn.bf16.f32 %rs8, %f5;
; CHECKPTX71-NEXT:    cvt.u32.u16 %r34, %rs8;
; CHECKPTX71-NEXT:    shl.b32 %r35, %r34, %r2;
; CHECKPTX71-NEXT:    and.b32 %r36, %r55, %r3;
; CHECKPTX71-NEXT:    or.b32 %r37, %r36, %r35;
; CHECKPTX71-NEXT:    atom.cas.b32 %r9, [%r1], %r55, %r37;
; CHECKPTX71-NEXT:    setp.ne.s32 %p2, %r9, %r55;
; CHECKPTX71-NEXT:    mov.u32 %r55, %r9;
; CHECKPTX71-NEXT:    @%p2 bra $L__BB0_3;
; CHECKPTX71-NEXT:  // %bb.4: // %atomicrmw.end8
; CHECKPTX71-NEXT:    and.b32 %r10, %r22, -4;
; CHECKPTX71-NEXT:    shl.b32 %r38, %r22, 3;
; CHECKPTX71-NEXT:    and.b32 %r11, %r38, 24;
; CHECKPTX71-NEXT:    shl.b32 %r40, %r26, %r11;
; CHECKPTX71-NEXT:    not.b32 %r12, %r40;
; CHECKPTX71-NEXT:    ld.global.u32 %r56, [%r10];
; CHECKPTX71-NEXT:  $L__BB0_5: // %atomicrmw.start27
; CHECKPTX71-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECKPTX71-NEXT:    shr.u32 %r41, %r56, %r11;
; CHECKPTX71-NEXT:    cvt.u16.u32 %rs10, %r41;
; CHECKPTX71-NEXT:    cvt.f32.bf16 %f6, %rs10;
; CHECKPTX71-NEXT:    add.rn.f32 %f8, %f6, %f2;
; CHECKPTX71-NEXT:    cvt.rn.bf16.f32 %rs12, %f8;
; CHECKPTX71-NEXT:    cvt.u32.u16 %r42, %rs12;
; CHECKPTX71-NEXT:    shl.b32 %r43, %r42, %r11;
; CHECKPTX71-NEXT:    and.b32 %r44, %r56, %r12;
; CHECKPTX71-NEXT:    or.b32 %r45, %r44, %r43;
; CHECKPTX71-NEXT:    atom.global.cas.b32 %r15, [%r10], %r56, %r45;
; CHECKPTX71-NEXT:    setp.ne.s32 %p3, %r15, %r56;
; CHECKPTX71-NEXT:    mov.u32 %r56, %r15;
; CHECKPTX71-NEXT:    @%p3 bra $L__BB0_5;
; CHECKPTX71-NEXT:  // %bb.6: // %atomicrmw.end26
; CHECKPTX71-NEXT:    and.b32 %r16, %r23, -4;
; CHECKPTX71-NEXT:    shl.b32 %r46, %r23, 3;
; CHECKPTX71-NEXT:    and.b32 %r17, %r46, 24;
; CHECKPTX71-NEXT:    shl.b32 %r48, %r26, %r17;
; CHECKPTX71-NEXT:    not.b32 %r18, %r48;
; CHECKPTX71-NEXT:    ld.shared.u32 %r57, [%r16];
; CHECKPTX71-NEXT:  $L__BB0_7: // %atomicrmw.start45
; CHECKPTX71-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECKPTX71-NEXT:    shr.u32 %r49, %r57, %r17;
; CHECKPTX71-NEXT:    cvt.u16.u32 %rs14, %r49;
; CHECKPTX71-NEXT:    cvt.f32.bf16 %f9, %rs14;
; CHECKPTX71-NEXT:    add.rn.f32 %f11, %f9, %f2;
; CHECKPTX71-NEXT:    cvt.rn.bf16.f32 %rs16, %f11;
; CHECKPTX71-NEXT:    cvt.u32.u16 %r50, %rs16;
; CHECKPTX71-NEXT:    shl.b32 %r51, %r50, %r17;
; CHECKPTX71-NEXT:    and.b32 %r52, %r57, %r18;
; CHECKPTX71-NEXT:    or.b32 %r53, %r52, %r51;
; CHECKPTX71-NEXT:    atom.shared.cas.b32 %r21, [%r16], %r57, %r53;
; CHECKPTX71-NEXT:    setp.ne.s32 %p4, %r21, %r57;
; CHECKPTX71-NEXT:    mov.u32 %r57, %r21;
; CHECKPTX71-NEXT:    @%p4 bra $L__BB0_7;
; CHECKPTX71-NEXT:  // %bb.8: // %atomicrmw.end44
; CHECKPTX71-NEXT:    ret;
  %r1 = atomicrmw fadd ptr %dp0, bfloat %val seq_cst
  %r2 = atomicrmw fadd ptr %dp0, bfloat 1.0 seq_cst
  %r3 = atomicrmw fadd ptr addrspace(1) %dp1, bfloat %val seq_cst
  %r4 = atomicrmw fadd ptr addrspace(3) %dp3, bfloat %val seq_cst
  ret void
}

attributes #1 = { argmemonly nounwind }
