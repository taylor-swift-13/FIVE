固定原 Paparazzi float_quat_vmult，CompCert3.17原Csyntax/Csem/Cexec，x86-64 Linux小端、binary32 RNE。明确前条件为3个不同block的零offset指针、4个已初始化binary32 quaternion字段和3个已初始化输入vector字段、输出0/4/8三个float32位置可写。允许所有float32含NaN/Inf/signedzero；有限有界CBMC域为本域子集。原0.5 double减法与最后integer2相乘表达式保留，未重写原C或Source.v。

原Csem全部reachable states无错误已证明；真实alloc/bind、原fn_body和cleanup由既有Call.call_summary建立evaluator存在，再通过已检查all-order语义引理得出安全。

请求目标：NoError；当前均proved。
