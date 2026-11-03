## AST 与库函数支持

逐个检查导出 AST，沿选定入口的直接调用闭包分类；区分实际调用与前端自动生成、未使用的外部声明。遇到间接调用或无法解析的调用，保留待解决项，不能默认无外部依赖。当前项目可运行 `python3 scripts/ast_library_audit.py --output reports/ast-library-audit.json`。

- 已落到官方具体操作（例如 EF_memcpy、EF_malloc、EF_free），直接复用官方 Events/Cexec；EF_builtin/EF_runtime 必须用官方 lookup_builtin_function 对名称和签名检查，不能只凭名字判断支持。不得复制或修改 Csem/Cexec。
- 普通外部库函数（包括 musl/libc）只为实际需要的函数添加最小规格和可执行适配，允许大模型生成；不验证库内部实现。所选库实现符合该规格是显式接受的外部接口假设。仍需验证适配器符合规格，并保持返回值、位模式、内存字节/frame、失败及可观察效果。不得以常数返回、数学近似或忽略副作用冒充原函数；浮点库函数尤其不能将近似数学值冒充具体库的位级结果。
- 直接涉及系统调用的接口，必须有官方 CompCert 的具体支持及相容的 world/事件驱动；抽象 EF_external 或 Event_syscall 本身不算已实现。没有具体支持时明确 unsupported，不生成 syscall、汇编或系统状态的占位实现，也不把缺失模型报成原 C 的 error。普通库内部可能使用系统调用，不要求验证其内部实现；普通库 I/O 的规格和适配仍须保留可观察事件及 world。
- 原始 C 和自动导出 AST 保持不变。已有官方操作与普通库接口的参数、返回值、对齐、重叠约束不同时，仅在适配层处理并给出对应证据；需要改 C/AST 的方案必须先有行为保持证明，不能静默替换。

`shared/compcert_libc/registry.json` 仅登记实际需要的普通库规格/适配及证据。导出器生成 library-audit.json，来源审计重新检查；未知函数、未解决间接调用和未支持系统接口不能通过交付门禁。规格/适配/证明源码与 registry 要纳入 execution-contract 的 source_semantics.source_sha256；external_library_bindings 按函数记录 callback、specification、assumption。已有八类执行对应证明仍须覆盖实际选用的回调及其显式环境假设，静态审计或登记成功不等于完成语义证明。
